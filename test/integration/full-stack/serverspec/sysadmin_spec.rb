require "spec_helper"

describe file("/home/jdoe") do
  it { should be_directory }
end

describe file("/home/jdoe/.ssh/authorized_keys") do
  its (:content) { should match /test-key/ }
end
