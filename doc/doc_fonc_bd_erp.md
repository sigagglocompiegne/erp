![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)


# Documentation fonctionelle de la base de données des ERP (Etablissements Recevants du Public)

## 1. La hiérarchie des ERP

Les ERP sont organisés en **3 niveaux** :

| Niveau | Définition fonctionnelle | Géométrie propre |
|---|---|---|
| **Objet ERP** | Classe descriptive des ERP| non |
| **Procédure** | Classe descriptive des procédures administratives pour chaque ERP | non |
| **Evènement** | Classe descriptive des évènements internes à une procédure | non |

Chaque niveau hérite automatiquement de l'**identifiant** du niveau supérieur.

graph TD
    A[Objet ERP] --> B[Procédure 1]
    A --> C[Procédure 2]
    B --> D[Événement 1.1]
    B --> E[Événement 1.2]
    C --> F[Événement 2.1]
    C --> G[Événement 2.2]
