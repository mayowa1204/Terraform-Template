CONFIG_FILE="infra/environments/dev/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE does not exist. Please create it."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but it's not installed. Please install jq."
    exit 
fi

# Check if the required keys exist in the JSON file
if ! jq -e 'has("project_id") and has("api_name")' "$CONFIG_FILE" >/dev/null; then
    echo "Error: $CONFIG_FILE does not contain the required keys (project_id, api_name). Please provide them."
    exit 
fi

# Read config values using jq
PROJECT_ID=$(jq -r '.project_id' "$CONFIG_FILE")
API_NAME=$(jq -r '.api_name' "$CONFIG_FILE")
#!/bin/bash

install_requirements() {
    fn=$1
    requirements="$fn/requirements.txt"
    if [[ -f $requirements ]]; then
        echo "Installing requirements for $fn function"
        pip3 install -r "$requirements"
    else
        echo "No requirements.txt found in $fn function"
    fi
}

# Iterate through each subdirectory in the functions directory
echo "..................Installing function dependencies................."
for fn in functions/*/; do
    if [[ -f "$fn/main.py" ]]; then
        install_requirements "$fn"
    else
        echo "No main.py found in $fn, skipping"
    fi
done

echo "..................Function dependencies installed.............."

echo ".......... Deploying Project $PROJECT_ID..............."

cd "infra/environments/dev"
terraform init
terraform apply
API_URL=$(terraform output -raw api_url)

echo "...............Enabling API................."

# Enable the API
gcloud services enable apigateway.googleapis.com --project $PROJECT_ID


