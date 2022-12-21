TEX := latexmk
TFLAGS := -pdf

# Liste alle TeX-Files im aktuellen Verzeichnis auf
TEXS := $(wildcard *.tex)
PDFS := $(patsubst %.tex,%.pdf,$(TEXS))

.PHONY: help all clean erase $(TEXS)
help:
	@echo "Latex Makefile."
	@echo "Folgende Befehle gibt es:"
	@echo "make all	| Führt latexmk für alle TeX-Files gefolgt von make clean aus."
	@echo "make %.tex	| Führt latexmk für das angegebene TeX-File aus."
	@echo "make clean	| Entfernt alle TeX-spezifischen Builddateien (aux,log,nav,out,snm,toc)"
	@echo "make erase	| Entfernt alle PDF-Dateien von TeX-Files im aktuellen Verzeichnis."
	@echo "Mit dem Flag -jN können N Jobs gleichzeitig ausgeführt werden. -j für unbegrenzte Anzahl."

all: $(PDFS)
	@echo "Finished with all."

clean:
	@echo "Cleaning up…"
	latexmk -c
	@echo "Done. To remove PDF files run: make erase"

erase: clean
	rm -f $(PDFS)

%.pdf: %.tex
	@echo "======= Running xelatex for: $@ =======";
	@while ($(TEX) $(TFLAGS) "$(basename $@).tex"; grep -q "Rerun to get" "$(basename $@).log") \
	do \
		echo "======= Rerunning xelatex for: $@ ======="; \
	done;
	@echo "======= Deleting build files for: $@ =======";
	rm -f $(basename $@).aux $(basename $@).log $(basename $@).nav $(basename $@).out $(basename $@).snm $(basename $@).toc
