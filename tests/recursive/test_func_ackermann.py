import pytest

from problems.recursive.func_ackermann import ackermann


@pytest.mark.parametrize(
    ("m", "n", "res"),
    [
        (1, 1, 3),
        (2, 3, 9),
        (3, 5, 253),
    ],
)
def test_ackermann(m, n, res):
    assert ackermann(m, n) == res
