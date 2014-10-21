%%%%Analyzing Data Collected from original Bottom Fish project for purpose
%%%%of further tag aquisition. 
%%%%Written By Stephen Scherrer on 18 December 2013
%%%%All rights preserved, all wrongs traversed


tic

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


%%%%Program to count number of detections of an individual at a monitor
%%%%during a detection event as defined by multiple detections occuring
%%%%within a given period of eachother. 


%%%%%%%%%%%%%%%%%%%VARIABLE ASSIGNMENT%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaximumAmmountOfTimeBetweenAny2Detections=0.5; %%As a fraction of a day

%%%%Program relies on the following variables.

%%BottomFish
%%%%%Notes on Outputed File
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
        
%Subsetting to just Opakapaka
Opakapaka=BottomFish(BottomFish(:,5)==2,:);
%%%%Analyzing Difference is Data Collected from original Bottom Fish project with both 150 and 180 second pinging tags for purpose
%%%%of further tag aquisition. 
%%%%Written By Stephen Scherrer on 18 December 2013
%%%%All rights preserved, all wrongs traversed


tic

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


%%%%Program to count number of detections of an individual at a monitor
%%%%during a detection event as defined by multiple detections occuring
%%%%within a given period of eachother. 


%%%%%%%%%%%%%%%%%%%VARIABLE ASSIGNMENT%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaximumAmmountOfTimeBetweenAny2Detections=0.5; %%As a fraction of a day

%%%%Program relies on the following variables.

%%BottomFish
%%%%%Notes on Outputed File
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
        



%%%%Determining How Many Pings Theoretically Sent Per Study Period by Species and 
%Aggregate

%%Tag Code Range     Average Seconds     Batery life (Days)
%%37935-37985        180                 539
%%57371-57470        150                 450
%%52142-52161        150                 450



Opakapaka=BottomFish(BottomFish(:,5)==2,:);

Opakapaka180Seconds=[];
Opakapaka150Seconds=[];

Tags150Seconds=37935:37985;
Tags180Seconds=[57371:57470,52142:52161];

for i=1:length(Tags150Seconds);
    TagMatch=Opakapaka(Opakapaka(:,1)==Tags150Seconds(i),:);
    Opakapaka150Seconds=[Opakapaka150Seconds;TagMatch];
end
for i=1:length(Tags180Seconds);
    TagMatch=Opakapaka(Opakapaka(:,1)==Tags180Seconds(i),:);
    Opakapaka180Seconds=[Opakapaka180Seconds;TagMatch];
end

%Detection vector of zeros with 15 bins. number of detections in a detection period will increase value of
%bin by 1. Histogram will be plotted from this.
Detections150=zeros(1,16);
LongestDetectionRun150=1;
%Counting detections
for i=1:length(TagID); %Index Tag IDs
    Individual=Opakapaka150Seconds(Opakapaka150Seconds(:,1)==TagID(i),:); %Pulls data on an individual
    [h,w]=size(Individual); % indexes all of the detections for that individual
    PingsWithinPeriod=1; %Establishes/Resets PingsWithinPeriod Counter for each individual
    if h==1; %if there is only one detection for that individual
        Detections150(h)=Detections150(h)+1; %the detection counter increases by one
    else
        for a=2:h; %if there is more than one detection, indexes that list of detections
            if Individual(a,2)-Individual(a-1,2)<=MaximumAmmountOfTimeBetweenAny2Detections && Individual(a,3)==Individual(a-1,3); %if a fish pings off the same receiver more than once without changing recievers in a given period of time
                PingsWithinPeriod=PingsWithinPeriod+1; %Advances counter by one
            else %if a detection is not within a given time frame of the last one or the receiver location changes
                if PingsWithinPeriod<15; %if the number of pings within that period is less than 15
                Detections150(PingsWithinPeriod)=Detections150(PingsWithinPeriod)+1; %increases appropriate spot on detection array by one
                if PingsWithinPeriod>LongestDetectionRun150;
                    LongestDetectionRun150=PingsWithinPeriod;
                end
                PingsWithinPeriod=1; %resets Pings within a period for next detection period
                else
                Detections150(16)=Detections150(16)+1; %if more than 15 detections, increases the last bin by 1 (last bin=15 or more)
                    if PingsWithinPeriod>LongestDetectionRun150;
                    LongestDetectionRun150=PingsWithinPeriod;
                end
                PingsWithinPeriod=1; %resets PingsWithinAPeriod for next detection period
                end
            end
        
        end
    end
end
clear individual


ValueOfASecond=(1/(3600/24));
Hours=MaximumAmmountOfTimeBetweenAny2Detections.*24;
Minutes=Hours.*60;
Seconds=Minutes.*60;

TimeTitle=[];
if Hours>1
    TimeTitle=Hours;
    Unit=' hours';
elseif Minutes>5
    TimeTitle=Minutes;
    Unit=' minutes';
else
    TimeTitle=Seconds;
    unit=' seconds';
end

FrequencyDetections150=Detections150./(sum(Detections150));

bar(FrequencyDetections150)
hold on
title(['Number of Detections within ', num2str(TimeTitle), Unit , 'of previous detection']);
xlabel('Number of Pings During A Detection Event');
ylabel('Number of Occurrences');


%Detection vector of zeros with 15 bins. number of detections in a detection period will increase value of
%bin by 1. Histogram will be plotted from this.
Detections180=zeros(1,16);
LongestDetectionRun180=1;
%Counting detections
for i=1:length(TagID); %Index Tag IDs
    Individual=Opakapaka180Seconds(Opakapaka180Seconds(:,1)==TagID(i),:); %Pulls data on an individual
    [h,w]=size(Individual); % indexes all of the detections for that individual
    PingsWithinPeriod=1; %Establishes/Resets PingsWithinPeriod Counter for each individual
    if h==1; %if there is only one detection for that individual
        Detections180(h)=Detections180(h)+1; %the detection counter increases by one
    else
        for a=2:h; %if there is more than one detection, indexes that list of detections
            if Individual(a,2)-Individual(a-1,2)<=MaximumAmmountOfTimeBetweenAny2Detections && Individual(a,3)==Individual(a-1,3); %if a fish pings off the same receiver more than once without changing recievers in a given period of time
                PingsWithinPeriod=PingsWithinPeriod+1; %Advances counter by one
            else %if a detection is not within a given time frame of the last one or the receiver location changes
                if PingsWithinPeriod<15; %if the number of pings within that period is less than 15
                Detections180(PingsWithinPeriod)=Detections180(PingsWithinPeriod)+1; %increases appropriate spot on detection array by one
                    if PingsWithinPeriod>LongestDetectionRun180
                    LongestDetectionRun180=PingsWithinPeriod;
                end
                PingsWithinPeriod=1; %resets Pings within a period for next detection period
                else
                Detections180(16)=Detections180(16)+1; %if more than 15 detections, increases the last bin by 1 (last bin=15 or more)
                    if PingsWithinPeriod>LongestDetectionRun180
                    LongestDetectionRun180=PingsWithinPeriod;
                end
                PingsWithinPeriod=1; %resets PingsWithinAPeriod for next detection period
                end
            end
        
        end
    end
end
clear individual


ValueOfASecond=(1/(3600/24));
Hours=MaximumAmmountOfTimeBetweenAny2Detections.*24;
Minutes=Hours.*60;
Seconds=Minutes.*60;

TimeTitle=[];
if Hours>1
    TimeTitle=Hours;
    Unit=' hours';
elseif Minutes>5
    TimeTitle=Minutes;
    Unit=' minutes';
else
    TimeTitle=Seconds;
    unit=' seconds';
end

FrequencyDetections180=Detections180./(sum(Detections180));

bar(FrequencyDetections180)
hold on
title(['Number of Detections within ', num2str(TimeTitle), Unit , 'of previous detection']);
xlabel('Number of Pings During A Detection Event');
ylabel('Number of Occurrences');

%%%IN THEORY... A TAG WITH A SHORTER INTERVAL SHOULD HAVE MORE DETECTIONS
%%%OF 2 OR MORE PER DETECTION PERIOD THAN A TAG WITH A LONGER INTERVAL. SO
%%%WE CAN DROP THE 1 PING PER INTERVAL NUMBER FROM EACH OF THE VECTORS.

FrequencyDetections150(1)=[];
FrequencyDetections180(1)=[];
DifferencesBetweenIntervalTypes=(FrequencyDetections150-FrequencyDetections180);

[h, p, ci, stats]=ttest(DifferencesBetweenIntervalTypes,0,'Tail','right')

[p,h,stats]=signrank(DifferencesBetweenIntervalTypes)

if p>.05;
    disp ('There is no significant difference between the proportion of multiple detections when comparing 150 and 180 second tags')
elseif p<.05;
    disp('Tags that ping every 150 seconds have a greater number of multiple detections than tags that ping every 180 seconds')
end

TagID=unique(Opakapaka(:,1));

%Detection vector of zeros with 15 bins. number of detections in a detection period will increase value of
%bin by 1. Histogram will be plotted from this.
Detections=zeros(1,16);

%Counting detections
for i=1:length(TagID); %Index Tag IDs
    Individual=Opakapaka(Opakapaka(:,1)==TagID(i),:); %Pulls data on an individual
    [h,w]=size(Individual); % indexes all of the detections for that individual
    PingsWithinPeriod=1; %Establishes/Resets PingsWithinPeriod Counter for each individual
    if h==1; %if there is only one detection for that individual
        Detections(h)=Detections(h)+1; %the detection counter increases by one
    else
        for a=2:h; %if there is more than one detection, indexes that list of detections
            if Individual(a,2)-Individual(a-1,2)<=MaximumAmmountOfTimeBetweenAny2Detections && Individual(a,3)==Individual(a-1,3); %if a fish pings off the same receiver more than once without changing recievers in a given period of time
                PingsWithinPeriod=PingsWithinPeriod+1; %Advances counter by one
            else %if a detection is not within a given time frame of the last one or the receiver location changes
                if PingsWithinPeriod<15; %if the number of pings within that period is less than 15
                Detections(PingsWithinPeriod)=Detections(PingsWithinPeriod)+1; %increases appropriate spot on detection array by one
                PingsWithinPeriod=1; %resets Pings within a period for next detection period
                else
                Detections(16)=Detections(16)+1; %if more than 15 detections, increases the last bin by 1 (last bin=15 or more)
                PingsWithinPeriod=1; %resets PingsWithinAPeriod for next detection period
                end
            end
        
        end
    end
end


ValueOfASecond=(1/(3600/24));
Hours=MaximumAmmountOfTimeBetweenAny2Detections.*24;
Minutes=Hours.*60;
Seconds=Minutes.*60;

TimeTitle=[];
if Hours>1
    TimeTitle=Hours;
    Unit=' hours';
elseif Minutes>5
    TimeTitle=Minutes;
    Unit=' minutes';
else
    TimeTitle=Seconds;
    unit=' seconds';
end


bar(Detections)
hold on
title(['Number of Detections within ', num2str(TimeTitle), Unit , 'of previous detection']);
xlabel('Number of Pings During A Detection Event');
ylabel('Number of Occurrences');

%%%%%%%%%%VERSION HISTORY%%%%%%%%%%%
%% V_0_2 Broke out tags by ping interval to compare by t-test if tags with shorter interval have more multiple detection events.

