
lambda = 10; 
mu = 1/10; 
T = 60; 
t_interval = 0:1:T; 
function M = simswitch(lambda, mu, t)
    s = poissonarrivals(lambda, max(t));
    y = s + exprnd(1/mu, size(s));
    A = histc(s, t);
    D = histc(y, t);
    M = A - D;
end
M = simswitch(lambda, mu, t_interval);
plot(t_interval, M);
xlabel('Tempo em min: ');
ylabel('Chamadas: ');
title('Simulação de atividades telefônicas ');
