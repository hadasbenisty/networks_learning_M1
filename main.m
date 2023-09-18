clear
datapath = '../data/';
labelsCTRL = {'train_1' 'train_2' 'train_3' 'train_4' 'train_5' 'train_6' 'train_7'};
labelsCNO = {'train_1' 'CNO_2' 'CNO_3' 'CNO_4' 'train_5' 'train_6' 'train_7'};

animalsnames = {'DT141' 'DT155'};
animalsLabels = [0 1];

chosen_animal = 1; % or 2

load(fullfile(datapath, animalsnames{chosen_animal}, 'data.mat'));

%% svm - naive expert
[chanceLevel, estimated_level] = naive_expert_svm(data_all, train_stage, training_labels_lut); 
figure;imagesc(linspace(-3.5, 7.5, 23), 1:7, estimated_level, [0 1]); set(gca, 'YtickLabels', labelsCTRL);
xlabel('Time [sec]'); ylabel('Session');title('Prediction probability as Expert')
colormap jet;colorbar;

%% pca trajectories
trajectories_analysis_sf(data_all, sflabels, train_stage, training_labels_lut);

%% centroids
mC = calc_centroids(data_all, train_stage);
cent = get_centrality(mC);
dR = calc_Rdist(mC);
