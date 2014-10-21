%%Calculate guassian detection function from range testing data, determine
%%amount of overlap required for a fish species...

%%%%Written By Stephen Scherrer on 24 February 2014
%%%%All rights preserved, all wrongs traversed

tic
dbstop if error

%%%%NOTES:

%%%%RangeTesting
%performed with 2 strings of 3 tags each and 1 string of 3 receivers.

%First Tag String (Closest to Receiver String)
DepthTagString1=350; %in meters
LatOfTagString1=21.2359; %Latitude in decimal degrees
LonOfTagString1=-157.81622;%Longitude in decimal degrees
HeightOfTags1=[3,30,60]; %in meters of the seafloor
LowestTagID1=37942; %tagID of tag in bottom of string
MiddleTagID1=37943; %tag ID of tag in middle of string
HighestTagID1=37944; %tagID of tag at bottom of string
TagString1=[LowestTagID1,MiddleTagID1,HighestTagID1];

DepthTagString2=327;%in meters
LatOfTagString2=21.2386; %Latitude in decimal degrees
LonOfTagString2=-157.81958; %Longitude in decimal degrees
HeightOfTags2=[3,30,60]; %in meters of the seafloor
LowestTagID2=37945; %tagID of tag in bottom of string
MiddleTagID2=37946; %tag ID of tag in middle of string
HighestTagID2=37947; %tagID of tag at bottom of string
TagString2=[LowestTagID2,MiddleTagID2,HighestTagID2];

DepthReceiverString=308;%in meters
LatOfReceiverString=21.23623; %Latitude in decimal degrees
LonOfReceiverString=-157.81433; %Longitude in decimal degrees
HeightOfReceivers=[3,30,60]; %in meters of the seafloor
LowestReceiver=110286; %tagID of tag in bottom of string
MiddleReceiver=110243; %tag ID of tag in middle of string
HighestReceiver=104542; %tagID of tag at bottom of string
ReceiverString=[LowestReceiver,MiddleReceiver,HighestReceiver];

%%%%%%%%%%%%%%%%%END USER DEFINED VARIABLES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%Making Database from detection data

%%Converting detection dates to datenumbers
DateTime=VarName1;
DateTime(1)=[];
DateTime=datenum(DateTime);
%%standardizing detection dates to matlab format if in another date format
DateTime(:,1)=DateTime(:,1)+(datenum(2012,12,9,0,34,0)-min(DateTime)); %Assumes minimum value of dataset is 08/13/2011
DateTime(:,1)=DateTime(:,1)-((1./12).*10); %subtracts 10 hours from time to convert from GMT to HST

%%Converting recievers to numbers
TempReceiver=Receiver;
TempReceiver(1)=[];
[~,Suffix]=strtok(TempReceiver,'-');
[Rec,~]=strtok(Suffix,'-');

%For some reason Receiver number was brought in as text, this converts back
%to a number so a matrix can be formed.
VR2W=nan(length(Rec),1);

for i = 1:length(Rec)
VR2W(i) = str2num(cell2mat(Rec(i)));
end

%%Converting TagIDs to relevant part of tag ID (3-5 digit code)
TempTransmitter=Transmitter;
TempTransmitter(1)=[];
[~,Suffix]=strtok(TempTransmitter,'-');
[~,TagIDWithHyphen]=strtok(Suffix,'-');
[TagsSorted,~]=strtok(TagIDWithHyphen,'-');
TagID=nan(length(TagsSorted),1);

%For some reason TagID was brought in as text, this converts back
%to a number so a matrix can be formed.
for i = 1:length(TagsSorted)
TagID(i) = str2num(cell2mat(TagsSorted(i)));
end

clearvars 'Prefix' 'Suffix' 'SuffixNoHyphen' 'TagIDWithHyphen' 'Hyphen' 'Tags' 'i' clearvars Rec Suffix Hyphen i 

%%Consolodating variables
AllRangingData=[DateTime, VR2W, TagID];
AllTagIDs=[TagString1,TagString2];
DateTimeTestBegins=min(AllRangingData(:,1));
DateTimeTestEnds=max(AllRangingData(:,1));

%%Determining horizontal distance between strings of tags and string of recievers
[DistanceFromString1,~]=lldistkm([LatOfTagString1,LonOfTagString1],[LatOfReceiverString,LonOfReceiverString]); %%lldistkm gives distance between 2 lat and lon points as km, downloaded 24 feb 2014 from http://www.mathworks.com/matlabcentral/fileexchange/38812-latlon-distance
[DistanceFromString2,~]=lldistkm([LatOfTagString2,LonOfTagString2],[LatOfReceiverString,LonOfReceiverString]);
DistanceFromString1=DistanceFromString1*1000; %Converts from km to meters
DistanceFromString2=DistanceFromString2*1000; %Converts from km to meters
%%Determining vertical distance between strings of tags and string of recievers
DepthOffsetString1=DepthTagString1-DepthReceiverString; %difference between deployment depths of tag string 1 and receiver string
DepthOffsetString2=DepthTagString2-DepthReceiverString; %difference between deployment depths of tag string 2 and receiver string
%%Creating matrix to represent distance between each tag and each receiver
DistanceBetweenTagString1AndReceiverString=nan(length(HeightOfTags1),length(HeightOfReceivers));
for i=1:length(HeightOfTags1);
    for a=1:length(HeightOfReceivers);
        DistanceBetweenTagString1AndReceiverString(i,a)=sqrt(DistanceFromString1^2+(HeightOfTags1(i)-HeightOfReceivers(a)+DepthOffsetString1)^2);
    end
end
DistanceBetweenTagString2AndReceiverString=nan(length(HeightOfTags2),length(HeightOfReceivers));
for i=1:length(HeightOfTags2);
    for a=1:length(HeightOfReceivers);
        DistanceBetweenTagString2AndReceiverString(i,a)=sqrt(DistanceFromString2^2+(HeightOfTags2(i)-HeightOfReceivers(a)+DepthOffsetString2)^2);
    end
end

%%Building TagAndReceiverData matrix to contain all data
%Column 1=TagID
%Column 2=Distance to lowest receiver 
%Column 3=Distance to middle reciever
%Column 4=Distance to highest receiver
%Column 5=Tag Transmission Interval (Ping Rate)
TagsAndReceiverDataTop=[TagString1',DistanceBetweenTagString1AndReceiverString];
TagsAndReceiverDataBottom=[TagString2',DistanceBetweenTagString2AndReceiverString];
TagsAndReceiverData=[TagsAndReceiverDataTop;TagsAndReceiverDataBottom];
[H,~]=size(TagsAndReceiverData); %indexes number of rows (ie:number of receivers)
TagsAndReceiverData=[TagsAndReceiverData,nan(H,1)]; %adds a new column (column 5) to that matrix.
clear TagsAndReceiverDataTop TagsAndReceiverDataBottom

%%%%Counting Detections for each tag at each receiver

%Determing Real Ping Interval of each tag (vemco tags ping at slightly different interval offset by a couple
%seconds, could have implications for overal values if this is assumed as manufacturer spec.)

for i=1:length(TagsAndReceiverData); %indexes TagString1
    for a=1:length(ReceiverString);
    SpecificReceiver=AllRangingData(AllRangingData(:,2)==ReceiverString(a),:); %pulls just one receiver record
    TagAtReceiver=SpecificReceiver(SpecificReceiver(:,3)==TagsAndReceiverData(i,1),:); %pulls transmissions associated with those tag numbers
    TagsAndReceiverData(i,5)=min(diff(TagAtReceiver(:,1))); %determines difference between detections and selects smallest detection interval 
    end
end

%%%Determining number of pings in the study period

StudyPeriodBegins=round(DateTimeTestBegins+.5); %Starts keeping track of study period the day after rigs deployed
StudyPeriodEnds=round(DateTimeTestEnds+.5)-1; %starts ends study period the day before rig recovered

DaysInTest=StudyPeriodEnds-StudyPeriodBegins; %determining total number of days for range test
ActualDatesInTest=StudyPeriodBegins:StudyPeriodEnds; %determine the actual dates of range test

PingsPerDay=ones(length(AllTagIDs),1); %number of pings per day (ones used because time of one day is 1 in matlab date)

[H,~]=size(TagsAndReceiverData); %sizes Tags and Receiver Data
for i=1:H;
    PingsPerDay(i)=PingsPerDay(i)./TagsAndReceiverData(i,5); %number of pings per day equivilant one day divided by the specific ping interval in seconds of each tag
end



%%Determining number of pings detected at each receiver

%%Will be 3 column matrix with Tag ID, Distance, and detection ratio. will
%%have several days data for each tag ID

AllRangingDataRounded=round(AllRangingData+.5)-1; %removes time leaving just detection date

AllDetectionRatesByDay=[];
for s=1:length(ReceiverString); %indexes receiver numbers for pulling out only data associated with a reciever
    DataByReceiver=AllRangingDataRounded(AllRangingDataRounded(:,2)==ReceiverString(s),:);
    [H,~]=size(TagsAndReceiverData);
        for i=1:H %indexes tag IDs to pull out only tag IDs associated with a receiver
        ReceiverDataByTag=DataByReceiver(DataByReceiver(:,3)==TagsAndReceiverData(i,1),:);
            for a=1:length(ActualDatesInTest); %indexes dates in test to pull out detections at a specific receiver by specific tag on specific day
                DailyDetections=ReceiverDataByTag(ReceiverDataByTag(:,1)==ActualDatesInTest(i),:);
                [h,~]=size(DailyDetections); %indexes number of detections that occured in that day bin.
                AllDetectionRatesByDay=[AllDetectionRatesByDay;TagsAndReceiverData(i,1),ReceiverString(s), ActualDatesInTest(a), h./PingsPerDay(i),TagsAndReceiverData(i,s+1)];%all detections by day becomes a matrix with TAG ID, Receiver ID, Date of Detection, % of pings recovered for that date, Distance to receiver for the tag
            end
        end
end


%%You Now should have a matrix called AllDetectionRatesByDay where
%Column 1: TagID
%Column 2: Receiver Number
%Column 3: Day of Detection
%Column 4: fraction of pings detected
%Column 5: Distance between Tag and Receiver


csvwrite('DiamondHeadRangeTestDataToFitInLoggerPro.csv',AllDetectionRatesByDay);
clearvars ActualDatesInTest AllDetectionRatesByDay AllRangingData AllRangingDataRounded AllReceiverData AllReceiverDataRounded AllTagIDs DailyDetections DataByReceiver DateTime DateTimeTestBegins DateTimeTestEnds DaysInTest DepthOffsetString1 DepthOffsetSTring2 DistanceBetweenTagString1AndReceiverString DistanceBetweenTagString2AndReceiverString DistanceFromString1 DistanceFromString2 HeightsOfReceivers Latitude Longitude LowestReciever PingIntervalOfTag PingsPerDay ReceiverDataByTag SensorUnit SensorValue SpecificReceiver StationName StudyPeriodBegins StudyPeriodEnds TagID TagAtReceiver TagsSorted TempTransmitter TransmitterName TransmitterSerial ValueOfASecond VR2W a ans h i s

%%TODO: fit distance and recovery data on a gaussian curve. Current
%%workflow uses LoggerPro to fit curve. Can this be done in matlab and if
%%so, how?

toc

%%%VERSION HISTORY
    
