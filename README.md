# FakeBook
A Sinatra app built to integrate with the fictional JSON 'Coolpay' api.

## Getting Started
Clone it: `git clone git@github.com:philbrockwell1984/fakebook.git`\
CD into it: `cd fakebook`\
Bundle it: `bundle`\
Create the log file: `touch log/db.log`\
Create the dbs: `rake db:create env=test && rake db:create env=development`\
Migrate the dbs: `rake db:migrate env=test && rake db:migrate env=development`\
Create the secrets file: `rake secrets:create`\
Run the App: `bundle exec rackup -p 3000`\
Check it out in the browser: `http://localhost:3000/`

## Improvements
### Front end
Some JS could be implemented for the api calls to avoid page refreshes and keep the user updated during requests.

### Feature testing
Test coverage should be increased to include coverage for all actions in the front end, e.g. Add Recipient/Payment. This could be done with Cucumber/Capybara.

### Add Payment with Recipient List
The Add Payment function could be extended to provide a list of available recipients by making a get request to the Coolpay API and rendering a list with ids, instead of having to copy and paste the recipient id
