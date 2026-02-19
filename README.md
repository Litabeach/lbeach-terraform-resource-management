# Terraform Resource Management
This repository demonstrates advanced Terraform workflows including remote state management, environment promotion, drift reconciliation, and safe deployment strategies.

### 1. Remote State Usage
Initially, Terraform uses Local State, where the terraform.tfstate file lives on the developer's machine. This prevents collaboration and risks state loss.

Transition: By moving to Remote State, state is stored centrally in a shared, secure location. Terraform now automatically reads and writes to the backend during every plan and apply, ensuring a single source of truth.

Backend Key Strategy: To prevent environment overlap, a unique key is used for each environment:

Dev: dev.terraform.tfstate

Test: test.terraform.tfstate

### 2. Environment Strategy
This project utilizes a Modular Structure. Both dev and test environments call the same source code located in /modules, but they remain isolated through:

Separate State: Managed via unique backend keys.

Separate Inputs: Specific terraform.tfvars files for each environment define realese versions, environment, tags, and naming conventions.

### 3. Promotion Process
Promotion is Code-Driven. To promote a release from Dev to Test:

Verify the configuration in the dev environment.

Update the test.tfvars with the approved values/versions.

Run terraform plan -var-file="test.tfvars" to verify the delta.

Apply the changes to the test environment.

### 4. Refactor Strategy
To improve maintainability, resources were organized into a tiny_workload module.

State Preservation: Instead of destroying and recreating resources, moved blocks (or terraform state mv) were used to map the old resource addresses to the new module addresses, ensuring zero downtime.

### 5. Import Strategy
Resources created via the Azure CLI or Portal were brought under Terraform management using the import block.

Reconciliation: After importing the resource ID, terraform plan was used to identify missing attributes in the code. The configuration was updated iteratively until the plan showed "No changes."

### 6. Drift Practice
I practiced drift detection by manually altering resources outside of Terraform:

Storage Account: Toggled Public Network Access.

Tags: Renamed and added metadata tags.

Reconciliation: Ran terraform plan to detect the discrepancy and terraform apply to overwrite manual changes and restore the desired state.

### 7. Lifecycle + Safe Change
App Service Slot Strategy
For safe deployments, a Staging Slot was implemented.

Apply changes (code/settings) to the staging slot first.

Verify the slot's behavior.

Perform a swap to move staging to production, minimizing downtime.

Lifecycle Controls
prevent_destroy: Applied to the Storage Account and Service Plan to prevent accidental deletion of critical data/hosting.

ignore_changes: Applied to specific tags (e.g., LastScanned) that are managed by external Azure Policies, preventing Terraform from fighting automated system updates.

### 8. Provider Version Discipline
We treat the azurerm provider as a production dependency:

Pinning: Versions are locked (e.g., = 3.90.0) in the required_providers block.

Upgrading: Upgrades are intentional via terraform init -upgrade.

Rollback: If an upgrade fails, we revert the version constraint and re-init.

Lock File: The .terraform.lock.hcl is committed to Git to ensure every developer and CI/CD agent uses the exact same provider binaries and checksums.