require 'methadone/cli_logger'
require 'methadone/cli_logging'

module TrackerGit
  class Deliverer
    include Methadone::CLILogging

    attr_reader :git, :note_delivery, :project

    def initialize(options = {})
      @git = options[:git]
      @note_delivery = options[:note_delivery]
      @project = options[:project]
    end

    def mark_as_delivered
      project.finished.each do |story|
        if git.contains?(story.id)
          project.deliver(story)
          project.note_delivery(story) if note_delivery
        end
      end
    end
  end
end
