#!/bin/bash

create_env_files_from_templates() {
    local templates=("$@")
    for template in "${templates[@]}"; do
        local env_file="${template%.template}"
        if [ -f "$env_file" ]; then
            echo "$env_file already exists, skipping..."
        else
            cp "$template" "$env_file"
            echo "$env_file created from $template."
        fi
    done
    echo "All .env files processed."
}

create_template_files_from_envs() {
    local env_files=("$@")
    for env_file in "${env_files[@]}"; do
        local template_file="${env_file}.template"
        if [ -f "$template_file" ]; then
            echo "$template_file already exists, skipping..."
        else
            if [ -f "$env_file" ]; then
                while IFS= read -r line || [[ -n "$line" ]]; do
                    # if line is empty, just append newline
                    if [ -z "$line" ]
                    then
                        echo "" >> "$template_file"
                        continue
                    else
                        echo "${line%%=*}=" >> "$template_file"
                    fi

                done < "$env_file"
                echo "$template_file created from $env_file (keys only)."
            else
                echo "$env_file does not exist, skipping..."
            fi
        fi
    done
    echo "All .env.template files processed."
}
env_folder="env"
env_templates=("docker.env.template" "docker_login.env.template" "grafana.env.template" "pipeline.env.template")
env_files=("docker.env" "docker_login.env" "grafana.env" "pipeline.env")

env_templates=("${env_templates[@]/#/$env_folder/}")
env_files=("${env_files[@]/#/$env_folder/}")
create_env_files_from_templates "${env_templates[@]}"
create_template_files_from_envs "${env_files[@]}"
