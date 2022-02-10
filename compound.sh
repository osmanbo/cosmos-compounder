nano compound.sh
------------------------------------------


#!/bin/bash
cd /root


# (BUILD_NAME="cohod")
BUILD_NAME=""

# (CHAIN_ID="darkmatter-1")
CHAIN_ID=""

# (VALIDATOR_ADDRESS="cohovaloper......")
VALIDATOR_ADDRESS=""

# (ACCOUNT_ADDRESS="coho1.......")
ACCOUNT_ADDRESS=""

# (FEE_AMOUNT="0")
FEE_AMOUNT=""

# (CURRENCY_UNIT="ucoho")
CURRENCY_UNIT=""

KEY_NAME=""
KEY_PASSWORD=""


while true
do
    current_date=$(date)

    echo "start" $current_date >> compound.log

    echo -e $current_date
    echo "$KEY_PASSWORD" | $BUILD_NAME tx distribution withdraw-rewards $VALIDATOR_ADDRESS --commission --from $KEY_NAME --gas auto --fees=${FEE_AMOUNT}${CURRENCY_UNIT} --chain-id $CHAIN_ID -y

    sleep 60s

    echo "sleep 60s"

    available_coin=$($BUILD_NAME query bank balances $ACCOUNT_ADDRESS --chain-id $CHAIN_ID | awk '/amount:/ {print}' | tr -cd [:digit:])
    compounding_coin="$(($available_coin - 100000))"

    if [[ $compounding_coin -gt 1000000 ]]
    then
        echo "$KEY_PASSWORD" | $BUILD_NAME tx staking delegate $VALIDATOR_ADDRESS ${compounding_coin}${CURRENCY_UNIT} --chain-id $CHAIN_ID --gas auto --fees=${FEE_AMOUNT}${CURRENCY_UNIT} --from $KEY_NAME --yes
    echo " " $compounding_coin " $CURRENCY_UNIT delegated" >> compound.log
    else
        echo " " $compounding_coin "lower than 1000000" >> compound.log
    fi

    echo "end" $current_date >> compound.log

    sleep 60s
done



------------------------------------------
sudo chmod +x compound.sh
nohup ./compound.sh &
sudo tail -f nohup.out
