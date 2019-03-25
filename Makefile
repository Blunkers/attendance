build:
	rm -f ./*.gem
	gem build jekyll-wowattendance.gemspec

push:
	gem push ./*.gem
