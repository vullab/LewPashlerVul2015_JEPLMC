%% Revision analyses
% 6/16/2015-Final sets of comments from JEP require new analyses

%% Settings
clear all
close all
clc

set(0, 'DefaultAxesFontSize',40)
set(0, 'DefaultLineLineWidth',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Experiments 1 & 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading Experiment 1')
centerE1=[500 400];
envRadE1=370;
[exp1error,allStru1]=loadE1();
[E1_Resp, E1_Targ,E1_Rep,E1_Prev,E1_sdRand]=Exp1_restruc(allStru1,size(exp1error,2),centerE1);

disp('Loading Experiment 2')
centerE2=[500 475];
envRadE2=450;
allStru2=loadE2();
[E2_Resp, E2_Targ,E2_sdRand]=Exp2_restruc(allStru2,centerE2);

clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distribution of responses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tempx=E2_Resp(:,:,:,1);
% tempy=E2_Resp(:,:,:,2);
% figure('Position', [100, 100, 650, 600])
% set(gcf,'color','w');
% hold on
% plot(tempx(:),tempy(:),'ko','Color',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5],'MarkerSize',5)
% circle(centerE2(1),centerE2(2),envRadE2)
% set(gca,'box','off')
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Random guessing SD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Does estimating the random guessing SD give different results?

% Fit model for Experiment 1
[E1Rand_params, E1Rand_llk, E1Rand_Mle]= ...
    Exp1Rand_fit(allStru1,centerE1,envRadE1);

% Fit model for Experiment 1 Rev
[E1RevRand_params, E1RevRand_llk, E1RevRand_Mle,allRandSd]= ...
    Exp1RevRand_fit(allStru1,centerE1,envRadE1);

% Fit model for Experiment 2
[E2Rand_params, E2Rand_llk, E2Rand_Mle]= ...
    Exp2Rand_fit(allStru2,centerE2,envRadE2);

% % Plot
% figure('Position', [100, 100, 1249, 895])
% set(gcf,'color','w');
% hold on
%
% E1_randsd_mean=mean(E1Rand_params(:,:,6),2);
% E1_randsd_std=std(E1Rand_params(:,:,6),[],2);
% plot(-21:-2,E1_sdRand(1:20),'k--','Color',[.5 .5 .5],'LineWidth',4)
% errorbar(-21:-12,E1_randsd_mean(1:10),E1_randsd_std(1:10),'k','LineWidth',4)
%
% E2_randsd_mean=mean(E2Rand_params(:,:,5),2);
% E2_randsd_std=std(E2Rand_params(:,:,5),[],2);
% plot([1 2 8],E2_sdRand,'k--','Color',[.5 .5 .5],'LineWidth',4)
% errorbar([1 2 8],E2_randsd_mean,E2_randsd_std,'k','LineWidth',4)
% xlabel('Block')
% ylabel('SD (px)')

% Log
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

E1_randsd_mean=mean(log10(E1Rand_params(:,:,6)),2);
E1_randsd_std=std(log10(E1Rand_params(:,:,6)),[],2);
E1_randsd_lo=prctile(log10(E1Rand_params(:,:,6)),2.5,2);
E1_randsd_hi=prctile(log10(E1Rand_params(:,:,6)),97.5,2);

%b=errorbar(-24:-5,E1_randsd_mean(1:20),E1_randsd_std(1:20),'Color',[.6 .6 .6],'LineWidth',4);
b=errorbar(-24:-5,E1_randsd_mean(1:20),E1_randsd_mean(1:20)-E1_randsd_lo(1:20),E1_randsd_hi(1:20)-E1_randsd_mean(1:20),'Color',[.6 .6 .6],'LineWidth',4);
a=plot(-24:-5,log10(E1_sdRand(1:20)),'k:','Color',[.1 .1 .1],'LineWidth',4);

E1Rev_randsd_mean=flipud(mean(log10(E1RevRand_params(:,:,6)),2));
E1Rev_randsd_std=flipud(std(log10(E1RevRand_params(:,:,6)),[],2));
E1Rev_randsd_lo=flipud(prctile(log10(E1RevRand_params(:,:,6)),2.5,2));
E1Rev_randsd_hi=flipud(prctile(log10(E1RevRand_params(:,:,6)),97.5,2));
errorbar(-3:-1,E1Rev_randsd_mean,E1Rev_randsd_mean-E1Rev_randsd_lo,E1Rev_randsd_hi-E1Rev_randsd_mean,'Color',[.6 .6 .6],'LineWidth',4);
plot(-3:-1,log10(allRandSd),'k:','Color',[.1 .1 .1],'LineWidth',4)

E2_randsd_mean=mean(log10(E2Rand_params(:,:,5)),2);
E2_randsd_std=std(log10(E2Rand_params(:,:,5)),[],2);
E2_randsd_lo=prctile(log10(E2Rand_params(:,:,5)),2.5,2);
E2_randsd_hi=prctile(log10(E2Rand_params(:,:,5)),97.5,2);
errorbar([1 2 8],E2_randsd_mean,E2_randsd_mean-E2_randsd_lo,E2_randsd_hi-E2_randsd_mean,'Color',[.6 .6 .6],'LineWidth',4)
plot([1 2 8],log10(E2_sdRand),'k:','Color',[.1 .1 .1],'LineWidth',4)

plot([0 0],[1.5 4],'Color',[.3 .3 .3]);
ylim([1.5 4])
xlim([-25 9])

set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel({'Dispersion: SD','of random guesses (Log_1_0 px)'});

hx1=text(-14,1.1,'Block','HorizontalAlignment','center');
hx2=text(4.5,1.1,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,3.75,'Training','HorizontalAlignment','center');
hx4=text(4,3.75,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

legh=legend([a b],'Empirical','Estimated','Location','West');

% Positioning and cleaning
scale = 0.10;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,hYLabel,legh)
set(hYLabel,'FontSize',40)
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameter recovery
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Is the model accurate in the first few iterations with high random
% guessing?

% Settings
numObj=10;
numSubj=size(allStru1,1);
foldName='ModRecov';
if ~exist(foldName)
    mkdir(foldName)
end

% fname='noTarglowMisshighRand.mat';
% probTarg=[0];
% probMiss=[0 .05 .1 .15 .2 .25 .3 .35];
% noise=[10 30 60 90 120 150];
% hx1=text(-240,-35,'True Location SD (px)','HorizontalAlignment','center');
% hx2=text(-690,200,'Recovered Location SD (px)','HorizontalAlignment','center','rotation',90);
% set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 48);
% 
fname='noTarglowMisshighRandMini.mat';
probTarg=[0];
probMiss=[.1 .2 .3];
noise=linspace(10,150,15);

% fname='lowTargnoMisshighRandMini.mat';
% probTarg=[.1 .2 .3];
% probMiss=[0];
% noise=linspace(10,150,15);

if ~exist(fullfile(foldName,fname))
    mkdir(fullfile(foldName,fname))
end

if ~exist(fullfile(foldName,fname,strcat(fname,'Data.mat')))
    
    allStruMod=cell(length(probTarg),length(probMiss),length(noise));
    
    for it=1:length(probTarg)
        for im=1:length(probMiss)
            
            pt=probTarg(it);
            pm=(1-pt)*probMiss(im);
            pr=(1-pt-pm);
            probs=[pt pm pr];
            for in=1:length(noise)
                sdNoise=noise(in);
                
                allStruCurr=cell(numSubj,1);
                for is=1:numSubj
                    objArray=[];
                    
                    % Generate targets
                    rho=(30+25)+((envRadE1-30-25-30)*rand(10,1));
                    theta=2*pi*rand(10,1);
                    [x, y]=pol2cart(theta,rho);
                    targ=[x y];
                    
                    % Generate responses
                    respSel=randsample([1 2 3],10,true,probs);
                    resp=nan(10,2);
                    
                    % Target
                    resp(respSel==1,:)=normrnd(targ(respSel==1,:),sdNoise);
                    
                    % Misassociation
                    numMiss=find(respSel==2);
                    for imSel=1:length(numMiss)
                        selMiss=randsample(setdiff(1:10,numMiss(imSel)),1);
                        resp(numMiss(imSel),:)=normrnd(targ(selMiss,:),sdNoise);
                    end
                    
                    % Rand
                    resp(respSel==3,:)=normrnd(repmat(centerE1,sum(respSel==3),1),mean(E1_sdRand));
                    
                    % Store
                    for os=1:10
                        obj=struct('xs',resp(os,1),'ys',resp(os,2),'xt',targ(os,1),'yt',targ(os,2));
                        objArray=[objArray obj];
                    end
                    
                    allStruCurr{is}=objArray;
                end
                allStruMod{it,im,in}=allStruCurr;
                
            end
        end
    end
    save(fullfile(foldName,fname,strcat(fname,'Data.mat')),'allStruMod','probTarg','probMiss','noise');
else
    load(fullfile(foldName,fname,strcat(fname,'Data.mat')))
end

%% Model fit
trueParam=nan(length(probTarg),length(probMiss),length(noise),4);
recovParam=nan(length(probTarg),length(probMiss),length(noise),4);
recovParamSD=nan(length(probTarg),length(probMiss),length(noise),4);
for it=1:length(probTarg)
    for im=1:length(probMiss)
        
        pt=probTarg(it);
        pm=(1-pt)*probMiss(im);
        pr=(1-pt-pm);
        probs=[pt pm pr];
        for in=1:length(noise)
            sdNoise=noise(in);
            
            allStruCurr=allStruMod{it,im,in};
            dataFile=fullfile(strcat(fname,'Fit', ...
                num2str(it),'_',num2str(im),'_',num2str(in),'_','.mat'));
            if ~exist(dataFile)
                [params, llk, mle]=Exp2ModRecov_fit(allStruCurr,centerE1,envRadE1,fullfile(foldName,fname),dataFile);
            else
                load(fullfile(foldName,fname,dataFile));
            end
            params2=squeeze(params);
            trueParam(it,im,in,:)=[pt pm pr sdNoise];
            recovParam(it,im,in,:)=[mean(log10(params2(:,[2 3 4 1])))];
            recovParamSD(it,im,in,:)=[std(log10(params2(:,[2 3 4 1])))];
            
        end
    end
end

%% Plot results

% Noise with random guessing
figure('Position', [100, 100, 1249, 400])
set(gcf,'color','w');

probRand=unique(trueParam(:,:,:,3));
[n]=numSubplots(length(probRand));
for it=1:length(probRand)
    %subplot(n(1),n(2),it)
    subplot(1,length(probRand),it)
    hold on
    
    sel=trueParam(:,:,:,3)==probRand(it);
    trueParamCurr=log10(trueParam(:,:,:,4));
    respParamCurr=recovParam(:,:,:,4);
    respParamSDCurr=recovParamSD(:,:,:,4);
    
    trueParamCurr=trueParamCurr(sel);
    respParamCurr=respParamCurr(sel);
    respParamSDCurr=respParamSDCurr(sel);
    
    temp=max([trueParamCurr(:);respParamCurr(:)+respParamSDCurr(:)]);
    plot([.9 2.25],[.9 2.25],'k--','Color',[.5 .5 .5])
    errorbar(trueParamCurr(:),respParamCurr(:),respParamSDCurr(:),'k.','MarkerSize',35)
    xlim([.9 2.25]);
    ylim([.9 2.25]);
    
    [b bint]=regress(respParamCurr(:),trueParamCurr(:));
    disp([b bint])
    
%     [a b]=corr(respParamCurr(:),trueParamCurr(:));
%     disp([a b])
    
    title({'Probability Random' strcat('Guess=',num2str(probRand(it)))},'FontSize',24,'FontName', 'Helvetica','Color',[.3 .3 .3])
    set(gca,'FontSize',24)
    if it==2
        xlabel('True Log Imprecision (px)','FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 32)
    end
    hold off
end

%hx1=text(-240,-35,'True Imprecision (px)','HorizontalAlignment','center');
hx2=text(-3.05,1.6,{'Recovered Log', 'Imprecision (px)'},'HorizontalAlignment','center','rotation',90);
set([hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 32);







