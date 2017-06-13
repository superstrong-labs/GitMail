require 'tmpdir'

class Finder  
  def initialize(repo_name)
    Dir.mktmpdir('GitMail') do |dir|
      repo_name = repo_name.chomp
      `git clone --bare #{ARGV[1] || "https://github.com/"}#{repo_name}.git #{dir}`
      Dir.chdir("#{dir}") do
        @emails = `git log --pretty=format:'%an, %ae, #{repo_name}'`
      end
    end
  end

  def all_contributors
    @emails.split("\n").uniq.sort
  end
end

if $PROGRAM_NAME == __FILE__
  File.open("repo.txt", "r").each do |repo_name|
    File.open(ENV['HOME']+'/projects/GitMail/contributors.csv', 'a') { |g|
      g.puts Finder.new(repo_name).all_contributors
    }
  end
end