#!/bin/sh

# produce a chapter its own tex file

if [ $1 = "main" ]
then echo "Calling this command with argument 'main' has undefined behaviour...  Exiting to prevent overwrite." && exit 1
fi

# temporary directory
TMP_DIR="tmp/$1"
# multifile directory
HARD_DIR="$TMP_DIR/hard"
# unified file directory
UNIT_DIR="$TMP_DIR/unit"
# linked directory
EDIT_DIR="$TMP_DIR/edit"

# make a temporary directories
mkdir -pv $HARD_DIR $UNIT_DIR $EDIT_DIR

# copy sources and preamble into the edits
cp -piv --target-directory=$HARD_DIR sources.bib preamble.tex format/bibliography.tex content/$1.tex

# make unified files
cp -piv --target-directory=$UNIT_DIR sources.bib

# link the sources and preamble
ln -fs -t $EDIT_DIR ../../../preamble.tex ../../../sources.bib
# link bibliography formatting
ln -fs ../../../format/bibliography.tex $EDIT_DIR/bibliography.tex
# link chapter
ln -fs ../../../content/$1.tex $EDIT_DIR/content.tex

# make a container for multifile format
MAIN_FILE=$HARD_DIR/main.tex
# make document header
echo '\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
\\include{preamble}
\\include{bibliography}
\\addbibresource{sources.bib}
\\begin{document}' > $MAIN_FILE
echo "\\include{$1}" >> $MAIN_FILE
echo '\\printbibliography
\\end{document}
' >> $MAIN_FILE

# make a container for single-file format
UNIT_FILE=$UNIT_DIR/main.tex
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN USER PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' > $UNIT_FILE
cat preamble.tex >> $UNIT_FILE
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END USER PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BEGIN BIBLIOGRAPHY FORMATTING %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' >> $UNIT_FILE
cat format/bibliography.tex >> $UNIT_FILE
echo '\\addbibresource{sources.bib}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% END BIBLIOGRAPHY FORMATTING %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN YOUR DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\begin{document}' >> $UNIT_FILE
cat content/$1.tex >> $UNIT_FILE
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END YOUR DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCT BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\printbibliography
\\end{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' >> $UNIT_FILE

# make a container for linked format
EDIT_FILE=$EDIT_DIR/main.tex
# make LaTeX document for compiling
echo '\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
\\include{preamble}
\\include{bibliography}
\\addbibresource{sources.bib}
\\begin{document}' > $EDIT_FILE
echo "\\include{content}" >> $EDIT_FILE
echo '\\printbibliography
\\end{document}
' >> $EDIT_FILE
