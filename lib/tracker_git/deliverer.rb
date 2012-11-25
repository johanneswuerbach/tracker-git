module TrackerGit
  class Deliverer
    attr_reader :project, :git

    def initialize(project, git)
      @project = project
      @git = git
    end

    def mark_as_delivered
      project.finished.each do |story|
        project.deliver(story) if git.contains?(story.id)
      end
    end
  end
end
