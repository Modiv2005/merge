// script.js
const gridSize = 4;
const grid = document.getElementById("grid");

const items = ["🍎", "🍌", "🍇"]; // You can define more levels

function createGrid() {
  for (let i = 0; i < gridSize * gridSize; i++) {
    const cell = document.createElement("div");
    cell.classList.add("cell");
    cell.dataset.index = i;

    cell.addEventListener("dragover", (e) => e.preventDefault());
    cell.addEventListener("drop", handleDrop);

    grid.appendChild(cell);
  }

  // Spawn 2 random items
  spawnRandomItem();
  spawnRandomItem();
}

function spawnRandomItem() {
  const emptyCells = [...document.querySelectorAll(".cell")].filter(
    (cell) => cell.children.length === 0
  );

  if (emptyCells.length === 0) return;

  const randCell = emptyCells[Math.floor(Math.random() * emptyCells.length)];
  const item = createItem(0);
  randCell.appendChild(item);
}

function createItem(level) {
  const item = document.createElement("div");
  item.classList.add("item");
  item.setAttribute("draggable", true);
  item.dataset.level = level;
  item.textContent = items[level];

  item.addEventListener("dragstart", (e) => {
    e.dataTransfer.setData("text/plain", JSON.stringify({
      level: item.dataset.level,
      from: item.parentElement.dataset.index
    }));
  });

  return item;
}

function handleDrop(e) {
  const data = JSON.parse(e.dataTransfer.getData("text/plain"));
  const sourceCell = document.querySelector(`[data-index="${data.from}"]`);
  const draggedItem = sourceCell.querySelector(".item");
  const targetCell = e.currentTarget;

  if (targetCell === sourceCell) return;

  const targetItem = targetCell.querySelector(".item");

  if (!targetItem) {
    targetCell.appendChild(draggedItem);
  } else if (targetItem.dataset.level === draggedItem.dataset.level) {
    const newLevel = parseInt(draggedItem.dataset.level) + 1;

    if (newLevel < items.length) {
      const newItem = createItem(newLevel);
      targetCell.innerHTML = "";
      targetCell.appendChild(newItem);
    } else {
      targetCell.innerHTML = ""; // Max level
    }

    sourceCell.innerHTML = "";
  }

  spawnRandomItem(); // Spawn new item after move
}

createGrid();
