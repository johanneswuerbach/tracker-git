require 'spec_helper'

describe Tracker::Project do

  let(:tracker_token) { double }
  let(:project_id) { double }
  let(:the_project) { double }
  let(:feature) { double }
  let(:bug) { double }

  describe "#initialize" do
    it "initializes the project class" do
      project = Tracker::Project.new(tracker_token, project_id)
      project.should be
      project.tracker_token.should == tracker_token
      project.project_id.should == project_id
    end
  end

  describe "#finished" do

    let(:query) { double }

    before do
      PivotalTracker::Project.should_receive(:find).with(project_id) { the_project }
      the_project.should_receive(:stories) { query }
      query.should_receive(:all).with(state: "finished", story_type: ['bug', 'feature']) { [feature, bug] }
    end

    it "retrieves finished stories and bugs" do
      project = Tracker::Project.new(tracker_token, project_id)
      project.finished.should == [feature, bug]
    end
  end

  describe "#deliver" do
    let(:project) { Tracker::Project.new(double, double) }
    let(:story) { double }

    it "marks the story as delivered" do
      story.should_receive(:update).with(current_state: "delivered")
      project.deliver(story)
    end
  end

end
