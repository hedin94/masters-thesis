# Use Bash shell expansion
SHELL=/bin/bash
#The program that you use for viewing pdf files
PDFVIEWER = evince
# Change name of this if you change the name of demo_student_thesis.tex, should be name of the main tex file
TEXMAINFILE = thesis.tex
# Name that you would like for your resulting pdf file, without extension.
# Defaults to $(TEXMAINFILE) with .pdf as extension
PDFNAME = $(shell basename -s.tex $(TEXMAINFILE))
PUBLISHNAME = appearance_preserving_mesh_simplification
#Location of latexmk binary
MKLATEX = latexmk
#Options to latexmk, should need to be changed
MKLATEXOPTS = -pdf -pdflatex="xelatex -interaction=nonstopmode" -use-make -f

all: $(PDFNAME).pdf $(PUBLISHNAME).pdf clearwindow

$(PDFNAME).pdf: $(TEXMAINFILE) *.tex
	$(MKLATEX) $(MKLATEXOPTS) $<

$(PUBLISHNAME).pdf: $(PDFNAME).pdf
	cp $(PDFNAME).pdf ../$(PUBLISHNAME).pdf

view: $(PDFNAME).pdf
	$(PDFVIEWER) $(PDFNAME).pdf &

clean:
	$(MKLATEX) -c
	rm -f *.{aux,bbl,bcf,blg,cb,fdb_latexmk,fls,lof,log,lot,out,run.xml,rel,synctex.gz,toc}

distclean: clean
	rm -f $(PDFNAME).pdf

clearwindow:
	clear

.PHONY: clean all clearwindow
