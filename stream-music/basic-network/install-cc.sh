#!/bin/bash
set -ev

# install chaincode for channelsales1
docker exec cli peer chaincode install -n smartcar-cc -v 1.0 -p chaincode/go
sleep 1
# instantiate chaincode for channelsales1
docker exec cli peer chaincode instantiate -o orderer.smartcar.com:7050 -C channelsales1 -n smartcar-cc -v 1.0 -c '{"Args":[""]}' -P "OR ('Sales1Org.member','Sales2Org.member')"
sleep 10
# # invoke chaincode for channelsales1
docker exec cli peer chaincode invoke -o orderer.smartcar.com:7050 -C channelsales1 -n smartcar-cc -c '{"function":"initWallet","Args":[""]}'
docker exec cli peer chaincode invoke -o orderer.smartcar.com:7050 -C channelsales1 -n smartcar-cc -c '{"function":"setCar","Args":["Fabric", "Hyper", "20", "1Q2W3E4R"]}'
sleep 3
# # query chaincode for channelsales1
docker exec cli peer chaincode query -o orderer.smartcar.com:7050 -C channelsales1 -n smartcar-cc -c '{"function":"getAllCar","Args":[""]}'