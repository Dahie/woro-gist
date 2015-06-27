require 'gist'

module Woro
  module Adapters
    class Gist < Base
      attr_reader :gist_id

      # Setup configuration for adapter
      # Highline CLI helpers can be used for interactivity.
      # @return [Hash] Configuration options
      def self.setup
        if agree 'Login to Gist/Github for private Woro tasks (Yes/No)?  '
          ::Gist.login!
        end

        # create Gist with welcome file
        # additional tasks will be added to this first gist
        begin
          require File.join(Dir.pwd, 'config', 'application.rb')
          app_name = Rails.application.class.parent_name
        rescue LoadError
          app_name = ask('Application name: ')
        end

        result = create_initial_remote_task(app_name)

        {
          gist_id: result['id'],
          public: false
        }
      end

      # Create a new gist collection adapter
      def initialize(options)
        @gist_id = options['gist_id']
      end

      # Returns the list of files included in the Gist
      # @return [Hash] List of files in the format { filename: { data }}
      def list_files
        gist['files'].keys
      end

      # Returns the list of rake files included in the remote collection
      # with their contents.
      # @return [Hash] List of files with their contents
      def list_contents
        gist['files']
      end

      # Push this task's file content to the Gist collection on the server.
      # Existing contents by the same #file_name will be overriden, but
      # can be accessed via Github or Gist's API.
      def push(task)
        ::Gist.multi_gist({ task.file_name => task.read_task_file },
                        public: false,
                        update: gist_id,
                        output: :all)
      end

      # The raw url is a permalink for downloading the content rake task within
      # the Gist as a file.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [String] HTTP-URL of addressed file within the gist collection
      def raw_url(file_name)
        retrieve_file_data(file_name)['raw_url']
      end

      # Creates an initial welcome gist on project setup
      # @param app_name [String] Name of the app is displayed in the
      # initial welcome message
      def self.create_initial_remote_task(app_name, access_token = nil)
        ::Gist.gist("Welcome to the Woro Task Repository for #{app_name}",
                    filename: app_name, access_token: access_token)
      end

      # Extract description from gist's data content string.
      # @param data [Hash] gist data hash
      # [String] description string
      def extract_description(data)
        Woro::TaskHelper.extract_description(data['content'])
      end

      protected

      # The Gist contains a collection of files.
      # These are stored and accessed on Github.
      # @return [Hash] parsed JSON hash of the gist's metadata
      def gist
        @gist ||= retrieve_gist(gist_id)
      end

      # Retrieves metadata of the specified gist
      # @param gist_id [String] id of the gist
      # @return [Hash] parsed JSON hash
      def retrieve_gist(gist_id)
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(URI.parse(service_url))
        JSON.parse(response.body || '')
      end

      # Retrieves the data hash included in the gist under the #file_name.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [Hash] parsed JSON hash
      def retrieve_file_data(file_name)
        gist['files'][file_name]
      end
    end
  end
end
