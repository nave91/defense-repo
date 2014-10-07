# !/bin/python
import socket
from subprocess import call
USER = 'loud'
netrange = '110-111'
netrange = netrange.split('-')
netlow = int(netrange[0])
nethigh = int(netrange[1])
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("gmail.com",80))
my_ip = s.getsockname()[0]
s.close()

my_ip =  my_ip.split('.')
my_ips = []
for i in range(netlow,nethigh):
    my_ips.append(my_ip[:3]+[i])

for ip in my_ips:
    ip = ".".join([str(i) for i in ip])
    useratip = USER+'@'+str(ip)
    call(['bash','shipper.sh','--pass','loud',useratip,'ejectcd.sh'])
