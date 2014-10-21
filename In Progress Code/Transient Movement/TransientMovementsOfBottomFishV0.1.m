
%%%%Building a working database for bottomfish
%%%%Load CSV data file from VUE into excell
%%%%Change Date and time format to numbers
%%%%To pull tag codes and separate date and time, use function code
%%%%=(Right(cell number,number of digits to keep)) and 
%%%%=(Left(cell number,number of digits to keep)) respectively and sort into their own columns

tic

%%Arranging Data By Tag
[Tag,Index]=sort(BF(:,1));

for i=1:length(Index);
    Bottomfish=BF(Index,:);
end

clear i; clear Index; clear Tag;

%%Indexing a list of unique Tag IDs
Tags=unique(Bottomfish(:,1));

%%Adjusting from Excel date format to Matlab Dates
BottomFish(:,2)=BottomFish(:,2)+693960;  %%adjusts dates from BF file from excel to matlab

BottomFish(:,3)=BottomFish(Times)-10; %%adjusts times from BF file from GMT to HIST

%%Combining Date and time for easy viewing
BottomFish(:,2)=BottomFish(:,2)+BottomFish(:,3);

Bottomfish(:,3)=zeros

%%Arranging Data by date and time

BottomFish=[];

for i=Tags %%indexes all Tag IDs
    x=Bottomfish(Bottomfish(:,1)==Tags(i),:); %%Pulls data from master file one ID at a time
    [R,T]=sort(x(:,2));  %%Sorts data by Date/Time and indexes
    BottomFish=[BottomFish;x(T,:)]; %%Fills in variable BottomFish (note capitalization) with data arranged first by Tag ID, then by date time
end
clearvars i x R T %%Clears variables used in previous loop


%%Determining that previous loop worked
if size(Bottomfish)==size(BottomFish)==1  %%Since BottomFish is the same as Bottomfish but in a different order, if the sizes match, all data was coppied. 
    clear Bottomfish %%therefore unsorted data is deleated
elseif size(Bottomfish)~=size(BottomFish)==1
    disp 'Something Terrible has gone wrong between lines 31 and 36' %%if sizes don't match, spits out where things are iffy
end

%%%%%Notes on Working Matrix
%%%%%BottomFish
%%Column 1=Tag ID
%%Column 2=Date&Time
%%Column 3=Zeros
%%Column 4=Reciever ID
%%Column 5=Location of Reciever (1=Barber Flats, 2=Diamond Head, 3=Kaena
    %%Pocket, 4=Kahuku, 5=Ko Olina, 6=Makapuu[in BAFR],7=Makapuu S[Out of
    %%BAFR], 8=Makapuu N, 9=Mokapu, 10=Powerplant, 11=Waianae)
%%Column 6 (Created in following section)=Presence in BAFR or out of BAFR.
    %%1 indicates individual detected in BAFR, 0 indicates detection outside
    %%BAFR
    
%%Creating a 6th Column. the difference between in the BARF and out of it

[Y,X]=size(BottomFish);
Addendum=zeros(Y,1);
BottomFish=[BottomFish,Addendum];


for i=1:Y
    if BottomFish(i,5)==6
        BottomFish(i,6)=1;
    elseif BottomFish(i,5)~=6
        BottomFish(i,6)=0;
    end
end

    
%%%%Determing Movement rates in and out of BAFR for 1 week intervals

%%Building 1 week interval bins
mDate=round(min(BottomFish(:,2))+.5)-1;
MDate=round(max(BottomFish(:,2))+.5)-1;
IntervalTotal=(MDate-mDate)/7;

if IntervalTotal/Round(IntervalTotal)==7
    Bins=linspace(mDate,MDate,IntervalTotal);
elseif IntervalTotal/Round(IntervalTotal)~=7
    Bins=[linspace(mDate,MDate,IntervalTotal),MDate];
end

%%%Building a matrix to fill with transient movements in and out of
%%%BAFR
    
BAFRMovements=nan(length(Tags),length(Bins));
    
%%filling in number of movements for each Tag ID

%%pulling just movements in or out, ignoring multiple ins or outs

InAndOut=[]

for i=1:length(Tags) %%indexes Tag length
    Fish=BottomFish(BottomFish(:,1)==Tags(i),:); %%pulls data by tag
    [y,x]=size(Fish); %%indexing size of matrix fish
    InAndOut=[InAndOut;Fish(1,:)] %% seeds InAndOut matrix with first detection of fish at a monitor
    for a=2:y
        if Fish(a,6)~=Fish(a-1,6);
            InAndOut=[InAndOut;Fish(a,:)];
        end
    end
end

%%%% InAndOut is a matrix of just movements into or out of the MPA. All
%%%% other detections don't count. Next step is to code a for statement to
%%%% bin these movements. Ask Kevin, should I ignore the first detection???
%%%% if so delete line 108


for i=1:length(Tags)
    Fish=InAndOut(InAndOut(:,1)==Tags(i),:);
    [D,d]=size(Fish);
        counter=zeros(D,1);
        for detections=1:D; 
            if InAndOut(detections,6)>=Bins(bins)
toc
