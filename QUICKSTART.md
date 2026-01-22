# Mini-Application CRUD - Guide de démarrage rapide

## 🚀 Démarrage en 3 étapes

1. **Installer Docker** (si ce n'est pas déjà fait)
   - Windows/Mac : https://www.docker.com/get-started
   - Vérifier l'installation : `docker --version`

2. **Lancer l'application**
   ```bash
   docker-compose up --build
   ```

3. **Accéder à l'application**
   - Frontend : http://localhost:3000
   - API : http://localhost:5000/api
   - MongoDB : localhost:27017

## 📝 Commandes essentielles

```bash
# Démarrer
docker-compose up

# Démarrer en arrière-plan
docker-compose up -d

# Arrêter
docker-compose down

# Voir les logs
docker-compose logs -f

# Reconstruire
docker-compose up --build
```

## 🔍 MongoDB Compass

Connexion string : `mongodb://localhost:27017`
Base de données : `products_db`
Collection : `products`

## ✅ Fonctionnalités implémentées

- ✅ Frontend React avec interface moderne
- ✅ Backend Node.js/Express avec API REST complète
- ✅ MongoDB pour la persistance
- ✅ Docker + docker-compose
- ✅ Bind mounts pour hot-reload
- ✅ Routes CRUD : GET, POST, PUT, DELETE

## 📖 Documentation complète

Voir [README.md](README.md) pour plus de détails.
