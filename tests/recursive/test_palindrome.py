import pytest

from problems.recursive.palindrome import is_palindrome


@pytest.mark.parametrize(
    ("value", "expected"),
    [
        ("", True),
        ("a", True),
        ("abba", True),
        ("abcba", True),
        ("abca", False),
    ],
)
def test_is_palindrome(value: str, expected: bool) -> None:

    assert is_palindrome(value) is expected
