Porch
======

A simple service layer pattern for plain old Ruby objects.

## DESCRIPTION

Yeah, yeah, yeah. Keep yer controllers skinny they always tell us. This is a lot easier to say than do in many cases. Our controllers are supposed to create that user, send them an invitation email, block them from access until they authenticate their email address, etc.

Porch allows you to move the code into a series of steps that execute simple methods on itself or within simple PORO objects.

This was inspired by [LightService](https://github.com/adomokos/light-service) and the middleware chain by [Sidekiq](https://github.com/mperham/sidekiq).

## USAGE

### Installation

```
gem install porch
```

### Getting started

Your service object is simply a series of steps.

```
# app/services/registers_user.rb

require "porch"

module Services
  class RegistersUser
    include Porch::Organizer

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def register
      with(attributes).steps do |chain|
        chain.add CreateUser
        chain.add SendWelcomeEmail
        chain.add CreateBillingCustomer
      end
    end
  end
end
```

You can then use your service in your controllers with the result that it returns from the chain.

```
# app/controllers/users_controller.rb

class UsersController < ApplicationController
  def create
    result = Services::RegistersUser.new(params[:user]).register

    if result.success?
      redirect_to dashboard_path(result.user), notice: "Welcome #{result.user.name}."
    else
      flash[:error] = result.message
      render :new
    end
  end
end
```

### Defining steps or actions

You can define steps as classes and include some nice helper methods.

```
# app/services/steps/create_user.rb

require "porch"

class CreateUser
  include Porch::Step

  params do
    required(:email, :string, format: RegEx.email_address)
    required(:password, :string, min_length: 8)
  end

  def call(context)
    context.user = User.create email: context.email, password: context.password
    context.fail! context.user.errors unless context.user.valid?
  end
end
```

You can define steps as PORO classes that respond to a call method.

```
# app/services/create_billing_customer.rb

require "stripe"

class CreateBillingCustomer
  def call(context)
    customer = Stripe::Customer.create email: context.email
    User.find_by_email(context.email).update_attributes(billing_id: customer.id)
  end
end
```

You can define steps as blocks on the organizer

```
# app/services/registers_user.rb

require "porch"

module Services
  class RegistersUser
    include Porch::Organizer

    # ...

    def register
      with(attributes).steps do |chain|
        # ...
        chain.add :send_welcome_email do |context|
          UserMailer.welcome(context.user).deliver_later
        end
        # ...
      end
    end
  end
end
```

You can define steps as methods on the organizer.

```
# app/services/registers_user.rb

require "porch"

module Services
  class RegistersUser
    include Porch::Organizer

    # ...

    def register
      with(attributes).steps do |chain|
        # ...
        chain.add :send_welcome_email
        # ...
      end
    end

    private

    def send_welcome_email(context)
      UserMailer.welcome(context.user).deliver_later
    end
  end
end
```

## CONTRIBUTING

1. Clone the repository `git clone https://github.com/jwright/porch`
1. Create a feature branch `git checkout -b my-awesome-feature`
1. Codez!
1. Commit your changes (small commits please)
1. Push your new branch `git push origin my-awesome-feature`
1. Create a pull request `hub pull-request -b jwright:master -h jwright:my-awesome-feature`

## LICENSE

This project is licensed under the [MIT License](LICENSE.md).
