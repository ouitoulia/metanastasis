SELECT
  CONCAT('page_',node.nid) AS 'migration_id'
  , node.`uuid`
  , node.uid AS 'uid'
  , 'page' AS 'type'
  , TRIM(node.title) AS 'title'
  , image.field_image_fid as 'field_copertina_media_id' -- id riferimento a media per la copertina
  , body.body_value AS 'body_value'
  , video.field_video_input AS 'field_paragraph_video' -- nessun contenuto per questo tipo
  , GROUP_CONCAT(DISTINCT galleria.field_galleria_fid ORDER BY galleria.delta SEPARATOR ';') AS 'field_paragraph_gallery' -- non c'è nessuna galleria da importare per questo tipo
  , GROUP_CONCAT(DISTINCT allegati.field_allegati_fid ORDER BY allegati.delta SEPARATOR ';') AS 'field_paragraph_allegati_id' -- valutare lo spostamento di cartella; devono finire in paragraph?
  , 'it' AS 'langcode'
  , node.promote AS 'promote'
  , node.sticky AS 'sticky'
  , node.status AS 'status'
  , node.created AS 'created'
  , node.changed AS 'changed'
FROM node
  LEFT JOIN field_data_field_image image ON node.nid = image.entity_id AND image.bundle = 'page'
  LEFT JOIN field_data_body body ON node.nid = body.entity_id AND body.bundle = 'page'
  LEFT JOIN field_data_field_galleria galleria ON node.nid = galleria.entity_id AND galleria.bundle = 'page'
  LEFT JOIN field_data_field_allegati allegati ON node.nid = allegati.entity_id AND allegati.bundle = 'page'
  LEFT JOIN field_data_field_video video ON node.nid = video.entity_id AND video.bundle = 'page'
WHERE
  node.type = 'page'
  AND node.nid NOT IN (10,17,24,31,32,33,58,156,271,272,273,274,458) -- decidere se escludere anche 21,22,23
GROUP BY
  node.nid, node.uuid, node.uid, node.title,
  image.field_image_fid, body.body_value,
  video.field_video_input,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.nid ASC
;
