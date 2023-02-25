%----------------------------  Part 1  --------------------------------

%Uncomment one of the following matrices or add your own matrix.

% M = [1 0 0;1 1 0;0 1 1;1 1 1];                
% M = [2 0 0;-4 -4 0;3 3 3];                    
% M = [1 -0.5;-0.5 1;0 1;0.5 1];               
% M = [1 1 -1 -1; -1 1 1 -1];                   

%First argument is symbols matrix and second argument is symbols duration.
[coeffecients, symbols_energy] = GramSchmidt(M, 3);

%%
%----------------------------  Part 2  --------------------------------

%The first argument which is symbols amplitude must be the same but with
%different signs. The first row is logical 1 and the second is logical 0.
%Logical 1 must be positive value and logical 0 must be negative value.

%The second arguement is the symbol duration.

%The third arguement is the probability of logical 1. 

binaryNRZ_BER([1; -1], 1, 0.5)
