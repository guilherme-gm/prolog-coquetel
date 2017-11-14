%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resolvendo Problema de Lógica em Prolog   %
%   Exercicio: Graça e Habilidade           %
%                                           %
% Grupo:                                    %
%   - Guilherme Guiguer Menaldo             %
%   - Jhenifer Marques dos Santos           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gera(p(Patinadora, Movimentos, Cor, Classificacao)) :-
%     member(Patinadora, [aline, ariane, beatriz, gisele, lana]),
%     member(Movimentos, [4, 5, 6, 7, 8]),
%     member(Cor, [azul, dourado, vermelho, verde, violeta]),
%     member(Classificacao, [1, 2, 3, 4, 5]).

% ---- Geradores
gera_pat(p(P, _, _, _), [P], []) :- !.
gera_pat(p(P, _, _, _), Patinadoras, Resto) :-
select(P, Patinadoras, Resto).

gera_mov(p(_, M, _, _), [M], []) :- !.
gera_mov(p(_, M, _, _), Movimentos, Resto) :-
    select(M, Movimentos, Resto).

gera_cor(p(_, _, C, _), [C], []) :- !.
gera_cor(p(_, _, C, _), Cores, Resto) :-
    select(C, Cores, Resto).

gera_class(p(_, _, _, C), [C], []) :- !.
gera_class(p(_, _, _, C), Classificacoes, Resto) :-
    select(C, Classificacoes, Resto).

gera_pessoa(P, atr(P1, Mv1, Cr1, Cl1), atr(P2, Mv2, Cr2, Cl2)) :-
    gera_pat(P, P1, P2), gera_mov(P, Mv1, Mv2),
    gera_cor(P, Cr1, Cr2), gera_class(P, Cl1, Cl2).

gera_pessoas([], _) :- !.
gera_pessoas([C|Cs], Atribs) :-
    gera_pessoa(C, Atribs, Atribs2), gera_pessoas(Cs, Atribs2).

gera_solucao([P1, P2, P3, P4, P5]) :-
    Patinadoras = [aline, ariane, beatriz, gisele, lana],
    Movimentos = [4, 5, 6, 7, 8],
    Cores = [azul, dourado, vermelho, verde, violeta],
    Classificacoes =[1, 2, 3, 4, 5],
    gera_pessoas([P1, P2, P3, P4, P5], atr(Patinadoras, Movimentos, Cores, Classificacoes)).

%% ---- Predicados
%% mov_mais(P1, P2, N, S)
% true se a pessoa P1 fez N movimentos a mais que P2
mov_mais(p(N1, M1, Cr1, Cl1), p(N2, M2, Cr2, Cl2), N, S) :-
    member(p(N1, M1, Cr1, Cl1), S),
    member(p(N2, M2, Cr2, Cl2), S),
    M1 is M2 + N.

%% mov_menos(P1, P2, N, S)
% true se a pessoa P1 fez N movimentos a menos que P2
mov_menos(p(N1, M1, Cr1, Cl1), p(N2, M2, Cr2, Cl2), N, S) :-
    member(p(N1, M1, Cr1, Cl1), S),
    member(p(N2, M2, Cr2, Cl2), S),
    M1 is M2 - N.

%% nao_mov(P1, N, S)
% true se a pessoa P1 não fez N movimentos
nao_mov(p(No, Mo, Cr, Cl), N, S) :-
    member(p(No, Mo, Cr, Cl), S),
    Mo \= N.

%% atras_de(P1, P2, N, S)
% true se a pessoa P1 está N posições atrás de P2
atras_de(p(N1, M1, Cr1, Cl1), p(N2, M2, Cr2, Cl2), N, S) :-
    member(p(N1, M1, Cr1, Cl1), S),
    member(p(N2, M2, Cr2, Cl2), S),
    Cl1 is Cl2 + N.

%% nao_pos(P1, N, S)
% true se a pessoa P1 não está na posição N
nao_pos(p(No, M, Cr, Cl), N, S) :-
    member(p(No, M, Cr, Cl), S),
    Cl \= N.

%% entre_pos(P1, Min, Max S)
% true se a pessoa P1 está entre as posições Min e Max
entre_pos(p(No, M, Cr, Cl), Min, Max, S) :-
    member(p(No, M, Cr, Cl), S),
    Cl >= Min,
    Cl =< Max.

%% ---- Principal
solucao(S) :-
    S=[P1,P2,P3,P4,P5],
    P1 = p(_, _, _, 1),
    P2 = p(_, _, _, 2),
    P3 = p(_, _, _, 3),
    P4 = p(_, _, _, 4),
    P5 = p(_, _, _, 5),
    % Implicações que não dependem de aritmética, otimizam o processo
    %   Por alguma razão a regra nao_mov faz com que nenhum resultado seja encontrado,
    %   removendo-a, temos apenas 1 resultado que também a respeita.
    %nao_mov(p(gisele, _, _, _), 7, S),
    nao_pos(p(_, _,dourado, _), 4, S),
    entre_pos(p(aline, _, _, _), 1, 3, S),
    gera_solucao(S),
    mov_mais(p(gisele, _,_ ,_), p(_, _, _, 5), 1, S),
    mov_mais(p(_, _, _, 5), p(_, _, azul, _), 1, S),
    atras_de(p(ariane, _, _, _), p(_, _, violeta, _), 3, S),
    atras_de(p(_, _,dourado,_), p(_, _, verde, _), 1, S),
    atras_de(p(_, _, verde, _), p(beatriz, _, _, _), 1, S),
    mov_menos(p(aline, _, _, _), p(_, _, _, 1), 1, S),
    mov_menos(p(_,_,_,1),  p(_,_,_,5), 2, S),
    mov_mais(p(beatriz, _, _, _), p(_, _, violeta, _), 2, S),
    mov_menos(p(beatriz, _, _, _), p(ariane, _, _, _), 1, S).
