*(I). DECLARATION
gen date_stata = mofd(date(date, "YMD"))
format date_stata %tm
tsset date_stata, monthly
*(II). FEATURINGS 
*Returns of MARKETS Calculating
foreach v in klse psi sti seti vni skew vix {    
    * Step 1: Returns
    gen r_`v' = ln(price_`v' / L.price_`v') 
    * Step 3: Mean Equation 
    arima r_`v', ar(1) ma(1)
    * Step 4: Innovations
    predict innovation_`v', resid
    * Step 7: Proxy Volatility
    gen σ_`v' = innovation_`v'^2 
    * Step 8: Summarize
    sum σ_`v' 
}
*Feature 00: Price
sum price_klse price_psi price_sti price_seti price_vni

*Feature 01: Log returns
sum r_klse r_psi r_sti r_seti r_vni

*Feature 02: Volatility of returns using ARMA(1,1) process
sum σ_klse σ_psi σ_sti σ_seti σ_vni

*Feature 04: UNCERTAINTIES INDICES 
rename r_skew lnskew 
rename r_vix lnvix
rename gprc_usa GPR_US

* Logarithm of indices: epu_us gprc_usa
rename lnskew lnSKEW_US
rename lnvix lnVIX_US
gen lnEPU_US = log(epu_us) 
sum lnSKEW_US lnVIX_US lnEPU_US GPR_US
*===========
*ROBUSTNESS CHECK 
*Feature 05: Volatility of returns using GARCH(1,1) process
*Other markets are not detected ARCH effect 
*ARCH effect detected (2): seti vni
*Volatility of MARKETS Calculating: due to ARCH effect detected 
arch r_seti, arch(1) garch(1) 
predict σ_seti_garch, variance
gen σ_seti_GARCH = sqrt(σ_seti_garch)

arch r_vni, arch(1) garch(1) 
predict σ_vni_garch, variance
gen σ_vni_GARCH = sqrt(σ_vni_garch)
sum σ_seti_GARCH σ_vni_GARCH

*===========
*(III). Plotting/ Visualisation 
* Time-series plots of returns
tsline price_klse price_psi price_sti price_seti price_vni,   title("Southeast Asian Stock Markets Price Movement")  ytitle("Closed Price") xtitle("Time") legend(rows(1))

tsline r_klse r_psi r_sti r_seti r_vni,   title("Southeast Asian Stock Markets Returns")  ytitle("Returns") xtitle("Time") legend(rows(1))

* Time-series plots of volatilities
tsline σ_klse σ_psi σ_sti σ_seti σ_vni,  title("Volatility of ASEAN Stock Markets") ytitle("Volatility") xtitle("Time") legend(rows(1))

* Time-series plots of indices

tsline lnSKEW_US lnVIX_US lnEPU_US GPR_US, title("US Uncertainty Indices Movement")    ytitle("  ") xtitle("Time")

tsline lnSKEW_US , title("US Skewness Index Behavior")    ytitle("lnSKEW") xtitle("Time")

tsline lnVIX_US,   title("US Volatility Index Behavior")   ytitle("lnVIX") xtitle("Time")

tsline lnEPU_US,  title("US Economic Policy Uncertainty Index Behavior") ytitle("lnEPU_US") xtitle("Time")

tsline GPR_US,  title("US Geopolitical Risk Index Behavior")  ytitle("GPR_US") xtitle("Time") 

*(IV). DIAGNOSTICS TESTS 
*===========
*STATIONARY at I(0) TEST 
*Feature 00: Price
foreach v in klse psi sti seti vni {    
    * Step 2: Stationarity
    dfuller price_`v', trend lags(0) regress
}

*Feature 01: Log returns
foreach v in klse psi sti seti vni {    
    * Step 2: Stationarity
    dfuller r_`v', trend lags(0) regress
}

*Feature 02: Volatility of returns using ARMA(1,1) process
foreach v in klse psi sti seti vni {    
    * Step 2: Stationarity
    dfuller σ_`v', trend lags(0) regress
} 

*Feature 04: UNCERTAINTIES INDICES (of lnSKEW_US lnVIX_US lnEPU_US GPR_US) 
dfuller lnSKEW_US, trend lags(0) regress
dfuller lnVIX_US, trend lags(0) regress
dfuller lnEPU_US, trend lags(0) regress
dfuller GPR_US, trend lags(0) regress
*ARCH EFFECT TEST
foreach v in klse psi sti seti vni {    
    * Step 5: ARCH LM
	reg innovation_`v'
    * Step 6: ARCH LM
    archlm, lags(1/12)   
}

*ARDL of r 
foreach v in klse psi sti seti vni {
ardl r_`v' lnskew, lags(1 1) ec
est sto ardl_`v'_skew
 estat ectest
ardl r_`v' lnvix, lags(1 1) ec
est sto ardl_`v'_vix
 estat ectest
ardl r_`v' lnEPU_US, lags(1 1) ec
est sto ardl_`v'_epu
 estat ectest
ardl r_`v' GPR_US, lags(1 1) ec
est sto ardl_`v'_gpr
 estat ectest
}
foreach v in klse psi sti seti vni {
esttab ardl_`v'_skew ardl_`v'_vix ardl_`v'_epu ardl_`v'_gpr, star(* 0.1 ** 0.05 *** 0.01) replace
}


*TABLE . Impacts of US uncertainty indices on Southeast Asian Stock Market returns
*PANEL A
esttab ardl_klse_skew ardl_psi_skew ardl_sti_skew ardl_seti_skew ardl_vni_skew, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL B
esttab ardl_klse_vix ardl_psi_vix ardl_sti_vix ardl_seti_vix ardl_vni_vix, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL C
esttab ardl_klse_epu  ardl_psi_epu ardl_sti_epu ardl_seti_epu ardl_vni_epu, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL D
esttab ardl_klse_gpr ardl_psi_gpr ardl_sti_gpr ardl_seti_gpr ardl_vni_gpr, star(* 0.1 ** 0.05 *** 0.01) replace



*======
*NARDL of r  
foreach v in klse psi sti seti vni {
nardl r_`v' lnskew, p(2) q(2)
est sto nardl_`v'_skew
nardl r_`v' lnvix, p(2) q(2)
est sto nardl_`v'_vix
nardl r_`v' lnEPU_US, p(2) q(2)
est sto nardl_`v'_epu
nardl r_`v' GPR_US, p(2) q(2)
est sto nardl_`v'_gpr
}
foreach v in klse psi sti seti vni {
esttab nardl_`v'_skew nardl_`v'_vix nardl_`v'_epu nardl_`v'_gpr, star(* 0.1 ** 0.05 *** 0.01) replace
}

*TABLE . Impacts of US uncertainty indices on Southeast Asian Stock Market returns
*PANEL A
esttab nardl_klse_skew nardl_psi_skew nardl_sti_skew nardl_seti_skew nardl_vni_skew, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL B
esttab nardl_klse_vix nardl_psi_vix nardl_sti_vix nardl_seti_vix nardl_vni_vix, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL C
esttab nardl_klse_epu  nardl_psi_epu nardl_sti_epu nardl_seti_epu nardl_vni_epu, star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL D
esttab nardl_klse_gpr nardl_psi_gpr nardl_sti_gpr nardl_seti_gpr nardl_vni_gpr, star(* 0.1 ** 0.05 *** 0.01) replace


*Additional analysis
*ARDL of σ 
foreach v in klse psi sti seti vni {
ardl σ_`v' lnskew, lags(1 1) ec
est sto ardl_`v'_skew_σ
 estat ectest
ardl σ_`v' lnvix, lags(1 1) ec
est sto ardl_`v'_vix_σ
 estat ectest
ardl σ_`v' lnEPU_US, lags(1 1) ec
est sto ardl_`v'_epu_σ
 estat ectest
ardl σ_`v' GPR_US, lags(1 1) ec
est sto ardl_`v'_gpr_σ
 estat ectest
}


*TABLE . Impacts of US uncertainty indices on Southeast Asian Stock Market Volatiles
*PANEL A
esttab ardl_klse_skew_σ  ardl_psi_skew_σ  ardl_sti_skew_σ  ardl_seti_skew_σ  ardl_vni_skew_σ , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL B
esttab ardl_klse_vix_σ ardl_psi_vix_σ  ardl_sti_vix_σ  ardl_seti_vix_σ  ardl_vni_vix_σ , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL C
esttab ardl_klse_epu_σ   ardl_psi_epu_σ  ardl_sti_epu_σ  ardl_seti_epu_σ  ardl_vni_epu_σ , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL D
esttab ardl_klse_gpr_σ  ardl_psi_gpr_σ  ardl_sti_gpr_σ  ardl_seti_gpr_σ  ardl_vni_gpr_σ , star(* 0.1 ** 0.05 *** 0.01) replace


*Robustness check : σ_seti_GARCH σ_vni_GARCH
*ARDL of σ
foreach v in seti_GARCH vni_GARCH {
ardl σ_`v' lnSKEW_US, lags(1 1) ec
est sto ardl_`v'_skew_σ_G
 estat ectest
ardl σ_`v' lnVIX_US, lags(1 1) ec
est sto ardl_`v'_vix_σ_G
 estat ectest
ardl σ_`v' lnEPU_US, lags(1 1) ec
est sto ardl_`v'_epu_σ_G
 estat ectest
ardl σ_`v' GPR_US,lags(1 1) ec
est sto ardl_`v'_gpr_σ_G
 estat ectest
}
foreach v in seti_GARCH vni_GARCH {
esttab ardl_`v'_skew_σ_G ardl_`v'_vix_σ_G ardl_`v'_epu_σ_G ardl_`v'_gpr_σ_G, star(* 0.1 ** 0.05 *** 0.01) replace
}
*TABLE . Impacts of US uncertainty indices on Southeast Asian Stock Market Volatiles
*PANEL A
esttab  ardl_seti_GARCH_skew_σ_G  ardl_vni_GARCH_skew_σ_G , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL B
esttab  ardl_seti_GARCH_vix_σ_G  ardl_vni_GARCH_vix_σ_G , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL C
esttab  ardl_seti_GARCH_epu_σ_G  ardl_vni_GARCH_epu_σ_G , star(* 0.1 ** 0.05 *** 0.01) replace
*PANEL D
esttab ardl_seti_GARCH_gpr_σ_G  ardl_vni_GARCH_gpr_σ_G , star(* 0.1 ** 0.05 *** 0.01) replace




*NARDL of σ 
foreach v in seti_GARCH vni_GARCH {
nardl  σ_`v' lnSKEW_US, p(2) q(2)
est sto nardl_`v'_skew_σ
nardl  σ_`v' lnVIX_US, p(2) q(2)
est sto nardl_`v'_vix_σ
nardl  σ_`v' lnEPU_US, p(2) q(2)
est sto nardl_`v'_epu_σ
nardl  σ_`v' GPR_US, p(2) q(2)
est sto nardl_`v'_gpr_σ
}
foreach v in seti_GARCH vni_GARCH {
esttab nardl_`v'_skew_σ nardl_`v'_vix_σ nardl_`v'_epu_σ nardl_`v'_gpr_σ, star(* 0.1 ** 0.05 *** 0.01) replace
}






































