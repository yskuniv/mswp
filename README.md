# MSwp

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/mswp`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Clone this repository at anywhere you want, then get into the directory:

```console
$ git clone https://github.com/yskuniv/mswp.git
$ cd mswp/
```

And then execute:

```console
$ bundle install
```

Or you want to install it locally, execute:

```console
$ bundle install --path=vendor/bundle
```

When you install locally, you should also install binstub of this gem:

```console
$ bundle binstubs mswp
```

Then, now you can run the command like the following:

```console
$ ./bin/mswp
Commands:
  mswp help [COMMAND]          # Describe available commands or one specific command
  mswp start size1 size2 -m=N  # Start a game.

$
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yskuniv/mswp.
