# 🧪 Guide de Tests et Validation

Ce document vous guide à travers les tests de validation du TP.

## ✅ Checklist de Validation

### 1. L'application fonctionne via le navigateur

#### Frontend (Interface utilisateur)
1. Ouvrir http://localhost:3000 dans le navigateur
2. ✅ Vérifier que la page s'affiche correctement
3. ✅ Vérifier que le design est responsive

**Résultat attendu :** Interface moderne avec un formulaire d'ajout et une liste de produits.

#### Backend (API)
1. Ouvrir http://localhost:5000/api/health dans le navigateur
2. ✅ Vérifier la réponse : `{"status":"OK","message":"API opérationnelle"}`

```bash
# Ou avec PowerShell
curl http://localhost:5000/api/health
```

---

### 2. Les opérations CRUD sont fonctionnelles

#### CREATE - Ajouter un produit

**Via l'interface :**
1. Remplir le formulaire avec :
   - Nom : "Clavier mécanique"
   - Description : "Clavier RGB"
   - Prix : 79.99
   - Quantité : 12
2. Cliquer sur "Ajouter le produit"
3. ✅ Le produit apparaît dans la liste

**Via l'API (PowerShell) :**
```powershell
$body = @{
    name = "Souris Gaming"
    description = "Souris RGB 16000 DPI"
    price = 59.99
    quantity = 8
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/products" -Method POST -Body $body -ContentType "application/json"
```

#### READ - Lire les produits

**Via l'interface :**
1. ✅ Tous les produits s'affichent automatiquement dans la liste

**Via l'API :**
```powershell
# Récupérer tous les produits
curl http://localhost:5000/api/products

# Ou avec Invoke-RestMethod (format plus lisible)
Invoke-RestMethod -Uri "http://localhost:5000/api/products" | ConvertTo-Json
```

#### UPDATE - Modifier un produit

**Via l'API :**
```powershell
# 1. Récupérer un ID de produit
$products = Invoke-RestMethod -Uri "http://localhost:5000/api/products"
$productId = $products[0]._id

# 2. Modifier le produit
$body = @{
    name = "Clavier mécanique Pro"
    description = "Clavier RGB avec switches Cherry MX"
    price = 99.99
    quantity = 15
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/products/$productId" -Method PUT -Body $body -ContentType "application/json"
```

**Vérification :**
- ✅ Le produit est mis à jour dans l'interface
- ✅ Les nouvelles valeurs s'affichent

#### DELETE - Supprimer un produit

**Via l'interface :**
1. Cliquer sur l'icône 🗑️ d'un produit
2. Confirmer la suppression
3. ✅ Le produit disparaît de la liste

**Via l'API :**
```powershell
# Récupérer un ID et supprimer
$products = Invoke-RestMethod -Uri "http://localhost:5000/api/products"
$productId = $products[0]._id

Invoke-RestMethod -Uri "http://localhost:5000/api/products/$productId" -Method DELETE
```

---

### 3. Les données sont visibles dans MongoDB Compass

#### Méthode 1 : Avec MongoDB Compass (application Desktop)

1. Télécharger et installer [MongoDB Compass](https://www.mongodb.com/products/compass)
2. Ouvrir MongoDB Compass
3. Se connecter avec : `mongodb://localhost:27017`
4. ✅ Naviguer vers `products_db` > `products`
5. ✅ Voir tous les produits ajoutés

#### Méthode 2 : Avec Mongo Express (Interface Web)

1. Ouvrir http://localhost:8081 dans le navigateur
2. Se connecter avec :
   - Username : `admin`
   - Password : `admin123`
3. ✅ Cliquer sur `products_db`
4. ✅ Cliquer sur `products`
5. ✅ Voir tous les documents (produits)

**Actions possibles :**
- Voir les données en format JSON
- Modifier des documents manuellement
- Supprimer des documents
- Ajouter de nouveaux documents

---

### 4. Les données persistent après redémarrage

#### Test de persistance

**Étape 1 : Ajouter des données**
```powershell
# Ajouter 3 produits
$produits = @(
    @{ name = "Produit Test 1"; price = 10.00; quantity = 5 },
    @{ name = "Produit Test 2"; price = 20.00; quantity = 10 },
    @{ name = "Produit Test 3"; price = 30.00; quantity = 15 }
)

foreach ($p in $produits) {
    $body = $p | ConvertTo-Json
    Invoke-RestMethod -Uri "http://localhost:5000/api/products" -Method POST -Body $body -ContentType "application/json"
}
```

**Étape 2 : Arrêter les conteneurs**
```powershell
docker-compose down
```
✅ Vérifier que tous les conteneurs sont arrêtés : `docker ps`

**Étape 3 : Redémarrer les conteneurs**
```powershell
docker-compose up -d
```

**Étape 4 : Vérifier les données**
```powershell
# Attendre 10 secondes que les services démarrent
Start-Sleep -Seconds 10

# Vérifier que les produits sont toujours là
Invoke-RestMethod -Uri "http://localhost:5000/api/products"
```

✅ **Résultat attendu :** Les 3 produits de test sont toujours présents.

**Note :** Pour supprimer définitivement les données :
```powershell
docker-compose down -v  # L'option -v supprime les volumes
```

---

### 5. Le code est modifiable sans rebuild (Bind Mounts)

#### Test du Hot-Reload Backend

**Étape 1 : Modifier le backend**
1. Ouvrir [backend/server.js](backend/server.js)
2. Trouver la route `/api/health` (ligne ~119)
3. Modifier le message :
```javascript
// Avant
res.json({ status: 'OK', message: 'API opérationnelle' });

// Après
res.json({ status: 'OK', message: 'API opérationnelle - MODIFICATION TEST' });
```

**Étape 2 : Vérifier sans rebuild**
```powershell
# Attendre 2-3 secondes (nodemon redémarre automatiquement)
Start-Sleep -Seconds 3

# Tester
curl http://localhost:5000/api/health
```

✅ **Résultat attendu :** Le nouveau message s'affiche **sans avoir reconstruit** l'image Docker.

#### Test du Hot-Reload Frontend

**Étape 1 : Modifier le frontend**
1. Ouvrir [frontend/src/App.js](frontend/src/App.js)
2. Trouver le titre (ligne ~93)
3. Modifier le texte :
```javascript
// Avant
<h1>📦 Gestion de Produits</h1>

// Après
<h1>📦 Gestion de Produits - TEST MODIFICATION</h1>
```

**Étape 2 : Vérifier dans le navigateur**
1. Ouvrir http://localhost:3000
2. ✅ Le titre est mis à jour automatiquement (en quelques secondes)
3. **Aucun rebuild nécessaire !**

#### Test des Styles CSS

**Étape 1 : Modifier les styles**
1. Ouvrir [frontend/src/styles.css](frontend/src/styles.css)
2. Modifier la couleur du header (ligne ~24) :
```css
/* Avant */
header h1 {
  color: #667eea;
  font-size: 2.5em;
  margin-bottom: 10px;
}

/* Après */
header h1 {
  color: #ff4757;  /* Rouge au lieu de violet */
  font-size: 2.5em;
  margin-bottom: 10px;
}
```

**Étape 2 : Vérifier**
- Retourner sur http://localhost:3000
- ✅ Le titre est maintenant rouge
- **Aucun rebuild nécessaire !**

---

## 📊 Résumé des Tests

| Test | Commande/Action | Résultat Attendu |
|------|----------------|------------------|
| ✅ Frontend accessible | Navigateur → http://localhost:3000 | Interface affichée |
| ✅ Backend accessible | `curl http://localhost:5000/api/health` | `{"status":"OK"}` |
| ✅ CREATE produit | Formulaire ou API POST | Produit ajouté |
| ✅ READ produits | Liste ou GET /api/products | Produits affichés |
| ✅ UPDATE produit | PUT /api/products/:id | Produit modifié |
| ✅ DELETE produit | Bouton 🗑️ ou DELETE | Produit supprimé |
| ✅ MongoDB Compass | http://localhost:8081 | Données visibles |
| ✅ Persistance | `docker-compose down` puis `up` | Données conservées |
| ✅ Hot-reload backend | Modifier server.js | Changement visible |
| ✅ Hot-reload frontend | Modifier App.js | Changement visible |

---

## 🔧 Commandes Utiles pour les Tests

```powershell
# Voir l'état des conteneurs
docker-compose ps

# Voir les logs en temps réel
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f backend

# Redémarrer un service
docker-compose restart backend

# Entrer dans un conteneur
docker-compose exec backend sh
docker-compose exec mongodb mongosh

# Vérifier les volumes
docker volume ls

# Inspecter un volume
docker volume inspect docker_2026_mongodb_data

# Nettoyer complètement (ATTENTION: supprime les données)
docker-compose down -v
docker system prune -a
```

---

## 🐛 Problèmes Courants

### Le frontend ne charge pas
```powershell
# Vérifier les logs
docker-compose logs frontend

# Reconstruire si nécessaire
docker-compose up --build frontend
```

### Le backend ne se connecte pas à MongoDB
```powershell
# Vérifier que MongoDB est démarré
docker-compose ps mongodb

# Vérifier les logs MongoDB
docker-compose logs mongodb

# Tester la connexion
docker-compose exec backend sh
# Puis dans le conteneur:
# nc -zv mongodb 27017
```

### Les modifications ne sont pas prises en compte
```powershell
# Vérifier les bind mounts
docker-compose config

# Redémarrer les services
docker-compose restart
```

---

## ✅ Validation Finale

Avant de considérer le TP comme terminé, assurez-vous que :

- [ ] Tous les services démarrent correctement avec `docker-compose up`
- [ ] Le frontend est accessible sur http://localhost:3000
- [ ] Le backend répond sur http://localhost:5000/api
- [ ] MongoDB Compass (Mongo Express) fonctionne sur http://localhost:8081
- [ ] Vous pouvez ajouter, lire, modifier et supprimer des produits
- [ ] Les données persistent après `docker-compose down` puis `up`
- [ ] Les modifications de code sont visibles sans rebuild
- [ ] Le README.md est complet et clair

**Félicitations ! Votre application CRUD conteneurisée est fonctionnelle ! 🎉**
