TEX := latexmk
TFLAGS := -pdf

TEXS := $(wildcard *.tex)
PDFS := $(patsubst %.tex,%.pdf,$(TEXS))

PYS := $(wildcard *.py)

.PHONY: help all clean erase $(TEXS)
help:
	@echo "Latex Makefile."
	@echo "Available commands:"
	@echo "make all		| Run latexmk for all available TeX files. Clean log files afterwards."
	@echo "make %.tex	| Run latexmk on a TeX file."
	@echo "make clean	| Removes all TeX specific build files."
	@echo "make erase	| Removes all PDF files generated from TeX files in the current directory."
	@echo "The -jN flag allows running N jobs at the same time. Use -j for an unlimited number of jobs."

all: imgs $(PDFS)
	@echo "Finished."

clean:
	@echo "Cleaning up…"
	latexmk -c
	@echo "Done. To remove PDF files run: make erase"

erase: clean
	rm -f $(PDFS)

imgs: $(PYS)
	@mkdir -p imgs
	@for PY in $(PYS); do python $$PY False; done

%.pdf: %.tex
	@echo "======= Running latexmk for: $@ =======";
	@while ($(TEX) $(TFLAGS) "$(basename $@).tex"; grep -q "Rerun to get" "$(basename $@).log") \
	do \
		echo "======= Rerunning latexmk for: $@ ======="; \
	done;
	@echo "======= Deleting build files for: $@ =======";
	rm -f $(basename $@).aux $(basename $@).log $(basename $@).nav $(basename $@).out $(basename $@).snm $(basename $@).toc
