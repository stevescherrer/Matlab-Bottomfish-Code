%%%%% A SCRIPT WITH ALL TAG IDS TO SORT AND SEPARATE ALL DETECTIONS INTO
%%%%% SEPARATE FILES BY SPECIES

tic

%load('BOTTOMFISHTAGDATA.csv')
%AllTagData=[BOTTOMFISHTAGDATA,BOTTOMFISHTAGDATA(:,1),BOTTOMFISHTAGDATA(:,1)];

DogfishTemp=nan(size(AllTagData));
EhuTemp=nan(size(AllTagData));
OpakaTemp=nan(size(AllTagData));
KaleTemp=nan(size(AllTagData));
GesTemp=nan(size(AllTagData));

for i=1:length(AllTagData) 
if AllTagData(i,7)==14412
DogfishTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37935
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37936
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37937
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37938
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37939
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37940
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37941
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37942
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37943
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37944
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37945
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37946
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37947
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37948
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37949
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37950
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37951
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37952
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37953
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37954
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37955
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37956
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37957
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37958
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37959
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37960
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37961
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37962
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37963
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37964
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37965
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37966
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37967
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37968
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37969
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37970
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37971
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37972
GesTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37973
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37974
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37975
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37976
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37977
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37978
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37979
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37980
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37981
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37982
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37983
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==37984
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57445
SandbarTemp=AllTagData(i,:);
elseif AllTagData(i,7)==57446
KaleTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57447
EhuTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57448
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57449
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57450
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57451
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57455
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57456
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57457
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57458
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57459
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57460
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57462
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57463
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57464
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57465
OpakaTemp(i,:)=AllTagData(i,:);
elseif AllTagData(i,7)==57466
OpakaTemp(i,:)=AllTagData(i,:);
    

    
    %%%%%%%%%ADD ANY ADDITIONAL TAGS
end
end

Opaka=OpakaTemp(isnan(OpakaTemp(:,1))==0,:);
Ehu=EhuTemp(isnan(EhuTemp(:,1))==0,:);
Kale=KaleTemp(isnan(KaleTemp(:,1))==0,:);
Dogfish=DogfishTemp(isnan(DogfishTemp(:,1))==0,:);
Sandbar=SandbarTemp(isnan(SandbarTemp(:,1))==0,:);
Ges=GesTemp(isnan(GesTemp(:,1))==0,:);

clearvars OpakaTemp EhuTemp KaleTemp DogFishTemp SandbarTemp GesTemp

%save 'Opaka'; save 'Ehu'; save 'Kale'; save 'Dogfish'; save 'Sandbar';

toc