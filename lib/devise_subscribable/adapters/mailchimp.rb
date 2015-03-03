module Devise
  module Models
    module Subscribable
      module Adapters
        class Mailchimp < Adapter

            # Subscribe an email to the instantiated list.
            def subscribe(email)
	            # Logic for mailchimp subcription.
	            api.subscribe({
	            	:id => @subscribable_list_id,
	                :email => {
	                    :email => email
	                }, 
	                :double_optin => false, # Don't require email authorization.
	                :update_existing => true, # Don't error if adding existing subscriber.
	                :send_welcome => false # Don't send a welcome email when they're added to the list.
	            })
            end

	        # Method to unsubscribe the user from the configured mailing list.
	        # This method is available for API Keys belonging to users with the following roles: manager, admin, owner
            def unsubscribe(email)
	            # Logic for mailchimp unsubscription.
	            # TODO: Move this into some form of adaptor for Mailchimp so this
	            # TODO: Should this check they are subscribed before attemoting to delete?
	            #       class becomes more generic.
	            api.unsubscribe({
	            	:id => @subscribable_list_id,
	                :email => {
	                    :email => email
	                }, 
	                :send_goodbye => false, # Don't send a goodbye email.
	                :send_notify => false # Don't notify the user of the unsubscription.
	            })
            end            

            # Subscribe all users as a batch.
            def batch_subscribe(emails=[])
                # Do this using a batch call to the MailChimp API for performance rather than lots of single API calls.
                api.batch_subscribe({
                	:id => @subscribable_list_id,
                    :batch => emails.map {|email| {:email => { :email => email }} }, # Map all users in the system into a mailchimp collcation.
                    :double_optin => false, # Don't require email authorization.
                    :update_existing => true, # Don't error if adding existing subscriber.
                    :replace_interests => false # Don't send a welcome email when they're added to the list.                
                })
            end

            # Unsubscribe all users as a batch.
            def batch_unsubscribe(emails=[])
                # Do this using a batch call to the MailChimp API for performance rather than lots of single API calls.
                api.batch_unsubscribe({
                	:id => @subscribable_list_id,
                    :batch => emails.map {|email| {:email => { :email => email }} }, # Map all users in the system into a mailchimp collcation.
                    :send_goodbye => false, # Don't send a goodbye email.
                    :send_notify => false # Don't notify the user of the unsubscription.             
                })
            end

            private

                # Get an instance of the MailChimp API.
                def api
                    # Instantiate an instance of Gibbon with the API key provided to this adapter.
                    # We only work with the lists api here, so namespace into that.
                    Gibbon::API.new(@subscribable_api_key).lists                   
                end

        end
      end
    end
  end
end