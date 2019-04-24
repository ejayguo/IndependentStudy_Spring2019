function [vtable,F] = BR_KB2F_gen(KB,fname)
% BR_KB2F_gen - produce error function for gradient descent
% On input:
%     KB (KB struct): CNF KB
%     fname (string): name of error function
% On output:
%     vtable (kxw array): variable table; identifies conditional variables
%     F (string): text of error function
% Call:
%     [vt,F] = BR_KB2F_gen(KB,'MP');
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

vtable = [];

len_vtable = 0;
n = length(BR_vars(KB,[]));
num_x = n;
len_KB = length(KB);

if len_KB==0
    return
end

fd = fopen([fname,'.m'],'w');
fprintf(fd,'function F = %s(x)\n',fname);
fprintf(fd,'%%\n\n');

for c = 1:len_KB
    clause = KB(c).clauses;
    p = KB(c).prob;
    switch length(clause)
        case 1  % [L1]
            L1 = clause(1);
            if L1<1
                F(c).f = ['F(',num2str(c),') = -',num2str(p),...
                    ' + (1-x(',num2str(abs(L1)),'));'];
            else
                F(c).f = ['F(',num2str(c),') = -',num2str(p),...
                    ' + (x(',num2str(abs(L1)),'));'];
            end
        case 2  % [L1,L2]
            L1 = clause(1);
            L2 = clause(2);
            bit1 = (L1>0);
            bit2 = (L2>0);
            parity_index2 = bit1*2 + bit2;
            len_vtable = len_vtable + 1;
            vtable(len_vtable,1) = L1;
            vtable(len_vtable,2) = L2;
            vtable(len_vtable,3) = 0;
            vtable(len_vtable,4) = c;
            vtable(len_vtable,5) = parity_index2;
            indexes = find((abs(vtable(1:len_vtable-1,1))==abs(L1))...
                & (abs(vtable(1:len_vtable-1,2))==abs(L2))...
                &vtable(1:len_vtable-1,3)==0);
            if isempty(indexes)
                num_x = num_x + 1;
                c_index = num_x;
            else
                c_index = vtable(indexes(1),6);
            end
            vtable(len_vtable,6) = c_index;
            if L1<1
                s1 = ['(1-x(',num2str(abs(L1)),'))'];
            else
                s1 = ['x(',num2str(abs(L1)),')'];
            end
            if L2<1
                s2 = ['(1-x(',num2str(abs(L2)),'))'];
            else
                s2 = ['x(',num2str(abs(L2)),')'];
            end
            F(c).f = ['F(',num2str(c),') = -',num2str(p),...
                ' + ',s1,' + ',s2,' - x(',num2str(num_x),')*',s2,';'];
        case 3  % [L1,L2,L3]
            L1 = clause(1);
            L2 = clause(2);
            L3 = clause(3);
            bit1 = (L1>0);
            bit2 = (L2>0);
            bit3 = (L3>0);
            parity_index2 = bit2*2 + bit3;
            parity_index3 = bit1*4 + bit2*2 + bit3;
            len_vtable = len_vtable + 1;
            vtable(len_vtable,1) = L2;
            vtable(len_vtable,2) = L3;
            vtable(len_vtable,3) = 0;
            vtable(len_vtable,4) = c;
            vtable(len_vtable,5) = parity_index2;
            num_x = num_x + 1;
            vtable(len_vtable,6) = num_x;
            len_vtable = len_vtable + 1;
            vtable(len_vtable,1) = L1;
            vtable(len_vtable,2) = L2;
            vtable(len_vtable,3) = L3;
            vtable(len_vtable,4) = c;
            vtable(len_vtable,5) = parity_index3;
            num_x = num_x + 1;
            vtable(len_vtable,6) = num_x;
            if L1<1
                s1 = ['(1-x(',num2str(abs(L1)),'))'];
            else
                s1 = ['x(',num2str(abs(L1)),')'];
            end
            if L2<1
                s2 = ['(1-x(',num2str(abs(L2)),'))'];
            else
                s2 = ['x(',num2str(abs(L2)),')'];
            end
            if L3<1
                s3 = ['(1-x(',num2str(abs(L3)),'))'];
            else
                s3 = ['x(',num2str(abs(L3)),')'];
            end
            F(c).f = ['F(',num2str(c),') = -',num2str(p),...
                ' + ',s1,' + ',s2,' + ',s3,' - x(',num2str(num_x-1),...
                ')*',s3,' - x(',num2str(num_x),')*',s2,...
                ' - x(',num2str(num_x),')*',s3,...
                ' + x(',num2str(num_x),')*x(',num2str(num_x-1),')*',s3,';'];
    end
end

for c = 1:len_KB
    fprintf(fd,'%s\n',F(c).f);
end
fclose(fd);

atable = zeros(n,6);
atable(:,1) = [1:n]';
atable(:,6) = [1:n]';
vtable = [atable;vtable];

%--------------------------------------------------------------------
function vars = BR_vars(KB,sentence)
% BR_vars - find list of variables in logical sentences
% On input:
%     KB (nx1 conjunctive normal form vector): conjunctive clauses
%       (i).clauses (1xm vector): disjunctive clause
%     sentence (1x1 conjunctive normal form vector): conjunctive clause
%       (1).clauses (1xk vector): disjunctive clause
% On output:
%     vars (1xp vector): list of variables in KB and sentence
% Call:
%     vars = BR_vars(KB,thm);
% Author:
%     T. Henderson
%     UU
%     Spring 2017
%

vars = [];

for s = 1:length(KB)
    vars = unique([vars,abs(KB(s).clauses)]);
end
for s = 1:length(sentence)
    vars = unique([vars,abs(sentence(s).clauses)]);
end
vars = sort(vars);

