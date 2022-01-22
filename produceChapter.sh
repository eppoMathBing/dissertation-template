#!/bin/sh

# produce a chapter its own tex file

# set initial options
EDIT=0
HARD=0
UNIT=0

# process options
for x in $@;
do
    if [ "$x" = "-e" ] || [ "$x" = "--edit" ]
    then EDIT=`expr 1 - $EDIT`
    elif [ "$x" = '-h' ] || [ "$x" = '--hard' ]
    then HARD=`expr 1 - $HARD`
    elif [ "$x" = '-u' ] || [ "$x" = '--unit' ]
    then UNIT=`expr 1 - $UNIT`
    elif [ "$x" = '-i' ] || [ "$x" = '--interactive' ]
    then INTERACTIVE="--interactive"
    elif [ "$x" = '-f' ] || [ "$x" = '--force' ]
    then FORCE="--force"
    elif [ "$x" = '-v' ] || [ "$x" = '--verbose' ]
    then VERBOSE="--verbose"
    else
        FILES="${FILES} ${x}"
    fi
done &&

    # set default option
    if [ `expr $EDIT + $HARD + $UNIT` -eq 0 ]; then EDIT=1; fi &&

    for content in $FILES;
    do
        if [ $content = "main" ]
        then
            echo "Calling this command with argument 'main' has undefined behaviour...  Skipping this one."
        else
            if [ "$VERBOSE" = "--verbose" ]; then printf "\nworking on $content\n"; fi
            # temporary directory
            TMP_DIR="tmp/${content}"
            # mainfile for multifile formats
            MAIN_STR='%% this file written to edit a thesis chapter
\\documentclass[12pt]{article}
\\newcommand{\\chapter}{\\section}
\\newcommand{\\spChapter}{\\section}
\\include{preamble}
\\include{bibliography}
\\addbibresource{sources.bib}
\\begin{document}
\\include{%s}
\\printbibliography
\\end{document}
'
            # linked files
            if [ $EDIT = 1 ]
            then
                # linked directory
                EDIT_DIR=$TMP_DIR--edit
                mkdir -p $VERBOSE $EDIT_DIR
                # link the files
                ln -s $VERBOSE $FORCE $INTERACTIVE -t $EDIT_DIR \
                   ../../preamble.tex \
                   ../../sources.bib \
                   ../../format/bibliography.tex \
                   ../../format/bibliography.tex \
                   ../../content/$content.tex
                # make a LaTeX container for linked format
                printf "$MAIN_STR" "$content" > $EDIT_DIR/main.tex
            fi
            # multifile format
            if [ $HARD = 1 ]
            then
                # multifile directory
                HARD_DIR=$TMP_DIR--hard
                mkdir -p $VERBOSE $HARD_DIR
                # copy sources and preamble into the edits
                cp -p $VERBOSE $FORCE $INTERACTIVE --target-directory=$HARD_DIR sources.bib preamble.tex format/bibliography.tex content/$content.tex
                # make a container for multifile format
                printf "$MAIN_STR" "$content" > $HARD_DIR/main.tex
            fi
            # single-file format
            if [ $UNIT = 1 ]
            then
                # unified file directory
                UNIT_DIR=$TMP_DIR--unit
                mkdir -p $VERBOSE $UNIT_DIR
                # make unified files
                cp -p $VERBOSE $FORCE $INTERACTIVE --target-directory=$UNIT_DIR sources.bib
                # make a container for single-file format
                UNIT_FILE=$UNIT_DIR/main.tex
                echo '%% this file written to edit a thesis chapter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                cat content/$content.tex >> $UNIT_FILE
                echo '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END YOUR DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCT BIBLIOGRAPHY %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\printbibliography
\\end{document}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
' >> $UNIT_FILE
            fi
        fi
    done
