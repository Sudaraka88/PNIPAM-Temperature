%% Generate Mat data from CSV files
% This is the first file to run, run only once!
% 'wl.mat' and 'RAW' folder must be in same path.
% Will generate 'Data' folder. Ignore varname identifier warning.
% Change all '/' to '\' for windows

load wl.mat     % Wavelength vector
addpath('RAW')
fold_nm = ['BP';'NR'];
for fold = 1:2  % BP and NR
    if ~exist(['Data/' fold_nm(fold,:)], 'file')
        mkdir(['Data/' fold_nm(fold,:)]) 
    end
    A = dir(['RAW/' fold_nm(fold,:) '/*.csv']);
    for i = 1:length(A)
        table = readtable([A(i).folder '/' A(i).name]);
        % Deal with inconsitencies manually
        if(size(table) ~= [1592,25])
            size(table)
            data = str2double(table2cell(table(2:602,4:2:26)));
        else
            data = str2double(table2cell(table(2:602,2:2:24)));
        end
        % Save refined data in mat format
        save(['Data/' fold_nm(fold,:) '/' num2str(i)],'data');
%%% Uncomment below to generate plots %%%
%         figure
%         plot(wl,data)
%         title(fold_nm(fold,:))
    end
end