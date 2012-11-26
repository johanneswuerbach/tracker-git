require 'spec_helper'
require 'tracker_git/deliverer'

describe TrackerGit::Deliverer do
  let(:project) { stub }
  let(:git) { stub }
  let(:deliverer) {
    TrackerGit::Deliverer.new(
      project: project,
      git: git,
      note_delivery: note_delivery
    )
  }

  describe '#initialize' do
    let(:note_delivery) { stub }

    subject { deliverer }

    its(:git) { should == git }
    its(:note_delivery) { should == note_delivery }
    its(:project) { should == project }
  end

  describe '#mark_as_delivered' do
    let(:committed_story) { stub(id: 1) }
    let(:uncommitted_story) { stub(id: 2) }
    let(:finished_stories) { [committed_story, uncommitted_story] }

    before do
      project.stub(:finished).and_return(finished_stories)
      git.stub(:contains?).with(1).and_return(true)
      git.stub(:contains?).with(2).and_return(false)
      project.should_receive(:deliver).with(committed_story)
      project.should_not_receive(:deliver).with(uncommitted_story)
    end

    context 'when note_delivery is not set' do
      let(:note_delivery) { false }

      specify { deliverer.mark_as_delivered }
    end

    context 'when note_delivery is set' do
      let(:note_delivery) { true }

      before do
        project.should_receive(:note_delivery).with(committed_story)
        project.should_not_receive(:note_delivery).with(uncommitted_story)
      end

      specify { deliverer.mark_as_delivered }
    end
  end
end
