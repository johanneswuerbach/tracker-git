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
          if options[:dryrun]
            puts "Delivering story #{story}"
          else
            project.deliver(story)
          end
        end
      end
    end
  end
end
