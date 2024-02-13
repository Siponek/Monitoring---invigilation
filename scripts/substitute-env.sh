#!/bin/bash

export_env_vars() {
    local env_file=$1
    while IFS=: read -r key value; do
        # Trim leading and trailing spaces in key/value
        key=$(echo $key | xargs)
        value=$(echo $value | xargs)
        # Remove possible leading 'export ' string
        key=${key#export }
        # Check if the line contains a valid variable assignment
        if [[ ! -z "$key" && ! -z "$value" && "$key" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
            export $key="$value"
        fi
    done < "$env_file"
}

unset_env_vars() {
    while IFS=: read -r key _; do
    key=$(echo $key | xargs) # Trim spaces
    key=${key#export } # Remove 'export ' if present
    if [[ "$key" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        unset "$key"
    fi
done < "$ENV_FILE"
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <env-file> <template-file> <output-file>"
    exit 1
fi

ENV_FILE=$1
TEMPLATE_FILE=$2
OUTPUT_FILE=$3

if [ ! -f "$ENV_FILE" ]; then
    echo "Environment file $ENV_FILE does not exist."
    exit 1
elif [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Template file $TEMPLATE_FILE does not exist."
    exit 1
fi

# Substitute environment variables into the output file
# Export environment variables from the custom format file

export_env_vars "$ENV_FILE"
envsubst < "$TEMPLATE_FILE" > "$OUTPUT_FILE"
unset_env_vars
echo "Substitution complete. The output file $OUTPUT_FILE is ready."
