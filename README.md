# WarcraftLogs attendance parser for Jekyll

[![Gem Version](https://badge.fury.io/rb/jekyll-wowattendance.svg)](https://badge.fury.io/rb/jekyll-wowattendance)

[Live Example](https://forestguild.club/attendance) - plugin built specially for this website

Example HTML table (grabbed from live example) you can find in file `jekyll.exampletable.html`

## Configuration

Add following block to your jekyll config (`_config.yml`)

```yml
attendance:
  guild: 374677 # Guild id from WarcraftLogs.com
  team: 15620 # Team id from WarcraftLogs.com (if you dont use teams, set 0)
  name: main # Team name for output file
  max: 50 #Maximum included reports
  twinks: # List of twinks to merge, format: "Result name": ['Twink name 1', 'Twink name 2']
    Rakshazi: ['Etke', 'Kaazgul', 'Aresanna']
```

## Usage

```bash
# If you set all configs in site config file:
jekyll attendance # check _data/attendance_teamname.json

# If you want to set custom config
jekyll attendance --help
```
