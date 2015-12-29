# DeviseCampaignable

[![Gem Version](https://badge.fury.io/rb/devise_campaignable.svg)](http://badge.fury.io/rb/devise_campaignable)

Have your users automatically added to and removed from your favourite mail campaign tool. Currently supports [MailChimp](http://mailchimp.com/).

Inspired by the now slightly out of date [devise_mailchimp](https://github.com/jcnnghm/devise_mailchimp) and based upon [Gibbon](https://github.com/amro/gibbon), this gem works in a similar fashion but with a focus on multi-vendor support, rather than exclusively MailChimp.

It is directly extracted from [Sorry&#8482;](http://www.sorryapp.com/) where we use MailChimp to stay in touch with customers about our product development.

## Installation

Simply add DeviseCampaignable and Gibbon to your application's Gemfile:

	gem 'devise'
    gem 'devise_campaignable'

## Devise Configuration

DeviseCampaignable adds a few configuration variables which you'll need to add to your devise initilizer.

```ruby
Devise.setup do |config|
	# ==> Configuration for :campaignable
	config.campaignable_vendor = :mailchimp
	config.campaignable_api_key = 'your_service_api_key'
	config.campaignable_list_id = 'the_id_of_the_list_to_which_we_subscribe'
	config.campaignable_additional_fields = [:array, :of, :additional, :fields]
end
```

#### config.campaignable_vendor (optional)

A symbol which represents which mail campaign vendor you wish to use. Defaults to `:mailchimp`. Yet to support any other options but future plans for CampaignMonitor etc.

#### config.campaignable_api_key (required)

A API key for your chosen vendor. How you aqcuire this will depend from vendor to vendor. We also recommend for security that you store this in an environment variable instead of directly in the initializer.

#### config.campaignable_list_id (required)

The unique ID of the list to which you want your users to be subscribed. Again, how you get this will vary from vendor to vendor.

#### config.campaignable_additional_fields (optional)

An array of symbols which denote attributes on the model you want sent to the campaign vendor. Can be things like Name, Age, Address. Defaults to no additional fields.

## Model Configuration

Add :campaignable to the **devise** call in your model (we’re assuming here you already have a User model with some Devise modules):

```ruby
class User < ActiveRecord::Base
	devise :database_authenticatable, :confirmable, :campaignable
end
```

## Usage

### Automatic subscribe / unsubscribe

Once configured this gem will ensure any users which are created by Devise will be automaticaly subscribed to your mailing list. They will also be unsubscribed when they are deleted.

By default users are not required to 'double opt in' when added to your list.

### Manual subscribe / unsubscribe

Should you wish to manually subscribe or unsubscribe any of your users, we have added some new methods to your user model to help you do this.

#### Individual subscriptions

Instance methods `User.find(1).subscribe` and `User.find(1).unsubscribe` perform an action on a particular user.

#### Batch subscriptions

Class methods `User.subscribe_all()` and `User.unsubscribe_all()` add or remove all users in your system to your mailing list of choice.

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

Once you are happy that your contribution is ready for production please send us a pull request, at which point we'll review the code and merge it in.

## Versioning

For transparency and insight into our release cycle, and for striving to maintain backward compatibility, This project will be maintained under the Semantic Versioning guidelines as much as possible.

Releases will be numbered with the following format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on SemVer, please visit <http://semver.org/>.

## Authors & Contributors

**Robert Rawlins**

+ <http://twitter.com/sirrawlins>
+ <https://github.com/SirRawlins>

## Copyright

&copy; Copyright 2015 - See [LICENSE](LICENSE) for details.