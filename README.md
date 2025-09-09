# NewsApp

---

## 1. Fonctionnalités Implémentées

*   Affichage de la liste des actualités françaises (titre et image).
*   Affichage de la vue de détail d'une actualité (titre, image, description, source).
*   Lien cliquable dans la vue de détail pour consulter l'article complet.
*   Gestion du mode sombre (Dark Mode).
*   Mise en cache des données pour une consultation hors-ligne basique.

---
## 2. Choix Techniques et Architecturaux

Cette version du projet affine l'architecture initiale pour adhérer plus strictement aux principes SOLID et aux meilleures pratiques de l'écosystème SwiftUI.

### Architecture Globale : Clean Architecture + MVVM + Coordinator 

*   **Clean Architecture :** Le projet conserve est conçu en trois couches (`Domain`, `Data`, `Presentation`), assurant une excellente séparation.

*   **Navigation 100% SwiftUI :** La navigation utiliser la stack native de SwiftUI.
    *   **`NavigationStack` & `NavigationPath` :** Le `AppCoordinator` gère un `NavigationPath` qui est lié à un `NavigationStack` dans la vue racine. Toute la navigation est programmatique, testable et découplée des vues.
    *   **`AppCoordinator` :** Le coordinateur centralise l'état de la navigation. Les vues lui demandent de naviguer vers une `Route`, et le coordinateur met à jour son `NavigationPath`, ce qui déclenche la mise à jour de l'UI par SwiftUI.

*   **Injection de Dépendances :**
    *   **`DIContainer` :** Un conteneur de dépendances a été mis en place pour centraliser la création et l'injection de tous les services, repositories, et use cases, rendant le code plus modulaire et facile à tester.

*   **Configuration Centralisée :**
    *   **`AppConstants.swift` :** Toutes les valeurs de configuration (URLs, clé API, valeurs par défaut) sont stockées dans un fichier unique pour facilite la maintenance.

### Stack Technique

*   **UI :** SwiftUI.
*   **Asynchronisme :** `async/await`.
*   **Networking :** `URLSession` natif avec `URLCache`.
*   **Tests :** Tests unitaires (TDD) pour `ViewModels`, `UseCases` et `Repositories`.

---

## 3. Problèmes non traités mais identifiés

Les points d'amélioration identifiés:
*   **Gestion Globale des Erreurs :** Actuellement, chaque `ViewModel` gère ses propres erreurs localement. Pour une application plus robuste, la gestion des erreurs pourrait être centralisée dans le `Coordinator`, qui serait responsable de présenter les erreurs à l'utilisateur de manière cohérente (par exemple, via une alerte unique).
*   **Pagination / Défilement infini :** L'application ne charge actuellement que la première page de résultats. L'ajout de la pagination permettrait de charger plus d'articles au fur et à mesure du défilement.
*   **Persistance avancée des données :** Le cache `URLCache` est utile pour un accès hors-ligne, mais une solution comme Core Data ou SwiftData offrirait une véritable base de données persistante.
*   **Cache des Images :** `AsyncImage` ne met pas en cache les images de manière agressive. Pour des performances optimales et une réduction de la consommation de données, l'implémentation d'un cache d'images dédié (en mémoire et sur disque), via une librairie comme `Kingfisher`, serait essentielle.
*   **Gestion sécurisée de la clé API :** La clé ne devrait pas être dans le code source. L'utilisation d'un fichier `.xcconfig` (ignoré par Git) est une pratique standard pour la gérer.
*   **Tests d'Interface Utilisateur (UI Tests) :** En complément des tests unitaires, des UI Tests permettraient de valider les parcours utilisateurs de bout en bout.
*   **Accessibilité :** Un audit complet garantirait une compatibilité parfaite avec les technologies d'assistance comme VoiceOver.

---
