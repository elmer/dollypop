require "spec_helper"

describe "stack::setup" do
  it { should contain_exec('refresh_apt_cache') }
  #.with_command("/usr/bin/apt-get -q update") }
end
