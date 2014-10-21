paka_tags = [37935,37936,37937,37938,37939,37940,37941,37948,37949,37950,37951,...
    37952,37953,37954,37955,37956,37957,37958,37959,37960,37961,37962,37963,37965,...
    37967,37968,37969,37970,37971,37975,37976,37977,37978,37979,37980,37981,37982,...
    37983,37984,57445,57446,57447,57447,57448,57449,57450,57451,57455,57456,57457,...
    57458,57459,57460,57462,57463,57464,57465,57466];

ehu_tags = [37973,37974,37976,37977,57447,57447];

kalekale_tags = [57446];

gindai_tags = [57452];

paka_db = [];
for i = 1:length(paka_tags);
    paka_db = [paka_db; OahuDatabase(OahuDatabase(:,1)==paka_tags(i),:)];
end

%% How long each tag was active for. if tag active for more than 2 weeks, output as a list
tags = unique(paka_db(:,1));
paka_tags2wks = [];
paka_time_active = zeros(length(tags),3);
for i = 1:length(tags)
    indv_record = paka_db(paka_db(:,1)==tags(i),:); 
    if length(indv_record(:,2))>1 
        active_days = max(indv_record(:,2))-min(indv_record(:,2));
    else
        active_days = 1;
    end
    if active_days >= 14
        paka_tags2wks = [paka_tags2wks, tags(i)];
    end
    paka_time_active(i,1) = tags(i); %tag ID
    paka_time_active(i,2) = ceil(active_days); %Days active
    paka_time_active(i,3) = length(indv_record(:,2)); % Total detections
end
 
ehu_db = [];
for i = 1:length(ehu_tags);
    ehu_db = [ehu_db; OahuDatabase(OahuDatabase(:,1)==ehu_tags(i),:)];
end

%% How long each tag was active for. if tag active for more than 2 weeks, output as a list
tags = unique(ehu_db(:,1));
ehu_tags2wks = [];
ehu_time_active = zeros(length(tags),3);
for i = 1:length(tags)
    indv_record = ehu_db(ehu_db(:,1)==tags(i),:); 
    if length(indv_record(:,2))>1 
        active_days = max(indv_record(:,2))-min(indv_record(:,2));
    else
        active_days = 1;
    end
    if active_days >= 14
        tags2wks = [tags2wks, tags(i)];
    end
    ehu_time_active(i,1) = tags(i); %tag ID
    ehu_time_active(i,2) = ceil(active_days); %Days active
    ehu_time_active(i,3) = length(indv_record(:,2)); % Total detections
end

gindai_db = [];
for i = 1:length(gindai_tags);
    gindai_db = [gindai_db; OahuDatabase(OahuDatabase(:,1)==gindai_tags(i),:)];
end
 
%% How long each tag was active for. if tag active for more than 2 weeks, output as a list
tags = unique(gindai_db(:,1));
gindai_tags2wks = [];
gindai_time_active = zeros(length(tags),3);
for i = 1:length(tags)
    indv_record = gindai_db(gindai_db(:,1)==tags(i),:); 
    if length(indv_record(:,2))>1 
        active_days = max(indv_record(:,2))-min(indv_record(:,2));
    else
        active_days = 1;
    end
    if active_days >= 14
        tags2wks = [tags2wks, tags(i)];
    end
    gindai_time_active(i,1) = tags(i); %tag ID
    gindai_time_active(i,2) = ceil(active_days); %Days active
    gindai_time_active(i,3) = length(indv_record(:,2)); % Total detections
end
 
kalekale_db = [];
for i = 1:length(kalekale_tags);
    kalekale_db = [kalekale_db; OahuDatabase(OahuDatabase(:,1)==kalekale_tags(i),:)];
end
 
%% How long each tag was active for. if tag active for more than 2 weeks, output as a list
tags = unique(kalekale_db(:,1));
kalekale_tags2wks = [];
kalekale_time_active = zeros(length(tags),3);
for i = 1:length(tags)
    indv_record = kalekale_db(kalekale_db(:,1)==tags(i),:); 
    if length(indv_record(:,2))>1 
        active_days = max(indv_record(:,2))-min(indv_record(:,2));
    else
        active_days = 1;
    end
    if active_days >= 14
        tags2wks = [tags2wks, tags(i)];
    end
    kalekale_time_active(i,1) = tags(i); %tag ID
    kalekale_time_active(i,2) = ceil(active_days); %Days active
    kalekale_time_active(i,3) = length(indv_record(:,2)); % Total detections
end
 





 
