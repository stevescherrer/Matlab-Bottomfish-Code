%%%For binning detections by the hours that they occurred and then
%%%determining the period in which an individual is most active. 

%%Written by Stephen Scherrer


BottomFish

Bins=linspace(1,24,1); %% Creating 24 bins to corrospond with 24 hour days

Times=BottomFish(:,2)-round(BottomFish(:,2)+.5)-1; %%should pull just date decimal from datestr

BottomFish(:,3)=Times; %%third bin of BottomFish was zeros, is replaced by just Times

Tags=unique(BottomFish(:,1)); %%indexes all individual fish


%% creating a matrix to determine which hour period a detection falls into.
ActiveHours=NaN(length(Tags),length(Bins)); %% creates active hours matrix 

%%placing detections into bins for each individual
for i=1:Tags
    Indv=BottomFish(BottomFish(:,1)==Tags(i),:);
    counter=zeros(1,length(Bins));
    for a=1:length(Indv);
    for b=2:length(Bins);
        if BottomFish(a,3)>=Bins(b-1) && BottomFish(a,3)<Bins(b);
            counter(b)=counter(b)+1;
        end
    end
    ActiveHours(i,:)=counter(1,:);
    end
end

clearvar Indv counter a b i


%% Splitting up the day into 4 periods
%Night=9pm-3am
%Day=3am-9am
%Dawn=9am-3pm
%Dusk=3pm-9pm

%%Making matrix for day period
DayPeriod=zeros(length(Tags),4);

for i=1:length(Tags);;
    DayPeriod(i,1)=ActiveHours(i,10)+ActiveHours(i,11)+ActiveHours(i,12)+ActiveHours(i,13)+ActiveHours(i,14)+ActiveHours(i,15);
    DayPeriod(i,2)=ActiveHours(i,16)+ActiveHours(i,17)+ActiveHours(i,18)+ActiveHours(i,19)+ActiveHours(i,20)+ActiveHours(i,21);
    DayPeriod(i,3)=ActiveHours(i,22)+ActiveHours(i,23)+ActiveHours(i,24)+ActiveHours(i,1)+ActieveHours(i,2)+ActiveHours(i,3);
    DayPeriod(i,4)=ActiveHours(i,4)+ActiveHours(i,5)+ActiveHours(i,6)+ActiveHours(i,7)+ActiveHours(i,8)+ActiveHours(i,9);
end

Night=DayPeriod(:,1);
Dawn=DayPeriod(:,2);
Day=DayPeriod(:,3);
Dusk=DayPeriod(:,4);

