<?php

namespace Drupal\metanastasis\Plugin\migrate\process;

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\Plugin\MigrateProcessInterface;
use Drupal\migrate\Row;
use Drupal\migrate\ProcessPluginBase;
use DOMDocument;

/**
 * Cleans HTML, entities, and applies custom transformations.
 *
 * @MigrateProcessPlugin(
 *   id = "mv_dom_cleaner"
 * )
 *
 * Opzioni
 *  clean_tags boolean
 *    Rimuove tutti i tag. Default: false
 *  preserve_tags string|null
 *    Preserva i tag indicati. Default: null
 *  remove_attributes array|null
 *    Rimuove gli attributi passati come array. Default: null
 *  remove_multiple_space boolean
 *    Rimuove doppi spazi dal testo. Default: true
 *  remove_empty_paragraphs boolean
 *    Rimuove i paragrafi vuoti '<p>&nbsp;</p>'. Default: false
 *  max_char int|null
 *    Tronca ad un numero massimo di caratteri. Default: null
 *  add_ellipse string|null
 *    Aggiunge una string alla fine. Default: null
 *
 * Examples:
 *
 *   field_body_value:
 *     - plugin: skip_on_empty
 *       source: body_value
 *       method: process
 *     - plugin: mv_dom_cleaner
 *       clean_tags: true
 *       preserve_tags: '<a><p><strong><em>'
 *       remove_attributes:
 *         - style
 *         - class
 *       remove_multiple_space: true
 *
 *   field_abstract:
 *     - plugin: skip_on_empty
 *       source: field_abstract
 *       method: process
 *     - plugin: mv_dom_cleaner
 *       clean_tags: true
 *       remove_multiple_space: true
 *       max_char: 160
 *
 *
 */
class MvDomCleaner extends ProcessPluginBase implements MigrateProcessInterface {

  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    // Decodifica entità HTML.
    $value = html_entity_decode($value, ENT_QUOTES | ENT_HTML5, 'UTF-8');

    // Rimuove entità specifiche come &nbsp;.
    $value = str_replace('&nbsp;', ' ', $value);

    // Converte a UTF-8.
    //$value = mb_convert_encoding($value, 'UTF-8', 'UTF-8');

    // Rimuove tag HTML, preservando quelli specificati.
    $clean_tags = $this->configuration['clean_tags'] ?? FALSE;
    if ($clean_tags) {
      $preserve_tags = $this->configuration['preserve_tags'] ?? '';
      if (!empty($preserve_tags)) {
        $value = strip_tags($value, $this->configuration['preserve_tags']);
      } else {
        $value = strip_tags($value);
      }
    }

    // Rimuove attributi specificati dai tag HTML.
    $remove_attributes = $this->configuration['remove_attributes'] ?? '';
    if (!empty($remove_attributes) && is_array($remove_attributes)) {
      $value = $this->removeAttributes($value, $remove_attributes);
    }

    // Rimuove spazi multipli se l'opzione è attivata.
    $remove_multiple_space = $this->configuration['remove_multiple_space'] ?? TRUE;
    if ($remove_multiple_space) {
      $value = preg_replace('/\s+/', ' ', $value);
    }

    // Rimuove i paragrafi vuoti
    $remove_empty_paragraphs = $this->configuration['remove_empty_paragraphs'] ?? FALSE;
    if ($remove_empty_paragraphs) {
      $value = preg_replace('/<p>(\s|&nbsp;)*<\/p>/', '', $value);
    }

    // Limita il numero di caratteri (opzione max_char).
    $max_char = $this->configuration['max_char'] ?? FALSE;
    if ($max_char && mb_strlen($value, 'UTF-8') > $max_char) {
      if ((!is_numeric($max_char) || $max_char <= 0)) {
        throw new \InvalidArgumentException('max_char deve essere un numero intero positivo.');
      }

      $add_ellipse = $this->configuration['add_ellipse'] ?? '';

      // Cerca il punto più vicino a max_char.
      $before = mb_substr($value, 0, $max_char, 'UTF-8');
      $after = mb_substr($value, $max_char, null, 'UTF-8');

      $last_dot_before = mb_strrpos($before, '.', 0, 'UTF-8');
      $first_dot_after = mb_strpos($after, '.', 0, 'UTF-8');

      if ($last_dot_before !== false) {
        // Tronca fino all'ultimo punto trovato prima di max_char.
        $value = mb_substr($before, 0, $last_dot_before + 1, 'UTF-8');
      } elseif ($first_dot_after !== false) {
        // Tronca fino al primo punto trovato dopo max_char.
        $value = mb_substr($value, 0, $max_char + $first_dot_after + 1, 'UTF-8');
      } else {
        // Se non ci sono punti, tronca normalmente.
        $value = mb_substr($value, 0, $max_char, 'UTF-8');
      }

      // Aggiungi l'ellissi se specificato.
      $value = rtrim($value) . $add_ellipse;
    }

    // Rimuove entità specifiche come &nbsp; (ultimo giro di giostra).
    $value = str_replace('&nbsp;', ' ', $value);

    // Trim del risultato.
    return trim($value);
  }

  /**
   * Rimuove attributi specificati dai tag HTML.
   */
  private function removeAttributes($html, array $attributes) {
    $dom = new DOMDocument();

    // Disabilita errori e avvisi durante il caricamento dell'HTML.
    libxml_use_internal_errors(true);

    // Forza la codifica UTF-8.
    $html = '<?xml encoding="UTF-8">' . $html;

    // Carica l'HTML.
    $dom->loadHTML($html, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

    // Ripristina la gestione degli errori di libxml.
    libxml_clear_errors();

    // Itera sui nodi e rimuove gli attributi specificati.
    foreach ($attributes as $attribute) {
      $xpath = new \DOMXPath($dom);
      foreach ($xpath->query('//*[@' . $attribute . ']') as $node) {
        $node->removeAttribute($attribute);
      }
    }

    // Recupera l'HTML modificato.
    $cleaned_html = $dom->saveHTML();

    // Rimuove il commento <!--?xml encoding="UTF-8"-->.
    $cleaned_html = str_replace('<?xml encoding="UTF-8">', '', $cleaned_html);

    return $cleaned_html;
  }

  /**
   * {@inheritdoc}
   */
  public function multiple() {
    return FALSE;
  }

}
