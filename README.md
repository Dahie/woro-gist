# woro-gist

Gist-Adapter for [Woro remote task management](https://github.com/github/woro).
Using Github's gist, you keep version control of the tasks and can share them with colleagues.

## Usage

On initialization of a new project, you can choose and setup Gist-configuration with:

```shell
$ woro init
```

If you already have a configuration, you can add these lines to you `lib/config/woro.yml`

```yaml
adapters:
  gist:
    gist_id: <ID of gist you want to append task files to>
```

Use `gist` as adapter to upload your task to.

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
