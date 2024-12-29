SELECT
  CONCAT('documento_',node.nid) AS 'migration_id'
  , node.uid AS 'uid' -- id giusto
  , node.`uuid`
  , 'documento' AS 'type'
  , TRIM(node.title) AS 'title'
  , body.body_value AS 'field_abstract' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT area.field_area_tid ORDER BY area.field_area_tid SEPARATOR ';') AS 'field_argomenti'
  , body.body_value AS 'body_value' -- pulire dai tag durante la migrazione
  , NULL AS 'field_tipologia_documento'
  , NULL AS 'field_copertina'
  , NULL AS 'field_galleria_immagini'
  , NULL AS 'field_persone'
  -- DA ATTENZIONARE BENE ------------------------------------------------------------------------------------------------------------------------------
  , GROUP_CONCAT(DISTINCT allegati.field_allegati_fid ORDER BY allegati.delta SEPARATOR ';') AS 'field_allegati_tid' -- gli allegati vanno importati mantenendo gli id
  , GROUP_CONCAT(DISTINCT file.uri ORDER BY file.uid SEPARATOR ';') AS 'field_allegati_uri' -- copia da "/albopretorio/..." a "/circolare/allegati/..."
  , 'Descrizione' AS  'field_allegati_desc' -- fai migrazione ad oc per recuperare la description sul campo field_data_field_allegati
  -- FINE DA ATTENZIONARE BENE -------------------------------------------------------------------------------------------------------------------------
  , NULL AS 'field_link'
  , protocollo.field_protocollo_value AS 'field_protocollo'
  , NULL AS 'field_data_inizio'
  , cig.field_cig_value AS 'field_cig'
  , data.field_data_scadenza_value AS 'field_data_fine'
  , cup.field_cup_value AS 'field_cup'
  , NULL AS 'field_codice_identificativo'
  , NULL AS 'field_data_oblio'
  , NULL AS 'field_servizio'
  , NULL AS 'field_eventi'
  , NULL AS 'field_progetti'
  , NULL AS 'field_percorso_di_studio'
  , NULL AS 'field_notizie'
  , NULL AS 'field_classi'
  , NULL AS 'field_finanziamenti'
  , NULL AS 'field_frequenza'
  , NULL AS 'field_struttura_responsabile'
  , GROUP_CONCAT(DISTINCT at.field_categoria_albo_tid ORDER BY at.field_categoria_albo_tid SEPARATOR ';') AS 'amministrazione_trasparente'
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
  ( node.type = 'albo_pretorio' OR node.type = 'documenti')
  AND node.title NOT LIKE '%circolare%'
GROUP BY
  node.nid, node.uid, node.uuid, node.title, body.body_value,
  protocollo.field_protocollo_value, cig.field_cig_value, cup.field_cup_value,
  data.field_data_scadenza_value,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.nid ASC
;
