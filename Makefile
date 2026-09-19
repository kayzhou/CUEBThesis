PYTHON ?= python3
.PHONY: all thesis minimal test release clean
all: thesis minimal
thesis:
	latexmk -outdir=build main.tex
minimal:
	latexmk -outdir=build/minimal examples/minimal.tex
test:
	$(PYTHON) -m unittest discover -s testfiles -p 'test_*.py'
	$(PYTHON) utils/check.py
release: all test
	$(PYTHON) utils/check.py --pdf build/main.pdf
	$(PYTHON) utils/check.py --pdf build/minimal/minimal.pdf
	$(PYTHON) utils/create_release.py
clean:
	latexmk -C -outdir=build main.tex
	latexmk -C -outdir=build/minimal examples/minimal.tex
