# Cahier des charges — RIHLA (open world navigateur)

> Document de cadrage du projet. **Version 0.1 — sans histoire scénarisée : priorité à l'open world vivant.**

---

## 1. Contexte & vision

**Rihla** est un jeu **open world dans le désert** jouable **directement dans le navigateur**, sans téléchargement. On y incarne un cavalier qui explore un désert vivant : dunes, médina, oasis, campements, caravanes. Le ton est contemplatif et atmosphérique, dans l'esprit de *Red Dead Redemption* (errance à cheval, monde vivant) et *Zelda* (exploration, intérieurs), mais en **stylisé/pixel**, à échelle d'un jeu indépendant.

**Objectif actuel :** un **bac à sable** crédible et agréable, **sans histoire** pour l'instant. La narration viendra plus tard.

---

## 2. Public & plateforme

| Élément | Cible |
|---|---|
| Plateforme | Web (WebGL), desktop + mobile |
| Moteur | Three.js (mono-fichier + assets GLB) |
| Rendu | **Pixel/low-poly** : basse résolution rendue puis agrandie (nearest-neighbor) |
| Entrée | Clavier (AZERTY/QWERTY), souris, tactile, joystick |
| Installation | Aucune — un lien suffit |

---

## 3. Boucle de jeu principale

1. **Explorer** le désert à cheval ou à pied.
2. **Entrer dans les bâtiments**, ouvrir les portes.
3. **Interagir** avec les PNJ (parler, acheter, recevoir une quête légère).
4. **Découvrir** des lieux, ramasser des objets.
5. **Revenir** au camp, se reposer, sauvegarder.

> Pas d'objectif narratif imposé : le joueur se fixe ses propres buts (exploration, découverte, petites missions).

---

## 4. Monde ouvert

### Zones
- **Dunes** (espace principal, journée/nuit, vent).
- **Médina** : souk, casbah, ruelles, place, fontaine.
- **Oasis** (eau, palmiers).
- **Hameau** (maisons, puits).
- **Passage en ruine** (porte monumentale).
- **Campement** + **caravane** animée.

### Vie du monde
- **Cycle jour/nuit** (déjà en place) : étoiles, lune, nuages à l'horizon.
- **Vent** et volutes de sable (déjà en place).
- **PNJ** qui vaquent, marchands, guides.
- **Points d'intérêt** + **minimap**.

---

## 5. Personnages

### Joueur
- Le cavalier **Rihla** : 3ᵉ personne, monte/descend de cheval, marche, court, galope.
- **Visage 3D** (voir ci-dessous).

### PNJ
- Marchands, villageois, guide de caravane, conteur.
- Comportements simples : se déplacer, s'arrêter, regarder le joueur, parler.

### 👤 Visages 3D — **pas de textures PNG**
Contrainte : les visages sont **de la géométrie 3D**, pas des images plaquées (pas de PNG de visage).
- **Tête low-poly** : yeux (sphères/creux), nez, bouche, sourcils, barbe/voile, oreilles.
- **Paramétrique** : variantes générées (teint, forme du nez, barbe, voile, coiffe).
- Budget : **~500 à 1 500 triangles** par tête.
- Deux approches possibles :
  1. **Procédural** (généré en code, cohérent avec le style actuel) ;
  2. **Modèles GLB** stylisés (Quaternius, Mixamo retravaillé).
- Le visage doit rester **lisible en pixel** (formes simples, contrastes).

---

## 6. Intérieurs, portes & interactions

### Bâtiments entrables
- Certains bâtiments ont une **porte fonctionnelle**.
- **Porte animée** : ouverture/fermeture (rotation), son, collision.
- **Transition extérieur → intérieur** : fondu/chargement d'une pièce dédiée, retour à la sortie.

### Intérieurs
- Pièces meublées : **souk**, **maison**, **écurie**, **tente**.
- PNJ à l'intérieur, objets interactifs.
- Chargés **à la demande** (ne pas tout garder en mémoire).

### Système d'interaction
- **Détection de proximité** autour du joueur.
- **Prompt contextuel** : « E — Entrer », « E — Parler », « E — Ouvrir », « E — Ramasser ».
- Actions : entrer/sortir, ouvrir/fermer une porte, parler, ramasser, s'asseoir, boire le thé.
- **Priorité** à l'action la plus proche du regard.

---

## 7. Systèmes techniques

### Cheval
- Modèle riggé/animé (fait : `Horse.glb`, clips Gallop/Walk/Idle).
- **Endurance** (le galop consomme, recharge au pas) — à venir.
- Montée/descente, transitions d'allures.

### Audio
- Sabots (par allure), vent/sable, ambiance nuit, pièces, portes, voix simples.
- Musique discrète d'ambiance.

### Interface (UI)
- HUD : objectif courant, prompt d'interaction, compteur.
- **Minimap** (déjà là).
- Menus (démarrer, régler, quitter).

### Sauvegarde
- `localStorage` : position, pièces, lieux découverts, réglages.

---

## 8. Direction artistique

- **Pixel/low-poly**, palette désert : sable chaud, ocre, nuit bleu-indigo, lune blanc-bleu, nuages violets.
- Cohérence : **tout procédural ou GLB stylisé**, pas de photo-réalisme.
- Le **rendu pixel** (basse résolution) est un choix esthétique assumé, pas une contrainte.

---

## 9. Périmètre

### ✅ Dans le périmètre
- Exploration libre, cheval, PNJ, bâtiments entrables, portes, interactions.
- Collectibles, missions légères, audio, sauvegarde, cycle jour/nuit.

### ❌ Hors périmètre (pour l'instant)
- Histoire scénarisée / cinématiques.
- Combat (armes, dégâts).
- Multijoueur.
- Rendu photoréaliste / UE5.

---

## 10. Jalons (proposition)

| Jalon | Contenu |
|---|---|
| **J1 — Visages & PNJ** | Têtes 3D low-poly, PNJ variés, comportements de base. |
| **J2 — Interactions** | Système de proximité, prompt, actions contextuelles. |
| **J3 — Intérieurs** | Premiers bâtiments entrables + portes animées. |
| **J4 — Ambiance** | Audio (sabots, vent, portes) + caméra cinématique. |
| **J5 — Contenu** | Missions légères, collectibles, sauvegarde complète. |

---

## 11. Contraintes & bonnes pratiques

- **Budget poly** maîtrisé (mobile) ; **LOD** et **instancing**.
- **Compression GLB** (Draco) + textures légères.
- Cible **60 fps** desktop, fallback mobile.
- Code maintenable : découper le mono-fichier à terme.

---

## 12. Indicateurs de réussite (à terme)

- Le joueur peut **errer 5 minutes** sans s'ennuyer.
- Il peut **entrer dans au moins 3 bâtiments** et **interagir** avec 3 PNJ.
- Le monde reste **fluide** sur un laptop récent.
