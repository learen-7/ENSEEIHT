function bits = octetToBit(Octets)
    bits=zeros(1,length(Octets)*8);
    for i=1:8
       bits(i:8:end)=floor((Octets-bitToOctet(bits))/2^(8-i));
    end
end