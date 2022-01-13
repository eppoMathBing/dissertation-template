#!/bin/sh

# produce only a chapter of the thesis in its own tex file

# copy the sources file
cp sources.bib tmp/sources.bib

# make a file
OUTFILE="tmp/$2.tex"
# make document header
echo '\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}

' > $OUTFILE
# include preamble.tex
cat "preamble.tex" >> $OUTFILE
# include bibliography formatting
cat "format/bibliography.tex" >> $OUTFILE
# include the sources file and begin document
echo '\\addbibresource{sources.bib}
\\begin{document}\n\n

' >> $OUTFILE
# include the named chapter (do NOT include the .tex)
cat "content/$1.tex" >> $OUTFILE
# add bibliography and end document
echo '

\\printbibliography
\\end{document}
' >> $OUTFILE
