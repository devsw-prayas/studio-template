%%
%% stormweaver.cls
%% StormWeaver Studios / NIT Rourkela — technical document class
%%
%% Requires: xelatex (uses fontspec + system TeX Gyre fonts, no install needed)
%%
%% Provides:
%%   - branded title page (\maketitle) with lab wordmark + confidentiality footer
%%   - section-scoped theorem/lemma/proposition/corollary/definition environments
%%   - three "proof-tier" boxes matching the proven / numerically-confirmed /
%%     open-flagged discipline used across the project's test suites
%%   - \tool{...} inline callout for methodology (naming the exact technique used
%%     at each derivation step)
%%   - macros for recurring project symbols (K_x, H_wp, J_TIR, lambda_ex, etc.)
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sw-studios}[2026/07/22 v1.0 StormWeaver Studios technical document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

\RequirePackage{fontspec}
\RequirePackage[a4paper,margin=0.95in,top=1in,bottom=1in]{geometry}
\RequirePackage[table]{xcolor}
\RequirePackage{amsmath,amssymb,mathtools}
\numberwithin{equation}{section}
\RequirePackage{amsthm}
\RequirePackage[skins,breakable,theorems]{tcolorbox}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{multirow}
\setlength{\tabcolsep}{7pt}
\renewcommand{\arraystretch}{1.15}

%% Header row styling for tables — standard academic style (booktabs), no
%% heavy fill. Usage: \toprule \swtablehead Col1 & Col2 \\ \midrule
\newcommand{\swtablehead}{\bfseries\sffamily}
%% Alternating row tint for long/dense tables (call once before tabular) — opt-in only
\newcommand{\swtablealt}{\rowcolors{2}{swPaper}{white}}
\RequirePackage{microtype}
\RequirePackage[colorlinks=true]{hyperref}

%% ------------------------------------------------------------------
%% 1. Palette — warm, ink-and-amber. Named so it reads in source, not hex soup.
%% ------------------------------------------------------------------
\definecolor{swInk}{HTML}{1A1A1A}      % near-black — headers, primary theorem frames
\definecolor{swAmber}{HTML}{4A4A4A}    % dark charcoal — open/flagged tier, links
\definecolor{swTeal}{HTML}{707070}     % mid gray — numerically-confirmed tier, definitions
\definecolor{swPaper}{HTML}{F1F0EE}    % warm-neutral light gray — box backgrounds
\definecolor{swGray}{HTML}{4F4F4F}     % secondary text, captions, footers

\hypersetup{linkcolor=swInk, citecolor=swTeal, urlcolor=swAmber}

%% ------------------------------------------------------------------
%% 2. Typography — TeX Gyre (metric-compatible, no external install needed)
%%    Pagella (Palatino-alike) reads warmer than Computer Modern; Heros for
%%    display/sans, matching the amber/ink identity.
%% ------------------------------------------------------------------
%% Requested fonts: Times New Roman (body) + Consolas (monospace).
%% These are proprietary Microsoft fonts — fontspec finds them by name on any
%% system that has them installed (Windows/Office ships both). If compiling
%% on a machine without them, swap in the commented fallbacks below.
\setmainfont{Times New Roman}
\setsansfont{TeX Gyre Heros}
\setmonofont{Consolas}[Scale=0.92]
%% Fallback (no Times/Consolas installed): metric-compatible free clones —
% \setmainfont{TeX Gyre Termes}
% \setmonofont{DejaVu Sans Mono}[Scale=0.88]
\setlength{\parskip}{0pt}
\setlength{\parindent}{1.2em}

\titleformat{\section}{\normalfont\large\bfseries\sffamily\color{swInk}}{\thesection}{0.5em}{}
\titleformat{\subsection}{\normalfont\normalsize\bfseries\sffamily\color{swInk}}{\thesubsection}{0.5em}{}
\titleformat{\subsubsection}{\normalfont\small\bfseries\sffamily\color{swInk}}{\thesubsubsection}{0.5em}{}
\titlespacing*{\section}{0pt}{1.3em}{0.5em}

%% ------------------------------------------------------------------
%% 3. Header / footer — lab wordmark running head + optional confidentiality line
%% ------------------------------------------------------------------
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhead[L]{\small\sffamily\color{swGray} StormWeaver Studios}
\fancyhead[R]{\small\sffamily\color{swGray} \nouppercase{\leftmark}}
\fancyfoot[C]{\small\sffamily\color{swGray} \thepage}

\newcommand{\swconfidential}[1]{%
  \fancyfoot[C]{\footnotesize\sffamily\color{swAmber} #1 \hfill \thepage}%
}

%% ------------------------------------------------------------------
%% 4. Title page metadata + \maketitle
%% ------------------------------------------------------------------
\newcommand{\swdoctype}[1]{\gdef\@swdoctype{#1}}
\newcommand{\swtagline}[1]{\gdef\@swtagline{#1}}
\newcommand{\swsubtitle}[1]{\gdef\@swsubtitle{#1}}
\swdoctype{Technical Document}
\swtagline{}
\swsubtitle{High Performance Graphics and Light Transport Research}

%% ------------------------------------------------------------------
%% 4b. Title-page identity/notice block — "internal document, written by,
%%     non-standard format note + link, repo link, do-not-redistribute."
%%     Usage (before \maketitle):
%%       \swnotice{
%%         author={Prayas Bharadwaj},
%%         formatlink={https://example.com/format-note},
%%         repolink={https://github.com/devsw-prayas/Inverse-Spectral-Rendering}
%%       }
%% ------------------------------------------------------------------
\RequirePackage{pgfkeys}
\gdef\sw@notice@author{}
\gdef\sw@notice@formatlink{}
\gdef\sw@notice@formatlinktext{format notes}
\gdef\sw@notice@repolink{}
\gdef\sw@notice@repolinktext{here}
\gdef\sw@notice@active{0}
\pgfkeys{
  author/.store in=\sw@notice@author,
  formatlink/.store in=\sw@notice@formatlink,
  formatlinktext/.store in=\sw@notice@formatlinktext,
  repolink/.store in=\sw@notice@repolink,
  repolinktext/.store in=\sw@notice@repolinktext,
}
\newcommand{\swnotice}[1]{\gdef\sw@notice@active{1}\pgfkeys{#1}}

\newcommand{\sw@noticebox}{%
  \ifnum\sw@notice@active=1
    \begin{center}
    \begin{tcolorbox}[colback=swPaper, colframe=swInk, boxrule=0.5pt,
      width=0.85\textwidth, left=8pt, right=8pt, top=6pt, bottom=6pt,
      fontupper=\sffamily\small\color{swGray}]
      \textbf{\color{swInk}This is an internal research document from
      StormWeaver Studios.}\\[0.4em]
      Written by --- \sw@notice@author\\[0.2em]
      \ifx\sw@notice@formatlink\@empty\else
        This document follows a non-standard format --- see
        \href{\sw@notice@formatlink}{\nolinkurl{\sw@notice@formatlinktext}}\\[0.2em]
      \fi
      \ifx\sw@notice@repolink\@empty\else
        For further details --- \href{\sw@notice@repolink}{\nolinkurl{\sw@notice@repolinktext}}\\[0.2em]
      \fi
      \textbf{\color{swAmber}Do not redistribute.}
    \end{tcolorbox}
    \end{center}
  \fi
}

\renewcommand{\maketitle}{%
  \begin{titlepage}
    \newgeometry{margin=0.9in}
    \color{swInk}
    \begin{center}
      \rule{\textwidth}{1.1pt}\\[0.35em]
      {\sffamily\bfseries\LARGE StormWeaver Studios}\\[0.15em]
      \ifx\@swsubtitle\@empty\else
        {\sffamily\color{swGray}\small \@swsubtitle}\\[0.35em]
      \fi
      \rule{\textwidth}{1.1pt}\\[1.8em]
      {\sffamily\color{swAmber}\bfseries\MakeUppercase{\@swdoctype}}\\[1em]
      {\fontsize{19}{23}\selectfont\bfseries \@title}\\[0.9em]
      \ifx\@swtagline\@empty\else
        {\itshape\color{swGray}\normalsize \@swtagline}\\[1em]
      \fi
      \vspace{1.2em}
      {\sffamily\@author}\\[0.2em]
      {\sffamily\color{swGray}\@date}
      \ifx\@swversion\@empty\else\\[0.15em]
        {\sffamily\footnotesize\color{swGray}\ttfamily \@swversion}
      \fi
    \end{center}
    \vfill
    \sw@noticebox
    \begin{center}
      \small\color{swGray}\itshape
      Shared privately and in confidence. Not for redistribution.
    \end{center}
    \restoregeometry
  \end{titlepage}
}

%% ------------------------------------------------------------------
%% 5. Theorem machinery — section-scoped numbering (Theorem 3.2 style),
%%    via tcolorbox's theorem library so numbering + styling are one thing.
%% ------------------------------------------------------------------
\tcbuselibrary{theorems}

\newtcbtheorem[number within=section]{swtheorem}{Theorem}%
{colback=swPaper, colframe=swInk, boxrule=0.6pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swInk, breakable}
{th}

\newtcbtheorem[number within=section]{swlemma}{Lemma}%
{colback=swPaper, colframe=swInk!70, boxrule=0.5pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swInk!70, breakable}
{lem}

\newtcbtheorem[number within=section]{swprop}{Proposition}%
{colback=swPaper, colframe=swInk!70, boxrule=0.5pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swInk!70, breakable}
{prop}

\newtcbtheorem[number within=section]{swcor}{Corollary}%
{colback=swPaper, colframe=swInk!70, boxrule=0.5pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swInk!70, breakable}
{cor}

\newtcbtheorem[number within=section]{swdef}{Definition}%
{colback=white, colframe=swTeal, boxrule=0.6pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swTeal, breakable}
{def}

%% Convenience wrappers so body text reads \begin{theorem}{Name}{label} not
%% the raw tcolorbox syntax.
\newenvironment{theorem}[2]{\begin{swtheorem}{#1\strut}{#2}}{\end{swtheorem}}
\newenvironment{lemma}[2]{\begin{swlemma}{#1\strut}{#2}}{\end{swlemma}}
\newenvironment{proposition}[2]{\begin{swprop}{#1\strut}{#2}}{\end{swprop}}
\newenvironment{corollary}[2]{\begin{swcor}{#1\strut}{#2}}{\end{swcor}}
\newenvironment{definition}[2]{\begin{swdef}{#1\strut}{#2}}{\end{swdef}}

%% Plain (unboxed) proof, standard style, small square end mark.
\renewenvironment{proof}[1][\proofname]{\par\smallskip\noindent%
  {\sffamily\bfseries\color{swGray}#1.}\hspace{0.4em}}{\hfill$\blacksquare$\par\smallskip}

\newtcbtheorem[number within=section]{swconj}{Conjecture}%
{colback=swPaper, colframe=swTeal, boxrule=0.6pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swTeal, breakable}
{conj}
\newenvironment{conjecture}[2]{\begin{swconj}{#1\strut}{#2}}{\end{swconj}}

\newtcbtheorem[number within=section]{swexample}{Example}%
{colback=white, colframe=swGray, boxrule=0.5pt, left=5pt, right=5pt,
 top=2pt, bottom=2pt, fonttitle=\sffamily\bfseries, coltitle=white,
 colbacktitle=swGray, breakable}
{ex}
\newenvironment{example}[2]{\begin{swexample}{#1\strut}{#2}}{\end{swexample}}

%% Implementation Note — callout style (left bar, no title tab), distinct
%% from the formal theorem family since it's a note about code/engineering,
%% not a mathematical claim. Usage: \begin{implnote}[optional short label]
\newcounter{swimplnote}[section]
\renewcommand{\theswimplnote}{\thesection.\arabic{swimplnote}}
\newtcolorbox{implnotebox}{colback=swPaper, colframe=swGray, boxrule=0pt,
  leftrule=2.5pt, arc=0pt, top=4pt, bottom=4pt, left=8pt, right=8pt}
\newenvironment{implnote}[1][]{%
  \refstepcounter{swimplnote}%
  \begin{implnotebox}%
  {\sffamily\bfseries\color{swInk}Implementation Note~\theswimplnote%
    \ifx\relax#1\relax\else\ (#1)\fi.}\quad\ignorespaces}%
  {\end{implnotebox}}

%% Remark — standard unboxed style, section-scoped, shares proof's plain look.
\newcounter{swremark}[section]
\renewcommand{\theswremark}{\thesection.\arabic{swremark}}
\newenvironment{remark}[1][]{%
  \refstepcounter{swremark}\par\smallskip\noindent%
  {\sffamily\bfseries\color{swGray}Remark~\theswremark%
    \ifx\relax#1\relax\else\ (#1)\fi.}\hspace{0.4em}\itshape}%
  {\par\smallskip}

%% ------------------------------------------------------------------
%% 6b. Proof-tier tags — for SCRATCH/WORKING documents (session logs, the
%%     inventory pass) where you want proof status visible at a glance.
%%     NOT meant for a finalized preprint — there, use the standard
%%     academic environments instead: Theorem/Lemma/etc. for proven claims,
%%     Conjecture for numerically-confirmed-only, Remark for open items.
%% ------------------------------------------------------------------
\newtcolorbox{proventag}{colback=swInk!6, colframe=swInk, boxrule=0.5pt,
  left=6pt, right=6pt, top=3pt, bottom=3pt, fonttitle=\sffamily\bfseries\small,
  title=PROVEN, coltitle=white, colbacktitle=swInk, breakable}

\newtcolorbox{numconfirmedtag}{colback=swTeal!6, colframe=swTeal, boxrule=0.5pt,
  left=6pt, right=6pt, top=3pt, bottom=3pt, fonttitle=\sffamily\bfseries\small,
  title=NUMERICALLY CONFIRMED ONLY, coltitle=white, colbacktitle=swTeal, breakable}

\newtcolorbox{openitemtag}{colback=swAmber!6, colframe=swAmber, boxrule=1.1pt,
  left=6pt, right=6pt, top=3pt, bottom=3pt, fonttitle=\sffamily\bfseries\small,
  title=OPEN / FLAGGED, coltitle=white, colbacktitle=swAmber, breakable}

%% ------------------------------------------------------------------
%% 7. \tool{...} — inline methodology callout, matching the project's
%%    "name the exact technique at every derivation step" discipline.
%% ------------------------------------------------------------------
\newcommand{\tool}[1]{{\sffamily\small\color{swTeal}[tool: #1]}}

%% ------------------------------------------------------------------
%% 8. Recurring symbol macros
%% ------------------------------------------------------------------
\newcommand{\Kx}{K_x}
\newcommand{\Ke}{K_e}
\newcommand{\bispec}{K(\lambda,\lambda')}
\newcommand{\Hwp}{H_{\mathrm{wp}}}
\newcommand{\JTIR}{J_{\mathrm{TIR}}}
\newcommand{\Jtheta}{J_\theta}
\newcommand{\Vtheta}{V_\theta}
\newcommand{\Phitheta}{\Phi_\theta}
\newcommand{\lex}{\lambda_{\mathrm{ex}}}
\newcommand{\lem}{\lambda_{\mathrm{em}}}
\newcommand{\sigf}{\sigma_f}
\newcommand{\lstar}{\lambda^{*}}

%% ------------------------------------------------------------------
%% 9. Code listings — minted (real Pygments highlighting), boxed to match
%%    the theorem styling. Requires compiling with -shell-escape.
%% ------------------------------------------------------------------
\RequirePackage{minted}
\usemintedstyle{friendly_grayscale}
\tcbuselibrary{minted}
\setminted{fontsize=\small, breaklines=true, tabsize=2, breaksymbolleft={}}

\newtcblisting{cppcode}[1][C++]{%
  listing engine=minted, minted style=friendly_grayscale, minted language=c++,
  minted options={fontsize=\small, breaklines, tabsize=2},
  colback=swPaper, colframe=swInk, boxrule=0.6pt,
  left=4pt, right=4pt, top=2pt, bottom=2pt,
  fonttitle=\sffamily\bfseries\small, coltitle=white, colbacktitle=swInk,
  listing only, breakable, title={#1}}

\newtcblisting{pycode}[1][Python]{%
  listing engine=minted, minted style=friendly_grayscale, minted language=python,
  minted options={fontsize=\small, breaklines, tabsize=2},
  colback=swPaper, colframe=swTeal, boxrule=0.6pt,
  left=4pt, right=4pt, top=2pt, bottom=2pt,
  fonttitle=\sffamily\bfseries\small, coltitle=white, colbacktitle=swTeal,
  listing only, breakable, title={#1}}

%% Generic: \begin{swcode}[title={Kernel}]{cuda}...\end{swcode}
\newtcblisting{swcode}[2][title=Code]{%
  listing engine=minted, minted style=friendly_grayscale, minted language=#2,
  minted options={fontsize=\small, breaklines, tabsize=2},
  colback=swPaper, colframe=swInk, boxrule=0.6pt,
  left=4pt, right=4pt, top=2pt, bottom=2pt,
  fonttitle=\sffamily\bfseries\small, coltitle=white, colbacktitle=swInk,
  listing only, breakable, #1}

%% ------------------------------------------------------------------
%% 9. Table of contents — styled to match section headers (ink, sans-bold),
%%    dotted leaders. Just call \tableofcontents as normal; \swtoc is a
%%    convenience alias that also forces it onto its own page.
%% ------------------------------------------------------------------
\RequirePackage{tocloft}
\renewcommand{\cftsecfont}{\sffamily\bfseries\color{swInk}}
\renewcommand{\cftsecpagefont}{\sffamily\color{swInk}}
\renewcommand{\cftsubsecfont}{\sffamily\color{swGray}}
\renewcommand{\cftsubsecpagefont}{\sffamily\color{swGray}}
\renewcommand{\contentsname}{\sffamily Contents}
\setlength{\cftbeforesecskip}{0.6em}

\newcommand{\swtoc}{%
  \begingroup
  \hypersetup{linkcolor=swInk}
  \tableofcontents
  \endgroup
  \clearpage
}

%% ------------------------------------------------------------------
%% 10. Bibliography — natbib (BibTeX-based, no biber dependency).
%%     Numeric, sorted+compressed citations by default (e.g. [3,7-9]).
%%     Usage: \swbibliography{refs}   (expects refs.bib next to the .tex)
%% ------------------------------------------------------------------
\RequirePackage[numbers,sort&compress]{natbib}
\newcommand{\swbibstyle}[1]{\bibliographystyle{#1}}
\swbibstyle{alpha}
%% NOTE: alpha.bst (author-initial keys, e.g. [ZSGJ21]) is not natbib-aware for
%% the *textual* citation form. Use \cite{} or \citep{} (both render correctly,
%% e.g. "[ZSGJ21]") — avoid \citet{} in alpha mode, it will print "(author?)".
%% To go back to numeric citations: \swbibstyle{unsrtnat} (then \citet works too).
\newcommand{\swbibliography}[1]{%
  \begingroup
  \sffamily
  \bibliography{#1}
  \endgroup
}

%% ------------------------------------------------------------------
%% 11. Figures — graphicx + styled captions (small, sans, ink label).
%% ------------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage[
  labelfont={bf,sf,color=swInk},
  font={small},
  textfont={color=swGray},
  labelsep=colon
]{caption}
\RequirePackage{subcaption}

%% ------------------------------------------------------------------
%% 12. cleveref — \cref{}/\Cref{} auto-name the reference type.
%%     Loaded after everything else that defines labels/counters.
%% ------------------------------------------------------------------
\RequirePackage[nameinlink]{cleveref}
\crefname{tcb@cnt@swtheorem}{Theorem}{Theorems}   \Crefname{tcb@cnt@swtheorem}{Theorem}{Theorems}
\crefname{tcb@cnt@swlemma}{Lemma}{Lemmas}         \Crefname{tcb@cnt@swlemma}{Lemma}{Lemmas}
\crefname{tcb@cnt@swprop}{Proposition}{Propositions} \Crefname{tcb@cnt@swprop}{Proposition}{Propositions}
\crefname{tcb@cnt@swcor}{Corollary}{Corollaries}  \Crefname{tcb@cnt@swcor}{Corollary}{Corollaries}
\crefname{tcb@cnt@swdef}{Definition}{Definitions} \Crefname{tcb@cnt@swdef}{Definition}{Definitions}
\crefname{tcb@cnt@swconj}{Conjecture}{Conjectures} \Crefname{tcb@cnt@swconj}{Conjecture}{Conjectures}
\crefname{swremark}{Remark}{Remarks} \Crefname{swremark}{Remark}{Remarks}
\crefname{tcb@cnt@swexample}{Example}{Examples} \Crefname{tcb@cnt@swexample}{Example}{Examples}
\crefname{swimplnote}{Implementation Note}{Implementation Notes} \Crefname{swimplnote}{Implementation Note}{Implementation Notes}

%% ------------------------------------------------------------------
%% 13. Algorithm / pseudocode — algorithm2e, ruled+vlined, numbered
%%     per-section to match everything else.
%% ------------------------------------------------------------------
\RequirePackage[ruled,vlined,linesnumbered]{algorithm2e}
\renewcommand{\algorithmcfname}{Algorithm}
\SetKwComment{Comment}{$\triangleright$\ }{}

%% ------------------------------------------------------------------
%% 14. Appendix — plain \appendix works out of the box (core LaTeX);
%%     section headers keep the same styling automatically (Section A,
%%     B, ... instead of 1, 2, ...). No extra package needed.
%% ------------------------------------------------------------------

%% ------------------------------------------------------------------
%% 15. PDF metadata + optional version/provenance stamp on title page.
%%     \swversion{...} e.g. commit hash / date, printed under the date.
%% ------------------------------------------------------------------
\AtBeginDocument{\hypersetup{pdftitle=\@title, pdfauthor=\@author}}
\newcommand{\swversion}[1]{\gdef\@swversion{#1}}
\swversion{}

\endinput
