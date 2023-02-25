## Part 1: Gram-Schmidt on an input matrix
This section involves passing an input matrix to the GramSchmidt function, which applies the Gram-Schmidt orthogonalization algorithm to generate a collection of basis functions. Then, the function generates a plot of the basis function's constellation diagram.

For illustration, We will pass a test matrix where each symbol is 3 duration is unit time.
```
M = [1 0 0;1 1 0;0 1 1;1 1 1];
[coeffecients, symbols_energy] = GramSchmidt(M, 3);
```
#### Firstly, The function plots the input symbols:

<img src="https://user-images.githubusercontent.com/90058055/221358150-e8e3ef37-51d3-4ebf-adbd-a821738a0c08.png" width="350">

#### Then it performs the algorithm and plots the basis functions:

<img src="https://user-images.githubusercontent.com/90058055/221358348-1abd91f0-07cd-4f4f-bacf-9c277887f83b.png" width="350">

#### Finally, it plots the constellation diagram and the signal space

<div>
<img src="https://user-images.githubusercontent.com/90058055/221358483-1aef2c8b-b0da-4b16-b935-a1742f9bfa69.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221358529-26236497-849b-485f-b45c-70a5415830b3.png" width="350">
</div>


## Part 2: Transmission of polar NRZ data through AWGN channel
This part involves simulating the transmission of binary data through an AWGN channel and generating a constellation plot of the received symbols. Subsequently, the code computes the bit error rate (BER) and compares it to the theoretical BER.

For example, We will pass binary data of amplitudes 1 and -1, each symbol has unit duration and equal probability.
```
binaryNRZ_BER([1; -1], 1, 0.5)
```
#### Firstly, The function plots the input symbols:

<img src="https://user-images.githubusercontent.com/90058055/221359394-21378ba4-f0a1-488d-8aba-73458e6cf6ba.png" width="350">

#### Then, the function calls GramSchmidt function from the previous part to calculate the basis function and plot the constellation

<div>
<img src="https://user-images.githubusercontent.com/90058055/221359555-a0bb0c10-6cf2-4b8e-b80b-d30d6247c989.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221359615-43e64797-f672-46a6-a84d-ab50115f2a3c.png" width="350">
<br>
</div>

#### The code adds AWGN to the symbols to simulate the channel. then, it plots the constellation of the recrived symnols at different Eb/No

<img src="https://user-images.githubusercontent.com/90058055/221360036-940ad0a7-120f-4e22-8c4c-eae5fcc63006.png" width="350">

#### Then, the distribution of symbols is plotted and compared with the expected distribution

<div>
<img src="https://user-images.githubusercontent.com/90058055/221360186-3ceeaa0d-5dda-425c-906b-9ad2dee719d7.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221360393-0900c5cf-54fe-48a6-80b4-dec76cb93946.png" width="350">
</div>

<div>
 <br>
<img src="https://user-images.githubusercontent.com/90058055/221360491-e905e31b-1016-4248-bce7-affcf7e12662.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221360525-07572480-f873-467d-a6a8-24801013abc9.png" width="350">
</div>

#### The BER is plotted and compared to the theoretical BER

<img src="https://user-images.githubusercontent.com/90058055/221366062-6875d994-6fa4-4746-a55c-f315529c01ac.png" width="350">

#### The user can also control the probability of logical 1, if the user specified a probability of 0.7 for example, they would get the following distributions

<div>
<img src="https://user-images.githubusercontent.com/90058055/221366937-415883d7-e273-4306-91c7-814cc0c1d63e.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221366602-8c4467f3-36c6-4a21-a3cf-2f373a966d63.png" width="350">
</div>

<div>
<br>
<img src="https://user-images.githubusercontent.com/90058055/221366620-71d5f3ba-a2df-4383-bb7e-b552ad72e432.png" width="350">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/90058055/221366648-9fa7f6d2-95ad-491a-bf13-2eb96a1d0365.png" width="350">
</div>

#### and the following BER

<img src="https://user-images.githubusercontent.com/90058055/221366760-b5ee633f-89c4-4dab-965c-47164533d3bb.png" width="350">


