# CUEB Undergraduate Thesis Implementation Plan

> For agentic workers: use subagent-driven-development for independent work and review. Continue through validation and local Git commits; the user has authorized implementation.

**Goal:** Build and locally version a usable undergraduate thesis template with reproducible examples and the 2024 handbook rules.

**Architecture:** An independent ctexart class exposes \cuebsetup, loads a versioned school profile and optional college profile, and supplies title/abstract/body layout. biblatex styles provide full footnote citations and a separately sorted GB/T 7714-2005 bibliography. ThuThesis informs interfaces and project organization.

**Tech Stack:** XeLaTeX, TeX Live 2022 or newer, Biber, latexmk, Python 3 standard library, Poppler; Git.

## Task 1 Repository and acceptance fixtures
- [ ] Initialize a dedicated repository on feat/initial-template; retain the approved design and this plan. Commit documentation before code.
- [ ] Create testfiles/acceptance.tex and testfiles/refs.bib: two sections, repeated citation, a plain footnote, Chinese authors deliberately supplied out of alphabetical order, one English author, online citation, equations and figures across sections.
- [ ] Run xelatex -halt-on-error -output-directory=build testfiles/acceptance.tex and record missing class failure before implementation.

## Task 2 Class and school profile
- [ ] Implement cuebthesis.cls and config/cueb-2024.def. Public interfaces: \cuebsetup{...}, \maketitle, cuebabstract and cuebabstract* environments, \cuebkeywords{...}, \cuebfrontmatter, \cuebmainmatter, \cuebappendix, \cuebacknowledgements, \cuebprintbibliography.
- [ ] Metadata: title/title*, author, student-id, department, major, supervisor, date. Options: standard=cueb-2024, college-profile=general, font-profile=preview|submission, numbering=continuous|section, thesis-type=research|review|design; header-logo and cover-file inputs.
- [ ] Enforce A4, top/bottom 2.54cm, left 3.8cm/right 2.8cm (including proposed binding), right footer, 4.5cm by 0.9cm school mark. Use explicit fontsize 12bp/18bp for body, 15bp first-level headings, 12bp lower headings, 9bp notes, 10.5bp captions. Record that 18bp line spacing is a calibration assumption.
- [ ] Default to portable Fandol/TeX Gyre fonts. Submission mode requires SimSun, SimHei and Times New Roman; absent fonts are fatal, never silently replaced.
- [ ] College profile is a file in config/colleges, selected separately from the displayed department. Apply profile before explicit user overrides; fixtures verify this precedence.

## Task 3 References
- [ ] Implement cueb-bibliography.bbx on gb7714-2005 and cueb-footnote.cbx on verbose. Define \cuebcite[page]{key} as a full citation in a new globally numbered bracketed footnote; normal footnotes share its counter.
- [ ] Sort bibliography by presort, sortkey, name, year/title. Map langid=chinese to the Chinese group, all other languages to foreign; require/document explicit Chinese pinyin sortname or sortkey. Set numeric bibliography labels after sorting, distinct from note sequence.
- [ ] Match article, book and online note fields to the handbook; render URL and publication date for online entries. Repeated citations create new notes; multiple keys preserve input citation order inside one note.
- [ ] Compile acceptance fixture with XeLaTeX/Biber and assert PDF text, .aux labels and .bbl order. Test submission missing-font error and bad metadata/config errors.

## Task 4 Examples, documentation and packaging
- [ ] Create main.tex, cuebsetup.tex, data/*.tex, ref/refs.bib, examples/minimal.tex with an original explanatory demo containing equations, table, longtable, diagram, multiple notes and appendices. Clearly identify synthetic data and avoid fabricated research claims.
- [ ] Add README.md, docs/requirements.md, docs/quickstart.md, assets/README.md, UPSTREAM.md, CHANGELOG.md, LPPL LICENSE and .gitignore. Record unconfirmed cover layout, edition, numbering conflict, binding interpretation and preview fonts.
- [ ] Add latexmkrc, Makefile, utils/check.py, utils/create_release.py and .github/workflows/test.yml. Build main and minimal examples, check fixture behavior, package only intended project files and PDF outputs. No original student document or personal sample data in repository.

## Task 5 Validate and finish
- [ ] Run make test and make thesis from a clean build, inspect log errors/warnings and PDF page/font/text properties.
- [ ] Render every page of main.pdf, inspect images, fix clipping or collisions and rerun affected checks.
- [ ] Independent specification review, then code quality review; resolve issues before final commit.
- [ ] Build ZIP, verify it compiles after fresh extraction and includes documentation. Record exact installed tool versions and validation limits.
- [ ] Commit coherent changes, merge the completed feature branch into main locally, tag v0.1.0 and verify a clean Git status. No remote publication requested.
