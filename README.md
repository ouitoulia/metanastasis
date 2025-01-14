# Metanástasis

Μετανάστασις è un modulo che migra i contenuti dal sito vecchio al nuovo.

1. Esegui le query che si trovano nella cartella `sql` e salva il risultato
in formato JSON dentro la cartella `artifact`.
2. Esegui [bin/sync_files.sh](bin/sync_files.sh) per scaricare/sincronizzare i file
3. Esegui le migrazioni per importare/aggiornare i contenuti
   `drush migrate:import --update --tag marvasivizzone --execute-dependencies`
