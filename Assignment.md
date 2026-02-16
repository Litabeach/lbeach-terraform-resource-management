# Week 5 — Terraform Resource Management (Day 2 Operations)
This week focuses on operating and evolving Terraform-managed infrastructure safely:
- Remote state (Azure Storage backend) and locking
- Environment isolation (dev/test) using the same codebase
- Promotion-by-change (apply the same change through environments)
- Safe refactors using moved blocks and/or state operations
- Importing existing resources into Terraform
- Drift detection and reconciliation
- Lifecycle controls and safe replacement strategies
- Provider pinning and upgrade discipline
---
## Folder Layout
Create this structure:
- modules/
  - tiny_workload/
    - main.tf
    - variables.tf
    - outputs.tf
- environments/
  - dev/
    - main.tf
    - dev.tfvars
  - test/
    - main.tf
    - test.tfvars
The module should create a small set of resources (at minimum):
- Resource group
- Storage account
- Storage container
Each environment should call the same module with different inputs (name suffix, tags, etc.).
Each environment must use a different backend key so the state is isolated.
---
# Assignment 1 — Remote State Backend (Azure Storage Blob) + Locking
Goal: Move from local state (terraform.tfstate on disk) to remote state stored in an Azure Storage blob with locking.
## Tasks
1) Create backend storage using Azure CLI:
- Create a resource group for state
- Create a Storage Account
- Create a blob container named: tfstate
2) Configure the azurerm backend in BOTH environments (dev and test), using separate keys:
- environments/dev uses key: dev.tfstate
- environments/test uses key: test.tfstate
3) Initialize Terraform:
- Run terraform init in environments/dev
- Run terraform init in environments/test
4) Demonstrate backend locking:
- In terminal A, run terraform apply in environments/dev (or any operation that holds a lock)
- In terminal B, attempt terraform plan or apply in environments/dev
## Verification
- The tfstate blob exists in the container.
- terraform plan/apply uses the remote state.
- Locking prevents concurrent writes.
---
# Assignment 2 — Environment Isolation (dev vs test) Using the Same Code
Goal: Use the same module and code patterns in both environments while keeping isolated state.
## Tasks
1) Implement the module (modules/tiny_workload) and call it from:
- environments/dev/main.tf
- environments/test/main.tf
2) Use different inputs in dev and test via tfvars:
- name_suffix differs (dev vs test)
- location can be the same, but names must be unique
- Ensure tags include assignment=assignment2
3) Apply dev then apply test:
- terraform plan + apply in environments/dev
- terraform plan + apply in environments/test
4) Destroy dev without impacting test:
- terraform destroy in environments/dev only
## Verification
- dev and test resources are distinct
- dev destroy does not delete test resources
---
# Assignment 3 — Promotion-by-Change
Goal: Promote a single intentional change from dev to test by updating Terraform inputs and applying in sequence.
Important: Promotion is code-driven.
- You do NOT change tags in the Azure portal for promotion.
- You change desired state in Terraform inputs (tfvars) for each environment.
## Tasks
1) Add a "release" tag in the module, driven by a variable:
- tag key: release
- value comes from var.release
2) In dev:
- set release = "0"
- apply
3) Promote release to dev:
- update environments/dev/dev.tfvars to release = "1"
- plan, then apply
4) Promote to test:
- update environments/test/test.tfvars to release = "1"
- plan, then apply
## Verification
- Plans show only the tag change (or the chosen change)
- Dev is updated first; test updated after dev succeeds
---
# Assignment 4 — Safe Refactor Without Recreation
Goal: Rename or restructure Terraform resource addresses without destroying/recreating the underlying Azure resources.
## Tasks
1) Pick one resource in the module to rename:
2) Add a moved block in the module to map old address to new address.
3) Run terraform plan in the environment where it exists.
- The plan must show no destroy/create for that resource.
- Apply if needed.
## Verification
- Terraform recognizes the moved resource and does not recreate it.
---
# Assignment 5 — Import / Adopt an Existing Resource
Goal: Create a resource outside Terraform using Azure CLI, then import it so Terraform manages it.
Resources (try each):
- Resource group
- Storage container
- Key Vault secret
## Tasks
1) Create the resource using Azure CLI.
2) Write Terraform code for that same resource in the appropriate environment folder (or module).
- Ensure name/location match exactly.
- Ensure tags are correct
3) Run terraform init (if not already done).
4) Import the resource into Terraform state:
- terraform import <resource_address> <azure_resource_id>
5) Run terraform plan.
- If differences appear, explain them.
6) Run terraform apply to reconcile to the desired state.
## Verification
- The imported resource appears in terraform state list.
- After reconciliation, terraform plan is clean (or only expected changes remain).
---
# Assignment 6 — Drift Detection and Reconciliation
Goal: Practice detecting drift and correcting it safely.
Important: Drift injection is the only time you may change resources outside Terraform for this assignment.
## Tasks
1) Pick at least TWO drift injection methods from the options below.
2) Apply drift using portal or az cli.
3) Run terraform plan and observe drift.
4) Reconcile drift using one of two approaches:
- Preferred: terraform apply to restore desired state
- Alternative: update Terraform code to match new intended state, then apply (must justify)
## Drift Injection Options (choose multiple)
Tags
- Change a tag value on any managed resource
- Rename a tag key
- Add an extra tag outside Terraform
Storage Account drift
- Toggle public network access (if managed in your config)
- Change minimum TLS version
- Change blob public access setting
- Add or remove a container manually
- Modify CORS settings (if managed)
Key Vault drift
- Add or delete a secret manually (if Terraform manages it)
- Change an access policy permission set (add/remove get/list/set)
- Toggle network access settings (if managed)
- Change relevant vault settings that are managed by Terraform
Azure SQL drift
- Change DB SKU/compute
- Toggle server public network access (if managed)
- Add/remove firewall rules (if present)
- Change tags on server or database
App Service / Function drift
- Change an app setting value
- Toggle HTTPS-only
- Change always_on (App Service)
- Modify VNet integration settings (if managed)
- Change runtime version (if managed)
Networking drift
- Change NSG rule priority/ports
- Add/remove NSG rule
- Associate/dissociate NSG to subnet
- Add/remove a route in route table
- Associate route table to a different subnet
## Verification
- terraform plan clearly detects drift
- reconcile returns the environment to intended state (or intentionally updates desired state)
---
# Assignment 7 — Lifecycle and Safe Replacement: App Service Slot Strategy + Lifecycle Controls
Goal: Learn safe change patterns and lifecycle controls, with an emphasis on App Service slot-based strategy.
## Part A — App Service slot-based safe change strategy
1) Ensure an App Service exists (can be a minimal plan/app).
2) Create a deployment slot with Terraform.
3) Configure at least ONE app setting that differs between production and staging.
4) Demonstrate a safe change workflow:
- Apply a change to the staging slot first (configuration/app setting)
- Verify staging behaves as expected
- Document the intended slot swap step (or perform a swap if included in your workflow)
## Part B — Lifecycle controls (prevent_destroy, ignore_changes)
Choose at least TWO of the following and demonstrate:
1) prevent_destroy
- Add prevent_destroy to a safe resource (e.g., storage container or RG)
- Attempt terraform destroy and observe the failure
- Remove prevent_destroy and destroy successfully (optional)
2) ignore_changes
- Choose a tag key and ignore changes to it
- Change that tag outside Terraform
- terraform plan should NOT attempt to revert it
## Verification
- Lifecycle behavior matches expectation
---
# Assignment 8 — Provider Pinning + Upgrade Drill (with explicit steps)
Goal: Treat provider versions as production dependencies: pin, lock, upgrade intentionally, verify, and rollback.
## Part 1 — Pin and lock
1) Add required_providers constraint for azurerm (pre-upgrade version range).
2) Run terraform init (no upgrade).
3) Confirm .terraform.lock.hcl exists.
4) Commit code + .terraform.lock.hcl.
## Part 2 — Upgrade deliberately
5) Update ONLY the azurerm version constraint to a newer allowed range (post-upgrade).
6) Run terraform init -upgrade.
7) Confirm .terraform.lock.hcl changed.
8) Run terraform plan.
9) Do NOT apply if unexpected diffs appear; investigate and document why.
## Part 3 — Rollback drill
10) Roll back to the previous constraint (git checkout/revert).
11) Run terraform init (no upgrade).
12) Run terraform plan to confirm behavior restored.
---
# README Change Requirement (Week 5)
Write a README that includes:
1) Remote state usage
- Explain what local state is and what changes when moving to remote state.
- Explain that Terraform reads/writes state from the backend automatically.
- Include your backend key strategy (dev/test).
2) Environment strategy
- Explain how dev/test use the same module code but separate state and separate inputs.
3) Promotion process
- Document the steps you used to promote release from dev to test (code-driven via tfvars).
4) Refactor strategy
- Document what you refactored and how moved blocks/state operations prevented recreation.
5) Import strategy
- Document what you created via CLI, how you imported it, and how you reconciled differences.
6) Drift practice
- List which drift injections you performed and how you reconciled.
7) Lifecycle + safe change
- Document your App Service slot approach for safe changes.
- Document which lifecycle controls you used and why.
8) Provider version discipline
- Document your pin/upgrade/rollback steps and why the lock file is committed.