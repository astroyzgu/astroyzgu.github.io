# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
#sys.path.insert(0, os.path.abspath('..'))
#sys.path.insert(0, os.path.abspath('../path/to/yourcode/'))
sys.path.insert(0, os.path.abspath('../src')) 
#sys.path.insert(0, os.path.abspath('../py/mypackage')) 

#sys.path.insert(0, os.path.abspath('../src/myproject')) 

#sys.path.append(os.path.abspath('..'))
#$ import myst_parser
from sphinx.application import Sphinx
from sphinx.util.docutils import SphinxDirective

# -- Project information -----------------------------------------------------

project = 'csstmock'
copyright = '2022, 0.0.0'
author = 'Gu Yizhou'

# The full version, including alpha/beta/rc tags
release = '0.0.0'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['myst_parser', 
              'sphinx.ext.autodoc',
'sphinx_math_dollar', 
'sphinx.ext.mathjax', 
'sphinx.ext.napoleon',
'sphinx.ext.viewcode']



#source_suffix = ['.rst', '.md'] 
#from markdown_it import MarkdownIt
#md = MarkdownIt("commonmark").enable('table')

source_suffix = {'.rst':'restructuredtext', '.md': 'markdown', }
myst_enable_extensions = ["dollarmath", "amsmath"] 
myst_dmath_double_inline= True  
myst_dmath_allow_labels = False 
myst_dmath_allow_space  = False  
myst_dmath_allow_digits = True  

mathjax_config = {
    'tex2jax': {
        'inlineMath': [ ["\\(","\\)"] ],
        'displayMath': [["\\[","\\]"] ],
    },
}

mathjax3_config = {
  "tex": {
    "inlineMath": [['\\(', '\\)']],
    "displayMath": [["\\[", "\\]"]],
  }
}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = []
 