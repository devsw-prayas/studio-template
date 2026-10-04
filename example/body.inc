\section{Formal results: the rendering equation}
\label{sec:rendering}

This section exercises the proven-claim family (Definition, Theorem, Lemma,
Proposition, Corollary, Proof) using a generic radiometry example, unrelated
to any specific paper's content --- exactly what you'd reach for when writing
up a proven result.

\begin{definition}{Energy-conserving BRDF}{econs}
A BRDF $f_r(\omega_i,\omega_o)$ is energy-conserving if
\begin{equation}
  \int_{\Omega} f_r(\omega_i,\omega_o)\,\cos\theta_o\,d\omega_o \le 1
  \quad \text{for all } \omega_i.
  \label{eq:econs}
\end{equation}
\end{definition}

\begin{theorem}{Reciprocity of the ideal Lambertian BRDF}{lambertian}
The ideal Lambertian BRDF $f_r = \rho/\pi$ satisfies Helmholtz reciprocity,
$f_r(\omega_i,\omega_o) = f_r(\omega_o,\omega_i)$, for any albedo $\rho \in [0,1]$.
\end{theorem}

\begin{proof}
The expression $\rho/\pi$ does not depend on $\omega_i$ or $\omega_o$
individually, so swapping the two arguments leaves it unchanged.
\end{proof}

\begin{lemma}{Fresnel reflectance bounds}{fresnel-bounds}
For a dielectric interface with real index of refraction $\eta > 1$, the
unpolarized Fresnel reflectance satisfies $F(\theta) \in [F(0), 1]$ over
$\theta \in [0, \pi/2]$, monotonically increasing.
\end{lemma}

\begin{corollary}{Grazing-angle limit}{grazing}
As $\theta \to \pi/2$, $F(\theta) \to 1$ --- every dielectric becomes a
perfect mirror at grazing incidence.
\end{corollary}

\begin{proposition}{Diffuse albedo as a special case}{diffuse-special}
Setting $\rho = 1$ in \cref{def:econs} recovers a perfectly energy-conserving
white Lambertian surface, saturating \cref{eq:econs} with equality.
\end{proposition}

\begin{example}{Fresnel reflectance of glass at normal incidence}{glass-example}
For $\eta = 1.5$ (typical glass) and $\theta = 0$, the unpolarized Fresnel
reflectance is $F(0) = \left(\frac{\eta-1}{\eta+1}\right)^2 = 0.04$ ---
about 4\% of light reflects at normal incidence, matching the familiar rule
of thumb for glass surfaces.
\end{example}

\section{Draft-stage claims}
\label{sec:draft}

This section exercises Conjecture and Remark --- the standard academic slots
for numerically-confirmed-only and open/discussion content, respectively.

\begin{conjecture}{Convergence rate of stratified MC estimators}{mc-rate}
Stratified sampling of the hemisphere reduces estimator variance by a factor
of $O(1/N)$ relative to uniform sampling, for any BRDF with bounded
second derivative.
\end{conjecture}

\begin{remark}[floating-point precision]
Accumulating radiance contributions in \texttt{float32} across very long
paths (30+ bounces) can lose precision for low-albedo scenes; switching the
accumulator (not the per-bounce math) to \texttt{float64} is usually
sufficient and cheap.
\end{remark}

\section{Implementation}
\label{sec:impl}

This section exercises Algorithm, the three code-listing flavors, and
Implementation Note --- the practical, engineering-facing environments.

\begin{algorithm}[H]
\caption{Persistent-thread wavefront scheduling (per SM)}
\KwIn{work queue $Q$ of active path states}
\KwOut{updated queue after one wavefront pass}
\While{$Q$ is not empty}{
  pop a batch of paths from $Q$\;
  evaluate next bounce for each path in the batch\;
  \eIf{path terminated (RR kill or escaped scene)}{
    write result to output buffer\;
  }{
    push updated path state back onto $Q$\;
  }
}
\end{algorithm}

\begin{cppcode}[BVH ray--AABB slab test]
inline bool intersectAABB(const Ray& r, const AABB& box, float& tHit) {
    float tMin = 0.0f, tMax = r.tMax;
    for (int axis = 0; axis < 3; ++axis) {
        float invD = 1.0f / r.dir[axis];
        float t0 = (box.lo[axis] - r.origin[axis]) * invD;
        float t1 = (box.hi[axis] - r.origin[axis]) * invD;
        if (invD < 0.0f) std::swap(t0, t1);
        tMin = std::max(tMin, t0);
        tMax = std::min(tMax, t1);
        if (tMax <= tMin) return false;
    }
    tHit = tMin;
    return true;
}
\end{cppcode}

\begin{pycode}[Monte Carlo hemisphere integration]
def estimate_irradiance(brdf_fn, n_samples=4096):
    """Uniform-hemisphere MC estimate of outgoing irradiance."""
    omega = sample_hemisphere_uniform(n_samples)
    cos_theta = omega[:, 2]
    pdf = 1.0 / (2.0 * np.pi)
    values = brdf_fn(omega) * cos_theta
    return np.mean(values / pdf)
\end{pycode}

\begin{swcode}[title={Kernel launch configuration}]{cuda}
dim3 block(128, 1, 1);
dim3 grid((numPaths + block.x - 1) / block.x, 1, 1);
wavefrontKernel<<<grid, block, 0, stream>>>(pathStates, numPaths);
\end{swcode}

\begin{implnote}[RNG seeding]
Seed the per-path RNG with \texttt{path\_id XOR frame\_index}, not
\texttt{path\_id} alone --- reusing the same seed every frame produces
correlated noise patterns that show up as visible temporal flicker after
denoising.
\end{implnote}

\section{Tables, figures, and citations}
\label{sec:figs}

This section exercises the table style, figure/caption support, and
\texttt{natbib} citations together.

\begin{table}[t]
  \centering
  \caption{Frame time (ms) at 1080p across denoiser configurations.}
  \label{tab:bench}
  \begin{tabular}{lccc}
    \toprule
    \swtablehead Configuration & Path tracing & Denoise & Total \\
    \midrule
    No denoiser & 18.2 & --- & 18.2 \\
    Spatial only & 18.2 & 1.4 & 19.6 \\
    Spatiotemporal & 18.2 & 2.1 & 20.3 \\
    \bottomrule
  \end{tabular}
\end{table}

\begin{figure}[t]
  \centering
  \includegraphics[width=0.55\textwidth]{convergence_plot.png}
  \caption{Estimator variance decreases with sample count $N$, consistent
  with the $O(1/N)$ rate proposed in \cref{conj:mc-rate}.}
  \label{fig:convergence}
\end{figure}

The reparameterization machinery used throughout this kind of derivation
follows \citep{loubet2019reparam}; gradient estimator correctness follows
the taxonomy of \citep{zeltner2021estimators}.

\section{Environment gallery}
\label{sec:gallery}

A quick-reference catalog of every custom environment this class provides,
each with minimal usage syntax. Come back here first if you forget how
something works.

\begin{definition}{Gallery: Definition}{gal-def}
\texttt{\textbackslash begin\{definition\}\{Name\}\{label\} ... \textbackslash end\{definition\}}
--- upright body text.
\end{definition}

\begin{theorem}{Gallery: Theorem}{gal-thm}
\texttt{\textbackslash begin\{theorem\}\{Name\}\{label\} ... \textbackslash end\{theorem\}}
--- italic body; all theorem-like environments share one section-scoped counter.
\end{theorem}

\begin{lemma}{Gallery: Lemma}{gal-lem}
\texttt{\textbackslash begin\{lemma\}\{Name\}\{label\} ... \textbackslash end\{lemma\}}
--- supporting results.
\end{lemma}

\begin{corollary}{Gallery: Corollary}{gal-cor}
\texttt{\textbackslash begin\{corollary\}\{Name\}\{label\} ... \textbackslash end\{corollary\}}
--- immediate consequences of a theorem or lemma.
\end{corollary}

\begin{proposition}{Gallery: Proposition}{gal-prop}
\texttt{\textbackslash begin\{proposition\}\{Name\}\{label\} ... \textbackslash end\{proposition\}}
--- standalone claims not depending on a preceding theorem.
\end{proposition}

\begin{conjecture}{Gallery: Conjecture}{gal-conj}
\texttt{\textbackslash begin\{conjecture\}\{Name\}\{label\} ... \textbackslash end\{conjecture\}}
--- numerically-confirmed-only, not yet closed-form.
\end{conjecture}

\begin{remark}[Gallery: Remark]
\texttt{\textbackslash begin\{remark\}[optional name] ... \textbackslash end\{remark\}}
--- italic label, upright body; for open questions and caveats.
\end{remark}

\begin{example}{Gallery: Example}{gal-ex}
\texttt{\textbackslash begin\{example\}\{Name\}\{label\} ... \textbackslash end\{example\}}
--- a worked numeric or concrete illustration.
\end{example}

\begin{implnote}[Gallery: Implementation Note]
\texttt{\textbackslash begin\{implnote\}[optional label] ... \textbackslash end\{implnote\}}
--- run-in paragraph for engineering/code notes, not a math claim.
\end{implnote}

\noindent\texttt{proof}: standard environment, plain style, ends with
$\blacksquare$. Use for any theorem/lemma/proposition/corollary.

\noindent\texttt{algorithm} (algorithm2e): \texttt{\textbackslash KwIn},
\texttt{\textbackslash KwOut}, \texttt{\textbackslash eIf}, \texttt{\textbackslash Return},
\texttt{\textbackslash Comment*[r]\{...\}}.

\noindent Code: \texttt{cppcode}, \texttt{pycode}, and generic
\texttt{swcode[title=...]\{language\}} --- all via \texttt{minted}, between thin rules with a bold title.

\begin{openitemtag}
\noindent Proof-status tags: \texttt{proventag}, \texttt{numconfirmedtag},
\texttt{openitemtag} --- wrap a paragraph to put a small-caps status in the
margin (like this one). \texttt{\textbackslash tool\{...\}} names a technique
inline \tool{e.g.\ this}.
\end{openitemtag}

\noindent Tables: \texttt{\textbackslash swtablehead} after \texttt{\textbackslash toprule}
for a bold header row; \texttt{\textbackslash swtablealt} before a long
\texttt{tabular} for alternating row tints.

\noindent Figures: standard \texttt{graphicx}/\texttt{caption}/\texttt{subcaption}, small captions
with a bold sans label.

\noindent Citations: \texttt{\textbackslash cite\{key\}} / \texttt{\textbackslash citep\{key\}}
for (Author et al.\ 2021), \texttt{\textbackslash citet\{key\}} for
Author et al.\ (2021) --- author-year via \texttt{plainnat} against
\texttt{\textbackslash swbibliography\{refs\}}.

\noindent Cross-references: \texttt{\textbackslash cref\{label\}} / \texttt{\textbackslash Cref\{label\}}
auto-name the type; \texttt{\textbackslash eqref\{label\}} for equations
(section-scoped numbering throughout).
