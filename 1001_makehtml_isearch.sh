#!/bin/sh

#set -x

insert_documentencoding () {
  grep "$4" $1 > /dev/null
  if [ $? -eq 1 ]; then
    echo "insert documentencoding : $1"
    cp $1 $2
    sed -e "/^$5\$/a $4" $2 > $1
    cp $1 $3
    sed -e "/^$6\$/a $4" $3 > $1
  fi
}

insert_isearch_data () {
  grep "$4" $1 > /dev/null
  if [ $? -eq 1 ]; then
    echo "insert isearch data : $1"
    cp $1 $2
    sed -e "/$5\$/r $3" $2 > $1
  fi
}

check_html_maker () {
  HTML_MAKER=''
  HTML_JP_OPTION=''
  type texi2html
  if [ $? -eq 0 ]; then
    HTML_MAKER='texi2html --number'
    HTML_JP_OPTION='--init-file=$(srcdir)/ja-init.pl'
  fi
  if [ -z "$HTML_MAKER" ]; then
    type texi2any
    if [ $? -eq 0 ]; then
      HTML_MAKER='texi2any -c TEXI2HTML=1'
    fi
  fi
  if [ -z "$HTML_MAKER" ]; then
    HTML_MAKER='makeinfo --html --no-split'
  fi
  echo "HTML_MAKER=$HTML_MAKER"
}

check_html_maker

insert_documentencoding           \
  gauche-ref.texi                 \
  gauche-ref_1000_bak.texi        \
  gauche-ref_1000_bak2.texi       \
  '@documentencoding UTF-8'       \
  '@setfilename gauche-refe.info' \
  '@setfilename gauche-refj.info'

make -f 1002_makehtml_isearch.Makefile \
     html-isearch-clean

make -f 1002_makehtml_isearch.Makefile \
     HTML_MAKER="$HTML_MAKER"          \
     HTML_JP_OPTION="$HTML_JP_OPTION"  \
     html-isearch

insert_isearch_data         \
  gauche-refe-isearch.html  \
  gauche-refe-normal.html   \
  1003_makehtml_isearch.dat \
  'isearch-function'        \
  '<\/style>'

insert_isearch_data         \
  gauche-refj-isearch.html  \
  gauche-refj-normal.html   \
  1003_makehtml_isearch.dat \
  'isearch-function'        \
  '<\/style>'

