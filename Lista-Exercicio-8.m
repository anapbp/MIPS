lambda = 5; 
T = 10; 
t_interval = 0:0.1:T; 
function a = poissonarrivals(lambda, T)
    pkg load statistics
    b = ceil(1.1 * lambda * T);
    a = cumsum(exprnd(1/lambda, 1, b));
    while (a(end) < T)
        a_new = a(end) + cumsum(exprnd(1/lambda, 1, b));
        a = [a, a_new];
    end
    a = a(a <= T);
end
function B = poissonprocess(lambda, t)
    a = poissonarrivals(lambda, max(t));
    B = histc(a, t);
end
B = poissonprocess(lambda, t_interval);
plot(t_interval, B);
xlabel('Tempo em min: ');
ylabel('Chegadas: ');
title('Processo de Poisson com \lambda = 5 chegadas/min ');
