import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Moves {

    static class Position {
        int x, y;

        Position(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }

    static int N;
    static int[][] grid;
    static final int[] dx = {-1, -1, -1, 0, 0, 1, 1, 1};
    static final int[] dy = {-1, 0, 1, -1, 1, -1, 0, 1};
    static final String[] directions = {"NW", "N", "NE", "W", "E", "SW", "S", "SE"};

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java Moves <input_file>");
            return;
        }

        String filename = args[0];
        try {
            Scanner scanner = new Scanner(new File(filename));
            N = scanner.nextInt();
            grid = new int[N][N];
            for (int i = 0; i < N; i++) {
                for (int j = 0; j < N; j++) {
                    grid[i][j] = scanner.nextInt();
                }
            }
            scanner.close();

            String result = findShortestPath();
            System.out.println(result);

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    static String findShortestPath() {
        boolean[][] visited = new boolean[N][N];
        int[][] parentX = new int[N][N];
        int[][] parentY = new int[N][N];

        Queue<Position> queue = new LinkedList<>();
        queue.add(new Position(0, 0));
        visited[0][0] = true;

        while (!queue.isEmpty()) {
            Position current = queue.poll();

            if (current.x == N - 1 && current.y == N - 1) {
                return reconstructPath(parentX, parentY);
            }

            for (int i = 0; i < 8; i++) {
                int newX = current.x + dx[i];
                int newY = current.y + dy[i];
                if (isValid(newX, newY) && !visited[newX][newY] && grid[newX][newY] < grid[current.x][current.y]) {
                    visited[newX][newY] = true;
                    parentX[newX][newY] = current.x;
                    parentY[newX][newY] = current.y;
                    queue.add(new Position(newX, newY));
                }
            }
        }
        return "IMPOSSIBLE";
    }

    static String reconstructPath(int[][] parentX, int[][] parentY) {
        List<String> path = new ArrayList<>();
        int x = N - 1, y = N - 1;

        while (x != 0 || y != 0) {
            for (int i = 0; i < 8; i++) {
                int prevX = x - dx[i];
                int prevY = y - dy[i];
                if (isValid(prevX, prevY) && parentX[x][y] == prevX && parentY[x][y] == prevY) {
                    path.add(directions[i]);
                    x = prevX;
                    y = prevY;
                    break;
                }
            }
        }

        Collections.reverse(path);
        return "[" + String.join(",", path) + "]";
    }

    static boolean isValid(int x, int y) {
        return x >= 0 && x < N && y >= 0 && y < N;
    }
}