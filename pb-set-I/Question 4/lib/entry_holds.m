function [RES,v]=entry_holds(P,v0,F,Phi,G,params,print)
%% Information
%print=1 thent print itaration, if print = 0 do not print


%% Parameters
w=params(1);
cf=params(2);
ce=params(3);
beta = params(4);
alpha = params(5);

%% Step 2: Solve for the static profit maximization given guess

%the static profit is defined in lib/PI.m
%this function takes a colums vector Phi and a price P and return a vector
%of profit corresponding to each pdty level in Phi
%Pro_Phi_P = PI(Phi,P,params);
 


%% Step 3: Solve for the value function using value function iteration

% Convergence criteria
tol=1e-3;
maxiteration=500;


%initialisation
v=v0;



if print==1;
disp('Starting value function iteration.');
disp('_________________________________________________________');
disp('iter       error        gain    hom   inner    elap.(s)  ');
disp('_________________________________________________________');
end;

iteration=1;
converge=0;
err0 = 1e6;
hom=1; %just useless
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
    fprintf('%d\t%e\t%.2f\t%.2f\t%d\t%.2f\n', iteration, err, gain, hom, nit, elapsed)
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

RES = ce-G'*v;



end