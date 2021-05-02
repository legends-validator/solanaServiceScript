#!/bin/bash

#Set variables for key path and public keys
IDENTITY=/home/sol/validator-keypair.json
VOTE=/home/sol/vote-account-keypair.json
MAINID="PUT YOUR MAIN IDENTITY PUBLIC KEY HERE"
MAINVOTE="PUT YOUR MAIN VOTE ACCOUNT PUBLIC KEY HERE"
BACKUPID="PUT YOUR BACKUP IDENTITY PUBLIC KEY HERE" 
BACKUPVOTE="PUT YOUR BACKUP VOTE ACCOUNT PUBLIC KEY HERE" 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
#Retrieve identity public key from file
if test -f "$IDENTITY"
then
IPUBKEY=$(solana-keygen pubkey $IDENTITY)
echo -e "${GREEN}Identity   -   $IPUBKEY"
else
echo -e "${RED}Identity key not found. Copy identity key to /home/sol directory"
echo -e "${RED}Failed to start validator"
exit
fi

#Retrieve vote account public key from file
if test -f "$VOTE"
then
VPUBKEY=$(solana-keygen pubkey $VOTE)
echo -e "${GREEN}Vote Account - $VPUBKEY"
else
echo -e "${RED}Vote account key not found. Copy vote account key to /home/sol directory"
echo -e "${RED}Failed to start validator"
exit
fi

#Evaluate public key results against secondary node keys. If match start validator non-voting.
if [[ "$IPUBKEY" == "$BACKUPID" && "$VPUBKEY" == "$BACKUPVOTE" ]]
then
echo -e "${GREEN}Non-voting keys present"
echo -e "${GREEN}Starting validator in ${YELLOW}non-voting mode!"
exec solana-validator \
	--no-voting \
	--identity ~/validator-keypair.json \
	--vote-account ~/vote-account-keypair.json \
	--trusted-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
	--trusted-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
	--trusted-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
	--trusted-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
	--no-untrusted-rpc \
	--ledger /mnt/ledger \
	--rpc-port 8899 \
	--private-rpc \
	--dynamic-port-range 8000-8010 \
	--entrypoint entrypoint.mainnet-beta.solana.com:8001 \
	--entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
	--entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
	--entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
	--entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
	--expected-genesis-hash 5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d \
	--wal-recovery-mode skip_any_corrupted_record \
	--limit-ledger-size \
	--accounts /mnt/solana-accounts \
	--snapshot-compression none \
 	--log ~/solana-validator.log
exit
fi

#Evaluate public key results against primary node keys. If match start validator voting.
if [[ "$IPUBKEY" == "$MAINID" && "$VPUBKEY" == "$MAINVOTE" ]]
then
echo -e "${GREEN}Voting keys present"
echo -e "${GREEN}Starting validator - ${YELLOW}using voting keys! Make sure secondary validator is not voting"
exec solana-validator \
    --identity ~/validator-keypair.json \
    --vote-account ~/vote-account-keypair.json \
    --trusted-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
    --trusted-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
    --trusted-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
    --trusted-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
    --no-untrusted-rpc \
    --ledger /mnt/ledger \
    --rpc-port 8899 \
    --private-rpc \
    --dynamic-port-range 8000-8010 \
    --entrypoint entrypoint.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
    --expected-genesis-hash 5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d \
    --wal-recovery-mode skip_any_corrupted_record \
    --limit-ledger-size \
    --accounts /mnt/solana-accounts \
    --snapshot-compression none
exit
fi
