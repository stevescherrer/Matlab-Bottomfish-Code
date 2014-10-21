%%%%Code to determine the average amount of time a tagged fish spends
%%%%either within or outside the BAFR MPA. 

%%Written By Stephen Scherrer
%%9 September 2013

%Updates in v_2_0
    %Code updated to work with new WorkingDatabaseForAllCode program

%Notes:
%%Before running this code, Run latest version of
%%WorkingDatabaseForAllCode to generate BottomFish variable

%%Code outputs summary statistics for both individuals and total cohort

%StateChangeStatisticsByTagID
%%First Column=Tag ID
%%Second Column=Average Time in BAFR
%%Third Column=Percentage of total time in BAFR relative to all time
%%Fourth Column=Percentage of total time in for individual spent in relative to
%%cohort for all time spent in
%%Fifth Column=percentage of total time for an individual spent in relative
%%to cohort for all time
%%sixth Column=Average time outside of BAFR
%%seventh Column=Percentage of total time outside of BAFR
%%eigth Column=Percentage of total time out for an individual relative to
%%all time out for cohort
%%nineth Column=percentag of total time out for an individual relative to
%%all time for cohort 

%%CohortStatistics is the same as above but as an average of all
%%individuals



%%limitations of code: Dependent on dataset available. movements not
%%detected by a monitor obviously cannot count and thus don't change a
%%fish's state. Use Martin's paper to discuss what the confidence is

tic

%%Load(BottomFish)

%%Notes on BottomFish
    %%Column 1=Tag ID
    %%Column 2=Date&Time
    %%Column 3=Reciever ID(1=Barber Flats, 2=Base3rdFinger, 3=Diamond Head
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

%%Pulling out a list of Tag IDs associated with individuals
Tags=unique(BottomFish(:,1));

%%Creating matrix for all Statistic Data to be fed
StateChangeStatisticsByTagID=zeros(length(Tags),9);
StateChangeStatisticsByTagID(:,1)=Tags;

%%Determining movements which change an individual's state (ie: into or out
%%of BAFR)

InAndOut=[];

for i=1:length(Tags) %Indexes Tag IDs
    DetectionsForAnIndividual=BottomFish(BottomFish(:,1)==Tags(i),:); %Pulls out list of individual tags
    [y,~]=size(DetectionsForAnIndividual); %Determines total number of tags
    InAndOut=[InAndOut;DetectionsForAnIndividual(1,:)]; 
        for r=2:y;
            if y>0
                 if DetectionsForAnIndividual(r,6)~=DetectionsForAnIndividual(r-1,6)
                InAndOut=[InAndOut;DetectionsForAnIndividual(r,:)];
                end
            end
        end
end

clearvars i y x r DetectionsForAnIndividual

%%Determining average time an individual spends in either an in or an out
%%state. aka computing second and fifth columns of
%%StateChangeStatisticsByTagID


for i=1:length(Tags)
    IndividualStateTimes=InAndOut(InAndOut(:,1)==Tags(i),:);
    [y,~]=size(IndividualStateTimes); %%indexes Individual State Times for each Tag ID
    if y>=2
        StateTimes=zeros(y,1); %%Sets up counter for determining averages for each individual
        MeanTimeIn=[];
        MeanTimeOut=[];
        TotalTime=[];
            for t=2:y;
                if IndividualStateTimes(t,8)==1  %%if the proceeding row indicated the individual was out of BAFR and now the individual is in BAFR
                    MeanTimeOut=[MeanTimeOut;IndividualStateTimes(t,2)-IndividualStateTimes(t-1,2)];
                elseif IndividualStateTimes(t,8)==0 %%if proceeding row indicated the individual was in BAFR
                    MeanTimeIn=[MeanTimeIn;IndividualStateTimes(t,2)-IndividualStateTimes(t-1,2)];
                end
            end
            if isnan(sum(MeanTimeIn)/length(MeanTimeIn))==0
                StateChangeStatisticsByTagID(i,2)=sum(MeanTimeIn)/length(MeanTimeIn); %%sums all time intervals the individual went from an in detection to an out detection and divides by the total number of events for an average, then fills in second column of StateChangeStatisticsByTagID for appropriate individual
            end
            if isnan(sum(MeanTimeOut)/length(MeanTimeOut))==0
                StateChangeStatisticsByTagID(i,6)=sum(MeanTimeOut)/length(MeanTimeOut);%%does same as above but for time spent out of BAFR
            end
    end
end
  



clearvars i t x y 

%%Determing percentage of total an Individual spends in In state or Out
%%State aka third and seventh columns of StateChangeStatisticsByID


for i=1:length(Tags)
    if StateChangeStatisticsByTagID(i,2)>0 || StateChangeStatisticsByTagID(i,6)>0
        StateChangeStatisticsByTagID(i,3)=StateChangeStatisticsByTagID(i,2)/(StateChangeStatisticsByTagID(i,2)+StateChangeStatisticsByTagID(i,6));
        StateChangeStatisticsByTagID(i,7)=StateChangeStatisticsByTagID(i,6)/(StateChangeStatisticsByTagID(i,2)+StateChangeStatisticsByTagID(i,6));
    end
end

%%Determining averages relative to Total Cohort aka columns 4 and 8
CohortMeanTimeIn=sum(StateChangeStatisticsByTagID(:,2))/length(Tags);
CohortMeanTimeOut=sum(StateChangeStatisticsByTagID(:,6))/length(Tags);

for i=1:length(Tags);
    StateChangeStatisticsByTagID(i,4)=StateChangeStatisticsByTagID(i,2)/CohortMeanTimeIn;
    StateChangeStatisticsByTagID(i,8)=StateChangeStatisticsByTagID(i,6)/CohortMeanTimeOut;
end

clear i 

%%Determing average time in or out compared to total cohort aka columns 5
%%and 9
CohortTotalTime=CohortMeanTimeIn+CohortMeanTimeOut;
for i=1:length(Tags);
    if StateChangeStatisticsByTagID(i,2)>0 || StateChangeStatisticsByTagID(i,6)>0
        StateChangeStatisticsByTagID(i,5)=StateChangeStatisticsByTagID(i,2)/CohortTotalTime;
        StateChangeStatisticsByTagID(i,9)=StateChangeStatisticsByTagID(i,6)/CohortTotalTime;
    end
end

clear i

%%Table for Cohort Statistics
%%

CohortStatistics=zeros(1,9);
CohortStatistics(1)=NaN;
CohortStatistics(2)=sum(StateChangeStatisticsByTagID(:,2))/length(Tags);
CohortStatistics(3)=sum(StateChangeStatisticsByTagID(:,3))/length(Tags);
CohortStatistics(4)=sum(StateChangeStatisticsByTagID(:,4))/length(Tags);
CohortStatistics(5)=sum(StateChangeStatisticsByTagID(:,5))/length(Tags);
CohortStatistics(6)=sum(StateChangeStatisticsByTagID(:,6))/length(Tags);
CohortStatistics(7)=sum(StateChangeStatisticsByTagID(:,7))/length(Tags);
CohortStatistics(8)=sum(StateChangeStatisticsByTagID(:,8))/length(Tags);
CohortStatistics(9)=sum(StateChangeStatisticsByTagID(:,9))/length(Tags);

%%%AllStatistics=CohortStatistics followed by Statistics for each
%%%individual ID

AllStatistics=[CohortStatistics;StateChangeStatisticsByTagID];

toc
