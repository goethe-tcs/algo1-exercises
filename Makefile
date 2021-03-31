WWWDIR=$(HOME)/Documents/Websites/tcs.uni-frankfurt.de/static/teaching/summer21/algo1

.PHONY: all
all:
	latexmk
	(test -d $(WWWDIR) && cp voraussetzungen.pdf *-wochenplan.pdf $(WWWDIR)/) || true

.PHONY: clean
clean:
	latexmk -C
