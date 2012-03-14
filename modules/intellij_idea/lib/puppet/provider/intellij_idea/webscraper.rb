module Puppet
    Type.type(:intellij_idea).provide(:webscraper) do

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
            return File.exists?(version_install_dir)
        end

        def create()
            Dir.mktmpdir("intellij-idea") do |tmpdir|
                download_file_path = File.join(tmpdir, File.basename(download_url))

                Puppet.debug("Downloading '#{download_url}' to '#{download_file_path}'")

                FileUtils.copy("/tmp/#{File.basename(download_url)}", download_file_path) 
                #download_file(download_url, download_file_path)


                File.chmod(0755, download_file_path)
                require "open4"

                cwd = Dir.getwd
                begin
                    Dir.chdir(resource[:installdir])
                    Timeout.timeout(30) do
                        Open4::popen4("tar zxvf #{download_file_path}") do |pid, stdin, stdout, stderr|
                            while line = stdout.readline
                                Puppet.debug(line)
                                break if stdout.eof?
                            end
                        end
                    end
                ensure
                    Dir.chdir(cwd)
                end

            end

            extracted_dir = Dir.glob("#{resource[:installdir]}/idea-IU-*")[0]

            FileUtils.chown_R(resource[:owner], resource[:group], extracted_dir)

            symlink = File.join(installdir, "latest")
            FileUtils.ln_s(extracted_dir, symlink, :force => true)
            FileUtils.chown(resource[:owner], resource[:owner], symlink)
        end

        def destroy()
            raise NotImplementedError.new
        end





        def version_install_dir()
            idea_dirs = Dir.glob("#{resource[:installdir]}/idea-IU-*")
            return idea_dirs[0] if idea_dirs.length > 0
            return File.join(resource[:installdir], "latest")
        end
        private :version_install_dir


        def version_dir_name()
            unless @version_dir_name
                match = install_file_name.match(/^ideaIU-(.*)\.tar\.gz$/)
                raise ArgumentError.new unless match
                raise NotImplementedError
                @version_dir_name = "jdk1.6.0_#{match[1]}"
            end
            @version_dir_name
        end
        private :version_dir_name

        def install_file_name()
            File.basename(download_url)
        end
        private :install_file_name

        def download_url()
            unless @download_url
                @download_url = find_in_page(
                    "http://www.jetbrains.com/idea/download/download_thanks.jsp?os=linux&edition=IU",
                    %r|^.*<a href="(http://download\.jetbrains\.com.*/ideaIU.*\.tar\.gz)">|
                )
                Puppet.debug("IDEA Download url: '#{@download_url}'")
                raise "Unable to find IDEA download URL" if @download_url.nil?
            end
            @download_url
        end
        private :download_url


        def find_in_page(url, pattern)
            open(url) do |page|
                result = nil
                page.each_line do |line|
                    match = line.match pattern
                    if match
                        result = match[1]
                        break
                    end
                end
                result
            end
        end
        private :find_in_page


        def download_file(url, local_path)
            open(local_path, "wb") do |local|
                Net::HTTP.get_response(URI.parse(url)) do |resp|
                    case resp
                    when Net::HTTPRedirection then
                        location = resp['location']
                        warn "redirected to #{location}"
                        download_file(location, local_path)
                    when Net::HTTPSuccess then
                        resp.read_body do |chunk|
                            local.write(chunk)
                        end
                    end
                end
            end
        end
        private :download_file

    end
end
