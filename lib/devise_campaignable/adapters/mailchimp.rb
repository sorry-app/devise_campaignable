module Devise
  module Models
    module Campaignable
      module Adapters
        class Mailchimp < Adapter

            # Subscribe an email to the instantiated list.
            def subscribe(email, merge_vars={})
	            # Logic for mailchimp subcription.
	            api.lists(@campaignable_list_id).members(subscriber_hash(email)).upsert(body: {
	                :email_address => email,
                    :status => "subscribed",
                    :merge_fields => merge_vars # Include additional variables to be stored.
	            })
            end

            # Update an existing subscription.
            def update_subscription(old_email, new_email, merge_vars={})
                # Update the existing member details.
                api.lists(@campaignable_list_id).members(subscriber_hash(old_email)).update(body: {
                    :email_address => new_email,
                    :status => "subscribed",
                    :merge_fields => merge_vars # Include additional variables to be stored.
                })
            end

	        # Method to unsubscribe the user from the configured mailing list.
	        # This method is available for API Keys belonging to users with the following roles: manager, admin, owner
            def unsubscribe(email)
	            # Logic for mailchimp unsubscription.
	            api.lists(@campaignable_list_id).members(subscriber_hash(email)).update(body: { status: "unsubscribed" })
            rescue Gibbon::MailChimpError => e
              raise unless e.status_code == 404
              Rails.logger.warn "unsubscribe: User #{email} not found!"
            end

            # Subscribe all users as a batch.
            def batch_subscribe(emails=[])
                # Prepate the batch of subscribe operations to be called.
                operations = []

                # Create a upsert operations for each of the email addresses.
                emails.each do |email|
                    # The operation is manually compiled as the Gibbon
                    # gem doesn't give us an easy way of doing this.
                    operations.append({
                        :method => "POST",
                        :path => "/lists/#{@campaignable_list_id}/members",
                        :body => {
                            :email_address => email,
                            :status => "subscribed"
                        }.to_json
                    })
                end

                # Make the request to process the batch of operations
                api.batches.create(body: {:operations => operations})
            end

            # Unsubscribe all users as a batch.
            def batch_unsubscribe(emails=[])
                # Prepate the batch of subscribe operations to be called.
                operations = []

                # Create a upsert operations for each of the email addresses.
                emails.each do |email|
                    # The operation is manually compiled as the Gibbon
                    # gem doesn't give us an easy way of doing this.
                    operations.append({
                        :method => "PATCH",
                        :path => "/lists/#{@campaignable_list_id}/members/#{subscriber_hash(email)}",
                        :body => { :status => "unsubscribed" }.to_json
                    })
                end

                # Make the request to process the batch of operations
                api.batches.create(body: {:operations => operations})
            end

            private

                # Convert the members email into a hash
                # to be sent to mailchimp as part of the update calls.
                def subscriber_hash(email)
                    # Simple hash of the email address.
                    Digest::MD5.hexdigest(email)
                end

                # Get an instance of the MailChimp API.
                def api
                    # Instantiate an instance of Gibbon with the API key provided to this adapter.
                    # We only work with the lists api here, so namespace into that.
                    Gibbon::Request.new(api_key: @campaignable_api_key)
                end

        end
      end
    end
  end
end
