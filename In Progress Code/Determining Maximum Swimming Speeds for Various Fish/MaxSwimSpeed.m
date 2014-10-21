%%%%Analyzing Data Collected from original Bottomfish project. To determine
%%%%The Maximum Swimming Speed Between Monitors.

%%%%Written By Stephen Scherrer on 20 November 2013
%%%%All rights preserved, all wrongs traversed


tic

%%%%%%%%%%%%%%%%%%NOTES%%%%%%%%%%%%%%%%%%%%%%


%%%%Program relies on the following variables.

%%BottomFish
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
    
%%RecieverDates
    %%Column 1=Reciever Location
    %%Column 2=Reciever Number
    %%Column 3=Deployment Date
    %%Column 4=Recovery Date
    %%Column 5=Deployment Latitude (prefix)
    %%Column 6=Deployment Latitude (degree minutes)
    %%Column 7=Deployment Longitude (prefix)
    %%Column 8=Deployment Longitude (degree minutes)
    %%Column 9=Deployment Longitude (prefix+decimal degrees)
    %%Column 10=Deployment Latitude (prefix+decimal Degrees)
    
    
    
 %% Building Time Between Detections Matrix

  TimeBetweenDetections=nan(length(BottomFish),6);
  
      %Notes on Time Between Detection Matrix
        %Column 1=Species
        %Column 2=Time between 2 recievers
        %Column 3=Time of First detection
        %Column 4=Time of Second detection
        %Column 5=Reciever number for First Detection
        %Column 6=Receiver number for Second Detection
        
  for i=2:length(BottomFish);
      if BottomFish(i,1)==BottomFish(i-1,1) && BottomFish(i,2)~=BottomFish(i-1,2) && BottomFish(i,3)~=BottomFish(i-1,3);
          TimeBetweenDetections(i,1)=BottomFish(i,5); 
          TimeBetweenDetections(i,2)=BottomFish(i,2)-BottomFish(i-1,2); 
          TimeBetweenDetections(i,2)=BottomFish(i-1,2); 
          TimeBetweenDetections(i,2)=BottomFish(i,2); 
          TimeBetweenDetections(i,5)=BottomFish(i-1,2); 
          TimeBetweenDetections(i,6)=BottomFish(i,2);
      end
  end
  
TimeBetweenDetections=TimeBetweenDetections(isnan(TimeBetweenDetections(:,1)==0),:);

%%indexing the shortest interval for each species tagged

%%Creating matrix of Maximum swim speeds (Shortest detection times between
%%two monitors by species)

MaxSpeedsBySpecies=[];

%%Notes on MaxSpeedsBySpecies
    %Column 1=Species (1=Ehu, 2=Opaka, 3=Dogfish, 4=Ges, 5=Kale, 6=Sandbar, 0=unknown)
    %Column 2=Time between 2 recievers
    %Column 3=Time of First detection
    %Column 4=Time of Second detection
    %Column 5=Reciever number for First Detection
    %Column 6=Receiver number for Second Detection
    
for i=1:max(BottomFish(:,5));
    Subset=TimeBetweenDetections(TimeBetweenDetections(:,5)==i,:);
    [Value,Index]=min(Subset(:,2));
    MaxSpeedsBySpecies=Subset(Index,:);
end

%%Calculating Distance traveled between the 2 receivers
Addendum=nan(length(MaxSpeedBySpecies(:,1),1)); %%Padding for MaxSpeedBySpeciesMatrix to add distance between recievers
MaxSpeedBySpecies=[MaxSpeedBySpecies,Addendum]; 
clear Addendum

%%Determining Reciever Lat/Long at Time of Detecion
for i=1:length(MaxSpeedBySpecies);
    for a=1:length(RecieverDates);
        if MaxSpeedBySpecies(i,5)==ReceiverDates(a,2) && MaxSpeedBySpecies(i,3)>=ReceiverDates(a,3) && MaxSpeedBySpecies(i,3)<=ReceiverDates(a,4);
            FirstReciever=RecieverDates(a,:);
        end
        if MaxSpeedBySpecies(i,6)==ReceiverDates(a,2) && MaxSpeedBySpecies(i,4)>=ReceiverDates(a,3) && MaxSpeedBySpecies(i,4)<=ReceiverDates(a,4);
            SecondReciever=ReceiverDates(a,:);
        end
            [arclen,az] = distance(FirstReceiver(a,10),FirstReciever(a,9),SecondReciever(a,10),SecondReceiver(a,9));
            MaxSpeedBySpecies(i,7)=arclen;
    end
end

%%Determining Maximum Swimming Speed and displaying it
    disp 'Ehu'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==1,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==1,2)
    disp 'Opakapaka'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==2,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==2,2)
    disp 'Dogfish'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==3,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==3,2)
    disp 'Ges'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==4,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==4,2)
    disp 'Kale'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==5,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==5,2)
    disp 'Sandbar'
    MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==6,7)/ MaxSpeedBySpecies(MaxSpeedBySpecies(:,1)==6,2)
    