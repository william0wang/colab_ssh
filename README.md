# Google Colab ssh starter
initialize Google Colab for ssh connection via frp

Code in iPython:
``` python
! curl "myip.ipip.net"

# frp config file
print("### writing frp config file")
ini = '''
[common]
server_addr = < frp server >
server_port = < frp port >
privilege_token = < frp server token >

[google_colab_ssh_23333]
type = tcp
local_ip = 127.0.0.1
local_port = 23333
remote_port = < port you like >
'''
with open("frpc.ini", "w") as f:
    f.write(ini)

# ssh keys
print("### writing ssh keys")
keys = '''
< ssh public keys >
'''
with open("authorized_keys", "w") as f:
    f.write(keys)

# download init script
print("### get init script and run")
! wget -q --show-progress -c https://raw.githubusercontent.com/william0wang/colab_ssh/master/colab_init.sh
! bash colab_init.sh
```
