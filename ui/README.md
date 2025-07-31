# UI

This directory contains all user interface elements and related scripts.

## Files

- `game_ui.gd` - Script that handles the game UI, including score tracking

## Usage

The UI elements are typically added to game scenes as CanvasLayer nodes. The `game_ui.gd` script connects to collectibles to track the score and update the UI accordingly.

## Adding New UI Elements

When adding new UI elements:

1. Create new scripts in this directory
2. For complex UI components, consider creating separate scenes
3. Use CanvasLayer nodes to ensure UI elements are displayed correctly regardless of camera position