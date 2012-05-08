clear all
close all


%% Load the data
load chile86


value=size; %Juste rename the vector to not make any confusion with size()
clear size;

%% Question 1 a) Normalized and Plot Empirical density

%Normalized the value of the firms by the mean of the distribution
value_norm = value./mean(value);

%Plot the empirical density
figure(1)
%hist(value_norm,100);

[f,xi] = ksdensity(value_norm,'npoints',1000);

subplot(221)
plot(xi,f,'LineWidth',2);
xlim([0,max(value_norm)]);
xlabel('Value normalized by the mean')
ylabel('Empirical pdf')
title('Empirical pdf for the whole range of value')

subplot(222)
plot(xi,f,'LineWidth',2);
xlim([0,5]);
xlabel('Value normalized by the mean')
ylabel('Empirical pdf')
title('Empirical pdf up to 5 times the mean value')

subplot(223)
plot(xi,f,'LineWidth',2);
xlim([0,10]);
xlabel('Value normalized by the mean')
ylabel('Empirical pdf')
title('Empirical pdf up to 10 times the mean value')

subplot(224)
plot(xi,f,'LineWidth',2);
xlim([0,50]);
xlabel('Value normalized by the mean')
ylabel('Empirical pdf')
title('Empirical pdf up to 50 times the mean value')


%% Question 1 b) log rank - log size plot and CCDF plot

%Organize the data in log-rank and log-size plot

N=length(value_norm); %number of firms in the sample

value_sort=sort(value_norm);
log_v_sort=log(value_sort);
rank=(N:-1:1)';
log_rank=log(rank);

figure(2)
plot(log_v_sort,log_rank,'r','LineWidth',2);
title('log rank - log size of chilean firms in 1986');
xlabel('Log value');
ylabel('log of rank');

%Plot the cunter cumulative distribution function

ccdf = 1-cumsum(value_sort)/sum(value_sort);
%ccdf(j)=Prob(V>= Vj)
figure(3)
plot(value_sort,ccdf,'k','LineWidth',2);
title('Cunter Cumulative Distribution Function of chilean firms value in 1986');
xlabel('Value');
ylabel('CCDF');

%% Question 1 c) Estimating a power law for the upper tail

N=length(log_v_sort); %number of firms in the sample


%Selecte the 350 largest firms
disp('-----------------------------------------------')
Ntop=350;
disp(['for the ', num2str(Ntop), ' largest firms'])

log_rank_350=log_rank(N-Ntop+1:N);
log_v_sort_350 = log_v_sort(N-Ntop+1:N);

X=[log_v_sort_350, ones(size(log_v_sort_350))];
Y=log_rank_350;

beta=lscov(X,Y);

zeta=beta(1);
std=zeta*(Ntop/2)^(-1/2);

disp('The estimated slope is')
disp(zeta)
disp('with an asymptotique standard error (Gabaix 2007)')
disp(std)

%Selecte the 100 largest firms
disp('-----------------------------------------------')
Ntop=100;
disp(['for the ', num2str(Ntop), ' largest firms'])

log_rank_350=log_rank(N-Ntop+1:N);
log_v_sort_350 = log_v_sort(N-Ntop+1:N);

X=[log_v_sort_350, ones(size(log_v_sort_350))];
Y=log_rank_350;

beta=lscov(X,Y);

zeta=beta(1);
std=zeta*(Ntop/2)^(-1/2);

disp('The estimated slope is')
disp(zeta)
disp('with an asymptotique standard error (Gabaix 2007)')
disp(std)

%Selecte the 50 largest firms
disp('-----------------------------------------------')
Ntop=50;
disp(['for the ', num2str(Ntop), ' largest firms'])

log_rank_350=log_rank(N-Ntop+1:N);
log_v_sort_350 = log_v_sort(N-Ntop+1:N);

X=[log_v_sort_350, ones(size(log_v_sort_350))];
Y=log_rank_350;

beta=lscov(X,Y);

zeta=beta(1);
std=zeta*(Ntop/2)^(-1/2);

disp('The estimated slope is')
disp(zeta)
disp('with an asymptotique standard error (Gabaix 2007)')
disp(std)

%% Question 1 d) Empirical evidence of the non existence of second moment
% figure(4);
% 
% T=100; 
% Ndraw=100;
% Ntop=350;
% value_sort_350=value_sort(N-Ntop+1:N);
% 
% N=length(value_sort);
% 
% emp_std = zeros(T,Ndraw); 
% 
% 
% for k=2:T;
%     for n=1:Ndraw;
%       isample=randi(N,k,1);
%       sample=value_sort(isample);
%       w = ksdensity(value_norm,sample);
%       m=mean(w.*sample);
%       emp_std(k,n)= sqrt( 1/(k-1) * sum( w.*(sample -m).^2 ) );
%     end;
% end;
% 
% 
% plot(mean(emp_std,2),'LineWidth',2);
% xlabel('sample size');
% ylabel('\sigma_k');
% title('Adjusted empirical standard error');
% 
