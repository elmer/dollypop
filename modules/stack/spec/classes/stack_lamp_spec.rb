require "spec_helper"

describe "stack::lamp" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should include_class('apache') }
  end

end
