# Continuation Power Flow (CPF)

This repository contains MATLAB Code for the calculating Continuation Power Flow (CPF) for IEEE-14 bus system. The reference book for this code was Mariesa Crow's [Computational Methods for Electric Power Systems](https://books.google.com/books/about/Computational_Methods_for_Electric_Power.html?id=4Z_AoSZ8lGEC).

## How to run the code? 

Go to `main.m`, and change the bus number in line 43, for the bus for which CPF needs to be performed. 

## Steps to perform CPF using the developed program:
1.	Get bus and branch data 
2.	Form Y bus matrix
3.	Calculate scheduled values of real and reactive power

_UPPER PART: LOAD AS CONTINUATION PARAMETER_
4.	Find out the Jacobian Matrix
5.	Predictor Step: 
	a.	Step size (sigma) := 0.1
	b.	Lambda := 0.1
	c.	Find out the voltage and angles
6.	Corrector Step:
	a.	Perform Newton Raphson load flow by increasing scheduled real and reactive power by a factor of lambda from predictor step.
	b.	Make sure the power flow converges within a certain number of iterations. If the power flow converges, the final value of voltage and lambda is saved. It is used to plot the loadability curve. 
	c.	If power flow converged, perform the next iteration of the predictor step (Step 5), and get the next point to plot, and carry on until the power flow stops to converge in the predictor step.
	OR,
	If power flow did not converge, then move to VOLTAGE AS CONTINUATION PARAMETER

_VOLTAGE AS CONTINUATION PARAMETER:_
 
7.	Step size (sigma) := 0.005
8.	Find the Jacobian Matrix
9.	Predictor Step: 
	a.	Lambda := last known value from Step 6.
	b.	Find out the voltage and angles
10.	Corrector Step:
	a.	Perform Newton Raphson load flow by increasing scheduled real and reactive power by a factor of lambda from predictor step.
	b.	Solution to V – Vpredicted = 0 is an additional criteria for convergence (Eq. 3.167 of book). 
	c.	Make sure the power flow converges within a certain number of iterations. If the power flow converges, the final value of voltage and lambda is saved. It is used to plot the loadability curve. 
	d.	If power flow converged, perform the next iteration of the predictor step, and get the next point to plot, and carry on until the power flow stops to converge in the predictor step (Step 9).

	e.	If the calculated lambda value is 75% of lambda last calculated in Step 6, CHANGE CONTINUATION PARAMETER AGAIN to Power. 

_CHANGE CONTINUATION PARAMETER AGAIN_

11.	Repeat steps 5 and 6. 
12.	Plot the final loadability curve. 

Table 1: Points where continuation factors need to be changed to avoid matrix singularity 
|-----------------|----------------------|----------------|-------------------------|--------------|
|| Load as CF to Voltage as CF 	|Voltage as CF to Load as CF|
|Bus Number|	Lambda at change|	V(p.u.)|	Lambda at change|	V(p.u.)|
|-----------------|----------------------|----------------|-------------------------|--------------|
|4|	4.0|	                  0.7641| 	2.9|	                  0.4491 |
|5|	4.0|	                  0.7496| 	3.2|	                  0.3946 |
|7|	4.0|	                  0.8463| 	2.8|	                  0.6013 |
|9|	4.0|	                  0.7652| 	2.9|	                  0.5152 |
|10|	4.0|	                  0.7792| 	2.9|	                  0.5692 |
|11|	4.0|	                  0.9055|	2.8|	                  0.7955 |
|14|	4.0|	                  0.7330| 	2.8|	                  0.5780| 
|-----------------|----------------------|----------------|-------------------------|--------------|

Table 2: Maximum loadability points
|--|---|
|Bus Number|	Lambda Max |	V(p.u.) at Lambda Max|
|--|---|
|4|	4.0593 |	       0.7041 | 
|5|	4.0594	|                  0.6796 |
|7|	4.0602	|                  0.8013 |
|9|	4.0592	 |                 0.7102 |
|10|	4.0591	 |                 0.7292 |
|11|	4.0638	 |                 0.8805 |
|14|	4.0585	 |                 0.6880 | 
|--|---|
If we increase the IEEE-14 bus load for all buses upto 4 times, power flow fails to converge. However, if we significantly decrease the step size and change the continuation parameter the maximum loadability point is reached. For all buses, it is around 4.05, however for bus 11, it is 4.06. The maximum loadability of all the buses are shown in Table 2. 

## Results

![Bus 4](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-4.png)
![Bus 5](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-5.png)
![Bus 7](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-7.png)
![Bus 9](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-9.png)
![Bus 10](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-10.png)
![Bus 11](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-11.png)
![Bus 14](https://github.com/sayonsom/continuation-power-flow/Results/cpf-bus-14.png)

## Credits

Special thanks to Juan Carlos Bodoya, a brilliant guy. 
If you used the repository, please "Star" the repository, and share it with your friends. If you have questions, please co

Also available at [my blog](sayonsom.github.io), [sayonsom.github.io](sayonsom.github.io)




 
