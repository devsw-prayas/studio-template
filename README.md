# sw-studios document class

A branded LaTeX document class for StormWeaver Studios — theorem-heavy
technical documents (internal preprints, research notes, working drafts)
with a consistent, dense, grayscale identity.

## Files

- `sw-studios.cls` — the document class. Drop this next to your `.tex` file.
- `main.tex` — orchestrator: title-page metadata + `\input`s the rest.
- `body.inc` — main content. Currently populated with a full environment
  gallery (see below) — replace with your actual document content.
- `appendix.inc` — appendix content (letter-numbered sections via `\appendix`).
- `bib.inc` — just the `\swbibliography{refs}` call.
- `refs.bib` — citation database.
- `convergence_plot.png` — example figure asset used in `body.inc`.

This split (`main.tex` / `body.inc` / `bib.inc` / `appendix.inc`) is just a
convention, not required by the class — extend it with more `.inc` files
(e.g. `preamble.inc`) however suits a given document.

## Compiling

Requires **XeLaTeX** (not pdfLaTeX — the class uses `fontspec` for Times New
Roman / Consolas) with **shell-escape enabled** (for `minted`'s syntax
highlighting, which shells out to Pygments).

Full compile cycle (bibliography needs its own pass):

```bash
xelatex -shell-escape main.tex
bibtex main
xelatex -shell-escape main.tex
xelatex -shell-escape main.tex
```

In VS Code with LaTeX Workshop, add a recipe with `xelatex -shell-escape`
and a `bibtex` step, or just run the four commands above manually.

### Fonts

The class requests **Times New Roman** and **Consolas** by name — both ship
with Windows/Office, so `fontspec` finds them automatically on a machine
that has them. If compiling somewhere without them, swap in the
metric-compatible fallbacks commented directly below the font declarations
near the top of `sw-studios.cls`:

```latex
% \setmainfont{TeX Gyre Termes}
% \setmonofont{DejaVu Sans Mono}[Scale=0.88]
```

## Environments

See the "Environment gallery" section in the compiled output (last section
of `body.inc`) for a live, rendered catalog with usage syntax for every
custom environment: `theorem`, `lemma`, `proposition`, `corollary`,
`definition`, `conjecture`, `remark`, `example`, `implnote`, plus the
draft-only tag boxes (`proventag`, `numconfirmedtag`, `openitemtag`),
code listings (`cppcode`, `pycode`, `swcode`), tables, figures, and
citations.

## Citation style

Default is **alpha-style** keys (e.g. `[ZSGJ21]`) via `alpha.bst`. Use
`\cite{}` or `\citep{}` — **not** `\citet{}`, which breaks under `alpha.bst`
(prints `(author?)`). To switch to numeric citations for a venue that
requires them:

```latex
\swbibstyle{unsrtnat}
```

`\citet{}` works normally again in that mode.

## Title-page toggles

Set any of these in `main.tex` before `\maketitle`:

- `\swdoctype{...}` — banner tag (e.g. "Internal Preprint")
- `\swtagline{...}` — italic subtitle under the title (optional)
- `\swsubtitle{...}` — line under "StormWeaver Studios" (optional, has a
  default)
- `\swversion{...}` — commit hash / version stamp under the date (optional)
- `\swconfidential{...}` — footer text (optional, plain page number if unset)
- `\swnotice{author=..., formatlink=..., repolink=..., formatlinktext=...,
  repolinktext=...}` — the identity/notice box (optional, box only appears
  if this is called)
