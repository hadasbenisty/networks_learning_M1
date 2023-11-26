function trajectories_analysis_sf(data_all, sflabels, train_stage, training_labels_lut)
REPS = 10;
X = data_all(:, 20:end, :);
y = sflabels;
alldataNT=[];
for k=1:size(X,1)
    alldataNT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
end
pcaTrajres=[];
[pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(alldataNT);
pcaTrajres.effectiveDim = getEffectiveDim(pcaTrajres.eigs, .95);

[~, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:pcaTrajres.effectiveDim);


for l=1:size(projeff,2)
    pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));

end
% trial variability, sensitivity index for s/f
d = nan(size(data_all, 2)-19, length(training_labels_lut));
p = nan(size(data_all, 2)-19, length(training_labels_lut));
drand = nan(size(data_all, 2)-19, length(training_labels_lut), REPS);


for ci=1:min(7, length(training_labels_lut))
    disp(ci);
    xx = pcaTrajres.projeff(:, :, train_stage == ci);
    yy = sflabels(train_stage==ci);
    d(:, ci) = calc_dprime_traj(xx, yy);
    if all(isnan(d(:, ci)))
        drand(:, ci, :) = nan;
        p(:, ci) = nan;
        continue;
    else
        for r = 1:REPS
            inds = randperm(length(yy));
            drand(:, ci, r) = calc_dprime_traj(xx, yy(inds));
        end
        for t = 1:size(drand,1)
            if all(isnan(squeeze(drand(t, ci, :))))
                p(t,ci) = nan;
            else
                p(t, ci)=sum(squeeze(drand(t, ci, :)) - d(t, ci)>0);
            end
        end
    end
end

figure;
for ci = 1:length(training_labels_lut)
    X = data_all(:, :, train_stage == ci);
    y = sflabels(train_stage==ci);
    alldataNT=[];
    for k=1:size(X,1)
        alldataNT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
    end
    pcaTrajres=[];
    [pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(alldataNT);
    pcaTrajres.effectiveDim = getEffectiveDim(pcaTrajres.eigs, .95);

    [~, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:pcaTrajres.effectiveDim);


    for l=1:size(projeff,2)
        pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));

    end
    subplot(2,4,ci);
    plot(mean(pcaTrajres.projeff(1,:,y==1), 3), ...
        mean(pcaTrajres.projeff(2,:,y==1), 3), 'b');
    hold all;
    plot(mean(pcaTrajres.projeff(1,:,y==0), 3), ...
        mean(pcaTrajres.projeff(2,:,y==0), 3), 'r');
    title(['Train_' num2str(ci)])
end



