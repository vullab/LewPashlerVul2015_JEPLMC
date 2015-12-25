function [allParam, allLlk,allMle]=Exp2ModRecov_fit(data,center,envrad,foldName,fName)
% Find the best parameter fits
% 4.8.2015-Created
% 6.16.2015-Exp2ModRecov_fit-Version for model recovery

%% Files
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
[allResp, allTarg]=Exp2ModRecov_restruc(data,center);

%% Run Gibbs sampler
numBurn=200;
numSamps=200;

numTotal=numSamps+numBurn;
allParam=nan(1,numSamps,4); % sessions x samples x parameters 
allLlk=nan(1,numSamps);
allMle=nan(10,11,size(allResp,1),1);
init=[60 1/3 1/3 1/3]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 1];
for is=1
    disp(fName)
    fullName=fullfile(foldName,strcat(fName,'.mat'));
    if ~exist(fullName)
        allRespSess=squeeze(allResp(:,is,:,:));
        allTargSess=squeeze(allTarg(:,is,:,:));
        [params, llk,Mle]=Exp2_gibbs(allRespSess,allTargSess,center,numBurn,numSamps,init,probPrior,envrad);
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is,:)=llk((numBurn+1):numTotal);
    allMle(:,:,:,is)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end

