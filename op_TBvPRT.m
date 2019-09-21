figure
scat_out_RF = zeros(4,5);
scat_out_GB = zeros(4,5);
scat_out_AB = zeros(4,5);
i = 1;
for tbrac_ = [1:4 6]
    A = tb_err(find(tb_err.tbrac == tbrac_), [4, 7]);
    scat_out_RF(:,i) = A.MAbsErr(:,1);
    scat_out_GB(:,i) = A.MAbsErr(:,2);
    scat_out_AB(:,i) = A.MAbsErr(:,3);
    i = i+1;
end

imagesc(flipud([scat_out_RF scat_out_GB scat_out_AB]))
colorbar
xticks(1:16)
xticklabels({'1','2','3','4','6','1','2','3','4','6','1','2','3','4','6'})
yticks(1:4)
yticklabels({'0.95','0.85','0.75','0.65'})
xlabel('Temperature Bracket')
ylabel('Training Portion')
axis square