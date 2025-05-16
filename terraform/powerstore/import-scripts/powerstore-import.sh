#!/bin/bash

# --- Configuration ---
# PowerStore API endpoint (e.g., https://<your_powerstore_ip>/api/rest)
POWERSTORE_ENDPOINT="https://172.24.185.60/api/rest"
# PowerStore username
POWERSTORE_USER="user"
# PowerStore password
POWERSTORE_PASSWORD=""
# Output Terraform file name
OUTPUT_TF_FILE="import_volumes.tf"
# Required PowerStore provider version
TERRAFORM_PROVIDER_VERSION="1.2.0"
# Limit for fetching volumes (adjust if you have more than 300 primary volumes)
VOLUME_FETCH_LIMIT="300"
# -------------------

# --- Helper Function to Sanitize Volume Name for Terraform Resource Name ---
# Terraform resource names must start with a letter or underscore and contain only letters, digits, and underscores.
sanitize_name() {
    local name="$1"
    # Convert to lowercase
    local sanitized=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    # Replace spaces, hyphens, dots, and other non-alphanumeric/underscore characters with underscores
    sanitized=$(echo "$sanitized" | sed 's/[^a-z0-9_]/_/g')
    # Remove consecutive underscores
    sanitized=$(echo "$sanitized" | sed 's/__*/_/g')
    # Remove leading/trailing underscores
    sanitized=$(echo "$sanitized" | sed 's/^_//;s/_$//')
    # Add a prefix if the name starts with a digit or is empty after sanitization
    if [[ "$sanitized" =~ ^[0-9] ]]; then
        sanitized="vol_${sanitized}"
    elif [[ -z "$sanitized" ]]; then
         sanitized="imported_volume_$(date +%s)" # Fallback with timestamp if sanitization results in empty string
    fi
     # Ensure it doesn't start with an underscore after adding prefix
    sanitized=$(echo "$sanitized" | sed 's/^_//')

    echo "$sanitized"
}

# --- Check for required commands ---
# Ensure curl, jq, sed, and terraform are installed
for cmd in curl jq sed terraform; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Command '$cmd' is not installed. Please install it and try again."
        exit 1
    fi
done

# --- Step 1 & 2: Get Volume IDs and Names ---
# Use curl to fetch primary volumes, jq to parse the output, and sed to clean up newline characters.
echo "Fetching primary volume data from PowerStore API..."
# Construct the curl command safely
CURL_CMD="curl -s -k -u \"$POWERSTORE_USER:$POWERSTORE_PASSWORD\" \"$POWERSTORE_ENDPOINT/volume?select=id%2Cname&type=eq.Primary&limit=$VOLUME_FETCH_LIMIT\""
VOLUME_DATA=$(eval "$CURL_CMD" | jq -c '.[] | { id: .id, volume_name: .name }' | sed 's/\r$//')

# Check if the API call was successful and returned data
if [ -z "$VOLUME_DATA" ]; then
    echo "Error fetching volume data or no primary volumes found."
    echo "Please check the endpoint, credentials, and connectivity."
    exit 1
fi

echo "Successfully fetched volume data."

# --- Step 3: Add empty resource blocks and provider to tf file ---
# Create the Terraform file with provider configuration and empty resource blocks for each volume.
echo "Generating $OUTPUT_TF_FILE with provider and empty resource blocks..."

# Add terraform and provider blocks to the file
cat << EOF > "$OUTPUT_TF_FILE"
terraform {
  required_providers {
    powerstore = {
      version = "$TERRAFORM_PROVIDER_VERSION"
      source = "registry.terraform.io/dell/powerstore"
    }
  }
}

provider "powerstore" {
  username = "$POWERSTORE_USER"
  password = "$POWERSTORE_PASSWORD"
  endpoint = "$POWERSTORE_ENDPOINT"
  insecure = true # Use 'false' for production with valid certificates
  timeout  = "120" # Adjust timeout if needed
}

# --- Resources to be imported ---
# Empty resource blocks are created below.
# After import, run 'terraform plan' to see the full configuration
# and manually populate the arguments in these blocks.

EOF

# Parse volume data line by line and add resource blocks
echo "$VOLUME_DATA" | while IFS= read -r line; do
    VOLUME_ID=$(echo "$line" | jq -r '.id')
    VOLUME_NAME=$(echo "$line" | jq -r '.volume_name')
    RESOURCE_NAME=$(sanitize_name "$VOLUME_NAME")

    echo "Adding resource block for volume: '$VOLUME_NAME' (ID: $VOLUME_ID) as resource 'powerstore_volume.$RESOURCE_NAME'"

    # Append the empty resource block to the file
    cat << EOF >> "$OUTPUT_TF_FILE"
resource "powerstore_volume" "$RESOURCE_NAME" {
  # This resource block is a placeholder for importing.
  # After import, run 'terraform plan' to see the full configuration.
  # You will need to manually add attributes like 'size', 'description', etc.
  # For example:
  # name = "$VOLUME_NAME"
  # size = 100 # Example attribute

  # ... (rest of the arguments will be populated by import and 'terraform plan' output)
}

EOF
done

echo "$OUTPUT_TF_FILE generated successfully."

# --- Initialize Terraform ---
# Run terraform init to download the provider.
echo "Running 'terraform init'..."
if ! terraform init; then
    echo "Error: terraform init failed. Please resolve the issue and try again."
    exit 1
fi
echo "Terraform initialized successfully."

# --- Step 4: Execute terraform import commands ---
# Iterate through the fetched volumes and run the import command for each.
echo "Starting terraform import process..."

# Re-parse the volume data to run imports
echo "$VOLUME_DATA" | while IFS= read -r line; do
    VOLUME_ID=$(echo "$line" | jq -r '.id')
    VOLUME_NAME=$(echo "$line" | jq -r '.volume_name')
    RESOURCE_NAME=$(sanitize_name "$VOLUME_NAME")

    echo "Attempting to import volume '$VOLUME_NAME' (ID: $VOLUME_ID) into resource 'powerstore_volume.$RESOURCE_NAME'..."
    # Execute the import command
    # We use || true to prevent the script from exiting immediately on a single import failure
    if terraform import "powerstore_volume.$RESOURCE_NAME" "$VOLUME_ID"; then
        echo "Successfully imported volume '$VOLUME_NAME'."
    else
        echo "Warning: Error importing volume '$VOLUME_NAME' (ID: $VOLUME_ID). Check the output above for details."
        # You might want to log failed imports or handle them differently
    fi
    echo "---" # Separator for clarity between imports
done

echo "Terraform import process completed."

# --- Step 5: After successful execution ---
# Provide instructions on the next steps.
echo ""
echo "------------------------------------------------------------------"
echo "Terraform import process finished."
echo ""
echo "Next Steps:"
echo "1. Review the generated '$OUTPUT_TF_FILE'. It contains the provider configuration and empty resource blocks for the imported volumes."
echo "2. Terraform state has been updated with the imported volumes."
echo "3. **Crucially, run 'terraform plan'** in the same directory as '$OUTPUT_TF_FILE'."
echo "   'terraform plan' will read the state file and compare it to the (currently empty) resource blocks in '$OUTPUT_TF_FILE'."
echo "   The output will show you the attributes (like size, description, etc.) that Terraform sees in the imported state but are missing from your .tf file."
echo "4. Manually add these missing attributes to the corresponding resource blocks in '$OUTPUT_TF_FILE' based on the 'terraform plan' output."
echo "5. Run 'terraform plan' again. Repeat step 4 until 'terraform plan' shows 'No changes. Your infrastructure matches the configuration.'"
echo "6. At this point, your Terraform configuration fully reflects the imported volumes."
echo "7. You can optionally run 'terraform apply' (which should show no changes) to confirm, but **always review the plan carefully** before applying."
echo "8. Check your terraform state file (e.g., terraform.tfstate) to confirm the volumes are listed with their details."
echo "------------------------------------------------------------------"

exit 0

