class Cells {
  int x, y;
  boolean walkable;
  float f, g, h;
  Cells previous;

  Cells(int x, int y) {
    this.x = x;
    this.y = y;
    this.walkable = false;
  }

  void reset() {
    f = g = h = 0;
    previous = null;
  }

  void show() {
    if (walkable) {
      fill(255);
    } else {
      fill(0);
    }
    stroke(50);
    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }

  void showStart() {
    fill(255, 0, 0);
    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }

  void showGoal() {
    fill(0, 255, 0);
    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }

  void showPath() {
    fill(0, 0, 255);
    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }

  ArrayList<Cells> getNeighbors() {
    ArrayList<Cells> neighbors = new ArrayList<Cells>();
    int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    for (int[] dir : dirs) {
      int nx = x + dir[0];
      int ny = y + dir[1];
      if (inBounds(nx, ny)) {
        neighbors.add(grid[nx][ny]);
      }
    }
    return neighbors;
  }
}
