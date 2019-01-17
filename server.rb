require 'sinatra'

class Monitor
  def self.get_stats
    command = `wmic cpu get loadpercentage`
    cpu = command.split("\n")[2].strip
    command = `nvidia-smi --query-gpu=utilization.gpu,utilization.memory, memory.total,memory.free,memory.used --format=csv`
    row = command.split("\n")[1]
    gpu, mem = row.gsub(' %', '').split(', ')
    [cpu, gpu.strip, mem.strip]
  end
end

set :bind, '0.0.0.0'
set :port, 8088

get '/stats' do
  Monitor.get_stats.join(', ')
end