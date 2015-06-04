Simple helpers for manipulating a Rack application response.

# Installation

It's a gem:

    gem install clutterbuck-response

There's also the wonders of [the Gemfile](http://bundler.io):

    gem 'clutterbuck-response'

If you're the sturdy type that likes to run from git:

    rake install

Or, if you've eschewed the convenience of Rubygems entirely, then you
presumably know what to do already.


# Usage

Load the code:

    request 'clutterbuck-response'

Include the module in your application:

    class MyExampleApp
      include Clutterbuck::Response
    end

Then call any of the methods in {Clutterbuck::Response} to do the needful.


# Contributing

Bug reports should be sent to the [Github issue
tracker](https://github.com/mpalmer/clutterbuck-response/issues), or
[e-mailed](mailto:theshed+clutterbuck@hezmatt.org).  Patches can be sent as a
Github pull request, or [e-mailed](mailto:theshed+clutterbuck@hezmatt.org).


# Licence

Unless otherwise stated, everything in this repo is covered by the following
copyright notice:

    Copyright (C) 2015  Matt Palmer <matt@hezmatt.org>

    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License version 3, as
    published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
