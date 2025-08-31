#!/bin/bash
set -euo pipefail

echo "⚠️  Starting cleanup process..."

# Hapus aplikasi (service API)
for service in basket-api catalog-api identity-api ordering-api web; do
  echo "🗑️  Deleting $service..."
  kubectl delete -f "../deployments/${service}.yaml" --ignore-not-found
done
# Hapus third-party dependencies (yaml-based)
echo "🗑️  Deleting MSSQL..."
kubectl delete -f ../deployments/mssql.yaml --ignore-not-found

echo "🗑️  Deleting RabbitMQ..."
kubectl delete -f ../deployments/rabbitmq.yaml --ignore-not-found

# Hapus monitoring (alertmanager)
echo "🗑️  Deleting Alertmanager..."
kubectl delete -f ../monitoring/alertmanager.yaml --ignore-not-found

# Hapus Helm releases
echo "🗑️  Uninstalling Magento (Helm)..."
helm uninstall magento || true

echo "🗑️  Uninstalling Prometheus (Helm)..."
helm uninstall monitoring || true

echo "✅ Cleanup finished successfully!"
