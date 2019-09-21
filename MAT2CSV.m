%% MAT2CSV
% This function writes a set of .csv files to the CSV folder, which is then
% used by rf.py for training and predicting purposes. This function is
% called by GenerateAccuracyData.m, there is no need to call this function
% separately!

function MAT2CSV(cf_tspr,cf_lspr1,cf_lspr2,w_ln_tspr,w_ln_lspr,w_sz_tspr,w_sz_lspr,train_portion)
addpath('Data')
fold_nm = ['NR';'BP'];
load wl         % wavelengths - Vector must be in the same path

%% Cut off points
tspr_ct_off = [linspace((cf_tspr(1)-w_ln_tspr),(cf_tspr(1)+w_ln_tspr),w_sz_tspr);
    linspace((cf_tspr(2)-w_ln_tspr),(cf_tspr(2)+w_ln_tspr),w_sz_tspr)];     

lspr_ct_off1 = [linspace((cf_lspr1(1)-w_ln_lspr),(cf_lspr1(1)+w_ln_lspr),w_sz_lspr);
    linspace((cf_lspr1(2)-w_ln_lspr),(cf_lspr1(2)+w_ln_lspr),w_sz_lspr)];

lspr_ct_off2 = [linspace((cf_lspr2(1)-w_ln_lspr),(cf_lspr2(1)+w_ln_lspr),w_sz_lspr);
    linspace((cf_lspr2(2)-w_ln_lspr),(cf_lspr2(2)+w_ln_lspr),w_sz_lspr)];


for i = 1:2                     %NR, NBP
    for j = 1:length(tspr_ct_off)
        win_tspr(i,j) = find(wl==round(tspr_ct_off(i,j)));         % indexes
    end
end

for i = 1:2                     %NR, NBP
    for j = 1:length(lspr_ct_off1)
        win_lspr1(i,j) = find(wl==round(lspr_ct_off1(i,j)));         % indexes
    end
end

for i = 1:2                     %NR, NBP
    for j = 1:length(lspr_ct_off2)
        win_lspr2(i,j) = find(wl==round(lspr_ct_off2(i,j)));         % indexes
    end
end

%% Viewer to verify samples - Uncomment to view output.
% for fold = 1:2
%     for k = 1:24
%         load(['Data/' fold_nm(fold,:) '/' num2str(k) '.mat'])
%         figure
%         plot(wl,data)
%         hold on
%         stem(wl(win_tspr(fold,:)),data(win_tspr(fold,:)))
%         stem(wl(win_lspr1(fold,:)),data(win_lspr1(fold,:)))
%         stem(wl(win_lspr2(fold,:)),data(win_lspr2(fold,:)))
%         title(fold_nm(fold,:))
%     end
% end

%% Sample creation
M1 = [];
M2 = [];
M3 = [];
M4 = [];
M6 = [];

for fold = 2:2
    A = dir(['Data/' fold_nm(fold,:) '/*mat']); % Change to '\' for windows
    for k = 1:length(A)
        load([A(k).folder '/' A(k).name])
        D_ = data([win_tspr(fold,:) win_lspr1(fold,:) win_lspr2(fold,:)],:)';
        %% Use each T
        M1 = [M1; D_ fold*ones(1,12)' (1:12)'];
        %% Use 2T bracket
        T = [];
        for j = 1:6
            T = [T j j];
        end
        M2 = [M2; D_ fold*ones(1,12)' T'];
        %% Use 3T bracket
        T = [];
        for j = 1:4
            T = [T j j j];
        end
        M3 = [M3; D_ fold*ones(1,12)' T'];
        %% Use 4T bracket
        T = [];
        for j = 1:3
            T = [T j j j j];
        end
        M4 = [M4; D_ fold*ones(1,12)' T'];
        %% Use 6T bracket
        T = [];
        for j = 1:2
            T = [T j j j j j j];
        end
        M6 = [M6; D_ fold*ones(1,12)' T'];
    end
end
% Call the writing function to write to CSV/
writeCSV(M1,train_portion,'1');
writeCSV(M2,train_portion,'2');
writeCSV(M3,train_portion,'3');
writeCSV(M4,train_portion,'4');
writeCSV(M6,train_portion,'6');
end

function writeCSV(M,training_portion,fname)
D = mat2dataset(M); D.Properties.VarNames(end) = {'T'}; 
D.Properties.VarNames(end-1) = {'P'};
T = dataset2table(D);
T = T(randperm(size(T, 1)), :);
[h,w] = size(T);
tr_s = round(training_portion*h);
% Randomly generate a subset. Use rng() for reprodicubility 
x = randperm(h,tr_s);
% Training portion
writetable(T(x,1:w-1),['CSV/' fname '_tr.csv']); % Features
writetable(T(x,w),['CSV/' fname '_tgt.csv']);    % Targets
% Testing portion
T(x,:) = [];
writetable(T(:,1:w-1),['CSV/' fname '_pr.csv']); % Features
writetable(T(:,w),['CSV/' fname '_out.csv']);    % Target
end
