README :

La structure du projet est la suivante : 
- un docker_compose qui pilote les conteneurs Docker (ici, mysql).
- un Dockerfile qui permet la création et la configuration du conteneur mysql.
- un fichier init.sql qui créer une base de données avec une table user. 
- un .env qui permet de définir les variables d'environnements du docker.

Afin de lancer le projet, à la racine du projet : 
- docker compose build
- docker compose up -d

Le conteneur mysql est crée au port défini dans la variable d'environnement. Afin de vérifier si le conteneur fonctionne : 

- docker compose ps => le conteneur devrait être visible et up.
- ouvrir votre visionneur de base de données favoris et entrer les informations suivantes : 
    - hote : 127.0.0.1 (ou localhost)
    - port : le port choisi dans le .env
    - user et password : choisi dans le .env
Une fois connecté, vous pourrez voir votre base de données et votre table user.