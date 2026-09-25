# Annexe — Diagnostic écoconception Campus Explorer

## Cinq problèmes observés (version initiale)

1. **Requêtes du catalogue à chaque frappe** — `app.js`, `onSearch()` appelait `loadCatalogue("/api/products?ts=" + Date.now())`. Chaque caractère relançait le téléchargement du catalogue (environ 2 Mo de JSON) et empêchait le cache grâce au paramètre variable.
2. **Statistiques interrogées toutes les 2 secondes** — `app.js`, `setInterval(pollStats, 2000)` et `server.py` route `/api/stats`. Génère 30 requêtes par minute même sans interaction ; le serveur relit le JSON à chaque appel.
3. **Traitements de recommandations inutiles et quadratiques** — `buildRecommendations()` comparait chaque session à toutes les autres, avec découpages et recherches de mots répétés (O(n²)), alors que les recommandations sont secondaires.
4. **Images lourdes et chargées d’emblée** — dossier `assets/` : hero.png ≈ 8,7 Mo et quatre images galerie de 0,9 à 1,9 Mo chacune. Les images de la galerie étaient sans `loading=lazy` ni `decoding=async`.
5. **Données de l’API enrichies inutilement** — `server.py`, `prepare_catalogue()` ajoutait pour chaque entrée une présentation HTML/plain text/teaser/titre en majuscules, des mots-clés et un score de recommandation ; la réponse dépassait 2 Mo pour des données dont l’interface n’utilisait pas ces champs.

## Trois rattachements RGESN 2024 (à vérifier dans le PDF officiel et le moyen de contrôle)

- **Critère 4.6 — Le service numérique évite-t-il les animations ou les contenus animés non nécessaires ?** (intitulé à reprendre exactement depuis la fiche officielle) : le bandeau `<marquee>` défile en continu sans apporter d’information fonctionnelle supplémentaire. Moyen de contrôle : évaluer la pertinence de l’animation et si elle sert une fonction critique ou apporte une information. Le bandeau a été retiré.
- **Critère 4.7 — Le service numérique opte-t-il pour les choix les plus sobres entre le texte, l’image, l’audio ou la vidéo, selon les besoins utilisateurs ?** : l’image hero pèse environ 8,7 Mo et les images de galerie 0,9 à 1,9 Mo. Le poids est disproportionné pour des images d’illustration et les images plus basses dans la page n’étaient pas différées. Moyen de contrôle : justifier la pertinence du média et le choix de la solution la plus sobre. Le chargement différé de galerie est appliqué ; compression d’image reste une piste.
- **Critère 4.5 — Le service numérique utilise-t-il des composants d’interface utilisateur conçus pour minimiser leurs impacts environnementaux ?** (confirmer l’intitulé exact et le moyen de contrôle dans la fiche RGESN) : appels réseau répétés sur chaque frappe et toutes les 2 secondes déclenchent des traitements sans action utilisateur utile. Lien avec le contrôle : sobriété des composants et minimisation des transferts/ressources. Pour un rattachement incontestable, relire le moyen de contrôle officiel avant remise.

> Référence officielle : [RGESN 2024 — fiches et référentiel](https://ecoresponsable.numerique.gouv.fr/publications/referentiel-general-ecoconception/). Les critères 4.6 et 4.7 concernent la pertinence des médias/animations ; reprendre mot pour mot les intitulés et moyens de contrôle de la fiche PDF avant dépôt. Ce TP n’est pas une déclaration de conformité globale.

## Modifications retenues

1. **Catalogue chargé une seule fois** : recherche, catégories, campus et réinitialisation filtrent les données déjà en mémoire. L’API n’est plus appelée à chaque frappe. Le chargement initial et le message d’erreur restent distincts du résultat vide.
2. **Suppression du polling statistiques** : les trois chiffres sont calculés localement à partir du catalogue déjà chargé ; le bouton actualise les chiffres locaux. Suppression de la requête répétée `/api/stats` toutes les 2 secondes.
3. **Allègement du parcours secondaire et du rendu** : suppression de recommandations automatiques (calcul O(n²)), du bandeau animé et de la newsletter factice ; images de galerie avec chargement différé et décodage asynchrone ; navigation et actions converties en éléments clavier natifs ; script chargé avec `defer`. L’API renvoie uniquement les champs sources utiles, sans enrichissements non utilisés.

## Fichiers modifiés

- `app.js` : filtrage local après chargement, statistiques locales, suppression recommandations et des appels périodiques, boutons accessibles.
- `server.py` : réponse API sans champs calculés non utilisés ; cache HTTP autorisé à revalider (`no-cache`) au lieu de `no-store`.
- `index.html` : script différé, navigation sémantique, liens/boutons natifs, images avec texte alternatif ou décoratives et chargement différé, retrait du ticker et de la newsletter de démonstration.
- `styles.css` : vérifier/compléter les styles de focus et de boutons natifs si nécessaire (voir bilan ci-dessous).

## Vérifications à faire avant remise

- Démarrer `python server.py`, ouvrir localhost:8000, puis Network avec cache désactivé.
- Confirmer un seul GET `/api/products` au chargement, aucun appel catalogue pendant la saisie, aucun appel `/api/stats` périodique.
- Tester `rustine` (25 résultats), campus Rangueil (5), recherche multi-mots avec accents, combinaison catégorie + campus, reset, aucun résultat et erreur serveur.
- Ouvrir/fermer une fiche et vérifier description, lieu, date/heure, durée, tarif, organisateur et modalités.
- Tester au clavier et à 360 px.
- Comparer dans Network le transfert initial et les appels avant/après dans les mêmes conditions. Ne pas présenter ces observations comme une mesure d’énergie ou de CO₂.

## Limites et défauts préexistants

- Le fichier `hero.png` reste très lourd (≈ 8,7 Mo) ; une conversion en WebP/AVIF et une variante responsive seraient à étudier si le temps le permet.
- Le catalogue JSON source est d’environ 2 Mo. Un découpage/format plus compact ou pagination API pourrait réduire le transfert initial, mais il faut garantir la recherche globale sur toutes les sessions.
- L’affichage au clavier et à 360 px doit être testé dans le navigateur réel ; aucun audit complet d’accessibilité n’a été réalisé.
- La newsletter et les recommandations ont été retirées car elles sont simulées/secondaires dans ce TP. Toutes les fonctions obligatoires du catalogue restent prévues.
- Aucun chiffre d’énergie ni de CO₂ n’a été calculé.
