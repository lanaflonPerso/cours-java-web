SHELL := /bin/bash
# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = python -msphinx
SPHINXPROJ    = Java
RAWSOURCEDIR  = source
SOURCEDIR     = build/processed-sources
BUILDDIR      = build

JINJA_EXEC    = jinja2 -D skip_package=True




xml_files= $(wildcard $(BUILDDIR)/xml/*/*.xml) $(wildcard $(BUILDDIR)/xml/*.xml)
RAW_SOURCES_FILES=$(shell find $(RAWSOURCEDIR) )

build_xml:
	@$(SPHINXBUILD) -M xml "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


%.ipynb:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst ipynb,xml, $@) $@

%.md:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst md,xml, $@) $@


ipynb:	process_sources build_xml $(subst xml,ipynb,$(xml_files))

md:	build_xml $(subst xml,md, $(xml_files))

$(SOURCEDIR) $(SOURCEDIR)/ipynb:
		mkdir -p $@



$(SOURCEDIR)/%:
			@echo [jinja2] preprocessing $@ ; \
 			target_file="$@"; \
   		original_file=$(RAWSOURCEDIR)/$${target_file#*/*/}; \
 			if [ -f $$original_file ]; \
 			then 		extension="$${original_file##*.}" ; \
 			mkdir -p $$(dirname "$$target_file"); \
 				if [ $$extension == rst ] && [[ $$target_file != *"angular"* ]]; \
 						then\
   					$(JINJA_EXEC) $$original_file > $$target_file; \
 		  			else cp  $$original_file $$target_file; \
 		  	fi; \
 		fi


process_sources: $(subst $(RAWSOURCEDIR),$(SOURCEDIR),$(RAW_SOURCES_FILES))

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@if [ $@ != ipynb ] && [ $@ != md ] && [ $@ != process_sources ]; then 	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O);	fi
