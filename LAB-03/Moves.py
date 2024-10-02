import sys
from collections import deque

class Position:
    def __init__(self, x, y):
        self.x = x
        self.y = y

def find_shortest_path(N, grid):
    dx = [-1, -1, -1, 0, 0, 1, 1, 1]
    dy = [-1, 0, 1, -1, 1, -1, 0, 1]
    directions = ["NW", "N", "NE", "W", "E", "SW", "S", "SE"]

    visited = [[False] * N for _ in range(N)]
    parentX = [[-1] * N for _ in range(N)]
    parentY = [[-1] * N for _ in range(N)]

    q = deque([Position(0, 0)])
    visited[0][0] = True

    while q:
        current = q.popleft()

        if current.x == N - 1 and current.y == N - 1:
            return reconstruct_path(parentX, parentY, directions, dx, dy)

        for i in range(8):
            newX, newY = current.x + dx[i], current.y + dy[i]
            if 0 <= newX < N and 0 <= newY < N and not visited[newX][newY] and grid[newX][newY] < grid[current.x][current.y]:
                visited[newX][newY] = True
                parentX[newX][newY] = current.x
                parentY[newX][newY] = current.y
                q.append(Position(newX, newY))

    return "IMPOSSIBLE"

def reconstruct_path(parentX, parentY, directions, dx, dy):
    path = []
    x, y = len(parentX) - 1, len(parentY) - 1

    while x != 0 or y != 0:
        for i in range(8):
            prevX, prevY = x - dx[i], y - dy[i]
            if 0 <= prevX < len(parentX) and 0 <= prevY < len(parentY) and parentX[x][y] == prevX and parentY[x][y] == prevY:
                path.append(directions[i])
                x, y = prevX, prevY
                break

    path.reverse()
    return "[" + ",".join(path) + "]"

def main():
    if len(sys.argv) != 2:
        print("Usage: python moves.py <input_file>")
        return

    filename = sys.argv[1]
    try:
        with open(filename) as file:
            N = int(file.readline().strip())
            grid = [list(map(int, file.readline().strip().split())) for _ in range(N)]

        result = find_shortest_path(N, grid)
        print(result)

    except FileNotFoundError:
        print(f"File {filename} not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()