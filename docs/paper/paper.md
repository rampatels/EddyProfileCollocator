---
title: 'EddyProfSync: A MATLAB tools for collocating coherent eddy and hydrographic datasets'
tags:
- mesoscale eddies
- Argo and BGC Argo
- Oceanography
- hydrographic profiles
- MATLAB
- ocean extremes
authors:
- affiliation: "1, 2"
  name: Ramkrushnbhai S. Patel
  orcid: 0000-0002-5302-6509
affiliations:
- index: 1
  name: Institute for Marine and Antarctic Studies, University of Tasmania, Hobart, Tasmania, Australia
- index: 2
  name: Australian Research Council Centre of Excellence for Climate System Science, Hobart, Tasmania, Australia
date: \today
bibliography: paper.bib
link-citations: true
output: pdf_document
---
EddyProfSync (Eddy and Profile Synchronizer) addresses a critical need in oceangraphy by providing a comprehensive and user-friendly MATLAB-based tool for collocating mesoscale eddies with hydrographic observations. Mesoscale eddies play a crucial role in transporting physical and biogeochemical properties, influencing local and remote ecosystems (e.g.,[@Patel:2019;@Patel:2020]). However, subsurface observations of mesoscale eddies are limited, partly due to their transient nature and ubiquity in the global ocean ([@Chelton:2011]). The scarcity of direct subsurface measurements in these eddies has hindered a deeper understanding of their role in influencing ocean dynamics and shaping the climate system.

EddyProfSync emerges as a solution, offering a unique oppotunity to extract subsurface observations of mesoscale eddies from existing datasets collected by research vessels or autonomous profiling floats. By seamlessly integrating automated eddy tracking outputs and hydrographic observations, EddyProfSync facilitates a systematic and efficient exploration of composite eddy studies as well as case studies of individual eddies.

Previous research has employed a variety of methodologies to integrate altimetry and hydrographic observations (e.g., [@Chaigneau:2011;@Pegliasco:2015;@Rykova:2015]). For instance, [@Rykova:2015] used Sea Level Anomaly maps derived from altimetry to objectively link Argo profiles obtained in eddies. The distance between an Argo profile and the centre of an eddy is also used to determine whether the profile is surfaced in eddy or not (e.g. [@Chaigneau:2011;@Pegliasco:2015;Frenger:2015]). Advances in eddy tracking algorithms now enable the detection of the outermost close contour of an eddy, along with various kinematic properties associated with mesoscale eddies. This eddy-boundary information can be leveraged to identify profiles surfaced in eddies, irrespective of shape constraints (e.g. [@Faghmous:2015;@Mason:2014;Pegliasco:2022]).

# Algorithm
The EddyProfSync (EPS) algorithm identifies profiles associated with eddies. The algorithmic steps are as follows:
1. Inputs: EPS takes automated eddy-tracking outputs, including information about eddy position, time, and shape, along with the spatio-temporal location of hydrographic observations. Detailed information about inputs is available in the function description and tutorials.
1. Identify profiles in eddies: using point-in-polygon algorithm, EPS determines whether each hydrographic observation profile lies in the boundary of a detected eddy for a given day. This process is vectorised for efficient filtering of profiles and eddies.
1. Assign an eddy to the surfaced profile: EPS employs the k-nearest-neighbour algorithm and poin-in-polygon algorithm to match surfaced profiles with the corresponding eddy.

The EPS algorithm is designed for MATLAB but can be seamlessly translated into other programming languages commonly used in the oceanographic community, such as Python and Julia.

# Reference