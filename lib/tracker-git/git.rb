module Tracker
  class Git
    def contains?(story_id, options = {})
      branch = options.fetch(:branch, "master")
      range  = options.fetch(:range, "");
      command = "git log #{branch} #{range}".strip
      result = `#{command}`
      result =~ /\[(.*)##{story_id}(.*)\]/ ? true : false
    end
  end
end
