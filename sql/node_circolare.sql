SELECT
  CONCAT('circolare_',node.nid) AS 'migration_id'
  , node.uid AS 'uid' -- id giusto
  , node.`uuid`
  , 'circolare' AS 'type'
  , node.title AS 'title'
  , NULL AS 'field_numero_circolare'
  , NULL AS 'field_anno_scolastico' -- si potrebbe ricavare dal created
  , body.body_value AS 'field_abstract' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT area.field_area_tid ORDER BY area.field_area_tid SEPARATOR ';') AS 'field_destinatari'
  , NULL AS 'field_data_oblio'
  -- DA ATTENZIONARE BENE ------------------------------------------------------------------------------------------------------------------------------
  , GROUP_CONCAT(DISTINCT allegati.field_allegati_fid ORDER BY allegati.delta SEPARATOR ';') AS 'field_allegati_tid' -- gli allegati vanno importati mantenendo gli id
  , GROUP_CONCAT(DISTINCT file.uri ORDER BY file.uid SEPARATOR ';') AS 'field_allegati_uri' -- copia da "/albopretorio/..." a "/circolare/allegati/..."
  , 'Descrizione' AS  'field_allegati_desc' -- fai migrazione ad oc per recuperare la description sul campo field_data_field_allegati
  -- FINE DA ATTENZIONARE BENE -------------------------------------------------------------------------------------------------------------------------
  , NULL AS 'field_link'
  , NULL AS 'field_eventi'
  , body.body_value AS 'body_value'
  , NULL AS 'field_persona_responsabile'
  -- ALTRI DATI ----------------------------------------------------------------------------------------------------------------------------------------
  , protocollo.field_protocollo_value AS 'field_protocollo'
  , cig.field_cig_value AS 'field_cig'
  , cup.field_cup_value AS 'field_cup'
  , data.field_data_scadenza_value AS 'field_data_scadenza'
  , GROUP_CONCAT(DISTINCT at.field_categoria_albo_tid ORDER BY at.field_categoria_albo_tid SEPARATOR ';') AS 'amministrazione_trasparente'
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
