# Tech Test Kubernetes Deployment

Repo ini berisi manifest Kubernetes dan script otomatis untuk melakukan **deploy**, **rollback**, dan **cleanup** pada beberapa service, third-party dependencies, serta monitoring di Kubernetes cluster.

---

## 📂 Struktur Folder

```
tech-test/
├── deployments/
│   ├── basket-api.yaml
│   ├── catalog-api.yaml
│   ├── identity-api.yaml
│   ├── ordering-api.yaml
│   ├── web.yaml
│   ├── mssql.yaml
│   ├── rabbitmq.yaml
│   ├── redis.yaml
│   └── magento-values.yaml
├── monitoring/
│   └── alertmanager.yaml
├── scripts/
│   ├── deploy.sh
│   ├── rollback.sh
│   └── cleanup.sh
└── README.md
```

---

## 🚀 Deployment

Gunakan script `deploy.sh` untuk melakukan deployment:

```bash
cd scripts
chmod +x deploy.sh
./deploy.sh
```

### Yang dilakukan:
1. Menambahkan Helm repository:
   - Bitnami
   - Prometheus Community
2. Deploy **application services**:
   - basket-api, catalog-api, identity-api, ordering-api, web
3. Deploy **monitoring**:
   - Alertmanager
   - Prometheus (Helm chart)
4. Deploy **third-party dependencies**:
   - MSSQL
   - RabbitMQ
   - Magento (Helm chart)

---

## ↩️ Rollback

Gunakan script `rollback.sh` untuk melakukan rollback:

```bash
cd scripts
chmod +x rollback.sh
./rollback.sh
```

### Mekanisme rollback:
- **Helm release**:
  - `magento` → rollback ke revisi sebelumnya (`helm rollback magento 1`)
  - `monitoring` → rollback ke revisi sebelumnya (`helm rollback monitoring 1`)
- **YAML-based services**:
  - Script akan mencari manifest versi lama di folder `../rollback/<service>.yaml`
  - Jika file rollback tidak ditemukan → service dilewati (skip)

> ⚠️ Pastikan kamu menyimpan manifest versi lama di folder `rollback/` jika ingin rollback untuk resource YAML (contoh: `../rollback/catalog-api.yaml`).

---

## 🗑️ Cleanup

Gunakan script `cleanup.sh` untuk menghapus semua resource yang sudah di-deploy:

```bash
cd scripts
chmod +x cleanup.sh
./cleanup.sh
```

### Yang dilakukan:
1. Menghapus seluruh **application services**:
   - basket-api, catalog-api, identity-api, ordering-api, web
2. Menghapus **third-party dependencies**:
   - MSSQL
   - RabbitMQ
3. Menghapus **monitoring**:
   - Alertmanager
4. Uninstall **Helm release**:
   - Magento
   - Prometheus

---

## 🛠️ Prasyarat

- Kubernetes cluster aktif (minikube, kind, GKE, EKS, AKS, dsb.)
- `kubectl` sudah terkoneksi ke cluster (`kubectl config current-context`)
- `helm` sudah terinstall di lokal
- Akses internet untuk menarik chart dari repository Helm

---

## ✅ Tips

- Untuk melihat riwayat Helm release:
  ```bash
  helm history magento
  helm history monitoring
  ```

- Untuk rollback ke revisi tertentu:
  ```bash
  helm rollback magento <REVISION>
  helm rollback monitoring <REVISION>
  ```

- Untuk memastikan resource sudah jalan:
  ```bash
  kubectl get pods -A
  kubectl get svc -A
  ```

---

## 🎉 Alur Kerja

1. Jalankan `deploy.sh` → untuk melakukan deployment semua komponen.  
2. Jika terjadi error atau butuh kembali ke versi sebelumnya → jalankan `rollback.sh`.  
3. Jika ingin menghapus semua resource dari cluster → jalankan `cleanup.sh`.  

---
