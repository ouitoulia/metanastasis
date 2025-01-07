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

`drush migrate:import --update --tag marvasivizzone --execute-dependencies`

https://icmarvasivizzone.edu.it/it/docenti/~preside/verbale-n4-collegio-dei-docenti-del-11122014
https://icmarvasivizzone.edu.it/it/notizie/saluti-del-dirigente-scolastico-nicolantonio-cutuli

# Spostare i file
vedi campi `=> paragraph ==> da spostare a mano in attachments`

```shell
cp /path/to/public/blog/allegati/* /path/to/public/attachments/
cp /path/to/public/articolo/allegati/* /path/to/public/attachments/
```

```sql
UPDATE file_managed
SET uri = REPLACE(uri, 'public://blog/allegati', 'public://attachments'),
uri = REPLACE(uri, 'public://articolo/allegati', 'public://attachments')
WHERE uri LIKE 'public://blog/allegati%'
OR uri LIKE 'public://articolo/allegati%';
```

# Da recuperare data corretta in file_managed
Persona/ritratto
media/immagini

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
├── documenti  -> `field_allegati`
├── materiali-didattici
│ ├── allegati  -> `field_allegati`
│ ├── immagine -> `field_image` ==> media
│ └── immagini -> `field_galleria`
├── modelli -> `field_allegati`
├── pagina
│ ├── allegati -> `field_allegati` > da valutare paragraph
│ ├── galleria -> `field_galleria` ==> no immagini di galleria
│ └── immagine -> `field_image` ==> media

```yaml
  permissions:
    -
      plugin: static_map
      source: permissions
      bypass: true
      map:
        'use PHP for block visibility': 'use PHP for settings'
        'administer site-wide contact form': 'administer contact forms'
        'post comments without approval': 'skip comment approval'
        'edit own blog entries': 'edit own blog content'
        'edit any blog entry': 'edit any blog content'
        'delete own blog entries': 'delete own blog content'
        'delete any blog entry': 'delete any blog content'
        'create forum topics': 'create forum content'
        'delete any forum topic': 'delete any forum content'
        'delete own forum topics': 'delete own forum content'
        'edit any forum topic': 'edit any forum content'
        'edit own forum topics': 'edit own forum content'
    - plugin: flatten
```
---------------------------------------------------------------
3. Usare BFG Repo-Cleaner (alternativa)

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

