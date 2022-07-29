
k=dec2bin(0,32);
I=25;
J=32;

for H = 1 : 32
    k(H)='0';
end

k(33-25)='1'
k(33-26)='1'


% for H = I : J 
%     HS=33-H;
%      k(HS)='1';
% end

dec2hex(bin2dec(k),8)
