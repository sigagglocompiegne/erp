/**ERP V0.1.0*/
/*Creation du fichier complet*/
/* init_db_erp.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteurs : Florent Vanhoutte*/

/*
#################################################################### SUIVI CODE SQL ####################################################################

2023-01-25 : FV / initialisation du code

*/



/*
ToDo :

il faut éclater les controles secu et accessibiltié pour des flux et réglementation séparée.
Voir si on a un table controle générale où on type si secu, access ou les 2 ou si on a de façon séparée les contoles sécu, les controneles access
il faut prévoir un volet urbanisme AT ou PC ERP avec numéro, décision sdis+ddt


bdd :
- 
- voir si succesion état (ouvert, fermé, réouverture ...) est un élément à conserver ou non
- geo_erp_objet : prévoir champ pour lien avec parcelle (fonctionnel comme pour adresse) ?  parcelles d'assise ou parcelles dossier AT ?
- geo : geoloc est celle obligatoirement de l'adresse ou au choix avec précision de la position. ca dépendra peut être aussi si on récupère des données ou si on produit de 0 ? 
- geo/an_erp_objet/ctrl : prévoir champ sur refurba et voir si lié à l'ERP ou controle (cas ouverture par ex)
- prévoir si possible de déterminer de façon auto la catégorie en fonction info nécessaire (principalement sur conditions du catégorie 5 avec suivi)
- question sur géom si du bati (lien vers cadastre ? bdtopo ? ref bati ?)
- prévoir question délai controle en fonction catégorie 3 (cat 1 à 4) ou 5 ans (cat 5 spécifique)
- prévoir un verrou iderp-ctrl_date pour s'assurer qu'on ne puisse pas saisir 2 ctrl à la meme date
- stat : prévoir pour les différents calculs stats, valeur absolue (nombre) + pourcentage (part)
- gérer l'interval de controle de suivi par une variable (à déterminer selon critère légaux)
- sequence : start à 1 et pas 0
- prb fct et trigger
- voir pour log pour traiter les faux delete (update) en précisant que si NEW.etat = '3' (sûpprimé) alors on va stocker une procédure identifiée comme un DELETE dans le log (ou alors on laisse en update ..)
- op_sai,op_maj,dbinsert,dbupdate a prévoir pour les contrôles
- prévoir reset anomalie quand decis_avis est conforme '02'
- revoir les cas de liste d'anomalie et les cas selon les avis type défavorable partiel ou sursuis à statuer

app :
- données ctx
- voir si injection sirene geolocalisé pour faire apparaitre nouveau commerce (autorisation nécessaire)

*/



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SUPPRESSION                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ## VUE
DROP VIEW IF EXISTS m_erp.xapps_an_v_erp_objet_nb_quartier;
DROP VIEW IF EXISTS m_erp.xapps_an_v_erp_objet_nb_categorie;
DROP VIEW IF EXISTS m_erp.xapps_an_v_erp_objet_nb_decis_avis;
DROP VIEW IF EXISTS m_erp.xapps_an_v_erp_ctrl_synthese;

-- ## CONTRAINTES
ALTER TABLE IF EXISTS m_erp.an_erp_ctrl DROP CONSTRAINT IF EXISTS geo_erp_objet_fkey;
ALTER TABLE IF EXISTS m_erp.an_erp_ctrl_media DROP CONSTRAINT IF EXISTS an_erp_ctrl_fkey;

-- ## CLASSE
DROP TABLE IF EXISTS m_erp.geo_erp_objet;
DROP TABLE IF EXISTS m_erp.an_erp_ctrl;

-- ## MEDIA
DROP TABLE IF EXISTS m_erp.an_erp_ctrl_media;

-- ## LOG
DROP TABLE IF EXISTS m_erp.an_erp_log;


-- ## DOMAINE DE VALEUR
-- geo_erp_objet
DROP TABLE IF EXISTS m_erp.lt_erp_objet_erp_type;
DROP TABLE IF EXISTS m_erp.lt_erp_objet_categorie;
DROP TABLE IF EXISTS m_erp.lt_erp_objet_groupement;
DROP TABLE IF EXISTS m_erp.lt_erp_objet_etat;
DROP TABLE IF EXISTS m_erp.lt_erp_boolean;
-- an_erp_ctrl
DROP TABLE IF EXISTS m_erp.lt_erp_ctrl_decis_avis;
DROP TABLE IF EXISTS m_erp.lt_erp_ctrl_anomalie;
DROP TABLE IF EXISTS m_erp.lt_erp_ctrl_dde_src;
-- an_erp_ctrl_media
DROP TABLE IF EXISTS m_erp.lt_erp_ctrl_media_doctyp;

-- ## SEQUENCE
-- ev
DROP SEQUENCE IF EXISTS m_erp.geo_erp_objet_iderp_seq;
DROP SEQUENCE IF EXISTS m_erp.an_erp_ctrl_iderpctrl_seq;
DROP SEQUENCE IF EXISTS m_erp.an_erp_ctrl_media_gid_seq;
DROP SEQUENCE IF EXISTS m_erp.an_erp_log_idlog_seq;

-- trigger
DROP FUNCTION IF EXISTS m_erp.ft_m_erp_objet();
DROP FUNCTION IF EXISTS m_erp.ft_m_erp_ctrl();
DROP FUNCTION IF EXISTS m_erp.ft_m_erp_log();

 -- ## SCHEMA
DROP SCHEMA IF EXISTS m_erp;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- SCHEMA: m_erp

-- DROP SCHEMA m_erp;

CREATE SCHEMA m_erp;

COMMENT ON SCHEMA m_erp IS 'Base de données métiers sur le thème des Etablissement Recevant du Public (ERP)';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINE  DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# lt_erp_objet_erp_type ###############################################

-- ajout de la table de liste "lt_erp_objet_erp_type"

CREATE TABLE  m_erp.lt_erp_objet_erp_type
(
	code character varying(5) NOT NULL,
	valeur character varying(254) NOT NULL,
	CONSTRAINT lt_erp_objet_erp_type_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_erp_type IS 'Liste permettant de décrire le type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erp_type.code IS 'Code de la liste énumérée relative au type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erp_type.valeur IS 'Valeur de la liste énumérée relative relative au type d''ERP';
COMMENT ON CONSTRAINT lt_erp_objet_erp_type_pkey ON m_erp.lt_erp_objet_erp_type IS 'Clé primaire du domaine de valeur lt_erp_objet_erp_type';

INSERT INTO m_erp.lt_erp_objet_erp_type(
            code, valeur)
    VALUES
  ('NR','Non renseigné'),
  ('CTS','Chapiteaux, tentes et structures'),
  ('EF','Etablissements flottants'),
  ('EP','Etablissement pénitentiaire'),
  ('GA','Gares'),
  ('J','Structures d''accueil pour personnes âgées et personnes handicapées'),
  ('L','Salles d''auditions, de conférences, de réunions, de spectacles ou à usage multiple'),
  ('M','Magasins de vente, centres commerciaux'),
  ('N','Restaurants et débits de boissons'),
  ('NALT','Restaurant d''altitude'),
  ('O','Hôtels et pensions de famille'),
  ('OA','Hôtels-restaurants d''altitude'),
  ('P','Salles de danse et salles de jeux'),
  ('PA','Etablissements de plein air'),
  ('PE','Petits ERP, de 5ème catégorie'),
  ('PN','Petits ERP, de 5ème catégorie, spécificités petits restaurants et debits de boissons'),
  ('PO','Petits ERP, de 5ème catégorie, spécificités petits hôtels'),
  ('PS','Parcs de stationnement couverts'),
  ('PU','Petits ERP, de 5ème catégorie, spécificités petits établissements de soins'),
  ('PX','Petits ERP, de 5ème catégorie, spécificités petits établissements sportifs'),
  ('R','Etablissements d''éveil, d''enseignement, de formation, centres de vacances, centres de loisirs sans hébergement'),
  ('REF','Refuges de montagne'),
  ('REF1','Refuges de montagne non gardés'),
  ('REF2','Refuges de montagne gardés'),
  ('RH','Etablissements d''éveil, d''enseignement, de formation, centres de vacances, centres de loisirs avec hébergement'),
  ('S','Bibliothèques, centres de documentation'),
  ('SG','Structures gonflables'),
  ('T','Salles d''expositions'),
  ('U','Etablissements sanitaires'),
  ('V','Etablissements de culte'),
  ('W','Administrations, banques, bureaux'),
  ('X','Etablissements sportifs couverts'),
  ('Y','Musées'),
  ('ZZ','Non concerné');


-- ################################################################# lt_erp_objet_categorie ###############################################

-- ajout de la table de liste "lt_erp_objet_categorie"

CREATE TABLE  m_erp.lt_erp_objet_categorie
(
	code character varying(1) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_objet_categorie_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_categorie IS 'Liste permettant de décrire la catégorie d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_categorie.code IS 'Code de la liste énumérée relative à la catégorie d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_categorie.valeur IS 'Valeur de la liste énumérée relative à la catégorie d''ERP';
COMMENT ON CONSTRAINT lt_erp_objet_categorie_pkey ON m_erp.lt_erp_objet_categorie IS 'Clé primaire du domaine de valeur lt_erp_objet_categorie';

INSERT INTO m_erp.lt_erp_objet_categorie(
            code, valeur)
    VALUES
  ('0','Non renseigné'),    
  ('1','Au dessus de 1500 personnes'),
  ('2','De 701 à 1500 personnes'),
  ('3','De 301 à 700 personnes'),
  ('4','Jusqu''à 300 personnes'),
  ('5','Inférieur aux seuils fixés pour la 5e catégorie');



-- ################################################################# lt_erp_objet_groupement ###############################################

-- ajout de la table de liste "lt_erp_objet_groupement"

CREATE TABLE  m_erp.lt_erp_objet_groupement
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_objet_groupement_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_groupement IS 'Liste permettant de type de groupement d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_groupement.code IS 'Code de la liste énumérée relative au type de groupement d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_groupement.valeur IS 'Valeur de la liste énumérée relative au type de groupement d''un ERP';
COMMENT ON CONSTRAINT lt_erp_objet_groupement_pkey ON m_erp.lt_erp_objet_groupement IS 'Clé primaire du domaine de valeur lt_erp_objet_groupement';

INSERT INTO m_erp.lt_erp_objet_groupement(
            code, valeur)    VALUES
  ('00','Non renseigné'),    
  ('01','Isolé'),
  ('02','Maître d''un groupement isolé'),
  ('03','Membre d''un groupement isolé'),  
  ('04','Maître d''un groupement non isolé'), 
  ('05','Membre d''un groupement non isolé'); 

-- ################################################################# lt_erp_objet_etat ###############################################

-- ajout de la table de liste "lt_erp_objet_etat"

CREATE TABLE  m_erp.lt_erp_objet_etat
(
	code character varying(1) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_objet_etat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_etat IS 'Liste permettant de décrire les différents états des objets ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_etat.code IS 'Code de la liste énumérée relative à l''état des objets ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_etat.valeur IS 'Valeur de la liste énumérée relative à l''état des objets ERP';
COMMENT ON CONSTRAINT lt_erp_objet_etat_pkey ON m_erp.lt_erp_objet_etat IS 'Clé primaire du domaine de valeur lt_erp_objet_etat';

INSERT INTO m_erp.lt_erp_objet_etat(
            code, valeur)
    VALUES
  ('0','Non renseigné'),
  ('1','Projet'),  
  ('2','Ouvert'),
  ('3','Fermé'),
  ('4','Fermeture partielle'),
  ('5','Ephémère'),
  ('6','Itinérant');


-- ################################################################# lt_erp_ctrl_dde_src ###############################################

-- ajout de la table de liste "lt_erp_ctrl_dde_src"

CREATE TABLE  m_erp.lt_erp_ctrl_dde_src
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_ctrl_dde_src_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_ctrl_dde_src IS 'Liste permettant de décrire l''origine du contrôle';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_dde_src.code IS 'Code de la liste énumérée relative à l''origine du contrôle';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_dde_src.valeur IS 'Valeur de la liste énumérée relative à l''origine du contrôle';
COMMENT ON CONSTRAINT lt_erp_ctrl_dde_src_pkey ON m_erp.lt_erp_ctrl_dde_src IS 'Clé primaire du domaine de valeur lt_erp_ctrl_dde_src';

INSERT INTO m_erp.lt_erp_ctrl_dde_src(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('01','Réception de travaux'),
  ('02','Visite de conformité'),   
  ('03','Visite périodique'),
  ('04','Visite ponctuelle'),
  ('99','Autre');


-- ################################################################# lt_erp_ctrl_decis_avis ###############################################

-- ajout de la table de liste "lt_erp_ctrl_decis_avis"

CREATE TABLE  m_erp.lt_erp_ctrl_decis_avis
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_ctrl_decis_avis_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_ctrl_decis_avis IS 'Liste permettant de décrire la décision de la commission de sécurité';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_decis_avis.code IS 'Code de la liste énumérée relative à la décision de la commission de sécurité';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_decis_avis.valeur IS 'Valeur de la liste énumérée relative à la décision de la commission de sécurité';
COMMENT ON CONSTRAINT lt_erp_ctrl_decis_avis_pkey ON m_erp.lt_erp_ctrl_decis_avis IS 'Clé primaire du domaine de valeur lt_erp_ctrl_decis_avis';

INSERT INTO m_erp.lt_erp_ctrl_decis_avis(
            code, valeur)
    VALUES
  ('00','Non renseigné'),    
  ('01','Favorable'),
  ('02','Défavorable'),
  ('03','Défavorable partiel'),  
  ('04','Sursis à statuer');
  
  
-- ################################################################# lt_erp_ctrl_media_doctyp ###############################################

-- ajout de la table de liste "lt_erp_ctrl_media_doctyp"

CREATE TABLE  m_erp.lt_erp_ctrl_media_doctyp
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_ctrl_media_doctyp_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_ctrl_media_doctyp IS 'Liste permettant de décrire le type de documents (média) pour les contrôles d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_media_doctyp.code IS 'Code de la liste énumérée relative au type de document (média) pour les contrôles d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_media_doctyp.valeur IS 'Valeur de la liste énumérée relative au type de document (média) pour les contrôles d''ERP';
COMMENT ON CONSTRAINT lt_erp_ctrl_media_doctyp_pkey ON m_erp.lt_erp_ctrl_media_doctyp IS 'Clé primaire du domaine de valeur lt_erp_ctrl_media_doctyp';

INSERT INTO m_erp.lt_erp_ctrl_media_doctyp(
            code, valeur)
    VALUES
  ('00','Non renseigné'),    
  ('01','Avis du SDIS'),
  ('02','Avis de la préfecture'),
  ('03','Arrété'),  
  ('99','Autre');


-- ################################################################# lt_erp_ctrl_anomalie ###############################################

-- ajout de la table de liste "lt_erp_ctrl_anomalie"

CREATE TABLE  m_erp.lt_erp_ctrl_anomalie
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_ctrl_anomalie_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_ctrl_anomalie IS 'Liste permettant de décrire les anomalies relevées lors de la commission de sécurité';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_anomalie.code IS 'Code de la liste énumérée relative aux anomalies relevées lors de la commission de sécurité';
COMMENT ON COLUMN m_erp.lt_erp_ctrl_anomalie.valeur IS 'Valeur de la liste énumérée relative aux anomalies relevées lors de la commission de sécurité';
COMMENT ON CONSTRAINT lt_erp_ctrl_anomalie_pkey ON m_erp.lt_erp_ctrl_anomalie IS 'Clé primaire du domaine de valeur lt_erp_ctrl_anomalie';

INSERT INTO m_erp.lt_erp_ctrl_anomalie(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
-- liste à développer d'anomalie     
  ('99','Autre'),
  ('ZZ','Non concerné'); -- cas où controle est conforme

-- ################################################################# lt_erp_boolean ###############################################

-- Table: m_erp.lt_erp_boolean

-- DROP TABLE m_erp.lt_erp_boolean;

CREATE TABLE m_erp.lt_erp_boolean
(
  code character varying(1) NOT NULL,
  valeur character varying(30),
  CONSTRAINT lt_erp_boolean_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_boolean IS 'Code permettant de décrire l''état d''un attribut boolean';
COMMENT ON COLUMN m_erp.lt_erp_boolean.code IS 'Code de la liste énumérée relative à l''état d''un attribut boolean';
COMMENT ON COLUMN m_erp.lt_erp_boolean.valeur IS 'Valeur de la liste énumérée relative à l''état d''un attribut boolean';
COMMENT ON CONSTRAINT lt_erp_boolean_pkey ON m_erp.lt_erp_boolean IS 'Clé primaire du domaine de valeur lt_erp_boolean';

INSERT INTO m_erp.lt_erp_boolean(
            code, valeur)
    VALUES
  ('0','Non renseigné'),
  ('f','Non'),
  ('t','Oui'),
  ('z','Non concerné');


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# Séquence sur TABLE geo_erp_objet ###############################################

-- SEQUENCE: m_erp.geo_erp_objet_iderp_seq

-- DROP SEQUENCE m_erp.geo_erp_objet_iderp_seq;

CREATE SEQUENCE m_erp.geo_erp_objet_iderp_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################################# Séquence sur TABLE an_erp_ctrl ###############################################

-- SEQUENCE: m_erp.an_erp_ctrl_iderpctrl_seq

-- DROP SEQUENCE m_erp.an_erp_ctrl_iderpctrl_seq;

CREATE SEQUENCE m_erp.an_erp_ctrl_iderpctrl_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################################# Séquence sur TABLE an_erp_ctrl_media ###############################################

-- SEQUENCE: m_erp.an_erp_ctrl_media_gid_seq

-- DROP SEQUENCE m_erp.an_erp_ctrl_media_gid_seq;

CREATE SEQUENCE m_erp.an_erp_ctrl_media_gid_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;                
    
-- ################################################################# Séquence sur TABLE an_erp_log ###############################################

-- SEQUENCE: m_erp.an_erp_log_idlog_seq

-- DROP SEQUENCE m_erp.an_erp_log_idlog_seq;

CREATE SEQUENCE m_erp.an_erp_log_idlog_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;        


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# TABLE geo_erp_objet ###############################################

-- DROP TABLE m_erp.geo_erp_objet;
  
CREATE TABLE m_erp.geo_erp_objet
(
  iderp bigint NOT NULL DEFAULT nextval('m_erp.geo_erp_objet_iderp_seq'::regclass),
  idext character varying(80),
  insee character varying(5),
  commune character varying(80),
  quartier character varying(80),
  libelle character varying(254),
  categorie character varying(1) NOT NULL DEFAULT '0',    
  erp_typ1 character varying(5) NOT NULL DEFAULT 'NR',
  erp_typ2 character varying(80) NOT NULL DEFAULT 'ZZ',        
  groupement character varying(80) NOT NULL DEFAULT '00',
  idmaitre character varying(80),
  refads character varying(15),
  siret character varying(14),   
  etat character varying(1) NOT NULL DEFAULT '0', -- voir a distinguer ouverture comme une succession de statut / état (sens informatique) de l'ERP
  position character varying(2) NOT NULL DEFAULT '00', -- info sur position du point (entrée batiment, accès secours ...)
-- typ1 activité principale ?
-- typ2 secondaire d'activités
-- adresse (décomposée ? lien simple référence vers BAL/BAN ? donnée rappatrié dans erp depuis BAL/BAN ?)
-- parcelle(s)
-- src_geom, src_date,
-- a fait l'objet d'un controle O/N pour les cas des ERP en infraction de dépot de procédure ERP ? + media pour stocker courrier infraction dans ce cas
  observ character varying(254),
  op_sai character varying(80),  
  op_maj character varying(80),  
  dbinsert timestamp without time zone,
  dbupdate timestamp without time zone,
  x_l93 numeric(10,3),
  y_l93 numeric(10,3),
  geom geometry(point,2154), 
  CONSTRAINT geo_erp_objet_pkey PRIMARY KEY (iderp)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.geo_erp_objet IS 'Classe géographique des ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.iderp IS 'Identifiant des objets ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.idext IS 'Identifiant externe de l''ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.insee IS 'Code insee de la commune ';
COMMENT ON COLUMN m_erp.geo_erp_objet.commune IS 'Nom de la commune';
COMMENT ON COLUMN m_erp.geo_erp_objet.quartier IS 'Nom du quartier';
COMMENT ON COLUMN m_erp.geo_erp_objet.libelle IS 'Nom de l''ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.categorie IS 'Catégorie d''ERP en fonction de la capacité d''accueil effectif admissible';
COMMENT ON COLUMN m_erp.geo_erp_objet.erp_typ1 IS 'Typologie principale de l''établissement, fonction de la nature ou de l''activité de l''exploitation';
COMMENT ON COLUMN m_erp.geo_erp_objet.erp_typ2 IS 'Typologie(s)) secondaire(s) de l''établissement';
COMMENT ON COLUMN m_erp.geo_erp_objet.groupement IS 'Etablissement isolé ou groupé';
COMMENT ON COLUMN m_erp.geo_erp_objet.idmaitre IS 'Identifiant de l''ERP maître lorsque membre d''un groupement';
COMMENT ON COLUMN m_erp.geo_erp_objet.refads IS 'Numéro de l''autorisation d''urbanisme';
COMMENT ON COLUMN m_erp.geo_erp_objet.siret IS 'Code SIRET de l''établissement';
COMMENT ON COLUMN m_erp.geo_erp_objet.etat IS 'Etat de l''ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.position IS 'Type de positionnement géographique de l''ERP';
COMMENT ON COLUMN m_erp.geo_erp_objet.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp.geo_erp_objet.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp.geo_erp_objet.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp.geo_erp_objet.dbinsert IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp.geo_erp_objet.dbupdate IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON COLUMN m_erp.geo_erp_objet.x_l93 IS 'Coordonnées X en lambert 93';
COMMENT ON COLUMN m_erp.geo_erp_objet.y_l93 IS 'Coordonnées Y en Lambert 93';
COMMENT ON COLUMN m_erp.geo_erp_objet.geom IS 'Géométrie des objets ERP';

COMMENT ON CONSTRAINT geo_erp_objet_pkey ON m_erp.geo_erp_objet IS 'Clé primaire de la classe geo_erp_objet';


-- ################################################################# TABLE an_erp_ctrl ###############################################

-- DROP TABLE m_erp.an_erp_ctrl;
  
CREATE TABLE m_erp.an_erp_ctrl
(
  iderpctrl bigint NOT NULL DEFAULT nextval('m_erp.an_erp_ctrl_iderpctrl_seq'::regclass),
  iderp bigint NOT NULL,
  dde_src character varying(2) NOT NULL DEFAULT '00', 
  dde_objet character varying(254),
  dde_date date,  
  conv_date date,
  ctrl_date date,
  secu_date date,
  secu_avis character varying(2) NOT NULL DEFAULT '00',
  acces_date date,
  acces_avis character varying(2) NOT NULL DEFAULT '00',
  decis_date date,
  decis_avis character varying(2) NOT NULL DEFAULT '00',
  anomalie character varying(2),
-- date d'envoi de la convocation ?
-- anomalie(s) en cas de non conformité (case à cocher multivarié)
-- date prochaine visite (? là ou rapporté à l'ERP, les 2 ?) info calculée/détuite ou à inscrire manuellement par utilisateur ?
-- lien avec media pour joindre arreté de décision par ex
  observ character varying(254),
  op_sai character varying(80),  
  op_maj character varying(80),  
  dbinsert timestamp without time zone,
  dbupdate timestamp without time zone, 
  CONSTRAINT an_erp_ctrl_pkey PRIMARY KEY (iderpctrl)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_ctrl IS 'Classe des contrôles des ERP';
COMMENT ON COLUMN m_erp.an_erp_ctrl.iderpctrl IS 'Identifiant du controle ERP';
COMMENT ON COLUMN m_erp.an_erp_ctrl.iderp IS 'Identifiant de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_ctrl.dde_src IS 'Source de la demande de contrôle';
COMMENT ON COLUMN m_erp.an_erp_ctrl.dde_objet IS 'Objet de la demande'; -- saisie libre pour expliciter
COMMENT ON COLUMN m_erp.an_erp_ctrl.dde_date IS 'Date de la demande'; -- dépot si dossier urba
COMMENT ON COLUMN m_erp.an_erp_ctrl.conv_date IS 'Date de convocation';
COMMENT ON COLUMN m_erp.an_erp_ctrl.ctrl_date IS 'Date du contrôle';
COMMENT ON COLUMN m_erp.an_erp_ctrl.secu_date IS 'Date de retour de l''avis sécurité';
COMMENT ON COLUMN m_erp.an_erp_ctrl.secu_avis IS 'Avis sécurité';
COMMENT ON COLUMN m_erp.an_erp_ctrl.acces_date IS 'Date de retour de l''avis accessibilité';
COMMENT ON COLUMN m_erp.an_erp_ctrl.acces_avis IS 'Avis accessibilité';
COMMENT ON COLUMN m_erp.an_erp_ctrl.decis_date IS 'Date de décision de la commission';
COMMENT ON COLUMN m_erp.an_erp_ctrl.decis_avis IS 'Décision de la commission';
COMMENT ON COLUMN m_erp.an_erp_ctrl.anomalie IS 'Type d''anomalie';
COMMENT ON COLUMN m_erp.an_erp_ctrl.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp.an_erp_ctrl.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp.an_erp_ctrl.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp.an_erp_ctrl.dbinsert IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp.an_erp_ctrl.dbupdate IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON CONSTRAINT an_erp_ctrl_pkey ON m_erp.an_erp_ctrl IS 'Clé primaire de la classe an_erp_ctrl';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        MEDIA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Table: m_erp.an_erp_ctrl_media

-- DROP TABLE m_erp.an_erp_ctrl_media;

CREATE TABLE m_erp.an_erp_ctrl_media
(
  gid bigint NOT NULL DEFAULT nextval('m_erp.an_erp_ctrl_media_gid_seq'::regclass),
  iderpctrl bigint NOT NULL,
  media text,
  miniature bytea,
  n_fichier text,
  t_fichier text,
  erp_doctyp character varying(2),
  op_sai character varying(100),
  date_sai timestamp without time zone,
  date_creation timestamp without time zone DEFAULT now(),
  CONSTRAINT an_erp_ctrl_media_pkey PRIMARY KEY (gid)    
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_ctrl_media IS 'Table gérant la liste des photos des objets ERP avec le module média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.gid IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.iderpctrl IS 'Identifiant du controle ERP';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.erp_doctyp IS 'Type de documents des contrôles ERP';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.date_sai IS 'Date d''intégration du document';
COMMENT ON COLUMN m_erp.an_erp_ctrl_media.date_creation IS 'Date de création du document';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        LOG                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Table: m_erp.an_erp_log

-- DROP TABLE m_erp.an_erp_log;

CREATE TABLE m_erp.an_erp_log (
  idlog bigint NOT NULL DEFAULT nextval('m_erp.an_erp_log_idlog_seq'::regclass),
	tablename character varying(80) NOT NULL,
	type_ope character varying(30) NOT NULL,
	dataold text,
	datanew text,
	date_maj timestamp default now(),
  CONSTRAINT an_erp_log_pkey PRIMARY KEY (idlog)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_log IS 'Table des opérations effectuées sur la base de données ERP';
COMMENT ON COLUMN m_erp.an_erp_log.idlog IS 'Identifiant de l''opération';
COMMENT ON COLUMN m_erp.an_erp_log.tablename IS 'Nom de la table concernée par une opération';
COMMENT ON COLUMN m_erp.an_erp_log.type_ope IS 'Type d''opération';
COMMENT ON COLUMN m_erp.an_erp_log.dataold IS 'Valeurs anciennes';
COMMENT ON COLUMN m_erp.an_erp_log.datanew IS 'Valeurs nouvelles';
COMMENT ON COLUMN m_erp.an_erp_log.date_maj IS 'Horodatage de l''opération';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    CONTRAINTE                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- geo_erp_objet
ALTER TABLE m_erp.geo_erp_objet
    ADD CONSTRAINT lt_erp_objet_erp_type_fkey FOREIGN KEY (erp_typ1)
        REFERENCES m_erp.lt_erp_objet_erp_type (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_categorie_fkey FOREIGN KEY (categorie)
        REFERENCES m_erp.lt_erp_objet_categorie (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_etat_fkey FOREIGN KEY (etat)
        REFERENCES m_erp.lt_erp_objet_etat (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,        
    ADD CONSTRAINT lt_position_fkey FOREIGN KEY (position)
        REFERENCES r_objet.lt_position (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION; 
-- an_erp_ctrl
ALTER TABLE m_erp.an_erp_ctrl
    ADD CONSTRAINT geo_erp_objet_fkey FOREIGN KEY (iderp)
        REFERENCES m_erp.geo_erp_objet (iderp) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_ctrl_dde_src_fkey FOREIGN KEY (dde_src)
        REFERENCES m_erp.lt_erp_ctrl_dde_src (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;        
        
-- an_erp_ctrl_media
ALTER TABLE m_erp.an_erp_ctrl_media
    ADD CONSTRAINT an_erp_ctrl_fkey FOREIGN KEY (iderpctrl)
        REFERENCES m_erp.an_erp_ctrl (iderpctrl) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,        
    ADD CONSTRAINT lt_erp_ctrl_media_doctyp_fkey FOREIGN KEY (erp_doctyp)
        REFERENCES m_erp.lt_erp_ctrl_media_doctyp (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
             

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       INDEX                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- geo_erp_objet
CREATE INDEX geo_erp_objet_insee_idx ON m_erp.geo_erp_objet USING btree (insee);
CREATE INDEX geo_erp_objet_erp_type_idx ON m_erp.geo_erp_objet USING btree (erp_typ1);
CREATE INDEX geo_erp_objet_categorie_idx ON m_erp.geo_erp_objet USING btree (categorie);
CREATE INDEX geo_erp_objet_geom_idx ON m_erp.geo_erp_objet USING gist (geom);

-- an_erp_ctrl
CREATE INDEX an_erp_ctrl_ctrl_date_idx ON m_erp.an_erp_ctrl USING btree (ctrl_date);


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUE                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### VUE xapps_an_v_erp_ctrl_synthese ###############################################

-- View: m_erp.xapps_an_v_erp_ctrl_synthese

-- DROP VIEW m_erp.xapps_an_v_erp_ctrl_synthese;

CREATE OR REPLACE VIEW m_erp.xapps_an_v_erp_ctrl_synthese
 AS
WITH decis_avis AS (
        SELECT iderp, ctrl_date as dctrl_date, secu_avis, acces_avis, decis_avis
        FROM m_erp.an_erp_ctrl  
        WHERE (iderp, ctrl_date) IN
          (SELECT iderp, MAX(ctrl_date)
           FROM m_erp.an_erp_ctrl
           GROUP BY iderp)
	 ), pctril AS (
		-- je vais calculer la date de prochain controle. la fonction interval produit un type timestamps que je converti en texte puir en date
    SELECT iderp, to_date(to_char(ctrl_date + interval '3 years','yyyy-mm-dd'),'yyyy-mm-dd') as pctrl_date
		FROM m_erp.an_erp_ctrl  
        WHERE (iderp, ctrl_date) IN
          (SELECT iderp, MAX(ctrl_date)
           FROM m_erp.an_erp_ctrl
           GROUP BY iderp)
     ), nombre AS (
        SELECT iderp, COUNT(*) AS nombre
        FROM m_erp.an_erp_ctrl
        GROUP BY iderp
     )
SELECT d.iderp, d.dctrl_date, d.secu_avis, acces_avis, d.decis_avis, c.pctrl_date, n.nombre
FROM decis_avis d
INNER JOIN pctril c ON d.iderp = c.iderp
INNER JOIN nombre n ON d.iderp = n.iderp;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     FONCTION                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION/TRIGGER ERP_OBJET ###############################################


CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_objet() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

-- ## controle des temporalités de saisie des dates
  IF LENGTH(NEW.siret) <> 14 THEN
  RAISE EXCEPTION 'Erreur : le code SIRET est incomplet<br><br>';
  END IF;


  IF (TG_OP = 'INSERT') THEN
    NEW.commune = (SELECT commune FROM r_osm.geo_osm_commune WHERE st_intersects(NEW.geom,geom));
    NEW.insee = (SELECT insee FROM r_osm.geo_osm_commune WHERE st_intersects(NEW.geom,geom));
    NEW.quartier = (SELECT nom FROM r_administratif.geo_adm_quartier WHERE st_intersects(NEW.geom,geom));
    NEW.libelle = UPPER(TRIM(NEW.libelle));  
    NEW.x_l93 = ST_X(new.geom);
    NEW.y_l93 = ST_Y(new.geom);
    NEW.dbinsert = current_timestamp;
    NEW.dbupdate = NULL;    
  RETURN NEW;
  
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.commune = (SELECT commune FROM r_osm.geo_osm_commune WHERE st_intersects(NEW.geom,geom));
    NEW.insee = (SELECT insee FROM r_osm.geo_osm_commune WHERE st_intersects(NEW.geom,geom));
    NEW.quartier = (SELECT nom FROM r_administratif.geo_adm_quartier WHERE st_intersects(NEW.geom,geom));
    NEW.libelle = UPPER(TRIM(NEW.libelle));    
    NEW.x_l93 = ST_X(new.geom);
    NEW.y_l93 = ST_Y(new.geom);
    NEW.dbinsert = OLD.dbinsert;
    NEW.dbupdate = current_timestamp;    
  RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
  UPDATE m_erp.geo_erp_objet SET
    etat = '3',
    dbupdate = current_timestamp
  WHERE iderp = OLD.iderp;  
  RETURN NEW;     
    
  END IF;
  
END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_objet on m_erp.geo_erp_objet;
CREATE TRIGGER t1_m_erp_objet
BEFORE INSERT OR UPDATE OR DELETE 
ON m_erp.geo_erp_objet
FOR EACH ROW EXECUTE PROCEDURE m_erp.ft_m_erp_objet();


-- controle
/*
- à prévoir pas 2x controles à la meme date pour 1 ERP

*/

-- #################################################################### FONCTION/TRIGGER ERP_CTRL ###############################################

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_ctrl() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

-- ## controle des temporalités de saisie des dates

  -- vérifier que la date de conv_date est postérieure à celle de dde_date
  IF NEW.conv_date <= NEW.dde_date THEN
  RAISE EXCEPTION 'Erreur : La date de convocation doit être postérieure à la date de demande<br><br>';
  END IF;
  -- vérifier que la date de ctrl_date est postérieure à celle de conv_date
  IF NEW.ctrl_date <= NEW.conv_date THEN
  RAISE EXCEPTION 'Erreur : La date de contrôle doit être postérieure à la date de convocation<br><br>';
  END IF;
  -- vérifier que la date de ctrl_date est postérieure à celle de dde_date
  IF NEW.ctrl_date <= NEW.dde_date THEN
  RAISE EXCEPTION 'Erreur : La date de contrôle doit être postérieure à la date de demande<br><br>';
  END IF;  
  -- vérifier que les dates d'avis secu_date et acces_date sont postérieures à celle de ctrl_date
  IF NEW.secu_date <= NEW.ctrl_date THEN
  RAISE EXCEPTION 'Erreur : La date de retour de l''avis de sécurité doit être postérieure à la date de contrôle<br><br>';
  END IF;
  IF NEW.acces_date <= NEW.ctrl_date THEN
  RAISE EXCEPTION 'Erreur : La date de retour de l''avis d''accessibilité doit être postérieure à la date de contrôle<br><br>';
  END IF;     
  -- vérifier que la date de decis_date est postérieure à celle de ctrl_date
  IF NEW.decis_date <= NEW.ctrl_date THEN
  RAISE EXCEPTION 'Erreur : La date de la décision doit être postérieure à la date de contrôle<br><br>';
  END IF;
  -- vérifier qu'une anomalie ne comporte pas le type "non concerné" en cas d'une décision défavorable de controle (decis_avis)
  IF NEW.decis_avis = '02' AND NEW.anomalie LIKE '%ZZ%' THEN
  RAISE EXCEPTION 'Erreur : Un contrôle défavorable ne peut pas comporter une anomalie de type "Non concerné"<br><br>';
  END IF;

  IF (TG_OP = 'INSERT') THEN
    NEW.dde_objet = UPPER(TRIM(NEW.dde_objet));
    NEW.anomalie = CASE WHEN NEW.decis_avis = '01' THEN 'ZZ' ELSE NEW.anomalie END;     
    NEW.dbinsert = current_timestamp;
    NEW.dbupdate = NULL;      
    RETURN NEW;
  
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.dde_objet = UPPER(TRIM(NEW.dde_objet));
    NEW.anomalie = CASE WHEN NEW.decis_avis = '01' THEN 'ZZ' ELSE NEW.anomalie END; -- prevoir cas en plus où si NEW.decisavis est défavorable ET anomalie NULL alors anomalrie = '00'
    NEW.dbinsert = OLD.dbinsert;
    NEW.dbupdate = current_timestamp;        
    RETURN NEW;

  ELSIF (TG_OP = 'DELETE') THEN
    RETURN OLD;     
    
  END IF;

       
RETURN NEW;

END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_ctrl on m_erp.an_erp_ctrl;
CREATE TRIGGER t1_m_erp_ctrl
BEFORE INSERT OR UPDATE --OR DELETE 
ON m_erp.an_erp_ctrl
FOR EACH ROW EXECUTE PROCEDURE m_erp.ft_m_erp_ctrl();


-- #################################################################### FONCTION/TRIGGER ERP_LOG ###############################################


CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_log() RETURNS trigger LANGUAGE plpgsql AS $$

DECLARE v_idlog integer;
DECLARE v_dataold character varying(50000);
DECLARE v_datanew character varying(50000);

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN
  ---
  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_datanew := ROW(NEW.*); -- On concatène tous les attributs dans un seul
  --
  INSERT INTO m_erp.an_erp_log (idlog, tablename, type_ope, dataold, datanew, date_maj)
  SELECT
  v_idlog,
  TG_TABLE_NAME,
  TG_OP,
  NULL,
  v_datanew,
  now(); 
  RETURN NEW;
  

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN 
  --
  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_dataold := ROW(OLD.*);-- On concatène tous les anciens attributs dans un seul
  v_datanew := ROW(NEW.*);-- On concatène tous les nouveaux attributs dans un seul	
  ---
  INSERT INTO m_erp.an_erp_log (idlog, tablename, type_ope, dataold, datanew, date_maj)
  SELECT
  v_idlog,
  TG_TABLE_NAME,
  TG_OP,
  v_dataold,
  v_datanew,
  now();
  RETURN NEW;

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN 
  --
  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_dataold := ROW(OLD.*);-- On concatène tous les anciens attributs dans un seul
  -- 
  INSERT INTO m_erp.an_erp_log (idlog, tablename, type_ope, dataold, datanew, date_maj)
  SELECT
  v_idlog,
  TG_TABLE_NAME,
  TG_OP,
  v_dataold,
  NULL,
  now();
  RETURN NEW;
  
END IF;

END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_log on m_erp.an_erp_ctrl;
CREATE TRIGGER t2_m_erp_log
BEFORE INSERT OR UPDATE OR DELETE 
ON m_erp.an_erp_ctrl
FOR EACH ROW EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- DROP TRIGGER IF EXISTS t_m_erp_log on m_erp.geo_erp_objet;
CREATE TRIGGER t2_m_erp_log
BEFORE INSERT OR UPDATE OR DELETE 
ON m_erp.geo_erp_objet
FOR EACH ROW EXECUTE PROCEDURE m_erp.ft_m_erp_log();

    
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/*
-- MAJ des calculs des coordonnées des objets de type point !!!!!! renvoit vers fonction trigger générique du schéma public !!!!;
-- DROP TRIGGER t_geo_erp_objet_xy_l93 ON m_erp.geo_erp_objet;
CREATE TRIGGER t_geo_erp_objet_xy_l93
BEFORE INSERT OR UPDATE OF geom ON m_erp.geo_erp_objet
FOR EACH ROW EXECUTE PROCEDURE public.ft_r_xy_l93();

*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    EXPLOITATION                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: m_erp.xapps_an_v_erp_objet_nb_quartier

-- DROP VIEW m_erp.xapps_an_v_erp_objet_nb_quartier;

CREATE OR REPLACE VIEW m_erp.xapps_an_v_erp_objet_nb_quartier
 AS
 SELECT count(*) as nombre, quartier, commune FROM m_erp.geo_erp_objet o
  WHERE o.etat = '2'
  GROUP BY quartier, commune;

COMMENT ON VIEW m_erp.xapps_an_v_erp_objet_nb_quartier IS 'Nombre total d''ERP en état existant par quartier et par commune';



-- View: m_erp.xapps_an_v_erp_objet_nb_categorie

-- DROP VIEW m_erp.xapps_an_v_erp_objet_nb_categorie;

CREATE OR REPLACE VIEW m_erp.xapps_an_v_erp_objet_nb_categorie
 AS
 SELECT count(*) as nombre, categorie, commune FROM m_erp.geo_erp_objet o
  WHERE o.etat = '2'
  GROUP BY categorie, commune;

COMMENT ON VIEW m_erp.xapps_an_v_erp_objet_nb_categorie IS 'Nombre total d''ERP en état existant par catégorie';


-- View: m_erp.xapps_an_v_erp_objet_nb_decis_avis

-- DROP VIEW m_erp.xapps_an_v_erp_objet_nb_decis_avis;

CREATE OR REPLACE VIEW m_erp.xapps_an_v_erp_objet_nb_decis_avis
 AS
 SELECT count(*) as nombre, decis_avis, commune
 FROM m_erp.geo_erp_objet o 
 JOIN m_erp.xapps_an_v_erp_ctrl_synthese s ON s.iderp = o.iderp
 WHERE o.etat = '2'
 GROUP BY decis_avis, commune;

COMMENT ON VIEW m_erp.xapps_an_v_erp_objet_nb_decis_avis IS 'Nombre total d''ERP en état existant par avis';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       DROITS                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        TESTS                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/*

         SELECT DISTINCT a.iderp
           FROM m_erp.an_erp_ctrl a
             JOIN ( SELECT an_erp_ctrl.iderp,
                    max(an_erp_ctrl.ctrl_date) AS dctrl_date
                   FROM m_erp.an_erp_ctrl
                  GROUP BY an_erp_ctrl.iderp) b ON a.iderp = b.iderp AND a.ctrl_date = b.ctrl_date

         SELECT DISTINCT a.id_adresse,
            a.rcc,
            a.ccdate
           FROM m_reseau_humide.an_euep_cc a
             JOIN ( SELECT an_euep_cc.id_adresse,
                    max(an_euep_cc.ccdate) AS ccdate
                   FROM m_reseau_humide.an_euep_cc
                  GROUP BY an_euep_cc.id_adresse) b_1 ON a.id_adresse = b_1.id_adresse AND a.ccdate = b_1.ccdate

      SELECT c_1.id_adresse,
            count(*) AS nb_cc,
            string_agg(c_1.certtype::text, ','::text) AS certtype
           FROM m_reseau_humide.an_euep_cc c_1
          GROUP BY c_1.id_adresse
        )


SELECT iderp, ctrl_date, decis_avis
FROM m_erp.an_erp_ctrl WHERE (iderp, ctrl_date) IN
(   SELECT iderp, MAX(ctrl_date) as date_crtl
    FROM m_erp.an_erp_ctrl
    GROUP BY iderp);
-- marche pas si plusieurs controle à la meme date par erp
-- ou alors prévoir cas où pas possible d'avoir plusieurs controle à la meme date ou alors passer à un timestamp ...   
          

SELECT s.iderp, MAX(s.ctrl_date), decis_avis FROM m_erp.an_erp_ctrl s GROUP BY s.iderp ;

SELECT  *
FROM    m_erp.geo_erp_objet as g
WHERE   EXISTS
        (   SELECT  1
            FROM    m_erp.an_erp_ctrl
            WHERE   an_erp_ctrl.iderp = g.iderp
            HAVING  MAX(an_erp_ctrl.ctrl_date) = g.dctrl_date
        );
        
select *
from 
(
select *, row_no = row_number() over (partition by TraderCode,MatchKey order by Date desc)
from m_erp.an_erp_ctrl
) i
where i.row_no = 1



select * from (
    select
        username,
        date,
        value,
        row_number() over(partition by username order by date desc) as rn
    from
        yourtable
) t
where t.rn = 1 

*/ 
