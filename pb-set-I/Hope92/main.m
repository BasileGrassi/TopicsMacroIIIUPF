
%% -------------------------------QUESTION 4a)-----------------------------

addpath('lib/');
%% Parameters of the benchmark case


%demand is defined in the file lib/D.m

%wage
w=0.3;
%fixe cost
cf=0.2;
%entry cost
ce=0.5;
%discount rate
beta=0.95;
%labor share
alpha=0.8;

%grid of the productivity level
Phi=[0.1 0.3 0.4 0.5 0.7];

%transition level of the markov process for productivity
F=[1 0 0 0;
    0.1 0.6 0.2 0.1];

%% Step 1 : Initial guess for the price
P=2;
disp(D(P));
%% Step 2: Solve for the static profit maximization

Pro_Phi_P = PI(Phi,P);