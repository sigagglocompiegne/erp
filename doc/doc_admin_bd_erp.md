# Documentation d'administration de la base de données des ERP (Etablissements Recevants du Public)
## Principes
 * **généralité** :

Dans le cadre d'une exigence gouvernementale accrue quant à la gestion des Etablissement Recevant du Public (ERP), la ville de Compiègne décide de renouveler son organisation et, plus particulièrement, sa gestion de l'information vis à vis des contrôles de sécurité et d'accessibilité de ses ERP. Les principaux objectifs de ce projet sont donc : la création et l'entretien d'un référentiel ERP et le développement d'une application web pour le service métier concerné. 

Cette BdD a été conçue à partir des réglementations propres à la ville de Compiègne. Elle est donc adaptée à ses besoins spécifiques, et n'a pas vocation à être un standard valable dans chaque collectivité.
 
 * **résumé fonctionnel** :

Pour rappel des grands principes :

* le modèle de données et l'application répondent à un besoin de gestion administrative des ERP
* la localisation des ERP s'appuie sur le référentiel Base Adresse Locale
* un contrôle est rattachée à un ERP et un seul
* une adresse peut disposer de n ERP
* un ERP peut-être partagée par plusieurs adresses
* l'application permet d'associer des documents

## Schéma fonctionnel

## Modèle relationel simplifié

## Dépendances

Cette base de données est dépendante de la Base Adresse Locale.

`[x_apps].[x_apps_geo_vmr_adresse]` : table géographique partagé des adresses

## Classes d'objets partagé et primitive graphique

`[m_erp_stage].[xapps_geo_vmr_erp]` : vue matérialisée géographique partagé avec la Base Adresse Locale permettant l'affichage et le fonctionnel au clic dans l'application. Cette vue remonte pour chaque adresse le nombre d'ERP ouverts et la conformité globale en fonction des derniers contrôles de sécurité et d'accessibilité.

|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|

Particularité(s) à noter :
* L'attribut `gid` sert de référence unique 
* Cette vue matérialisée est rafraichie automatiquement à chaque insertion, mise à jour ou suppression d'un ERP ou d'un contrôle.

## Classes d'objets ERP

L'ensemble des classes d'objets de gestion sont stockés dans le schéma `m_erp_stage`.

### Classes d'objets attributaire :

`[m_erp_stage].[an_erp_objet]` : table alphanumérique contenant les attributs métiers de l'ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idobjet|Identifiant des objets ERP|bigint|nextval('m_erp_stage.an_erp_objet_seq'::regclass)|
|id_adresse|Identifiant adresse|bigint| |
|libelle|Libellé des objets ERP|character varying(100)| |
|cat|Catégories des objets ERP|character varying(2)|'00'::character varying|
|erptype|Type des objets ERP|character varying(3)|'00'::character varying|
|erptype_2|Type secondaire des objets ERP|character varying(20)|'ZZ'::character varying|
|etat|Etat des objets ERP|character varying(2)|'00'::character varying|
|gestion|Caractérise le type de gestion de l'ERP|character varying(2)|'00'::character varying|
|groupement|Caractérise le type de groupement de l'ERP|character varying(2)|'00'::character varying|
|idobjet_maitre|ERP associé au groupement de l'ERP|bigint| |
|ephemere|Indique si l'ERP est éphémère|character varying(1)|'0'::character varying|
|eff_public|Effectif public de l'ERP|character varying(10)| |
|eff_nuit|Effectif nuit de l'ERP|character varying(10)| |
|eff_pers|Effectif personnel de l'ERP|character varying(10)| |
|eff_heberg|Effectif hebergement de l'ERP|character varying(10)| |
|eff_total|Effectif total de l'ERP|character varying(10)| |
|loc_som|Présence de local à sommeil des objets ERP|character varying(1)|'0'::character varying|
|siret|SIRET de l'ERP|character varying(14)| |
|d_ouvert|Date d'ouverture de l'ERP|timestamp without time zone| |
|d_ferme|Date de fermeture de l'ERP|timestamp without time zone| |
|observ|Observations diverses|character varying(254)| |
|op_sai|Opérateur de saisie de l'objet|character varying(80)| |
|op_maj|Opérateur de la dernière mise à jour de l'objet|character varying(80)| |
|date_sai|Horodatage d'insertion de la donnée dans la base|timestamp without time zone| |
|date_maj|Horodatage de la dernière mise à jour de la donnée dans la base|timestamp without time zone| |

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

`[m_erp_stage].[an_erp_accessibilite]` : table alphanumérique contenant les attributs métiers des contrôles d'accessibilité d'un ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id|Identifiant des controles de sécurité|bigint|nextval('m_erp_stage.an_erp_accessibilite_seq'::regclass)|
|idobjet|Identifiant de l'ERP controlé|bigint| |
|d_convoc|Date de la convocation|timestamp without time zone| |
|type_visite|Type de visite de l'ERP|character varying(2)|'00'::character varying|
|d_visite|Date de visite de l'ERP|timestamp without time zone| |
|expert|Expert qui participe au controle|character varying(2)|'00'::character varying|
|avis_expert|Avis de l'expert qui participe au controle|character varying(2)|'00'::character varying|
|d_avis_exp|Date de récéption de l'avis expert|timestamp without time zone| |
|commission|Commission qui participe au controle|character varying(2)|'00'::character varying|
|avis_com|Avis de la commission qui participe au controle|character varying(2)|'00'::character varying|
|d_avis_com|Date de récéption de l'avis expert|timestamp without time zone| |
|observ|Observations diverses|character varying(254)| |
|op_sai|Opérateur de saisie de l'objet|character varying(80)| |
|op_maj|Opérateur de la dernière mise à jour de l'objet|character varying(80)| |
|date_sai|Horodatage d'insertion de la donnée dans la base|timestamp without time zone| |
|date_maj|Horodatage de la dernière mise à jour de la donnée dans la base|timestamp without time zone| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_commission_fkey` (lien vers la liste de valeurs des commissions `lt_erp_controle_commission`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_expert_fkey` (lien vers la liste de valeurs des experts `lt_erp_controle_expert`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_exp_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_com_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)

* 1 triggers :
  * `t_t3_erp_refresh_adresse` : trigger permettant de rafraichir la vue matérialisée `m_erp_stage.xapps_geo_vmr_erp`

  ---

`[m_erp_stage].[an_erp_securite]` : table alphanumérique contenant les attributs métiers des contrôles de sécurité d'un ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id|Identifiant des controles de sécurité|bigint|nextval('m_erp_stage.an_erp_securite_seq'::regclass)|
|idobjet|Identifiant de l'ERP controlé|bigint| |
|d_convoc|Date de la convocation|timestamp without time zone| |
|type_visite|Type de visite de l'ERP|character varying(2)|'00'::character varying|
|d_visite|Date de visite de l'ERP|timestamp without time zone| |
|expert|Expert qui participe au controle|character varying(2)|'00'::character varying|
|avis_expert|Avis de l'expert qui participe au controle|character varying(2)|'00'::character varying|
|d_avis_exp|Date de récéption de l'avis expert|timestamp without time zone| |
|commission|Commission qui participe au controle|character varying(2)|'00'::character varying|
|avis_com|Avis de la commission qui participe au controle|character varying(2)|'00'::character varying|
|d_avis_com|Date de récéption de l'avis de la commission|timestamp without time zone| |
|observ|Observations diverses|character varying(254)| |
|op_sai|Opérateur de saisie de l'objet|character varying(80)| |
|op_maj|Opérateur de la dernière mise à jour de l'objet|character varying(80)| |
|date_sai|Horodatage d'insertion de la donnée dans la base|timestamp without time zone| |
|date_maj|Horodatage de la dernière mise à jour de la donnée dans la base|timestamp without time zone| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_commission_fkey` (lien vers la liste de valeurs des commissions  `lt_erp_controle_commission`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_expert_fkey` (lien vers la liste de valeurs des experts `lt_erp_controle_expert`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_exp_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)
* Une clé étrangère existe sur la table de valeur `lt_erp_controle_avis_com_fkey` (lien vers la liste de valeurs des conformités `lt_erp_controle_avis`)

* 1 triggers :
  * `t_t3_erp_refresh_adresse` : trigger permettant de rafraichir la vue matérialisée `m_erp_stage.xapps_geo_vmr_erp`

  ---

`[m_erp_stage].[an_erp_exploitant]` : table alphanumérique contenant les attributs de l'exploitant d'un ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idexploit|Identifiant de l'exploitant|bigint|nextval('m_erp_stage.an_erp_exploitant_seq'::regclass)|
|civilite|Civilite de l'expoitant|character varying(2)|'00'::character varying|
|nom|Nom de l'exploitant|character varying(100)| |
|prenom|Prenom de l'exploitant|character varying(100)| |
|coord_tel|Coordonnees telephonique de l'exploitant|character varying(10)| |
|mail|Mail de l'exploitant|character varying(100)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `idexploit` l'attribution automatique de la référence unique s'effectue via une séquence. 
* Une clé étrangère existe sur la table de valeur `lt_erp_exploitant_civilite_fkey` (lien vers la liste de valeurs des civilités  `lt_erp_exploitant_civilite`)

  ---

`[m_erp_stage].[an_erp_conf_secu]` : table alphanumérique contenant les paramètres des périodes à appliquer entre chaque contrôle de sécurité
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|erptype|Type d'ERP|character varying(3)| |
|cat1|Périodicité des contrôles de sécurité des ERP de catégorie 1 en fonction des types|integer| |
|cat2|Périodicité des contrôles de sécurité des ERP de catégorie 2 en fonction des types|integer| |
|cat3|Périodicité des contrôles de sécurité des ERP de catégorie 3 en fonction des types|integer| |
|cat4|Périodicité des contrôles de sécurité des ERP de catégorie 4 en fonction des types|integer| |
|cat5|Périodicité des contrôles de sécurité des ERP de catégorie 5 en fonction des types|integer| |
|date_sai|Date de saisie|timestamp without time zone| |
|date_maj|Date de mise à jour|timestamp without time zone| |
|op_sai|Opérateur de saisie|character varying(20)| |
|op_maj|Opérateur de msie à jour|character varying(20)| |

  ---

`[m_erp_stage].[an_erp_ctrl_media]` : table alphanumérique contenant le dictionnaire des documents joints à un contrôle
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id|Identifiant unique du média|bigint|nextval('m_erp_stage.an_erp_ctrl_media_gid_seq'::regclass)|
|iderpctrl|Identifiant du controle ERP (classe an_erp_securite et an_erp_accessibilite)|bigint| |
|media|Champ Média de GEO|text| |
|miniature|Champ miniature de GEO|bytea| |
|n_fichier|Nom du fichier|text| |
|t_fichier|Type de média dans GEO|text| |
|erp_doctyp|Type de documents des contrôles ERP (à faire)|character varying(2)|'00'::character varying|
|op_sai|Libellé de l'opérateur ayant intégrer le document|character varying(100)| |
|date_sai|Date d'intégration du document|timestamp without time zone| |
|date_creation|Date de création du document|timestamp without time zone|now()|

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence.
* Une clé étrangère existe sur la table de valeur `lt_erp_ctrl_media_doctyp_fkey` (lien vers la liste de valeurs sur le type de documents `lt_erp_ctrl_media_doctyp`)

  ---

`[m_erp_stage].[an_erp_objet_media]` : table alphanumérique contenant le dictionnaire des documents joints à un ERP
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id|Identifiant unique du média|bigint|nextval('m_erp_stage.an_erp_objet_media_gid_seq'::regclass)|
|idobjet|Identifiant de l'ERP (classe an_erp_objet)|bigint| |
|media|Champ Média de GEO|text| |
|miniature|Champ miniature de GEO|bytea| |
|n_fichier|Nom du fichier|text| |
|t_fichier|Type de média dans GEO|text| |
|erp_doctyp|Type de documents|character varying(2)|'00'::character varying|
|op_sai|Libellé de l'opérateur ayant intégrer le document|character varying(100)| |
|date_sai|Date d'intégration du document|timestamp without time zone| |
|date_creation|Date de création du document|timestamp without time zone|now()|

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence.
* Une clé étrangère existe sur la table de valeur `lt_erp_objet_media_doctyp_fkey` (lien vers la liste de valeurs sur le type de documents `lt_erp_objet_media_doctyp`)

---

`[m_erp_stage].[geo_erp_point_utilisateur]` : table géographique contenant les points créés par les utilisateurs
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idobjet|Identifiant de la localisation utilisateur|bigint|nextval('m_erp_stage.an_erp_objet_seq'::regclass)|
|x_l93|Coordonnées X en lambert 93|numeric| |
|y_l93|Coordonnées Y en lambert 93|numeric| |
|insee|Horodatage de la dernière mise à jour de la donnée dans la base|character varying(5)| |
|commune|Code insee de la commune|character varying(80)| |
|indications|Compléments de localisation|character varying(1000)| |
|geom|Géométrie du point|USER-DEFINED| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `idobjet` l'attribution automatique de la référence unique s'effectue via une séquence.

#### Liste de valeurs

`[m_erp_stage].[lt_erp_ctrl_avis]` : Liste de valeurs des conformités des contrôles d'accessibilité et de sécurité

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

`[m_erp_stage].[lt_erp_controle_commission]` : Liste de valeurs des commissions des contrôles d'accessibilité et de sécurité

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de commission des contrôles|character varying(2)| |
|valeur|Valeur des types de commission des contrôles|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|S.C.D.S.|
|20|Commission communale Compiègne|

---

`[m_erp_stage].[lt_erp_controle_expert]` : Liste de valeurs des experts des contrôles d'accessibilité et de sécurité

|Nom attribut | Définition |
|:---|:---|
|code|Code des experts participant aux contrôles|character varying(2)| |
|valeur|Valeur des experts participant aux contrôles|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|SDIS|
|20|Préfécture|
|99|Autre|

---

`[m_erp_stage].[lt_erp_controle_type_visite]` : Liste de valeurs des types de visite des contrôles d'accessibilité et de sécurité

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de visite|character varying(2)| |
|valeur|Valeur des types de visite|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Visite périodique|
|11|Visite de conformité|
|12|Visite inopinée|
|13|Visite d'ouverture|
|20|Réception de travaux|
|99|Autre|

---

`[m_erp_stage].[lt_erp_ctrl_media_doctyp]` : Liste de valeurs des types de média des contrôles d'accessibilité et de sécurité

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de média des contrôles d'accessibilité et de sécurité|character varying(2)| |
|valeur|Valeur des types de média des contrôles d'accessibilité et de sécurité|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Avis du SDIS|
|02|Avis de la préfecture|
|03|Arrété|
|99|Autre|

---

`[m_erp_stage].[lt_erp_exploitant_civilite]` : Liste de valeurs des civilités

|Nom attribut | Définition |
|:---|:---|
|code|Code des civilités|character varying(2)| |
|valeur|Valeur des civilités|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|11|Monsieur|
|12|Madame|
|20|Madame & Monsieur|
|21|Monsieur & Monsieur|
|22|Madame & Madame|
|30|Mesdames & Messieurs|
|99|Autre|

---

`[m_erp_stage].[lt_erp_gestion]` : Liste de valeurs des types de gestion des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de gestion des ERP|character varying(2)| |
|valeur|Valeur des types de gestion des ERP|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Opérateur public|
|20|Entreprise privée|

---

`[m_erp_stage].[lt_erp_groupement]` : Liste de valeurs des types de groupement des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de groupement des ERP|character varying(2)| |
|valeur|Valeur des types de groupement des ERP|text| |

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

`[m_erp_stage].[lt_erp_objet_cat]` : Liste de valeurs des catégories des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des catégories des ERP|character varying(2)| |
|valeur|Valeur des catégories des ERP|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|1|
|20|2|
|30|3|
|40|4|
|50|5|

---

`[m_erp_stage].[lt_erp_objet_erptype]` : Liste de valeurs des types des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des types des ERP|character varying(2)| |
|valeur|Valeur des types des ERP|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|J|Structures d'accueil pour personnes âgées et personnes handicapées|
|L|Salles d auditions, de conférences, de réunions, de spectacles ou polyvalentes|
|M|Magasins de vente, centres commerciaux|
|N|Restaurants et débits de boissons|
|O|Hôtels et pensions de famille|
|P|Salles de danses et salles de jeux|
|R|Établissements d'éveil, d'enseignement, de formation, centres de vacances, centres de loisirs sans hébergement|
|S|Bibliothèques, centres de documentation|
|T|Salles d expositions|
|U|Établissements sanitaires|
|V|Établissement de culte|
|W|Administrations, banques, bureaux|
|X|Établissements sportifs couverts|
|Y|Musées|
|EF|Établissements flottants|
|GA|Gares|
|PA|Établissements de plein air|
|PS|Parcs de stationnement couverts|
|SG|Structure gonflable|
|CTS|Chapiteaux, tentes et structures|
|OA|Hôtels-restaurants d altitude|
|REF|Refuges de montagne|
|ZZ|Non concerné|

---

`[m_erp_stage].[lt_erp_objet_etat]` : Liste de valeurs des etats des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des etats des ERP|character varying(2)| |
|valeur|Valeur des etats des ERP|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|10|Ouvert|
|20|Fermé temporairement|
|30|Fermé|

---

`[m_erp_stage].[lt_erp_objet_media_doctyp]` : Liste de valeurs des types de média des ERP

|Nom attribut | Définition |
|:---|:---|
|code|Code des types de média des ERP|character varying(2)| |
|valeur|Valeur des types de média des ERP|text| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|99|Autre|

### Classes d'objets attributaire gérant les associations (ou relation d'appartenance des objets entre eux) :

`[m_erp_stage].[lk_erp_localisation]` : table alphanumérique de relation entre les ERP et leurs localisations
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id|Identifiant interne non signifiant|bigint|nextval('lk_erp_localisation_seq'::regclass)|
|idobjet|Identifiant de l'ERP|bigint| |
|idloc|Identifiant de la localisation|bigint| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id` l'attribution automatique de la référence unique s'effectue via une séquence. 
 
---

### classes d'objets applicatives métiers (vue) :

  * xapps_an_v_erp_contsecu_periode : Vue matérialisée applicative calculant les dates des prochains contrôles à partir des derniers contrôles en fonction de leur nature et de leur conclusion de chaque ERP ouvert (rafraichie après chaque insertion ou mise à jour d'un contrôle)
  * xapps_geo_vmr_erp : Vue affichant les ERP saisis (pas de gestion) (à supprimer à la production, remplacé par xapps_geo_vmr_erp_gb)
  * xapps_geo_vmr_erp_adresse : Vue matérialisée rafraichie applicative le nombre d''ERP à l''adresse pour le fonctionnel de saisie GEO
  * xapps_geo_vmr_erp_gb : Vue affichant les ERP à l''adresse ou temporaire en présentant le nombre et le dernier état du contrôle de l''ensemble des ERP rpésents (l''état le plus mauvais qui s''affiche
 
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
