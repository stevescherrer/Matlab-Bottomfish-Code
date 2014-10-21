TagID = VarName1;
Date = VarName2;
ReceiverID = VarName3;
Distancem = VarName4;
ReturnRate = VarName5;


RangeData = [ReceiverID, TagID, Distancem, ReturnRate, Date];
rangedata=RangeData;
range_data = rangedata;

%rangedata=rangedata(rangedata(:,3)>100,:);

low_0=18236;
high_0=18237;
low_200=18238;
high_200=18239; %this has low detections....
low_400=18240;
high_400=18241;
low_600=18242;
high_600=18243;
low_800=18244;
high_800=18245;
low_1000=18246;
high_1000=18247;

high_tags=[rangedata(rangedata(:,2)==18237,:); rangedata(rangedata(:,2)==18239,:); rangedata(rangedata(:,2)==18241,:); rangedata(rangedata(:,2)==18243,:); rangedata(rangedata(:,2)==18245,:); rangedata(rangedata(:,2)==18247,:)]; 
low_tags=[rangedata(rangedata(:,2)==18236,:); rangedata(rangedata(:,2)==18238,:); rangedata(rangedata(:,2)==18240,:); rangedata(rangedata(:,2)==18242,:); rangedata(rangedata(:,2)==18244,:); rangedata(rangedata(:,2)==18246,:)]; 
high_tags_high_receiver=high_tags(high_tags(:,1)==123732,:);
high_tags_low_receiver=high_tags(high_tags(:,1)==123736,:);
low_tags_low_receiver=low_tags(low_tags(:,1)==123732,:);
low_tags_high_receiver=low_tags(low_tags(:,1)==123736,:);

high_receiver=rangedata(rangedata(:,1)==123732,:);
low_receiver=rangedata(rangedata(:,1)==123736,:);

data_0=[range_data(range_data(:,2)==low_0,:) ; range_data(range_data(:,2)==high_0,:)];
data_200=[range_data(range_data(:,2)==low_200,:) ; range_data(range_data(:,2)==high_200,:)];
data_400=[range_data(range_data(:,2)==low_400,:) ; range_data(range_data(:,2)==high_400,:)];
data_600=[range_data(range_data(:,2)==low_600,:) ; range_data(range_data(:,2)==high_600,:)];
data_800=[range_data(range_data(:,2)==low_800,:) ; range_data(range_data(:,2)==high_800,:)];
data_1000=[range_data(range_data(:,2)==low_1000,:) ; range_data(range_data(:,2)==high_1000,:)];

low_receiver_low_0=low_receiver(low_receiver(:,2)==low_0,:);
low_receiver_low_200=low_receiver(low_receiver(:,2)==low_200,:);
low_receiver_low_400=low_receiver(low_receiver(:,2)==low_400,:);
low_receiver_low_600=low_receiver(low_receiver(:,2)==low_600,:);
low_receiver_low_800=low_receiver(low_receiver(:,2)==low_800,:);
low_receiver_low_1000=low_receiver(low_receiver(:,2)==low_1000,:);
high_receiver_high_0=high_receiver(high_receiver(:,2)==high_0,:);
high_receiver_high_200=high_receiver(high_receiver(:,2)==high_200,:);
high_receiver_high_400=high_receiver(high_receiver(:,2)==high_400,:);
high_receiver_high_600=high_receiver(high_receiver(:,2)==high_600,:);
high_receiver_high_800=high_receiver(high_receiver(:,2)==high_800,:);
high_receiver_high_1000=high_receiver(high_receiver(:,2)==high_1000,:);


low_detections_200_dates=datestr(data_200(data_200(:,4)<.25,5));
high_detections_200_dates=datestr(data_200(data_200(:,4)>.25,5));
tag_low_detections_200=data_200(data_200(:,4)<.25,:);
tag_low_detections_200=data_200(data_200(:,4)>.25,2);
size(low_detections_200_dates);
size(high_detections_200_dates);

low_detections=[data_0(data_0(:,4) == 0,:); data_200(data_200(:,4)<.25,:);data_600(data_600(:,4)<.2,:);data_800(data_800(:,4)<.16,:)];
low_tags=unique(low_detections(:,2));
low_dates=datestr(unique(low_detections(:,5)));

low_detections_200=data_200(data_200(:,4)<.25,:);
low_tag_200=unique(low_detections_200(:,2));
low_date_200=datestr(unique(low_detections_200(:,5)));
low_receiver_200=unique(low_detections_200(:,1));
% the only tag responsible for the low detections at 200m is tag 18239 (the
    % one at 15m).  The only receiver reporting low detections is 123736
    % which is the receiver at 0.2m

low_detections_600=data_600(data_600(:,4)<.2,:);
low_tag_600=unique(low_detections_600(:,2));
low_date_600=datestr(unique(low_detections_600(:,5)));
low_receiver_600=unique(low_detections_600(:,1));

low_detections_800=data_600(data_800(:,4)<.2,:);
low_tag_800=unique(low_detections_800(:,2));
low_date_800=datestr(unique(low_detections_800(:,5)));
low_receiver_800=unique(low_detections_800(:,1));

%line plot
figure
clear returns_array
returns_array = [data_0(:,4), data_200(:,4), data_400(:,4), data_600(:,4), data_800(:,4), data_1000(:,4)];
x_matrix = ones(length(returns_array(:,1)),6);
x_axis = [0, 200, 400, 600, 800, 1000];
returns_mean = mean(returns_array, 1);
std_dev = std(returns_array);
for i = 1:length(x_matrix(1,:));
    if i == 1
        x_matrix(:,i) = x_matrix(:,i) * 0;
    elseif i == 2
        x_matrix(:,i) = x_matrix(:,i) * 200;
    elseif i == 3
        x_matrix(:,i) = x_matrix(:,i) * 400;
    elseif i == 4
        x_matrix(:,i) = x_matrix(:,i) * 600;
    elseif i == 5
        x_matrix(:,i) = x_matrix(:,i) * 800;
    elseif i == 6
        x_matrix(:,i) = x_matrix(:,i) * 1000;
    end
end
    
errorbar(x_axis, returns_mean, std_dev) 
%plot(x_axis, mean(returns_array,1))

figure
clear returns_array
returns_array = [low_detections(:,4), low_detections(:,4), low_detections(:,4), low_detections(:,4), low_detections(:,4), low_detections(:,4)];
x_matrix = ones(length(returns_array(:,1)),6);
x_axis = [0, 200, 400, 600, 800, 1000];
returns_mean = mean(returns_array, 1);
std_dev = std(returns_array);
for i = 1:length(x_matrix(1,:));
    if i == 1
        x_matrix(:,i) = x_matrix(:,i) * 0;
    elseif i == 2
        x_matrix(:,i) = x_matrix(:,i) * 200;
    elseif i == 3
        x_matrix(:,i) = x_matrix(:,i) * 400;
    elseif i == 4
        x_matrix(:,i) = x_matrix(:,i) * 600;
    elseif i == 5
        x_matrix(:,i) = x_matrix(:,i) * 800;
    elseif i == 6
        x_matrix(:,i) = x_matrix(:,i) * 1000;
    end
end
    
errorbar(x_axis, returns_mean, std_dev) 


%%Plotting higher receiver
figure
clear returns_array
returns_array = [data_0(:,4), data_200(:,4), data_400(:,4), data_600(:,4), data_800(:,4), data_1000(:,4)];
x_matrix = ones(length(returns_array(:,1)),6);
x_axis = [0, 200, 400, 600, 800, 1000];
returns_mean = mean(returns_array, 1);
std_dev = std(returns_array);
for i = 1:length(x_matrix(1,:));
    if i == 1
        x_matrix(:,i) = x_matrix(:,i) * 0;
    elseif i == 2
        x_matrix(:,i) = x_matrix(:,i) * 200;
    elseif i == 3
        x_matrix(:,i) = x_matrix(:,i) * 400;
    elseif i == 4
        x_matrix(:,i) = x_matrix(:,i) * 600;
    elseif i == 5
        x_matrix(:,i) = x_matrix(:,i) * 800;
    elseif i == 6
        x_matrix(:,i) = x_matrix(:,i) * 1000;
    end
end
    
errorbar(x_axis, returns_mean, std_dev) 


figure
s_plotrangedata(high_receiver,'b')
hold all
s_plotrangedata(low_receiver,'r')
hold all
legend('30m receiver', '0.2m receiver')
xlabel('Distance from receiver (m)')
ylabel('% of pings recovered')
title('Average Range Results for Receivers at 2 heights')

figure
s_plotrangedata(high_receiver,'b')
hold all
s_plotrangedata(high_tags_high_receiver, 'c')
s_plotrangedata(low_tags_high_receiver, 'g')
legend('30m receiver - all tags' , '30m receiver - 15m tags', '30m receiver - 0.2m tags')
xlabel('Distance from receiver (m)')
ylabel('% of pings recovered')
title('Range Test Results for receiver at 30m')



figure
s_plotrangedata(low_receiver,'r')
hold all
s_plotrangedata(high_tags_low_receiver, 'k')
s_plotrangedata(low_tags_low_receiver, 'm')
legend('0.2m receiver - all tags' , '0.2m receiver - 15m tags', '0.2m receiver - 0.2m tags')
xlabel('Distance from receiver (m)')
ylabel('% of pings recovered')
title('Range Test Results for receiver at 0.2m')

figure



