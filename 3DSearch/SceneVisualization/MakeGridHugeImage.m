% MakeGridHugeImage.m
%
% Created 11/7/11 by DJ for one-time use.

campoints = [];
for i=1:8 % column
    xval = 15*(i-1); 
    if (mod(i,2)==1) %if we're on an up trial
        for j=0:8 %row
            campoints = [campoints; [xval, 20*j]];
        end
    else
        for j=0:8 %row
            campoints = [campoints; [xval,160-20*j]];
        end
    end
end
campoints = [campoints; [110, 0]];
zeroPoint = [15, 9.5];
sessionOffset = [121,0];
nObjPerSession = 56;
save GridHuge campoints zeroPoint sessionOffset nObjPerSession

%%
C = MakeRepeatedImage('GridHugeSingle_separated.png',[56,35],[4.22 4.22],[0 121],9);
imwrite(C,'GridHugeMulti_separated.png','png')
CNew = ScaleImage('GridHugeMulti_separated.png',[4.22 4.22]);
imwrite(CNew,'GridHuge.png','png')