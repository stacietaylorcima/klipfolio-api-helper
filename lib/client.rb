require "httparty"
require "json"
require "csv"

class Client
  include HTTParty

  def initialize(u, p)
    @auth = { username: u, password: p }
  end

  # The method starts by reading the file, using  File.read.
  # The file will be in a CSV format. We use the CSV class to parse the file.
  # The result of CSV.parse is an object of type CSV::Table.
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    # Iterate over the CSV::Table object's rows, create a hash for each row, and convert each row_hash to a Client by using the create_client method.
    csv.each do |row|
      name = row.to_s.chomp
      create_client(name)
    end
  end

  # Creates a new client and sends a request to Klipfolio's API via the HTTP POST method
  # Params: name = the client's name found on spreadsheet, string
  def create_client(name)
    # Point the HTTP POST method at the clients endpoint of Klipfolio's API.
    # Use HTTParty basic suth to pass valid credentials from the initialize method.
    # Use HTTP header option to pass the content type.
    # Use HTTP body option to pass all of the required parameters
    puts name
    response = self.class.post("https://app.klipfolio.com/api/1.0/clients", basic_auth: @auth, headers: { "Content-Type" => "application/json" },
    body: {
      "name": name,
      "description": "",
      "seats": 5,
      "status": "active"
    }.to_json)
    puts response.body
    puts "Your client was created!" if response.success?
  end
end
