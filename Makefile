# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = python -msphinx
SPHINXPROJ    = Java
SOURCEDIR     = source
BUILDDIR      = build

xml_files:= $(wildcard $(BUILDDIR)/xml/*/*.xml)

build_xml:
	@$(SPHINXBUILD) -M xml "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


%.ipynb:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst ipynb,xml, $@) $@

%.md:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst md,xml, $@) $@

ipynb:	build_xml $(subst xml,ipynb, $(xml_files))

md:	build_xml $(subst xml,md, $(xml_files))





# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@if [ $@ != ipynb ] && [ $@ != md ] ; then 	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O);	fi
