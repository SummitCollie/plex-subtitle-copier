# frozen-string-literal: true

require 'io/console'
require 'fileutils'
require 'cli/ui'

CLI::UI::StdoutRouter.enable
puts CLI::UI.fmt '{{green:Plex Subtitle Copier v1.0.0 by SummitCollie - https://github.com/SummitCollie}}'
puts

def press_any_key_to_exit
  puts
  puts 'Press any key to exit...'
  STDIN.getch
  exit
end

begin
  video_folder = ARGV[0]
  unless video_folder
    puts CLI::UI.fmt '{{yellow:Please supply the path to the folder containing your video files.}}'
    puts CLI::UI.fmt '{{yellow:The folder is expected to have a sub-folder called "Subs" or "Subtitles".}}'
    example_path = Gem.win_platform? ? 'C:\Users\username\Videos\Deadwood\Season\ 1' : '~/Videos/Deadwood/Season\ 1'
    puts CLI::UI.fmt "{{yellow:example: #{example_path}}}"
    video_folder = CLI::UI.ask('Video folder:')
  end
  FileUtils.cd(video_folder)
  video_folder = Dir.pwd # Store absolute path so it's easy to return to later
rescue Errno::ENOENT
  puts CLI::UI.fmt "{{red:Folder not found: #{video_folder}}}"
  press_any_key_to_exit
end

if Dir.exist?('Subtitles')
  subtitles_folder = 'Subtitles'
elsif Dir.exist?('Subs')
  subtitles_folder = 'Subs'
else
  puts CLI::UI.fmt "{{red:Couldn't find a 'Subs' or 'Subtitles' folder in that directory.}}"
  press_any_key_to_exit
end

language_code = CLI::UI.ask('What language code should be added to subtitle filenames?', default: 'en')
puts

FileUtils.cd(subtitles_folder)
subtitles_subfolders = Dir.glob('*')

# Hash key = sorted array of filenames seen within a subtitles_subfolder
# Hash value = user preference for preferred filename from list in hash key
#   example: {
#     ['2_English.srt', '3_English.srt']: '2_English.srt',
#     ['3_English.srt', '4_English.srt']: '3_English.srt'
#   }
subtitle_filename_patterns = {}

subtitles_subfolders.each_with_index do |subfolder, i|
  FileUtils.cd(i == 0 ? subfolder : "../#{subfolder}")
  filename_list = Dir.glob('*').select { |f| File.file? f }.sort

  unless subtitle_filename_patterns[filename_list]
    subtitle_filename_patterns[filename_list] = CLI::UI.ask(
      'From these subtitle files, which do you want?',
      options: filename_list
    )
  end

  subtitle_filename = subtitle_filename_patterns[filename_list]

  FileUtils.cp(
    subtitle_filename,
    "#{video_folder}/#{subfolder}.#{language_code}#{File.extname(subtitle_filename)}"
  )
end

puts CLI::UI.fmt "{{green:All done!}}"
press_any_key_to_exit
