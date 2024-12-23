SELECT
  u.uid AS 'nid' -- si deve mantenere l'originale id e viene usato come migration id
  , u.`uid` AS 'uid'
  , 'persona' AS 'type'
  , CONCAT(TRIM(nome.field_nome_value),' ',TRIM(cognome.field_cognome_value)) AS 'title'
  , REPLACE(file.uri, 'private://user/avatar/', 'https://icmarvasivizzone.edu.it/it/system/files/user/avatar/') AS 'field_ritratto_url'
  , CONCAT('Foto di ', TRIM(nome.field_nome_value),' ',TRIM(cognome.field_cognome_value)) AS 'field_ritratto_alt'
  , TRIM(nome.field_nome_value) AS 'field_nome'
  , TRIM(cognome.field_cognome_value) AS 'field_cognome'
  , CONCAT('Profilo di ', TRIM(nome.field_nome_value),' ',TRIM(cognome.field_cognome_value)) AS 'field_abstract'
  , TRIM(telefono.field_telefono_value) AS 'field_telefono'
  , TRIM(u.mail) AS 'field_email'
  , GROUP_CONCAT(
      DISTINCT
      CASE WHEN role.rid NOT IN (1,2,3,4,6,10,11,13,15,16,17,18) THEN role.rid ELSE NULL END
      ORDER BY role.rid
      SEPARATOR ';'
    ) AS 'field_ruolo_persona'
  , CASE
      WHEN EXISTS (
        SELECT 1
        FROM field_data_field_materie_public materia
        WHERE materia.bundle = 'user'
          AND materia.entity_id = u.uid
          AND materia.field_materie_public_tid = 90
      ) THEN 1052
      WHEN EXISTS (
        SELECT 1
        FROM field_data_field_materie_public materia
        WHERE materia.bundle = 'user'
          AND materia.entity_id = u.uid
      ) THEN 1051
      ELSE NULL
    END AS 'field_tipologia_posto' -- id giusto
  , contratto.field_tipologia_contratto_tid AS 'field_tipologia_incarico' -- id vecchio
  , NULL AS 'field_tipologia_supplenza'
  , NULL AS 'field_data_fine'
  , GROUP_CONCAT(
      DISTINCT
      CASE
        WHEN materie.field_materie_public_tid NOT IN (90, 204) THEN
          -- Split per primaria e secondaria in quanto nel nuovo sito sono divise per ordine
          CASE
            WHEN plesso.field_plesso_public_tid IN (20, 21, 42) THEN materie.field_materie_public_tid + 1000 -- se è primaria
            WHEN plesso.field_plesso_public_tid = 22 THEN materie.field_materie_public_tid + 2000 -- se è secondaria
            ELSE materie.field_materie_public_tid
          END
        ELSE NULL
      END
      ORDER BY materie.field_materie_public_tid
      SEPARATOR ';'
    ) AS 'field_materie' -- id vecchio
  , CASE
      WHEN data_nascita.field_data_di_nascita_value LIKE '1919%' THEN NULL
      ELSE data_nascita.field_data_di_nascita_value
    END AS 'field_data_nascita'
  , NULL AS 'field_genere'
  , CASE
      WHEN UCASE(TRIM(cf.field_codice_fiscale_value)) IN ('AAAAAA01A01A000A', '91006770803', 'AAABBB12A12A123A', 'AAABBB11A11A111S', 'AAABBB00A00A000A') THEN NULL
      ELSE UCASE(TRIM(cf.field_codice_fiscale_value))
    END AS 'field_codice_fiscale'
  , 'it' AS 'langcode'
  , 0 AS 'promote'
  , 0 AS 'sticky'
  , 1 AS 'status' -- sono tutti attivi in quanto è il CT persona
  , u.created AS 'created'
  , u.changed AS 'changed'
  , u.uuid AS 'uuid'
  , plesso.field_plesso_public_tid
FROM users u
  LEFT JOIN field_data_field_nome nome ON u.uid = nome.entity_id AND nome.bundle = 'user'
  LEFT JOIN field_data_field_cognome cognome ON u.uid = cognome.entity_id AND cognome.bundle = 'user'
  LEFT JOIN file_managed file ON u.uid = file.uid AND file.uri LIKE CONCAT('private://user/avatar/picture-',u.uid,'-%')
  LEFT JOIN field_data_field_telefono telefono ON u.uid = telefono.entity_id AND telefono.bundle = 'user'
  LEFT JOIN users_roles role ON u.uid = role.uid
  LEFT JOIN field_data_field_tipologia_contratto contratto ON u.uid = contratto.entity_id AND contratto.bundle = 'user'
  LEFT JOIN field_data_field_materie_public materie ON u.uid = materie.entity_id AND materie.bundle = 'user'
  LEFT JOIN field_data_field_data_di_nascita data_nascita ON u.uid = data_nascita.entity_id AND data_nascita.bundle = 'user'
  LEFT JOIN field_data_field_codice_fiscale cf ON u.uid = cf.entity_id AND cf.bundle = 'user'
  LEFT JOIN field_data_field_plesso_public plesso ON u.uid = plesso.entity_id AND plesso.bundle = 'user'
WHERE u.uid > 0
GROUP BY
  u.uid, nome.field_nome_value, cognome.field_cognome_value, file.uri
  , telefono.field_telefono_value, u.mail, u.name, u.status, cf.field_codice_fiscale_value
  , contratto.field_tipologia_contratto_tid, u.created, u.changed, u.uuid
ORDER BY u.uid ASC
;
