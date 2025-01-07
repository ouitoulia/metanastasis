SELECT
  CONCAT('circolare_',node.nid) AS 'migration_id'
  , node.uid AS 'uid' -- id giusto
  , node.`uuid`
  , 'circolare' AS 'type'
  , TRIM(node.title) AS 'title'
  , NULL AS 'field_numero_circolare'
-- field_anno_scolastico
  , CASE
      WHEN FROM_UNIXTIME(node.created, '%m%d') >= '0901'
        THEN CONCAT(
          FROM_UNIXTIME(node.created, '%Y'),
          '_',
          FROM_UNIXTIME(node.created, '%Y') + 1
        )
        ELSE CONCAT(
          FROM_UNIXTIME(node.created, '%Y') - 1,
          '_',
          FROM_UNIXTIME(node.created, '%Y')
        )
    END AS 'field_anno_scolastico' -- viene ricavato dal created
  , TRIM(body.body_value) AS 'field_abstract' -- pulire dai tag durante la migrazione
  , CONCAT(
      IFNULL(
        GROUP_CONCAT(DISTINCT tags.field_tags_tid ORDER BY tags.delta SEPARATOR ';'),
        '1423;'
      ),
      GROUP_CONCAT(DISTINCT at.field_categoria_albo_tid ORDER BY at.field_categoria_albo_tid SEPARATOR ';')
    ) AS 'field_argomenti'
  , GROUP_CONCAT(DISTINCT area.field_area_tid ORDER BY area.field_area_tid SEPARATOR ';') AS 'field_destinatari'
  , NULL AS 'field_data_oblio'
  , JSON_ARRAYAGG(
      DISTINCT JSON_OBJECT(
        'migration_target_id', CONCAT('file_',allegati.field_allegati_fid),
        'description', IFNULL(
                        NULLIF(TRIM(allegati.field_allegati_description), ''),
                        REPLACE(REPLACE(file.filename, '_', ' '), '.pdf', '')
                       ),
        'langcode', CASE
                      WHEN allegati.language IS NULL OR allegati.language = 'und' THEN 'it'
                      ELSE allegati.language
                    END
      )
      ORDER BY allegati.delta
    ) AS 'field_allegati'
  , NULL AS 'field_link'
  , NULL AS 'field_eventi'
  , TRIM(body.body_value) AS 'body_value'
  , NULL AS 'field_persona_responsabile'
  -- ALTRI DATI ----------------------------------------------------------------------------------------------------------------------------------------
  , TRIM(protocollo.field_protocollo_value) AS 'field_protocollo'
  , TRIM(cig.field_cig_value) AS 'field_cig'
  , TRIM(cup.field_cup_value) AS 'field_cup'
  , data.field_data_scadenza_value AS 'field_data_scadenza'
  -- FINE ALTRI DATI -----------------------------------------------------------------------------------------------------------------------------------
  , 'it' AS 'langcode'
  , node.promote AS 'promote'
  , node.sticky AS 'sticky'
  , node.status AS 'status'
  , node.created AS 'created'
  , node.changed AS 'changed'
FROM node
  LEFT JOIN field_data_body body ON node.nid = body.entity_id AND body.bundle IN ('albo_pretorio', 'documenti')
  LEFT JOIN field_data_field_area area ON node.nid = area.entity_id AND area.bundle IN ('albo_pretorio', 'documenti') AND area.field_area_tid IN (30,27,29,28) -- recupera i destinatari
  LEFT JOIN field_data_field_allegati allegati ON node.nid = allegati.entity_id AND allegati.bundle IN ('albo_pretorio', 'documenti') -- recupera gli allegati
  LEFT JOIN file_managed file ON allegati.field_allegati_fid = file.fid
  -- le due seguenti recuperano l'area e i tag che verranno messi nello stesso campo
  -- LEFT JOIN field_data_field_area area_tag ON node.nid = area.entity_id AND area_tag.bundle IN ('albo_pretorio', 'documenti') AND area_tag.field_area_tid NOT IN (30,27,29,28)
  LEFT JOIN field_data_field_tags tags ON node.nid = tags.entity_id AND tags.bundle IN ('albo_pretorio', 'documenti')
  -- LEFT JOIN taxonomy_term_data term ON tags.field_tags_tid = term.tid OR area_tag.field_area_tid = term.tid
  -- Recupero altri dati
  LEFT JOIN field_data_field_protocollo protocollo ON node.nid = protocollo.entity_id AND protocollo.bundle IN ('albo_pretorio', 'documenti')
  LEFT JOIN field_data_field_cig cig ON node.nid = cig.entity_id AND cig.bundle IN ('albo_pretorio', 'documenti')
  LEFT JOIN field_data_field_cup cup ON node.nid = cup.entity_id AND cup.bundle IN ('albo_pretorio', 'documenti')
  LEFT JOIN field_data_field_data_scadenza data ON node.nid = data.entity_id AND data.bundle IN ('albo_pretorio', 'documenti')
  LEFT JOIN field_data_field_categoria_albo at ON node.nid = at.entity_id AND at.bundle IN ('albo_pretorio', 'documenti')
WHERE
  (node.type = 'albo_pretorio' OR node.type = 'documenti')
  AND node.title LIKE '%circolare%'
GROUP BY
  node.nid, node.uid, node.uuid, node.title, body.body_value,
  protocollo.field_protocollo_value, cig.field_cig_value, cup.field_cup_value,
  data.field_data_scadenza_value,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.nid ASC
;
