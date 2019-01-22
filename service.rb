LOG_FILE = 'C:\\test.log'

require "rubygems"
require 'sinatra'

class Monitor < Sinatra::Base
  def self.get_stats
    command = `wmic cpu get loadpercentage`
    cpu = command.split("\n")[2].strip
    command = `nvidia-smi dmon -c 1`
    row = command.split("\n")[2].split()
    gpu = row[3]
    enc = row[5]
    dec = row[6]
    [cpu, gpu, enc, dec]
  rescue
    [0, 0, 0]
  end
  
  set :bind, '0.0.0.0'
  set :port, 8089
  
  get '/stats' do
    Monitor.get_stats.join(', ')
  end
end

begin
  require 'win32/daemon'

  include Win32

  class MonitorDaemon < Daemon

    def service_main
      Monitor.run!
      while running?
      sleep 10
      File.open("c:\\test.log", "a"){ |f| f.puts "Service is running #{Time.now}" } 
    end
  end 

    def service_stop
      File.open("c:\\test.log", "a"){ |f| f.puts "***Service stopped #{Time.now}" }
      exit! 
    end
  end

  MonitorDaemon.mainloop
rescue Exception => err
  File.open(LOG_FILE,'a+'){ |f| f.puts " ***Daemon failure #{Time.now} err=#{err} " }
  raise
end 
