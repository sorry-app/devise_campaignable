module Devise
  module Models
    module Subscribable
      module Adapters
        class Adapter

            # Create a new list manager adapter.
            def initialize(subscribable_api_key, subscribable_list_id)
                # Set the basic properties for an adapter.
                @subscribable_api_key = subscribable_api_key
                @subscribable_list_id = subscribable_list_id
            end

            # Placeholder methods for the adapter, these should be implemented
            # in the parent class but not on the base adapter.
            #
            # Accepts single email address to subscribe.
            def subscribe(email)
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