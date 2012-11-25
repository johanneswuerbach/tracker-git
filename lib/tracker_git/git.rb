require 'methadone/cli_logger'
require 'methadone/cli_logging'
require 'methadone/sh'

module TrackerGit
  class Git
    include Methadone::CLILogging
    include Methadone::SH

    attr_reader :branch

    def initialize(branch)
      @branch = branch
    end

    def log_command
      "git log #{branch if branch}".strip
    end

    def grep_pattern(story_id)
      '\[(fix|finish).*#' + story_id.to_s + '.*\]'
    end

    def contains?(story_id)
      sh "#{log_command} -i -E --grep=\"#{grep_pattern story_id}\"" do |stdout, stderr|
        if !stdout.strip.empty?
          info "Found commit messages matching ##{story_id}"
          return true
        else
          info "Found no commit messages matching ##{story_id}"
          return false
        end
      end
    end
  end
end
