%ToDo:
    %Determine bad tags
    
    %%Tags Excluded by visual inspection of records in VUE. Tags with only
    %%a few detections occuring on just a few days were removed. 
    %Bad_Tags=[37942, 37943, 37944, 37945, 37946, 37947, 37950, 37952, 37955, 37958, 37961, 37971, 37979];
    %viable_tags=[37960, 37961, 57455, 57457];
    %possible_prey_tag=37981;
    %Get Receiver Lon and Lat to BottomFish matrix in columns 11 and 12
        %respectively.
    
dbstop if error

%Notes on starting file:
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


%%%Totally cheating to add Lon and Lat to tag detection location
BF= [BottomFish]; % = [TagDateAddition, BottomFish];
Addendum=zeros(length(BF(:,1)),2);
if length(BF(1,:))==10;
    BF=[BF,Addendum];
end
Good_Tags=[37960, 37961, 57455, 57457];
Trans_good=Good_Tags;

OpT=[];
for i=1:length(Good_Tags);
   indv=BF(BF(:,1)==Good_Tags(i),:);
   OpT=[OpT; indv];
end
Opakapaka= OpT;

%%Fixing Receiver that went out with Botcam and is still "deployed ont he
%%banks"

[H,~]=size(Opakapaka);
for T=1:H;
    %%Fixing Bad Columns
    
    if isnan(Opakapaka(T,6))
        Opakapaka(T,6)=-99999;
    end
    
    if isnan(Opakapaka(T,7))
        Opakapaka(T,7)=-99999;
    end
    
    if isnan(Opakapaka(T,9))
        Opakapaka(T,9)=-99999;
    end
    
    if isnan(Opakapaka(T,10))
        Opakapaka(T,10)=-99999;
    end
        
        
    if Opakapaka(T,4)==1, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==2, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==3, 
        Opakapaka(T,11)=-157.7408;
        Opakapaka(T,12)=21.5068;
    elseif Opakapaka(T,4)==4, 
        Opakapaka(T,11)=-157.6948;
        Opakapaka(T,12)=21.4255;
    elseif Opakapaka(T,4)==5, 
        Opakapaka(T,11)=-157.5722;
        Opakapaka(T,12)=21.3080;
    elseif Opakapaka(T,4)==6, 
        Opakapaka(T,11)=-157.5688;
        Opakapaka(T,12)=21.2560;
    elseif Opakapaka(T,4)==7, 
        Opakapaka(T,11)=-157.8134;
        Opakapaka(T,12)=21.2315;
    elseif Opakapaka(T,4)==8, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==9, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==10, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==11, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==12, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==13, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==100, 
        Opakapaka(T,11)=-157.3471;
        Opakapaka(T,12)=21.0028;
    elseif Opakapaka(T,4)==101, 
        Opakapaka(T,11)=0;
        Opakapaka(T,12)=0;
    elseif Opakapaka(T,4)==102, 
        Opakapaka(T,11)=-157.3553;
        Opakapaka(T,12)=20.9894;
    elseif Opakapaka(T,4)==103, 
        Opakapaka(T,11)=-157.4133;
        Opakapaka(T,12)=20.9551;
    elseif Opakapaka(T,4)==104, 
        Opakapaka(T,11)=-157.5791;
        Opakapaka(T,12)=20.9087;
    elseif Opakapaka(T,4)==105, 
        Opakapaka(T,11)=-157.7351;
        Opakapaka(T,12)=20.8584;
    end
end
    
viable_tags=unique(Opakapaka(:,1));

%By transmitter
for i=1:length(viable_tags);
    ii=i;
    tag=Opakapaka(Opakapaka(:,1)==viable_tags(i),:);
    Transmitter_index=find(tag(:,1)==tag(:,1));
    Longitude3=tag(:,11);
    Lon_ii=Longitude3(Transmitter_index);
    Latitude3=tag(:,12);
    Lat_ii=Latitude3(Transmitter_index);
    Dates_ii=tag(:,2);

    tags=tag;
    
    
    
    
%How ManyTimes the animal Moved.
disp (['For tag ', int2str(viable_tags(i))])
move_count = 0;
    for a=2:length(tag(:,1));
         if tag(a,4)~=tag(a-1,4)
            move_count=move_count+1;
         end
    end
disp(['There were ', int2str(move_count), ' recorded movements.'])

%total number of detections
detections=length(tag(:,1));
disp(['There were ' , int2str(detections), ' total detections.'])

%total number of tracked days
track_days = max(tag(:,2))-min(tag(:,2));
disp(['recorded over a period of ', int2str(track_days) , ' days'])

%days detected
unique_days=floor(tag(:,2));
tag_unique_days=tag;
tag_unique_days(:,2)=unique_days;
tag_unique_days=unique(tag_unique_days,'rows');

days_detected=length(tag_unique_days(:,2));

percentage_of_days_detected=days_detected./track_days;

disp(['The transmitter was detected ' , int2str(days_detected), ' days, or ', num2str(percentage_of_days_detected), '% of the total number of tracked days'])
Days_detected=days_detected;

%BRFA Statistics
detections_in_BRFA = 0; %counter for number of detections in BRFA
detections_out_BRFA = 0;
for m=2:length(tag(:,2));
    if tag(m,8)~=tag(m-1,8);
        detections_in_BRFA=detections_in_BRFA+1;
    else
        detections_out_BRFA=detections_out_BRFA+1;
    end
end
det_in_BRFA=detections_in_BRFA;
det_out_BRFA=detections_out_BRFA;



days_in_BRFA = 0;
days_out_BRFA = 0;
[h,~]=size(tag_unique_days);
for c=2:h;
    if tag_unique_days(c,8)==1
        days_in_BRFA = days_in_BRFA+1;
    else
        days_out_BRFA = days_out_BRFA+1;
    end
end

Days_in_BRFA=days_in_BRFA;
Days_out_BRFA = days_out_BRFA;



disp(['This tag was detected ' , int2str(detections_in_BRFA), ' times in the BRFA on ', int2str(days_in_BRFA), ' unique days.']);
disp(['therefore the tag was detected ' int2str(detections_out_BRFA), ' times out of the BFRA on ', int2str(days_out_BRFA), ' unique days.']);

%measure time between detections
time_between_detections=diff(tag(:,2));
gaps=time_between_detections;

%movements in and out of BRFA
border_crossings = 0;
cross_in_out = 0;
cross_out_in = 0;


for r = 2:length(tag(:,1))
    if tag(r,8)~=tag(r-1,8)
        border_crossings = border_crossings+1; %if BRFA desigantion changes, incriment the crossing index
        if tag(r-1,8)==1;
            cross_in_out = cross_in_out + 1; %if the first detection of a change occured inside the BRFA, the second must have occurred out and thus the fish moved from in to out
        else
            cross_out_in = cross_out_in + 1; %if the designation changed, and the first change did not occur in the BRFA, then the fish must have moved into the BRFA
        end
    end
end

disp(['The tag was detected crossing the BRFA boundary ', int2str(border_crossings) , ' times. Of these, ' , int2str(cross_in_out), ' were movements from inside to outside the BRFA and ', int2str(cross_out_in), ' were movements from the outside to within the BRFA boundaries.'])

outin=cross_out_in;
inout=cross_in_out;

%Residency within and outsie the BRFA
BRFA_detections=tag_unique_days(tag_unique_days(:,8)==1,:);
outside_detections=tag_unique_days(tag_unique_days(:,8)~=1,:);

BRFA_date_differences=diff(BRFA_detections(:,2));
days_resident_in_BRFA=sum(BRFA_date_differences==1);

outside_date_differences=diff(outside_detections(:,2));
days_resident_out_BRFA=sum(outside_date_differences==1);

resident_in=days_resident_in_BRFA;
resident_out=days_resident_out_BRFA;

% %%%%%%%%%%%%%%%MAP OF MOVEMENTS FOR EACH FISH
 scrsz = get(0,'ScreenSize');
     figure('Position',[1 1 scrsz(3)/4 scrsz(4)]) %%% for a subplot 211 vertical
 figure('Position',[1 1 scrsz(3)*.8 scrsz(4)*.5]*.7) %%% for a 121 horizontal
 subplot 121
 lon_proj_bounds = [-157.84, -157.24];
 lat_proj_bounds = [20.80, 21.47];
 
 m_proj('Mercator','lon<gitude>',lon_proj_bounds,'lat<itude>',lat_proj_bounds);

 zz=zeros(length(Dates_ii),1);
 igapstemp = ones(length(tag(:,2)),1);
 minc = 0;
 maxc = 60;
 m_plot4(Lon_ii,Lat_ii,zz,igapstemp,minc,maxc,'linewidth',2); %points of interpolated track
 set(gca,'CLim',[minc,maxc]);%colorbar
 set(gca,'color',[0 0 0]);
 m_grid('linestyle','none');
  if ii==1;
     m_gshhs_h
     m_gshhs_h('save','BRFAEF');
 else
     m_usercoast('BRFAEF')
 end
 %m_coast('patch',[.4 .4 .4],'edgecolor','k');
 if tag(1,5)==1
    speciesID='ehu';
 elseif tag(1,5)==2
     speciesID='Paka';
 elseif tag(1,5)==3
     speciesID='Dogfish';
 elseif tag(1,5)==4
     speciesID='Ges';
 elseif tag(1,5)==5
     speciesID='Kalekale';
 elseif tag(1,5)==6
     speciesID='Sandbar';
 elseif tag(1,5)==7
     speciesID='Onaga';
 end
 species_ii=speciesID;
 
 title([char(speciesID),' ',num2str(tag(1,1)),': ',num2str(round(detections)),' detections, ',num2str(move_count),' movements, ',num2str(cross_in_out),' in-out ,',num2str(cross_out_in),' out-in'])

 hold
 m_plot(tag(:,11),tag(:,12),'bo'); 
 
 BRFA_E_lon = [
     -157.6833
     -157.5333
     -157.5333
     -157.6833];
 BRFA_E_lat = [
     21.41666
     21.41666
     21.28333
     21.28333];
 m_plot(BRFA_E_lon,BRFA_E_lat,'r')
 
 BRFA_F_lon = [
     -157.5666
     -157.3666
     -157.3666
     -157.5666
     -157.5666];
 BRFA_F_lat = [
     21.03333
     21.03333
     20.91666
     20.91666
     21.0333];
 m_plot(BRFA_F_lon, BRFA_F_lat,'r')
 
 MakapuuNorth = [-157.6948  , 21.42553333];
 MakapuuIn = [-157.5722  , 21.308];
 MakapuuSouth = [-157.5943167  , 21.26245];
 DiamondHead = [-157.8134  , 21.23151667];
 BaseOf3rdFinger = [-157.5791  , 20.90865];
 SouthTip = [-157.7350167  , 20.85848333];
 PinnacleSouth = [-157.4132667  , 20.95513333];
 TheMound = [-157.3551  , 20.98948333];
 FirstFinger = [-157.347  , 21.00305;];
 
m_plot(MakapuuNorth(:,1),MakapuuNorth(:,2),'g.')
m_plot(MakapuuIn(:,1),MakapuuIn(:,2),'g.')
m_plot(MakapuuSouth(:,1),MakapuuSouth(:,2),'g.')
m_plot(DiamondHead(:,1),DiamondHead(:,2),'g.')
m_plot(BaseOf3rdFinger(:,1),BaseOf3rdFinger(:,2),'g.')
m_plot(SouthTip(:,1),SouthTip(:,2),'g.')
m_plot(PinnacleSouth(:,1),PinnacleSouth(:,2),'g.')
m_plot(FirstFinger(:,1),FirstFinger(:,2),'g.')
 
 
% m_text(-157.7465833 , 21.49878333,'Marine Corps Base','vertical','top');
 m_text(-157.6948  , 21.42553333,'Makapuu North','vertical','top');
 m_text(-157.5722  , 21.308,'Makapuu BRFA','vertical','top');
 m_text(-157.5943167  , 21.26245,'Makapuu South','vertical','top');
 m_text(-157.8134  , 21.23151667,'Diamond Head','vertical','top');
 m_text(-157.5791  , 20.90865,'Base of 3rd Finger','vertical','top');
 m_text(-157.7350167  , 20.85848333,'South Tip','vertical','top');
 m_text(-157.4132667  , 20.95513333,'Pinnacle South','vertical','top');
 m_text(-157.3551  , 20.98948333,'The Mound','vertical','top');
 %m_text(-1.573552666,19.01061666,'Penguin Banks in BRFA','vertical','top');
 m_text(-157.347  , 21.00305,'First Finger','vertical','top');

 hold off
 
 subplot 122
 hist(time_between_detections)
 title([char(speciesID),' ',num2str(tag(1,1)),': track d ',num2str(round(track_days)),', detected on ',num2str(days_detected),' d, res in ',num2str(days_resident_in_BRFA),' d,',' res out ',num2str(days_resident_out_BRFA),' d, '])
 xlabel('gap length (days)')
 ylabel('frequency')
 
 set(gcf,'PaperPositionMode','auto') % makes the pdf the same size/aspect/appearance as on screen fig
 orient landscape
 print('-dpdf',num2str(tag(ii))); % makes pdf
 close
    
move_dist_all_segments=[];

 clear i_dist
 Long_of_tag = Longitude3(Transmitter_index);
 Lat_of_tag = Latitude3(Transmitter_index);
 for i_dist = 1:length(Transmitter_index)-1
     [mov_dist(i_dist),a12,a21] = m_idist(Long_of_tag(i_dist),Lat_of_tag(i_dist),Long_of_tag(i_dist+1),Lat_of_tag(i_dist+1),'wgs84');
 end
 mov_dist(mov_dist==0)=NaN; %%%%% turn all the zeros into NaNs
 %mov_dist(mov_dist<500)=NaN;   %%%%%  get rid of the short movements between D and E
 
detections_all(i,1)=detections;
det_in_BRFA_all(i,1)=det_in_BRFA;
det_out_BRFA_all(i,1)=det_out_BRFA;
movements_all(i,1)=move_count;
inout_all(i,1)=inout*30;
outin_all(i,1)=outin*30;
track_days_all(i,1)=track_days;
Days_detected_all(i,1)=Days_detected;
Days_in_BRFA_all(i,1)= Days_in_BRFA;
Days_out_BRFA_all(i,1)= Days_out_BRFA;
resident_in_all(i,1)=resident_in;
resident_out_all(i,1)=resident_out;
mov_dist_med(i,1) = nanmedian(mov_dist);
mov_dist_max(i,1) = nanmax(mov_dist);
mov_dist_min(i,1) = nanmin(mov_dist);
move_dist_all_segments = [move_dist_all_segments;mov_dist'];

end

track_days_all1 = round(track_days_all);
det_ratio = Days_detected_all./track_days_all1;
det_ratio(det_ratio>1)=1;  %% there are some errors caused when detections happen either side of midnight (ie on two different days, but the track length is one day.




%%%%%%% calculate distances between locations
[dist_BRFA_E_width,a12,a21] = m_idist(-157.6833,21.41666,-157.5333,21.41666,'wgs84');



%[dist_AH,a12,a21] = m_idist(-160.045000,21.872500,-160.1,21.78783333,'wgs84');
%[dist_DE,a12,a21] = m_idist(-160.0683333,21.82333333,-160.0688167,21.81903333,'wgs84');
%[dist_GH,a12,a21] = m_idist(-160.0841667,21.80633333,-160.1,21.78783333,'wgs84');
%[dist_IA,a12,a21] = m_idist(-160.14615,21.7469,-160.045000,21.872500,'wgs84');

%%%%%%%%%%%%%%% figure showing overall results as histograms
figure
subplot 421
hist(detections_all)
xlabel('detections')
subplot 422
hist(track_days_all)
xlabel('track days')
subplot 423
hist(Days_detected_all)
xlabel('days detected')
subplot 424
hist(movements_all)
xlabel('movements')
subplot 425
hist(inout_all)
xlabel('in-out movements')
subplot 426
hist(outin_all)
xlabel('out-in movements')
subplot 427
hist(resident_in_all)
xlabel('resident in days')
subplot 428
hist(resident_out_all)
xlabel('resident out days')

set(gcf,'PaperPositionMode','auto') % makes the pdf the same size/aspect/appearance as on screen fig
orient landscape
print('-dpdf','Histograms'); % makes pdf

%%%%%%%%%%%%%%% overall results as boxplot
figure
subplot 421
boxplot(detections_all)
xlabel('detections')
subplot 422
boxplot(track_days_all)
xlabel('track days')
subplot 423
boxplot(Days_detected_all)
xlabel('days detected')
subplot 424
boxplot(movements_all)
xlabel('movements')
subplot 425
boxplot(inout_all)
xlabel('in-out movements')
subplot 426
boxplot(outin_all)
xlabel('out-in movements')
subplot 427
boxplot(resident_in_all)
xlabel('resident in days')
subplot 428
boxplot(resident_out_all)
xlabel('resident out days')

 set(gcf,'PaperPositionMode','auto') % makes the pdf the same size/aspect/appearance as on screen fig
 orient landscape
 print('-dpdf','Boxplots'); % makes pdf

%%%%%%%%%%%%%%%%%%%%%%%%%%% for each species
%%%%%%%%%%%%%%%%% couldn't get find or if to work with cell array 'species'
%%%%%%%%%%%%%%%%% so I'm using a numeric species code: 1=ONA, 2=EHU,
%%%%%%%%%%%%%%%%% 3=PAKA.

onaga_ind = find(Opakapaka(:,4) == 7);
ehu_ind = find(Opakapaka(:,4) == 1);
Opakapaka_ind = find(Opakapaka(:,4)==2);

onaga_tagnumbers = Trans_good(onaga_ind);
onaga_det = detections_all(onaga_ind);
onaga_mvt = movements_all(onaga_ind);
onaga_inout =inout_all(onaga_ind);
onaga_outin = outin_all(onaga_ind);
onaga_trackdays = track_days_all(onaga_ind);
onaga_days_det =Days_detected_all(onaga_ind);
onaga_Days_in_BRFA = Days_in_BRFA_all(onaga_ind);
onaga_Days_out_BRFA = Days_out_BRFA_all(onaga_ind);
onaga_res_in = resident_in_all(onaga_ind);
onaga_res_out = resident_out_all(onaga_ind);
onaga_det_ratio = det_ratio(onaga_ind);
onaga_sp_code_vector = ones(length(onaga_ind),1)*7;
onaga_mov_dist = mov_dist_med(onaga_ind);
onaga_mov_dist_max = mov_dist_max(onaga_ind);
onaga_mov_dist_min = mov_dist_min(onaga_ind);

ehu_tagnumbers = Trans_good(ehu_ind);
ehu_det = detections_all(ehu_ind);
ehu_mvt = movements_all(ehu_ind);
ehu_inout =inout_all(ehu_ind);
ehu_outin = outin_all(ehu_ind);
ehu_trackdays = track_days_all(ehu_ind);
ehu_days_det =Days_detected_all(ehu_ind);
ehu_Days_in_BRFA = Days_in_BRFA_all(ehu_ind);
ehu_Days_out_BRFA = Days_out_BRFA_all(ehu_ind);
ehu_res_in = resident_in_all(ehu_ind);
ehu_res_out = resident_out_all(ehu_ind);
ehu_det_ratio = det_ratio(ehu_ind);
ehu_sp_code_vector = ones(length(ehu_ind),1)*1;
ehu_mov_dist = mov_dist_med(ehu_ind);
ehu_mov_dist_max = mov_dist_max(ehu_ind);
ehu_mov_dist_min = mov_dist_min(ehu_ind);

Opakapaka_tagnumbers = Trans_good(Opakapaka_ind);
Opakapaka_det = detections_all(Opakapaka_ind);
Opakapaka_mvt = movements_all(Opakapaka_ind);
Opakapaka_inout =inout_all(Opakapaka_ind);
Opakapaka_outin = outin_all(Opakapaka_ind);
Opakapaka_trackdays = track_days_all(Opakapaka_ind);
Opakapaka_days_det =Days_detected_all(Opakapaka_ind);
Opakapaka_Days_in_BRFA = Days_in_BRFA_all(Opakapaka_ind);
Opakapaka_Days_out_BRFA = Days_out_BRFA_all(Opakapaka_ind);
Opakapaka_res_in = resident_in_all(Opakapaka_ind);
Opakapaka_res_out = resident_out_all(Opakapaka_ind);
Opakapaka_det_ratio = det_ratio(Opakapaka_ind);
Opakapaka_sp_code_vector = ones(length(Opakapaka_ind),1)*2;
Opakapaka_mov_dist = mov_dist_med(Opakapaka_ind);
Opakapaka_mov_dist_max = mov_dist_max(Opakapaka_ind);
Opakapaka_mov_dist_min = mov_dist_min(Opakapaka_ind);

%%%%%%%%%%%%%%%%%%%%%%%%% put all of these results into a big table
table_results(:,1)= [onaga_tagnumbers;ehu_tagnumbers;Opakapaka_tagnumbers];
table_results(:,2)= [onaga_det;ehu_det;Opakapaka_det];
table_results(:,3)= [onaga_mvt;ehu_mvt;Opakapaka_mvt];
table_results(:,4)= [onaga_inout;ehu_inout;Opakapaka_inout];
table_results(:,5)= [onaga_outin;ehu_outin;Opakapaka_outin];
table_results(:,6)= [onaga_trackdays;ehu_trackdays;Opakapaka_trackdays];
table_results(:,7)= [onaga_days_det;ehu_days_det;Opakapaka_days_det];
% table_results(:,8)= [onaga_res_in;ehu_res_in];
% table_results(:,9)= [onaga_res_out;ehu_res_out];
table_results(:,8)= [onaga_Days_in_BRFA;ehu_Days_in_BRFA;Opakapaka_Days_in_BRFA];
table_results(:,9)= [onaga_Days_out_BRFA;ehu_Days_out_BRFA;Opakapaka_Days_out_BRFA];
table_results(:,10)= [onaga_det_ratio;ehu_det_ratio;Opakapaka_det_ratio];
table_results(:,11)= [onaga_sp_code_vector;ehu_sp_code_vector;Opakapaka_sp_code];
table_results(:,12)= table_results(:,3)./table_results(:,7);%.*30; %%%%%%%  normalize the movements by the days_detected
table_results(:,13)= table_results(:,4)./table_results(:,7);%.*30;%%%%%%%  normalize the inout by the days_detected
table_results(:,14)= table_results(:,5)./table_results(:,7);%.*30;%%%%%%%  normalize the outin by the days_detected
%%%%%%%%%%% note that columns 8 and 9 are now for days in and days out BRFA
table_results(:,15)= table_results(:,8)./table_results(:,7);%.*30;%%%%%%%  NULL
table_results(:,16)= table_results(:,9)./table_results(:,7);%.*30;%%%%%%%  NULL
table_results(:,17)= table_results(:,2)./table_results(:,7);%.*30;%%%%%%%  normalize the detections by the days_detected
table_results(:,18)= table_results(:,8)./table_results(:,7);%.*30;%%%%%%%  normalize the days_inside by the days_detected
table_results(:,19)= table_results(:,9)./table_results(:,7);%.*30;%%%%%%%  normalize the days_outside by the days_detected
table_results(:,20)= [onaga_mov_dist;ehu_mov_dist;Opakapaka_mov_dist];  %%%%% distances moved
table_results(:,21)= [onaga_mov_dist_max;ehu_mov_dist_max;Opakapaka_mov_dist_max];  %%%%% distances moved
table_results(:,22)= [onaga_mov_dist_min;ehu_mov_dist_min;Opakapaka_mov_dist_max];  %%%%% distances moved


%%%%%%%%%%%%%% knock out tags that have tracks less than 7 days long
short_tracks = find(table_results(:,6) <7);
table_results2 = table_results;
table_results2(short_tracks,:) =NaN;
table_results3 = table_results;
table_results3(short_tracks,:) =[];



%%%%%%%%%% pull back out the onaga and ehu data for statistical tests,
%%%%%%%%%% using the data with only the tracks longer than 7 days. Note
%%%%%%%%%% that ranksum doesn't work with NaNs so I created a third summary
%%%%%%%%%% table that just removes the short tracks.
onaga_ind3=find(table_results3(:,11)==7);
ehu_ind3=find(table_results3(:,11)==1);
paka_ind3=find(table_results3(:,11)==2);

[p_detections,h] = ranksum(table_results3(onaga_ind3,2),table_results3(ehu_ind3,2),table_results3(paka_ind3,2)); %%% detections
[p_detperday,h] = ranksum(table_results3(onaga_ind3,17),table_results3(ehu_ind3,17),table_results3(paka_ind3,17)); %%% detections per day
[p_mvtperday,h] = ranksum(table_results3(onaga_ind3,12),table_results3(ehu_ind3,12),table_results3(paka_ind3,12)); %%% mvt/day
[p_inoutperday,h] = ranksum(table_results3(onaga_ind3,13),table_results3(ehu_ind3,13),table_results3(paka_ind3,13)); %%% inout/day
[poutinperday,h] = ranksum(table_results3(onaga_ind3,14),table_results3(ehu_ind3,14),table_results3(paka_ind3,14)); %%% outin/day
[p_resinperday,h] = ranksum(table_results3(onaga_ind3,15),table_results3(ehu_ind3,15),table_results3(paka_ind3,15)); %%% resin/day
[p_resoutperday,h] = ranksum(table_results3(onaga_ind3,16),table_results3(ehu_ind3,16),table_results3(paka_ind3,16)); %%% resout/day
[p_dayinperdaydet,h] = ranksum(table_results3(onaga_ind3,17),table_results3(ehu_ind3,17),table_results3(paka_ind3,17)); %%% resout/day
[p_dayoutperdaydet,h] = ranksum(table_results3(onaga_ind3,18),table_results3(ehu_ind3,18),table_results3(paka_ind3,18)); %%% resout/day
[p_trackdays,h] = ranksum(table_results3(onaga_ind3,6),table_results3(ehu_ind3,6),table_results3(paka_ind3,6)); %%% trackdays
[p_days_det,h] = ranksum(table_results3(onaga_ind3,7),table_results3(ehu_ind3,7),table_results3(paka_ind3,7)); %%% days detected
[p_mov_dist_med,h] = ranksum(table_results3(onaga_ind3,20),table_results3(ehu_ind3,20),table_results3(paka_ind3,20)); %%% movement distance
[p_mov_dist_max,h] = ranksum(table_results3(onaga_ind3,21),table_results3(ehu_ind3,21),table_results3(paka_ind3,21)); %%% movement distance
[p_mov_dist_min,h] = ranksum(table_results3(onaga_ind3,22),table_results3(ehu_ind3,22),table_results3(paka_ind3,22)); %%% movement distance


%%%%%%%%%%%%%%% build a table for the summary results and ranksum tests
%%%%%%%%%%%%%%% comparing onaga and ehu; these are for tracks >7days

%%%%%%%%%%%%%%% detections/day row
table_summary(1,1) = median(table_results3(onaga_ind3,17));
table_summary(1,2) = quantile(table_results3(onaga_ind3,17),.25);
table_summary(1,3) = quantile(table_results3(onaga_ind3,17),.75);
table_summary(1,4) = median(table_results3(ehu_ind3,17));
table_summary(1,5) = quantile(table_results3(ehu_ind3,17),.25);
table_summary(1,6) = quantile(table_results3(ehu_ind3,17),.75);
table_summary(1,7) = median(table_results3(paka_ind3,17));
table_summary(1,8) = quantile(table_results3(paka_ind3,17),.25);
table_summary(1,9) = quantile(table_results3(paka_ind3,17),.75);
table_summary(1,10) = p_detperday;

%%%%%%%%%%%%%%%%%%% movements/day row
table_summary(2,1) = median(table_results3(onaga_ind3,12));
table_summary(2,2) = quantile(table_results3(onaga_ind3,12),.25);
table_summary(2,3) = quantile(table_results3(onaga_ind3,12),.75);
table_summary(2,4) = median(table_results3(ehu_ind3,12));
table_summary(2,5) = quantile(table_results3(ehu_ind3,12),.25);
table_summary(2,6) = quantile(table_results3(ehu_ind3,12),.75);
table_summary(2,7) = median(table_results3(paka_ind3,12));
table_summary(2,8) = quantile(table_results3(paka_ind3,12),.25);
table_summary(2,9) = quantile(table_results3(paka_ind3,12),.75);
table_summary(2,10) = p_mvtperday;

%%%%%%%%%%%%%%%%%%% inout/day row
table_summary(3,1) = median(table_results3(onaga_ind3,13));
table_summary(3,2) = quantile(table_results3(onaga_ind3,13),.25);
table_summary(3,3) = quantile(table_results3(onaga_ind3,13),.75);
table_summary(3,4) = median(table_results3(ehu_ind3,13));
table_summary(3,5) = quantile(table_results3(ehu_ind3,13),.25);
table_summary(3,6) = quantile(table_results3(ehu_ind3,13),.75);
table_summary(3,7) = median(table_results3(paka_ind3,13));
table_summary(3,8) = quantile(table_results3(paka_ind3,13),.25);
table_summary(3,9) = quantile(table_results3(paka_ind3,13),.75);
table_summary(3,10) = p_inoutperday;

%%%%%%%%%%%%%%%%%%% outin/day row
table_summary(4,1) = median(table_results3(onaga_ind3,14));
table_summary(4,2) = quantile(table_results3(onaga_ind3,14),.25);
table_summary(4,3) = quantile(table_results3(onaga_ind3,14),.75);
table_summary(4,4) = median(table_results3(ehu_ind3,14));
table_summary(4,5) = quantile(table_results3(ehu_ind3,14),.25);
table_summary(4,6) = quantile(table_results3(ehu_ind3,14),.75);
table_summary(4,7) = median(table_results3(paka_ind3,14));
table_summary(4,8) = quantile(table_results3(paka_ind3,14),.25);
table_summary(4,9) = quantile(table_results3(paka_ind3,14),.75);
table_summary(4,10) = poutinperday;

%%%%%%%%%%%%%%%%%%% DAYS INSIDE BRFA resin/day row
table_summary(5,1) = median(table_results3(onaga_ind3,15));
table_summary(5,2) = quantile(table_results3(onaga_ind3,15),.25);
table_summary(5,3) = quantile(table_results3(onaga_ind3,15),.75);
table_summary(5,4) = median(table_results3(ehu_ind3,15));
table_summary(5,5) = quantile(table_results3(ehu_ind3,15),.25);
table_summary(5,6) = quantile(table_results3(ehu_ind3,15),.75);
table_summary(5,7) = median(table_results3(paka_ind3,15));
table_summary(5,8) = quantile(table_results3(paka_ind3,15),.25);
table_summary(5,9) = quantile(table_results3(paka_ind3,15),.75);
table_summary(5,10) = p_resinperday;

%%%%%%%%%%%%%%%%%%% DAYS OUTSIDE BRFA    resout/day row
table_summary(6,1) = median(table_results3(onaga_ind3,16));
table_summary(6,2) = quantile(table_results3(onaga_ind3,16),.25);
table_summary(6,3) = quantile(table_results3(onaga_ind3,16),.75);
table_summary(6,4) = median(table_results3(ehu_ind3,16));
table_summary(6,5) = quantile(table_results3(ehu_ind3,16),.25);
table_summary(6,6) = quantile(table_results3(ehu_ind3,16),.75);
table_summary(6,7) = median(table_results3(paka_ind3,16));
table_summary(6,8) = quantile(table_results3(paka_ind3,16),.25);
table_summary(6,9) = quantile(table_results3(paka_ind3,16),.75);
table_summary(6,10) = p_resoutperday;

%%%%%%%%%%%%%%%%%%% DAYS INSIDE BRFA    days_in/days_detected
table_summary(7,1) = median(table_results3(onaga_ind3,18));
table_summary(7,2) = quantile(table_results3(onaga_ind3,18),.25);
table_summary(7,3) = quantile(table_results3(onaga_ind3,18),.75);
table_summary(7,4) = median(table_results3(ehu_ind3,18));
table_summary(7,5) = quantile(table_results3(ehu_ind3,18),.25);
table_summary(7,6) = quantile(table_results3(ehu_ind3,18),.75);
table_summary(7,7) = median(table_results3(paka_ind3,18));
table_summary(7,8) = quantile(table_results3(paka_ind3,18),.25);
table_summary(7,9) = quantile(table_results3(paka_ind3,18),.75);
table_summary(7,10) = p_dayinperdaydet;

%%%%%%%%%%%%%%%%%%% DAYS OUTSIDE BRFA    days_OUT/days_detected
table_summary(8,1) = median(table_results3(onaga_ind3,19));
table_summary(8,2) = quantile(table_results3(onaga_ind3,19),.25);
table_summary(8,3) = quantile(table_results3(onaga_ind3,19),.75);
table_summary(8,4) = median(table_results3(ehu_ind3,19));
table_summary(8,5) = quantile(table_results3(ehu_ind3,19),.25);
table_summary(8,6) = quantile(table_results3(ehu_ind3,19),.75);
table_summary(8,7) = median(table_results3(paka_ind3,19));
table_summary(8,8) = quantile(table_results3(paka_ind3,19),.25);
table_summary(8,9) = quantile(table_results3(paka_ind3,19),.75);
table_summary(8,10) = p_dayoutperdaydet;

%%%%%%%%%%%%%%%%%%% Track Days
table_summary(9,1) = median(table_results3(onaga_ind3,6));
table_summary(9,2) = quantile(table_results3(onaga_ind3,6),.25);
table_summary(9,3) = quantile(table_results3(onaga_ind3,6),.75);
table_summary(9,4) = median(table_results3(ehu_ind3,6));
table_summary(9,5) = quantile(table_results3(ehu_ind3,6),.25);
table_summary(9,6) = quantile(table_results3(ehu_ind3,6),.75);
table_summary(9,7) = median(table_results3(paka_ind3,6));
table_summary(9,8) = quantile(table_results3(paka_ind3,6),.25);
table_summary(9,9) = quantile(table_results3(paka_ind3,6),.75);
table_summary(9,10) = p_trackdays;

%%%%%%%%%%%%%%%%%%% Days Detected
table_summary(10,1) = median(table_results3(onaga_ind3,7));
table_summary(10,2) = quantile(table_results3(onaga_ind3,7),.25);
table_summary(10,3) = quantile(table_results3(onaga_ind3,7),.75);
table_summary(10,4) = median(table_results3(ehu_ind3,7));
table_summary(10,5) = quantile(table_results3(ehu_ind3,7),.25);
table_summary(10,6) = quantile(table_results3(ehu_ind3,7),.75);
table_summary(10,7) = median(table_results3(paka_ind3,7));
table_summary(10,8) = quantile(table_results3(paka_ind3,7),.25);
table_summary(10,9) = quantile(table_results3(paka_ind3,7),.75);
table_summary(10,10) = p_days_det;

%%%%%%%%%%%%%%%%%%% movement distance (medians for each fish)
table_summary(11,1) = median(table_results3(onaga_ind3,20));
table_summary(11,2) = quantile(table_results3(onaga_ind3,20),.25);
table_summary(11,3) = quantile(table_results3(onaga_ind3,20),.75);
table_summary(11,4) = median(table_results3(ehu_ind3,20));
table_summary(11,5) = quantile(table_results3(ehu_ind3,20),.25);
table_summary(11,6) = quantile(table_results3(ehu_ind3,20),.75);
table_summary(11,7) = median(table_results3(paka_ind3,20));
table_summary(11,8) = quantile(table_results3(paka_ind3,20),.25);
table_summary(11,9) = quantile(table_results3(paka_ind3,20),.75);
table_summary(11,10) = p_mov_dist_med;

%%%%%%%%%%%%%%%%%%% movement distance (max for each fish)
table_summary(12,1) = median(table_results3(onaga_ind3,21));
table_summary(12,2) = quantile(table_results3(onaga_ind3,21),.25);
table_summary(12,3) = quantile(table_results3(onaga_ind3,21),.75);
table_summary(12,4) = median(table_results3(ehu_ind3,21));
table_summary(12,5) = quantile(table_results3(ehu_ind3,21),.25);
table_summary(12,6) = quantile(table_results3(ehu_ind3,21),.75);
table_summary(12,7) = median(table_results3(paka_ind3,21));
table_summary(12,8) = quantile(table_results3(paka_ind3,21),.25);
table_summary(12,9) = quantile(table_results3(paka_ind3,21),.75);
table_summary(12,10) = p_mov_dist_max;

%%%%%%%%%%%%%%%%%%% movement distance (medians for each fish)
table_summary(13,1) = median(table_results3(onaga_ind3,22));
table_summary(13,2) = quantile(table_results3(onaga_ind3,22),.25);
table_summary(13,3) = quantile(table_results3(onaga_ind3,22),.75);
table_summary(13,4) = median(table_results3(ehu_ind3,22));
table_summary(13,5) = quantile(table_results3(ehu_ind3,22),.25);
table_summary(13,6) = quantile(table_results3(ehu_ind3,22),.75);
table_summary(13,7) = median(table_results3(paka_ind3,22));
table_summary(13,8) = quantile(table_results3(paka_ind3,22),.25);
table_summary(13,9) = quantile(table_results3(paka_ind3,22),.75);
table_summary(13,10) = p_mov_dist_min;







figure
subplot 421
hist(onaga_det)
xlabel('detections')
ylabel('frequency')
title('onaga')
subplot 422
hist(onaga_trackdays)
xlabel('track days')
subplot 423
hist(onaga_days_det)
xlabel('days detected')
subplot 424
hist(onaga_mvt)
xlabel('movements')
subplot 425
hist(onaga_inout)
xlabel('in-out movements')
subplot 426
hist(onaga_outin)
xlabel('out-in movements')
subplot 427
hist(onaga_res_in)
xlabel('resident in days')
subplot 428
hist(onaga_res_out)
xlabel('resident out days')







figure
subplot 421
hist(ehu_det)
xlabel('detections')
ylabel('frequency')
title('ehu')
subplot 422
hist(ehu_trackdays)
xlabel('track days')
subplot 423
hist(ehu_days_det)
xlabel('days detected')
subplot 424
hist(ehu_mvt)
xlabel('movements')
subplot 425
hist(ehu_inout)
xlabel('in-out movements')
subplot 426
hist(ehu_outin)
xlabel('out-in movements')
subplot 427
hist(ehu_res_in)
xlabel('resident in days')
subplot 428
hist(ehu_res_out)
xlabel('resident out days')

figure
subplot 421
hist(Opakapaka_det)
xlabel('detections')
ylabel('frequency')
title('Opakapaka')
subplot 422
hist(Opakapaka_trackdays)
xlabel('track days')
subplot 423
hist(Opakapaka_days_det)
xlabel('days detected')
subplot 424
hist(Opakapaka_mvt)
xlabel('movements')
subplot 425
hist(Opakapaka_inout)
xlabel('in-out movements')
subplot 426
hist(Opakapaka_outin)
xlabel('out-in movements')
subplot 427
hist(Opakapaka_res_in)
xlabel('resident in days')
subplot 428
hist(Opakapaka_res_out)
xlabel('resident out days')

%%%%%%HAVENT EVEN TOUCHED THIS YET.....

%%%%%%%%%%%%%%%%%%%%% onaga vs ehu

figure
% subplot 221
% boxplot(table_results3(:,17),table_results3(:,11))
% set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
% set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
% ylabel('detections/day detected')
subplot 321
boxplot(table_results3(:,6),table_results3(:,11))
set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
ylabel('track duration (days)')

subplot 322
boxplot(table_results3(:,12),table_results3(:,11))
set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
ylabel('movements/day detected')

subplot 323
boxplot(table_results3(:,14),table_results3(:,11))
set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
ylabel('enterings/day detected')

subplot 324
boxplot(table_results3(:,13),table_results3(:,11))
set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
ylabel('departures/day detected')

subplot 325
boxplot(table_results3(:,21),table_results3(:,11))
set(gca,'xtick',[1:length(unique(table_results3(:,11)))]) %%% as far as I can tell the boxplot doesnt come with xticks, so you have to make them, otherwise you can't set xticklabels.
set(gca,'XTickLabel',{'E. coruscans','E. carbunculus'},'fontsize',12)
ylabel('max movement distance')







figure
subplot 421
hist(table_results3(onaga_ind3,17))
xlabel('detections')
ylabel('frequency')
title('ehu')
subplot 422
hist(ehu_trackdays)
xlabel('track days')
subplot 423
hist(ehu_days_det)
xlabel('days detected')
subplot 424
hist(ehu_mvt)
xlabel('movements')
subplot 425
hist(ehu_inout)
xlabel('in-out movements')
subplot 426
hist(ehu_outin)
xlabel('out-in movements')
subplot 427
hist(ehu_res_in)
xlabel('resident in days')
subplot 428
hist(ehu_res_out)
xlabel('resident out days')


figure
subplot 421
aboxplot(table_results3(onaga_ind3,17));
boxplot(detections_all,species);
ylabel('detections')
subplot 422
boxplot(track_days_all,species); ylabel('track days')
subplot 423
boxplot(Days_detected_all,species); ylabel('Days detected')
subplot 424
boxplot(movements_all,species); ylabel('movements')
subplot 425
boxplot(inout_all,species); ylabel('in-out movements')
subplot 426
boxplot(outin_all,species); ylabel('out-in movements')
subplot 427
boxplot(resident_in_all,species); ylabel('resident in days')
subplot 428
boxplot(resident_out_all,species); ylabel('resident out days')


figure
subplot 421
notBoxPlot([onaga_det,[ehu_det;NaN(length(onaga_det)-length(ehu_det),1)]])
ylim([0 max([onaga_det;ehu_det])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('detections')
subplot 422
notBoxPlot([onaga_trackdays,[ehu_trackdays;NaN(length(onaga_trackdays)-length(ehu_trackdays),1)]])
ylim([0 max([onaga_trackdays;ehu_trackdays])*1.1])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('trackdays')
subplot 423
notBoxPlot([onaga_mvt,[ehu_mvt;NaN(length(onaga_mvt)-length(ehu_mvt),1)]])
ylim([0 max([onaga_mvt;ehu_mvt])*1.1])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('movements')
subplot 424
notBoxPlot([onaga_det_ratio,[ehu_det_ratio;NaN(length(onaga_det_ratio)-length(ehu_det_ratio),1)]])
ylim([0 max([onaga_det_ratio;ehu_det_ratio])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('detection ratio')
subplot 425
notBoxPlot([onaga_inout,[ehu_inout;NaN(length(onaga_inout)-length(ehu_inout),1)]])
ylim([0 max([onaga_inout;ehu_inout])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('in-out movements')
subplot 426
notBoxPlot([onaga_outin,[ehu_outin;NaN(length(onaga_outin)-length(ehu_outin),1)]])
ylim([0 max([onaga_outin;ehu_outin])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('out-in movements')
subplot 427
notBoxPlot([onaga_res_in,[ehu_res_in;NaN(length(onaga_res_in)-length(ehu_res_in),1)]])
ylim([0 max([onaga_res_in;ehu_res_in])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('resident in days')
subplot 428
notBoxPlot([onaga_res_out,[ehu_res_out;NaN(length(onaga_res_out)-length(ehu_res_out),1)]])
ylim([0 max([onaga_res_out;ehu_res_out])])
set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
ylabel('resident out days')







% figure
% subplot 421
% notBoxPlot([onaga_det,[ehu_det;NaN(length(onaga_det)-length(ehu_det),1)]])
% ylim([0 max([onaga_det;ehu_det])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('detections')
% subplot 422
% notBoxPlot([onaga_trackdays,[ehu_trackdays;NaN(length(onaga_trackdays)-length(ehu_trackdays),1)]])
% ylim([0 max([onaga_trackdays;ehu_trackdays])*1.1])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('trackdays')
% subplot 423
% notBoxPlot([onaga_mvt,[ehu_mvt;NaN(length(onaga_mvt)-length(ehu_mvt),1)]])
% ylim([0 max([onaga_mvt;ehu_mvt])*1.1])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('movements')
% subplot 424
% notBoxPlot([onaga_det_ratio,[ehu_det_ratio;NaN(length(onaga_det_ratio)-length(ehu_det_ratio),1)]])
% ylim([0 max([onaga_det_ratio;ehu_det_ratio])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('detection ratio')
% subplot 425
% notBoxPlot([onaga_inout,[ehu_inout;NaN(length(onaga_inout)-length(ehu_inout),1)]])
% ylim([0 max([onaga_inout;ehu_inout])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('in-out movements')
% subplot 426
% notBoxPlot([onaga_outin,[ehu_outin;NaN(length(onaga_outin)-length(ehu_outin),1)]])
% ylim([0 max([onaga_outin;ehu_outin])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('out-in movements')
% subplot 427
% notBoxPlot([onaga_res_in,[ehu_res_in;NaN(length(onaga_res_in)-length(ehu_res_in),1)]])
% ylim([0 max([onaga_res_in;ehu_res_in])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('resident in days')
% subplot 428
% notBoxPlot([onaga_res_out,[ehu_res_out;NaN(length(onaga_res_out)-length(ehu_res_out),1)]])
% ylim([0 max([onaga_res_out;ehu_res_out])])
% set(gca,'xticklabel',{'onaga','ehu'},'fontsize',10)
% ylabel('resident out days')
% 




%%%%%%% create a density plot of 
Lat_7day =[]; Lon_7day = [];
Trans_7day = [7581;7586;52153;57378;57379;57385;57387;57388;57389;57390;57391;57394;57395;57404;57405;52147;52151;52154;52155;52158;52160];
for i_7day = 1:length(Trans_7day)
    Lat_7 = Latitude3(find(Transmitter3==Trans_7day(i_7day)));
    Lon_7 = Longitude3(find(Transmitter3==Trans_7day(i_7day)));
    Lat_7day = [Lat_7day;Lat_7];
    Lon_7day = [Lon_7day;Lon_7];
end

incr = 0.01;
LL_data = [Lon_7day Lat_7day];
bins_lon = [-160.1833333:incr:-160.0166667];
bins_lat = [21.73333333:incr:21.9];
%bins_ = [bins_lon;bins_lat]'
LL_array = hist3(LL_data,{bins_lon bins_lat});
LL_array = flipud(LL_array);



