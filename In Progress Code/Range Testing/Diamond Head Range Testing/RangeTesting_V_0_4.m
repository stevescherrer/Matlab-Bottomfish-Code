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
VR2W(i) = str2double(cell2mat(Rec(i)));
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
TagID(i) = str2double(cell2mat(TagsSorted(i)));
end

clearvars 'Prefix' 'Suffix' 'SuffixNoHyphen' 'TagIDWithHyphen' 'Hyphen' 'Tags' 'i' clearvars Rec Suffix Hyphen i 

%%Consolodating variables
AllRangingData=[TagID, DateTime, VR2W];
AllTagIDs=[TagString1,TagString2];
DateTimeTestBegins=min(AllRangingData(:,2));
DateTimeTestEnds=max(AllRangingData(:,2));
StudyPeriodBegins=round(DateTimeTestBegins+.5); %Starts keeping track of study period the day after rigs deployed
StudyPeriodEnds=round(DateTimeTestEnds+.5)-1; %starts ends study period the day before rig recovered
DaysInTest=StudyPeriodEnds-StudyPeriodBegins; %determining total number of days for range test
DateBins=StudyPeriodBegins:StudyPeriodEnds; %determine the actual dates of range test

%%Ranging Matrixes
%3 Matrixes each represent a receiver. Each matrix have 7 rows, and columns length of day bins, following rows are for each
%Tag, Each matrix is 4 Panes deep. First Pane is distance, Second is Pings
%Detected and Third is total pings sent fourth is recovery rate
RangingMatrix110286=zeros(6,length(DaysInTest),3);
RangingMatrix110243=zeros(6,length(DaysInTest),3);
RangingMatrix104542=zeros(6,length(DaysInTest),3);

%%First Pane of Detection Matrix
%Distance To tag

%%Determining horizontal distance between strings of tags and string of recievers
[DistanceFromString1,~]=lldistkm([LatOfTagString1,LonOfTagString1],[LatOfReceiverString,LonOfReceiverString]); %%lldistkm gives distance between 2 lat and lon points as km, downloaded 24 feb 2014 from http://www.mathworks.com/matlabcentral/fileexchange/38812-latlon-distance
[DistanceFromString2,~]=lldistkm([LatOfTagString2,LonOfTagString2],[LatOfReceiverString,LonOfReceiverString]);
DistanceFromString1=DistanceFromString1*1000; %Converts from km to meters
DistanceFromString2=DistanceFromString2*1000; %Converts from km to meters

%%Determining vertical distance between strings of tags and string of recievers
DepthOffsetString1=DepthTagString1-DepthReceiverString; %difference between deployment depths of tag string 1 and receiver string
DepthOffsetString2=DepthTagString2-DepthReceiverString; %difference between deployment depths of tag string 2 and receiver string

%%Pathagorean Theorum to figure out actual distance between receivers and
%%tags
DistanceBetweenTagString1AndReceiverString=nan(length(HeightOfTags1),length(HeightOfReceivers));
for i=1:length(HeightOfTags1);
    for a=1:length(HeightOfReceivers);
        DistanceBetweenTagString1AndReceiverString(i,a)=sqrt(DistanceFromString1^2+(HeightOfTags1(i)-HeightOfReceivers(a)+DepthOffsetString1)^2);
    end
end

DistanceBetweenTagString2AndReceiverString=zeros(length(HeightOfTags2),length(HeightOfReceivers));
for i=1:length(HeightOfTags2);
    for a=1:length(HeightOfReceivers);
        DistanceBetweenTagString2AndReceiverString(i,a)=sqrt(DistanceFromString2^2+(HeightOfTags2(i)-HeightOfReceivers(a)+DepthOffsetString2)^2);
    end
end

for i=2:length(DateBins);
    for h=1:length(TagString1);
        RangingMatrix110286(h,i-1,1)=DistanceBetweenTagString1AndReceiverString(h,1);
        RangingMatrix110243(h,i-1,1)=DistanceBetweenTagString1AndReceiverString(h,2);
        RangingMatrix104542(h,i-1,1)=DistanceBetweenTagString1AndReceiverString(h,3);
        RangingMatrix110286(h+3,i-1,1)=DistanceBetweenTagString2AndReceiverString(h,1);
        RangingMatrix110243(h+3,i-1,1)=DistanceBetweenTagString2AndReceiverString(h,2);
        RangingMatrix104542(h+3,i-1,1)=DistanceBetweenTagString2AndReceiverString(h,3);
    end
end

%%Second Pane of Detection Matrix
%Received Tranmissions
Detections110286=AllRangingData(AllRangingData(:,3)==110286,:);
Detections110243=AllRangingData(AllRangingData(:,3)==110243,:);
Detections104542=AllRangingData(AllRangingData(:,3)==104542,:);
for i=2:length(DateBins);
    for h=1:length(AllTagIDs);
        IndividualTagDetections110286=Detections110286(Detections110286(:,1)==AllTagIDs(h),:);
        IndividualTagDetections110243=Detections110243(Detections110243(:,1)==AllTagIDs(h),:);
        IndividualTagDetections104542=Detections104542(Detections104542(:,1)==AllTagIDs(h),:);
        RangingMatrix110286(h,i-1,2)=sum(((IndividualTagDetections110286(:,2)>=DateBins(i-1))+(IndividualTagDetections110286(:,2)<DateBins(i)))==2);
        RangingMatrix110243(h,i-1,2)=sum(((IndividualTagDetections110243(:,2)>=DateBins(i-1))+(IndividualTagDetections110243(:,2)<DateBins(i)))==2);
        RangingMatrix104542(h,i-1,2)=sum(((IndividualTagDetections104542(:,2)>=DateBins(i-1))+(IndividualTagDetections104542(:,2)<DateBins(i)))==2);
    end
end

%3rd pane of Detection Matrix
%# of pings sent (Ping interval was 180 Seconds)
for i=2:length(DateBins);
    for h=1:length(AllTagIDs)
    RangingMatrix110286(h,i-1,3)=((((DateBins(i)-DateBins(i-1))*24)*60)*60)./180;
    RangingMatrix110243(h,i-1,3)=((((DateBins(i)-DateBins(i-1))*24)*60)*60)./180;
    RangingMatrix104542(h,i-1,3)=((((DateBins(i)-DateBins(i-1))*24)*60)*60)./180;
    end
end

%4th Pane of Detection Matrix
%Recovery Rates
RangingMatrix110286(:,:,4)=RangingMatrix110286(:,:,2)./RangingMatrix110286(:,:,3);
RangingMatrix110243(:,:,4)=RangingMatrix110243(:,:,2)./RangingMatrix110243(:,:,3);
RangingMatrix104542(:,:,4)=RangingMatrix104542(:,:,2)./RangingMatrix104542(:,:,3);


%%You Now should have a matrix called AllDetectionRatesByDay where
%Column 1: TagID
%Column 2: Receiver Number
%Column 3: Day of Detection
%Column 4: fraction of pings detected
%Column 5: Distance between Tag and Receiver

AllDetectionRatesByDay=[];
for h=1:length(AllTagIDs);
    for i=1:DaysInTest;
        AllDetectionRatesByDay=[AllDetectionRatesByDay;AllTagIDs(h),110286,DateBins(i),RangingMatrix110286(h,i,4),RangingMatrix110286(h,i,1);AllTagIDs(h),110243,DateBins(i),RangingMatrix110243(h,i,4),RangingMatrix104542(h,i,1);AllTagIDs(h),104542,DateBins(i),RangingMatrix104542(h,i,4),RangingMatrix104542(h,i,1)];
        AllDetectionDataMinusBottomReceiver=[AllDetectionRatesByDay;AllTagIDs(h),110243,DateBins(i),RangingMatrix110243(h,i,4),RangingMatrix104542(h,i,1);AllTagIDs(h),104542,DateBins(i),RangingMatrix104542(h,i,4),RangingMatrix104542(h,i,1)];
        AllDetectionsMinusBottomTag=AllDetectionRatesByDay(AllDetectionRatesByDay(:,1)~=37942,:);
        AllDetectionsMinusBottomTags=AllDetectionsMinusBottomTag(AllDetectionsMinusBottomTag(:,1)~=37945,:);
        AllDetectionsMinusBottomTagAndReceiver=AllDetectionDataMinusBottomReceiver(AllDetectionDataMinusBottomReceiver(:,1)~=37942,:);
        AllDetectionsMinusBottomTagsAndReceiver=AllDetectionsMinusBottomTagAndReceiver(AllDetectionsMinusBottomTagAndReceiver(:,1)~=37945,:);
    end
end


csvwrite('DiamondHeadRangeTestDataToFitInLoggerPro.csv',AllDetectionRatesByDay);
csvwrite('DiamondHeadRangeTestDataMinusBottomReceiverForLoggerPro.csv',AllDetectionDataMinusBottomReceiver);
csvwrite('DH_rangingMinusBottomTagsAndReceiver.csv',AllDetectionsMinusBottomTagsAndReceiver);
csvwrite('DH_RangingMinusBottomTags.csv',AllDetectionsMinusBottomTags);


clearvars ActualDatesInTest AllDetectionRatesByDay AllRangingData AllRangingDataRounded AllReceiverData AllReceiverDataRounded AllTagIDs DailyDetections DataByReceiver DateTime DateTimeTestBegins DateTimeTestEnds DaysInTest DepthOffsetString1 DepthOffsetSTring2 DistanceBetweenTagString1AndReceiverString DistanceBetweenTagString2AndReceiverString DistanceFromString1 DistanceFromString2 HeightsOfReceivers Latitude Longitude LowestReciever PingIntervalOfTag PingsPerDay ReceiverDataByTag SensorUnit SensorValue SpecificReceiver StationName StudyPeriodBegins StudyPeriodEnds TagID TagAtReceiver TagsSorted TempTransmitter TransmitterName TransmitterSerial ValueOfASecond VR2W a ans h i s

%%TODO: fit distance and recovery data on a gaussian curve. Current
%%workflow uses LoggerPro to fit curve. Can this be done in matlab and if
%%so, how?

toc

%%%VERSION HISTORY
%%V_0_4 Overhauled Whole damn thing. Still Produces same output however. 
    
