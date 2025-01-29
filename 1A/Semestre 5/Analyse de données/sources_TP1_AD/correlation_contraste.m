% function correlation_contraste (pour exercice_1.m)

function [correlation,contraste] = correlation_contraste(X)

meanX = mean(X);
X_centree = X - repmat(meanX, size(X,1), 1);
sigma = (X_centree'*X_centree)/size(X,1);

r_rv = sigma(1, 2) / sqrt(sigma(1,1)*sigma(2,2));
r_rb = sigma(1, 3) / sqrt(sigma(1,1)*sigma(3,3));
r_vb = sigma(2, 3) / sqrt(sigma(2,2)*sigma(3,3));
correlation = [r_rv r_rb r_vb]';

c_r = sigma(1,1) / (sigma(1,1)+sigma(2,2)+sigma(3,3));
c_v = sigma(2,2) / (sigma(1,1)+sigma(2,2)+sigma(3,3));
c_b = sigma(3,3) / (sigma(1,1)+sigma(2,2)+sigma(3,3));
contraste = [c_r c_v c_b]';
    
end
