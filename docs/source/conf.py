"""Module containing sphinx config."""

import os
import sys

sys.path.insert(
    0,
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "..", "src")
    ),
)

project = "docker-spark"
copyright = "2026, Christian Wolf"
author = "Christian Wolf"
release = "0.1.0"

extensions = [
    "sphinx.ext.napoleon",  # NumPy docstring parser
    "sphinx.ext.autodoc",  # (recommended for later API docs)
]

# Force pure NumPy style
napoleon_google_docstring = False
napoleon_numpy_docstring = True

templates_path = ["_templates"]
exclude_patterns = []

html_theme = "alabaster"
html_static_path = ["_static"]
