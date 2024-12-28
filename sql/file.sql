SELECT
  file.fid AS 'fid' -- si mantiene invariato
  , file.uuid AS 'uuid' -- solo come migration_id
  , 'it' AS 'langcode'
  , file.uid AS 'uid'
  , file.filename AS 'filename'
  , file.uri AS 'uri'
  , file.filemime AS 'filemime'
  , file.filesize AS 'filesize'
  , file.status AS 'status'
  , file.timestamp AS 'created'
  , file.timestamp AS 'changed'
FROM file_managed file
WHERE
  -- ESCLUSIONI
  -- - I seguenti vengono importati tramite media_image
  file.uri NOT LIKE 'public://articolo/immagine%' -- nid < 2057 field_image ==> public://articolo/immagine -> public://media/immagine
  AND file.uri NOT LIKE 'public://articolo/immagini%' -- nid > 2057 field_image ==> public://articolo/immagini -> public://media/immagine
  AND file.uri NOT LIKE 'public://blog/immagine%' -- field_image ==> public://blog/immagine -> public://media/immagine
  AND file.uri NOT LIKE 'public://book/immgagine%' -- field_image ==> public://book/immagine -> public://media/immagine
  AND file.uri NOT LIKE 'public://materiali-didattici/immagine%' -- field_image ==> public://materiali-didattici/immagine -> public://media/immagine
  AND file.uri NOT LIKE 'public://pagina/immagine%' -- field_image ==> public://pagina/immagine -> public://media/immagine
  -- - Gli avatar vengono scaricati durante la migrazione delle persone
  AND file.uri NOT LIKE 'private://user/avatar/picture-%' -- picture ==> private://user/avatar -> public://persona/ritratto
  -- - I seguenti non verranno migrati
  AND file.uri NOT LIKE 'private://Blocchi%' -- escludo i file dei blocchi
  AND file.uri NOT LIKE 'public://curriculum%' -- escludo dati sensibili
  AND file.uri NOT LIKE 'public://default_images%' -- escludo i placeholder dei nodi
  AND file.uri NOT LIKE 'private://feeds%' -- escludo i file di importazione vecchi e con dati sensibili
  AND file.uri NOT LIKE 'private://focal_point%' -- escludo i samples
  AND file.uri NOT LIKE 'private://istanze_online%' -- escludo dati sensibili
  AND file.uri NOT LIKE 'private://rubrica-valorizzazione%' -- escludo dati sensibili
  AND file.uri NOT LIKE 'public://slideshow%' -- escludo cartella che non verrà migrata
  AND file.uri NOT LIKE 'public://user%' -- escludo vecchia cartella public user
  AND file.uri NOT LIKE 'private://webform%' -- escludo dati sensibili
  -- - Allegati alle pagine non necessari
  AND file.fid NOT IN (1125,1126,1127,1128) -- allegati /node/17
  AND file.fid NOT IN (204,206,205) -- allegati e image /node/156
  AND file.fid NOT IN (9429,9563,2569,2570,2571,2575,2572,2573,2574,2576,9428) -- allegati e image /node/458
  -- - Il ct book non viene migrato (guide obsolete)
  AND file.uri NOT LIKE 'public://book%'
  AND file.uri NOT LIKE 'private://book%'
  AND file.uri NOT LIKE 'private://pagine-e-tassonomia%'
  AND file.uri NOT LIKE 'private://articoli/acc%'
  AND file.uri NOT LIKE 'private://articoli/apps%'
  AND file.uri NOT LIKE 'private://articoli/google%'
  AND file.uri NOT LIKE 'private://articoli/login%'
  AND file.uri NOT LIKE 'private://lim_%'
  AND file.uri NOT LIKE 'private://logo_classe_viva.png'
ORDER BY file.fid ASC
;
