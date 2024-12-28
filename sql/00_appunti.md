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

https://icmarvasivizzone.edu.it/it/notizie/saluti-del-dirigente-scolastico-nicolantonio-cutuli

./
├── 00file_caricati
├── albopretorio -> `field_allegati`
├── amministrazione-trasparente -> `field_allegati`
├── articolo
│ ├── allegati  -> `field_allegati` > da valutare paragraph
│ ├── gallery   -> `field_galleria` > da valutare paragraph
│ ├── immagine  -> `field_image` ==> media
│ └── immagini  -> `field_image` ==> media
├── blog
│ ├── allegati -> `field_allegati` > da valutare paragraph
│ ├── galleria -> `field_galleria` > da valutare paragraph
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
