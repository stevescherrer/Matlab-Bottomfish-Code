%%%%Program to determine number of movements individually tagged fish make
%%%%into and out of the BRFA MPA in 1 week intervals. 

%%Written by Stephen Scherrer
%%Completed 6 September 2013
%%All Rights Preserved, All Wrongs Traversed

%%Updates in V_2_2
    %code no longer self creates BottomFish from matrix, now relies on
    %BottomFish variable produced in WorkingDatabaseForAllCode Program

%%%%This data is output in a matrix 
%%%%called BRFAMovements. NaNs indicate a period with no detections. A zero
%%%%indicates a detection without a state change (in to out or out to in)
%%%%an interger represents the number of state changes recorded.

%%%%READ ME%%%%
%%%%Before running code, BottomFish Matrix needs to be be generated from
%%%%program WorkingDatabaseForAllCode

tic

dbstop if error

%%%%Determing Movement rates in and out of BRFA for 1 week intervals

%%Building 1 week interval bins
mDate=round(min(BottomFish(:,2))+.5)-1;
MDate=round(max(BottomFish(:,2))+.5)-1;
IntervalTotal=(MDate-mDate)/7;

if IntervalTotal/round(IntervalTotal)==7
    Bins=linspace(mDate,MDate,IntervalTotal);
elseif IntervalTotal/round(IntervalTotal)~=7
    Bins=[linspace(mDate,MDate,IntervalTotal),MDate];
end

clearvars mDate MDate IntervalTotal

%%%Building a matrix to fill with transient movements in and out of
%%%BRFA
    
BRFAMovements=zeros(length(Tags),length(Bins));
    
%%filling in number of movements for each Tag ID

%%pulling just movements in or out, ignoring multiple ins or outs

InAndOut=[];

%%%% DEBUG THIS BITCH!
for i=1:length(Tags) %%indexes Tag length
        Fish=BottomFish(BottomFish(:,1)==Tags(i),:); %%pulls data by tag
        [y,~]=size(Fish); %%indexing size of matrix fish
    
%%%% First detection is equivilant to "Normal" aka "Tag
%%%% State" of fish and does not contribute to movement count, only serves
%%%% as reference for second detection/change in state. Hence the following
%%%% line has been dissabled

    %InAndOut=[InAndOut;Fish(1,:)] %% seeds InAndOut matrix with first detection of fish at a monitor
    
    for a=2:y
        if Fish(a,8)~=Fish(a-1,8);
            InAndOut=[InAndOut;Fish(a,:)];
        end
    end
end
clearvars i a x y Fish 

%%%% InAndOut is a matrix of just movements into or out of the MPA. All
%%%% other detections don't count. Next step is to code a for statement to
%%%% bin these movements.



for i=1:length(Tags)
    fish=InAndOut(InAndOut(:,1)==Tags(i),:);
    for b=1:length(Bins)-1
        [f,F]=size(fish);
        for F=1:f
            if fish(F,2)>=Bins(b) && fish(F,2)<Bins(b+1)
                BRFAMovements(i,b)=BRFAMovements(i,b)+1;
            end
        end
    end
end
clearvars i fish b f F InAndOut

%%%Accounting for an individual at the same monitor over an interval who
%%%doesn't change location but is detected. 

BRFAMovements(BRFAMovements==0)=NaN;  %%%Zeros were used in previous database to allow counting. Now changing all zeros to NaNs.

    %%%Pulling all movement data for a tag where individual stays at the same
    %%%monitor

DetectionsWithoutMovements=[];

for i=1:length(Tags)
    Subset=BottomFish(BottomFish(:,1)==Tags(i),:);  %%pulls subset data for each individual
    [y,~]=size(Subset);
    for s=2:y
        if Subset(s,4)==Subset(s-1,4) %%if monitor at which detection occurred is same as the one that proceeds it
                DetectionsWithoutMovements=[DetectionsWithoutMovements;Subset(s,:)];
        end
    end
end
clearvars i Subset y x s


%%Building a ghost matrix same dimensions as BRFAMovements but with NaNs to fill in with
%%zeros for bins where detections occur.
BRFAMovementsGhost=NaN(size(BRFAMovements));

for i=1:length(Tags)
    Subset=DetectionsWithoutMovements(DetectionsWithoutMovements(:,1)==Tags(i),:);
    IndividualLine=NaN(1,length(Bins));
    [y,~]=size(Subset);
    for b=2:length(Bins)
        for a=1:y;
            if Subset(a,2)>=Bins(b-1) && Subset(a,2)<Bins(b);
                IndividualLine(b-1)=0;
            end
        end
    end
    BRFAMovementsGhost(i,:)=IndividualLine;
end

clearvars i Subset IndividualLine y x b a DetectionsWithoutMovements

%%%%Consolodating BRFAMovements and BRFAMovementsGhost so detections in
%%%%which no movements occur are indicated by zeros and bins with no
%%%%detections are indicated by NaNs

[y,x]=size(BRFAMovements); %%BRFAMovements and BRFAMovementsGhost are the same size

for i=1:y
    for a=1:x
        if isnan(BRFAMovements(i,a))==1;
            BRFAMovements(i,a)=BRFAMovementsGhost(i,a);
        end
    end
end

clearvars i a x y BRFAMovementsGhost Tags

save 'BottomFish'; save 'BRFAMovements'
            
toc
