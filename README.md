![npm](https://img.shields.io/npm/dm/localeval.svg) ![Eclipse Marketplace](https://img.shields.io/eclipse-marketplace/favorites/notepad4e.svg) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1209882.svg)](https://doi.org/10.5281/zenodo.1209882)
# Continuation Power Flow (CPF)

This repository contains MATLAB Code for the calculating Continuation Power Flow (CPF) for IEEE-14 bus system. The reference book for this code was Mariesa Crow's [Computational Methods for Electric Power Systems](https://books.google.com/books/about/Computational_Methods_for_Electric_Power.html?id=4Z_AoSZ8lGEC).

## How to run the code? 

Go to `main.m`, and change the bus number in line 43, for the bus for which CPF needs to be performed. 

## Steps to perform CPF using the developed program:

- Get bus and branch data 
- Form Y bus matrix
- Calculate scheduled values of real and reactive power


__UPPER PART: LOAD AS CONTINUATION PARAMETER__

-	Find out the Jacobian Matrix
-	Predictor Step: 
	-	Step size (sigma) := 0.1
	-	Lambda := 0.1
	-	Find out the voltage and angles

- Corrector Step:
	-	Perform Newton Raphson load flow by increasing scheduled real and reactive power by a factor of lambda from predictor step.
	- 	Make sure the power flow converges within a certain number of iterations. If the power flow converges, the final value of voltage and lambda is saved. It is used to plot the loadability curve. 
	-	If power flow converged, perform the next iteration of the predictor step (Step 5), and get the next point to plot, and carry on until the power flow stops to converge in the predictor step.
	OR,
	If power flow did not converge, then move to VOLTAGE AS CONTINUATION PARAMETER


__VOLTAGE AS CONTINUATION PARAMETER:__
 
 - Step size (sigma) := 0.005
 - Find the Jacobian Matrix
 - Predictor Step: 
 	- 	Lambda := last known value from Step 6.
	- 	Find out the voltage and angles
- Corrector Step:
	-	Perform Newton Raphson load flow by increasing scheduled real and reactive power by a factor of lambda from predictor step.
	-	Solution to V – Vpredicted = 0 is an additional criteria for convergence (Eq. 3.167 of book). 
	-	Make sure the power flow converges within a certain number of iterations. If the power flow converges, the final value of voltage and lambda is saved. It is used to plot the loadability curve. 
	- 	If power flow converged, perform the next iteration of the predictor step, and get the next point to plot, and carry on until the power flow stops to converge in the predictor step (Step 9).
	- 	If the calculated lambda value is 75% of lambda last calculated in Step 6, CHANGE CONTINUATION PARAMETER AGAIN to Power. 

__CHANGE CONTINUATION PARAMETER AGAIN__

- Repeat steps 5 and 6. 
- Plot the final loadability curve. 

__Table 1: Points where continuation factors need to be changed to avoid matrix singularity__

Columns 2 and 3:  Load as CF to Voltage as CF<br>
Columns 4 and 5:  Voltage as CF to Load as CF<br>


| Bus Number 	| Lambda at change 	| V(p.u.) 	| Lambda at change 	| V(p.u.) 	|
|------------	|------------------	|---------	|------------------	|---------	|
| 4          	| 4.0              	| 0.7641  	| 2.9              	| 0.4491  	|
| 5          	| 4.0              	| 0.7496  	| 3.2              	| 0.3946  	|
| 7          	| 4.0              	| 0.8463  	| 2.8              	| 0.6013  	|
| 9          	| 4.0              	| 0.7652  	| 2.9              	| 0.5152  	|
| 10         	| 4.0              	| 0.7792  	| 2.9              	| 0.5692  	|
| 11         	| 4.0              	| 0.9055  	| 2.8              	| 0.7955  	|
| 14         	| 4.0              	| 0.7330  	| 2.8              	| 0.5780  	|

If we increase the IEEE-14 bus load for all buses upto 4 times, power flow fails to converge. However, if we significantly decrease the step size and change the continuation parameter the maximum loadability point is reached. For all buses, it is around 4.05, however for bus 11, it is 4.06. The maximum loadability of all the buses are shown in Table 2. 

__Table 2: Maximum loadability points__

| Bus Number 	| Lambda Max 	| V(p.u.) at Lambda Max 	|
|------------	|------------	|-----------------------	|
| 4          	| 4.0593     	| 0.7041                	|
| 5          	| 4.0594     	| 0.6796                	|
| 7          	| 4.0602     	| 0.8013                	|
| 9          	| 4.0592     	| 0.7102                	|
| 10         	| 4.0591     	| 0.7292                	|
| 11         	| 4.0638     	| 0.8805                	|
| 14         	| 4.0585     	| 0.6880                	|



## Results

![Bus 4](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-4.png)
![Bus 5](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-5.png)
![Bus 7](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-7.png)
![Bus 9](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-9.png)
![Bus 10](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-10.png)
![Bus 11](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-11.png)
![Bus 14](https://github.com/sayonsom/continuation-power-flow/blob/master/Results/cpf-bus-14.png)

## Credits

Special thanks to Juan Carlos Bodoya, a brilliant guy. 

If you used this, please cite:

Bibtex:
```tex
@misc{sayon_cpf,
  author       = {Sayonsom Chanda},
  title        = {{Open Source Continuation Power Flow Implementation in MATLAB}},
  month        = mar,
  year         = 2018,
  doi          = {10.5281/zenodo.1209882},
  url          = {https://doi.org/10.5281/zenodo.1209882}
}

```

IEEE:
```
Sayonsom, “Open Source Continuation Power Flow Implementation in        MATLAB”. Zenodo, 29-Mar-2018.
```


If you used the repository, please "Star" the repository, and share it with your friends. If you have questions, please contact me:

Sayonsom Chanda, MSEE, EIT<br>
Washington State University<br>
Email: ![sayon@ieee.org](mailto:sayon@ieee.org)

Also available at [my blog](https://sayonsom.github.io), [sayonsom.github.io](https://sayonsom.github.io). 




 
