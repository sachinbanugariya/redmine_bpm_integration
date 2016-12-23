Rails.configuration.to_prepare do
  ActiveSupport::Dependencies.autoload_paths << File.expand_path('../app/services', __FILE__)
  ActiveSupport::Dependencies.autoload_paths << File.expand_path('../app/jobs', __FILE__)
end

require_relative './lib/bpm_integration/utils/sync_jobs_period'

Redmine::Plugin.register :bpm_integration do
  name 'BPM Integration Plugin'
  author 'Filipe Xavier, Lucas Arnaud, Thales Pires'
  description 'This is a plugin for integrating Redmine with Activiti BPM.'
  version '0.0.1'
  url 'https://github.com/thalestpires/redmine_bpm_integration'

  menu :admin_menu, :bpm_processes, { controller: 'process_definitions', action: 'index' }, caption: :bpm_processes

  settings default: {}, partial: 'settings/bpm_integration'

  require 'bpm_integration/hooks/process_instance_hook_listener'

  Tracker.send(:include, BpmIntegration::Patches::TrackerPatch) unless Tracker.included_modules.include? BpmIntegration::Patches::TrackerPatch
  Issue.send(:include, BpmIntegration::Patches::IssuePatch) unless Issue.included_modules.include? BpmIntegration::Patches::IssuePatch
  CustomField.send(:include, BpmIntegration::Patches::CustomFieldPatch) unless CustomField.included_modules.include? BpmIntegration::Patches::CustomFieldPatch

end
