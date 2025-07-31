# Raccacoonie - GMTK Game Jam 2025 Submission

A top-down 2D game prototype created with Godot

## Features

- Top-down 2D movement with arrow keys or WASD
- Collectible items with score tracking
- Obstacles to navigate around

## Controls

- Move Up: W or Up Arrow
- Move Down: S or Down Arrow
- Move Left: A or Left Arrow
- Move Right: D or Right Arrow

## Getting Started

1. Clone this repository
2. Open the project in Godot 4.4 or later
3. Press F5 or click the Play button to run the game

## Project Structure

The project follows a topic-based organization:

```
/
├── entities/           # Game entities
│   ├── player/         # Player character files
│   └── collectibles/   # Collectible items
├── levels/             # Game levels/scenes
├── ui/                 # User interface elements
├── globals/            # Global scripts (AutoLoad)
└── assets/             # Raw asset files
```

### Key Files

- `entities/player/player.tscn` - The player character
- `entities/collectibles/collectible.tscn` - Collectible item
- `levels/game.tscn` - Main game scene
- `ui/game_ui.gd` - UI script for score tracking

Each directory contains a README.md with more specific information about its contents and usage.
