 #!/bin/bash

 head -n 1 extracted_meta.csv >> assessed_docs.csv
# Read all values from the third column of file1 into an array
values=($(awk -F '\t' '{print $3}' CHS-2021/assessments/qrels.txt ))

# Loop through each value in the array
for value in "${values[@]}"; do
    # Search for lines containing the value in file2 and write them to a new file
    grep "$value" extracted_meta.csv >> assessed_docs.csv
done
