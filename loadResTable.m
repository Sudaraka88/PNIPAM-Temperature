%% Output - 1
% Output must be generated before running this file.
% This method loads the data from the Output folder based on the data
% specified
np_type = 'BP'; % 'NR', 'BP', 'COMBO'
n_trees = '5000'; % '150', '500', '1500', '2500', '5000'
wln = 25;   % 15, 25, 35
wsz = 17;    % 5:2:17
prt = 0.75; % 0.65:0.1:0.95
tbrac = 1;  % 1:4 6
tb_res = [];

T_data = readtable(getPath(n_trees,np_type,wln,wsz,prt,tbrac));
T_data = sortrows(T_data,find(strcmpi(T_data.Properties.VariableNames,'T')));

[X,Y] = drawboxes(T_data);

% Plot the Predictions vs. Expected values
figure
hold on
plot(T_data.R_RF,'b*','MarkerSize',5)
plot(T_data.R_GB,'k*','MarkerSize',5)
plot(T_data.R_AB,'m*','MarkerSize',5)

for i = 1:numel(X)/4
    h = fill(X(i,:),Y(i,:),'r');
    set(h,'facealpha',0.2);
end
legend('RF','GB','AB','Location','NorthWest')
title([np_type n_trees])
axis([0 inf 0.5 numel(X)/4 + 0.5])
grid on 
grid minor

hold off

% Replace '/' with '\' for Windows
function path = getPath(n_trees,np_type,wln,wsz,prt,tbrac)
path = ['Output/n' n_trees '/' np_type '/cfT645  540/wln' num2str(wln) '/wsz' num2str(wsz) '/prt' num2str(prt) '/' num2str(tbrac) '_result.csv'];
end

function [X,Y] = drawboxes(T_data)
box_count = numel(unique(T_data.T));
X = zeros(box_count,4);
Y = X;
for i = 1:box_count
    h1 = i - 0.5;
    h2 = i + 0.5;
    p_len = numel(find(T_data.T<i));
    len = numel(find(T_data.T==i));
    X(i,:) = [p_len p_len+len p_len+len p_len];
    Y(i,:) = [h1 h1 h2 h2];
end

end

