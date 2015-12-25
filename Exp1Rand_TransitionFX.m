function [params, llk, samps,Mle]=Exp1Rand_TransitionFX(allResp, allTarg, allRep, allPrev, ...
    center,curr_samps,curr_params, curr_llk,probPrior,curr_Mle,envrad)
% Generate new parameter vlaues, compare to old
% 4.8.2015-Created

%% Get data for conj prior
% *** Priors: Because these fits are across subjects, these should be very weak
%errTypePrior=[1 1 1 1]; % Add one count to each err type to prevent exclusion of err type
%errTypePrior=[0 0 0 0]; % Zero counts
errTypePrior=probPrior;
distsPrior=15; % Add one distance for same reason
distsPrior2=100; % Add one distance for same reason

errType=curr_samps{1}+errTypePrior;
dists=[curr_samps{2};distsPrior];
distsRand=[curr_samps{3};distsPrior2];

%% Sample probabilities from Dirichlet
new_probs=drchrnd(errType,1);

%% Sample sd from gamma
dfVar = sum(dists.^2);
df = length(dists);
p1 = df/2;
p2 = dfVar/2;
new_sd=sqrt(1./gamrnd(p1,1./p2));

%% Sample randsd from gamma

dfVar = sum(distsRand.^2);
df = length(distsRand);
p1 = df/2;
p2 = dfVar/2;
new_randsd=sqrt(1./gamrnd(p1,1./p2));

new_param=[new_sd new_probs new_randsd];

%% Calculate llk of new parameters
[llk_responses, new_samps]=Exp1Rand_ResponseLikelihood(allResp, allTarg, allRep, allPrev, center,new_param,envrad);
llk_trial=Exp1_TrialLikelihood(llk_responses);
new_llk=Exp1_TotalLikelihood(llk_trial);

% Accept or reject new parameters
if (curr_llk/new_llk)>rand()
    params=new_param;
    llk=new_llk;
    samps=new_samps;
    Mle=llk_responses;
else
    params=curr_params;
    llk=curr_llk;
    samps=curr_samps;
    Mle=curr_Mle;
end




