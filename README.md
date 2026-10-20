# Engineering Course Projects & Numerical Simulations

A curated collection of advanced engineering simulations and thermodynamic models developed during engineering coursework at Aalto University. The repository highlights physics-based modeling, numerical partial differential equation (PDE) solvers, and real-gas thermodynamic cycle optimization.

---

## 📁 Repository Structure

```text
├── Reheat_Gas_Turbine_Cycle_Simulation/
│   ├── reheat_gas_turbine_simulation.py       # Cantera real-gas Brayton reheat cycle model
│   ├── chem.yaml                              # Chemical mechanism & NASA polynomial coefficients
│   ├── thermal_efficiency_vs_reheat_pressure.png
│   ├── turbine_power_output_vs_reheat_pressure.png
│   └── reheat_oxygen_sufficiency.png
│
├── 2D_Convection_Channel_Flow/
│   ├── channel_convection_diffusion.m         # 2D Advection-Diffusion FDM solver
│   ├── compute_derivatives.m                  # 2D central difference derivative operator
│   ├── c1a.jpg                                # Temperature contour visualization
│   ├── c1b.jpg                                # Bulk cup-mean temperature progression
│   ├── c1b2.jpg                               # Thermal entry length & Nusselt validation
│   └── c1c.jpg                                # Boundary heat flux and thermal profiles
│
└── 2D_Transient_Conduction/
    ├── transient_conduction_2d.m              # 2D unsteady diffusion solver & validation
    ├── compute_derivatives.m                  # 2D spatial derivative functions
    ├── set_bc.m                               # Ghost-cell boundary condition handler
    ├── S1a.jpg                                # Initial 2D Gaussian thermal distribution
    ├── s1b.jpg                                # 1st spatial derivative verification
    ├── s1c.jpg                                # 2nd spatial derivative verification
    └── s2.jpg                                 # Dynamic 3D surface temperature relaxation
```

---

## 🚀 Projects

### 1. Reheat Gas Turbine Cycle Simulation & Optimization
Located in [`Reheat_Gas_Turbine_Cycle_Simulation/`](./Reheat_Gas_Turbine_Cycle_Simulation/)

* **Topic**: Advanced thermodynamic modeling of an open Brayton gas turbine cycle with two-stage expansion and intermediate reheat.
* **Methodology**:
  * Utilizes **[Cantera](https://cantera.org/)** with NASA 7-term polynomial thermodynamic data (`chem.yaml`) to calculate exact, temperature-dependent real gas specific enthalpies ($h$) and entropies ($s$) of combustion air ($O_2 / N_2$).
  * Models non-ideal compressor compression ($\eta_{ic} = 0.9$) from 1 bar to 22 bar.
  * Models primary combustion, high-pressure (HP) turbine expansion, reheat combustor, and low-pressure (LP) turbine expansion.
  * Performs parametric sweep over intermediate reheat pressures ($p_{\text{reheat}} \in [4, 21]\text{ bar}$) to identify the optimal pressure ratio that maximizes combined turbine power output and thermal efficiency.
  * Verifies oxygen availability ($\lambda$) in the exhaust gas to ensure complete secondary combustion during reheat.

---

### 2. 2D Laminar Convective Heat Transfer in Duct Flow
Located in [`2D_Convection_Channel_Flow/`](./2D_Convection_Channel_Flow/)

* **Topic**: 2D forced convection and thermal boundary layer growth in laminar channel flow between parallel heated plates.
* **Governing PDE**:
  $$\frac{\partial T}{\partial t} = \alpha \left(\frac{\partial^2 T}{\partial x^2} + \frac{\partial^2 T}{\partial y^2}\right) - u_x(y) \frac{\partial T}{\partial x}$$
* **Methodology**:
  * Couples fully developed parabolic Poiseuille velocity $u_x(y) = \frac{4 U_{\max}}{H^2} (H y - y^2)$ with explicit 2D finite difference time-stepping.
  * Evaluates cup-mean bulk temperature $T_m(x)$, wall heat flux $q''_{\text{wall}}(x)$, and local convective heat transfer coefficient $h(x)$.
  * Validates the numerical Nusselt number against theoretical asymptotic limits ($Nu_\infty = 7.52$) and analytical thermal entry length $x_t \approx 0.05 \cdot Re \cdot Pr \cdot H$.

---

### 3. 2D Transient Heat Diffusion & FDM Verification
Located in [`2D_Transient_Conduction/`](./2D_Transient_Conduction/)

* **Topic**: Unsteady two-dimensional thermal conduction starting from an anisotropic Gaussian pulse.
* **Governing PDE**:
  $$\frac{\partial T}{\partial t} = \alpha \nabla^2 T = \alpha \left(\frac{\partial^2 T}{\partial x^2} + \frac{\partial^2 T}{\partial y^2}\right)$$
* **Methodology**:
  * Implements structured Cartesian grid with ghost cells for mixed boundary conditions (Dirichlet lateral walls $T=290\text{ K}$, adiabatic Neumann top/bottom boundaries $\partial T/\partial y = 0$).
  * Numerically evaluates 1st and 2nd spatial derivatives ($T_x$, $T_{yy}$) via central differencing and benchmarks accuracy directly against analytical symbolic derivatives.
  * Time-integrates transient temperature field decay using explicit Euler stepping with 3D surface visualization.

---

## 🛠️ Technologies
- **Python**: [Cantera](https://cantera.org/) (chemical thermodynamics & real-gas equations of state), NumPy, Matplotlib.
- **MATLAB**: Finite Difference Method (FDM), vectorized matrix stencil operations, meshgrid indexing, ODE time-stepping.
