% function noircir_pixels_blancs (pour exercice_3.m)

function I_sans_blanc = noircir_pixels_blancs(I)

I_sans_blanc = I;
I_sans_blanc(I_sans_blanc == 255) = 0; 

    
end
