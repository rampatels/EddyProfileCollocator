# EddyProfSync: A MATLAB tools for collocating coherent eddy and hydrographic datasets

The **`EddyProfSync`** is a MATLAB - based tool designed to identify profiles that are surfaced in mesoscale eddies.


[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10453071.svg)](https://doi.org/10.5281/zenodo.10453071)


## Table of Content
1. [**Installation**](#installation-1)
1. [**Functions**](#functions)
1. [**Tutorials**](#examples)
1. [**Contributing**](#contributing)
1. [**Contact**](#contact)
1. [**Acknowledgement**](#acknowledgement)
1. [**Citation**](#citation)

<!-- 1. [**Requirements**](#requirements-1) -->

## Installation
The `EddyProfSync` is a standard MATLAB toolbox-style software. Therefore, it can be installed directly by downloading this repository and adding it to the path in your MATLAB. 

Alternatively, you can start your script with:
```matlab
addpath('path-to-the-EddyProfileCollocator-repo')
```
<!-- To quickly get started with `EddyProfSync`, follow these steps:
1.	Clone `EddyProfileCollocator` repository to your local machine.
1.	Add the toolbox to your MATLAB path.
1.	Run the provided example notebooks in the tutorials directory to understand the toolbox's capabilities. -->

<!-- ## Requirements
It is designed to work with MATLAB basic Toolbox. -->

## Functions
Functions are stored in two directories, namely, `src` and `utils`.

The source directory (**`src/`**) :
| Function | Description
:--|:--
| `find_profineddy()` | To collocate eddies and profile, uses `collocateeddynprof()`|
| `collocateeddynprof()` | To match eddies and surfaced profile |


The additional function directory (**`utils/`**) :
| Function | Description
:--- | :---
| `Ecode2voaygenums()` | To create indices from voyage name and station ID |
| `myargoindex()` | To create indices from Argo float WMO and Cycle Number |
| `omitvirtualeddy4mMETA()` | To remove virtual eddies from META eddies |
| `ra_fagwithshape2meta()` | To convert Chalton's table to META format |
| `ra_get_lon_lat_time()` | To extract spatio-temporal information from Argo data |
| `ra_getlonlattimeIncol()` | same as `ra_get_lon_lat_time` but all outputs are in column |
| `ra_importdata_interp()` | To extract Argo parameters after QCing for a given float WMO and Cycle Number |

**_NOTE: The detailed usage of each of these functions is elucidated in the following [tutorials](#examples)._**

## Examples
[**Collocate eddies and in-situ profiles**](tutorials/matchInsituProfiles_stas.html):\
This notebook demonstrates how to identify in-situ profiles that are surfaced in mesoscale eddies using historical observations.

[**Collocate eddies and BGC-Argo profiles**](tutorials/matchArgo_SO.ipynb):\
This notebook demonstrates the collocation of mesoscale eddies and BGC-Argo profiles in the Southern Ocean.

## Contributing
If you find a bug, have a question, or want to contribute, please open an issue or email [Ramkrushn Patel](Ramkrushnbhai.Patel@utas.edu.au). 

Detailed version of How to contribute will be provided in `doc/` directory.

## Contact
Ramkrushnbhai S. Patel

[IMAS](https://www.imas.utas.edu.au/), University of Tasmania\
ARC Centre of Excellence for Climate System Science (CLEX)

Email: [Ramkrushn Patel](mailto:Ramkrushnbhai.Patel@utas.edu.au)


## Acknowledgement

## Citation
