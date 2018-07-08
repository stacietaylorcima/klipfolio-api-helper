# Klipfolio API Script

Have you recently signed up with Klipfolio for reporting services? Do you need to import a bulk load of clients? Then this code is for you! This script is used to simplify the client setup process for when you need to add a large number at once.

<hr>

## My Use Case Scenario

My company decided to switch reporting tools, so we signed up with Klipfolio and were faced with the challenge of adding our 170+ clients to their platform all at once. The manual process for this would have been very laborious, so I built a script to make it more efficient.

For our initial rollout of Klipfolio portals to all our clients, we wanted each client portal to be identical EXCEPT the client name. To implement this, we created a csv with the names of each client and hard coded the values into the script that would be the same across the board.

This script will create a new client for each row on the spreadsheet using the name found on the spreadsheet and the other hard coded values found in the HTTP body method found in the create_client method of the client.rb

<hr>

## What does the script do?

This script loops through each row of a csv that contains client names and creates a client in the Klipfolio app for each. It creates the clients by sending a HTTP POST request to Klipfolio's API: [see documentation here](https://apidocs.klipfolio.com/reference#section-post-clients)

The client that is created includes the following attributes:
* **Client Name**
* **Account Status:** active
* **Resources:**
  * Max Dashboard Limit: 1
  * Max API Calls Per Day:
  * Max Users: 5
* **Enabled Features:**
  * Download Reports
  * Email Reports
  * Private Links
  * Public Links
* **Company Properties:**
  * FBPageID
  * TwitterHandle
* **Group**
  * Create a group named Social High Rise Client
* **Dashboard Management**
  * Share "Social Snapshot" Dashboard

<hr>

## To use:
* Create a csv that includes the following columns:
  * Client Name
  * Facebook ID
  * Twitter Handle
* Save this csv in this project's `lib` directory as `clients.csv`.
  * Be sure to remove the existing `clients.csv` file or simple replace it's contents with your own.
* Navigate to the `lib` directory
* Launch `irb`
* `require './client.rb'`
* `client = Client.new("yourusername", "yourpassword")`
* `client.import_from_csv('./clients.csv')`

<hr>

## Customize the script
There are many customizations you can make to the script to create your clients exactly how you would like them. Below I have listed the Klipfolio documentation for all of the HTTP requests I've used in the script. You can access the documentation and see all the ways to customize each specific request.

`create_client` method: See Klipfolio's API Documentation for [POST Clients](https://apidocs.klipfolio.com/reference#section-post-clients)

`update_resources` method: See Klipfolio's API Documentation for [PUT Resources](https://apidocs.klipfolio.com/reference#section-putclientsidresources)

`update_features` method: See Klipfolio's API Documentation for [PUT Features](https://apidocs.klipfolio.com/reference#section-putclientsidfeatures)

`update_company_properties` method: See Klipfolio's API Documentation for [PUT Company Properties](https://apidocs.klipfolio.com/reference#section-put-clientsidproperties)

`create_group` method: See Klipfolio's API Documentation for [POST Groups](https://apidocs.klipfolio.com/reference#section-post-groups)

`share_dashboard` method: See Klipfolio's API Documentation for [POST Tab](https://apidocs.klipfolio.com/reference#section-post-tabsidimport)
