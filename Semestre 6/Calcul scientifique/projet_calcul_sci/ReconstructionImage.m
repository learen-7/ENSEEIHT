%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_1.png');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k), axis equal
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause


% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%

M = zeros(min(p, q));
if (p < q)
    M = I'*I;
else
    M = I * I';
end


%% calcul des couples propres
% TODO
    % eig
    [VA, DA] = eig(M);
    [WA, indices] = sort(diag(DA), 'descend');
    VA = VA(:, indices);

%     % power
%     [VA, DA, ~, ~, ~ ] = power_v12(M, search_space, percentage, eps, maxit);
%     WA = diag(DA);
% 
%     % subspace_V0
%     [VA, DA, ~, ~] = subspace_iter_v0(M, search_space, eps, maxit);
%     WA = diag(DA);
% 
%     % subspace_V1
%     [VA, DA, ~, ~, ~, ~] = subspace_iter_v1(M, search_space, percentage, eps, maxit);
%     WA = diag(DA);
% 
%     % subspace_V2
%     [VA, DA, ~, ~, ~, ~] = subspace_iter_v2(M, search_space, percentage, puiss, eps, maxit);
%     WA = diag(DA);
% 
%     % subspace_V3
%     [VA, DA, ~, ~, ~, ~ ] = subspace_iter_v3(M, search_space, percentage, puiss, eps, maxit);
%     WA = diag(DA);

U_k = zeros(q, m);
V_k = zeros(p, m);
if (p < q)
    U_k = VA(:, 1:k);
else
    V_k = VA(:, 1:k);
end

%% calcul des valeurs singulières
% TODO
Sigma_k = diag(sqrt(WA(1:m)));

%% calcul de l'autre ensemble de vecteurs
% TODO
if (p < q)
    for i = 1:m
        V_k(:, i) = (1/Sigma_k(i, i)) * I' * U_k(:, i);
    end  
else
    for i = 1:m
        U_k(:, i) = (1/Sigma_k(i, i)) * I * V_k(:, i);
    end  
end


%% calcul des meilleures approximations de rang faible

DifferenceSVD_bis = zeros(size(inter, 2), 1);
% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U_k(:, 1:k)*Sigma_k(1:k, 1:k)*V_k(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_bis(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end
