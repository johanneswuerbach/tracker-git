module TrackerGit
  VERSION = '0.1.0'

  DESCRIPTION =
    "Tracker integration: Update Tracker based on current Git repo.\n" +
      "\nPass your Pivotal Tracker project id and API token on the command line, e.g:\n" +
      "  tracker 123456 abc123\n" +
      "\nor as an environment variable:\n" +
      "  export TRACKER_PROJECT_ID=123456\n" +
      "  export TRACKER_TOKEN=abc123\n" +
      "  tracker"

  GEM_DESCRIPTION = %q{Tracker integration: Update Tracker based on current Git repo.}
  GEM_SUMMARY = %q{Tracker integration.}
end
