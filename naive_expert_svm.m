function [chanceLevel, estimated_level] = naive_expert_svm(data_all, train_stage, training_labels_lut)

params.duration = 12;

params.slidingWinLen = 1; params.slidingWinHop = 0.5;
params.foldsnum = 10; params.islin = 1;params.tone=4;
params.naiveLabel = 'train1';




expertindex = find(strcmp(training_labels_lut, 'train_7'));
naiveindex = 1;

[winstSec, winendSec] = getFixedWinsFine(params.duration, params.slidingWinLen, params.slidingWinHop);
t = linspace(0, params.duration, size(data_all, 2));
chanceLevel = sum(train_stage==expertindex)/sum(train_stage==naiveindex|train_stage==expertindex);
chanceLevel=max(chanceLevel,1-chanceLevel);

predictions = train_test_naive_expert_svm_sliding(data_all, t, winstSec, winendSec, 1, ...
    train_stage, naiveindex,  expertindex);
labs = unique(train_stage);
expertEstimation = nanmean(predictions==expertindex,3);
tmid = mean([winstSec;winendSec]) - params.tone;
estimated_level = nan(length(labs), length(tmid));
for ti=1:size(predictions,2)
    for ci = 1:length(labs)
        estimated_level(ci,ti) = sum(expertEstimation(train_stage==labs(ci),ti))/sum(train_stage==labs(ci));
    end

end

