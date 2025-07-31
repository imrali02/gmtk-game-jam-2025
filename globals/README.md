# Globals

This directory contains global scripts and resources that are accessible throughout the game.

## Usage

Global scripts should be registered as AutoLoad in the Godot project settings. This makes them accessible from any script in the project without needing to be explicitly referenced.

## Adding New Global Scripts

When adding new global scripts:

1. Create a new script in this directory
2. Register it as an AutoLoad in Project > Project Settings > AutoLoad
3. Give it a meaningful name that reflects its purpose

## Examples of Global Scripts

- Game state management
- Audio management
- Input management
- Save/load systems
- Event bus for communication between scenes
