#!/bin/sh
#!/usr/bin/expect

#################################################################
#### 
#### -@author:  Naveen Kumar Lekkalapudi
#### -@Usage:   bash kworker.sh -[-pass/i] <password / identity file> 
####            user@<machine> <script> --port <portnumer def:22>
#### -@Example: bash kworker.sh --pass my_password user@192.168.1.1 
####            script
#### -@Example: bash kworker.sh -i my_key.pem user@192.168.1.1 script
#### -@Description: Copies script to remote <machine> and executes it
#### -@Dependencies: Expect package    
#### -@contact: nalekkalapudi@mix.wvu.edu
####
##################################################################


DIR=`pwd`

#Build expect file

echo "set machine [lrange \$argv 0 0]
set password [lrange \$argv 1 1]
set port [lrange \$argv 2 2]
set filename [lrange \$argv 3 3]

set timeout -1
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn scp -P \$port \$filename \$machine:/tmp/ 
match_max 100000
# Look for passwod prompt
expect \"*?assword:*\"
# Send password aka \$password
send -- \"\$password\\r\"
# send blank line (\r) to make sure we get back to gui
expect \"*\$*\"
sleep 1
 " > "$DIR/"expscppass.exp

echo "set machine [lrange \$argv 0 0]
set password [lrange \$argv 1 1]
set port [lrange \$argv 2 2]
set filename [lrange \$argv 3 3]

set timeout -1
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn ssh \$machine -p\$port
match_max 100000
# Look for passwod prompt
expect \"*?assword:*\"
# Send password aka \$password
send -- \"\$password\\r\"
# send blank line (\r) to make sure we get back to gui
expect \"*\$*\"
sleep 1
# execute filename
send \"cd /tmp/ \\r \"
sleep 1
expect \"*\$*\"
send -- \"sh \$filename \\r\"
expect \"*\$*\"
sleep 1
 " > "$DIR/"expfilepass.exp

echo "set machine [lrange \$argv 0 0]
set key [lrange \$argv 1 1]
set port [lrange \$argv 2 2]
set filename [lrange \$argv 3 3]

set timeout -1
# now connect to remote UNIX box (ipaddr) with given script to execute
spawn ssh -i \$key \$machine -p\$port
expect \"*\$*\"
sleep 1
# execute filename
send \"cd /tmp/ \\r \"
sleep 1
expect \"*\$*\"
send -- \"sh \$filename \\r\"
expect \"*\$*\"
sleep 1
 " > "$DIR/"expfilekey.exp

echo "************** WAIT TILL YOU SEE \"DONE\" *****************"

SSHTYPE=$1 #Specify ssh type with --pass or -i.
PWDORKEY=$2 #Password or key.
MACHINE=$3
FILE=$4 #Script to be executed.
PORTTEST=$5
PORT=$6


if [ "$PORTTEST" == "--port" ] 
then
    echo ">Trying on port $PORT.."
else
    echo ">Trying on port 22.."
    PORT=22
fi

#Act according to type 
if [ "$SSHTYPE" == "--pass" ]
then
    echo ">Type is password"
    echo ">Copying $FILE from local machine to $MACHINE using port number $PORT..."
    expect $DIR'/'expscppass.exp "$MACHINE" "$PWDORKEY" "$PORT" "$FILE"
    echo ">File copied"
    echo ">Executing $FILE from local machine to $MACHINE using port number $PORT..."
    expect $DIR'/'expfilepass.exp "$MACHINE" "$PWDORKEY" "$PORT" "$FILE"
    echo ""
    echo "**************         \"DONE\"          *****************"

elif [ "$SSHTYPE" == "-i" ]
then
    echo ">Type is key"
    echo ">Copying $FILE from local machine to $MACHINE using port number $PORT..."
    scp -i $PWDORKEY $FILE $MACHINE:/tmp/ 
    echo ">File copied"
    echo ">Executing $FILE from local machine to $MACHINE using port number $PORT..."
    expect $DIR'/'expfilekey.exp "$MACHINE" "$PWDORKEY" "$PORT" "$FILE"
    echo ""
    echo "**************         \"DONE\"          *****************"

elif [ "SSHTYPE" ]
then
    echo ">Specify ssh type with --pass or -i"
    echo "**************         \"DONE\"          *****************"
fi

rm expscppass.exp
rm expfilepass.exp
rm expfilekey.exp
