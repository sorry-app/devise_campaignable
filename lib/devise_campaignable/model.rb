# Require the various adapters.
require 'devise_campaignable/adapters/adapter'
require 'devise_campaignable/adapters/mailchimp'
# NOTE: Add other adapters here as and when they're created.

module Devise
  module Models
    #
    # Campaignable adds callbacks to your devise model which automaticaly subscribes
    # them to a mailing list when they create their account, and also updates
    # their mailing list profile when they edit their personal details.
    #
    # This is a multi-vendor libarary which will hopefully support a variety of campaign
    # tools from Mailchimp to Campaign Monitor.
    #
    module Campaignable
        # This modules are injected as concerms.
        extend ActiveSupport::Concern

        # Add the callbacks to the user model.
        included do
            # Callback to subscribe the user whenever the record is created
            after_create :subscribe
            # Callback to see if the subscription for this users needs updating.
            after_update :update_subscription
            # Callback to unsubscribe the user when they are destroyed.
            after_destroy :unsubscribe
        end

        # Method to subscibe the user to the configrued mailing list.
        def subscribe
            # Ask the list manager to subscribe this devise models email.
            self.class.list_manager.subscribe(self.email, campaignable_additional_fields)
        end

        # Method to update the subscription
        def update_subscription
            # Only change the subscription if the models email
            # address has been changed.
            self.class.list_manager.update_subscription(self.email_was, self.email, campaignable_additional_fields) if self.email_changed?
        end

        # Method to unsubscribe the user from the configured mailing list.
        def unsubscribe
            # Ask the list manager to unsubscribe this devise models email.
            self.class.list_manager.unsubscribe(self.email)
        end

        private

            # Get a hash of the additional fields.
            def campaignable_additional_fields
                # Create an empty hash to store the fields.
                additional_fields = {}

                # Loop over the additional fields configured.
                self.class.campaignable_additional_fields.each do |field_name|
                    # Create a new additional field using the key/value.
                    additional_fields[field_name] = self.send(field_name)
                end

                # Compact to the hash to remove any empty data.
                additional_fields.compact
            end

        module ClassMethods

            # Get the list subscriber library.
            def list_manager
                # For this initial mockup let's us the mailchimp adapter.
                # TODO: Wrap this in a try/catch with a useful error if not adapter is found.
                manager = Devise::Models::Campaignable::Adapters.const_get(campaignable_vendor.to_s.camelize).new(campaignable_api_key, campaignable_list_id)

                # Proxy the manager with delayed job if it's available for us to use.
                # This will mean tasks are managed in the background where possible.
                #
                # If class responds to delayed job then return the delayed instance
                # but if it doesn't look like delayed job implemented just return the
                # underlying manager object directly.
                manager.respond_to?(:delay) ? manager.delay(:queue => 'devise_campaignable') : manager
            end

            # Subscribe all users as a batch.
            def subscribe_all
                # Get an array of all the email addresses accociated with this devise class.
                emails = all.map(&:email)

                # Ask the list managed to subscibe all of these emails.
                list_manager.batch_subscribe(emails)
            end

            # Unsubscribe all users as a batch.
            def unsubscribe_all
                # Get an array of all the email addresses accociated with this devise class.
                emails = all.map(&:email)

                # Ask the list managed to subscibe all of these emails.
                list_manager.batch_unsubscribe(emails)                
            end

            # Set the configuration variables for the modeule.
            Devise::Models.config(self, :campaignable_api_key, :campaignable_list_id, :campaignable_vendor, :campaignable_additional_fields)
        end
    end
  end
end