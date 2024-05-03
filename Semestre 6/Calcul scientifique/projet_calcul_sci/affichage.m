imat = 1;
n = 200;

[A, D, ~] = matgen_csad(imat,n);
save(['A_' num2str(n) '_' num2str(imat)], 'A', 'D', 'imat', 'n');

figure
plot(1:n, D);
xlabel('Numéro de valeur propre');
ylabel('Valeur propre associée');
title('Valeurs propres triées par ordre décroissant pour une matrice de type 1 (n = 200)');


figure;
imat = 2;
[A, D, ~] = matgen_csad(imat,n);
save(['A_' num2str(n) '_' num2str(imat)], 'A', 'D', 'imat', 'n');
hold on
plot(1:n, D, 'DisplayName',"Type 2");

imat = 3;
[A, D, ~] = matgen_csad(imat,n);
save(['A_' num2str(n) '_' num2str(imat)], 'A', 'D', 'imat', 'n');
hold on
plot(1:n, D, 'DisplayName',"Type 3");

imat = 4;
[A, D, ~] = matgen_csad(imat,n);
save(['A_' num2str(n) '_' num2str(imat)], 'A', 'D', 'imat', 'n');
hold on
plot(1:n, D, 'DisplayName',"Type 4");

xlabel('Numéro de valeur propre');
ylabel('Valeur propre associée');
title('Valeurs propres triées par ordre décroissant en fonction du type de matrice (n = 200)');
hold off;
legend show