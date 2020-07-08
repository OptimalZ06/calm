#!/bin/bash
# create ~/foundation/config/foundation_settings.json
# adjust heartbeat and intent_poll
# ensure node is not in a cluster
# genesis stop foundation
# genesis restart
echo "Updating foundation_settings.json..."
echo -n "{
  "version" : 2,
  "ipv6_interface": 2,
  "http_port" : 8000,
  "fc_settings": {
    "foundation_central_port" : 9440,
    "heartbeat_interval_mins": 1,
    "intent_poll_interval_mins": 1,
    "ipv6_interface": "eth0",
    "vendor_class": "NutanixFC",
    "register_interval_mins": 1
  }
}" > ~/foundation/config/foundation_settings.json

echo "Creating foundation_central.json..."

cat > /etc/nutanix/foundation_central.json <<EOF
{
   "fc_ip": "$1",
   "api_key": "$2"
}
EOF

chmod 644 /etc/nutanix/foundation_central.json

genesis stop foundation
genesis restart
