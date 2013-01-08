SPEC_ROOT = File.expand_path('..', __FILE__)
require 'givey_ruby'
require 'factory_girl'
require 'log_buddy'
require 'json'
require "#{SPEC_ROOT}/factories.rb"
Dir["#{SPEC_ROOT}/support/**/*.rb"].each { |file| require file }

# autoload models
#Dir["spec/models/*.rb"].each do |file|
#  autoload File.basename(file, ".rb").titleize.to_sym, "models/#{File.basename(file, ".#rb")}"
#end


RSpec.configure do |config|

  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.include FactoryGirl::Syntax::Methods

  # only run specs tagged with focus id any are tagged
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
  end

  config.after(:each) do
    Dir.glob("#{SPEC_ROOT}/tmp/*").each {|f| File.delete(f) }
  end

  config.after(:all) do
  end

end
