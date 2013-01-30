#
# Cookbook Name:: wkhtmltopdf
# Recipe:: default
#

execute "install wkhtmltopdf" do
  command "curl http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2 | bunzip2 - | sudo tar xfv -; sudo mv wkhtmltopdf-amd64 wkhtmltopdf"
  user "root"
  group "root"
  cwd "/usr/local/bin"
  not_if { File.exists?("/usr/local/bin/wkhtmltopdf") }
end