#!/bin/bash

# Read all values from the third column of file1 into an array
values=($(awk -F '\t' '{print $3}' CHS-2021/assessments/qrels.txt ))

# Print number of unique values in the array
echo "Number of unique values: ${#values[@]}"

# Get the length of the array
len=${#values[@]}

# Get the start time
start_time=$(date +%s)
i=0
# Loop through each value in the array
for value in "${values[@]}"; do
    # Check if value already exists in output file
    if grep -q "$value" assessed_docs.csv; then
        # If it does, skip this iteration
        continue
    fi
    # Search for lines containing the value in file2 and write them to a new file
    grep "$value" extracted_meta.csv >> assessed_docs.csv

    # If value is not found in file2, add it to a different file not_found.txt 
    if [ $? -ne 0 ]; then
        echo "$value" >> not_found.txt
    fi


    # Every 10 iterations, print the time elapsed
    if ((++i % 10 == 0)); then
        clear
        # Get the current time
        current_time=$(date +%s)

        # Calculate the elapsed time
        elapsed_time=$((current_time - start_time))

        # Calculate the average time per iteration. The result will be smaller than 1, so we need to use bc to do floating point division
        average_time_per_iteration=$(echo "scale=2; $elapsed_time / $i" | bc)

        # Calculate the total time using the average time per iteration using bc
        total_time=$(echo "scale=2; $average_time_per_iteration * $len" | bc)
        # Calculate the estimated time remaining using bc
        estimated_time_remaining=$(echo "scale=2; $total_time - $elapsed_time" | bc)

        # Convert times to HH:MM:SS format
        elapsed_time=$(date -u -d @"$elapsed_time" +'%H:%M:%S')
        estimated_time_remaining=$(date -u -d @"$estimated_time_remaining" +'%H:%M:%S')

        # Print number of iterations completed
        echo "Iterations completed: $i/$len in $elapsed_time"
        echo "Average time per iteration: $average_time_per_iteration"
        # Print the estimated time remaining
        echo "Estimated time remaining (HH:MM:SS): $estimated_time_remaining"
        # Print a blank line
        echo
    fi


done
