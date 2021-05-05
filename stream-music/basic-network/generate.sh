#!/bin/sh

CHANNEL_NAME=channelsales1

rm -fr config/*
rm -fr crypto-config/*

./bin/cryptogen generate --config=./crypto-config.yaml
./bin/configtxgen -profile OrdererGenesis -outputBlock ./config/genesis.block  

./bin/configtxgen -profile Channel1 -outputCreateChannelTx ./config/channel1.tx  -channelID ${CHANNEL_NAME}

./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate ./config/Sales1Organchors.tx -channelID ${CHANNEL_NAME} -asOrg Sales1Org 

./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate ./config/Sales2Organchors.tx -channelID ${CHANNEL_NAME} -asOrg Sales2Org 