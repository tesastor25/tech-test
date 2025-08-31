#!/bin/bash
set -euo pipefail

# fungsi helper untuk pause
pause() {
  local seconds=$1
  echo "⏳ Waiting $seconds seconds..."
  sleep "$seconds"
}

echo "✅ Adding Helm repositories..."
helm repo add bitnami https://charts.bitnami.com/bitnami
pause 10
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
pause 10

# Deploy application services
for service in basket-api catalog-api identity-api ordering-api web; do
  echo "🚀 Deploying $service..."
  kubectl apply -f "../deployments/${service}.yaml"
  pause 10
done

# Deploy monitoring
echo "🚀 Deploying Alertmanager..."
kubectl apply -f ../monitoring/alertmanager.yaml
pause 10

# Deploy third-party dependencies
echo "🚀 Deploying MSSQL..."
kubectl apply -f ../deployments/mssql.yaml
pause 10

echo "🚀 Deploying RabbitMQ..."
kubectl apply -f ../deployments/rabbitmq.yaml
pause 10

echo "🚀 Deploying Magento..."
helm upgrade --install magento bitnami/magento -f ../deployments/magento-values.yaml
pause 10

echo "🚀 Deploying Prometheus..."
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack
pause 60


echo "🎉 All deployments finished successfully!"
