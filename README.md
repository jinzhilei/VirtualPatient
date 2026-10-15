# Virtual Patient Generation Framework

MATLAB implementation accompanying the manuscript:

> **A unified framework for generating and calibrating virtual patients from heterogeneous clinical data**
>
> Lei Du, Jinzhi Lei
> School of Mathematical Sciences & Center for Applied Mathematics, Tiangong University, Tianjin 300387, China

This repository reproduces all numerical results and figures of the three
oncology case studies presented in the paper.

---

## 1. Overview

The framework generates **virtual patient (VP)** cohorts by combining
mechanism-based ordinary differential equation (ODE) models with clinical data.
It consists of five steps:

1. **Model construction** — mechanism-based ODE models with interpretable parameters.
2. **Parameter estimation** — parameters are split into *deterministic* (directly
   measurable) and *fuzzy* (unknown) groups; fuzzy parameters are sampled with
   **Latin hypercube sampling (LHS)** and calibrated by **R^2 fitting**.
3. **Sensitivity analysis** — global sensitivity analysis via the
   **partial rank correlation coefficient (PRCC)** selects the key parameters.
4. **Calibration against clinical data** — three complementary strategies:
   * **Gamma-distribution fitting** for indicators with an unknown distribution;
   * **Bayesian density-ratio estimation** for indicators with a known distribution;
   * **Euclidean-distance minimisation** for point-set data.
5. **Posterior distributions** — reusable posterior parameter distributions are
   extracted for downstream sampling.

The framework is demonstrated on three oncology case studies:

| Module  | Case study (model reference)                              | Output cohort |
|:-------:|:----------------------------------------------------------|:-------------:|
| `eq1_v` | Oncolytic virus therapy (Kim et al., 2015)                | ~1,500 VPs    |
| `eq2_C` | Dendritic cell therapy for melanoma (Dickman et al., 2020)| ~120 VPs      |
| `eq3`   | Immune cell therapy for renal carcinoma (Li et al., 2024) | 662 VPs       |

---

## 2. Repository structure

```
.
├── README.md
├── LICENSE
├── .gitignore
│
├── eq1_v/                                  # Case 1 — oncolytic virus therapy
│   ├── model/                              #   ODE model (Eqs. 1–2), 5 state variables U, I, V, T, A
│   │   ├── model.m                         #     right-hand side of the ODE system
│   │   ├── parameter.m                     #     deterministic parameter set
│   │   └── initialzation.m                 #     initial conditions
│   ├── R2/                                 #   Parameter calibration by R^2 fitting
│   │   ├── solve.m                         #     MAIN: LHS sampling + fitting (5 experimental conditions)
│   │   ├── R2.m, RK4.m, model_parameter.m  #     fitting engine and integration
│   │   ├── ColorMatrix.m, picture.m        #     plotting utilities
│   │   ├── data/                           #     INPUT clinical data 1.dat … 5.dat
│   │   ├── Result_1/ … Result_5/           #     OUTPUT simulation trajectories
│   │   └── picture/                        #     OUTPUT figures
│   ├── VP/                                 #   Virtual-patient generation
│   │   ├── solve.m                         #     MAIN: 30,000 initial VPs + selection
│   │   ├── select.m, Data_processing.m     #     density-ratio selection and post-processing
│   │   ├── parameter_VP.m, gamma_es.m, …   #     VP parameter distributions
│   │   ├── data/                           #     INPUT clinical data 1.dat, 2.dat
│   │   ├── Result/                         #     OUTPUT simulation trajectories
│   │   └── picture/                        #     OUTPUT figures
│   └── Parameter_sensitivity_analysis/     #   PRCC sensitivity analysis
│       ├── Model_LHS.m                     #     MAIN: LHS sampling + simulation
│       ├── Parameter_settings_LHS.m, LHS_Call.m, PRCC.m, picture.m
│       ├── data_prcc/                      #     OUTPUT (Model_LHS.mat)
│       └── picture_prcc/                   #     OUTPUT figures
│
├── eq2_C/                                  # Case 2 — dendritic cell therapy (same layout as eq1_v)
│   ├── model/                              #   4 state variables D_b, D_t, E, T
│   ├── R2/
│   ├── VP/
│   └── Parameter_sensitivity_analysis/
│
└── eq3/                                    # Case 3 — renal-carcinoma immune model
    ├── model/                              #   Baseline ODE model (4 state variables X, T_h, T_r, T_c)
    │   ├── main.m                          #     MAIN: single-trajectory simulation
    │   ├── model.m, parameter.m, RK4.m, initialzation.m
    │   ├── data/                           #     OUTPUT
    │   └── picture/                        #     OUTPUT figures
    ├── VP/                                 #   Virtual-patient generation
    │   ├── main_VP.m                       #     MAIN: 30,000 initial VPs + selection + divergence
    │   ├── select.m, KL_JS_div.m, …        #     density-ratio selection, KL/JS divergence
    │   ├── OptimizeVPgeneration.m, nsphereVolume.m
    │   ├── Immunogenomic.xlsx              #     INPUT immunogenomic data (959 patients)
    │   ├── data/                           #     INPUT True_data_log.mat, True_data_ksdensity.mat
    │   ├── VP_immune/                      #     OUTPUT virtual-patient cohort
    │   ├── VP_parallel/                    #     OUTPUT parallel simulation cache
    │   └── picture/                        #     OUTPUT figures
    ├── PD/                                 #   Pharmacodynamic (drug-response) evaluation
    │   ├── main_VP_beta.m                  #     MAIN: drug-response virtual cohort
    │   ├── select_dan.m, counts.m, …       #     RECIST-like classification
    │   ├── data/                           #     OUTPUT
    │   ├── VP_parallel/                    #     OUTPUT parallel simulation cache
    │   └── picture/                        #     OUTPUT figures
    └── Parameter_sensitivity_analysis/     #   PRCC sensitivity analysis
        ├── main.m                          #     MAIN: LHS sampling + simulation
        ├── LHS_Call.m, Parameter_settings_LHS.m, PRCC.m, picture.m
        ├── data_prcc/                      #     OUTPUT
        └── picture_prcc/                   #     OUTPUT figures
```

> **Note.** All `.mat` files that are *generated* by the scripts (fitted
> parameters, VP labels, simulation trajectories, KL/JS divergences, …) are
> intentionally **not** included; they are recreated when the scripts are run in
> the order described in §4. **Three input `.mat` files are the exception and are
> committed**: `eq3/VP/data/True_data_log.mat`, `eq3/VP/data/True_data_ksdensity.mat`
> (pre-processed reference distributions) and `eq3/PD/data/parameter.mat` (PD-stage
> posterior transition matrix — see §5). Empty output directories are kept in the
> repository with `.gitkeep` placeholders so that the code runs out of the box.

---

## 3. Requirements

* **MATLAB** R2023b or later (developed and tested on R2023b, macOS).
* MATLAB toolboxes:
  * **Statistics and Machine Learning Toolbox** —
    `ksdensity`, `kstest2`, `KDTreeSearcher`, `knnsearch`, `betarnd`, `randi`.
  * **Global Optimization Toolbox** — `simulannealbnd` (simulated annealing).
  * **Parallel Computing Toolbox** — `parpool` / `parfor`
    (used by `eq3/VP/main_VP.m` and `eq3/PD/main_VP_beta.m`; can be replaced by a
    plain `for` loop if unavailable).

No third-party dependencies are required.

---

## 4. Usage

> **Important.** The scripts use *relative paths* (e.g. `./data/`,
> `../R2/data/`, `./Result/`). Always `cd` into the directory of the script
> before running it.

### Case 1 — Oncolytic virus therapy (`eq1_v`)

Open MATLAB in the `eq1_v` folder and run, in order:

```matlab
cd R2                                  % 1. parameter calibration
solve                                  %    writes data/Par.mat, data/index.mat, data/R2.mat

cd ../VP                               % 2. virtual-patient generation
solve                                  %    writes data/Number_VP_patients.mat

cd ../Parameter_sensitivity_analysis   % 3. PRCC sensitivity analysis
Model_LHS                              %    writes data_prcc/Model_LHS.mat
PRCC
```

### Case 2 — Dendritic cell therapy for melanoma (`eq2_C`)

```matlab
cd eq2_C/R2
solve

cd ../VP
solve

cd ../Parameter_sensitivity_analysis
Model_LHS
PRCC
```

### Case 3 — Immune cell therapy for renal carcinoma (`eq3`)

```matlab
cd eq3/Parameter_sensitivity_analysis
main                                   % 1. PRCC sensitivity analysis

cd ../VP
main_VP                                % 2. virtual-patient generation (reads Immunogenomic.xlsx)

cd ../PD
main_VP_beta                           % 3. drug-response (pharmacodynamic) evaluation
```

The baseline single-trajectory simulation for the renal-carcinoma model is
available separately:

```matlab
cd eq3/model
main
```

---

## 5. Input data

| File | Description | Source |
|------|-------------|--------|
| `eq1_v/R2/data/{1..5}.dat` | Tumour-burden measurements for 5 treatment arms (PBS, Ad, Ad/4-1BBL, Ad/IL-12, Ad/4-1BBL/IL-12) | Huang et al., 2010 |
| `eq1_v/VP/data/{1,2}.dat` | Clinical reference curves for VP selection | Huang et al., 2010 |
| `eq2_C/R2/data/1.dat` | Clinical tumour-volume data for DC therapy | Lee et al., 2007 |
| `eq2_C/VP/data/{1,2}.dat` | Clinical reference curves for VP selection | Lee et al., 2007 |
| `eq3/VP/Immunogenomic.xlsx` | Immune-cell ratios for 959 renal-cancer patients (CD8/CD4, CD4/Treg, CD8/Treg) | iAtlas (https://isb-cgc.shinyapps.io/shiny-iatlas/) |
| `eq3/VP/data/True_data_log.mat` | Log-transformed immunogenomic ratios (pre-processed input for VP selection) | derived from `Immunogenomic.xlsx` |
| `eq3/VP/data/True_data_ksdensity.mat` | Kernel-density estimates of the clinical distributions (pre-processed input) | derived from `Immunogenomic.xlsx` |
| `eq3/PD/data/parameter.mat` | Posterior parameter transition matrix for the Metropolis–Hastings sampler in `model_parameter_select.m` (KDE grid of the VP posterior) | derived from `eq3/VP/picture_par.m` (see below); **whitelisted and committed** |

`True_data_log.mat` and `True_data_ksdensity.mat` are treated as *input* because
they represent the pre-processed reference distributions used by the selection
and divergence routines. Both can be regenerated from the spreadsheet at any
time:

```matlab
cd eq3/VP
Data_processing        % reads Immunogenomic.xlsx, rewrites the two .mat files above
```

`eq3/PD/data/parameter.mat` is the **posterior parameter transition matrix**
consumed by `eq3/PD/model_parameter_select.m`. It is *not* produced by
`main_VP_beta.m`; instead it is built from the virtual-patient posterior by
`eq3/VP/picture_par.m` and then copied into the PD stage:

```matlab
cd eq3/VP
main_VP              % writes VP_immune/VP_model_parameter.mat, Number_VP_patients.mat
picture_par          % writes VP_immune/parameter.mat (KDE grid of the 6 heterogeneity params)
```
Then copy `eq3/VP/VP_immune/parameter.mat` to `eq3/PD/data/parameter.mat`.
Because this file is an *input* to the PD stage (and no script inside the PD
folder regenerates it), it is whitelisted in `.gitignore` and **already
committed**, so a fresh clone can run the PD stage without this manual step.

#### Regenerating every generated data file

All other `*.mat` artefacts are produced by the scripts. The table below lists
each ignored file and the exact command that creates it (run from the folder
containing the script, as noted in §4):

| Artefact(s) | Created by | Command |
|-------------|-----------|---------|
| `eq3/VP/data/True_data_log.mat`, `True_data_ksdensity.mat` | `Data_processing.m` | `cd eq3/VP; Data_processing` |
| `eq3/VP/VP_immune/VP_model_parameter.mat` | `main_VP.m` | `cd eq3/VP; main_VP` |
| `eq3/VP/VP_immune/Number_VP_patients.mat` | `select.m` (called inside `main_VP.m`) | (same run as above) |
| `eq3/VP/VP_immune/parameter.mat` | `picture_par.m` | `cd eq3/VP; picture_par` |
| `eq3/VP/VP_immune/score_KL.mat`, `score_JS.mat`, `PDF_VP.mat` | `KL_JS_div.m` | `cd eq3/VP; KL_JS_div` |
| `eq3/PD/data/parameter.mat` | `picture_par.m` → copied (see above) | copy `VP_immune/parameter.mat` → `PD/data/` (**already committed**) |
| `eq3/PD/data/beta_params.mat` | `main_VP_beta.m` | `cd eq3/PD; main_VP_beta` |
| `eq3/PD/data/VP_model_parameter_select.mat` | `main_VP_beta.m` (`model_parameter_select`) | `cd eq3/PD; main_VP_beta` |
| `eq3/PD/data/VP_model_parameter1..r.mat` | `main_VP_beta.m` | `cd eq3/PD; main_VP_beta` |
| `eq3/PD/data/CPSP.mat` | `main_VP_beta.m` (`counts`) | `cd eq3/PD; main_VP_beta` |
| `eq1_v/R2/data/Par.mat`, `index.mat`, `R2.mat` | `eq1_v/R2/solve.m` | `cd eq1_v/R2; solve` |
| `eq1_v/VP/data/Number_VP_patients.mat` | `eq1_v/VP/solve.m` | `cd eq1_v/VP; solve` |
| `eq1_v/Parameter_sensitivity_analysis/data_prcc/Model_LHS.mat` | `Model_LHS.m` | `cd eq1_v/Parameter_sensitivity_analysis; Model_LHS` |
| `eq2_C/...` (analogous to eq1_v) | `eq2_C/R2/solve.m`, `eq2_C/VP/solve.m` | see §4 |
| `eq3/Parameter_sensitivity_analysis/data_prcc/*` | `eq3/Parameter_sensitivity_analysis/main.m` | `cd eq3/Parameter_sensitivity_analysis; main` |

> **Note.** `main_VP_beta.m` internally calls `model_parameter_select`, which
> requires `eq3/PD/data/parameter.mat` (the committed input above). The parallel
> routines use `parpool`; replace `parfor` with a plain `for` loop if the Parallel
> Computing Toolbox is unavailable. Simulation of 30,000 initial VPs and the PD
> cohort is computationally intensive.

**Reproducibility (eq3).** The virtual-patient selection in `eq3/VP/select.m`
uses a fixed random seed (`rng(42)`). Re-running `main_VP.m` therefore
reproduces the cohort of **662 virtual patients** (selected from 30,000
candidates) and the reported KL/JS divergences exactly, independently of the
machine or MATLAB session.

---

## 6. Outputs

Key generated artefacts (all recreated by running the scripts):

| Artefact | Produced by | Content |
|----------|-------------|---------|
| `eq1_v/R2/data/Par.mat`, `index.mat`, `R2.mat` | `eq1_v/R2/solve.m` | best-fit parameter sets and fit indices |
| `eq1_v/VP/data/Number_VP_patients.mat` | `eq1_v/VP/solve.m` | indices of the selected virtual patients |
| `eq2_C/R2/data/Par.mat`, `index.mat` | `eq2_C/R2/solve.m` | best-fit parameter sets |
| `eq2_C/VP/data/Number_VP_patients.mat` | `eq2_C/VP/solve.m` | selected virtual patients |
| `eq3/VP/VP_immune/Number_VP_patients.mat` | `eq3/VP/select.m` | indices of the 662 selected virtual patients |
| `eq3/VP/VP_immune/score_KL.mat`, `score_JS.mat`, `PDF_VP.mat` | `eq3/VP/KL_JS_div.m` | KL / JS divergence and posterior densities |
| `eq3/PD/data/*.mat` | `eq3/PD/main_VP_beta.m` | drug-response classification results |

---

## 7. Notes

* Simulation of 30,000 initial virtual patients is computationally intensive.
  The parallel routines (`parpool` / `parfor`, 15–17 workers) are used to speed
  it up; adjust the pool size to your machine.
* For the R^2 calibration, intermediate trajectories are written one file per
  sampled parameter set into `Result*/`; these folders can grow large and are
  excluded from version control.
* A brief description of the biological mechanisms and of the parameter
  classification is given in the manuscript (Sections 2–3 and Tables 1–3).

---

## 8. Citation

If you use this code, please cite:

```bibtex
@article{DuLei2026virtual,
  title   = {A unified framework for generating and calibrating virtual patients
             from heterogeneous clinical data},
  author  = {Du, Lei and Lei, Jinzhi},
  journal = {CSIAM Transactions on Life Sciences},
  year    = {2026}
}
```

---

## 9. License

Released under the **MIT License** — see [LICENSE](LICENSE) for details.

---

## 10. Contact

* Lei Du — dulei@tiangong.edu.cn
* Jinzhi Lei — jzlei@tiangong.edu.cn
