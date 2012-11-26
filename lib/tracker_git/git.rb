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
        if stdout.strip.empty?
          info "Found no commit messages referring to ##{story_id}"
          return false
        else
          info "Found commit messages referring to ##{story_id}"
          return true
        end
      end
    end
  end
end
