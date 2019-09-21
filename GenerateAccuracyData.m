%% Main Code
% After building the data file (RAW2MAT.m), run this method. MAT2CSV() will
% be called to generate training and testing data. Next, rf.py will be
% called to run the train-test cycle. Predicted and actual outputs will be
% compared and results will be saved to Output/

% Note: Python and sklearn needs to be setup separately. Installing
% Anaconda (https://www.anaconda.com/) is recommended.

%% Define window data
cf_tspr_ = [645 540]; %NR, BP
cf_lspr1_ = [750 760];
cf_lspr2_ = [825 825];
w_ln_tspr_ = 25;     % window length around tspr_cf
w_ln_lspr_ = 25;     % window length around lspr_cf
w_sz_tspr_ = 11;     % samples around tspr_cf
w_sz_lspr_ = 11;     % samples around lspr_cf

% Data will be saved to and read from CSV
if ~exist('CSV', 'file')
            mkdir('CSV') 
end

%% Train and Predict cycles
out_table = [];
for centre_freq = [0]
    cf_tspr = cf_tspr_ - centre_freq;
    cf_lspr1 = cf_lspr1_ - centre_freq;
    cf_lspr2 = cf_lspr2_ -centre_freq;
    for window_len = [-10 0 10]
        w_ln_tspr = w_ln_tspr_ + window_len;
        w_ln_lspr = w_ln_lspr_ + window_len;
        for sample_sz = [-6 -4 -2 0 2 4 6]
            w_sz_tspr = w_sz_tspr_ + sample_sz;
            w_sz_lspr = w_sz_lspr_ + sample_sz;
            for portion  = [0.65 0.75 0.85 0.95]
                % Generate Train and Test data
                MAT2CSV(cf_tspr,cf_lspr1,cf_lspr2,w_ln_tspr,w_ln_lspr,w_sz_tspr,w_sz_lspr,portion)
                % Run the python script for training and predicting
                system('python rf.py');
                % Compare the test portion with predicted output
                for i = [1 2 3 4 6]
                    out = readtable(['CSV/' num2str(i) '_out.csv']);
                    pred = readtable(['CSV/' num2str(i) '_PRED.csv']);
                    ftable = [pred out];
                    foldnm = ['Output/cfT' num2str(cf_tspr) '/wln' num2str(w_ln_tspr) '/wsz' num2str(w_sz_tspr) '/prt' num2str(portion)];
                    mkdir(foldnm)
                    writetable(ftable,[foldnm '/' num2str(i) '_result.csv']);  
                    % Find the prediction error
                    [SMAPE, MAbsErr] = findMAbsErr(ftable);
                    out_table = [out_table; [cf_tspr cf_lspr1 cf_lspr2 w_ln_tspr w_ln_lspr w_sz_tspr w_sz_lspr portion i MAbsErr SMAPE]];
                end
            end
        end
    end
end

% This function computes the prediction error
function [SMAPE, MAbsErr] = findMAbsErr(ftable)

SMAPE = 1/numel(ftable.T)*[sum(abs(ftable.R_RF - ftable.T))/sum(ftable.R_RF + ftable.T) sum(abs(ftable.R_GB - ftable.T))/sum(ftable.R_GB + ftable.T) sum(abs(ftable.R_AB - ftable.T))/sum(ftable.R_AB + ftable.T)];
MAbsErr = [mean(abs(ftable.R_RF - ftable.T)) mean(abs(ftable.R_GB - ftable.T)) mean(abs(ftable.R_AB - ftable.T))];
end
