
/*Creation du fichier complet*/
/* init_db_erp_v6_GB_phase_2.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ 
 Auteurs : Grégory Bodet (appui sur les versions de Florent Vanhoutte et Alice Loubaresse (stagiaire 2023-2024) */

/*
#################################################################### SUIVI CODE SQL ####################################################################

2026-07-20 : GB / Intégration des élélents de la phase 2 sur la gestion des évènements
2026-07-20 : GB / Adaptation du modèle phase 1 prémice de la phase 2
2026-02-02 : GB / intégration de la gestion des contacts et organisme
2026-01-23 : GB / reprise du code pour répondre à une intégration par phase

            Phase 1 : 
                - localisation des ERP à l'adresse
                - Intégration de la partie descriptive avec une liste des process par catégorie + média lié à un ERP
                - Intégration la possibilité de forcer l'état de l'ERP dans l'attente d'évènement (si évènement déduit) = ERP en création, ERP existant, ERP fermé
                - Intégration de l'historisaiton des ERP pour assurer la filiation (question de l'historisation des contacts)
                - Intégration de la gestion des contacts
                - Intégration de la gestion d'une corbeille
                - Intégration d'un export d'une liste des ERP (au d�but liste sans aucune information, le temps de constituer l'inventaire), avec l'état et ensuite intégrer la procédure en cours, le dernier état du contrôle, ...
                date de décision administrative, ...
            Phase 2 :
                - Intégration des évènements (liste des types d'évènements et des infos associées)
                - Intégration du fonctionnel automatique en rapport avec la liste des process par catégorie pour gérer si l'ERP respecte les règles
                - Intégration du fonctionnel automatique pour afficher les informations de synthèse (cf service)
                
            Phase 3 : 
                - en attente
