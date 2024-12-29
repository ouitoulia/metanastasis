SELECT
  CONCAT('finanziamento_',term.tid) AS 'migration_id'
  , term.uuid AS 'uuid'
  , 1 AS 'uid'
  , 'finanziamento' AS 'type'
  , TRIM(term.name) AS 'title'
  , parent.parent AS 'field_tipologia_finanziamento' -- id vecchio
  , TRIM(term.description) AS 'field_abstract'
  , '69' AS 'field_argomenti' -- id vecchio
  , NULL AS 'field_codice_cup'
  , NULL AS 'field_codice_identificativo'
  , NULL AS 'field_importo_finanziamento'
  , NULL AS 'field_stato_progetto'
  , NULL AS 'field_copertina'
  , TRIM(term.description) AS 'body_value'
  , NULL AS 'field_link'
  , NULL AS 'field_data_inizio'
  , NULL AS 'field_data_fine'
  , NULL AS 'field_struttura_responsabile'
  , NULL AS 'field_persona_responsabile'
  , NULL AS 'field_persone'
  , NULL AS 'field_persone_esterne'
  , NULL AS 'field_collaborazioni'
  , 'it' AS 'langcode'
  , 0 AS 'promote'
  , 0 AS 'sticky'
  , 1 AS 'status'
FROM taxonomy_term_data term
  LEFT JOIN taxonomy_term_hierarchy parent ON term.tid = parent.tid
WHERE
  term.vid = 6
  AND (
    term.tid = 379
    OR term.tid = 378
    OR term.tid = 376
    OR term.tid = 408
    OR term.tid = 409
    OR term.tid = 418
    OR term.tid = 377
    OR term.tid = 415
    OR term.tid = 362
    OR term.tid = 365
    OR term.tid = 361
    OR term.tid = 358
    OR term.tid = 357
    OR term.tid = 366
    OR term.tid = 406
    OR term.tid = 360
    OR term.tid = 364
    OR term.tid = 410
    OR term.tid = 359 -- nel body c'è un'immagine da migrare da private://
  )
ORDER BY term.weight ASC
;
