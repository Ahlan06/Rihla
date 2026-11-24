# Cahier des charges — RIHLA (open world + parkour & infiltration)

> Document de cadrage. **Version 0.2 — sans histoire scénarisée : priorité à l'open world et aux systèmes.**

---

## 1. Contexte & vision

**Rihla** est un jeu **open world dans le désert** jouable **directement dans le navigateur**, sans téléchargement. On y incarne un cavalier agile qui explore un désert vivant (dunes, médina, oasis, campements, caravanes) et qui se déplace aussi **à pied, en parkour**, pour infiltrer les zones gardées.

La vision **fusionne deux inspirations** :

- **Red Dead Redemption** — errance posée à cheval, monde vivant, atmosphère, PNJ, intérieurs.
- **Assassin's Creed** — parkour, toits, escalade, infiltration, gardes, Vision d'aigle.

Le tout en **stylisé/pixel**, à échelle d'un jeu indépendant. **Pas d'histoire** pour l'instant : on construit d'abord le monde, les déplacements et les systèmes.

---

## 2. Public & plateforme

| Élément | Cible |
|---|---|
| Plateforme | Web (WebGL), desktop + mobile |
| Moteur | Three.js (mono-fichier → modules + assets GLB) |
| Rendu | **Pixel/low-poly** : basse résolution rendue puis agrandie (nearest-neighbor) |
| Entrée | Clavier (AZERTY/QWERTY), souris, tactile, joystick |
| Installation | Aucune — un lien suffit |

---

## 3. Boucle de jeu principale

1. **Explorer** le désert à cheval ou à pied.
2. **Se déplacer en parkour** : escalader murs, échelles, corniches, toits.
3. **Infiltrer** les zones gardées (discrétion, couverts, Vision d'aigle).
4. **Entrer dans les bâtiments**, ouvrir les portes.
5. **Interagir** avec les PNJ (parler, acheter, quête légère).
6. **Découvrir**, ramasser des objets, petites missions.
7. **Revenir** au camp, se reposer, sauvegarder.

> Pas d'objectif narratif imposé : le joueur se fixe ses propres buts (exploration, infiltration, découverte).

---

## 4. Monde ouvert

### Zones
- **Dunes** (espace principal, jour/nuit, vent).
- **Médina** : souk, casbah, ruelles, place, fontaine.
- **Oasis** (eau, palmiers).
- **Hameau** (maisons, puits).
- **Passage en ruine** (porte monumentale).
- **Campement** + **caravane** animée.

### Verticalité (parkour)
- **Toits praticables**, corniches, échelles, balcons, passages.
- Points d'escalade identifiables ; **sauts de la foi** (descente contrôlée depuis un point haut).

### Vie du monde
- **Cycle jour/nuit** (déjà en place) : étoiles, lune, nuages à l'horizon.
- **Vent** et volutes de sable (déjà en place).
- **PNJ** qui vaquent, marchands, guides, **gardes en patrouille**.
- **Points d'intérêt** + **minimap**.

---

## 5. Personnages

### Joueur
- **Rihla** : 3ᵉ personne, cheval, marche, course, **parkour**, discrétion.
- **Visage 3D** (voir ci-dessous).

### Gardes (IA)
- **Patrouilles** et **machines à états** : Patrouille → Soupçon → Alerte → Combat.
- **Champ de vision**, raycasts, **NavMesh** pour contourner les bâtiments et poursuivre sur les toits.

### PNJ
- Marchands, villageois, guide de caravane, conteur.
- Comportements simples : se déplacer, s'arrêter, regarder le joueur, parler.

### 👤 Visages 3D — **pas de textures PNG**
Contrainte : les visages sont **de la géométrie 3D**, pas des images plaquées (pas de PNG de visage).
- **Tête low-poly** : yeux (sphères/creux), nez, bouche, sourcils, barbe/voile, oreilles.
- **Paramétrique** : variantes générées (teint, forme du nez, barbe, voile, coiffe).
- Budget : **~500 à 1 500 triangles** par tête.
- Deux approches : **procédural** (généré en code) ou **GLB stylisés**.
- Le visage doit rester **lisible en pixel** (formes simples, contrastes).

---

## 6. Parkour & infiltration

### Parkour
- **Escalade** (murs, toits), **saut de rebord**, **roulade**, **sauts de la foi**.
- Géré par un **Kinematic Character Controller** (Rapier) : pentes, marches, sauts, raycasts de rebords.

### Infiltration
- **Discrétion** : accroupi, couverts, bruit, détection par les gardes.
- **Vision d'aigle** : surligne cibles / gardes / objets (filtre post-traitement).
- **Caches** et chemins alternatifs (toits, fenêtres, ruelles).

### Combat léger
- **Parade**, **esquive**, attaque simple.
- **Gadgets** : fumigène (fumée/particules).

---

## 7. Intérieurs, portes & interactions

### Bâtiments entrables
- Certains bâtiments ont une **porte fonctionnelle**.
- **Porte animée** : ouverture/fermeture (rotation), son, collision.
- **Transition extérieur → intérieur** : fondu/chargement d'une pièce dédiée, retour à la sortie.

### Intérieurs
- Pièces meublées : **souk**, **maison**, **écurie**, **tente**.
- PNJ à l'intérieur, objets interactifs.
- Chargés **à la demande**.

### Système d'interaction
- **Détection de proximité** autour du joueur.
- **Prompt contextuel** : « E — Entrer », « E — Parler », « E — Ouvrir », « E — Ramasser », « E — Escalader ».
- Actions : entrer/sortir, ouvrir/fermer, parler, ramasser, s'asseoir, boire le thé.
- **Priorité** à l'action la plus proche du regard.

---

## 8. Systèmes techniques

### Cheval
- Modèle riggé/animé (fait : `Horse.glb`, clips Gallop/Walk/Idle).
- **Endurance** (le galop consomme, recharge au pas).
- Montée/descente, transitions d'allures.

### Parkour & physique
- **Rapier** (Kinematic Character Controller) : pentes, marches, sauts, rebords.

### IA & foules
- **yuka** (FSM gardes, foule, évitement) + **NavMesh** (`three-pathfinding` / `recast-navigation-js`).

### Audio
- Sabots, vent/sable, ambiance nuit, portes, pièces, pas des gardes, voix.
- **Spatialisation 3D** (howler).

### Interface (UI)
- HUD : objectif, prompt d'interaction, compteur, **indicateur de détection**.
- **Minimap** (déjà là).
- Menus (démarrer, régler, quitter).

### Sauvegarde
- `localStorage` : position, pièces, lieux découverts, réglages.

---

## 9. Direction artistique

- **Pixel/low-poly**, palette désert : sable chaud, ocre, nuit bleu-indigo, lune blanc-bleu, nuages violets.
- Cohérence : **tout procédural ou GLB stylisé**, pas de photo-réalisme.
- Le **rendu pixel** (basse résolution) est un choix esthétique assumé.
- La **Vision d'aigle** a une DA dédiée (teinte désaturée, silhouettes surlignées).

---

## 10. Périmètre

### ✅ Dans le périmètre
- Open world, cheval, **parkour**, **infiltration**, **gardes**, intérieurs/portes, interactions.
- **Combat léger** et **gadgets**, Vision d'aigle, collectibles, audio, sauvegarde, cycle jour/nuit.

### ❌ Hors périmètre (pour l'instant)
- Histoire scénarisée / cinématiques.
- Multijoueur.
- Rendu photoréaliste / UE5.

---

## 11. Jalons (proposition)

| Jalon | Contenu |
|---|---|
| **J1 — Parkour & physique** | Rapier + camera-controls, escalade, sauts, toits. |
| **J2 — Gardes & infiltration** | yuka, NavMesh, champ de vision, Vision d'aigle. |
| **J3 — Intérieurs & portes** | Bâtiments entrables, portes animées, transitions. |
| **J4 — Combat & gadgets** | Parade, esquive, fumigène, particules. |
| **J5 — Ambiance & contenu** | Audio spatialisé, sauvegarde, missions légères, collectibles. |

---

## 12. Contraintes & bonnes pratiques

- **Budget poly** maîtrisé (mobile) ; **LOD** et **instancing**.
- **Compression GLB** (Draco) + textures légères.
- Cible **60 fps** desktop, fallback mobile.
- Code maintenable : découper le mono-fichier en modules (Vite/TS).

---

## 13. Stack technique recommandée (à adopter progressivement)

> Le démo actuel est un fichier unique en Three.js vanilla. Les bibliothèques ci-dessous sont la **cible** pour passer à un vrai jeu structuré — adoption **incrémentale**.

### 13.1 Rendu 3D & caméra
- **three** — cœur du rendu : modèles glTF, lumières, ombres, `AnimationMixer`.
- **camera-controls** — caméra 3ᵉ personne fluide avec **collisions automatiques contre les murs** (évite que la caméra ne traverse les bâtiments).
- **postprocessing (pmndrs)** — post-traitement nettement plus rapide que le natif : motion blur, SMAA, bloom, filtre « Vision d'aigle ».

### 13.2 Physique & déplacements (parkour)
- **@dimforge/rapier3d-compat** — moteur physique WebAssembly ; **Kinematic Character Controller** intégré (pentes, marches, sauts, raycasts de rebords, parkour).

### 13.3 IA & foules
- **yuka** — IA de jeu : machines à états finis (Patrouille → Soupçon → Alerte → Combat), comportements de foule, évitement d'obstacles.
- **three-pathfinding** ou **recast-navigation-js** — génération de **NavMesh** sur la ville pour que les gardes contournent les bâtiments et montent sur les toits.

### 13.4 Audio & effets spéciaux
- **howler** — audio fiable avec **spatialisation 3D** (pas des gardes, voix de la foule, direction d'un sifflement).
- **three-nebula** — moteur de particules : poussière de saut, fumée, étincelles.

### 13.5 Architecture & outils (recommandé)
- **vite + typescript** — dev ultra-rapide + typage strict (indispensable au-delà de quelques milliers de lignes).
- **bitecs** ou **miniplex** — ECS performant pour gérer des centaines de PNJ sans ralentir le navigateur.

### 13.6 Principe d'adoption
1. Aujourd'hui : fichier unique `demo-3d/index.html`.
2. Étape 1 : extraire en modules + **Vite/TS**.
3. Étape 2 : ajouter **Rapier** (physique) + **camera-controls**.
4. Étape 3 : **yuka/NavMesh** + audio spatialisé + particules.
5. Étape 4 : **ECS** si le nombre de PNJ explose.

---

## 14. Indicateurs de réussite (à terme)

- Le joueur peut **errer 5 minutes** sans s'ennuyer.
- Il peut **escalader jusqu'à un toit** et **sauter de la foi**.
- Il peut **infiltrer une zone gardée** sans être repéré.
- Il peut **entrer dans au moins 3 bâtiments** et **interagir** avec 3 PNJ.
- Le monde reste **fluide** sur un laptop récent.
