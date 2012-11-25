require 'pivotal-tracker'

module TrackerGit
  class Project
    attr_reader :api_token, :project_id

    def initialize(api_token, project_id)
      @api_token = api_token
      @project_id = project_id

      PivotalTracker::Client.token = api_token
      PivotalTracker::Client.use_ssl = true
    end

    def tracker_project
      @project ||= PivotalTracker::Project.find(project_id)
    end

    def stories
      tracker_project.stories
    end

    def finished
      stories.all(state: 'finished', story_type: %w(bug feature))
    end

    def deliver(story)
      story.update(current_state: 'delivered')
    end
  end
end
