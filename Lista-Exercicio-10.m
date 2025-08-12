aux = 0.1;
n = 1000;

dt = 0.01;
W = zeros(n, 1);
dW = sqrt(dt) * randn(n, 1);
for i = 2:n
    W(i) = W(i-1) + aux * dW(i);
end

plot(0:dt:(n*dt-dt), W);
xlabel('Tempo: ');
ylabel('Valor: ');
title('Com A');
