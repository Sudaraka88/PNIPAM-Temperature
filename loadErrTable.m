%% Output - 2 
% Output must be generated before running this file.
% This method loads the data from the Output folder based on the data
% specified

np_type = 'BP'; % 'NR', 'BP', 'COMBO'
n_trees = '500'; % '150', '500', '1500', '2500', '5000'

% wln = 25;   % 15, 25, 35
% wsz = 15;    % 5:2:17
prt = 0.75; % 0.65:0.1:0.95
tbrac = 1;  % 1:4 6
tb_err = [];
for wln = [15 25 35]
    for wsz = 5:2:17
        [SMAPE, MAbsErr] = getErrors(getPath(n_trees,np_type,wln,wsz,prt,tbrac));
        tb_err = [tb_err; cell2table({np_type,wln,wsz,prt,tbrac,SMAPE,MAbsErr})];
    end
end
tb_err.Properties.VariableNames = {'np_type','wln','wsz','prt','tbrac','SMAPE','MAbsErr'};

% Call the op_WLNvWSZ method to generate the plot based on workspace data.
op_WLNvWSZ

function path = getPath(n_trees,np_type,wln,wsz,prt,tbrac)
path = ['Output/n' n_trees '/' np_type '/cfT645  540/wln' num2str(wln) '/wsz' num2str(wsz) '/prt' num2str(prt) '/' num2str(tbrac) '_result.csv'];
end

function [SMAPE, MAbsErr] = getErrors(path)
ftable = readtable(path);
SMAPE = 1/numel(ftable.T)*[sum(abs(ftable.R_RF - ftable.T))/sum(ftable.R_RF + ftable.T) sum(abs(ftable.R_GB - ftable.T))/sum(ftable.R_GB + ftable.T) sum(abs(ftable.R_AB - ftable.T))/sum(ftable.R_AB + ftable.T)];
MAbsErr = [mean(abs(ftable.R_RF - ftable.T)) mean(abs(ftable.R_GB - ftable.T)) mean(abs(ftable.R_AB - ftable.T))];
end