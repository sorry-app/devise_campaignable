# Require the core devise module.
require 'devise'

module Devise
	# Extend the configuration options of the core devise
	# module with our required proprties for the campaignable
	# extsntion, such as vendor choice, api keys and lists.

	# Public: Default mailing list vendor choice. 
	# By default this is set to Mailchimp as it's the only supported vendor at the
	# moment until we get around to adding some addiitional vendor adaptors.
	#
	# Set campaignable_vendor in the Devise configuration file (config/initializers/devise.rb)
	#
	#   Devise.campaignable_vendor = :mailchimp	
	mattr_accessor :campaignable_vendor
	@@campaignable_vendor = :mailchimp

	# Public: Default mailing list for user to join.  This can be an array of strings, or just one string.
	# By default, this is "Site List".  If this will be configurable for each user, override
	# mailchimp_lists_to_join returning the list name or an array of list names for the user to
	# join.
	#
	# Set campaignable_list_name in the Devise configuration file (config/initializers/devise.rb)
	#
	#   Devise.campaignable_list_id = "12345"
	#
	# TODO: Should we allow friendly list names here like devise_mailchimp does?
	mattr_accessor :campaignable_list_id
	@@campaignable_list_id = "12345"

	# Public: The API key for accessing the mailchimp service.  To generate a new API key, go to the
	# account tab in your MailChimp account and select API Keys & Authorized Apps, then add
	# a key.  This defaults to 'your_api_key'
	#
	# Set subsribable_api_key in the Devise configuration file (config/initializers/devise.rb)
	#
	#   Devise.subsribable_api_key = "your_api_key"
	mattr_accessor :campaignable_api_key
	@@campaignable_api_key = 'your_api_key'
end

Devise.add_module :campaignable, :model => 'devise_campaignable/model'