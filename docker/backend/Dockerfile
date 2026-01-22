# Dockerfile pour le backend Node.js
FROM node:18-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du code
COPY . .

# Exposer le port de l'API
EXPOSE 5000

# Commande de démarrage
CMD ["npm", "start"]
