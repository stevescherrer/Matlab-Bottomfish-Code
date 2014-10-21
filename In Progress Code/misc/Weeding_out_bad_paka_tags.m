all_paka=[];
Opakapaka=[];
sharked_paka=[];


Bad_Tags=[37950, 37952, 37955, 37958, 37970, 37975, 57459, 57463];
viable_tags=[37960, 37961, 57455, 57457];
possible_prey_tags=37980;
tag_at_wrong_receiver=57464;
All_Tags=[Bad_Tags, viable_tags, possible_prey_tags];

for i=1:length(All_Tags);
    indiv=BottomFish(BottomFish(:,1)==All_Tags(i),:);
    all_paka=[all_paka;indiv];
end

for i=1:length(viable_tags);
    indiv=all_paka(all_paka(:,1)==viable_tags(i),:);
    Opakapaka=[Opakapaka;indiv];
end

sharked_paka=all_paka(all_paka(:,1)==possible_prey_tags,:);

clear i  indiv 