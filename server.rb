require 'sinatra'

class Monitor
  def self.get_stats
    command = `wmic cpu get loadpercentage`
    cpu = command.split("\n")[2].strip
    command = `nvidia-smi pmon -c 1`
    row = command.split("\n")[2].split()
    gpu = row[3]
    enc = row[5]
    [cpu, gpu, enc]
  rescue
    [0, 0, 0]
  end
end

set :bind, '0.0.0.0'
set :port, 8088

get '/stats' do
  Monitor.get_stats.join(', ')
end
