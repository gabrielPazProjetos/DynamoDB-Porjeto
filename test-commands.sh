#!/bin/bash

echo "🔍 Teste 1: Buscar todas as músicas do artista Iron Maiden"
aws dynamodb query \
  --table-name Music \
  --key-condition-expression "Artist = :artist" \
  --expression-attribute-values '{":artist":{"S":"Iron Maiden"}}'

echo "🔍 Teste 2: Buscar música específica por artista e título"
aws dynamodb query \
  --table-name Music \
  --key-condition-expression "Artist = :artist and SongTitle = :title" \
  --expression-attribute-values file://keyconditions.json

echo "🔍 Teste 3: Buscar por índice AlbumTitle-index"
aws dynamodb query \
  --table-name Music \
  --index-name AlbumTitle-index \
  --key-condition-expression "AlbumTitle = :name" \
  --expression-attribute-values '{":name":{"S":"Fear of the Dark"}}'

echo "🔍 Teste 4: Buscar por índice ArtistAlbumTitle-index"
aws dynamodb query \
  --table-name Music \
  --index-name ArtistAlbumTitle-index \
  --key-condition-expression "Artist = :v_artist and AlbumTitle = :v_title" \
  --expression-attribute-values '{":v_artist":{"S":"Iron Maiden"},":v_title":{"S":"Fear of the Dark"}}'

echo "🔍 Teste 5: Buscar por índice SongTitleYear-index"
aws dynamodb query \
  --table-name Music \
  --index-name SongTitleYear-index \
  --key-condition-expression "SongTitle = :v_song and SongYear = :v_year" \
  --expression-attribute-values '{":v_song":{"S":"Wasting Love"},":v_year":{"S":"1992"}}'
