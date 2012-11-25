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

    arg :tracker_project_id, :optional
    arg :tracker_api_token, :optional
    arg :git_branch, :optional

    use_log_level_option

    description TrackerGit::DESCRIPTION
    version TrackerGit::VERSION
  end
end
