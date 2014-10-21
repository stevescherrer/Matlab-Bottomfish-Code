%%%%Analyzing Data Collected from original Bottomfish project. To determine
%%%%The Maximum Swimming Speed Between Monitors.

%%%%Written By Stephen Scherrer on 20 November 2013
%%%%All rights preserved, all wrongs traversed



tic

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


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
    
%%RecieverDates
    %%Column 1=Reciever Location
    %%Column 2=Reciever Number
    %%Column 3=Deployment Date
    %%Column 4=Recovery Date
    %%Column 5=Deployment Latitude (prefix)
    %%Column 6=Deployment Latitude (degree minutes)
    %%Column 7=Deployment Longitude (prefix)
    %%Column 8=Deployment Longitude (degree minutes)
    %%Column 9=Deployment Longitude (prefix+decimal degrees)
    %%Column 10=Deployment Latitude (prefix+decimal Degrees)
    
    
    
 %% Building Time Between Detections Matrix

  TimeBetweenDetections=nan(length(BottomFish),6);
  
      %Notes on Time Between Detection Matrix
        %Column 1=Species
        %Column 2=Time between 2 recievers
        %Column 3=Time of First detection
        %Column 4=Time of Second detection
        %Column 5=Reciever number for First Detection
        %Column 6=Receiver number for Second Detection

%%Sorting detections by date
[~,DatesIndexed]=sort(BottomFish(:,2));

DateIndexedBottomFish=[];
for i=1:length(DatesIndexed);
    DateIndexedBottomFish=[DateIndexedBottomFish,BottomFish(DatesIndexed(i),:)];
end

%%Sorting detections by individual (in date order)
TagIndexedBottomFish=[];
Tags=unique(BottomFish(:,1));
for i=1:length(Tags);
    UniqueTagsPerIndividual=DateIndexedBottomFish(DateIndexedBottomFish(:,1)==Tags(i),:);
    TagIndexedBottomFish=[TagIndexedBottomFish;UniqueTagsPerIndividual];
end
clear UniqueTagsPerIndividual

%%Determining minimum time between any two receiver locations

for i=2:length(TagIndexedBottomFish);
    if TagIndexedBottomFish(i,1)==TagIndexedBottomFish(i-1) && TagIndexedBottomFish(i,3)~=TagIndexedBottomFish(i-1,3); %If same indivisual and location changes
        TimeBetweenDetections(i,1)=TagIndexedBottomFish(i,5);  %Species
        TimeBetweenDetections(i,2)=TagIndexedBottomFish(i,2)-TagIndexedBottomFish(i-1,2); %Time between Detections
        TimeBetweenDetections(i,3)=TagIndexedBottomFish(i-1,2); %Time of first detection
        TimeBetweenDetections(i,4)=TagIndexedBottomFish(i,2); %Time of second detection
        TimeBetweenDetections(i,5)=TagIndexedBottomFish(i-1,4); %Location of first detection
        TimeBetweenDetections(i,6)=TagIndexedBottomFish(i,4); %Location of second detection
    end
end
DetectionIntervals=TimeBetweenDetections(isnan(TimeBetweenDetections(:,1))==0,:);
clear TimeBetweenDetections

[~,Index]=min(DetectionIntervals(:,2));

ShortestIntervalBetweenTwoReceivers=DetectionIntervals(Index,:);
ShortestTimeBetweenTwoReceivers=DetectionIntervals(Index,2);

%Finding Lat and Long of Receivers that recorded first and second
%detections

for i=1:length(ReceiverDates);
    if ReceiverDates(i,1)==ShortestIntervalBetweenTwoReceivers(1,5) && ReceiverDates(i,3)<=ShortestIntervalBetweenTwoReceivers(1,3) && ReceiverDates(i,4)>=ShortestIntervalBetweenTwoReceivers(1,4);
        FirstDetectionLatitude=ReceiverDates(i,10);
        FirstDetectionLongitude=ReceiverDates(i,9);
    end
    if ReceiverDates(i,1)==ShortestIntervalBetweenTwoReceivers(1,6) && ReceiverDates(i,3)<=ShortestIntervalBetweenTwoReceivers(1,3) && ReceiverDates(i,4)>=ShortestIntervalBetweenTwoReceivers(1,4);
        SecondDetectionLatitude=ReceiverDates(i,10);
        SecondDetectionLongitude=ReceiverDates(i,9);
    end
end

DistanceDegreesLat=FirstDetectionLatitude-SecondDetectionLatitude;
if DistanceDegreesLat<0
    DistanceDegreesLat.*(-1);
end

DistanceDegreesLon=FirstDetectionLongitude-SecondDetectionLongitude;
if DistanceDegreesLon<0
    DistanceDegreesLon.*(-1);
end



DistanceMetersLat=DistanceDegreesLat.*110567; %Multiplys Distance calculated from lat and long degrees by a factor of 110567, an approximation of the number of meters in a degree of latitude and latitude are for equatorial locations. Source: http://geography.about.com/library/faq/blqzdistancedegree.htm
DistanceMetersLong=DistanceDegreesLon.*111.321;

TotalDistanceBetweenReceivers=sqrt(DistanceMetersLat^2.*DistanceMetersLong^2); %Pathagorean Theorum Bitch.



SecondsBetweenDetections=ShortestTimeBetweenTwoReceivers./(24.*60.*60); %Determines number of seconds inbetween detection interval by dividing difference in date number by 24(hours in a day) 60(minutes in an hour) and 60(seconds in a minute)
SwimRate=TotalDistanceBetweenReceivers./SecondsBetweenDetections; %final swim rate determined by distance between receivers and seconds between those detections.
DistanceRequiredBetweenReceivers150SecondIntervals=SwimRate*150 %Distancerequired between receivers to pick up tag intervals of 150 seconds
DistanceRequiredBetweenReceivers180SecondIntervals=SwimRate*180 %Distance required between receivers to pick up tag intervals of 180 secons
