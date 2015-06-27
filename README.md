# woro-gist

Gist-Adapter for Woro remote task management

Using Github's gist, you keep version control of the tasks and can share them with colleagues.

## Woro adapters

## Usage


Once you are done writing the task and you want to execute it on the remote system.
First you have to push them online, in this case to Gist.

```shell
$ woro push gist:cleanup_users
```

_Attention, depending on whether you set up a Gist/Github login on
initialization. These tasks are online anonymous, but public, or
private under the specified Github account._

Now, to run a task remotely using Mina, specify the task:

```shell
$ mina woro:run task=gist:cleanup_users
```

Or to run it with Capistrano:

```shell
$ cap woro:run task=gist:cleanup_users
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
