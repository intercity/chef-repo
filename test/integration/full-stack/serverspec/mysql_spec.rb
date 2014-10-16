require "spec_helper"

describe "MySQL Server" do

  it "is listening on port 3306" do
    expect(port(3306)).to be_listening
  end

end

describe command('mysql -u root --password=test -e "show databases;"') do
  its (:stdout) { should match /information_schema/ }
  its (:exit_status) { should eq 0 }
end
