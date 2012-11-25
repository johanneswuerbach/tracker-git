require 'spec_helper'

describe TrackerGit::Deliverer do
  let(:committed_story) { stub(id: 1) }
  let(:uncommitted_story) { stub(id: 2) }
  let(:finished_stories) { [committed_story, uncommitted_story] }
  let(:project) { stub }
  let(:git) { stub }
  let(:deliverer) { TrackerGit::Deliverer.new project, git }

  describe '#initialize' do
    subject { deliverer }
    its(:git) { should == git }
    its(:project) { should == project }
  end

  describe '#mark_as_delivered' do
    before do
      project.stub(:finished).and_return(finished_stories)
      git.stub(:contains?).with(1).and_return(true)
      git.stub(:contains?).with(2).and_return(false)
      project.should_receive(:deliver).with(committed_story)
      project.should_not_receive(:deliver).with(uncommitted_story)
    end

    specify { deliverer.mark_as_delivered }
  end
end
