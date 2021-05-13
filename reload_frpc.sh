#!/bin/bash

# download frp
echo "### reload frp"
killall frpc
screen -dmS frpc /opt/frp/frpc -c /opt/frp/frpc.ini
