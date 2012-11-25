require 'spec_helper'
require 'tracker_git/project'

describe TrackerGit::Project do
  let(:api_token) { stub }
  let(:project_id) { stub }
  let(:tracker_project) { stub }

  before do
    PivotalTracker::Project.stub(:find).with(project_id).and_return(tracker_project)
  end

  describe '#initialize' do
    let(:project) { TrackerGit::Project.new api_token, project_id }

    describe 'the project instance' do
      subject { project }
      its(:tracker_project) { should == tracker_project }
    end

    describe 'PivotalTracker::Client' do
      before { project }
      subject { PivotalTracker::Client }
      its(:use_ssl) { should be_true }
      specify { subject.instance_variable_get(:@token).should == api_token }
    end
  end

  describe '#stories' do
    let(:project) { TrackerGit::Project.new api_token, project_id }

    before do
      project.stub(:tracker_project).and_return(tracker_project)
      tracker_project.stub(:stories).and_return('stories')
    end

    subject { project.stories }
    it { should == 'stories' }
  end

  describe '#finished' do
    let(:project) { TrackerGit::Project.new api_token, project_id }
    let(:stories) { stub }

    before do
      project.stub(:stories).and_return(stories)
      stories.stub(:all).with(state: 'finished', story_type: %w(bug feature)).and_return('bugs and features')
    end

    subject { project.finished }
    it { should == 'bugs and features' }
  end

  describe '#deliver' do
    let(:project) { TrackerGit::Project.new api_token, project_id }
    let(:story) { stub }

    before do
      story.should_receive(:update).with(current_state: 'delivered').and_return('result')
    end

    subject { project.deliver(story) }
    it { should == 'result' }
  end
end
