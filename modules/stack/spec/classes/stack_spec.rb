require "spec_helper"

describe "stack" do
  it { should include_class('stdlib') }
  it { should include_class('stack::setup') }
  it { should include_class('apt::unattended-upgrades') }
end
