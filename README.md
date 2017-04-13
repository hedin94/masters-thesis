#LiU Thesis class

Ola Leifler, ola.leifler@liu.se, 2011-2017

## Package options

The following options are recognized by the liuthesis document class

- `phd` - For doctoral dissertations 
- `lic` - For licentiate theses
- `msc` - For Masters' theses (default)
- `bachelor` - For Bachelors' theses
- `hu`     - For the medical sciences (experimental)
- `filfak` - For the Faculty of Arts and Sciences
- `lith`   - For LiTH (default)
- `exhibitpage` - Produce an exhibit page (spikblad) and no thesis. Use
	      this option to produce an exhibit page only for Licentiate/PhD
	      dissertations.
- `printerfriendly` - ensure chapters begin on recto pages
- `swedish` - use Swedish as the main language, English as the secondary language
- `english` - use English as the main language

... plus all the options recognized by the [memoir](https://www.ctan.org/pkg/memoir) package, which liuthesis extends.

## Packages included

The `liuthesis` package includes a number of packages for convenient,
contemporary TeX typesetting. When using the XeTeX engine for
typesetting your manuscript, the polyglossia, mathspec, fontspec,
xunicode and xltxtra packages are loaded. All manuscript files should
be written with UTF-8 encoding. When PDFLaTeX is used as the
typsetting engine, the babel, palatino and mathpazo packages are used
instead.

Note that _for correct typesetting of the front matter, XeTeX must be
used_ as a typesettings engine on a platform where the proprietary
fonts KorolevLiU or Calibri/Calibri Italic are available.

The [BibLaTeX](https://www.ctan.org/pkg/biblatex) package is used for
managing references. Currently, there is no way to specify the
load-time options to biblatex as document class options together with
other options, so the biblatex package _has to be loaded manually_ in
settings.tex (see Usage below).

## Usage

This package contains a style file for theses (`liuthesis.cls`) and a file
`settings.tex` which must at least include the lines

```
\usepackage{biblatex}
\addbibresource{<my bibliography file>}
```

and possibly other settings. In the directory figures/, you should
place all graphics for your thesis. Logos are included for LiU,
please add other logotypes as appropriate.

In your thesis file, you need to specify where the bibliography
should be typeset using the command `\printbibliography`.

There are a number of demo thesis files (`demo*.tex`) that provide
examples of how the template works.

`Abstract.tex` is a mandatory file with your abstract,
`sammanfattning.tex` is included for dissertations that must include
popular science descriptions. Other files can
be included at will from your main thesis file.

For further usage instructions, please refer to `demo*.tex` that
provide minimal examples that should get you started.

## Makefile

If you are on a platform where you can use Make for building your PDF,
we have a Makefile ready for you. Edit the name of the main file that
you wish to process (`TEXMAINFILE`) and run `make`. This will run
xelatex and biber as many times as needed to produce a PDF. To clean
all auxiliary files, run `make clean`. To typeset the demos, run `make
demos`, which will update the pdf files in the `demo` directory.

## Including articles

```
\includearticle{<citekey>}
```

With the `\includearticle` command, you can include pdf articles and
refer to them in your thesis. demothesis.tex provides an example of
this. `<citekey>` should be the same as the key in your bibliography
which describes your article, and the file name of the pdf file. You
can refer to your articles in your thesis using the reference key
`art:<citekey>`.

```
\includearticletex{<citekey>}
```

With the `\includearticletex` command, you can include TeX articles
and refer to them in your thesis. The files `demo*{lic,phd}.tex` provide examples
of this. `<citekey>` should be the same as the key in your bibliography
which describes your article, and the file name of the TeX manuscipt
in the papers/ directory. Please refer to the scigen.tex example for
hints how you format your manuscript for inclusion. You can refer to
your articles in your thesis using the reference key `art:<citekey>`.

There are a number of commands with one parameter which should be used
to specify thesis metadata, and they are all typeset using the command
names as they appear in the PDF. For instance, using the command
`\opponent{Your opponent}`, you can specify the opponent. If you do not,
the pdf will contain the verbatim text `\opponent` on all locations
where the argument supplied to that command will substitute
`\opponent`.

## File headers

To use and update the file headers appropriately, you will need Emacs
with the header2 package. Put this information in an Emacs init file:

```
(require 'package)
;; Marmalade
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;; The original ELPA archive still has some useful
;; stuff.
 (add-to-list 'package-archives
              '("elpa" . "http://tromey.com/elpa/"))
(package-initialize)

(autoload 'auto-update-file-header "header2")
(add-hook 'write-file-hooks 'auto-update-file-header)
(add-hook 'latex-mode-hook   'auto-make-header)
```
