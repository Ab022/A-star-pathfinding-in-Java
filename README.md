# A-star-pathfinding-in-Java

This is a simple **A* pathfinding** visualization created for an exam project. It’s a stripped-down version of the original game project, **Alone Outside**, which you can check out on Itch.io:
# 🎮 https://ab0-22.itch.io/alone-outside

This demo shows how A* works in a randomly generated maze using **Processing 4** (v4.4.4).

The repository includes:
**sketch.properties**: Contains metadata so Processing can recognize the folder as a valid sketch.
**Main.pde**: Handles the logic to generate the maze (using recursive backtracking). place start and goal cells, run the A* algorithm to find a path, handle mouse and keyboard input.
**Cell.pde**: Defines the Cells class, which represents each grid tile and includes methods for drawing, pathfinding, and neighbor handling.

**Controls**
Left Mouse Button Clicks:
1️⃣ **First click** → Place start (red) & goal (green) cells randomly in walkable tiles.
2️⃣ **Second click** → Run A* and visualize the path (blue).
3️⃣ **Third click** → Reset start/goal/path but keep the same maze.
Keyboard:
⬜️ **SPACE** → Regenerate a new random maze.

**Features**
✅ Random maze generation.
✅ Visual A* pathfinding between start and goal.
✅ Interactive controls for exploring different configurations.

**Requirements**
Processing, available here: https://processing.org/download
