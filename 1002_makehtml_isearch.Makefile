include Makefile

html-isearch: gauche-refe-isearch-main.html gauche-refj-isearch-main.html

gauche-refe-isearch-main.html: gauche-refe.texi
#	texi2html --number -o $@ $<
#	makeinfo --html --no-split -o $@ $<
#	makeinfo -c TEXI2HTML=1 -o $@ $<
	$(HTML_MAKER) $(HTML_OPTION) -o $@ $<

gauche-refj-isearch-main.html: gauche-refj.texi
#	texi2html --init-file=$(srcdir)/ja-init.pl --number --document-language=ja -o $@ $<
#	makeinfo --html --no-split --document-language=ja -o $@ $<
#	makeinfo -c TEXI2HTML=1 --document-language=ja -o $@ $<
	$(HTML_MAKER) $(HTML_OPTION) $(HTML_OPTION_JP) --document-language=ja -o $@ $<

html-isearch-clean:
	rm -rf gauche-refe-isearch-main.html  gauche-refj-isearch-main.html \
	       gauche-refe-isearch-input.html gauche-refj-isearch-input.html \
	       gauche-refe-isearch.html       gauche-refj-isearch.html

