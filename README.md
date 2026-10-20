# Heat Transfer Simulation & Analysis

Numerical simulations and thermodynamic analysis scripts developed for heat transfer course assignments at Aalto University. The repository covers 1D and 2D finite difference methods (FDM) for conduction, laminar convective heat transfer with advection-diffusion, surface radiation equilibrium, and real-gas thermodynamic cycle modeling.

---

## 📌 Topics & Weekly Assignments

### Week 1: 1D Transient Conduction & Lumped Capacitance Cooling
- **`week1s1.m`**: Transient 1D conduction with an initial sinusoidal temperature perturbation. Computes analytical temperature decay over time towards equilibrium.
- **`week1s2.m`**: Lumped capacitance model comparing numerical Euler integration against analytical exponential cooling across different convection coefficients ($h_1 = 8.09 \text{ W/m}^2\text{K}$ and $h_2 = 40 \text{ W/m}^2\text{K}$).

### Week 2: Finite Difference Method (FDM) Verification & 1D Diffusion
- **`week2s1.m`**: Spatial discretization of first- and second-order derivatives using central difference schemes on a 1D grid with ghost cells. Validated directly against analytical Gaussian derivatives.
- **`week2s2.m`**: Explicit finite difference solver for 1D transient heat diffusion with an imposed surface heat flux (Neumann boundary condition) and fixed temperature boundaries.
- **`week2/s2c.m`**: Extended transient diffusion simulations and boundary sensitivity investigations.

### Week 3: 2D Heat Conduction & Pipe Heat Exchanger Sizing
- **`week3/Viikko3laskari.m`**, **`week3/set_bc.m`**, **`week3/compute_derivatives.m`**: 2D heat conduction solver using finite difference central differencing on structured Cartesian meshes with ghost cell boundary conditions (Dirichlet and Neumann).
- **`week3/pp2.m`**: Conjugate heat transfer analysis in a counterflow/crossflow pipe heat exchanger:
  - Internal forced convection (Gnielinski/Dittus-Boelter style correlations).
  - External natural convection using Rayleigh/Grashof numbers ($Gr$) and Prandtl numbers ($Pr$).
  - Cylindrical conduction resistance and Log-Mean Temperature Difference (LMTD) method to solve for required pipe length.

### Week 4: 2D Convection-Diffusion in Laminar Channel Flow
- **`week4/C1.m`**: 2D advection-diffusion solver modeling forced convective heat transfer in laminar duct flow.
  - Implements fully developed parabolic Poiseuille velocity profile: $u(y) = \frac{4 U_{max}}{H^2}(H y - y^2)$.
  - Captures thermal boundary layer development and validates thermal entry length $x_t \approx 0.05 \cdot Re \cdot Pr \cdot H$.
- **`week4/Pp1.m`**, **`week4/Pp2.m`**: Supplementary heat exchanger and convective boundary layer exercises.

### Week 5: Thermal Radiation & Gas Turbine Cycle Analysis
- **`week5/C1.m`**: Conjugate thermal radiation and 1D transient heat conduction through a vehicle roof exposed to solar irradiance ($G = 1200 \text{ W/m}^2$) and radiative exchange with the sky ($T_{sky} = 280\text{ K}$):
  - Solves nonlinear surface energy balance $\alpha G = \epsilon \sigma (T^4 - T_{sky}^4) + h(T - T_{amb})$.
  - Models transient temperature diffusion through the roof material for various convection coefficients $h \in \{0, 10, 25, 50\} \text{ W/m}^2\text{K}$.
- **`week5/Avoin_kaasuturbiini.py`**: Open Brayton gas turbine cycle simulation in Python using **Cantera**:
  - Uses NASA 7-term polynomials for temperature-dependent real gas specific enthalpies and entropies ($O_2 / N_2$ air mixture).
  - Computes isentropic compressor power, combustor heat addition, turbine expansion work, and overall thermal efficiency.

---

## 🛠️ Tools & Environments
- **MATLAB**: Finite difference discretization, mesh generation (`meshgrid`), vectorization with ghost cells, ODE integration, and visualization.
- **Python**: [Cantera](https://cantera.org/) chemical kinetics and thermodynamics library, NumPy.
