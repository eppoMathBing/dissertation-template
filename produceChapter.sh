#!/bin/sh

# produce a chapter its own tex file

if [ $1 = "main" ]
then echo "Calling this command with argument 'main' has undefined behaviour...  Exiting to prevent overwrite." && exit 1
fi

# temporary directory
TMP_DIR="tmp/$1"
# multifile directory
EDIT_DIR="$TMP_DIR/edit"
# unified file directory
UNI_DIR="$TMP_DIR/unified"
# linked directory
LINK_DIR="$TMP_DIR/link"

# make a temporary directories
mkdir -pv $EDIT_DIR $UNI_DIR $LINK_DIR

# copy sources and preamble into the edits
cp -piv --target-directory=$EDIT_DIR sources.bib preamble.tex format/bibliography.tex content/$1.tex

# make unified files
cp -piv --target-directory=$UNI_DIR sources.bib

# link the sources and preamble
ln -fs -t $LINK_DIR ../../../preamble.tex ../../../sources.bib
# link bibliography formatting
ln -fs ../../../format/bibliography.tex $LINK_DIR/bibliography.tex
# link chapter
ln -fs ../../../content/$1.tex $LINK_DIR/content.tex

# make a container for multifile format
MAIN_FILE=$EDIT_DIR/main.tex
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
UNI_FILE=$UNI_DIR/main.tex
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN USER PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' > $UNI_FILE
cat preamble.tex >> $UNI_FILE
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END USER PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BEGIN BIBLIOGRAPHY FORMATTING %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' >> $UNI_FILE
cat format/bibliography.tex >> $UNI_FILE
echo '\\addbibresource{sources.bib}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% END BIBLIOGRAPHY FORMATTING %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN YOUR DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\begin{document}' >> $UNI_FILE
cat content/$1.tex >> $UNI_FILE
echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END YOUR DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCT BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\printbibliography
\\end{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' >> $UNI_FILE

# make a container for linked format
LINK_FILE=$LINK_DIR/main.tex
# make LaTeX document for compiling
echo '\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
\\include{preamble}
\\include{bibliography}
\\addbibresource{sources.bib}
\\begin{document}' > $LINK_FILE
echo "\\include{content}" >> $LINK_FILE
echo '\\printbibliography
\\end{document}
' >> $LINK_FILE
