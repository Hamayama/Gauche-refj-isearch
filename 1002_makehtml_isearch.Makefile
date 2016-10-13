include Makefile

html-isearch: gauche-refe-isearch-main.html gauche-refj-isearch-main.html

gauche-refe-isearch-main.html: gauche-refe.texi
	$(HTML_MAKER) $(HTML_OPTION) -o $@ $<

gauche-refj-isearch-main.html: gauche-refj.texi
	$(HTML_MAKER) $(HTML_OPTION) $(HTML_OPTION_JP) --document-language=ja -o $@ $<

html-isearch-clean:
	rm -rf gauche-refe-isearch-main.html  gauche-refj-isearch-main.html \
	       gauche-refe-isearch-input.html gauche-refj-isearch-input.html \
	       gauche-refe-isearch.html       gauche-refj-isearch.html

