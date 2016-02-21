#!/bin/sh

# makehtml-isearch
# 2016-2-21 v1.14

#set -x
set -u

check_html_maker () {
  HTML_MAKER=''
  HTML_OPTION=''
  HTML_OPTION_JP=''
  type texi2html
  if [ $? -eq 0 ]; then
    HTML_MAKER='texi2html'
    HTML_OPTION='--number --split=section --init-file=$(srcdir)/1004_texi2html_init.pl'
    HTML_OPTION_JP='--init-file=$(srcdir)/ja-init.pl'
  fi
  if [ -z "$HTML_MAKER" ]; then
    type texi2any
    if [ $? -eq 0 ]; then
      HTML_MAKER='texi2any'
      HTML_OPTION='-c TEXI2HTML=1 --split=section'
    fi
  fi
  if [ -z "$HTML_MAKER" ]; then
    type makeinfo
    if [ $? -eq 0 ]; then
      HTML_MAKER='makeinfo'
      HTML_OPTION='--html --no-split'
    fi
  fi
  if [ -z "$HTML_MAKER" ]; then
    echo 'There is no html maker.  Aborting.'
    exit 1
  fi
  echo "HTML_MAKER=$HTML_MAKER"
}

insert_documentencoding () {
  grep "$3" $1 > /dev/null
  if [ $? -eq 1 ]; then
    echo "insert documentencoding : $1"
    cp $1 $2
    sed -e "/^$4\$/a $3" \
        -e "/^$5\$/a $3" \
        $2 > $1
  fi
}

insert_frame_data () {
  echo "insert frame data : $1"
  sed -e "s@input.html@$3@" \
      -e "s@main.html@$4@"  \
      $2 > $1
}

insert_index_data () {
  echo "insert index data : $1"
  sed -e "/^$4\$/r $3" $2 > $1
}

make_anchor () {
  echo "make anchor : $1"
  cp $1 $1.bak
  sed -r -e "$2" $1.bak > $1
  rm -f $1.bak
  cp $3 $3.bak
  sed -e "s@$4@$1$4@" $3.bak > $3
  rm -f $3.bak
}


check_html_maker

insert_documentencoding           \
  gauche-ref.texi                 \
  gauche-ref_1000_bak.texi        \
  '@documentencoding UTF-8'       \
  '@setfilename gauche-refe.info' \
  '@setfilename gauche-refj.info'

make -f 1002_makehtml_isearch.Makefile \
     html-isearch-clean

make -f 1002_makehtml_isearch.Makefile \
     HTML_MAKER="$HTML_MAKER"          \
     HTML_OPTION="$HTML_OPTION"        \
     HTML_OPTION_JP="$HTML_OPTION_JP"  \
     html-isearch


make_isearch () {
  MAIN_FILE=gauche-$1-isearch-main.html
  FRAME_FILE=gauche-$1-isearch.html
  INPUT_FILE=gauche-$1-isearch-input.html
  INDEX_DATA=1012_gauche-$1-index.dat
  case "$HTML_MAKER" in
    "texi2html")
      START_FILE=$MAIN_FILE/gauche-$1.html
      IDX_FILES_1=`grep -l 'class="index-fn"' $MAIN_FILE/*.html`
      IDX_FILES_2=`grep -l 'class="index-md"' $MAIN_FILE/*.html`
      IDX_FILES_3=`grep -l 'class="index-lx"' $MAIN_FILE/*.html`
      IDX_FILES_4=`grep -l 'class="index-cl"' $MAIN_FILE/*.html`
      IDX_FILES_5=`grep -l 'class="index-vr"' $MAIN_FILE/*.html`
      INDEX_FILES="$IDX_FILES_1 $IDX_FILES_2 $IDX_FILES_3 $IDX_FILES_4 $IDX_FILES_5"
      ANCHOR_FILE1=$MAIN_FILE/gauche-$1.html
      ANCHOR_FILE2=`grep -l 'class="contents"' $MAIN_FILE/*.html | head -1`
      ANCHOR_FILE3=`grep -l -E 'class="appendix">(Appendix C|C)' $MAIN_FILE/*.html | head -1`
      ANCHOR_SEARCH2='name="SEC_Contents"'
      TABLE_BEGIN='<table id="result_table">'
      TABLE_END='</table>'
      ;;
    "texi2any")
      START_FILE=$MAIN_FILE/index.html
      IDX_FILES_1=`grep -l 'class="index-fn"' $MAIN_FILE/*.html`
      IDX_FILES_2=`grep -l 'class="index-md"' $MAIN_FILE/*.html`
      IDX_FILES_3=`grep -l 'class="index-lx"' $MAIN_FILE/*.html`
      IDX_FILES_4=`grep -l 'class="index-cl"' $MAIN_FILE/*.html`
      IDX_FILES_5=`grep -l 'class="index-vr"' $MAIN_FILE/*.html`
      INDEX_FILES="$IDX_FILES_1 $IDX_FILES_2 $IDX_FILES_3 $IDX_FILES_4 $IDX_FILES_5"
      ANCHOR_FILE1=$MAIN_FILE/index.html
      ANCHOR_FILE2=`grep -l 'class="contents"' $MAIN_FILE/*.html | head -1`
      ANCHOR_FILE3=`grep -l -E 'class="appendix">(Appendix C|C)' $MAIN_FILE/*.html | head -1`
      ANCHOR_SEARCH2='name="SEC_Contents"'
      TABLE_BEGIN='<table id="result_table">'
      TABLE_END='</table>'
      ;;
    *)
      START_FILE=$MAIN_FILE
      INDEX_FILES=$MAIN_FILE
      ANCHOR_FILE1=$MAIN_FILE
      ANCHOR_FILE2=$MAIN_FILE
      ANCHOR_FILE3=$MAIN_FILE
      ANCHOR_SEARCH2='class="contents"'
      TABLE_BEGIN='<ul id="result_table">'
      TABLE_END='</ul>'
      ;;
  esac

  echo "extract index data : $INDEX_DATA"
  echo $TABLE_BEGIN > $INDEX_DATA
  for f in $INDEX_FILES; do
    gosh 1003_extract_index_data.scm \
         $f                          \
         $INDEX_DATA
  done
  echo $TABLE_END >> $INDEX_DATA
 
  insert_frame_data             \
    $FRAME_FILE                 \
    1010_gauche-ref-isearch.dat \
    $INPUT_FILE                 \
    $START_FILE

  insert_index_data           \
    $INPUT_FILE               \
    1011_gauche-ref-input.dat \
    $INDEX_DATA               \
    '<!-- index-data -->'

  make_anchor                             \
    $ANCHOR_FILE1                         \
    '/^<body>$/a <a name="Top1000"><\/a>' \
    $INPUT_FILE                           \
    '#Top1000'

  make_anchor                                           \
    $ANCHOR_FILE2                                       \
    "/$ANCHOR_SEARCH2/i <a name=\"Contents1000\"><\/a>" \
    $INPUT_FILE                                         \
    '#Contents1000'

  make_anchor                                                      \
    $ANCHOR_FILE3                                                  \
    '/class="appendix">(Appendix C|C)/i <a name="Index1000"><\/a>' \
    $INPUT_FILE                                                    \
    '#Index1000'
}


make_isearch refe
make_isearch refj


