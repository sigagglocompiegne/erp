# Documentation d'administration de la base de données des ERP (Etablissements Recevants du Public)
## Principes
 * **généralité** :

Dans le cadre d'une exigence gouvernementale accrue quant à la gestion des Etablissement Recevant du Public (ERP), la ville de Compiègne décide de renouveler son organisation et, plus particulièrement, sa gestion de l'information vis à vis des contrôles de sécurité et d'accessibilité de ses ERP. Les principaux objectifs de ce projet sont donc : la création et l'entretien d'un référentiel ERP et le développement d'une application web pour le service métier concerné. 

Cette BdD a été conçue à partir des réglementations propres à la ville de Compiègne. Elle est donc adaptée à ses besoins spécifiques, et n'a pas vocation à être un standard valable dans chaque collectivité.
 
 * **résumé fonctionnel** :

Pour rappel des grands principes :

* le modèle de données et l'application répondent à un besoin de gestion administrative des ERP
* la localisation des ERP s'appuie sur le référentiel Base Adresse Locale
* une adresse peut disposer de n ERP
* chaque procédure administrative peut-être rattachée à un ERP (PC, autorisation de travaux, visites)
* chaque procédure peut être détaillée par des évènements propres (avis de sécurité, d'accessibilité, procès verbal de visite, arrêté d'ouverture, ...)
* chaque ERP dispose d'un état réel (constaté) et d'un état réglementaire
  
## Schéma fonctionnel

## Modèle relationnel simplifié

![spanc_mcd](/bdd/mrs_erp.png)

## Dépendances

Cette base de données est dépendante de la Base Adresse Locale.

`[r_adresse].[x_apps_geo_vmr_adresse]` : table géographique partagé des adresses

## Classes d'objets partagé et primitive graphique

`[m_erp].[xapps_geo_vmr_erp]` : vue matérialisée géographique partagé avec la Base Adresse Locale permettant l'affichage dans l'application. Cette vue remonte chaque adresse ou lieu (non adressé) localisant un ERP avec son état réglementaire.

`[m_erp].[xapps_geo_vmr_adresse_erp]` : vue matérialisée géographique partagé avec la Base Adresse Locale permettant la saisie/interrogation des ERP.

|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|

Particularité(s) à noter :
* L'attribut `gid` sert de référence unique 
* Cette vue matérialisée est rafraichie automatiquement à chaque insertion, mise à jour ou suppression d'un ERP ou d'un contrôle.

## Classes d'objets ERP

L'ensemble des classes d'objets de gestion sont stockés dans le schéma `m_erp`.

### Classes d'objets attributaire :

`[m_erp].[an_erp_objet]` : table alphanumérique contenant les attributs métiers de l'ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` l'attribution automatique de la référence unique s'effectue via une séquence.
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_cat_fkey` (lien vers la liste de valeurs des catégories d'ERP `lt_erp_objet_cat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_erptype_fkey` (lien vers la liste de valeurs des types d'ERP `lt_erp_objet_erptype`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_etat_fkey` (lien vers la liste de valeurs de l'état d'ERP `lt_erp_objet_etat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_gestion_fkey` (lien vers la liste de valeurs du type de gestion d'ERP `lt_erp_gestion`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_groupement_fkey` (lien vers la liste de valeurs du type de groupement d'ERP `lt_erp_groupement`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_loc_som_fkey` (lien vers la liste de valeurs booleen `lt_booleen`)

* 2 triggers :
  * `t_t1_erp_objet` : trigger permettant d'insérer toutes les modifications dans la table ERP
  * `t_t2_erp_refresh_adresse` : trigger permettant de rafraichir la vue matérialisée `m_erp_stage.xapps_geo_vmr_erp`

  ---

`[m_erp].[]` : table alphanumérique contenant les attributs métiers des contrôles d'accessibilité d'un ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_commission_fkey` (lien vers la liste de valeurs des commissions `lt_erp_controle_commission`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_expert_fkey` (lien vers la liste de valeurs des experts `lt_erp_controle_expert`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_exp_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_com_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)

* 1 triggers :
  * `t_t3_erp_refresh_adresse` : trigger permettant de rafraichir la vue matérialisée `m_erp_stage.xapps_geo_vmr_erp`

  ---

#### Liste de valeurs

`[m_erp].[lt_erp_ctrl_avis]` : Liste de valeurs des conformités des contrôles d'accessibilité et de sécurité

|Nom attribut | Définition |
|:---|:---|
|code|Code des conformités des contrôles|character varying(2)| |
|valeur|Valeur des conformités de conclusion des contrôles|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Défavorable|
|20|Sursis à statuer|
|30|Favorable|
|11|Favorable avec prescription|

---

---

### classes d'objets applicatives métiers (vue) :

  * xapps_an_v_erp_contsecu_periode : Vue matérialisée applicative calculant les dates des prochains contrôles à partir des derniers contrôles en fonction de leur nature et de leur conclusion de chaque ERP ouvert (rafraichie après chaque insertion ou mise à jour d'un contrôle)

 
### classes d'objets applicatives grands publics sont classés dans le schéma x_apps_public :

Sans objet

### classes d'objets opendata sont classés dans le schéma x_opendata :

Sans objet

## Projet QGIS pour la gestion

Sans objet

## Traitement automatisé mis en place (Workflow de l'ETL FME)

Sans objet

## Export Open Data

Sans objet


---
