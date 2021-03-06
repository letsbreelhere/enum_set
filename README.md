[![Build Status](https://travis-ci.org/breestanwyck/enum_set.svg?branch=master)](https://travis-ci.org/breestanwyck/enum_set)

# EnumSet

`enum_set` is a gem for treating integer columns as a compact set of boolean
fields. It defines boolean getter methods similar to the standard `enum` method
as well as an array setter.

## Installation

* With bundler:

        $ gem 'enum_set'

* Without bundler:

        $ gem install enum_set

## Usage

### Array Specification

```ruby
# user.rb
class User < ActiveRecord::Base
  include EnumSet
  enum_set roles: [:admin, :super_user, :kaiser]
end
```

### Hash Specification

```ruby
# user.rb
class User < ActiveRecord::Base
  include EnumSet
  # N.B.: values must be powers of 2
  enum_set roles: { admin: 1, super_user: 4, kaiser: 256 }
end
```

### Elsewhere

```ruby
user = User.create(roles: [:super_user])

user.super_user? # => true
user.admin? # => false

super_users = User.super_user.all # will include `user`

user.roles <<= :kaiser # Adds `:kaiser` role to `user`
user.roles # => [:super_user, :kaiser]
user.roles <<= :gender # raises `EnumSet::EnumError`, since `:gender` isn't a role
```

## Notes

The gem currently requires ActiveRecord due to scope creation.
