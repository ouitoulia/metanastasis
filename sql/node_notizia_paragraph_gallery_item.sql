SELECT
  CONCAT('article_',galleria.entity_id,'--gallery-item_',galleria.field_galleria_fid) AS 'migration_id'
  , CASE
      WHEN galleria.language IS NULL OR galleria.language = 'und' THEN 'it'
      ELSE galleria.language
    END AS 'langcode'
  , CONCAT('file_',galleria.field_galleria_fid) AS 'migration_target_id'
  , CASE
      WHEN galleria.field_galleria_alt IS NULL OR galleria.field_galleria_alt = '' THEN TRIM(galleria.field_galleria_title)
      ELSE TRIM(galleria.field_galleria_alt)
  END AS 'alt'
  , TRIM(galleria.field_galleria_title) AS 'title'
  , galleria.field_galleria_width AS 'width'
  , galleria.field_galleria_height AS 'height'
  , node.created AS 'created'
FROM field_data_field_galleria galleria
  LEFT JOIN node node ON galleria.entity_id = node.nid
WHERE galleria.bundle IN ('article', 'blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530)
ORDER BY galleria.entity_id
;
