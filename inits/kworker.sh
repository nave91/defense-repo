#!/bin/sh
#!/usr/bin/expect
# This is some secure program that uses security.
#Usage: sh kworker.sh -[pass/i] <password / identity file> user@<machine> <file> -port <portnumer def:22> 
#Example: sh kworker.sh -pass my_password user@192.168.1.1 file
#Dependencies: expect


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
 " > "$DIR/"expscp.exp

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
 " > "$DIR/"expfile.exp

echo "************** WAIT TILL YOU SEE \"DONE\" *****************"

SSHTYPE=$1 #this is our password.
PWDORKEY=$2
MACHINE=$3
FILE=$4
PORTTEST=$5
PORT=$6


if [ "$PORTTEST" == "-port" ]; 
then
    echo "Trying on port $PORT.."
else
    echo "Trying on port 22"
    PORT=22
fi

#Act according to type 
if [ "$SSHTYPE" == "-pass" ]; then
    echo "Type is password"
    echo "Copying $FILE from local machine to $MACHINE using port number $PORT..."
    expect $DIR'/'expscp.exp "$MACHINE" "$PWDORKEY" "$PORT" "$FILE"
    echo "File copied"
    echo "Executing $FILE from local machine to $MACHINE using port number $PORT..."
    expect $DIR'/'expfile.exp "$MACHINE" "$PWDORKEY" "$PORT" "$FILE"
    echo ""
    echo "********* Done *********"
elif [ "$SSHTYPE" == "-i" ]; then
    echo "Type is key"
elif [ "SSHTYPE" ]; then
    echo "Specify ssh type with -p or -i"
fi

rm expscp.exp
rm expfile.exp