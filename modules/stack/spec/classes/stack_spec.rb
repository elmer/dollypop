require "spec_helper"

describe "stack" do
  it { should include_class('stdlib') }
  it { should contain_service('sshd') }
end
