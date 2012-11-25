require 'spec_helper'
require 'tracker_git/git'

describe TrackerGit::Git do
  before do
    TrackerGit::Git.any_instance.stub(:debug)
    TrackerGit::Git.any_instance.stub(:info)
  end

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

  describe '#grep_pattern' do
    let(:git) { TrackerGit::Git.new false }
    subject { git.grep_pattern(42) }
    it { should == '\[(fix|finish).*#42.*\]' }
  end

  describe '#contains?' do
    let(:story_id) { '123456' }
    let(:log_command) { "git log foo -i -E --grep=\"pattern-#{story_id}\"" }
    let(:git) { TrackerGit::Git.new 'foo' }

    before do
      git.stub(:grep_pattern).and_return("pattern-#{story_id}")
      git.should_receive(:sh).with(log_command).and_yield(result, 'error')
    end

    subject { git.contains? story_id }

    context 'when the grep pattern matches a commit message in the branch' do
      let(:result) { 'found' }
      it { should be_true }
    end

    context 'when the grep pattern does not match any commit message in the branch' do
      let(:result) { '' }
      it { should be_false }
    end
  end
end
