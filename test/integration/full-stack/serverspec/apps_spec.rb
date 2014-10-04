require "spec_helper"

describe file("/u/apps/intercity_sample_app") do
  it { should be_directory }
end

describe command('mysql -u intercity --password=r4nd0m -e "show databases;"') do
  its (:stdout) { should match /intercity_sample_app/ }
  its (:exit_status) { should eq 0 }
end

describe file("/etc/nginx/sites-available/intercity_sample_app.conf") do
  its (:content) { should match /^  server_name intercity.io;$/ }
end
