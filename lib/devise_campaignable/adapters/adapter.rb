module Devise
  module Models
    module Campaignable
      module Adapters
        class Adapter

            # Create a new list manager adapter.
            def initialize(campaignable_api_key, campaignable_list_id)
                # Set the basic properties for an adapter.
                @campaignable_api_key = campaignable_api_key
                @campaignable_list_id = campaignable_list_id
            end

            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Accepts single email address to subscribe.
            def subscribe(email, merge_vars={})
                # Raise an error to warn it isn't implemented.
                raise NotImplementedError.new
            end
            
            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Update an existing subscription.
            def update_subscription(old_email, new_email, merge_vars={})
                # Raise an error to warn it isn't implemented.
                raise NotImplementedError.new
            end

            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Accepts single email address to subscribe.
            def unsubscribe(email)
                # Raise an error to warn it isn't implemented.
                raise NotImplementedError.new
            end            

            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Accepts single email address to subscribe.
            def batch_subscribe(email)
                # Raise an error to warn it isn't implemented.
                raise NotImplementedError.new
            end

            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Accepts single email address to subscribe.
            def batch_unsubscribe(email)
                # Raise an error to warn it isn't implemented.
                raise NotImplementedError.new
            end

            private

                # Get the API for this adaper. i.e. Mailchimp, CampaignMonitor.
                def api
                    # Should return an instance of the API instantiated 
                    # with the credentials passed into the initialized.
                    # Raise an error to warn it isn't implemented.
                    raise NotImplementedError.new                    
                end

        end
      end
    end
  end
end