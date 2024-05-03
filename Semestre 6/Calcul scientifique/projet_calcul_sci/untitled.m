%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_1.png');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf("start SVD\n")
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
    imagesc(Im_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end

% Figure des différences entre image réelle et image reconstruite
fprintf("fig\n")
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
fprintf("start eig \n")
%%
% calcul des couples propres
%%
A = I'*I;
%%  Avec eig

[V, D] = eig(A);
D = diag(D);
[D, perm] = sort(D, 'descend');
V = V(:,perm);
tic
%%
% calcul des valeurs singulières
%%
Vsing_200 = sqrt(D(1:200));
Vsing_200 = diag(Vsing_200);
V_200 = V(:,1:200);
%%
% calcul de l'autre ensemble de vecteurs
%%
for i=1:200
    U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
end
toc

ti = 0;
td = 0;
differenceSVD_200 = zeros(size(inter,2), 1);

pause 
for k = inter
 Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_200_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
    pause
end

figure(8)
hold on 
plot(inter, differenceSVD_200, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

%% Avec power_v11 et power_v12
fprintf("start power_v11 et _v12 \n")
% Il n'y a pas convergence : le programme boucle jusqu'à
%que maxit soit atteint.

% tic
% A = I'*I;
% [ V, Dp, ~, ~,~] = power_v11(A, 100, 0.99 ,eps, maxit );
% Dp = diag(Dp);
% %%
% % calcul des valeurs singulières
% %%
% Vsing_200 = sqrt(Dp(1:184));
% Vsing_200 = diag(Vsing_200);
% V_200 = V(:,1:184);
% %%
% % calcul de l'autre ensemble de vecteurs
% %%
% for i=1:184
%     U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
% end
% toc
% 
% ti = 0;
% td = 0;
% differenceSVD_200 = zeros(size(inter,2), 1);
% 
% pause 
% for k = inter(1:5)
%  Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';
% 
%     % Affichage de l'image reconstruite
%     ti = ti+1;
%     figure(ti)
%     colormap('gray')
%     imagesc(Im_200_k)
%     
%     % Calcul de la différence entre les 2 images
%     td = td + 1;
%     differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
%     pause
% end
% 
% figure(13)
% hold on 
% plot(inter, differenceSVD_200, 'rx')
% ylabel('RMSE')
% xlabel('rank k')
% pause

%% Avec subspace_iter_v0
fprintf("start subspace_iter_v0\n")
tic
[ V, D, ~, ~] = subspace_iter_v0(A,search_space, eps, maxit );
D = diag(D);
m = min(200, length(D));
%%
% calcul des valeurs singulières
%%
Vsing_200 = sqrt(D(1:m));
Vsing_200 = diag(Vsing_200);
V_200 = V(:,1:m);
%%
% calcul de l'autre ensemble de vecteurs
%%
U_200 = zeros(length(U),m);
for i=1:m
    U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
end
toc

ti = 0;
td = 0;
differenceSVD_200 = zeros(size(inter,2), 1);

pause 
for k = inter(inter <= length(D))
 Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_200_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
    pause
end

figure(9)
hold on 
plot(inter, differenceSVD_200, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

%% Avec subspace_iter_v1
fprintf("start subspace_iter_v1\n")
tic
[ V, D, ~, ~, ~, ~ ] = subspace_iter_v1(A, search_space, percentage, eps, maxit );
D = diag(D);
m = min(200, length(D));
%%
% calcul des valeurs singulières
%%
Vsing_200 = sqrt(D(1:m));
Vsing_200 = diag(Vsing_200);
V_200 = V(:,1:m);
%%
% calcul de l'autre ensemble de vecteurs
%%
U_200 = zeros(length(U),m);
for i=1:m
    U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
end
toc

ti = 0;
td = 0;
differenceSVD_200 = zeros(size(inter,2), 1);

pause 
for k = inter(inter <= length(D))
 Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_200_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
    pause
end


figure(10)
hold on 
plot(inter, differenceSVD_200, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

% Avec subspace_iter_v2
fprintf("start subspace_iter_v2\n")
tic
[ V, D, ~, ~, ~, ~ ] = subspace_iter_v2(A, search_space, percentage,puiss, eps, maxit );
D = diag(D);
m = min(200, length(D));
%%
% calcul des valeurs singulières
%%
Vsing_200 = sqrt(D(1:m));
Vsing_200 = diag(Vsing_200);
V_200 = V(:,1:m);
%%
% calcul de l'autre ensemble de vecteurs
%%
U_200 = zeros(length(U),m);
for i=1:m
    U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
end
toc

ti = 0;
td = 0;
differenceSVD_200 = zeros(size(inter,2), 1);

pause 
for k = inter(inter <= length(D))
 Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_200_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
    pause
end

figure(11)
hold on 
plot(inter, differenceSVD_200, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause

%% Avec subspace_iter_v3
fprintf("start subspace_iter_v3\n")
tic
[ V, D, ~, ~, ~, ~ ] = subspace_iter_v3(A, search_space, percentage,puiss, eps, maxit );
D = diag(D);
m = min(200, length(D));
%%
% calcul des valeurs singulières
%%
Vsing_200 = sqrt(D(1:m));
Vsing_200 = diag(Vsing_200);
V_200 = V(:,1:m);
%%
% calcul de l'autre ensemble de vecteurs
%%
U_200 = zeros(length(U),m);
for i=1:m
    U_200(:,i) = (1/Vsing_200(i,i))*I*V_200(:,i);
end
toc

ti = 0;
td = 0;
differenceSVD_200 = zeros(size(inter,2), 1);

pause 
for k = inter(inter <= length(D))
 Im_200_k = U_200(:, 1:k)*Vsing_200(1:k, 1:k)*V_200(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_200_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_200(td) = sqrt(sum(sum((I-Im_200_k).^2)));
    pause
end

figure(12)
hold on 
plot(inter, differenceSVD_200, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause
%%
% calcul des meilleures approximations de rang faible
%%