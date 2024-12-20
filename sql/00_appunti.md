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

