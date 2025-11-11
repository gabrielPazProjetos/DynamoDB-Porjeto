--- Projeto: Boas Práticas com DynamoDB 
O projeto demonstra como aplicar boas práticas de modelagem NoSQL com o Amazon DynamoDB, simulando aspectos relacionais em um banco não relacional.

--- Objetivo
Explorar os recursos do DynamoDB para criar uma estrutura de dados eficiente, utilizando:
- Chaves compostas (Partition Key e Sort Key)
- Índices secundários globais (GSI)
- Operações via AWS CLI
- Modelagem orientada a agregados

--- Estrutura da Tabela

- bash
aws dynamodb create-table \
  --table-name Music \
  --attribute-definitions \
    AttributeName=Artist,AttributeType=S \
    AttributeName=SongTitle,AttributeType=S \
  --key-schema \
    AttributeName=Artist,KeyType=HASH \
    AttributeName=SongTitle,KeyType=RANGE \
  --provisioned-throughput \
    ReadCapacityUnits=10,WriteCapacityUnits=5

--- Inserção de Dados
Inserir item único
bash
aws dynamodb put-item \
  --table-name Music \
  --item file://itemmusic.json
Inserir múltiplos itens
- bash
aws dynamodb batch-write-item \
  --request-items file://batchmusic.json
  
--- Índices Secundários Globais
-- Por título do álbum
- bash
aws dynamodb update-table \
  --table-name Music \
  --attribute-definitions AttributeName=AlbumTitle,AttributeType=S \
  --global-secondary-index-updates \
  "[{\"Create\":{\"IndexName\": \"AlbumTitle-index\",\"KeySchema\":[{\"AttributeName\":\"AlbumTitle\",\"KeyType\":\"HASH\"}], \
  \"ProvisionedThroughput\": {\"ReadCapacityUnits\": 10, \"WriteCapacityUnits\": 5 },\"Projection\":{\"ProjectionType\":\"ALL\"}}}]"
  
-- Por artista + título do álbum
- bash
aws dynamodb update-table \
  --table-name Music \
  --attribute-definitions \
    AttributeName=Artist,AttributeType=S \
    AttributeName=AlbumTitle,AttributeType=S \
  --global-secondary-index-updates \
  "[{\"Create\":{\"IndexName\": \"ArtistAlbumTitle-index\",\"KeySchema\":[{\"AttributeName\":\"Artist\",\"KeyType\":\"HASH\"}, \
  {\"AttributeName\":\"AlbumTitle\",\"KeyType\":\"RANGE\"}], \
  \"ProvisionedThroughput\": {\"ReadCapacityUnits\": 10, \"WriteCapacityUnits\": 5 },\"Projection\":{\"ProjectionType\":\"ALL\"}}}]"
  
-- Por título da música + ano
- bash
aws dynamodb update-table \
  --table-name Music \
  --attribute-definitions \
    AttributeName=SongTitle,AttributeType=S \
    AttributeName=SongYear,AttributeType=S \
  --global-secondary-index-updates \
  "[{\"Create\":{\"IndexName\": \"SongTitleYear-index\",\"KeySchema\":[{\"AttributeName\":\"SongTitle\",\"KeyType\":\"HASH\"}, \
  {\"AttributeName\":\"SongYear\",\"KeyType\":\"RANGE\"}], \
  \"ProvisionedThroughput\": {\"ReadCapacityUnits\": 10, \"WriteCapacityUnits\": 5 },\"Projection\":{\"ProjectionType\":\"ALL\"}}}]"
  
--- Consultas
-- Por artista
- bash
aws dynamodb query \
  --table-name Music \
  --key-condition-expression "Artist = :artist" \
  --expression-attribute-values '{":artist":{"S":"Iron Maiden"}}'
  
-- Por artista e título da música
- bash
aws dynamodb query \
  --table-name Music \
  --key-condition-expression "Artist = :artist and SongTitle = :title" \
  --expression-attribute-values file://keyconditions.json
  
-- Por índice AlbumTitle-index
- bash
aws dynamodb query \
  --table-name Music \
  --index-name AlbumTitle-index \
  --key-condition-expression "AlbumTitle = :name" \
  --expression-attribute-values '{":name":{"S":"Fear of the Dark"}}'
  
-- Por índice ArtistAlbumTitle-index
- bash
aws dynamodb query \
  --table-name Music \
  --index-name ArtistAlbumTitle-index \
  --key-condition-expression "Artist = :v_artist and AlbumTitle = :v_title" \
  --expression-attribute-values '{":v_artist":{"S":"Iron Maiden"},":v_title":{"S":"Fear of the Dark"}}'
  
-- Por índice SongTitleYear-index
- bash
aws dynamodb query \
  --table-name Music \
  --index-name SongTitleYear-index \
  --key-condition-expression "SongTitle = :v_song and SongYear = :v_year" \
  --expression-attribute-values '{":v_song":{"S":"Wasting Love"},":v_year":{"S":"1992"}}'
  
--- Testes e Validação
-- Este projeto inclui um script de testes (test-commands.sh) que são feitos via comandos AWS CLI e cobrem:
- Consulta por artista
- Consulta por artista e título da música
- Consulta por índice AlbumTitle-index
- Consulta por índice ArtistAlbumTitle-index
- Consulta por índice SongTitleYear-index

-- Esses testes garantem que:
- Os dados foram inseridos corretamente
- Os índices secundários estão funcionando como esperado
- As consultas retornam os resultados esperados com base nos atributos definidos

--- Aprendizados
- Diferença entre bancos relacionais e não relacionais
- Modelagem orientada a agregados
- Eficiência com índices secundários
- Uso do AWS CLI para manipulação de dados
- Simulação de arquitetura relacional em NoSQL
