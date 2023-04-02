#!/bin/bash

while true; do
    echo " "
    echo "Which Offline Repository Are You Installing?"
    echo " "
    echo "1. DMSS"
    echo "2. Users VLAN"
    echo -n "Please Make A Selection: "
    read user_input

    # Execute a script based on the user input
    if [ "$user_input" == "1" ]; then
        #./DMSS-Offline-Repo.sh
        echo "Executing DMSS"
        break  # Exit the loop when a valid input is entered
    elif [ "$user_input" == "2" ]; then
        #./Users-Vlan-Offline-Repo.sh
        echo "Executing Users"
        break  # Exit the loop when a valid input is entered
    else
        echo "Invalid input. Please enter either 1 or 2."
    fi
done
