%%Determining the number of pings recovered durring an presence event


%%%%Written 23 January 2014 By Stephen Scherrer
%%%%All rights preserved, all wrongs traversed

%%Determining Variables
TimeInterval=30; %%Define time interval in which to count detections, denoted in minutes

tic

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


%%%%Program relies on the following variable.

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
        
%%Determining what the perscribed interval is in datenum format
IntervalDecimal=(1./(24.*60.*60))*TimeInterval;
        
LessThanFivePingsPerInterval=0;
FiveOrMorePingsPerInterval=0;
OnePingPerInterval=0;
for i=2:(length(BottomFish))-1;
    if BottomFish(i,1)==BottomFish(i+1,1); %if tags match
        if BottomFish(i,3)==BottomFish(i+1,3); %%if receivers match
            if BottomFish(i,2)-BottomFish(i-1,2)>IntervalDecimal; %%if the time between two detections is greater than the time of the interval
            FishInInterval=BottomFish(BottomFish(:,3)>=BottomFish(i,3) && BottomFish(:,3)<=(BottomFish(i,3)+IntervalDecimal),:);
            [H,W]=size(FishInInterval);
                if H==1;
                OnePingPerInterval=OnePingPerInterval+1;
                elseif H>1 && H<5;
                LessThanFivePingsPerInterval=LessThanFivePingsPerInterval+1;
                elseif H>=5;
                FiveOrMorePingsPerInterval=FiveOrMorePingsPerInterval+1;
                end
            end
        end
    else OnePingPerInterval=OnePingPerInterval+1;
    end
end

LessThanFivePingsPerInterval
FiveOrMorePingsPerInterval
OnePingPerInterval
            
            
