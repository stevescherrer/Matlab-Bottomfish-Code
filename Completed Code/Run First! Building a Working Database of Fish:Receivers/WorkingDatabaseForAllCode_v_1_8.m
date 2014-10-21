%%ToDo: Fix location Lon Lat information. Right now this is poorly
%%% See Detection Statistics_KW for information about what tags are viable.


%%implemented. Also kind of cheating and wrong.

%%Building a working matrix (BottomFish) for all individuals with metadata to be the basis of all
%%future code. Also creates Receiver Dates Matrix for cross checking receiver information.
%Output organized By Tag number followed by Detection Date

%%Code stitched together from other projects on 28 Jan 2014
%%Written by Stephen Scherrer

%%All Rights Preserved All Wrongs Traversed


tic
dbstop if error
 
 
%%%%%%%%Building ReceiverDates Matrix%%%%%%%%

%%%FOR BUILDING RECEIVERDATES MATRIX FROM THE 
%RECOVERY LOG
%%WRITTEN 3 JANUARY 2014 IN A COFFEE SHOP IN CAMPBELL BY STEPHEN SCHERRER

%%NOTES: 
%%THIS PROGARM REQUIRES DEPLOYMENT_RECOVERY_LOG.CSV TO BUILD ReceiverDates,
%%A COMMON MATRIX USED IN MANY OTHER CODES. RUN THIS AFTER EVERY DATA
%%DOWNLOAD FROM THE FIELD TO UPDATE DATABASE.

%%NOTES ON OUTPUT FILE:
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

    
    DateAdjustment=datenum(2011,8,12)-min(DEPLOYMENT_DATE); %determines date offset from any other date format
    AdjustedDeploymentDates=DEPLOYMENT_DATE+DateAdjustment; %creates new variable with this date adjustment for deployments
    AdjustedRecoveryDates=RECOVERY_DATE+DateAdjustment; %creates new variable with this date adjustment for recoveries
    
    TemporaryReceiverDates=[STEVES_ARBITRARY_LOCATION,VR2_SERIAL_NO,AdjustedDeploymentDates, AdjustedRecoveryDates, Lat_deg, Lat_min, Lon_deg, Lon_min];
    Addendum=nan(length(TemporaryReceiverDates),2);
    TemporaryReceiverDates=[TemporaryReceiverDates, Addendum];
    
    for i = 1:length(TemporaryReceiverDates);
    if TemporaryReceiverDates(i,5)>1
        TemporaryReceiverDates(i,9)=TemporaryReceiverDates(i,5)+(TemporaryReceiverDates(i,6)./(60));
    else
        TemporaryReceiverDates(i,9)=TemporaryReceiverDates(i,5)-(TemporaryReceiverDates(i,6)./(60));
    end
    if TemporaryReceiverDates(i,7)>1
        TemporaryReceiverDates(i,10)=TemporaryReceiverDates(i,7)+(TemporaryReceiverDates(i,8)./(60));
    else
        TemporaryReceiverDates(i,10)=TemporaryReceiverDates(i,7)-(TemporaryReceiverDates(i,8)./(60));
    end
    end
   
    
    if length(TemporaryReceiverDates)==length(IN_DATA_SET);
        IndexOfReceiversWithData=IN_DATA_SET==1;
        ReceiverDates=TemporaryReceiverDates(IndexOfReceiversWithData,:);
        clear Addendum RECOVERY_DATE DateAdjustment CONSECUTIVE_DEPLOY_NO IndexOfReceiversWithData TemporaryReceiverDates AdjustedDeploymentDates AdjustedRecoveryDates AR_EXPECTED_BATTERY_LIFE AR_RELEASE_CODE AR_SERIAL_NO AR_VOLTAGE_AT_DEPLOY BOTTOM_DEPTH COMMENTS_DEPLOYMENT COMMENTS_RECOVERY CONSECUTIVE_DEPLOYMENTS DEPLOYED_BYLeadTechnician DEPLOYMENT_DATE DEPLOYMENT_TIME DATEADJUSTMENT Downloaded IN_DATA_SET Lat_deg Lon_deg Lat_min Lon_min RD RECOVER_DATE RECOVERY_TIME RecoveredBy SERVICED STATION_NO STEVES_ARBITRARY_LOCATION TempLoggerserial VR2_SERIAL_NO VarName26 VarName27 VarName28 VarName29 VarName30 i;
    else
        disp ('There is a size mismatch between ReceiverDates and IN_DATA_SET vectors. See DEPLOYMENT_AND_RECOVERY_LOG.csv and import for troubleshooting')
    end
   
%%Building a working matrix (BottomFish) for all individuals with metadata to be the basis of all
%%future code. Organized By Tag number followed by Detection Date

%%%%READ ME%%%%

%%%%%Notes on Outputed File
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Reciever Location (
        %OAHU RECEIVERS
            %1=Haleiwa, 
            %2=Kahuku, 
            %3=Marine Corps Base,
            %4=Makapuu North, 
            %5=Makapuu in BRFA, 
            %6=Makapuu South, 
            %7=Diamond Head,
            %8=SWAC, 
            %9=Barber's Flats, 
            %10=Ko'olina, 
            %11=Power Plant, 
            %12=Waianae,
            %13=Kaena, 
        %Penguin Banks Receivers
            %100=First Finger
            %101=Dropoff Inside
            %102=The Mound
            %103=Pinnacle South
            %104=Base 3rd Finger
            %105=South Tip
        %Cross Seamount Recievers=Receiver numbers 200-210
    %%Column 5=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, 0=unknown)
    %%Column 6=Size (cm)
    %%Column 7=Sex (1=Female, 2=Male, 0=Unknown)
    %%Column 8=(Created in following section)=Presence in BRFA or out of BRFA.
        %%1 indicates individual detected in BAFR, 0 indicates detection outside
        %%BRFA 
    %%Column 9=Date Tag Was Deployed
    %%Column 10=Date Tag is Expected to Die
    %%Column 11=Detection Longitude
    %%Column 12=Detection Latitude

%%%%Clearing unused metadata
 clearvars Area AudioLogFile BladderVented Cannulation Capture_Lat_Deg Capture_Lon_Degrees Capture_Lat_min Capture_Lon_min Cohort Comments Conventional DNAClip Detections20130713 Dropshot EyesPopped Gutsample ID Length Notes PCLcm Photo PhotoName PointofIncision Recaptured Stomach Everted Tagger TissueSample VarName36 VarName37 VemTagType VemTagno VemTagType Video 

%%%%Converting CSV file into a working matrix

%%Converting detection dates to datenumbers
DateTime=DateandTimeUTC;
DateTime=datenum(DateTime);

%%standardizing detection dates to matlab format if in another date format
DateTime(:,1)=DateTime(:,1)+(datenum(2011,08,13,8,38,0)-min(DateTime)); %Assumes minimum value of dataset is 08/13/2011

%%Converting recievers to numbers
TempReceiver=Receiver;
[~,Suffix]=strtok(TempReceiver,'-');
[Rec,~]=strtok(Suffix,'-');

%For some reason Receiver number was brought in as text, this converts back
%to a number so a matrix can be formed.
VR2W=nan(length(Rec),1);

for i = 1:length(Rec)
VR2W(i) = str2double(cell2mat(Rec(i)));
end

clearvars Rec Suffix Hyphen i 

%%Converting TagIDs to relevant part of tag ID (3-5 digit code)
TempTransmitter=Transmitter;
[~,Suffix]=strtok(TempTransmitter,'-');
[~,TagIDWithHyphen]=strtok(Suffix,'-');
[TagsSorted,~]=strtok(TagIDWithHyphen,'-');
TagID=nan(length(TagsSorted),1);

%For some reason TagID was brought in as text, this converts back
%to a number so a matrix can be formed.
for i = 1:length(TagsSorted)
TagID(i) = str2double(cell2mat(TagsSorted(i)));
end

clearvars 'Prefix' 'Suffix' 'SuffixNoHyphen' 'TagIDWithHyphen' 'Hyphen' 'Tags' 'i';

%building matrix for TagID, Detection Date, and Reciever Number
BF=[TagID, DateTime, VR2W];

%%Arranging Data By Tag
[~,Index]=sort(BF(:,1));
Bottomfish=BF(Index,:);

clear BF Index

%%Indexing a list of unique Tag IDs
TagsSorted=unique(Bottomfish(:,1));
TagsSorted=TagsSorted(isnan(TagsSorted)==0); %% I have no idea why this line is necessary.. for some reason the Tag ID list produces a shit ton of NaNs


%%Modifying Detection Times from GMT to HST
Bottomfish(:,2)=Bottomfish(:,2)-0.4167; %%adjusts times from BF file from GMT to HST by subtracting equivilant of 10 hours 

%%Arranging Data by date and time

BottomFish=zeros(size(Bottomfish));
counter=0;

for i=1:length(TagsSorted) %%indexes all Tag IDs
    x=Bottomfish(Bottomfish(:,1)==TagsSorted(i),:); %%Pulls data from master file one ID at a time
    [~,T]=sort(x(:,2));  %%Sorts data by Date/Time and indexes
    sortedBf=x(T,:);
    [H,~]=size(sortedBf);
    for M=1:H;
        counter=counter+1;
        BottomFish(counter,:)=x(M,:); %%Fills in variable BottomFish (note capitalization) with data arranged first by Tag ID, then by date time
    end
end
clearvars i x R T M sortedBf %%Clears variables used in previous loop


%%Determining that previous loop worked
if size(Bottomfish)==size(BottomFish)==1  %%Since BottomFish is the same as Bottomfish but in a different order, if the sizes match, all data was coppied. 
    clear Bottomfish %%therefore unsorted data is deleated
elseif size(Bottomfish)~=size(BottomFish)==1
    disp 'Something Terrible has gone wrong between lines 31 and 36' %%if sizes don't match, spits out where things are iffy
end

BottomFish=BottomFish(BottomFish(:,1)~=37969,:); %%This fish is very dead right next to a receiver.

%%Adding Meta Data

%%Padding matrix for remaining information 
[Y,~]=size(BottomFish);
Addendum=nan(Y,7);
BottomFish=[BottomFish,Addendum];
clear Addendum

[h,~]=size(BottomFish); %indexing length of BottomFish Variable
[R,~]=size(ReceiverDates); %indexing length of ReceiverDates Variable

for i=1:h; %cycles down BottomFish
    for a=1:R; %cycles down ReceiverDates
        if BottomFish(i,3)==ReceiverDates(a,2) && BottomFish(i,2)>ReceiverDates(a,3) && BottomFish(i,3)<ReceiverDates(a,4); %%if receiver # is the same, detection occurred after receiver deployment and before receiver recovery
           BottomFish(i,4)=ReceiverDates(a,1); %Location for that entry is equivilant to corrosoponding receiver dates entry
           BottomFish(i,11)=ReceiverDates(a,10); %Longitude for that entry is equivilant to corrosponding Longitude for receiver data
           BottomFish(i,12)=ReceiverDates(a,9); %Longitude for that entry is equivilant to corrosponding Longitude for receiver data
        end
    end
end

clearvars h r a i

%Confirming we have a fish in the BRFA
[A,L]=find(BottomFish(:,4)==5);
if A>0;
   disp ('finally found a fish in BRFA!, follow the following fish through the rest of this process')
    L(1)
else
    disp ('No Fish in BRFA. Theres no way this is possible so find fish with tag ID=57445')
end

%%If an detection is in BRFA column 8=1, if outside, column 6=0
for i=1:Y
    if BottomFish(i,4)==5
        BottomFish(i,8)=1;
    elseif BottomFish(i,4)==101
        BottomFish(i,8)=1;
    else
        BottomFish(i,8)=0;
    end
end


clearvars X Y

%Data from Bottomfish_Tag_Master.csv

for i=1:length(BottomFish) 
if BottomFish(i,1)==14412
BottomFish(i,5)=3;
elseif BottomFish(i,1)==37935
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37936
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37937
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37938
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37939
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37940
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37941
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37943
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37944
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37945
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37946
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37948
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37949
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37950
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37951
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37952
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37953
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37954
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37955
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37956
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37957
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37958
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37959
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37960
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37961
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37962
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37963
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37965
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37966
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37967
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37968
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37969
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37970
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37971
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37972
BottomFish(i,5)=4;
elseif BottomFish(i,1)==37973
BottomFish(i,5)=1;
elseif BottomFish(i,1)==37974
BottomFish(i,5)=1;
elseif BottomFish(i,1)==37975
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37976
BottomFish(i,5)=1;
elseif BottomFish(i,1)==37977
BottomFish(i,5)=1;
elseif BottomFish(i,1)==37978
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37979
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37980
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37981
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37982
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37983
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37984
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57445
BottomFish(i,5)=6;
elseif BottomFish(i,1)==57446
BottomFish(i,5)=5;
elseif BottomFish(i,1)==57447
BottomFish(i,5)=1;
elseif BottomFish(i,1)==57448
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57449
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57450
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57451
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57455
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57456
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57457
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57458
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57459
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57460
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57462
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57463
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57464
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57465
BottomFish(i,5)=2;
elseif BottomFish(i,1)==57466
BottomFish(i,5)=2;

 
    
    %%%%%%%%%ADD ANY ADDITIONAL TAGS
end
end


%%Adjusting Sex from string to vector
TempSex1=nan(length(Sex),1); %%This has to be created to convert sex from str to matrix
for i=1:length(Sex)
    if Sex{i}=='F';
        TempSex1(i)=1;
    elseif Sex{i}=='M';
        TempSex1(i)=2;
    else
        TempSex1(i)=0;
    end
end

%%Assigning Sex and Length to each entry of BottomFish
for i=1:length(Transmitter);
    BottomFish(BottomFish(:,1)==Transmitter(i,1),7)=TempSex1(i,1);
    BottomFish(BottomFish(:,1)==Transmitter(i,1),6)=FLcm(i,1);
end

for i=1:length(BottomFish);
    if BottomFish(i,6)==0;
        BottomFish(i,6)=NaN;
    end
end

%%%%Start Added April 28 2014

%Creating TagDate Variable
Date=(datenum(2012,08,18)-min(datenum(Date)))+datenum(Date);
TagDate=[VemTagCode, datenum(Date)];
%Creating a 9th and 10th Column for BottomFish Workspace 9th column for Tag Date, 10th for anticipated transmitter death.
Addendum=nan(length(BottomFish),2); %creates additional columns for BottomFish variable
BottomFish=[BottomFish,Addendum]; %adds these variables to Bottomfish matrix
clear Addendum %clears Addendum Variable
%%%Replacing zeros in column 9 of BottomFish with Tagging Date
for i=1:length(TagDate); %indexes previously created TagDate variable
    for b=1:length(BottomFish); %indexes all monitor detections
        if TagDate(i,1)==BottomFish(b,1); %if Tag IDs match
          BottomFish(b,9)=TagDate(i,2); %Tagging Date written to column 9 of BottomFish Variable
        end
    end
end
clear i b;
%%In this project, tags have been coded as follows:

%%Tag Code Range     Average Seconds     Batery life (Days)
%%57371-57470        150                 450
%%37935-37985        180                 539
%%52142-52161        150                 450

%Calculating Tag Death
for i=1:length(BottomFish); %indexes BottomFish matrix
	if BottomFish(i,1)>=57371 && BottomFish(i,1)<=57470;
		BottomFish(i,10)=BottomFish(i,9)+450;
	elseif BottomFish(i,1)>=37935 && BottomFish(i,1)<=37985;
		BottomFish(i,10)=BottomFish(i,9)+539;
	elseif BottomFish(i,1)>=52142 && BottomFish(i,1)<=52161;
		BottomFish(i,10)=BottomFish(i,9)+450;
	end
end

clearvars -except ReceiverDates BottomFish

%removing any duplicates
OahuDatabase=unique(BottomFish, 'rows');


%Breaking Out Tags By Species

Ehu=OahuDatabase(OahuDatabase(:,5)==1,:);
Opakapaka=OahuDatabase(OahuDatabase(:,5)==2,:);
Kalekale=OahuDatabase(OahuDatabase(:,5)==5,:);
%Onaga=OahuDatabase(OahuDatabase(:,5)==___,:);

BottomFish=[Ehu; Opakapaka; Kalekale];

save BottomFish 

%%%%%Notes on Outputed File
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Reciever Location 
        %OAHU RECEIVERS
            %1=Haleiwa, 
            %2=Kahuku, 
            %3=Marine Corps Base,
            %4=Makapuu North, 
            %5=Makapuu in BRFA, 
            %6=Makapuu South, 
            %7=Diamond Head,
            %8=SWAC, 
            %9=Barber's Flats, 
            %10=Ko'olina, 
            %11=Power Plant, 
            %12=Waianae,
            %13=Kaena, 
        %Penguin Banks Receivers
            %100=First Finger
            %101=Dropoff Inside
            %102=The Mound
            %103=Pinnacle South
            %104=Base 3rd Finger
            %105=South Tip
    %%Column 5=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, NaN=unknown)
    %%Column 6=Size (cm) if=NaN, information Unknown/Unavailable
    %%Column 7=Sex (1=Female, 2=Male, NaN=Unknown/Unavailable)
    %%Column 8=(Created in following section)=Presence in BRFA or out of BRFA.
        %%1 indicates individual detected in BAFR, 0 indicates detection outside
        %%BRFA
    %%Column 9=Date Tag Was Deployed
    %%Column 10=Date Tag is Expected to Die
        
        
%%%%%%%%%%%%%%%%%%%%Version Updates%%%%%%%%%%%%%%%%%%%%%%

%%Updates in V_1.8
    %Rewrote code to be a little easier to read/no longer thinks its a
    %function. 
%%Updates in V_1.7
    %%Added Tag date and tag death columns
    %%Updated receiver location indexes
%%Updates in V_1.6
    %%in V_1.5, tried to automatically import data files but this proved
    %%problematic so it has been removed until it can be debugged. Added
    %%code to use tag 37969, which is inside a very dead fish, to look at
    %%temporal differences in receiver detection range
%%Updats in V_1.2
    %%removes the same detections if vue file imported too many times. not
    %%sure how this wasn't done sooner...
%%Updates in v_1.0
    %%Code has been rewritten to eliminate excel data massage. Excel now only
    %%used to compile VUE files into one massive database. This step could
    %%possibly be simplified if all VUE data exported as one huge datadump.
%%Updates in v_0.6
    %corrected location data to reflect actual reciever files
%%Updates in v_0.5
    %added notation for BOTTOMFISHTAGDATA initial file


