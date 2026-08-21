![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

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

Particularité(s) à noter :
* La vue [xapps_geo_vmr_erp] est rafraichie à chaque insertion ou mise à jour.
* La vue [xapps_geo_vmr_adresse_erp] est rafraichie à chaque insertion ou mise à jour d'une adresse dans la base du même nom.

## Classes d'objets ERP

L'ensemble des classes d'objets de gestion sont stockés dans le schéma `m_erp`.

### Classes d'objets attributaire :

`[m_erp].[an_erp_objet]` : table alphanumérique contenant les attributs métiers de l'ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
| Colonne | Description | Type | Valeur par défaut |
| idobjet | Identifiant des objets ERP | integer | nextval('m_erp.an_erp_objet_idobjet_seq'::regclass) |
| idadresse | Identifiant adresse | bigint |   |
| refrnb | Réference RNB | character varying(12) |   |
| refsdis | Réference SDIS | character varying(254) |   |
| libelle | Libellé des objets ERP | character varying(100) |   |
| cat | Catégories des objets ERP | character varying(1) | '0'::character varying |
| erptype | Type des objets ERP | character varying(3) | '00'::character varying |
| erptype_p | Précision sur le type des objets ERP | character varying(100) |   |
| erptype2 | Type secondaire des objets ERP | text |   |
| etat | Etat réel d'ouverture des objets ERP | character varying(2) | '00'::character varying |
| group | Caractérise le type de groupement de l'ERP | character varying(2) | '00'::character varying |
| idmaitre | ERP associé au groupement de l'ERP | integer |   |
| ephemere | Indique si l'ERP est éphémère | boolean | false |
| eff_public | Effectif public de l'ERP | integer |   |
| eff_nuit | Effectif nuit de l'ERP | integer |   |
| eff_pers | Effectif personnel de l'ERP | integer |   |
| eff_heberg | Effectif hebergement de l'ERP | integer |   |
| eff_total | Effectif total de l'ERP | integer |   |
| loc_som | Présence de locaux à sommeil | boolean | false |
| erp_src | Source de la saisie de l'ERP | character varying(2) | '00'::character varying |
| erp_public | Identifie l'ERP comme public | boolean | false |
| siret | SIRET de l'ERP | character varying(14) |   |
| ouvert_d | Date d'ouverture de l'ERP | date |   |
| ferme_d | Date de fermeture de l'ERP | date |   |
| ferme_src | Source de l'information sur la fermeture de l'ERP | character varying(254) |   |
| observ | Observations diverses | character varying(254) |   |
| op_sai | Opérateur de saisie de l'objet | character varying(80) |   |
| op_maj | Opérateur de la dernière mise à jour de l'objet | character varying(80) |   |
| dbstatut | Statut de l'objet dans la base | character varying(2) | '10'::character varying |
| dbinsert | Horodatage d'insertion de la donnée dans la base | timestamp without time zone |   |
| dbupdate | Horodatage de la dernière mise à jour de la donnée dans la base | timestamp without time zone |   |
| idobjet_enfant | Identifiant de l'objet enfant pour la saisie des relations uniquement (valeur remis à null après enregistrement) | integer |   |
| complt | Complément de localisation | text |   |
| eff_autre | Effectif non précisé dans la demande d'autorisation de travaux ou de PC | integer |   |
| etat_reg | Etat réglementaire des objets ERP (déduit par défaut des évènements). Modification manuelle possible. | character varying(2) | '00'::character varying |
| etat_manu | Gestion manuelle des états réglementaires | boolean | false |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` l'attribution automatique de la référence unique s'effectue via une séquence.
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_cat_fkey` (lien vers la liste de valeurs des catégories d'ERP `lt_erp_objet_cat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_erptype_fkey` (lien vers la liste de valeurs des types d'ERP `lt_erp_objet_erptype`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_etat_fkey` (lien vers la liste de valeurs de l'état d'ERP `lt_erp_objet_etat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_group_fkey` (lien vers la liste de valeurs du type de groupement d'ERP `lt_erp_objet_group`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_dbstatut_fkey` (lien vers la liste de valeurs des statuts `r_objet.lt_statut`)

* 8 triggers :
  * `t_t1_dbinsert` : trigger permettant d'insérer une date de saisie
  * `t_t2_dbupdate` : trigger permettant d'insérer une date de mise à jour
  * `t_t3_gestion_ctrl` : trigger permettant le contrôle de saisie et la saisie d'attributs automatisé
  * `t_t4_delete_histo` : trigger after permettant de supprimer les ERP de la table principale se trouvant dans la table historique
  * `t_t5_resp_unique` : trigger after insert permettant d'associer un responsable unique d'un groupement
  * `t_t6_etat_reg` : trigger permettant de gérer l'état réglementaire affiché
  * `t_t7_refresh` : trigger permettant de rafraichir les vues matérialisées
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

  ---

`[m_erp].[an_erp_cad]` : table alphanumérique gérant les références cadastrales associés à l'ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| id | Identifiant interne non signifiant pour chaque enregistrement | bigint | nextval('m_erp.an_erp_cad_id_seq'::regclass) |
| idobjet | Identifiant de l'objet ERP | integer |   |
| ccosec | Section cadastrale | character varying(2) |   |
| dnupla | Parcelle cadastrale | character varying(4) |   |
| dbinsert | Date de saisie | timestamp without time zone |   |
| dbupdate | Date de mise à jour | timestamp without time zone |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 

* 4 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_dbupdate` : trigger permettant de saisir la date de mise à jour
  * `t_t3_controle` : trigger permettant de contrôler les valeurs insérées
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_contact]` : table alphanumérique stockant les contacts liés aux ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idcontact | Identifiant du contact | bigint | nextval('m_erp.an_erp_contact_id_seq'::regclass) |
| denomination | Identité du contact (service, nom/prénom, etc. ) | character varying(254) |   |
| idorga | Identifiant de l'Organisme d'appartenance du contact | smallint |   |
| tel | Numéro de téléphone fixe du contact | character varying(10) |   |
| mobile | Numéro de téléphone mobile du contact | character varying(10) |   |
| email | Adresse email du contact | character varying(100) |   |
| observ | Commentaires | character varying(254) |   |
| dbstatut | Statut de l'objet | character varying(2) | '10'::character varying |
| op_sai | Opérateur de saisie initiale | character varying(80) |   |
| op_maj | Opérateur de mise à jour | character varying(80) |   |
| dbinsert | Date de saisie initiale | timestamp without time zone | now() |
| dbupdate | Date de mise à jour | timestamp without time zone | now() |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idcontact` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table `an_erp_orga_fkey` (liste des organismes issue de la table `an_erp_orga`)
* Une clé étrangère existe sur la table de valeur `lt_statut_fkey` (lien vers la liste de valeurs des statuts pour la corbeille `l r_objet.lt_statut`)
  
* 4 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_dbupdate` : trigger permettant de saisir la date de mise à jour
  * `t_t3_gestion_ctrl` : trigger permettant de contrôler les valeurs insérées
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_evenement]` : table alphanumérique stockant les évènements internes à chaque procédure déclarée à l'ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| ideve | Identifiant interne non signifiant pour chaque évènement | bigint | nextval('m_erp.an_erp_evenement_ideve_seq'::regclass) |
| idproc | Identifiant de la procédure | integer |   |
| typ | type d'évènement | character varying(2) |   |
| deve | date de l'évènement (date de l'avis, de l'arrêté, ...) | date |   |
| decision | décision lié à l'évènement | character varying(2) |   |
| op_sai | Opérateur de saisie de l'objet | character varying(80) |   |
| op_maj | Opérateur de la dernière mise à jour de l'objet | character varying(80) |   |
| dbinsert | Date de saisie | timestamp without time zone |   |
| dbupdate | Date de mise à jour | timestamp without time zone |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `ideve` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_eve_decision_fkey` (lien vers la liste de valeurs des décisions `lt_erp_eve_decision`)
* Une clé étrangère existe sur la table de valeur `lt_erp_eve_eve_fkey` (lien vers la liste de valeurs des évènements `lt_erp_eve`)
  
* 6 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_dbupdate` : trigger permettant de saisir la date de mise à jour
  * `t_t3_controle` : trigger permettant de contrôler les valeurs insérées
  * `t_t4_etat_reg` :  trigger permettant de gérer l'état réglementaire affiché
  * `t_t5_delete` :  trigger permettant de supprimer les médias quand un évènement est supprimé
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_evenement_media]` : table alphanumérique stockant les médias liés aux évènements
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| id | Identifiant unique du média | bigint | nextval('m_erp.an_erp_evenement_media_id_seq'::regclass) |
| ideve | Identifiant de l'ERP | bigint |   |
| media | Champ Média de GEO | text |   |
| miniature | Champ miniature de GEO | bytea |   |
| n_fichier | Nom du fichier | text |   |
| t_fichier | Type de média dans GEO | text |   |
| doctype | Type de documents | character varying(2) |   |
| op_sai | Libellé de l'opérateur ayant intégrer le document | character varying(80) |   |
| dbinsert | Horodatage d'insertion du média dans la base | timestamp without time zone | now() |
| adoc | Précision sur le type de documents si autre (99) indiqué dans l'attribut doctype | character varying(100) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `an_erp_evenement_media_typdoc_fkey` (lien vers la liste de valeurs des types de médias `lt_erp_eve_typdoc`)

  
* 3 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_controle_adoc` : trigger permettant de vérifier la saisie de la précision du document si autre choisit dans type de documents
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_log]` : table alphanumérique stockant les logs de chaque mouvement
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idlog | Identifiant unique | bigint | nextval('m_erp.an_erp_log_idlog_seq'::regclass) |
| tablename | Nom de la classe concernée par une opération | character varying(80) |   |
| typeope | Type d'opération | text |   |
| dataold | Anciennes données | text |   |
| datanew | Nouvelles données | text |   |
| dbinsert | Horodatage d'exécution de l'opération | timestamp without time zone | now() |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `idlog` l'attribution automatique de la référence unique s'effectue via une séquence. 
---

`[m_erp].[an_erp_objet_h]` : table alphanumérique stockant les objets ERP historisé
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idobjet | Identifiant des objets ERP | integer |   |
| idadresse | Identifiant adresse | bigint |   |
| refrnb | Réference RNB | character varying(12) |   |
| refsdis | Réference SDIS | character varying(254) |   |
| libelle | Libellé des objets ERP | character varying(100) |   |
| cat | Catégories des objets ERP | character varying(1) | '0'::character varying |
| erptype | Type des objets ERP | character varying(3) | '00'::character varying |
| erptype_p | Précision sur le type des objets ERP | character varying(100) |   |
| erptype2 | Type secondaire des objets ERP | text |   |
| etat | Etat des objets ERP | character varying(2) | '00'::character varying |
| group | Caractérise le type de groupement de l'ERP | character varying(2) | '00'::character varying |
| idmaitre | ERP associé au groupement de l'ERP | bigint |   |
| ephemere | Indique si l'ERP est éphémère | boolean | false |
| eff_public | Effectif public de l'ERP | integer |   |
| eff_nuit | Effectif nuit de l'ERP | integer |   |
| eff_pers | Effectif personnel de l'ERP | integer |   |
| eff_heberg | Effectif hebergement de l'ERP | integer |   |
| eff_total | Effectif total de l'ERP | integer |   |
| loc_som | Présence de locaux à sommeil | boolean | false |
| erp_src | Source de la saisie de l'ERP | character varying(2) | '00'::character varying |
| erp_public | Identifie l'ERP comme public | boolean | false |
| siret | SIRET de l'ERP | character varying(14) |   |
| ouvert_d | Date d'ouverture de l'ERP | date |   |
| ferme_d | Date de fermeture de l'ERP | date |   |
| ferme_src | Source de l'information sur la fermeture de l'ERP | character varying(254) |   |
| observ | Observations diverses | character varying(254) |   |
| op_sai | Opérateur de saisie de l'objet | character varying(80) |   |
| op_maj | Opérateur de la dernière mise à jour de l'objet | character varying(80) |   |
| dbstatut | Statut de l'objet dans la base | character varying(2) | '10'::character varying |
| dbinsert | Horodatage d'insertion de la donnée dans la base | timestamp without time zone |   |
| dbupdate | Horodatage de la dernière mise à jour de la donnée dans la base | timestamp without time zone |   |
| dbhisto | Horodatage de la date d'insertion dans la classe historique | timestamp without time zone |   |
| complt | Complément de localisation | text |   |
| eff_autre | Effectif non précisé lors d'une autorisaiton de travaux ou d'un PC | integer |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` 
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_cat_fkey` (lien vers la liste de valeurs des catégories d'ERP `lt_erp_objet_cat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_erptype_fkey` (lien vers la liste de valeurs des types d'ERP `lt_erp_objet_erptype`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_etat_fkey` (lien vers la liste de valeurs de l'état d'ERP `lt_erp_objet_etat`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_group_fkey` (lien vers la liste de valeurs du type de groupement d'ERP `lt_erp_objet_group`)
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_dbstatut_fkey` (lien vers la liste de valeurs des statuts `r_objet.lt_statut`)
  
* 1 trigger :
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_objet_media]` : table alphanumérique stockant les médias liés aux objets ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| id | Identifiant unique du média | integer | nextval('m_erp.an_erp_objet_media_id_seq'::regclass) |
| idobjet | Identifiant de l'ERP | bigint |   |
| media | Champ Média de GEO | text |   |
| miniature | Champ miniature de GEO | bytea |   |
| n_fichier | Nom du fichier | text |   |
| t_fichier | Type de média dans GEO | text |   |
| doctype | Type de documents | character varying(2) | '00'::character varying |
| op_sai | Libellé de l'opérateur ayant intégrer le document | character varying(80) |   |
| doc_sai_d | Date de création du document | date |   |
| dbinsert | Horodatage d'insertion du média dans la base | timestamp without time zone | now() |
| adoc | Précision sur le document joint (si 99 saisie dans doctype) | character varying(100) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `an_erp_evenement_media_typdoc_fkey` (lien vers la liste de valeurs des types de médias `lt_erp_eve_typdoc`)

  
* 3 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_controle_adoc` : trigger permettant de vérifier la saisie de la précision du document si autre choisit dans type de documents
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_orga]` : table alphanumérique stockant les organismes liés aux ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idorga | Identifiant de l'organisme | integer | nextval('m_erp.an_erp_orga_id_seq'::regclass) |
| type_orga | Liste de valeurs des types d'organisme (commune, EPCI, syndicat, etc...) | character varying(2) |   |
| nom_orga | Nom de l'organisme | character varying(254) |   |
| observ | Commentaires | character varying(254) |   |
| dbstatut | Statut de l'objet | character varying(2) | '10'::character varying |
| op_sai | Opérateur de saisie initiale | character varying(80) |   |
| op_maj | Opérateur de mise à jour | character varying(80) |   |
| dbinsert | Date de saisie initiale | timestamp without time zone | now() |
| dbupdate | Date de mise à jour | timestamp without time zone | now() ||


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idorga` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_type_orga_fkey` (lien vers la liste de valeurs des types d'organisme `lt_erp_type_orga`)
* Une clé étrangère existe sur la table de valeur `lt_statut_fkey` (lien vers la liste de valeurs de statut corbeille `r_objet.lt_statut`)

  
* 4 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_dbupdate` : trigger permettant de saisir la date de mise à jour
  * `t_t3_gestion_ctrl` : trigger permettant de vérifier la saisie et d'automatiser certains attributs
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_procedure]` : table alphanumérique stockant les procédures liés à chaque ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idproc | Identifiant interne non signifiant pour chaque procédure | bigint | nextval('m_erp.an_erp_procedure_idproc_seq'::regclass) |
| idobjet | Identifiant de l'objet ERP | integer |   |
| typ | Type de procédure | character varying(2) |   |
| ident | Numéro éventuel de la procédure | text |   |
| objet | Objet de la procédure | text |   |
| ddepot | Date de dépôt de la procédure | date |   |
| op_sai | Opérateur de saisie | character varying(80) |   |
| op_maj | Opérateur de mise à jour | character varying(80) |   |
| dbinsert | Date de saisie | timestamp without time zone |   |
| dbupdate | Date de mise à jour | timestamp without time zone |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idproc` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_procedure_fkey` (lien vers la liste de valeurs des types de procédures `lt_erp_procedure`)


  
* 5 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_dbupdate` : trigger permettant de saisir la date de mise à jour
  * `t_t3_etat_reg` :  trigger permettant de gérer l'état réglementaire affiché
  * `t_t4_delete` : trigger permettant de supprimer les médias liés à une procédure, ces évènements et les médias des évènements à la suppression d'une procédure
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[an_erp_procedure_media]` : table alphanumérique stockant les médias d'une procédure
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| id | Identifiant unique du média | bigint | nextval('m_erp.an_erp_procedure_media_id_seq'::regclass) |
| idproc | Identifiant de l'ERP | bigint |   |
| media | Champ Média de GEO | text |   |
| miniature | Champ miniature de GEO | bytea |   |
| n_fichier | Nom du fichier | text |   |
| t_fichier | Type de média dans GEO | text |   |
| doctype | Type de documents | character varying(2) |   |
| op_sai | Libellé de l'opérateur ayant intégrer le document | character varying(80) |   |
| dbinsert | Horodatage d'insertion du média dans la base | timestamp without time zone | now() |
| adoc | Précision sur le document joint (si 99 saisie dans doctype) | character varying(100) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `an_erp_procedure_media_typdoc_fkey` (lien vers la liste de valeurs des types de documents `lt_erp_proc_typdoc`)
  
* 3 triggers :
  * `t_t1_dbinsert` : trigger permettant de saisir la date de saisie
  * `t_t2_controle_adoc` : trigger permettant de vérifier la saisie de la précision du document si autre choisit dans type de documents
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

### Classes d'objets géographique :

`[m_erp].[geo_erp_userpoint]` : Classe d'objets de localisation utilisateur des ERP (ERP sans adresse correspondant à des ERP temporaires)
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idobjet | Identifiant de l'ERP localisé par un point utilisateur | bigint | nextval('m_erp.an_erp_objet_idobjet_seq'::regclass) |
| x_l93 | Coordonnée X (Lambert 93) | numeric(9,2) |   |
| y_l93 | Coordonnée Y (Lambert 93) | numeric(10,2) |   |
| insee | Code insee de la commune | character varying(5) |   |
| commune | Nom de la commune | character varying(80) |   |
| indication | Compléments de localisation | text |   |
| dbstatut | Statut de l'objet dans la base | character varying(2) | '10'::character varying |
| geom | Géométrie du point | geometry(Point,2154) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` l'attribution automatique de la référence unique s'effectue via une séquence. 
  
* 5 triggers :
  * `t_t1_gestion_ctrl` : trigger permettant de vérifier la saisie utilisateur et d'automatiser certains attributs
  * `t_t3_xy_l93` : trigger permettant de calculer automatiquement les coordonnées du point de localisation
  * `t_t4_insee_commune` : trigger permettant de déterminer automatiquement le code insee et le nom de la commune par rapport au point saisie
  * `t_t5_refresh` : trigger permettant de rafraichir les vues matérialisées
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

  ---
`[m_erp].[geo_erp_userpoint_h]` : Classe d'objets de localisation utilisateur des ERP (ERP sans adresse correspondant à des ERP temporaires) - historisation
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idobjet | Identifiant de l'ERP localisé par un point utilisateur | integer |   |
| x_l93 | Coordonnée X (Lambert 93) | numeric(9,2) |   |
| y_l93 | Coordonnée Y (Lambert 93) | numeric(10,2) |   |
| insee | Code insee de la commune | character varying(5) |   |
| commune | Nom de la commune | character varying(80) |   |
| indication | Compléments de localisation | text |   |
| dbstatut | Statut de l'objet dans la base | character varying(2) | '10'::character varying |
| geom | Géométrie du point | geometry(Point,2154) |   |
| dbhisto | Horodatage de la date d'insertion dans la classe historique | timestamp without time zone |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` l'attribution automatique de la référence unique s'effectue via une séquence. 
  
* 1 trigger :
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

### Classes d'objets de relation :

`[m_erp].[lk_an_erp_objet_histo]` : Classe d'objets de relation des ERP historisés
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| id | Identifiant de la relation historique | integer | nextval('m_erp.lk_an_erp_objet_histo_id_seq'::regclass) |
| idobjet_p | Identifiant de l'objet parent | integer |   |
| idobjet_e | Identifiant de l'objet enfant | integer |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
  
* 1 trigger :
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[lk_erp_contact]` : Classe d'objets de relation avec des contacts
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idlk | Identifiant unique de la relation | integer | nextval('m_erp.lk_erp_contact_id_seq'::regclass) |
| idobjet | Identifiant unique de l'objet | integer |   |
| idcontact | Identifiant unique ndu contact | integer |   |
| code_fonction | Code dde la fonction du contact | character varying(3) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idlk` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `an_erp_contact_fkey` (lien vers la table des contacts `an_erp_contact`)
* Une clé étrangère existe sur la table de valeur `an_erp_objet_fkey` (lien vers la table des objets ERP `an_erp_objet`)
* Une clé étrangère existe sur la table de valeur `lt_erp_contact_fonction_fkey` (lien vers la liste de valeurs des fonctions des contacts `lt_erp_contact_fonction`)

* 1 trigger :
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

---

`[m_erp].[lk_erp_orga]` : Classe d'objets de relation avec des organismes
   
|Nom attribut | Définition | Type | Valeurs par défaut |
| :--- | :--- | :--- | :--- |
| idlk | Identifiant unique de la relation | integer | nextval('m_erp.lk_erp_orga_id_seq'::regclass) |
| idobjet | Identifiant unique de l'objet | integer |   |
| idorga | Identifiant unique de l'organisme | integer |   |
| code_role | Code du role de l'organisme | character varying(3) |   |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idlk` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `an_erp_objet_fkey` (lien vers la table des objets ERP `an_erp_objet`)
* Une clé étrangère existe sur la table de valeur `an_erp_orga_fkey` (lien vers la table des organismes `an_erp_orga`)
* Une clé étrangère existe sur la table de valeur `lt_erp_orga_role_fkey` (lien vers la liste de valeurs des rôles `lt_erp_orga_role`)

* 1 trigger :
  * `t_t9_log` : trigger permettant d'insérer toutes opérations dans une table de log

#### Liste de valeurs

`[m_erp].[lt_erp_contact_fonction]` : Liste de valeurs des fonctions des contacts

|Nom attribut | Définition |
|:---|:---|
| code | Code de la classe décrivant la fonction | character varying(2) |   |
| valeur | Valeur de la classe décrivant la fonction | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Exploitant|
|02|Architecte|
|03|Technicien|
|04|Responsable unique|
|99|Autre|

---

`[m_erp].[lt_erp_eve]` : Liste de valeurs des évènements

|Nom attribut | Définition |
|:---|:---|
| code | Code de la classe décrivant le type d'évènements | character varying(2) |   |
| valeur | Valeur de la classe décrivant le type d'évènement | character varying(80) |   |
| tri | Attribut permettant de classer les évèvements dans l'ordre d'affichage souhaité dans GEO | smallint |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|PC Valant ERP (modificatif)|1|
|20|Avis du SDIS (sécurité pour 5ème catégorie sans sommeil|4|
|30|Arrêté d'autorisation de travaux|5|
|31|Arrêté de refus d'autorisation de travaux|6|
|32|Arrêté d'autorisation du permis de construire|7|
|33|Arrêté de refus du permis de construire|8|
|34|Arrêté d'ouverture|19|
|35|Arrêté de fermeture administrative provisoire|20|
|40|RVRAT|9|
|60|PV de la SCDC (sécurité)|2|
|61|PV de la SCDA (accessibilité)|3|
|62|PV de visite périodique|13|
|63|PV de visite inopinée|14|
|64|PV de réception de travaux|15|
|65|PV d'ouverture|16|
|66|PV de conformité|17|
|67|PV de réception de travaux/conformité|18|

---

`[m_erp].[lt_erp_eve_decision]` : Liste de valeurs des décisions des évènements

|Nom attribut | Définition |
|:---|:---|
| code | Code de la classe décrivant le type de décisions liés à un évènement | character varying(2) |   |
| valeur | Valeur de la classe décrivant le type de décisions liés à un évènement | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|Favorable|
|11|Favorable (avec prescription)|
|20|Défavorable|
|ZZ|Non concerné|

---

`[m_erp].[lt_erp_eve_typdoc]` : Liste de valeurs des types de documents des évènements

|Nom attribut | Définition |
|:---|:---|
| code | Code du type de documents joints | character varying(2) |   |
| valeur | Valeur du type de documents joints | character varying(255) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|Arrêté|
|20|Procès verbal|
|30|Avis du SDIS|
|99|Autre (à préciser)|

---

`[m_erp].[lt_erp_objet_cat]` : Liste de valeurs des catégories d'ERP

|Nom attribut | Définition |
|:---|:---|
| code | Code de la liste énumérée relative à la catégorie d'un ERP | character varying(1) |   |
| valeur | Valeur de la liste énumérée relative à la catégorie d'ERP | character varying(20) |   |
| descrip | Description de la liste énumérée relative à la catégorie d'un ERP | character varying(100) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|1|1|Au dessus de 1500 personnes|
|2|2|De 701 à 1500 personnes|
|3|3|De 301 à 700 personnes|
|4|4|Jusqu'à 300 personnes|
|5|5|Inférieur aux seuils fixés pour la 5e catégorie|

---

`[m_erp].[lt_erp_objet_erptype]` : Liste de valeurs des types d'ERP

|Nom attribut | Définition |
|:---|:---|
| code | Code de la liste énumérée relative au type d'ERP | character varying(3) |   |
| valeur | Valeur de la liste énumérée relative au type d'ERP | character varying(150) |   |
| tri | Ordre de tri de la liste énumérée relative au type d'ERP | integer |   |
| cle | Clé de liste UUID V4 pour le multi-valué permettant une recherche en like | text |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|e4cbbc85-72b9-456d-94fa-1c2928324c3a|
|CTS|Chapiteaux, tentes et structures|d6e0e679-842c-4d3f-9cd5-e92ff943d04b|
|EF|Établissements flottants|75c284e8-64e8-4737-b8a9-09e547f4e3dc|
|GA|Gares|f4b7b317-81f5-4197-b7b4-7b9a27093e8b|
|J|Structures d'accueil pour personnes âgées et personnes handicapées|f43dbff6-2259-4bba-94fc-e41782b1f1b6|
|L|Salles d'auditions, de conférences, de réunions, de spectacles ou polyvalentes|7f267c5a-57dc-4ba5-bb18-423b95a40acc|
|M|Magasins de vente, centres commerciaux|df15a441-cdca-4503-80b0-d60d2b4ede43|
|N|Restaurants et débits de boissons|44df23e4-bfa1-4c08-af5c-4f3219f6a699|
|O|Hôtels et pensions de famille|232995ce-9abe-419f-afa6-702b9e92b455|
|P|Salles de danses et salles de jeux|8b0b17f3-faa8-48d2-9c83-b897c284c82d|
|PA|Établissements de plein air|01994984-e941-4fed-833e-ef397777ad87|
|PS|Parcs de stationnement couverts|59ef1825-843d-4df9-a7ff-bc6fe71553a0|
|R|Établissements d'éveil, d'enseignement, de formation, centres de vacances, centres de loisirs sans hébergement|40b9a616-1efc-4fb9-98b1-c89a90f4333c|
|S|Bibliothèques, centres de documentation|70019419-a9e2-4589-a401-7c5e6175ef79|
|SG|Structure gonflable|50db47dd-af8d-421e-b476-a3bdb42a919d|
|T|Salles d'expositions|f7356e54-9ede-489f-a7c9-5aecaf2f944b|
|U|Établissements sanitaires|dc71596f-b78a-4b2f-aeee-493c92f51d56|
|V|Établissement de culte|51335594-fb3f-4177-a5ac-a99feeae4296|
|W|Administrations, banques, bureaux|bed6a009-7317-41e3-b37b-f198b88605d4|
|X|Établissements sportifs couverts|8a13ab60-fa35-4030-9fe4-809154d3417a|
|Y|Musées|eda18498-cdad-4cf8-8507-403414ef2744|

---

`[m_erp].[lt_erp_objet_etat]` : Liste de valeurs des états d'ERP

|Nom attribut | Définition |
|:---|:---|
| code | Code de la liste énumérée relative à l'état d'un ERP | character varying(2) |   |
| valeur | Valeur de la liste énumérée relative à l'état d'un ERP | character varying(30) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|En création|
|11|Autorisé|
|20|Ouvert|
|21|Ouvert (sans autorisation)|
|22|Ouvert (en attente conformité)|
|30|Fermé temporairement|
|31|Fermé|
|40|Refusé|

---

`[m_erp].[lt_erp_objet_group]` : Liste de valeurs des types de groupements d'ERP

|Nom attribut | Définition |
| code | Code de la liste énumérée relative à l'appartenance d'un ERP à un groupement | character varying(2) |   |
| valeur | Valeur de la liste énumérée relative à l'appartenance d'un ERP à un groupement | character varying(30) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|ERP indépendant|
|20|Membre d'un groupement|
|30|Maitre d'un groupement|

---

`[m_erp].[lt_erp_objet_media_doctype]` : Liste de valeurs des types de documents des objets ERP

|Nom attribut | Définition |
| code | Code de la liste énumérée relative au type de document (média) pour les ERP | character varying(2) |   |
| valeur | Valeur de la liste énumérée relative au type de document (média) pour les ERP | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Courrier|
|20|Plan|
|80|Photographie|
|99|Autre document|

---

`[m_erp].[lt_erp_objet_src]` : Liste de valeurs des sources d'inventaire des ERP

|Nom attribut | Définition |
| code | Code de la classe décrivant les sources d'idendification de l'ERP | character varying(2) |   |
| valeur | Valeur de la classe décrivant les sources d'idendification de l'ERP | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Procédure ERP|
|02|SDIS|
|03|Service de l'ARC|
|04|Insee-SIRENE|
|05|Presse|
|06|Réseaux sociaux|
|99|Autre|

---

`[m_erp].[lt_erp_orga_role]` : Liste de valeurs des rôles des organismes

|Nom attribut | Définition |
| code | Code de la classe décrivant le rôle | character varying(2) |   |
| valeur | Valeur de la classe décrivant le rôle | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Propriétaire|
|02|Nu-Propriétaire|
|03|Exploitant|
|04|Gestionnaire|
|99|Autre|

---

`[m_erp].[lt_erp_proc_typdoc]` : Liste de valeurs des types de documents de procédures rattachées aux ERP

|Nom attribut | Définition |
| code | Code du type de documents joints | character varying(2) |   |
| valeur | Valeur du type de documents joints | character varying(255) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|Permis de construire (PC)|
|20|Autorisation de travaux (AT)|
|99|Autre (à préciser)|

---

`[m_erp].[lt_erp_procedure]` : Liste de valeurs des procédures rattachées aux ERP

|Nom attribut | Définition |
| code | Code de la classe décrivant le type de procédure | character varying(2) |   |
| valeur | Valeur de la classe décrivant le type de procédure | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|Autorisation de travaux|
|20|PC valant ERP|
|30|Visite périodique|
|31|Visite inopinée|
|99|Autre|

---

`[m_erp].[lt_erp_type_orga]` : Liste de valeurs des types d'organisme

|Nom attribut | Définition |
| code | Code de la classe décrivant le type d'organisme | character varying(2) |   |
| valeur | Valeur de la classe décrivant le type d'organisme | character varying(80) |   |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Etat|
|02|Région|
|03|Département|
|04|Commune|
|05|Syndicat|
|06|Association|
|07|Privé|

---

### classes d'objets applicatives métiers (vue) :

  * xapps_geo_vmr_adresse_erp : Vue matérialisée applicative pour le fonctionnel de saisie/interrogation d'ERP à l'adresse dans GEO
  * xapps_geo_vmr_erp : Vue matérialisée applicative pour la visualisation des ERP à l'adresse et temporaire dans GEO

  * xapps_geo_v_erp_ferme_dispo : Vue listant les ERP par adresse non affecté à un ERP existant.
  * xapps_geo_v_erp_historise : Vue récursive permettant de récupérer pour chaque objet parent, tous les enfants (pour affichage de l'historique des ERP).
  * xapps_geo_v_erp_maitre : Vue listant les ERP maitre à l'adresse.
  * xapps_geo_v_erp_tab1 : Vue applicative du tableau bord pour les chiffres clés des ERP
  * xapps_geo_v_erp_tab2 : Vue applicative du tableau bord pour le graphique de répartition par typologie des ERP
 
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
