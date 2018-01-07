# PGVersion Parser

This object provides a clean little interface to the offical Postgres versioning
policy declared here: https://www.postgresql.org/support/versioning/

## Usage

```ruby
# new version
v1 = PGVersion.v "9.2.5"
v1.major  #=> "9.2"
v1.minor  #=> 5
v1.eol?   #=> true

# comarison to other version
v2 = PGVersion.v "9.6.6"
v2 > v1   #=> true
```

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pgversion`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pgversion'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pgversion

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pgversion.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

