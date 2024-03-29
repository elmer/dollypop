require "spec_helper"

describe "stack::apps::drupal" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should include_class("stack::lamp") }
    it { should include_class("stack::apps::drupal::dependencies") }
    it { should include_class("stack::apps::drupal::install") }
  end
end
