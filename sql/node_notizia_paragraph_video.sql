SELECT
  CONCAT('article_',video.entity_id,'--video_',video.entity_id) AS 'migration_id'
  , 'remote_video' AS 'bundle'
  , TRIM(node.title) AS 'title'
  , node.uid AS 'uid'
  , video.field_video_input AS 'field_video_url'
  , CASE
      WHEN node.language IS NULL OR node.language = 'und' THEN 'it'
      ELSE node.language
    END AS 'langcode'
  , node.status AS 'status'
  , node.created AS 'created'
FROM field_data_field_video video
       LEFT JOIN node node ON video.entity_id = node.nid
WHERE video.bundle IN ('article','blog')
GROUP BY video.entity_id, video.language, node.created
ORDER BY video.entity_id ASC;
