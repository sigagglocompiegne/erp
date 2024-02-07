/**ERP Stage V0.1.0*/
/*Creation du fichier complet*/
/* init_db_erp_stage.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteurs : Alice Loubaresse */

/*
#################################################################### SUIVI CODE SQL ####################################################################

2023-09-21 : GB / initialisation de la structure du fichier

*/
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SUPPRESSION                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ## VUE
--DROP VIEW IF EXISTS m_erp_stage.;


-- ## CONTRAINTES
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_cat_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_erptype_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_etat_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_gestion_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_groupement_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet DROP CONSTRAINT IF EXISTS lt_erp_objet_loc_som_fkey;


ALTER TABLE IF EXISTS m_erp_stage.an_erp_securite DROP CONSTRAINT IF EXISTS lt_erp_controle_commission_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_securite DROP CONSTRAINT IF EXISTS lt_erp_controle_avis_exp_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_securite DROP CONSTRAINT IF EXISTS lt_erp_controle_avis_com_fkey;

ALTER TABLE IF EXISTS m_erp_stage.an_erp_accessibilite DROP CONSTRAINT IF EXISTS lt_erp_controle_commission_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_accessibilite DROP CONSTRAINT IF EXISTS lt_erp_controle_avis_exp_fkey;
ALTER TABLE IF EXISTS m_erp_stage.an_erp_accessibilite DROP CONSTRAINT IF EXISTS lt_erp_controle_avis_com_fkey;

ALTER TABLE IF EXISTS m_erp_stage.an_erp_exploitant DROP CONSTRAINT IF EXISTS lt_erp_exploitant_civilite_fkey;

ALTER TABLE IF EXISTS m_erp_stage.an_erp_ctrl_media DROP CONSTRAINT IF EXISTS lt_erp_ctrl_media_doctyp_fkey;

ALTER TABLE IF EXISTS m_erp_stage.an_erp_objet_media DROP CONSTRAINT IF EXISTS lt_erp_objet_media_doctyp_fkey;

-- ## VUE
drop materialized view if exists m_erp_stage.xapps_geo_vmr_erp;
drop materialized view if exists m_erp_stage.xapps_geo_vmr_erp_adresse;
drop materialized view if exists m_erp_stage.xapps_an_v_erp_contsecu_periode;
DROP MATERIALIZED VIEW IF EXISTS m_erp_stage.xapps_geo_vmr_erp_gb;



-- ## CLASSE
DROP TABLE IF EXISTS m_erp_stage.an_erp_log;
DROP TABLE IF EXISTS m_erp_stage.an_erp_objet;
DROP TABLE IF EXISTS m_erp_stage.geo_erp_point_utilisateur;
DROP TABLE IF EXISTS m_erp_stage.an_erp_securite;
DROP TABLE IF EXISTS m_erp_stage.an_erp_accessibilite;
DROP TABLE IF EXISTS m_erp_stage.an_erp_exploitant;
DROP TABLE IF EXISTS m_erp_stage.an_erp_ctrl_media;
DROP TABLE IF EXISTS m_erp_stage.an_erp_objet_media;
DROP TABLE IF EXISTS m_erp_stage.an_erp_conf_secu;

-- ## TABLE DE RELATION
DROP TABLE IF EXISTS m_erp_stage.lk_erp_localisation;

-- ## DOMAINE DE VALEUR
DROP TABLE IF EXISTS m_erp_stage.lt_erp_objet_cat;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_objet_erptype;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_objet_etat;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_controle_commission;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_controle_type_visite;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_controle_avis;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_controle_expert;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_exploitant_civilite;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_gestion;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_groupement;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_ctrl_media_doctyp;
DROP TABLE IF EXISTS m_erp_stage.lt_erp_objet_media_doctyp;

-- ## SEQUENCE
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_objet_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.lk_erp_localisation_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_securite_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_accessibilite_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_exploitant_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_log_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_ctrl_media_gid_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_conf_seq;
DROP SEQUENCE IF EXISTS m_erp_stage.an_erp_objet_media_gid_seq;






-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- SCHEMA: m_erp_stage

-- DROP SCHEMA m_erp_stage ;
/*
CREATE SCHEMA m_erp_stage
    AUTHORIZATION aloubaresse;

COMMENT ON SCHEMA m_erp_stage
    IS 'Schéma de gestion des ERP (établissements recevant du public) sur la ville de Compiègne (stage de Alice Loubaresse 2023-2024)';

GRANT ALL ON SCHEMA m_erp_stage TO aloubaresse;
GRANT ALL ON SCHEMA m_erp_stage TO create_sig;
GRANT ALL ON SCHEMA m_erp_stage TO postgres;
GRANT ALL ON SCHEMA m_erp_stage TO sig_read;

ALTER DEFAULT PRIVILEGES IN SCHEMA m_erp_stage
GRANT ALL ON TABLES TO sig_create WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA m_erp_stage
GRANT ALL ON TABLES TO create_sig WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA m_erp_stage
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO sig_edit WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA m_erp_stage
GRANT ALL ON TABLES TO aloubaresse WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA m_erp_stage
GRANT SELECT ON TABLES TO sig_read WITH GRANT OPTION;

*/
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINE  DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# lt_erp_objet_cat ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_objet_cat"

CREATE TABLE  m_erp_stage.lt_erp_objet_cat
(
	code character varying(2) NOT NULL,
	valeur character varying(20) NOT NULL,
	CONSTRAINT lt_erp_objet_cat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_objet_cat IS 'Liste permettant de décrire les catégories d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_cat.code IS 'Code de la liste énumérée relative à la catégorie d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_cat.valeur IS 'Valeur de la liste énumérée relative relative à la catégorie d''ERP';
COMMENT ON CONSTRAINT lt_erp_objet_cat_pkey ON m_erp_stage.lt_erp_objet_cat IS 'Clé primaire du domaine de valeur lt_erp_objet_cat';

INSERT INTO m_erp_stage.lt_erp_objet_cat(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','1'),
  ('20','2'),
  ('30','3'),
  ('40','4'),
  ('50','5');

-- ################################################################# lt_erp_objet_erptype ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_objet_erptype"

CREATE TABLE  m_erp_stage.lt_erp_objet_erptype
(
	code character varying(3) NOT NULL,
	valeur character varying(150) NOT NULL,
	CONSTRAINT lt_erp_objet_erptype_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_objet_erptype IS 'Liste permettant de décrire le type d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_erptype.code IS 'Code de la liste énumérée relative au type d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_erptype.valeur IS 'Valeur de la liste énumérée relative relative au type d''ERP';
COMMENT ON CONSTRAINT lt_erp_objet_erptype_pkey ON m_erp_stage.lt_erp_objet_erptype IS 'Clé primaire du domaine de valeur lt_erp_objet_erptype';

INSERT INTO m_erp_stage.lt_erp_objet_erptype(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('J','Structures d''accueil pour personnes âgées et personnes handicapées'),
  ('L','Salles d auditions, de conférences, de réunions, de spectacles ou polyvalentes'),
  ('M','Magasins de vente, centres commerciaux'),
  ('N','Restaurants et débits de boissons'),
  ('O','Hôtels et pensions de famille'),
  ('P','Salles de danses et salles de jeux'),
  ('R','Établissements d''éveil, d''enseignement, de formation, centres de vacances, centres de loisirs sans hébergement'),
  ('S','Bibliothèques, centres de documentation'),
  ('T','Salles d expositions'),
  ('U','Établissements sanitaires'),
  ('V','Établissement de culte'),
  ('W','Administrations, banques, bureaux'),
  ('X','Établissements sportifs couverts'),
  ('Y','Musées'),
  ('EF','Établissements flottants'),
  ('GA','Gares'),
  ('PA','Établissements de plein air'),
  ('PS','Parcs de stationnement couverts'),
  ('SG','Structure gonflable'),
  ('CTS','Chapiteaux, tentes et structures'),
  ('OA','Hôtels-restaurants d altitude'),
  ('REF','Refuges de montagne'),
  ('ZZ','Non concerné');

-- ################################################################# lt_erp_objet_etat ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_objet_etat"

CREATE TABLE  m_erp_stage.lt_erp_objet_etat
(
	code character varying(2) NOT NULL,
	valeur character varying(20) NOT NULL,
	CONSTRAINT lt_erp_objet_etat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_objet_etat IS 'Liste permettant de décrire l''état d''un ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_etat.code IS 'Code de la liste énumérée relative à l''état d''un ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_etat.valeur IS 'Valeur de la liste énumérée relative relative à l''état d''un ERP';
COMMENT ON CONSTRAINT lt_erp_objet_etat_pkey ON m_erp_stage.lt_erp_objet_etat IS 'Clé primaire du domaine de valeur lt_erp_objet_etat';

INSERT INTO m_erp_stage.lt_erp_objet_etat(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','Ouvert'),
  ('20','Fermé temporairement'),
  ('30','Fermé');
 
  
   -- ################################################################# lt_erp_gestion ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_gestion"

CREATE TABLE m_erp_stage.lt_erp_gestion
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_gestion_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_gestion IS 'Code permettant de décrire l''état d''un attribut gestion';
COMMENT ON COLUMN m_erp_stage.lt_erp_gestion.code IS 'Code de la liste énumérée relative à l''état d''un attribut gestion';
COMMENT ON COLUMN m_erp_stage.lt_erp_gestion.valeur IS 'Valeur de la liste énumérée relative à l''état d''un attribut gestion';
COMMENT ON CONSTRAINT lt_erp_gestion_pkey ON m_erp_stage.lt_erp_gestion IS 'Clé primaire du domaine de valeur lt_erp_gestion';

INSERT INTO m_erp_stage.lt_erp_gestion(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','Opérateur public'),
  ('20','Entreprise privée');
  
   -- ################################################################# lt_erp_groupement ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_groupement"

CREATE TABLE m_erp_stage.lt_erp_groupement
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_groupement_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_groupement IS 'Code permettant de décrire l''état d''un attribut groupement';
COMMENT ON COLUMN m_erp_stage.lt_erp_groupement.code IS 'Code de la liste énumérée relative à l''état d''un attribut groupement';
COMMENT ON COLUMN m_erp_stage.lt_erp_groupement.valeur IS 'Valeur de la liste énumérée relative à l''état d''un attribut groupement';
COMMENT ON CONSTRAINT lt_erp_groupement_pkey ON m_erp_stage.lt_erp_groupement IS 'Clé primaire du domaine de valeur lt_erp_groupement';

INSERT INTO m_erp_stage.lt_erp_groupement(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','ERP indépendant'),
  ('20','Membre d''un groupement'),
  ('30','Maitre d''un groupement');
  
   -- ################################################################# lt_erp_controle_commission ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_controle_commission"

CREATE TABLE m_erp_stage.lt_erp_controle_commission
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_controle_commission_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_controle_commission IS 'Code permettant de décrire le type de commission';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_commission.code IS 'Code de la liste énumérée relative au type de commission';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_commission.valeur IS 'Valeur de la liste énumérée relative au type de commission';
COMMENT ON CONSTRAINT lt_erp_controle_commission_pkey ON m_erp_stage.lt_erp_controle_commission IS 'Clé primaire du domaine de valeur lt_erp_controle_commission';

INSERT INTO m_erp_stage.lt_erp_controle_commission(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','S.C.D.S.'),
  ('20','Commission communale Compiègne');
  
   -- ################################################################# lt_erp_controle_avis ###############################################

-- ajout de la table de liste "m_erp_stage.lt_controle_avis"
 
CREATE TABLE m_erp_stage.lt_erp_controle_avis
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    tri integer,
    CONSTRAINT lt_erp_controle_avis_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_controle_avis IS 'Code permettant de décrire le type d''avis';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_avis.code IS 'Code de la liste énumérée relative au type d''avis';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_avis.valeur IS 'Valeur de la liste énumérée relative au type d''avis';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_avis.tri IS 'Ordre des avis du plus dévaforable au favorable';
COMMENT ON CONSTRAINT lt_erp_controle_avis_pkey ON m_erp_stage.lt_erp_controle_avis IS 'Clé primaire du domaine de valeur lt_controle_avis';

INSERT INTO m_erp_stage.lt_erp_controle_avis(
            code, valeur,tri)
    VALUES
  ('00','Non renseigné',5),
  ('10','Défavorable',1),
  ('11','Favorable avec prescription',3),
  ('20','Sursis à statuer',2),
  ('30','Favorable',4);
  
     -- ################################################################# lt_erp_controle_expert ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_controle_expert"

CREATE TABLE m_erp_stage.lt_erp_controle_expert
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_controle_expert_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_controle_expert IS 'Code permettant de décrire le type d''expert';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_expert.code IS 'Code de la liste énumérée relative au type d''expert';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_expert.valeur IS 'Valeur de la liste énumérée relative au type d''expert';
COMMENT ON CONSTRAINT lt_erp_controle_expert_pkey ON m_erp_stage.lt_erp_controle_expert IS 'Clé primaire du domaine de valeur lt_controle_expert';

INSERT INTO m_erp_stage.lt_erp_controle_expert(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','SDIS'),
  ('20','Préfécture'),
  ('99','Autre');
  
   -- ################################################################# lt_erp_controle_type_visite ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_controle_type_visite"

CREATE TABLE m_erp_stage.lt_erp_controle_type_visite
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_controle_type_visite_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_controle_type_visite IS 'Code permettant de décrire le type de visite';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_type_visite.code IS 'Code de la liste énumérée relative au type de visite';
COMMENT ON COLUMN m_erp_stage.lt_erp_controle_type_visite.valeur IS 'Valeur de la liste énumérée relative au type de visite';
COMMENT ON CONSTRAINT lt_erp_controle_type_visite_pkey ON m_erp_stage.lt_erp_controle_type_visite IS 'Clé primaire du domaine de valeur lt_controle_type_visite';

INSERT INTO m_erp_stage.lt_erp_controle_type_visite(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','Visite périodique'),
  ('11','Visite de conformité'),
  ('12','Visite inopinée'),
  ('13','Visite d''ouverture'),
  ('20','Réception de travaux'),
  ('99','Autre');
  
   -- ################################################################# lt_erp_exploitant_civilite ###############################################

-- ajout de la table de liste "m_erp_stage.lt_erp_exploitant_civilite"
 
CREATE TABLE m_erp_stage.lt_erp_exploitant_civilite
(
    code character varying(2) NOT NULL,
    valeur character varying(30),
    CONSTRAINT lt_erp_exploitant_civilite_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_exploitant_civilite IS 'Code permettant de décrire la civilité de l''exploitant';
COMMENT ON COLUMN m_erp_stage.lt_erp_exploitant_civilite.code IS 'Code de la liste énumérée relative au type de civilite';
COMMENT ON COLUMN m_erp_stage.lt_erp_exploitant_civilite.valeur IS 'Valeur de la liste énumérée relative au type de civilite';
COMMENT ON CONSTRAINT lt_erp_exploitant_civilite_pkey ON m_erp_stage.lt_erp_exploitant_civilite IS 'Clé primaire du domaine de valeur lt_exploitant_civilite';

INSERT INTO m_erp_stage.lt_erp_exploitant_civilite(
            code, valeur)
    VALUES
    ('00','Non renseigné'),
    ('11','Monsieur'),
    ('12','Madame'),
    ('20','Madame & Monsieur'),
    ('21','Monsieur & Monsieur'),
	('22','Madame & Madame'),    
    ('30','Mesdames & Messieurs'),
    ('99','Autre');
	
-- ################################################################# lt_erp_ctrl_media_doctyp ###############################################

-- ajout de la table de liste "lt_erp_ctrl_media_doctyp"

CREATE TABLE  m_erp_stage.lt_erp_ctrl_media_doctyp
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_ctrl_media_doctyp_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_ctrl_media_doctyp IS 'Liste permettant de décrire le type de documents (média) pour les contrôles d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_ctrl_media_doctyp.code IS 'Code de la liste énumérée relative au type de document (média) pour les contrôles d''ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_ctrl_media_doctyp.valeur IS 'Valeur de la liste énumérée relative au type de document (média) pour les contrôles d''ERP';
COMMENT ON CONSTRAINT lt_erp_ctrl_media_doctyp_pkey ON m_erp_stage.lt_erp_ctrl_media_doctyp IS 'Clé primaire du domaine de valeur lt_erp_ctrl_media_doctyp';

INSERT INTO m_erp_stage.lt_erp_ctrl_media_doctyp(
            code, valeur)
    VALUES
  ('00','Non renseigné'),    
  ('01','Avis du SDIS'),
  ('02','Avis de la préfecture'),
  ('03','Arrété'),  
  ('99','Autre');
  
 -- ################################################################# lt_erp_objet_media_doctyp ###############################################

-- ajout de la table de liste "lt_erp_objet_media_doctyp"

CREATE TABLE  m_erp_stage.lt_erp_objet_media_doctyp
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_objet_media_doctyp_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lt_erp_objet_media_doctyp IS 'Liste permettant de décrire le type de documents (média) pour les ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_media_doctyp.code IS 'Code de la liste énumérée relative au type de document (média) pour les ERP';
COMMENT ON COLUMN m_erp_stage.lt_erp_objet_media_doctyp.valeur IS 'Valeur de la liste énumérée relative au type de document (média) pour les ERP';
COMMENT ON CONSTRAINT lt_erp_objet_media_doctyp_pkey ON m_erp_stage.lt_erp_objet_media_doctyp IS 'Clé primaire du domaine de valeur lt_erp_objet_media_doctyp';

INSERT INTO m_erp_stage.lt_erp_objet_media_doctyp(
            code, valeur)
    VALUES
  ('00','Non renseigné'),      
  ('99','Autre');
  

 
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# Séquence sur TABLE an_erp_objet ###############################################

-- SEQUENCE: m_erp_stage.an_erp_objet_seq

-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_objet_seq;

CREATE SEQUENCE m_erp_stage.an_erp_objet_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

    
-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.lk_erp_localisation_seq;

CREATE SEQUENCE m_erp_stage.lk_erp_localisation_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;
    
-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_securite_seq;

CREATE SEQUENCE m_erp_stage.an_erp_securite_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;
    
-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_accessibilite_seq;

CREATE SEQUENCE m_erp_stage.an_erp_accessibilite_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_exploitant_seq;

CREATE SEQUENCE m_erp_stage.an_erp_exploitant_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;

-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_exploitant_seq;

CREATE SEQUENCE m_erp_stage.an_erp_ctrl_media_gid_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;
    
-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_log_seq;  

CREATE SEQUENCE m_erp_stage.an_erp_log_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;	

-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_conf_seq;  

CREATE SEQUENCE m_erp_stage.an_erp_conf_seq
    INCREMENT 1
    START 0
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;
    
-- DROP SEQUENCE -- SEQUENCE: m_erp_stage.an_erp_objet_media_gid_seq;  

CREATE SEQUENCE m_erp_stage.an_erp_objet_media_gid_seq
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


-- ################################################################# TABLE an_erp_objet ###############################################

-- DROP TABLE m_erp_stage.an_erp_objet;

CREATE TABLE m_erp_stage.an_erp_objet
(
  idobjet bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_objet_seq'::regclass),
  id_adresse bigint,
  libelle character varying(100),
  cat character varying(2) NOT NULL DEFAULT '00',
  erptype character varying(3) NOT NULL DEFAULT '00',
  erptype_2 character varying(20) NOT NULL DEFAULT 'ZZ',
  etat character varying(2) NOT NULL DEFAULT '00',
  gestion character varying(2) NOT NULL DEFAULT '00',
  groupement character varying(2) NOT NULL DEFAULT '00',
  idobjet_maitre bigint,
  ephemere character varying(1) NOT NULL DEFAULT '0',
  eff_public character varying(10),
  eff_nuit character varying(10),
  eff_pers character varying(10),
  eff_heberg character varying(10),
  eff_total character varying(10),
  loc_som character varying(1) NOT NULL DEFAULT '0',
  siret character varying(14),
  d_ouvert timestamp without time zone,
  d_ferme timestamp without time zone,
  idexploit bigint,
  observ character varying(254),
  op_sai character varying(80),  
  op_maj character varying(80),  
  date_sai timestamp without time zone,
  date_maj timestamp without time zone,
  CONSTRAINT an_erp_objet_pkey PRIMARY KEY (idobjet)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_objet IS 'Classe d''objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.idobjet IS 'Identifiant des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.id_adresse IS 'Identifiant adresse';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.libelle IS 'Libellé des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.cat IS 'Catégories des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.erptype IS 'Type des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.erptype_2 IS 'Type secondaire des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.etat IS 'Etat des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.gestion IS 'Caractérise le type de gestion de l''ERP'; --public ou privé
COMMENT ON COLUMN m_erp_stage.an_erp_objet.groupement IS 'Caractérise le type de groupement de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.idobjet_maitre IS 'ERP associé au groupement de l''ERP'; --si l'ERP appartient à un groupement
COMMENT ON COLUMN m_erp_stage.an_erp_objet.ephemere IS 'Indique si l''ERP est éphémère';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.eff_public IS 'Effectif public de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.eff_nuit IS 'Effectif nuit de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.eff_pers IS 'Effectif personnel de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.eff_heberg IS 'Effectif hebergement de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.eff_total IS 'Effectif total de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.loc_som IS 'Présence de local à sommeil des objets ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.SIRET IS 'SIRET de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.d_ouvert IS 'Date d''ouverture de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.d_ferme IS 'Date de fermeture de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.date_sai IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp_stage.an_erp_objet.date_maj IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON CONSTRAINT an_erp_objet_pkey ON m_erp_stage.an_erp_objet IS 'Clé primaire de la classe an_erp_objet';

GRANT ALL ON m_erp_stage.an_erp_objet TO aloubaresse WITH GRANT OPTION;



-- ################################################################# TABLE lk_erp_localisation ###############################################

-- DROP TABLE m_erp_stage.lk_erp_localisation;
  
CREATE TABLE m_erp_stage.lk_erp_localisation
(
  id bigint NOT NULL DEFAULT nextval('m_erp_stage.lk_erp_localisation_seq'::regclass),
  idobjet bigint,
  idloc bigint,
   CONSTRAINT lk_erp_localisation_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.lk_erp_localisation IS 'Classe d''objets de localisation des ERP';
COMMENT ON COLUMN m_erp_stage.lk_erp_localisation.idobjet IS 'Identifiant de l''ERP';
COMMENT ON COLUMN m_erp_stage.lk_erp_localisation.id IS 'Identifiant interne à la classe';
COMMENT ON COLUMN m_erp_stage.lk_erp_localisation.idloc IS 'Identifiant d''adresse ou du point utilisateur';


-- ################################################################# TABLE geo_erp_point_utilisateur ###############################################

-- DROP TABLE m_erp_stage.geo_erp_point_utilisateur;
  
CREATE TABLE m_erp_stage.geo_erp_point_utilisateur
(
  idobjet bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_objet_seq'::regclass),
  x_l93 numeric(9,2),
  y_l93 numeric(10,2),
  insee character varying(5),
  commune character varying(80),
  indications character varying(1000),
  geom geometry(point,2154),

  CONSTRAINT geo_erp_point_utilisateur_pkey PRIMARY KEY (idobjet)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.geo_erp_point_utilisateur IS 'Classe d''objets de localisation utilisateur des ERP';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.idobjet IS 'Identifiant de la localisation utilisateur';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.x_l93 IS 'Coordonnées X en lambert 93';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.y_l93 IS 'Coordonnées Y en lambert 93';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.indications IS 'Compléments de localisation';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.insee IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.commune IS 'Code insee de la commune';
COMMENT ON COLUMN m_erp_stage.geo_erp_point_utilisateur.geom IS 'Géométrie du point';


-- ################################################################# TABLE an_erp_securite ###############################################

-- DROP TABLE m_erp_stage.an_erp_securite;
  
CREATE TABLE m_erp_stage.an_erp_securite
(
  id bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_securite_seq'::regclass),
  idobjet bigint,
  d_convoc timestamp without time zone,
  type_visite character varying(2) NOT NULL DEFAULT '00',
  d_visite timestamp without time zone,
  expert character varying(2) NOT NULL DEFAULT '00',
  avis_expert character varying(2) NOT NULL DEFAULT '00',
  d_avis_exp timestamp without time zone,
  commission character varying(2) NOT NULL DEFAULT '00',
  avis_com character varying(2) NOT NULL DEFAULT '00',
  d_avis_com timestamp without time zone,
  observ character varying(254),
  op_sai character varying(80),  
  op_maj character varying(80),  
  date_sai timestamp without time zone,
  date_maj timestamp without time zone,
    CONSTRAINT an_erp_securite_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_securite IS 'Classe d''objets informative concernant la sécurité des ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.id IS 'Identifiant des controles de sécurité';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.idobjet IS 'Identifiant de l''ERP controlé';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.d_convoc IS 'Date de la convocation';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.type_visite IS 'Type de visite de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.d_visite IS 'Date de visite de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.expert IS 'Expert qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.avis_expert IS 'Avis de l''expert qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.d_avis_exp IS 'Date de récéption de l''avis expert';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.commission IS 'Commission qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.avis_com IS 'Avis de la commission qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.d_avis_com IS 'Date de récéption de l''avis de la commission';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.date_sai IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp_stage.an_erp_securite.date_maj IS 'Horodatage de la dernière mise à jour de la donnée dans la base';


-- ################################################################# TABLE an_erp_accessibilite ###############################################

-- DROP TABLE m_erp_stage.an_erp_accessibilite;
  
CREATE TABLE m_erp_stage.an_erp_accessibilite
(
  id bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_accessibilite_seq'::regclass),
  idobjet bigint,
  d_convoc timestamp without time zone,
  type_visite character varying(2) NOT NULL DEFAULT '00',
  d_visite timestamp without time zone,
  expert character varying(2) NOT NULL DEFAULT '00',
  avis_expert character varying(2) NOT NULL DEFAULT '00',
  d_avis_exp timestamp without time zone,
  commission character varying(2) NOT NULL DEFAULT '00',
  avis_com character varying(2) NOT NULL DEFAULT '00',
  d_avis_com timestamp without time zone,
  observ character varying(254),
  op_sai character varying(80),  
  op_maj character varying(80),  
  date_sai timestamp without time zone,
  date_maj timestamp without time zone,
  CONSTRAINT an_erp_accessibilite_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_accessibilite IS 'Classe d''objets informative concernant la sécurité des ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.id IS 'Identifiant des controles de sécurité';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.idobjet IS 'Identifiant de l''ERP controlé';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.d_convoc IS 'Date de la convocation';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.type_visite IS 'Type de visite de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.d_visite IS 'Date de visite de l''ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.expert IS 'Expert qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.avis_expert IS 'Avis de l''expert qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.d_avis_exp IS 'Date de récéption de l''avis expert';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.commission IS 'Commission qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.avis_com IS 'Avis de la commission qui participe au controle';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.d_avis_com IS 'Date de récéption de l''avis expert';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.date_sai IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp_stage.an_erp_accessibilite.date_maj IS 'Horodatage de la dernière mise à jour de la donnée dans la base';

-- ################################################################# TABLE an_erp_exploitant ###############################################

-- DROP TABLE m_erp_stage.an_erp_exploitant;
  
CREATE TABLE m_erp_stage.an_erp_exploitant
(
  idexploit bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_exploitant_seq'::regclass),
  idobjet bigint,
  civilite character varying(2) NOT NULL DEFAULT '00',
  nom character varying(100),
  prenom character varying(100),
  coord_tel character varying(10),
  mail character varying(100),
  CONSTRAINT an_erp_exploitant_pkey PRIMARY KEY (idexploit)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_exploitant IS 'Classe d''objets informative concernant la sécurité des ERP';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.idexploit IS 'Identifiant de l''exploitant';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.civilite IS 'Civilite de l''expoitant';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.nom IS 'Nom de l''exploitant';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.prenom IS 'Prenom de l''exploitant';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.coord_tel IS 'Coordonnees telephonique de l''exploitant';
COMMENT ON COLUMN m_erp_stage.an_erp_exploitant.mail IS 'Mail de l''exploitant';

-- ################################################# Classe des objets des variables paramétrables : an_erp_conf_secu ##################################

CREATE TABLE m_erp_stage.an_erp_conf_secu (
	erptype varchar(3) NOT null,
	cat1 integer, 
    cat2 integer,
    cat3 integer,
    cat4 integer,
    cat5 integer,
	date_sai timestamp without time ZONE NOT NULL,
    date_maj timestamp without time zone,
    op_sai character varying(20) NOT NULL,
    op_maj character varying(20),
	CONSTRAINT an_erp_conf_pkey PRIMARY KEY (erptype)
);

COMMENT ON TABLE m_erp_stage.an_erp_conf_secu 
 IS 'Table gérant les variables paramétrables pour les périodicités des contrôles de sécurité';      
   
COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.erptype
    IS 'Type d''ERP';
   
COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.date_sai
    IS 'Date de saisie';
COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.date_maj
    IS 'Date de mise à jour';
   
   COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.op_sai
    IS 'Opérateur de saisie';
COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.op_maj
    IS 'Opérateur de msie à jour';

COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.cat1
    IS 'Périodicité des contrôles de sécurité des ERP de catégorie 1 en fonction des types';

   COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.cat2
    IS 'Périodicité des contrôles de sécurité des ERP de catégorie 2 en fonction des types';
   
   COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.cat3
    IS 'Périodicité des contrôles de sécurité des ERP de catégorie 3 en fonction des types';
   
   COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.cat4
    IS 'Périodicité des contrôles de sécurité des ERP de catégorie 4 en fonction des types';
   
   COMMENT ON COLUMN m_erp_stage.an_erp_conf_secu.cat5
    IS 'Périodicité des contrôles de sécurité des ERP de catégorie 5 en fonction des types';

 -- permissions
   
 
ALTER TABLE m_erp_stage.an_erp_conf_secu OWNER TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.an_erp_conf_secu TO create_sig;
GRANT ALL ON TABLE m_erp_stage.an_erp_conf_secu TO sig_stage;
GRANT ALL ON TABLE m_erp_stage.an_erp_conf_secu TO sig_create;
GRANT UPDATE, SELECT, DELETE, INSERT ON TABLE m_erp_stage.an_erp_conf_secu TO sig_edit;
GRANT SELECT ON TABLE m_erp_stage.an_erp_conf_secu TO sig_read;
GRANT ALL ON TABLE m_erp_stage.an_erp_conf_secu TO aloubaresse;

   
create trigger t_t1_date_sai before
insert
    on
    m_erp_stage.an_erp_conf_secu for each row execute procedure ft_r_timestamp_sai()   ;
   

       
create trigger t_t2_date_maj before
update
    on
    m_erp_stage.an_erp_conf_secu for each row execute procedure ft_r_timestamp_maj()  ;


 insert into m_erp_stage.an_erp_conf_secu (erptype,cat1,cat2,cat3,cat4,cat5,op_sai) values
('J',3,3,3,3,5,'gbodet'),
('L',3,3,3,5,0,'gbodet'),
('M',3,3,5,5,0,'gbodet'),
('N',3,3,5,5,0,'gbodet'),
('O',3,3,3,3,5,'gbodet'),
('P',3,3,3,5,0,'gbodet'),
('R',3,3,3,3,5,'gbodet'),
('S',3,3,5,5,0,'gbodet'),
('T',3,3,5,5,0,'gbodet'),
('U',3,3,3,3,5,'gbodet'),
('V',5,5,5,5,0,'gbodet'),
('W',3,3,5,5,0,'gbodet'),
('X',3,3,5,5,0,'gbodet'),
('Y',3,3,5,5,0,'gbodet');

   
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        MEDIA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Table: m_erp_stage.an_erp_ctrl_media

-- DROP TABLE m_erp_stage.an_erp_ctrl_media;

CREATE TABLE m_erp_stage.an_erp_ctrl_media
(
  id bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_ctrl_media_gid_seq'::regclass),
  iderpctrl bigint NOT NULL,
  media text,
  miniature bytea,
  n_fichier text,
  t_fichier text,
  erp_doctyp character varying(2) NOT NULL DEFAULT '00',
  op_sai character varying(100),
  date_sai timestamp without time zone,
  date_creation timestamp without time zone DEFAULT now(),
  CONSTRAINT an_erp_ctrl_media_pkey PRIMARY KEY (id)    
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_ctrl_media IS 'Table gérant la liste des photos des objets ERP avec le module média dans GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.id IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.iderpctrl IS 'Identifiant du controle ERP (classe an_erp_securite et an_erp_accessibilite)';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.erp_doctyp IS 'Type de documents des contrôles ERP (à faire)';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.date_sai IS 'Date d''intégration du document';
COMMENT ON COLUMN m_erp_stage.an_erp_ctrl_media.date_creation IS 'Date de création du document';

-- Table: m_erp_stage.an_erp_objet_media

-- DROP TABLE m_erp_stage.an_erp_objet_media;

CREATE TABLE m_erp_stage.an_erp_objet_media
(
  id bigint NOT NULL DEFAULT nextval('m_erp_stage.an_erp_objet_media_gid_seq'::regclass),
  idobjet bigint NOT NULL,
  media text,
  miniature bytea,
  n_fichier text,
  t_fichier text,
  erp_doctyp character varying(2) NOT NULL DEFAULT '00',
  op_sai character varying(100),
  date_sai timestamp without time zone,
  date_creation timestamp without time zone DEFAULT now(),
  CONSTRAINT an_erp_objet_media_pkey PRIMARY KEY (id)    
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_objet_media IS 'Table gérant la liste des photos des objets ERP avec le module média dans GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.id IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.idobjet IS 'Identifiant de l''ERP (classe an_erp_objet)';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.erp_doctyp IS 'Type de documents';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.date_sai IS 'Date d''intégration du document';
COMMENT ON COLUMN m_erp_stage.an_erp_objet_media.date_creation IS 'Date de création du document';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        LOG                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################# TABLE an_erp_log ##################################   

-- DROP TABLE m_erp_stage.an_erp_log;

CREATE TABLE m_erp_stage.an_erp_log 
(
	idlog bigint NOT NULL, 
	tablename varchar(80) NOT NULL,
	type_ope text NOT NULL,
	dataold text NULL,
	datanew text NULL,
	date_maj timestamp NULL DEFAULT now(),
	CONSTRAINT an_erp_log_pkey PRIMARY KEY (idlog)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp_stage.an_erp_log IS 'Table des opérations effectuées sur les données activités économiques à l''insert, update et delete';
COMMENT ON COLUMN m_erp_stage.an_erp_log.idlog IS 'Identifiant unique';
COMMENT ON COLUMN m_erp_stage.an_erp_log.tablename IS 'Nom de la classe concernée par une opération';
COMMENT ON COLUMN m_erp_stage.an_erp_log.type_ope IS 'Type d''opération';
COMMENT ON COLUMN m_erp_stage.an_erp_log.dataold IS 'Anciennes données';
COMMENT ON COLUMN m_erp_stage.an_erp_log.datanew IS 'Nouvelles données';
COMMENT ON COLUMN m_erp_stage.an_erp_log.date_maj IS 'Date d''exécution de l''opération';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                    CONTRAINTE                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


ALTER TABLE m_erp_stage.an_erp_objet
    ADD CONSTRAINT lt_erp_objet_cat_fkey FOREIGN KEY (cat)
        REFERENCES m_erp_stage.lt_erp_objet_cat (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_erptype_fkey FOREIGN KEY (erptype)
        REFERENCES m_erp_stage.lt_erp_objet_erptype (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_etat_fkey FOREIGN KEY (etat)
        REFERENCES m_erp_stage.lt_erp_objet_etat (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_gestion_fkey FOREIGN KEY (gestion)
        REFERENCES m_erp_stage.lt_erp_gestion (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_objet_groupement_fkey FOREIGN KEY (groupement)
        REFERENCES m_erp_stage.lt_erp_groupement (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO action,
    ADD CONSTRAINT lt_erp_objet_loc_som_fkey FOREIGN KEY (loc_som)
        REFERENCES r_objet.lt_booleen (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO action;
       
       
ALTER TABLE m_erp_stage.an_erp_securite
    ADD CONSTRAINT lt_erp_controle_commission_fkey FOREIGN KEY (commission)
        REFERENCES m_erp_stage.lt_erp_controle_commission (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,  
    ADD CONSTRAINT lt_erp_controle_avis_exp_fkey FOREIGN KEY (avis_expert)
        REFERENCES m_erp_stage.lt_erp_controle_avis (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_controle_avis_com_fkey FOREIGN KEY (avis_com)
        REFERENCES m_erp_stage.lt_erp_controle_avis (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
        
ALTER TABLE m_erp_stage.an_erp_accessibilite
    ADD CONSTRAINT lt_erp_controle_commission_fkey FOREIGN KEY (commission)
        REFERENCES m_erp_stage.lt_erp_controle_commission (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,  
    ADD CONSTRAINT lt_erp_controle_avis_exp_fkey FOREIGN KEY (avis_expert)
        REFERENCES m_erp_stage.lt_erp_controle_avis (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT lt_erp_controle_avis_com_fkey FOREIGN KEY (avis_com)
        REFERENCES m_erp_stage.lt_erp_controle_avis (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
        
ALTER TABLE m_erp_stage.an_erp_exploitant
    ADD CONSTRAINT lt_erp_exploitant_civilite_fkey FOREIGN KEY (civilite)
        REFERENCES m_erp_stage.lt_erp_exploitant_civilite (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
 
ALTER TABLE m_erp_stage.an_erp_ctrl_media
    ADD CONSTRAINT lt_erp_ctrl_media_doctyp_fkey FOREIGN KEY (erp_doctyp)
        REFERENCES m_erp_stage.lt_erp_ctrl_media_doctyp (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
		
ALTER TABLE m_erp_stage.an_erp_objet_media
    ADD CONSTRAINT lt_erp_objet_media_doctyp_fkey FOREIGN KEY (erp_doctyp)
        REFERENCES m_erp_stage.lt_erp_objet_media_doctyp (code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION;
        
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       INDEX                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
/*

CREATE INDEX .... ON m_erp_stage. USING btree (.....);
CREATE INDEX .... ON m_erp_stage. USING gist (geom);
*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     FONCTION                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION/TRIGGER ft_m_refresh_adresse_erp ###############################################
-- DROP FUNCTION m_erp_stage.ft_m_refresh_adresse_erp();

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_refresh_adresse_erp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

begin


refresh materialized view m_erp_stage.xapps_geo_vmr_erp_adresse;
refresh materialized view m_erp_stage.xapps_geo_vmr_erp;

 return new ;
  
END;

$function$
;

COMMENT ON FUNCTION m_erp_stage.ft_m_refresh_adresse_erp() IS 'Fonction générant le rafraichissement de la vue adresse après insertion d''ERP';

-- Permissions

ALTER FUNCTION m_erp_stage.ft_m_refresh_adresse_erp() OWNER TO aloubaresse;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_refresh_adresse_erp() TO public;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_refresh_adresse_erp() TO aloubaresse;


-- #################################################################### FONCTION/TRIGGER ft_m_refresh_periode_contsecu_erp ###############################################
-- DROP FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp();

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

begin

refresh materialized view m_erp_stage.xapps_an_v_erp_contsecu_periode;

 return new ;
  
END;

$function$
;

COMMENT ON FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp() IS 'Fonction générant le rafraichissement de la vue calculant la date du prochain contrôle de sécurité';

-- Permissions

ALTER FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp() OWNER TO aloubaresse;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp() TO public;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_refresh_periode_contsecu_erp() TO aloubaresse;


-- #################################################################### FONCTION/TRIGGER ERP_OBJET ###############################################


-- DROP FUNCTION m_erp_stage.ft_m_erp_objet();

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_erp_objet()
RETURNS trigger
LANGUAGE plpgsql
AS $function$

BEGIN

     IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
     
-- vérifier que le type principal n'appartient pas à la liste des types secondaires
IF POSITION(NEW.erptype IN NEW.erptype_2) > 0 THEN
  RAISE EXCEPTION 'Erreur : Le type principal ne peut pas appartenir aux types secondaires';
  END IF;

-- vérifier que "non concerné" n'appartiennent pas à la liste des types secondaires si il y en a au moins un
IF (LENGTH(NEW.erptype_2) > 2) AND (POSITION('ZZ' IN NEW.erptype_2) > 0) THEN
  RAISE EXCEPTION 'Erreur : l''ERP ne peut pas être non concerné si il possède au moins un type secondaire';
  END IF;

 
 IF LENGTH(NEW.siret) <> 14 THEN
  RAISE EXCEPTION 'Erreur : le code SIRET est incomplet<br><br>';
  END IF;

 /*
IF NEW.eff_total<NEW.eff_heberg+NEW.eff_public+NEW.eff_nuit+NEW.eff_pers THEN
RAISE EXCEPTION 'Erreur : L''effectif total ne peut pas être inférieur à la somme des autres effectifs';
  END IF;
  */
-- vérifier que la date de de fermeure est postérieure à celle d'ouverture'
IF NEW.d_ferme <= NEW.d_ouvert THEN
  RAISE EXCEPTION 'Erreur : La date de fermeture doit être postérieure à la date d''ouverture<br><br>';
  END IF;
  
 END IF;

  IF (TG_OP = 'INSERT') THEN
    NEW.libelle := UPPER(TRIM(NEW.libelle)); 
    NEW.date_sai := current_timestamp;
    NEW.date_maj := NULL;    
   
  ELSIF (TG_OP = 'UPDATE') THEN
     NEW.libelle := UPPER(TRIM(NEW.libelle));
     NEW.date_maj := current_timestamp;
     NEW.date_maj := NULL;    


  ELSIF (TG_OP = 'DELETE') THEN
     IF (OLD.groupement = '30') THEN
       RAISE EXCEPTION 'Erreur : Vous ne pouvez pas supprimer un ERP Maitre. Contactez le service SIG';
     END IF;
     if (select count(*) from m_erp_stage.an_erp_securite s where s.idobjet = old.idobjet) > 0 or 
        (select count(*) from m_erp_stage.an_erp_accessibilite a where a.idobjet = old.idobjet) > 0
         then 
          RAISE EXCEPTION 'Vous ne pouvez pas supprimer un ERP disposant de contrôles. Vous devez indiquer "FERME" dans l''état de l''ERP.<br><br>';
     else
     return old;
     END if;
    
  
  END IF;
    RETURN NEW;
END;
$function$
;

-- Permissions

ALTER FUNCTION m_erp_stage.ft_m_erp_objet() OWNER TO aloubaresse;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_erp_objet() TO public;
GRANT ALL ON FUNCTION m_erp_stage.ft_m_erp_objet() TO aloubaresse;


-- #################################################################### FONCTION/TRIGGER ERP_CTRL_S ###############################################

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_erp_ctrl_s() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

-- ## controle des temporalités de saisie des dates

  -- vérifier que la date de d_visite est postérieure à celle de d_convoc
  IF NEW.d_visite <= NEW.d_convoc THEN
  RAISE EXCEPTION 'Erreur : La date de visite doit être postérieure à la date de convocation<br><br>';
  END IF;
  -- vérifier que les dates d'avis d_avis_exp est postérieure à celle de d_visite
  IF NEW.d_avis_exp <= NEW.d_visite THEN
  RAISE EXCEPTION 'Erreur : La date de retour de l''avis de l''expert doit être postérieure à la date de visite<br><br>';
  END IF;     
  -- vérifier que la date de d_avis_com est postérieure à celle de d_visite
  IF NEW.d_avis_com <= NEW.d_visite THEN
  RAISE EXCEPTION 'Erreur : La date de la décision doit être postérieure à la date de visite<br><br>';
  END IF;
  
  
  IF (TG_OP = 'INSERT') THEN
    NEW.date_sai := current_timestamp;
   
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.date_maj := current_timestamp;        


  END IF;

       
RETURN NEW;

END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_ctrl_s on m_erp_stage.an_erp_s;
CREATE TRIGGER t_t1_m_erp_ctrl_s
BEFORE INSERT OR UPDATE
ON m_erp_stage.an_erp_securite
FOR EACH ROW EXECUTE PROCEDURE m_erp_stage.ft_m_erp_ctrl_s();

-- #################################################################### FONCTION/TRIGGER ERP_CTRL_A ###############################################

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_erp_ctrl_a() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

-- ## controle des temporalités de saisie des dates

  -- vérifier que la date de d_visite est postérieure à celle de d_convoc
  IF NEW.d_visite <= NEW.d_convoc THEN
  RAISE EXCEPTION 'Erreur : La date de visite doit être postérieure à la date de convocation<br><br>';
  END IF;
  -- vérifier que les dates d'avis d_avis_exp est postérieure à celle de d_visite
  IF NEW.d_avis_exp <= NEW.d_visite THEN
  RAISE EXCEPTION 'Erreur : La date de retour de l''avis de l''expert doit être postérieure à la date de visite<br><br>';
  END IF;     
  -- vérifier que la date de d_avis_com est postérieure à celle de d_visite
  IF NEW.d_avis_com <= NEW.d_visite THEN
  RAISE EXCEPTION 'Erreur : La date de la décision doit être postérieure à la date de visite<br><br>';
  END IF;
  
  IF (TG_OP = 'INSERT') THEN
    NEW.date_sai := current_timestamp;
    
  
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.date_maj := current_timestamp;        

    
  END IF;

       
RETURN NEW;

END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_ctrl_a on m_erp_stage.an_erp_a;
CREATE TRIGGER t1_m_erp_ctrl_a
BEFORE INSERT OR UPDATE 
ON m_erp_stage.an_erp_accessibilite
FOR EACH ROW EXECUTE PROCEDURE m_erp_stage.ft_m_erp_ctrl_a();

-- #################################################################### FONCTION/TRIGGER ERP_POINT_UTILISATEUR ###############################################

CREATE OR REPLACE FUNCTION m_erp_stage.ft_m_erp_point_utilisateur() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN
  
  
  IF (TG_OP = 'INSERT') THEN
    NEW.x_l93 = ST_X(new.geom);
    NEW.y_l93 = ST_Y(new.geom);
   
  ELSIF (TG_OP = 'UPDATE') THEN
    NEW.x_l93 = ST_X(new.geom);
    NEW.y_l93 = ST_Y(new.geom);        


  END IF;

       
RETURN NEW;

END;
$$
;

-- DROP TRIGGER IF EXISTS t_m_erp_point_utilisateur on m_erp_stage.geo_erp_point_utilisateur;
CREATE TRIGGER t_m_erp_point_utilisateur
BEFORE INSERT OR UPDATE
ON m_erp_stage.geo_erp_point_utilisateur
FOR EACH ROW EXECUTE PROCEDURE m_erp_stage.ft_m_erp_point_utilisateur();
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


create trigger t_t1_erp_objet before
insert or update or delete
    on
    m_erp_stage.an_erp_objet for each row execute procedure m_erp_stage.ft_m_erp_objet();

create trigger t_t2_erp_refresh_adresse after
insert or update or delete
    on
    m_erp_stage.an_erp_objet for each row execute procedure m_erp_stage.ft_m_refresh_adresse_erp();
   
create trigger t_t2_erp_refresh_adresse after
insert or update or delete
    on
    m_erp_stage.geo_erp_point_utilisateur for each row execute procedure m_erp_stage.ft_m_refresh_adresse_erp();   
   
create trigger t_t2_erp_refresh_periode after
insert or update or delete
    on
    m_erp_stage.an_erp_securite for each row execute procedure m_erp_stage.ft_m_refresh_periode_contsecu_erp();
   
   
create trigger t_t3_erp_refresh_adresse after
insert
    or
delete
    or
update
    on
    m_erp_stage.an_erp_securite for each row execute procedure m_erp_stage.ft_m_refresh_adresse_erp();
   
create trigger t_t3_erp_refresh_adresse after
insert
    or
delete
    or
update
    on
    m_erp_stage.an_erp_accessibilite for each row execute procedure m_erp_stage.ft_m_refresh_adresse_erp();     

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUE APPLICATIVE                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

   
-- vue générant les dates des prochains contrôles de sécurité pour les ERP avec un contrôle favorable
       
-- m_spanc.xapps_an_v_erp_contsecu_periode
   
   
-- calcul de la date du prochain contrôle de sécurité
-- uniquement sur les contrôles de sécurité FAVORABLE
-- local en sommeil OUI uniquement (si NR ou NON pas pris en compte)
CREATE MATERIALIZED VIEW m_erp_stage.xapps_an_v_erp_contsecu_periode
TABLESPACE pg_default
AS
with req_dcont as
(
SELECT 
	a.idobjet,
	a.d_visite,
	b_1.valeur as cat,
	b_1.erptype,
	b_1.loc_som,
	(
		select
			case 
			when b_1.valeur = '1' then s.cat1 
			when b_1.valeur = '2' then s.cat2  
			when b_1.valeur = '3' then s.cat3
			when b_1.valeur = '4' then s.cat4 
			when b_1.valeur = '5' then s.cat5 else null end
		from 
			m_erp_stage.an_erp_conf_secu s where erptype = b_1.erptype
	) as periode
FROM 
	m_erp_stage.an_erp_securite a 
JOIN
	(SELECT s.idobjet, o.erptype, o.loc_som , c.valeur, max(s.d_visite) AS d_visite 
		FROM m_erp_stage.an_erp_securite s, m_erp_stage.an_erp_objet o, m_erp_stage.lt_erp_objet_cat c
		where s.idobjet = o.idobjet and c.code = o.cat and s.avis_com = '30' and o.cat <> '00'
		GROUP BY s.idobjet, o.erptype, o.cat,o.loc_som, c.valeur) b_1 
		ON a.idobjet = b_1.idobjet AND a.d_visite = b_1.d_visite
)
select 
	idobjet,
	d_visite,
	cat,
	erptype,
	loc_som,
	periode,
	case 
	  when cat <> '5' and erptype in ('J','L','M','N','O','P','S','T','U','V','W','X','Y')
	  then to_char((d_visite::date + (periode::text || ' year'::text)::interval)::date,'DD-MM-YYYY')
	  when cat = '5' and erptype in ('J','O','U') and loc_som = 't'
  	  then to_char((d_visite::date + (periode::text || ' year'::text)::interval)::date,'DD-MM-YYYY')
  	  when cat IN ('1','2','3','4','5') and erptype = 'R' and loc_som = 't'
  	  then to_char((d_visite::date + (periode::text || ' year'::text)::interval)::date,'DD-MM-YYYY')
  	  when cat IN ('1','2','3') and erptype = 'R' and loc_som IN ('f','0')
  	  then to_char((d_visite::date + (periode::text || ' year'::text)::interval)::date,'DD-MM-YYYY')
  	  when cat = '4' and erptype = 'R' and loc_som IN ('f','0')
  	  then to_char((d_visite::date + ('5'::text || ' year'::text)::interval)::date,'DD-MM-YYYY')
	else 'Non concerné' end as date_pcontlsecu  
from 
	req_dcont

WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp_stage.xapps_an_v_erp_contsecu_periode IS 'Vue générant les dates des prochains contrôles de sécurité pour les ERP avec un contrôle favorable';

-- Permissions


ALTER TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode OWNER TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO create_sig;
GRANT ALL ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO sig_create;
GRANT DELETE, INSERT, UPDATE, SELECT ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO sig_edit WITH GRANT OPTION;
GRANT SELECT ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO sig_read WITH GRANT OPTION;
GRANT ALL ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO sig_stage;
GRANT ALL ON TABLE m_erp_stage.xapps_an_v_erp_contsecu_periode TO aloubaresse;
   
-- vue matérialisée récupérant toutes les adresses de Compiègne avec le nombre d'ERP présent
       
-- m_erp_stage.xapps_geo_vmr_erp_adresse source
CREATE MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp_adresse
TABLESPACE pg_default
AS WITH req_ad AS (
         SELECT a_1.id_adresse,
            a_1.commune,
            a_1.libvoie_c,
            a_1.numero,
            a_1.repet,
            ((((((((a_1.numero::text ||
                CASE
                    WHEN a_1.repet IS NOT NULL OR a_1.repet::text <> ''::text THEN a_1.repet
                    ELSE ''::character varying
                END::text) || ' '::text) || a_1.libvoie_c::text) ||
                CASE
                    WHEN a_1.ld_compl IS NULL OR a_1.ld_compl::text = ''::text THEN ''::text
                    ELSE chr(10) || a_1.ld_compl::text
                END) ||
                CASE
                    WHEN a_1.complement IS NULL OR a_1.complement::text = ''::text THEN ''::text
                    ELSE chr(10) || a_1.complement::text
                END) || chr(10)) || a_1.codepostal::text) || ' '::text) || a_1.commune::text AS adresse,
            a_1.mot_dir,
            a_1.libvoie_a,
            e.iepci,
            a_1.geom
           FROM x_apps.xapps_geo_vmr_adresse a_1,
            r_administratif.an_geo g,
            r_osm.geo_osm_epci e
          WHERE a_1.insee = g.insee::bpchar AND e.cepci::text = g.epci::text AND a_1.commune::text = 'Compiègne'::text
        ), req_erp AS (
         SELECT o.id_adresse,
            count(*) AS nb_erp
           FROM m_erp_stage.an_erp_objet o where o.etat IN ('00','10','20')
          GROUP BY o.id_adresse
        )
SELECT
        CASE
            WHEN req_erp.nb_erp IS NULL THEN 0::bigint
            ELSE req_erp.nb_erp
        END AS nb_erp,
    req_ad.id_adresse,
    req_ad.commune,
    req_ad.libvoie_c,
    req_ad.numero,
    req_ad.repet,
    req_ad.adresse,
    req_ad.mot_dir,
    req_ad.libvoie_a,
    req_ad.iepci,
    req_ad.geom
   FROM req_ad
     LEFT JOIN req_erp ON req_ad.id_adresse = req_erp.id_adresse

WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp_adresse IS 'Vue matérialisée rafraichie applicative le nombre d''ERP à l''adresse pour le fonctionnel de saisie GEO';

-- Permissions

ALTER TABLE m_erp_stage.xapps_geo_vmr_erp_adresse OWNER TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO create_sig;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO sig_create;
GRANT DELETE, UPDATE, SELECT, INSERT ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO sig_edit WITH GRANT OPTION;
GRANT SELECT ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO sig_read WITH GRANT OPTION;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_adresse TO sig_stage;


/*
-- vue cartographique affichant les ERP saisis via une adresse ou un point

-- m_erp_stage.geo_v_erp

CREATE OR REPLACE VIEW m_erp_stage.geo_v_erp
AS 

select 
'bal_' || erp_a.id_adresse as gid,
erp_a.nb_erp,
erp_a.geom
from
m_erp_stage.xapps_geo_vmr_erp_adresse erp_a
where nb_erp <> 0
union ALL
select 
'erp_' || p.idobjet as gid,
count(*) as nb_erp,
p.geom
from
m_erp_stage.geo_erp_point_utilisateur p join m_erp_stage.an_erp_objet o on p.idobjet = o.idobjet
group by p.idobjet;

COMMENT ON VIEW m_erp_stage.geo_v_erp IS 'Vue affichant les ERP saisis (pas de gestion)';

-- Permissions


ALTER TABLE m_erp_stage.geo_v_erp OWNER TO postgres;
GRANT ALL ON TABLE m_erp_stage.geo_v_erp TO create_sig;
GRANT ALL ON TABLE m_erp_stage.geo_v_erp TO sig_create;
GRANT DELETE, INSERT, UPDATE, SELECT ON TABLE m_erp_stage.geo_v_erp TO sig_edit WITH GRANT OPTION;
GRANT SELECT ON TABLE m_erp_stage.geo_v_erp TO sig_read WITH GRANT OPTION;
GRANT ALL ON TABLE m_erp_stage.geo_v_erp TO sig_stage;
GRANT ALL ON TABLE m_erp_stage.geo_v_erp TO aloubaresse;
*/


CREATE MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp
TABLESPACE pg_default
AS SELECT 'bal_'::text || erp_a.id_adresse AS gid,
    erp_a.nb_erp,
    erp_a.geom
   FROM m_erp_stage.xapps_geo_vmr_erp_adresse erp_a
  WHERE erp_a.nb_erp <> 0
UNION ALL
 SELECT 'erp_'::text || p.idobjet AS gid,
    count(*) AS nb_erp,
    p.geom
   FROM m_erp_stage.geo_erp_point_utilisateur p
     JOIN m_erp_stage.an_erp_objet o ON p.idobjet = o.idobjet
  GROUP BY p.idobjet
 
  WITH DATA;

COMMENT on MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp IS 'Vue affichant les ERP saisis (pas de gestion) (à supprimer à la production, remplacé par xapps_geo_vmr_erp_gb';

-- Permissions

ALTER TABLE m_erp_stage.xapps_geo_vmr_erp OWNER TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp TO create_sig;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp TO sig_create;
GRANT UPDATE, INSERT, DELETE, SELECT ON TABLE m_erp_stage.xapps_geo_vmr_erp TO sig_edit WITH GRANT OPTION;
GRANT SELECT ON TABLE m_erp_stage.xapps_geo_vmr_erp TO sig_read WITH GRANT OPTION;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp TO sig_stage;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp TO aloubaresse;


-- vue générant l'affichage carto selon l'état du dernier contrôle des ERP à une même adresse

-- m_erp_stage.xapps_geo_vmr_erp source
-- m_erp_stage.xapps_geo_vmr_erp source

CREATE MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp_gb
TABLESPACE pg_default
AS 

with req_nb as
(
SELECT 'bal_'::text || erp_a.id_adresse AS gid,
    erp_a.nb_erp,
    erp_a.geom
   FROM m_erp_stage.xapps_geo_vmr_erp_adresse erp_a
  WHERE erp_a.nb_erp <> 0
UNION ALL
 SELECT 'erp_'::text || p.idobjet AS gid,
    count(*) AS nb_erp,
    p.geom
   FROM m_erp_stage.geo_erp_point_utilisateur p
     JOIN m_erp_stage.an_erp_objet o ON p.idobjet = o.idobjet
  GROUP BY p.idobjet
), 
req_acces as
	(	
	select distinct 
	 r_1.gid,
	 max(r_1.d_visite) as d_visite,
	 min(b_2.tri) as tri
	 from
	(
		SELECT 
		case when 'bal_' || b_1.id_adresse is not null then 'bal_' || b_1.id_adresse
		else 'erp_' || b_1.idobjet end as gid,
		a.d_visite,
		a.avis_com
		FROM m_erp_stage.an_erp_accessibilite a 
		join
			(SELECT o.id_adresse, o.idobjet, max(s.d_visite) AS d_visite
			FROM m_erp_stage.an_erp_objet o
			left join m_erp_stage.an_erp_accessibilite s on s.idobjet = o.idobjet
			where o.etat in ('00','10','20')
			GROUP BY o.id_adresse,o.idobjet) b_1 
		ON a.d_visite = b_1.d_visite and a.idobjet = b_1.idobjet 
	 ) r_1 join 
			(select o.id_adresse, o.idobjet,min(lta.tri) as tri
			from m_erp_stage.an_erp_objet o , m_erp_stage.lt_erp_controle_avis lta, 
			m_erp_stage.an_erp_accessibilite s
			where lta.code = s.avis_com and o.idobjet = s.idobjet and o.etat in ('00','10','20')
			group by o.id_adresse,o.idobjet) b_2
		ON b_2.tri = 
		case 
			when r_1.avis_com = '10' then 1 
			when r_1.avis_com = '11' then 3
			when r_1.avis_com = '20' then 2
			when r_1.avis_com = '30' then 4
			when r_1.avis_com = '00' then 5
		end
		group by gid
	), 
req_secu as
	(	
	select distinct 
	 r_1.gid,
	 max(r_1.d_visite) as d_visite,
	 min(b_2.tri) as tri
	 from
	(
		SELECT 
		case when 'bal_' || b_1.id_adresse is not null then 'bal_' || b_1.id_adresse
		else 'erp_' || b_1.idobjet end as gid,
		a.d_visite,
		a.avis_com
		FROM m_erp_stage.an_erp_securite a 
		join
			(SELECT o.id_adresse, o.idobjet, max(s.d_visite) AS d_visite
			FROM m_erp_stage.an_erp_objet o
			left join m_erp_stage.an_erp_securite s on s.idobjet = o.idobjet
			where o.etat in ('00','10','20')
			GROUP BY o.id_adresse,o.idobjet) b_1 
		ON a.d_visite = b_1.d_visite and a.idobjet = b_1.idobjet
	 ) r_1 join 
			(select o.id_adresse, o.idobjet,min(lta.tri) as tri
			from m_erp_stage.an_erp_objet o , m_erp_stage.lt_erp_controle_avis lta, 
			m_erp_stage.an_erp_securite s
			where lta.code = s.avis_com and o.idobjet = s.idobjet and o.etat in ('00','10','20')
			group by o.id_adresse,o.idobjet) b_2
		ON b_2.tri = 
		case 
			when r_1.avis_com = '10' then 1 
			when r_1.avis_com = '11' then 3
			when r_1.avis_com = '20' then 2
			when r_1.avis_com = '30' then 4
			when r_1.avis_com = '00' then 5
		end
		group by gid
	)	
select 
    row_number() over() as id,
	n.gid,
	n.nb_erp,
	--a.d_visite as d_visite_a ,
	case when a.tri is not null then a.tri else 5 end as tri_a,
	--s.d_visite as d_visite_s,
	case when s.tri is not null then s.tri else 5 end as tri_s,
	case when s.tri is not null then ltas.code else '00' end || 
	case when a.tri is not null then ltaa.code else '00' end as matrice,
	-- matrice de confusion pour afficher le plus mauvais entre avis sécritué et accessiblité
	CASE 
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '3030' then '30'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1030' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1130' then '11'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '2030' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '0030' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '3010' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1010' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1110' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '2010' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '0010' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '3011' then '11'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1011' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1111' then '11'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '2011' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '0011' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '3020' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1020' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1120' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '2020' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '0020' then '20'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '3000' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1000' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '1100' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '2000' then '10'
		WHEN case when s.tri is not null then ltas.code else '00' end || case when a.tri is not null then ltaa.code else '00' end = '0000' then '00'
	ELSE
	    '00'
	end as picto_carto,
	n.geom
from 
	req_nb n
left join req_acces a on n.gid = a.gid
left join req_secu s on n.gid  = s.gid
left join m_erp_stage.lt_erp_controle_avis ltaa on ltaa.tri = a.tri
left join m_erp_stage.lt_erp_controle_avis ltas on ltas.tri = s.tri
  

WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp_stage.xapps_geo_vmr_erp_gb IS 'Vue affichant les ERP à l''adresse ou temporaire en présentant le nombre et le dernier état du contrôle de l''ensemble des ERP rpésents (l''état le plus mauvais qui s''affiche';

-- Permissions

ALTER TABLE m_erp_stage.xapps_geo_vmr_erp_gb OWNER TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO create_sig;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO sig_create;
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO sig_edit WITH GRANT OPTION;
GRANT SELECT ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO sig_read WITH GRANT OPTION;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO aloubaresse;
GRANT ALL ON TABLE m_erp_stage.xapps_geo_vmr_erp_gb TO sig_stage;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUE OPEN DATA                                                                    ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       DROITS                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/* cf grégory */
