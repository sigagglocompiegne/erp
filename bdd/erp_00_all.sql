/*Creation du fichier complet*/
/* init_db_erp_v6_GB_phase_2.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ 
 Auteurs : Grégory Bodet (appui sur les versions de Florent Vanhoutte et Alice Loubaresse (stagiaire 2023-2024) */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                       SCHEMA                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

/*
-- SCHEMA: m_erp

DROP SCHEMA IF EXISTS m_erp CASCADE;

CREATE SCHEMA m_erp;

COMMENT ON SCHEMA m_erp IS 'Schéma de gestion des ERP (�tablissement recevant du public) - phase 2 intégration des évènements';


*/
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINE  DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################   lt_erp_contact_fonction ###############################################


-- nom de la table : lt_erp_contact_fonction


-- DROP TABLE m_erp.lt_erp_contact_fonction;

CREATE TABLE m_erp.lt_erp_contact_fonction
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_contact_fonction_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_contact_fonction IS 'Liste permettant de décrire les différentes fonctions des contacts dans la gestion des bassins (GEP : Gestion des Eaux Pluviales)';
COMMENT ON COLUMN m_erp.lt_erp_contact_fonction.code IS 'Code de la classe décrivant la fonction';
COMMENT ON COLUMN m_erp.lt_erp_contact_fonction.valeur IS 'Valeur de la classe décrivant la fonction';
COMMENT ON CONSTRAINT lt_erp_contact_fonction_pkey ON m_erp.lt_erp_contact_fonction IS 'Clé primaire du domaine de valeur lt_erp_contact_fonction';

INSERT INTO m_erp.lt_erp_contact_fonction(
            code, valeur)
    VALUES
  ('00', 'Non renseigné'),
  ('01', 'Exploitant'),
  ('02', 'Architecte'),
  ('03', 'Technicien'),
  ('04', 'Responsable unique'),
  ('99', 'Autre');



-- ################################################################# lt_erp_objet_cat ###############################################

-- ajout de la table de liste "m_erp.lt_erp_objet_cat"

CREATE TABLE  m_erp.lt_erp_objet_cat
(
	code character varying(1) NOT NULL,
	valeur character varying(20) NOT NULL,
    descrip character varying(100),
	CONSTRAINT lt_erp_objet_cat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_cat IS 'Liste permettant de décrire la catégorie d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_cat.code IS 'Code de la liste énumérée relative à la catégorie d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_cat.valeur IS 'Valeur de la liste énumérée relative à la catégorie d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_cat.descrip IS 'Description de la liste énumérée relative à la catégorie d''un ERP';
COMMENT ON CONSTRAINT lt_erp_objet_cat_pkey ON m_erp.lt_erp_objet_cat IS 'Clé primaire du domaine de valeur lt_erp_objet_cat';

INSERT INTO m_erp.lt_erp_objet_cat(
            code, valeur, descrip)
    VALUES
  ('0','Non renseigné',NULL),
  ('1','1','Au dessus de 1500 personnes'),
  ('2','2','De 701 à 1500 personnes'),
  ('3','3','De 301 à 700 personnes'),
  ('4','4','Jusqu''à 300 personnes'),
  ('5','5','Inférieur aux seuils fixés pour la 5e catégorie');

-- ################################################################# lt_erp_objet_erptype ###############################################

-- ajout de la table de liste "m_erp.lt_erp_objet_erptype"

CREATE TABLE  m_erp.lt_erp_objet_erptype
(
	code character varying(3) NOT NULL,
	valeur character varying(150) NOT NULL,
    tri integer NOT NULL,
    cle text,
	CONSTRAINT lt_erp_objet_erptype_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_erptype IS 'Liste permettant de décrire le type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erptype.code IS 'Code de la liste énumérée relative au type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erptype.valeur IS 'Valeur de la liste énumérée relative au type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erptype.tri IS 'Ordre de tri de la liste énumérée relative au type d''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_erptype.cle IS 'Clé de liste UUID V4 pour le multi-valué permettant une recherche en like';
COMMENT ON CONSTRAINT lt_erp_objet_erptype_pkey ON m_erp.lt_erp_objet_erptype IS 'Clé primaire du domaine de valeur lt_erp_objet_erptype';

INSERT INTO m_erp.lt_erp_objet_erptype(
            code, valeur, tri,cle)
    VALUES
  ('00','Non renseigné',1,'e4cbbc85-72b9-456d-94fa-1c2928324c3a'),
  ('J','Structures d''accueil pour personnes âgées et personnes handicapées',2,'f43dbff6-2259-4bba-94fc-e41782b1f1b6'),
  ('L','Salles d''auditions, de conférences, de réunions, de spectacles ou polyvalentes',3,'7f267c5a-57dc-4ba5-bb18-423b95a40acc'),
  ('M','Magasins de vente, centres commerciaux',4,'df15a441-cdca-4503-80b0-d60d2b4ede43'),
  ('N','Restaurants et débits de boissons',5,'44df23e4-bfa1-4c08-af5c-4f3219f6a699'),
  ('O','Hôtels et pensions de famille',6,'232995ce-9abe-419f-afa6-702b9e92b455'),
  ('P','Salles de danses et salles de jeux',7,'8b0b17f3-faa8-48d2-9c83-b897c284c82d'),
  ('R','Établissements d''éveil, d''enseignement, de formation, centres de vacances, centres de loisirs sans hébergement',8,'40b9a616-1efc-4fb9-98b1-c89a90f4333c'),
  ('S','Bibliothèques, centres de documentation',9,'70019419-a9e2-4589-a401-7c5e6175ef79'),
  ('T','Salles d''expositions',10,'f7356e54-9ede-489f-a7c9-5aecaf2f944b'),
  ('U','Établissements sanitaires',11,'dc71596f-b78a-4b2f-aeee-493c92f51d56'),
  ('V','Établissement de culte',12,'51335594-fb3f-4177-a5ac-a99feeae4296'),
  ('W','Administrations, banques, bureaux',13,'bed6a009-7317-41e3-b37b-f198b88605d4'),
  ('X','Établissements sportifs couverts',14,'8a13ab60-fa35-4030-9fe4-809154d3417a'),
  ('Y','Musées',15,'eda18498-cdad-4cf8-8507-403414ef2744'),
  ('GA','Gares',16,'f4b7b317-81f5-4197-b7b4-7b9a27093e8b'),
  ('PA','Établissements de plein air',17,'01994984-e941-4fed-833e-ef397777ad87'),
  ('PS','Parcs de stationnement couverts',18,'59ef1825-843d-4df9-a7ff-bc6fe71553a0'),
  ('EF','Établissements flottants',19,'75c284e8-64e8-4737-b8a9-09e547f4e3dc'),
  ('SG','Structure gonflable',20,'50db47dd-af8d-421e-b476-a3bdb42a919d'),
  ('CTS','Chapiteaux, tentes et structures',21,'d6e0e679-842c-4d3f-9cd5-e92ff943d04b');
  --('OA','Hôtels-restaurants d altitude',22),
  --('REF','Refuges de montagne',23),



-- ################################################################# lt_erp_objet_etat ###############################################

-- ajout de la table de liste "m_erp.lt_erp_objet_etat"

CREATE TABLE  m_erp.lt_erp_objet_etat
(
	code character varying(2) NOT NULL,
	valeur character varying(30) NOT NULL,
	CONSTRAINT lt_erp_objet_etat_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_etat IS 'Liste permettant de décrire l''état d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_etat.code IS 'Code de la liste énumérée relative à l''état d''un ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_etat.valeur IS 'Valeur de la liste énumérée relative à l''état d''un ERP';
COMMENT ON CONSTRAINT lt_erp_objet_etat_pkey ON m_erp.lt_erp_objet_etat IS 'Clé primaire du domaine de valeur lt_erp_objet_etat';

INSERT INTO m_erp.lt_erp_objet_etat(
            code, valeur)
    VALUES
  ('10','En création'),
  ('11','Autorisé'),
  ('20','Ouvert'),
  ('21','Ouvert (sans autorisation)'),
  ('22','Ouvert (en attente conformité)'),
  ('30','Fermé temporairement'),
  ('31','Fermé'),
  ('40','Refusé')
  ;


 
-- ################################################################# lt_erp_objet_group ###############################################

-- ajout de la table de liste "m_erp.lt_erp_objet_group"

CREATE TABLE m_erp.lt_erp_objet_group
(
    code character varying(2) NOT NULL,
    valeur character varying(30) NOT NULL,
    CONSTRAINT lt_erp_objet_group_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_group IS 'Liste permettant de décrire l''appartenance d''un ERP à un groupement';
COMMENT ON COLUMN m_erp.lt_erp_objet_group.code IS 'Code de la liste énumérée relative à l''appartenance d''un ERP à un groupement';
COMMENT ON COLUMN m_erp.lt_erp_objet_group.valeur IS 'Valeur de la liste énumérée relative à l''appartenance d''un ERP à un groupement';
COMMENT ON CONSTRAINT lt_erp_objet_group_pkey ON m_erp.lt_erp_objet_group IS 'Clé primaire du domaine de valeur lt_erp_objet_group';

INSERT INTO m_erp.lt_erp_objet_group(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('10','ERP indépendant'),
  ('20','Membre d''un groupement'),
  ('30','Maitre d''un groupement'); 



-- ################################################################# lt_erp_objet_media_doctype ###############################################

-- ajout de la table de liste "lt_erp_objet_media_doctype"

CREATE TABLE  m_erp.lt_erp_objet_media_doctype
(
	code character varying(2) NOT NULL,
	valeur character varying(80) NOT NULL,
	CONSTRAINT lt_erp_objet_media_doctype_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_media_doctype IS 'Liste permettant de décrire le type de documents (média) pour les ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_media_doctype.code IS 'Code de la liste énumérée relative au type de document (média) pour les ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_media_doctype.valeur IS 'Valeur de la liste énumérée relative au type de document (média) pour les ERP';
COMMENT ON CONSTRAINT lt_erp_objet_media_doctype_pkey ON m_erp.lt_erp_objet_media_doctype IS 'Clé primaire du domaine de valeur lt_erp_objet_media_doctype';

INSERT INTO m_erp.lt_erp_objet_media_doctype(
            code, valeur)
    VALUES
  ('00','Non renseigné'),      
  ('10','Courrier'),
  ('20','Plan'),
  ('80','Photographie'),
  ('99','Autre document');


-- #################################################################   lt_erp_objet_src ###############################################


-- nom de la table : lt_erp_objet_src


-- DROP TABLE m_erp.lt_erp_objet_src;

CREATE TABLE m_erp.lt_erp_objet_src
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_objet_src_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_objet_src IS 'Liste permettant de décrire les différentes sources d''idendification de l''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_src.code IS 'Code de la classe décrivant les sources d''idendification de l''ERP';
COMMENT ON COLUMN m_erp.lt_erp_objet_src.valeur IS 'Valeur de la classe décrivant les sources d''idendification de l''ERP';
COMMENT ON CONSTRAINT lt_erp_objet_src_pkey ON m_erp.lt_erp_objet_src IS 'Clé primaire du domaine de valeur lt_erp_objet_src';

INSERT INTO m_erp.lt_erp_objet_src(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('01','Procédure ERP'),
  ('02','SDIS'),
  ('03','Service de l''ARC'),
  ('04','Insee-SIRENE'),
  ('05','Presse'),
  ('06','Réseaux sociaux'),
  ('99','Autre');
  

-- #################################################################  lt_erp_orga_role ###############################################


-- nom de la table : lt_erp_orga_role


-- DROP TABLE m_erp.lt_erp_orga_role;

CREATE TABLE m_erp.lt_erp_orga_role
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_orga_role_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_orga_role IS 'Liste permettant de décrire les différents rôles dans la gestion des bassins (GEP : Gestion des Eaux Pluviales)';
COMMENT ON COLUMN m_erp.lt_erp_orga_role.code IS 'Code de la classe décrivant le rôle';
COMMENT ON COLUMN m_erp.lt_erp_orga_role.valeur IS 'Valeur de la classe décrivant le rôle';
COMMENT ON CONSTRAINT lt_erp_orga_role_pkey ON m_erp.lt_erp_orga_role IS 'Clé primaire du domaine de valeur lt_erp_orga_role';

INSERT INTO m_erp.lt_erp_orga_role(
            code, valeur)
    VALUES
  ('00', 'Non renseigné'),
  ('01', 'Propriétaire'),
  ('02', 'Nu-Propriétaire'),
  ('03', 'Exploitant'),
  ('04', 'Gestionnaire'),
  ('99', 'Autre');


-- #################################################################   lt_erp_procedure ###############################################


-- nom de la table : lt_erp_procedure


-- DROP TABLE m_erp.lt_erp_procedure;

CREATE TABLE m_erp.lt_erp_procedure
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_procedure_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_procedure IS 'Liste permettant de décrire les différentes types d''organisme';
COMMENT ON COLUMN m_erp.lt_erp_procedure.code IS 'Code de la classe décrivant le type d''organisme';
COMMENT ON COLUMN m_erp.lt_erp_procedure.valeur IS 'Valeur de la classe décrivant le type d''organisme';
COMMENT ON CONSTRAINT lt_erp_procedure_pkey ON m_erp.lt_erp_procedure IS 'Clé primaire du domaine de valeur lt_theme_type_orga';

INSERT INTO m_erp.lt_erp_procedure(
            code, valeur)
    VALUES
  ('10','Autorisation de travaux'),
  ('20','PC valant ERP'),
  ('30','Visite périodique'),
  ('31','Visite inopinée');


-- #################################################################   lt_erp_type_orga ###############################################


-- nom de la table : lt_erp_type_orga


-- DROP TABLE m_erp.lt_erp_type_orga;

CREATE TABLE m_erp.lt_erp_type_orga
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_type_orga_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_type_orga IS 'Liste permettant de décrire les différentes types d''organisme';
COMMENT ON COLUMN m_erp.lt_erp_type_orga.code IS 'Code de la classe décrivant le type d''organisme';
COMMENT ON COLUMN m_erp.lt_erp_type_orga.valeur IS 'Valeur de la classe décrivant le type d''organisme';
COMMENT ON CONSTRAINT lt_erp_type_orga_pkey ON m_erp.lt_erp_type_orga IS 'Clé primaire du domaine de valeur lt_theme_type_orga';

INSERT INTO m_erp.lt_erp_type_orga(
            code, valeur)
    VALUES
  ('00','Non renseigné'),
  ('01','Etat'),
  ('02','Région'),
  ('03','Département'),
  ('04','Commune'),
  ('05','Syndicat'),
  ('06','Association'),
  ('07','Privé');


-- #################################################################   lt_erp_procedure ###############################################


-- nom de la table : lt_erp_procedure


-- DROP TABLE m_erp.lt_erp_procedure;

CREATE TABLE m_erp.lt_erp_procedure
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_procedure_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_procedure IS 'Liste permettant de décrire les différentes types de procédure';
COMMENT ON COLUMN m_erp.lt_erp_procedure.code IS 'Code de la classe décrivant le type de procédure';
COMMENT ON COLUMN m_erp.lt_erp_procedure.valeur IS 'Valeur de la classe décrivant le type de procédure';
COMMENT ON CONSTRAINT lt_erp_procedure_pkey ON m_erp.lt_erp_procedure IS 'Clé primaire du domaine de valeur lt_erp_procedure';

INSERT INTO m_erp.lt_erp_procedure(
            code, valeur)
    VALUES
  ('10','Autorisation de travaux'),
  ('20','PC valant ERP'),
  ('30','Visite périodique'),
  ('31','Visite inopinée'),
  ('99','Autres');

 
-- #################################################################   lt_erp_eve ###############################################


-- nom de la table : lt_erp_eve


-- DROP TABLE m_erp.lt_erp_eve;

CREATE TABLE m_erp.lt_erp_eve
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    tri int2 NOT NULL,
    CONSTRAINT lt_erp_eve_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_eve IS 'Liste permettant de décrire les différentes types d''évènements';
COMMENT ON COLUMN m_erp.lt_erp_eve.code IS 'Code de la classe décrivant le type d''évènements';
COMMENT ON COLUMN m_erp.lt_erp_eve.valeur IS 'Valeur de la classe décrivant le type d''évènement';
COMMENT ON COLUMN m_erp.lt_erp_eve.tri IS 'Attribut permettant de classer les évèvements dans l''ordre d''affichage souhaité dans GEO';
COMMENT ON CONSTRAINT lt_erp_eve_pkey ON m_erp.lt_erp_eve IS 'Clé primaire du domaine de valeur lt_erp_eve';

INSERT INTO m_erp.lt_erp_eve(
            code, valeur,tri)
    VALUES
  ('10','PC Valant ERP (modificatif)',1),
  ('20','Avis du SDIS (sécurité pour 5ème catégorie sans sommeil',4),
  ('30','Arrêté d''autorisation de travaux',5),
  ('31','Arrêté de refus d''autorisation de travaux',6),
  ('32','Arrêté d''autorisation du permis de construire',7),
  ('33','Arrêté de refus du permis de construire',8),
  ('34','Arrêté d''ouverture',19),
  ('35','Arrêté de fermeture administrative provisoire',20),
  ('40','RVRAT',9),
  /*
  ('50','Visite de réception de travaux',10),
  ('51','Visite d''ouverture',11),
  ('52','Visite de réception de travaux/ouverture',12),
  */
  ('60','PV de la SCDC (sécurité)',2),
  ('61','PV de la SCDA (accessibilité)',3),
  ('62','PV de visite périodique',13),
  ('63','PV de visite inopinée',14),
  ('64','PV de réception de travaux',15),
  ('65','PV d''ouverture',16),
  ('66','PV de conformité',17),
  ('67','PV de de réception de travaux/conformité',18),
  ;


-- #################################################################  lt_erp_eve_decision ###############################################


-- nom de la table : lt_erp_eve_decision


-- DROP TABLE m_erp.lt_erp_eve_decision;

CREATE TABLE m_erp.lt_erp_eve_decision
(
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    CONSTRAINT lt_erp_eve_decision_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lt_erp_eve_decision IS 'Liste permettant de décrire les différentes types de décisions liés à un évènement';
COMMENT ON COLUMN m_erp.lt_erp_eve_decision.code IS 'Code de la classe décrivant le type de décisions liés à un évènement';
COMMENT ON COLUMN m_erp.lt_erp_eve_decision.valeur IS 'Valeur de la classe décrivant le type de décisions liés à un évènement';
COMMENT ON CONSTRAINT lt_erp_eve_decision_pkey ON m_erp.lt_erp_eve_decision IS 'Clé primaire du domaine de valeur lt_erp_eve_decision';

INSERT INTO m_erp.lt_erp_eve_decision(
            code, valeur)
    VALUES
  ('10','Favorable'),
  ('11','Favorable (avec prescription)'),
  ('20','Défavorable'),
  ('ZZ','Non concerné');

 
-- #################################################################  lt_erp_eve_typdoc ###############################################

-- m_erp.lt_erp_typdoc definition

-- Drop table

-- DROP TABLE m_erp.lt_erp_eve_typdoc;

CREATE TABLE m_erp.lt_erp_eve_typdoc (
	code varchar(2) NOT NULL, -- Code du type de documents joints
	valeur varchar(255) NULL, -- Valeur du type de documents joints
	CONSTRAINT lt_erp_eve_typdoc_pkey PRIMARY KEY (code)
);
CREATE INDEX lt_erp_typdoc_idx ON m_erp.lt_erp_eve_typdoc USING btree (code);
COMMENT ON TABLE m_erp.lt_erp_eve_typdoc IS 'Type de documents joints à un évènement';

-- Column comments

COMMENT ON COLUMN m_erp.lt_erp_eve_typdoc.code IS 'Code du type de documents joints';
COMMENT ON COLUMN m_erp.lt_erp_eve_typdoc.valeur IS 'Valeur du type de documents joints';

INSERT INTO m_erp.lt_erp_eve_typdoc(
            code, valeur)
    VALUES
  ('10','Arrêté'),
  ('20','Procès verbal'),
  ('30','Avis du SDIS'),
  ('99','Autre (à préciser)');



-- #################################################################  lt_erp_proc_typdoc ###############################################

-- m_erp.lt_erp_proc_typdoc definition

-- Drop table

-- DROP TABLE m_erp.lt_erp_proc_typdoc;

CREATE TABLE m_erp.lt_erp_proc_typdoc (
	code varchar(2) NOT NULL, -- Code du type de documents joints
	valeur varchar(255) NULL, -- Valeur du type de documents joints
	CONSTRAINT lt_erp_proc_typdoc_pkey PRIMARY KEY (code)
);
CREATE INDEX lt_erp_proc_typdoc_idx ON m_erp.lt_erp_proc_typdoc USING btree (code);
COMMENT ON TABLE m_erp.lt_erp_proc_typdoc IS 'Type de documents joints à une procédure';

-- Column comments

COMMENT ON COLUMN m_erp.lt_erp_proc_typdoc.code IS 'Code du type de documents joints';
COMMENT ON COLUMN m_erp.lt_erp_proc_typdoc.valeur IS 'Valeur du type de documents joints';

INSERT INTO m_erp.lt_erp_proc_typdoc(
            code, valeur)
    VALUES
  ('10','Permis de construire (PC)'),
  ('20','Autorisation de travaux (AT)'),
  ('99','Autre (à préciser)');


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# SEQUENCE an_erp_cad_id_seq ###############################################

-- DROP SEQUENCE -- SEQUENCE: m_erp.an_erp_cad_id_seq;  

CREATE SEQUENCE m_erp.an_erp_cad_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################################# Séquence sur TABLE an_erp_conf_regle_id_seq   ###############################################

-- SEQUENCE: m_erp.an_erp_conf_regle_id_seq
-- DROP SEQUENCE m_erp.an_erp_conf_regle_id_seq;

CREATE SEQUENCE m_erp.an_erp_conf_regle_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1; 

-- ################################################################# Séquence sur TABLE an_erp_contact_id_seq ###############################################

-- SEQUENCE: m_erp.an_erp_contact_id_seq
-- DROP SEQUENCE m_erp.an_erp_contact_id_seq;

CREATE SEQUENCE m_erp.an_erp_contact_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;   


-- ################################################################# Séquence sur TABLE an_erp_log_idlog_seq   ###############################################

-- DROP SEQUENCE -- SEQUENCE: m_erp.an_erp_log_idlog_seq;  

CREATE SEQUENCE m_erp.an_erp_log_idlog_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################################# SEQUENCE an_erp_objet_idobjet_seq ############################################### 

-- SEQUENCE: m_erp.an_erp_objet_idobjet_seq

-- DROP SEQUENCE -- SEQUENCE: m_erp.an_erp_objet_idobjet_seq;

CREATE SEQUENCE m_erp.an_erp_objet_idobjet_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;


-- ################################################################# SEQUENCE an_erp_objet_media_id_seq ###############################################

-- DROP SEQUENCE -- SEQUENCE: m_erp.an_erp_objet_media_id_seq;  

CREATE SEQUENCE m_erp.an_erp_objet_media_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################################# Séquence sur TABLE an_erp_orga_id_seq ###############################################

-- SEQUENCE: m_erp.an_erp_orga_id_seq
-- DROP SEQUENCE m_erp.an_erp_orga_id_seq;

CREATE SEQUENCE m_erp.an_erp_orga_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;    


-- ################################################################# SEQUENCE lk_an_erp_objet_histo_id_seq ###############################################

-- DROP SEQUENCE -- SEQUENCE: m_erp.lk_an_erp_objet_histo_id_seq;  

CREATE SEQUENCE m_erp.lk_an_erp_objet_histo_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;


	
-- ################################################################# Séquence sur TABLE lk_erp_contact_id_seq   ###############################################

-- SEQUENCE: m_erp.lk_erp_contact_id_seq
-- DROP SEQUENCE m_erp.lk_erp_contact_id_seq;

CREATE SEQUENCE m_erp.lk_erp_contact_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;    



-- ################################################################# Séquence sur TABLE lk_erp_orga_id_seq   ###############################################

-- SEQUENCE: m_erp.lk_erp_orga_id_seq
-- DROP SEQUENCE m_erp.lk_erp_orga_id_seq;

CREATE SEQUENCE m_erp.lk_erp_orga_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;  


-- ################################################################# Séquence sur TABLE an_erp_procedure_idproc_seq   ###############################################

-- SEQUENCE: m_erp.an_erp_procedure_idproc_seq
-- DROP SEQUENCE m_erp.an_erp_procedure_idproc_seq;

CREATE SEQUENCE m_erp.an_erp_procedure_idproc_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;  


-- ################################################################# Séquence sur TABLE an_erp_evenement_ideve_seq   ###############################################

-- SEQUENCE: m_erp.an_erp_evenement_ideve_seq
-- DROP SEQUENCE m_erp.an_erpan_erp_evenement_ideve_seq_evenement_id_seq;

CREATE SEQUENCE m_erp.an_erp_evenement_ideve_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;  

-- ################################################################# Séquence sur TABLE an_erp_procedure_media_id_seq   ###############################################

-- SEQUENCE: m_erp.an_erp_procedure_media_id_seq
-- DROP SEQUENCE m_erp.an_erp_procedure_media_id_seq;

CREATE SEQUENCE m_erp.an_erp_procedure_media_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;  

-- ################################################################# Séquence sur TABLE an_erp_evenement_media_id_seq   ###############################################

-- SEQUENCE: m_erp.an_erp_evenement_media_id_seq
-- DROP SEQUENCE m_erp.an_erp_evenement_media_id_seq;

CREATE SEQUENCE m_erp.an_erp_evenement_media_id_seq
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9223372036854775807
    CACHE 1;  

   
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# TABLE an_erp_cad ###############################################


-- m_erp.an_erp_cad definition

-- Drop table

-- DROP TABLE m_erp.an_erp_cad;

CREATE TABLE m_erp.an_erp_cad (
	id int8 DEFAULT nextval('m_erp.an_erp_cad_id_seq'::regclass) NOT NULL, -- Identifiant interne non signifiant pour chaque enregistrement
	idobjet int4 NOT NULL, -- Identifiant interne non signifiant de l'erp
	ccosec varchar(2) NOT null, -- Section cadastrale,
	dnupla varchar(4) NOT NULL, -- Parcelle cadastrale
	dbinsert timestamp NOT NULL, -- Date de saisie des informations de l'erp
	dbupdate timestamp null, -- Date de mise à jour des informations de l'erp,
	CONSTRAINT an_erp_cad_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE m_erp.an_erp_cad IS 'Table gérant les références cadastrales associés à l''ERP';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_cad.id IS 'Identifiant interne non signifiant pour chaque enregistrement';
COMMENT ON COLUMN m_erp.an_erp_cad.idobjet IS 'Identifiant de l''objet ERP';
COMMENT ON COLUMN m_erp.an_erp_cad.ccosec IS 'Section cadastrale';
COMMENT ON COLUMN m_erp.an_erp_cad.dnupla IS 'Parcelle cadastrale';
COMMENT ON COLUMN m_erp.an_erp_cad.dbinsert IS 'Date de saisie';
COMMENT ON COLUMN m_erp.an_erp_cad.dbupdate IS 'Date de mise à jour';


-- ################################################# TABLE an_erp_log ##################################   

-- DROP TABLE m_erp.an_erp_log;

CREATE TABLE m_erp.an_erp_log 
(
	idlog bigint NOT NULL DEFAULT nextval('m_erp.an_erp_log_idlog_seq'::regclass), 
	tablename varchar(80) NOT NULL,
	typeope text NOT NULL,
	dataold text NULL,
	datanew text NULL,
	dbinsert timestamp without time zone DEFAULT now(),
	CONSTRAINT an_erp_log_pkey PRIMARY KEY (idlog)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_log IS 'Table des opérations effectuées sur les données ERP et procédures liés à l''insert, update et delete';
COMMENT ON COLUMN m_erp.an_erp_log.idlog IS 'Identifiant unique';
COMMENT ON COLUMN m_erp.an_erp_log.tablename IS 'Nom de la classe concernée par une opération';
COMMENT ON COLUMN m_erp.an_erp_log.typeope IS 'Type d''opération';
COMMENT ON COLUMN m_erp.an_erp_log.dataold IS 'Anciennes données';
COMMENT ON COLUMN m_erp.an_erp_log.datanew IS 'Nouvelles données';
COMMENT ON COLUMN m_erp.an_erp_log.dbinsert IS 'Horodatage d''exécution de l''opération';


-- ################################################################# TABLE an_erp_objet ###############################################

-- m_erp.an_erp_objet definition

-- Drop table

-- DROP TABLE m_erp.an_erp_objet;

CREATE TABLE m_erp.an_erp_objet (
	idobjet serial4 NOT NULL, -- Identifiant des objets ERP
	idadresse int8 NULL, -- Identifiant adresse
	refrnb varchar(12) NULL, -- Réference RNB
	refsdis varchar(254) NULL, -- Réference SDIS
	libelle varchar(100) NULL, -- Libellé des objets ERP
	cat varchar(1) DEFAULT '0'::character varying NOT NULL, -- Catégories des objets ERP
	erptype varchar(3) DEFAULT '00'::character varying NOT NULL, -- Type des objets ERP
	erptype_p varchar(100) NULL, -- Précision sur le type des objets ERP
	erptype2 text NULL, -- Type secondaire des objets ERP
	etat varchar(2) DEFAULT '00'::character varying NOT NULL, -- Etat des objets ERP
	"group" varchar(2) DEFAULT '00'::character varying NOT NULL, -- Caractérise le type de groupement de l'ERP
	idmaitre int4 NULL, -- ERP associé au groupement de l'ERP,
	ephemere bool DEFAULT false NOT NULL, -- Indique si l'ERP est éphémère
	eff_public int4 NULL, -- Effectif public de l'ERP,
	eff_nuit int4 NULL, -- Effectif nuit de l'ERP
	eff_pers int4 NULL, -- Effectif personnel de l'ERP,
	eff_heberg int4 NULL, -- Effectif hebergement de l'ERP
	eff_total int4 NULL, -- Effectif total de l'ERP,
	loc_som bool DEFAULT false NOT NULL, -- Présence de locaux à sommeil
	erp_src varchar(2) DEFAULT '00'::character varying NOT NULL, -- Source de la saisie de l'ERP
	erp_public bool DEFAULT false NOT NULL, -- Identifie l'ERP comme public,
	siret varchar(14) NULL, -- SIRET de l'ERP
	ouvert_d date NULL, -- Date d'ouverture de l'ERP,
	ferme_d date NULL, -- Date de fermeture de l'ERP
	ferme_src varchar(254) NULL, -- Source de l'information sur la fermeture de l'ERP,
	observ varchar(254) NULL, -- Observations diverses
	op_sai varchar(80) NULL, -- Opérateur de saisie de l'objet
	op_maj varchar(80) NULL, -- Opérateur de la dernière mise à jour de l'objet,
	dbstatut varchar(2) DEFAULT '10'::character varying NOT NULL, -- Statut de l'objet dans la base
	dbinsert timestamp NULL, -- Horodatage d'insertion de la donnée dans la base,
	dbupdate timestamp NULL, -- Horodatage de la dernière mise à jour de la donnée dans la base
	idobjet_enfant int4 NULL, -- Identifiant de l'objet enfant pour la saisie des relations uniquement (valeur remis à null après enregistrement)
	complt text NULL, -- Complément de localisation,
	eff_autre int4 NULL, -- Effectif non précisé dans la demande d'autorisation de travaux ou de PC
	etat_reg varchar(2) NOT NULL DEFAULT '00', -- Etat réglementaire des objets ERP (déduit par défaut des évènements). Modification manuelle possible.
	CONSTRAINT an_erp_objet_pkey PRIMARY KEY (idobjet),
	CONSTRAINT lt_erp_objet_cat_fkey FOREIGN KEY (cat) REFERENCES m_erp.lt_erp_objet_cat(code),
	CONSTRAINT lt_erp_objet_dbstatut_fkey FOREIGN KEY (dbstatut) REFERENCES r_objet.lt_statut(code),
	CONSTRAINT lt_erp_objet_erptype_fkey FOREIGN KEY (erptype) REFERENCES m_erp.lt_erp_objet_erptype(code),
	CONSTRAINT lt_erp_objet_etat_fkey FOREIGN KEY (etat) REFERENCES m_erp.lt_erp_objet_etat(code),
	CONSTRAINT lt_erp_objet_group_fkey FOREIGN KEY ("group") REFERENCES m_erp.lt_erp_objet_group(code)
);
COMMENT ON TABLE m_erp.an_erp_objet IS 'Classe d''objets ERP';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_objet.idobjet IS 'Identifiant des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.idadresse IS 'Identifiant adresse';
COMMENT ON COLUMN m_erp.an_erp_objet.refrnb IS 'Réference RNB';
COMMENT ON COLUMN m_erp.an_erp_objet.refsdis IS 'Réference SDIS';
COMMENT ON COLUMN m_erp.an_erp_objet.libelle IS 'Libellé des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.cat IS 'Catégories des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.erptype IS 'Type des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.erptype_p IS 'Précision sur le type des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.erptype2 IS 'Type secondaire des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.etat IS 'Etat des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet."group" IS 'Caractérise le type de groupement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.idmaitre IS 'ERP associé au groupement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.ephemere IS 'Indique si l''ERP est éphémère';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_public IS 'Effectif public de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_nuit IS 'Effectif nuit de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_pers IS 'Effectif personnel de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_heberg IS 'Effectif hebergement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_total IS 'Effectif total de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.loc_som IS 'Présence de locaux à sommeil';
COMMENT ON COLUMN m_erp.an_erp_objet.erp_src IS 'Source de la saisie de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.erp_public IS 'Identifie l''ERP comme public';
COMMENT ON COLUMN m_erp.an_erp_objet.siret IS 'SIRET de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.ouvert_d IS 'Date d''ouverture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.ferme_d IS 'Date de fermeture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.ferme_src IS 'Source de l''information sur la fermeture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp.an_erp_objet.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp.an_erp_objet.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp.an_erp_objet.dbstatut IS 'Statut de l''objet dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet.dbinsert IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet.dbupdate IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet.idobjet_enfant IS 'Identifiant de l''objet enfant pour la saisie des relations uniquement (valeur remis à null après enregistrement)';
COMMENT ON COLUMN m_erp.an_erp_objet.complt IS 'Complément de localisation';
COMMENT ON COLUMN m_erp.an_erp_objet.eff_autre IS 'Effectif non précisé dans la demande d''autorisation de travaux ou de PC';
COMMENT ON COLUMN m_erp.an_erp_objet.etat_reg IS 'Etat réglementaire des objets ERP (déduit par défaut des évènements). Modification manuelle possible';


-- Constraint comments

COMMENT ON CONSTRAINT an_erp_objet_pkey ON m_erp.an_erp_objet IS 'Clé primaire de la classe an_erp_objet';


-- ################################################################# TABLE an_erp_objet_h ###############################################

-- m_erp.an_erp_objet_h definition

-- Drop table

-- DROP TABLE m_erp.an_erp_objet_h;

CREATE TABLE m_erp.an_erp_objet_h (
	idobjet int4 NOT NULL, -- Identifiant des objets ERP
	idadresse int8 NULL, -- Identifiant adresse
	refrnb varchar(12) NULL, -- Réference RNB
	refsdis varchar(254) NULL, -- Réference SDIS
	libelle varchar(100) NULL, -- Libellé des objets ERP
	cat varchar(1) DEFAULT '0'::character varying NOT NULL, -- Catégories des objets ERP
	erptype varchar(3) DEFAULT '00'::character varying NOT NULL, -- Type des objets ERP
	erptype_p varchar(100) NULL, -- Précision sur le type des objets ERP
	erptype2 text NULL, -- Type secondaire des objets ERP
	etat varchar(2) DEFAULT '00'::character varying NOT NULL, -- Etat des objets ERP
	"group" varchar(2) DEFAULT '00'::character varying NOT NULL, -- Caractérise le type de groupement de l'ERP
	idmaitre int8 NULL, -- ERP associé au groupement de l'ERP,
	ephemere bool DEFAULT false NOT NULL, -- Indique si l'ERP est éphémère
	eff_public int4 NULL, -- Effectif public de l'ERP,
	eff_nuit int4 NULL, -- Effectif nuit de l'ERP
	eff_pers int4 NULL, -- Effectif personnel de l'ERP,
	eff_heberg int4 NULL, -- Effectif hebergement de l'ERP
	eff_total int4 NULL, -- Effectif total de l'ERP,
	loc_som bool DEFAULT false NOT NULL, -- Présence de locaux à sommeil
	erp_src varchar(2) DEFAULT '00'::character varying NOT NULL, -- Source de la saisie de l'ERP
	erp_public bool DEFAULT false NOT NULL, -- Identifie l'ERP comme public,
	siret varchar(14) NULL, -- SIRET de l'ERP
	ouvert_d date NULL, -- Date d'ouverture de l'ERP,
	ferme_d date NULL, -- Date de fermeture de l'ERP
	ferme_src varchar(254) NULL, -- Source de l'information sur la fermeture de l'ERP,
	observ varchar(254) NULL, -- Observations diverses
	op_sai varchar(80) NULL, -- Opérateur de saisie de l'objet
	op_maj varchar(80) NULL, -- Opérateur de la dernière mise à jour de l'objet,
	dbstatut varchar(2) DEFAULT '10'::character varying NOT NULL, -- Statut de l'objet dans la base
	dbinsert timestamp NULL, -- Horodatage d'insertion de la donnée dans la base,
	dbupdate timestamp NULL, -- Horodatage de la dernière mise à jour de la donnée dans la base
	dbhisto timestamp NULL, -- Horodatage de la date d'insertion dans la classe historique
	complt text NULL, -- Complément de localisation,
	eff_autre int4 NULL, -- Effectif non précisé lors d'une autorisaiton de travaux ou d'un PC
	CONSTRAINT an_erp_objet_h_pkey PRIMARY KEY (idobjet),
	CONSTRAINT lt_erp_objet_cat_h_fkey FOREIGN KEY (cat) REFERENCES m_erp.lt_erp_objet_cat(code),
	CONSTRAINT lt_erp_objet_dbstatut_h_fkey FOREIGN KEY (dbstatut) REFERENCES r_objet.lt_statut(code),
	CONSTRAINT lt_erp_objet_erptype_h_fkey FOREIGN KEY (erptype) REFERENCES m_erp.lt_erp_objet_erptype(code),
	CONSTRAINT lt_erp_objet_etat_h_fkey FOREIGN KEY (etat) REFERENCES m_erp.lt_erp_objet_etat(code),
	CONSTRAINT lt_erp_objet_group_h_fkey FOREIGN KEY ("group") REFERENCES m_erp.lt_erp_objet_group(code)
);
COMMENT ON TABLE m_erp.an_erp_objet_h IS 'Classe d''objets ERP historisé';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_objet_h.idobjet IS 'Identifiant des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.idadresse IS 'Identifiant adresse';
COMMENT ON COLUMN m_erp.an_erp_objet_h.refrnb IS 'Réference RNB';
COMMENT ON COLUMN m_erp.an_erp_objet_h.refsdis IS 'Réference SDIS';
COMMENT ON COLUMN m_erp.an_erp_objet_h.libelle IS 'Libellé des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.cat IS 'Catégories des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.erptype IS 'Type des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.erptype_p IS 'Précision sur le type des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.erptype2 IS 'Type secondaire des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.etat IS 'Etat des objets ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h."group" IS 'Caractérise le type de groupement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.idmaitre IS 'ERP associé au groupement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.ephemere IS 'Indique si l''ERP est éphémère';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_public IS 'Effectif public de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_nuit IS 'Effectif nuit de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_pers IS 'Effectif personnel de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_heberg IS 'Effectif hebergement de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_total IS 'Effectif total de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.loc_som IS 'Présence de locaux à sommeil';
COMMENT ON COLUMN m_erp.an_erp_objet_h.erp_src IS 'Source de la saisie de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.erp_public IS 'Identifie l''ERP comme public';
COMMENT ON COLUMN m_erp.an_erp_objet_h.siret IS 'SIRET de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.ouvert_d IS 'Date d''ouverture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.ferme_d IS 'Date de fermeture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.ferme_src IS 'Source de l''information sur la fermeture de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_objet_h.observ IS 'Observations diverses';
COMMENT ON COLUMN m_erp.an_erp_objet_h.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp.an_erp_objet_h.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp.an_erp_objet_h.dbstatut IS 'Statut de l''objet dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet_h.dbinsert IS 'Horodatage d''insertion de la donnée dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet_h.dbupdate IS 'Horodatage de la dernière mise à jour de la donnée dans la base';
COMMENT ON COLUMN m_erp.an_erp_objet_h.dbhisto IS 'Horodatage de la date d''insertion dans la classe historique';
COMMENT ON COLUMN m_erp.an_erp_objet_h.complt IS 'Complément de localisation';
COMMENT ON COLUMN m_erp.an_erp_objet_h.eff_autre IS 'Effectif non précisé lors d''une autorisaiton de travaux ou d''un PC';


-- Constraint comments

COMMENT ON CONSTRAINT an_erp_objet_h_pkey ON m_erp.an_erp_objet_h IS 'Clé primaire de la classe an_erp_objet_h';

-- ################################################################# TABLE an_erp_objet_media ###############################################


-- Table: m_erp.an_erp_objet_media

-- DROP TABLE m_erp.an_erp_objet_media;

CREATE TABLE m_erp.an_erp_objet_media
(
  id int4 NOT NULL DEFAULT nextval('m_erp.an_erp_objet_media_id_seq'::regclass),
  idobjet bigint NOT NULL,
  media text,
  miniature bytea,
  n_fichier text,
  t_fichier text,
  doctype character varying(2) NOT NULL DEFAULT '00',
  adoc varchar(100), -- Précision sur le document joint (si 99 saisie dans doctype)
  op_sai character varying(80),
  doc_sai_d date,
  dbinsert timestamp DEFAULT now(),

  CONSTRAINT an_erp_objet_media_pkey PRIMARY KEY (id)    
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_objet_media IS 'Table gérant la liste des photos des objets ERP avec le module média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_objet_media.id IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp.an_erp_objet_media.idobjet IS 'Identifiant de l''ERP'; -- classe an_erp_objet
COMMENT ON COLUMN m_erp.an_erp_objet_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp.an_erp_objet_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp.an_erp_objet_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp.an_erp_objet_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_objet_media.doctype IS 'Type de documents';
COMMENT ON COLUMN m_erp.an_erp_objet_media.adoc IS 'Précision sur le document joint (si 99 saisie dans doctype)';
COMMENT ON COLUMN m_erp.an_erp_objet_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp.an_erp_objet_media.doc_sai_d IS 'Date de création du document';
COMMENT ON COLUMN m_erp.an_erp_objet_media.dbinsert IS 'Horodatage d''insertion du média dans la base';


-- ################################################################# TABLE an_erp_orga ##################################################

-- nom de la table : an_erp_orga

-- DROP TABLE m_erp.an_erp_orga;
  
CREATE TABLE m_erp.an_erp_orga
(
	idorga int4 NOT NULL DEFAULT (nextval('m_erp.an_erp_orga_id_seq'::regclass)),
	type_orga character varying(2) NOT NULL,	
	nom_orga character varying(254) NOT NULL,
	observ character varying(254),
	dbstatut character varying(2) NOT NULL default '10',
	op_sai character varying(80) NOT NULL,
    op_maj character varying(80),
    dbinsert timestamp without time zone DEFAULT now(),
    dbupdate timestamp without time zone DEFAULT now(),
    CONSTRAINT an_erp_orga_pkey PRIMARY KEY (idorga),
    CONSTRAINT lt_erp_type_orga_fkey FOREIGN KEY (type_orga) REFERENCES m_erp.lt_erp_type_orga(code),
    CONSTRAINT lt_statut_fkey FOREIGN KEY (dbstatut) REFERENCES r_objet.lt_statut(code)	
	
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_orga IS 'Base de organismes pour les bassins (GEP : Gestion des Eaux Pluviales)';

COMMENT ON COLUMN m_erp.an_erp_orga.idorga IS 'Identifiant de l''organisme';
COMMENT ON COLUMN m_erp.an_erp_orga.nom_orga IS 'Nom de l''organisme';
COMMENT ON COLUMN m_erp.an_erp_orga.type_orga IS 'Liste de valeurs des types d''organisme (commune, EPCI, syndicat, etc...)';
COMMENT ON COLUMN m_erp.an_erp_orga.observ IS 'Commentaires';
COMMENT ON COLUMN m_erp.an_erp_orga.dbstatut IS 'Statut de l''objet';
COMMENT ON COLUMN m_erp.an_erp_orga.op_sai IS 'Opérateur de saisie initiale';
COMMENT ON COLUMN m_erp.an_erp_orga.dbinsert IS 'Date de saisie initiale';
COMMENT ON COLUMN m_erp.an_erp_orga.op_maj IS 'Opérateur de mise à jour';
COMMENT ON COLUMN m_erp.an_erp_orga.dbupdate IS 'Date de mise à jour';

COMMENT ON CONSTRAINT an_erp_orga_pkey ON m_erp.an_erp_orga IS 'Clé primaire de la table an_erp_orga';


INSERT INTO m_erp.an_erp_orga (type_orga,nom_orga,op_sai) VALUES
('05','Commune de Compiègne','geo2'),
('04','Communauté d''Agglomération de la Région de Compiègne','geo2'),
('01','Etat','geo2'),
('03','Département','geo2'),
('02','Région','geo2');


-- ################################################################# TABLE an_erp_contact ###############################################

-- nom de la table : an_erp_contact


-- DROP TABLE m_erp.an_erp_contact;
  
CREATE TABLE m_erp.an_erp_contact
(
	idcontact bigint NOT NULL DEFAULT (nextval('m_erp.an_erp_contact_id_seq'::regclass)),
	denomination character varying(254),
	idorga int2 ,
    tel character varying(10),
    mobile character varying(10),
   	email character varying(100),
    observ character varying(254),
    dbstatut character varying(2) NOT NULL default '10',
    op_sai character varying(80),
    op_maj character varying(80),
    dbinsert timestamp without time zone DEFAULT now(),
	dbupdate timestamp without time zone DEFAULT now(),
    CONSTRAINT an_erp_contact_pkey PRIMARY KEY (idcontact),
    CONSTRAINT an_erp_orga_fkey FOREIGN KEY (idorga) REFERENCES m_erp.an_erp_orga(idorga),
    CONSTRAINT lt_statut_fkey FOREIGN KEY (dbstatut) REFERENCES r_objet.lt_statut(code)	
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.an_erp_contact IS 'Base de contacts pour les bassins (GEP : Gestion des Eaux Pluviales)';

COMMENT ON COLUMN m_erp.an_erp_contact.idcontact IS 'Identifiant du contact';
COMMENT ON COLUMN m_erp.an_erp_contact.denomination IS 'Identité du contact (service, nom/prénom, etc. )';
COMMENT ON COLUMN m_erp.an_erp_contact.idorga IS 'Identifiant de l''Organisme d''appartenance du contact';
COMMENT ON COLUMN m_erp.an_erp_contact.tel IS 'Numéro de téléphone fixe du contact';
COMMENT ON COLUMN m_erp.an_erp_contact.mobile IS 'Numéro de téléphone mobile du contact';
COMMENT ON COLUMN m_erp.an_erp_contact.email IS 'Adresse email du contact';
COMMENT ON COLUMN m_erp.an_erp_contact.observ IS 'Commentaires';
COMMENT ON COLUMN m_erp.an_erp_contact.dbstatut IS 'Statut de l''objet';
COMMENT ON COLUMN m_erp.an_erp_contact.op_sai IS 'Opérateur de saisie initiale';
COMMENT ON COLUMN m_erp.an_erp_contact.op_maj IS 'Opérateur de mise à jour';
COMMENT ON COLUMN m_erp.an_erp_contact.dbinsert IS 'Date de saisie initiale';
COMMENT ON COLUMN m_erp.an_erp_contact.dbupdate IS 'Date de mise à jour';


COMMENT ON CONSTRAINT an_erp_contact_pkey ON m_erp.an_erp_contact IS 'Clé primaire de la table an_erp_contact';

-- ################################################################# TABLE geo_erp_userpoint ###############################################

-- DROP TABLE m_erp.geo_erp_userpoint;
  
CREATE TABLE m_erp.geo_erp_userpoint
(
  idobjet bigint NOT NULL DEFAULT nextval('m_erp.an_erp_objet_idobjet_seq'::regclass),
  -- le parti pris est que dans le cas où à un userpoint, il n'y a qu'un seul et unique ERP. En conséquence, iduserpoint = idobjet (erp), donc on peut faire tourner la séquence erp_objet
  x_l93 numeric(9,2),
  y_l93 numeric(10,2),
  insee character varying(5),
  commune character varying(80),
  indication text,
  dbstatut character varying(2) NOT NULL DEFAULT '10',    
  geom geometry(point,2154),
  CONSTRAINT geo_erp_userpoint_pkey PRIMARY KEY (idobjet)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.geo_erp_userpoint IS 'Classe d''objets de localisation utilisateur des ERP';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.idobjet IS 'Identifiant de l''ERP localisé par un point utilisateur';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.x_l93 IS 'Coordonnée X (Lambert 93)';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.y_l93 IS 'Coordonnée Y (Lambert 93)';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.indication IS 'Compléments de localisation';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.insee IS 'Code insee de la commune';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.commune IS 'Nom de la commune';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.dbstatut IS 'Statut de l''objet dans la base';
COMMENT ON COLUMN m_erp.geo_erp_userpoint.geom IS 'Géométrie du point';


-- Constraint comments

COMMENT ON CONSTRAINT geo_erp_userpoint_pkey ON m_erp.geo_erp_userpoint IS 'Clé primaire de la classe geo_erp_userpoint';


-- ################################################################# TABLE geo_erp_userpoint_h ###############################################


-- DROP TABLE m_erp.geo_erp_userpoint_h;
  
CREATE TABLE m_erp.geo_erp_userpoint_h
(
  idobjet int4,
  x_l93 numeric(9,2),
  y_l93 numeric(10,2),
  insee character varying(5),
  commune character varying(80),
  indication text,
  dbstatut character varying(2) NOT NULL DEFAULT '10',    
  geom geometry(point,2154),
  dbhisto timestamp NULL, -- Horodatage de la date d'insertion dans la classe historique
  CONSTRAINT geo_erp_userpoint_h_pkey PRIMARY KEY (idobjet)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.geo_erp_userpoint_h IS 'Historisation de la classe d''objets de localisation utilisateur des ERP';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.idobjet IS 'Identifiant de l''ERP localisé par un point utilisateur';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.x_l93 IS 'Coordonnée X (Lambert 93)';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.y_l93 IS 'Coordonnée Y (Lambert 93)';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.indication IS 'Compléments de localisation';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.insee IS 'Code insee de la commune';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.commune IS 'Nom de la commune';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.dbstatut IS 'Statut de l''objet dans la base';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.geom IS 'Géométrie du point';
COMMENT ON COLUMN m_erp.geo_erp_userpoint_h.dbhisto IS 'Horodatage de la date d''insertion dans la classe historique';


-- Constraint comments

COMMENT ON CONSTRAINT geo_erp_userpoint_h_pkey ON m_erp.geo_erp_userpoint_h IS 'Clé primaire de la classe geo_erp_userpoint_h';


-- ################################################################# TABLE an_erp_procedure ###############################################


-- m_erp.an_erp_procedure definition

-- Drop table

-- DROP TABLE m_erp.an_erp_procedure;

CREATE TABLE m_erp.an_erp_procedure (
	idproc int8 DEFAULT nextval('m_erp.an_erp_procedure_idproc_seq'::regclass) NOT NULL, -- Identifiant interne non signifiant pour chaque enregistrement
	idobjet int4 NOT NULL, -- Identifiant interne non signifiant de l'erp
	typ varchar(2) NOT NULL, -- type de procédure
	ident text, -- identification ou numéro éventuel de la procédure
	objet text, -- objet de la procédure
	ddepot date, -- date de dépôt de la procédure
	op_sai varchar(80) NULL, -- Opérateur de saisie de l'objet
	op_maj varchar(80) NULL, -- Opérateur de la dernière mise à jour de l'objet,
	dbinsert timestamp NOT NULL, -- Date de saisie
	dbupdate timestamp null, -- Date de mise à jour
	
	CONSTRAINT an_erp_procedure_pkey PRIMARY KEY (idproc),
	CONSTRAINT lt_erp_procedure_fkey FOREIGN KEY (typ) REFERENCES m_erp.lt_erp_procedure(code)	
);

COMMENT ON TABLE m_erp.an_erp_procedure IS 'Table gérant les procédures associées à l''ERP';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_procedure.idproc IS 'Identifiant interne non signifiant pour chaque procédure';
COMMENT ON COLUMN m_erp.an_erp_procedure.idobjet IS 'Identifiant de l''objet ERP';
COMMENT ON COLUMN m_erp.an_erp_procedure.typ IS 'Type de procédure';
COMMENT ON COLUMN m_erp.an_erp_procedure.ident IS 'Numéro éventuel de la procédure';
COMMENT ON COLUMN m_erp.an_erp_procedure.objet IS 'Objet de la procédure';
COMMENT ON COLUMN m_erp.an_erp_procedure.ddepot IS 'Date de dépôt de la procédure';
COMMENT ON COLUMN m_erp.an_erp_procedure.op_sai IS 'Opérateur de saisie';
COMMENT ON COLUMN m_erp.an_erp_procedure.op_maj IS 'Opérateur de mise à jour';
COMMENT ON COLUMN m_erp.an_erp_procedure.dbinsert IS 'Date de saisie';



-- ################################################################# TABLE an_erp_procedure_media ###############################################

-- m_erp.an_erp_procedure_media definition

-- Drop table

-- DROP TABLE m_erp.an_erp_procedure_media;

CREATE TABLE m_erp.an_erp_procedure_media (
	id int8 DEFAULT nextval('m_erp.an_erp_procedure_media_id_seq'::regclass) NOT NULL, -- Identifiant interne non signifiant pour chaque enregistrement
	idproc int8 NOT NULL, -- Identifiant de l'ERP
	media text null, -- Champ Média de GEO,
	miniature bytea NULL, -- Champ miniature de GEO
	n_fichier text NULL, -- Nom du fichier
	t_fichier text NULL, -- Type de média dans GEO
	doctype varchar(2), -- Type de documents
	adoc varchar(100), -- Précision sur le document joint (si 99 saisie dans doctype)
	op_sai varchar(80) NULL, -- Libellé de l'opérateur ayant intégrer le document
	dbinsert timestamp DEFAULT now() NULL, -- Horodatage d'insertion du média dans la base
	CONSTRAINT an_erp_procedure_media_pkey PRIMARY KEY (idproc)
	CONSTRAINT an_erp_procedure_media_typdoc_fkey FOREIGN KEY (doctype) REFERENCES m_erp.lt_erp_proc_typdoc(code)
);
COMMENT ON TABLE m_erp.an_erp_procedure_media IS 'Table gérant les documents joinrs à un évènement';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_procedure_media.id IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.idobjet IS 'Identifiant de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.doctype IS 'Type de documents';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.adoc IS 'Précision sur le document joint (si 99 saisie dans doctype)';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp.an_erp_procedure_media.dbinsert IS 'Horodatage d''insertion du média dans la base';

-- ################################################################# TABLE an_erp_evenement ###############################################


-- m_erp.an_erp_evenement definition

-- Drop table

-- DROP TABLE m_erp.an_erp_evenement;

CREATE TABLE m_erp.an_erp_evenement (
	ideve int8 DEFAULT nextval('m_erp.an_erp_evenement_ideve_seq'::regclass) NOT NULL, -- Identifiant interne non signifiant pour chaque évènement
	idproc int4 NOT NULL, -- Identifiant interne  de la procédure
	typ varchar(2) NOT NULL, -- type d'évènement
	deve date NOT NULL, -- date de l'évènement (date de l'avis, de l'arrêté, ...)
	decision varchar(2) NOT NULL, -- décision lié à l'évènement
	op_sai varchar(80) NULL, -- Opérateur de saisie de l'objet
	op_maj varchar(80) NULL, -- Opérateur de la dernière mise à jour de l'objet,
	dbinsert timestamp NOT NULL, -- Date de saisie
	dbupdate timestamp null, -- Date de mise à jour
	CONSTRAINT an_erp_evenement_pkey PRIMARY KEY (ideve),
	CONSTRAINT lt_erp_eve_eve_fkey FOREIGN KEY (typ) REFERENCES m_erp.lt_erp_eve(code),
	CONSTRAINT lt_erp_eve_decision_fkey FOREIGN KEY (decision) REFERENCES m_erp.lt_erp_eve_decision(code)
);

COMMENT ON TABLE m_erp.an_erp_evenement IS 'Table gérant les évènements internes à chaque procédure déclarée à l''ERP';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_evenement.ideve IS 'Identifiant interne non signifiant pour chaque évènement';
COMMENT ON COLUMN m_erp.an_erp_evenement.idproc IS 'Identifiant de la procédure';
COMMENT ON COLUMN m_erp.an_erp_evenement.typ IS 'type d''évènement';
COMMENT ON COLUMN m_erp.an_erp_evenement.deve IS 'date de l''évènement (date de l''avis, de l''arrêté, ...)';
COMMENT ON COLUMN m_erp.an_erp_evenement.decision IS 'décision lié à l''évènement';
COMMENT ON COLUMN m_erp.an_erp_evenement.op_sai IS 'Opérateur de saisie de l''objet';
COMMENT ON COLUMN m_erp.an_erp_evenement.op_maj IS 'Opérateur de la dernière mise à jour de l''objet';
COMMENT ON COLUMN m_erp.an_erp_evenement.dbinsert IS 'Date de saisie';
COMMENT ON COLUMN m_erp.an_erp_evenement.dbupdate IS 'Date de mise à jour';



-- ################################################################# TABLE an_erp_evenement_media ###############################################

-- m_erp.an_erp_evenement_media definition

-- Drop table

-- DROP TABLE m_erp.an_erp_evenement_media;

CREATE TABLE m_erp.an_erp_evenement_media (
	id int8 DEFAULT nextval('m_erp.an_erp_evenement_media_id_seq'::regclass) NOT NULL, -- Identifiant interne non signifiant pour chaque enregistrement
	ideve int8 NOT NULL, -- Identifiant de l'ERP
	media text null, -- Champ Média de GEO,
	miniature bytea NULL, -- Champ miniature de GEO
	n_fichier text NULL, -- Nom du fichier
	t_fichier text NULL, -- Type de média dans GEO
	doctype varchar(2), -- Type de documents
	adoc varchar(100), -- Précision sur le document joint (si 99 saisie dans doctype)
	op_sai varchar(80) NULL, -- Libellé de l'opérateur ayant intégrer le document
	dbinsert timestamp DEFAULT now() NULL, -- Horodatage d'insertion du média dans la base
	CONSTRAINT an_erp_evenement_media_pkey PRIMARY KEY (id),
	CONSTRAINT an_erp_evenement_media_typdoc_fkey FOREIGN KEY (doctype) REFERENCES m_erp.lt_erp_eve_typdoc(code)
);
COMMENT ON TABLE m_erp.an_erp_evenement_media IS 'Table gérant les documents joints à un évènement';

-- Column comments

COMMENT ON COLUMN m_erp.an_erp_evenement_media.id IS 'Identifiant unique du média';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.ideve IS 'Identifiant de l''ERP';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.media IS 'Champ Média de GEO';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.miniature IS 'Champ miniature de GEO';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.doctype IS 'Type de documents';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.adoc IS 'Précision sur le document joint (si 99 saisie dans doctype)';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.t_fichier IS 'Type de média dans GEO';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.op_sai IS 'Libellé de l''opérateur ayant intégrer le document';
COMMENT ON COLUMN m_erp.an_erp_evenement_media.dbinsert IS 'Horodatage d''insertion du média dans la base';

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                               CLASSE DE RELATION                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ################################################################# TABLE lk_an_erp_objet_histo ###############################################


-- m_erp.lk_an_erp_objet_histo definition

-- Drop table

-- DROP TABLE m_erp.lk_an_erp_objet_histo;

CREATE TABLE m_erp.lk_an_erp_objet_histo (
	id int4 NOT NULL DEFAULT nextval('m_erp.lk_an_erp_objet_histo_id_seq'::regclass), -- Identifiant de la relation historique
	idobjet_p int4 NOT NULL, -- Identifiant de l'objet parent
	idobjet_e int4 NOT NULL, -- Identifiant de l'objet enfant
	CONSTRAINT lk_an_erp_objet_histo_pkey PRIMARY KEY (id)
);

COMMENT ON TABLE m_erp.lk_an_erp_objet_histo IS 'Classe de relation des ERP historisés';

-- Column comments

COMMENT ON COLUMN m_erp.lk_an_erp_objet_histo.id IS 'Identifiant de la relation historique';
COMMENT ON COLUMN m_erp.lk_an_erp_objet_histo.idobjet_p IS 'Identifiant de l''objet parent';
COMMENT ON COLUMN m_erp.lk_an_erp_objet_histo.idobjet_e IS 'Identifiant de l''objet enfant';


-- Constraint comments

COMMENT ON CONSTRAINT lk_an_erp_objet_histo_pkey ON m_erp.lk_an_erp_objet_histo IS 'Clé primaire de la classe lk_an_erp_objet_histo';



-- ################################################################# TABLE lk_erp_contact ###############################################


-- nom de la table : lk_erp_contact



-- DROP TABLE m_erp.lk_erp_contact;
  
CREATE TABLE m_erp.lk_erp_contact
(
    idlk int4 NOT NULL DEFAULT (nextval('m_erp.lk_erp_contact_id_seq'::regclass)),
	idobjet int4 NOT NULL,
	idcontact int4 NOT NULL,
	code_fonction character varying(3), -- pour faire le lien avec le champ "code" de la table lt_theme_contact_fonction (dans GEO)
 CONSTRAINT lk_erp_contact_pkey PRIMARY KEY (idlk),
 CONSTRAINT an_erp_objet_fkey FOREIGN KEY (idobjet) REFERENCES m_erp.an_erp_objet(idobjet),
 CONSTRAINT an_erp_contact_fkey FOREIGN KEY (idcontact) REFERENCES m_erp.an_erp_contact(idcontact),
 CONSTRAINT lt_erp_contact_fonction_fkey FOREIGN KEY (code_fonction) REFERENCES m_erp.lt_erp_contact_fonction(code)
 
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lk_erp_contact IS 'Table alphanumérique de l''ensemble des contacts liés au bassins (GEP : Gestion des Eaux Pluviales)';

COMMENT ON COLUMN m_erp.lk_erp_contact.idlk IS 'Identifiant unique de la relation';
COMMENT ON COLUMN m_erp.lk_erp_contact.idobjet IS 'Identifiant unique de l''objet';
COMMENT ON COLUMN m_erp.lk_erp_contact.idcontact IS 'Identifiant unique ndu contact';
COMMENT ON COLUMN m_erp.lk_erp_contact.code_fonction IS 'Code dde la fonction du contact';

COMMENT ON CONSTRAINT lk_erp_contact_pkey ON m_erp.lk_erp_contact IS 'Clé primaire de la table lk_erp_contact';


-- ################################################################# TABLE lk_erp_orga ###############################################


-- nom de la table : lk_erp_orga



-- DROP TABLE m_erp.lk_erp_orga;
  
CREATE TABLE m_erp.lk_erp_orga
(
    idlk int4 NOT NULL DEFAULT (nextval('m_erp.lk_erp_orga_id_seq'::regclass)),
	idobjet int4 NOT NULL,
	idorga int4 NOT NULL,
	code_role character varying(3), -- pour faire le lien avec le champ "code" de la table lk_theme_orga (dans GEO)
    CONSTRAINT lk_erp_orga_pkey PRIMARY KEY (idlk),
    CONSTRAINT an_erp_objet_fkey FOREIGN KEY (idobjet) REFERENCES m_erp.an_erp_objet(idobjet),
    CONSTRAINT an_erp_orga_fkey FOREIGN KEY (idorga) REFERENCES m_erp.an_erp_orga(idorga),
    CONSTRAINT lt_erp_orga_role_fkey FOREIGN KEY (code_role) REFERENCES m_erp.lt_erp_orga_role(code)
)
WITH (
  OIDS=FALSE
);

COMMENT ON TABLE m_erp.lk_erp_orga IS 'Table alphanumérique de l''ensemble des contacts liés au bassins (GEP : Gestion des Eaux Pluviales)';

COMMENT ON COLUMN m_erp.lk_erp_orga.idlk IS 'Identifiant unique de la relation';
COMMENT ON COLUMN m_erp.lk_erp_orga.idobjet IS 'Identifiant unique de l''objet';
COMMENT ON COLUMN m_erp.lk_erp_orga.idorga IS 'Identifiant unique de l''organisme';
COMMENT ON COLUMN m_erp.lk_erp_orga.code_role IS 'Code du role de l''organisme';

COMMENT ON CONSTRAINT lk_erp_orga_pkey ON m_erp.lk_erp_orga IS 'Clé primaire de la table lk_erp_orga';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  VUES APPLICATIVES                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################   



-- ################################################################# TABLE xapps_geo_vmr_adresse_erp ###############################################

-- m_erp.xapps_geo_vmr_adresse_erp source

CREATE MATERIALIZED VIEW m_erp.xapps_geo_vmr_adresse_erp
TABLESPACE pg_default
AS WITH req_ad AS (
         SELECT a_1.id_adresse AS idadresse,
            a_1.commune,
            a_1.libvoie_c,
            a_1.numero,
            a_1.etiquette,
            a_1.angle,
            a_1.repet,
            a_1.numero::text ||
                CASE
                    WHEN a_1.repet IS NOT NULL OR a_1.repet::text <> ''::text THEN a_1.repet
                    ELSE ''::character varying
                END::text AS numero_repet,
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
            ((((a_1.numero::text ||
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
                END AS adresse_courte,
            a_1.mot_dir,
            a_1.libvoie_a,
            e.iepci AS epci,
            a_1.insee,
            a_1.geom
           FROM r_adresse.xapps_geo_vmr_adresse a_1,
            r_administratif.an_geo g,
            r_osm.geo_osm_epci e
          WHERE a_1.insee = g.insee::bpchar AND e.cepci::text = g.epci::text AND a_1.diag_adr::text <> '00'::text AND a_1.diag_adr::text <> '12'::text AND a_1.diag_adr::text <> '99'::text AND a_1.insee = '60159'::bpchar
        ), req_erp AS (
         SELECT o.idadresse,
            count(*) AS nb_erp
           FROM m_erp.an_erp_objet o
          WHERE o.etat::text <> '31'::text AND o.dbstatut::text = '10'::text
          GROUP BY o.idadresse
        )
 SELECT
        CASE
            WHEN req_erp.nb_erp IS NULL THEN 0::bigint
            ELSE req_erp.nb_erp
        END AS nb_erp,
    req_ad.idadresse,
    req_ad.commune,
    req_ad.libvoie_c,
    req_ad.numero,
    req_ad.etiquette,
    req_ad.numero_repet,
    req_ad.angle,
    req_ad.repet,
    req_ad.adresse,
    req_ad.adresse_courte,
    req_ad.mot_dir,
    req_ad.libvoie_a,
    req_ad.epci,
    req_ad.insee,
    req_ad.geom
   FROM req_ad
     LEFT JOIN req_erp ON req_ad.idadresse = req_erp.idadresse
WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp.xapps_geo_vmr_adresse_erp IS 'Vue matérialisée applicative pour le fonctionnel de saisie/interrogation d''ERP à l''adresse dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.nb_erp IS 'Nombre d''ERP';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.idadresse IS 'Identifiant adresse';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.commune IS 'Nom de la commune';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.libvoie_c IS 'Libellé de la voie (complet)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.numero IS 'Numéro';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.etiquette IS 'Etiquette visible sur la cartographie (numéro + repet raccourci)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.numero_repet IS 'Numéro + repet complet pour tri';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.angle IS 'Angle de rotation de l''étiquette';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.repet IS 'Indice de répétition';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.adresse IS 'Adresse';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.adresse_courte IS 'Adresse sans code postal et commune';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.mot_dir IS 'Mot directeur';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.libvoie_a IS 'Libellé de la voie (abrégé)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.epci IS 'Sigle de l''EPCI';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.insee IS 'Code insee de la commune';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_adresse_erp.geom IS 'Géométrie ponctuelle du lieu ERP';

-- Permissions

ALTER TABLE m_erp.xapps_geo_vmr_adresse_erp OWNER TO sig_create;
GRANT ALL ON TABLE m_erp.xapps_geo_vmr_adresse_erp TO sig_create;
GRANT DELETE, SELECT, UPDATE, INSERT, MAINTAIN ON TABLE m_erp.xapps_geo_vmr_adresse_erp TO sig_edit;
GRANT SELECT ON TABLE m_erp.xapps_geo_vmr_adresse_erp TO sig_read;

-- ################################################################# TABLE xapps_geo_vmr_erp ###############################################

-- m_erp.xapps_geo_vmr_erp source

CREATE MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp
TABLESPACE pg_default
AS
WITH req_nberp AS (
         SELECT a.idadresse,
            count(*) AS nb_erp,
            (('<b>'::text || a.adresse_courte) || '</b><br>'::text) || string_agg(((((o.libelle::text || ' (catégorie : '::text) ||
                CASE
                    WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
                    ELSE o.cat
                END::text) || ', type : '::text) ||
                CASE
                    WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
                    ELSE o.erptype
                END::text) || ')'::text, '<br>'::text) AS info_bulle,
            a.geom
           FROM m_erp.xapps_geo_vmr_adresse_erp a
             JOIN m_erp.an_erp_objet o USING (idadresse)
             JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
          WHERE o.etat_reg::text <> '31'::text AND o.dbstatut::text = '10'::text
          GROUP BY a.idadresse, a.geom, a.adresse_courte, e.valeur
        ), req_nberp_ferme AS (
         SELECT a.idadresse,
            count(*) AS nb_erp,
            (('<b>'::text || a.adresse_courte) || '</b><br>'::text) || string_agg(((((o.libelle::text || ' (catégorie : '::text) ||
                CASE
                    WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
                    ELSE o.cat
                END::text) || ', type : '::text) ||
                CASE
                    WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
                    ELSE o.erptype
                END::text) || ')'::text, '<br>'::text) AS info_bulle
           FROM m_erp.xapps_geo_vmr_adresse_erp a
             LEFT JOIN m_erp.an_erp_objet_h o USING (idadresse)
             JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
          WHERE NOT (o.idadresse IN ( SELECT an_erp_objet.idadresse
                   FROM m_erp.an_erp_objet
                  WHERE an_erp_objet.idadresse IS NOT NULL))
          GROUP BY a.idadresse, a.adresse_courte, e.valeur
        ), req_etat_reg AS (
         WITH req_etat_reg AS (
                 WITH req_objet AS (
                         SELECT o_1.idadresse,
                            o_1.etat_reg
                           FROM m_erp.an_erp_objet o_1
                          WHERE o_1.idadresse IS NOT NULL AND o_1.dbstatut::text = '10'::text
                        UNION ALL
                         SELECT oh.idadresse,
                            oh.etat
                           FROM m_erp.an_erp_objet_h oh
                          WHERE oh.idadresse IS NOT NULL AND oh.dbstatut::text = '10'::text
                        )
                 SELECT o.idadresse,
                    string_agg(DISTINCT o.etat_reg::text, ';'::text ORDER BY (o.etat_reg::text)) AS etat_reg
                   FROM req_objet o
                  GROUP BY o.idadresse
                )
         SELECT req_etat_reg.idadresse,
                case
	                WHEN req_etat_reg.etat_reg ~~ '%21%'::text THEN '21'::text
	                WHEN req_etat_reg.etat_reg ~~ '%22%'::text THEN '22'::text
                    WHEN req_etat_reg.etat_reg ~~ '%30%'::text THEN '30'::text
					WHEN req_etat_reg.etat_reg ~~ '%40%'::text THEN '40'::text
					WHEN req_etat_reg.etat_reg ~~ '%10%'::text THEN '10'::text
	                WHEN req_etat_reg.etat_reg ~~ '%11%'::text THEN '11'::text
                    WHEN req_etat_reg.etat_reg = '31'::text THEN '31'::text
                    ELSE '20'::text
                END AS etat_reg
           FROM req_etat_reg
        ), req_etat AS (
         WITH req_etat AS (
                 WITH req_objet AS (
                         SELECT o_1.idadresse,
                            o_1.etat
                           FROM m_erp.an_erp_objet o_1
                          WHERE o_1.idadresse IS NOT NULL AND o_1.dbstatut::text = '10'::text
                        UNION ALL
                         SELECT oh.idadresse,
                            oh.etat
                           FROM m_erp.an_erp_objet_h oh
                          WHERE oh.idadresse IS NOT NULL AND oh.dbstatut::text = '10'::text
                        )
                 SELECT o.idadresse,
                    string_agg(DISTINCT o.etat::text, ';'::text ORDER BY (o.etat::text)) AS etat
                   FROM req_objet o
                  GROUP BY o.idadresse
                )
         SELECT req_etat.idadresse,
                CASE
                    WHEN req_etat.etat ~~ '%10%'::text THEN '10'::text
                    WHEN req_etat.etat ~~ '%30%'::text THEN '30'::text
                    WHEN req_etat.etat = '31'::text THEN '31'::text
                    ELSE '20'::text
                END AS etat
           FROM req_etat
        )
 SELECT 'BAL_'::text || a.idadresse AS idgeo,
    nb.nb_erp,
    lte.valeur AS affiche_carto,
    lter.valeur AS affiche_carto_reg,
        CASE
            WHEN lte.valeur::text = 'ERP fermé'::text THEN nbf.info_bulle
            ELSE nb.info_bulle
        END AS info_bulle,
    er.etat_reg,
    e.etat,
    a.insee,
    a.etiquette,
    a.angle,
    a.geom
   FROM m_erp.xapps_geo_vmr_adresse_erp a
     LEFT JOIN req_nberp nb ON nb.idadresse = a.idadresse
     LEFT JOIN req_nberp_ferme nbf ON a.idadresse = nbf.idadresse
     LEFT JOIN req_etat_reg er ON er.idadresse = a.idadresse
     LEFT JOIN req_etat e ON e.idadresse = a.idadresse
     LEFT JOIN m_erp.lt_erp_objet_etat lter ON lter.code::text = er.etat_reg
     LEFT JOIN m_erp.lt_erp_objet_etat lte ON lte.code::text = e.etat
UNION ALL
 SELECT 'ERP_'::text || p.idobjet AS idgeo,
    count(*) AS nb_erp,
    e.valeur AS affiche_carto,
    e.valeur AS affiche_carto_reg,
    ((((((('<b>'::text || p.indication) || '</b><br>'::text) || o.libelle::text) || ' (catégorie : '::text) ||
        CASE
            WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
            ELSE o.cat
        END::text) || ', type : '::text) ||
        CASE
            WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
            ELSE o.erptype
        END::text) || ')'::text AS info_bulle,
    o.etat,
    o.etat as etat_reg,
    p.insee,
    ''::text AS etiquette,
    NULL::integer AS angle,
    p.geom
   FROM m_erp.geo_erp_userpoint p
     JOIN m_erp.an_erp_objet o USING (idobjet, dbstatut)
     JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
  WHERE o.etat::text <> '31'::text AND o.dbstatut::text = '10'::text
  GROUP BY ('ERP_'::text || p.idobjet), p.geom, (((((((('<b>'::text || p.indication) || '</b><br>'::text) || o.libelle::text) || ' (catégorie : '::text) ||
        CASE
            WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
            ELSE o.cat
        END::text) || ', type : '::text) ||
        CASE
            WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
            ELSE o.erptype
        END::text) || ')'::text), e.valeur, o.etat, p.insee
WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp IS 'Vue matérialisée applicative pour la visualisation des ERP à l''adresse et temporaire dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.idgeo IS 'Identifiant temporaire des ERP regroupés (à l''adresse et temporaire)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.nb_erp IS 'Nombre d''ERP (non fermé)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.affiche_carto IS 'Attribut pour la catégorisation d''affichage dans GEO avec l''état réel';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.affiche_carto_reg IS 'Attribut pour la catégorisation d''affichage dans GEO avec l''état réglementaire';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.info_bulle IS 'Contenu de l''info bulle affiché dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.etat IS 'Etat réél de l''ERP';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.etat_reg IS 'Etat réglementaire de l''ERP';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.insee IS 'Code Insee de la commune';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.geom IS 'Géométrie des points de localisation';



/* ANCIENNE VERSION AVEC UNISUEMENT L'ETAT REEL

-- m_erp.xapps_geo_vmr_erp source

CREATE MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp
TABLESPACE pg_default
AS WITH req_nberp AS (
         SELECT a.idadresse,
            count(*) AS nb_erp,
            (('<b>'::text || a.adresse_courte) || '</b><br>'::text) || string_agg(((((o.libelle::text || ' (catégorie : '::text) ||
                CASE
                    WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
                    ELSE o.cat
                END::text) || ', type : '::text) ||
                CASE
                    WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
                    ELSE o.erptype
                END::text) || ')'::text, '<br>'::text) AS info_bulle,
            a.geom
           FROM m_erp.xapps_geo_vmr_adresse_erp a
             JOIN m_erp.an_erp_objet o USING (idadresse)
             JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
          WHERE o.etat::text <> '31'::text AND o.dbstatut::text = '10'::text
          GROUP BY a.idadresse, a.geom, a.adresse_courte, e.valeur
        ), req_nberp_ferme AS (
         SELECT a.idadresse,
            count(*) AS nb_erp,
            (('<b>'::text || a.adresse_courte) || '</b><br>'::text) || string_agg(((((o.libelle::text || ' (catégorie : '::text) ||
                CASE
                    WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
                    ELSE o.cat
                END::text) || ', type : '::text) ||
                CASE
                    WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
                    ELSE o.erptype
                END::text) || ')'::text, '<br>'::text) AS info_bulle
           FROM m_erp.xapps_geo_vmr_adresse_erp a
             LEFT JOIN m_erp.an_erp_objet_h o USING (idadresse)
             JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
          WHERE NOT (o.idadresse IN ( SELECT an_erp_objet.idadresse
                   FROM m_erp.an_erp_objet
                  WHERE an_erp_objet.idadresse IS NOT NULL))
          GROUP BY a.idadresse, a.adresse_courte, e.valeur
        ), req_etat AS (
         WITH req_etat AS (
                 WITH req_objet AS (
                         SELECT o_1.idadresse,
                            o_1.etat
                           FROM m_erp.an_erp_objet o_1
                          WHERE o_1.idadresse IS NOT NULL AND o_1.dbstatut::text = '10'::text
                        UNION ALL
                         SELECT oh.idadresse,
                            oh.etat
                           FROM m_erp.an_erp_objet_h oh
                          WHERE oh.idadresse IS NOT NULL AND oh.dbstatut::text = '10'::text
                        )
                 SELECT o.idadresse,
                    string_agg(DISTINCT o.etat::text, ';'::text ORDER BY (o.etat::text)) AS etat
                   FROM req_objet o
                  GROUP BY o.idadresse
                )
         SELECT req_etat.idadresse,
                CASE
                    WHEN req_etat.etat ~~ '%10%'::text THEN '10'::text
                    WHEN req_etat.etat ~~ '%30%'::text THEN '30'::text
                    WHEN req_etat.etat = '31'::text THEN '31'::text
                    ELSE '20'::text
                END AS etat
           FROM req_etat
        )
 SELECT 'BAL_'::text || a.idadresse AS idgeo,
    nb.nb_erp,
    lte.valeur AS affiche_carto,
        CASE
            WHEN lte.valeur::text = 'ERP fermé'::text THEN nbf.info_bulle
            ELSE nb.info_bulle
        END AS info_bulle,
    e.etat,
    a.insee,
    a.etiquette,
    a.angle,
    a.geom
   FROM m_erp.xapps_geo_vmr_adresse_erp a
     LEFT JOIN req_nberp nb ON nb.idadresse = a.idadresse
     LEFT JOIN req_nberp_ferme nbf ON a.idadresse = nbf.idadresse
     LEFT JOIN req_etat e ON e.idadresse = a.idadresse
     LEFT JOIN m_erp.lt_erp_objet_etat lte ON lte.code::text = e.etat
UNION ALL
 SELECT 'ERP_'::text || p.idobjet AS idgeo,
    count(*) AS nb_erp,
    e.valeur AS affiche_carto,
    ((((((('<b>'::text || p.indication) || '</b><br>'::text) || o.libelle::text) || ' (catégorie : '::text) ||
        CASE
            WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
            ELSE o.cat
        END::text) || ', type : '::text) ||
        CASE
            WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
            ELSE o.erptype
        END::text) || ')'::text AS info_bulle,
    o.etat,
    p.insee,
    ''::text AS etiquette,
    NULL::integer AS angle,
    p.geom
   FROM m_erp.geo_erp_userpoint p
     JOIN m_erp.an_erp_objet o USING (idobjet, dbstatut)
     JOIN m_erp.lt_erp_objet_etat e ON e.code::text = o.etat::text
  WHERE o.etat::text <> '31'::text AND o.dbstatut::text = '10'::text
  GROUP BY ('ERP_'::text || p.idobjet), p.geom, (((((((('<b>'::text || p.indication) || '</b><br>'::text) || o.libelle::text) || ' (catégorie : '::text) ||
        CASE
            WHEN o.cat::text = '0'::text THEN 'non renseignée'::character varying
            ELSE o.cat
        END::text) || ', type : '::text) ||
        CASE
            WHEN o.erptype::text = '00'::text THEN 'non renseigné'::character varying
            ELSE o.erptype
        END::text) || ')'::text), e.valeur, o.etat, p.insee
WITH DATA;

COMMENT ON MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp IS 'Vue matérialisée applicative pour la visualisation des ERP à l''adresse et temporaire dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.idgeo IS 'Identifiant temporaire des ERP regroupés (à l''adresse et temporaire)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.nb_erp IS 'Nombre d''ERP (non fermé)';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.affiche_carto IS 'Attribut pour la catégorisation d''affichage dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.info_bulle IS 'Contenu de l''info bulle affiché dans GEO';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.etat IS 'Etat de l''ERP';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.insee IS 'Code Insee de la commune';
COMMENT ON COLUMN m_erp.xapps_geo_vmr_erp.geom IS 'Géométrie des points de localisation';
 
 */

-- ################################################################# TABLE xapps_geo_v_erp_historise ###############################################
-- m_erp.xapps_geo_v_erp_historise source

-- m_erp.xapps_geo_v_erp_historise source

CREATE OR REPLACE VIEW m_erp.xapps_geo_v_erp_historise
AS WITH RECURSIVE descendants AS (
         SELECT lk_an_erp_objet_histo.idobjet_e,
            lk_an_erp_objet_histo.idobjet_p,
            0 AS level
           FROM m_erp.lk_an_erp_objet_histo
        UNION ALL
         SELECT t.idobjet_e,
            d_1.idobjet_p,
            d_1.level + 1
           FROM m_erp.lk_an_erp_objet_histo t
             JOIN descendants d_1 ON t.idobjet_p = d_1.idobjet_e
        )
 SELECT row_number() OVER () AS id,
    idobjet_p,
    idobjet_e
   FROM descendants d
  ORDER BY idobjet_e;

COMMENT ON VIEW m_erp.xapps_geo_v_erp_historise IS 'Vue récursive permettant de récupérer pour chaque objet parent, tous les enfants (pour affichage de l''historique des ERP).';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_historise.id IS 'Identifiant de la relation';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_historise.idobjet_p IS 'Identifiant de l''objet parent';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_historise.idobjet_e IS 'Identifiant des objets enfantes';

-- Permissions

ALTER TABLE m_erp.xapps_geo_v_erp_historise OWNER TO sig_create;
GRANT ALL ON TABLE m_erp.xapps_geo_v_erp_historise TO sig_create;
GRANT DELETE, SELECT, UPDATE, INSERT ON TABLE m_erp.xapps_geo_v_erp_historise TO sig_edit;
GRANT SELECT ON TABLE m_erp.xapps_geo_v_erp_historise TO sig_read;


-- ################################################################# TABLE xapps_geo_v_erp_ferme_dispo ###############################################

-- m_erp.xapps_geo_v_erp_ferme_dispo source

CREATE OR REPLACE VIEW m_erp.xapps_geo_v_erp_ferme_dispo
AS SELECT row_number() OVER () AS id,
    idadresse,
    idobjet,
    libelle
   FROM m_erp.an_erp_objet_h h
  WHERE NOT (idobjet IN ( SELECT xapps_geo_v_erp_historise.idobjet_e
           FROM m_erp.xapps_geo_v_erp_historise));

COMMENT ON VIEW m_erp.xapps_geo_v_erp_ferme_dispo IS 'Vue listant les ERP par adresse non affecté à un ERP existant.';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_ferme_dispo.id IS 'Identifiant temporaire de résultat';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_ferme_dispo.idadresse IS 'Identifiant de l''adresse';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_ferme_dispo.idobjet IS 'Identifiant des ERP fermés';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_ferme_dispo.libelle IS 'Libellé de l''ERP';



-- ################################################################# TABLE xapps_geo_v_erp_maitre ###############################################

-- m_erp.xapps_geo_v_erp_maitre source

CREATE OR REPLACE VIEW m_erp.xapps_geo_v_erp_maitre
AS SELECT idadresse,
    idobjet,
    libelle
   FROM m_erp.an_erp_objet
  WHERE "group"::text = '30'::text AND dbstatut::text = '10'::text;

COMMENT ON VIEW m_erp.xapps_geo_v_erp_maitre IS 'Vue listant les ERP maitre à l''adresse.';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_maitre.idadresse IS 'Identifiant de l''adresse';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_maitre.idobjet IS 'Identifiant des ERP maître';
COMMENT ON COLUMN m_erp.xapps_geo_v_erp_maitre.libelle IS 'Libellé de l''ERP maître';




-- ################################################################# TABLE xapps_geo_v_erp_tab1 ###############################################

-- m_erp.xapps_geo_v_erp_tab1 source

CREATE OR REPLACE VIEW m_erp.xapps_geo_v_erp_tab1
AS WITH req_nberp AS (
         SELECT 1 AS id,
            count(*) AS nb_erp
           FROM m_erp.an_erp_objet
          WHERE (an_erp_objet.etat::text = ANY (ARRAY['10'::character varying::text, '20'::character varying::text, '30'::character varying::text])) AND an_erp_objet.dbstatut::text = '10'::text
        ), req_nberp_exist AS (
         SELECT 1 AS id,
            count(*) AS nb_erp_exist
           FROM m_erp.an_erp_objet
          WHERE an_erp_objet.etat::text = '10'::text AND an_erp_objet.dbstatut::text = '10'::text
        ), req_nberp_create AS (
         SELECT 1 AS id,
            count(*) AS nb_erp_create
           FROM m_erp.an_erp_objet
          WHERE an_erp_objet.etat::text = '20'::text AND an_erp_objet.dbstatut::text = '10'::text
        ), req_nberp_fermetemp AS (
         SELECT 1 AS id,
            count(*) AS nb_erp_fermetemp
           FROM m_erp.an_erp_objet
          WHERE an_erp_objet.etat::text = '30'::text AND an_erp_objet.dbstatut::text = '10'::text
        ), req_cat AS (
         WITH req_cat_detail AS (
                 SELECT 1 AS id,
                    an_erp_objet.cat,
                    count(*) AS nb
                   FROM m_erp.an_erp_objet
                  WHERE (an_erp_objet.etat::text = ANY (ARRAY['10'::character varying::text, '20'::character varying::text, '30'::character varying::text])) AND an_erp_objet.dbstatut::text = '10'::text
                  GROUP BY an_erp_objet.cat
                  ORDER BY an_erp_objet.cat
                )
         SELECT req_cat_detail.id,
            COALESCE(max(
                CASE
                    WHEN req_cat_detail.cat::text = '1'::text THEN req_cat_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cat1,
            COALESCE(max(
                CASE
                    WHEN req_cat_detail.cat::text = '2'::text THEN req_cat_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cat2,
            COALESCE(max(
                CASE
                    WHEN req_cat_detail.cat::text = '3'::text THEN req_cat_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cat3,
            COALESCE(max(
                CASE
                    WHEN req_cat_detail.cat::text = '4'::text THEN req_cat_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cat4,
            COALESCE(max(
                CASE
                    WHEN req_cat_detail.cat::text = '5'::text THEN req_cat_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cat5
           FROM req_cat_detail
          GROUP BY req_cat_detail.id
        ), req_type AS (
         WITH req_type_detail AS (
                 SELECT 1 AS id,
                    o.erptype,
                    count(*) AS nb
                   FROM m_erp.an_erp_objet o,
                    m_erp.lt_erp_objet_erptype l
                  WHERE o.erptype::text = l.code::text AND (o.etat::text = ANY (ARRAY['10'::character varying::text, '20'::character varying::text, '30'::character varying::text])) AND o.dbstatut::text = '10'::text
                  GROUP BY o.erptype, l.tri
                  ORDER BY l.tri
                )
         SELECT req_type_detail.id,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'J'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS j,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'L'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS l,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'M'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS m,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'N'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS n,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'O'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS o,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'P'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS p,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'R'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS r,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'S'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS s,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'T'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS t,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'U'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS u,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'V'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS v,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'W'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS w,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'X'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS x,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'Y'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS y,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'GA'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS ga,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'PA'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS pa,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'PS'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS ps,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'EF'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS ef,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'SG'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS sg,
            COALESCE(max(
                CASE
                    WHEN req_type_detail.erptype::text = 'CTS'::text THEN req_type_detail.nb
                    ELSE NULL::bigint
                END), 0::bigint) AS cts
           FROM req_type_detail
          GROUP BY req_type_detail.id
        )
 SELECT n.id,
    n.nb_erp,
    e.nb_erp_exist,
    ec.nb_erp_create,
    f.nb_erp_fermetemp,
    c.cat1,
    c.cat2,
    c.cat3,
    c.cat4,
    c.cat5,
    t.j,
    t.l,
    t.m,
    t.n,
    t.o,
    t.p,
    t.r,
    t.s,
    t.t,
    t.u,
    t.v,
    t.w,
    t.x,
    t.y,
    t.ga,
    t.pa,
    t.ps,
    t.ef,
    t.sg,
    t.cts
   FROM req_nberp n
     JOIN req_nberp_exist e ON n.id = e.id
     JOIN req_nberp_create ec ON n.id = ec.id
     JOIN req_nberp_fermetemp f ON n.id = f.id
     JOIN req_cat c ON n.id = c.id
     JOIN req_type t ON n.id = t.id;

COMMENT ON VIEW m_erp.xapps_geo_v_erp_tab1 IS 'Vue applicative du tableau bord pour les chiffres clés des ERP';



-- ################################################################# TABLE xapps_geo_v_erp_tab2 ###############################################
-- m_erp.xapps_geo_v_erp_tab2 source

CREATE OR REPLACE VIEW m_erp.xapps_geo_v_erp_tab2
AS WITH req_typ AS (
         SELECT o.erptype,
            count(*) AS nb
           FROM m_erp.an_erp_objet o
          WHERE (o.etat::text = ANY (ARRAY['10'::character varying::text, '20'::character varying::text, '30'::character varying::text])) AND o.dbstatut::text = '10'::text
          GROUP BY o.erptype
        )
 SELECT row_number() OVER () AS id,
        CASE
            WHEN l.code::text = '00'::text THEN 'n.r'::character varying
            ELSE l.code
        END AS code,
        CASE
            WHEN t.nb IS NULL THEN 0::numeric
            ELSE t.nb::numeric
        END AS nb_erp,
    l.tri::numeric AS tri
   FROM m_erp.lt_erp_objet_erptype l
     LEFT JOIN req_typ t ON t.erptype::text = l.code::text
  WHERE l.code::text <> 'ZZ'::text
  ORDER BY l.tri;

COMMENT ON VIEW m_erp.xapps_geo_v_erp_tab2 IS 'Vue applicative du tableau bord pour le graphique de répartition par typologie des ERP';





-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      OPEN DATA                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# TABLE  ###############################################

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     FONCTION                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################   

-- ################################################################# FUNCTION ft_m_controle_erp_saisie_contact ###############################################

-- DROP FUNCTION m_erp.ft_m_controle_erp_saisie_contact();

CREATE OR REPLACE FUNCTION m_erp.ft_m_controle_erp_saisie_contact()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$


BEGIN
	
	IF (TG_OP = 'INSERT' or TG_OP = 'UPDATE') THEN    

    IF LENGTH(COALESCE(trim(new.tel::text), '')) = 0 AND LENGTH(COALESCE(trim(new.email::text), '')) = 0  AND LENGTH(COALESCE(trim(new.mobile::text), '')) = 0 THEN
	RAISE EXCEPTION 'Vous devez au moins remplir un n° de téléphone ou un email pour créer un contact';
	END IF;
	IF  LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
		IF left(new.tel,1) <> '0' THEN
			RAISE EXCEPTION 'Le numéro de téléphone ne peut commencer que par le chiffre 0.';
		END IF;
	END IF;
    IF LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
	   IF left(new.tel,1) <> '0' THEN
        	RAISE EXCEPTION 'Le numéro de téléphone ne peut commencer que par le chiffre 0.';
	   END IF;
	END IF;	
    IF LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
		IF (SELECT to_number(new.tel,'999999999')) < 10000000 OR (SELECT to_number(new.tel,'999999999')) > 99999999 THEN
        RAISE EXCEPTION 'Le numéro de téléphone ne correspond pas à un numéro valide.';
		END IF;
	END IF;	
	IF LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
		IF (SELECT to_number(new.tel,'999999999')) < 10000000 OR (SELECT to_number(new.tel,'999999999')) > 99999999 THEN
        RAISE EXCEPTION 'Le numéro de téléphone ne correspond pas à un numéro valide.';
		END IF;
	END IF;	
	IF LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
	     IF length(new.tel)-1 <> length(to_number(new.tel,'9999999999')::text) THEN
		 RAISE EXCEPTION 'Le numéro de téléphone saisi contient des lettres ou des caractères non chiffrés.';
		 END IF;

    END IF;
	IF LENGTH(COALESCE(trim(new.tel::text), '')) > 0 THEN
	     IF length(new.tel)-1 <> length(to_number(new.tel,'9999999999')::text) THEN
		 RAISE EXCEPTION 'Le numéro de téléphone saisi contient des lettres ou des caractères non chiffrés.';
		 END IF;
	END IF;
	
	
	
	
	IF  LENGTH(COALESCE(trim(new.mobile::text), '')) > 0 THEN
		IF left(new.mobile,1) <> '0' THEN
			RAISE EXCEPTION 'Le numéro de téléphone portable ne peut commencer que par le chiffre 0.';
		END IF;
	END IF;
    IF LENGTH(COALESCE(trim(new.mobile::text), '')) = 0 THEN
	   IF left(new.mobile,1) <> '0' THEN
        	RAISE EXCEPTION 'Le numéro de téléphone portable ne peut commencer que par le chiffre 0.';
	   END IF;
	END IF;	
    IF LENGTH(COALESCE(trim(new.mobile::text), '')) = 0 THEN
		IF (SELECT to_number(new.mobile,'999999999')) < 10000000 OR (SELECT to_number(new.mobile,'999999999')) > 99999999 THEN
        RAISE EXCEPTION 'Le numéro de téléphone portable ne correspond pas à un numéro valide.';
		END IF;
	END IF;	
	IF LENGTH(COALESCE(trim(new.mobile::text), '')) > 0  THEN
		IF (SELECT to_number(new.mobile,'999999999')) < 10000000 OR (SELECT to_number(new.mobile,'999999999')) > 99999999 THEN
        RAISE EXCEPTION 'Le numéro de téléphone portable ne correspond pas à un numéro valide.';
		END IF;
	END IF;	
	IF LENGTH(COALESCE(trim(new.mobile::text), '')) = 0 THEN
	     IF length(new.mobile)-1 <> length(to_number(new.mobile,'9999999999')::text) THEN
		 RAISE EXCEPTION 'Le numéro de téléphone portable saisi contient des lettres ou des caractères non chiffrés.';
		 END IF;

    END IF;
	IF LENGTH(COALESCE(trim(new.mobile::text), '')) = 0  THEN
	     IF length(new.mobile)-1 <> length(to_number(new.mobile,'9999999999')::text) THEN
		 RAISE EXCEPTION 'Le numéro de téléphone portable saisi contient des lettres ou des caractères non chiffrés.';
		 END IF;
	END IF;
	
	
	IF LENGTH(COALESCE(trim(new.email::text), '')) = 0  THEN
	   IF trim(new.email) not like '%@%' THEN
	   RAISE EXCEPTION 'Votre email ne contient pas le caractère @.';
	   END IF;
	END IF;
	IF LENGTH(COALESCE(trim(new.email::text), '')) = 0  THEN
	   IF trim(new.email) not like '%.%' THEN
	   RAISE EXCEPTION 'Votre email ne contient pas le caractère .fr, .com, ...';
	   END IF;
	END IF;

	END IF;

	IF (TG_OP = 'DELETE') THEN 

    IF (OLD.dbstatut = '10') THEN
    UPDATE m_erp.an_erp_contact SET dbstatut = '11' WHERE idcontact = OLD.idcontact;
    RETURN NEW;
    ELSE
	
	DELETE FROM m_erp.lk_erp_contact WHERE idcontact = OLD.idcontact;
    
    RETURN OLD;
    END IF;

END IF;
	

	
	
    return new ;
END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_controle_erp_saisie_contact() IS 'Fonction de contrôle de saisie d''un contact';


-- ################################################################# FUNCTION ft_m_erp_delete_histo ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_delete_histo();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_delete_histo()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN



	DELETE FROM m_erp.an_erp_objet WHERE idobjet IN (select idobjet FROM m_erp.an_erp_objet_h);



RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_delete_histo() IS 'Fonction gérant la suppression de l''ERP fermé dans la classe d''objet des ERP non fermé';




-- ################################################################# FUNCTION ft_m_erp_gestion_ctrl ###############################################



-- DROP FUNCTION m_erp.ft_m_erp_gestion_ctrl();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_gestion_ctrl()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

NEW.eff_total := sum(CASE WHEN LENGTH(COALESCE(trim(new.eff_public::text), '')) <> 0 THEN NEW.eff_public ELSE 0 END 
					 + 
					CASE WHEN LENGTH(COALESCE(trim(new.eff_nuit::text), '')) <> 0 THEN NEW.eff_nuit ELSE 0 END
					+
					CASE WHEN LENGTH(COALESCE(trim(new.eff_pers::text), '')) <> 0 THEN NEW.eff_pers ELSE 0 END
					+
					CASE WHEN LENGTH(COALESCE(trim(new.eff_heberg::text), '')) <> 0 THEN NEW.eff_heberg ELSE 0 END
					+
					CASE WHEN LENGTH(COALESCE(trim(new.eff_autre::text), '')) <> 0 THEN NEW.eff_autre ELSE 0 END
					);

NEW.libelle := upper(NEW.libelle);
NEW.erptype_p := lower(NEW.erptype_p);

NEW.idmaitre := CASE 
					WHEN new.group IN ('00','10','30') then null
				ELSE
					new.idmaitre
				END; 

NEW.refsdis := CASE
				WHEN LENGTH(COALESCE(trim(new.refsdis::text), '')) = 0 then null
				else NEW.refsdis END;



END IF;

-- à l'insertion force l'état réglementaire à non renseigné. Cet état est mis à jour au moment ou des évènements sont insérés
IF (TG_OP = 'INSERT') THEN

new.etat_reg := '00';

END IF;

IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW."group" = '20' AND LENGTH(COALESCE(trim(new.idmaitre::text), '')) = 0 THEN
	--raise exception 'ok -->%',NEW."group";
	RAISE EXCEPTION '<font color="#ff0000"><b>Vous ne pouvez pas saisir un ERP membre sans avoir sélection un ERP maître.</b></font><br><br>';
END IF;

IF (TG_OP = 'UPDATE') AND OLD."group" = '30' and NEW."group" = '10' AND (SELECT count(*) from m_erp.an_erp_objet WHERE idmaitre = old.idobjet) >= 1 THEN
	RAISE EXCEPTION '<font color="#ff0000"><b>Vous ne pouvez pas modifier un ERP Maître en indépendant tant que des membres y sont associés.</b></font><br><br>';
END IF;


IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') and LENGTH(COALESCE(trim(new.erptype2::text), '')) <> 0 and new.erptype = '00' then
	RAISE EXCEPTION '<font color="#ff0000"><b>Vous ne pouvez pas saisir un type secondaire si vous n''avez pas renseigné le type principale.</b></font><br><br>';
END if;


IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND new.erptype IN

	(
	with
	req_typ2 as
	(
		select unnest(STRING_TO_ARRAY(new.erptype2,';')) as erptyp2 
	)
	select
		code
	from
		req_typ2 t2 join m_erp.lt_erp_objet_erptype lt2 on t2.erptyp2 = lt2.cle 
	)
THEN

	RAISE EXCEPTION '<font color="#ff0000"><b>Vous avez saisi un type secondaire déjà identifié en type principale.</b></font><br><br>';
END if;


IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND 
(SELECT count(*) FROM m_erp.an_erp_objet WHERE etat IN ('10','11','20','21','30') AND refsdis = NEW.refsdis and idobjet <> new.idobjet and length(NEW.refsdis) > 0 ) >=1 THEN

	RAISE EXCEPTION '<font color="#ff0000"><b>Le n° de dossier SDIS est déjà attribué.</b></font><br><br>';

END IF;


IF TG_OP = 'INSERT' AND NEW.etat = '31' THEN

	RAISE EXCEPTION '<font color="#ff0000"><b>Vous devez d''abord enregistrer l''ERP en tant qu''ERP existant avant de le fermer.</b></font><br><br>';

END IF;

IF TG_OP = 'UPDATE' AND OLD.etat <> '31' AND NEW.etat = '31' THEN

INSERT INTO m_erp.an_erp_objet_h (idobjet,idadresse,refrnb,refsdis,libelle,cat,erptype,erptype_p,erptype2,etat,"group",idmaitre,ephemere,
eff_public,eff_nuit,eff_pers,eff_heberg,eff_total,loc_som,erp_src,erp_public,siret,ouvert_d,ferme_d,ferme_src,observ,op_sai,op_maj,dbstatut,
dbinsert,dbupdate,dbhisto,complt,eff_autre) VALUES (old.idobjet,old.idadresse,old.refrnb,old.refsdis,old.libelle,old.cat,old.erptype,OLD.erptype_p,old.erptype2,NEW.etat,old."group",old.idmaitre,old.ephemere,
old.eff_public,old.eff_nuit,old.eff_pers,old.eff_heberg,old.eff_total,old.loc_som,old.erp_src,OLD.erp_public,old.siret,old.ouvert_d,old.ferme_d,old.ferme_src,old.observ,old.op_sai,old.op_maj,old.dbstatut,
old.dbinsert,old.dbupdate,now(),old.complt,old.eff_autre);

	--IF (SELECT count(*) FROM m_erp.geo_erp_userpoint WHERE idobjet=OLD.idobjet) = 1 THEN
	IF EXISTS (SELECT 1 FROM m_erp.geo_erp_userpoint WHERE idobjet=OLD.idobjet) THEN
		INSERT INTO m_erp.geo_erp_userpoint_h (idobjet,x_l93,y_l93,insee,commune,indication,dbstatut,geom,dbhisto) 
		SELECT idobjet,x_l93,y_l93,insee,commune,indication,dbstatut,geom,now() FROM m_erp.geo_erp_userpoint WHERE idobjet=OLD.idobjet;
		
	END IF;

END IF;
IF TG_OP = 'UPDATE' AND OLD.dbstatut = '11' AND NEW.dbstatut = '10' AND (SELECT count(*) FROM m_erp.geo_erp_userpoint WHERE idobjet = OLD.idobjet) = 1 THEN

	UPDATE m_erp.geo_erp_userpoint SET dbstatut = NEW.dbstatut WHERE idobjet = OLD.idobjet;

END IF;

IF TG_OP = 'UPDATE' AND OLD.dbstatut = '10' AND NEW.dbstatut = '11' AND (SELECT count(*) FROM m_erp.geo_erp_userpoint WHERE idobjet = OLD.idobjet) = 1 THEN

	UPDATE m_erp.geo_erp_userpoint SET dbstatut = NEW.dbstatut WHERE idobjet = OLD.idobjet;

END IF;


IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') and NEW.idobjet_enfant IS NOT NULL THEN

INSERT INTO m_erp.lk_an_erp_objet_histo (id, idobjet_p, idobjet_e) VALUES
(nextval('m_erp.lk_an_erp_objet_histo_id_seq'::regclass),NEW.idobjet,NEW.idobjet_enfant);

NEW.idobjet_enfant := NULL;

END IF;

IF (TG_OP = 'INSERT') AND NEW."group" = '20' THEN

insert into m_erp.lk_erp_contact (idobjet,idcontact,code_fonction)

select o.idobjet, lkc.idcontact, lkc.code_fonction from m_erp.lk_erp_contact lkc, m_erp.an_erp_objet o where o.idobjet IN

(
WITH
req_objet_avec_maitre as
(
select o.idobjet from m_erp.lk_erp_contact lkc,  m_erp.an_erp_objet o where lkc.idobjet = o.idmaitre 
)
select 
	m.idobjet
from 
	req_objet_avec_maitre m where m.idobjet not in (select idobjet from m_erp.lk_erp_contact where code_fonction = '04')
) and o.idobjet = NEW.idobjet;


END IF;

IF (TG_OP = 'UPDATE') AND OLD."group" = '20' AND NEW."group" = '10' THEN
	NEW.idmaitre := NULL;
END IF;


IF (TG_OP = 'DELETE') THEN 

    IF (OLD.dbstatut = '10') THEN
    UPDATE m_erp.an_erp_objet SET dbstatut = '11' WHERE idobjet = OLD.idobjet;
    RETURN NEW;
    ELSE
	--raise EXCEPTION 'OK -->%',old.dbstatut;
    DELETE FROM m_erp.lk_erp_contact WHERE idobjet = OLD.idobjet;
    DELETE FROM m_erp.lk_erp_orga WHERE idobjet = OLD.idobjet;
    DELETE FROM m_erp.an_erp_objet_media WHERE idobjet = OLD.idobjet;
    DELETE FROM m_erp.geo_erp_userpoint WHERE idobjet = OLD.idobjet;
    DELETE FROM m_erp.an_erp_cad WHERE idobjet = OLD.idobjet;
	DELETE FROM m_erp.lk_an_erp_objet_histo WHERE idobjet_p = OLD.idobjet;
	
	--DELETE FROM m_erp.lk_an_erp_objet_histo WHERE idobjet_p = OLD.idobjet;
	--DELETE FROM m_erp.lk_an_erp_objet_histo WHERE idobjet_e = OLD.idobjet;

	--DELETE FROM m_erp.an_erp_eve_media WHERE ideve = ;
	
    RETURN OLD;
    END IF;


END IF;

	
RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_gestion_ctrl() IS 'Fonction gérant la gestion et le contrôle des objets ERP';





-- ################################################################# FUNCTION ft_m_erp_gestion_orga ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_gestion_orga();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_gestion_orga()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN


IF (TG_OP = 'DELETE') THEN 

    IF (OLD.dbstatut = '10') THEN
    UPDATE m_erp.an_erp_orga SET dbstatut = '11' WHERE idorga = OLD.idorga;
    RETURN NEW;
    ELSE
		
	DELETE FROM m_erp.lk_erp_orga WHERE idorga = OLD.idorga;
    
    RETURN OLD;
    END IF;

END IF;

	
RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_gestion_orga() IS 'Fonction gérant la gestion des contrôles des organismes.';


-- ################################################################# FUNCTION ft_m_erp_log ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_log();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_log()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE v_idlog bigint;
DECLARE v_dataold text;
DECLARE v_datanew text;
DECLARE v_tablename character varying(80);

BEGIN

IF (TG_OP = 'INSERT') THEN

  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_datanew := ROW(NEW.*); -- On concatène tous les attributs dans un seul
  INSERT INTO m_erp.an_erp_log (idlog, tablename, typeope, dataold, datanew, dbinsert)
  SELECT
  v_idlog,
  TG_TABLE_NAME,
  'INSERT',
  NULL,
  v_datanew,
  now(); 
  RETURN NEW;
  
ELSIF (TG_OP = 'UPDATE') THEN 
  
  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_dataold := ROW(OLD.*); -- On concatène tous les anciens attributs dans un seul
  v_datanew := ROW(NEW.*); -- On concatène tous les nouveaux attributs dans un seul	
  v_tablename := TG_TABLE_NAME;
  INSERT INTO m_erp.an_erp_log (idlog, tablename, typeope, dataold, datanew, dbinsert)
  SELECT
  v_idlog,
  v_tablename,
  'UPDATE',
  v_dataold,
  v_datanew,
  now();
  RETURN NEW;
  
ELSIF (TG_OP = 'DELETE') THEN 
  
  v_idlog := nextval('m_erp.an_erp_log_idlog_seq'::regclass);
  v_dataold := ROW(OLD.*); -- On concatène tous les anciens attributs dans un seul
  v_tablename := TG_TABLE_NAME;
  INSERT INTO m_erp.an_erp_log (idlog, tablename, typeope, dataold, datanew, dbinsert)
  SELECT
  v_idlog,
  v_tablename,
  'DELETE',
  v_dataold,
  NULL,
  now();
  RETURN OLD;   

END IF;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_log() IS 'Fonction gérant l''insertion d''une opération effectuée sur les données ERP dans la table des logs';




-- ################################################################# FUNCTION ft_m_erp_refresh ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_refresh();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_refresh()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN
 
	
REFRESH MATERIALIZED VIEW m_erp.xapps_geo_vmr_adresse_erp;
REFRESH MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp;


RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_refresh() IS 'Fonction gérant le rafraichissement des vues matérialisées ERP';




-- ################################################################# FUNCTION ft_m_erp_resp_unique ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_resp_unique();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_resp_unique()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN



insert into m_erp.lk_erp_contact (idobjet,idcontact,code_fonction)
select DISTINCT o.idobjet, lkc.idcontact, lkc.code_fonction from m_erp.lk_erp_contact lkc, m_erp.an_erp_objet o where o.idobjet IN

(
WITH
req_objet_avec_maitre as
(
select distinct o.idobjet from m_erp.lk_erp_contact lkc,  m_erp.an_erp_objet o where lkc.idobjet = o.idmaitre 
)
select distinct
	m.idobjet
from 
	req_objet_avec_maitre m where m.idobjet not in (select idobjet from m_erp.lk_erp_contact where code_fonction = '04')
) and o.idobjet =NEW.idobjet;


RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_resp_unique() IS 'Fonction gérant l''associaiton du responsable unique d''un groupement aux membres';




-- ################################################################# FUNCTION ft_m_erp_temp_gestion_ctrl ###############################################

-- DROP FUNCTION m_erp.ft_m_erp_temp_gestion_ctrl();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_temp_gestion_ctrl()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

IF (TG_OP = 'INSERT') AND (SELECT count(*) FROM r_osm.geo_vm_osm_commune_arcba c where c.insee = '60159' AND st_intersects(c.geom,new.geom) is false) = 1 THEN

	RAISE EXCEPTION '<font color="#ff0000"><b>Vous ne pouvez pas saisir un ERP temporaire en dehors des limites communales de Compiègne.</b></font><br><br>';

END IF ;
IF (TG_OP = 'UPDATE') AND st_equals(old.geom,new.geom) is false AND (SELECT count(*) FROM r_osm.geo_vm_osm_commune_arcba c where c.insee = '60159' AND st_intersects(c.geom,new.geom) is false) = 1 THEN

	RAISE EXCEPTION '<font color="#ff0000"><b>Vous ne pouvez pas déplacer un ERP temporaire en dehors des limites communales de Compiègne.</b></font><br><br>';

END IF ;


IF ((TG_OP = 'INSERT') OR (TG_OP = 'UPDATE')) and (select insee from r_osm.geo_vm_osm_commune_grdc where st_intersects(new.geom,geom)) <> '60159' THEN
		RAISE EXCEPTION '<font color="#FF0000"><b>Vous ne pouvez pas saisir un ERP temporaire en dehors de la commune de Compiègne.</font></b><br><br>';
end if;


IF (TG_OP = 'DELETE') THEN 


    IF (OLD.dbstatut = '10') THEN
    UPDATE m_erp.an_erp_objet SET dbstatut = '11' WHERE idobjet = OLD.idobjet;
	UPDATE m_erp.geo_erp_userpoint SET dbstatut = '11' WHERE idobjet = OLD.idobjet;

    RETURN NEW;
    ELSE
	--DELETE FROM m_erp.lk_an_erp_objet_histo WHERE idobjet_p = OLD.idobjet;
	--DELETE FROM m_erp.lk_an_erp_objet_histo WHERE idobjet_e = OLD.idobjet;

	--DELETE FROM m_erp.an_erp_eve_media WHERE ideve = ;
    RETURN OLD;
    END IF;

END IF;


	
RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_temp_gestion_ctrl() IS 'Fonction gérant la gestion et le contrôle des objets ERP temporaires';



-- ################################################################# FUNCTION ft_m_erp_temp_refresh ###############################################
-- DROP FUNCTION m_erp.ft_m_erp_temp_refresh();

CREATE OR REPLACE FUNCTION m_erp.ft_m_erp_temp_refresh()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN
 
	
REFRESH MATERIALIZED VIEW m_erp.xapps_geo_vmr_erp;


RETURN NEW;

END;

$function$
;

COMMENT ON FUNCTION m_erp.ft_m_erp_temp_refresh() IS 'Fonction gérant le rafraichissement de la vue matérilaisée affichant la synthèse des ERP adressé et temporaire';

-- ################################################################# FUNCTION ft_m_verif_ref_cad ###############################################

-- DROP FUNCTION m_erp.ft_m_verif_ref_cad();

CREATE OR REPLACE FUNCTION m_erp.ft_m_verif_ref_cad()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

IF LENGTH(COALESCE(trim(new.ccosec::text), '')) <> 2 OR LENGTH(COALESCE(trim(new.dnupla::text), '')) <> 4 THEN
RAISE EXCEPTION USING MESSAGE = 'La section doit être codée sur 2 caractères (mettre un "0" devant la lettre si besoin, ex : 0B) et la parcelle sur 4 caractères. Vérifiez votre saisie et recommencer.';
END IF;

IF (right(NEW.ccosec,1) = '0' OR NEW.ccosec = '00') THEN
RAISE EXCEPTION USING MESSAGE = 'Une section ne peut pas être composée d''une lettre suivie d''un 0, n''y être composée d''un double 0. Corrigez votre saisie et validez.';
END IF;

IF length(NEW.ccosec) = 2 AND
left(NEW.ccosec,1) NOT IN ('0','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') THEN
RAISE EXCEPTION USING MESSAGE = 'Une section doit être codée sur 2 caractères et en majusucle. Si la section est codée sur 1 caractère, ajouter un "0" devant la lettre (ex : 0B).';
END IF;

IF length(NEW.ccosec) = 2 AND
right(NEW.ccosec,1) NOT IN ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') THEN
RAISE EXCEPTION USING MESSAGE = 'Une section doit être codée sur 2 caractères et en majusucle. Si la section est codée sur 1 caractère, ajouter un "0" devant la lettre (ex : 0B).';
END IF;


NEW.ccosec := upper(NEW.ccosec);

return new;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_verif_ref_cad() IS 'Fonction trigger vérifiant la saisie des références cadastrales';

-- ################################################################# FUNCTION ft_m_etat_reg ###############################################
-- DROP FUNCTION m_erp.ft_m_etat_reg();

CREATE OR REPLACE FUNCTION m_erp.ft_m_etat_reg()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

--RAISE EXCEPTION 'Id : -->%',new.idproc;

IF TG_OP ='INSERT' OR TG_OP = 'UPDATE' THEN
--RAISE EXCEPTION 'Table source : -->%',TG_TABLE_NAME;
	
	-- si la demande provient de la classe procédure 
	IF  TG_TABLE_NAME = 'an_erp_procedure' /*OR  TG_TABLE_NAME = 'an_erp_objet'*/  THEN
	
		-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_objet disable trigger t_t6_etat_reg;
		alter table m_erp.an_erp_evenement disable trigger t_t4_etat_reg;

		--si l'état de la réglementation est automatique
		IF (SELECT etat_manu FROM m_erp.an_erp_objet WHERE idobjet = NEW.idobjet) is false THEN
			-- si aucune procédure enregistrée à l'ERP, etat_reg = Non renseigné
			--RAISE EXCEPTION 'passe 1';
			--RAISE EXCEPTION 'Table source : -->%',TG_TABLE_NAME;
			IF EXISTS (SELECT DISTINCT 1 FROM m_erp.an_erp_procedure p where p.idobjet = new.idobjet) THEN
					-- si il existe une procédure (je prends la dernière), et si aucun évènement j'indique un état réglementaire à En création (10)
					IF (SELECT
							count(*)
						from m_erp.an_erp_evenement e 
						WHERE e.idproc = (
								 			select 
												p.idproc
											from
												m_erp.an_erp_procedure p where idobjet = NEW.idobjet
											order by p.ddepot desc
											limit 1)
						) = 0
					THEN
						-- je mets à jour l'état réglementaire à 10 (En création)					
						UPDATE m_erp.an_erp_objet SET etat_reg = '10' WHERE idobjet = NEW.idobjet;
					ELSE
						
						-- si il y a des évènements, j'applique la grille d'analyse pour formater l'état réglementaire
						with
						req_eve as
						(
						select 
							e.ideve, p.idproc, p.idobjet, e.typ, e.decision
						from
							m_erp.an_erp_evenement e
						join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = 
							(
							select 
								p.idproc
							from
								m_erp.an_erp_procedure p where idobjet = NEW.idobjet
							order by p.ddepot desc, p.idproc DESC
							limit 1
							)
							order by e.deve desc
							limit 1
						)
						UPDATE m_erp.an_erp_objet SET etat_reg =
						-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
						CASE 
							WHEN req_eve.typ IN ('10') THEN '10'
							WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
							WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('30') THEN '11'
							WHEN req_eve.typ IN ('20','31','35') and req_eve.decision IN ('20','ZZ') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
							WHEN req_eve.typ IN ('31') THEN '40'
							WHEN req_eve.typ IN ('32') THEN '11'
							WHEN req_eve.typ IN ('33') THEN '40'
							WHEN req_eve.typ IN ('34') THEN '20'
							WHEN req_eve.typ IN ('35') THEN '30'
							WHEN req_eve.typ IN ('40') THEN '10'
							WHEN req_eve.typ IN ('60') THEN '10'
							WHEN req_eve.typ IN ('61') THEN '10'
							WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('64') and req_eve.decision in ('10','11') THEN '10'
							WHEN req_eve.typ IN ('64') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
							WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('67') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('67') and req_eve.decision = '20' THEN '22'
							ELSE '00' END
 							FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
					END IF;				
				
			ELSE
				-- je mets non renseigné en état réglementaire si aucune procédure
				UPDATE m_erp.an_erp_objet SET etat_reg = '00' WHERE idobjet = NEW.idobjet; 
			END IF;

		-- résactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_objet enable trigger t_t6_etat_reg;
		alter table m_erp.an_erp_evenement enable trigger t_t4_etat_reg;

		END IF;
	END IF;

	-- si la demande provient de la classe objet 
	IF  TG_TABLE_NAME = 'an_erp_objet'  THEN

		-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_procedure disable trigger t_t3_etat_reg;
		alter table m_erp.an_erp_evenement disable trigger t_t4_etat_reg;


		--si l'état de la réglementation est automatique
		IF (SELECT etat_manu FROM m_erp.an_erp_objet WHERE idobjet = NEW.idobjet) is false THEN
			-- si aucune procédure enregistrée à l'ERP, etat_reg = Non renseigné
			--RAISE EXCEPTION 'passe 1';
			--RAISE EXCEPTION 'Table source : -->%',TG_TABLE_NAME;
			IF EXISTS (SELECT DISTINCT 1 FROM m_erp.an_erp_procedure p where p.idobjet = new.idobjet) THEN
					-- si il existe une procédure (je prends la dernière), et si aucun évènement j'indique un état réglementaire à En création (10)
					IF (SELECT
							count(*)
						from m_erp.an_erp_evenement e 
						WHERE e.idproc = (
								 			select 
												p.idproc
											from
												m_erp.an_erp_procedure p where idobjet = NEW.idobjet
											order by p.ddepot desc
											limit 1)
						) = 0
					THEN
						-- je mets à jour l'état réglementaire à 10 (En création)					
						UPDATE m_erp.an_erp_objet SET etat_reg = '10' WHERE idobjet = NEW.idobjet;
					ELSE
						
						-- si il y a des évènements, j'applique la grille d'analyse pour formater l'état réglementaire
						with
						req_eve as
						(
						select 
							e.ideve, p.idproc, p.idobjet, e.typ, e.decision
						from
							m_erp.an_erp_evenement e
						join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = 
							(
							select 
								p.idproc
							from
								m_erp.an_erp_procedure p where idobjet = NEW.idobjet
							order by p.ddepot desc, p.idproc DESC
							limit 1
							)
							order by e.deve desc
							limit 1
						)
						UPDATE m_erp.an_erp_objet SET etat_reg =
						-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
						CASE 
							WHEN req_eve.typ IN ('10') THEN '10'
							WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
							WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('30') THEN '11'
							WHEN req_eve.typ IN ('20','31','35') and req_eve.decision IN ('20','ZZ') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
							WHEN req_eve.typ IN ('31') THEN '40'
							WHEN req_eve.typ IN ('32') THEN '11'
							WHEN req_eve.typ IN ('33') THEN '40'
							WHEN req_eve.typ IN ('34') THEN '20'
							WHEN req_eve.typ IN ('35') THEN '30'
							WHEN req_eve.typ IN ('40') THEN '10'
							WHEN req_eve.typ IN ('60') THEN '10'
							WHEN req_eve.typ IN ('61') THEN '10'
							WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('64') and req_eve.decision in ('10','11') THEN '10'
							WHEN req_eve.typ IN ('64') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'							
							WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('67') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('67') and req_eve.decision = '20' THEN '22'
							ELSE '00' END
 							FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
					END IF;				
				
			ELSE
				-- je mets non renseigné en état réglementaire si aucune procédure
				UPDATE m_erp.an_erp_objet SET etat_reg = '00' WHERE idobjet = NEW.idobjet; 
			END IF;

		-- résactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_procedure enable trigger t_t3_etat_reg;
		alter table m_erp.an_erp_evenement enable trigger t_t4_etat_reg;

		END IF;


	END IF;

	-- si la demande provient de la classe évènement 
	 IF TG_TABLE_NAME = 'an_erp_evenement' THEN

	-- mise à jour de l'attribut aggrégeant les évènements associés
	-- ici test pour remplacer le champ calculé dans geo par un attribut fixe, mais ne change pas le rafrachissement de l'affichage
	/*
		UPDATE m_erp.an_erp_procedure p
		SET leve = (
    		SELECT 
	    		string_agg('<tr><td>' || te.valeur || '</td><td>' || to_char(e.deve,'dd-MM-YYYY') || '</td><td>' || 
				CASE 
					WHEN e.decision = '10' then '<img src="https://geo.compiegnois.fr/documents/metiers/erp/erp_favorable.png" alt="" width=100%></img>'
					WHEN e.decision = '11' then '<img src="https://geo.compiegnois.fr/documents/metiers/erp/erp_fav_presc.png" alt="" width=100%></img>'
					WHEN e.decision = '20' then '<img src="https://geo.compiegnois.fr/documents/metiers/erp/erp_defavorable.png" alt="" width=100%></img>'
				ELSE '' END
				|| '</td></tr>','<br>' ORDER BY e.deve DESC) 
			 
    		FROM m_erp.an_erp_evenement e
    			left JOIN m_erp.lt_erp_eve te ON te.code = e.typ
    		WHERE e.idproc = p.idproc
		)
		WHERE p.idproc = NEW.idproc;	
		*/
		-- si l'état de la réglementation est automatique
		IF (SELECT o.etat_manu FROM m_erp.an_erp_objet o join m_erp.an_erp_procedure p on o.idobjet = p.idobjet WHERE p.idproc = NEW.idproc) is false THEN
				-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
				alter table m_erp.an_erp_objet disable trigger t_t6_etat_reg;
				alter table m_erp.an_erp_procedure disable trigger t_t3_etat_reg;
				with
						req_eve as
						(
						select 
							e.ideve, p.idproc, p.idobjet, e.typ, e.decision
						from
							m_erp.an_erp_evenement e
						join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = 
							(
							select 
								p.idproc
							from
								m_erp.an_erp_procedure p where idproc = NEW.idproc
							order by p.ddepot desc, p.idproc DESC
							limit 1
							)
							order by e.deve desc
							limit 1
						)
						UPDATE m_erp.an_erp_objet SET etat_reg =
						-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
						CASE 
							WHEN req_eve.typ IN ('10') THEN '10'
							WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
							WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('30') THEN '11'
							WHEN req_eve.typ IN ('20','31','35') and req_eve.decision IN ('20','ZZ') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
							WHEN req_eve.typ IN ('31') THEN '40'
							WHEN req_eve.typ IN ('32') THEN '11'
							WHEN req_eve.typ IN ('33') THEN '40'
							WHEN req_eve.typ IN ('34') THEN '20'
							WHEN req_eve.typ IN ('35') THEN '30'
							WHEN req_eve.typ IN ('40') THEN '10'
							WHEN req_eve.typ IN ('60') THEN '10'
							WHEN req_eve.typ IN ('61') THEN '10'
							WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('64') and req_eve.decision in ('10','11') THEN '10'
							WHEN req_eve.typ IN ('64') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
							WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('67') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('67') and req_eve.decision = '20' THEN '22'
							ELSE '00' END
 							FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
						-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
						alter table m_erp.an_erp_objet enable trigger t_t6_etat_reg;
						alter table m_erp.an_erp_procedure enable trigger t_t3_etat_reg;
		END IF;
	 END IF;

END IF;
	
-- si je supprime une procédure
IF TG_OP = 'DELETE' AND TG_TABLE_NAME = 'an_erp_procedure' THEN

		
		-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_objet disable trigger t_t6_etat_reg;
		alter table m_erp.an_erp_evenement disable trigger t_t4_etat_reg;



		--si l'état de la réglementation est automatique
		IF (SELECT etat_manu FROM m_erp.an_erp_objet WHERE idobjet = OLD.idobjet) is false THEN
			-- si aucune procédure enregistrée à l'ERP, etat_reg = Non renseigné
			--RAISE EXCEPTION 'passe 1';
			--RAISE EXCEPTION 'Table source : -->%',TG_TABLE_NAME;
			IF EXISTS (SELECT DISTINCT 1 FROM m_erp.an_erp_procedure p where p.idobjet = OLD.idobjet) THEN
					-- si il existe une procédure (je prends la dernière), et si aucun évènement j'indique un état réglementaire à En création (10)
					IF (SELECT
							count(*)
						from m_erp.an_erp_evenement e 
						WHERE e.idproc = (
								 			select 
												p.idproc
											from
												m_erp.an_erp_procedure p where idobjet = OLD.idobjet
											order by p.ddepot desc
											limit 1)
						) = 0
					THEN
						RAISE EXCEPTION 'delete 1';
						-- je mets à jour l'état réglementaire à 10 (En création)					
						UPDATE m_erp.an_erp_objet SET etat_reg = '10' WHERE idobjet = OLD.idobjet;
					ELSE
						--RAISE EXCEPTION 'delete 2';
						-- si il y a des évènements, j'applique la grille d'analyse pour formater l'état réglementaire
						with
						req_eve as
						(
						select 
							e.ideve, p.idproc, p.idobjet, e.typ, e.decision
						from
							m_erp.an_erp_evenement e
						join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = 
							(
							select 
								p.idproc
							from
								m_erp.an_erp_procedure p where idobjet = OLD.idobjet
							order by p.ddepot desc, p.idproc DESC
							limit 1
							)
							order by e.deve desc
							limit 1
						)
						UPDATE m_erp.an_erp_objet SET etat_reg =
						-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
						CASE 
							WHEN req_eve.typ IN ('10') THEN '10'
							WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
							WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('30') THEN '11'
							WHEN req_eve.typ IN ('20','31','35') and req_eve.decision IN ('20','ZZ') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
							WHEN req_eve.typ IN ('31') THEN '40'
							WHEN req_eve.typ IN ('32') THEN '11'
							WHEN req_eve.typ IN ('33') THEN '40'
							WHEN req_eve.typ IN ('34') THEN '20'
							WHEN req_eve.typ IN ('35') THEN '30'
							WHEN req_eve.typ IN ('40') THEN '10'
							WHEN req_eve.typ IN ('60') THEN '10'
							WHEN req_eve.typ IN ('61') THEN '10'
							WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('64') and req_eve.decision in ('10','11') THEN '10'
							WHEN req_eve.typ IN ('64') and req_eve.decision = '20' THEN '10'
							WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
							WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '22'
							WHEN req_eve.typ IN ('67') and req_eve.decision in ('10','11') THEN '20'
							WHEN req_eve.typ IN ('67') and req_eve.decision = '20' THEN '22'
							ELSE '00' END
 							FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 

					END IF;				
				
			ELSE
				--RAISE EXCEPTION 'objet -->%',old.idobjet;
				-- je mets non renseigné en état réglementaire si aucune procédure
				UPDATE m_erp.an_erp_objet SET etat_reg = '00' where idobjet = OLD.idobjet; 
			END IF;
		END IF;

		-- désactiviation des triggers sur les tables qui seront appelés du fait de l'update induit
		alter table m_erp.an_erp_objet enable trigger t_t6_etat_reg;
		alter table m_erp.an_erp_evenement enable trigger t_t4_etat_reg;


END IF;


return new;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_etat_reg() IS 'Fonction trigger mettant à jour l''attribut etat_reg (état réglementaire) dans la table an_erp_objet';




-- ################################################################# FUNCTION old_ft_m_etat_reg ###############################################

/*

CREATE OR REPLACE FUNCTION m_erp.ft_m_etat_reg()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

--raise exception 'après delete1';
-- si la demande vient d'une procédure
IF TG_TABLE_NAME = 'an_erp_procedure' THEN
--raise EXCEPTION 'ok10';
--raise exception 'veleur idobjet -->%',new.idobjet;
-- si la gestion des états réglementaires est automatique passe sinon rien
	IF EXISTS (SELECT distinct 1 FROM m_erp.an_erp_procedure p join m_erp.an_erp_objet o on p.idobjet = o.idobjet 
			where p.idobjet = new.idobjet and o.etat_manu is false)
		   THEN

	--raise exception 'ok0';
	-- je test si il y a au moins une procédure sinon etat_reg = '00'
		IF EXISTS (SELECT 1 FROM m_erp.an_erp_procedure p where p.idobjet = new.idobjet) THEN
		-- si il y a une procédure, je regarde la dernière
		--RAISE EXCEPTION 'after delete 1';
			IF EXISTS (SELECT 1 from m_erp.an_erp_evenement e WHERE e.idproc = (
										select 
											p.idproc
										from
											m_erp.an_erp_procedure p where idobjet = new.idobjet
										order by p.ddepot desc
										limit 1
																		)) THEN
			-- je conditonne etat_reg en fonction de l'évèment inséré, donc je fais rien ici car l'état sera généré depuis l'appel de la tabe évènement
			--RAISE EXCEPTION 'ok1';
			null;
			-- si pas d'évènements liés à la procédure, etat_reg = '10' en création car ici j'ai intéser une procédure
			ELSE
			--RAISE EXCEPTION 'after delete 3';
				-- si visite périodique ou inopinée pas de changement de l'état, se fera par l'évènement
				--raise exception 'valeur proc -->%',new.typ;
				--raise exception 'une visite 0';
				IF new.typ <> '30' and new.typ <> '31' then
					UPDATE m_erp.an_erp_objet SET etat_reg = '10' WHERE idobjet = NEW.idobjet;
				-- si visites, et si évènement lié, j'applique l'état automatique
				ELSE
					raise exception 'une visite 1';
					IF EXISTS (SELECT 1 from m_erp.an_erp_evenement e WHERE e.idproc = (
										select 
											p.idproc
										from
											m_erp.an_erp_procedure p where idobjet = new.idobjet
										order by p.ddepot desc
										limit 1
																		)) THEN
					--raise exception 'une visite avec eve';
					
					with
					req_eve as
					(
					select 
						e.ideve, p.idobjet, e.typ, e.decision
					from
						m_erp.an_erp_evenement e
					join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = new.idproc
					order by e.deve desc
					limit 1
					)
					UPDATE m_erp.an_erp_objet SET etat_reg =
					-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
					CASE 
						WHEN req_eve.typ IN ('10') THEN '10'
						WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
						WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
						WHEN req_eve.typ IN ('30') THEN '11'
						-- ici prévoir si AT refusé et etat_reel ouvert alors etat_reg = '21'
						WHEN req_eve.typ IN ('20','31','35') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
						WHEN req_eve.typ IN ('31') THEN '10'
						WHEN req_eve.typ IN ('32') THEN '11'
						WHEN req_eve.typ IN ('33') THEN '10'
						WHEN req_eve.typ IN ('34') THEN '20'
						WHEN req_eve.typ IN ('35') THEN '30'
						WHEN req_eve.typ IN ('40') THEN '10'
						WHEN req_eve.typ IN ('50') THEN '10'
						WHEN req_eve.typ IN ('51') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('51') and req_eve.decision = '20' THEN '11'
						WHEN req_eve.typ IN ('52') THEN '10'
						WHEN req_eve.typ IN ('60') THEN '10'
						WHEN req_eve.typ IN ('61') THEN '10'
						WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '30'
						WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '30'
						WHEN req_eve.typ IN ('64') THEN '10'
						WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
						WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '10'
						WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '10'
						ELSE '00' END
 						FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
								END IF;
				END IF;
			--RAISE EXCEPTION 'ok2';
	
		END IF;	

	ELSE
		--RAISE EXCEPTION 'after delete 2';
		UPDATE m_erp.an_erp_objet SET etat_reg = '00' WHERE idobjet = CASE WHEN TG_OP = 'DELETE' THEN OLD.idobjet ELSE NEW.idobjet END;
	END IF;



END IF;


	-- si je supprime une procédure
	IF TG_OP = 'DELETE' THEN
		-- si la gestion des états réglementaires est automatique passe sinon rien
		IF EXISTS (SELECT distinct 1 FROM m_erp.an_erp_procedure p join m_erp.an_erp_objet o on p.idobjet = o.idobjet 
			where p.idobjet = old.idobjet and o.etat_manu is false)
		   THEN
				--raise exception 'idobjet --> %',old.idobjet;
				-- attention, ici je vais rechercher l'avant dernier enregisrment des procédures, car à la suppression va charcher dand celui supprimé
				IF EXISTS (SELECT 1 from m_erp.an_erp_evenement e WHERE e.idproc = (
										select 
											p.idproc
										from
											m_erp.an_erp_procedure p where idobjet = old.idobjet
										order by p.ddepot desc, p.idproc desc
										limit 1 offset 1
																		)) THEN
					--raise exception 'une visite avec eve';
					--raise exception 'idobjet --> %',old.idobjet;
					with
					req_eve as
					(
					select 
						e.ideve, p.idobjet, e.typ, e.decision
					from
						m_erp.an_erp_evenement e
					join m_erp.an_erp_procedure p on e.idproc = p.idproc where p.idobjet = old.idobjet
					order by e.deve desc
					limit 1
					)
					UPDATE m_erp.an_erp_objet SET etat_reg =
					-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
					CASE 
						WHEN req_eve.typ IN ('10') THEN '10'
						WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
						WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
						WHEN req_eve.typ IN ('30') THEN '11'
						-- ici prévoir si AT refusé et etat_reel ouvert alors etat_reg = '21'
						WHEN req_eve.typ IN ('20','31','35') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
						WHEN req_eve.typ IN ('31') THEN '10'
						WHEN req_eve.typ IN ('32') THEN '11'
						WHEN req_eve.typ IN ('33') THEN '10'
						WHEN req_eve.typ IN ('34') THEN '20'
						WHEN req_eve.typ IN ('35') THEN '30'
						WHEN req_eve.typ IN ('40') THEN '10'
						WHEN req_eve.typ IN ('50') THEN '10'
						WHEN req_eve.typ IN ('51') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('51') and req_eve.decision = '20' THEN '11'
						WHEN req_eve.typ IN ('52') THEN '10'
						WHEN req_eve.typ IN ('60') THEN '10'
						WHEN req_eve.typ IN ('61') THEN '10'
						WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '30'
						WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '30'
						WHEN req_eve.typ IN ('64') THEN '10'
						WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
						WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
						WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '10'
						WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '10'
						ELSE '00' END
 						FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
				END IF;
		END IF;
	END IF;


END IF;

-- si la demande vient d'un évènement
IF TG_TABLE_NAME = 'an_erp_evenement' THEN
--raise exception 'ok11';
-- si la gestion des états réglementaires est automatique passe sinon rien
	IF EXISTS (SELECT distinct 1 FROM m_erp.an_erp_evenement e 
								join m_erp.an_erp_procedure p ON e.idproc = p.idproc 
								join m_erp.an_erp_objet o on p.idobjet = o.idobjet 
							where p.idproc = new.idproc and o.etat_manu is false)
	THEN

	--RAISE EXCEPTION 'ok3';
	--RAISE EXCEPTION 'valeur -->%',new.idproc;
		with
			req_eve as
			(
			select 
				e.ideve, p.idobjet, e.typ, e.decision
			from
				m_erp.an_erp_evenement e
			join m_erp.an_erp_procedure p on e.idproc = p.idproc where e.idproc = new.idproc
			order by e.deve desc
			limit 1
			)
	UPDATE m_erp.an_erp_objet SET etat_reg =
	-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
		CASE 
			WHEN req_eve.typ IN ('10') THEN '10'
			WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
			WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
			WHEN req_eve.typ IN ('30') THEN '11'
			-- ici prévoir si AT refusé et etat_reel ouvert alors etat_reg = '21'
			WHEN req_eve.typ IN ('20','31','35') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
			WHEN req_eve.typ IN ('31') THEN '10'
			WHEN req_eve.typ IN ('32') THEN '11'
			WHEN req_eve.typ IN ('33') THEN '10'
			WHEN req_eve.typ IN ('34') THEN '20'
			WHEN req_eve.typ IN ('35') THEN '30'
			WHEN req_eve.typ IN ('40') THEN '10'
			WHEN req_eve.typ IN ('50') THEN '10'
			WHEN req_eve.typ IN ('51') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('51') and req_eve.decision = '20' THEN '11'
			WHEN req_eve.typ IN ('52') THEN '10'
			WHEN req_eve.typ IN ('60') THEN '10'
			WHEN req_eve.typ IN ('61') THEN '10'
			WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '30'
			WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '30'
			WHEN req_eve.typ IN ('64') THEN '10'
			WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
			WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '10'
			WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '10'
			ELSE '00' END
 	FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
		--RAISE EXCEPTION 'ok3';
	END IF;
	
END IF;

IF TG_TABLE_NAME = 'an_erp_objet' THEN
	-- si il existe au moins un évènement
	-- si l'état est automatique (etat_manu is false)

	IF new.etat_manu is false THEN
		IF EXISTS (SELECT distinct 1 FROM m_erp.an_erp_evenement e 
								join m_erp.an_erp_procedure p ON e.idproc = p.idproc 
								join m_erp.an_erp_objet o on p.idobjet = o.idobjet 
							where p.idobjet = new.idobjet and o.etat_manu is false)
		THEN

		--RAISE EXCEPTION 'ok1';
		--RAISE EXCEPTION 'valeur -->%',new.idproc;
			with
				req_eve as
				(
				select 
					e.ideve, p.idobjet, e.typ, e.decision
				from
					m_erp.an_erp_evenement e
				join m_erp.an_erp_procedure p on e.idproc = p.idproc where p.idobjet = new.idobjet
				order by e.deve desc
				limit 1
				)
		UPDATE m_erp.an_erp_objet SET etat_reg =
		-- en fonction du type d'évènement (à corrigert pour intégrer les décisions)
		CASE 
			WHEN req_eve.typ IN ('10') THEN '10'
			WHEN req_eve.typ IN ('20') and req_eve.decision IN ('10','11') THEN '11'
			WHEN req_eve.typ IN ('20') and req_eve.decision = '20' THEN '10'
			WHEN req_eve.typ IN ('30') THEN '11'
			-- ici prévoir si AT refusé et etat_reel ouvert alors etat_reg = '21'
			WHEN req_eve.typ IN ('20','31','35') and (select etat from m_erp.an_erp_objet where idobjet = req_eve.idobjet) = '20' THEN '21'
			WHEN req_eve.typ IN ('31') THEN '10'
			WHEN req_eve.typ IN ('32') THEN '11'
			WHEN req_eve.typ IN ('33') THEN '10'
			WHEN req_eve.typ IN ('34') THEN '20'
			WHEN req_eve.typ IN ('35') THEN '30'
			WHEN req_eve.typ IN ('40') THEN '10'
			WHEN req_eve.typ IN ('50') THEN '10'
			WHEN req_eve.typ IN ('51') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('51') and req_eve.decision = '20' THEN '11'
			WHEN req_eve.typ IN ('52') THEN '10'
			WHEN req_eve.typ IN ('60') THEN '10'
			WHEN req_eve.typ IN ('61') THEN '10'
			WHEN req_eve.typ IN ('62') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('62') and req_eve.decision = '20' THEN '30'
			WHEN req_eve.typ IN ('63') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('63') and req_eve.decision = '20' THEN '30'
			WHEN req_eve.typ IN ('64') THEN '10'
			WHEN req_eve.typ IN ('65') and req_eve.decision in ('10','11') THEN '20'
			WHEN req_eve.typ IN ('65') and req_eve.decision = '20' THEN '11'
			WHEN req_eve.typ IN ('66') and req_eve.decision in ('10','11') THEN '10'
			WHEN req_eve.typ IN ('66') and req_eve.decision = '20' THEN '10'
			ELSE '00' END
 		FROM req_eve WHERE an_erp_objet.idobjet = req_eve.idobjet; 
		ELSE
			UPDATE m_erp.an_erp_objet SET etat_reg = '00' WHERE an_erp_objet.idobjet = new.idobjet; 
		END IF;
	END IF;	
END IF;


return new;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_etat_reg() IS 'Fonction trigger mettant à jour l''attribut etat_reg (état réglementaire) dans la table an_erp_objet';

*/

-- ################################################################# FUNCTION ft_m_controle_eve ###############################################

-- DROP FUNCTION m_erp.ft_m_controle_eve();

CREATE OR REPLACE FUNCTION m_erp.ft_m_controle_eve()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

-- si les types d"évènements indiqués ne sont pas concernés par un avis favorable, ..., on l'indique
IF NEW.typ IN ('30','31','32','33','34','35','40') AND NEW.decision <> 'ZZ' THEN
	RAISE EXCEPTION '<font color="#FF0000"><b>La décision de ce type d''évènements ne requiert pas de décision, indiquer "Non concerné".</font></b><br><br>';
END IF;

-- si les types d"évènements oblige une décision et que celle-ci est à non concerné, on l'indique
IF NEW.typ IN ('10','20','50','51','52','60','61','62','63','64','65','66') AND NEW.decision = 'ZZ' THEN
	RAISE EXCEPTION '<font color="#FF0000"><b>La décision de ce type d''évènements requiert une décision différente de "Non concerné".</font></b><br><br>';
END IF;

-- la décision doit-être à non concerné pour les évènements de type Arrêté (enregistrement par défaut de ZZ quand ce type est sélectionné (dans GEO, la liste déroulante ne s'affiche pas si la sélection d'un arrêté)
IF NEW.typ IN ('30','31','32','33','34','35') THEN
NEW.decision := 'ZZ';
END IF;


-- contrôle sur les dates, voir si ontrôle sur l'ordre des évènements par rapport à leur type ?

-- contrôle sur les évènements insérés par rapport à la procédure renseignées
IF TG_OP = 'INSERT' OR  TG_OP = 'UPDATE' THEN
	--raise exception 'valeur -->%',(select typ from m_erp.an_erp_procedure where idproc = new.idproc);
	--raise exception 'valeur -->%',new.typ;
	-- si autorisation de travaux
	IF (select typ from m_erp.an_erp_procedure where idproc = new.idproc) = '10' and new.typ IN ('10','32','33','62','63') then 
		raise exception  '<font color="#FF0000"><b>Vous avez renseigné un évènement non compatible avec la procédure.</b></font><br><br>';
	END IF;

	-- si PC Valant ERP
	IF (select typ from m_erp.an_erp_procedure where idproc = new.idproc) = '20' and new.typ IN ('20','30','31','62','63') then 
		raise exception  '<font color="#FF0000"><b>Vous avez renseigné un évènement non compatible avec la procédure.</b></font><br><br>';
	END IF;
	-- si Visite périodique
	IF (select typ from m_erp.an_erp_procedure where idproc = new.idproc) = '30' and new.typ IN ('10','20','30','31','32','33','34','40','60','61','63','64','67') then 
		raise exception  '<font color="#FF0000"><b>Vous avez renseigné un évènement non compatible avec la procédure.</b></font><br><br>';
	END IF;
	-- si Visite inopinée
	IF (select typ from m_erp.an_erp_procedure where idproc = new.idproc) = '31' and new.typ IN ('10','20','30','31','32','33','34','40','60','61','62','64','67') then 
		raise exception  '<font color="#FF0000"><b>Vous avez renseigné un évènement non compatible avec la procédure.</b></font><br><br>';
	END IF;
		
/*
	RAISE EXCEPTION 'idobjet -->%',(select typ from m_erp.an_erp_procedure where idproc = new.idproc);
	RAISE EXCEPTION 'eve -->%',new.idproc || '-' || new.typ;
	*/
END IF; 

return new;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_controle_eve() IS 'Fonction trigger contrôlant la saisie des évènements';



-- ################################################################# FUNCTION ft_m_delete_eve ###############################################

-- DROP FUNCTION m_erp.ft_m_delete_eve();

CREATE OR REPLACE FUNCTION m_erp.ft_m_delete_eve()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN
	
	DELETE FROM m_erp.an_erp_evenement_media WHERE ideve = OLD.ideve;

return old;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_delete_eve() IS 'Fonction trigger supprimant les médias quand un évènement est supprimé';


-- ################################################################# FUNCTION ft_m_delete_proc ###############################################

-- DROP FUNCTION m_erp.ft_m_delete_proc();

CREATE OR REPLACE FUNCTION m_erp.ft_m_delete_proc()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN
	
	DELETE FROM m_erp.an_erp_procedure_media WHERE idproc = OLD.idproc;
	DELETE FROM m_erp.an_erp_evenement WHERE idproc = OLD.idproc;
	DELETE FROM m_erp.an_erp_evenement_media WHERE ideve IN (SELECT ideve FROM m_erp.an_erp_evenement WHERE idproc = OLD.idproc) ;
	
return old;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_delete_proc() IS 'Fonction trigger supprimant les médias et les évènements liés à la suppression d''une procédure';



-- ################################################################# FUNCTION ft_m_controle_media_adoc ###############################################

-- DROP FUNCTION m_erp.ft_m_controle_eve();

CREATE OR REPLACE FUNCTION m_erp.ft_m_controle_media_adoc()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

-- je contrôle si la saisie de la précision du document joint est renseigné lorsue le type de doc est à "autre"
IF NEW.doctype = '99' AND LENGTH(TRIM(COALESCE(NEW.adoc, ''))) BETWEEN 0 and 3 THEN

	RAISE EXCEPTION '<font color="#FF0000"><b>Vous devez préciser le type de document lorsque vous indiquez "Autre document"</b></font><br><br>';

END IF ;

return new;

END;
$function$
;

COMMENT ON FUNCTION m_erp.ft_m_controle_media_adoc() IS 'Fonction trigger contrôlant si le document joint est précisé si type de doc = autre';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     TRIGGER                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################  

-- ################################################################# SUR TABLE an_erp_objet ###############################################

-- Trigger: t_t1_dbinsert

-- DROP TRIGGER IF EXISTS t_t1_dbinsert ON m_erp.an_erp_objet;

CREATE TRIGGER t_t1_dbinsert
    BEFORE INSERT
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbinsert();

-- Trigger: t_t2_dbupdate

-- DROP TRIGGER IF EXISTS t_t2_dbupdate ON m_erp.an_erp_objet;

CREATE TRIGGER t_t2_dbupdate
    BEFORE UPDATE
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbupdate();

-- Trigger: t_t3_gestion_ctrl

-- DROP TRIGGER IF EXISTS t_t3_gestion_ctrl ON m_erp.an_erp_objet;

CREATE TRIGGER t_t3_gestion_ctrl
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_gestion_ctrl();

-- Trigger: t_t4_delete_histo

-- DROP TRIGGER IF EXISTS t_t4_delete_histo ON m_erp.an_erp_objet;

CREATE TRIGGER t_t4_delete_histo
    AFTER insert or UPDATE OR delete
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_delete_histo();


-- Trigger: t_t5_resp_unique

-- DROP TRIGGER IF EXISTS t_t5_refresh ON m_erp.an_erp_objet;

CREATE TRIGGER t_t5_resp_unique
    AFTER INSERT
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_resp_unique();

-- Trigger: t_t6_refresh

-- DROP TRIGGER IF EXISTS t_t6_refresh ON m_erp.an_erp_objet;

CREATE TRIGGER t_t7_refresh
    AFTER INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_refresh();

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_objet;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();


-- Trigger: t_t6_etat_reg

-- DROP TRIGGER IF EXISTS t_t6_etat_reg ON m_erp.an_erp_objet;

CREATE TRIGGER t_t6_etat_reg
    BEFORE update
    of etat
    ON m_erp.an_erp_objet
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_etat_reg();

-- ################################################################# SUR TABLE an_erp_objet_h ###############################################

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_objet_h;
create trigger t_t9_log before
insert
    or
delete
    or
update
    on
    m_erp.an_erp_objet_h for each row execute function m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE geo_erp_userpoint ###############################################

-- Trigger: t_t1_gestion_ctrl

-- DROP TRIGGER IF EXISTS t_t1_gestion_ctrl ON m_erp.geo_erp_userpoint;

CREATE TRIGGER t_t1_gestion_ctrl
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.geo_erp_userpoint
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_temp_gestion_ctrl();

-- Trigger: t_t3_xy_l93

-- DROP TRIGGER IF EXISTS t_t3_xy_l93 ON m_erp.geo_erp_userpoint;

create trigger t_t3_xy_l93 before
insert
    or
update
    of geom on
    m_erp.geo_erp_userpoint for each row execute procedure ft_r_xy_l93();

-- Trigger: t_t5_geo_voirie_statio_pmr_insee

-- DROP TRIGGER IF EXISTS t_t5_geo_voirie_statio_pmr_insee ON m_erp.geo_erp_userpoint;

create trigger t_t4_insee_commune before
insert
    or
update
    of geom on
    m_erp.geo_erp_userpoint for each row execute procedure ft_r_commune_pl();

-- Trigger: t_t5_refresh

-- DROP TRIGGER IF EXISTS t_t5_refresh ON m_erp.geo_erp_userpoint;

CREATE TRIGGER t_t5_refresh
    AFTER INSERT OR UPDATE OR DELETE
    ON m_erp.geo_erp_userpoint
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_temp_refresh();


-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.geo_erp_userpoint;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.geo_erp_userpoint
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE an_erp_cad ###############################################

-- Table Triggers

create trigger t_t1_dbinsert before
insert
    on
    m_erp.an_erp_cad for each row execute procedure ft_r_timestamp_dbinsert();

create trigger t_t2_dbupdate before
UPDATE
    on
    m_erp.an_erp_cad for each row execute procedure ft_r_timestamp_dbupdate();


create trigger t_t3_controle before
insert
    or
update
    on
    m_erp.an_erp_cad for each row execute procedure m_erp.ft_m_verif_ref_cad();


-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_cad;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_cad
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();


-- ################################################################# SUR TABLE an_erp_objet_media ###############################################

-- Table Triggers

create trigger t_t1_dbinsert before
insert
    on
    m_erp.an_erp_objet_media for each row execute procedure ft_r_timestamp_dbinsert();


-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_objet_media;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_objet_media
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

create trigger t_t2_controle_adoc before
insert
    on
    m_erp.an_erp_objet_media for each row execute function m_erp.ft_m_controle_media_adoc();

-- ################################################################# SUR TABLE an_erp_orga ###############################################


-- Trigger: t_t1_dbinsert
-- DROP TRIGGER IF EXISTS t_t1_dbinsert ON m_erp.an_erp_orga;

CREATE TRIGGER t_t1_dbinsert
    BEFORE INSERT
    ON m_erp.an_erp_orga
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbinsert();


-- Trigger: t_t2_dbupdate
-- DROP TRIGGER IF EXISTS t_t2_dbupdate ON m_erp.an_erp_orga;

CREATE TRIGGER t_t2_dbupdate
    BEFORE UPDATE 
    ON m_erp.an_erp_orga
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbupdate();

-- Trigger: t_t3_gestion_ctrl
-- DROP TRIGGER IF EXISTS t_t3_gestion_ctrl ON m_erp.an_erp_orga;

CREATE TRIGGER t_t3_gestion_ctrl
    before DELETE
    ON m_erp.an_erp_orga
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_gestion_orga();

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_orga;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_orga
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE an_erp_contact ###############################################


-- Trigger: t_t1_dbinsert
-- DROP TRIGGER IF EXISTS t_t1_dbinsert ON m_erp.an_erp_contact;

CREATE TRIGGER t_t1_dbinsert
    BEFORE INSERT
    ON m_erp.an_erp_contact
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbinsert();


-- Trigger: t_t2_dbupdate
-- DROP TRIGGER IF EXISTS t_t2_dbupdate ON m_erp.an_erp_contact;

CREATE TRIGGER t_t2_dbupdate
    BEFORE UPDATE 
    ON m_erp.an_erp_contact
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbupdate();



-- Trigger: t_t3_gestion_ctrl
-- DROP TRIGGER t_t3_controle_saisie_contact ON m_erp.an_erp_contact;

CREATE TRIGGER t_t3_gestion_ctrl
    BEFORE INSERT OR UPDATE or DELETE
    ON m_erp.an_erp_contact
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_controle_erp_saisie_contact();



-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_contact;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.an_erp_contact
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE geo_erp_userpoint_h ###############################################

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.geo_erp_userpoint_h;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.geo_erp_userpoint_h
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();



-- ################################################################# SUR TABLE lk_an_erp_objet_histo ###############################################

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.lk_an_erp_objet_histo;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.lk_an_erp_objet_histo
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE lk_erp_contact ###############################################

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.lk_erp_contact;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.lk_erp_contact
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE lk_erp_orga ###############################################

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.lk_erp_orga;

CREATE TRIGGER t_t9_log
    BEFORE INSERT OR UPDATE OR DELETE
    ON m_erp.lk_erp_orga
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE an_erp_procedure_media ###############################################

-- Table Triggers

create trigger t_t9_log before
insert
    or
delete
    or
update
    on
    m_erp.an_erp_procedure_media for each row execute function m_erp.ft_m_erp_log();

create trigger t_t1_dbinsert before
insert
    on
    m_erp.an_erp_procedure_media for each row execute function ft_r_timestamp_dbinsert();

create trigger t_t2_controle_adoc before
insert
    on
    m_erp.an_erp_procedure_media for each row execute function m_erp.ft_m_controle_media_adoc();


-- ################################################################# SUR TABLE an_erp_evenement_media ###############################################

-- Table Triggers

create trigger t_t9_log before
insert
    or
delete
    or
update
    on
    m_erp.an_erp_evenement_media for each row execute function m_erp.ft_m_erp_log();

create trigger t_t1_dbinsert before
insert
    on
    m_erp.an_erp_evenement_media for each row execute function ft_r_timestamp_dbinsert();

create trigger t_t2_controle_adoc before
insert
    on
    m_erp.an_erp_evenement_media for each row execute function m_erp.ft_m_controle_media_adoc();

-- ################################################################# SUR TABLE an_erp_procedure ###############################################

-- Trigger: t_t1_dbinsert

-- DROP TRIGGER IF EXISTS t_t1_dbinsert ON m_erp.an_erp_procedure;

CREATE TRIGGER t_t1_dbinsert
    BEFORE INSERT
    ON m_erp.an_erp_procedure
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbinsert();

-- Trigger: t_t2_dbupdate

-- DROP TRIGGER IF EXISTS t_t2_dbupdate ON m_erp.an_erp_procedure;

CREATE TRIGGER t_t2_dbupdate
    BEFORE UPDATE
    ON m_erp.an_erp_procedure
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbupdate();

-- Trigger: t_t3_etat_reg

-- DROP TRIGGER IF EXISTS t_t3_etat_reg ON m_erp.an_erp_procedure;

CREATE TRIGGER t_t3_etat_reg
    AFTER INSERT OR update or DELETE
    ON m_erp.an_erp_procedure
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_delete_eve();

-- Trigger: t_t4_delete

-- DROP TRIGGER IF EXISTS t_t4_delete ON m_erp.an_erp_procedure;

CREATE TRIGGER t_t4_delete
    BEFORE DELETE
    ON m_erp.an_erp_procedure
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_delete_proc();

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_procedure;


create trigger t_t9_log before
insert
    or
delete
    or
update
    on
    m_erp.an_erp_procedure for each row execute function m_erp.ft_m_erp_log();

-- ################################################################# SUR TABLE an_erp_evenement ###############################################

-- Trigger: t_t1_dbinsert

-- DROP TRIGGER IF EXISTS t_t1_dbinsert ON m_erp.an_erp_evenement;

CREATE TRIGGER t_t1_dbinsert
    BEFORE INSERT
    ON m_erp.an_erp_evenement
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbinsert();

-- Trigger: t_t2_dbupdate

-- DROP TRIGGER IF EXISTS t_t2_dbupdate ON m_erp.an_erp_evenement;

CREATE TRIGGER t_t2_dbupdate
    BEFORE UPDATE
    ON m_erp.an_erp_evenement
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_dbupdate();


-- Trigger: t_t3_controle

-- DROP TRIGGER IF EXISTS t_t3_controle ON m_erp.an_erp_evenement;

CREATE TRIGGER t_t3_controle
    BEFORE INSERT OR UPDATE
    ON m_erp.an_erp_evenement
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_controle_eve();

-- Trigger: t_t4_etat_reg

-- DROP TRIGGER IF EXISTS t_t4_etat_reg ON m_erp.an_erp_evenement;

CREATE TRIGGER t_t4_etat_reg
    AFTER INSERT OR update or DELETE
    ON m_erp.an_erp_evenement
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_etat_reg();

-- Trigger: t_t5_delete

-- DROP TRIGGER IF EXISTS t_t5_delete ON m_erp.an_erp_evenement;

CREATE TRIGGER t_t5_delete
    BEFORE DELETE
    ON m_erp.an_erp_evenement
    FOR EACH ROW
    EXECUTE PROCEDURE m_erp.ft_m_delete_eve();

-- Trigger: t_t9_log

-- DROP TRIGGER IF EXISTS t_t9_log ON m_erp.an_erp_evenement;

create trigger t_t9_log before
insert
    or
delete
    or
update
    on
    m_erp.an_erp_evenement for each row execute function m_erp.ft_m_erp_log();
