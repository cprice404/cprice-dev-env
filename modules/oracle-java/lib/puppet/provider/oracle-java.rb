#!/usr/bin/env ruby

require 'open-uri'
require 'net/http'


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

def download_file(url, local_path)
    open(local_path, "wb") do |local|
        Net::HTTP.get_response(URI.parse(url)) do |resp|
            resp.read_body do |chunk|
                local.write(chunk)
            end
        end
    end
end

host = "http://www.oracle.com"
next_url = find_in_page(
    "#{host}/technetwork/java/javase/downloads/index.html",
    %r|^.*<a href="(.*downloads/jdk-6[a-zA-Z\d]+-download.*html)">|)
raise "Unable to find Java 6 download URL" if next_url.nil?

puts("Next url: '#{next_url.inspect}'")

download_url = find_in_page("#{host}#{next_url}",
    %r|"filepath":"(http://download.oracle.com/.*jdk-6[a-zA-Z\d]+-linux-x64.bin)"|)

puts("Download url: '#{download_url.inspect}'")
puts("Filename: '#{File.basename(download_url)}'")

download_file_path = "./#{File.basename(download_url)}"

#download_file(download_url, download_file_path)

