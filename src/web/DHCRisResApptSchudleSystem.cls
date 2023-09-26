Import SQLUser

Class web.DHCRisResApptSchudleSystem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCRisResApptSchudleSystem).GetBookedParam("20019","20017||3884@20017||3873","6904","Y","685")
ClassMethod GetBookedParam(paadmdr As %String, OrderItemRowid As %String, ResSchduleID As %String, UserID As %String) As %String
{
    s (ResourcesInfo,GetEQDR,GetRoomDR,GroupDescDR,GetResDesc,GetRoomDesc,GroupDesc)=""
    s (RecLocDR,AppSetDR,perOrderItemRowid,Param,IsCIndex)=""
    s (IndexclsInfo,GetIndex,GetNoRuleCode,GetTypeDesc,GetAppDateType)=""
    s (Index,GroupIndex,RoomIndex,GetTypeRowid,MuitStudyNoInfo,SelectDate)=""
    s (OutParam,GetAppointMethod,PACSStudyNo)=""
    //w !,"AppFlag="_AppFlag
    s perOrderItemRowid=$p(OrderItemRowid,"@",1)
    s AppMethodDR=..GetAppointMethod(perOrderItemRowid) 
    //w !,"perOrderItemRowid="_perOrderItemRowid
    s ResourcesInfo=..InitSelResources(ResSchduleID)
    //w !,"ResourcesInfo="_ResourcesInfo
    i ResourcesInfo'="" d
    .s GetEQDR=$p($g(ResourcesInfo),"^",1)
    .s GetRoomDR=$p($g(ResourcesInfo),"^",2)
    .s GroupDescDR=$p($g(ResourcesInfo),"^",3)
    .s GroupDesc=$p($g(ResourcesInfo),"^",6)
    .s SelectDate=$p($g(ResourcesInfo),"^",7)
    .s RecLocDR=$p(^OEORD($p(perOrderItemRowid,"||",1),"I",$p(perOrderItemRowid,"||",2),3),"^",6)
    .s AppSetDR=$o(^DHCRBCLocResourceSeti("Booked-Resource",GetEQDR,AppSetDR))
    .i AppSetDR'="" s RecLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",AppSetDR)),"^",4)
    .s Param=GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_RecLocDR_"^"_perOrderItemRowid_"^"_ResSchduleID
    .s IsCIndex=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocDR)
    .i IsCIndex'="" s IsCIndex=$p(IsCIndex,"^",1)
    .i IsCIndex="B" d
    ..s IndexclsInfo=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)
    ..i IndexclsInfo'="" d
    ...s GetIndex=$p(IndexclsInfo,"^",1)
    ...s GetNoRuleCode=$p(IndexclsInfo,"^",2)
    ...s GetTypeDesc=$p(IndexclsInfo,"^",3)
    ...s GetAppDateType=$p(IndexclsInfo,"^",4)
    ...s GetTypeRowid=$p(IndexclsInfo,"^",5)
    ...i GetNoRuleCode="L" s Index=GetIndex
    ...i GetNoRuleCode="Z" s GroupIndex=GetIndex
    ...i GetNoRuleCode="R" s RoomIndex=GetIndex
    .s MuitStudyNoInfo=..GetMuitStudyNo(OrderItemRowid,GroupDesc,GroupDescDR,RecLocDR,SelectDate)
    .i MuitStudyNoInfo'="" d
    ..s OutParam=OrderItemRowid_"^"_ResSchduleID_"^"_AppMethodDR_"^^"_MuitStudyNoInfo_"^"_GetIndex_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR
    ..s OutParam=OutParam_"^"_paadmdr_"^"_GetTypeRowid_"^"_$zdh(SelectDate,"3")_"^"_UserID_"^"_PACSStudyNo_"^"_$g(AppFlag)_"^"_RecLocDR
    
    q OutParam
}

/// w ##class(web.DHCRisResApptSchudleSystem).GetMuitStudyNo("3||108","","3","83","2014-10-17")
/// 修改:2015-10-16 sunyi
ClassMethod GetMuitStudyNo(OrderItemRowid, GroupDesc, GroupDescDR, RecLocDR, SelectDate) As %String
{
    s MutiStudyNo="",counts=0
    s IsExit="N",LastStudyNo=""
    
    s Counts=$l(OrderItemRowid,"@")
    
    for i=1:1:Counts
    {  
        s persOrditemRowid="",Studyinfo="",StudyNumber=""
        s persOrditemRowid=$p(OrderItemRowid,"@",i)
        
        s StudyInfo=##class(web.DHCRisBookParam).GetStudyNo(persOrditemRowid,GroupDesc,RecLocDR,SelectDate)
        i StudyInfo'="" d
        .s InStudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
        .s StudyNumber=$p($g(StudyInfo),"^",2)
        .s IsUpdate=$p($g(StudyInfo),"^",3)
        
        i IsExit="Y" s InStudyNo=LastStudyNo
        s IsMore=""
        s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(RecLocDR,persOrditemRowid,GroupDesc)
        
        //多条医嘱产生多个检查号
        i (IsMore="Y")&(IsUpdate="1") d
        .s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(RecLocDR,GroupDescDR,StudyNumber,SelectDate)
        e  d
        .i (IsExit="N") d
        ..s LastStudyNo=InStudyNo  s IsExit="Y"
        ..s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(RecLocDR,GroupDescDR,StudyNumber,SelectDate)
        
        if MutiStudyNo="" d
        .s MutiStudyNo=InStudyNo
        e  d
        .s MutiStudyNo=MutiStudyNo_"@"_InStudyNo
    }
    
    q MutiStudyNo
}

/// w ##class(web.DHCRisResApptSchudleSystem).InitSelResources("6857")
ClassMethod InitSelResources(SchudleRowid As %String)
{
     s (ResourceId,ResDesc,CTCPDR,EQDR,ResDesc,RoomDR,GroupDescDR,RoomDesc,BookedDate,Info)=""
     s (RoomDesc)=""
     i SchudleRowid'="" d
     .s ResourceId=$p($g(^DHCRBCResourceSchdule(SchudleRowid)),"^",1)
     .s BookedDate=$p($g(^DHCRBCResourceSchdule(SchudleRowid)),"^",2)
     .i BookedDate'="" s BookedDate=$zd(BookedDate,3)
     .s ResDesc=""
     .i ResourceId'="" s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
     .s CTCPDR=$p(CTCPDR,$c(0))
     .i CTCPDR'="" d
     ..s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
     .else  d
     ..s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
     ..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
     ..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
     ..i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
     ..s GroupDescDR=$p($g(^RBC("EQ",EQDR)),"^",3)
     ..i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2)
     .s Info=$g(EQDR)_"^"_$g(RoomDR)_"^"_$g(GroupDescDR)_"^"_$g(ResDesc)_"^"_$g(RoomDesc)_"^"_$g(GroupDesc)_"^"_$g(BookedDate)
    
    q Info
}

/// 锁定预约资源记录
/// w ##class(web.DHCRisResApptSchudleSystem).LockApptRes("6842")
ClassMethod LockApptRes(InResSchduleID As %String) As %String
{
      s SQLCODE="-1"
      q:(InResSchduleID="") SQLCODE
      
      s MaxNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",7)      ;最大预约数
      s AutoNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",8)     ;自动预约数
      s UseNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",9)      ;总的使用数量
      s RemainNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",10)  ;总剩余数
      s AutoUseNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",13)  ;自动预约使用数
      s LockBookNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",15)  ;预占资源数量
      s RemainUnLockBookNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",16) ;预占资源剩余数
      
      i UseNumber="" s UseNumber=0
      i AutoUseNumber="" s AutoUseNumber=0
      i RemainNumber=""  s RemainNumber=0
      i RemainUnLockBookNumber="" s RemainUnLockBookNumber=MaxNumber
      i LockBookNumber="" s LockBookNumber=0
      
      i (RemainUnLockBookNumber>0)
      {
          s LockBookNumber=LockBookNumber+1
          s RemainUnLockBookNumber=RemainUnLockBookNumber-1
          
           &sql(update DHCRBC_ResSchdule (DRPS_LockBookNumber,DRPS_RemainUnLockBookNumber)
                              values (:LockBookNumber,:RemainUnLockBookNumber) where  DRPS_RowID=:InResSchduleID)     
      }
      
      q SQLCODE
}

/// w ##class(web.DHCRisResApptSchudleSystem).UnLockApptRes("6842")
ClassMethod UnLockApptRes(InResSchduleID As %String) As %String
{
      s SQLCODE="-1"
      q:(InResSchduleID="") SQLCODE
      
      s MaxNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",7)      ;最大预约数
      s AutoNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",8)     ;自动预约数
      s UseNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",9)      ;总的使用数量
      s RemainNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",10)  ;总剩余数
      s AutoUseNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",13)  ;自动预约使用数
      s LockBookNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",15)  ;预占资源数量
      s RemainUnLockBookNumber=$p($g(^DHCRBCResourceSchdule(InResSchduleID)),"^",16) ;预占资源剩余数
      
      i UseNumber="" s UseNumber=0
      i AutoUseNumber="" s AutoUseNumber=0
      i RemainNumber=""  s RemainNumber=0
      i RemainUnLockBookNumber="" s RemainUnLockBookNumber=MaxNumber
      i LockBookNumber="" s LockBookNumber=0
      
      i ((LockBookNumber>0)&(RemainUnLockBookNumber>=0))
      {
          s LockBookNumber=LockBookNumber-1
          s RemainUnLockBookNumber=RemainUnLockBookNumber+1
          
           &sql(update DHCRBC_ResSchdule (DRPS_LockBookNumber,DRPS_RemainUnLockBookNumber)
                              values (:LockBookNumber,:RemainUnLockBookNumber) where  DRPS_RowID=:InResSchduleID)     
      }
      
      q SQLCODE
}

/// w ##class(web.DHCRisResApptSchudleSystem).RequestFlag("6842")
ClassMethod RequestFlag(InResSchduleID As %String, InOrderItemRowid As %String, Inpaadmdr As %String) As %String
{
     s UseBookRes="N"
     q:(InResSchduleID="") UseBookRes
     q:(InOrderItemRowid="") UseBookRes
     q:(Inpaadmdr="") UseBookRes

     s InOrderItemRowid=$p(InOrderItemRowid,"@",1)
     s OrderRowid=$p(InOrderItemRowid,"||",1)
     s itemsub=$p(InOrderItemRowid,"||",2)
     s InArcItmDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    
     s Rowid="" f  s Rowid=$o(^DHCRBItemBookSavei("PAADM",Inpaadmdr,Rowid)) q:(Rowid="")  d
     .s ArcItmDR=$p($g(^DHCRBItemBookSave(Rowid)),"^",3)
     .s ResSchudleDR=$p($g(^DHCRBItemBookSave(Rowid)),"^",2)
     .i ((InArcItmDR=ArcItmDR)&(InResSchduleID=ResSchudleDR)) s UseBookRes="Y"
     .i UseBookRes="Y"  BREAK:UseBookRes

     q UseBookRes
}

/// 保存选中资源记录
/// w ##class(web.DHCRisResApptSchudleSystem).SaveSelRecord("20019^6842^10453||1")
ClassMethod SaveSelRecord(Info As %String) As %String
{
    s paadmdr=$p($g(Info),"^",1)
    s ResSchduleID=$p($g(Info),"^",2)
    s ArcItmMastDR=$p($g(Info),"^",3)
    s SaveDate=+$h
    s SaveTime=$p($h,",",2)
    s SQLCODE="-1"
    
    i (ResSchduleID'="")
    {
        s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
        s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)  
        s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
        
      
       s bWrite=""
       &sql(select count(*) into:bWrite from DHCRB_ItemBookSave where ((DIB_ResSchdule_DR=:ResSchduleID) and (DIB_ArcItmMast_DR=:ArcItmMastDR)and (DIB_Paadm_DR=:paadmdr)))
       i (bWrite=1) d
       .&sql(update DHCRB_ItemBookSave(DIB_Paadm_DR,DIB_ResSchdule_DR,DIB_ArcItmMast_DR,DIB_Resource_DR,DIB_AppDate,DIB_AppTime,DIB_SaveDate,DIB_SaveTime)
              values(:paadmdr,:ResSchduleID,:ArcItmMastDR,:ResouceId,:Date,:StartTime,:SaveDate,:SaveTime) 
              where ((DIB_ResSchdule_DR=:ResSchduleID) and (DIB_ArcItmMast_DR=:ArcItmMastDR)and (DIB_Paadm_DR=:paadmdr)))
       i (bWrite=0) d
       .&sql(insert into DHCRB_ItemBookSave (DIB_Paadm_DR,DIB_ResSchdule_DR,DIB_ArcItmMast_DR,DIB_Resource_DR,DIB_AppDate,DIB_AppTime,DIB_SaveDate,DIB_SaveTime) 
              values (:paadmdr,:ResSchduleID,:ArcItmMastDR,:ResouceId,:Date,:StartTime,:SaveDate,:SaveTime))
           
    }
    
    q SQLCODE
}

/// 删除保存资源记录
/// 入参:就诊ID,资源计划排班ID,医嘱项ID
/// 返回值: N-失败  Y-成功
/// w ##class(web.DHCRisResApptSchudleSystem).CancelSaveRecord("20019^6842^10453||1")
ClassMethod CancelSaveRecord(Info As %String) As %String
{
    s paadmdr=$p($g(Info),"^",1)
    s ResSchduleID=$p($g(Info),"^",2)
    s ArcItmMastDR=$p($g(Info),"^",3)
    s Cancel="N"
    s UnLock=""
    i (ResSchduleID'="")
    {
       &sql(Delete from DHCRB_ItemBookSave where ((DIB_ResSchdule_DR=:ResSchduleID) and (DIB_ArcItmMast_DR=:ArcItmMastDR)and (DIB_Paadm_DR=:paadmdr))) 
       i SQLCODE=0 d
       .s UnLock=..UnLockApptRes(ResSchduleID)
       .i UnLock=0 d
       ..s Cancel="Y"
    }
    q Cancel
}

/// 插入预约数据
/// (
/// -999   ----病人欠费
/// -10001 ----获取预约参数失败  
/// -10002 ----医嘱对应的就诊记录是否一致 
/// -10003 ----预约台保存项目失败
/// 修改:2015-10-16 sunyi
/// w ##class(web.DHCRisResApptSchudleSystem).InsertBookedData(^DHCRis("Ris2015"))
ClassMethod InsertBookedData(Info As %String) As %String
{
    s ^DHCRis("Ris2015")=Info
    lock +(^DHCRisTMPReg)
    k ^DHCRISDOCTMP("STUDYNO")
    
    s InOrderItemRowid=$p($g(Info),"^",1)
    s InResSchduleID=$p($g(Info),"^",2)
    s Inpaadmdr=$p($g(Info),"^",3)
    ;w !,Inpaadmdr
    s InUserID=$p($g(Info),"^",4)
    s InIp=$p($g(Info),"^",5)
    s Pasmatdr=$p($g(^PAADM(Inpaadmdr)),"^",1)
    ;s IsInsert=..RequestFlag(InResSchduleID,InOrderItemRowid,Inpaadmdr)
    ;q:(IsInsert="N") "-10003^0"
    ;b //001
    

    s InParam=""
    s InParam=..GetBookedParam(Inpaadmdr,InOrderItemRowid,InResSchduleID,InUserID)
    ;w !,"InParam="_InParam
    i InParam="" lock -(^DHCRisTMPReg)
    q:(InParam="") "-10001^0"
    ;b //002
    s OrderItemRowid=$p(InParam,"^",1)
    s ResSchduleID=$p(InParam,"^",2)
    s AppointMethod=$p(InParam,"^",3)      ; 1: 手动， 2：自动
    s OherParam=$p($g(InParam),"^",4)     //计费标识 HIS
    s MuitStudyNo=$p($g(InParam),"^",5)
    s RegEQIndex=$p($g(InParam),"^",6)
    s CheckGroupIndex=$p($g(InParam),"^",7)
    s RoomIndex=$p($g(InParam),"^",8)
    s EQDr=$p($g(InParam),"^",9)
    s EQGroupDR=$p($g(InParam),"^",10)
    s RoomDR=$p($g(InParam),"^",11)
    s paadr=$p($g(InParam),"^",12)
    s IndexTypeDR=$p($g(InParam),"^",13)
    s InputRegDate=$p($g(InParam),"^",14)
    i InputRegDate'="" s InputRegDate=$zd(InputRegDate,3)
    s UserDR=$p($g(InParam),"^",15)
    s GetStudyNo=$p($g(InParam),"^",16) //PACS传入的检查号
    ;s GetFlag=$p($g(InParam),"^",17)    ;登陆科室资源配置标记Y/N
    s GetRecLocDR=$p($g(InParam),"^",18) 
    s OperateDate=+$h
    s OperateTime=$p($h,",",2)
    i ResSchduleID'="" s StratTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
    i paadr'="" s patienttype=$p(^PAADM(paadr),"^",2) ;病人类型
    s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
   
    Set $ZT="ERROR" 
    s Count=$l(OrderItemRowid,"@")
    
     //判断是否有已经预约的记录 wangfeng 
    s ret=##class(web.DHCRisResourceApptSchudle).hasBookOrder(OrderItemRowid)
    q:(ret="Y") "-11112^"
    
   ;b //003
    s SQLCODE=""
    for i=1:1:Count 
    {
        ;b ///0001
      s Arrearage="1"
      s perOrditemRowid=$p(OrderItemRowid,"@",i)
      s StudyNo=$p($g(MuitStudyNo),"@",i)
      i GetStudyNo'="" s StudyNo=GetStudyNo
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
      s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
      s ArcItmid=$p(^OEORD(OrdRowid,"I",itemsub,1),"^",2)
      ;b ///0002
      //医嘱对应的就诊记录是否一致
      i (Inpaadmdr'=EpisodeID)
      { 
        s SQLCODE="-10002"
        s ret="0"
      }
      i SQLCODE="-10002" lock -(^DHCRisTMPReg)
      ;b ///0003
      q:(SQLCODE="-10002")
      ;b //0004
      s RecLocdr=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
      i GetRecLocDR'="" s RecLocdr=GetRecLocDR
      
      s UseInfo="",UpType="",AppDateType=""
      s UseInfo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocdr)
      i (UseInfo'="")
      {
         s UpType=$p(UseInfo,"^",1)
         s AppDateType=$p(UseInfo,"^",2)
      }
      ;b //0005
      if (UpType="I")
      {
          s RoomIndex=""
          s CheckGroupIndex=""
          s RegEQIndex=""
      }else
      {
        if ('$d(^DHCRISDOCTMP("STUDYNO",StudyNo)))
        {
            ;b //006
            s MaxParam="",MaxIndexInfo="",indexroom=""
            s MaxParam=EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_RecLocdr_"^"_perOrditemRowid_"^"_StratTime_"^"_InputRegDate_"^"_Pasmatdr
            ;w !,MaxParam
            s MaxIndexInfo=##class(web.DHCRisResourceApptSchudle).GetCurrentBookMaxIndex(MaxParam)
            ;w !,"MaxIndexInfo="_MaxIndexInfo
            i MaxIndexInfo'="" d
            .s RegEQIndex=$p(MaxIndexInfo,"^",1)
            .s CheckGroupIndex=$p(MaxIndexInfo,"^",2)
            .s RoomIndex=$p(MaxIndexInfo,"^",3)    
            .s IsUpBookNo=$p($g(MaxIndexInfo),"^",4)
            
        }
    
      }
      /*
      s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(EpisodeID,"A","完全控制")
      ;w !,"Arrearage="_Arrearage
      i Arrearage="1" s SQLCODE="-999",ret="0"
      i Arrearage="1" lock -(^DHCRisTMPReg)
      q:(Arrearage="1")
     */
       ;b //006
      s value=""
      s value=RegEQIndex_"^"_CheckGroupIndex_"^"_RoomIndex_"^"_EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_AppDateType_"^"_InputRegDate
      s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
      s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
      s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
      s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
      s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
      i UseNumber="" s UseNumber=0
      i AutoUseNumber="" s AutoUseNumber=0
      
      s ItmPatTypeRowid=""
      s OrderRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
      s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
      s ItemBookeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
      s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",arcimid,patienttype,ItmPatTypeRowid))
      s MehtodDesc=""
      i ItemBookeRowid'="" d
      .s AppointmentMethodId=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",2)
      .i AppointmentMethodId'="" d
      ..s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
      
      i ItmPatTypeRowid'="" d
      .s AppointmentMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
      .i AppointmentMethodId'=""  s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
      ;b //007
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) s SQLCODE=-1000,ret=0
      i (MehtodDesc="无需预约")!(MehtodDesc="不需预约")   lock -(^DHCRisTMPReg)
      q:(MehtodDesc="无需预约")!(MehtodDesc="不需预约")    
      ;b //008
      TSTART
      s SQLCODE=100
      
      s IsCancel=""
      s IsCancel=##class(web.DHCRisResourceApptSchudleEx).IsCancelBooked(perOrditemRowid)
      ;b //009
      i (IsCancel="Y")
      {
          i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)!((AppointMethod'="2")&(MaxNumber>UseNumber)))
          {
            &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time)
                               values (:ResSchduleID,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,'Booked',:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime) where  DRPD_OrderItem_ID=:perOrditemRowid) 
            i (AppointMethod="2")&(AutoUseNumber<AutoNumber) s AutoUseNumber=AutoUseNumber+1          
          } 
      }                    
      else
      {
         i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)) d
         .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
                              ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
                            values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime))                     
         .s AutoUseNumber=AutoUseNumber+1
         else  if (MaxNumber>UseNumber)||($d(^DHCRISTMP("STUDYNO",StudyNo)))  d
          .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
                              ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
                            values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime))
            .i InputRegDate'="" s InputRegDate=$zdh(InputRegDate,"3")
            .i RoomDR'="" s ^DHCRisBookIndexForRoom(Pasmatdr,RoomDR,InputRegDate,StratTime)=RoomIndex
      }
      //b //01   
     //医嘱接收科室和资源不一致，自动修改接收科室
     //ResSchduleID perOrditemRowid
     s recLocOld=$p(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3),"^",6)
     s resouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
     s locRes=$p(^RB("RES",resouceId),"^",1)
     if (locRes'=recLocOld)
     {
         s retChangeRecLoc=##class(web.DHCDocOrderCommon).ChangeOrderRecDep(perOrditemRowid,locRes)
     }
                        
     s DHCENSInfo="",ret="0"
     /*
     i (OherParam'="HIS")
     {
       s ^TMPOrditemRowid=perOrditemRowid
       s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).SendHisBookedInfo(perOrditemRowid)
       s ret=$p(DHCENSInfo,"^",1)     
     }
     */
     
     ;b //010
     I SQLCODE TRollback  
     I SQLCODE lock -(^DHCRisTMPReg)
     q:SQLCODE 
     
     ;b //011
     if ('$d(^DHCRISDOCTMP("STUDYNO",StudyNo)))
     {
         ;w !,SQLCODE_"^"_UpType
         i ((SQLCODE=0)&(IsUpBookNo="Y")&(UpType="B")) d
         .;w !,RecLocdr_"^"_value_"^"_ResSchduleID
          .;do ##class(web.DHCRisPatRegisterDoEx).UpdateIndexcls(RecLocdr,value,ResSchduleID)
          .do ##class(web.DHCRisResourceApptSchudle).UpdateBookedIndexcls(RecLocdr,value,StratTime)
         s UseNumber=UseNumber+1
         
         if ((AppointMethod="1")&(MaxNumber<UseNumber))
         {
             s RemainNumber="0"
         }
         else
         {
             s RemainNumber=MaxNumber-UseNumber
         }
         
         &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                              values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)     
         I SQLCODE TRollback  
         I SQLCODE lock -(^DHCRisTMPReg)
         q:SQLCODE 
     }                      
      /*i (OherParam'="HIS")
      {
        s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).UpdateHisBookedInfo(perOrditemRowid)
        s ret=$p(DHCENSInfo,"^",1) 
      } 
      */ 
      ;b //012
      ;更新医嘱表及医嘱状态表的的数据
      s Now=$zd(+$H,8)_$zt($p($h,",",2))
      s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowid,"BK",Now,"","","")
      
      ;&sql(Update SQLUser.OE_OrdItem Set OEORI_RecDep_DR= :GetRecLocDR Where OEORI_RowId= :perOrditemRowid)
      /*&sql(Update DHCRB_ItemBookSave Set DIB_IsUseResource='Y' 
            Where (DIB_ResSchdule_DR=:ResSchduleID) and (DIB_ArcItmMast_DR=:ArcItmid)and (DIB_Paadm_DR=:paadr))*/
            
      //I SQLCODE TRollback  
      //I SQLCODE lock -(^DHCRisTMPReg)
      //q:SQLCODE 
     ;b //013
      ///记录日志
      s LogInfo=""
      s LogInfo=InUserID_"^"_InIp_"^"_perOrditemRowid_"^"_StudyNo_"^"_InResSchduleID_"^预约"
      s SQLCODE=##class(web.DHCRisResApptSchudleSystem).SetBookLog(LogInfo)
      
      ;发送预约消息到RIS4系统
      i ((StudyNo'="")&(i=Count))
      {            
         do ##class(web.DHCRisSendToRis4Set).SendBookedtoRIS4(StudyNo,RecLocdr)
      }
      s ^DHCRISDOCTMP("STUDYNO",StudyNo)=StudyNo
       ;b //014
      I SQLCODE TRollback  
      I SQLCODE lock -(^DHCRisTMPReg)
      I SQLCODE q 
      TCOMMIT
      
      ;b //015
    }
    lock -(^DHCRisTMPReg)
    ;b //016
    q $g(SQLCODE)_"^"_$g(ret)
    

ERROR   
    Set ErrorMsg=$ZE               //得到系统返回的错误消息
    
    TROLLBACK
    I SQLCODE lock -(^DHCRisTMPReg)
    q $g(SQLCODE)_"^"_$g(ret)
}

/// 函数名称:CancelBooked
/// 功能:取消预约函数
/// 输入参数:OrderItemRowid
/// 返回:"0" 
/// 作者:孙毅
/// 日期:2015-10-22
/// w ##class(web.DHCRisResApptSchudleSystem).CancelBooked("20017||3898","687","10.10.116.103")
ClassMethod CancelBooked(OrderItemRowid As %String, InUserID As %String = "", InIp As %String = "") As %String
{
    q "0"
}

/// 插入预约流程
/// s Info="20017||3870^6842^20019^685"
/// do ##class(web.DHCRisResApptSchudleSystem).TestInsertSucess("20017||3870^6842^20019^685")
ClassMethod TestInsertSucess(Info)
{
     s ret1="-1",Saveret=""
     s OrditemDR=$p(Info,"^",1)
     s ResSchudleDR=$p(Info,"^",2)
     s paadr=$p(Info,"^",3)
     s UserDR=$p(Info,"^",4)
     q:(OrditemDR="")
     s ArcItmDR=$p(^OEORD($p(OrditemDR,"||",1),"I",$p(OrditemDR,"||",2),1),"^",2)
     
     s SaveInfo=paadr_"^"_ResSchudleDR_"^"_ArcItmDR
     
     i (ResSchudleDR'="" )
     {
         s ret=..LockApptRes(ResSchudleDR)
         
         s Saveret=..SaveSelRecord(SaveInfo)
         //医生站插入医嘱
         i (Saveret=0)
         {
             s result=..InsertBookedData(Info)
             i result'="" d
             .s ret1=$p($g(result),"^",1)
             .i ret1'=0 d
             ..s UnLock=..UnLockApptRes(ResSchudleDR)
         }
         
     }
     
     q ret1
}

/// 转预约
/// w ##class(web.DHCRisResApptSchudleSystem).ChangeBooked("20017||3870^6842^20019^685")
/// w ##class(web.DHCRisResApptSchudleSystem).ChangeBooked("20017||3900^10380^20019^685^10.10.116.103")
ClassMethod ChangeBooked(Info As %String) As %String
{
	s ^DHCRisTemp("ChangeBooked")=$g(Info)
	s $ZT="ErrorChangeBook"
    //cancelbook
    s OrderBodyList=$p(Info,"^",1)    
    s userRowid=$p($g(Info),"^",5)        //操作人
    s ipIn=$p($g(Info),"^",6)
    s retCancelBook=##class(web.DHCRisResourceApptSchudle).CancelBook(OrderBodyList,userRowid,ipIn)
    if (retCancelBook="0")
    {
    	s retBook=..Book(Info)
    }
    else
    {
	    s retBook="1000"
    }
    q $g(retBook)
    //book
ErrorChangeBook
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^DHCRisTemp("ChangeBook-erroe")=ErrorMsg
 	q "-0001"
}

/// 获取预约插入方式 1-手动预约  2-自动预约
/// w ##class(web.DHCRisResApptSchudleSystem).GetAppointMethod("20017||3870")
ClassMethod GetAppointMethod(OrderItemRowid As %String) As %String
{
    s AppointID="1"
    s ^tmp("RISTMP")=OrderItemRowid
    
    s OrderRowid="",itemsub="",BPRowid="",arcimid=""
    s OrderRowid=$p(OrderItemRowid,"||",1)
    s itemsub=$p(OrderItemRowid,"||",2)
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    
    i (arcimid'="")
    {
        s paadmdr=$p(^OEORD(OrderRowid),"^",1)
        i paadmdr'="" s PatType=$p(^PAADM(paadmdr),"^",2) 
        
        s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
        q:(BPRowid="") AppointID
        s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
        i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
        s ItmPatTypeRowid="",AppMethod=""
        s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",arcimid,PatType,ItmPatTypeRowid))
        i ItmPatTypeRowid'="" s AppointMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
        i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
        i AppMethod="自动预约" s AppointID="2"
    }
    
    q AppointID
}

/// 根据就诊获取病人所院区
/// w ##class(web.DHCRisResApptSchudleSystem).GetPatientHospital("20019")
ClassMethod GetPatientHospital(paadmdr As %String) As %String
{
     q:(paadmdr="") ""
     s HospitalDR=$p($g(^PAADM(paadmdr,2)),"^",85)
     i HospitalDR="" d
     .s Docdr="",SSURowid="",AppLocDR=""
     .s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
     .i $g(Docdr)'="" d
     ..s SSURowid=$o(^SSU("SSUSR",0,"CTPCP",Docdr,-1))
     ..i SSURowid'="" s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
     ..i AppLocDR'="" s HospitalDR=$p($g(^CTLOC(AppLocDR)),"^",22)
     q HospitalDR
}

/// 获取自动选择预约资源
/// w ##class(web.DHCRisResApptSchudleSystem).RequestAutoBookedRes("20019","63327","55946","10453||1","1383")
ClassMethod RequestAutoBookedRes(Paadmdr As %String, ChargeDate As %Integer, ChargeTime As %Integer, ItemMastRowid As %String, InResID As %String = "") As %String
{
    s PatType="",HospitalDR="",BPRowid="",AppMethod=""
    s UseResInfo="^^",AppointMethodId="",ServiceGroupId=""
    
    s ^TMPRIS("20140609")=Paadmdr_"^"_ChargeDate_"^"_ChargeTime_"^"_ItemMastRowid_"^"_InResID
    i ChargeDate=""  d
    .s ChargeDate=+$h
    e  d
    .s ChargeDate=$zdh(ChargeDate,"8")
    
    i ChargeTime="" s ChargeTime=$p($h,",",2)
    q:((Paadmdr="")!(ItemMastRowid="")) "-0001"
    
    s PatType=$p($g(^PAADM(Paadmdr)),"^",2)
    s HospitalDR=..GetPatientHospital(Paadmdr)
    s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
    q:(BPRowid="") "-0002"
      
    s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
    i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
     
    s ItmPatTypeRowid=""
    s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",ItemMastRowid,PatType,ItmPatTypeRowid))
    i ItmPatTypeRowid'="" s AppointMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
    i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
     
    q:((AppMethod="不需预约")!(AppMethod="无需预约")) "-0003"
    s ServiceGroupId=$p(^ARCIM($p(ItemMastRowid,"||",1),$p(ItemMastRowid,"||",2),8),"^",7) 
    q:(ServiceGroupId="") "-0004" 
    
    s UseResInfo=..GetUseResPanTR(ChargeDate,ChargeTime,ServiceGroupId,ItemMastRowid,HospitalDR,InResID)
    
    q UseResInfo
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPanTR(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, ItemMastRowid As %String, HospitalDR As %String, InResID As %String = "") As %String
{
        
    s bFind=0
    s Day=ChargeDate
    s UseResInfo=""
    s ServiceName=""
    
    i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
   
    //查找可使用的预约资源
    while(bFind<1)
    {   
        ;w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
        s UseResInfo=..GetDayUseBookInfoTR(Day,ChargeDate,ChargeTime,ServiceGroupId,ItemMastRowid,HospitalDR,InResID)
        ;w !,"UseResInfo"_UseResInfo
        if (UseResInfo="")
        {
            s Day=Day+1
            i (Day-ChargeDate)>50  s bFind=1   ;如果超过50天没有，可能是系统没有设置排版，则退出循环
           
        }   
        else    ; 找到可用的计划
        {   
            s bFind=1
        }
    }
    
    q UseResInfo
}

/// 函数：GetDayUseBookNum
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetDayUseBookInfoTR(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, ItemMastRowid As %String, InHospitalDR As %String, InResID As %String = "") As %String
{
    s MaxRemainNumber=0    ; 最大的剩余数
    s SelSchuldRowid=0
    
    s Info="",ServiceName="",QFind=""
    
    s CurrentTime=$p($h,",",2)
    s CurrentDate=+$h
    
    i ServiceGroupId'="" d
    .s ServiceName=$p(^RBC("SG",ServiceGroupId),"^",2)

    ; 按服务组索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
    s SchRowid=0 f  s SchRowid=$o(^DHCRBCResSchdulei("SericeGroup",ServiceGroupId,Day,SchRowid)) q:SchRowid=""  d
    .q:(Info'="")
    .s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
    .q:(RessourceID="")
    .q:(InResID'="")&(InResID'=RessourceID)
    .s UseResID="",LocResID="",TimeDesc="",ResourceDesc="",EqId="",CareProvId=""
    .s EqId=$p($g(^RB("RES",RessourceID)),"^",3)
    .s CareProvId=$p($g(^RB("RES",RessourceID)),"^",2)
    .i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
    .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2) 
    .s UseResID=$o(^DHCRBCSerAvailableResi("AvailableRes",RessourceID,UseResID)) ;服务组可用资源
    .q:(UseResID="")
    .s LocResID=$o(^DHCRBCLocResourceSeti("Booked-Resource",RessourceID,LocResID)) ;资源所在院区
    .q:(LocResID="")
    .s GetHospitalDR=$p(^DHCRBCLocResourceSet("LoginLocRes",LocResID),"^",3)
    .q:(InHospitalDR'="")&(InHospitalDR'=GetHospitalDR) 
    .s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
    .s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
    .s TimeDescCode=$p(^DHCRBCResourceSchdule(SchRowid),"^",3)
    .i (TimeDescCode="")  d
	..s TimeDesc=$zt(StartTime,2)_"-"_$zt(EndTime,2)
    .e  d
    ..s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    ..s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    
    .;q:(TimeDescCode="")
    .;s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    .;s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    .s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
    .i AutoUseNumber="" s AutoUseNumber=0
    .s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
    .i AutoNumber="" s AutoNumber=0
    .;q:(AutoNumber="0")
    .s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
    .s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
    .i (RemainNum="")!(RemainNum=0) s RemainNum=MaxNumber
    .s LockBookNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",15)  ;预占资源数量
    .i LockBookNumber="" s LockBookNumber=0
    .s RemainUnLockBookNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",16) ;预占资源剩余
    .i RemainUnLockBookNumber="" s RemainUnLockBookNumber=MaxNumber
    .s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
    .i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
    
    .s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
    .i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
    .q:((Day=CurrentDate)&(EndTime<CurrentTime))
    .;i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber)) d 
    .;i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum<RemainUnLockBookNumber)) d 
    .;.s MaxRemainNumber=AutoRemainNum
    .;w !,"RemainNum="_RemainNum_"&&&&&&&"_"RemainUnLockBookNumber="_RemainUnLockBookNumber
    .i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(RemainUnLockBookNumber>0)&(QFind="")) d
    ..s MaxRemainNumber=RemainNum 
    ..s Info=SchRowid_"^"_$g(TimeDesc)_"^"_$zd(Day,"3")_"^"_$ZT(StartTime,"1")_"^"_ResourceDesc   //EndTime 
    ..s ret=##class(web.DHCRisResApptSchudleSystem).LockApptRes(SchRowid)
    ..s QFind="Y"

    q Info
}

/// 获取预约插入方式 1-手动预约  2-自动预约
/// w ##class(web.DHCRisResApptSchudleSystem).RequestAppMethod("10453||1","I")
ClassMethod RequestAppMethod(ArcItmDR As %String, PatType As %String) As %String
{
        s AppFlag=""
        q:((ArcItmDR="")!(PatType="")) AppFlag

        s BPRowid="",AppointMethodId="",AppMethod=""
        
        s BPRowid=$o(^DHCRBCItemBookProperTypei(ArcItmDR,0))
        q:(BPRowid="") AppFlag
        s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
        i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
        s ItmPatTypeRowid=""
        s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",ArcItmDR,PatType,ItmPatTypeRowid))
        i ItmPatTypeRowid'="" s AppointMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
        i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
        
        i ((AppMethod="不需预约")!(AppMethod="无需预约"))
        {
            s AppFlag="N"
        }elseif (AppMethod="自动预约")
        {
            s AppFlag="A"
        }else
        {
            s AppFlag="B"
        }
        
        q AppFlag
}

/// 函数：QuerySchduleDetail
/// 功能：查询设备的预约资源明细
/// 参数：ArcItemID,开始日期,结束日期
/// 作者：sunyi
/// 日期: 2011-08-05
/// 修改: 2015-10-16 sunyi
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResApptSchudleSystem","QuerySchduleDetail","13174||1","20151028","20151103","652768||64")
Query QuerySchduleDetail(ArcItemDR As %String, StartDate As %String, EndDate As %String, orderList As %String = "") As %Query(ROWSPEC = "SchRowid:%String,TimeDesc:%String,BookedDate:%String,StartTime:%String,ResourceDesc:%String,ReUnLockBKNumber:%String,ResID:%String,View:%String,MaxNumber:%String,AutoNumber:%String,RemainAutoNumber:%String,conflict:%String,earliest:%String")
{
}

ClassMethod QuerySchduleDetailExecute(ByRef qHandle As %Binary, ArcItemDR As %String, StartDate As %String, EndDate As %String, orderList As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s ^DHCRisTemp("QuerySchduleDetail")=ArcItemDR_"^"_StartDate_"^"_EndDate_"^"_orderList
    
    k bookDateList
    k scheduleList
    
    i ((StartDate="")&(EndDate="")) 
    {
       s StartDate=+$h
       s EndDate=+$h
    }else
    {
       s StartDate= $zdh(StartDate,"8")
       s EndDate=$zdh(EndDate,"8")
    }
    /*
    s OrderRowid=$p(oeorditemdr,"||",1)
    s ItemRowid=$p(oeorditemdr,"||",2)
    s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2) 
    s ServiceGroupId=""
    
    i ArcItemDR="" s qHandle=$lb(0,repid,0)
    Quit:ArcItemDR="" $$$OK
    s ServiceGroupId=##class(web.DHCRisCommFunctionEx).GetServiceGroup(ArcItemDR)
    i ServiceGroupId'="" s ServiceGroupId=$p(ServiceGroupId,"^",1)
    ;w !,"ServiceGroupId="_ServiceGroupId
    ;s ServiceGroupId=$p(^ARCIM($p(ArcItemDR,"||",1),$p(ArcItemDR,"||",2),8),"^",7)
    ;w !,"ServiceGroupId2="_ServiceGroupId
    i ServiceGroupId="" s qHandle=$lb(0,repid,0)
    Quit:ServiceGroupId="" $$$OK
    */
    if ( orderList'="")
	{
		s isEmpty=..needEmpty(orderList)
		s oeorditemdr=$p(orderList,"@",1)
		s oeorditemdr=$p(oeorditemdr,"$",1)
	    s OrderRowid=$p(oeorditemdr,"||",1)
	    s ItemRowid=$p(oeorditemdr,"||",2)
    	
    	s recLoc=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)
	    s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	    i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2) 
	    s ServiceGroupId=""
	    
	    // 查找就诊里的预约时间记录
		s orderRowidCon=""
		for
		{
			s orderRowidCon=$o(^OEORD(0,"Adm",paadmdr,orderRowidCon))
			q:orderRowidCon=""
			s itemSubCon=""
			for
			{
				s itemSubCon=$o(^OEORD(orderRowidCon,"I",itemSubCon))
				q:itemSubCon=""
				s orderItemRowidCon=orderRowidCon_"||"_itemSubCon
				s itemMastCon=$p($g(^OEORD(orderRowidCon,"I",itemSubCon,1)),"^",2)
				continue:(itemMastCon="")
				s serviceMaterial=$p($g(^ARCIM($p(itemMastCon,"||",1),$p(itemMastCon,"||",2),7)),"^",6)
				continue:((serviceMaterial'="Service")&(serviceMaterial'="S"))
				s itemStatRowid=$p(^OEORD(orderRowidCon,"I",itemSubCon,1),"^",13)
				s itemStatCode=""
				if (itemStatRowid'="")
				{
					s itemStatCode=$p(^OEC("OSTAT",itemStatRowid),"^",1)
				}
				continue:((itemStatCode="D")||(itemStatCode="U")||(itemStatCode="C")||(itemStatCode="I"))
				s bodyInfoCon=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(orderItemRowidCon)
				for jj=1:1:$l(bodyInfoCon,"^")
				{
					s bodyPartCon=$p($g(bodyInfoCon),"^",jj)
					s bodyRowidCon=$p($g(bodyPartCon),":",1)
					s regRowid=##class(web.DHCRisPlatCommonBusiness).getRegRowid(orderItemRowidCon,bodyRowidCon)
					continue:(regRowid'="")
					s bookDetailRowid=##class(web.DHCRisPlatCommonBusiness).GetBookDetailRowid(orderRowidCon,itemSubCon,bodyRowidCon)
					continue:(bookDetailRowid="")
					s scheduleRowidCon=$p($g(^DHCRBCResSchduleDetail("Detail",bookDetailRowid)),"^",2)
					s bookDateCon=$p($g(^DHCRBCResourceSchdule(scheduleRowidCon)),"^",2)
					s startTimeCon=$p($g(^DHCRBCResourceSchdule(scheduleRowidCon)),"^",5)
					s endTimeCon=$p($g(^DHCRBCResourceSchdule(scheduleRowidCon)),"^",6)
					s bookDateList(bookDateCon,startTimeCon)=endTimeCon
				}
			}
		}

    
	    s ArcItemDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
	    if (ArcItemDR="")
	    {
		    s qHandle=$lb(0,repid,0)
	    	Quit $$$OK
	    }
   
	    ;s ServiceGroupId=##class(web.DHCRisCommFunctionEx).GetServiceGroup(ArcItemDR)
	   
	    ;i ServiceGroupId'="" s ServiceGroupId=$p(ServiceGroupId,"^",1)
	    ;获取检查组信息
	    s itemGroupRowidList=##class(web.DHCRisBookAllResource).getItemGroupRowidList(orderList)
		;w !,itemGroupRowidList
		s ServiceGroupId=##class(web.DHCRisCommFunctionEx).GetSameServiceGroup(orderList)
        
	    i ServiceGroupId="" 
	    {
		    s qHandle=$lb(0,repid,0)
	   		Quit $$$OK
	    }
	}
 	
 	s (earliestSchedule,earlyDate,earlyTime)=""
    s SGCount=0
    s SGCount=$l(ServiceGroupId,"^")
    s radioNow=""
    ;w !,ServiceGroupId
    for i=1:1:SGCount
    {
	    ;w !,"SGCount="_SGCount
        s perServcieGroupId=""
        s perServcieGroupId=$p(ServiceGroupId,"^",i)
        ;w !,"perServcieGroupId="_perServcieGroupId
        s RessourceID="" f  s RessourceID=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID)) q:(RessourceID="")  d
        .;w !,"RessourceID="_RessourceID
        .s locIdRes=$p($g(^RB("RES",RessourceID)),"^",1)
        .q:(recLoc'=locIdRes)
        .s IsAppRes=""
        .i orderList'="" s IsAppRes=..IsUseResbyAppLoc(orderList,RessourceID)
        .q:(IsAppRes="N") ;按申请科室使用设备过滤
        .;q:(locDrList'[locIdRes)
        .for BookDate=StartDate:1:EndDate d
        ..s stTime=0 f  s stTime=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,BookDate,stTime)) q:stTime=""  d
        ...s SchRowid="" f  s SchRowid=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,BookDate,stTime,SchRowid)) q:(SchRowid="")  d
        ....d ResSchduleDetail
    }
    
    d outSchedule
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

ResSchduleDetail
    s View=""
    ;w !,SchRowid
    s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
    q:(RessourceID="")
    ;s IsAppRes=""
    ;i oeorditemdr'="" s IsAppRes=..IsUseResbyAppLoc(oeorditemdr,RessourceID)
    
    ;q:(IsAppRes="N") ;按申请科室使用设备过滤
    ;q:(UseRessourceID'=RessourceID)
    s UseResID="",LocResID="",TimeDesc="",ResourceDesc="",EqId="",CareProvId="",GetLocId=""
    s MaxNumber=""
    s GetLocId=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",11) 
    ;q:(RecLocdr'="")&(RecLocdr'=GetLocId)
    ;q:(locDrList'[GetLocId)
    s EqId=$p($g(^RB("RES",RessourceID)),"^",3)
    s CareProvId=$p($g(^RB("RES",RessourceID)),"^",2)
    i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
    i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2) 
    ;s UseResID=$o(^DHCRBCSerAvailableResi("AvailableRes",RessourceID,UseResID)) ;服务组可用资源
    ;q:(UseResID="")
    
    ;q:(TimeDescCode="")
    ;s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    ;s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
    ;空腹只能预约到上午
    if ($g(isEmpty)="Y")
    {
	    if (StartTime>43200)
	    {
		    s View="N"
	    }
    }
    s Date=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
    s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6)
    s TimeDescCode=$p(^DHCRBCResourceSchdule(SchRowid),"^",3)
    if (TimeDescCode="")
    {
	    s TimeDesc=$zt(StartTime,2)_"-"_$zt(EndTime,2)
    }
    else
    {
	    s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    	s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    }
    s CurrentTime=$p($h,",",2)
    s CurrentDate=+$h
    i ((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate) s View="N"
    s StartTimeDesc=$zt(StartTime)
    s BookedDate=$zd(Date,8)
    s availPatType=$p(^DHCRBCResourceSchdule(SchRowid),"^",19)
    q:((availPatType'="")&&(availPatType'[PatType))
    ;wf 判断不可用，退出
    s notAvailable=$p(^DHCRBCResourceSchdule(SchRowid),"^",23)
    q:(notAvailable="Y")
    
    ;判断超声医生能力
    s docInfoList=##class(web.DHCRisBookAllResource).getDocByDateTimeRes(RessourceID,Date,StartTime,EndTime)
    ;w !,docInfoList
    s docRowid=$p(docInfoList,"^",1)
    s docName=$p(docInfoList,"^",2)
    
    s isExamByDoc=##class(web.DHCRisBookAllResource).canExamByDoc(docRowid,itemGroupRowidList)
    q:(isExamByDoc="N")
    
    s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
    s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)     ;自动预约数
    i AutoNumber="" s AutoNumber=0
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13)  ;自动预约使用数
    i AutoUseNumber="" s AutoUseNumber=0
    s radio=""
    if (+AutoNumber>0)
    {
    	s radio=$fn(AutoUseNumber/AutoNumber,"",2)
    }
    s RemainAutoNumber=AutoNumber-AutoUseNumber
    s RemainUnLockBookNumber=""
    s RemainUnLockBookNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",10) ;$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",16) ;预占资源剩余
    ;w !,"RemainUnLockBookNumber="_RemainUnLockBookNumber_"--"
    i RemainUnLockBookNumber="" s RemainUnLockBookNumber=MaxNumber
    i RemainUnLockBookNumber=0 s View="N"
    i RemainAutoNumber>RemainUnLockBookNumber s RemainAutoNumber=RemainUnLockBookNumber
    i RemainAutoNumber<=0 d
    .s RemainAutoNumber=0
    .s View="N"
    
    
    
    //判断是否有时间冲突
    s conflict="N"
    // bookDateList(bookDateCon,startTimeCon)=endTimeCon
    s startTimeCompare=""
    for
    {
	    s startTimeCompare=$o(bookDateList(Date,startTimeCompare))
	    q:(startTimeCompare="")
	    s endTimeCompare=bookDateList(Date,startTimeCompare)
	    continue:(startTimeCompare>EndTime)!(endTimeCompare<StartTime)
	    s conflict="Y"
    }
    
    
    if ((View'="N")&(conflict="N"))
    {
	    // earliestSchedule,earlyDate,earlyTime
	    if ( earliestSchedule="")
	    {
		    s earliestSchedule=SchRowid
		    s earlyDate=Date
		    s earlyTime=StartTime
		    s radioNow=radio
	    }
	    else
	    {
		    if (Date<earlyDate)
		    {
			    s earliestSchedule=SchRowid
		    	s earlyDate=Date
		    	s earlyTime=StartTime
		    	s radioNow=radio
		    }
		    elseif (Date=earlyDate)
		    {
			    if (StartTime<earlyTime)
			    {
				    s earliestSchedule=SchRowid
		    		s earlyDate=Date
		    		s earlyTime=StartTime
		    		s radioNow=radio
			    }
			    elseif (StartTime=earlyTime)
			    {
				    if (radioNow>radio)
				    {
					    s earliestSchedule=SchRowid
		    			s earlyDate=Date
		    			s earlyTime=StartTime
		    			s radioNow=radio
				    }
			    }
		    }
	    }
    }
    
    s scheduleList(RessourceID,Date,StartTime,SchRowid)=$lb(SchRowid,TimeDesc,BookedDate,StartTimeDesc,ResourceDesc,RemainUnLockBookNumber,RessourceID,View,MaxNumber,AutoNumber,RemainAutoNumber,conflict,"")
	quit
	
outSchedule
	s resourceRowidOut=""
	for
	{
		s resourceRowidOut=$o(scheduleList(resourceRowidOut))
		q:(resourceRowidOut="")
		s dateOut=""
		for
		{
			s dateOut=$o(scheduleList(resourceRowidOut,dateOut))
			q:(dateOut="")
			s startTimeOut=""
			for
			{
				s startTimeOut=$o(scheduleList(resourceRowidOut,dateOut,startTimeOut))
				q:(startTimeOut="")
				s scheduleRowidOut=""
				for
				{
					s scheduleRowidOut=$o(scheduleList(resourceRowidOut,dateOut,startTimeOut,scheduleRowidOut))
					q:(scheduleRowidOut="")
					s data=scheduleList(resourceRowidOut,dateOut,startTimeOut,scheduleRowidOut)
					if (scheduleRowidOut=earliestSchedule)
					{
						s $list(data,13)="Y"					
					}
					Set ^CacheTemp(repid,ind)=data
    				Set ind=ind+1
				}
			}
		}
	}
    
    quit
}

ClassMethod QuerySchduleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySchduleDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QuerySchduleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySchduleDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 根据就诊信息查询病人申请和预约状态的医嘱(modify)
/// d ##class(%ResultSet).RunQuery("web.DHCRisResApptSchudleSystem","QuerySerOrder","1790","","")
/// 修改日期:2015-10-16 sunyi
Query QuerySerOrder(paadmdr As %String, Code As %String, patientId As %String, allVisit As %String = "fasle") As %Query(ROWSPEC = "ExamOrder:%String,ArcItmId:%String,SchRowid:%String,OrderName:%String,Status:%String,datestr:%String,timestr:%String,TimeDesc:%String,BookDate:%String,BookTime:%String,BookRes:%String,BookTypeFlag:%String,RecLocDR:%String,LocDesc:%String,IsMydriasis:%String,SendReportTime:%String,UseBookResInfo:%String,BillDesc:%String,AppDocDesc:%String,BodyDr:%String,BookNo:%String,StudyNo:%String,AppNo:%String,BookTypeDesc:%String")
{
}

ClassMethod QuerySerOrderExecute(ByRef qHandle As %Binary, paadmdr As %String, Code As %String, patientId As %String, allVisit As %String = "false") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s PaAdmID=$p(paadmdr,$C(0))
 
 s ^TempDHCRisWf("QuerySerOrder")=paadmdr_"^"_Code_"^"_patientId_"^"_allVisit
 
 i ((PaAdmID="")&&(patientId=""))
 { 
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 }
 k serOrderOut
 if (patientId'="")
 {/*
	 //^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	 s patMasRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(patientId,"U"),""))
	 //^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	 if (patMasRowid'="")
	 {
		 s admType=""
		 for
		 {
			 s admType=$o(^PAPERdr(patMasRowid,"ADM",admType)) q:(admType="")
			 ;w !,admType
			 s PaAdmID=""
			 for
			 {
				 s PaAdmID=$o(^PAPERdr(patMasRowid,"ADM",admType,PaAdmID)) q:(PaAdmID="")
				 ;w !,PaAdmID
				 s admDate=$p($g(^PAADM(PaAdmID)),"^",6)
 				 if (admDate'=+$h) &&(allVisit'="true")
 				 {
	 				 continue
 				 }	
 				 ;w !,PaAdmID
 				 s PatType=$p($g(^PAADM(PaAdmID)),"^",2)
				 s (ExamOrder,ArcItmId,SchRowid,OrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,GetPatientStatusCode,RecLocID,LocDesc,AppLocID,AppDocDesc)=""
				 s ordrowid=""
				 s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
				 .s itmsub=0 f  s itmsub=$o(^OEORD(ordrowid,"I",itmsub)) q:(itmsub="")  d
				 ..s (ExamOrder,ArcItmId,SchRowid,OrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,GetPatientStatusCode,RecLocID,LocDesc,AppLocID)=""
				 ..s ordInfo=""
				 ..s ArcItmId=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",2)
				 ..s AppLocID=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",3)
				 ..;w !,"ArcItmId="_ArcItmId_"**"_"AppLocID="_AppLocID
				 ..q:(ArcItmId="")
				 ..s itemcatdesc=""
				 ..i ArcItmId'="" d 
				 ...s itemcatdr=$p(^ARCIM(+ArcItmId,$p(ArcItmId,"||",2),1),"^",10) 
				 ...s itemcatdesc=$p(^ARC("IC",itemcatdr),"^",2)
				 ...;q:(itemcatdesc'["眼")
				 ..s GetServerMaterial=""
				 ..s GetServerMaterial=$p($g(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),7)),"^",6)
				 ..q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
				 ..s IsSeeItembyAppLoc=""
				 ..s IsSeeItembyAppLoc=..IsSeeArcItembyApp(ArcItmId,AppLocID)
				 ..q:(IsSeeItembyAppLoc="N") ;按检查项目配置的申请科室过滤
				 ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,itmsub)
				 ..s GetstrOrderName=$p(ordInfo,"^",1)
				 ..s datestr=$p(ordInfo,"^",2)
				 ..s timestr=$p(ordInfo,"^",3)
				 ..s AppDocDesc=$p(ordInfo,"^",4)
				 ..s SubCatDesc=$p(ordInfo,"^",7)
				 ..s RecLocID=$p(ordInfo,"^",19)
				 ..s LocDesc=$p(ordInfo,"^",21)
				 ..s BillDesc=$p(ordInfo,"^",27)
				 ..q:SubCatDesc="门诊诊疗费"
				 ..q:SubCatDesc="挂号费"
				 ..s GetItemStatusCode=$p(ordInfo,"^",14)
				 ..s GetServerMaterial=$p(ordInfo,"^",18)
				 ..s ServerGroupDR=$p(ordInfo,"^",36)
				 ..q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
				 ..s ExamOrder=ordrowid_"||"_itmsub
				 ..s IsOpenBookWin=..IsOpenBookWin(ExamOrder)
				 ..q:(IsOpenBookWin="N")
				 ..s regrowid=""
				 ..s regrowid=$o(^DHCPACRegInfoi("OEORI",ExamOrder,""))
				 ..q:(regrowid'="")
				 ..s MemoInfo=##class(web.DHCRisResourceApptSchudle).GetMemo(ExamOrder)
				 ..s IsMydriasis=$p(MemoInfo,";",1)     ;是否散瞳
				 ..s SendReportTime=$p(MemoInfo,";",2)    ;发报告时间
				 ..s UseResInfo=""
				 ..;s UseResInfo=..GetBookUseRes("","",ServerGroupDR,RecLocID,ExamOrder,"","")
				 ..;w !,UseResInfo
				 ..;s RenBookDate=$p(UseResInfo,"^",2)
				 ..;i RenBookDate'="" s RenBookDate=$zd(RenBookDate,3)
				 ..;s RenBookTime=$p(UseResInfo,"^",3)
				 ..;s RenBookTime=$zt(RenBookTime)
				 ..;s UseBookResInfo=RenBookDate
				 ..s BookTypeFlag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmId,PatType)
				 ..q:(BookTypeFlag="N")   ;wf 20160328
				 ..s RRowid=""
				 ..s RRowid=$o(^DHCRBAppOrdi(0,ExamOrder,0)) 
				 ..i RRowid'="" s GetPatientStatusCode="A"  ;申请
				 ..s GetRejDR=""
				 ..i RRowid'="" s GetRejDR=$o(^DHCRBRejecti("OeordDR",ExamOrder,0))
				 ..i GetRejDR'=""  s GetPatientStatusCode="RJ"  ;----------拒绝申请
				 ..s DetailRowid="",CAFlag="",BKInfo=""
				 ..s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,ExamOrder,0)) 
				 ..i DetailRowid'="" s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
				 ..i ((CAFlag'="Cancel")&(DetailRowid'="")) d
				 ...s GetPatientStatusCode="B"
				 ...s BKInfo=##class(web.DHCRisResApptSchudleSystem).GetBookResInfo(DetailRowid)
				 ...q:(BKInfo="")
				 ...s SchRowid=$p(BKInfo,"^",1)
				 ...s TimeDesc=$p(BKInfo,"^",2)
				 ...s BookDate=$p(BKInfo,"^",3)
				 ...s BookTime=$p(BKInfo,"^",4)
				 ...s BookRes=$p(BKInfo,"^",5)
				 ..q:((Code="Y")&((GetPatientStatusCode="A")!(GetPatientStatusCode="RJ")!(GetPatientStatusCode="")))
				 ..i GetPatientStatusCode'="" d
				 ...s Status=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
				 ..DO OutServiceOrder
			 }
		 }		 
	 }
	 */
 }
 elseif (PaAdmID'="")
 { 
	 s PatType=$p($g(^PAADM(PaAdmID)),"^",2)
	 s (ExamOrder,ArcItmId,SchRowid,OrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,GetPatientStatusCode,RecLocID,LocDesc,AppLocID,AppDocDesc)=""
	 s ordrowid=""
	 s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
	 .s itmsub=0 f  s itmsub=$o(^OEORD(ordrowid,"I",itmsub)) q:(itmsub="")  d
	 ..s (ExamOrder,ArcItmId,SchRowid,OrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,GetPatientStatusCode,RecLocID,LocDesc,AppLocID)=""
	 ..s ordInfo=""
	 ..s ArcItmId=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",2)
	 ..s AppLocID=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",3)
	 ..;w !,"ArcItmId="_ArcItmId_"**"_"AppLocID="_AppLocID
	 ..q:(ArcItmId="")
	 ..s itemcatdesc=""
	 ..i ArcItmId'="" d 
	 ...s itemcatdr=$p(^ARCIM(+ArcItmId,$p(ArcItmId,"||",2),1),"^",10) 
	 ...s itemcatdesc=$p(^ARC("IC",itemcatdr),"^",2)
	 ..s GetServerMaterial=""
	 ..s GetServerMaterial=$p($g(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),7)),"^",6)
	 ..q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
	 ..;s IsSeeItembyAppLoc=""
	 ..;s IsSeeItembyAppLoc=..IsSeeArcItembyApp(ArcItmId,AppLocID)
	 ..;b //05
	 ..;q:(IsSeeItembyAppLoc="N") ;按检查项目配置的申请科室过滤
	 ..s StrOrderBodyName=##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm(ordrowid_"||"_itmsub)
	 ..s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(ordrowid_"||"_itmsub)
	 ..s bodyList=$p($g(StrOrderBodyName),"!",2)
	 ..;w !,bodyList
	 ..f j=1:1:$l(bodyList,"^")  d  
	 ...s bodypart=$p($g(bodyList),"^",j)
	 ...s bodyRowidSer=$p($g(bodypart),":",1) 
	 ...s bodyDesc=$p($g(bodypart),":",2)
	 ...;b //1111
	 ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,itmsub,bodyRowidSer)
	 ...s ordDate=$p(^OEORD(ordrowid,"I",itmsub,1),"^",9)  ;医嘱日期 OEORI_Date
	 ...s ordTime=$p(^OEORD(ordrowid,"I",itmsub,1),"^",17) ;医嘱的开始时间
	 ...s GetstrOrderName=$p(ordInfo,"^",1)
	 ...s datestr=$p(ordInfo,"^",2)
	 ...s timestr=$p(ordInfo,"^",3)
	 ...s AppDocDesc=$p(ordInfo,"^",4)
	 ...s SubCatDesc=$p(ordInfo,"^",7)
	 ...s RecLocID=$p(ordInfo,"^",19)
	 ...s LocDesc=$p(ordInfo,"^",21)
	 ...s BillDesc=$p(ordInfo,"^",27)
	 ...;q:SubCatDesc="门诊诊疗费"
	 ...;q:SubCatDesc="挂号费"
	 ...s GetItemStatusCode=$p(ordInfo,"^",14)
	 ...s GetServerMaterial=$p(ordInfo,"^",18)
	 ...s ServerGroupDR=$p(ordInfo,"^",36)
	 ...q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
	 ...s ExamOrder=ordrowid_"||"_itmsub
	 ...;s IsOpenBookWin=..IsOpenBookWin(ExamOrder)
	 ...;q:(IsOpenBookWin="N")
	 ...;s UseResInfo=""
	 ...;s UseResInfo=..GetBookUseRes("","",ServerGroupDR,RecLocID,ExamOrder,"","")
	 ...;w !,UseResInfo
	 ...;s RenBookDate=$p(UseResInfo,"^",2)
	 ...;i RenBookDate'="" s RenBookDate=$zd(RenBookDate,3)
	 ...;s RenBookTime=$p(UseResInfo,"^",3)
	 ...;s RenBookTime=$zt(RenBookTime)
	 ...;s UseBookResInfo=""   ;RenBookDate
	 ...;s BookTypeFlag=##class(web.DHCRisResApptSchudleSystem).RequestAppMethod(ArcItmId,PatType)
	 ...;q:(BookTypeFlag="N")   ;wf 20160328
	 ...;b //02
	 ...DO OutServiceOrder
	 /*
	 ....s BKInfo=##class(web.DHCRisResApptSchudleSystem).GetBookResInfo(DetailRowid)
	 ....q:(BKInfo="")
	 ....s SchRowid=$p(BKInfo,"^",1)
	 ....s TimeDesc=$p(BKInfo,"^",2)
	 ....s BookDate=$p(BKInfo,"^",3)
	 ....s BookTime=$p(BKInfo,"^",4)
	 ....s BookRes=$p(BKInfo,"^",5)
	 ...q:((Code="Y")&((GetPatientStatusCode="A")!(GetPatientStatusCode="RJ")!(GetPatientStatusCode="")))
	 ...i GetPatientStatusCode'="" d
	 ....s Status=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 */
 }
 
 do doSort
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutServiceOrder
  
 s (bookNo,studyNo,detailRowid,Status)=""
 s (BKInfo,SchRowid,TimeDesc,BookDate,BookTime,BookRes,bookNo)=""
 s (regInfoRowid,bookType,bookTypeId)=""
 // SchRowid   Status  TimeDesc  BookDate,BookTime,BookRes,BookTypeFlag
 s stautsFlag=1
 s detailRowid=..getBookDetailRowid(ExamOrder_"^"_bodyRowidSer)
 if (detailRowid'="")
 {
	 s Status="预约"
	 s stautsFlag=2
	 s BKInfo=##class(web.DHCRisResApptSchudleSystem).GetBookResInfo(detailRowid)
	 s SchRowid=$p(BKInfo,"^",1)
	 s TimeDesc=$p(BKInfo,"^",2)
	 s BookDate=$p(BKInfo,"^",3)
	 s BookTime=$p(BKInfo,"^",4)
	 s BookRes=$p(BKInfo,"^",5)
	 s bookNo=$p(BKInfo,"^",6)
 }
 s regInfoRowid=..getRegRowid(ExamOrder_"^"_bodyRowidSer)
 if (regInfoRowid'="")
 {
	 s stautsFlag=3
	 s Status="登记"
	 s studyNo=$p($g(^DHCPACRegInfo(regInfoRowid)),"^",2)
 }
 
 //获取预约方式
 s bookType=..getBookType(ExamOrder,bodyRowidSer)
 ;w !,bookType
 s bookTypeId=$p(bookType,"^",1)
 s bookTypeDesc=$p(bookType,"^",2)
 if (bookTypeId'="")
 {
 	//s serOrderOut(RecLocID,bookTypeId,ExamOrder_"|"_bodyRowidSer)=$lb(ExamOrder,ArcItmId,SchRowid,GetstrOrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,RecLocID,LocDesc,$g(IsMydriasis),$g(SendReportTime),$g(UseBookResInfo),BillDesc,AppDocDesc,bodyRowidSer,bookNo,studyNo,AppBillNo,$g(bookTypeDesc))
 	//s serOrder(RecLocID,bookTypeId,ExamOrder_"|"_bodyRowid)=$lb(ExamOrder,ArcItmId,SchRowid,"",Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,RecLocID,LocDesc,$g(IsMydriasis),$g(SendReportTime),$g(UseBookResInfo),BillDesc,AppDocDesc)
 	if (bookTypeDesc="自动预约")
 	{
	 	s bookTypeFlag=1
	}
	else
	{
		s bookTypeFlag=2
	}
 	s serOrderOut(bookTypeFlag,stautsFlag,ordDate,ordTime,ExamOrder_"|"_bodyRowidSer)=$lb(ExamOrder,ArcItmId,SchRowid,GetstrOrderName,Status,datestr,timestr,TimeDesc,BookDate,BookTime,BookRes,BookTypeFlag,RecLocID,LocDesc,$g(IsMydriasis),$g(SendReportTime),$g(UseBookResInfo),BillDesc,AppDocDesc,bodyRowidSer,bookNo,studyNo,AppBillNo,$g(bookTypeDesc))
 }
 ;b //001
 quit
 
doSort
    b  //01
    /*
 	s locId="" f  s locId=$o(serOrderOut(locId)) q:(locId="")  d
	.s typeId="" f  s typeId=$o(serOrderOut(locId,typeId)) q:(typeId="")  d
	..s orderid="" f  s orderid=$o(serOrderOut(locId,typeId,orderid)) q:(orderid="")  d
	...Set ^CacheTemp(repid,ind)=serOrderOut(locId,typeId,orderid)
 	...Set ind=ind+1 
 	*/
 	s bookTypeFind="" f  s bookTypeFind=$o(serOrderOut(bookTypeFind)) q:(bookTypeFind="")  d
 	.s statusFind="" f  s statusFind=$o(serOrderOut(bookTypeFind,statusFind)) q:(statusFind="")  d
 	..s dateFor="" f  s dateFor=$o(serOrderOut(bookTypeFind,statusFind,dateFor),-1) q:(dateFor="")  d
	...s timeFor="" f  s timeFor=$o(serOrderOut(bookTypeFind,statusFind,dateFor,timeFor),-1) q:(timeFor="")  d
	....s orderid="" f  s orderid=$o(serOrderOut(bookTypeFind,statusFind,dateFor,timeFor,orderid)) q:(orderid="")  d
	.....Set ^CacheTemp(repid,ind)=serOrderOut(bookTypeFind,statusFind,dateFor,timeFor,orderid)
 	.....Set ind=ind+1 
	;b //01
	quit
}

ClassMethod QuerySerOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySerOrderExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
     // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySerOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySerOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisResApptSchudleSystem).GetBookResInfo("376")
ClassMethod GetBookResInfo(DetailRowid As %String) As %String
{
    
    s ResSchduleID="",ResouceId="",EqId="",CareProvId="",ResourceDesc=""
    s Date="",TimeDescCode="",StartTime=""
    
    s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
    s bookNo=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",6)
    i ResSchduleID'="" d
    .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
    .s ResourceDesc=""
    .i ResouceId'="" d
    ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
    ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
    ..i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
    ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
    .s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
    .i Date'="" s BookedDate=##class(web.DHCRisCommFunction).changeDateToString(Date)   ;$zd(Date,3)
    .s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
    .s BooketTime=$zt(StartTime)
    .s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
    .s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
    .s TimeDesc=""
    .i TimeDescCode'="" d
    ..s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
    ..s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    .e  d
    ..s TimeDesc=$zt(StartTime)_"-"_$zt(EndTime)
    .s Info=ResSchduleID_"^"_$g(TimeDesc)_"^"_BookedDate_"^"_BooketTime_"^"_ResourceDesc_"^"_bookNo
    
    q Info
}

/// 插入预约流程
/// s Info="20017||3870^6842^20019^685"
/// do ##class(web.DHCRisResApptSchudleSystem).SaveBooked("20017||3870^6842^20019^685")
ClassMethod SaveBooked(Info)
{
     s Saveret="",UnLock="" ,ret=""
     
     s OrditemDR=$p(Info,"^",1)
     s ResSchudleDR=$p(Info,"^",2)
     s paadr=$p(Info,"^",3)
     s UserDR=$p(Info,"^",4)
     q:((OrditemDR="")!(paadr="")!(ResSchudleDR="")) "PARAMNULL"
     
     s ArcItmDR=$p(^OEORD($p(OrditemDR,"||",1),"I",$p(OrditemDR,"||",2),1),"^",2)
     q:(ArcItmDR="") "ARCNULL"
      
     s SaveInfo=paadr_"^"_ResSchudleDR_"^"_ArcItmDR
     s Saveret=..SaveSelRecord(SaveInfo)
     i Saveret'=0 s UnLock=..UnLockApptRes(ResSchudleDR)
     q:(Saveret'=0) "SAVEERROR"
     
     s result=..InsertBookedData(Info)
     i result'="" s ret=$p($g(result),"^",1)
     i ret'=0 s UnLock=..UnLockApptRes(ResSchudleDR)
     q:(ret'=0) "INSERTERROR"
     
     q ret
}

/// do ##class(web.DHCRisResApptSchudleSystem).UnLockService("","")
/// 释放资源同时删除临时表数据
ClassMethod UnLockService(InDate As %String, InTime As %String) As %String
{
    i InDate="" s InDate=+$h
    i InTime="" s InTime=$p($h,",",2)
    
    s Rowid="" f  s Rowid=$o(^DHCRBItemBookSave(Rowid)) q:(Rowid="")  d
    .s SaveDate="",SaveTime="",ResSchduleID="",IsUseResource=""
    .s SaveDate=$p($g(^DHCRBItemBookSave(Rowid)),"^",8)
    .s SaveTime=$p($g(^DHCRBItemBookSave(Rowid)),"^",9)
    .q:((SaveDate="")!(SaveTime=""))
    .q:((SaveDate>InDate)!(SaveTime>InTime))
    .s ResSchduleID=$p($g(^DHCRBItemBookSave(Rowid)),"^",2)
    .s IsUseResource=$p($g(^DHCRBItemBookSave(Rowid)),"^",7)
    .i ((ResSchduleID'="")&(IsUseResource'="Y")) d
    ..s ret=..UnLockApptRes(ResSchduleID)
    .&sql(delete from DHCRB_ItemBookSave where DIB_RowID=:Rowid)
    
    q 0
}

/// do ##class(web.DHCRisResApptSchudleSystem).GetBookedPrintData("965164||165")
/// 函数:GetBookedPrintData
ClassMethod GetBookedPrintData(OrditemRowid As %String) As %String
{
    q:(OrditemRowid="") ""
    s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,LocId,LocDesc,ResDetailRowid)=""
    s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid)=""
    s (MemoTMRowid,RecLocdr,RecLocDesc,UserID,UserCode,UserDesc,Memo,indexbook,strDate,strTime)=""
    s Info=""
    
    s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    s Pasmatdr=$p(^PAADM(paadmdr),"^",1)
    s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)

    if (ArcItemId'="")
    {
      s (MRowid,TMRowid)="" 
      
      s MRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemId,0))
      i MRowid'="" d
      .s TMRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
      .i TMRowid'="" d
      ..s Memo=$p($g(^DHCRBCApp("Memo-Template",TMRowid)),"^",3)
      .i Memo="" d
      ..s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
      
    }
    
    s RecLocdr=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
    if RecLocdr'="" d
    .s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
    .i $f(RecLocDesc,"-")>0 d
    ..s RecLocDesc=$p(RecLocDesc,"-",2)
    s Date1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",9)  ;医嘱日期 OEORI_Date
    ;w !,"Date1="_Date1
    s strDate=$zd(Date1,3)
    s Time1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",17) ;医嘱的开始时间
    s strTime=$zt(Time1,1)
    s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
    i (ResDetailRowid'="")
    {  
       s UserID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",15)
       i UserID'="" d
       .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
       .s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
       s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
       ;s BookNumber=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",9)
       i ResSchduleID'="" d
       .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       .s ResourceDesc="",ResourceCode=""
       .i ResouceId'="" d
       ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
       ..i EqId'="" d
       ...s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       ...s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
       ..i CareProvId'="" d
       ...s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
       ...s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
       ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
       ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
       .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       .i Date'="" s BookedDate=$zd(Date,3)
       .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       .i StartTime'="" s BooketTime=$zt(StartTime)
       .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
       .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
       .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
       .s indexbook=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",10)
       .;i $g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))'=""  s indexbook=$g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))
       .i (indexbook'="")&&(StartTime>43200)  s indexbook="下午"_indexbook_"号"
       .i (indexbook'="")&&(StartTime<43200)  s indexbook="上午"_indexbook_"号"
       .s Info="" 
       .s Info=ResSchduleID_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_Memo_"^"_indexbook_"^"_strDate_"^"_strTime
       
    }
    
    q Info
}

/// do ##class(web.DHCRisResApptSchudleSystem).updateRecLoc("","")
ClassMethod updateRecLoc(locDesc As %String, OeOrdDr As %String) As %String
{
    s ^DHCRisTemp("updateRecLoc")=locDesc_"^"_OeOrdDr
    q:((locDesc="")||(OeOrdDr="")) "-001"
    s locDr=""
    s locDr=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(locDesc),locDr))
    q:(locDr="") "-002"
    &sql(Update SQLUser.OE_OrdItem Set OEORI_RecDep_DR= :locDr Where OEORI_RowId= :OeOrdDr)
    q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisResApptSchudleSystem","QueryOrdRecLoc","331||25","83")
Query QueryOrdRecLoc(OEORIRowid As %String, OrderDepRowid As %String) As %Query(CONTAINID = 0, ROWSPEC = "LocDesc:%String,LocDr:%String")
{
}

ClassMethod QueryOrdRecLocExecute(ByRef qHandle As %Binary, OEORIRowid As %String, OrderDepRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s index=1
    /*
    s ItmCatdr="",locDr="",locDesc=""
    if $l(ItmMastDr,"||")=2 d
    .s ItmCatdr=$p($g(^ARCIM($p(ItmMastDr,"||",1),$p(ItmMastDr,"||",2),1)),"^",10)
    .;w !,"ItmCatdr="_ItmCatdr
    .i ItmCatdr'="" d
    ..s itmCatRecLocDr=0 f  s itmCatRecLocDr=$o(^ARC("IC",ItmCatdr,"RL",itmCatRecLocDr)) q:(itmCatRecLocDr="")  d
    ...;b //02
    ...;w !,"itmCatRecLocDr="_itmCatRecLocDr
    ...s locDr=$p(^ARC("IC",ItmCatdr,"RL",itmCatRecLocDr),"^",3)
    ...;w !,"locDr="_locDr
    ...i locDr'="" d
    ....s locDesc=$p(^CTLOC(locDr),"^",2)
    ...Do QueryOrdRecLoc
    */
    /*
    s sqlStr="select * from ct_loc where CTLOC_Desc like 'YXYX%' "
                       
   s result=##class(%Library.ResultSet).%New()
   d result.Prepare(sqlStr)
   d result.Execute()
    
  s count=0
  
  While(result.Next()){  
    
    s locDr=result.Data("CTLOC_RowID")
    s locDesc=result.Data("CTLOC_Desc")
    Do QueryOrdRecLoc
   }

  d result.Close()
  
  */
    s ^DHCRisTemp("QueryOrdRecLoc")=OEORIRowid_"^"_OrderDepRowid
    s LocList=##Class(web.DHCDocOrderCommon).GetArcimReclocStr(OEORIRowid,OrderDepRowid)
    for LocNumber=1:1:$l(LocList,$c(2))
    {
        s locInfoList=$p(LocList,$c(2),LocNumber)
        s locDesc=$p(locInfoList,$c(1),2)
        s locDr=$p(locInfoList,$c(1),1)
        Do QueryOrdRecLoc
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
QueryOrdRecLoc
    set Data=$lb(locDesc,locDr)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod QueryOrdRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdRecLocExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QueryOrdRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdRecLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数名称:IsUseResbyAppLoc
/// 功能:申请科室使用设备设置
/// 输入参数:OEorditem , RessourceID
/// 返回:"Y/N" Y-显示 N-不显示
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisResApptSchudleSystem).IsUseResbyAppLoc("3||108","1381")
ClassMethod IsUseResbyAppLoc(OEorditem As %String, RessourceDR As %String) As %String
{
	s ^DHCRisTemp("IsUseResbyAppLoc")=OEorditem_"^"_RessourceDR
	s canUse="Y"
	q:((OEorditem="") || (RessourceDR="")) canUse
	
	//查询医嘱接收科室和申请科室
	s (recLocGet,appLocGet)=""
	for len1=1:1:$l(OEorditem,"@")
	{
		s orderbodyGet=$p(OEorditem,"@",len1)
		s orderRowidGet=$p(orderbodyGet,"$",1)
		if (orderRowidGet'="")
		{
			s appLoc1=$p(^OEORD($p(orderRowidGet,"||",1),"I",$p(orderRowidGet,"||",2),1),"^",3)
			s recLoc1=$p(^OEORD($p(orderRowidGet,"||",1),"I",$p(orderRowidGet,"||",2),3),"^",6)
			if (appLocGet'="")
			{
				if ( ##class(web.DHCRisBookAllResource).isExistInGroup(appLocGet,appLoc1)=0)
				{
					s appLocGet=appLocGet_"^"_appLoc1
				}
			}
			else
			{
				s appLocGet=appLoc1
			}				
		}
	    
	}
	
	s numOfRes=""
	&sql(select count(*) into :numOfRes from DHCRBC_ResourceInAppLoc where DRIL_Resource_DR=:RessourceDR )
	//设备没有配置申请科室，所有科室均可以检查
	q:(numOfRes=0) canUse 
	b //01
	for numOfAppLoc=1:1:$l(appLocGet,"^")
	{
		q:(canUse="N")
		s appLocDr=$p(appLocGet,"^",numOfAppLoc)
		if ( appLocDr'="" )
		{
			s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",appLocDr,RessourceDR,0))
    		i ResAppRowid="" s canUse="N"
		}
	}
	
	q canUse
	
 /*
    s (OrderRowid,ItemRowid,AppLocDR)=""
    s ResAppFind=0            ;申请科室是否设置资源
    s ResAppSetFind="N"  ;是设置了是否发现可用资源默认"N"
    
    s OrderRowid=$p(OEorditem,"||",1)
    s ItemRowid=$p(OEorditem,"||",2)
    s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
    
    ;按申请科室查询可用资源
    s AppRowid=0  f  s AppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",AppLocDR,AppRowid)) q:AppRowid=""  d 
    .q:(ResAppFind=1)
    .s ResAppFind=1
    .;w !,"AppRowid="_AppRowid
    
    q:(ResAppFind=0) "Y"   ;申请科室没配置资源，则所有资源都允许预约
    
    s ResAppRowid=""
    i ResAppFind=1 s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",AppLocDR,RessourceDR,ResAppRowid))
    i ResAppRowid'="" s ResAppSetFind="Y"
    ;w !,"ResAppFindA="_ResAppFind
    q:(ResAppFind=1)&(ResAppSetFind="N") "N"
    q:(ResAppSetFind="Y") "Y"
    ;w !,"ResAppFind="_ResAppFind
    */
}

/// 函数名称:IsSeeArcItembyApp
/// 功能:根据检查项目和医嘱的申请科室来显示检查医嘱
/// 输入参数:检查项目ID, 医嘱关联申请科室ID
/// 返回:"Y/N" Y-显示 N-不显示
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisResApptSchudleSystem).IsSeeArcItembyApp("8866||1","15")
ClassMethod IsSeeArcItembyApp(ArcItemDR As %String, AppLocDR As %String) As %String
{
    //^DHCRBCArcItemAppLoci("ARC-APPLOC",{DAA_ArcItem_DR},{DAA_AppLoc_DR},{DAA_RowID})  
    s ItmAppFind=0            ;医嘱项目是否设置申请科室
    s ItmAppSetFind="N"  ;是设置了是否发现可用申请科室默认"N"
     
    ;查找检查项目可用的申请科室
    s AppRowid=0  f  s AppRowid=$o(^DHCRBCArcItemAppLoci("ARC-APPLOC",ArcItemDR,AppRowid)) q:AppRowid=""  d 
    .q:(ItmAppFind=1)
    .s ItmAppFind=1
    
    s ArcAppRowid=""
    i ItmAppFind=1 s ArcAppRowid=$o(^DHCRBCArcItemAppLoci("ARC-APPLOC",ArcItemDR,AppLocDR,ArcAppRowid))
    i ArcAppRowid'="" s ItmAppSetFind="Y"
    ;w !,"ResAppFindA="_ResAppFind
    q:(ItmAppFind=1)&(ItmAppSetFind="N") "N"
    q:(ItmAppSetFind="Y") "Y"
    
    q:(ItmAppFind=0) "Y"
}

/// 函数名称:IsOpenBookWin
/// 功能:根据病人就诊获取医嘱是否可以打开眼科预约界面
/// 输入参数:病人就诊ID
/// 返回:"Y/N" Y-显示 N-不显示
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisResApptSchudleSystem).IsOpenBookWin("965164||165@965164||166@965165||167")
ClassMethod IsOpenBookWin(OrditemRowid As %String) As %String
{
    s ^DHCRisTemp("IsOpenBookWin")=OrditemRowid
    s logo="N" 
    s Count=$l(OrditemRowid,"@")
    
    for i=1:1:Count 
    {
        s FistOrditemRowid=$p(OrditemRowid,"@",i)
        s oeordrowid=$p(FistOrditemRowid,"||",1)
        s oeorisub=$p(FistOrditemRowid,"||",2)
        s (IPRowid,IPRowid,AppointMethodId,AppointMethod)=""
        s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
        ;w !,"itmmastdr="_itmmastdr
        i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
        i IPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",2)
        ;w !,"AppointMethodId="_AppointMethodId
        ;i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)
        s itemcatdesc=""
        i itmmastdr'="" d 
        .s itemcatdr=$p(^ARCIM(+itmmastdr,$p(itmmastdr,"||",2),1),"^",10) 
        .s itemcatdesc=$p(^ARC("IC",itemcatdr),"^",2)
        /*
        i (AppointMethodId="3")     ;||(AppointMethodId="4")
             {
                s logo="Y"
             }
             */
         s isBodyPart="N"
         s arReqID=$o(^DHCAPREP(0,"OrdItem",FistOrditemRowid,""))
		if ( arReqID'="")
		{
			s CH=$o(^DHCAPREP(0,"OrdItem",FistOrditemRowid,arReqID,""))
			if (CH'="")
			{
				if ($d(^DHCAPREP(arReqID,"AR",CH)))
				{
					s Sub=""
					f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
					.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
					.s ExtStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) 
					.Q:PartID=0
					.q:ExtStat="D"
					.s isBodyPart="Y"
					.;查询部位
					.s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",itmmastdr,PartID,0))
					.if bookparamRowid'="" d
					..s appointMethodIdBody=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
					..i appointMethodIdBody=3 d
					...s logo="Y"
				}
			}
		}
		
		if (isBodyPart="N")
		{
			i (AppointMethodId="3") 
             {
                s logo="Y"
             }
		}		
     }
    Q logo
}

/// 函数名称:SetBookLog
/// 功能:记录预约、转预约、取消预约日志
/// 输入参数:登陆用户ID^IP^医嘱ID^检查号^排版资源ID^状态
/// 返回:SQLCODE 0
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisResApptSchudleSystem).SetBookLog("685^10.10.116.103^20017||3865^20017-3865^10376^预约")
ClassMethod SetBookLog(BookInfo As %String) As %String
{
   s (LogUserID,LogIP,LogOpDate,LogOpTime,LogOrordItmDR,LogStudyNo)=""
   s (LogGetBKDate,LogGetBKSTime,LogGetEndTime,LogGetStatus,LogResourceId,LogResDesc)=""
   
   s SQLCODE="-1"
   s LogUserID=$p($g(BookInfo),"^",1)
   s LogIP=$p($g(BookInfo),"^",2)
   s LogOrordItmDR=$p($g(BookInfo),"^",3)
   s LogStudyNo=$p($g(BookInfo),"^",4)
   s LogSchdulID=$p($g(BookInfo),"^",5)
   s LogGetStatus=$p($g(BookInfo),"^",6)
   s LogOpDate=+$h
   s LogOpTime=$p($h,",",2)
   
   i LogSchdulID'="" d
   .s LogGetSTime=$p($g(^DHCRBCResourceSchdule(LogSchdulID)),"^",5)
   .s LogGetEndTime=$p($g(^DHCRBCResourceSchdule(LogSchdulID)),"^",6)
   .s LogGetBKDate=$p($g(^DHCRBCResourceSchdule(LogSchdulID)),"^",2)
   .s LogResourceId=$p($g(^DHCRBCResourceSchdule(LogSchdulID)),"^",1)
   .s LogResDesc="",LogCTCPDR="",LogEQDR=""
   .i LogResourceId'="" s LogCTCPDR=$p($g(^RB("RES",LogResourceId)),"^",2)
   .s LogCTCPDR=$p(LogCTCPDR,$c(0))
   .i LogCTCPDR'="" d
   ..s LogResDesc=$p($g(^CTPCP(LogCTCPDR,1)),"^",2)
   .else  d
   ..s LogEQDR=$p($g(^RB("RES",LogResourceId)),"^",3)
   ..s LogResDesc=$p($g(^RBC("EQ",LogEQDR)),"^",2)
   
   
   &sql(insert into  DHCRB_SaveBookLog(DSBL_USER_DR,DSBL_IP,DSBL_OperateDate,DSBL_OperateTime,DSBL_OEordItem_DR,DSBL_StudyNo,DSBL_BookDate
           ,DSBL_StartTime,DSBL_EndTime,DSBL_Status,DSBL_EQ) 
        values (:LogUserID,:LogIP,:LogOpDate,:LogOpTime,:LogOrordItmDR,:LogStudyNo,:LogGetBKDate,:LogGetSTime,:LogGetEndTime,:LogGetStatus,:LogResDesc)) 
        
  q SQLCODE
}

/// 函数名称:GetEqAddress
/// 功能:根据资源IDRB_Resource表Rowid 获取设备地址
/// 输入参数:IDRB_Resource表Rowid
/// 返回:设备地址
/// 作者:孙毅
/// 日期:2015-10-22
/// d ##class(web.DHCRisResApptSchudleSystem).GetEqAddress("1381")
ClassMethod GetEqAddress(RessourceID As %String) As %String
{
    //^DHCRBCEquipmentAddressi(EqDR,Rowid)
    s addRowid="",LogEQDR="",address=""
    i RessourceID'="" d
    .s LogEQDR=$p($g(^RB("RES",RessourceID)),"^",3)
    .i LogEQDR'="" d
    .s addRowid=$o(^DHCRBCEquipmentAddressi(LogEQDR,addRowid))
    .i addRowid'="" s address=$p($g(^DHCRBCEquipmentAddress(addRowid)),"^",2)
    
    q address
}

/// w ##class(web.DHCRisResApptSchudleSystem).autoSendAppbill("771025||4")
ClassMethod autoSendAppbill(oeorditemdr As %String) As %String
{
    s Count=$l(oeorditemdr,"@")
    s SGroupRowid=""
    s SQLCODE=100
    for i=1:1:Count 
    {
        s FistOrditemRowid=$p(oeorditemdr,"@",i)
        s oeordrowid=$p(FistOrditemRowid,"||",1)
        s oeorisub=$p(FistOrditemRowid,"||",2)
        s (IPRowid,IPRowid,AppointMethodId,AppointMethod)=""
        s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
        ;w !,"itmmastdr="_itmmastdr
        s IsAutoSendApp=""
        i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
        i IPRowid'="" s IsAutoSendApp=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",10)
        i (IsAutoSendApp="Y")
             {
               s artItemDr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
               s recLoc=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6)
               s caredr=$p(^OEORD(oeordrowid,"I",oeorisub,1),"^",11)
               s ssUserDr="",AppRowid=""
               s ssUserDr=$o(^SSU("SSUSR",0,"CTPCP",caredr,ssUserDr))
    
                s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
                ;w !,AppRowid,!
                s date=+$h
                s time=$p($h,",",2)
                if ( AppRowid'= "")
                {
                    &sql(update DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time,DRA_LocID_DR) 
                        values ( :oeorditemdr,:ssUserDr,:date,:date,:time,:recLoc) where DRA_RowID=:AppRowid )
                }
                else
                {
                    &sql(insert into DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time, DRA_LocID_DR) 
                          values ( :oeorditemdr,:ssUserDr,:date,:date,:time,:recLoc))
                    s rowid=$p(%ROWID,$c(1))
                    &sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:rowid,:oeorditemdr))
                }

             }
    
    
    }
    ;w !,isSend,!
    q SQLCODE
}

/// do ##class(web.DHCRisResApptSchudleSystem).TTT()
ClassMethod TTT() As %String
{
   s oeorditemdr="771025||4"
    s AppRowid=""
    s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0))
    w !,"AppRowid="_AppRowid
    q AppRowid
}

/// 拼医嘱ID串，以"@"分隔
ClassMethod TransOrditmID(OrditemRowid As %String) As %String
{
    s OrditemRowid2=""
    s num=$l(OrditemRowid,"^")
    for j=1:1:(num-1) 
    {
     s OrditemRowid1=$p(OrditemRowid,"^",j)
     s OrditemRowid1=$p(OrditemRowid1,"*",2)
     i OrditemRowid2="" s OrditemRowid2=OrditemRowid1
     e  s OrditemRowid2=OrditemRowid2_"@"_OrditemRowid1
        }
    ;s ^tmpguojie("IsOpenBookWin",1)=OrditemRowid2_"######"_num_"#####"_OrditemRowid
    q OrditemRowid2
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：lei 
/// 日期：2016-04-07
/// w ##class(web.DHCRisResApptSchudleSystem).GetBookUseRes("","","68","967","965463||7","","")
ClassMethod GetBookUseRes(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OeorditemRowid As %String = "", GetEqDR As %String = "", bookUseType As %String = "1") As %String
{
    s ^DHCRis("GetBookUseRes")=ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId_"^"_OeorditemRowid_"^"_GetEqDR_"^"_bookUseType
    s bFind=0
    if ChargeDate="" d
    .s ChargeDate=+$h
    s Day=ChargeDate
    s UseResInfo=""
    s ServiceName=""
    s bookUseType=1
    
    i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
    .;w !,ServiceName
    ;i (Empty'="Y")&(ServiceName="CTB组") d            ; 未空腹的CTB组第二天进行预约
    ;.s Day=Day+1  
   
    //查找可使用的预约资源
    while(bFind<1)
    {   
        ;w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
        s UseResInfo=..GetFutureUseBookInfo(Day,ChargeDate,ChargeTime,ServiceGroupId,LocId,OeorditemRowid,GetEqDR,bookUseType)
        ;w !,"UseResInfo="_UseResInfo
        if (UseResInfo="")
        {
            s Day=Day+1
            i (Day-ChargeDate)>50  s bFind=1   ;如果超过50天没有，可能是系统没有设置排版，则退出循环
           
        }   
        else    ; 找到可用的计划
        {   
            s bFind=1
        }
    }
    
    q UseResInfo
}

/// 函数：GetFutureUseBookInfo
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：lei
/// 日期：2016-04-07
/// w ##class(web.DHCRisResApptSchudleSystem).GetFutureUseBookInfo("","","","68","967","965463||7","","")
ClassMethod GetFutureUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "", GetEqDR As %String = "", bookUseType As %String = "1") As %String
{
    s ^DHCRisTemp("GetFutureUseBookInfo")=Day_"^"_InChargeDate_"^"_InChargeTime_"^"_ServiceGroupId_"^"_LocId_"^"_OEorditem_"^"_GetEqDR
    s MaxRemainNumber=0    ; 最大的剩余数
    s SelSchuldRowid=0
    s LastRatio=1.0
    s Info="",ServiceName="",LastInfo="",CurrentRatio=""
    s CurrentTime=$p($h,",",2)
    s CurrentDate=+$h
    //s FindServiceCount=0
    //s FindServiceCount=$l(ServiceGroupId,",")

    s OrderRowid=$p(OEorditem,"||",1)
    s ItemRowid=$p(OEorditem,"||",2)
    s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2) 
    
    s RecLocdr=""
    s locDrList=""
    if (OEorditem'="") 
    {
        s RecLocdr=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)
        /*s LocList=##Class(web.DHCDocOrderCommon).GetArcimReclocStr(OEorditem,RecLocdr)
        ;w !,LocList
        for LocNumber=1:1:$l(LocList,$c(2))
        {
            s locInfoList=$p(LocList,$c(2),LocNumber)
            if (locInfoList'="")
            {
                s locDesc=$p(locInfoList,$c(1),2)
                s locDrList=locDrList_"@"_$p(locInfoList,$c(1),1)
                ;w !,locDrList
            }
        }*/
        if (locDrList="")
        {
            s locDrList=RecLocdr
        }
    }
    
    //^DHCRBCResSchdulei("Date-Time-ServiceRes",{DRPS_Date},{DRPS_StartTime},{DRPS_ServiceGroupID},{DRPS_RessourceID},
    
    s stTime=""
    for
    {
        s stTime=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",Day,stTime))
        q:(stTime="" )
        ;W !,$zd(Day,3)_" "_$zt(stTime,1)_"^"_Day_"^"_stTime
        q:(LastInfo'="")
        s ServiceId=""
        for
        {
            s ServiceId=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",Day,stTime,ServiceId))
            q:(ServiceId="")
            ;w !,ServiceId_"^"_ServiceGroupId
            if (ServiceGroupId'[ServiceId)
            {
                continue
            }
            s RessourceID="" for  s RessourceID=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",Day,stTime,ServiceId,RessourceID)) q:(RessourceID="")  d
            .s SchRowid=0  for  s SchRowid=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",Day,stTime,ServiceId,RessourceID,SchRowid)) q:(SchRowid="")  d
            ..s Info="" 
            ..;w !,RessourceID_"^"_SchRowid
            ..q:(RessourceID="")
            ..s locRes=$p($g(^RB("RES",RessourceID)),"^",1)
            ..q:(locDrList'[locRes)
            ..s BK=""
            ..s BK=##class(web.DHCRisBookParam).GetAppResParam(OEorditem,RessourceID)
            ..q:(BK="N")
            ..q:(GetEqDR'="")&(GetEqDR'=RessourceID)
            ..s StartTime=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",5) 
            ..s EndTime=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",6)
            ..q:(StartTime="") 
            ..q:((Day=CurrentDate)&(EndTime<CurrentTime))  ;当天需要判断当前时间
            ..;............
            ..s UseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",9)   ; 使用数
            ..i UseNumber="" s UseNumber=0
            ..s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
            ..s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
            ..i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
            ..s availPatType=$p(^DHCRBCResourceSchdule(SchRowid),"^",19)
            ..q:((availPatType'="")&&(availPatType'[PatType))
            ..;wf 判断不可用，退出
    		..s notAvailable=$p(^DHCRBCResourceSchdule(SchRowid),"^",23)
    		..q:(notAvailable="Y")
            ..s RemainNum=MaxNumber-UseNumber
            ..;i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
            ..i MaxNumber'=0  s CurrentRatio=$fn(UseNumber/MaxNumber,"",3) ;占用比率=已使用数/最大预约数
            ..;i MaxNumber=0 s CurrentRatio=1.0
            ..q:(MaxNumber=0)
            ..q:(UseNumber=MaxNumber)
            ..if (Day>InChargeDate) d   //
            ...i (RemainNum>0)  d
            ....s Info=SchRowid_"^"_Day_"^"_StartTime
            ..else  if (Day=InChargeDate) d
            ...if ( CurrentTime<ChargeTime) d
            ....s Info=SchRowid_"^"_Day_"^"_StartTime
            ..;w !,"Info"_Info
            ..if (Info'="")&(CurrentRatio<=LastRatio) d
            ...s LastRatio=CurrentRatio
            ...s LastInfo=Info
        }
        
    }
    

    q LastInfo
}

/// 查询显示预约打印按钮的安全组
Query QuerySSGroupShowPrintB() As %Query(ROWSPEC = "TRowid:%String,TName:%String")
{
}

ClassMethod QuerySSGroupShowPrintBExecute(ByRef qHandle As %Binary) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisResApptSchudleSystem","QuerySSGroupShowPrintB")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid="" f  s Rowid=$o(^SSU("SSGRP",Rowid)) q:(Rowid="")  d
 .s Desc=$p(^SSU("SSGRP",Rowid),"^",1)
 .if ( $g(^DHCRisGlobalSet("ShowBookPrintBtn",Rowid))="Y") d
 ..Do OutShowPrint
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutShowPrint
 set Data=$lb(Rowid,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySSGroupShowPrintBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSGroupShowPrintBExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
     
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySSGroupShowPrintBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSGroupShowPrintBExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询显示预约打印按钮的安全组
Query QuerySSGroup(GroupDesc As %String) As %Query(ROWSPEC = "TRowid:%String,TName:%String")
{
}

ClassMethod QuerySSGroupExecute(ByRef qHandle As %Binary, GroupDesc As %String) As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCRisResApptSchudleSystem","QuerySSGroupShowPrintB")
 Set repid=$I(^CacheTemp)
 s ind=1
 
 s Rowid="" f  s Rowid=$o(^SSU("SSGRP",Rowid)) q:(Rowid="")  d
 .s Desc=$p(^SSU("SSGRP",Rowid),"^",1)
 .if ( Desc[GroupDesc) d
 ..Do OutSSGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutSSGroup
 set Data=$lb(Rowid,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerySSGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
     
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QuerySSGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod setBookPrintFlag(GroupId As %String, Flag As %String) As %String
{
    if (GroupId'="") d
    .s ^DHCRisGlobalSet("ShowBookPrintBtn",GroupId)=Flag
    q "0"
}

ClassMethod getBookPrintFlag(GroupId As %String) As %String
{
    q $g(^DHCRisGlobalSet("ShowBookPrintBtn",GroupId))
}

/// 函数：AutoBooked
/// 功能：自动预约
/// w ##class(web.DHCRisResApptSchudleSystem).AutoBooked()
ClassMethod AutoBooked(orderList As %String, userId As %String, ipInfo As %String) As %String
{
    s ^DHCRisTemp("AutoBooked")=orderList_"^"_userId_"^"_ipInfo
    ;s orderList=$p(info,"^",1)
    ;s userId=$p(info,"^",2)
    ;s ipInfo=$p(info,"^",3)
    s orderListToday=""
    s orderListBook=""
    s retOrder=""
    s maxDate=""
    s sameDayOrder=""
    s OrderInfo=""
    for num=1:1:$l(orderList,"@")
    {
        s orderRowId=$p(orderList,"@",num)
        
        //s nearBookInfo=
        if (orderRowId'="" )
        {
            s arcimid=$p(^OEORD($p(orderRowId,"||",1),"I",$p(orderRowId,"||",2),1),"^",2)
            s RecLocdr=$p(^OEORD($p(orderRowId,"||",1),"I",$p(orderRowId,"||",2),3),"^",6)
            s paadmId=$p(^OEORD($p(orderRowId,"||",1)),"^",1)
            s SGInfo=##class(web.DHCRisCommFunctionEx).GetServiceGroup(arcimid)
            i SGInfo'="" d
            .s ServerGroupDR=$p($g(SGInfo),"^",1)
            .s SGroupDesc=$p($g(SGInfo),"^",2)
            s OrderInfo(orderRowId,1)=RecLocdr
            s OrderInfo(orderRowId,2)=ServerGroupDR
            s nearBookInfo=..GetBookUseRes("","",ServerGroupDR,RecLocdr,orderRowId,"","")
            ;w !,nearBookInfo
            //=SchRowid_"^"_Day_"^"_StartTime
            s scheduleRowid=$p($g(nearBookInfo),"^",1)
            s bookDate=$p($g(nearBookInfo),"^",2)
            if (bookDate'="")
            {
                //s bookDate=$zdh(bookDate,3)
                if (bookDate=+$h)
                {
                    s ret=..InsertBookedData(orderRowId_"^"_scheduleRowid_"^"_paadmId_"^"_userId_"^"_ipInfo)
                    ;w !,ret
                    if ($p(ret,"^",1)= "0")
                    {
                        if (retOrder="")
                        {
                            s retOrder=orderRowId
                        }
                        else
                        {
                            s retOrder=retOrder_"^"_orderRowId
                        }
                    }       
                }
                else
                {
                    if (maxDate="")
                    {
                        s maxDate=bookDate
                    }
                    else
                    {
                        if (bookDate>maxDate)
                        {
                            s maxDate=bookDate
                        }
                    }
                    if (sameDayOrder="")
                    {
                        s sameDayOrder=orderRowId
                    }
                    else
                    {
                        s sameDayOrder=sameDayOrder_"^"_orderRowId
                    }
                }
            }
        }
    }
   
    ;b //01
    for num=1:1:$l(sameDayOrder,"^")
    {
        s orderRowId=$p(sameDayOrder,"^",num)
        if (orderRowId'="" )
        {
            s paadmId=$p(^OEORD($p(orderRowId,"||",1)),"^",1)
            s BookInfo=..GetBookUseRes(maxDate,"",OrderInfo(orderRowId,2),OrderInfo(orderRowId,1),orderRowId,"","")
            s scheduleRowid=$p($g(BookInfo),"^",1)
            s bookDate=$p($g(BookInfo),"^",2)
            
            if (bookDate'="")
            {
                
                //s bookDate=$zdh(bookDate,3)
                ;b //02
                if (bookDate=maxDate)
                {
                    
                    s ret=..InsertBookedData(orderRowId_"^"_scheduleRowid_"^"_paadmId_"^"_userId_"^"_ipInfo)
                    ;b //03
                    if ($p(ret,"^",1)= "0")
                    {
                        if (retOrder="")
                        {
                            s retOrder=orderRowId
                        }
                        else
                        {
                            s retOrder=retOrder_"^"_orderRowId
                        }
                    }       
                }
            }
        }
    }
    q retOrder
}

/// w ##class(web.DHCRisResApptSchudleSystem).getBookInfo("2521699||9")
ClassMethod getBookInfo(order As %String) As %String
{
    s ret=""
    q:(order="") ""
    
    s ResourceDesc=""
    s ResDetailRowid=""
    s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,order,0)) 
    i (ResDetailRowid'="")
    {
       s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
       i ResSchduleID'="" d
       .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       .s ResourceDesc=""
       .i ResouceId'="" d
       ..s EqId=$p(^RB("RES",ResouceId),"^",3)
       ..s CareProvId=$p(^RB("RES",ResouceId),"^",2)
       ..i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
       ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
       .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       .i Date'="" s BookedDate=$zd(Date,3)
       .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       .i StartTime'="" s BooketSTime=$zt(StartTime)
       .s endTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
       .i endTime'="" s BooketETime=$zt(endTime)
       .s ret=ResDetailRowid_"^"_BookedDate_"^"_BooketSTime_"^"_BooketETime_"^"_ResourceDesc
    }


    q ret
}

/// w ##class(web.DHCRisResApptSchudleSystem).getPatientInfo("0000000043")
ClassMethod getPatientInfo(RegNo As %String) As %String
{
	q:(RegNo="") ""
	s ret=""
	s papatmasmdr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(RegNo,"U"),""))
	if (papatmasmdr'="")
	{
	   ;s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
       ;s ^DHCRISTEMP("papatmasmdr")=papatmasmdr_"^"_paadmdr        
       s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
       ;q:RegNo=""  
       s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
       ;s PinYin=..HZtoPin(Name)
       s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
       /*s CardNo=""
       i papatmasmdr'="" s CardNo=..GetCardNobyPatDR(papatmasmdr)
       i $g(^PAPER(papatmasmdr,"PAT",3))'="" d
     	 .s SafetynetCardNo=$p(^PAPER(papatmasmdr,"PAT",3),"^",4)
     	 */
       i DOB="" d
 	 	.s strDOB=""
 	 	.s strAge=""
 	   e  d
        .s strDOB=$ZD(DOB,3)
        .s strToday=$ZD(+$h,3)
        .s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
        .s year=$p(strDOB,"-",1)
        .s Month=$p(strDOB,"-",2)
        .s day=$p(strDOB,"-",3)
        .s strDOB=day_"/"_Month_"/"_year
       s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
       i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
       s ret=RegNo_"^"_Name_"^"_SexDesc_"^"_strAge
	}
	q ret
}

/// w ##class(web.DHCRisResApptSchudleSystem).GetRegNofromCardNo("115311677001")
ClassMethod GetRegNofromCardNo(CardNo As %String) As %String
{
    s CardRowid=0,RegNo=""
    s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1) 
    i CardRowid'="" d
    .s RegNo=$p($g(^DHCCARD("CF",CardRowid)),"^",6)
    q RegNo
}

/// 插入预约资源排版
/// lei  20160801
/// w ##class(web.DHCRisResApptSchudleSystem).InsertBookResourse("414^内镜1^1^内镜1诊室^14:00:00^17:00:00^15^5^18:00:00")
ClassMethod InsertBookResourse(Info As %String)
{
		s ^DHCRisTMP("InsertBookResourse")=Info
	s LocID=$p($g(Info),"^",1)
	s Rersource=$p($g(Info),"^",2)
	s weekID=$p($g(Info),"^",3)
	s ServiceGroup=$p($g(Info),"^",4)
    s StartTime=$p($g(Info),"^",5)
    i StartTime'="" s StartTime=$zth(StartTime,1)
    s EndTime=$p($g(Info),"^",6)
    i EndTime'=""  s EndTime=$zth(EndTime,1)
    s MaxNumber=$p($g(Info),"^",7)
    s AutoNumber=$p($g(Info),"^",8)
    s ChargeTime=$p($g(Info),"^",9)
    i ChargeTime'=""  s ChargeTime=$zth(ChargeTime,1)
    s notAvailable=$p($g(Info),"^",10)
    if (notAvailable="是")
    {
		s notAvailable="Y"
    }
    else
    {
	    s notAvailable=""
    }
    b 
    ;w !,"StartTime="_StartTime
    ;w !,"EndTime="_EndTime
    s (EQEquipmentRowid,ServiceGroupID,ServiceGroupCode,ResPlanID,GetweekID,GetServiceGroupID)=""    
    s (GetStartTime,GetEndTime,GetLocID,RersourceID)=""
    i ServiceGroup'="" d
    .s ServiceGroupID=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ServiceGroup),0))
    q:(LocID="") ""
	q:(Rersource="") ""

    s EQEquipmentRowid=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Rersource),EQEquipmentRowid))
    q:(EQEquipmentRowid="") ""
	s RersourceID=$o(^RB("RES",0,"EQ",EQEquipmentRowid,LocID,RersourceID))
	q:(RersourceID="") ""
	s resPlanRowid=""
    s ResPlanID="" f  s ResPlanID=$o(^DHCRBCResPlani("Week-Resource",weekID,LocID,RersourceID,ResPlanID))  q:(ResPlanID="")  d 
    .s GetStartTime=$P(^DHCRBCResourcePlan(ResPlanID),"^",5)
    .s GetNotAvailable=$P(^DHCRBCResourcePlan(ResPlanID),"^",15)
    .;b //3
    .;if ((GetStartTime=StartTime) &&(GetNotAvailable=notAvailable)) d
    .if (GetStartTime=StartTime)  d
    ..s GetLocID=$P(^DHCRBCResourcePlan(ResPlanID),"^",1)
    ..s GetweekID=$P(^DHCRBCResourcePlan(ResPlanID),"^",7)
    ..s GetServiceGroupID=$P(^DHCRBCResourcePlan(ResPlanID),"^",3)
    ..s resPlanRowid=ResPlanID
    i (resPlanRowid'="")
    {
	    b //1
	     &sql(update  DHCRBC_ResPlan (DRP_LocID,DRP_ResourceID,DRP_Week,DRP_ServiceGroupID,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime,DRP_NotAvailable)
	     values(:LocID,:RersourceID,:weekID,:ServiceGroupID,:StartTime,:EndTime,:MaxNumber,:AutoNumber,:ChargeTime,:notAvailable) where DRP_RowID =:resPlanRowid )
	    
	}
	else{
		b //2
    &sql(insert into DHCRBC_ResPlan (DRP_LocID,DRP_ResourceID,DRP_Week,DRP_ServiceGroupID,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime,DRP_NotAvailable)
           values (:LocID,:RersourceID,:weekID,:ServiceGroupID,:StartTime,:EndTime,:MaxNumber,:AutoNumber,:ChargeTime,:notAvailable))
	
	}
    q SQLCODE
}

/// 插入基础数据(服务组，设备，指定设备到科室)
/// lei  20160801
/// w ##class(web.DHCRisResApptSchudleSystem).InsertBasedata("414^内镜1^内镜1^内镜1诊室^内镜1诊室^门诊楼3层")
ClassMethod InsertBasedata(Info As %String)
{
	s ^DHCRisTMP("InsertBasedata")=Info
	s LocID=$p($g(Info),"^",1)
	s EQCode=$p($g(Info),"^",2)
	s EQDesc=$p($g(Info),"^",3)
    s ServiceGroupCode=$p($g(Info),"^",4)
    s ServiceGroupDesc=$p($g(Info),"^",5)
    s StartDate=+$h    ;$p($h,",",1)
    ;i StartDate'=""  s StartDate=$zdh(StartDate,4)
    s RoomAddress=$p($g(Info),"^",6)
    
    s (EQRowID,GetEQCode,GetEQDesc,RBRowid)=""    
    s (GetSGCode,GetSGDesc)=""

    s EQRowID=""  F  s EQRowID=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(EQDesc),EQRowID)) Q:(EQRowID="")  d
    .s GetEQCode=$p(^RBC("EQ",EQRowID),"^",1)
    .s GetEQDesc=$p(^RBC("EQ",EQRowID),"^",2)
    .s EQIDRowid=EQRowID
    
    if ((EQCode'=GetEQCode)&&(EQDesc'=GetEQDesc))
    {
	    ;b //1
	    &sql(insert into RBC_Equipment (EQ_Code,EQ_Desc,EQ_DateFrom) values (:EQCode,:EQDesc,:StartDate))
		s EQIDRowid=$p(%ROWID,$c(1))
	}
	//s EQIDRowid=$p(%ROWID,$c(1))
	
	s Availability="-1",QueueLen="999",Type="Equipment",ScheduleRequired="Y"
	s RBRowid=$o(^RB("RES",0,"EQ",EQIDRowid,LocID,RBRowid))  
	;w !,"RBRowid="_RBRowid
	;w !,"EQIDRowid="_EQIDRowid
    if (RBRowid="")
    {
	    ;b //2
    	&sql(insert into RB_Resource (RES_CTLOC_DR,RES_EQ_DR,RES_Code,RES_Availability,RES_QueueLen,RES_Type,RES_ScheduleRequired,RES_DateActiveFrom)
			values (:LocID,:EQIDRowid,:EQCode,:Availability,:QueueLen,:Type,:ScheduleRequired,:StartDate))
    }

    s PreadmissionCheck="N",BypassDateCheck="N",AllowBookAfterDischarge="N"
    s ServiceGroupCodeID=""  f   s ServiceGroupCodeID=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ServiceGroupDesc),ServiceGroupCodeID))  q:(ServiceGroupCodeID="")  d
    .s GetSGCode=$p(^RBC("SG",ServiceGroupCodeID),"^",1)
    .s GetSGDesc=$p(^RBC("SG",ServiceGroupCodeID),"^",2)
    
    if ((ServiceGroupCode'=GetSGCode)&&(ServiceGroupDesc'=GetSGDesc))
    {
	    ;b //3
	   &sql(insert into RBC_ServiceGroup (SG_Code,SG_Desc,SG_PreadmissionCheck,SG_BypassDateCheck,SG_AllowBookAfterDischarge,SG_DateFrom) 
	        values (:ServiceGroupCode,:ServiceGroupDesc,:PreadmissionCheck,:BypassDateCheck,:AllowBookAfterDischarge,:StartDate))
    }
    q SQLCODE
}

/// 插入基础数据(诊间,诊间设备)
/// lei  20160801
/// w ##class(web.DHCRisResApptSchudleSystem).InsertRoomdata("83^CT16^CT16^CT16^门诊地下一层")
ClassMethod InsertRoomdata(Info As %String)
{
	s ^DHCRisTMP("InsertRoomdata")=Info
	s LocID=$p($g(Info),"^",1)
	s RoomCode=$p($g(Info),"^",2)
	s RoomDesc=$p($g(Info),"^",3)
	s EQDesc=$p($g(Info),"^",4)
    s RoomAddress=$p($g(Info),"^",5)
    
    s (EQRowID,GetEQCode,GetEQDesc,ResPlanID,GetweekID,GetServiceGroupID,RBRowid)=""    
    s (GetStartTime,EQRowid)=""

    s GetRoomRowid="" f  s GetRoomRowid=$o(^DHCRBCi(0,"LocDR",LocID,GetRoomRowid))  q:(GetRoomRowid="")  d
    .s RoomCode1=$p(^DHCRBC("Room",GetRoomRowid),"^",1)
    .i RoomCode1=RoomCode d
    ..s GetRoomCode=RoomCode1
    ..s GetRoomName=$p(^DHCRBC("Room",GetRoomRowid),"^",2)
     
    if ((RoomCode'=GetRoomCode)&&(RoomDesc'=GetRoomName))
    {
	    &sql(insert into DHCRBC_Room (DCRM_RoomCode,DCRM_RoomName,DCRM_Loc_DR,DCRM_Address) 
	        values (:RoomCode,:RoomDesc,:LocID,:RoomAddress))
	 }
    s RoomRowID=$p(%ROWID,$c(1))
    s Count=$l(EQDesc,",")

	for i=1:1:Count 
    {
	  s EQDesc=$p(EQDesc,",",i)
      s EQRowid=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(EQDesc),EQRowid))
      ;w !,"EQRowid="_EQRowid
      if (EQRowid'="")
      {
      	&sql(Insert into DHCRBC_Room_Equipment(DCRME_ParRef,DCRME_Equipment_DR) 
	      values(:RoomRowID,:EQRowid))
      }
    }
    
	      
    q SQLCODE
}

/// w ##class(web.DHCRisResApptSchudleSystem).ImportItemBodyData("F00000006051^自动预约^否^内镜1诊室,内镜2诊室^^垂体")
/// w ##class(web.DHCRisResApptSchudleSystem).ImportItemBodyData("ZT001881^服务台预约^一楼3T A增强,二楼3T A增强^30^前列腺^磁共振平扫+动态增强(3.0T)")
ClassMethod ImportItemBodyData(Info As %String) As %String
{
	s ^DHCRis("BSInfo")=Info
	s ArcItmCode=$p($g(Info),"^",1)
    s AppointDesc=$p($g(Info),"^",2)
    s IsEmpty=$p($g(Info),"^",3)
    s ServiceGroup=$p($g(Info),"^",4)
    s ExamTime=$p($g(Info),"^",5)
    s BodyPartCode=$p($g(Info),"^",6)
    
    s ArcItmRowid="" ,SubscriptID="",VersionID="",AppMRowid="",DIPRowid="",GetArcItmRowid="",AppPartRowID=""
    s SerGroupCount=0
    s GetBodyPartCode=""
    i ArcItmCode'="" d
     .s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),0))
     .i SubscriptID'="" d
     ..s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcItmCode),SubscriptID,0))
     ..i VersionID'="" s ArcItmRowid=SubscriptID_"||"_VersionID
     /*..s DIPRowid=$o(^User.DHCAppPartS(ArcItmRowid))
     ..i DIPRowid'="" s GetArcItmRowid=$lg(^User.DHCRBCBookParamD(DIPRowid),"^",1)
     */
    q:(ArcItmRowid="") ""
    
    i AppointDesc'="" d
    .s AppMethodID=0 f  s AppMethodID=$o(^DHCRBCAppointMethod(AppMethodID)) q:(AppMethodID="")  d
    ..s AppDesc=$p(^DHCRBCAppointMethod(AppMethodID),"^",2)
    ..i (AppDesc=AppointDesc) s AppMRowid=AppMethodID
	q:(AppMRowid="") ""
	
	s PartID=""
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",ArcItmRowid,TraID)) q:TraID=""  d
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",ArcItmRowid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..q:(PartID="")
	..;Q:'$D(^DHCAPPART(PartID))
	..;s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	..s PartCode=$p(^DHCAPPART(PartID),"^",1)  /// 部位代码
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)  /// 部位描述
	
	..i (BodyPartCode'="")&&(BodyPartCode=PartCode) d
	...s AppPartRowID=PartID   ;$o(^DHCAPPART(0,"Code",BodyPartCode,AppPartRowID))   
    
    q:(AppPartRowID="") "-200"
	i (IsEmpty="是")
	{
	   s IsEmpty="Y"
	}
	else
	{
	   s IsEmpty="N"	
	}
	i (BodyPartCode'="") d
    .s BPRowID="" f  s BPRowID=$o(^User.DHCRBCBookParamI("IndexItemBody",ArcItmRowid,AppPartRowID,BPRowID))  q:(BPRowID="")  d
    ..;w !,"BPRowID="_BPRowID
    ..s GetArcItmRowid=$lg(^User.DHCRBCBookParamD(BPRowID),2)
    ..s GetBodyPartCode=$lg(^User.DHCRBCBookParamD(BPRowID),4)
	
    s ParentRefRowid=""
	i ((ArcItmRowid=GetArcItmRowid)&&(BodyPartCode=GetBodyPartCode))
	{
	    &sql(update dhcrbc_bookparam set AppointMethodID=:AppMRowid,IsEmpty=:IsEmpty,ExamTime=:ExamTime 
	        where ArcItmMastRowid =:ArcItmRowid and BodyCode =:BodyPartCode)

	}
	else
	{
	    &sql(insert into dhcrbc_bookparam (AppointMethodID,ArcItmMastRowid,BodyCode,BodyRowid,ExamTime,IsEmpty)
	       values (:AppMRowid,:ArcItmRowid,:BodyPartCode,:AppPartRowID,:ExamTime,:IsEmpty))
  
	} 
	s ParentRefRowid=$p(%ROWID,$c(1))

	i (ParentRefRowid'="")
	{

		&sql(delete from dhcrbc_bookparamsg where BPParref=:ParentRefRowid)
		
		i ServiceGroup'="" d
		.s SerGroupCount=$l(ServiceGroup,",")
		.f i=1:1:SerGroupCount d
		..s ServiceGroupId=""
		..s perServiceGroup=$p(ServiceGroup,",",i)
	    ..s ServiceGroupId=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(perServiceGroup),0))
	    ..i ServiceGroupId'="" d
	    ...s SameCount=0
	    ...&sql(select count(*) into :SameCount from dhcrbc_bookparamsg
 	         where ServiceGroupID=:ServiceGroupId and BPParref=:ParentRefRowid)
	    ...i SameCount=0 d
	    ....&sql(Insert into dhcrbc_bookparamsg(BPParref,ServiceGroupCode,ServiceGroupID) values(:ParentRefRowid,:perServiceGroup,:ServiceGroupId))	
	}
   
	q SQLCODE
}

/// 取登记表rowid
/// wf  20160814 入参为  医嘱^部位
ClassMethod getRegRowid(orderBody) As %String
{
	s ^TempDHCRis("getRegRowid")=orderBody
	
	s regInfoDrRet=""
    s orderitemRowid=$p(orderBody,"^",1)
	s bodyRowid=$p(orderBody,"^",2)
	q:(orderitemRowid="") ""
	s reginfoRowid=""
	for
	{
		s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",orderitemRowid,reginfoRowid))
		q:(reginfoRowid="")	
		if (bodyRowid'="")
		{
			s childSub=""
			for 
			{
				s childSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub))
				q:(childSub="")
				s bodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub),"^",1)
				if (bodyDr=bodyRowid)
				{
					s regInfoDrRet=reginfoRowid
				}
			}
		}
		else
		{
			s regInfoDrRet=reginfoRowid
		}
		
	}
	
	
	q regInfoDrRet
}

/// 取预约明细表rowid
/// wf  20160814 入参为  医嘱^部位
/// w ##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid("")
ClassMethod getBookDetailRowid(orderBody As %String) As %String
{
	s detailRowidRet=""
	s orderDr=$p(orderBody,"^",1)
	s bodyRowid=$p(orderBody,"^",2)
	q:(orderDr="") ""
		
	s ResDetailRowid=""
	for 
	{
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderDr,ResDetailRowid)) 
		q:(ResDetailRowid="")
		
		;b //01
	   if (bodyRowid'="")
	   {
			
		   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid,bodyRowid,0))
		   ;b //02
		   if (detailBodyRowid'="")
		   {
			   s detailRowidRet=ResDetailRowid
		   }

	   }
	   else
	   {
	   		s detailRowidRet=ResDetailRowid
	   }
		
	}
	

    q detailRowidRet
}

/// 取预约明细表rowid
/// wf  20160814 入参为  医嘱 部位
/// w ##class(web.DHCRisResApptSchudleSystem).getBookType("")
ClassMethod getBookType(orderRowid, bodyRowid As %String = "") As %String
{
	s appointMethodId=""
	s Find=0
	s bookTypeRet=""
	q:(orderRowid="") ""
	s arcimid=$p(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1),"^",2)
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s appointMethodId=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
		}
		
	}	
	else //if (appointMethodId="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  	s appointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2)
		}
		
	}
	
	if (appointMethodId'="")
	{
		s appointMethodDesc=$p(^DHCRBCAppointMethod(appointMethodId),"^",2)
		s bookTypeRet=appointMethodId_"^"_appointMethodDesc
	}
	q bookTypeRet
}

/// 插入基础数据(设备，指定设备的物理位置)
/// pan  20160817
/// w ##class(web.DHCRisResApptSchudleSystem).InsertEQAdress("病房01诊室^诊间预约")
ClassMethod InsertEQAdress(Info As %String)
{
	s ^DHCRisTMP("InsertBasedata")=Info
	s EQDesc=$p($g(Info),"^",1)
	s Adress=$p($g(Info),"^",2)
    
    s (EQRowID)=""    
   	s EQRowID=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(EQDesc),EQRowID))
  	i (EQRowID'=""){
	s bWrite=""
    &sql(select count(*) into:bWrite from DHCRBC_Equipment_Address where DEA_Equipment_DR=:EQRowID)
    i bWrite=0   d
	.&sql(insert into DHCRBC_Equipment_Address (DEA_Equipment_DR,DEA_Address)values(:EQRowID,:Adress))
    e  d
    .&sql(UpDate DHCRBC_Equipment_Address(DEA_Address)values(:Adress)where DEA_Equipment_DR=:EQRowID)
    q SQLCODE
  	}
}

/// w ##class(web.DHCRisResApptSchudleSystem).GetBodyPartCodeID("头部+胸部+全腹部")
ClassMethod GetBodyPartCodeID(BodyPartCode As %String) As %String
{
	S AppPartRowID=""
	i (BodyPartCode'="") d
	.s AppPartRowID=$o(^DHCAPPART(0,"Code",BodyPartCode,AppPartRowID))   
    
    Q AppPartRowID
}

/// 功能:预约
/// 作者:wf
/// 日期:20160801
/// w ##class(web.DHCRisResApptSchudleSystem).Book(^DHCRis("Ris2015"))
ClassMethod Book(Info As %String) As %String
{
	n (Info)
	s ^TempDHCRis("SchSystemBook")=Info
	
	s OrderItemRowid=$p(Info,"^",1)    //医嘱串，可能会有部位
	s ResSchduleID=$p(Info,"^",2)      //资源计划rowid
	s AppointMethod=$p(Info,"^",3)     //1: 手动， 2：自动 可能会有其他标志 
	//s OherParam=$p($g(Info),"^",4)     //暂时不用
    s InLocDR=$p($g(Info),"^",4)       //科室rowid 可以后台取出
    //s paadr=$p($g(Info),"^",6)         //就诊，暂时不用
    //s InputRegDate="" //$p($g(Info),"^",7)  //日期，应该不用，可以从资源计划取出
    s UserDR=$p($g(Info),"^",5)        //操作人
    //s GetStudyNo=$p($g(Info),"^",9)    //检查号 ，不需要
    //s bookTimeIn=$p($g(Info),"^",10)   //时间点（适用于时间点预约，选座模式）
    //s examTime=$p($g(Info),"^",11)     //检查时间(分钟)
     s InIp=$p($g(Info),"^",6)
     s examTime=""
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	
	//i bookTimeIn'="" d
	//.s bookTime=$zth(bookTimeIn,2)
	

	s bookDateGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	s InputRegDate=$zd(bookDateGet,3)
    
    n MaxNumber,AutoNumber,UseNumber,RemainNumber,AutoUseNumber,nextStartTime,remainTime
    s RegEQIndex="",CheckGroupIndex="",RoomIndex="",IsUpBookNo="",IndexTypeDR=""
    
    //s bookType="1"   ; 1为按最大数预约   2为按检查时间预约
    
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
   
    s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    //i (remainTime'="")&&(nextStartTime'="") d
    //.s bookType="2"
	s bookType=##class(web.DHCRisCodeTableAdd).GetBKUseFlagbyLoc(InLocDR)
	
	s notAvailable=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",23)
    q:(notAvailable="Y") "-800"
	
    s examTime=""
    Set $ZT="ERRORBook"	
    
    s Count=$l(OrderItemRowid,"@")
    
    //判断是否有已经预约的记录 wangfeng 
    s ret=##class(web.DHCRisResourceApptSchudle).hasBookOrder(OrderItemRowid)
    q:(ret="Y") "-11112"
    
    //先判断是不是同一个病人的医嘱
	s isSamePat=##class(web.DHCRisRegisterPatientDoEx).isSamePatient(OrderItemRowid)
	q:(isSamePat="N") "-11111"

    
    lock +(^DHCRisTMPReg)
    
    //k ^DHCRISTMP("STUDYNO")
    
    //TSTART
    //判断此时间点已经有预约,

    //判断资源数
    s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
	i UseNumber="" s UseNumber=0
    i AutoUseNumber="" s AutoUseNumber=0
   	;wangfeng  服务台预约判断手动预约数
   	i AutoNumber="" s AutoNumber=0
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
   	s ManualNumber=MaxNumber-AutoNumber
   	s ManulaUseNumber=UseNumber-AutoUseNumber
   	  
   	s startTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
   	s stopTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
   	
   	
   	s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
   	if (nextStartTime="")
   	{
	   	s nextStartTime=startTime
	}
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    if (remainTime="")
    {
	    s remainTime=(stopTime-startTime)/60
    }
    
    if ((bookDateGet=+$h) && ($p($h,",",2)>stopTime))
   	{
	   	lock -(^DHCRisTMPReg) 
		q "-400"  
	}

    ;预约已满，不允许预约
    if (AppointMethod="2")   //自动预约
    {
	    if ((AutoUseNumber>=AutoNumber)||RemainNumber<=0)
	    {
		    lock -(^DHCRisTMPReg) 
		    q "-100"  
	    }
    }
    else
    {
	    if (RemainNumber<=0)
	    {
		   lock -(^DHCRisTMPReg) 
		   q "-300" 
	    }
    }
    
    
    s bookNo=##class(web.DHCRisResourceApptSchudle).GetBookNo(OrderItemRowid,InLocDR,InputRegDate)
    if (examTime="")
    {
	    s examTime=+(##class(web.DHCRisResourceApptSchudle).getExamTime(OrderItemRowid))
    }
    
    
    s updateNextStartTime="",updateRemainTime="",updateOccupyOfTimeRelease=""
   	s examEndTime="",examStartTime=""
   	s getStartTime="",getEndTime=""
   	
   	if ( (bookType=2) && (examTime=0))  //按最大数预约，检查时间不能为空
   	{
	    lock -(^DHCRisTMPReg) 
		q "-500" 
   	}
    if ((bookType=2) &&(examTime'=0))
    {
	    s bookTimeInfo=##class(web.DHCRisResourceApptSchudle).getBookTimeInfo(examTime,ResSchduleID)
	    /*if (remainTime=0)
	    {
		    lock -(^DHCRisTMPReg) 
		    q "-200" 
	    }
	    */
	    
	    if (bookTimeInfo'="")
	    { 
	    	if ( $p($g(bookTimeInfo),"^",1)="N")
	    	{
		    	lock -(^DHCRisTMPReg) 
				q "-200" 
	    	}
	    	s examStartTime=$p($g(bookTimeInfo),"^",2)
	    	s examEndTime=$p($g(bookTimeInfo),"^",3)
	    	s updateNextStartTime=$p($g(bookTimeInfo),"^",4)
	    	s updateOccupyOfTimeRelease=$p($g(bookTimeInfo),"^",5)
	    }
    }
    else
    {
	    s examStartTime=startTime
	    s examEndTime=stopTime
	    s updateNextStartTime=startTime
	    s updateOccupyOfTimeRelease=""
	    
    }
    
    s retList=##class(web.DHCRisResourceApptSchudle).getNextNumber(ResSchduleID)
    s nextNum=$p(retList,"^",1)
    s updateUseNoList=$p(retList,"^",2)
    /*
    s bookNo=##class(web.DHCRisResourceApptSchudle).GetBookNo(OrderItemRowid,InLocDR,InputRegDate)
    //if (examTime="")
    //{
	    s examTime=##class(web.DHCRisResourceApptSchudle).getExamTime(OrderItemRowid)
    //}
    ;预约时间已满
    if ((+examTime)'=0)
    {
	    if (remainTime=0)
	    {
		    lock -(^DHCRisTMPReg) 
		    q "-200" 
	    }
    }
    s retList=##class(web.DHCRisResourceApptSchudle).getNextNumber(ResSchduleID)
    s nextNum=$p(retList,"^",1)
    s updateUseNoList=$p(retList,"^",2)
    
    s updateNextStartTime="",updateRemainTime=""
   	s examEndTime="",examStartTime=""
   	s getStartTime="",getEndTime=""
    
    
    s examStartTime=nextStartTime
	i ( (nextStartTime+(examTime*60)) < stopTime )
	{ 
	 	s examEndTime=examTime*60+nextStartTime
	}
	else
	{
		s examEndTime=stopTime
	}
	*/
	
    TSTART
    s SQLCODE=100
    
    //插入预约表
    for Ni=1:1:Count 
    {
      s perOrditemRowid=$p(OrderItemRowid,"@",Ni)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
   	  
	  &sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,
	                   	                      DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime) 
	         values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:bookNo,:nextNum,:UserDR,:OperateDate,:OperateTime,:examStartTime,:examEndTime)) 
	    	//values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime)) 
      s detailRowid=$p(%ROWID,$c(1))
      if (bodyList'="")
      {
	      s bodyLength=$l(bodyList,",")
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      if (bodyRowid'="")
		      {
			      s BodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",1)
			      &sql(insert into DHCRBC_SchduleDetailBody (SchduleDetailRowid,BodyRowid,BodyCode)values(:detailRowid,:bodyRowid,:BodyCode))
		      }
	      }
      }
	  q:SQLCODE 
    }  
			
    if (SQLCODE)
    {
		TRollback
		lock -(^DHCRisTMPReg)
		q SQLCODE
    }

    //更新资源计划表
    /*
    s (updateNextStartTime,updateRemainTime,updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
    s updateNextStartTime=examEndTime
    i ((remainTime-examTime)>0) 
    {
    	s updateRemainTime=remainTime-examTime
    }
     else 
     {
     	s updateRemainTime=0
     }
     s updateUseNumber= UseNumber+1
   	 s updateRemainNumber=RemainNumber-1	
   	 if (AppointMethod="2")  //自动预约
   	 {
   	     s updateAutoUseNumber=AutoUseNumber+1
   	 }
   	 else
   	 {
	   	 s updateAutoUseNumber=AutoUseNumber
   	 }
   	 
   
     
   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber)
                          values (:updateAutoUseNumber,:updateRemainNumber,:updateUseNumber,:updateNextStartTime,:updateRemainTime,:updateUseNoList) where  DRPS_RowID=:ResSchduleID)  
 	*/
 	s (updateRemainTime,updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
 	
 	s updateUseNumber= UseNumber+1
   	 s updateRemainNumber=RemainNumber-1	
   	 if (AppointMethod="2")  //自动预约
   	 {
   	     s updateAutoUseNumber=AutoUseNumber+1
   	 }
   	 else
   	 {
	   	 s updateAutoUseNumber=AutoUseNumber
   	 }
   	 
     b //02
   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam)
                          values (:updateAutoUseNumber,:updateRemainNumber,:updateUseNumber,:updateNextStartTime,:updateRemainTime,:updateUseNoList,:updateOccupyOfTimeRelease) where  DRPS_RowID=:ResSchduleID)  
 
     b //03
     if (SQLCODE)
     {
		TRollback
		lock -(^DHCRisTMPReg)
		q SQLCODE
     }  
     

     TCOMMIT  
     lock -(^DHCRisTMPReg)
     
     
     s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(bookNo,"B")
 	 s ^DHCRisTemp("systembookToRis4")=bookNo_"^"_"B"_"^"_ret
 	 
 	 
 
 	//状态接口 	
   	if ($g(UserDR)'="")
   	{
	   	s userName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
   	}
   	//##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus("59||35","222",bookNo,"BK",$g(UserDR),$g(userName))
   	s Count=$l(OrderItemRowid,"@")
    for num=1:1:Count 
    {
	  
      s perOrditemRowid=$p(OrderItemRowid,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyCodeList=""
	      s bodyLength=$l(bodyList,",")
	      s bodyDescList=""
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      
		      if (bodyRowid'="")
		      {
			      s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			      if bodyDescList= "" s bodyDescList=bodyDesc
			      else  s bodyDescList=bodyDescList_"@@"_bodyDesc
			      
		      }
		      
	      }
	      
	      s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,bodyDescList,bookNo,"BK",$g(UserDR),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,bodyDescList,$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"BK"_"^"_$g(UserDR)_"^"_$g(userName)_"^"_$g(ret)
	    
      }
      else
      {

      	  s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,"",bookNo,"BK",$g(UserDR),$g(userName))
	      s ^TempDHCRis("postStatus",perOrditemRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"BK"_"^"_$g(UserDR)_"^"_$g(userName)_"^"_$g(ret)
      	
      }
    }
    /*
    //ris4.0接口
 	s insertObj=##class(RISService.BookPlatformClass.InsertStudyInfo).%New()
 	s insertObj.StudyNo=bookNo
 	s insertObj.BookOrArrive="Book"
 	
 	s Count=$l(OrderItemRowid,"@")
    for num=1:1:Count 
    {
	    s itemObj=##class(RISService.BookPlatformClass.Item).%New()
	    
      s perOrditemRowid=$p(OrderItemRowid,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyCodeList=""
	      s bodyLength=$l(bodyList,",")
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      if (bodyRowid'="")
		      {
			      s BodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",1)
			      s rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(perOrditemRowid_"^"_bodyRowid)
			      if bodyCodeList="" s bodyCodeList=BodyCode
			      e  s bodyCodeList=bodyCodeList_"^"_BodyCode
		      }
	      }
	      
	      s itemObj.BodyCodeList=bodyCodeList
			s itemObj.OEORowid=perOrditemRowid
			s itemObj.Rowid=rowid
			d insertObj.Items.Insert(itemObj)
      }
      else
      {

      		s rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(perOrditemRowid_"^")
	      s itemObj.BodyCodeList=""
	      s itemObj.OEORowid=perOrditemRowid
	      s itemObj.Rowid=rowid
	      d insertObj.Items.Insert(itemObj)
      	
      }
      //s OrdRowid=$p(perOrditemRowid,"||",1)
      //s itemsub=$p(perOrditemRowid,"||",2)
	  //s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
    }
    
    s info=##Class(RISService.BookPlatformInterface).WriteXmlToStream(insertObj,"")
    s ret=##Class(RISService.BookPlatformInterface).InsertStudyInfoPACS(info)
    s ^DHCRisTemp("systembookToRis4",bookNo,$zd(+$h,3),$zt($p($h,",",2),1))=info_"^"_ret
   	*/
   	
    q $g(SQLCODE)
    
  
ERRORBook	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^TempDHCRis("SchSystemBook-error")=ErrorMsg
	b //02
 	TROLLBACK
 	lock -(^DHCRisTMPReg)
 	q $g(SQLCODE)_"^"_$g(ret)
}

/// 是否需要空腹
/// w ##class(web.DHCRisCommFunctionEx).needEmpty("88||69$35,12@88||70$10")
ClassMethod needEmpty(orderList As %String) As %String
{
	s ret="",emptyFind=""
	for lenOfList=1:1:$l(orderList,"@")
	{
		
		s orderBodyList=$p(orderList,"@",lenOfList)
		if (orderBodyList'="")
		{
			
			s orderRowid=$p(orderBodyList,"$",1)
			s arcimid=$p($g(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1)),"^",2)
			s bodyList=$p(orderBodyList,"$",2)
			if (bodyList'="")   //有部位
			{
				for lenOfBody=1:1:$l(bodyList,",")
				{
					s bodyRowid=$p(bodyList,",",lenOfBody)
					if (bodyRowid'="")
					{
						s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
						if (bookparamRowid'="")
						{
							s emptyFind=$lg(^User.DHCRBCBookParamD(bookparamRowid),6)
							if (emptyFind="Y")
							{
								s ret="Y"
							}
						}
					}
				}
			}
			else    //没有部位
			{
				s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
				i (BPRowid'="")
				{
					s emptyFind=$p(^DHCRBCItemBookProperty(BPRowid),"^",4)
					if (emptyFind="Y")
					{
						s ret="Y"
					}
				}
			}	
		}
	}
	
	q ret
}

/// 是否预约
/// wf   入参为  医嘱^部位
/// w ##class(web.DHCRisResApptSchudleSystem).HasBooked("","")
ClassMethod HasBooked(orderItemRowid As %String, bodyRowid As %String = "") As %String
{
	n (orderItemRowid,bodyRowid)
	s hasBooked="N"
	
	q:(orderItemRowid="") hasBooked
		
	s resDeteailRowid=""
	for 
	{
		s resDeteailRowid=$o(^DHCRBCResSchduleDetaili(0,orderItemRowid,resDeteailRowid)) 
		q:(resDeteailRowid="")
		
		;b //01
	   if (bodyRowid'="")
	   {
			
		   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",resDeteailRowid,bodyRowid,0))
		   ;b //02
		   if (detailBodyRowid'="")
		   {
			   s hasBooked="Y"
		   }

	   }
	   else
	   {
	   		s hasBooked="Y"
	   }
		
	}
	
	//判断第三方预约表
	if (hasBooked="N")
	{
		if (bodyRowid="")
		{
			s extRowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",orderItemRowid,""))
			if (extRowid'="")
		    {
			   s hasBooked="Y"
		    }
		}
		else
		{
			s bodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			if (bodyCode'="")
			{
				s extRowid=$o(^DHCRBCExternalBookInfoi("OrderBody",orderItemRowid,bodyCode,""))
			
				if (extRowid'="")
			    {
				   s hasBooked="Y"
			    }
			}
		}
	}
	

    q hasBooked
}

}
