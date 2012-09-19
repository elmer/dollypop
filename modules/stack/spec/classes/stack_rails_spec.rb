require "spec_helper"

describe "stack::rails" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should contain_class("stack") }
    it { should include_class("stack::ruby") }
  end
end
