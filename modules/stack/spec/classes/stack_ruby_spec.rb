require "spec_helper"

describe "stack::ruby" do
  it { should include_class('stack') }
  it { should include_class('rvm') }
  it { should contain_rvm__define__version('ruby-1.9.2').with_ensure(:present) }
end
