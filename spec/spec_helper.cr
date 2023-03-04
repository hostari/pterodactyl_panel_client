require "spec"
require "webmock"
Spec.before_each &->WebMock.reset
require "../src/pterodactyl_panel_client"

class WebMockWrapper
  HOST    = "137.184.187.126"
  ROOT    = "http://#{HOST}"
  HEADERS = {
    "Authorization" => "Bearer 1234",
    "Accept"        => "application/json",
    "Content-Type"  => "application/json",
  }

  def self.client_stub(method, body, path = "", status = 200)
    WebMock.stub(method, "#{ROOT}/api/client#{path}")
      .to_return(status: status, body: File.read("spec/support/#{body}"), headers: HEADERS)
  end

  def self.application_stub(method, body, path = "", status = 200)
    WebMock.stub(method, "#{ROOT}/api/application#{path}")
      .to_return(status: status, body: File.read("spec/support/#{body}"), headers: HEADERS)
  end
end
