# Valor

Take a Ruby Hash and transform it into the makings of a Virtus Model class.

## How to

So how do we go about this then? First we get Valor a hash to use:
```ruby
hash = {a: {b: 1, c: [{d: 1}, {d: 2}]}}
```

Then we make a Valor Generator. Send a file directory if you want it to auto save:
```ruby
valor = Valor::Generator.new('Test', hash)
valor = Valor::Generator.new('Test', hash, '/tmp') # For autosaving
```

Which will generate the following models and attributes:
```ruby
{
  "D"    => ["attribute :d, Integer"],
  "A"    => ["attribute :b, Integer", "attribute :c, Array[D]"],
  "Test" => ["attribute :a, A"]
}
```

It even makes sure to generate new models for every sub hash you happen to pass it.

Now we can save the files. Pass in a directory, or it will default to your current working directory.
```ruby
valor.save_files('path_to_save_in')
```

...and you'll notice the following files were created:
```ruby
# A.rb
class A
  include Virtus.model

  attribute :b, Integer
  attribute :c, Array[D]
end

# D.rb
class D
  include Virtus.model

  attribute :d, Integer
end

# Test.rb
class Test
  include Virtus.model

  attribute :a, A
end
```

Automation, such a wondrous time saver some times.

## Installation

Add this line to your application's Gemfile:

    gem 'valor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install valor

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/valor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
