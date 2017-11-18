#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Java documentation build configuration file, created by
# sphinx-quickstart on Fri Sep 29 15:00:41 2017.
#
# This file is execfile()d with the current directory set to its
# containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath


import os
profile = {}
if 'BUILD_PROFILE' in os.environ:
  import importlib
  profile = importlib.import_module('conf-%s' % os.environ['BUILD_PROFILE'])


# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.imgmath']

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
#
# source_suffix = ['.rst', '.md']
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = 'Le langage Java'
author = 'David Gayerie'
email = getattr(profile, 'email', 'dagaydevel@free.fr')

copyright = """
<a ref="author" href="mailto:%s">%s</a>
<a rel="license" href="https://creativecommons.org/licenses/by-sa/3.0/fr/"><img alt="Licence Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/3.0/fr/80x15.png" /></a>
""" % (email, author)

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = '1.0'
# The full version, including alpha/beta/rc tags.
release = '1.0'

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = 'fr'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This patterns also effect to html_static_path and html_extra_path
exclude_patterns = []

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = True


# -- Options for HTML output ----------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
html_theme_options = {
    'show_powered_by': False,
    'fixed_sidebar': False,
    'page_width': '75%',
    'sidebar_width': '25%',
    'font_family': '"Open Sans", sans-serif',
    'font_size': '12pt',
    'head_font_family': '"Quicksand", sans-serif',
    'extra_nav_links': {
        'API Java': 'http://docs.oracle.com/javase/8/docs/api/index.html?overview-summary.html',
        'Documentation Java': 'http://docs.oracle.com/javase/8/docs/',
    }
}

html_theme_options.update(getattr(profile, 'html_theme_options', {}))

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Custom sidebar templates, must be a dictionary that maps document names
# to template names.
#
# This is required for the alabaster theme
# refs: http://alabaster.readthedocs.io/en/latest/installation.html#sidebars
html_sidebars = {
    '**': [
        'about.html',
        'navigation.html',
        'searchbox.html',
    ]
}

html_copy_source = False

# -- Options for HTMLHelp output ------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = 'Javadoc'


# -- Options for LaTeX output ---------------------------------------------

latex_elements = {
    # The paper size ('letterpaper' or 'a4paper').
    #
    'papersize': 'a4paper',

    # The font size ('10pt', '11pt' or '12pt').
    #
    'pointsize': '11pt',
    
    # Additional stuff for the LaTeX preamble.
    #
    # 'preamble': '',

    # Latex figure (float) alignment
    #
    # 'figure_align': 'htbp',
    
    'sphinxsetup': 'TitleColor={rgb}{.1,.1,.1}, verbatimwithframe=false, VerbatimBorderColor={rgb}{.5,.5,.5}, verbatimsep=10pt, VerbatimColor={rgb}{.95,.95,.97}', 
}


# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, 'Java.tex', 'Le Langage Java',
     'David Gayerie', 'manual'),
]


# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, 'java', 'Java Documentation',
     [author], 1)
]


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (master_doc, 'Java', 'Apprentissage du langage Java',
     author, 'Java', 'Cours sur les fondamentaux du langage Java',
     'Langage de programmation'),
]

# default language for highlighting
highlight_language = 'java'
# replacement for ROOT_PKG in java source
highlight_root_package = getattr(profile, 'highlight_root_package', 'io.github.spoonless')

# Example configuration for intersphinx: refer to the Python standard library.
intersphinx_mapping = {'https://docs.python.org/': None}


def register_pygments_filter(highlight_language, root_package_name):
    from pygments.filter import simplefilter
    from pygments.token import Name

    @simplefilter
    def replace_root_package_filter(self, lexer, stream, options):
        for ttype, value in stream:
            if (ttype is Name or ttype is Name.Namespace) and value.startswith("ROOT_PKG"):
                value = value.replace("ROOT_PKG", root_package_name)
            yield ttype, value

    from pygments.lexers import get_lexer_by_name
    from sphinx.highlighting import lexers
    javaLexer = get_lexer_by_name(highlight_language, tabsize=0)
    javaLexer.add_filter(replace_root_package_filter())
    lexers[highlight_language] = javaLexer

register_pygments_filter(highlight_language, highlight_root_package)

rst_epilog = """
.. |ROOT_PKG| replace:: *%s*
""" % highlight_root_package
