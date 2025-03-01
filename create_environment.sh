#!/bin/bash

#Ask user to enter username
read -p "Enter your username: " username
mkdir -p "submission_reminder_$username"
cd "submission_reminder_$username"
 
#Create first repository inside submission_reminder_$username with it's file and add contents
mkdir -p modules
cat > modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#make file within repository be executable
chmod +x modules/functions.sh

#creating the second directory under submission_reminder_$username with it's file and content within the file
mkdir -p assets
cat > assets/submissions.txt << 'EOF'
Student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Emmanuel, Shell Permissions, submitted
Ade, Python, submitted
Sade, Git, not submitted
David, Shell Navigation, submitted
Malle, Intro to Linux, submitted
Nnamdi, Shell Loops, not submitted
EOF

#make file within directory be executable
chmod +x assets/submissions.txt

#creating the third directory under submission_reminder_$usernmae with it's file and content within the file
mkdir -p config
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#make file within directory be executable
chmod +x config/config.env

#creating the fourth directory under submission_reminder_$username
mkdir -p app
cat > app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#makefile within that repository be executable
chmod +x app/reminder.sh

#Create startup file to run remainder file under app directory
cat > startup.sh << 'EOF'
#!/bin/bash
cd app
./reminder.sh
EOF

#make startup file executable
chmod +x startup.sh

echo "All work done successfully under directory named create_reminder_$username"
