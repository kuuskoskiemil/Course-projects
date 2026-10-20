# 2D Heat Transfer & Numerical Fluid Thermal Simulations

Advanced numerical simulations of two-dimensional heat transfer phenomena in MATLAB, developed as part of computational heat transfer coursework at Aalto University. The repository highlights two complex 2D simulation solvers utilizing finite difference methods (FDM): **laminar advection-diffusion in channel flow** and **transient 2D heat diffusion with analytical verification**.

---

## 📁 Repository Structure

```text
├── 2D_Convection_Channel_Flow/
│   ├── channel_convection_diffusion.m   # 2D Advection-Diffusion solver
│   ├── compute_derivatives.m            # 2D central difference derivative operator
│   ├── c1a.jpg                          # Temperature contour visualization
│   ├── c1b.jpg                          # Cup-mean temperature progression
│   ├── c1b2.jpg                         # Entry length & Nusselt number validation
│   └── c1c.jpg                          # Boundary heat flux and thermal profiles
│
├── 2D_Transient_Conduction/
│   ├── transient_conduction_2d.m        # 2D transient diffusion solver & verification
│   ├── compute_derivatives.m            # 2D spatial derivative functions
│   ├── set_bc.m                         # Ghost-cell boundary condition handler
│   ├── S1a.jpg                          # Initial 2D Gaussian thermal field
│   ├── s1b.jpg                          # 1st spatial derivative verification (numerical vs. analytical)
│   ├── s1c.jpg                          # 2nd spatial derivative verification (numerical vs. analytical)
│   └── s2.jpg                           # Time-dependent 3D surface relaxation
│
├── .gitignore
└── README.md
```

---

## 🔬 Project 1: 2D Laminar Convective Heat Transfer in Duct Flow

Located in [`2D_Convection_Channel_Flow/`](./2D_Convection_Channel_Flow/)

Simulates forced convection in a 2D channel where fluid enters at an inlet temperature and is heated by constant-temperature walls. The solver couples a fully developed hydrodynamic velocity profile with the unsteady energy equation.

### Governing Equation
$$\frac{\partial T}{\partial t} = \alpha \left(\frac{\partial^2 T}{\partial x^2} + \frac{\partial^2 T}{\partial y^2}\right) - u_x(y) \frac{\partial T}{\partial x}$$

### Key Features & Physics
- **Velocity Profile**: Fully developed laminar Poiseuille flow:
  $$u_x(y) = \frac{4 U_{\max}}{H^2} (H y - y^2), \quad u_y = 0$$
- **Boundary Conditions**:
  - Heated upper and lower walls: Dirichlet constant temperature $T_s = 303\text{ K}$
  - Channel inlet: Uniform incoming fluid $T_{\text{in}} = 293\text{ K}$
  - Channel outlet: Convective outflow condition $\frac{\partial T}{\partial x} = 0$
- **Bulk (Cup-Mean) Temperature**:
  $$T_m(x) = \frac{\int_0^H T(x,y)\, u_x(y)\, dy}{\int_0^H u_x(y)\, dy}$$
- **Nusselt Number & Entry Length Validation**:
  - Evaluates local wall heat flux $q''_{\text{wall}}(x) = k \left.\frac{\partial T}{\partial y}\right|_{\text{wall}}$ and heat transfer coefficient $h(x) = \frac{q''_{\text{wall}}(x)}{T_s - T_m(x)}$.
  - Validates local Nusselt number $Nu(x)$ against theoretical asymptotic values ($Nu_\infty = 7.52$ for parallel plates).
  - Validates thermal entrance length:
    $$x_t \approx 0.05 \cdot Re \cdot Pr \cdot H$$

---

## 🔬 Project 2: 2D Transient Heat Diffusion & FDM Verification

Located in [`2D_Transient_Conduction/`](./2D_Transient_Conduction/)

Models unsteady 2D conduction starting from an anisotropic Gaussian temperature pulse. Prior to time-stepping, the numerical spatial derivative operators are rigorously benchmarked against closed-form analytical solutions.

### Governing Equation
$$\frac{\partial T}{\partial t} = \alpha \nabla^2 T = \alpha \left(\frac{\partial^2 T}{\partial x^2} + \frac{\partial^2 T}{\partial y^2}\right)$$

### Key Features & Physics
- **Initial Thermal Condition**: 2D anisotropic Gaussian distribution:
  $$T(x,y,0) = T_{\text{ref}} + T_a \exp\left(-\frac{(x - x_c)^2}{2\sigma_x^2} - \frac{(y - y_c)^2}{2\sigma_y^2}\right)$$
- **Boundary Handling via Ghost Cells**:
  - Lateral boundaries ($x = 0, L_x$): Isothermal Dirichlet conditions ($T = 290\text{ K}$)
  - Top & bottom boundaries ($y = 0, L_y$): Insulated adiabatic Neumann conditions ($\frac{\partial T}{\partial y} = 0$)
- **Numerical Scheme Verification**:
  - Compares 2nd-order central differences for $\frac{\partial T}{\partial x}$ and $\frac{\partial^2 T}{\partial y^2}$ with symbolic analytical derivatives.
- **Dynamic Evolution**: Solves transient decay using explicit forward Euler time-stepping and visualizes 3D temperature relaxation over time.

---

## 💻 Tech Stack
- **MATLAB**: 2D finite difference discretization, vectorized stencil indexing with ghost cells, mesh generation (`meshgrid`), ODE numerical time-stepping, and surface contour visualization.
