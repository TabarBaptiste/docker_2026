# 🎤 Guide de Présentation du Projet

Ce document vous aide à préparer la présentation/démonstration de votre projet.

---

## 📋 Plan de Présentation (10-15 minutes)

### 1. Introduction (2 min)
- **Titre** : Mini-Application CRUD - Gestion de Produits
- **Équipe** : Les GOAT (AndriamHarena, Ibrahima)
- **Classe** : Docker - Promotion 2026
- **Objectif** : Application full-stack conteneurisée avec opérations CRUD

### 2. Architecture Technique (3 min)

**Technologies utilisées :**
- **Frontend** : React 18 + Webpack 5
- **Backend** : Node.js 18 + Express 4
- **Base de données** : MongoDB 7.0
- **Orchestration** : Docker Compose

**Architecture en 4 services :**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Frontend   │────▶│   Backend   │────▶│   MongoDB   │
│   (3000)    │     │   (5000)    │     │   (27017)   │
└─────────────┘     └─────────────┘     └─────────────┘
                                              │
                                              ▼
                                        ┌─────────────┐
                                        │Mongo Express│
                                        │   (8081)    │
                                        └─────────────┘
```

### 3. Démonstration en Direct (6 min)

#### Étape 1 : Démarrage de l'application (1 min)
```powershell
# Montrer cette commande
.\start.ps1 up

# Ou
docker-compose up -d
```

**Points à mentionner :**
- Tous les services démarrent automatiquement
- Les dépendances sont gérées (healthcheck MongoDB)
- Temps de démarrage : ~30 secondes

#### Étape 2 : Frontend - Interface utilisateur (2 min)
1. Ouvrir http://localhost:3000
2. **Montrer l'interface :**
   - Design moderne et responsive
   - Formulaire d'ajout
   - Liste des produits

3. **Démontrer les opérations :**
   - **CREATE** : Ajouter un produit via le formulaire
     - Nom : "Clavier Mécanique RGB"
     - Description : "Switches Cherry MX Red"
     - Prix : 129.99
     - Quantité : 15
   - **READ** : Le produit apparaît dans la liste
   - **DELETE** : Supprimer un produit avec le bouton 🗑️

#### Étape 3 : Backend - API REST (1 min)
1. Ouvrir un terminal
2. **Tester l'API :**
```powershell
# Vérifier la santé
curl http://localhost:5000/api/health

# Récupérer tous les produits
curl http://localhost:5000/api/products
```

**Points à mentionner :**
- 5 routes CRUD implémentées (GET, POST, PUT, DELETE)
- Validation des données
- Gestion des erreurs

#### Étape 4 : MongoDB - Visualisation des données (1 min)
1. Ouvrir http://localhost:8081
2. Login : `admin` / `admin123`
3. Naviguer : `products_db` → `products`
4. **Montrer :**
   - Tous les documents (produits)
   - Structure JSON
   - Possibilité de modifier manuellement

#### Étape 5 : Persistance des données (1 min)
```powershell
# Arrêter les services
docker-compose down

# Redémarrer
docker-compose up -d

# Attendre 10 secondes
Start-Sleep -Seconds 10

# Vérifier que les données sont toujours là
curl http://localhost:5000/api/products
```

**Point clé :** Les données persistent grâce au volume Docker `mongodb_data`

### 4. Points Techniques Clés (3 min)

#### Dockerisation
**Montrer les Dockerfiles :**
- [docker/backend/Dockerfile](docker/backend/Dockerfile)
- [docker/frontend/Dockerfile](docker/frontend/Dockerfile)

**Points à mentionner :**
- Images légères basées sur `node:18-alpine`
- Installation des dépendances
- Exposition des ports

#### Docker Compose
**Montrer [docker-compose.yml](docker-compose.yml)**

**Points à mentionner :**
- 4 services orchestrés
- Réseau commun `app-network`
- **Bind mounts** pour le hot-reload :
  ```yaml
  volumes:
    - ./backend:/app
    - /app/node_modules
  ```
- **Volume pour persistance** :
  ```yaml
  volumes:
    - mongodb_data:/data/db
  ```
- **Restart policy** : `unless-stopped` sur tous les services

#### Hot-Reload (Bind Mounts)
**Démonstration :**
1. Ouvrir [frontend/src/App.js](frontend/src/App.js)
2. Modifier le titre :
   ```javascript
   <h1>📦 Gestion de Produits - DEMO EN DIRECT</h1>
   ```
3. Sauvegarder
4. **Montrer :** Le navigateur se rafraîchit automatiquement
5. **Souligner :** Aucun rebuild d'image nécessaire !

### 5. Conclusion (1 min)

**Récapitulatif des réalisations :**
- ✅ Application CRUD full-stack fonctionnelle
- ✅ 4 services conteneurisés et orchestrés
- ✅ Persistance des données
- ✅ Hot-reload pour le développement
- ✅ Documentation complète

**Technologies maîtrisées :**
- Docker & Docker Compose
- React (Frontend)
- Node.js/Express (Backend)
- MongoDB (Base de données)

---

## 🎯 Points à Souligner

### Points Forts du Projet

1. **Architecture moderne et scalable**
   - Séparation frontend/backend
   - API REST
   - Microservices

2. **Expérience développeur optimale**
   - Hot-reload grâce aux bind mounts
   - Pas de rebuild nécessaire
   - Développement rapide

3. **Persistance des données**
   - Volume Docker pour MongoDB
   - Les données survivent aux redémarrages
   - Pas de perte de données

4. **Production-ready**
   - Redémarrage automatique (`restart: unless-stopped`)
   - Healthchecks
   - Variables d'environnement
   - Réseau isolé

5. **Documentation complète**
   - README détaillé
   - Guide de tests
   - Guide de démarrage rapide
   - Scripts d'automatisation

---

## 💡 Questions Fréquentes et Réponses

### Q1 : Pourquoi utiliser Docker ?
**R :** 
- Environnement cohérent entre développement et production
- Isolation des services
- Facilite le déploiement
- Reproductibilité

### Q2 : Comment fonctionnent les bind mounts ?
**R :** 
- Montage du code local dans le conteneur
- Modifications synchronisées en temps réel
- Pas besoin de rebuild pour voir les changements

### Q3 : Comment les données persistent-elles ?
**R :** 
- Volume Docker `mongodb_data` monté sur `/data/db`
- Le volume existe indépendamment du conteneur
- Survit aux `docker-compose down`

### Q4 : Peut-on déployer en production ?
**R :** 
- Oui, mais quelques modifications nécessaires :
  - Utiliser des secrets pour les mots de passe
  - Build production pour le frontend
  - Configurer un reverse proxy (nginx)
  - Ajouter HTTPS

### Q5 : Comment gérer plusieurs environnements ?
**R :** 
- Fichiers `.env` différents (.env.dev, .env.prod)
- Fichiers docker-compose différents
- Variables d'environnement spécifiques

---

## 🎬 Script de Démonstration

### Scénario : Gestion d'une boutique informatique

**Introduction :**
> "Nous allons démontrer une application de gestion de produits pour une boutique informatique. L'application permet d'ajouter, lister et supprimer des produits du stock."

**Étape 1 - Démarrage :**
```powershell
.\start.ps1 up
```
> "En une seule commande, nous démarrons 4 services : le frontend React, le backend Express, MongoDB et l'interface web Mongo Express."

**Étape 2 - Ajout de produits :**
1. Ouvrir http://localhost:3000
2. Ajouter ces produits :
   - Clavier Mécanique RGB - 129.99€ - 15 unités
   - Souris Gaming - 59.99€ - 25 unités
   - Casque Audio - 89.99€ - 10 unités

> "L'interface permet d'ajouter facilement des produits au stock. Les données sont immédiatement envoyées à l'API backend."

**Étape 3 - Consultation des données :**
1. Montrer la liste dans le frontend
2. Ouvrir http://localhost:8081
3. Naviguer vers les données

> "Nous pouvons voir les mêmes données dans l'interface MongoDB. Chaque produit est stocké comme document JSON avec son ID unique."

**Étape 4 - Test de persistance :**
```powershell
docker-compose down
docker-compose up -d
```
> "Même après redémarrage complet, les données sont préservées grâce au volume Docker."

**Étape 5 - Hot-reload :**
1. Modifier le code frontend
2. Montrer le changement instantané

> "Grâce aux bind mounts, les modifications du code sont visibles immédiatement sans rebuild."

---

## 📊 Métriques du Projet

- **Lignes de code** : ~600 lignes
- **Temps de démarrage** : ~30 secondes
- **Nombre de services** : 4
- **Ports utilisés** : 4 (3000, 5000, 8081, 27017)
- **Technologies** : 7 (React, Webpack, Babel, Node.js, Express, MongoDB, Docker)

---

## 🎯 Checklist Avant Présentation

- [ ] Tester l'application complètement
- [ ] Vérifier que tous les services démarrent
- [ ] Préparer des données de démonstration
- [ ] Tester le hot-reload
- [ ] Vérifier la persistance
- [ ] Relire la documentation
- [ ] Préparer les réponses aux questions
- [ ] Tester le script de démarrage
- [ ] Nettoyer les anciennes données de test
- [ ] Avoir un backup en cas de problème

---

## 🚀 Commandes de Présentation

```powershell
# Démarrage rapide
.\start.ps1 up

# Voir les logs
.\start.ps1 logs

# Voir l'état
.\start.ps1 status

# Redémarrer
.\start.ps1 restart

# Arrêter
.\start.ps1 down
```

---

**Bonne présentation ! 🎉**
