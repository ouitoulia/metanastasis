SELECT
  file.fid AS 'mid'
  , file.uid AS 'uid'
  , 'image' AS 'bundle'
  , REVERSE(SUBSTRING_INDEX(REVERSE(file.filename), '.', -1)) AS 'name' -- togliere estensione
  , file.filename AS 'filename'
  , file.fid AS 'field_media_image_target_id'
  , REVERSE(SUBSTRING_INDEX(REVERSE(file.filename), '.', -1)) AS 'field_media_image_alt' -- togliere estensione
  , NULL AS 'field_icona'
  , NULL AS 'field_trascrizione'
  , 'it' AS 'langcode'
  , file.status AS 'status'
  , file.uri AS 'uri'
  , REPLACE(file.uri, 'public://', 'https://icmarvasivizzone.edu.it/sites/default/files/') AS 'url'
  , file.timestamp AS 'created'
  , file.uuid AS 'uuid'
FROM file_managed file
WHERE
  file.uri LIKE 'public://articolo/immagine%' -- nid < 2057 field_image
  OR file.uri LIKE 'public://articolo/immagini%' -- nid > 2057 field_image
  OR file.uri LIKE 'public://blog/immagine%' -- field_image
  -- OR  file.uri LIKE 'public://book/immgagine%' -- field_image
  OR file.uri LIKE 'public://materiali-didattici/immagine%' -- field_image
  OR file.uri = 'public://pagina/immagine/ciberbullismo-image-sample.png' -- field_image node/2428
  OR file.uri = 'public://pagina/immagine/istituto_comprensivo_marvasi_vizzone_logo_e_marchio_orizzontale.png' -- field_image node 3190
ORDER BY file.fid ASC
;
