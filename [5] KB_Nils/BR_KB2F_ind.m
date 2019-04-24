function BR_KB2F_ind(KB,fname)
% BR_KB2F_ind - convert KB to .m function file
% On input:
%     KB (KB struct): CNF KB
%     fname (string): root name of file
% On output:
%     N/A - side effect is creation of 2 files:
%       fname.m: has vector function for sentence probabilities
%       fnames.m: scalar output function (norm(F) from fname.m)
% Call:
%     BR_KB2F_ind(KB,'IJ');
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

num_clauses = length(KB);

% fsolve function (vector output)
file_name = [fname,'.m'];

fd = fopen(file_name,'w');

fprintf(fd,'function F = %s(x)\n',fname);
fprintf(fd,'%%\n\n');

for c = 1:num_clauses
    F = BR_sentence2formula(KB(c).clauses,KB(c).prob);
    F = ['F(',num2str(c),') = ',F];
    fprintf(fd,'%s;\n',F);
end
fclose(fd);

% fmincon function (scalar - error output)
file_name = [fname,'s.m'];

fd = fopen(file_name,'w');

fprintf(fd,'function err = %s(x)\n',[fname,'s']);
fprintf(fd,'%%\n\n');

for c = 1:num_clauses
    F = BR_sentence2formula(KB(c).clauses,KB(c).prob);
    F = ['F(',num2str(c),') = ',F];
    fprintf(fd,'%s;\n',F);
end
fprintf(fd,'err = norm(F);\n');
fclose(fd);

%---------------------------------------------------------------------
function F = BR_sentence2formula(s,p)
% BR_sentence2formula - convert logical sentence to nonlinear equation
% On input:
%     s (1xk vector): disjunctive clause
%     p (float): probability s
% On output:
%     F (string): equation for s with probability p
% Call:
%     Fs = BR_sentence2formula([-1,2],0.7);
% Author:
%     T. Henderson
%     UU
%     Spring 2017
%

len_s = length(s);
F = ['-',num2str(p),'+'];

for k = 1:len_s
    combos = nchoosek([1:len_s],k);
    num_combos = length(combos(:,1));
    if rem(k,2)==0
        c_sign = '-';
    else
        c_sign = '+';
    end
    for c = 1:num_combos
        if ~(c==1&k==1)
            F = [F,c_sign];
        end
        for m = 1:k
            atom = s(abs(combos(c,m)));
            if atom>0
                term = ['x(',int2str(abs(atom)),')'];
            else
                term = ['(1-x(',int2str(abs(atom)),'))'];
            end
            F = [F,term];
            if m<k
                F = [F,'*'];
            end
        end
    end
end
