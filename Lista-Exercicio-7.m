lambda = 0.5;
T = 10; 
function a = poissonarrivals(lambda, T) 
    pkg load statistics
    n = ceil(1.1 * lambda * T);
    a = cumsum(exprnd(1/lambda, 1, n));
    while (a(end) < T)
        a_new = a(end) + cumsum(exprnd(1/lambda, 1, n));
        a = [a, a_new];
    end
    a = a(a <= T);
end

arrivals = poissonarrivals(lambda, T);
disp(arrivals);

