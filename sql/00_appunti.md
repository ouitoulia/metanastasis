# Cose manuali durante migrazione
Se cambi dominio cambia url in migrazioni tassonomie e menu

`drush migrate:import --update --tag marvasivizzone --execute-dependencies`

https://icmarvasivizzone.edu.it/it/docenti/~preside/verbale-n4-collegio-dei-docenti-del-11122014
https://icmarvasivizzone.edu.it/it/notizie/saluti-del-dirigente-scolastico-nicolantonio-cutuli

# Spostare i file
vedi campi `=> paragraph ==> da spostare a mano in attachments`

```shell
cp /path/to/public/blog/allegati/* /path/to/public/attachments/
cp /path/to/public/articolo/allegati/* /path/to/public/attachments/
```
Aggiorna il db eseguendo [0_file_managed_update_uri_attachments.sql](0_file_managed_update_uri_attachments.sql)

# Data dei file di copertina
[0_fix_media_file.sql](0_fix_media_file.sql)


# Gestione file

  `field_allegati`	File (modulo: File)
    Articolo                article => articolo/allegati
    Albo Pretorio           albo-pretorio => albopretorio
    Albo Pretorio TAXONOMY  albo_pretorio => amministrazione-trasparente
    Articolo Blog Docente   blog => blog/allegati
    Documenti               documenti => documenti
    Materiali Didattici     materiali-didattici => materiali-didattici/allegati
    Modello                 webform => modelli
    Pagina Base             page => pagina/allegati
    Corsi di Formazione (T) corsi_di_formazione => corsi-di-formazione/allegati

  `field_galleria`	Immagine (modulo: Image)
    Articolo                article => articolo/gallery
    Articolo Blog Docente   blog => blog/galleria
    Materiali Didattici     materiali_didattici => materiali-didattici/immagini
    Pagina Base             page => pagina/galleria

./
├── 00file_caricati
├── albopretorio -> `field_allegati`
├── amministrazione-trasparente -> `field_allegati`
├── articolo
│ ├── allegati  -> `field_allegati` => paragraph ==> da spostare a mano in attachments
│ ├── gallery   -> `field_galleria` => paragraph
│ ├── immagine  -> `field_image` ==> media
│ └── immagini  -> `field_image` ==> media
├── blog
│ ├── allegati -> `field_allegati` => paragraph ==> da spostare a mano in attachments
│ ├── galleria -> `field_galleria` => paragraph
│ └── immagine -> `field_image` ==> media
├── book ==> NON MIGRATO OBSOLETO
│ ├── allegati -> `field_allegati` ==> NON MIGRATO OBSOLETO
│ ├── galleria -> `field_galleria` ==> NON MIGRATO OBSOLETO
│ └── immgagine -> `field_image` ==> NON MIGRATO OBSOLETO
├── corsi-di-formazione
│ └── allegati -> `field_allegati`
├── documenti -> `field_allegati` => paragraph ==> da spostare a mano in attachments
├── materiali-didattici
│ ├── allegati -> `field_allegati` => paragraph ==> da spostare a mano in attachments
│ ├── immagine -> `field_image` ==> media
│ └── immagini -> `field_galleria` ==> paragraph
├── modelli -> `field_allegati`
├── pagina
│ ├── allegati -> `field_allegati` > da valutare paragraph
│ ├── galleria -> `field_galleria` ==> no immagini di galleria
│ └── immagine -> `field_image` ==> media


# AT
https://icmarvasivizzone.edu.it/it/albo-pretorio/tassi-di-assenza
Pubblicare un documento con i link

https://icmarvasivizzone.edu.it/it/albo-pretorio/piano-triennale-la-prevenzione-della-corruzione-e-della-trasparenza
Pubblicare dei documenti con i piani passati associati a /taxonomy/term/9561

https://icmarvasivizzone.edu.it/it/albo-pretorio/bilancio-preventivo-e-consuntivo
Differenziare tra preventivo e consuntivo in quanto non lo sono

https://icmarvasivizzone.edu.it/it/albo-pretorio/titolari-di-incarichi-di-amministrazione-di-direzione-o-di-governo

https://icmarvasivizzone.edu.it/it/albo-pretorio/accessibilit%C3%A0-e-catalogo-di-dati-metadati-e-banche-dati

https://icmarvasivizzone.edu.it/it/albo-pretorio/informazioni-ambientali
c'è un DVR pubblicato da importare a mano come storico

https://icmarvasivizzone.edu.it/it/albo-pretorio/tipologie-di-procedimento
copiare informazioni nella pagina

https://icmarvasivizzone.edu.it/it/albo-pretorio/accessibilit%C3%A0-e-catalogo-di-dati-metadati-e-banche-dati
Pubblicare dei documenti con le informazioni memorizzate nella pagina di tassonomia

https://icmarvasivizzone.edu.it/it/albo-pretorio/iban-e-pagamenti-informatici
Pubblicare dei documenti con le informazioni memorizzate nella pagina di tassonomia

---------------------------------------------------------------
# Usare BFG Repo-Cleaner (alternativa)

Se preferisci un approccio più semplice, usa BFG Repo-Cleaner.
Installazione

Scarica il JAR di BFG da BFG Repo-Cleaner.
Eliminazione della cartella /artifact

Esegui il comando seguente:

java -jar bfg.jar --delete-folders artifact path/to/repository.git

Questo rimuove tutti i file presenti nella cartella /artifact in ogni commit.
Rimuovere specifici tipi di file (opzionale)

Se desideri eliminare tutti i file JSON dal repository:

java -jar bfg.jar --delete-files '*.json' path/to/repository.git

4. Ripulire e comprimere la cronologia

Dopo aver usato git filter-repo o BFG, esegui questi comandi per eliminare i riferimenti a oggetti rimossi dalla cronologia:

git reflog expire --expire=now --all
git gc --prune=now --aggressive

