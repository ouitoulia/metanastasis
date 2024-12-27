SELECT
  CONCAT('article_',galleria.entity_id,'--gallery_',galleria.entity_id) AS 'migration_id'
  , 0 AS 'field_overlay'
  , 'double' AS 'field_gallery_grid_type'
  , GROUP_CONCAT(
      DISTINCT CONCAT('article_',galleria.entity_id,'--gallery-item_',galleria.field_galleria_fid)
      ORDER BY galleria.delta
      SEPARATOR ';'
    ) AS 'field_gallery_item'
  , 1 AS 'field_show_caption'
  , CASE
      WHEN galleria.language IS NULL OR galleria.language = 'und' THEN 'it'
      ELSE galleria.language
  END AS 'langcode'
  , node.created AS 'created'
FROM field_data_field_galleria galleria
  LEFT JOIN node node ON galleria.entity_id = node.nid
WHERE galleria.bundle IN ('article', 'blog')
GROUP BY galleria.entity_id, node.created, galleria.language
ORDER BY galleria.entity_id
;
