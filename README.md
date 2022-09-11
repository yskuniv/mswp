# MSwp

MSwp game.

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

When you install it locally, you should also install binstub of this gem:

```console
$ bundle binstubs mswp
```

Then now you can run the command like the following:

```console
$ ./bin/mswp
Commands:
  mswp help [COMMAND]          # Describe available commands or one specific command
  mswp start size1 size2 -m=N  # Start a game.

$
```

## Usage

Just run the command like the following:

```console
$ mswp start -m 10 10 10
```

So now you can play the game!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yskuniv/mswp.
