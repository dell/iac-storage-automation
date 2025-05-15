import requests
import json
import subprocess
import os
import re
import sys

# --- Configuration ---
# PowerStore API endpoint (e.g., https://<your_powerstore_ip>/api/rest)
POWERSTORE_ENDPOINT = "https://1.2.3.4/api/rest"
# PowerStore username
POWERSTORE_USER = "user"
# PowerStore password
POWERSTORE_PASSWORD = "password"
# Output Terraform file name
OUTPUT_TF_FILE = "import_volumes.tf"
# Required PowerStore provider version
TERRAFORM_PROVIDER_VERSION = "1.2.0"  # Check the required provider version
# Limit for fetching volumes (adjust if you have more than 300 primary volumes)
VOLUME_FETCH_LIMIT = 300
# --- End Configuration ---

# --- Helper Function to Sanitize Volume Name for Terraform Resource Name ---
# Terraform resource names must start with a letter or underscore and contain only letters, digits, and underscores.
def sanitize_name(name):
    """Sanitizes a volume name into a valid Terraform resource name."""
    # Convert to lowercase
    sanitized = name.lower()
    # Replace spaces, hyphens, dots, and other non-alphanumeric/underscore characters with underscores
    sanitized = re.sub(r'[^a-z0-9_]', '_', sanitized)
    # Remove consecutive underscores
    sanitized = re.sub(r'_+', '_', sanitized)
    # Remove leading/trailing underscores
    sanitized = sanitized.strip('_')
    # Add a prefix if the name starts with a digit or is empty after sanitization
    if not sanitized or sanitized[0].isdigit():
        sanitized = f"vol_{sanitized}"
    # Ensure it doesn't start with an underscore after adding prefix
    sanitized = sanitized.lstrip('_')

    return sanitized

# --- Function to Fetch Volume Data ---
def fetch_volume_data(endpoint, user, password, limit):
    """Fetches primary volume data from the PowerStore API."""
    url = f"{endpoint}/volume?select=id,name&type=eq.Primary&limit={limit}"
    print(f"Fetching volume data from {url}...")

    try:
        # Disable SSL warnings for -k equivalent, use verify=True with proper certs in production
        requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)
        response = requests.get(url, auth=(user, password), verify=False) # verify=False for -k

        # Raise an HTTPError for bad responses (4xx or 5xx)
        response.raise_for_status()

        volume_data = response.json()

        if not isinstance(volume_data, list):
             print("Warning: API response is not a list. Check API endpoint and query.")
             return []

        # Process the data to match the desired format
        processed_data = [{"id": item["id"], "volume_name": item["name"]} for item in volume_data]

        print(f"Successfully fetched {len(processed_data)} primary volumes.")
        return processed_data

    except requests.exceptions.RequestException as e:
        print(f"Error fetching volume data: {e}")
        return None
    except json.JSONDecodeError:
        print("Error decoding JSON response from API. Check API endpoint and response format.")
        return None

# --- Function to Generate Terraform File ---
def generate_terraform_file(volumes, output_file, provider_version, endpoint, user, password):
    """Generates the Terraform configuration file with provider and resource blocks."""
    print(f"Generating {output_file}...")

    try:
        with open(output_file, "w") as f:
            # Add terraform and provider blocks
            f.write(f"""terraform {{
  required_providers {{
    powerstore = {{
      version = "{provider_version}"
      source = "registry.terraform.io/dell/powerstore"
    }}
  }}
}}

provider "powerstore" {{
  username = "{user}"
  password = "{password}"
  endpoint = "{endpoint}"
  insecure = true # Use 'false' for production with valid certificates
  timeout  = "120" # Adjust timeout if needed
}}

# --- Resources to be imported ---
# Empty resource blocks are created below.
# After import, run 'terraform plan' to see the full configuration
# and manually populate the arguments in these blocks.

""")

            # Add resource blocks for each volume
            for volume in volumes:
                volume_id = volume["id"]
                volume_name = volume["volume_name"]
                resource_name = sanitize_name(volume_name)

                print(f"Adding resource block for volume: '{volume_name}' (ID: {volume_id}) as resource 'powerstore_volume.{resource_name}'")

                f.write(f"""
resource "powerstore_volume" "{resource_name}" {{
  # This resource block is a placeholder for importing.
  # After import, run 'terraform plan' to see the full configuration.
  # You will need to manually add attributes like 'size', 'description', etc.
  # For example:
  # name = "{volume_name}"
  # size = 100 # Example attribute

  # ... (rest of the arguments will be populated by import and 'terraform plan' output)
}}

""")
        print(f"{output_file} generated successfully.")
        return True
    except IOError as e:
        print(f"Error writing to file {output_file}: {e}")
        return False

# --- Function to Run Terraform Init ---
def run_terraform_init():
    """Runs terraform init."""
    print("Running 'terraform init'...")
    try:
        # Capture stdout and stderr
        result = subprocess.run(["terraform", "init"], check=True, capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("Terraform init stderr:")
            print(result.stderr)
        print("Terraform initialized successfully.")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running 'terraform init': {e}")
        print("Terraform init stdout:")
        print(e.stdout)
        print("Terraform init stderr:")
        print(e.stderr)
        return False
    except FileNotFoundError:
        print("Error: 'terraform' command not found. Please ensure Terraform is installed and in your PATH.")
        return False

# --- Function to Run Terraform Import ---
def run_terraform_import(volumes):
    """Runs terraform import for each volume."""
    print("Starting terraform import process...")
    import_success_count = 0
    import_fail_count = 0

    for volume in volumes:
        volume_id = volume["id"]
        volume_name = volume["volume_name"]
        resource_name = sanitize_name(volume_name)
        terraform_resource_address = f"powerstore_volume.{resource_name}"

        print(f"Attempting to import volume '{volume_name}' (ID: {volume_id}) into resource '{terraform_resource_address}'...")

        try:
            # Run the import command
            result = subprocess.run(
                ["terraform", "import", terraform_resource_address, volume_id],
                check=True, # Raise CalledProcessError if command returns non-zero exit code
                capture_output=True,
                text=True
            )
            print(result.stdout)
            if result.stderr:
                 # Terraform often prints warnings/info to stderr even on success
                 print("Terraform import stderr:")
                 print(result.stderr)
            print(f"Successfully imported volume '{volume_name}'.")
            import_success_count += 1
        except subprocess.CalledProcessError as e:
            print(f"Error importing volume '{volume_name}' (ID: {volume_id}).")
            print("Terraform import stdout:")
            print(e.stdout)
            print("Terraform import stderr:")
            print(e.stderr)
            import_fail_count += 1
        except FileNotFoundError:
             print("Error: 'terraform' command not found. Please ensure Terraform is installed and in your PATH.")
             # Exit immediately as we can't proceed without terraform
             sys.exit(1)

        print("---") # Separator for clarity between imports

    print(f"Terraform import process completed.")
    print(f"Successfully imported: {import_success_count}")
    print(f"Failed to import: {import_fail_count}")

    if import_fail_count > 0:
        print("Warning: Some volumes failed to import. Please review the output above.")

# --- Main Execution ---
if __name__ == "__main__":
    # Check if requests library is installed
    try:
        import requests
    except ImportError:
        print("Error: The 'requests' library is not installed.")
        print("Please install it using: pip install requests")
        sys.exit(1)

    # Step 1 & 2: Fetch Volume Data
    volume_data = fetch_volume_data(POWERSTORE_ENDPOINT, POWERSTORE_USER, POWERSTORE_PASSWORD, VOLUME_FETCH_LIMIT)

    if volume_data is None:
        sys.exit(1) # Exit if fetching data failed

    if not volume_data:
        print("No volumes found to import. Exiting.")
        sys.exit(0) # Exit successfully if no volumes are found

    # Step 3: Generate Terraform File
    if not generate_terraform_file(volume_data, OUTPUT_TF_FILE, TERRAFORM_PROVIDER_VERSION, POWERSTORE_ENDPOINT, POWERSTORE_USER, POWERSTORE_PASSWORD):
        sys.exit(1) # Exit if file generation failed

    # Initialize Terraform
    if not run_terraform_init():
        sys.exit(1) # Exit if terraform init failed

    # Step 4: Execute Terraform Import Commands
    run_terraform_import(volume_data)

    # Step 5: After successful execution
    print("\n------------------------------------------------------------------")
    print("Terraform import process finished.")
    print("")
    print("Next Steps:")
    print(f"1. Review the generated '{OUTPUT_TF_FILE}'. It contains the provider configuration and empty resource blocks for the imported volumes.")
    print("2. Terraform state has been updated with the imported volumes.")
    print("3. **Crucially, run 'terraform plan'** in the same directory as the .tf file.")
    print("   'terraform plan' will read the state file and compare it to the (currently empty) resource blocks in the .tf file.")
    print("   The output will show you the attributes (like size, description, etc.) that Terraform sees in the imported state but are missing from your .tf file.")
    print(f"4. Manually add these missing attributes to the corresponding resource blocks in '{OUTPUT_TF_FILE}' based on the 'terraform plan' output.")
    print("5. Run 'terraform plan' again. Repeat step 4 until 'terraform plan' shows 'No changes. Your infrastructure matches the configuration.'")
    print("6. At this point, your Terraform configuration fully reflects the imported volumes.")
    print("7. You can optionally run 'terraform apply' (which should show no changes) to confirm, but **always review the plan carefully** before applying.")
    print("8. Check your terraform state file (e.g., terraform.tfstate) to confirm the volumes are listed with their details.")
    print("------------------------------------------------------------------")


