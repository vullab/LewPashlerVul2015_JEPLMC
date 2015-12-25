function [allResp, allTarg,sdRand]=Exp2ModRecov_restruc(data,center)
% Turn the data into responses and targets
% 4.8.2015-Created

allResp=nan(length(data),1,10,2); % subj x session x objects x dim
allTarg=nan(length(data),1,10,2);

numSubj=length(data);
numSess=[1]; % identify testing sessions

for is=1:numSubj
    for iSe=1:length(numSess)
        allResp(is,iSe,:,1)=[data{is}.xs];
        allResp(is,iSe,:,2)=[data{is}.ys];
        allTarg(is,iSe,:,1)=[data{is}.xt];
        allTarg(is,iSe,:,2)=[data{is}.yt];
    end
end

sdRand=nan(1,length(numSess));
for iSe=1:length(numSess)
    xdif=allResp(:,iSe,:,1)-center(1);
    xdif=xdif(:);
    ydif=allResp(:,iSe,:,2)-center(2);
    ydif=ydif(:);
    sdRand(iSe)=std([xdif;ydif]);
end


