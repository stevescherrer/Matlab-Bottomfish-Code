%%Building a working matrix (BottomFish) for all individuals with metadata to be the basis of all
%%future code.

%%Code stitched together from other projects on 17 Septemeber 2013
%%Written by Stephen Scherrer

%%updates in v_0.5
%%added notation for BOTTOMFISHTAGDATA initial file

%%%%READ ME%%%%
%%%%Before running code, a matrix needs to be constructed from VUE cvs file 
%%%%Insturctions for building a working database for bottomfish
%%%%Load CSV data file from VUE into excell
%%%%Change Date and time format to numbers
%%%%To pull tag codes and separate date and time, use function code
%%%%=(Right(cell number,number of digits to keep)) and 
%%%%=(Left(cell number,number of digits to keep)) respectively and sort into their own columns

%%Import from VUE to excell
%%Convert column A from date/time to number
%%Column I= =(left(C1,5))
%%Cut paste and drag down this formula
%%Column J= =RIGHT(B1,6)
%%Drag down copy paste
%%Column K='= if(H1="Barber Flats",1,if(H1="Diamond Head",2,if(H1="Kaena
%%Pocket",3,if(H4="Kahuku",4,if(H1="Ko Olina",5,if(H1="Makapuu[in
%%BRFA]",6,if(H4="Makapuu",8,if(H1="Mokapu",9,if(H1="Powerplant",10,if(H1="Waianae",11,0)))))))))))

%%%%BOTTOMFISHTAGDATA
%%Column 1=tag number
%%Column 2=date
%%Column 3=Time
%%Column 4=Reciever ID
%%Column 5=Location (1=Barber Flats, 2=Diamond Head, 3=Kaena
    %%Pocket, 4=Kahuku, 5=Ko Olina, 6=Makapuu[in BAFR],7=Makapuu S[Out of
    %%BAFR], 8=Makapuu N, 9=Mokapu, 10=Powerplant, 11=Waianae)


%%Additionally build a TagSizeSex database CSV file by taking master file
%%and deleting all other columns, then turning sex into 1=female, 2=male
%%0=unknown.

tic

dbstop if error

BF=BOTTOMFISHTAGDATA;

%%Arranging Data By Tag
[Tag,Index]=sort(BF(:,1));

Bottomfish=BF(Index,:);

clear BF Index Tag 

%%Indexing a list of unique Tag IDs
Tags=unique(Bottomfish(:,1));
Tags=Tags(isnan(Tags)==0); %% I have no idea why this line is necessary.. for some reason the Tag ID list produces a shit ton of NaNs

%%Adjusting from Excel date format to Matlab Dates
Bottomfish(:,2)=Bottomfish(:,2)+693960;  %%adjusts dates from BF file from excel to matlab
Bottomfish(:,3)=Bottomfish(:,3)-.10; %%adjusts times from BF file from GMT to HIST

%%Combining Date and time for easy viewing
Bottomfish(:,2)=Bottomfish(:,2)+Bottomfish(:,3);

Bottomfish(:,3)=zeros;

%%Arranging Data by date and time

BottomFish=[];

for i=1:length(Tags) %%indexes all Tag IDs
    x=Bottomfish(Bottomfish(:,1)==Tags(i),:); %%Pulls data from master file one ID at a time
    [R,T]=sort(x(:,2));  %%Sorts data by Date/Time and indexes
    BottomFish=[BottomFish;x(T,:)]; %%Fills in variable BottomFish (note capitalization) with data arranged first by Tag ID, then by date time
end
clearvars i x R T %%Clears variables used in previous loop

BottomFish=BottomFish(BottomFish(:,1)~=37969,:);


%%Determining that previous loop worked
if size(Bottomfish)==size(BottomFish)==1  %%Since BottomFish is the same as Bottomfish but in a different order, if the sizes match, all data was coppied. 
    clear Bottomfish %%therefore unsorted data is deleated
elseif size(Bottomfish)~=size(BottomFish)==1
    disp 'Something Terrible has gone wrong between lines 31 and 36' %%if sizes don't match, spits out where things are iffy
end

%%%%%SOMETHING TERRIBLE HAS GONE WRONG. WHY ARE THERE SO MANY NANS IN FIRST
%%%%%COLUMN OF Bottomfish? %% Previous loop removes this data but at what
%%%%%cost? OH THE HUMANITY!


%%%%%%%CORROLATE RECEVIER NUMBER TO LOCATION?? 
%%%%%%%THIS NEEDS TO BE DONE ONCE LARGER ARRAYS IN PLACE

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
%%Column 7=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, 0=unknown)
%%Column 8=Size (cm)
%%Column 9=Sex (1=Female, 2=Male, 0=Unknown)
    
%%Creating a 6th Column. the difference between in the BARF and out of it

[Y,X]=size(BottomFish);
Addendum=zeros(Y,4);
BottomFish=[BottomFish,Addendum];
clear Addendum


for i=1:Y
    if BottomFish(i,5)==6
        BottomFish(i,6)=1;
    elseif BottomFish(i,5)~=6
        BottomFish(i,6)=0;
    end
end

clearvars X Y

%%%%% Determinging Species of each Tag ID

%load('BOTTOMFISHTAGDATA.csv')


for i=1:length(BottomFish) 
if BottomFish(i,1)==14412
Bottomfish(i,7)=3;
elseif BottomFish(i,1)==37935
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37936
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37937
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37938
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37939
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37940
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37941
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37942
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37943
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37944
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37945
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37946
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37947
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37948
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37949
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37950
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37951
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37952
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37953
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37954
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37955
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37956
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37957
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37958
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37959
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37960
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37961
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37962
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37963
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37964
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37965
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37966
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37967
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37968
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37969
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37970
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37971
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37972
BottomFish(i,7)=4;
elseif BottomFish(i,1)==37973
BottomFish(i,7)=1;
elseif BottomFish(i,1)==37974
BottomFish(i,7)=1;
elseif BottomFish(i,1)==37975
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37976
BottomFish(i,7)=1;
elseif BottomFish(i,1)==37977
BottomFish(i,7)=1;
elseif BottomFish(i,1)==37978
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37979
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37980
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37981
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37982
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37983
BottomFish(i,7)=2;
elseif BottomFish(i,1)==37984
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57445
BottomFish(i,7)=6;
elseif BottomFish(i,1)==57446
BottomFish(i,7)=5;
elseif BottomFish(i,1)==57447
BottomFish(i,7)=1;
elseif BottomFish(i,1)==57448
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57449
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57450
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57451
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57455
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57456
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57457
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57458
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57459
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57460
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57462
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57463
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57464
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57465
BottomFish(i,7)=2;
elseif BottomFish(i,1)==57466
BottomFish(i,7)=2;

 
    
    %%%%%%%%%ADD ANY ADDITIONAL TAGS
end
end


%%%%The proceding code is for all Bottom Fish tagged in association with
%%%%the project. All other detections (fish from other projects) are
%%%%removed with the following
BottomFish=BottomFish(BottomFish(:,7)>0,:);
clear Bottomfish %%clears out Bottomfish variable

Sex=NaN(length(Tags),1);
%Mass=NaN(length(Tags),1);
Length=NaN(length(Tags),1);

%%pulling sex and length meta data from masterfile into bottomfish
for i=1:length(Tags);
        IndvMetaData=TagSizeSex(TagSizeSex(:,1)==Tags(i),:);
        if isempty(IndvMetaData)==0;
            Length(i)=IndvMetaData(:,2); %%%%Length Data Unavailable right now. Get it in the future and add to this
            Sex(i)=IndvMetaData(:,3);
    %%%%Mass(i)=IndvMetaData(:,  %%%%Mass Data Unavailable right now. Get it in the future and add to this
        end
end
clear i IndvMetaData

%adding length and sex characteristics to entire BottomFish file

for i=1:length(Tags);
    for a=1:length(BottomFish);
    if Tags(i)==BottomFish(a,1); %%if tags match
        BottomFish(a,8)=Length(i); %%assigns corrosponding length
        BottomFish(a,9)=Sex(i); %%assigns corrosponding sex
    end
    end
end


clearvars Sex Length i a Tags TagSizeSex BOTTOMFISHTAGDATA


%% Replacing unknown Sexes in column 9 from tags with no meta data with zero instead of NaN
for i=1:length(BottomFish)
    if isnan(BottomFish(i,9))==1
        BottomFish(i,9)=0;
    end
end

clear i

save BottomFish 
toc

%%%%%Notes on Output File
%%%%%Name: BottomFish
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
    %%Column 7=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, 0=unknown)
    %%Column 8=Size (cm)
    %%Column 9=Sex (1=Female, 2=Male, 0=Unknown)