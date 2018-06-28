# Klipfolio API Script

Have you recently signed up with Klipfolio for reporting services? Do you need to import a bulk load of clients? Then this code is for you! This script is used to simplify the client setup process for when you need to add a large number at once.

## My Use Case Scenario

My company decided to switch reporting tools, so we signed up with Klipfolio and were faced with the challenge of adding our 170+ clients to their platform all at once. The manual process for this would have been very laborious, so I built a script to make it more efficient.

For our initial rollout of Klipfolio portals to all our clients, we wanted each client portal to be identical EXCEPT the client name. To implement this, we created a csv with the names of each client and hard coded the values into the script that would be the same across the board.

This script will create a new client for each row on the spreadsheet using the name found on the spreadsheet and the other hard coded values found in the HTTP body method found in the create_client method of the client.rb

## What does the script do?

This script loops through each row of a csv that contains client names and creates a client in the Klipfolio app for each. It creates the clients by sending a HTTP POST request to Klipfolio's API: [see documentation here](https://apidocs.klipfolio.com/reference#section-post-clients)

## To use:

* Create a csv that includes a header, followed by a list of only your client's names in the A column. Save this csv in this project's `lib` directory.
* Navigate to the `lib` directory
* Launch `irb`
* `require './client.rb'`
* `client = Client.new("yourusername", "yourpassword")`
* `client.import_from_csv('./clients.csv')`

## Customize the script

There are 6 parameters you can include to customize the client you are creating: `name, description, status, seats (optional), custom_theme (optional), external_id (optional)`. See Klipfolio's API Documentation for [POST Clients](https://apidocs.klipfolio.com/reference#section-post-clients)
