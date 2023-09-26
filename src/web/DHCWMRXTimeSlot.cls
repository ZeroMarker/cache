Import SQLUser

Class web.DHCWMRXTimeSlot Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 225;

/// 获取两操作项时间跨度信息
/// 条件：病案类型，前操作项，后操作项，起始日期（出院日期），截止日期，时间跨度，比较类型符号（大于，小于，等于）
/// 结果：JIndex^出院数量^卷数量^符合条件数量^平均时间跨度
ClassMethod GetTimeSlotByTowItem(Condition)
{
	n (Condition)
	
	Set ^CacheTemp($zn,$j)=Condition
	
	s ret=""
	q:Condition="" ret
	s MrType=+$p(Condition,"^",1)
	
	s FirstItem=+$p(Condition,"^",2)
	q:FirstItem=0 ret
	s Item=$g(^DHCWMRWITM(FirstItem))
	s ItemType=+$p(Item,"^",1)
	q:ItemType'=3 ret      //3表示顺序项目
	
	s SecondItem=+$p(Condition,"^",3)
	q:SecondItem=0 ret
	s Item=$g(^DHCWMRWITM(SecondItem))
	s ItemType=+$p(Item,"^",1)
	q:ItemType'=3 ret      //3表示顺序项目
	
	s FromDate=$p(Condition,"^",4)
	s:FromDate["/" FromDate=$zdh(FromDate,4)   //30/05/2007
	s:FromDate["-" FromDate=$zdh(FromDate,3)   //2007-05-30
	s ToDate=$p(Condition,"^",5)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	q:((FromDate="")||(ToDate="")) ret
	s TimeSlot=+$p(Condition,"^",6)   //天
	s Note=$p(Condition,"^",7)        //">","<","="
	
	k ^CacheTemp("TowItemTimeSlot",$j)
	f Date=FromDate:1:ToDate d
	.q:'$d(^PAADMi("DischDate",Date))
	.s ADMId=0
	.f  s ADMId=$o(^PAADMi("DischDate",Date,ADMId)) q:ADMId=""  d
	..q:'$d(^PAADM(ADMId))
	..//出院数量
	..s ^CacheTemp("TowItemTimeSlot",$j,"DischargeCount")=+$g(^CacheTemp("TowItemTimeSlot",$j,"DischargeCount"))+1
	..s VolId=$o(^DHCWMRVOL(0,"VolAdm",ADMId,0))
	..q:VolId=""
	..q:'$d(^DHCWMRVOL(VolId))
	..s VolInfo=$g(^DHCWMRVOL(VolId))
	..s VolActiveFlg=$p(VolInfo,"^",7)
	..q:(VolActiveFlg'="Y")     //病案卷无效退出
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s MainId=$p(VolumeInfo,"^",2)
	..s MainInfo=$g(^DHCWMRMAIN(MainId))
	..s MainType=$p(MainInfo,"^",1)          //病案类型
	..q:((MrType'=0)&&(MainType'=MrType))    //病案类型不符,退出
	..//病案卷数量
	..s ^CacheTemp("TowItemTimeSlot",$j,"VolumeCount")=+$g(^CacheTemp("TowItemTimeSlot",$j,"VolumeCount"))+1
	..s FChildId=$o(^DHCWMRVOL(VolId,"S",0,"Status",FirstItem,0))
	..q:FChildId=""
	..q:'$d(^DHCWMRVOL(VolId,"S",FChildId))
	..s FVolStatus=$g(^DHCWMRVOL(VolId,"S",FChildId))
	..s FCurrDate=$p(FVolStatus,"^",3)
	..s FCurrTime=$p(FVolStatus,"^",4)
	..s SChildId=$o(^DHCWMRVOL(VolId,"S",0,"Status",SecondItem,0))
	..i SChildId'="" d
	...s SVolStatus=$g(^DHCWMRVOL(VolId,"S",SChildId))
	...s SCurrDate=$p(SVolStatus,"^",3)
	...s SCurrTime=$p(SVolStatus,"^",4)
	..e  d
	...s SVolStatus=""
	...s SCurrDate=$p($h,",",1)
	...s SCurrTime=$p($h,",",2)
	..//计算时间跨度
	..s Seconds=..AccountTimeSlot(FCurrDate,FCurrTime,SCurrDate,SCurrTime)
	..q:Seconds=""
	..//判断是否在指定时间范围内
	..s FormatTimeSlot=..FormatTimeSlot(Seconds)
	..s Days=+FormatTimeSlot
	..q:((Note="<")&&((Days>TimeSlot)||(Days=TimeSlot)))
	..q:((Note=">")&&((Days<TimeSlot)||(Days=TimeSlot)))
	..q:((Note="=")&&(Days'=TimeSlot))
	..//符合条件数量
	..s ^CacheTemp("TowItemTimeSlot",$j,"AccordCount")=+$g(^CacheTemp("TowItemTimeSlot",$j,"AccordCount"))+1
	..//时间跨度总和
	..s ^CacheTemp("TowItemTimeSlot",$j,"SecondsSun")=+$g(^CacheTemp("TowItemTimeSlot",$j,"SecondsSun"))+Seconds
	..//取查询列表信息
	..s PatBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)  //病人基本信息
	..s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)               //病案信息
	..s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)                 //病案卷信息
	..s ADMInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(ADMId)                //取就诊信息
	..s:FChildId'="" FVolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,FChildId)
	..s:SChildId'="" SVolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,SChildId)
	..s Info=FormatTimeSlot_$c(2)_PatBaseInfo_$c(2)_MainInfo_$c(2)_VolInfo_$c(2)_ADMInfo_$c(2)_FVolStatus_$c(2)_SVolStatus
	..s ^CacheTemp("TowItemTimeSlot",$j,"Seconds",VolId)=Info
	s DischargeCount=+$g(^CacheTemp("TowItemTimeSlot",$j,"DischargeCount"))
	s VolumeCount=+$g(^CacheTemp("TowItemTimeSlot",$j,"VolumeCount"))
	s AccordCount=+$g(^CacheTemp("TowItemTimeSlot",$j,"AccordCount"))
	s:AccordCount'=0 AveTimeSlot=+$g(^CacheTemp("TowItemTimeSlot",$j,"SecondsSun"))\AccordCount
	s:AccordCount=0 AveTimeSlot=0
	s AveTimeSlot=..FormatTimeSlot(AveTimeSlot)
	//出院数量  卷数量  符合条件卷数量  平均时间跨度
	s ret=$j_"^"_DischargeCount_"^"_VolumeCount_"^"_AccordCount_"^"_AveTimeSlot
	q ret
}

ClassMethod BuildDataTowItem(repid, ind, JIndex, VolId)
{
	//n (repid, ind,JIndex,VolId)
	
	s Info=$g(^CacheTemp("TowItemTimeSlot",JIndex,"Seconds",VolId))
	s TimeSlot=$p(Info,$c(2),1)         //时间跨度
	s PatBaseInfo=$p(Info,$c(2),2)
	s MainInfo=$p(Info,$c(2),3)
	s VolInfo=$p(Info,$c(2),4)
	s ADMInfo=$p(Info,$c(2),5)
	s FVolStatus=$p(Info,$c(2),6)
	s SVolStatus=$p(Info,$c(2),7)
	
	Set $li(Data,1)=TimeSlot                          //TimeSlot  0D 00:00T
	
	//病人基本信息
	For iBuild=2:1:28 Do
 	.Set $li(Data,iBuild)=$p(PatBaseInfo,"^",iBuild-1)
 	
 	//病案信息
 	For iBuild=29:1:38 Do
 	.Set $li(Data,iBuild)=$p(MainInfo,"^",iBuild-28)
 	set MrTypeId=$p(MainInfo,"^",2)
 	set:MrTypeId'="" MrType=$g(^DHCWMRDIC(MrTypeId))
 	set:MrTypeId="" MrType=""
 	set MrTypeDesc=$p(MrType,"^",3)
 	set $li(Data,39)=MrTypeDesc                        //MrTypeDesc
 	
 	//病案卷信息
 	set $li(Data,40)=$p(VolInfo,"^",1)                 //VolId
	set $li(Data,41)=$p(VolInfo,"^",3)                 //VPaadmId
	set $li(Data,42)=$p(VolInfo,"^",4)                 //VHistroyAdmId
	set StatusId=$p(VolInfo,"^",7)
	set $li(Data,43)=StatusId                          //VStatusId
	set:StatusId'="" $li(Data,44)=$p(^DHCWMRWITM(StatusId),"^",2)   //VStatusDesc
	set:StatusId="" $li(Data,44)=""
	set $li(Data,45)=$p(VolInfo,"^",8)                 //VIsActive
	set $li(Data,46)=$p(VolInfo,"^",9)                 //VInFlow
	set $li(Data,47)=$p(VolInfo,"^",10)                //VResumeText
	
	//就诊信息
	For iBuild=48:1:61 Do
	.set $li(Data,iBuild)=$p(ADMInfo,"^",iBuild-47)
	set ADMLoc=$p(ADMInfo,"^",7)
	set $li(Data,54)=$p(ADMLoc,"/",2)
	set ADMDoc=$p(ADMInfo,"^",8)
	set $li(Data,55)=$p(ADMDoc,"/",3)
	
	//起始状态信息
	set $li(Data,62)=$p(FVolStatus,"^",1)                //FStaId
	set FStatusItem=$p(FVolStatus,"^",2) 
	set $li(Data,63)=$p(FStatusItem,"/",1)               //FStatusId
	set $li(Data,64)=$p(FStatusItem,"/",3)               //FStatusDesc
	set FFromUser=$p(FVolStatus,"^",3)
	set $li(Data,65)=$p(FFromUser,"/",1)                 //FUserFromId
	set $li(Data,66)=$p(FFromUser,"/",2)                 //FUserFromCode
	set $li(Data,67)=$p(FFromUser,"/",3)                 //FUserFromDesc
	set $li(Data,68)=$p(FVolStatus,"^",4)                //FCurrDate
	set $li(Data,69)=$p(FVolStatus,"^",5)                //FCurrTime
	set FToUser=$p(FVolStatus,"^",6)
	set $li(Data,70)=$p(FToUser,"/",1)                   //FUserToId
	set $li(Data,71)=$p(FToUser,"/",2)                   //FUserToCode
	set $li(Data,72)=$p(FToUser,"/",3)                   //FUserToDesc
	
	//截止状态信息
	set $li(Data,73)=$p(SVolStatus,"^",1)                //SStaId
	set SStatusItem=$p(SVolStatus,"^",2) 
	set $li(Data,74)=$p(SStatusItem,"/",1)               //SStatusId
	set $li(Data,75)=$p(SStatusItem,"/",3)               //SStatusDesc
	set SFromUser=$p(SVolStatus,"^",3)
	set $li(Data,76)=$p(SFromUser,"/",1)                 //SUserFromId
	set $li(Data,77)=$p(SFromUser,"/",2)                 //SUserFromCode
	set $li(Data,78)=$p(SFromUser,"/",3)                 //SUserFromDesc
	set $li(Data,79)=$p(SVolStatus,"^",4)                //SCurrDate
	set $li(Data,80)=$p(SVolStatus,"^",5)                //SCurrTime
	set SToUser=$p(SVolStatus,"^",6)
	set $li(Data,81)=$p(SToUser,"/",1)                   //SUserToId
	set $li(Data,82)=$p(SToUser,"/",2)                   //SUserToCode
	set $li(Data,83)=$p(SToUser,"/",3)                   //SUserToDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryTimeSlotTowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimeSlotTowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryTimeSlotTowExecute(ByRef qHandle As %Binary, JIndex As %String) As %Status
{
	//***************************************
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRXTimeSlot","QueryTimeSlotTow","JIndex")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:JIndex="" $$$OK
	Do:'$d(^CacheTemp("TowItemTimeSlot",JIndex)) ..GetTimeSlotByTowItem(^CacheTemp($ZN,$j))
	s VolId=0
	f  s VolId=$o(^CacheTemp("TowItemTimeSlot",JIndex,"Seconds",VolId)) q:VolId=""  d
	.q:'$d(^CacheTemp("TowItemTimeSlot",JIndex,"Seconds",VolId))
	.d ..BuildDataTowItem(repid,ind,JIndex,VolId)
	.s ind=ind+1
	k ^CacheTemp("TowItemTimeSlot",JIndex)
	
	Quit $$$OK
}

ClassMethod QueryTimeSlotTowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeSlotTowExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询两个操作项目之间的时间跨度信息
Query QueryTimeSlotTow(JIndex As %String) As %Query(ROWSPEC = "TimeSlot:%String,BaseId:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,IsActive:%String,ResumeText:%String,Papmi:%String,PatitneNO:%String,MainId:%String,MrTypeDr:%String,MRNO:%String,PapmiDr:%String,HistoryDR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,MrTypeDesc:%String,VolId:%String,VPaadmId:%String,VHistroyAdmId:%String,VStatusId:%String,VStatusDesc:%String,VIsActive:%String,VInFlow:%String,VResumeText:%String,paadm:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,papmi:%String,LocDesc:%String,DocDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DischgDate:%String,DischgTime:%String,VisitStatus:%String,FStaId:%String,FStatusId:%String,FStatusDesc:%String,FUserFromId:%String,FUserFromCode:%String,FUserFromDesc:%String,FCurrDate:%String,FCurrTime:%String,FUserToId:%String,FUserToCode:%String,FUserToDesc:%String,SStaId:%String,SStatusId:%String,SStatusDesc:%String,SUserFromId:%String,SUserFromCode:%String,SUserFromDesc:%String,SCurrDate:%String,SCurrTime:%String,SUserToId:%String,SUserToCode:%String,SUserToDesc:%String")
{
}

/// 获取单个操作项时间跨度信息
/// 条件：病案类型，操作项，起始日期（操作日期），截止日期（操作日期），时间跨度，比较类型符号（大于，小于，等于）
/// 结果：JIndex^状态总数量^病案状态数量^卷状态数量^符合条件总^符合条件病案数量^符合条件卷数量^总的平均时间跨度^病案平均时间跨度^卷平均时间跨度
ClassMethod GetTimeSlotByOneItem(Condition)
{
	n (Condition)
	
	s ret=""
	q:Condition="" ret
	s MrType=+$p(Condition,"^",1)
	s Status=+$p(Condition,"^",2)
	q:Status=0 ret
	s FromDate=$p(Condition,"^",3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)   //25/02/2007
	s:FromDate["-" FromDate=$zdh(FromDate,3)   //2007-02-25
	s ToDate=$p(Condition,"^",4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	q:((FromDate="")||(ToDate="")) ret
	s TimeSlot=+$p(Condition,"^",5)    //天
	s Note=$p(Condition,"^",6)         //比较符号（<,>,=）
	s:Note="" Note="<"
	
	
	k ^CacheTemp("OneItemTimeSlot",$j)
	//病案
	f CurrDate=FromDate:1:ToDate d
	.q:'$d(^DHCWMRMAIN(0,"SDateStatus",CurrDate,Status))
	.s MainId=0
	.f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",CurrDate,Status,MainId)) q:MainId=""  d
	..s MainInfo=$g(^DHCWMRMAIN(MainId))
	..s IsMainActive=$p(MainInfo,"^",6)    //bug update by zf 2008-05-23
	..q:IsMainActive'="Y"        //病案无效
	..s Type=$p(^DHCWMRMAIN(MainId),"^",1)
	..q:((MrType'=0)&&(MrType'=Type))
	..s SubId=0
	..f  s SubId=$o(^DHCWMRMAIN(0,"SDateStatus",CurrDate,Status,MainId,"S",SubId)) q:SubId=""  d
	...q:'$d(^DHCWMRMAIN(MainId,"S",SubId))
	...//病案记录总数
	...s ^CacheTemp("OneItemTimeSlot",$j,"MainCount")=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainCount"))+1
	...s MainStatus=$g(^DHCWMRMAIN(MainId,"S",SubId))
	...s CurrDate=$p(MainStatus,"^",3)
	...s CurrTime=$p(MainStatus,"^",4)
	...s NextId=$o(^DHCWMRMAIN(MainId,"S",SubId))
	...i NextId'="" d
	....s NextStatus=$g(^DHCWMRMAIN(MainId,"S",NextId))
	....s NextDate=$p(NextStatus,"^",3)
	....s NextTime=$p(NextStatus,"^",4)
	...e  d
	....s NextDate=$p($h,",",1)  //update by zf 2010-12-03
	....s NextTime=$p($h,",",2)  //update by zf 2010-12-03
	...//计算时间跨度
	...s Seconds=..AccountTimeSlot(CurrDate,CurrTime,NextDate,NextTime)
	...q:Seconds=""
	...//判断是否在指定时间范围内
	...s FormatTimeSlot=..FormatTimeSlot(Seconds)
	...s Days=+FormatTimeSlot
	...q:((Note="<")&&((Days>TimeSlot)||(Days=TimeSlot)))
	...q:((Note=">")&&((Days<TimeSlot)||(Days=TimeSlot)))
	...q:((Note="=")&&(Days'=TimeSlot))
	...//q:((TimeSlot'=0)&(Note="<")&&(Days'<TimeSlot))
	...//q:((TimeSlot'=0)&(Note=">")&&(Days'>TimeSlot))
	...//q:((TimeSlot'=0)&(Note="=")&&(Days'=TimeSlot))
	...//病案符合条件的数量
	...s ^CacheTemp("OneItemTimeSlot",$j,"MainAccordCount")=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainAccordCount"))+1
	...s ^CacheTemp("OneItemTimeSlot",$j,"MainSecondSun")=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainSecondSun"))+Seconds
	...s PatBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)  //病人基本信息
	...s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)               //病案信息
	...s VolInfo=""                                                            //病案卷信息
	...s StatusInfo=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,SubId)       //病案状态信息
	...s RowId=1_"||"_MainId_"||"_SubId
	...//存储查询列表信息
	...s ^CacheTemp("OneItemTimeSlot",$j,"Seconds",RowId)=FormatTimeSlot_$c(2)_PatBaseInfo_$c(2)_MainInfo_$c(2)_VolInfo_$c(2)_StatusInfo
	
	//病案卷
	s CurrDate=0
	f CurrDate=FromDate:1:ToDate d
	.q:'$d(^DHCWMRVOL(0,"VSDateStatus",CurrDate,Status))
	.s VolId=0
	.f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",CurrDate,Status,VolId)) q:VolId=""  d
	..s VolInfo=$g(^DHCWMRVOL(VolId))
	..s VolActiveFlg=$p(VolInfo,"^",7)
	..q:(VolActiveFlg'="Y")     //病案卷无效退出
	..s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	..s MainId=$p(VolumeInfo,"^",2)
	..s Type=$p(^DHCWMRMAIN(MainId),"^",1)
	..q:((MrType'=0)&&(MrType'=Type))
	..s SubId=0
	..f  s SubId=$o(^DHCWMRVOL(0,"VSDateStatus",CurrDate,Status,VolId,SubId)) q:SubId=""  d
	...q:'$d(^DHCWMRVOL(VolId,"S",SubId))
	...//病案卷记录总数
	...s ^CacheTemp("OneItemTimeSlot",$j,"VolCount")=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolCount"))+1
	...s VolStatus=$g(^DHCWMRVOL(VolId,"S",SubId))
	...s CurrDate=$p(VolStatus,"^",3)
	...s CurrTime=$p(VolStatus,"^",4)
	...s NextId=$o(^DHCWMRVOL(VolId,"S",SubId))
	...i NextId'="" d
	....s NextStatus=$g(^DHCWMRVOL(VolId,"S",SubId))
	....s NextDate=$p(NextStatus,"^",3)
	....s NextTime=$p(NextStatus,"^",4)
	...e  d
	....s VolStatus=""
	....s NextDate=$p($h,",",1)
	....s NextTime=$p($h,",",2)
	...//计算时间跨度
	...s Seconds=..AccountTimeSlot(CurrDate,CurrTime,NextDate,NextTime)
	...q:Seconds=""
	...//判断是否在指定时间范围内
	...s FormatTimeSlot=..FormatTimeSlot(Seconds)
	...s Days=+FormatTimeSlot
	...q:((Note="<")&&((Days>TimeSlot)||(Days=TimeSlot)))
	...q:((Note=">")&&((Days<TimeSlot)||(Days=TimeSlot)))
	...q:((Note="=")&&(Days'=TimeSlot))
	...//q:((TimeSlot'=0)&&(Note="<")&&(Days'<TimeSlot))
	...//q:((TimeSlot'=0)&&(Note=">")&&(Days'>TimeSlot))
	...//q:((TimeSlot'=0)&&(Note="=")&&(Days'=TimeSlot))
	...//病案符合条件的数量
	...s ^CacheTemp("OneItemTimeSlot",$j,"VolAccordCount")=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolAccordCount"))+1
	...s ^CacheTemp("OneItemTimeSlot",$j,"VolSecondSun")=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolSecondSun"))+Seconds
	...s PatBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)  //病人基本信息
	...s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)               //病案信息
	...s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)                 //病案卷信息
	...s StatusInfo=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,SubId)     //病案卷状态信息
	...s RowId=2_"||"_VolId_"||"_SubId
	...//存储查询列表信息
	...s ^CacheTemp("OneItemTimeSlot",$j,"Seconds",RowId)=FormatTimeSlot_$c(2)_PatBaseInfo_$c(2)_MainInfo_$c(2)_VolInfo_$c(2)_StatusInfo
	
	s MainCount=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainCount"))
	s VolCount=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolCount"))
	s CountSun=MainCount+VolCount
	
	s MainAccordCount=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainAccordCount"))
	s VolAccordCount=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolAccordCount"))
	s AccordCountSun=MainAccordCount+VolAccordCount
	
	s:MainAccordCount'=0 MainTimeSlot=+$g(^CacheTemp("OneItemTimeSlot",$j,"MainSecondSun"))\MainAccordCount
	s:MainAccordCount=0 MainTimeSlot=0
	s MainTimeSlot=..FormatTimeSlot(MainTimeSlot)
	s:VolAccordCount'=0 VolTimeSlot=+$g(^CacheTemp("OneItemTimeSlot",$j,"VolSecondSun"))\VolAccordCount
	s:VolAccordCount=0 VolTimeSlot=0
	s VolTimeSlot=..FormatTimeSlot(VolTimeSlot)
	s TimeSlotSun=(+$g(^CacheTemp("OneItemTimeSlot",$j,"MainSecondSun")))+(+$g(^CacheTemp("OneItemTimeSlot",$j,"VolSecondSun")))
	s:AccordCountSun'=0 AveTimeSlot=TimeSlotSun\AccordCountSun
	s:AccordCountSun=0 AveTimeSlot=0
	s AveTimeSlot=..FormatTimeSlot(AveTimeSlot)
	
	s JIndex=$j
	s ret=JIndex_"^"_MainCount_"^"_VolCount_"^"_CountSun_"^"_MainAccordCount_"^"_VolAccordCount_"^"_AccordCountSun_"^"_MainTimeSlot_"^"_VolTimeSlot_"^"_AveTimeSlot
	q ret
}

ClassMethod BuildDataOneItem(repid, ind, JIndex, RowId)
{
	n (repid,ind,JIndex,RowId)
	
	s Info=$g(^CacheTemp("OneItemTimeSlot",JIndex,"Seconds",RowId))
	s TimeSlot=$p(Info,$c(2),1)
	s PatBaseInfo=$p(Info,$c(2),2)
	s MainInfo=$p(Info,$c(2),3)
	s VolInfo=$p(Info,$c(2),4)
	s Status=$p(Info,$c(2),5)
	
	Set $li(Data,1)=TimeSlot                          //TimeSlot
	
	//病人基本信息
	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild+1)=$p(PatBaseInfo,"^",iBuild)
 	
 	//病案信息
 	For iBuild=1:1:10 Do
 	.Set $li(Data,iBuild+28)=$p(MainInfo,"^",iBuild)
 	set MrTypeId=$p(MainInfo,"^",2)
 	set:MrTypeId'="" MrType=$g(^DHCWMRDIC(MrTypeId))
 	set:MrTypeId="" MrType=""
 	set MrTypeDesc=$p(MrType,"^",4)
 	set $li(Data,39)=MrTypeDesc                        //MrTypeDesc
 	
 	//病案卷信息
 	set $li(Data,40)=$p(VolInfo,"^",1)                 //VolId
	set $li(Data,41)=$p(VolInfo,"^",3)                 //VPaadmId
	set $li(Data,42)=$p(VolInfo,"^",4)                 //VHistroyAdmId
	set StatusId=$p(VolInfo,"^",7)
	set $li(Data,43)=StatusId                          //VStatusId
	set:StatusId'="" $li(Data,44)=$p(^DHCWMRWITM(StatusId),"^",2)   //VStatusDesc
	set:StatusId="" $li(Data,44)=""
	set $li(Data,45)=$p(VolInfo,"^",8)                 //VIsActive
	set $li(Data,46)=$p(VolInfo,"^",9)                 //VInFlow
	set $li(Data,47)=$p(VolInfo,"^",10)                 //VResumeText
	
	//病案/卷状态信息
	set $li(Data,48)=$p(Status,"^",1)                   //MainVolStaId
	set StatusItem=$p(Status,"^",2) 
	set $li(Data,49)=$p(StatusItem,"/",1)               //StatusId
	set $li(Data,50)=$p(StatusItem,"/",3)               //StatusDesc
	set FromUser=$p(Status,"^",3)
	set $li(Data,51)=$p(FromUser,"/",1)                 //UserFromId
	set $li(Data,52)=$p(FromUser,"/",2)                 //UserFromCode
	set $li(Data,53)=$p(FromUser,"/",3)                 //UserFromDesc
	set $li(Data,54)=$p(Status,"^",4)                   //CurrDate
	set $li(Data,55)=$p(Status,"^",5)                   //CurrTime
	set ToUser=$p(Status,"^",6)
	set $li(Data,56)=$p(ToUser,"/",1)                   //UserToId
	set $li(Data,57)=$p(ToUser,"/",2)                   //UserToCode
	set $li(Data,58)=$p(ToUser,"/",3)                   //UserToDesc
	
	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryTimeSlotOneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimeSlotOneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryTimeSlotOneExecute(ByRef qHandle As %Binary, JIndex As %String) As %Status
{
	//***************************************
	//调试：d ##class(%ResultSet).RunQuery("web.DHCWMRXTimeSlot","QueryTimeSlotOne","JIndex")
	//*****************************************
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:JIndex="" $$$OK
	//w JIndex,!!
	s RowId=0
	f  s RowId=$o(^CacheTemp("OneItemTimeSlot",JIndex,"Seconds",RowId)) q:RowId=""  d
	.q:'$d(^CacheTemp("OneItemTimeSlot",JIndex,"Seconds",RowId))
	.d ..BuildDataOneItem(repid,ind,JIndex,RowId)
	.s ind=ind+1
	
	k ^CacheTemp("OneItemTimeSlot",JIndex)
	
	Quit $$$OK
}

ClassMethod QueryTimeSlotOneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeSlotOneExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询单个操作项时间跨度信息
Query QueryTimeSlotOne(JIndex As %String) As %Query(ROWSPEC = "TimeSlot:%String,BaseId:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,IsActive:%String,ResumeText:%String,Papmi:%String,PatitneNO:%String,MainId:%String,MrTypeDr:%String,MRNO:%String,PapmiDr:%String,HistoryDR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,MrTypeDesc:%String,VolId:%String,VPaadmId:%String,VHistroyAdmId:%String,VStatusId:%String,VStatusDesc:%String,VIsActive:%String,VInFlow:%String,VResumeText:%String,MainVolStaId:%String,StatusId:%String,StatusDesc:%String,UserFromId:%String,UserFromCode:%String,UserFromDesc:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserToCode:%String,UserToDesc:%String")
{
}

/// 计算时间跨度方法
/// Condition:FDate,FTime,TDate,TTime
/// Return:Seconds
ClassMethod AccountTimeSlot(FDate, FTime, TDate, TTime)
{
	n (FDate,FTime,TDate,TTime)
	
	q:((FDate="")||(FTime="")) ""
	q:((TDate="")||(TTime="")) ""
	s Days=TDate-FDate
	s Times=TTime-FTime
	s Seconds=Days*86400+Times
	s:Seconds<0 Seconds=-Seconds
	
	q Seconds
}

/// 格式化时间跨度
/// Condition：Seconds
/// Return：0D 00:00T
ClassMethod FormatTimeSlot(Seconds)
{
	n (Seconds)
	
	s Seconds=+Seconds
	s:Seconds<0 Seconds=0
	s Days=Seconds\86400
	s Times=Seconds#86400
	s Times=$zt(Times,2)
	s TimeSlot=Days_"Day "_Times_"Time"
	
	q TimeSlot
}

}
