%%
%% sw-studios.cls
%% StormWeaver Studios — internal preprint class.
%%
%% Single-column layout with SIGGRAPH/acmart typography: Libertinus,
%% sans headings, plain theorems, author-year citations.
%% Build with: xelatex -shell-escape (fontspec + minted).
%%
%% Options:
%%   personal  — author's name instead of "StormWeaver Studios" in the
%%               strip and running head. Confidentiality notice stays.
%%   Other options are passed to article.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sw-studios}[2026/10/04 v2.0 StormWeaver Studios internal preprint class]

\newif\ifsw@personal
\DeclareOption{personal}{\sw@personaltrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt]{article}

%% ------------------------------------------------------------------
%% 1. Page, fonts, headings
%% ------------------------------------------------------------------
\RequirePackage[a4paper,margin=1.1in,marginparwidth=0.8in,marginparsep=0.12in]{geometry}
\RequirePackage{amsmath,amssymb,mathtools,amsthm}
\RequirePackage[libertine]{newtxmath}
\RequirePackage{fontspec}
%% Loaded by filename from the TeX tree (packages libertinus-fonts,
%% inconsolata), so no system font install is needed.
\setmainfont{LibertinusSerif}[Extension=.otf, UprightFont=*-Regular,
  BoldFont=*-Bold, ItalicFont=*-Italic, BoldItalicFont=*-BoldItalic]
\setsansfont{LibertinusSans}[Extension=.otf, UprightFont=*-Regular,
  BoldFont=*-Bold, ItalicFont=*-Italic, BoldItalicFont=*-Bold]
\setmonofont{Inconsolatazi4}[Extension=.otf, UprightFont=*-Regular,
  BoldFont=*-Bold, ItalicFont=*-Regular, Scale=MatchLowercase]
\RequirePackage{microtype}
\RequirePackage[table]{xcolor}
\definecolor{swGray}{HTML}{5A5A5A}   % strip, running head, footer, margin tags
\definecolor{swRule}{HTML}{B0B0B0}   % title/abstract rules
\numberwithin{equation}{section}

\RequirePackage{titlesec}
\titleformat{\section}{\normalfont\large\sffamily\bfseries}{\thesection}{0.6em}{}
\titleformat{\subsection}{\normalfont\normalsize\sffamily\bfseries}{\thesubsection}{0.6em}{}
\titleformat{\subsubsection}[runin]{\normalfont\normalsize\sffamily\itshape}{\thesubsubsection}{0.5em}{}[.]
\titlespacing*{\section}{0pt}{1.4em}{0.5em}
\titlespacing*{\subsection}{0pt}{1.1em}{0.4em}

\RequirePackage{enumitem}
\setlist{itemsep=0.15em, topsep=0.4em}

%% ------------------------------------------------------------------
%% 2. Identity — metadata, studio/personal label, header and footer
%% ------------------------------------------------------------------
\newcommand{\swdoctype}[1]{\gdef\@swdoctype{#1}}
\newcommand{\swtagline}[1]{\gdef\@swtagline{#1}}
\newcommand{\swsubtitle}[1]{\gdef\@swsubtitle{#1}}
\newcommand{\swshorttitle}[1]{\gdef\@swshorttitle{#1}}
\swdoctype{Internal Preprint}
\swtagline{}
\swsubtitle{}
\swshorttitle{}

\newcommand{\sw@org}{\ifsw@personal\sw@notice@author\else StormWeaver Studios\fi}
\newcommand{\sw@confidential}{Confidential --- do not redistribute}
\newcommand{\swconfidential}[1]{\renewcommand{\sw@confidential}{#1}}

\RequirePackage{pgfkeys}
\gdef\sw@notice@author{}
\gdef\sw@notice@formatlink{}
\gdef\sw@notice@formatlinktext{format notes}
\gdef\sw@notice@repolink{}
\gdef\sw@notice@repolinktext{repository}
\pgfkeys{
  author/.store in=\sw@notice@author,
  formatlink/.store in=\sw@notice@formatlink,
  formatlinktext/.store in=\sw@notice@formatlinktext,
  repolink/.store in=\sw@notice@repolink,
  repolinktext/.store in=\sw@notice@repolinktext,
}
\newcommand{\swnotice}[1]{\pgfkeys{#1}}
%% Fall back to \author when \swnotice gives no author.
\AtBeginDocument{\ifx\sw@notice@author\@empty\let\sw@notice@author\@author\fi}

%% Head: label left, (short) title right. Foot: confidentiality left, page right.
%% The plain style (page 1) has the footer only.
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[L]{\footnotesize\sffamily\color{swGray}\sw@org}
\fancyhead[R]{\footnotesize\sffamily\color{swGray}%
  \ifx\@swshorttitle\@empty\@title\else\@swshorttitle\fi}
\fancyfoot[L]{\footnotesize\sffamily\color{swGray}\sw@confidential}
\fancyfoot[R]{\footnotesize\sffamily\thepage}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[L]{\footnotesize\sffamily\color{swGray}\sw@confidential}%
  \fancyfoot[R]{\footnotesize\sffamily\thepage}}

%% ------------------------------------------------------------------
%% 3. Title block (page 1) and abstract
%%    Strip: label · subtitle · doctype ... Do not redistribute
%% ------------------------------------------------------------------
%% Teaser: \swteaser[width]{image}{caption} before \maketitle. Full-width
%% figure under the author line, numbered as Figure 1. \label goes in caption.
\let\sw@teaser\@empty
\newcommand{\swteaser}[3][\textwidth]{%
  \gdef\sw@teaser{%
    \begin{center}
      \includegraphics[width=#1]{#2}%
      \captionof{figure}{#3}%
    \end{center}}}

\renewcommand{\maketitle}{%
  \thispagestyle{plain}%
  \begingroup\raggedright
  {\footnotesize\sffamily\color{swGray}%
    \sw@org
    \ifsw@personal\else\ifx\@swsubtitle\@empty\else\ \textperiodcentered\ \@swsubtitle\fi\fi
    \ \textperiodcentered\ \@swdoctype
    \hfill\textbf{Do not redistribute}\par}
  \vspace{0.3em}{\color{swRule}\rule{\textwidth}{0.4pt}}\par
  \vspace{1.4em}
  {\sffamily\bfseries\fontsize{20}{24}\selectfont\@title\par}
  \ifx\@swtagline\@empty\else
    \vspace{0.5em}{\large\itshape\@swtagline\par}
  \fi
  \vspace{1em}
  {\sffamily\large\@author\par}
  \vspace{0.2em}
  {\sffamily\small\color{swGray}\@date
    \ifx\sw@notice@repolink\@empty\else
      \ \textperiodcentered\ \href{\sw@notice@repolink}{\sw@notice@repolinktext}\fi
    \ifx\sw@notice@formatlink\@empty\else
      \ \textperiodcentered\ \href{\sw@notice@formatlink}{\sw@notice@formatlinktext}\fi
    \par}
  \endgroup
  \ifx\sw@teaser\@empty\else
    \vspace{0.8em}\sw@teaser\vspace{-0.4em}%
  \fi
  \vspace{1.6em}%
}

\renewenvironment{abstract}%
  {\small\noindent{\sffamily\bfseries Abstract.}\ \ignorespaces}%
  {\par\vspace{1.2em}\noindent{\color{swRule}\rule{\textwidth}{0.4pt}}\par\vspace{0.6em}}

%% ------------------------------------------------------------------
%% 4. Floats, algorithms, links
%%    cleveref is loaded before the theorems are defined so it picks them up.
%% ------------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage[labelfont={bf,sf}, font=small, labelsep=period]{caption}
\RequirePackage{subcaption}
\RequirePackage{booktabs,array,multirow}
\RequirePackage[ruled,vlined,linesnumbered]{algorithm2e}
\SetKwComment{Comment}{$\triangleright$\ }{}
%% Thin rules to match the code listings (algorithm2e default is 0.8pt).
\setlength{\algoheightrule}{0.5pt}
\setlength{\algotitleheightrule}{0.3pt}
\RequirePackage[colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black]{hyperref}
\RequirePackage[nameinlink]{cleveref}

%% ------------------------------------------------------------------
%% 5. Theorems — plain amsthm, one shared section-scoped counter.
%%    \begin{theorem}{Name}{label} -> \cref{th:label}; empty Name omits it.
%%    Label prefixes: th lem prop cor conj def ex.
%% ------------------------------------------------------------------
%% amsthm's plain/definition/remark with more air between stacked blocks.
\newtheoremstyle{swplain}{0.9em}{0.9em}{\itshape}{}{\bfseries}{.}{0.5em}{}
\newtheoremstyle{swdefinition}{0.9em}{0.9em}{\normalfont}{}{\bfseries}{.}{0.5em}{}
\newtheoremstyle{swremark}{0.7em}{0.7em}{\normalfont}{}{\itshape}{.}{0.5em}{}
\theoremstyle{swplain}
\newtheorem{swtheorem}{Theorem}[section]
\newtheorem{swlemma}[swtheorem]{Lemma}
\newtheorem{swprop}[swtheorem]{Proposition}
\newtheorem{swcor}[swtheorem]{Corollary}
\newtheorem{swconj}[swtheorem]{Conjecture}
\theoremstyle{swdefinition}
\newtheorem{swdef}[swtheorem]{Definition}
\newtheorem{swexample}[swtheorem]{Example}
\theoremstyle{swremark}
\newtheorem{swremark}[swtheorem]{Remark}

\newcommand{\sw@thmenv}[3]{% {public env}{amsthm env}{label prefix}
  \newenvironment{#1}[2]{%
    \def\sw@tmp{##1}%
    \ifx\sw@tmp\@empty\begin{#2}\else\begin{#2}[##1]\fi
    \label{#3:##2}}{\end{#2}}}
\sw@thmenv{theorem}{swtheorem}{th}
\sw@thmenv{lemma}{swlemma}{lem}
\sw@thmenv{proposition}{swprop}{prop}
\sw@thmenv{corollary}{swcor}{cor}
\sw@thmenv{conjecture}{swconj}{conj}
\sw@thmenv{definition}{swdef}{def}
\sw@thmenv{example}{swexample}{ex}

%% Remark: optional [name], numbered with the theorems.
\newenvironment{remark}[1][]%
  {\def\sw@tmp{#1}\ifx\sw@tmp\@empty\begin{swremark}\else\begin{swremark}[#1]\fi}%
  {\end{swremark}}

\crefname{swtheorem}{Theorem}{Theorems}
\crefname{swlemma}{Lemma}{Lemmas}
\crefname{swprop}{Proposition}{Propositions}
\crefname{swcor}{Corollary}{Corollaries}
\crefname{swconj}{Conjecture}{Conjectures}
\crefname{swdef}{Definition}{Definitions}
\crefname{swexample}{Example}{Examples}
\crefname{swremark}{Remark}{Remarks}

%% Implementation note: unnumbered run-in paragraph, optional [label].
\newenvironment{implnote}[1][]%
  {\par\medskip\noindent{\itshape Implementation note%
    \def\sw@tmp{#1}\ifx\sw@tmp\@empty\else\ (#1)\fi.}\ \ignorespaces}%
  {\par\medskip}

%% ------------------------------------------------------------------
%% 6. Internal markers — proof-status margin tags, \tool{} inline technique.
%% ------------------------------------------------------------------
\newcommand{\sw@margintag}[1]{%
  \leavevmode\marginpar{\raggedright\footnotesize\sffamily\scshape\color{swGray}#1}}
\newenvironment{proventag}{\par\noindent\sw@margintag{proven}\ignorespaces}{\par}
\newenvironment{numconfirmedtag}{\par\noindent\sw@margintag{numerical}\ignorespaces}{\par}
\newenvironment{openitemtag}{\par\noindent\sw@margintag{open}\ignorespaces}{\par}
\newcommand{\tool}[1]{{\footnotesize\sffamily[#1]}}

%% ------------------------------------------------------------------
%% 7. Code listings — minted between thin rules, bold title row.
%%    swcode[tcolorbox options]{language}; cppcode/pycode[title].
%% ------------------------------------------------------------------
\RequirePackage{minted}
\RequirePackage[skins,breakable,minted]{tcolorbox}
\setminted{fontsize=\small, breaklines=true, tabsize=2, breaksymbolleft={}}
\tcbset{swcodestyle/.style={
  listing engine=minted, listing only, breakable,
  minted style=friendly_grayscale,
  minted options={fontsize=\small, breaklines, tabsize=2},
  enhanced, sharp corners, colback=white, colframe=black,
  boxrule=0pt, toprule=0.5pt, bottomrule=0.5pt,
  left=2pt, right=2pt, top=2pt, bottom=2pt,
  coltitle=black, colbacktitle=white, titlerule=0.3pt,
  fonttitle=\sffamily\bfseries\small}}
\newtcblisting{swcode}[2][]{swcodestyle, minted language=#2, #1}
\newtcblisting{cppcode}[1][C++]{swcodestyle, minted language=c++, title={#1}}
\newtcblisting{pycode}[1][Python]{swcodestyle, minted language=python, title={#1}}

%% ------------------------------------------------------------------
%% 8. Tables, TOC, bibliography
%% ------------------------------------------------------------------
\setlength{\tabcolsep}{7pt}
\newcommand{\swtablehead}{\bfseries\sffamily}
\newcommand{\swtablealt}{\rowcolors{2}{black!4}{white}}

%% Optional table of contents; not page-broken.
\newcommand{\swtoc}{{\small\tableofcontents}\bigskip}

%% Author-year: \citep -> (Loubet et al., 2019), \citet -> Loubet et al. (2019).
%% Change with \swbibstyle{...}.
\RequirePackage[round,sort]{natbib}
\setlength{\bibsep}{0.3em}
\newcommand{\swbibstyle}[1]{\bibliographystyle{#1}}
\swbibstyle{plainnat}
\newcommand{\swbibliography}[1]{{\small\bibliography{#1}}}

\AtBeginDocument{\hypersetup{pdftitle=\@title, pdfauthor=\@author}}

\endinput
