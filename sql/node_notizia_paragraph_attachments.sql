SELECT
  CONCAT('article_',allegati.entity_id,'--attachments_',allegati.entity_id) AS 'migration_id'
  , JSON_ARRAYAGG(
      JSON_OBJECT(
        'migration_target_id', CONCAT('file_',allegati.field_allegati_fid),
        'description', IFNULL(TRIM(allegati.field_allegati_description), ''),
        'langcode', CASE
                      WHEN allegati.language IS NULL OR allegati.language = 'und' THEN 'it'
                      ELSE allegati.language
                    END
      )
    ORDER BY allegati.delta
  ) AS 'field_file'
  , 'Allegati' AS 'field_title'
  , CASE
      WHEN node.language IS NULL OR node.language = 'und' THEN 'it'
      ELSE node.language
    END AS 'langcode'
  , node.status AS 'status'
  , node.created AS 'created'
FROM field_data_field_allegati allegati
  LEFT JOIN node node ON allegati.entity_id = node.nid
WHERE allegati.bundle IN ('article','blog')
GROUP BY allegati.entity_id, allegati.language, node.created
ORDER BY allegati.entity_id ASC;
