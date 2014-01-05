actions :supervise, :start, :stop, :restart

attribute :name, :kind_of => String, :name_attribute => true
attribute :command, :kind_of => String, :required => true

attribute :autostart, :kind_of => [FalseClass, TrueClass], :default => false
attribute :startsecs, :kind_of => Integer, :default => nil
attribute :user, :kind_of => String, :default => nil
attribute :directory, :kind_of => String, :default => nil

attribute :stdout_logfile, :kind_of => String, :default => nil
attribute :stdout_logfile_maxbytes, :kind_of => String, :default => nil
attribute :stderr_logfile, :kind_of => String, :default => nil
attribute :stderr_logfile_maxbytes, :kind_of => String, :default => nil

attribute :stopsignal, :equal_to => ["TERM", "HUP", "INT", "QUIT", "KILL", "USR1", "USR2"], :default => nil

# private
attribute :service
