%%Building a working matrix (BottomFish) for all individuals with metadata to be the basis of all
%%future code. Also creates Receiver Dates Matrix for cross checking receiver information.
%Output organized By Tag number followed by Detection Date

%%Code stitched together from other projects on 28 Jan 2014
%%Written by Stephen Scherrer

%%All Rights Preserved All Wrongs Traversed


tic
dbstop if error
 
 
%%%%%%%%Building ReceiverDates Matrix%%%%%%%%

%%%FOR BUILDING RECEIVERDATES MATRIX FROM THE DEPLOYMENT RECOVERY LOG
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

    
    DateAdjustment=datenum(2011,10,01)-min(DEPLOYMENT_DATE); %determines date offset from any other date format
    AdjustedDeploymentDates=DEPLOYMENT_DATE+DateAdjustment; %creates new variable with this date adjustment for deployments
    AdjustedRecoveryDates=RECOVERY_DATE+DateAdjustment; %creates new variable with this date adjustment for recoveries
    
    TemporaryReceiverDates=[STEVES_ARBITRARY_LOCATION,VR2_SERIAL_NO,AdjustedDeploymentDates, AdjustedRecoveryDates, Lat_deg, Lat_min, Lon_deg, Lon_min];
    Addendum=nan(length(TemporaryReceiverDates),2);
    TemporaryReceiverDates=[TemporaryReceiverDates, Addendum];
    TemporaryReceiverDates(:,9)=TemporaryReceiverDates(:,5)+(TemporaryReceiverDates(:,6)./(60));
    TemporaryReceiverDates(:,10)=TemporaryReceiverDates(:,7)+(TemporaryReceiverDates(:,8)./(60));
    
    
    
    if length(TemporaryReceiverDates)==length(IN_DATA_SET);
        IndexOfReceiversWithData=IN_DATA_SET==1;
        ReceiverDates=TemporaryReceiverDates(IndexOfReceiversWithData,:);
        clear Addendum RECOVERY_DATE DateAdjustment CONSECUTIVE_DEPLOY_NO IndexOfReceiversWithData TemporaryReceiverDates AdjustedDeploymentDates AdjustedRecoveryDates AR_EXPECTED_BATTERY_LIFE AR_RELEASE_CODE AR_SERIAL_NO AR_VOLTAGE_AT_DEPLOY BOTTOM_DEPTH COMMENTS_DEPLOYMENT COMMENTS_RECOVERY CONSECUTIVE_DEPLOYMENTS DEPLOYED_BYLeadTechnician DEPLOYMENT_DATE DEPLOYMENT_TIME DATEADJUSTMENT Downloaded IN_DATA_SET Lat_deg Lon_deg Lat_min Lon_min RD RECOVER_DATE RECOVERY_TIME RecoveredBy SERVICED STATION_NO STEVES_ARBITRARY_LOCATION TempLoggerserial VR2_SERIAL_NO VarName26 VarName27 VarName28 VarName29 VarName30 i;
    else
        disp ('There is a size mismatch between ReceiverDates and IN_DATA_SET vectors. See DEPLOYMENT_AND_RECOVERY_LOG.csv and import for troubleshooting')
    end
   

%%Building a working matrix (BottomFish) for all individuals with metadata to be the basis of all
%%future code. Organized By Tag number followed by Detection Date

%%Code stitched together from other projects on 17 Septemeber 2013
%%Written by Stephen Scherrer

%%%%READ ME%%%%

%%Required Files
    %VUE Files combined into one (Column Vectors)
    %Bottomfish_Tag_Master (Column Vectors)
    %RecieverDates (Matrix)


%%%%Before running code, a matrix needs to be constructed from VUE cvs file 
%%%%Insturctions for building a working database for bottomfish
%%%%Load CSV data file from VUE into excell
%%%%Add latest CSV files to end of ongoing database
%%%%Save as updated CSV


%%Additionally build a TagSizeSex database CSV file by taking master file
%%and deleting all other columns, then turning sex into 1=female, 2=male
%%0=unknown.

%%Finally need to use Monitor Deployment file to determine locations

%%%%%Notes on Outputed File
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Reciever Location (1=Barber Flats, 2=Base3rdFinger, 3=Diamond Head
        %%Kaena Pocket, 4=Dropoff Inside, 5=First Finger, 6=Haleiwa,7=Kaena Pocket,
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
        





%%%%Clearing Data that is unused
clearvars Area AudioLogFile BladderVented Cannulation Capture_Lat_Deg Capture_Lon_Degrees Capture_Lat_min Capture_Lon_min Cohort Comments Conventional DNAClip Detections20130713 Dropshot EyesPopped Gutsample ID Length Notes PCLcm Photo PhotoName PointofIncision Recaptured Stomach Everted Tagger TissueSample VarName36 VarName37 VemTagType VemTagno VemTagType Video 

%%%%Converting CSV file into a working matrix

%%Converting detection dates to datenumbers
DateTime=VarName1;
DateTime(1)=[];
DateTime=datenum(DateTime);
%%standardizing detection dates to matlab format if in another date format
DateTime(:,1)=DateTime(:,1)+(datenum(2012,04,05,8,43,0)-min(DateTime)); %Assumes minimum value of dataset is 08/13/2011

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

clearvars Rec Suffix Hyphen i 

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

BottomFish=[];

for i=1:length(TagsSorted) %%indexes all Tag IDs
    x=Bottomfish(Bottomfish(:,1)==TagsSorted(i),:); %%Pulls data from master file one ID at a time
    [~,T]=sort(x(:,2));  %%Sorts data by Date/Time and indexes
    BottomFish=[BottomFish;x(T,:)]; %%Fills in variable BottomFish (note capitalization) with data arranged first by Tag ID, then by date time
end
clearvars i x R T %%Clears variables used in previous loop


%%Determining that previous loop worked
if size(Bottomfish)==size(BottomFish)==1  %%Since BottomFish is the same as Bottomfish but in a different order, if the sizes match, all data was coppied. 
    clear Bottomfish %%therefore unsorted data is deleated
elseif size(Bottomfish)~=size(BottomFish)==1
    disp 'Something Terrible has gone wrong between lines 31 and 36' %%if sizes don't match, spits out where things are iffy
end

%%%%%SOMETHING TERRIBLE HAS GONE WRONG. WHY ARE THERE SO MANY NANS IN FIRST
%%%%%COLUMN OF Bottomfish? %% Previous loop removes this data but at what
%%%%%cost? OH THE HUMANITY!

%%accounting for dead fish
%using dead fish to analyze receiver temporal data
DeadFish=BottomFish(BottomFish(:,1)==37969,:); %pulls out detections for fish 37969
DeadFishTimeBins=zeros(2,25); %makes matrix for times 24 hour days (extra bin for 24th hour to be removed later. 
DeadFishTimeBins(1,:)=linspace(0,1,25); %creates 25 time bins for counting hours
DeadFishDates=round(max(DeadFish(:,2)+.5))-1:round(min(DeadFish(:,2)+.5)-1); %for determining days of study period from earliest detection date to latest
DeadFishDateMatrix=zeros(round(max(DeadFish(:,2))-min(DeadFish(:,2))+.5),DeadFishTimeBins); %makes a matrix 25 columns long and length of number of days in study
for i=min(DeadFish(:,2)):max(DeadFish(:,2)); %indexes total nubmer of days dead fish transmitter has been transmitting
    DeadFishDateTimeBins=DeadFish(sum((DeadFish(:,2)>i-1)+(DeadFish(:,2)<i))==2,:); %pulls records associated with a single date
    for a=2:length(DeadFishDateTimeBins);%indexes those records that occured that day
         DeadFishTimes=DeadFishDateTimeBins(:,2)-(round(DeadFishDateTimeBins(:,2)+.5)-1); %subtracts full date and time from just the date to leave just time data
         DeadFishTimeDateMatrix(i,a)=sum(DeadFishTimes>=DeadFishTimeBins(1,a-1)+DeadFishTimes<DeadFishTimeBins(a)==2)./length(DeadFishDateTimeBins); %calculates frequency of detections of dead fish by hour and places them in appropriate bins as a fraction of 1
         [r,~]=size(DeadFishTimeDateMatrix); %finds number of dates in DeadFishTimeMatrix
         DeadFishTimes(2,a)=sum(DeadFishTimeDateMatrix(:,a))./r; %Divides summed detection rates by total number of days to return a fraction of 1 again.
    end
end
DeadFishTimeDateMatrix(:,25)=[]; % removes bin associated with hour 25 since that doesn't exist
p=anova1(DeadFishTimeDateMatrix); %performs 1 way ANOVA on daily detection ratios 
DeadFishTimeBins(:,25)=[];%removes 25th hour bin because there is no 25th hour...
figure %plots new figure
hist(DeadFishTimes(2,:),DeadFishTimes(1,:)); %plots histogram of detection frequency where DeadFishTimes(2,:) is proportion of detections for an hour bin and DeadFishTimes(1,:) is the hour bin. 
datetick %adds hour ticks
xlabel('Hour Bin') %labels x axis
ylabel('Frequency of Received Transmissions') %labels y axis
title('Percentage of Transmissions Received from a Tag in a Very Dead Fish By the Hour They Occured') %titles figure
mTextBox=uicontrol('style','text'); %creates a text box
TextBoxText=['One Way Anova P=',num2str(p)];
set(mTextBox,'string',TextBoxText)%creates a text box with anova results
print('Figure 1')

%removing the dead fish
BottomFish=BottomFish(BottomFish(:,1)~=37969,:); %%This fish is very dead right next to a receiver.


%%%%%%%CORROLATE RECEVIER NUMBER TO LOCATION?? 
%%%%%%%THIS NEEDS TO BE DONE ONCE LARGER ARRAYS IN PLACE

%%%%%Notes on Outputed File
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Receiver Location(1=Barber Flats, 2=Base3rdFinger, 3=Diamond Head
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
        
%%Determining location of reciever at which tag pinged (by matching to reciever dates)

        
%%Padding matrix for remaining information 
[Y,~]=size(BottomFish);
Addendum=nan(Y,5);
BottomFish=[BottomFish,Addendum];
clear Addendum

%%THE FOLLOWING 50 LINES HAVE BEEN SILENCED. DID NOT PRODUCE DESIRED
%%RESULTS AND HAVE NOW BEEN REPLACED WITH UNSILENCED CODE SECTION BELOW.

%%Reciever Location MetaData-Adjusting Dates from Excel
%ReceiverDeploymentsAndRecoveries=ReceiverDates;
%ReceiverDateAdjustment=(datenum(2011,10,01)-min(ReceiverDeploymentsAndRecoveries(:,3)));
%ReceiverDeploymentsAndRecoveries(:,4)=ReceiverDates(:,4)+ReceiverDateAdjustment;
%ReceiverDeploymentsAndRecoveries(:,3)=ReceiverDates(:,3)+ReceiverDateAdjustment;

%%Adjusting Receiver Recovery Date. If Date is NaN (ie: receiver is
%%deployed), sets recovery date to last detection for the sake of
%%processing.

%for i=1:length(ReceiverDeploymentsAndRecoveries);
 %   if isnan(ReceiverDeploymentsAndRecoveries(i,4))==1;
  %      ReceiverDeploymentsAndRecoveries(i,4)=max(BottomFish(:,2));
   % end
%end

%%Modifying Lat Long degrees in ReceiverDeploymentsAndRecoveries to Decimal
%%Degrees

%ReceiverDeploymentsAndRecoveries(:,5)=ReceiverDeploymentsAndRecoveries(:,5)+(ReceiverDeploymentsAndRecoveries(:,6)./(60));
%ReceiverDeploymentsAndRecoveries(:,6)=ReceiverDeploymentsAndRecoveries(:,7)+(ReceiverDeploymentsAndRecoveries(:,8)./(60));
%ReceiverDeploymentsAndRecoveries(:,8)=[];
%ReceiverDeploymentsAndRecoveries(:,7)=[];

%Removing Receivers with Missing Meta-Data
%ReceiverDeploymentsAndRecoveries=ReceiverDeploymentsAndRecoveries(isnan(ReceiverDeploymentsAndRecoveries(:,3))==0,:);
%ReceiverDeploymentsAndRecoveries=ReceiverDeploymentsAndRecoveries(isnan(ReceiverDeploymentsAndRecoveries(:,2))==0,:);

%%A new approach to an old problem
%%Assigning location to a detection and determining if it occured in or out
%%of BRFA
%for i=1:length(BottomFish);
 %   for a=1:length(ReceiverDeploymentsAndRecoveries);
  %      if BottomFish(i,3)==ReceiverDeploymentsAndRecoveries(a,2);
          %  if BottomFish(i,2)>=ReceiverDeploymentsAndRecoveries(a,3) && BottomFish(i,2)<=ReceiverDeploymentsAndRecoveries(a,4);
         %       BottomFish(i,4)=ReceiverDeploymentsAndRecoveries(a,1);
        %        if BottomFish(i,4)==9;
       %             BottomFish(i,8)=1;
      %          else
     %               BottomFish(i,8)=0;
    %            end
   %         end
  %      end
 %   end
%end

%for i=1:length(ReceiverDeploymentsAndRecoveries);
%   BottomFish(BottomFish(:,3)==ReceiverDeploymentsAndRecoveries(i,2),4)=ReceiverDeploymentsAndRecoveries(i,1);
%end

[h,~]=size(BottomFish); %indexing length of BottomFish Variable
[R,~]=size(ReceiverDates); %indexing length of ReceiverDates Variable

for i=1:h; %cycles down BottomFish
    for a=1:R; %cycles down ReceiverDates
        if BottomFish(i,3)==ReceiverDates(a,2) && BottomFish(i,2)>ReceiverDates(a,3) && BottomFish(i,3)<ReceiverDates(a,4); %%if receiver # is the same, detection occurred after receiver deployment and before receiver recovery
            BottomFish(i,4)=ReceiverDates(a,1); %Location for that entry is equivilant to corrosoponding receiver dates entry
        end
    end
end

clearvars h r a i
    
[A,L]=find(BottomFish(:,4)==9);
if A>0;
   disp ('finally found a fish in BRFA!, follow the following fish through the rest of this process')
    L(1)
else
    disp ('No Fish in BRFA. Theres no way this is possible so find fish with tag ID=57445')
end


%%If an individual is in BRFA column 6=1, if outside, column 6=0
for i=1:Y
    if BottomFish(i,4)==9
        BottomFish(i,8)=1;
    elseif BottomFish(i,4)~=9
        BottomFish(i,8)=0;
    end
end

clearvars X Y

%%%%% Determinging Species of each Tag ID

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
elseif BottomFish(i,1)==37942
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37943
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37944
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37945
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37946
BottomFish(i,5)=2;
elseif BottomFish(i,1)==37947
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
elseif BottomFish(i,1)==37964
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
for i=1:length(VemTagCode);
    BottomFish(BottomFish(:,1)==VemTagCode(i,1),7)=TempSex1(i,1);
    BottomFish(BottomFish(:,1)==VemTagCode(i,1),6)=FLcm(i,1);
end
    
%for i=1:length(VemTagCode);
 %   for a=1:length(BottomFish);
   %     if VemTagCode(i,1)==BottomFish(a,1);
      %      BottomFish(a,6)=FLcm(i,1);
        %    BottomFish(a,7)=TempSex1(i,1);
        %end
   % end
%end

for i=1:length(BottomFish);
    if BottomFish(i,6)==0;
        BottomFish(i,6)=NaN;
    end
end

%%Removing duplicate detections
DatesUnsorted=unique(BottomFish(:,2));
DatesSorted=sort(DatesUnsorted);

BFD=[];
for i=1:length(DatesSorted);
    BFD=[BFD;BottomFish(BottomFish(:,2)==DatesSorted(i),:)];
end

TagsUnsorted=unique(BFD(:,1));
TagsSorted=sort(TagsUnsorted);

BFT=[];
for i=1:length(TagsSorted);
    BFT=[BFT;BFD(BFD(:,1)==TagsSorted(i),:)];
end

IAmTheRemover=ones(length(BFT),1);

for i=2:length(BFT);
    if BFT(i,1)==BFT(i-1,1) && BFT(i,2)==BFT(i-1,2) && BFT(i,3)==BFT(i-1,3); %if tag ID, date/time, and receiver are all the same
        IAmTheRemover(i)=0; %changes from a 1 to a zero
    end
end

[Index,~]=find(IAmTheRemover(:,1)==1); 
OahuDatabase=BFT(Index,:); %only ones make up OahuDatabase

BottomFish=OahuDatabase(isnan(OahuDatabase(:,5))==0,:); %if There is a number associated with species for OahuDatabase, it counts as BottomFish

csvwrite('BottomFish.csv',BottomFish);

%clearvars DetectionsByTagIDThenDate UniqueDetectionsPerFish i NonDuplicateData Dates Tags BFT ReceiverDateAdjustment Latitude Longitude SensorUnit i SensorValue StationName TransmitterName TransmitterSerial B  FT BFD IAmTheRemover TagsUnsorted TagsSorted DatesUnsorted DatesSorted i j k r t s a l I J K R T S A L t T Index NonDuplicateData Index TagsSorted TagsUnsorted DatesSorted DatesUnsorted A L l s b i AdjustedReceiverDeploymentsAndRecoveries DateTime FLcm Receiver ReceiverDeploymentsAndRecoveries Sex Sex1 Species StomachEverted TagID Tags TempReceiver TempSex TempSex1 TempTransmitter TemporaryReceiverDates Time Transmitter  VarName1 a ans

save BottomFish 

toc

%%%%%Notes on Outputed File
%%%%%Name: BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID
    %%Column 4=Receiver Location (1=Barber Flats, 2=Base3rdFinger, 3=Diamond Head
        %%Pocket, 4=Dropoff Inside, 5=First Finger, 6=Haleiwa,7=Kaena Pocket,
        %%8=Kahuku, 9=Makapuu In BFRA, 10=Makapuu North, 11=Makapuu South,
        %%12=Marine Corps Base, 13=Pinnacle South, 14=Powerplant, 
        %%15=South of Ko Olina,16=South Tip, 17=SWAC, 18=The Mound, 19=Waianae,
        %%20=Cross Seamount, 21=Botcam Crew)
    %%Column 5=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, NaN=unknown)
    %%Column 6=Size (cm) if=NaN, information Unknown/Unavailable
    %%Column 7=Sex (1=Female, 2=Male, NaN=Unknown/Unavailable)
    %%Column 8=(Created in following section)=Presence in BRFA or out of BRFA.
        %%1 indicates individual detected in BAFR, 0 indicates detection outside
        %%BRFA
        
        
%%%%%%%%%%%%%%%%%%%%Version Updates%%%%%%%%%%%%%%%%%%%%%%
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
