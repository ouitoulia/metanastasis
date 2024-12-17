SELECT 
users.uid AS `id`
, user_data.name AS `User`
, user_data.mail AS `E-mail`
, nome.field_nome_value AS `Nome` 
, cognome.field_cognome_value AS `Cognome`
-- , nascita.field_data_di_nascita_value AS `Data nascita`
-- , luogo_nascita.field_luogo_di_nascita_value AS `Luogo Nascita`
-- , indirizzo.field_indirizzo_value AS `Indirizzo`
-- , citta.field_citt__value AS `Città`
-- , cap.field_cap_value AS `CAP`
, cf.field_codice_fiscale_value AS `CF`
, file.uri  AS `Curriculum`
, curriculum.field_curriculum_description AS `Curriculum description`
, GROUP_CONCAT(links.field_link_social_uri SEPARATOR ';') AS `Links Social`
FROM users 
  LEFT JOIN user__field_nome nome ON users.uid = nome.entity_id 
  LEFT JOIN users_field_data user_data ON users.uid = user_data.uid 
  LEFT JOIN user__field_cognome cognome ON users.uid = cognome.entity_id 
  LEFT JOIN user__field_data_di_nascita nascita ON users.uid = nascita.entity_id 
  LEFT JOIN user__field_luogo_di_nascita luogo_nascita ON users.uid = luogo_nascita.entity_id 
  LEFT JOIN user__field_indirizzo indirizzo ON users.uid = indirizzo.entity_id 
  LEFT JOIN user__field_citt_ citta ON users.uid = citta.entity_id 
  LEFT JOIN user__field_cap cap ON users.uid = cap.entity_id 
  LEFT JOIN user__field_codice_fiscale cf ON users.uid = cf.entity_id 
  LEFT JOIN user__field_curriculum curriculum ON users.uid = curriculum.entity_id 
  LEFT JOIN file_managed file ON curriculum.field_curriculum_target_id = file.fid 
  LEFT JOIN user__field_link_social links ON users.uid = links.entity_id 
--  LEFT JOIN user__field_materia_public materia ON users.uid = materia.field_materia_public_target_id 
--  LEFT JOIN user__field_materie_public materie ON users.uid = materie.field_materie_public_target_id 
  LEFT JOIN user__field_plesso_public plesso ON users.uid = plesso.entity_id 
GROUP BY 
  users.uid
  , nome.field_nome_value, cognome.field_cognome_value
  , nascita.field_data_di_nascita_value, luogo_nascita.field_luogo_di_nascita_value 
  , indirizzo.field_indirizzo_value, citta.field_citt__value, cap.field_cap_value
  , cf.field_codice_fiscale_value
  , file.uri, curriculum.field_curriculum_description
ORDER BY users.uid ASC;