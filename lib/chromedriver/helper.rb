require 'fileutils'
require 'open-uri'
require 'rbconfig'
require 'rest-client'
require 'xmlsimple'
require 'digest/md5'

module Chromedriver
  class Helper
    DOWNLOAD_URL = 'http://chromedriver.storage.googleapis.com'

    def run *args
      download
      exec binary_path, *args
    end

    def check_latest os=platform
      response = RestClient.get DOWNLOAD_URL, {:accept => :json}
      data = XmlSimple.xml_in response

      name, etag, version = nil, nil, 0.0

      data['Contents'].each do |file|
        n = file['Key'][0].to_s
        next if !n.include? os
        v = n.split('/')[0].to_f
        next if v < version

        name = n
        etag = file['ETag'][0].to_s
        version = v

      end

      raise "Unable to find chromedriver for #{os}" if name.nil?

      return version, etag, "#{DOWNLOAD_URL}/#{name}"

    end

    def download hit_network=false

      version, hash, url = check_latest

      return if File.exists?(binary_path) && Digest::MD5.file(binary_path).hexdigest == hash && ! hit_network

      filename = File.basename url
      Dir.chdir platform_install_dir do
        unless File.exists? filename
          download_binary url, filename
          raise "Could not download #{url}" unless File.exists? filename
          system "unzip -o #{filename}"
        end
      end
      raise "Could not unzip #{filename} to get #{binary_path}" unless File.exists? binary_path
      return binary_path
    end

    def download_binary url, filename
      File.open(filename, 'wb') do |dest|
        open(url, 'rb') do |src|
          dest.write src.read
        end
      end
    end

    def update
      download true
    end

    def binary_path
      File.join platform_install_dir, "chromedriver"
    end

    def platform_install_dir
      dir = File.join install_dir, platform
      FileUtils.mkdir_p dir
      dir
    end

    def install_dir
      dir = File.expand_path 'lib'
      FileUtils.mkdir_p dir
      dir
    end

    def platform
      cfg = RbConfig::CONFIG
      case cfg['host_os']
      when /linux/ then
        cfg['host_cpu'] =~ /x86_64|amd64/ ? "linux64" : "linux32"
      when /darwin/ then "mac"
      else "win"
      end
    end
  end
end
