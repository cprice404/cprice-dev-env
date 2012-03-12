module Puppet
    Type.type(:oraclejava6).provide(:webscraper) do

        def installdir()
            resource[:installdir]
        end

        def owner()
            Etc.getpwuid(File.stat(version_install_dir).uid).name
        end

        def owner=(val)
            FileUtils.chown_R(val, nil, version_install_dir)
        end

        def group()
            Etc.getgrgid(File.stat(version_install_dir).gid).name
        end

        def group=(val)
            FileUtils.chown_R(nil, val, version_install_dir)
        end

        

        def exists?()
            puts("intellij_idea.exists?")
            return File.exists?(version_install_dir)
        end

        def create()
            puts("intellij_idea.create")
#            Dir.mktmpdir("oracle-java") do |tmpdir|
#                download_file_path = File.join(tmpdir, File.basename(download_url))
#
#                download_file(download_url, download_file_path)
#                File.chmod(0755, download_file_path)
#                require "open4"
#
#                cwd = Dir.getwd
#                begin
#                    Dir.chdir(resource[:installdir])
#                    Timeout.timeout(30) do
#                        Open4::popen4(download_file_path) do |pid, stdin, stdout, stderr|
#                            while line = stdout.readline
#                                Puppet.debug(line)
#                                if (line =~ /^Press Enter to continue/)
#                                    stdin.puts
#                                end
#                                break if stdout.eof?
#                            end
#                        end
#                    end
#                ensure
#                    Dir.chdir(cwd)
#                end
#
#            end
#
#            FileUtils.chown_R(resource[:owner], resource[:group], version_install_dir)
#            symlink = File.join(installdir, "latest")
#            FileUtils.ln_s(version_install_dir, symlink, :force => true)
#            FileUtils.chown(resource[:owner], resource[:owner], symlink)
        end
#
#        def destroy()
#            raise NotImplementedError.new
#        end
#
#
#
#
#
#        def version_install_dir()
#            unless @version_install_dir
#                @version_install_dir = File.join(resource[:installdir], version_dir_name)
#            end
#            @version_install_dir
#        end
#        private :version_install_dir
#
#
#        def version_dir_name()
#            unless @version_dir_name
#                match = install_file_name.match(/^jdk-6u(\d+)-linux-x64\.bin$/)
#                raise ArgumentError.new unless match
#                @version_dir_name = "jdk1.6.0_#{match[1]}"
#            end
#            @version_dir_name
#        end
#        private :version_dir_name
#
#        def install_file_name()
#            File.basename(download_url)
#        end
#        private :install_file_name
#
#        def download_url()
#            unless @download_url
#                host = "http://www.oracle.com"
#                next_url = find_in_page(
#                    "#{host}/technetwork/java/javase/downloads/index.html",
#                    %r|^.*<a href="(.*downloads/jdk-6[a-zA-Z\d]+-download.*html)">|
#                )
#                raise "Unable to find Java 6 download URL" if next_url.nil?
#
#                @download_url = find_in_page("#{host}#{next_url}",
#                                            %r|"filepath":"(http://download.oracle.com/.*jdk-6[a-zA-Z\d]+-linux-x64.bin)"|)
#
#            end
#            @download_url
#        end
#        private :download_url
#
#
#        def find_in_page(url, pattern)
#            open(url) do |page|
#                result = nil
#                page.each_line do |line|
#                    match = line.match pattern
#                    if match
#                        result = match[1]
#                        break
#                    end
#                end
#                result
#            end
#        end
#        private :find_in_page
#
#
#        def download_file(url, local_path)
#            open(local_path, "wb") do |local|
#                Net::HTTP.get_response(URI.parse(url)) do |resp|
#                    resp.read_body do |chunk|
#                        local.write(chunk)
#                    end
#                end
#            end
#        end
#        private :download_file

    end
end
