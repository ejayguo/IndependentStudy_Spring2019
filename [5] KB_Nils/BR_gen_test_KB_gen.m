function [KB,cc_probs] = BR_gen_test_KB_gen(n,max_sentences,...
    max_sentence_len)
% BR_gen_test_KB_gen - create a random KB with correct probabilities
% On input:
%     n (int): number of atoms
%     max_sentences (int): maximum number of sentences
%     max_sentence_length (int): maximum length of any sentence
% On output:
%     KB (KB data structure): KB
%     cc_probs (1x2^n vector): complete conjunction probabilities
% Call:
%     [KB2,cc_probs2] = BR_gen_test_KB_gen(3,6,3);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

MAX_FAILS = 100;

m = randi(max_sentences);
cc_probs = [];
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
    if isempty(KB)|(B1*B2==1)|(max(BR_vars(KB,[]))<n)
        count = count + 1;
%        ['Failed: ',num2str(count)]
        OK = 0;
    end
end
%display('Success');
num_cc = 2^n;
cc_probs = rand(1,num_cc);
cc_probs = cc_probs/sum(cc_probs);
for s = 1:num_sentences
    KB(s).prob = BR_cc2clauseprob(KB(s).clauses,cc_probs);
end

%--------------------------------------------------------------------
function p = BR_cc2clauseprob(clause,cc_probs)
% BR_cc2clauseprob - compute clause probability from cc probs
% On input:
%     clause (1xk vector): disjunctive clause
%     cc_probs (1x2^n vector): cc probabilities
% On output:
%     p (float): probability of clause
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

p = 0;

len_clause = length(clause);
clause_sign = zeros(1,len_clause);
for d = 1:len_clause
    clause_sign(d) = clause(d)>0;
end
num_cc = length(cc_probs);
n = log2(num_cc);
indexes = sort(abs(clause));

for b = 0:num_cc-1
    bits = BR_int2bits(b,n);
    cc_sign = bits(indexes);
    if max(cc_sign==clause_sign)==1
        p = p + cc_probs(b+1);
    end
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

