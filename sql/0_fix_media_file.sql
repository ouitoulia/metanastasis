SELECT
  media.mid,
  image.field_media_image_target_id,
  file.created,
  file.changed
FROM db.media media
  LEFT JOIN db.media_field_data data ON media.mid = data.mid AND media.bundle = 'image'
  LEFT JOIN db.media__field_media_image image ON media.mid = image.entity_id
  LEFT JOIN db.file_managed file ON image.field_media_image_target_id = file.fid
;
