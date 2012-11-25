#!/usr/bin/env ruby

require 'optparse'
require 'methadone'
require 'tracker_git'

module TrackerGit
  class App
    include Methadone::Main
    include Methadone::CLILogging

    singleton_class.instance_eval do
      attr_reader :deliverer, :git, :main_block, :project
    end

    main do |project_id, api_token, branch|
      project_id ||= ENV['TRACKER_PROJECT_ID']
      api_token ||= ENV['TRACKER_TOKEN']

      branch ||= ENV['GIT_BRANCH'] || 'master'
      branch = nil if options['current-branch']

      @project = TrackerGit::Project.new api_token, project_id
      @git = TrackerGit::Git.new branch
      @deliverer = TrackerGit::Deliverer.new @project, @git
      @deliverer.mark_as_delivered
    end

    on '--current-branch', '-c',
       'Do not specify a branch to use when searching commit messages'

    arg :tracker_project_id, :optional,
        "A Tracker project ID is required. Pass it as an argument, or set the\n" +
          "\tenvironment variable TRACKER_PROJECT_ID."

    arg :tracker_api_token, :optional,
        "An API token is required. Pass it as an argument, or set the\n" +
          "\tenvironment variable TRACKER_TOKEN."

    arg :git_branch, :optional,
        "Which branch to search for commit messages. Pass it as an argument,\n"+
          "\tor set the environment variable GIT_BRANCH. 'master' is the default.\n" +
          "\tOr specify no branch using the --current-branch flag."

    use_log_level_option

    description TrackerGit::DESCRIPTION
    version TrackerGit::VERSION
  end
end
