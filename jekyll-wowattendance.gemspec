Gem::Specification.new do |s|
    s.name        = 'jekyll-wowattendance'
    s.version     = '1.0.6'
    s.date        = '2019-02-19'
    s.summary     = "Guild RT attendance"
    s.description = "Guild RT attendance. Parses WarcraftLogs.com to grab attendance data for guild and teams. That gem can merge twinks to receive more relevant stats. Example: https://forestguild.club/attendance"
    s.authors     = ["Nikita Chernyi"]
    s.email       = 'github@rakshazi.me'
    s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR).grep(%r!^lib/!)
    s.require_paths = %w(lib)
    s.homepage    = 'https://github.com/rakshazi/jekyll-wowattendance'
    s.license     = 'MIT'
    s.metadata = {
        "bug_tracker_uri"   => "https://github.com/rakshazi/jekyll-wowattendance",
        "changelog_uri"     => "https://github.com/rakshazi/jekyll-wowattendance/releases",
        "documentation_uri" => "https://github.com/rakshazi/jekyll-wowattendance/blob/master/README.md",
        "homepage_uri"      => "https://github.com/rakshazi/jekyll-wowattendance",
        "source_code_uri"   => "https://github.com/rakshazi/jekyll-wowattendance",
    }
    s.required_ruby_version = '>=2.0.0'
    s.add_runtime_dependency 'jekyll', '~> 3.8.5', '>=3.0.0'
    s.add_runtime_dependency 'nokogiri', '~> 1.10.1', '>=1.0.0'
end
