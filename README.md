# Check In Service

A basic example check-in service which allows a user to check-in to a store. It is incomplete but supports basic functionality and has some security checks to prevent abuse.

## Developer Setup
Simple Rack based ruby web application. Uses the Grape API micro-framework. MySQL database is used in development.

1. Clone the repository.
2. Install necessary gems.

        bundle install
3. Double-check database settings in the .env file and use rake to setup your database.

        rake db:create db:schema:load
4. Start the app server using the shotgun gem.

        shotgun
5. Test the API using a variety of tools, such as cURL.

        curl http://localhost:9393/health

## Testing
This service is tested using rspec and request specs with help from FactoryGirl.

1. Setup the test database.

        RACK_ENV=test rake db:create db:schema:load
2. Run the tests using rspec.

        rspec
       
## Features

- Allows a user to check-in to a store.
- Validates the request using a secret key that is provided only to the store.
- Prevents users from checking in to the same store more than once an hour.
- Prevents users from checking in to any stores more than once every 5 minutes.
