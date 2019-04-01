#!/usr/bin/expect -f

set IP [lindex $argv 0]   
set PORT [lindex $argv 1]
set PASSWORD [lindex $argv 2]
set NEWPASSWORD [lindex $argv 3]

spawn ssh -p $PORT $IP "echo '$NEWPASSWORD'| passwd --stdin root"

expect {  
"yes/no" { send "yes\r";exp_continue }  
"*password:" { send "$PASSWORD\r";exp_continue }  
}
