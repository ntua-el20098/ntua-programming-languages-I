#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <climits> // Include the <climits> header for INT_MAX

using namespace std;

class TreeNode {
public:
    int value;
    TreeNode* left;
    TreeNode* right;

    TreeNode(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Function to build the tree from the given nodes
TreeNode* buildTree(vector<int>& nodes, vector<int>::size_type& index) {
    if (index >= nodes.size() || nodes[index] == 0)
        return nullptr;

    TreeNode* node = new TreeNode(nodes[index]);
    node->left = buildTree(nodes, ++index);
    node->right = buildTree(nodes, ++index);
    return node;
}

int arrange(TreeNode* root) {
    // Base case: if the node is a leaf, return its value
    if (root->left == nullptr && root->right == nullptr)
        return root->value;

    // If only the left child exists
    else if (root->right == nullptr) {
        int minElement = arrange(root->left);

        // Check if swapping is needed
        if (root->value < minElement) {
            root->right = root->left;
            root->left = nullptr;
            return root->value;
        } else {
            return minElement;
        }
    }

    // If only the right child exists
    else if (root->left == nullptr) {
        int minElement = arrange(root->right);

        // Check if swapping is needed
        if (root->value > minElement) {
            root->left = root->right;
            root->right = nullptr;
            return minElement;
        } else {
            return root->value;
        }
    }

    // If both children exist
    int leftValue = arrange(root->left);
    int rightValue = arrange(root->right);

    // Swap children if necessary
    if (leftValue > rightValue) {
        TreeNode* temp = root->left;
        root->left = root->right;
        root->right = temp;
        return rightValue;
    } else {
        return leftValue;
    }
}

// Function to print the in-order traversal of the tree
void printInOrder(TreeNode* root) {
    if (root == nullptr)
        return;

    printInOrder(root->left);
    cout << root->value << " ";
    printInOrder(root->right);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        cout << "Usage: " << argv[0] << " <input_file_path>" << endl;
        return 1;
    }

    string inputFilePath = argv[1];
    ifstream file(inputFilePath);
    if (!file.is_open()) {
        cout << "Unable to open file: " << inputFilePath << endl;
        return 1;
    }

    vector<int> nodes;
    int number;
    while (file >> number) {
        nodes.push_back(number);
    }
    file.close();

    vector<int>::size_type index = 1; // Use vector<int>::size_type for index

    TreeNode* root = buildTree(nodes, index);

    // Perform swap operations to get lexicographically minimum sequence
    arrange(root);

    // Print the in-order traversal of the modified tree
    printInOrder(root);
    cout << endl;

    return 0;
}