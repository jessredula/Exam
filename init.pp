class PUPPET_CLASS{

$program = ["vim","curl","git"]

user 	{ 'monitor':
		ensure     => 'present',
		managehome => true,
		shell      => '/bin/bash',
		}->
		
file 	{ '/home/monitor/scripts':
		ensure => 'directory',
		group=>monitor,
	        owner=>monitor,
		}->

exec	{'wget':
		command => '/usr/bin/wget "https://raw.githubusercontent.com/jessredula/Exam/master/memory_check.sh" -O  /home/monitor/scripts/memory_check',
		timeout => 0,
		creates => '/home/monitor/script/memory_check',
		}->

file 	{ '/home/monitor/src':
		ensure => 'directory',
		group=>monitor,
	        owner=>monitor,
		}->
		
file 	{ '/home/monitor/src/my_memory_check':
		ensure => 'link',
		target => ' /home/monitor/scripts/memory_check',
		}->
		
file 	{ '/var/spool/cron/crontabs/monitor':
		force=>true,
		mode=>644,
		group=>crontab,
		owner=>monitor,
        recurse  => true,
		content => '*/10 * * * * /home/monitor/src/my_memory_check',
		}->
exec	{ 'hostname':
		command => '/bin/hostname bpx.local.server',
		timeout => 0,
		}
}

