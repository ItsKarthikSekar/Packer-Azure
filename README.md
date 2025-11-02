# 🚀 Why You Need Packer for Azure Image Automation (Even When You Have Docker & Ansible)

## Prerequisites

You only need:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (Latest version)
- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) (Latest version)
- Azure login access (`az login`)

Optional: a Service Principal if you want to run this from pipelines.

---

## Repository Structure

```
Packer-Azure/
├── scripts/                      # Shell scripts to sxecute in when build image
│   ├── create-base.sh            # Shell script to execute when build base image
│   └── update.base.sh            # Shell script to execute when build image with latest update
├── 01-create-base-image.pkr.hcl  # HCL script to build bas image as a initial image
├── 02-update-base-image.pkr.hcl  # HCL script to build new image using existing image with latest patches
├── default.pkrvars.hcl           # Default values such as Resource group, location, image name, version and so on
├── plugins.pkr.hcl               # Plugin defined
├── variables.pkr.hcl             # Required variables are defined
└── README.md                     
```

---

## Login and create resource to sto image gallery

### Step 1 - Login and Select the subscription

```bash
az login
```

---

### Step 2 - Create Resource Group and Shared Image Gallery

```bash
az group create -n rg-packer-lab -l eastus2

az sig create \
  --resource-group rg-packer-lab \
  --gallery-name packerGallery \
  --location eastus2 \
  --description "Packer custom images"
```

---

### Step 3 - Create the Image Definition (only once)

```bash
az sig image-definition create \
  -g rg-packer-lab -r packerGallery -i ubuntu-base \
  --publisher "CareerByteCode" --offer "UbuntuBase" --sku "24_04-lts-gen2" \
  --os-type Linux --hyper-v-generation V2 --location eastus2
```

📸 **Screenshot idea:** Azure Portal → Shared Image Gallery → `packerGallery` → `ubuntu-base` definition overview.

---

## Initiate, Validate, and Build Base Image
```bash
packer init .
packer validate -var-file=default.pkrvars.hcl -only=azure-arm.base .
packer build -var-file=default.pkrvars.hcl -only=azure-arm.base .
```

✅ Result: `ubuntu-base:1.0.0` (NGINX-preinstalled base image)

---

## Create an Update Build (new version)
Before build the image with latest update, make sure the version is update

### Step 1 - Execute the below command to get the latest version of the image and store it a variable to use it
```bash
BASE_ID=$(az sig image-version list \
  --resource-group rg-packer-lab \
  --gallery-name packerGallery \
  --gallery-image-definition ubuntu-base \
  --query "sort_by([?publishingProfile.endOfLife==null], &publishingProfile.publishedDate)[-1].id" \
  -o tsv)
```

### Step 2 - Run the below commands to validate and build the new image
```bash
packer validate -var="base_sig_image_id=$BASE_ID" -var-file=default.pkrvars.hcl -only=azure-arm.update .
packer build -var="base_sig_image_id=$BASE_ID" -var-file=default.pkrvars.hcl -only=azure-arm.update .
```

✅ Result: `ubuntu-base:1.1.0` - a new version of the same image with Docker installed.
