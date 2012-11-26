require 'methadone/cli_logger'
require 'methadone/cli_logging'
require 'pivotal-tracker'
require 'tracker_git/information'

module TrackerGit
  class Project
    include Methadone::CLILogging

    attr_reader :tracker_project

    def initialize(api_token, project_id)
      PivotalTracker::Client.token = api_token
      PivotalTracker::Client.use_ssl = true

      @tracker_project = PivotalTracker::Project.find project_id
      info "Pivotal Tracker project ##{project_id} - #{@tracker_project.name}"
    end

    def stories
      tracker_project.stories
    end

    def finished
      stories.all(state: 'finished', story_type: %w(bug feature))
    end

    def deliver(story)
      info "Delivering ##{story.id} - #{story.name}"
      story.update(current_state: 'delivered')
    end

    def note_delivery(story)
      note = story.notes.create(text: TrackerGit::DELIVERY_NOTE)
      debug "  \"#{note.text}\""
    end
  end
end
