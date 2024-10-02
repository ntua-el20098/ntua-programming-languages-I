import java.io.*;
import java.util.*;

class TreeNode {
    int value;
    TreeNode left;
    TreeNode right;

    TreeNode(int val) {
        value = val;
        left = null;
        right = null;
    }
}

public class TreeArrange {
    
    // Function to build the tree from the given nodes
    static TreeNode buildTree(List<Integer> nodes, int[] index) {
        if (index[0] >= nodes.size() || nodes.get(index[0]) == 0)
            return null;

        TreeNode node = new TreeNode(nodes.get(index[0]));
        index[0]++;
        node.left = buildTree(nodes, index);
        index[0]++;
        node.right = buildTree(nodes, index);
        return node;
    }

    static int arrange(TreeNode root) {
        // Base case: if the node is a leaf, return its value
        if (root.left == null && root.right == null)
            return root.value;

        // If only the left child exists
        else if (root.right == null) {
            int minElement = arrange(root.left);

            // Check if swapping is needed
            if (root.value < minElement) {
                root.right = root.left;
                root.left = null;
                return root.value;
            } else {
                return minElement;
            }
        }

        // If only the right child exists
        else if (root.left == null) {
            int minElement = arrange(root.right);

            // Check if swapping is needed
            if (root.value > minElement) {
                root.left = root.right;
                root.right = null;
                return minElement;
            } else {
                return root.value;
            }
        }

        // If both children exist
        int leftValue = arrange(root.left);
        int rightValue = arrange(root.right);

        // Swap children if necessary
        if (leftValue > rightValue) {
            TreeNode temp = root.left;
            root.left = root.right;
            root.right = temp;
            return rightValue;
        } else {
            return leftValue;
        }
    }

    // Function to print the in-order traversal of the tree
    static void printInOrder(TreeNode root) {
        if (root == null)
            return;

        printInOrder(root.left);
        System.out.print(root.value + " ");
        printInOrder(root.right);
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java TreeArrange <input_file_path>");
            return;
        }

        String inputFilePath = args[0];
        List<Integer> nodes = new ArrayList<>();

        try (Scanner fileScanner = new Scanner(new File(inputFilePath))) {
            while (fileScanner.hasNextInt()) {
                nodes.add(fileScanner.nextInt());
            }
        } catch (FileNotFoundException e) {
            System.out.println("Unable to open file: " + inputFilePath);
            return;
        }

        int[] index = {1}; // Use an array to mimic pass-by-reference

        TreeNode root = buildTree(nodes, index);

        // Perform swap operations to get lexicographically minimum sequence
        arrange(root);

        // Print the in-order traversal of the modified tree
        printInOrder(root);
        System.out.println();
    }
}