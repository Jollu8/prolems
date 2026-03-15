import pytest

from problems.recursive.simple1 import concat, product


@pytest.mark.parametrize(
    ("s1", "s2", "res"),
    [
        ("hello", "world", "helloworld"),
        ("Hello", "World", "HelloWorld"),
        ("This Pythond", " lang is Python", "This Pythond lang is Python"),
    ],
)
def test_concat(s1, s2, res):
    assert concat(s1, s2) == res


@pytest.mark.parametrize(
    ("arr", "res"),
    [
        ([4, 5], 20),
        ([1, 2, 3, 4], 24),
        ([5, 5, 5, 1], 125),
    ],
)
def test_product(arr, res):
    assert product(arr) == res
