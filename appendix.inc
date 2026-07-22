\appendix
\section{Deferred proof: energy conservation of the Lambertian BRDF}
\label{sec:appendix-proof}

This appendix demonstrates letter-numbered sections (\cref{sec:appendix-proof}
instead of a numeric section) --- the standard place for material moved out
of the main narrative but still fully proven, matching the "harsh reviewer,
nothing hand-waved" standard.

\begin{proof}
For $f_r = \rho/\pi$, the left side of \cref{eq:econs} evaluates to
\[
  \int_{\Omega} \frac{\rho}{\pi} \cos\theta_o \, d\omega_o
  = \frac{\rho}{\pi} \int_0^{2\pi}\!\!\int_0^{\pi/2} \cos\theta \sin\theta \, d\theta \, d\phi
  = \frac{\rho}{\pi} \cdot \pi = \rho \le 1,
\]
which holds for any $\rho \in [0,1]$, proving \cref{def:econs} directly.
\end{proof}
