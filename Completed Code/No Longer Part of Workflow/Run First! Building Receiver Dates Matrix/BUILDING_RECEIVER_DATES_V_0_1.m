%%%FOR BUILDING RECEIVERDATES MATRIX FROM THE DEPLOYMENT RECOVERY LOG
%%WRITTEN 3 JANUARY 2014 IN A COFFEE SHOP IN CAMPBELL BY STEPHEN SCHERRER

%%NOTES: 
%%THIS PROGARM REQUIRES DEPLOYMENT_RECOVERY_LOG.CSV TO BUILD ReceiverDates,
%%A COMMON MATRIX USED IN MANY OTHER CODES. RUN THIS AFTER EVERY DATA
%%DOWNLOAD FROM THE FIELD TO UPDATE DATABASE.

%%NOTES ON OUTPUT FILE:
%%RecieverDates
    %%Column 1=Reciever Location
    %%Column 2=Reciever Number
    %%Column 3=Deployment Date
    %%Column 4=Recovery Date
    %%Column 5=Deployment Latitude (prefix)
    %%Column 6=Deployment Latitude (degree minutes)
    %%Column 7=Deployment Longitude (prefix)
    %%Column 8=Deployment Longitude (degree minutes)
    %%Column 9=Deployment Longitude (decimal degrees)
    %%Column 10=Deployment Latitude (decimal Degrees) 
    
    DateAdjustment=datenum(2011,10,01)-min(DEPLOYMENT_DATE); %determines date offset from any other date format
    AdjustedDeploymentDates=DEPLOYMENT_DATE+DateAdjustment; %creates new variable with this date adjustment for deployments
    AdjustedRecoveryDates=RECOVERY_DATE+DateAdjustment; %creates new variable with this date adjustment for recoveries
    
    TemporaryReceiverDates=[STEVES_ARBITRARY_LOCATION,VR2_SERIAL_NO,AdjustedDeploymentDates, AdjustedRecoveryDates, Lat_deg, Lat_min, Lon_deg, Lon_min];
    Addendum=nan(length(TemporaryReceiverDates),2);
    TemporaryReceiverDates=[TemporaryReceiverDates, Addendum];
    
    if TemporaryReceiverDates(:,5)>0
        TemporaryReceiverDates(:,9)=TemporaryReceiverDates(:,5)+(TemporaryReceiverDates(:,6)./(60));
    elseif TemporaryReceiverDates(:,5)<0
        TemporaryReceiverDates(:,9)=TemporaryReceiverDates(:,5)-(TemporaryReceiverDates(:,6)./(60));
    end
    

    if TemporaryReceiverDates(:,7)>0
    TemporaryReceiverDates(:,10)=TemporaryReceiverDates(:,7)+(TemporaryReceiverDates(:,8)./(60));
    elseif TemporaryReceiverDates(:,7)<0
    TemporaryReceiverDates(:,10)=TemporaryReceiverDates(:,7)-(TemporaryReceiverDates(:,8)./(60));
    end
    
    
    
    if length(TemporaryReceiverDates)==length(IN_DATA_SET);
        IndexOfReceiversWithData=IN_DATA_SET==1;
        ReceiverDates=TemporaryReceiverDates(IndexOfReceiversWithData,:);
        clear Addendum RECOVERY_DATE DateAdjustment CONSECUTIVE_DEPLOY_NO IndexOfReceiversWithData TemporaryReceiverDates AdjustedDeploymentDates AdjustedRecoveryDates AR_EXPECTED_BATTERY_LIFE AR_RELEASE_CODE AR_SERIAL_NO AR_VOLTAGE_AT_DEPLOY BOTTOM_DEPTH COMMENTS_DEPLOYMENT COMMENTS_RECOVERY CONSECUTIVE_DEPLOYMENTS DEPLOYED_BYLeadTechnician DEPLOYMENT_DATE DEPLOYMENT_TIME DATEADJUSTMENT Downloaded IN_DATA_SET Lat_deg Lon_deg Lat_min Lon_min RD RECOVER_DATE RECOVERY_TIME RecoveredBy SERVICED STATION_NO STEVES_ARBITRARY_LOCATION TempLoggerserial VR2_SERIAL_NO VarName26 VarName27 VarName28 VarName29 VarName30 i;
    else
        disp ('There is a size mismatch between ReceiverDates and IN_DATA_SET vectors. See DEPLOYMENT_AND_RECOVERY_LOG.csv and import for troubleshooting')
    end
   