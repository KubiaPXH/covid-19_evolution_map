## Animated Map For Covid-19 Evolution With Stata

In this assignment, we create a data visualization map (Figure 1) which shows the number of confirmed cases of COVID-19 for each country in the world on november 18,
2020 and an animated map ([video link](http://www.youtube.com/watch?v=rCzYxJ0y4zE)) to illustrate the evolution of the epidemic overtime. This static map is created using two commands which are _spshape2dta_ and _spmap_ and the animated map is generated using the _ffmpeg_ free package.

![image](https://user-images.githubusercontent.com/62499070/163431112-580a9d95-6e22-4ba0-ac04-2a780361d80a.png)

## Table of Contents
- [data](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/data)
  - [processed](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/data/processed): final dataset for modeling
  - [raw](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/data/raw): raw, original data
    - [covid data](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/data/raw/covid%20data): covid raw data
    - [GIS data](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/data/raw/GIS%20data): GIS data to plot the map
- [graphs](https://github.com/KubiaPXH/covid-19_evolution_map/tree/main/graphs): generated graphics and figures to be used in the thesis
  - [s
- [references](https://github.com/KubiaPXH/effectiveness_of_APPCAP-M1_thesis/tree/master/references): related documentations with the thesis
- [scr](https://github.com/KubiaPXH/effectiveness_of_APPCAP-M1_thesis/tree/master/scr): source code for use in this project
  - [code](https://github.com/KubiaPXH/effectiveness_of_APPCAP-M1_thesis/tree/master/scr/code): code for ploting and running econometrics model
  - [notebook](https://github.com/KubiaPXH/effectiveness_of_APPCAP-M1_thesis/tree/master/scr/notebook): jupiter notebook with code for ploting and running econometrics model
