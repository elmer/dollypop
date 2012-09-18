require "spec_helper"

describe "stack::database" do
  context "on Ubuntu" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    it { should include_class('stack') }
    it { should include_class('postgres') }
  end

  context "with test1 and test2 databases" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
        :databases               => "test1,test2",
        :database_test1_user     => "user1",
        :database_test1_password => "password1",
        :database_test2_user     => "user2",
        :database_test2_password => "password2"
      }
    end
    it { should contain_stack__database__create("test1") }
    it { should contain_stack__database__create("test2") }

    it { should contain_postgres__role("user1").with_password('password1') }
    it { should contain_postgres__database("test1").with_owner('user1') }

    it { should contain_postgres__role("user2").with_password('password2') }
    it { should contain_postgres__database("test2").with_owner('user2') }
  end

  context "with missing database parameters" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
        :databases               => "test1",
      }
    end
    it 'should fail with Missing DB parameters' do
      expect do
        subject
      end.to raise_error(/Missing DB/)
    end
  end
end
