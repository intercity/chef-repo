require "spec_helper"

describe "Ngninx server" do

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

end
