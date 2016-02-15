include Makefile

html-isearch: gauche-refe-isearch.html gauche-refj-isearch.html

gauche-refe-isearch.html: gauche-refe.texi
#	texi2html --number -o $@ $<
#	makeinfo --html --no-split -o $@ $<
#	makeinfo -c TEXI2HTML=1 -o $@ $<
	$(HTML_MAKER) -o $@ $<

gauche-refj-isearch.html: gauche-refj.texi
#	texi2html --init-file=$(srcdir)/ja-init.pl --number --document-language=ja -o $@ $<
#	makeinfo --html --no-split --document-language=ja -o $@ $<
#	makeinfo -c TEXI2HTML=1 --document-language=ja -o $@ $<
	$(HTML_MAKER) $(HTML_JP_OPTION) --document-language=ja -o $@ $<

html-isearch-clean:
	rm -f gauche-refe-isearch.html gauche-refj-isearch.html \
	      gauche-refe-normal.html  gauche-refj-normal.html

