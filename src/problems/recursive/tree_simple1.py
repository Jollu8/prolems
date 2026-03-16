# 1. Создаем корень

root = {"data": "A", "children": []}

# 2. Добавляем B
B = {"data": "B", "children": []}
D = {"data": "D", "children": []}
B["children"].append(D)
root["children"].append(B)

# 3. Добавляем C
C = {"data": "C", "children": []}

# 3.1 C -> E
E = {"data": "E", "children": []}
G = {"data": "G", "children": []}
H = {"data": "H", "children": []}
E["children"].append(G)
E["children"].append(H)
C["children"].append(E)

# 3.2 C -> F
F = {"data": "F", "children": []}
C["children"].append(F)

# 3.3 Подвешиваем C к A
root["children"].append(C)


def preorderTraverse(node):
    print(node["data"], end=" ")  # Получение доступа к данным узла
    if len(node["children"]) > 0:
        # РЕКУРСИВНЫЙ СЛУЧАЙ
        for child in node["children"]:
            preorderTraverse(child)  # Обход дочерних узлов
        # БАЗОВЫЙ СЛУЧАЙ
    return


# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def maxDepth(root: TreeNode | None) -> int:
    if root is None:
        return 0
    if root.left is None and root.right is None:
        return 1

    left = 0
    right = 0
    if root.left:
        left = maxDepth(root.left)
    if root.right:
        right = maxDepth(root.right)
    return 1 + max(left, right)


def minDepth(root: TreeNode | None) -> int:
    if root is None:
        return 0
    if root.left is None and root.right is None:
        return 1
    left = 100
    right = 100
    if root.left:
        left = minDepth(root.left)
    if root.right:
        right = minDepth(root.right)
    return 1 + min(left, right)
