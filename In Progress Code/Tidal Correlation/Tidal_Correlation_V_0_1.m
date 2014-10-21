%%%%Program to correlate reciever detections with tidal data
%%%%Written by Stephen Scherrer 23 September 2013

%%%REMEMBER THAT TIME I CHNAGED THIS TO LEARN SHIT ABOUT GITHUB? THAT TIME
%%%IS NOW

tic

%%Program relies on BottomFish Variable created from latest version of
%%WorkingDatabaseForAllCode program as well as Tidal Data in the form of a
%%variable called TideTable. At present, TideTable needs to be rebuilt
%%everytime new data is added and imported in the format described below.

%%Tide Data comes from NOAA at:
%%http://opendap.co-ops.nos.noaa.gov/dods/IOOS/High_Low_Verified_Water_Level.html
%%with the following variables: 
%%STATION_ID="1612480" (Makapuu)
%%BEGIN_DATE="20111109"
%%END_DATE=Whatever max date of data collected is
%%DATE_TIME=check this box
%%WL_Value=Check this box

%%Tide Data then exported to an ASCII file and metadata stripped from
%%header. Import to Excell and adjust to format described below


%%%%%%TideTable
%%Column 1=NOAA Bouy Location Number
%%Column 2=Date
%%Column 3=Time of Tidal Event
%%Column 4=Hight of Tide
%%Column 5=NaNs (previously was L, LL, H, HH
%%Column 6=Description of Tide (1=Low Low, 2=Low, 3=High, 4=High High)

%%Notes on variable BottomFish
%%In this program, Column 3 holds data relating to tides

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


%%For some reason, times have been exported with a constant date of
%%01-01-2013. This will clear the third column and leave a complete
%%date:time string in its place
TideTime=TideTable;
TideTime(:,2)=TideTime(:,2)+(TideTime(:,3)-(round(TideTime(:,3)+.5)-1));

%%Separating out species of interest
Ehu=BottomFish(BottomFish(:,7)==1,:);
Opaka=BottomFish(BottomFish(:,7)==2,:);

%%%%Treating High Highs and Low Lows the same as Highs and Lows
HHLL=TideTime;
for i=1:length(TideTime)
    if TideTime(i,6)==1||TideTime(i,6)==2
        HHLL(i,5)=-1;
    elseif TideTime(i,6)==3||TideTime(i,6)==4
        HHLL(i,5)=1;
    end
end

%%%%Treating High Highs and highs as well as Low Lows and Lows different
hl=TideTime;
for i=1:length(TideTime)
    if TideTime(i,6)==1
        hl(i,5)=-2;
    elseif TideTime(i,6)==2
        hl(i,5)=-1;
    elseif TideTime(i,6)==3
        hl(i,5)=1;
    elseif TideTime(i,6)==4
        hl(i,5)=2;
    end
end


%%%%Only looking at High Highs and Low Lows
HL=TideTime;
for i=1:length(TideTime)
    if TideTime(i,6)==1
        HL(i,5)=-1;
    elseif TideTime(i,6)==4
        HL(i,5)=1;
    end
end


%%Determining if Ehu detections corrolate with any tidal event (LL L H HH)


for i=1:length(Ehu)
    Closest=nan(length(TideTime),1);
    for t=1:length(TideTime)
        if Ehu(i,2)-TideTime(t,2)<0
            Closest(t)=Ehu(i,2)-TideTime(t,2)*(-1);
        elseif Ehu(i,2)-TideTime(t,2)>=1
            Closest(t)=Ehu(i,2)-TideTime(t,2);
        end
    end
    Ehu(i,3)=min(Closest);
end


EhuTideCorrolation=boxplot(Ehu(:,3));
hold on


%%Determining if Opaka detections corrolate with any tidal event (LL L H HH)


for i=1:length(Opaka)
    Closest=nan(length(TideTime),1);
    for t=1:length(TideTime)
        if Opaka(i,2)-TideTime(t,2)<0
            Closest(t)=Opaka(i,2)-TideTime(t,2)*(-1);
        elseif Opaka(i,2)-TideTime(t,2)>=1
            Closest(t)=Opaka(i,2)-TideTime(t,2);
        end
    end
    Opaka(i,3)=min(Closest);
end


OpakaTideCorrolation=boxplot(Opaka(:,3));
hold on

%%Is there a tide type that is prefered?

%%Treatment 1=High High and Low Low Tides treated the same as High and Low

%%LL and L tides given value of -1, H and HH tides given value +1
%%All detections are corrolated to nearest tide and a average is taken of
%%all 1 and -1 values. A high negative number or high positive number shows
%%a strong prefference for one type of tide
for i=1:length(Ehu)
    Closest=nan(length(HHLL),1);
    for t=1:length(HHLL)
        if Ehu(i,2)-TideTime(t,2)<0
            Closest(t)=Ehu(i,2)-HHLL(t,2)*(-1);
        elseif Ehu(i,2)-HHLL(t,2)>=1
            Closest(t)=Ehu(i,2)-HHLL(t,2);
        end
    end
    [value,index]=min(Closest);
    Ehu(i,3)=Closest(index);
end

EhuHHLLMean=mean(Ehu(:,3)); 

for i=1:length(Opaka)
    Closest=nan(length(HHLL),1);
    for t=1:length(HHLL)
        if Opaka(i,2)-HHLL(t,2)<0
            Closest(t)=Opaka(i,2)-HHLL(t,2)*(-1);
        elseif Opaka(i,2)-HHLL(t,2)>=1
            Closest(t)=Opaka(i,2)-HHLL(t,2);
        end
    end
    [value,index]=min(Closest);
    Opaka(i,3)=Closest(index);
end

OpakaHHLLMean=mean(Opaka(:,3));


%%Treatment 2=High High and Low Low Tides treated the different than high
%%or Low

for i=1:length(Ehu)
    Closest=nan(length(hl),1);
    for t=1:length(hl)
        if Ehu(i,2)-hl(t,2)<0
            Closest(t)=Ehu(i,2)-hl(t,2)*(-1);
        elseif Ehu(i,2)-hl(t,2)>=1
            Closest(t)=Ehu(i,2)-hl(t,2);
        end
    end
    [value,index]=min(Closest);
    Ehu(i,3)=Closest(index);
end

EhuhlMean=mean(Ehu(:,3)); 


for i=1:length(Opaka)
    Closest=nan(length(hl),1);
    for t=1:length(hl)
        if Opaka(i,2)-hl(t,2)<0
            Closest(t)=Opaka(i,2)-hl(t,2)*(-1);
        elseif Opaka(i,2)-hl(t,2)>=1
            Closest(t)=Opaka(i,2)-hl(t,2);
        end
    end
    [value,index]=min(Closest);
    Opaka(i,3)=Closest(index);
end


OpakahlMean=mean(Opaka(:,3));

%%Treatment 3=High High and Low Low Tides only of interest. No interest in
%%non extreme (High or Low) Tides

for i=1:length(Ehu)
    Closest=nan(length(HL),1);
    for t=1:length(HL)
        if Ehu(i,2)-HL(t,2)<0
            Closest(t)=Ehu(i,2)-HL(t,2)*(-1);
        elseif Ehu(i,2)-HL(t,2)>=1
            Closest(t)=Ehu(i,2)-HL(t,2);
        end
    end
    [value,index]=min(Closest);
    Ehu(i,3)=Closest(index);
end

EhuHLMean=mean(Ehu(:,3)); 


for i=1:length(Opaka)
    Closest=nan(length(HL),1);
    for t=1:length(HL)
        if Opaka(i,2)-HL(t,2)<0
            Closest(t)=Opaka(i,2)-HL(t,2)*(-1);
        elseif Opaka(i,2)-HL(t,2)>=1
            Closest(t)=Opaka(i,2)-HL(t,2);
        end
    end
    [value,index]=min(Closest);
    Opaka(i,3)=Closest(index);
end

OpakaHLMean=mean(Opaka(:,3));

clearvars i t Closest Opaka Ehu 

toc