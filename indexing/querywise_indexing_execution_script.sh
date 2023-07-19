#!/bin/bash

quiet=false
# parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -m|--model)
        model_name="$2"
        shift
        shift
        ;;
        -q|--quiet)
        quiet=true
        shift
        ;;
        *)
        echo "Unknown option: $key"
        exit 1
        ;;
    esac
done

# load topics.txt file
topics_file="../data/topics/topics.txt"

# execute appropriate script based on model name
if [ "$model_name" = "colbert_v1" ]; then
    script_name="querywise_indexing_colbert_v1.py"
elif [ "$model_name" = "monoT5" ]; then
    script_name="querywise_indexing_T5.py"
else
    echo "Unknown model name: $model_name"
    exit 1
fi

# loop over each topic in topics.txt
while IFS= read -r line; do
    if [[ $line == *"<id>"* ]]; then
        qid=$(echo $line | sed 's/<[^>]*>//g')
        echo "Query ID: $qid"
        if [ "$quiet" = false ]; then
            python "$script_name"  "$qid" "$model_name"
        else
            python "$script_name" "$qid" "$model_name" > /dev/null 2>&1
        fi
    fi
done < "$topics_file"

# pass model name to average_results.py
python average_results.py "$model_name"