#!/bin/bash

# buat folder utama
mkdir -p tech-test

# masuk ke folder utama
cd tech-test || exit

# buat subfolder
mkdir -p deployments scripts monitoring

# buat file di deployments
touch deployments/eshop-deployment.yaml
touch deployments/eshop-service.yaml
touch deployments/magento-values.yaml

# buat file di scripts
touch scripts/deploy.sh
touch scripts/rollback.sh
touch scripts/cleanup.sh

# buat file di monitoring
touch monitoring/alertmanager.yaml

# buat README
touch README.md

echo "✅ Struktur folder & file berhasil dibuat di ./tech-test/"


