% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-10
% Description du programme : Asservissement global

% Initialisations 

run('SM_4.m')
flag_graph = 0;         % 0 on ne montre pas les graphiques

%% SA-8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('SA_8.m')

%% SA-9 cas 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('SA_9.m')

%% SA-9 cas 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run('SA_9cas2.m')

%% SA-10 angle theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run('SA_10.m')

%% SA-10 angle phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run('SA_10y.m')

