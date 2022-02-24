% Build and test a classifier based on computed features.
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

% Load data


% Classification 
is_resp = ~strcmp(annot.type, 'cardiac');
% n_resp = sum(is_resp);

Yresp = annot.type_num;
Xresp = vertcat(X.ad_down);

th1 = -0.02;
th2 = -0.1;

Ypred = nan(n_s,1);

Ypred(~is_resp) = 2;
Ypred(is_resp & Xresp > th1) = 1;
Ypred(is_resp & Xresp > th2 & Xresp <=th1) = 4;
Ypred(is_resp & Xresp <= th2) = 3;

figure;
subplot(121);hold on;
ind = [1 3 4];
for s=1:3
    scatter(ind(s) -1 + ones(1,sum(Yresp==ind(s))), Xresp(Yresp==ind(s)));
end
plot([1 4],[th1 th1],'--k');
plot([1 4],[th2 th2],'--k');

C = nan(3,3);
for i=1:4
    for j=1:4
        C(i,j) = sum(Ypred(Yresp==i) ==j)/sum(Yresp==i)*100;
    end
end

subplot(122);
imagesc(C);
xticks(1:4);
xticklabels({'chest','cardiac','CO2','O2'})
yticks(1:4);
yticklabels({'chest','cardiac','CO2','O2'})
