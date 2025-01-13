# SELECT
#   media.mid,
#   data.created,
#   image.field_media_image_target_id,
#   file.created,
#   file.changed
# FROM db.media media
#   LEFT JOIN db.media_field_data data ON media.mid = data.mid AND media.bundle = 'image'
#   LEFT JOIN db.media__field_media_image image ON media.mid = image.entity_id
#   LEFT JOIN db.file_managed file ON image.field_media_image_target_id = file.fid
# ;
UPDATE db.file_managed file
  JOIN (
    SELECT
      image.field_media_image_target_id AS fid,
      data.created AS new_created
    FROM db.media media
           LEFT JOIN db.media_field_data data
                     ON media.mid = data.mid AND media.bundle = 'image'
           LEFT JOIN db.media__field_media_image image
                     ON media.mid = image.entity_id
  ) AS updates
  ON file.fid = updates.fid
SET file.created = updates.new_created
WHERE updates.new_created IS NOT NULL
;
