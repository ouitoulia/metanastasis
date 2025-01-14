# Metanástasis

Μετανάστασις è un modulo che migra i contenuti dal sito vecchio al nuovo.

1. Esegui le query che si trovano nella cartella `sql` e salva il risultato
in formato JSON dentro la cartella `artifact`.
2. Esegui [bin/sync_files.sh](bin/sync_files.sh) per scaricare/sincronizzare i file
3. Esegui le migrazioni per importare/aggiornare i contenuti
   `drush migrate:import --update --tag marvasivizzone --execute-dependencies`

## License

Copyright (C) 2023-2025 https://github.com/ouitoulia

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

Questo è un software libero: puoi ridistribuirlo e/o modificarlo secondo i termini della GNU General Public License versione 3 pubblicata dalla Free Software Foundation.

Questo programma è distribuito nella speranza che possa essere utile, ma SENZA ALCUNA GARANZIA; senza nemmeno la garanzia implicita di COMMERCIABILITÀ o IDONEITÀ PER UNO SCOPO PARTICOLARE. Vedere la GNU General Public License per maggiori dettagli.

