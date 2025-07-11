int cols, rows;
int cellSize = 10; //Adjust to the preferred size
Cells[][] grid;

Cells startCell = null;
Cells goalCell = null;
boolean pathFound = false;
ArrayList<Cells> path = new ArrayList<Cells>();

boolean firstClickDone = false;
int clickCount = 0;


void setup() {
  size(1000, 1000); //Adjust to the preferred size
  cols = width / cellSize;
  rows = height / cellSize;

  //Create grid using Cell class
  grid = new Cells[cols][rows];
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      grid[i][j] = new Cells(i, j);

  //Initialize all cells as non walkable walls
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      grid[i][j].walkable = false;

  //Generate maze
  int startX = int(random(cols / 2)) * 2 + 1;
  int startY = int(random(rows / 2)) * 2 + 1;
  generateMaze(startX, startY);
}


void draw() {
  background(255);
  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      grid[i][j].show();

  //Draw path only if successful
  if (pathFound)
    for (Cells c : path)
      c.showPath();

  //Draw start and goal cells with different colors only when generated
  if (startCell != null)
    startCell.showStart();
  if (goalCell != null)
    goalCell.showGoal();
}

/*
* MOUSE CLICK BEHAVIOUR
* First click: Randomize start/goal cell and draw them
* Second click: Search path
* Third click: Reset
*/


void mousePressed() {
  //Use Modulo to check click count
  if (clickCount % 3 == 0){
    //Randomize start and goal cells
    startCell = getRandomWalkableCell();
    goalCell = getRandomWalkableCell();
    while (goalCell == startCell) //Ensure start and end are set on different cells
      goalCell = getRandomWalkableCell();
    
    //Initialize path Lsit
    path.clear();
    pathFound = false;
    println("Start and Goal placed.");
  } else if (clickCount % 3 == 1) {
    //run A* to find the path
    path = aStar(startCell, goalCell);
    pathFound = true;
    println("A* pathfinding executed.");
  } else if (clickCount % 3 == 2) {
    //Reset start, goal, and path
    startCell = null;
    goalCell = null;
    path.clear();
    pathFound = false;
    println("Reset start/goal/path.");
  }
  
  clickCount++;
  redraw();
}


Cells getRandomWalkableCell() {
  Cells c;
  do {
    int x = int(random(cols));
    int y = int(random(rows));
    c = grid[x][y];
  } while (!c.walkable);
  return c;
}


//Recursive backtracking maze generator
void generateMaze(int x, int y) {
  grid[x][y].walkable = true;

  int[][] directions = {{0, -2}, {2, 0}, {0, 2}, {-2, 0}};
  directions = shuffleArray(directions);

  for (int[] dir : directions) {
    int nx = x + dir[0];
    int ny = y + dir[1];

    if (inBounds(nx, ny) && !grid[nx][ny].walkable) {
      grid[x + dir[0] / 2][y + dir[1] / 2].walkable = true;
      generateMaze(nx, ny);
    }
  }
}

boolean inBounds(int x, int y) {
  return x > 0 && x < cols - 1 && y > 0 && y < rows - 1;
}

int[][] shuffleArray(int[][] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = int(random(i + 1));
    int[] temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  return array;
}

//A* Pathfinding
ArrayList<Cells> aStar(Cells start, Cells goal) {
  ArrayList<Cells> openSet = new ArrayList<Cells>();
  ArrayList<Cells> closedSet = new ArrayList<Cells>();
  openSet.add(start);

  for (int i = 0; i < cols; i++)
    for (int j = 0; j < rows; j++)
      grid[i][j].reset();

  start.g = 0;
  start.h = heuristic(start, goal);
  start.f = start.g + start.h;

  while (openSet.size() > 0) {
    //Find lowest f
    Cells current = openSet.get(0);
    for (Cells c : openSet)
      if (c.f < current.f)
        current = c;

    if (current == goal) {
      //Reconstruct path
      ArrayList<Cells> path = new ArrayList<Cells>();
      Cells temp = current;
      while (temp != null) {
        path.add(temp);
        temp = temp.previous;
      }
      return path;
    }

    openSet.remove(current);
    closedSet.add(current);

    for (Cells neighbor : current.getNeighbors()) {
      if (!neighbor.walkable || closedSet.contains(neighbor))
          continue;

      float tempG = current.g + 1;
      boolean newPath = false;
      if (!openSet.contains(neighbor)) {
        openSet.add(neighbor);
        newPath = true;
      } else if (tempG < neighbor.g)
        newPath = true;

      if (newPath) {
        neighbor.g = tempG;
        neighbor.h = heuristic(neighbor, goal);
        neighbor.f = neighbor.g + neighbor.h;
        neighbor.previous = current;
      }
    }
  }

  return new ArrayList<Cells>(); //No path found
}

float heuristic(Cells a, Cells b) {
  return abs(a.x - b.x) + abs(a.y - b.y); //Manhattan distance
}


//Reset by pressing Spacebar
void keyPressed() {
  if (key == ' ') { //Spacebar pressed
    println("Regenerating maze...");
    regenerateMaze();
  }
}

void regenerateMaze() {
  //Clear grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].walkable = false;
    }
  }

  //Generate a new maze
  int startX = int(random(cols / 2)) * 2 + 1;
  int startY = int(random(rows / 2)) * 2 + 1;
  generateMaze(startX, startY);

  //Reset varibales
  startCell = null;
  goalCell = null;
  path.clear();
  pathFound = false;
  clickCount = 0;

  redraw();
}
