SELECT
  u.uid AS 'uid' -- si deve mantenere l'originale id
  , u.`uuid` AS 'uuid' -- non importare, solo per migration_id in caso
  , u.`language` AS 'langcode'
  , u.`language` AS 'preferred_langcode'
  , u.`language` AS 'preferred_admin_langcode'
  , u.name AS 'name'
  , u.mail AS 'mail'
  , 'Europe/Rome' AS 'timezone' -- imposto a tutti il timezone italiano
  , u.status AS 'status'
  , u.created AS 'created'
  , u.changed AS 'changed'
  , u.access AS 'access'
  , u.login AS 'login'
  , u.init AS 'init'
  , 'it' AS 'default_langcode'
  , UCASE(cf.field_codice_fiscale_value) AS 'field_codice_fiscale'
FROM users u
  LEFT JOIN field_data_field_codice_fiscale cf ON u.uid = cf.entity_id AND cf.bundle = 'user'
WHERE u.uid > 1
;
