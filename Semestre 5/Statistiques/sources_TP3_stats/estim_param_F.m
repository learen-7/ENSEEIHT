% Fonction estim_param_F (exercice_1.m)

function [rho_F,theta_F,ecart_moyen] = estim_param_F(rho,theta)

 n = size(rho, 1);
 A = [cos(theta) , sin(theta)]; 
 B = rho;
  
 X = A\B;

 x_F = X(1);
 y_F = X(2);

 rho_F = sqrt(x_F^2 + y_F^2);
 theta_F = atan2(y_F, x_F);

 ecart_moyen = (1/n)* sum(abs(A*X - B));

end