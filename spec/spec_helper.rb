require 'woro'
require 'woro-gist'
require 'fakefs/safe'

Dir[('./spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.color = true
  config.order = 'random'

  config.before(:each) do
    FakeFS.activate!
    FileUtils.mkdir_p 'config'
    FileUtils.mkdir_p 'lib/woro_tasks'
    FileUtils.mkdir_p 'lib/tasks'
  end
end

