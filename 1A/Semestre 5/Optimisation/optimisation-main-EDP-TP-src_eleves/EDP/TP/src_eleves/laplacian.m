function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les directions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation

% dx1 = h1 et dx2 = h2
delta1 = (-nu(1))/(dx1^2);
delta2 = (-nu(2))/(dx2^2);

e1 = ones(N1, 1);
e2 = ones(N2, 1);

A2 = kron(speye(N1,N1), spdiags([-delta2*e2 2*delta2*e2 -delta2*e2] , [-1 0 1], N2, N2));
A1 = kron(spdiags([-delta1*e1 2*delta1*e1 -delta1*e1] , [-1 0 1], N1, N1), speye(N2, N2));

L=A1+A2;

end    
