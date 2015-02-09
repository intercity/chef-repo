require "spec_helper"

describe "ruby::default" do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it "installs ruby" do
    expect(chef_run).to install_package("foo")
  end
end
