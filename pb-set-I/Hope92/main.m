
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
P0=1;
disp(D(P0));
P=P0;

% Convergence criteria
tol_price=1e-3;
maxiteration_price=50000;
step_price=1e-4;

RES0 = 1e6;

iteration_price=1;
converge_price=0;

print=0;  %print=1 thent print iteration on value function, if print = 0 do not print


disp('Starting iteration on price');
disp('_________________________________________________________');
disp('iter       error        gain    price   inner    elap.(s)  ');
disp('_________________________________________________________');

while converge_price==0 && iteration_price < maxiteration_price
    %% Step 2: Solve for the static profit maximization given guess

    %the static profit is defined in lib/PI.m
    %this function takes a colums vector Phi and a price P and return a vector
    %of profit corresponding to each pdty level in Phi
    Pro_Phi_P = PI(Phi,P,params);



    %% Step 3: Solve for the value function using value function iteration

    % Convergence criteria
    tol=1e-3;
    maxiteration=500;
    

    %initial guess
    v0= ones(size(Phi));
    v=v0;

   

    
    if print==1;
    disp('Starting value function iteration.');
    disp('_________________________________________________________');
    disp('iter       error        gain    price   inner    elap.(s)  ');
    disp('_________________________________________________________');
    end;

    iteration=1;
    converge=0;
    err0 = 1e6;

    nit=1; %just useless


    tic;
    t0 = tic;
    while converge==0 && iteration < maxiteration

        Ev = (F*v); 
        %See the response sheet for more information about the above expression
        %The row i of the Ev vector is just the Expectation of v given that the
        %past pdty realization was Phi_i
        v_up = PI(Phi,P,params) + beta * max(0,Ev);


        err=sum(sum(abs(v-v_up)));
        if (err < tol);
            converge=1;
        end;

        t1 = tic;
        elapsed = double(t1 - t0)/1e6;
        t0 = t1;

        if print==1;
        gain=err/err0;
        fprintf('%d\t%e\t%.2f\t%.2f\t%d\t%.2f\n', iteration, err, gain, P, nit, elapsed)
        end;

        err0 = err;  

        v=v_up;
        iteration = iteration+1;


    end;
    if print==1;
    disp('___________ ________________________________');
    toc;
    end;
    %% Step 4: Check that given the guess the entry condition holds

    RES = ce-G'*v; %how much you miss the entry condition
%     disp('You miss the entry condition by');
%     disp(RES);

    err_price=abs(RES);

    gain_price=err_price/RES0;
    fprintf('%d\t%e\t%.2f\t%.2f\t%d\t%.2f\n', iteration_price, err_price, gain_price, P, nit, elapsed)
    
    
    if RES >0; P=P+step_price;
    else P=P-step_price;
    end;
    
    if (err_price < tol_price);
      converge_price=1;
    end;
    
    iteration_price = iteration_price+1;
   
end;
disp('___________ ________________________________');

disp('The equilibrium price is')
disp(P)

%here I have implement the dumbiest convergence algorithm for P in
%main_better.m I use the matlab routine 'fsolve' for doing the iteration on
%price.

%% Step 5: Find the cutoff value below whih it is better to default.

Ev = (F*v); %Compute the vector of expectation for v for each productivity level
%If there is a 1 in i then phi_i is above phi*, if there is a 0 then phi_i is below phi*

iphi_star=sum(1-Ev>0)-1;
if iphi_star>0;
    phi_star=Phi(sum(1-Ev>0)-1); %if error then equilibrium with no exit
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