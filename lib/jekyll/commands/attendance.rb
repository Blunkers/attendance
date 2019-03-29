require "nokogiri"
require "open-uri"
require "json"

module Jekyll
    module Commands
        class Attendance < Command
            class << self
                def init_with_program(prog)
                    prog.command(:attendance) do |c|
                        c.syntax "attendance [options]"
                        c.description "Guild RT attendance"
                        c.option "guild", "--guild ID", "Warcraft Logs guild id, eg: 374677"
                        c.option "team", "--team ID", "Warcraft Logs team id, eg: 15620 (main), 15829 (static), 0 (all)"
                        c.option "name", "--name NAME", "Report name, eg: main, static, all"
                        c.option "max", "--max INT", "How many reports should be included"
                        c.action do |args, options|
                            # Options
                            options = getConfig(options)

                            # Grab data
                            url = 'https://www.warcraftlogs.com/guild/attendance-table/' + options['guild'] + '/' + options['team'] + '/0?page=1'
                            Jekyll.logger.info 'Grabbing data for guild #' + options['guild'] + ' (team #' + options['team'] + ' - ' + options['name'] + ')'
                            Jekyll.logger.info 'Attendance table url: ' + url
                            data = {}
                            fightLinks = []
                            iReports = 0
                            doc = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s).css("#attendance-table")
                            Jekyll.logger.info 'Found following reports:'
                            doc.css('a').each do |a|
                                link = a.get_attribute('href').gsub('/reports/','https://www.warcraftlogs.com/reports/fights-and-participants/') + '0'
                                Jekyll.logger.info link
                                fightLinks.push(link)
                                if iReports >= options['max'].to_i
                                    break
                                end
                                iReports+=1
                            end
                            fights = getProgress(fightLinks)
                            person = nil
                            doc.search('tr').each do |row|
                                i = 1
                                row.search('td').each do |cell|
                                    if i == 1
                                        options['twinks'].each do |owner, names|
                                            person = cell.text.strip
                                            if names.include? cell.text.strip
                                                person = owner
                                                break
                                            end
                                        end
                                        if (data.key? person) === false
                                            data[person] = {}
                                        end
                                        data[person]['name'] = person
                                        if (data[person].key? 'items') === false
                                            data[person]['items'] = {}
                                        end
                                    elsif i == 2
                                        data[person]["att"] = cell.text.strip.gsub('%','')
                                    else
                                        if data[person]["items"][i] != 1
                                            data[person]["items"][i] = (cell.attr('class') == "present" ? 1 : 0)
                                        end
                                    end
                                    i+=1
                                end
                            end
                            data = calcAttendance(data)
                            File.write(options['data_dir'] + '/attendance_' + options['name'] + '.json', [data, fights].to_json)
                        end
                    end
                end

                def getConfig(options)
                    config = Jekyll.configuration({})
                    options['data_dir'] = File.expand_path(config['data_dir'])
                    ['guild', 'team', 'name', 'max', 'twinks'].each do |key|
                        if (options.key? key) === false
                            if(['guild', 'team', 'max'].include? key) === false #guild and team are integers, so we will call .to_s on them
                                options[key] = config['attendance'][key]
                            else
                                options[key] = config['attendance'][key].to_s
                            end
                        end
                    end
                    options
                end

                def calcAttendance(data)
                    data.each do |person, info|
                        absent = 0
                        present = 0
                        data[person]['items'].each do |index, value|
                            value == 1 ? present+=1 : absent+=1
                        end
                        if absent > 0 or present > 0
                            data[person]['att'] = format('%.1f', present.to_f / ((absent + present).to_f/100).to_f)
                        else
                            data[person]['att'] = 0
                        end
                    end
                    data
                end

                def getProgress(links)
                    i = 3 # Because we use 1 and 2 for name and att% in report, so first fight will have increment = 3
                    fights = {}
                    Jekyll.logger.info 'Processign reports...'
                    links.each do |link|
                        fights[i] = {}
                        Jekyll.logger.info link
                        open(link) do |rawreport|
                            report = JSON.parse(rawreport.read)
                            report['fights'].each do |data|
                                if data['boss'] > 0
                                    if (fights[i].key? data['name']) === false
                                        fight = {}
                                        fight['name'] = data['name']
                                        fight['kill'] = data['kill']
                                        fight['pulls'] = 1
                                    else
                                        fight = fights[i][data['name']]
                                        fight['pulls']+=1
                                        if fight['kill'] === false
                                            fight['kill'] = data['kill']
                                        end
                                    end
                                    fights[i][fight['name']] = fight
                                end
                            end
                        end
                        i+=1
                    end
                    fights
                end
            end
        end
    end
end
