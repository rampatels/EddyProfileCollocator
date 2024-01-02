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
output: pdf_document
---
EddyProfSync (Eddy and Profile Synchronizer, futher abberiviated as EPS) addresses a critical need in the field of oceangraphy by providing a comprehensive and user-friendly tool for collocating mesoscale eddy with hydrographic observations. Mesoscale eddies transport physical and biogeochemical properties, thereby influencing local and remote ecosystem. However, subsurface observations of mesoscale eddies are limited due to their transient nature and ubiquity in the global ocean. The scarcity of direct subsurface measurements in these eddies has hindered a deeper understanding of their impact on oceanic processes. 

EddyProfSync emerges as a solution to this limitation, offering a unique oppotunity to extract subsurface observation of mesoscale eddies from existing datasets collected by research vessels or autonomous profiling floats. By seamlessly integrating the outputs of automated eddy tracking software and hydrographic observations. The workflow facilitates a systematic and efficient exploration of composite eddy studies as well as case study of individual eddy.

Existing studies have used diverse approaches to combine satellite observations and Argo float data for eddy research. For example, using manual tracking of eddies and using SLA data to idenfiy eddies such as those in Tatiyana paper. Another study used eddy equivalent length to identify profiles that are surfaced in eddy or not frenger et al. 2015 and Chigulie et al. Pagalio et al. etc. However no code availabe to perform this. In addition, with state-of-the-art eddy tracking algorithm it is possible to detect the outermost close contour of an eddy theyby leveraging this to detect profile would be efficient. The algorithm to perform this is given as follow.

# Algorithm
The EddyProfSync algorithm, designed for MATLAB, seamlessly integrates eddy tracking outputs and hydrographic observations to identify profiles associated with eddies. The algorithmic steps are as follows:
1. Inputs: EddyProfSync takes automated eddy-tracking output as input, including information about eddy position and time, and shape. In addition, it takes spatio-temporal location of hydrographic observations. For further detail about input is provided in function description and tutorial.
1. Identify profiles in eddies: using point-in-polygon algorithm, EddyProfSync determines whether each hydrographic observation profile lies in the boundary of a detected eddy for a given day. This is vectorised for efficient filtering of profiles and eddies.
1. Assign an eddy to the surfaced profile: using k-nearest-neighbour algorithm and poin-in-polygon algorithm, EddyProfSync matches the eddy to surfaced profile.

This algorithm can be seamlessly translated into other programming languages that are used by oceanographic community such as Python and Julia.

# Acknowledgements
funding from clex to conduct this research and support from supervisor to explore this idea.
matlab toolbox used in this software should be acknowledged/cited
# Reference
-------------