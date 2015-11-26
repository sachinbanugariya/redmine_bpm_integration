# encoding: UTF-8

namespace :redmine do
  namespace :plugins do
    namespace :bpm_integration do
      task sync_process_definitions: :environment do
          require_relative '../../app/jobs/sync_process_definitions_job'
          SyncProcessDefinitionsJob.perform_now
      end
    end
  end
end
