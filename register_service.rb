require "rubygems"
require "win32/service"

include Win32

options = {:service_name=>'signalwire_monitoring',
  :service_type => Service::WIN32_OWN_PROCESS,
  :description        => 'A simple monitoring service',
  :start_type         => Service::AUTO_START,
  :error_control      => Service::ERROR_NORMAL,
  :binary_path_name   => 'C:\Ruby26-x64\bin\ruby.exe -C c:\monitor service.rb',
  :load_order_group   => 'Network',
  :dependencies       => ['W32Time','Schedule'],
  :display_name       => 'signalwire_monitoring'}

p options

Service.create(options)
