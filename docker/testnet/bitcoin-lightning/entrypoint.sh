#!/usr/bin/env bash

# This path is expected to be volume to make lnd data persistent.
DATA_DIR=/root/.lnd

# This path is expected to have default data used to init environment
# at first deploy such as config.
DEFAULTS_DIR=/root/default

CONFIG=$DATA_DIR/lnd.conf

# If data directory doesn't exists this means that volume is not mounted
# or mounted incorrectly, so we must fail.
if [ ! -d $DATA_DIR ]; then
    echo "Data directory '$DATA_DIR' doesn't exists. Check your volume configuration."
    exit 1
fi

# We always restoring default config shipped with docker.
echo "Restoring default config"
cp $DEFAULTS_DIR/lnd.conf $CONFIG

# If external IP defined we need to set corresponding run option
if [ ! -z "$EXTERNAL_IP" ]; then
    echo "Setting external IP"
    EXTERNAL_IP_OPT="--externalip=$EXTERNAL_IP"
fi

RPC_USER_OPT="--bitcoind.rpcuser="

# We are using `exec` to enable gracefull shutdown of running daemon.
# Check http://veithen.github.io/2014/11/16/sigterm-propagation.html.
exec lnd $EXTERNAL_IP_OPT \
--bitcoind.rpcuser=$BITCOIN_RPC_USER \
--bitcoind.rpcpass=$BITCOIN_RPC_PASSWORD