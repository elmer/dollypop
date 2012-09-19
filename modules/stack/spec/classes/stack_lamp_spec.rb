require "spec_helper"

describe "stack::lamp" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should include_class("apache") }
    it { should include_class('apache::mod::php') }

    it { should contain_package("php5-gd") }
    it { should contain_package("php5-pgsql") }
  end

end
