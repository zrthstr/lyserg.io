#!/bin/bash
# check status of GH action
# with -w flag, scirpt pols GH for run to compleete

repo="zrthstr/lyserg.io"

check_status() {
    local latest_run_id=$(curl -s "https://api.github.com/repos/$repo/actions/runs" | jq -r '.workflow_runs[0].id')
    local latest_status=$(curl -s "https://api.github.com/repos/$repo/actions/runs/$latest_run_id" | jq -r '.conclusion')

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

check_status
