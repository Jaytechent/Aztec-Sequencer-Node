#!/bin/bash

START_COMMAND="aztec start --network alpha-testnet --l1-rpc-urls <your urlhere> --l1-consensus-host-urls <your url here> --sequencer.validatorPrivateKey <your private key here> --sequencer.governanceProposerPayload 0x54F7fe24E349993b363A5Fa1bccdAe2589D5E5Ef --p2p.p2pIp <your ip here> --archiver --node --sequencer --p2p.maxTxPoolSize 1000000000"

echo "Welcome to AZTEC MONITOR"
echo "We are monitoring your node running at port 8080..."
echo

while true; do
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  
  STATUS=$(curl -s --max-time 5 http://localhost:8080/status)
  
  if [[ "$STATUS" == "OK" ]]; then
    echo "[$TIMESTAMP] Node is UP ✅"
  else
    echo "[$TIMESTAMP] Node is DOWN ❌, updating node with aztec-up latest..."

    aztec-up latest
    UPDATE_EXIT_CODE=$?

    if [[ $UPDATE_EXIT_CODE -eq 0 ]]; then
      echo "[$TIMESTAMP] Update successful! Starting node now..."
      $START_COMMAND &
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] Node start command issued."
    else
      echo "[$TIMESTAMP] Update failed! Will retry on next check."
    fi
  fi

  sleep 7200
done
