module Clutterbuck; end

module Clutterbuck::Response
	def status(s)
		s = s.to_i

		if s < 100 || s > 599
			raise ArgumentError,
			      "Status code must be between 100-599 inclusive"
		end

		@status = s
	end

	alias_method :status=, :status

	# Add a header to the response, possibly duplicating an existing header
	#
	# If you want to be sure that your header is the only one that will be
	# sent in the response, overriding any previous values for the same
	# header, you want to use `set_header` rather than this method.
	#
	# @param name [String] the name of the header to add.
	#
	# @param val [String] the value of the header to add.
	#
	# @return void
	#
	def add_header(name, val)
		@headers ||= []

		@headers << [name.downcase, val]
	end

	# Set a header in the response
	#
	# This will override any previous value(s) for the same header previously
	# set.  Sometimes this is what you want, and sometimes it isn't.  You're
	# expected to know which is which.
	#
	# @param name [String] the name of the header to set.
	#
	# @param val [String] the value to set for the header.
	#
	# @return void
	#
	def set_header(name, val)
		clear_header(name)
		add_header(name, val)
	end

	# Remove all instances of the specified header from the response headers.
	#
	# @param name [String] the name of the header to remove.
	#
	# @return void
	#
	def clear_header(name)
		@headers ||= []
		name = name.downcase
		@headers = @headers.delete_if { |h| h[0] == name }
	end

	# Retrieve the current value(s) of the specified header
	#
	# Values for all instances of the header will be returned in an array.
	#
	# @param name [String]
	#
	# @return [Array<String>]
	#
	def get_header(name)
		@headers ||= []
		name = name.downcase
		@headers.select { |h| h[0] == name }.map { |h| h[1] }
	end

	# Set the response body.
	#
	# Any ol' string or array you might like to create.
	#
	# @param body [String, Array<#to_s>] the body to set.
	#
	# @return [nil]
	#
	def set_body(body)
		@body = body.respond_to(:each) ? body : [body]
	end

	# Convenience method for defining a temporary redirect.
	#
	# Redirecting a request to a new URL is such a common operation that
	# it's nice to be able to do it in one call, rather than two.
	#
	def redirect(url)
		status 303
		set_header "Location", url
		set_body ""
	end

	#:nodoc:
	#
	# Override the default `call` method which (we hope) the application is
	# using.  Due to Ruby's way of handling overriding with mixed-in modules,
	# the original `call` method *must not* be defined on the class which
	# this module is being included in.  It must be defined in a parent
	# class, or else a module which is included *before* this one.
	#
	def call
		s, h, b = if self.class.ancestors.any? { |k| k.respond_to?(:call) }
			super
		else
			[nil, [], []]
		end

		if @status
			s = @status
		end

		if @headers
			h = h.to_a
			h += @headers
		end

		if @body
			b = @body
		end

		[s, h, b]
	end
end
