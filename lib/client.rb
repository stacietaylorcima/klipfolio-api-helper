require "httparty"
require "json"
require "csv"

class Client
  include HTTParty

  # def initialize(u, p)
  #   @auth = { username: u, password: p }
  # end

  # The method starts by reading the file, using  File.read.
  # The file will be in a CSV format. We use the CSV class to parse the file.
  # The result of CSV.parse is an object of type CSV::Table.
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    # Iterate over the CSV::Table object's rows, create a hash for each row, and convert each row_hash to a Client by using the create_client method.
    csv.each do |row|
      row_hash = row.to_hash
      puts row_hash
      create_client(row_hash["name"])
    end
  end

  # Creates a new client and sends a request to Klipfolio's API via the HTTP POST method
  # Params: name = the client's name found on spreadsheet, string
  def create_client(name)
    # Point the HTTP POST method at the clients endpoint of Klipfolio's API.
    # Use HTTP header option to pass the auth_token.
    # Use HTTP body option to pass all of the required parameters
    response = self.class.post("https://app.klipfolio.com/api/1.0/clients", basic_auth: @auth,
    body: {
      "name": name, # Get name from csv file
      "description": "",
      "seats": 1,
      "status": "Active"
      })
      puts "Your client was created!" if response.success?
  end
end
