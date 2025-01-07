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
     , COALESCE(tind.created, UNIX_TIMESTAMP(NOW())) AS 'created'
     , COALESCE(tind.created, UNIX_TIMESTAMP(NOW())) AS 'changed'
FROM taxonomy_term_data term
   LEFT JOIN taxonomy_term_hierarchy parent ON term.tid = parent.tid
   LEFT JOIN (
    SELECT tid, MIN(created) AS created
    FROM taxonomy_index
    GROUP BY tid
  ) tind ON term.tid = tind.tid
WHERE
  term.tid IN (
     357, 358, 359, -- nel body c'è un'immagine da migrare da private://
     360, 361, 362, 364, 365, 366,
     374, 376, 377, 378, 379,
     406, 408, 409, 410, 415, 418,
     420, 421, 422, 423, 424, 425, 426, 427, 428, 429,
     430, 431, 432, 433, 434, 435, 436, 437, 438, 439,
     440, 441, 442, 443, 444, 445, 446, 447, 448,
     450
  )
ORDER BY term.weight ASC
;
