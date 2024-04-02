% fonction estim_param_MC_paire (pour exercice_2.m)

function parametres = estim_param_MC_paire(d,x,y_inf,y_sup)
p=length(x);
A=zeros(2*p,(2*d-1));

for k = 1:(d-1)
    A(1:p, k) = vecteur_bernstein(x, d, k);
end
for k = 1:d
    A(p+1:end, d-1+k) = vecteur_bernstein(x, d, k);
end
A(1:p, 2*d-1) = vecteur_bernstein(x,d,d);

B = [y_inf - y_inf(1) * vecteur_bernstein(x, d, 0); y_sup - y_sup(1) * vecteur_bernstein(x, d, 0)] ;

parametres = A\B;

end
