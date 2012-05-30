################################################################
## Makefile for mdframed project folder
## $Id: Makefile 416 2012-05-30 21:07:41Z marco $
################################################################
## Definitions
################################################################
.SILENT:
SHELL     := /bin/bash
.PHONY: all clean ctan allwithoutclean
################################################################
## Name list
################################################################
PACKAGE   = mdframed
EXAMPLED  = mdframed-example-default
EXAMPLET  = mdframed-example-tikz
EXAMPLEP  = mdframed-example-pstricks
EXAMPLESX = mdframed-example-texsx
STYLE_I   = md-frame-0
STYLE_II  = md-frame-1
STYLE_III = md-frame-2
STYLE_IV  = md-frame-3
EXAMPLLIST=  $(EXAMPLED) $(EXAMPLET) $(EXAMPLEP) $(EXAMPLESX) 
FILELIST  =  $(PACKAGE) $(EXAMPLED) $(EXAMPLET) $(EXAMPLEP) $(EXAMPLESX)
STYLELIST = $(STYLE_I) $(STYLE_II) $(STYLE_III) $(STYLE_IV)
AUXFILES  = aux dtxe glo glolog gls hd ins idx idxlog ilg ind log out ps thm tmp toc 
################################################################
## Colordefinition
################################################################
NO_COLOR    = \x1b[0m
OK_COLOR    = \x1b[32;01m
WARN_COLOR  = \x1b[33;01m
ERROR_COLOR = \x1b[31;01m
################################################################
## make help
################################################################
help:
	@echo 
	@echo -e "$(WARN_COLOR)The following definitions provided by this Makefile"
	@echo -e "$(OK_COLOR)\tmake docsty\t\t--\ttypesets the documenation and the package"
	@echo -e "$(OK_COLOR)\tmake all\t\t--\trun docsty examples clean"
	@echo -e "\tmake examples\t\t--\tcompiles all example files"
	@echo -e "\tmake clean\t\t--\tremove all helpfiles created by mdframed"
	@echo -e "\tmake changeversion\t--\tmaintaner tool to change the version"
	@echo -e "\tmake localinstall\t--\tinstall the package in TEXMFHOME"
	@echo -e "$(WARN_COLOR)End help$(NO_COLOR)"

################################################################
## Compilation
################################################################
%.pdf: %.tex
	NAME=`basename $< .tex` ;\
	echo -e "" ;\
	echo -e "\t$(WARN_COLOR)Typesetting $$NAME$(NO_COLOR)" ;\
	pdflatex -draftmode -interaction=nonstopmode $< > /dev/null ;\
	if [ $$? = 0 ] ; then \
	  echo -e "\t$(OK_COLOR)compilation in draftmode without errors$(NO_COLOR)" ;\
	  echo -e "\t$(OK_COLOR)Run PDFLaTeX again on $$NAME.tex$(NO_COLOR)" ;\
	  pdflatex -interaction=nonstopmode $< > /dev/null ;\
	else \
	  echo -e "\t$(ERROR_COLOR)compilation in draftmode with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\
	echo -e "\t$(OK_COLOR)Typesetting $$NAME finished $(NO_COLOR)" ;\

%.ps: %.tex
	NAME=`basename $< .tex` ;\
	echo -e "" ;\
	echo -e "\t$(WARN_COLOR)Typesetting $$NAME$(NO_COLOR)" ;\
	xelatex -draftmode -interaction=nonstopmode $< > /dev/null ;\
	if [ $$? = 0 ] ; then \
	  echo -e "\t$(OK_COLOR)compilation in draftmode without errors$(NO_COLOR)" ;\
	  echo -e "\t$(OK_COLOR)Run LaTeX again on $$NAME.tex$(NO_COLOR)" ;\
	  xelatex -interaction=nonstopmode $< > /dev/null ;\
	else \
	  echo -e "\t$(ERROR_COLOR)compilation in draftmode with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\
	echo -e "\t$(OK_COLOR)Typesetting $$NAME done$(NO_COLOR)" ;\

#	latex -draftmode -interaction=nonstopmode $< > /dev/null ;\
#	if [ $$? = 0 ] ; then \
#	  echo -e "\t$(OK_COLOR)compilation in draftmode without errors$(NO_COLOR)" ;\
#	  echo -e "\t$(OK_COLOR)Run LaTeX again on $$NAME.tex$(NO_COLOR)" ;\
#	  latex -interaction=nonstopmode $< > /dev/null ;\
#	  latex -interaction=nonstopmode $< > /dev/null ;\
#	  dvips -q $$NAME.dvi ;\
#	  ps2pdf $$NAME.ps ;\
#	else \
#	  echo -e "\t$(ERROR_COLOR)compilation in draftmode with errors$(NO_COLOR)" ;\
#	  exit 0;\
#	fi ;\
#	echo -e "\t$(OK_COLOR)Typesetting $$NAME done$(NO_COLOR)" ;\
################################################################
## Compilation
################################################################
docsty: $(PACKAGE).dtx
	echo -e "" ;\
	echo -e "\t$(WARN_COLOR)Typesetting $(PACKAGE).dtx$(NO_COLOR)" ;\
	pdflatex -draftmode -interaction=nonstopmode $(PACKAGE).dtx > /dev/null ;\
	if [ $$? = 0 ] ; then \
	  echo -e "\t$(OK_COLOR)compilation in draftmode without errors$(NO_COLOR)" ;\
	  if [ -f $(PACKAGE).glo ] ; then \
	   echo -e "\t$(WARN_COLOR)Typesetting $(PACKAGE).glo$(NO_COLOR)" ;\
	   makeindex -q -t $(PACKAGE).glolog  -s gglo.ist -o $(PACKAGE).gls $(PACKAGE).glo ;\
	   if [ $$? = 0 ] ; then \
	     echo -e "\t$(OK_COLOR)compilation of Glossar without errors$(NO_COLOR)" ;\
	   else \
	     echo -e "\t$(ERROR_COLOR)compilation of Glossar with errors$(NO_COLOR)" ;\
	   fi ;\
	  fi ;\
	  if [ -f $(PACKAGE).idx ] ; then \
	   echo -e "\t$(WARN_COLOR)Typesetting $(PACKAGE).idx$(NO_COLOR)" ;\
	   makeindex -q -t $(PACKAGE).idxlog -s gind.ist $(PACKAGE).idx ;\
	   if [ $$? = 0 ] ; then \
	     echo -e "\t$(OK_COLOR)compilation of Index without errors$(NO_COLOR)" ;\
	   else \
	     echo -e "\t$(ERROR_COLOR)compilation of Index with errors$(NO_COLOR)" ;\
	   fi ;\
	  fi ;\
	  pdflatex $(PACKAGE).dtx > /dev/null ;\
	  if [ $$? = 0 ] ; then \
	     echo -e "\t$(OK_COLOR)Second pdflatex compilation without errors$(NO_COLOR)" ;\
	  else \
	     echo -e "\t$(ERROR_COLOR)Second pdflatex compilation with errors$(NO_COLOR)" ;\
	     exit 0;\
	  fi ;\
	  pdflatex $(PACKAGE).dtx > /dev/null ;\
	else \
	  echo -e "\t$(ERROR_COLOR)compilation in draftmode with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\

examples: $(EXAMPLED).pdf $(EXAMPLET).pdf $(EXAMPLEP).ps $(EXAMPLESX).pdf

exampled: $(EXAMPLED).pdf
examplet: $(EXAMPLET).pdf
examplep: $(EXAMPLEP).ps
examplesx:$(EXAMPLESX).pdf

clean:  
	echo  "" ;\
	echo -e "\t$(WARN_COLOR)Start removing help files$(NO_COLOR)" ;\
	for I in $(FILELIST) ;\
	do \
	  for J in $(AUXFILES) ;\
	  do \
	    rm -rf $$I.$$J ;\
	  done ;\
	done ;\
	echo -e "\t$(OK_COLOR)Removing finished$(NO_COLOR)" ;\

all:	docsty examples clean

################################################################
## personal setting
################################################################
localinstall:	docsty examples makelocalinstall clean

makelocalinstall:
	echo  "" ;\
	echo -e "\t$(ERROR_COLOR)Start local install$(NO_COLOR)" ;\
	PATHTEXHOME=`kpsewhich --var-value=TEXMFHOME` ;\
	echo -e "\t$(ERROR_COLOR)Creating folders if don't exist$(NO_COLOR)" ;\
	mkdir -p $$PATHTEXHOME/doc/latex/$(PACKAGE)/ ;\
	mkdir -p $$PATHTEXHOME/tex/latex/$(PACKAGE)/ ;\
	for I in $(FILELIST) ;\
	do \
	  cp $$I.pdf $$PATHTEXHOME/doc/latex/$(PACKAGE)/  ;\
	done ;\
	for I in $(STYLELIST) ;\
	do \
	  cp $$I.mdf $$PATHTEXHOME/tex/latex/$(PACKAGE)/  ;\
	done ;\
	cp $(PACKAGE).sty $$PATHTEXHOME/tex/latex/$(PACKAGE)/  ;\
	cp ltxmdf.cls $$PATHTEXHOME/tex/latex/$(PACKAGE)/  ;\
	echo -e "\t$(OK_COLOR)Installation done$(NO_COLOR)" ;\

################################################################
## maintaner tool
################################################################
changeversion:
	@echo 
	@echo -e "$(OK_COLOR)Aktuell wird die folgende Version verwendet"
	@sed '/\\def\\mdversion/!d' $(PACKAGE).sty 
	@echo -e "$(WARN_COLOR)"
	@read -p "Bitte neue Version eingeben: " REPLY &&  sed -rie "s/(\\\\def\\\\mdversion\{).*(})/\1$$REPLY\2/" $(PACKAGE).dtx&&\
	 echo -e "$(OK_COLOR)Version geändert zu $$REPLY$(NO_COLOR)"
	@echo

usectanify:
	echo  "" ;\
	echo -e "\t$(ERROR_COLOR)Start ctanify$(NO_COLOR)" ;\
	ctanify $(PACKAGE).ins $(PACKAGE).pdf README.txt ltxmdf.cls \
	        donald-duck.jpg=doc/latex/mdframed/ \
	        $(EXAMPLED).tex=doc/latex/mdframed/ \
	        $(EXAMPLED).pdf=doc/latex/mdframed/ \
	        $(EXAMPLET).tex=doc/latex/mdframed/ \
	        $(EXAMPLET).pdf=doc/latex/mdframed/ \
	        $(EXAMPLEP).tex=doc/latex/mdframed/ \
	        $(EXAMPLEP).pdf=doc/latex/mdframed/ \
	        $(EXAMPLESX).tex=doc/latex/mdframed/ \
	        $(EXAMPLESX).pdf=doc/latex/mdframed/ \
	        Makefile=source/latex/mdframed/ \
	        mdframedmake.bat=source/latex/mdframed/ \
	        md-frame-0.mdf=tex/latex/mdframed/ \
	        md-frame-1.mdf=tex/latex/mdframed/ \
	        md-frame-2.mdf=tex/latex/mdframed/ \
	        md-frame-3.mdf=tex/latex/mdframed/ ;\
	if [ $$? = 0 ] ; then \
	     echo -e "\t$(OK_COLOR)ctanify without errors$(NO_COLOR)" ;\
	     echo -e "" ;\
	else \
	  echo -e "\t$(ERROR_COLOR)ctanify with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\

ctan: docsty examples usectanify clean
