<?php

namespace Drupal\marvasi_migration\Plugin\migrate\source;

use Drupal\migrate\Plugin\migrate\source\SourcePluginBase;
use Drupal\migrate\MigrateException;
use Iterator;

/**
 * Generates dynamic paginated URLs for JSON API source.
 *
 * @MigrateSource(
 *   id = "dynamic_json_api"
 * )
 */
class DynamicJsonApi extends SourcePluginBase {

  /**
   * {@inheritdoc}
   * @throws MigrateException
   */
  public function initializeIterator(): Iterator {
    // Genera gli URL dinamici.
    $urls = $this->generateUrls();

    // Recupera i dati da ciascun URL e costruisce un array completo.
    $all_data = [];
    foreach ($urls as $url) {
      $data = $this->fetchDataFromUrl($url);
      if (isset($data['data'])) {
        $all_data = array_merge($all_data, $data['data']);
      }
    }

    dump($all_data);

    // Restituisce i dati come iteratore.
    return new \ArrayIterator($all_data);
  }

  /**
   * Genera dinamicamente gli URL paginati.
   *
   * @return array
   *   Un array di URL.
   * @throws MigrateException
   */
  protected function generateUrls(): array {
    $config = $this->configuration['page'];

    // Parametri obbligatori.
    $base_url = $config['base_url'] ?? '';
    $limit = $config['limit'] ?? 50;
    $max_offset = $config['max_offset'] ?? 0;

    if (empty($base_url) || !is_numeric($limit) || !is_numeric($max_offset)) {
      throw new MigrateException('Parametri obbligatori mancanti o non validi.');
    }

    // Parametri opzionali: filtri e ordinamenti.
    $filter_params = '';
    if (!empty($config['filter']) && is_array($config['filter'])) {
      $query_params = [];
      foreach ($config['filter'] as $filter) {
        if (!empty($filter['name']) && isset($filter['value'])) {
          $query_params[] = "{$filter['name']}=" . urlencode($filter['value']);
        }
      }
      $filter_params = '&' . implode('&', $query_params);
    }

    // Genera gli URL.
    $urls = [];
    for ($offset = 0; $offset <= $max_offset; $offset += $limit) {
      $urls[] = "{$base_url}?page[offset]={$offset}&page[limit]={$limit}{$filter_params}";
    }
    return $urls;
  }

  /**
   * Recupera i dati da un URL.
   *
   * @param string $url
   *   L'URL da cui recuperare i dati.
   *
   * @return array
   *   I dati decodificati dal JSON.
   * @throws MigrateException
   */
  protected function fetchDataFromUrl(string $url): array {
    $response = file_get_contents($url);
    if ($response === FALSE) {
      throw new MigrateException("Errore nel recupero dei dati da: {$url}");
    }
    $data = json_decode($response, TRUE);
    if (json_last_error() !== JSON_ERROR_NONE) {
      throw new MigrateException('Errore nella decodifica JSON: ' . json_last_error_msg());
    }
    return $data;
  }

  /**
   * {@inheritdoc}
   */
  public function getIds(): array {
    return [
//      'uuid' => [
//        'type' => 'string',
//      ],
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function fields() {
    return [
      'uuid' => 'UUID del file',
      'fid' => 'ID interno di Drupal',
      'langcode' => 'Lingua del file',
      'filename' => 'Nome del file',
      'uri' => 'Percorso del file',
      'filemime' => 'MIME type',
      'filesize' => 'Dimensione del file',
      'status' => 'Stato del file',
      'created' => 'Data di creazione',
      'changed' => 'Data di modifica',
    ];
  }

  public function __toString() {
    return 'DynamicJsonApi';
  }
}
