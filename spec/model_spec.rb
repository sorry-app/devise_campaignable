require "spec_helper"

describe Devise::Models::Campaignable do
	describe "callbacks" do
		it "subscribes the user after save"
		it "unsubscribes the user after destroy"
	end

	describe "instance methods" do
		it "Subscribes the user using their email"
		it "Unsubscribes the user using their email"
	end

	describe "class methods" do
		describe "#list_manager" do
			it "provides an instance of the list manager"
			it "throws an error if asked for an unknown adapter"
			it "wrap the instance with delayed job"
		end

		it "Subscribes all users using their email"
		it "Unsubscribes all users using their email"
	end
end