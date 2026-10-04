# sw-studios document class

A LaTeX class for StormWeaver Studios internal preprints. Typography and
restraint borrowed from SIGGRAPH papers (Libertinus, sans headings, plain
theorems, author-year citations), single column, with a thin internal strip
and confidentiality footer so it's clearly not a published paper.

## Files

- `sw-studios.cls` — the document class. Drop this next to your `.tex` file.
- `main.tex` — orchestrator: title metadata, abstract, `\input`s the rest.
- `body.inc` — main content (currently an environment gallery — replace it).
- `appendix.inc` — appendix content (letter-numbered sections via `\appendix`).
- `bib.inc` — just the `\swbibliography{refs}` call.
- `refs.bib` — citation database.
- `example/` — the same files plus a rendered `main.pdf`.

## Compiling

Requires **XeLaTeX** with **shell-escape** (for `minted`):

```bash
xelatex -shell-escape main.tex
bibtex main
xelatex -shell-escape main.tex
xelatex -shell-escape main.tex
```

In VS Code, `.vscode/settings.json` sets this up for LaTeX Workshop: saving
or `Ctrl+Alt+B` runs the full cycle above, cleans the build files, and opens
the PDF in a tab. It also maps `.inc`/`.cls` to LaTeX so they aren't
highlighted as assembly.

Fonts (Libertinus Serif/Sans, Inconsolata) are loaded by filename from the
TeX tree — MiKTeX/TeX Live packages `libertinus-fonts` and `inconsolata`. No
system install needed.

## Studio vs personal

```latex
\documentclass{sw-studios}            % "StormWeaver Studios" in strip + running head
\documentclass[personal]{sw-studios}  % your name instead (for outreach)
```

Both modes keep "Do not redistribute" in the strip and the confidentiality
footer.

## Title block

Set before `\maketitle`:

- `\title`, `\author`, `\date` — as usual
- `\swdoctype{...}` — shown in the strip (default "Internal Preprint")
- `\swsubtitle{...}` — appended after the studio name in the strip (optional, studio mode only)
- `\swtagline{...}` — italic line under the title (optional)
- `\swshorttitle{...}` — running-head title if the full one is too long (optional)
- `\swteaser[width]{image}{caption}` — full-width teaser figure under the
  author line, numbered Figure 1; put `\label{...}` inside the caption (optional)
- `\swconfidential{...}` — replaces the footer text (default "Confidential — do not redistribute")
- `\swnotice{author=..., repolink=..., repolinktext=..., formatlink=..., formatlinktext=...}`
  — links shown under the author line; `author` is the name used in `personal` mode
  (falls back to `\author`)

Follow `\maketitle` with `\begin{abstract}...\end{abstract}`. `\swtoc` adds an
optional table of contents.

## Environments

See the "Environment gallery" section of the compiled output. Summary:

- `theorem`, `lemma`, `proposition`, `corollary`, `conjecture`, `definition`,
  `example` — `\begin{theorem}{Name}{label}`, referenced as `\cref{th:label}`
  (prefixes `th lem prop cor conj def ex`). Plain amsthm style, one shared
  section-scoped counter.
- `remark[name]`, `implnote[label]`, `proof` — unboxed run-in paragraphs.
- `proventag`, `numconfirmedtag`, `openitemtag` — small-caps proof status in
  the margin. `\tool{...}` names a technique inline.
- `cppcode[title]`, `pycode[title]`, `swcode[title=...]{language}` — minted
  listings between thin rules.
- Tables: booktabs; `\swtablehead`, `\swtablealt`. Figures: standard
  `graphicx`/`caption`/`subcaption`. Algorithms: `algorithm2e`.

## Citations

Author-year via `plainnat`: `\citep{key}` → (Loubet et al., 2019),
`\citet{key}` → Loubet et al. (2019). Switch with `\swbibstyle{...}`.
