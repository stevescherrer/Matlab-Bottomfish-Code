%%Determining the number of movements between Oahu and Penguin Banks for
%%Opakapaka


%%%%Written 23 January 2014 By Stephen Scherrer
%%%%All rights preserved, all wrongs traversed

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


%%%%Program relies on the following variables.

%%BottomFish (with 10 columns. Must run Percetage of Pings Detected first)
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
    %%Column 9=Tag Deployment Date
    %%Column 10=Expected Tag Death

%%ReceiverDates
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

BF=BottomFish;
BanksReceivers=[2,5,13,16,18]; %A list of the location IDs that corrospond to to receivers on Penguin Banks

[~,w]=size(BF);
if w~=10;
    disp 'BottomFish Matrix does not include tag deployment and expected battery death. Run PercentageOfPingsDetected before continuing'
end
clear w

Opakapaka=BF(BF(:,5)==2,:); %sorts out just Opakapaka from full detection database and removes any variables may have been added from other scripts
for i=1:length(Opakapaka);
    if sum(Opakapaka(:,4)==BanksReceivers)==1
    Opakapaka(i,8)=1;
    else
        Opakapaka(i,2)=0;
    end
end

%%Building matrix for output, 3 rows each column representing an individual
%%fish. matrix is as follows
%row 1=Number of recorded trips between Penguin Banks and Oahu 
%row 2=How long tag has been deployed on that individual
%row 3=Number of trips./How long tag deployed (for standardizing purposes)

TagID=unique(Opakapaka(:,1));
OpakapakaCrossingMatrix=zeros(4,length(TagID));
%%Filling in first row of crossing matrix with Tag ID
OpakapakaCrossingMatrix(1,:)=TagID';
%%Filling in second row of crossing matrix with length of time that tag has
%%been deployed.
OpakapakaCrossingMatrix(2,:)=s_changecounter(OpakaBanks,2)';
%%Filling in third row of crossing matrix with length of time that tag has been deployed.
%Determining maximum date in data set for working out how long tags have
%been deployed
IndividualMetaData=Opakapaka(unique(Opakapaka(:,1)),:);
if length(IndividualMetaData)~=length(OpakapakaCrossingMatrix);
    disp 'something has gone wrong with pulling one line of meta data for each individual'
else
    MaxDate=max(Opakapaka(:,2));
    for i=1:length(IndividualMetaData);
        if IndividualMetaData(i,10)<MaxDate; %if tag death is before last data recovery then the time of tag deployment is tag deployment subtracted from tag death
        OpakapakaCrossingMatrix(3,i)=IndividualMetaData(i,10)-IndividualMetaData(i,9);
        else
        OpakapakaCrossingMatrix(3,i)=MaxDate-IndividualMetaData(i,9); %if tag death is after last data recovery, then time of deployment is date tag deployment subtracted from date of last data recovery
        end
    end
end


%%Filling in fourth row with a "crossing index" equivilant to the number of crossings/amount of time tag has
%%been deployed
OpakapakaCrossingMatrix(4,:)=OpakapakaCrossingMatrix(2,:)./OpakapakaCrossingMatrix(3,:);

clear IndividualMetaData MaxDate i r a s t individual j TagID h w



