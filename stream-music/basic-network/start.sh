#!/bin/bash
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose.yaml up -d orderer.smartcar.com peer0.sales1.smartcar.com peer1.sales1.smartcar.com peer0.sales2.smartcar.com peer1.sales2.smartcar.com cli

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec cli peer channel create -o orderer.smartcar.com:7050 -c channelsales1 -f /etc/hyperledger/configtx/channel1.tx

# Join peer0.sales1.smartcar.com to the channel and Update the Anchor Peers in Channel1
docker exec cli peer channel join -b channelsales1.block
docker exec cli peer channel update -o orderer.smartcar.com:7050 -c channelsales1 -f /etc/hyperledger/configtx/Sales1Organchors.tx

# Join peer1.sales1.smartcar.com to the channel
docker exec -e "CORE_PEER_ADDRESS=peer1.sales1.smartcar.com:7051" cli peer channel join -b channelsales1.block

# Join peer0.sales2.smartcar.com to the channel and update the Anchor Peers in Channel1
docker exec -e "CORE_PEER_LOCALMSPID=Sales2Org" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales2.smartcar.com/users/Admin@sales2.smartcar.com/msp" -e "CORE_PEER_ADDRESS=peer0.sales2.smartcar.com:7051" cli peer channel join -b channelsales1.block
docker exec -e "CORE_PEER_LOCALMSPID=Sales2Org" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales2.smartcar.com/users/Admin@sales2.smartcar.com/msp" -e "CORE_PEER_ADDRESS=peer0.sales2.smartcar.com:7051" cli peer channel update -o orderer.smartcar.com:7050 -c channelsales1 -f /etc/hyperledger/configtx/Sales2Organchors.tx

# Join peer0.sales2.smartcar.com to the channel
docker exec -e "CORE_PEER_LOCALMSPID=Sales2Org" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales2.smartcar.com/users/Admin@sales2.smartcar.com/msp" -e "CORE_PEER_ADDRESS=peer1.sales2.smartcar.com:7051" cli peer channel join -b channelsales1.block