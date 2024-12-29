SELECT
  CONCAT('struttura_',term.tid) AS 'migration_id'
  , term.uuid AS 'uuid'
  , 1 AS 'uid'
  , 'struttura_organizzativa' AS 'type'
  , TRIM(term.name) AS 'title'
  , CASE WHEN term.tid IN (57,36,407,261) THEN 1307 ELSE 1306 END AS 'field_tipologia_struttura' -- id nuovo
  , NULL AS 'field_copertina'
  , TRIM(term.description) AS 'field_abstract'
  , 1401 AS 'field_argomenti' -- id nuovo
  , NULL AS 'body_value'
  , codice_m.field_codice_meccanografico_value AS 'field_codice_meccanografico'
  , NULL AS 'field_struttura_organizzativa'
  , NULL AS 'field_persona_responsabile'
  , GROUP_CONCAT(DISTINCT plesso.entity_id ORDER BY plesso.delta SEPARATOR ';') AS 'field_persone' -- id giusti così (uguali al vecchio)
  , NULL AS 'field_persone_esterne'
  , CASE WHEN term.vid = 4 THEN CONCAT('luogo_',term.tid) END AS 'field_luoghi_gestiti' -- Sì c'è scritto luogo ed è giusto così
  , CASE WHEN term.vid = 4 THEN CONCAT('luogo_',term.tid) END AS 'field_luoghi' -- Sì c'è scritto luogo ed è giusto così
  , NULL AS 'field_telefono'
  , NULL AS 'field_email'
  , 'it' AS 'langcode'
  , 0 AS 'promote'
  , 0 AS 'sticky'
  , 1 AS 'status'
  , 1413404636 AS 'created'
FROM taxonomy_term_data term
  LEFT JOIN field_data_field_codice_meccanografico codice_m ON term.tid = codice_m.entity_id AND codice_m.bundle = 'plesso'
  LEFT JOIN field_data_field_plesso_public plesso ON term.tid = plesso.field_plesso_public_tid AND plesso.bundle = 'user'
WHERE
  term.vid = 4 -- sono le strutture di tipo scuola/istituto 1306
  OR term.tid IN (57,36,407,261) -- strutture tipo organo collegiale 1307
GROUP BY
  term.tid, term.uuid, term.name, term.description, term.weight,
  codice_m.field_codice_meccanografico_value
ORDER BY term.weight ASC
;
