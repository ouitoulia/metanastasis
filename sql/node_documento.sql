SELECT
  CONCAT('documento_',node.nid) AS 'migration_id'
  , node.uid AS 'uid' -- id giusto
  , node.`uuid`
  , 'documento' AS 'type'
  , TRIM(node.title) AS 'title'
  , TRIM(body.body_value) AS 'field_abstract' -- pulire dai tag durante la migrazione
  , GROUP_CONCAT(DISTINCT area.field_area_tid ORDER BY area.field_area_tid SEPARATOR ';') AS 'field_argomenti'
  , TRIM(body.body_value) AS 'body_value' -- pulire dai tag durante la migrazione
  -- , NULL AS 'field_tipologia_documento'
  , CASE
      -- Bandi e gare
      WHEN node.title LIKE '%determina a contrarre%' OR at.field_categoria_albo_tid IN (24,315,316,317,318,319,320,321,322,323,324,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350) THEN 1802
      -- Bilancio
      WHEN at.field_categoria_albo_tid IN (101) THEN 1805
      -- Contratti - Personale ATA
      WHEN at.field_categoria_albo_tid IN (95) THEN 1805
      -- Contratti - Personale Docente
      WHEN at.field_categoria_albo_tid IN (96) THEN 1806
      -- Contratti e convenzioni
      WHEN node.title LIKE 'Incarico individuale per assistenza specialistica%' THEN 1807
      -- Convocazioni
      WHEN node.title LIKE 'convocazion%' OR at.field_categoria_albo_tid IN (98) THEN 1808
      -- Delibere Consiglio di Istituto
      WHEN node.title LIKE 'Verbale%Istituto%' THEN 1810
      -- Delibere Collegio dei Docenti
      WHEN node.title LIKE 'Verbale%Docenti%' THEN 1811
      -- Graduatorie
      WHEN node.title LIKE '%graduatori%' OR at.field_categoria_albo_tid IN (26) THEN 1816
      -- Regolamento
      WHEN node.title LIKE '%regolament%' OR at.field_categoria_albo_tid IN (310) THEN 1822
      ELSE NULL
    END AS 'field_tipologia_documento'
  , NULL AS 'field_copertina'
  , NULL AS 'field_galleria_immagini'
  , NULL AS 'field_persone'
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
  , CASE
      WHEN TRIM(protocollo.field_protocollo_value) = 'Ancora non definito' THEN NULL
      ELSE TRIM(protocollo.field_protocollo_value)
    END AS 'field_protocollo'
  , NULL AS 'field_data_inizio'
  , REPLACE(REPLACE(REPLACE(TRIM(cig.field_cig_value), ' ', ''), ':', ''), '-', '') AS 'field_cig'
  , data.field_data_scadenza_value AS 'field_data_fine'
  , TRIM(cup.field_cup_value) AS 'field_cup'
  , NULL AS 'field_codice_identificativo'
  , DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(node.created), INTERVAL 10 YEAR), '%Y-%m-%dT%H:%i:%s') AS 'field_data_oblio'
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
  , NULL AS 'field_servizio'
  , NULL AS 'field_eventi'
  , NULL AS 'field_progetti'
  , NULL AS 'field_percorso_di_studio'
  , NULL AS 'field_notizie'
  , NULL AS 'field_classi'
  , GROUP_CONCAT(DISTINCT CONCAT('finanziamento_',finanziamento.field_area_tid) ORDER BY finanziamento.delta SEPARATOR ';') AS 'field_finanziamenti'
  , NULL AS 'field_frequenza'
  , NULL AS 'field_struttura_responsabile'
  , 904 AS 'field_tipologia_licenza'
  , NULL AS 'field_timeline'
  , NULL AS 'field_extra_info'
  , GROUP_CONCAT(DISTINCT at.field_categoria_albo_tid ORDER BY at.field_categoria_albo_tid SEPARATOR ';') AS 'field_obbligo_di_pubblicazione'
  , 'it' AS 'langcode'
  , node.promote AS 'promote'
  , node.sticky AS 'sticky'
  , node.status AS 'status'
  , node.created AS 'created'
  , node.created AS 'changed'
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
  -- Recupero l'eventuale finanziamento correlato
  LEFT JOIN field_data_field_area finanziamento ON
    node.nid = finanziamento.entity_id AND
    finanziamento.bundle IN ('albo_pretorio', 'documenti') AND
    finanziamento.field_area_tid IN (
       357, 358, 359, -- nel body c'è un'immagine da migrare da private://
       360, 361, 362, 364, 365, 366,
       374, 376, 377, 378, 379,
       406, 408, 409, 410, 415, 418,
       420, 421, 422, 423, 424, 425, 426, 427, 428, 429,
       430, 431, 432, 433, 434, 435, 436, 437, 438, 439,
       440, 441, 442, 443, 444, 445, 446, 447, 448,
       450
    )
  -- Recupero il campo field_circolare
  LEFT JOIN field_data_field_circolare circolare ON node.nid = circolare.entity_id AND circolare.bundle IN ('albo_pretorio', 'documenti')
WHERE
  node.`type` IN ('albo_pretorio', 'documenti')
  AND (circolare.field_circolare_value = 0 OR circolare.field_circolare_value IS NULL) -- FALSE o NULL se non è una circolare
GROUP BY
  node.nid, node.uid, node.uuid, node.title, body.body_value,
  protocollo.field_protocollo_value, cig.field_cig_value, cup.field_cup_value,
  data.field_data_scadenza_value,
  node.promote, node.sticky, node.status, node.created, node.changed
ORDER BY node.created ASC
;
