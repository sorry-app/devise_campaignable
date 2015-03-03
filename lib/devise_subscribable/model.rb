# Require the various adapters.
require 'adapters/mailchimp'
# NOTE: Add other adapters here as and when they're created.

module Devise
  module Models
    #
    # Subscribable adds callbacks to your devise model which automaticaly subscribes
    # them to a mailing list when they create their account, and also updates
    # their mailing list profile when they edit their personal details.
    #
    # This is a multi-vendor libarary which will hopefully support a variety of campaign
    # tools from Mailchimp to Campaign Monitor.
    #
    module Subscribable
        # This modules are injected as concerms.
        extend ActiveSupport::Concern

        # Add the callbacks to the user model.
        included do
            # Callback to subscribe the user whenever the record is saved.
            after_save :subscribe
            # Callback to unsubscribe the user when they are destroyed.
            after_destroy :unsubscribe
        end

        # Method to subscibe the user to the configrued mailing list.
        def subscribe
            # Ask the list manager to subscribe this devise models email.
            self.class.list_manager.subscribe(self.email)
        end

        # Method to unsubscribe the user from the configured mailing list.
        def unsubscribe
            # Ask the list manager to unsubscribe this devise models email.
            self.class.list_manager.unsubscribe(self.email)
        end

        module ClassMethods

            # Get the list subscriber library.
            def list_manager
                # For this initial mockup let's us the mailchimp adapter.
                # TODO: Wrap this in a try/catch with a useful error if not adapter is found.
                manager = Devise::Models::Subscribable::Adapters.const_get(subscribable_vendor.to_s.camelize).new(subscribable_api_key, subscribable_list_id)

                # Proxy the manager with delayed job if it's available for us to use.
                # This will mean tasks are managed in the background where possible.
                #
                # If class responds to delayed job then return the delayed instance
                # but if it doesn't look like delayed job implemented just return the
                # underlying manager object directly.
                respond_to?(:delay) ? manager.delay(:queue => 'devise_subscribable') : manager
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
            Devise::Models.config(self, :subscribable_api_key, :subscribable_list_id, :subscribable_vendor)
        end
    end
  end
end