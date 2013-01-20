# AssoLeaks

La Mairie de Toulouse propose un site pour consulter les subventions et aides attribuées aux associations: [http://subventions.associations.toulouse.fr/presentation/recherche/formulaireAssociations.html](http://subventions.associations.toulouse.fr/presentation/recherche/formulaireAssociations.html)

Après l'avoir consulter rapidement, vous remarquerez qu'il n'est pas possible d'accèder a l'intégralité des chiffres afin de travailler dessus.

AssoLeaks est un script qui permet de 'scaper' rapidement l'intégralité des fiches de chaque association, de consulter le résultat dans un fichier CSV, et a terme, de constuire des analyses sur les subventions et aides apportées par la mairie de Toulouse a partir de ce résultat.

Si vous désirez construire votre propre fichier de résultat, ou re-constuire le fichier actuel, voici la commande pour lancer sa construction:

```
ruby asso_leaks.rb
```

Le fichier final se trouveras dans ```asso.csv```
