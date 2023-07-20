#!/bin/bash
# list of all possible models
all_llms="chatgpt falcon7b_instruct falcon7b_prompt falcon40b_instruct falcon40b_prompt OA_LLama"
llm_names=""
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
        -l|--llm)
        llm_names="$2"
        shift
        shift
        ;;
        -q|--quiet)
        quiet=true
        shift
        ;;
        -h|--help)
        echo "Usage: querywise_indexing_execution_script.sh [OPTIONS]"
        echo "Options:"
        echo "  -m, --model MODEL_NAME    Name of the model to use"
        echo "  -l, --llm LLM_NAMES      Names of the LLMs to use. If 'all' is specified, then all LLMs will be used"
        echo "  -q, --quiet              Run script in quiet mode"
        echo "  -h, --help               Show this help message and exit"
        exit 0
        ;;
        *)
        echo "Unknown option: $key"
        exit 1
        ;;
    esac
done

# if llm_names = all, then set llm_names to all_llms
if [ "$llm_names" = "all" ]; then
    llm_names="$all_llms"
fi

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
        
        if [ -z "$llm_names" ]; then
            echo "Query ID: $qid"
            if [ "$quiet" = false ]; then
                python "$script_name" "$qid" "$model_name"
            else
                python "$script_name" "$qid" "$model_name" > /dev/null 2>&1
            fi
        else
            for llm_name in $llm_names; do
                echo "LLM: $llm_name for Query ID: $qid"
                if [ "$quiet" = false ]; then
                    python "$script_name" "$qid" "$model_name" "$llm_name"
                else
                    python "$script_name" "$qid" "$model_name" "$llm_name" > /dev/null 2>&1
                fi
            done
        fi
    fi
done < "$topics_file"

# pass model name to average_results.py
python average_results.py "$model_name"