function out = PI (Phi, P, params)
%Phi could be a colum vector of level of pdty and then out will also be
%a colums vector with same size

%params = [w, cf , ce, beta, alpha];

w=params(1);
cf=params(2);
ce=params(3);
beta = params(4);
alpha = params(5);

out = (P.*Phi).^(1/(1-alpha)).*alpha^(1/(1-alpha)) .* (1/alpha -alpha) .* (1/w)^(alpha/(1-alpha))-cf;


end