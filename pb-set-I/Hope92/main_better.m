
%% -------------------------------QUESTION 4a)-----------------------------
clear all
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

params = [w, cf , ce, beta, alpha]; %put all the parameters in a single vector

%grid of the productivity level
Phi=[0.1 0.3 0.5 0.7];
Phi=Phi'; %just make it as a colum vector

%transition level of the markov process for productivity
%this implies that for today pdty phi, the tomorow pdty phi_next is
%phi_next=F*phi where phi is a 4*1 vector
F=[1 0 0 0;
    0.1 0.6 0.2 0.1;
    0 0.1 0.8 0.1;
    0 0.1 0.1 0.8];

%Initial distribution for productivity
G=[0.4 0.4 0.1 0.1];
G=G'; %just make it as a colum vector

%% Step 1: Initial guess for the price
P0=2;
disp('Demand at initial price')
disp(D(P0));



%% Step 2, 3, 4
%here I use the matlab routine 'fsolve' for doing the iteration on price
%In main.m, I use a dumb algorithm ofr doing the same job

%initial guess for the value function
v0= ones(size(Phi));
v=v0;

options=optimset('Display','iter');

print=0; % put it to one if you want to display iteration of the value function algorithm

fun= @(P) entry_holds(P,v0,F,Phi,G,params,print);
P=fsolve(fun,P0,options);

[RES,v]=entry_holds(P,v0,F,Phi,G,params,print);

disp('The equilibrium price is')
disp(P)

%% Step 5: Find the cutoff value below whih it is better to default.

Ev = (F*v); %Compute the vector of expectation for v for each productivity level
%If there is a 1 in i then phi_i is above phi*, if there is a 0 then phi_i is below phi*

iphi_star=sum(1-(Ev>0));
if iphi_star>0;
    phi_star=Phi(iphi_star); %if error then equilibrium with no exit
    disp('Phi* is');
    disp(phi_star)
else disp('equilibrium with no exit')
end;

T=zeros(size(F));
T(iphi_star+1:size(F,1),:)=F(iphi_star+1:size(F,1),:);


%% Step 6: Solve for the stationnary distribution of phi
%The stationary distribution satisfied a equation with a fixed point such
%that mu = G*(I-T)^-1

%let us set M=1
I=eye(length(Phi));
mu= inv(I-T)*G;

disp('with a normalized mass of active firm equal to 1 the mesure of  productivity level is')
disp(mu);

%% Step 7: Find the value of M mass of active firm

y=y_star(Phi,P,params);

M=D(P)/(mu'*y);

disp('the equilibrium triplet is:')
disp('P=');disp(P);
disp('M=');disp(M);
disp('mu=');disp(mu*M);



