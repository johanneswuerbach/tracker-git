module Tracker
  class Deliverer
    attr_reader :project, :git
    def initialize(project, git)
      @project = project
      @git = git
    end

    def mark_as_delivered(options={})
      project.finished.each do |story|
        if git.contains?(story.id, options)
          puts "Delivering story #{story}"
          unless options[:dryrun]
            project.deliver(story)
          end
        end
      end
    end
  end
end
