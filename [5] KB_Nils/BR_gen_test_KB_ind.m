function [KB,cc_probs,ap] = BR_gen_test_KB_ind(n,max_sentences,...
    max_sentence_len)
% BR_gen_test_KB_ind - create a random KB with correct probabilities
%   where variables are independent
% On input:
%     n (int): number of atoms
%     max_sentences (int): maximum number of sentences
%     max_sentence_length (int): maximum length of any sentence
% On output:
%     KB (KB data structure): KB
%     cc_probs (1x2^n vector): complete conjunction probabilities
%     ap (1xn vector): atom probabilities
% Call:
%     [KB2,cc_probs2] = BR_gen_test_KB_ind(3,6,3);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

MAX_FAILS = 100;

KB = [];
cc_probs = [];
ap = [];

m = randi(max_sentences);
max_sentence_len = min(n,max_sentence_len);
OK = 0;
count = 0;
thm1(1).clauses = [1];
thm2(1).clauses = [-1];
while OK==0
    OK = 1;
    KB = [];
    num_sentences = 0;
    while num_sentences<m
        clause_length = randi(max_sentence_len);
        clause = randperm(n);
        clause = clause(1:clause_length);
        lit_sign = rand(1,clause_length)<0.5;
        lit_sign = 3.^lit_sign - 2;
        clause = clause.*lit_sign;
        clause = sort(unique(clause));
        KB = BR_KB_insert_clause(KB,clause);
        num_sentences = length(KB);
    end
    B1 = CS4300_Ask(KB,thm1);
    B2 = CS4300_Ask(KB,thm2);
    if ~isempty(KB)&(B1*B2==1)
        count = count + 1;
        if count>MAX_FAILS
            return
        end
        OK = 0;
    end
end

ap = rand(1,n);
cc_probs = BR_ap2ccp(ap);
for s = 1:num_sentences
    KB(s).prob = BR_prob_or_atom_probs(KB(s).clauses,ap);
end

%--------------------------------------------------------------------
function KB_out = BR_KB_insert_clause(KB,clause)
% BR_KB_insert_clause - insert a new clause into KB
% On input:
%     KB (KB data structure): knowledge base of disjunctions
%     clause (1xn vector): clause of literals
% On output:
%     KB_out (KB data structure): KB with new clause
% Call:
%     KB1 = BR_KB_insert_clause(KB,[2]);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

KB_out = KB;

num_clauses = length(KB);
clause = sort(unique(clause));
len_clause = length(clause);
for s = 1:num_clauses
    KB_clause = KB(s).clauses;
    if (length(KB_clause)==len_clause)&(min(KB_clause==clause)==1)
        return
    end
end
num_clauses = num_clauses + 1;
KB_out(num_clauses).clauses = clause;
KB_out(num_clauses).prob = 0;

%--------------------------------------------------------------------
function b = CS4300_Ask(KB,sentence)
% CS4300_Ask - Ask function for logic KB
% On input:
%     KB (KB struct): Knowledge base (CNF)
%       (k).clauses (1xp vector): disjunction clause
%     sentence (KB struct): query theorem (CNF)
%       (k).clauses (1xq vector): disjunction
% On output:
%     b (Boolean): 1 if KB entails sentence, else 0
% Call:
%     KB(1).clauses = [1];
%     KB(2).clauses = [-1,2];
%     sentence(1).clauses = [2];
%     b = CS4300_Ask(KB,sentence);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

b = 0;

if isempty(sentence)
    return
end

vars = CS4300_vars(KB,sentence);
num_sentences = length(KB);
len_sentence = length(sentence);
for s = 1:len_sentence
    KB(num_sentences+1).clauses = -sentence(s).clauses;
    CS4300_create_SAT_prob(KB,'HYBKB');
    system('sat.py < HYBKB >popo');
    fd = fopen('popo','r');
    t = fscanf(fd,'%s');
    if ~isempty(t)
        return
    end
    clear t
    fclose(fd);
end

b = 1;

%--------------------------------------------------------------------
function CS4300_create_SAT_prob(KB,fn)
% CS4300_create_SAT_prob - setup file to call Python SAT solver
% On input:
%     KB (KB data struct): CNF KB
%     fn (string): filename for SAT problem
% On output:
%   N/A (writes a file with name fn)
% Call:
%     CS4300_create_SAT_prob(KB,'HYBKB');
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

MINUS = '~';
BLANK = ' ';
x = 'x';

fd = fopen(fn,'w');
num_clauses = length(KB);

for c = 1:num_clauses
    clause = KB(c).clauses;
    len_clause = length(clause);
    for d = 1:len_clause
        if clause(d)<0
            fprintf(fd,'%s',MINUS);
        end
        fprintf(fd,'%s',x);
        fprintf(fd,'%d',abs(clause(d)));
        fprintf(fd,'%s',BLANK);
    end
    fprintf(fd,'\n');
end
fclose(fd);

%--------------------------------------------------------------------
function vars = CS4300_vars(KB,sentence)
% CS4300_vars - determine variable set of KB
% On input:
%     KB (KB struct): CNF KB
%     sentence (1xk vector): disjunction
% On output:
%     vars (1xn vector): atom variable values
% Call:
%     v = CS4300_vars(KB,[1]);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

vars = [];

for s = 1:length(KB)
    vars = unique([vars,abs(KB(s).clauses)]);
end
for s = 1:length(sentence)
    vars = unique([vars,abs(sentence(s).clauses)]);
end
vars = sort(vars);

%--------------------------------------------------------------------
function prob = BR_prob_or_atom_probs(clause,A_probs)
% BR_prob_or_atom_probs -= compute probability of or clause from atom probs
% On input:
%     clause (1xk vector): disjunction of literals
%     A_probs (1xn vector): atom probabilities
% On output:
%     prob (float): probability of clause
% Call:
%     p = BR_prob_or_atom_probs(clause,A_probs);
% Author:
%     T. Henderson
%     UU
%     Spring 2017
%

prob = 0;
if isempty(clause)
    return
end
len_clause = length(clause);
if len_clause==1
    if clause(1)<0
        prob = 1 - A_probs(abs(clause(1)));
    else
        prob = A_probs(abs(clause(1)));
    end
    return
end
L_probs = A_probs;
for e = 1:len_clause
    if clause(e)<0
        L_probs(abs(clause(e))) = 1 - A_probs(abs(clause(e)));
    end
end
p1 = L_probs(abs(clause(1)));
p2 = BR_prob_or(clause(2:end),L_probs);
prob = p1 + p2 - p1*p2;

%--------------------------------------------------------------------
function prob = BR_prob_or(clause,L_probs)
% BR_prob_or - compute probability of or clause
% On input:
%     clause (1xk vector): disjuction of literals
%     L_probs (1xn vector): probabilities of literals
% On output:
%     prob (float): probability of disjunction
% Call:
%     p = BR_prob_or(clause,L_probs);
% Author:
%     T. Henderson
%     UU
%     Spring 2017
%

prob = 0;
if isempty(clause)
    return
end
len_clause = length(clause);
if len_clause==1
    prob = L_probs(abs(clause(1)));
    return
end
p1 = L_probs(abs(clause(1)));
p2 = BR_prob_or(clause(2:end),L_probs);
prob = p1 + p2 - p1*p2;

%--------------------------------------------------------------------
function cc_probs = BR_ap2ccp(ap)
% BR_ap2ccp - compute complete conjunction probs from atom probs
% On input:
%     ap (1xn vector): atom probabilities
% On output:
%     cc_probs (1x2^n vector): complete conjunction probabilities
% Call:
%     cc = BR_ap2ccp(ap);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

n = length(ap);
num_cc = 2^n;
cc_probs = zeros(1,num_cc);

for w = 0:num_cc-1
    bits = BR_int2bits(w,n);
    p = 1;
    for e = 1:n
        if bits(e)==0
            p = p*(1-ap(e));
        else
            p = p*ap(e);
        end
    end
    cc_probs(w+1) = p;
end

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
