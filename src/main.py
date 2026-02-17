"""Main utilities module."""

from __future__ import annotations


def add(a: int, b: int) -> int:
    """
    Add two integers.

    This function computes the sum of two integers and
    demonstrates NumPy-style formatting.

    Parameters
    ----------
    a : int
        First integer to add.
    b : int
        Second integer to add.

    Returns
    -------
    int
        Sum of ``a`` and ``b``.

    Examples
    --------
    >>> add(2, 3)
    5
    >>> add(-1, 1)
    0
    >>> add(0, 0)
    0
    """
    return a + b
