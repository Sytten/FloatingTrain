% %% 8pts aller
% dt8 = tt/(length(NAB)-1);
% aller8pts_t = [NAB; zeros(1,length(NAB))];
% for i = 1:length(NAB)
%     aller8pts_t(3,i) = dt8*(i-1);
% end
% csvwrite('trajectoireofficielle/aller8pts.csv',aller8pts_t);
% %% 8 pts retour
% dt8 = tt/(length(NBA)-1);
% retour8pts_t = [NBA; zeros(1,length(NBA))];
% for i = 1:length(NAB)
%     retour8pts_t(3,i) = dt8*(i-1);
% end
% csvwrite('trajectoireofficielle/retour8pts.csv',retour8pts_t);
%% npts aller
dtn = tt/(length(O)-1);
aller_n_pts_t = [O(1:2,:); zeros(1,length(O))];
for i = 1:length(O)
    aller_n_pts_t(3,i) = dtn*(i-1);
end
csvwrite('trajectoireofficielle/aller_interpole.csv',aller_n_pts_t);
%% npts retour
dt8 = tt/(length(O1)-1);
retour_n_pts_t = [O1(1:2,:); zeros(1,length(O1))];
for i = 1:length(O1)
    retour_n_pts_t(3,i) = dtn*(i-1);
end
csvwrite('trajectoireofficielle/retour_interpole.csv',retour_n_pts_t);
