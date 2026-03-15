def ackermann(m, n, ind=None):
    if ind is None:
        ind = 0
    if m == 0:
        return n + 1
    elif m > 0 and n == 0:
        return ackermann(m - 1, 1, ind + 1)
    elif m > 0 and n > 0:
        return ackermann(m - 1, ackermann(m, n - 1, ind + 1), ind + 1)
