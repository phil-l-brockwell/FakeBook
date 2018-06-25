# FakeBook
A Sinatra app built to integrate with the fictional JSON 'Coolpay' api.

## Getting Started
Clone it: `git clone git@github.com:philbrockwell1984/fakebook.git`\
CD into it: `cd fakebook`\
Initialize the app: `bundle exec rake app:init`\
Follow the instructions on screen!

## Improvements
### Front end
Some JS could be implemented for the api calls to avoid page refreshes and keep the user updated during requests.

### Feature testing
Test coverage should be increased to include coverage for all actions in the front end, e.g. Add Recipient/Payment. This could be done with Cucumber/Capybara.

### Add Payment with Recipient List
The Add Payment function could be extended to provide a list of available recipients by making a get request to the Coolpay API and rendering a list with ids, instead of having to copy and paste the recipient id
