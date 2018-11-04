require_relative './spec_helper'
require 'clutterbuck-response'

class ExampleApp
	include Clutterbuck::Response
end

describe Clutterbuck::Response do
	let(:app)     { ExampleApp.new }
	let(:status)  { app.call[0] }
	let(:headers) { app.call[1] }
	let(:body)    { app.call[2] }

	context "#status" do
		it "exists" do
			expect { app.status 200 }.to_not raise_error
		end

		it "barfs on invalid status codes" do
			expect { app.status(666) }.
			  to raise_error(ArgumentError, /Status code must be/)
		end

		it "returns the status code that is set" do
			app.status = 303

			expect(status).to eq(303)
		end
	end

	context "#add_header" do
		it "exists" do
			expect { app.add_header "Content-Type", "ohai" }.to_not raise_error
		end

		it "adds the header I ask for" do
			app.add_header "Faff", "foobooblee"

			expect(headers).to include(["faff", "foobooblee"])
		end

		it "accepts multiple instances of the same header" do
			app.add_header "X-Womble", "awesome"
			app.add_header "X-Womble", "amazing"

			expect(headers.length).to eq(2)
			expect(headers).to include(["x-womble", "awesome"])
			expect(headers).to include(["x-womble", "amazing"])
		end
	end

	context "#set_header" do
		it "exists" do
			expect { app.set_header "Content-Type", "ohai" }.to_not raise_error
		end

		it "adds the header I ask for" do
			app.set_header "Faff", "foobooblee"

			expect(headers).to include(["faff", "foobooblee"])
		end

		it "only includes the last instance of the same header" do
			app.add_header "X-Womble", "awesome"
			app.set_header "X-Womble", "amazing"

			expect(headers.length).to eq(1)
			expect(headers).to include(["x-womble", "amazing"])
		end
	end

	context "#clear_header" do
		it "exists" do
			expect { app.clear_header "Content-Type" }.to_not raise_error
		end

		it "removes the header I ask for" do
			app.add_header "Faff", "foobooblee"
			app.clear_header "Faff"

			expect(headers).to be_empty
		end

		it "doesn't touch other headers" do
			app.add_header "Faff", "blah"
			app.add_header "X-Womble", "amazing"
			app.clear_header "Faff"

			expect(headers.length).to eq(1)
			expect(headers).to include(["x-womble", "amazing"])
		end
	end

	context "#get_header" do
		it "exists" do
			expect { app.get_header "Content-Type" }.to_not raise_error
		end

		it "returns an empty array for a non-existent header" do
			expect(app.get_header("Faff")).to eq([])
		end

		it "returns a single valued header" do
			app.add_header "Faff", "foobooblee"

			expect(app.get_header("Faff")).to eq(["foobooblee"])
		end

		it "returns all values for a header added multiple times" do
			app.add_header "X-Womble", "awesome"
			app.add_header "X-Womble", "amazing"

			expect(app.get_header("X-womble")).to eq(%w{awesome amazing})
		end
	end

	context "#set_body" do
		it "exists" do
			expect { app.set_body "" }.to_not raise_error
		end

		it "returns a string body in an array" do
			app.set_body ""

			expect(body).to eq([""])
		end

		it "returns an array body exactly as set" do
			app.set_body ["ohai!"]

			expect(body).to eq(["ohai!"])
		end
	end

	context "#redirect" do
		it "exists" do
			expect { app.redirect "/" }.to_not raise_error
		end

		it "sets the status" do
			app.redirect "/"

			expect(status).to eq(303)
		end

		it "sets the Location header" do
			app.redirect "/foobooblee"

			expect(headers).to eq([["location", "/foobooblee"]])
		end

		it "sets an empty body" do
			app.redirect "/foobooblee"

			expect(body).to eq([""])
		end
	end
end
