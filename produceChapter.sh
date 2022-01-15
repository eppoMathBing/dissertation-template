#!/bin/sh

# produce only a chapter of the thesis in its own tex file

# link the sources and preamble in tmp/
ln -is -t tmp ../preamble.tex ../sources.bib

# make a file
OUTFILE="tmp/$2.tex"
# make document header
echo '\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
\\include{preamble}

' > $OUTFILE
# include bibliography formatting
cat "format/bibliography.tex" >> $OUTFILE
# finish bibliography formatting and begin document
echo '
\\addbibresource{sources.bib}
\\begin{document}
' >> $OUTFILE
# include the named chapter (do NOT include the .tex)
cat "content/$1.tex" >> $OUTFILE
# add bibliography and end document
echo '
\\printbibliography
\\end{document}
' >> $OUTFILE

# warn Emacs users of local variables
echo 'Emacs users: this file may include local variables you do not intend to set.
You should fix these manually...'
