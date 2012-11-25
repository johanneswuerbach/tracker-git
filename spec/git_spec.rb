require 'spec_helper'
require 'tracker_git/git'

describe TrackerGit::Git do
  describe '#initialize' do
    let(:git) { TrackerGit::Git.new 'branch' }
    subject { git.branch }
    it { should == 'branch' }
  end

  describe '#log_command' do
    subject { git.log_command }

    context 'when the branch is not set' do
      let(:git) { TrackerGit::Git.new false }
      it { should == 'git log' }
    end

    context 'when the branch is set' do
      let(:git) { TrackerGit::Git.new 'foo' }
      it { should == 'git log foo' }
    end
  end

  describe '#contains?' do
    let(:story_id) { '123456' }
    let(:log_command) { "git log foo --exit-code --grep='#{story_id}'" }
    let(:git) { TrackerGit::Git.new 'foo' }

    before do
      git.should_receive(:sh).with(log_command).and_return(result)
    end

    subject { git.contains? story_id }

    context 'when the grep pattern matches a commit message in the branch' do
      let(:result) { 1 }
      it { should be_true }
    end

    context 'when the grep pattern does not match any commit message in the branch' do
      let(:result) { 0 }
      it { should be_false }
    end
  end
end
