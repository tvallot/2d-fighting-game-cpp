# Assets

The sprites, stages and music used during development come from *Street Fighter III: 3rd Strike* (Capcom) and are not distributed with this repository. The game expects the following files, relative to the repository root:

| Path | Content |
|---|---|
| `data/images/fighters/dudleyAtlas.png`, `alexGimp.png` | Sprite atlases of the two fighters |
| `data/images/backgrounds/` | Stage backgrounds |
| `data/images/loading/Chargement1.png` ... `Chargement8.png` | Loading screen animation |
| `data/images/menu/Menu1.png` ... `Menu4.png` | Main menu (one image per selected item) |
| `data/images/selection/Atlas_CharacterSelection.png`, `BackGround_CharacterSelection.png` | Character selection screen |
| `data/images/overlay/overlay.png` | HUD (health bars, timer) |
| `data/kastagne.ttf` | Font |
| `data/music/introTheme.ogg` | Intro music |

The atlas coordinates and boxes of each animation frame are defined in [`src/core/fighter/Fighter.cpp`](../src/core/fighter/Fighter.cpp), so a replacement atlas has to follow the same layout.
