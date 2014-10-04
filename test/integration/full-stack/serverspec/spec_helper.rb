require "serverspec"

Specinfra.configuration.backend = :exec

RSpec.configure do |c|
  c.before :all do
    c.path = "/bin:/sbin:/usr/sbin:/usr/bin"
  end
end
