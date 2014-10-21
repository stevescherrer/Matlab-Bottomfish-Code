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
TagID=unique(Opakapaka(:,1));

%Detection vector of zeros with 15 bins. number of detections in a detection period will increase value of
%bin by 1. Histogram will be plotted from this.
Detections=zeros(1,16);

%Counting detections
for i=1:length(TagID); %Index Tag IDs
    Individual=Opakapaka(Opakapaka(:,1)==TagID(i),:); %Pulls data on an individual
    [h,w]=size(Individual); % indexes all of the detections for that individual
    PingsWithinPeriod=0; %Establishes/Resets PingsWithinPeriod Counter for each individual
    if h==1; %if there is only one detection for that individual
        Detections(h)=Detections(h)+1; %the detection counter increases by one
    else for a=2:h; %if there is more than one detection, indexes that list of detections
            if Individual(a,2)-Individual(a-1,2)<=MaximumAmmountOfTimeBetweenAny2Detections && Individual(a,3)==Individual(a-1,3); %if a fish pings off the same receiver more than once without changing recievers in a given period of time
                PingsWithinPeriod=PingsWithinPeriod+1; %Advances counter by one
            else %if a detection is not within a given time frame of the last one
                if Individual(a,2)-Individual(a-1,2)>MaximumAmmountOfTimeBetweenAny2Detections || Individual(a,3)~=Individual(a-1,3); %if a fish pings off the same receiver more than once without changing recievers in a given period of time
                    PingsWithinPeriod=PingsWithinPeriod+1; %Advances counter by one
                end
                if PingsWithinPeriod<15; %if the number of pings within that period is less than 15
                Detections(PingsWithinPeriod)=Detections(PingsWithinPeriod)+1; %increases appropriate spot on detection array by one
                PingsWithinPeriod=0; %resets Pings within a period for next detection period
                else
                Detections(16)=Detections(16)+1; %if more than 15 detections, increases the last bin by 1 (last bin=15 or more)
                PingsWithinPeriod=0; %resets PingsWithinAPeriod for next detection period
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

