# The etymology of this class name is that I needed a base class
# that describes managers of ruby environments.  Given that RVM
# and rbenv were already taken, I went with a self-deprecating
# variation on manager.

class Clerk

  # find a clerk
  def self.select
    if RVM.available?
      RVM.new
    elsif RBenv.available?
      RBenv.new
    end
  end

  # look in all of the normal places where a dashboard might be found
  def find_dashboard
    roots = %W(
      /var/www
      /Library/WebServer/Documents
      #{ENV['HOME']}/public_html
      #{ENV['HOME']}/Sites
    )

    roots.each do |root|
       return "#{root}/dashboard.yml" if File.exist? "#{root}/dashboard.yml"
    end
  end

  # sort a list of versions numerically
  def sort(versions)
    versions.sort(&:RELEASE_COMPARE)
  end

protected

  # compare source releases by patch number
  RELEASE_COMPARE = Proc.new do |a,b|
    pattern = /(.*?)(\d+)$/
    if a =~ pattern and a[pattern,1] == b[pattern,1]
      a[pattern,2].to_i <=> b[pattern,2].to_i
    else
      a <=> b
    end
  end

  # parse svn revision and git commit hash from log
  def gitlog(path='.')
    Dir.chdir path do
      log = `git log -n 1`

      def log.svnid
        self[/git-svn-id: .*@(\d*)/,1]
      end

      def log.commit
        self [/commit ([a-f0-9]+)/,1]
      end

      log
    end
  end
end
