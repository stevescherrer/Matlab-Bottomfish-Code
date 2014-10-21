%%For determining how long after deployment a tag is detected.

%%Code stitched together from other projects on 28 Jan 2014
%%Written by Stephen Scherrer

%%All Rights Preserved All Wrongs Traversed

%%Notes: Percentage of Pings detected must be run prior to this script for
%%deployment dates of tags

%%Average tag detection time
%%Histogram of tags by month bin
%%Fraction of tag life for which pings have been recovered

%%BottomFish
%%Created in "BuildingAWorkingDataBaseForBottomFish.m"
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Reciever Location (1=Barber Flats, 2=Base3rdFinger, 3=Diamond Head
        %%Pocket, 4=Dropoff Inside, 5=First Finger, 6=Haleiwa,7=Kaena Pocket,
        %%8=Kahuku, 9=Makapuu In BFRA, 10=Makapuu North, 11=Makapuu South,
        %%12=Marine Corps Base, 13=Pinnacle South, 14=Powerplant, 
        %%15=South of Ko Olina,16=South Tip, 17=SWAC, 18=The Mound, 19=Waianae,
        %%20=Cross Seamount, 21=Botcam Crew)
    %%Column 5=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, 0=unknown)
    %%Column 6=Size (cm)
    %%Column 7=Sex (1=Female, 2=Male, 0=Unknown)
    %%Column 8=(Created in following section)=Presence in BRFA or out of BRFA.
        %%1 indicates individual detected in BAFR, 0 indicates detection outside
        %%BRFA
    %%Column 9=Tagging Date
    %%Column 10=Anticipated tag death
    
%%RecieverDates
    %%Column 1=Reciever Location
    %%Column 2=Reciever Number
    %%Column 3=Deployment Date
    %%Column 4=Recovery Date
    %%Column 5=Deployment Latitude (prefix)
    %%Column 6=Deployment Latitude (degree minutes)
    %%Column 7=Deployment Longitude (prefix)
    %%Column 8=Deployment Longitude (degree minutes)
    %%Column 9=Deployment Longitude (decimal degrees)
    %%Column 10=Deployment Latitude (decimal Degrees) 
    
%%In this project, tags have been coded as follows:

%%Tag Code Range     Average Seconds     Batery life (Days)
%%57371-57470        150                 450
%%37935-37985        180                 539
%%52142-52161        150                 450



ThirtyDayBins450=linspace(1,450,round(450/30)); %creates bins for 30 day periods between deployment and tag death
ThirtyDayBins539=linspace(1,539,round(539+15/30)-1); %creates bins for 30 day periods between deployment and tag death

Opakapaka=BottomFish(:,5)==2; %pulls just Opakapaka out
UniqueOpakapaka=Opakapaka(find(unique(Opakapaka(:,1)),:)); %pulls out an individual fish
Opaka450IDs=Opakapaka(UniqueOpakapaka(:,10)-UniqueOpakapaka(:,9)==450,1); %if time between anticipated tag death and deployment is 450
Opaka539IDs=Opakapaka(UniqueOpakapaka(:,10)-UniqueOpakapaka(:,9)==539,1); %if time between anticipated tag death and deployment is 539
    
Opakapaka450DetectionMatrix=zeros(Opaka450IDs,ThirtyDayBins450); %makes matrix length Tag IDs for that tag interval
Opakapaka539DetectionMatrix=zeros(Opaka539IDs,ThirtyDayBins539); 

Opakapaka450=Opakapaka(Opakapaka(:,1)==Opaka450IDs,:);
for i=1:length(Opaka450IDs);
    Individuals=Opakapaka450(Opakapaka450(:,1)==Opaka450IDs(i),:);
    DateBins=Individuals(1,9)+ThirtyDayBins450;
    for b=2:length(DateBins);
        if max(Individuals(:,2))>=DateBins(b-1) && max(Individuals(:,2)<DateBins(b)
            BinFiller=1:b-1;
            Opakapaka450DetectionMatrix(i,BinFiller)=1;
        end
        if DateBins(b)>max(ReceiverDates(:,4))
            DateBins(b)=NaN;
        end
            
    end
end

Opakapaka539=Opakapaka(Opakapaka(:,1)==Opaka539IDs,:);
for i=1:length(Opaka539IDs);
    Individuals=Opakapaka539(Opakapaka539(:,1)==Opaka539IDs(i),:);
    DateBins=Individuals(1,9)+ThirtyDayBins539;
    for b=2:length(DateBins);
        if max(Individuals(:,2))>=DateBins(b-1) && max(Individuals(:,2)<DateBins(b)
            BinFiller=1:b-1;
            Opakapaka539DetectionMatrix(i,BinFiller)=1;
        end
        if DateBins(b)>max(ReceiverDates(:,4))
        DateBins(b)=NaN;
        end
    end
end

NumberOfOpaka450WithPingsBy30DayTag=zeros(1,length(ThirtyDayBins450);
for i=1:length(ThirtyDayBins450);
    NumberOfOpaka450WithPingsBy30DayTag=sum(isnan(Opakapaka450DetectionMatrix(:,i))==0);
end

NumberOfOpaka539WithPingsBy30DayTag=zeros(1,length(ThirtyDayBins539);
for i=1:length(ThirtyDayBins539);
    NumberOfOpaka539WithPingsBy30DayTag=sum(isnan(Opakapaka450DetectionMatrix(:,i))==0);
end

[R,~]=size(Opakapaka450DetectionMatrix);

y=(['Number of tags still known to be active. (', num2str(R) , 'Deployed tags)']);
figure
hist(NumberOfOpakapaka450WithPingsBy30DayTag)
ylabel=(y);
xlabel='In 30 Day Incraments';
title='How Long Are Tags Detected? (450 Interval Tags)';
print('Figure 1')

[R,~]=size(Opakapaka539DetectionMatrix);

y=(['Number of tags still known to be active. (', num2str(R) , 'Deployed tags)']);
figure
hist(NumberOfOpakapaka539WithPingsBy30DayTag)
ylabel=(y);
xlabel='In 30 Day Incraments';
title='How Long Are Tags Detected? (539 Interval Tags)';
print('Figure 2')
