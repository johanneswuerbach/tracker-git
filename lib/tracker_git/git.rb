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

    def contains?(story_id)
      exit_code = sh "git log #{branch} --grep='#{story_id}' --exit-code"
      exit_code == 1
    end
  end
end
