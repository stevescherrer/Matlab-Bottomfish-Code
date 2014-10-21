%%%%% A SCRIPT WITH ALL TAG IDS TO SORT AND SEPARATE ALL DETECTIONS INTO
%%%%% SEPARATE FILES BY SPECIES

tic

%load('BOTTOMFISHTAGDATA.csv')
AllTagData=BOTTOMFISHTAGDATA;

DogfishTemp=nan(size(AllTagData));
EhuTemp=nan(size(AllTagData));
OpakaTemp=nan(size(AllTagData));
KaleTemp=nan(size(AllTagData));
GesTemp=nan(size(AllTagData));

for i=1:length(AllTagData) 
if AllTagData(i,1)==14412
DogfishTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37935
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37936
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37937
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37938
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37939
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37940
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37941
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37942
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37943
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37944
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37945
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37946
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37947
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37948
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37949
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37950
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37951
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37952
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37953
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37954
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37955
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37956
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37957
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37958
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37959
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37960
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37961
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37962
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37963
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37964
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37965
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37966
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37967
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37968
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37969
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37970
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37971
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37972
GesTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37973
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37974
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37975
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37976
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37977
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37978
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37979
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37980
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37981
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37982
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37983
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==37984
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57445
SandbarTemp=AllTagData(i,:);
elseif AllTagData(i,1)==57446
KaleTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57447
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57448
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57449
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57450
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57451
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57455
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57456
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57457
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57458
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57459
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57460
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57462
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57463
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57464
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57465
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,1)==57466
OpakaTemp(i,:)=AllTagData(i,:);
    
 
    
    %%%%%%%%%ADD ANY ADDITIONAL TAGS
end
end




Opaka=OpakaTemp(isnan(OpakaTemp(:,1))==0,:);
Ehu=EhuTemp(isnan(EhuTemp(:,1))==0,:);
Kale=KaleTemp(isnan(KaleTemp(:,1))==0,:);
DogFish=DogfishTemp(isnan(DogfishTemp(:,1))==0,:);
Sandbar=SandbarTemp(isnan(SandbarTemp(:,1))==0,:);
Ges=GesTemp(isnan(GesTemp(:,1))==0,:);

clearvars OpakaTemp EhuTemp KaleTemp DogfishTemp SandbarTemp GesTemp i

%save 'Opaka'; save 'Ehu'; save 'Kale'; save 'Dogfish'; save 'Sandbar';

toc