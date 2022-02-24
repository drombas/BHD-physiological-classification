%% Visualization
f = figure(1);clf;hold on;
sig_type = {'respiratory_chest','respiratory_CO2','respiratory_O2'};

for i_s=1:length(sig_type)
    selec = strcmp(annot.type, sig_type{i_s});
    scatter(vertcat(X(selec).ad_up),vertcat(X(selec).ad_down),'filled','MarkerFaceAlpha',0.6);
end
grid on;
legend(sig_type, 'Interpreter', 'none');set(gca,'FontSize',12);