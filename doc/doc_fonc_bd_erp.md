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
```mermaid
graph TD
    A[Objet ERP] --> B[Procédure 1]
    A --> C[Procédure 2]
    B --> D[Événement 1.1]
    B --> E[Événement 1.2]
    C --> F[Événement 2.1]
    C --> G[Événement 2.2]
```
---
## 2. Les informations transverses liées à un objet ERP

Un objet ERP peut se voir rattacher les objets suivants :

```mermaid
flowchart TD
    ENT(("Objet ERP"))
    ORGA["Organisations<br/>+ role (proprietaire, exploitant...)"]
    CONTACT["Contacts<br/>+ fonction (exploitant, architecte, technicien, responsable unique, autre)"]
    FILIATION["Filiation"]
    MEDIA["Medias<br/>(photos, plans, documents)"]
    
    ENT --- ORGA
    ENT --- CONTACT
    ENT --- FILIATION
    ENT --- MEDIA

```

- **Organisations et rôles** : une même entité peut avoir plusieurs organisations rattachées, chacune avec un rôle (propriétaire, nu-propriétaire, exploitant, autre). Le système empêche d'attribuer deux fois le même rôle à la même organisation sur la même entité.
- **Contacts** : chaque contact rattaché à une entité a une fonction ((exploitant, architecte, technicien, responsable unique, autre). Même règle d'unicité que pour les organisations.
- **Filiation** : association particulière, une filiation ne peut s'effectuer uniquement si un ERP est d'abord fermé puis associé au nouvel ERP à la même adresse.
- **Médias** : photos, plans, notices techniques, devis, rapports d'expertise... rattachés librement à une entité.

Les classes attributaires des procédures et des évènements ont seulement les informations transverses de type médias.

---

## 3. Automatismes de saisie

L'essentiel de l'automatisme se situe au niveau de la génération de l'état réglementaire à partir de la saisie des procédures et des évènements.

```mermaid
flowchart TD
    A[Procédure avec événement ?] -->|Non| B[État : en création]
    A -->|Oui| C[Quel événement ?]

    %% Événements simples (sans sous-conditions)
    C -->|PC modificatif Valant ERP| D[État : en création]
    C -->|Arrêté d'autorisation| E[État : autorisé]
    C -->|Arrêté de refus| F[État : Refusé]
    C -->|Arrêté d'ouverture| G[État : ouvert]
    C -->|Arrêté de fermeture| H[État : Fermé temporairement]
    C -->|RVAT| I[État : en création]
    C -->|PV de sécurité ou accessibilité| J[État : en création]
    C -->|PV de réception de travaux| K[État : en création]
    C -->|Avis du SDIS ou Arrêté de refus ou Arrêté de fermeture| L[État : ouvert sans autorisation]

    %% Événements avec sous-conditions
    C -->|Avis du SDIS| M[Décision ?]
    M -->|Favorable ou Favorable avec prescription| N[État : autorisé]
    M -->|Défavorable| O[État : en création]

    C -->|PV de visite| P[Avis ?]
    P -->|Favorable ou Favorable avec prescription| Q[État : ouvert]
    P -->|Défavorable| R[État : Ouvert en attente conformité]

    C -->|PV d’ouverture| S[Avis ?]
    S -->|Favorable ou Favorable avec prescription| T[État : ouvert]
    S -->|Défavorable| U[État : en création]

    C -->|PV de conformité| V[Avis ?]
    V -->|Favorable ou Favorable avec prescription| W[État : ouvert]
    V -->|Défavorable| X[État : Ouvert en attente conformité]

    C -->|PV de réception de travaux/conformité| Y[Avis ?]
    Y -->|Favorable ou Favorable avec prescription| Z[État : ouvert]
    Y -->|Défavorable| AA[État : Ouvert en attente conformité]
```

---
## 4. La corbeille : suppression et restauration

Aucune donnée n'est perdue lors d'une première suppression. Cela fonctionne comme une corbeille à deux temps :

```mermaid
stateDiagram-v2
    [*] --> Actif : Creation de l'entite
    Actif --> Corbeille : 1ere suppression
    Corbeille --> Actif : Reactivation manuelle
    Corbeille --> [*] : 2eme suppression = definitive
```

- **1ère suppression** : l'entité passe simplement en statut « désactivé » (corbeille). Elle n'apparaît plus dans les vues actives mais toutes ses données restent en base.
  - **Effet en cascade** : désactiver un site désactive automatiquement tous les sous-sites, bâtiments, UF et locaux compris dans son emprise géographique qui étaient encore actifs. De même avec le fait de désactiver un bâtiment et ses UF et locaux.
- **Réactivation** : possible depuis la corbeille, à condition que l'entité **parente soit elle-même active** (impossible de réactiver un bâtiment si son site est toujours en corbeille — il faut réactiver le site en premier).
- **2ème suppression (depuis la corbeille)** : suppression **physique et définitive**. Dans ce cas, toutes les entités filles situées dans l'emprise géographique sont également supprimées définitivement, qu'elles soient actives ou déjà en corbeille.


