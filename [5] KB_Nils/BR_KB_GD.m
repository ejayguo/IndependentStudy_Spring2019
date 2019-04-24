function [x,e,xt,et] = BR_KB_GD(KB,KBF,alpha,tol,max_iter,x0)
% BR_KB_Jacobian - gradient descent to solve PSAT
% On input:
%     KB (KB struct): CNF KB
%     KBF (string): name of error function
%     alpha (float): step size in gradient direction
%     tol (float): quitting tolerance
%     max_iter (int): maximum number of steps to take
%     x0 (kx1 vector): initial starting value
%       * for independent variable, k is n (number of atoms)
%       * if not, k is number of rows in vtable from BR_KB2F_gen call
% On output:
%     x (kx1 vector): final gradient descent vector
%     e (float): sentence probability error
%     xt (mxk array): trace of x values during descent
%     et (mx1 vector): trace of sentence error values
% Call:
%     % indepenent variables example
%     KB(1).clauses = [1];
%     KB(1).prob = 0.7;
%     KB(2).clauses = [-1,2];
%     KB(2).prob = 0.7;
%     BR_KB2F_ind(KB,'KB');
%     [x,e,xt,et] = BR_KB_GD(KB,KBF,0.001,0.01,10000,0.5*ones(2,1));
%     % indepenent variables example
%     KB(1).clauses = [1];
%     KB(1).prob = 0.7;
%     KB(2).clauses = [-1,2];
%     KB(2).prob = 0.7;
%     [vt,F] = BR_KB2F_gen(KB,'KB');
%     v_len = length(vt(:,1));
%     [x,e,xt,et] = BR_KB_GD(KB,KBF,0.001,0.01,10000,0.5*ones(v_len,1));
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

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
