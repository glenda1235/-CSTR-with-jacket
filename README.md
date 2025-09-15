# CSTR Simulation with Target Conversion

## Overview

This project simulates a **Continuous Stirred Tank Reactor (CSTR)** for a **first-order reaction** in MATLAB.  
It calculates:

- Concentration of reactant A over time (`C_A`)  
- Conversion of reactant (`X`)  
- Residence time (`tau`)  
- Damköhler number (`Da`)  
- Analytical steady-state values  
- Design calculations for a specified target conversion (`X_target`)

The simulation uses `ode45` to solve the mass balance differential equation and generates plots for concentration and conversion.

---

## Model Description

The mass balance for a first-order reaction in a CSTR is given by:

\[
\frac{dC_A}{dt} = \frac{F}{V} (C_{Af} - C_A) - k C_A
\]

Where:  
- `F` = volumetric flow rate [L/min]  
- `V` = reactor volume [L]  
- `CAf` = feed concentration [mol/L]  
- `k` = reaction rate constant [1/min]  

Conversion and Damköhler number:

\[
X = \frac{C_{Af} - C_A}{C_{Af}}, \quad \tau = \frac{V}{F}, \quad Da = k \tau
\]

Design calculations for a target conversion `X_target` are included.

---