#!/bin/sh

# Default configuration
DEFAULT_ISSUE_PATTERN="issues/([0-9]+)"
DEFAULT_RELEASE_PATTERN="release/(.*)"
DEFAULT_ISSUE_PREFIX="(#%s) "
DEFAULT_RELEASE_PREFIX="(%s) "
DEFAULT_POSITION="prefix"

# Parse command line arguments
ISSUE_PATTERN="${DEFAULT_ISSUE_PATTERN}"
RELEASE_PATTERN="${DEFAULT_RELEASE_PATTERN}"
ISSUE_PREFIX="${DEFAULT_ISSUE_PREFIX}"
RELEASE_PREFIX="${DEFAULT_RELEASE_PREFIX}"
POSITION="${DEFAULT_POSITION}"

# Store the commit message file (first argument is the commit message file for git hooks)
COMMIT_FILE="$1"
shift

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --issue-pattern)
            ISSUE_PATTERN="$2"
            shift 2
            ;;
        --release-pattern)
            RELEASE_PATTERN="$2"
            shift 2
            ;;
        --issue-prefix)
            ISSUE_PREFIX="$2"
            shift 2
            ;;
        --release-prefix)
            RELEASE_PREFIX="$2"
            shift 2
            ;;
        --position)
            POSITION="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Function to extract issue number using regex pattern
extract_issue_number() {
    local pattern="$1"
    local branch="$2"
    
    # Use bash regex matching with BASH_REMATCH
    if [[ $branch =~ $pattern ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

# Function to apply prefix/suffix to commit message
apply_format() {
    local message="$1"
    local format="$2"
    local value="$3"
    
    local formatted=$(printf "$format" "$value")
    
    if [[ "$POSITION" == "suffix" ]]; then
        echo "$message $formatted"
    else
        echo "$formatted$message"
    fi
}

# Read the original commit message
COMMIT_MESSAGE=$(cat "$COMMIT_FILE")

# Try to extract issue number
ISSUE_NUMBER=$(extract_issue_number "$ISSUE_PATTERN" "$BRANCH_NAME")

if [[ -n $ISSUE_NUMBER ]]; then
    # Format with issue number
    NEW_MESSAGE=$(apply_format "$COMMIT_MESSAGE" "$ISSUE_PREFIX" "$ISSUE_NUMBER")
    echo "$NEW_MESSAGE" > "$COMMIT_FILE"
else
    # Try to match release pattern
    RELEASE_NAME=$(extract_issue_number "$RELEASE_PATTERN" "$BRANCH_NAME")
    if [[ -n $RELEASE_NAME ]]; then
        NEW_MESSAGE=$(apply_format "$COMMIT_MESSAGE" "$RELEASE_PREFIX" "$RELEASE_NAME")
        echo "$NEW_MESSAGE" > "$COMMIT_FILE"
    fi
fi

