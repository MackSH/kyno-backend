FROM php:8.3-fpm

# 1. Installation des dépendances système (Linux)
# On installe git, curl, et les librairies pour traiter les images et la base de données
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    libzip-dev \
    zip \
    unzip

# 2. Nettoyage du cache (pour garder l'image légère)
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Installation des extensions PHP requises par Laravel & KYNO
# pdo_pgsql : Pour se connecter à PostgreSQL
# bcmath : Pour les calculs d'argent précis (Indispensable pour le 80/20)
# gd : Pour redimensionner les images/posters
# zip : Pour l'installation de paquets Composer
RUN docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd zip

# 4. Installation de Composer (Le gestionnaire de paquets PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Définition du dossier de travail
WORKDIR /var/www

# 6. Commande par défaut au démarrage du conteneur
CMD ["php-fpm"]