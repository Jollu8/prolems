"""
Check whether a string is a palindrome using recursion.

Idea:
    Compare the first and last characters, then recurse on the inner substring.

Complexity:
    Time: O(n)
    Space: O(n)
"""


def is_palindrome(value: str) -> bool:
    if len(value) <= 1:
        return True
    if value[0] != value[-1]:
        return False
    return is_palindrome(value[1:-1])
