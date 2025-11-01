# 🚀 Why You Need Packer for Azure Image Automation (Even When You Have Docker & Ansible)

## 🧰 Prerequisites

You only need:

- Azure CLI installed (`az version`)
- Packer 1.14 or later (`packer version`)
- Azure login access (`az login`)

Optional: a Service Principal if you want to run this from pipelines.

---

## ⚙️ Step 1 — Login and Select the subscription

```bash
az login
```

---

## 🗂️ Step 2 — Create Resource Group and Shared Image Gallery

```bash
az group create -n rg-packer-lab -l eastus2

az sig create \
  --resource-group rg-packer-lab \
  --gallery-name packerGallery \
  --location eastus2 \
  --description "Packer custom images"
```

---

## 🧱 Step 3 — Create the Image Definition (only once)

```bash
az sig image-definition create \
  -g rg-packer-lab -r packerGallery -i ubuntu-base \
  --publisher "CareerByteCode" --offer "UbuntuBase" --sku "22_04-lts-gen2" \
  --os-type Linux --hyper-v-generation V2 --location eastus2
```

📸 **Screenshot idea:** Azure Portal → Shared Image Gallery → `packerGallery` → `ubuntu-base` definition overview.

---

## 🧩 Step 4 — Initiate, Validate, and Build Base Image
```bash
packer init 01-create-base-image.pkr.hcl
packer validate 01-create-base-image.pkr.hcl
packer build 01-create-base-image.pkr.hcl
```

✅ Result: `ubuntu-base:1.0.0` (NGINX-preinstalled base image)

---

## 🔁 Step 5 — Create an Update Build (new version)

```bash
BASE_ID=$(az sig image-version list \
  --resource-group rg-packer-lab \
  --gallery-name packerGallery \
  --gallery-image-definition ubuntu-base \
  --query "sort_by([?publishingProfile.endOfLife==null], &publishingProfile.publishedDate)[-1].id" \
  -o tsv)
```

Run:
```bash
packer init -var "base_sig_image_id=$BASE_ID" 02-update-base-image.pkr.hcl
packer validate -var "base_sig_image_id=$BASE_ID" 02-update-base-image.pkr.hcl
packer build -var "base_sig_image_id=$BASE_ID" 02-update-base-image.pkr.hcl
```

✅ Result: `ubuntu-base:1.1.2510` — a new version of the same image with Docker installed.
