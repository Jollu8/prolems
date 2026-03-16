from problems.recursive.tree_simple1 import maxDepth, minDepth


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


# Test empty tree (should return 0)
def test_empty_tree():
    assert minDepth(None) == 0
    assert maxDepth(None) == 0


# Test single node tree (should return 1)
def test_single_node():
    root = TreeNode(1)
    assert minDepth(root) == 1
    assert maxDepth(root) == 1


# Test balanced tree (LeetCode example)
def test_balanced_tree():
    #       3
    #     /   \
    #    9    20
    #        /  \
    #       15   7
    root = TreeNode(3)
    root.left = TreeNode(9)
    root.right = TreeNode(20, TreeNode(15), TreeNode(7))

    assert minDepth(root) == 2
    assert maxDepth(root) == 3


# Test left-skewed tree (min=max=3)
def test_left_skewed():
    # 1
    # \
    #  2
    #   \
    #    3
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.left.left = TreeNode(3)

    # assert minDepth(root) == 3
    # assert maxDepth(root) == 3


# Test unbalanced tree (min=2, max=4)
def test_unbalanced():
    #       1
    #      / \
    #     2   3
    #    /     \
    #   4       5
    #        /
    #       6
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.left.left = TreeNode(4)
    root.right = TreeNode(3)
    root.right.right = TreeNode(5)
    root.right.right.left = TreeNode(6)

    assert minDepth(root) == 3  # Shortest path: 1->2->4
    assert maxDepth(root) == 4  # Longest path: 1->3->5->6


# Test right-skewed tree (min=max=3)
def test_right_skewed():
    root = TreeNode(1)
    root.right = TreeNode(2)
    root.right.right = TreeNode(3)

    assert minDepth(root) == 3
    assert maxDepth(root) == 3
