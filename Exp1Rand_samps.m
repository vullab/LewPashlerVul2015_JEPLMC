function [targ, miss, r_err, curr_dist,curr_distRand]=Exp1Rand_samps(llk_curr,xr,yr,xt,yt,center)
% Given llk, sample whether targ, miss or rand, and also how far from targ
% 6.16.2015-Exp1Rand_samps-Adding random guessing sd parameter

numObj=size(llk_curr,1);

% Sample from llk
llk_norm=llk_curr./repmat(sum(llk_curr,2),1,numObj+1);
randNum=rand(numObj,1);
randsel=sum(cumsum(llk_norm,2)<repmat(randNum,1,numObj+1),2)+1;

targ=randsel==[1:10]';
miss=~(randsel==[1:10]') & ~(randsel==11);
r_err=randsel==11;

% And calculate distances
isLoc=targ | miss;
distx=xr(isLoc)-xt(randsel(isLoc));
disty=yr(isLoc)-yt(randsel(isLoc));
curr_dist=[distx';disty'];

% And calculate rand distances
isLoc=r_err;
distx=xr(isLoc)-center(1);
disty=yr(isLoc)-center(2);
curr_distRand=[distx';disty'];

end