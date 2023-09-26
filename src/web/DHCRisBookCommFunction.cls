Import SQLUser

Class web.DHCRisBookCommFunction Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 按检查号生成规则判断产生一个或多个检查号
/// 默认没有配置生成规则,按医嘱号生成一个检查号
/// w ##class(web.DHCRisBookCommFunction).GetMutiStudyNo("20017||3895@20017||3898","","83","2014-10-17","3")
ClassMethod GetMutiStudyNo(InOrditmGroup As %String, GroupDesc As %String = "", GetLocDR As %String, SelectDate As %String, GroupDR As %String) As %String
{
	s MutiCount=0
	s MutiCount=$l(InOrditmGroup,"@")
	s MutiStudyNo=""
	s IsExit="N",LastStudyNo=""

	for l=1:1:MutiCount 
    {
	   s StudyInfo="",gIsUpdate="",perOrditemID=""
	   s perOrditemID=$p(InOrditmGroup,"@",l)
	   s StudyInfo=##class(web.DHCRisPatRegisterDoEx).GetStudyNo(perOrditemID,GroupDesc,GetLocDR,SelectDate)
	   
	   i StudyInfo'="" d
	   .s StudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	   .s StudyNumber=$p($g(StudyInfo),"^",2)
       .s IsUpdate=$p($g(StudyInfo),"^",3)
	  
	   i IsExit="Y" s StudyNo=LastStudyNo
	   s IsMore=""
	   s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(GetLocDR,perOrditemID,GroupDesc)
	   
	   //多条医嘱产生多个检查号
	   i (IsMore="Y")&(IsUpdate="1") d
	   .s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	   e  d
	   .i (IsExit="N") d
	   ..s LastStudyNo=StudyNo  s IsExit="Y"
	   ..s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	  
	   i MutiStudyNo="" d
	   .s MutiStudyNo=StudyNo
	   e  d
	   .s MutiStudyNo=MutiStudyNo_"@"_StudyNo
	   
    }
    q MutiStudyNo
}

/// w ##class(web.DHCRisBookCommFunction).InitAutoBKedData("5037","58460||1782","63042")
ClassMethod InitAutoBKData(SchudleRowid As %String, orditmGroup, SelectDate As %String = "", InStudyNo As %String = "") As %String
{
	s (Infos,ResourcesInfo,GetEQDR,GetRoomDR,GroupDescDR,GetResDesc,GetRoomDesc,GroupDesc)=""
	s (IndexclsInfo,GetLocDR,Param,GetIndex,GetNoRuleCode,GetTypeDesc,GetAppDateType,GetTypeRowid)=""
	s (Index,GroupIndex,RoomIndex,paadmdr,IsCStudyNo,IsCIndex,StudyNo)=""
	s (StudyInfo,IsUpdate,StudyNumber)=""
	
	q:(SchudleRowid="") Infos
	q:(orditmGroup="") Infos
	s Fistoeorditemrowid=$p(orditmGroup,"@",1)
	
	i SelectDate="" s SelectDate=+$h
	s SelectDate=$zd(SelectDate,"3")
	
	s ResourcesInfo=##class(web.DHCRisResourceApptSchudleEx).SetSelResources(SchudleRowid)
	i ResourcesInfo'="" d
	.s GetEQDR=$p($g(ResourcesInfo),"^",1)
	.s GetRoomDR=$p($g(ResourcesInfo),"^",2)
	.s GroupDescDR=$p($g(ResourcesInfo),"^",3)
	.s GetResDesc=$p($g(ResourcesInfo),"^",4)
	.s GetRoomDesc=$p($g(ResourcesInfo),"^",5)
	.s GroupDesc=$p($g(ResourcesInfo),"^",6)
	.s GetLocDR=$p(^OEORD($p(Fistoeorditemrowid,"||",1),"I",$p(Fistoeorditemrowid,"||",2),3),"^",6)
	.s paadmdr=$p(^OEORD($p(Fistoeorditemrowid,"||",1)),"^",1)
	.s Param=GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_GetLocDR_"^"_Fistoeorditemrowid_"^"_SchudleRowid
	.s IsCIndex=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(GetLocDR)
	.i IsCIndex'="" s IsCIndex=$p(IsCIndex,"^",1)
	.s IsCStudyNo=##class(web.DHCRisResourceApptSchudleEx).IsCreateStudyNo(GetLocDR)
	.i InStudyNo="" d
	..i IsCIndex="B" d
	...s IndexclsInfo=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)
	...i IndexclsInfo'="" d
	....s GetIndex=$p(IndexclsInfo,"^",1)
	....s GetNoRuleCode=$p(IndexclsInfo,"^",2)
	....s GetTypeDesc=$p(IndexclsInfo,"^",3)
	....s GetAppDateType=$p(IndexclsInfo,"^",4)
	....s GetTypeRowid=$p(IndexclsInfo,"^",5)
	....i GetNoRuleCode="L" s Index=GetIndex
	....i GetNoRuleCode="Z" s GroupIndex=GetIndex
	....i GetNoRuleCode="R" s RoomIndex=GetIndex
	..;根据配置创建一个或多个检查号 
	..s StudyNo=..GetMutiStudyNo(orditmGroup,GroupDesc,GetLocDR,SelectDate,GroupDescDR)
	.e  d
	..s StudyNo=InStudyNo
	.s Infos=StudyNo_"^"_Index_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_paadmdr_"^"_GetTypeRowid_"^"_SelectDate
	q Infos
}

/// w ##class(web.DHCRisBookCommFunction).GetBookInfoInterface("20017||3880")
/// 函数名称:GetBookInfoInterface
/// 入参:医嘱ID
/// 返回值:OrditemRowid_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_TimeDesc_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_Memo
/// 返回值:医嘱ID_"^"_预约设备CODE_"^"_预约设备描述_"^"_预约日期_"^"_时段_"^"_"预约时间"_"接收科室"_"^"_预约人代码_"^"_预约人描述_"^"_注意事项
ClassMethod GetBookInfoInterface(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") ""
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid)=""
	s (MemoTMRowid,RecLocdr,RecLocDesc,UserID,UserCode,UserDesc,Memo,CancelFlag)=""
	
	s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
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
	
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	i ResDetailRowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",7) 
	
	i ((ResDetailRowid'="")&(CancelFlag'="Cancel"))
	{  
	   s UserID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",15)
	   i UserID'="" d
	   .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	   .s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
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
	   .s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	   .s TimeDesc=""
	   .i TimeDescCode'="" d
	   ..s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	   ..s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	   .s Info="" 
	   .s Info=OrditemRowid_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_TimeDesc_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_Memo
	   
	}
	
	q Info
}

/// 根据医嘱查询项目是否符合自动预约条件 Y/N
/// 入参:医嘱ID
/// 返回值:Y/N
/// w ##class(web.DHCRisBookCommFunction).IsAutoBooked("20017||56")
ClassMethod IsAutoBooked(OrditemRowid As %String) As %String
{
	s IsAB="N"
	s arcimid="",BPRowid="",AppointMethodId="",AppMethod="",AppLocDR="",RessourceID=""
	s ServerGroupDR=""
	s FindCount=0
	s OrderRowid=$p($g(OrditemRowid),"||",1)
	s itemsub=$p($g(OrditemRowid),"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s AppLocDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",3)
	s ServerGroupDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
	q:(ServerGroupDR="") IsAB
	i arcimid'="" s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
	i BPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
    i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
	i (AppMethod="自动预约")&(ServerGroupDR'="") s IsAB="Y"
	q IsAB
}

/// ///////////////////////////////////////////////最新程序///////////////////////////////////////////
/// 同病人,同接收科室,同预约方式医嘱在一起 
/// 入参:OrditemRowid=1@2@3@....
/// 返回值:OrditemRowid@OrditemRowid^OrditemRowid@OrditemRowid^........
/// sunyi 2012-01-16
/// w ##class(web.DHCRisBookCommFunction).SplitArrayGroup("20017||3874@20017||3877@20017||3878@20017||3898")
/// w ##class(web.DHCRisBookCommFunction).SplitArrayGroup("20017||3899@76304||6@20017||3900")
ClassMethod SplitArrayGroup(OrditemRowid) As %String
{
	s SameCount=0
	s SameCount=$l(OrditemRowid,"@")
	s SGroupRowid=""
	
	s SetInfo=""
	
	for Mi=1:1:SameCount 
    {
	    s arcimid="",IsAllow="Y",CurrentRowid="",paadmdr="",papatmasmdr=""
	    s CurrentRegNo="",CurrentRecLocdr=""
	    s perOrditemRowids=$p(OrditemRowid,"@",Mi)
	    s OrderRowid=$p(perOrditemRowids,"||",1)
	    s itemsub=$p(perOrditemRowids,"||",2)
	    s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	    i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	    i papatmasmdr'="" s CurrentRegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    s CurrentRecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	    i arcimid'=""
	    {
		   s BPRowid=""
		   s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		   s SubscriptID=$p(arcimid,"||",1)
		   s VersionID=$p(arcimid,"||",2)
		   ;s ServiceGroupId=$p($g(^ARCIM(SubscriptID,VersionID,8)),"^",7)

		   i (BPRowid="")
		   {
			   i $g(NoSetGroup("NOSET"))="" d
			   .s NoSetGroup("NOSET")="0-"_perOrditemRowids
			   e  d
			   .s NoSetGroup("NOSET")=NoSetGroup("NOSET")_"@"_perOrditemRowids
			   
		   }else
		   {
			   s AppMethod="不需预约",AppointMethodId="",AppMethodCode=""
			   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
               i AppointMethodId'="" d
               .s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
               .s AppMethodCode=..GetBookType(AppMethod)
               
               i ((CurrentRecLocdr'="")&(CurrentRegNo'="")&(BPRowid'="")&(AppMethodCode'=""))  d
			   .i $g(SameArray(CurrentRegNo,CurrentRecLocdr,AppMethodCode))="" d
			   ..s SameArray(CurrentRegNo,CurrentRecLocdr,AppMethodCode)=AppMethodCode_"-"_perOrditemRowids
			   .e  d
			   ..s SameArray(CurrentRegNo,CurrentRecLocdr,AppMethodCode)=SameArray(CurrentRegNo,CurrentRecLocdr,AppMethodCode)_"@"_perOrditemRowids
		       
		   }
		   
		}
    }
   
   
   s SameRowid="" f  s SameRowid=$o(SameArray(CurrentRegNo,CurrentRecLocdr,SameRowid)) q:(SameRowid="")  d
   .i SetInfo="" s SetInfo=SameArray(CurrentRegNo,CurrentRecLocdr,SameRowid)
   .e  d
   ..s SetInfo=SetInfo_"^"_SameArray(CurrentRegNo,CurrentRecLocdr,SameRowid)
   
   i (($g(NoSetGroup("NOSET"))'="")&(SetInfo'="") )
   {
	   s SetInfo=NoSetGroup("NOSET")_"^"_SetInfo
   }elseif(($g(NoSetGroup("NOSET"))'="")&(SetInfo="") )
   {
	   s SetInfo=NoSetGroup("NOSET")
   }    
   
   k SameArray
   k NoSetGroup
   
   q SetInfo
}

/// do ##class(web.DHCRisBookParam).web.DHCRisBookCommFunction("")
/// 返回值:1-"不需预约",2-"自动预约",3-"服务台预约"  
ClassMethod GetBookType(AppMethod) As %String
{
	s BK=""
	if (AppMethod="不需预约")!(AppMethod="无需预约")
	{
		s BK="1"
	}elseif (AppMethod="自动预约")
	{
		s BK="2"
	}else
	{
		s BK="3"
	} 
	q BK
}

/// w ##class(web.DHCRisBookParam).GetAppResParam("20017||3880","1383")
ClassMethod GetAppResParam(OEorditem As %String, RessourceID As %String) As %String
{
	q:(OEorditem="")
	s (OrderRowid,ItemRowid,paadmdr,AppLocDR,AppResSetRowid,ResPatCodeRowid)=""
	s ResAppFind=0,PatTypeFind=0            ;申请科室或病人类型是否设置资源
	s ResAppSetFind="N",PatTypeSetFind="N"  ;是设置了是否发现可用资源默认"N"
	
    s OrderRowid=$p(OEorditem,"||",1)
    s ItemRowid=$p(OEorditem,"||",2)
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i paadmdr'="" s patienttype=$p($g(^PAADM(paadmdr)),"^",2)  
    s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
    
    ;按申请科室查询可用资源
    s ResAppRowid=0  f  s ResAppRowid=$o(^DHCRBCResourceInAppLoc(ResAppRowid)) q:ResAppRowid=""  d 
    .q:(ResAppFind=1)
    .s GetAppLocDR=$p($g(^DHCRBCResourceInAppLoc(ResAppRowid)),"^",1)
    .i AppLocDR=GetAppLocDR s ResAppFind=1
    s ResAppRowid=""
    i ResAppFind=1 s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",AppLocDR,RessourceID,ResAppRowid))
    i ResAppRowid'="" s ResAppSetFind="Y"
    q:(ResAppFind=1)&(ResAppSetFind="N") "N"
    q:(ResAppSetFind="Y") "Y"
    
    ;按病人类型查询可用资源
    s ResCodeRowid=0 f  s ResCodeRowid=$o(^DHCRBCPatTypeUseResource(ResCodeRowid)) q:(ResCodeRowid="")  d
    .q:(PatTypeFind=1)
    .s GetPatType=$p($g(^DHCRBCPatTypeUseResource(ResCodeRowid)),"^",1)
    .i patienttype=GetPatType s PatTypeFind=1
    s ResCodeRowid=""
    i PatTypeFind=1 s ResCodeRowid=$o(^DHCRBCPatTypeUseResourcei("TYPECODE",patienttype,RessourceID,ResCodeRowid))
    i ResCodeRowid'="" s PatTypeSetFind="Y"
    q:(PatTypeFind=1)&(PatTypeSetFind="N") "N"
    q:(PatTypeSetFind="Y") "Y"
    
    q:(ResAppFind=0)&(PatTypeFind=0) "Y"
}

/// 是否是奥抗阳性病人
/// s ret=##class(web.DHCRisBookParam).GetAokangPatient("1567||30")
ClassMethod GetAokangPatient(OeOrdRowid As %String) As %String
{
	 s ret="N"
     s info=##class(web.DHCRisApplicationBill).GetAppItemInfo(OeOrdRowid)
     s len=$l(info,"^")
     for i=1:1:len d
     .s ItemInfo=$p(info,"^",i)
     .s Name=$p(ItemInfo,$c(2))
     .s Value=$p(ItemInfo,$c(2),2)
     .s ItemInfo=Name_Value
     .i ItemInfo="奥抗阳性" d
     ..s ret="Y"
     q ret
}

/// do ##class(web.DHCRisBookParam).GetAddress("632")
ClassMethod GetAddress(LocDR As %String) As %String
{
	q:(LocDR="") ""
	
	s (Location ,AppLocation,InputFee,Rowid)=""
	s (Info)=""
	
	s Rowid=$o(^DHCRBCLocationi("Rec-LocDR",LocDR,0))
	i Rowid'="" d
	.s Location=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",2)
    .s AppLocation=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",3)
    .s InputFee=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",4)
    .s Info=Location_"^"_AppLocation_"^"_InputFee
    
    q Info
}

ClassMethod GetEqAddress(resourceId As %String) As %String
{
	s RoomID="",RoomDesc=""
	s EqRowid=$p($g(^RB("RES",resourceId)),"^",3)
	i (EqRowid'="")
	{
		s RoomID=$o(^DHCRBC("EQDR-ROOM",EqRowid,RoomID))
		i RoomID'="" d
		.s RoomDesc= $p($g(^DHCRBC("Room",RoomID)),"^",2)
	}
	
	q RoomDesc
}

ClassMethod GetAppMemo(ArcItemRowid As %String) As %String
{
	s Memo="",DMRowid="",UMCode=""
	s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemRowid,0))
	i DMRowid'="" d
	.s MTRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",4)
	.q:(MTRowid="")
	.s UMRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",5)
	.i (UMRowid'="") d
	..s UMCode=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",1)
	..i UMCode="NP" d
	...s Memo="到综合服务台拿检查须知"
	..e  d
	...i MTRowid'="" s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	q Memo
}

/// 函数：GetEmpty
/// 功能：判断是否空腹
/// 参数：医嘱ROWID 
/// 返回：Y/N
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetEmpty(OrditemRowid) As %String
{
	s Empty="N"
	s AppRowid=$o(^DHCRBAppOrdi(0,OrditemRowid,0))
	i AppRowid'="" d
	.s ItemInfo=^DHCRBApp("Bill",AppRowid,"ItemInfo")
	.s count=$l(ItemInfo,"^")
	.for i=1:count:1 d
	..s pItemInfo=$p(ItemInfo,"^",i)
	..s ItemName=$p(pItemInfo,$c(2),1)  
	..s ItemResult=$p(pItemInfo,$c(2),2)
	..i (ItemName="空腹")!(ItemName="是否空腹")  d
	...i ItemResult="是"  s Empty="Y"
	q Empty
}

/// 函数：AutoBooked 
/// 功能：自动预约，返回预约日期、时间以及注意事项(如果按医嘱时间来预约只能传入一条记录)
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）,UserID用户ID
/// 返回：(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点^OrditemRowid@OrditemRowid)&.... flag-0:自动预约失败，1 自动预约成功  
/// 作者：gongping 
/// 日期：2011-08-22 
/// s ret=##class(web.DHCRisBookCommFunction).AutoBooked("1567||30",+$h,$p($h,",",2),"","")
/// s ret=##class(web.DHCRisBookCommFunction).AutoBooked("20017||3899@77006||1","63405","35919","","687","","")
/// s ret=##class(web.DHCRisBookCommFunction).AutoBooked("20017||3899@76304||6@20017||3900","63405","51462","","687","","")
ClassMethod AutoBooked(OrditemRowid As %String, ChargeDate As %Integer, ChargeTime As %Integer, OherParam As %String = "", UserRowid As %String = "", GetEqDR As %String = "", InStudyNo As %String = "", InEndTime As %String = "") As %String
{

    i UserRowid="" s UserRowid="71"
    s ItemGroup="",GetInfo=""
    s ItemGroup=..SplitArrayGroup(OrditemRowid) ;
    i ChargeTime="" s ChargeTime=$p($h,",",2)
    ;w !,"ItemGroup="_ItemGroup
    q:(ItemGroup="") "NoParam"
    s Itmcount=0
    s Itmcount=$l(ItemGroup,"^")
    s ^tt("001")=InEndTime
    ;w !,"Itmcount="_Itmcount
    for lk=1:1:Itmcount 
    {  
         ;w !,"k="_k
	     s perItmGroup=$p(ItemGroup,"^",lk)
	     ;w !,"perItmGroup="_perItmGroup
	     s pertItmGroupCount=0
	     s pertItmGroupCount=$l(perItmGroup,"@")
	     ;w !,"pertItmGroupCount="_pertItmGroupCount
	     i (perItmGroup'="")
	     {
		     i (pertItmGroupCount'=0)
		     {
			     ;w !,"perItmGroup="_perItmGroup
			     s Request=""
			     s Request=..RequestAutoBooked(perItmGroup,ChargeDate,ChargeTime,OherParam,GetEqDR,InStudyNo,UserRowid,InEndTime)
			     ;w !,"Request="_Request
			     if (Request'="")
			     {
				     i GetInfo="" s GetInfo=Request
				     e  d
				     .s GetInfo=GetInfo_"&"_Request
			     }
			 }
	     }
    }
    q GetInfo
}

/// 函数：RequestAutoBooked 
/// 功能：自动预约，返回预约日期、时间以及注意事项 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）,GetEqDR 设备ID, InStudyNo 第三方传入的检查号
/// 返回：(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点^OrditemRowid@OrditemRowid) flag-0:自动预约失败，1 自动预约成功   
/// BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
/// 日期：2011-08-22 
/// s ret=##class(web.DHCRisBookCommFunction).RequestAutoBooked("20017||3899@20017||3900","63405","35919","","687")
ClassMethod RequestAutoBooked(OrditemRowidGroup As %String, ChargeDate As %Integer, ChargeTime As %Integer, OherParam As %String = "", GetEqDR As %String = "", InStudyNo As %String = "", UserRowid As %String, InEndTime As %String = "") As %String
{
   n (OrditemRowidGroup,ChargeDate,ChargeTime,OherParam,UserRowid,GetEqDR,InEndTime,InStudyNo)
   s ^tt("0002")=OrditemRowidGroup_"^"_ChargeDate_"^"_ChargeTime_"^"_OherParam_"^"_GetEqDR_"^"_InStudyNo_"^"_UserRowid_"^"_InEndTime
   s ResInfo="",Info="",AddressInfo=""
   s BookedFlag=0
   s (ServiceName,GetResCode,GetResDesc,ArriveDate,ArriveTime,BookedNote,RecLocName)=""
   s (Paadmdr,PatType)=""
   s (AppMemo,rets,Location,AppLocation,InputFee,EQLocation,DetailRowid)=""
   s Desc="就诊",AutoInputFee="",EndInputFee="",hasBooked="",Param=""
   s (StudyNumber,IsUpdate,GroupDR,Upret,CAFlag,BKStudyNo,MethodCode)=""
   s GroupLen=0

   s ^DHCCTmp("RIS-001")=OrditemRowidGroup_"^"_ChargeDate_"^"_ChargeTime_"^"_OherParam_"^"_UserRowid_"^"_GetEqDR 
   s GetperOrditemRowid=""
   //0-没有配置 1-不需预约 2-自动预约 3-服务台预约
   s MethodCode=$p(OrditemRowidGroup,"-",1)
   s OrditemRowidGroup=$p(OrditemRowidGroup,"-",2)
   s GetperOrditemRowid=$p(OrditemRowidGroup,"@",1)
   
   s GroupLen=$l(OrditemRowidGroup,"@")
   s OrderRowid=$p(GetperOrditemRowid,"||",1)
   s ItemRowid=$p(GetperOrditemRowid,"||",2)
   s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
   i Paadmdr'="" s PatType=$p($g(^PAADM(Paadmdr)),"^",2)
   s RecLocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)       ; 执行科室
   i RecLocId'="" d 
   .s RecLocName=$p(^CTLOC(RecLocId),"^",2)
   .i $l(RecLocName,"-")>1 s RecLocName=$p(RecLocName,"-",2)
   .s AddressInfo=..GetAddress(RecLocId)
   .i AddressInfo'="" d
   ..s Location=$p(AddressInfo,"^",1)   ; 科室的物理位置
   ..s AppLocation=$p(AddressInfo,"^",2)  ;预约位置
   ..s InputFee=$p(AddressInfo,"^",3)   ;划价位置
   s ItemMastRowid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
   s AutoInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",25) ;"需要另划价标志"
   s EndInputFee=$P($g(^OEORD(OrderRowid,"I",ItemRowid,"DHC")),"^",26)  ;"已另划价标识"
   i (PatType="O")&(((AutoInputFee="Y")&((EndInputFee="")!(EndInputFee="N"))))
   {
	   s Desc="划价"   
   }
   
   s bookUseType="1"
   s locParamDr="",examTime=""
   ;根据科室rowid查询预约方式 1 为最大数 2为检查时间
   s locParamDr=$o(^DHCRBC("Loc",RecLocId,locParamDr))
   i locParamDr'="" s bookUseType=$p(^DHCRBC("LocParam",locParamDr),"^",23)
   q:(GroupLen>=2)&(bookUseType="2") "^0^^^^^按检查时间预约只能传入一条医嘱$$^^^^"_OrditemRowidGroup
   s Subscript=$p(ItemMastRowid,"||",1)
   s Version=$p(ItemMastRowid,"||",2)
   s AppMemo=..GetAppMemo(ItemMastRowid)  ;N-提示到服务台打须知 
   
   q:(MethodCode="0") "^0^^^^^系统没有设置预约信息,请联系信息中心$$^^^^"_OrditemRowidGroup
   i (MethodCode="1") d
   .s Info="3^1^^^^^请您立即到"_RecLocName_"做检查。$"_Location_"$"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation_"^"_OrditemRowidGroup
   q:(MethodCode="1") Info
   
   b //0001
   
   ////////////////////////////////////////修改 /////////////////////////////////////////////
   if (MethodCode="2")
   {
	   ;入参:同病人科室预约类型医嘱组 用"@"分割
	   ;返回值:4-20017||3874^7@8-20017||3877@20017||3898
	   
	   s SameGroupArrayCount=0
	   s SameGroupArray=""
	   s SameGroupArray=..SameServiceGroup(OrditemRowidGroup)
	   ;w !,"SameGroupArray="_SameGroupArray
	   
	   s SameGroupArrayCount=$l(SameGroupArray,"^")
	
	   for lr=1:1:SameGroupArrayCount
	   {
		   s perService="",ServiceName="",perSameSerOrditemRowid=""
		   s perFristOrditemRowid=""
		   s perService=$p($g(SameGroupArray),"^",lr)
		   s ServiceGroupId=$p($g(perService),"-",1)
		   s perSameSerOrditemRowid=$p($g(perService),"-",2)
		   s perFristOrditemRowid=$p($g(perSameSerOrditemRowid),"@",1)
		   ;是否空腹
		   s isEmpty="N"
		   for kkk=1:1:$l($g(perSameSerOrditemRowid),"@")
		   {
			  q:(isEmpty="Y")
		      s orderItemIsbook=$p($g(perSameSerOrditemRowid),"@",kkk)
		      if (orderItemIsbook="")
		      {
			      continue
		      }
		      s arcItemDr=$p(^OEORD($p(orderItemIsbook,"||",1),"I",$p(orderItemIsbook,"||",2),1),"^",2)
		      if ( arcItemDr="")
		      {
			      continue
		      }
		      s itembookPropertydr=""
		      s itembookPropertydr=$o(^DHCRBCItemBookProperTypei(arcItemDr,itembookPropertydr))
		      if (itembookPropertydr="")
		      {
			      continue
		      }
		      if ( $p($g(^DHCRBCItemBookProperty(itembookPropertydr)),"^",4)="Y")
		      {
			      s isEmpty="Y"
		      }
		   }
		   i ServiceGroupId'="" d
		   .s ServiceName=##class(web.DHCRisCommFunctionEx).GetServicebySerID(ServiceGroupId)
		   .i ServiceName["CTA组"   d 
		   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,"",RecLocId,perFristOrditemRowid,$g(GetEqDR),ServiceName,InEndTime)   //返回可预约信息
		   .else  if (ServiceName["CTB组")  d
		   ..s ret=..GetEmpty(OrditemRowid)
		   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,ret,RecLocId,perFristOrditemRowid,$g(GetEqDR),ServiceName,InEndTime)   //返回可预约信息
		   .else  d
		   ..; 其他的需要自动预约的项目
		   ..s ResInfo=..GetUseResPan(ChargeDate,ChargeTime,ServiceGroupId,isEmpty,RecLocId,perFristOrditemRowid,$g(GetEqDR),bookUseType,ServiceName,InEndTime)   //返回可预约信息
	       ;w !,"ResInfo="_ResInfo
	       ///////////////////////////////////////////////////////////////////////////////
		   i ResInfo'="" d
		   .; 插入预约表 
		   .s SchRowid=$p(ResInfo,"^",1)
		   .s ArriveDate=$p(ResInfo,"^",2)
		   .s strArriveDate=$zd(ArriveDate,3)
		   .s ArriveTime=$p(ResInfo,"^",3)
		   .s strArriveTime=$zt(ArriveTime,1)
		   .s BookeInfo=perSameSerOrditemRowid_"^"_SchRowid_"^2^"_OherParam_"^"_RecLocId_"^"_Paadmdr_"^"_strArriveDate_"^"_UserRowid_"^"_$g(InStudyNo)
		   .i BookeInfo'="" d
		   ..s SQLCODEInfo=##class(web.DHCRisResourceApptSchudle).InsertBookedInfo(BookeInfo)
		   ..s SQLCODE=$p(SQLCODEInfo,"^",1)
		   .i SQLCODE=0  D
		   ..i bookUseType="2" d  ;按检查时间预约需要查询出开始时间
		   ...s scheduleDetailDr=""
		   ...s scheduleDetailDr=$o(^DHCRBCResSchduleDetaili(0,perFristOrditemRowid,scheduleDetailDr))
		   ...i scheduleDetailDr'="" d
		   ....s strArriveTime=$zt($p(^DHCRBCResSchduleDetail("Detail",scheduleDetailDr),"^",18),1)
		   ..s resourceId=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
		   ..i resourceId'="" d
		   ...s EQLocation=..GetEqAddress(resourceId)
		   ...s BookedFlag=1
		   ...s CTCPDR=$p($g(^RB("RES",resourceId)),"^",2)
		   ...s CTCPDR=$p(CTCPDR,$c(0))
		   ...i CTCPDR'="" d
		   ....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",1)
		   ....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
		   ...else  d
		   ....s EQDR=$p($g(^RB("RES",resourceId)),"^",3)
		   ....s GetResCode=$p($g(^RBC("EQ",EQDR)),"^",1)
		   ....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
		   ..s BookedNote=..GetBookNote(ArriveDate,strArriveTime,ServiceName,ItemMastRowid, RecLocName,ChargeDate,strArriveDate,RecLocId,Desc)
		   ..s Info="1"_"^"_BookedFlag_"^"_GetResCode_"^"_GetResDesc_"^"_strArriveDate_"^"_strArriveTime_"^"_BookedNote_"^"_AppMemo_"^"_InputFee_"^"_EQLocation_"^"_perSameSerOrditemRowid
		   .else  d
		   ..s Info="1^0^^^^^请您到"_RecLocName_Desc_"。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation_"^"_perSameSerOrditemRowid
		   else  d
		   .s Info="1^0^^^^^请您到"_RecLocName_"服务台预约_。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation_"^"_perSameSerOrditemRowid
		   
	   }
	   
  }
  else
  {
	   if Desc'="划价" s Desc="预约"
	  ; 其他的预约方式 都是通过服务台预约的方式
	  s Info="2^1^^^^^请您到"_RecLocName_Desc_"。$"_AppLocation_" $"_Location_"^"_AppMemo_"^"_InputFee_"^"_EQLocation_"^"_OrditemRowidGroup
  }
  
  q Info
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPan(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, Empty As %String, LocId As %String, OeorditemRowid As %String = "", GetEqDR As %String = "", bookUseType As %String = "1", GetServiceName As %String = "", InEndTime As %String = "") As %String
{
	s ^tt("003")=InEndTime	
	s bFind=0
	s Day=ChargeDate
	s UseResInfo=""
	s ServiceName=""
	
	i ServiceGroupId'="" s ServiceName=GetServiceName
    .;s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
    .;w !,ServiceName
    
    i (Empty'="Y")&(ServiceName["CTB组") d            ; 未空腹的CTB组第二天进行预约
    .s Day=Day+1  
   
	//查找可使用的预约资源
	while(bFind<1)
	{	
	    ;w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
		s UseResInfo=..GetDayUseBookInfo(Day,ChargeDate,ChargeTime,ServiceGroupId,LocId,OeorditemRowid,GetEqDR,bookUseType,InEndTime,Empty)
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
/// w ##class(web.DHCRisBookCommFunction).GetDayUseBookInfo("63566","63566","46184","6@7@8@9","83","20017||3895","","1")
ClassMethod GetDayUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "", GetEqDR As %String = "", bookUseType As %String = "1", InEndTime As %String = "", isEmpty As %String = "") As %String
{
	s LastRatio=1.0
	s SelSchuldRowid=0	
	s Info="",ServiceName="",LastInfo="" 
	s CurrentTime=$p($h,",",2)
	s CurrentDate=+$h
	s FindServiceCount=0
	s FindServiceCount=$l(ServiceGroupId,"@")

	// 是否是奥抗病人
	s IsAK=..GetAokangPatient(OEorditem)    
	s paadmID="",PType=""
	s paadmID=$p($g(^OEORD($p(OEorditem,"||",1))),"^",1)
    i paadmID'="" s PType=$p($g(^PAADM(paadmID)),"^",2)  

    ; 按时间段索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
    s TPRowid=0 f  s TPRowid=$o(^DHCRBCTimePeriodSet(TPRowid)) q:TPRowid=""  d
    .s TimeDuration=$p(^DHCRBCTimePeriodSet(TPRowid),"^",1)
    .q:(LastInfo'="")
    .f lh=1:1:FindServiceCount d
    ..s perServiceGroupId=$p(ServiceGroupId,"@",lh)
    ..s perServiceName=$p($g(^RBC("SG",perServiceGroupId)),"^",2)
    ..s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Date-Time-Res",LocId,Day,perServiceGroupId,TimeDuration,SchRowid)) q:SchRowid=""  d
    ...;q:(Info'="")
    ...s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1) 
    ...q:(RessourceID="")
    ...s ResPlanId=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",12)
    ...q:(ResPlanId="")
    ...s NotAllowIPBooked=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",13)
    ...s AvailPatType=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",14)
    ...q:(AvailPatType'="")&(AvailPatType'[PType) ;新增病人类型可使用资源段判断
    ...q:(PType'="")&(PType="I")&(NotAllowIPBooked="Y") ;此处判断青医附院在用
    ...s BK=""
    ...s BK=..GetAppResParam(OEorditem,RessourceID)
    ...q:(BK="N")
	...q:(GetEqDR'="")&(GetEqDR'=RessourceID)
	...s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	...s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	...;q:((isEmpty="Y")&&(EndTime>43200))   ;空腹必须预约到上午
	...q:((Day=CurrentDate)&(EndTime<CurrentTime))   ;当天需要判断当前时间
	...q:(InEndTime'="")&(EndTime'=InEndTime) ;对于结束时间的判断
	...i bookUseType="2" d  ;检查时间预约
	....s remainTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",18)
	....i remainTime>0 d
	.....s Info=SchRowid_"^"_Day_"^"_StartTime
	...e  d   ;最大数预约
 	....s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
	....i AutoUseNumber="" s AutoUseNumber=0
	....s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
	....q:(AutoNumber="0")
	....s UseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",9)  ;总的预约使用数量
	....i UseNumber="" s UseNumber=0 
	....s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	....s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	....q:(MaxNumber=0)!(MaxNumber="")
	....i (RemainNum="")!(RemainNum=0) s RemainNum=MaxNumber
	....s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	....i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	....s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
	....i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
	....s CurrentRatio=$fn(UseNumber/MaxNumber,"",3) ;占用比率=已使用数/最大预约数
	....;w !,"CurrentRatio="_CurrentRatio
	....s MaxRemainNumber=0
	....i (Day=InChargeDate)&(perServiceName="CTA组")  d           ; 当天预约情况，判断缴费时间点，如果是下一天则不用判断
    .....i (InChargeTime<StartTime)&(AutoRemainNum>0)  d
	......s Info=SchRowid_"^"_Day_"^"_StartTime
	.....i (InChargeTime<ChargeTime)&(AutoRemainNum>0) d
	......s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	....else  i (Day=InChargeDate)&(perServiceName="CTB组")  d 
	.....i (InChargeTime<ChargeTime)&(AutoRemainNum>0) d 
	......s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	....else  d
	.....i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>0)) d 
	......s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	....if (Day>=InChargeDate)&(IsAK'="Y")  d
	.....i (AutoRemainNum>0) d    ; 下一个工作日的预约，只考虑限额
	......s Info=SchRowid_"^"_Day_"^"_StartTime
	....else  if (Day>=InChargeDate)&(IsAK="Y") d
	.....i (AutoRemainNum>0)  d
	......s Info=SchRowid_"^"_Day_"^"_StartTime  //EndTime
    ....if (Info'="")&(CurrentRatio<=LastRatio) d
	.....s LastRatio=CurrentRatio
	.....s LastInfo=Info
	q LastInfo
}

ClassMethod GetBookNote(ArriveDate As %String, ArriveTime As %String, ServiceName As %String, ItemMastRowid As %String, RecLocName As %String, ChargeDate As %String, strArriveDate As %String, RecLocId As %String = "", Desc As %String = "") As %String
{

   s Info="",Address="",AppLocation=""
   s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
   s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
   s FsDesc="等候报到"
   
   i (Desc'="划价") s Desc=FsDesc
   i RecLocId'="" d
   .s Address=..GetAddress(RecLocId)
   .i Address'="" d
   ..s Location=$p(Address,"^",1)   ; 科室的物理位置
   ..s AppLocation=$p(Address,"^",2)  ;预约位置
   ..s InputFee=$p(Address,"^",3)   ;划价位置 
   
   if ServiceName="CTB组" d
    .i (ChargeDate=ArriveDate) d
    ..s Info="请您空腹今天"_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
    .else  d
    ..s Info="请您需要空腹(或者至少空腹四小时),并于"_strArriveDate_" "_ArriveTime_"到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
   else  d
     .i (ChargeDate=ArriveDate) d
     ..s Info="请您今天"_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
     .else  d 
     ..s Info="请您"_strArriveDate_" "_ArriveTime_",到"_RecLocName_Desc_"."_"$"_AppLocation_"$"_Location
  	q Info
}

/// 对于同病人自(动预约项目)按相同服务组交集分组 
/// 入参:(自动预约)的 OrditemRowid=1@2@3@....
/// 返回值:OrditemRowid@OrditemRowid-ServiceGroupID@ServiceGroupID^...
/// sunyi 2012-01-16
/// w ##class(web.DHCRisBookCommFunction).SameServiceGroup("20017||3874@20017||3877@20017||3898")
/// w ##class(web.DHCRisBookCommFunction).SameServiceGroup("20017||3893@20017||3895@20017||3870")
/// w ##class(web.DHCRisBookCommFunction).SameServiceGroup("20017||3874@20017||3877@20017||3898")
ClassMethod SameServiceGroup(SameBkOrditemRowid) As %String
{
	s BookCount=0
	s BookCount=$l(SameBkOrditemRowid,"@")
	
	s SameSerInfo=""
	s LastIntersect=""
	s FristOeItemID=""
	s LastGroups=""
	s FristGroup=""
    
	
	for ls=1:1:BookCount
    {
	    s itemsub="",OrderRowid="",ArcItemID="",GroupID=""
	    s perOrditemID=$p(SameBkOrditemRowid,"@",ls)
	    s OrderRowid=$p(perOrditemID,"||",1)
	    s itemsub=$p(perOrditemID,"||",2)
	    s ArcItemID=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    q:(ArcItemID="")
	    s GroupID=##class(web.DHCRisCommFunctionEx).GetServiceGroup(ArcItemID)
	    ;w !,"GroupID="_GroupID
	    s GroupID=$p($g(GroupID),"^",1)
	    s GroupID=..Replace(GroupID,",","@") 
	    if (GroupID="")
	    {
		    continue
	    }
	 
		
		s LastIntersect=..Intersection(LastGroups,GroupID)
		i (LastIntersect'="")
		{
			;w !,"第"_s_"次"
		    ;w !,"GroupIDB="_GroupID_"LastGroupsB="_LastGroups
		    ;w !,"LastIntersectB="_LastIntersect
		    ;w !,"perOrditemIDB="_perOrditemID
		    ;w !,"------------I-------------"
		    ;w !,""
		    k SameIntersect(LastGroups)
		    s perOrditemID=LastOeItemID_"@"_perOrditemID
		    
			i $g(SameIntersect(LastIntersect))="" d
            .s SameIntersect(LastIntersect)=LastIntersect_"-"_perOrditemID
            e  d
            .s SameIntersect(LastIntersect)=SameIntersect(LastIntersect)_"@"_perOrditemID
			s GroupID=LastIntersect
			
	    }else
	    {
		    ;w !,"第"_s_"次"
		    ;w !,"GroupIDA="_GroupID_"LastGroupsA="_LastGroups
		    ;w !,"LastIntersectA="_LastIntersect
		    ;w !,"perOrditemIDA="_perOrditemID
		    ;w !,"------------NUL-------------"
		    ;w !,""
		    i $g(SameIntersect(GroupID))="" d
            .s SameIntersect(GroupID)=GroupID_"-"_perOrditemID
            e  d
            .s SameIntersect(GroupID)=SameIntersect(GroupID)_"@"_perOrditemID
            
           s LastIntersect=GroupID
			
		}
			
	    s LastOeItemID=perOrditemID
	    s LastGroups=GroupID
	}
	
	s Rowid=0 f  s Rowid=$o(SameIntersect(Rowid)) q:(Rowid="")  d
	.i SameSerInfo="" d
	..s SameSerInfo=SameIntersect(Rowid)
	.e  d
	..s SameSerInfo=SameSerInfo_"^"_SameIntersect(Rowid)
	.;w !,"SameIntersect="_SameIntersect(Rowid)
	k SameIntersect
	
	q SameSerInfo
}

/// w ##class(web.DHCRisBookCommFunction).Intersection("2@3@4@6@7","4@6@32@1")
/// w ##class(web.DHCRisBookCommFunction).Intersection("6@7@8","7@8")
/// 求元素交集
ClassMethod Intersection(LastGroup, CurrentGroup) As %String
{
	s LastGroupLen=0,CurrentGroupLen=0
	s LastGroupLen=$l(LastGroup,"@")
	s CurrentGroupLen=$l(CurrentGroup,"@")
	s IntersectInfo=""
	
	q:(LastGroup=CurrentGroup) CurrentGroup
	
	for n=1:1:LastGroupLen
	{
		s perLastGroup=""
		s perLastGroup=$p(LastGroup,"@",n)
		for m=1:1:CurrentGroupLen
		{
			s perCurrentGroup=$p(CurrentGroup,"@",m)
			i perLastGroup=perCurrentGroup  d
			.i IntersectInfo="" d
			..s IntersectInfo=perLastGroup
			.e  d
			..s IntersectInfo=IntersectInfo_"@"_perCurrentGroup
		}	
	}
	
	q IntersectInfo
}

/// w ##class(web.DHCRisBookCommFunction).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	   
	   return Replace(Strings,Str,Rep)
}

/// w ##class(web.DHCRisBookCommFunction).Test()
ClassMethod Test() As %String
{
	s a="1,2,3,4"
	s b="3"
	
	i a[b d
	.b //001
	
	q 0
}

/// "1:20^1:30^2:50^4:60"
/// do ##class(web.DHCRisBookCommFunction).GetData("1:20^1:30^2:50^4:60")
ClassMethod GetData(Info As %String) As %String
{
	s DataCount=0
	s DataCount=$l(Info,"^")
	
	for i=1:1:DataCount
	{
		s perData=$p(Info,"^",i)
		q:(perData="")
		s perBodyDR="", perMuscleDR=""
		s perBodyDR=$p(perData,":",1)
		q:(perBodyDR="")
		s perMuscleDR=$p(perData,":",2)
		
	    i $g(SameBodyPartDR(perBodyDR))="" d
        .s SameBodyPartDR(perBodyDR)=perBodyDR_":"_perMuscleDR
        e  d
        .s SameBodyPartDR(perBodyDR)=SameBodyPartDR(perBodyDR)_"、"_perMuscleDR
	}
	
	s SameInfo=""
	s Rowid=0 f  s Rowid=$o(SameBodyPartDR(Rowid)) q:(Rowid="")  d
	.i SameInfo="" d
	..s SameInfo=SameBodyPartDR(Rowid)
	.e  d
	..s SameInfo=SameInfo_$c(10,13)_SameBodyPartDR(Rowid)

	k SameBodyPartDR
	
	q SameInfo
}

// w ##class(web.DHCRisBookCommFunction).getPatType("20017||56")

ClassMethod getPatType(OrditemRowid As %String) As %String
{
	s ^DHCRis("getPatType")=OrditemRowid
	s patType=""
	s OrderRowid=$p($g(OrditemRowid),"||",1)
	s itemsub=$p($g(OrditemRowid),"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	s patType=$p(^PAADM(paadmdr),"^",2)
	q patType
}

/// w ##class(web.DHCRisBookCommFunction).getHospitalDr("20017||56")
ClassMethod HospitalDr(OrditemRowid As %String) As %String
{
	;s ^DHCRis("HospitalDr")=OrditemRowid
	s patType=""
	s OrderRowid=$p($g(OrditemRowid),"||",1)
	s itemsub=$p($g(OrditemRowid),"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
    s Locdr=$p(^PAADM(paadmdr),"^",4)
  	s HospitalDr=$p($g(^CTLOC(Locdr)),"^",22)
  	q HospitalDr
}

}
