### Part 1: Gram-Schmidt on an input matrix
This section involves passing an input matrix to the GramSchmidt function, which applies the Gram-Schmidt orthogonalization algorithm to generate a collection of basis functions. Then, the function generates a plot of the basis function's constellation diagram.

For illustration, We will pass a test matrix where each symbol is 3 duration is unit time.
```
M = [1 0 0;1 1 0;0 1 1;1 1 1];
[coeffecients, symbols_energy] = GramSchmidt(M, 3);
```
Firstly, The function plots the input symbols:

<img src="https://user-images.githubusercontent.com/90058055/221358150-e8e3ef37-51d3-4ebf-adbd-a821738a0c08.png" width="350">

Then it performs the algorithm and plots the basis functions:

<img src="https://user-images.githubusercontent.com/90058055/221358348-1abd91f0-07cd-4f4f-bacf-9c277887f83b.png" width="350">

Finally, it plots the constellation diagram and the signal space

<div>
<img src="https://user-images.githubusercontent.com/90058055/221358483-1aef2c8b-b0da-4b16-b935-a1742f9bfa69.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221358529-26236497-849b-485f-b45c-70a5415830b3.png" width="350">
</div>
