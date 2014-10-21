%%For Determining Placement of Receiver line

%%Pull bathymetry transect from Geomap App using
%%Basemaps>RegionalGrid>PacificRegion>Hawaii>SOESTMainHawaiianIslandsMultiBeamSynthesis50M
%%Save as ASCII Table
%import to matlab.

%%%%%%%%USER DEFINED PARAMETERS%%%%%%%%%%
UpperDepthLimit=-20; %in meters
LowerDepthLimit=-400; %in meters
HeightOfReceiverOffBottom=30; %in meters
Receiver12Percent=600; %Radius of receiver detection sphere where 12.5 percent of pings are picked up from range testing data
Receiver25Percent=700; %Radius of receiver detection sphere where 25 percent of pings are picked up from range test data
NumberOfReceiversToPlace=4; 
AcceptableDetectionDistanceFromCenterOfReceiver=[]; %%Distance Away from center of Receiver that tags must still be heard. if blank, assumed to be 50% of total radius
SwimSpeedOfStudySpecies=.5; %In m/s

%%%%%%%End USER DEFINED PARAMETERS%%%%%%%

IdealizedReceiverSpacing=(sqrt(2)/2)*Receiver12Percent;
FixedNumerOfReceivers=[];
FixedNumberOfReceiversRequired=[];
IdealReceiverSpacing=Receiver12Percent.*sqrt(2);

DistanceOfReceiverRangeAccountingForBottom=sqrt((Receiver25Percent^2)-(HeightOfReceiverOffBottom^2));

TransectIndex=find((Elevationm<UpperDepthLimit)+(Elevationm>=LowerDepthLimit)==2);
TransectBounds=[(Distancekm(TransectIndex).*1000) , Elevationm(TransectIndex), zeros(length(TransectIndex),3), Latitude(TransectIndex), Longitude(TransectIndex)]; %Builds new matrix Transect Bounds

TransectBounds(:,3)=[0;diff(TransectBounds(:,1))];
for i=2:length(TransectBounds)
    TransectBounds(i,4)=sqrt(((TransectBounds(i,1)-TransectBounds(i-1))^2)+((TransectBounds(i,2)-TransectBounds(i-1,2))^2));
end
    TransectBounds(i,5)=TransectBounds(i-1,5)+TransectBounds(i,4);
for i=2:length(TransectBounds)
    TransectBounds(i,4)=sqrt(((TransectBounds(i,1)-TransectBounds(i-1))^2)+((TransectBounds(i,2)-TransectBounds(i-1,2))^2));
    TransectBounds(i,5)=TransectBounds(i-1,5)+TransectBounds(i,4);
end
TransectBounds(:,1)=TransectBounds(:,1)-TransectBounds(1,1);
TransectIndex=find((Elevationm<UpperDepthLimit)+(Elevationm>=LowerDepthLimit)==2);
TransectIndex=[min(TransectIndex)-1;TransectIndex;max(TransectIndex)+1];

TransectBounds=[(Distancekm(TransectIndex).*1000) , Elevationm(TransectIndex), zeros(length(TransectIndex),3), Latitude(TransectIndex), Longitude(TransectIndex)]; %Builds new matrix Transect Bounds

%%Notes on TransectBounds
%Column 1=Distance in meters from point to point
%Column 2=Elevation change in meters
%Column 3=Horizontal distance change between points for each transect
%Column 4=line of sight distance from point to point accounting for both elevation and horizontal distance
%Column 5=Line of Sight distance changes from point to point
%Column 6=Latitude of Transect points
%Coulmn 7=Longitude of Transect Points


%%Filling in Column 3, 4, and 5 of transect bounds and zeroing column 1
TransectBounds(:,3)=[0;diff(TransectBounds(:,1))];
for i=2:length(TransectBounds)
    TransectBounds(:,1)=TransectBounds(:,1)-TransectBounds(1,1);
    TransectBounds(i,4)=sqrt(((TransectBounds(i,1)-TransectBounds(i-1))^2)+((TransectBounds(i,2)-TransectBounds(i-1,2))^2));
    TransectBounds(i,5)=TransectBounds(i-1,5)+TransectBounds(i,4);
end

%Accounting for 25% detection range on ends of receiver line being smaller than 12%
[R,~]=size(TransectBounds);
StartSightedTransect=TransectBounds(1,5)+DistanceOfReceiverRangeAccountingForBottom;
EndSightedTransect=TransectBounds(R,5)-DistanceOfReceiverRangeAccountingForBottom;

%%A Receiver is to be placed at the two following points (ends of the
%%fence)
[~,IndexStart]=min(abs(TransectBounds(:,5) - StartSightedTransect));
IndexStop=max(find(TransectBounds(:,5)<EndSightedTransect));

%%%For calculating positions of receivers if there was an assigned fixed
%%%number of receivers. 

%%Spacing receivers by number of receivers specified or by ideal spacing
%arrangement
ReceiverLineIndex=IndexStart:IndexStop;
ReceiverLine=TransectBounds(ReceiverLineIndex,:); %for only putting in distance that need to be spanned by the receiver fence
[R,~]=size(ReceiverLine); %determining maximum ReceiverLine index
if isempty(NumberOfReceiversToPlace); % if there is no restriction no receivers specified for number of receivers to place 
    NumberOfReceiversToPlace=round((((ReceiverLine(R,5)-ReceiverLine(1,5))+(2*IdealizedReceiverSpacing)+2*(Receiver12Percent-Receiver25Percent)))./(2.*IdealizedReceiverSpacing)); %determines the ideal number of receivers to place
end
DistancesOfReceiverLine=linspace(ReceiverLine(1,5),ReceiverLine(R,5),NumberOfReceiversToPlace); %places those receivers evenly


%%Determining which receivers are closest and figuring out Long Lats for
%that spot.

%%Notes on FenceLine
%%Column 1=sequential receiver number
%%Column 2=Distance between subsequent receivers
%%Column 3=Depth of that placement
%%Coulmn 4=Longitude of that placement
%%Column 5=Latitude of that Placement


FenceLine=[]; %makes/clears fence line variabe
for i=1:length(DistancesOfReceiverLine);
    LocationIndex1=max(find(ReceiverLine(:,5)<=DistancesOfReceiverLine(i)));
    LocationIndex2=LocationIndex1+1;
    if i==1;
        PercentageOfTotalDistance=0;
        DistanceToLocationIndex1=0;
        DistanceToLastReceiver=0;
        DistanceBetweenLocations=ReceiverLine(LocationIndex2,5)-ReceiverLine(LocationIndex1,5);
        DepthAtPlacement=ReceiverLine(LocationIndex1,2);
        ReceiverLatitude=ReceiverLine(LocationIndex1,6);
        ReceiverLongitude=ReceiverLine(LocationIndex1,7);
        DistanceToReceiverIndex2=DistanceBetweenLocations;
        OldIndex2=LocationIndex2;
    elseif i==length(DistancesOfReceiverLine);
        LocationIndex1=LocationIndex1-1;
        LocationIndex2=LocationIndex2-1;
        DistanceBetweenOldReceiverAndCurrentReceiverIndex1=(ReceiverLine(LocationIndex1,5)-ReceiverLine(OldIndex2,5))+DistanceToReceiverIndex2;
        DistanceBetweenLocations=ReceiverLine(LocationIndex2,5)-ReceiverLine(LocationIndex1,5);
        DistanceOfReceiverToLocation1=DistancesOfReceiverLine(i)-ReceiverLine(LocationIndex1,5);
        PercentageOfTotalDistance=DistanceOfReceiverToLocation1/DistanceBetweenLocations;
        DistanceToLastReceiver=DistanceBetweenOldReceiverAndCurrentReceiverIndex1+DistanceOfReceiverToLocation1;
        DepthAtPlacement=(ReceiverLine(LocationIndex2,2)-ReceiverLine(LocationIndex1,2))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,2);
        ReceiverLatitude=(ReceiverLine(LocationIndex2,6)-ReceiverLine(LocationIndex1,6))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,6);
        ReceiverLongitude=(ReceiverLine(LocationIndex2,7)-ReceiverLine(LocationIndex1,7))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,7);
    else
        DistanceBetweenOldReceiverAndCurrentReceiverIndex1=(ReceiverLine(LocationIndex1,5)-ReceiverLine(OldIndex2,5))+DistanceToReceiverIndex2;
        DistanceBetweenLocations=ReceiverLine(LocationIndex2,5)-ReceiverLine(LocationIndex1,5);
        DistanceOfReceiverToLocation1=DistancesOfReceiverLine(i)-ReceiverLine(LocationIndex1,5);
        PercentageOfTotalDistance=DistanceOfReceiverToLocation1/DistanceBetweenLocations;
        DistanceToLastReceiver=DistanceBetweenOldReceiverAndCurrentReceiverIndex1+DistanceOfReceiverToLocation1;
        DepthAtPlacement=(ReceiverLine(LocationIndex2,2)-ReceiverLine(LocationIndex1,2))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,2);
        ReceiverLatitude=(ReceiverLine(LocationIndex2,6)-ReceiverLine(LocationIndex1,6))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,6);
        ReceiverLongitude=(ReceiverLine(LocationIndex2,7)-ReceiverLine(LocationIndex1,7))*PercentageOfTotalDistance+ReceiverLine(LocationIndex1,7);
        DistanceToReceiverIndex2=DistanceBetweenLocations-DistanceOfReceiverToLocation1;
        OldIndex2=LocationIndex2;
    end
    FenceLine=[FenceLine; i, DistanceToLastReceiver, DepthAtPlacement, ReceiverLongitude, ReceiverLatitude];
end




csvwrite('FenceLine.csv',FenceLine);

%%%%Notes On Output File
%%Column 1=sequential receiver number
%%Column 2=Distance between subsequent receivers
%%Column 3=Depth of that placement
%%Coulmn 4=Longitude of that placement
%%Column 5=Latitude of that Placement

[R,~]=size(FenceLine);
RadiusOfOverlappingSphere=(sqrt((Receiver12Percent.^2)-((FenceLine(R,2)/2)^2)));

if isempty(AcceptableDetectionDistanceFromCenterOfReceiver)==1;
    AcceptableDetectionDistanceFromCenterOfReceiver=Receiver12Percent*(.50);
end

LengthOfAcceptableDetection=2*sqrt(RadiusOfOverlappingSphere^2-AcceptableDetectionDistanceFromCenterOfReceiver^2);

if isreal(RadiusOfOverlappingSphere)==0;
    disp ('Insufficient receivers to place a fence')
else
    if RadiusOfOverlappingSphere<=AcceptableDetectionDistanceFromCenterOfReceiver;
        disp('Insufficient receivers to place a fence')
    else
        MaximumTagInterval=LengthOfAcceptableDetection./SwimSpeedOfStudySpecies;
        disp(['The maximum ping interval in this configuration is ' , num2str(MaximumTagInterval), ' seconds'])
    end
end


%%%%%%%%%%VERSION%HISTORY%%%%%%%%%%%%%
%%V_0_3: Debugged and working????
%%V_0_2: Rewrote a bunch of logic after talking to astrid. this stuff sort
%%of makes sense now...I think.