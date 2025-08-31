#!/bin/bash
set -euo pipefail

# fungsi helper untuk pause
pause() {
  local seconds=$1
  echo "⏳ Waiting $seconds seconds..."
  sleep "$seconds"
}

echo "⚠️ Starting rollback process..."

# Rollback Helm releases (Magento & Prometheus)
echo "↩️ Rolling back Magento (Helm)..."
helm rollback magento 1 || echo "Magento rollback failed or no previous revision"
pause 10

echo "↩️ Rolling back Prometheus (Helm)..."
helm rollback monitoring 1 || echo "Prometheus rollback failed or no previous revision"
pause 10

# Rollback application services (kubectl apply -f dengan versi lama)
# Asumsi kamu simpan YAML lama di folder ../rollback/<service>.yaml
for service in basket-api catalog-api identity-api ordering-api web; do
  if [[ -f "../rollback/${service}.yaml" ]]; then
    echo "↩️ Rolling back $service..."
    kubectl apply -f "../rollback/${service}.yaml"
    pause 10
  else
    echo "⚠️ Skip $service rollback (no rollback manifest found)"
  fi
done

# Rollback monitoring (alertmanager)
if [[ -f "../rollback/alertmanager.yaml" ]]; then
  echo "↩️ Rolling back Alertmanager..."
  kubectl apply -f ../rollback/alertmanager.yaml
  pause 10
else
  echo "⚠️ Skip Alertmanager rollback (no rollback manifest found)"
fi

# Rollback third-party dependencies (mssql & rabbitmq)
for dep in mssql rabbitmq; do
  if [[ -f "../rollback/${dep}.yaml" ]]; then
    echo "↩️ Rolling back $dep..."
    kubectl apply -f "../rollback/${dep}.yaml"
    pause 10
  else
    echo "⚠️ Skip $dep rollback (no rollback manifest found)"
  fi
done

echo "✅ Rollback process finished!"
