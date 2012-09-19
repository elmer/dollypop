require "spec_helper"

describe "stack::apps::redmine_install" do
  context "on Ubuntu installing to /var/lib/redmine/redmine-2.1.0 as 'redmine' user" do
    let(:facts) do
      {
        :osfamily                => "Debian",
        :operatingsystem         => "Ubuntu",
      }
    end
    let(:params) do 
      { :path  => "/var/lib/redmine",
        :owner => "redmine" }
    end
    it { should contain_package("libpq-dev") }
    it { should contain_package("libmagickcore-dev") }
    it { should contain_package("libmagickwand-dev") }
    it { should contain_package("libopenssl-ruby1.8") }
    it { should contain_package("librmagick-ruby") }

    it { should contain_rvm__define__gem("unicorn") }
    it { should contain_file("/var/lib/redmine/download") }
    it { should contain_exec("redmine_source") }
    it { should contain_exec("extract_source") }
    it { should contain_exec("ensure_owner") }
    it { should contain_exec("bundle_wrapper") }
    it { should contain_exec("bundle_redmine") }

    it { should contain_file("/var/lib/redmine/redmine-2.1.0/config/database.yml") }
    it { should contain_exec("redmine_rake_generate_token") }
    it { should contain_exec("redmine_rake_migrate") }
    it { should contain_exec("redmine_load_default_data") }
    it { should contain_file("redmine_files") }
    it { should contain_file("redmine_log") }
    it { should contain_file("redmine_tmp") }
    it { should contain_file("redmine_plugin_assets") }
    it { should contain_file("/etc/init/redmine.conf") }
    it { should contain_file("/etc/init.d/redmine") }
    it { should contain_service("redmine").with_ensure(:running) }







  end
end
