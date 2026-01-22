# 🚀 Mini-Application CRUD - Guide de Démarrage Rapide

## ⚡ Démarrage en 3 étapes

### 1. Installer Docker

Si ce n'est pas déjà fait :

- **Windows/Mac** : https://www.docker.com/get-started
- **Vérifier** : `docker --version` et `docker-compose --version`

### 2. Lancer l'application

```bash
docker-compose up --build
```

⏱️ **Temps de démarrage** : 2-3 minutes la première fois

### 3. Accéder aux services

| Service | URL | Identifiants |
|---------|-----|--------------|
| 🎨 **Frontend** | http://localhost:3000 | - |
| 🔌 **API Backend** | http://localhost:5000/api | - |
| 🗄️ **Mongo Express** | http://localhost:8081 | admin / admin123 |
| 💾 **MongoDB** | mongodb://localhost:27017 | - |

---

## 📋 Ports Utilisés

| Port | Service | Description |
|------|---------|-------------|
| **3000** | Frontend React | Interface utilisateur |
| **5000** | Backend API | API REST Node.js/Express |
| **8081** | Mongo Express | Interface web MongoDB |
| **27017** | MongoDB | Base de données |

**⚠️ Attention** : Assurez-vous que ces ports sont libres avant de démarrer.

---

## 📝 Commandes Essentielles

### Démarrage et arrêt

```bash
# Démarrer tous les services
docker-compose up

# Démarrer en arrière-plan
docker-compose up -d

# Arrêter tous les services
docker-compose down

# Arrêter ET supprimer les données (⚠️)
docker-compose down -v
```

### Surveillance

```bash
# Voir les logs en temps réel
docker-compose logs -f

# Voir l'état des conteneurs
docker-compose ps

# Voir les logs d'un service
docker-compose logs -f backend
```

### Maintenance

```bash
# Redémarrer tous les services
docker-compose restart

# Reconstruire les images
docker-compose up --build
```

---

## ✅ Fonctionnalités Disponibles

### Frontend (http://localhost:3000)

- ✅ Afficher la liste des produits
- ✅ Ajouter un nouveau produit via le formulaire
- ✅ Supprimer un produit (bouton 🗑️)
- ✅ Interface responsive et moderne

### Backend (http://localhost:5000/api)

- ✅ `GET /api/products` - Liste tous les produits
- ✅ `GET /api/products/:id` - Récupère un produit
- ✅ `POST /api/products` - Crée un produit
- ✅ `PUT /api/products/:id` - Modifie un produit
- ✅ `DELETE /api/products/:id` - Supprime un produit
- ✅ `GET /api/health` - Vérifie la santé de l'API

### Mongo Express (http://localhost:8081)

- ✅ Visualiser les données
- ✅ Ajouter/Modifier/Supprimer des documents
- ✅ Exécuter des requêtes MongoDB
- 🔐 **Credentials** : `admin` / `admin123`

---

## 🧪 Test Rapide

### 1. Vérifier que tout fonctionne

```powershell
# Vérifier l'API
curl http://localhost:5000/api/health

# Devrait retourner: {"status":"OK","message":"API opérationnelle"}
```

### 2. Ajouter un produit de test

```powershell
$body = @{
    name = "Produit Test"
    description = "Description du test"
    price = 29.99
    quantity = 10
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/products" -Method POST -Body $body -ContentType "application/json"
```

### 3. Vérifier dans l'interface

- Ouvrir http://localhost:3000
- Le produit "Produit Test" devrait apparaître ✅

### 4. Vérifier dans Mongo Express

- Ouvrir http://localhost:8081
- Login : `admin` / `admin123`
- Aller dans `products_db` → `products`
- Le produit est visible ✅

---

## 🔥 Hot-Reload (Bind Mounts)

Les modifications du code sont automatiquement prises en compte **sans rebuild** !

### Tester le Hot-Reload

**Backend :**

1. Modifier [backend/server.js](backend/server.js)
2. Sauvegarder
3. Attendre 2 secondes (nodemon redémarre)
4. ✅ Changement visible immédiatement

**Frontend :**

1. Modifier [frontend/src/App.js](frontend/src/App.js) ou [frontend/src/styles.css](frontend/src/styles.css)
2. Sauvegarder
3. Le navigateur se rafraîchit automatiquement
4. ✅ Changement visible immédiatement

---

## 🔍 Vérification de la Persistance

```bash
# 1. Ajouter des données via l'interface
#    (ajoutez quelques produits)

# 2. Arrêter les conteneurs
docker-compose down

# 3. Redémarrer
docker-compose up -d

# 4. Attendre 10 secondes
Start-Sleep -Seconds 10

# 5. Vérifier que les données sont toujours là
curl http://localhost:5000/api/products
```

✅ **Résultat attendu** : Les produits sont toujours présents !

---

## 🐛 Problèmes Fréquents

### Port déjà utilisé

```bash
# Trouver le processus qui utilise le port
netstat -ano | findstr :3000

# Changer le port dans docker-compose.yml si nécessaire
```

### Les conteneurs ne démarrent pas

```bash
# Voir les logs
docker-compose logs

# Nettoyer et redémarrer
docker-compose down -v
docker-compose up --build
```

### Modifications non visibles

```bash
# Redémarrer le service concerné
docker-compose restart backend
docker-compose restart frontend
```

---

## 📖 Documentation Complète

Pour plus de détails, consultez :

- **[README.md](README.md)** - Documentation complète du projet
- **[TESTS.md](TESTS.md)** - Guide de tests et validation

---

## 🎯 Checklist Rapide

Avant de considérer le TP terminé :

- [ ] `docker-compose up` démarre sans erreur
- [ ] Frontend accessible sur http://localhost:3000
- [ ] Backend accessible sur http://localhost:5000/api
- [ ] Mongo Express accessible sur http://localhost:8081
- [ ] Les 4 services apparaissent dans `docker-compose ps`
- [ ] Peut ajouter/supprimer des produits
- [ ] Les données persistent après `docker-compose down` puis `up`
- [ ] Le hot-reload fonctionne (modif code → visible sans rebuild)

---

## 🎉 Félicitations !

Votre application CRUD full-stack conteneurisée est opérationnelle !

**Prochaines étapes :**

1. Tester toutes les fonctionnalités CRUD
2. Vérifier la persistance des données
3. Valider le hot-reload
4. Consulter [TESTS.md](TESTS.md) pour les tests détaillés
