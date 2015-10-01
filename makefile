VERSION:=$(shell grep Version: DESCRIPTION|sed 's/Version: //')
NAME:=$(shell grep Package: DESCRIPTION|sed 's/Package: //')
PACKAGEFILE:=../$(NAME)_$(VERSION).tar.gz

all: $(PACKAGEFILE) README.md

.PHONY: all install

install:
	R -e 'devtools::install_github("sherrillmix/$(NAME)")'

plots: generatePlots.R
	Rscript generatePlots.R

man: R/*.R
	R -e 'devtools::document()'
	touch man

inst/doc: vignettes/*.Rnw
	R -e 'devtools::build_vignettes()'
	touch inst/doc

package: docs R/*.R DESCRIPTION
$(PACKAGEFILE): man R/*.R DESCRIPTION tests/testthat/tests.R inst/doc
	R -e 'devtools::check();devtools::build()'
