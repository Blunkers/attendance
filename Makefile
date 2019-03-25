build:
	rm -f *.gem
	gem build attendance.gemspec

push:
	gem push *.gem
