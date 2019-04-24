function BR_test_NILS
% BR_test_NILS - test PSAT functions
% On input:
%     N/A
% On output:
%     echoes variable values after calls
% Call:
%     BR_test_NILS
% Author:
%     T. Henderson
%     UU
%     Summer 2018
%

% Set up a KB
KB(1).clauses = [1];
KB(1).prob = 0.7;
KB(2).clauses = [-1,2];
KB(2).prob = 0.7;

% Set up a query (to test Nilsson method)
query(1).clauses = [2];
query(1).prob = 0;

% Run Nilsson
% [P,pq] = BR_Nilsson_method_all(KB,query)

% Run BR_gen_test_KB_ind
[KB_ind,CC,ap] = BR_gen_test_KB_ind(3,7,3)

% Run BR_gen_test_KB_gen
[KB_gen,CC] = BR_gen_test_KB_gen(3,10,3)

% Run BR_KB2F_ind
BR_KB2F_ind(KB,'KB')

% Run BR_KB2F_gen
[vtable,F] = BR_KB2F_gen(KB,'KBg')

% Run gradient descent on ind variables
% [x,e,xt,et] = BR_KB_GD(KB,'KB',0.001,0.01,10000,0.5*ones(2,1));
% x
% e


% Run gradient descent on general variables
[x,e,xt,et] = BR_KB_GD(KB,'KB',0.001,0.01,10000,0.5*ones(3,1));
x
e

EJay = 0;

