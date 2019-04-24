function [x,e,xt,et] = BR_KB_Jacobian2(KB,KBF,alpha,tol,max_iter,x0)
% BR_KB_Jacobian - gradient descent to solve PSAT

n = length(x0);
done = 0;
iter = 0;
x = x0;
xt = x0';
vt = feval(KBF,x0);
et = norm(vt);
e = et(end);
wb = waitbar(0,'Jacobian');
while done==0
    waitbar(iter/max_iter);
    iter = iter + 1;
    J = zeros(n,1);
    for d = 1:n
        xm = x;
        xm(d) = x(d) - alpha;
        vm = norm(feval(KBF,xm));
        xp = x;
        xp(d) = x(d) + alpha;
        vp = norm(feval(KBF,xp));
        J(d) = vm - vp;
    end
    if e>tol&norm(J)==0
        J = 0.5 - rand(n,1);
    end
    J = J/norm(J);
    x = abs(x + alpha*J);
    x = max(0,min(x,1));
    xt = [xt; x'];
    et = [et;norm(feval(KBF,x))];
    e = et(end);
    if et(end)<tol||(iter==max_iter)
        done = 1;
    end
end
close(wb);
e = et(end);
