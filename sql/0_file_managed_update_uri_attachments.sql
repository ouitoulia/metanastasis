UPDATE db.file_managed
SET uri = REPLACE(uri, 'public://blog/allegati', 'public://attachments'),
    uri = REPLACE(uri, 'public://articolo/allegati', 'public://attachments')
WHERE uri LIKE 'public://blog/allegati%'
   OR uri LIKE 'public://articolo/allegati%';
