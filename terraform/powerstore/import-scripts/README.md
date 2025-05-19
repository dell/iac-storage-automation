# Automating PowerStore Volume Import with Terraform for brownfield 

This repository contains scripts to automate the process of importing existing Dell PowerStore volumes into HashiCorp Terraform. This is particularly useful for brownfield environments where infrastructure was created manually and needs to be brought under Infrastructure as Code (IaC) management.

The scripts perform the following key steps:

1. Fetch a list of existing primary volumes from the PowerStore API.
2. Generate a Terraform configuration file (`import_volumes.tf`) with the necessary provider configuration and empty resource blocks for each volume.
3. Run `terraform init` to initialize the working directory and download the provider.
4. Execute `terraform import` commands for each volume, linking the existing PowerStore volumes to the generated resource blocks and updating the Terraform state file.

Two versions of the script are provided: a Bash script and a Python script.

## Prerequisites: 

Before running either script, ensure you have the following installed:

- Terraform: https://www.terraform.io/downloads

- Access to a Dell PowerStore array with API credentials.

**For the Bash Script (`import_powerstore_volumes.sh`)**

- A Bash-compatible shell (Linux, macOS, WSL on Windows).

- `curl`: For making API calls.

- `jq`: For parsing JSON output from the API.

- `sed`: For text manipulation.

**For the Python Script (`import_powerstore_volumes.py`)**

- Python 3.x

- The `requests` Python library: Install using `pip install requests`

## Configuration

Both scripts require you to configure your PowerStore connection details and other parameters.

1. Open the script file you intend to use (`import_powerstore_volumes.sh` or `import_powerstore_volumes.py`) in a text editor.

2. Locate the "--- Configuration ---" section at the top of the file.

3. Update the following variables with your specific details:

- `POWERSTORE_ENDPOINT`: The URL of your PowerStore API endpoint (e.g., https://1.2.3.4/api/rest).

- `POWERSTORE_USER`: Your PowerStore API username.

- `POWERSTORE_PASSWORD`: Your PowerStore API password.

- `TERRAFORM_PROVIDER_VERSION`: The desired version of the Dell PowerStore Terraform provider.

- `OUTPUT_TF_FILE`: The name for the generated Terraform file (default is import_volumes.tf).

- `VOLUME_FETCH_LIMIT`: The maximum number of primary volumes to fetch (adjust if you have more).

**Security Note**: Storing credentials directly in the script is not recommended for production environments. Consider using environment variables, a secrets management system, or prompting for input in a more secure implementation.

## How to Run

Navigate to the directory where you saved the script and the generated `import_volumes.tf` file will reside.

### Running the Bash Script

1. Make the script executable:
`chmod +x import_powerstore_volumes.sh`

2. Run the script:
`./import_powerstore_volumes.sh`

### Running the Python Script

1. Ensure the `requests` library is installed (pip install requests).

2. Run the script:
`python import_powerstore_volumes.py`

Both scripts will print their progress to the console, including fetching data, generating the `.tf` file, running `terraform init`, and executing the `terraform import` commands.

## After Execution: Important Next Steps

The script automates the initial import process, but there are crucial manual steps you must perform afterward:

**1. Review the Generated `.tf` File:** Open the `import_volumes.tf` file. It now contains the provider configuration and empty resource blocks for each imported volume.

**2. Run `terraform plan`:** Execute `terraform plan` in the same directory. This command reads the Terraform state file (which now knows about the imported volumes) and compares it to your `.tf` configuration (which has empty resource blocks). The output will show you all the attributes (size, description, etc.) that Terraform sees in the imported state but are missing from your configuration file.

**3. Populate Resource Attributes:** Manually add the missing attributes shown in the `terraform plan` output to the corresponding resource blocks in your `import_volumes.tf` file.

**4. Re-run `terraform plan`:** Run `terraform plan` again. Repeat step 3 until the output shows "No changes. Your infrastructure matches the configuration."

**5. Verify State:** Check your Terraform state file (e.g., `terraform.tfstate`) to confirm the imported volumes are listed with their details.

**6. Implement Remote State:** Crucially for enterprise environments, configure a remote backend for your Terraform state (e.g., Powerscale S3) and migrate your state to it using `terraform init -migrate-state`. This is essential for collaboration, state locking, and durability.

By following these steps, you successfully bring your brownfield PowerStore volumes under Terraform management, laying the groundwork for future automation and IaC practices.
