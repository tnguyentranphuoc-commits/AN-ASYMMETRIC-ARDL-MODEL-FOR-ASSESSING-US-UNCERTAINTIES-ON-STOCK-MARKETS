# AN ASYMMETRIC ARDL MODEL FOR ASSESSING US UNCERTAINTIES ON STOCK MARKETS

📅 **Duration**: May 2025 – Oct 2025  
👤 **Team Size**: 1  
🛠️ **Tech Stack**: Stata  

---

## (i). Overview

This project investigates the **asymmetric transmission of U.S.-based uncertainties** to stock market **returns (r)** and **volatility (σ)** across **ASEAN and East Asian equity markets**. The analysis focuses on four major U.S. uncertainty indicators:

- **Economic Policy Uncertainty (EPU)**
- **Geopolitical Risk (GPR)**
- **Market Volatility (VIX)**
- **Tail Risk (SKEW)**

The study explicitly decomposes uncertainty shocks into **positive (Δ⁺)** and **negative (Δ⁻)** components to capture **nonlinear and asymmetric market responses**. Both **ARMA-based** and **GARCH-based volatility measures** are employed to ensure robustness across volatility specifications.

---

## (ii). Methodology

- Examined **9 major stock indices** spanning **ASEAN and East Asia**
- All series passed **ADF and Phillips–Perron (PP) stationarity diagnostics**
- Returns were constructed using log-differences; volatility was proxied using:
  - **ARMA-based residual variance**
  - **GARCH(1,1)-based conditional volatility**
- U.S. uncertainty indicators were transformed and decomposed to isolate asymmetric effects

---

## (iii). Modeling Pipeline

The empirical framework integrates **symmetric ARDL** and **asymmetric NARDL** models following:

- **Pesaran et al. (2001)** – ARDL bounds testing approach
- **Shin et al. (2014)** – Nonlinear ARDL (NARDL) framework

### Estimation and Validation Strategy:
- Cointegration confirmed via **Bounds Test**  
  *(F-statistic ≥ upper critical value)*
- Optimal lag structures selected using **AIC and BIC minimization**
- Short-run and long-run asymmetries validated through **Wald tests (p < 0.05)**
- Error-correction terms ensured stable long-run equilibrium adjustment

---

## (iv). Key Findings

- **Asymmetric effects are statistically significant and economically meaningful**
- **Positive uncertainty shocks** (ΔEPU⁺, ΔVIX⁺) exert **stronger negative impacts** on:
  - ASEAN markets: **VNI, SETI, PSI**
  - Relative to East Asian markets: **N225 (Japan), KS11 (Korea)**
- **Negative uncertainty shocks** (EPU⁻, VIX⁻) significantly **amplify volatility persistence**, particularly in emerging markets
- Results confirm **nonlinear risk transmission**, highlighting structural differences in financial resilience and cross-market integration

---

## (v). Application: Portfolio & Risk Implications

- ASEAN markets exhibit **higher vulnerability** to global uncertainty shocks
- East Asian developed markets show **greater shock absorption capacity**
- Findings provide practical insights for:
  - International portfolio diversification
  - Cross-market risk management
  - Macroprudential surveillance under global uncertainty regimes

---

## (vi). Repository Contents

├── AN ASYMMETRIC ARDL MODEL FOR ASSESSING US UNCERTAINTIES ON STOCK MARKETS.do
│       # Stata code for ARDL–NARDL estimation
├── AN ASYMMETRIC ARDL MODEL FOR ASSESSING US UNCERTAINTIES ON STOCK MARKETS.dta
│       # Processed dataset
├── BASED WORK.pdf
│       # Full research manuscript
├── Methods and Results.pdf
│       # Condensed methodology and empirical findings
├── README.md
│       # Project documentation

---
## (vii). Citation

> **Toan N.T.P., et al. (2025)**  
> *Southeast Asian Stock Markets in the Uncertainty World: Evidence from Symmetric and Asymmetric Cointegration Approach.*  
> College of Economics, Law and Government – CELG 2025, University of Economics Ho Chi Minh City (UEH)

 # Based study: Tran MP-B, Vo DH (2023) Asia-Pacific stock market return and volatility in the uncertain world: Evidence from the nonlinear autoregressive distributed lag approach. PLoS ONE 18(5): e0285279. https://doi.org/10.1371/journal. pone.0285279 
				
---
## (viii). License

This project is released under the **MIT License**.  
If you use or reference this work, please cite the authors appropriately.

---

## (ix). Acknowledgements
This research is conducted in the context of the UEH CELG Awards 2025.
 Award details: https://celg.ueh.edu.vn/celg-awards-2025/
Special thanks to the CELG academic committee for methodological guidance and research support.
---


