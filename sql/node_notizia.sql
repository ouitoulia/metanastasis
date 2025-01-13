SELECT
  CONCAT('article_',node.nid) AS 'migration_id'
  , node.`uuid`
  , node.uid AS 'uid' -- id giusto
  , 'article' AS 'type'
  , TRIM(node.title) AS 'title'
  , CASE
      WHEN term.tid = 40 THEN 653
      WHEN node.type = 'blog' OR node.type = 'materiali_didattici' THEN 651
      ELSE 652
    END AS 'field_tipologia_notizia' -- id giusto
  , body.body_value AS 'field_abstract' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT term.tid ORDER BY term.weight SEPARATOR ';') AS 'field_argomenti'
  , image.field_image_fid AS 'field_copertina_media_id' -- id media per collegare la copertina
  , body.body_value AS 'body_value' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT insegnante.field_insegnante_target_id ORDER BY insegnante.delta SEPARATOR ';') AS 'field_persone' -- id sono giusti
  , NULL AS 'field_persona_responsabile'
  , CASE
      WHEN galleria.field_galleria_fid IS NOT NULL AND allegati.field_allegati_fid IS NOT NULL AND video.field_video_input IS NOT NULL
        THEN CONCAT(
          CONCAT('article_', node.nid, '--gallery_', node.nid),
          ';',
          CONCAT('article_', node.nid, '--attachments_', node.nid),
          ';',
          CONCAT('article_', node.nid, '--video_', node.nid)
        )
      WHEN galleria.field_galleria_fid IS NOT NULL AND allegati.field_allegati_fid IS NOT NULL
        THEN CONCAT(
          CONCAT('article_', node.nid, '--gallery_', node.nid),
          ';',
          CONCAT('article_', node.nid, '--attachments_', node.nid)
        )
      WHEN galleria.field_galleria_fid IS NOT NULL AND video.field_video_input IS NOT NULL
        THEN CONCAT(
          CONCAT('article_', node.nid, '--gallery_', node.nid),
          ';',
          CONCAT('article_', node.nid, '--video_', node.nid)
        )
      WHEN allegati.field_allegati_fid IS NOT NULL AND video.field_video_input IS NOT NULL
        THEN CONCAT(
          CONCAT('article_', node.nid, '--attachments_', node.nid),
          ';',
          CONCAT('article_', node.nid, '--video_', node.nid)
        )
      WHEN galleria.field_galleria_fid IS NOT NULL
        THEN CONCAT('article_', node.nid, '--gallery_', node.nid)
      WHEN allegati.field_allegati_fid IS NOT NULL
        THEN CONCAT('article_', node.nid, '--attachments_', node.nid)
      WHEN video.field_video_input IS NOT NULL
        THEN CONCAT('article_', node.nid, '--video_', node.nid)
      ELSE NULL
    END AS 'field_extra_info'
  , GROUP_CONCAT(DISTINCT CONCAT('luogo_',plesso.field_plesso_public_tid) ORDER BY plesso.field_plesso_public_tid SEPARATOR ';') AS 'field_luoghi'
  , NULL AS 'field_eventi'
  , 'it' AS 'langcode'
  , node.promote AS 'promote'
  , node.sticky AS 'sticky'
  , node.status AS 'status'
  , node.created AS 'created'
  , node.changed AS 'changed'
FROM node
  LEFT JOIN field_data_body body ON node.nid = body.entity_id AND ( body.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_insegnante insegnante ON node.nid = insegnante.entity_id AND ( body.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_image image ON node.nid = image.entity_id AND ( image.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_video video ON node.nid = video.entity_id AND ( video.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_galleria galleria ON node.nid = galleria.entity_id AND ( galleria.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_allegati allegati ON node.nid = allegati.entity_id AND ( allegati.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_plesso_public plesso ON node.nid = plesso.entity_id AND ( plesso.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  -- le seguenti recuperano l'area, i tag, l'eventuale materia e ordine scolastico che verranno messi nello stesso campo
  LEFT JOIN field_data_field_area area ON node.nid = area.entity_id AND ( area.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_tags tags ON node.nid = tags.entity_id AND ( tags.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_materie_public materie ON node.nid = materie.entity_id AND ( materie.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN field_data_field_ordine_scolastico ordine ON node.nid = ordine.entity_id AND ( ordine.bundle IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530) )
  LEFT JOIN taxonomy_term_data term ON area.field_area_tid = term.tid OR tags.field_tags_tid = term.tid OR materie.field_materie_public_tid = term.tid
WHERE node.type IN ('article','blog') OR node.nid IN (387,392,434,435,547,569,582,683,808,822,825,885,1207,1208,1530)
GROUP BY
  node.nid, node.uid, node.uuid, node.title, body.body_value,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.nid ASC
;
