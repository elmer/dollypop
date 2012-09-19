require "spec_helper"

describe "stack::apps::redmine" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should include_class("stack::rails") }
    it { should include_class("apache") }
    it { should include_class("apache::mod::proxy") }
    it { should include_class("apache::mod::proxy_http") }
    it { should contain_user("redmine") }

    it { should contain_rvm__define__user("redmine") }
    it { should contain_rvm__define__gemset("redmine").with_ruby_version("ruby-1.9.2") }

    it { should include_class("stack::apps::redmine_install") }


  end
end
