Porch
======

[ ![Codeship Status for jwright/porch](https://app.codeship.com/projects/8780ad70-b5ae-0134-fb0d-62cbe9f5cc84/status?branch=master)](https://app.codeship.com/projects/194128)

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
      with(attributes) do |chain|
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

You can define steps as classes and include some nice helper methods. (COMING SOON)

```
# app/services/steps/create_user.rb

require "porch"

class CreateUser
  include Porch::Step

  params do
    required(:email).filled(type?: :str, format?: RegEx.email_address)
    required(:password).filled(type?: :str, min_size?: 8)
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
      with(attributes) do |chain|
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
      with(attributes) do |chain|
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

### Failing the chain

At any step, you can set the `Porch::Context` as a failure which will stop processing the remaining steps and set the `Context` as a failed context with an optional message.

```
class RegistersUser
  include Porch::Organizer

  # ...

  def register
    with(attributes) do |chain|
      # ...
      chain.add :send_welcome_email
      # ...
    end
  end

  private

  def send_welcome_email(context)
    context.fail! "Better luck next time!" if some_failure_condition?
    UserMailer.welcome(context.user).deliver_later
  end
end

result = RegistersUser.new(email: "test@example.com").register
if result.failure?
  puts result.message # => "Better luck next time!"
end
```

### Skipping steps

At any step, you can skip the remaining actions in the organizer. This stops the running of the remaining actions but the `Porch::Context` will still return a successful `Porch::Context`.

```
class RegistersUser
  include Porch::Organizer

  # ...

  def register
    with(attributes) do |chain|
      # ...
      chain.add :save_user
      # ...
    end
  end

  private

  def save_user(context)
    User.create context
    context.skip_remaining! if sending_emails_disabled?
  end
end

result = RegistersUser.new(email: "test@example.com").register
result.success? # => true
```

### Validating the context

Porch comes with multiple ways that you can validate each step is setup correctly. It uses the DSL provided by [dry-validation](http://dry-rb.org/gems/dry-validation/).

Several helper methods are included in the `Porch::Context` to guard against an invalid `Porch::Context`.

`Porch::Context#guard` can be used and if the validation fails, the `Context` will skip the remaining actions.

```
class SomeStep
  def call(context)
    context.guard { required(:email) }
    # The rest of the action will not be performed and the rest of the actions will be
    # skipped if the guard fails
  end
end
```

`Porch::Context#guard!` (with a bang(!)) can be used and if the validation fails, the `Context` will be marked as a failure. The failure message for the `Context` will be set to be a comma-seperated list of the context errors that failed.

```
class SomeStep
  def call(context)
    context.guard! { required(:email) }
    # The rest of the action will not be performed and the rest of the actions will be
    # skipped and the action will be marked as failed if the guard fails
  end
end
```

At any point, you can use the `Porch::GuardRail::Guard` helper method to validate any hash (including the `Porch::Context`).

```
hash = { email: "test@example" }
result = Porch::GuardRail::Guard.new(hash).against { required(:email).value(format?: RegEx::Email) }
result.success? # => false
result.errors # => { email: ["is invalid"] }
```

## CONTRIBUTING

1. Clone the repository `git clone https://github.com/jwright/porch`
1. Create a feature branch `git checkout -b my-awesome-feature`
1. Codez!
1. Commit your changes (small commits please)
1. Push your new branch `git push origin my-awesome-feature`
1. Create a pull request `hub pull-request -b jwright:master -h jwright:my-awesome-feature`

## RELEASING A NEW GEM

1. Bump the VERSION in `lib/porch/version.rb`
1. Commit changes and push to GitHub
1. run `bundle exec rake release`

## LICENSE

This project is licensed under the [MIT License](LICENSE.md).
