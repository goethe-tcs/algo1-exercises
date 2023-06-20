WWWDIR=$(HOME)/Documents/Websites/tcs.uni-frankfurt.de/static_large_files/teaching/summer21/algo1
SOURCES=$(wildcard *.tex)
TARGETS=$(patsubst %.tex,%.pdf,$(SOURCES))
GITINFOS=$(patsubst %.tex,%.gitinfo,$(SOURCES))

%.gitinfo: .git/logs/HEAD
	@echo "%%% This file is generated by Makefile." > $@.new
	@echo "%%% Do not edit this file!%%%" >> $@.new
	@git log -1 --format="format:\\gdef\\gitHash{%H}\\gdef\\gitAbbrevHash{%h}\\gdef\\gitAuthorDate{%as}\\gdef\\gitAuthorIsoDate{%ad}\\gdef\\gitAuthorName{%an}" $(patsubst %.gitinfo,%.tex,$@) >> $@.new
	@if ! diff $@ $@.new &> /dev/null; then mv $@.new $@; else rm $@.new; fi

%.pdf: %.tex %.gitinfo algo121.sty uebung_cs.cls allgemeine-kriterien.inc
	latexmk $<

.PHONY: all
all: $(TARGETS)

.PHONY: gitinfo
gitinfo: $(GITINFOS)

.PHONY: deploy
deploy: all
	@if test -d $(WWWDIR); then \
		for f in $(TARGETS); do \
			if ! diff $$f $(WWWDIR)/$$f &> /dev/null; then \
				cp $$f $(WWWDIR)/$$f; \
				echo "Copied $$f to WWWDIR."; \
			fi; \
		done \
	fi
	@cd $(WWWDIR) && yarn build && yarn upload

.PHONY: clean
clean:
	rm -f *.gitinfo *.gitinfo.new
	latexmk -C
