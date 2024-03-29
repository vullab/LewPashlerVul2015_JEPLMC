function [targ, miss, r_err,r_err2, curr_dist]=Exp2_samps(llk_curr,xr,yr,xt,yt)
% Given llk, sample whether targ, miss or rand, and also how far from targ
numObj=size(llk_curr,1);

% Sample from llk
llk_norm=llk_curr./repmat(sum(llk_curr,2),1,numObj+3);
randNum=rand(numObj,1);
randsel=sum(cumsum(llk_norm,2)<repmat(randNum,1,numObj+3),2)+1;

targ=randsel==[1:10]';
miss=~(randsel==[1:10]') & ~(randsel>=11);
r_err=randsel==11;
r_err2=randsel>11;

% And calculate distances
isLoc=targ | miss;
distx=xr(isLoc)-xt(randsel(isLoc));
disty=yr(isLoc)-yt(randsel(isLoc));
if sum(isnan(distx))>0
disp('')
end
curr_dist=[distx';disty'];

end