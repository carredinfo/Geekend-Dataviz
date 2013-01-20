# Gestionnaire de l'Eau en Midi-Pyrénées

Le but de cet exercice a été de récupérer un fichier fournis par [...] afin de visualiser sur la région Midi-Pyrénées le marché de l'eau attribué au secteur public et au secteur privé.

Pour cela, nous avons rajoutés des données de géolocalisation sur le fichier original afin de permettre de présenter les données sur une carte.

Ce fichier final s'appelle ```map_data.csv``` et pour l'obtenir de nouveau, vous pouvez éxécuter le script:

```
ruby city_gestionnaire_to_map_data.rb
```

Une fois ce fichier ```map_data.csv``` généré, vous pouvew vous rendre sur le site [http://cartodb.com](http://cartodb.com) et l'importer dans une nouvelle table.

Une carte vous sera proposée, et vous pourrez la décorer en utilisant les différentes colonnes de votre tableau grâce à CartoCSS.
