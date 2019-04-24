function [P_cc,p_query] = BR_Nilsson_method_all(KB,query)
% BR_Nilsson_method - Nilsson's probabilistic logic method (max value)
% On input:
%     KB (KB struct): KB clauses
%     query (KB struct): query
% On output:
%     P_cc (kx1 vector): model probabilities
%     p_query (float): probability of query
% Call:
%     KB(1).clauses = [1];
%     KB(1).prob = 0.7;
%     KB(2).clauses = [-1,2];
%     KB(2).prob = 0.7;
%     query.clauses = [2];
%     query.prob = 0;
%     [P,pt] = BR_Nilsson_method(KB,query);
% Author:
%     T. Henderson
%     UU
%     Summer 2018
%

p_query = 0;

num_sentences = length(KB);
vars = BR_vars(KB,query);
num_vars = length(vars);
num_cc = 2^num_vars;
query_sat = zeros(1,num_cc);
V = zeros(num_sentences+1,num_cc);
P_s = zeros(num_sentences+1,1);
V(end,:) = ones(1,num_cc);
P_s(end) = 1;

for s = 1:num_sentences
    P_s(s) = KB(s).prob;
    for cc = 0:num_cc-1
        bits = BR_int2bits(cc,num_vars);
        V(s,cc+1) = BR_sat(KB(s).clauses,bits);
        query_sat(cc+1) = BR_sat(query.clauses,bits);
    end
end

%P_cc = V\P_s;
P_cc = lsqlin(V,P_s,[],[],[],[],zeros(num_cc,1),ones(num_cc,1));
p_query = query_sat*P_cc;

%--------------------------------------------------------------------
function v_bits = BR_int2bits(v,n)
% BR_int2bits - convert an integer to an n-bit binary number
% On input:
%     v (int): integer value
%     n (int): number of bits
% On output:
%     v_bits (1xn vector): binary representation of v
% Call:
%     v = BR_int2bits(5,3);
% Author:
%     T. Henderson
%     UU
%     Fall 2014
%

v_bits = zeros(1,n);

for b = 1:n
    v_bits(b) = rem(v,2);
    v = floor(v/2);
end

v_bits = v_bits(end:-1:1);

%--------------------------------------------------------------------
function b = BR_sat(sentence,bits)
% BR_sat - check if bits satisfy the sentence
% On input:
%     sentence (1xk vector): disjunction of k literals
%     bits (1xn vector): n truth assignments to logical variables
% On output:
%     b (Boolean): 1 if bits satisfy sentence; else 0
% Call:
%     b = BR_sat([1,-2],[0,1]);
% Author:
%     T. Henderson
%     UU
%     Summer 2018
%

b = 0;

len_sentence = length(sentence);
for e = 1:len_sentence
    if sentence(e)>0==bits(abs(sentence(e)))
        b = 1;
        return
    end
end

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
