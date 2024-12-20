SELECT
  u.uid AS 'nid' -- si deve mantenere l'originale id e viene usato come migration id
  , u.`uid` AS 'uid'
  , 'persona' AS 'type'
  , CONCAT(nome.field_nome_value,' ',cognome.field_cognome_value) AS 'title'
  , REPLACE(file.uri, 'private://user/avatar/', 'https://icmarvasivizzone.edu.it/it/system/files/user/avatar/') AS 'field_ritratto_url'
  , CONCAT('Foto di ', nome.field_nome_value,' ',cognome.field_cognome_value) AS 'field_ritratto_alt'
  , nome.field_nome_value AS 'field_nome'
  , cognome.field_cognome_value AS 'field_cognome'
  , CONCAT('Profilo di ',nome.field_nome_value,' ',cognome.field_cognome_value) AS 'field_abstract'
  , telefono.field_telefono_value AS 'field_telefono'
  , u.mail AS 'field_email'
  , GROUP_CONCAT(DISTINCT role.rid ORDER BY role.rid SEPARATOR ';') AS 'field_ruolo_persona' -- da verificare
  , NULL AS 'field_tipologia_posto'
  , contratto.field_tipologia_contratto_tid AS 'field_tipologia_incarico' -- id vecchio
  , NULL AS 'field_tipologia_supplenza'
  , NULL AS 'field_data_fine'
  , GROUP_CONCAT(DISTINCT materie.field_materie_public_tid ORDER BY materie.field_materie_public_tid SEPARATOR ';') AS 'field_materie' -- id vecchio
  , data_nascita.field_data_di_nascita_value AS 'field_data_nascita'
  , NULL AS 'field_genere'
  , UCASE(cf.field_codice_fiscale_value) AS 'field_codice_fiscale'
  , 'it' AS 'langcode'
  , 0 AS 'promote'
  , 0 AS 'sticky'
  , 1 AS 'status' -- sono tutti attivi in quanto è il CT persona
  , u.created AS 'created'
  , u.changed AS 'changed'
  , u.uuid AS 'uuid'
FROM users u
  LEFT JOIN field_data_field_nome nome ON u.uid = nome.entity_id AND nome.bundle = 'user'
  LEFT JOIN field_data_field_cognome cognome ON u.uid = cognome.entity_id AND cognome.bundle = 'user'
  LEFT JOIN file_managed file ON u.uid = file.uid AND file.uri LIKE 'private://user/avatar/picture-%'
  LEFT JOIN field_data_field_telefono telefono ON u.uid = telefono.entity_id AND telefono.bundle = 'user'
  LEFT JOIN users_roles role ON u.uid = role.uid
  LEFT JOIN field_data_field_tipologia_contratto contratto ON u.uid = contratto.entity_id AND contratto.bundle = 'user'
  LEFT JOIN field_data_field_materie_public materie ON u.uid = materie.entity_id AND materie.bundle = 'user'
  LEFT JOIN field_data_field_data_di_nascita data_nascita ON u.uid = data_nascita.entity_id AND data_nascita.bundle = 'user'
  LEFT JOIN field_data_field_codice_fiscale cf ON u.uid = cf.entity_id AND cf.bundle = 'user'
WHERE u.uid > 1
GROUP BY
  u.uid, nome.field_nome_value, cognome.field_cognome_value, file.uri
  , telefono.field_telefono_value, u.mail, u.name, u.status, cf.field_codice_fiscale_value
  , contratto.field_tipologia_contratto_tid, u.created, u.changed, u.uuid
ORDER BY u.uid ASC
;
