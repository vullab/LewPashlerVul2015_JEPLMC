function [allParam, allLlk, allMle]=Exp1Rand_fit(data,center,envrad)
% Find the best parameter fits
% 4.8.2015-Created
% 6.16.2015-Exp1Rand_fit-Introducing random guessing noise parameter

%% Files
foldName='E1RandFits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
numAnalyze=20;
[allResp, allTarg,allRep,allPrev]=Exp1_restruc(data,numAnalyze,center);

%% Run Gibbs sampler
numBurn=500;
numSamps=700;

numTotal=numSamps+numBurn;
allParam=nan(numAnalyze,numSamps,6); % sessions x samples x parameters 
allLlk=nan(numAnalyze,numSamps);
allMle=nan(10,13,size(allResp,1),3);
init=[60 1/3 1/3 1/6 1/6 100]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 .5 .5];
for is=1:numAnalyze
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        allRespSess=squeeze(allResp(:,is,:,:));
        allTargSess=squeeze(allTarg(:,is,:,:));
        allRepSess=squeeze(allRep(:,is,:,:));
        allPrevSess=squeeze(allPrev(:,is,:,:));
        [params, llk,Mle]=Exp1Rand_gibbs(allRespSess,allTargSess, ...
            allRepSess,allPrevSess, ...
        center,numBurn,numSamps,init,probPrior,envrad);
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is,:)=llk((numBurn+1):numTotal);
    allMle(:,:,:,is)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end



