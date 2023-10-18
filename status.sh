#!/bin/bash
# check status of GH action
# with -w flag, scirpt pols GH for run to compleete

repo="zrthstr/lyserg.io"


#!/bin/bash

repo="yourusername/yourrepo"  # Replace with your GitHub username and repository name

# Function to check the latest status and rate limit
check_status() {
    local api_response=$(curl -i -s "https://api.github.com/repos/$repo/actions/runs")
    local latest_run_id=$(echo "$api_response" | jq -r '.workflow_runs[0].id')
    local rate_limit_info=$(echo "$api_response" | grep 'x-ratelimit-remaining')

    # Check for HTTP status code 403 (Forbidden)
    if [ "$latest_run_id" == "403" ]; then
        if [ -n "$rate_limit_info" ]; then
            echo "Rate limit exceeded. Remaining requests: $rate_limit_info"
        else
            echo "Error: Access to GitHub API is forbidden. Check your authentication or repository permissions."
        fi
        exit 1
    fi

    local latest_status=$(echo "$api_response" | jq -r '.workflow_runs[0].conclusion')

    if [ "$latest_status" == "success" ]; then
        echo "Latest build status: Success"
        exit 0
    elif [ "$latest_status" == "failure" ]; then
        echo "Latest build status: Failure"
        exit 1
    elif [ "$latest_status" == "null" ]; then
        echo "Workflow is still running"
        return 2
    else
        echo "Latest build status: Unknown"
        exit 3
    fi
}

# Fetch the latest_run_id only once
latest_run_id=$(check_status | grep -Eo '[0-9]+')

# Check for the -w flag
while getopts "w" opt; do
    case $opt in
        w)
            while true; do
                check_status
                sleep 1
            done
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

# If the -w flag is not provided, check status once
check_status

