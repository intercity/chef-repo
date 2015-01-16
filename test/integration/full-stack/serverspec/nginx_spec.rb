require "spec_helper"

describe "Ngninx server" do

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

end

describe file("/etc/nginx/sites-available/intercity_sample_app.conf") do
  it { should be_file }

  its(:content) do
    should match /location ~ \^\/\(assets\)\/.*gzip_static on;/m
  end
end
