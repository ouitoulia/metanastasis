SELECT
  CONCAT('scheda_didattica_',node.nid) AS 'migration_id'
  , node.`uuid`
  , node.uid AS 'uid' -- id giusto
  , 'scheda_didattica' AS 'type'
  , TRIM(node.title) AS 'title'
  , body.body_value AS 'field_abstract' -- pulire dai tag durante la migrazione
  , body.body_value AS 'body_value' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT term.tid ORDER BY term.weight SEPARATOR ';') AS 'field_argomenti'
  , 'it' AS 'langcode'
  , node.promote AS 'promote'
  , node.sticky AS 'sticky'
  , node.status AS 'status'
  , node.created AS 'created'
  , node.changed AS 'changed'
  FROM node node
    -- Recupero i tag
    LEFT JOIN field_data_body body ON node.nid = body.entity_id AND node.nid IN (372,574)
    LEFT JOIN field_data_field_materie_public materie ON node.nid = materie.entity_id AND node.nid IN (372,574)
    LEFT JOIN field_data_field_ordine_scolastico ordine ON node.nid = ordine.entity_id AND node.nid IN (372,574)
    LEFT JOIN taxonomy_term_data term ON materie.field_materie_public_tid = term.tid OR ordine.field_ordine_scolastico_tid = term.tid
  WHERE node.nid IN (372,574)
GROUP BY
  node.nid, node.uid, node.uuid, node.title, body.body_value,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.nid ASC
;
