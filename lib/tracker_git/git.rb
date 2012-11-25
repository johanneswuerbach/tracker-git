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

    def contains?(story_id)
      exit_code = sh "#{log_command} --exit-code --grep='#{story_id}'"
      exit_code == 1
    end
  end
end
