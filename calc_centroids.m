function mC = calc_centroids(data_all, train_stage)

clusters = unique(train_stage);
for ci = 1:length(clusters)
    x = data_all(:, 20:end, train_stage == ci);
    CC=[];r=[];e=[];
    for kk=1:size(x, 3)
        CC(:, :, kk) = corr(x(:, :, kk)');
        e(:,kk) = sort(eig(CC(:,:,kk)), 'descend');
        r(kk) = find(e(:,kk) < median(e(:,kk) ), 1);
    end

    r = min(r);
    mC(:, :, ci) = SpsdMean(CC, r);
end




