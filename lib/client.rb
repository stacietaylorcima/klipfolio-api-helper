require "httparty"
require "json"
require "csv"
require "pry"

class Client
  include HTTParty

  def initialize(u, p)
    # Use HTTParty basic auth to pass valid Klipfolio credentials to the requests
    @auth = { username: u, password: p }
  end

  # The method starts by reading the file, using  File.read.
  # The file will be in a CSV format. We use the CSV class to parse the file.
  # The result of CSV.parse is an object of type CSV::Table.
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    # Iterate over the CSV::Table object's rows, create a string for each row, and convert each row to a Client by using the create_client method.
    csv.each do |row|
      name, facebook_id, twitter_handle = row.to_s.split(",").map(&:chomp)
      create_client(name, facebook_id, twitter_handle)
    end
  end

  # Creates a new client and sends a request to Klipfolio's API via the HTTP POST method
  # Params: name = the client's name found on spreadsheet, string
  def create_client(name, facebook_id, twitter_handle)
    puts name, facebook_id, twitter_handle
    # Point the HTTP POST method at the clients endpoint of Klipfolio's API.
    response = self.class.post("https://app.klipfolio.com/api/1.0/clients", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      "name": name,
      "description": "",
      "seats": 5,
      "status": "active"
    }.to_json)
    puts response.body
    puts "Client was successfully created." if response.success?

    # Extract the new client's ID from the HTTP response so that it can be passed to the update_features & update_resources methods.
    client_id = response["meta"]["location"]
    client_id.slice!("/clients/")
    p client_id

    update_resources(client_id)
    update_features(client_id)
    update_company_properties(client_id, facebook_id, twitter_handle)
    create_group(client_id)
    share_dashboard(client_id)
  end

  # Adds resources to newly created Klipfolio client
  # Params: client_id is extracted from the response of the POST request in the create_client method, string
  def update_resources(client_id)
    response = self.class.put("https://app.klipfolio.com/api/1.0/clients/#{client_id}/resources", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      "resources": [{"name":"dashboard.tabs.total", "value":1}]
    }.to_json)
    puts response.body
    puts "Client's resources were updated." if response.success?
  end

  # Adds features to newly created Klipfolio client
  # Params: client_id is extracted from the response of the POST request in the create_client method, string
  def update_features(client_id)
    response = self.class.put("https://app.klipfolio.com/api/1.0/clients/#{client_id}/features", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      features:[{"name":"public_dashboards","enabled":true},
        {"name":"published_dashboards","enabled":true},
        {"name":"downloadable_reports","enabled":true},
        {"name":"scheduled_emails","enabled":true}]
    }.to_json)
    puts response.body
    puts "Client's features were updated." if response.success?
  end

  # Add the client's Facebook ID as a company property to their Klipfolio account
  # Params: client_id is extracted from the response of the POST request in the create_client method, string
  def update_company_properties(client_id, facebook_id, twitter_handle)
    response = self.class.put("https://app.klipfolio.com/api/1.0/clients/#{client_id}/properties", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
    'properties': {'FBPageID': facebook_id,
      'TwitterHandle': twitter_handle}
    }.to_json)
    puts response.body
    puts "Client's FBPageID & TwitterHandle were saved." if response.success?
  end

  def create_group(client_id)
    response = self.class.post("https://app.klipfolio.com/api/1.0/groups", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      'name': 'Social High Rise Client', 'description': 'Point of contact', 'client_id': client_id
    }.to_json)
    puts response.body
    puts "Group was successfully created." if response.success?
  end

  def share_dashboard(client_id)
    response = self.class.post("https://app.klipfolio.com/api/1.0/tabs/2e4dc815febc627a216b511b71afd119/@/import", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      'client_id': client_id
    }.to_json)
    puts response.body
    puts "Dashboard template was successfully shared." if response.success?
  end
end
