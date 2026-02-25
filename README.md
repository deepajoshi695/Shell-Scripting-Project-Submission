# ATM Management System - Shell Scripting Project

## Project Overview
This project is a comprehensive **ATM Management System** built using Bash scripting. It simulates a real-world banking experience through a command-line interface, covering everything from account creation with ID validation to secure financial transactions.

## Features & Functionality
*   **Step 1: Account Creation**: Collects user details (Name, ID Type, ID Number, Account Type, and Initial Deposit). Includes strict validation for ID formats (Aadhar, PAN, License) using regex.
*   **Step 2: ATM Card Processing**: Simulates card issuance with a default PIN (`12345`) and user consent prompts.
*   **Step 3: Transaction Selection**: Secure PIN verification and selection between Debit and Credit operations.
*   **Step 4: Debit Process**: Handles cash withdrawals with logic for denomination validation (multiples of 100) and insufficient balance checks.
*   **Step 5: Credit Process**: Handles cash deposits with denomination validation (multiples of 500) and real-time balance updates.

## Skills & Techniques Implemented
To meet the project requirements, the following shell scripting concepts were utilized:
*   **Functions**: Five distinct functions (`Customer_Details`, `Customer_Choice`, `ATM_Process`, `Debit_Process`, and `Credit_Process`) to manage project flow.
*   **String Manipulation**: Used `${var^^}` to force uppercase names and `${var,,}` for case-insensitive input comparisons.
*   **Pattern Matching (Regex)**: Used `[[ $id_value =~ ^[a-zA-Z0-9]+$ ]]` and specific length checks to validate official ID numbers.
*   **Control Structures**: Implementation of `while` loops for error recovery and `if-elif-else`/`case` statements for decision making.
*   **Arithmetic Operations**: Used `(( ... ))` for balance calculations and the modulo operator `%` to enforce currency denomination rules.
*   **Terminal Interaction**: Enhanced user experience with `read -p` prompts, `read -sp` for secure PIN entry, and clear status messages.

## Project Structure
```text
.
├── Transaction.sh          # Main Shell Script
├── README.md               # Project Documentation
├── Screenshots/            # Folder containing output captures
└── Transaction.sh - ATM_Project - Visual Studio Code 2026-02-25 22-16-11  # Screen recording of the execution flow

How to Run the Project
Open your terminal (Linux, macOS, or Git Bash). 
Grant execution permissions:
bash
chmod +x Transaction.sh

Run the script:
bash
./Transaction.sh

3.  **Save the file.**
4.  In VS Code, you can click the **"Open Preview to the Side"** button (looks like a page with a magnifying glass in the top right) to see how beautiful it will look on GitHub!
