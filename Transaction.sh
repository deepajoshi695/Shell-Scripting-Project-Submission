#!/bin/bash

# Global variable to store balance
BALANCE=0
# shellcheck disable=SC2034
DEFAULT_PIN="12345"

# shellcheck disable=SC2162
# 1. Function for Account Creation (Step-1)
Customer_Details() {
    while true; do
        echo "Account Creation Process Started..."
        
        # 1. FullName Input
        read -p "Enter the FullName in Bold Letters:" cust_name
        cust_name=${cust_name^^} # String Manipulation: Convert to Bold/Uppercase
        
        # 2. ID Type Selection (Matches image failure for "P" or "Lice")
        read -p "Enter the ID Proof Type [Ex: Aadhar, Pan, License, etc..]:" id_type
        
        if [[ "$id_type" != "Aadhar" && "$id_type" != "Pan" && "$id_type" != "License" ]]; then
            echo "Invalid ID Proof Type."
            echo "Account Creation Process Failed. Restarting Again...."
            echo "------------------------------------------------"
            continue # Restarts entire process
        fi

        # 3. ID Detail Input (Matches "Only Letters & Numbers" error)
        read -p "Enter $id_type Details [Note: Without Special Characters and Spaces]:" id_value
        
        # Pattern Matching: Only Alphanumeric allowed
        if [[ ! "$id_value" =~ ^[a-zA-Z0-9]+$ ]]; then
            echo "Only Letters & Numbers are Allowed"
            echo "Account Creation Process Failed. Restarting Again..."
            echo "------------------------------------------------"
            continue
        fi

        # Specific Validation rules
        # Aadhar: Exactly 12 digits, no letters
        if [[ "$id_type" == "Aadhar" && ! "$id_value" =~ ^[0-9]{12}$ ]]; then
            echo "Error: Aadhar must be exactly 12 digits (Numbers only)."
            echo "Account Creation Process Failed. Restarting Again..."
            continue

        # PAN: 10 chars, MUST be mixed (not only numbers, not only letters)
        elif [[ "$id_type" == "Pan" ]]; then
            if [[ ! "$id_value" =~ ^[a-zA-Z0-9]{10}$ ]] || [[ "$id_value" =~ ^[0-9]+$ ]] || [[ "$id_value" =~ ^[a-zA-Z]+$ ]]; then
                echo "Error: PAN must be 10 Alphanumeric characters (Both Letters and Numbers required)."
                echo "Account Creation Process Failed. Restarting Again..."
                continue
            fi

        # License: 15-16 chars, MUST be mixed (not only numbers, not only letters)
        elif [[ "$id_type" == "License" ]]; then
            if [[ ! "$id_value" =~ ^[a-zA-Z0-9]{15,16}$ ]] || [[ "$id_value" =~ ^[0-9]+$ ]] || [[ "$id_value" =~ ^[a-zA-Z]+$ ]]; then
                echo "Error: License must be 15-16 Alphanumeric characters (Both Letters and Numbers required)."
                echo "Account Creation Process Failed. Restarting Again..."
                continue
            fi
        fi

        # shellcheck disable=SC2034
        # 4. Account Type & Deposit
        read -p "Enter the Account Type as Savings or Current:" acc_type
        read -p "Enter the Deposit Amount: Rs." deposit_input
        # CONDITION: Check if input contains ONLY numbers
        if [[ ! "$deposit_input" =~ ^[0-9]+$ ]]; then
            echo "InValid Deposit Amount. [Note: Numbers only Allowed.]"
            echo "Account Creation Process Failed. Restarting Again......."
            echo "------------------------------------------------"
            continue # This triggers the while loop to restart from the beginning
        fi

        # If valid, assign to global BALANCE
        BALANCE=$deposit_input

        # 5. Success Status
        echo -e "\nAccount Created Successfully with Initial Deposit"
        echo "Your Current Available Balance is Rs.$BALANCE"

        # 5. Success Status
        echo -e "\nAccount Created Successfuly with Initial Deposit"
        echo "Your Current Available Balance is Rs.$BALANCE"
        
        # Trigger next Step
        Customer_Choice
        break
    done
}


# 2. Function for ATM Card Processing (Step-2)
Customer_Choice() {
    # Loop for the Apply for ATM Card Prompt
    while true; do
        echo "------------------------------------------------"
        read -p "Do you want to Apply for ATM Card: Type Yes or No: " apply_choice
        
        # Exact matching from image (Yes/No/yes/no)
        if [[ "${apply_choice,,}" == "no" ]]; then
            echo "No"
            echo "Thanks for Being a Valuable Customer to Us"
            exit 0
        elif [[ "${apply_choice,,}" == "yes" ]]; then
            echo "Yes"
            echo "Your ATM Card is Processed"
            echo "Your Temporary ATM Pin Number is: 12345"
            break # Move to ATM Access prompt
        else
            # Handling "YeNo" or wrong choice case from your image
            echo "$apply_choice"
            echo "ATM Card Process Failed. Restarting the Card Process Again......"
            continue
        fi
    done

    # Prompt for ATM Access
    # shellcheck disable=SC2162
    read -p "Do you want Access ATM?: Type Okay or Cancel: " access_choice
    
    if [[ "${access_choice,,}" == "cancel" ]]; then
        echo "Cancel"
        echo "Thankyou Visit Again !!"
        exit 0
    elif [[ "${access_choice,,}" == "okay" ]]; then
        echo "Okay"
         ATM_Process 
    fi
}

ATM_Process() {
    # If the requirement says "Restarting", use a loop
    while true; do
        read -p "Enter the Pin Number: " input_pin
        
        if [[ "$input_pin" == "12345" ]]; then
            echo "Welcome User!!"
            echo "Enter 1 For Cash Withdraw or 2 For Cash Deposit."
            read -p "Choice: " trans_choice

            if [[ "$trans_choice" == "1" ]]; then
                Debit_Process
                break # Exit loop on success
            elif [[ "$trans_choice" == "2" ]]; then
                Credit_Process
                break # Exit loop on success
            else
                # To match screenshot perfectly but keep script alive:
                echo "Invalid Choice"
                echo "------------------------------------------------"
                # If you want it to EXIT like the picture, use 'exit 1' here instead of 'continue'
                continue 
            fi
        else
            echo "Invalid Pin Number"
        fi
    done
}


# 4. Function for Cash Withdrawal (Debit)
Debit_Process() {
    # Infinite loop to match image behavior: keep asking until success
    while true; do
        read -p "Enter the Amount to Withdraw: Rs." withdraw_amt

        # Step-5: Denomination Validation (Multiples of 100)
        if (( withdraw_amt % 100 != 0 )); then
            echo "Enter The Valid Amount"
            # No exit here; loop restarts at "Enter the Amount"
            continue 
        fi

        # Step-4: Insufficient Balance Validation
        if (( withdraw_amt > BALANCE )); then
            echo "Insufficient Balance"
            echo "Your Current Available is Rs.$BALANCE"
            # No exit here; loop restarts at "Enter the Amount"
            continue 
        fi

        # Success Case (matches green arrows in your image)
        BALANCE=$((BALANCE - withdraw_amt))
        echo "Your Current Available Balance After Deduction is Rs.$BALANCE"
        
        # Once successful, break the loop and end the session
        echo -e "\nThank you for using our ATM Management System. Have a great day!"
        exit 0
    done
}


# 5. Function for Cash Deposit (Credit_Process)
Credit_Process() {
    # Infinite loop to match image behavior: keep asking until success
    while true; do
        # Prompt exactly as shown in the image
        read -p "Enter the Amount to Deposit Rs." deposit_amt
        
        # Denomination Validation (Image shows failures for 20, 40, 90, 145, 180, 135, 555, 980, 950, 920, 620)
        # Only 500 is accepted in the example.
        if (( deposit_amt % 500 != 0 )); then
            echo "Enter the Valid Amount"
            continue # Re-prompts the user
        fi

        # Success Case - Logic for updating balance
        BALANCE=$((BALANCE + deposit_amt))
        
        # Success messages matching the green arrows in the image
        echo "Your Amount Deposited Successfully !!"
        echo "Your Current Available Balance is Rs.$BALANCE"
        
        # Exit the loop and end the session as per project flow
        echo -e "\nThank you for using our ATM Management System. Have a great day!"
        exit 0
    done
}


# Project Execution Mapping
Customer_Details
