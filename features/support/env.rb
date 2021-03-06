NEWSLETTRE_CONFIG = YAML.load_file File.dirname(__FILE__) + "/../../config/newslettre.yml"

require 'vcr'
require 'newslettre'
require 'chronic'

VCR.config do |c|
  c.stub_with :webmock
  c.cassette_library_dir = 'features/cassettes'
  c.filter_sensitive_data('<<USERNAME>>') { Curl::PostField.content "api_user", NEWSLETTRE_CONFIG['sendgrid']['username'] }
  c.filter_sensitive_data('<<PASSWORD>>') { Curl::PostField.content "api_key", NEWSLETTRE_CONFIG['sendgrid']['password'] }
  c.default_cassette_options = { :record => :once }
end

VCR.cucumber_tags do |t|
  t.tags '@sendgrid_adding_recipients', '@sendgrid_removing_recipients', '@sendgrid_scheduling_newsletter',
    '@sendgrid_descheduling_newsletter'
end

class OuterWorld
  def newslettre
    @newslettre ||= Newslettre::Client.new(NEWSLETTRE_CONFIG['sendgrid']['username'],
                                           NEWSLETTRE_CONFIG['sendgrid']['password'])
  end
end

World { OuterWorld.new }
