SHELL := /bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Minimal makefile for Sphinx documentation
#

PREPROCESSING=NO

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = python -msphinx
SPHINXPROJ    = Java
OVERIDDEN_TARGETS	= ipynb md preprocess_sources

ifeq ($(PREPROCESSING),YES)
 RAWSOURCEDIR  			= source
 SOURCEDIR     			= build/processed-sources
 PREPROCESS_COMMAND	= preprocess_sources
else
 RAWSOURCEDIR  = source
 SOURCEDIR     = source
 PREPROCESS_COMMAND	=
endif


BUILDDIR      = build

JINJA_EXEC    = jinja2
JINJA_OPTS 		= $(ROOT_DIR)/preprocessing.conf.yaml --format=yaml




build_xml:
	@$(SPHINXBUILD) -M xml "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


$(BUILDDIR)/%.ipynb:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst ipynb,xml, $@) $@

$(BUILDDIR)/%.md:
				@if [ ! -d "$(dir $@)" ];then mkdir -p $(dir $@); fi
				rst-converter $(subst md,xml, $@) $@



build_ipynb: $(subst xml,ipynb,$(wildcard $(BUILDDIR)/xml/*/*.xml) $(wildcard $(BUILDDIR)/xml/*.xml))

build_md: $(subst xml,md,$(wildcard $(BUILDDIR)/xml/*/*.xml) $(wildcard $(BUILDDIR)/xml/*.xml))


ipynb: build_xml
	make build_ipynb -j

md:     build_md
	make build_md -j


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
   					$(JINJA_EXEC) $$original_file $(JINJA_OPTS) > $$target_file; \
 		  			else cp  $$original_file $$target_file; \
 		  	fi; \
 		fi


preprocess_sources: $(subst $(RAWSOURCEDIR),$(SOURCEDIR),$(shell find $(RAWSOURCEDIR)))

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile build_ipynb build_md ipynb md preprocess_sources

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(PREPROCESS_COMMAND)
	@if [ $@ != build_md ] && [ $@ != build_ipynb ] && [ $@ != ipynb ] && [ $@ != md ] && [ $@ != preprocess_sources ]; then \
	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O); \
	fi
