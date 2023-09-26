Import SQLUser

/// 对病案/病案卷状态的查询
/// by ZF 2007－04
Class web.DHCWMRStatusInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 137;

ClassMethod BuildDataStatusInfoByNo(repid, ind, RefRowid, ChildSub, Flag)
{
	n (repid, ind, RefRowid,ChildSub,Flag)
	
	i Flag=0 d       //病案
	.s MainId=RefRowid
	.s StatusInfo=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,ChildSub)
	i Flag=1 d       //病案卷
	.s VolId=RefRowid
	.s StatusInfo=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.s MainId=$p(VolumeInfo,"^",2)
	
	s WorkItem=$p(StatusInfo,"^",2)
	s UserFrom=$p(StatusInfo,"^",3)
	s UserTo=$p(StatusInfo,"^",6)
	
	s $p(StatusInfo,"^",2)=$p(WorkItem,"/",1)
	s $p(StatusInfo,"^",3)=$p(UserFrom,"/",1)
	s $p(StatusInfo,"^",6)=$p(UserTo,"/",1)
	
	Set Data=$lb("")
 	For iBuild=1:1:$l(StatusInfo,"^") Do
 	.Set $li(Data,iBuild)=$p(StatusInfo,"^",iBuild)
 	
 	set $li(Data,7)=$p(UserFrom,"/",3)      ;UserFromDesc
 	set $li(Data,8)=$p(UserTo,"/",3)        ;UserToDesc
 	Set $li(Data,9)=$p(WorkItem,"/",2)      ;ItemTypeDr
 	set ItemTypeDesc=""
 	Set:$p(WorkItem,"/",2)'="" ItemTypeDesc=$p(^DHCWMRDIC(+$p(WorkItem,"/",2)),"^",3)
 	Set $li(Data,10)=ItemTypeDesc           ;ItemTypeDesc
 	Set $li(Data,11)=$p(WorkItem,"/",3)     ;ItemDesc
 	Set $li(Data,12)=$p(WorkItem,"/",4)     ;ItemActive
 	Set $li(Data,13)=$p(WorkItem,"/",5)     ;ItemResume
 	Set $li(Data,14)=$p(WorkItem,"/",6)     ;SysOperDr
 	set SysOperDesc=""
 	set SysOperDr=+$p(WorkItem,"/",6)
 	Set:SysOperDr'=0 SysOperDesc=$p($g(^DHCWMRDIC(SysOperDr)),"^",3)
 	Set $li(Data,15)=SysOperDesc           ;SysOperDesc
 	
 	//根据病案id查询病人基本信息
 	//s MainId=PatId
 	s PatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
 	
 	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild+15)=$p(PatInfo,"^",iBuild)
 	
 	//根据病案id查询病案基本信息
 	s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)
 	s MainTypeId=$p(MainInfo,"^",2)
 	s MainType=$p(^DHCWMRDIC(MainTypeId),"^",3)
 	Set $li(Data,43)=MainTypeId             ;MainTypeId
 	Set $li(Data,44)=MainType               ;MainType
 	Set $li(Data,45)=$p(MainInfo,"^",3)     ;MainNo
 	Set $li(Data,46)=$p(MainInfo,"^",9)     ;MainDate生成日期
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryStatusInfoByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatusInfoByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryStatusInfoByNoExecute(ByRef qHandle As %Binary, MrType As %String, No As %String, Flg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:No="" $$$OK
	s No=$$ALPHAUP^SSUTIL4($g(No))    //add by zf 2008-04-14
	q:Flg="" $$$OK
	q:((Flg=2)&&(MrType="")) $$$OK
	i Flg=2 d                    //按病案号查询
	.s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,No,0))
	.q:MainId=""
	.q:'$d(^DHCWMRMAIN(MainId))
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCWMRMAIN(MainId,"S",ChildSub)) q:ChildSub=""  d
	..q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    ..d ..BuildDataStatusInfoByNo(repid, ind, MainId,ChildSub,0)
    ..s ind=ind+1
    i Flg=1 d                    //按病案卷Rowid查询
    .s VolId=No
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCWMRVOL(VolId,"S",ChildSub)) q:ChildSub=""  d
    ..q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    ..d ..BuildDataStatusInfoByNo(repid, ind, VolId,ChildSub,1)
    ..s ind=ind+1
    i Flg=0 d                    //按病案Rowid查询
    .s MainId=No
    .s ChildSub=0
    .f  s ChildSub=$o(^DHCWMRMAIN(MainId,"S",ChildSub)) q:ChildSub=""  d
    ..q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    ..d ..BuildDataStatusInfoByNo(repid, ind, MainId,ChildSub,0)
    ..s ind=ind+1
    
    q $$$OK
}

ClassMethod QueryStatusInfoByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatusInfoByNoExecute ]
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

/// 根据病案号或病案卷号查询病案或病案卷状态信息列表
/// 输入参数：病案类型（病案查询）、号码（MainId/VolId/病案号）,Flg(0/1/2)
Query QueryStatusInfoByNo(MrType As %String, No As %String, Flg As %String) As %Query(ROWSPEC = "RowId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String,PapatRowid:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,IsActive:%String,ResumeText:%String,Papmi:%String,PatitneNO:%String,MainTypeId:%String,MainType:%String,MainNo:%String,MainDate:%String")
{
}

ClassMethod BuildDataStaByDatUserItm(repid, ind, RefRowid, ChildSub, Flag)
{
	n (repid, ind, RefRowid,ChildSub,Flag)
	
	//s PatId=$p(RefRowid,"||",1)
	//s SubId=$p(RefRowid,"||",2)
	
	s StatusEvaInfo=""
	s CurrStatusID="" 		//当前状态ID 由于DHC_WMR_Main表中无当前状态，预留后续处理
	s CurrStatusDesc=""		//当前状态描述

	s MainId="",VolId="",MainStaId="",VolStaId=""
	i Flag=0 d     //病案
	.s MainId=RefRowid
	.s StatusInfo=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,ChildSub)
	.s MainStaId=$p(StatusInfo,"^",1)
	.;s CurrStatusID=$p($g(^DHCWMRMAIN(+MainId)),"^")
	.;s CurrStatusDesc=$p($g(^DHCWMRWITM(+CurrStatusID)),"^",2)
	i Flag=1 d     //病案卷
	.s VolId=RefRowid
	.s CurrStatusID=$p($g(^DHCWMRVOL(+VolId)),"^",6)
	.s CurrStatusDesc=$p($g(^DHCWMRWITM(+CurrStatusID)),"^",2)
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.s MainId=$p(VolumeInfo,"^",2)
	.s StatusInfo=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	.s VolStaId=$p(StatusInfo,"^",1)
	.s EvaChildSub=""
	.s EvaChildSub=$o(^DHCWMRVol(VolId,"S",ChildSub,"E",EvaChildSub),-1)
	.q:((EvaChildSub=0)||(EvaChildSub=""))
	.s StatusEvaInfo=$g(^DHCWMRVol(VolId,"S",ChildSub,"E",EvaChildSub))

	
	s WorkItem=$p(StatusInfo,"^",2)
	s UserFrom=$p(StatusInfo,"^",3)
	s UserTo=$p(StatusInfo,"^",6)
	
	s $p(StatusInfo,"^",2)=$p(WorkItem,"/",1)
	s $p(StatusInfo,"^",3)=$p(UserFrom,"/",1)
	s $p(StatusInfo,"^",6)=$p(UserTo,"/",1)
	
	Set Data=$lb("")
 	For iBuild=1:1:$l(StatusInfo,"^") Do
 	.Set $li(Data,iBuild)=$p(StatusInfo,"^",iBuild)
 	
 	set $li(Data,7)=$p(UserFrom,"/",3)      ;UserFromDesc
 	set $li(Data,8)=$p(UserTo,"/",3)        ;UserToDesc
 	Set $li(Data,9)=$p(WorkItem,"/",2)      ;ItemTypeDr
 	set ItemTypeDesc=""
 	set ItemTypeId=+$p(WorkItem,"/",2)
 	Set:ItemTypeId'=0 ItemTypeDesc=$p($g(^DHCWMRDIC(ItemTypeId)),"^",3)
 	Set $li(Data,10)=ItemTypeDesc           ;ItemTypeDesc
 	Set $li(Data,11)=$p(WorkItem,"/",3)     ;ItemDesc
 	Set $li(Data,12)=$p(WorkItem,"/",4)     ;ItemActive
 	Set $li(Data,13)=$p(WorkItem,"/",5)     ;ItemResume
 	Set $li(Data,14)=$p(WorkItem,"/",6)     ;SysOperDr
 	set SysOperDesc=""
 	set SysOperDr=+$p(WorkItem,"/",6)
 	Set:SysOperDr'=0 SysOperDesc=$p($g(^DHCWMRDIC(SysOperDr)),"^",3)
 	Set $li(Data,15)=SysOperDesc           ;SysOperDesc
 	
 	//如果为病案卷查询显示最后一次评价的信息
 	//如果为病案查询显示空
 	S $li(Data,16)=$p(StatusEvaInfo,"^",1)     ;EvaDr    病案卷评价RowId
 	s ItmId=$p($p(StatusEvaInfo,"^",1),"||",1)
 	s SubId=$p($p(StatusEvaInfo,"^",1),"||",2)
 	s EvaInfo=""
 	s:((ItmId'="")&&(SubId'="")) EvaInfo=$g(^DHCWMRWITM(ItmId,"R",SubId))
 	S $li(Data,17)=$p(EvaInfo,"^",1)           ;EvaDesc   病案卷评价描述
 	
 	//根据病案id查询病案基本信息
 	;s MainId=PatId
 	s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)
 	s MainTypeId=$p(MainInfo,"^",2)
 	s MainType=$p(^DHCWMRDIC(MainTypeId),"^",3)
 	Set $li(Data,18)=MainTypeId             ;MainTypeId
 	Set $li(Data,19)=MainType               ;MainType
 	Set $li(Data,20)=$p(MainInfo,"^",3)     ;MainNo
 	Set $li(Data,21)=$p(MainInfo,"^",9)     ;MainDate生成日期
 	
 	//RowId
 	set $li(Data,22)=Flag                   ;区分标记 0--病案   1--病案卷
 	Set $li(Data,23)=MainId                 ;MainId
 	Set $li(Data,24)=VolId                  ;VolId
 	Set $li(Data,25)=MainStaId              ;MainStaId
 	Set $li(Data,26)=VolStaId               ;VolStaId
 	
 	s PatientID=$p(MainInfo,"^",4)			;PatientID
 	Set $li(Data,27)=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1) 
 	Set $li(Data,28)=CurrStatusDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

/// 根据时间、人员、操作项目查询病案或病案卷状态信息
/// 输入参数：开始日期，结束日期，转交人、接收人、操作项目、区分标记(0:病案,1:病案卷,2:病案和病案卷)
ClassMethod GetStaByDatUserItm(Condition)
{
	s ret=-1
	s DateFrom=$p(Condition,"^",1)
	s:DateFrom["-" DateFrom=$p(DateFrom,3)
	s:DateFrom["/" DateFrom=$p(DateFrom,4)
	s DateTo=$p(Condition,"^",2)
	s:DateTo["-" DateTo=$p(DateTo,3)
	s:DateTo["/" DateTo=$p(DateTo,4)
	s UserFrom=$p(Condition,"^",3)
	s UserTo=$p(Condition,"^",4)
	s WorkItem=+$p(Condition,"^",5)
	s Flg=$p(Condition,"^",6)
	
    q:DateFrom="" ret
	q:DateTo="" ret
	q:Flg="" ret
	s:WorkItem=0 WorkItem=""
	s FlgStr=""
	
	s JIndex=$j
	k ^CacheTemp("DoStatusQuery",JIndex)
	
	//病案查询
    i ((Flg=0)||(Flg=2)) d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date))
	..i WorkItem'="" d
	...q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ...s MainId=0
    ...f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    .....s ^CacheTemp("DoStatusQuery",JIndex,1,MainId,ChildSub)=""
    .....//d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    .....//s ind=ind+1
	..e  d
	...s WorkItem=""
	...f  s WorkItem=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem)) q:WorkItem=""  d
	....q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ....s MainId=0
    ....f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    ......s ^CacheTemp("DoStatusQuery",JIndex,1,MainId,ChildSub)=""
    ......//d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    ......//s ind=ind+1
	
	
	//病案卷查询
	i ((Flg=1)||(Flg=2)) d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date))
	..i WorkItem'="" d
	...q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ...s VolId=0
    ...f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,"S",ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    .....s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    .....s ^CacheTemp("DoStatusQuery",JIndex,2,VolId,ChildSub)=""
    .....//d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    .....//s ind=ind+1
	..e  d
	...s WorkItem=""
	...f  s WorkItem=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem)) q:WorkItem=""  d
	....q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ....s VolId=0
    ....f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,"S",ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    ......s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    ......s ^CacheTemp("DoStatusQuery",JIndex,2,VolId,ChildSub)=""
    ......//d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    ......//s ind=ind+1
    
    q JIndex
}

ClassMethod QueryStaByDatUserItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStaByDatUserItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryStaByDatUserItmExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, WorkItem As %String, Flg As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
    q:DateFrom="" $$$OK
	q:DateTo="" $$$OK
	q:Flg="" $$$OK
	s:WorkItem=0 WorkItem=""
	s FlgStr=""
	
	s JIndex=$j
	//k ^CacheTemp("DoStatusQuery",JIndex)
	
	//病案查询
    i ((Flg=0)||(Flg=2)) d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date))
	..i WorkItem'="" d
	...q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ...s MainId=0
    ...f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    .....//s ^CacheTemp("DoStatusQuery",JIndex,1,MainId,ChildSub)=""
    .....d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    .....s ind=ind+1
    ..e  d
    ...s WorkItem=""
    ...f  s WorkItem=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem)) q:WorkItem=""  d
    ....q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ....s MainId=0
    ....f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    ......//s ^CacheTemp("DoStatusQuery",JIndex,1,MainId,ChildSub)=""
    ......d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    ......s ind=ind+1
	
	
    //病案卷查询
    i ((Flg=1)||(Flg=2)) d
    .f Date=DateFrom:1:DateTo d
    ..q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date))
    ..i WorkItem'="" d
    ...q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ...s VolId=0
    ...f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,"S",ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    .....s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    .....//s ^CacheTemp("DoStatusQuery",JIndex,2,VolId,ChildSub)=""
    .....d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    .....s ind=ind+1
    ..e  d
    ...s WorkItem=""
    ...f  s WorkItem=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem)) q:WorkItem=""  d
    ....q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ....s VolId=0
    ....f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,"S",ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    ......s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    ......//s ^CacheTemp("DoStatusQuery",JIndex,2,VolId,ChildSub)=""
    ......d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    ......s ind=ind+1
	
	//s ID=0
	//f  s ID=$o(^CacheTemp("DoStatusQuery",JIndex,ID)) q:ID=""  d
	//.q:'$d(^CacheTemp("DoStatusQuery",JIndex,ID))
	//.s RowId=0
	//.f  s RowId=$o(^CacheTemp("DoStatusQuery",JIndex,ID,RowId)) q:RowId=""  d
	//..s SubId=0
	//..f  s SubId=$o(^CacheTemp("DoStatusQuery",JIndex,ID,RowId,SubId)) q:SubId=""  d
	//...d ..BuildDataStaByDatUserItm(repid, ind,RowId,SubId,ID)
	//...s ind=ind+1
	
    q $$$OK
}

ClassMethod QueryStaByDatUserItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStaByDatUserItmExecute ]
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

/// 根据时间、人员、操作项目查询病案或病案卷状态信息
/// 输入参数：开始日期，结束日期，转交人、接收人、操作项目、区分标记(0:病案,1:病案卷,2:病案和病案卷)
Query QueryStaByDatUserItm(DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, WorkItem As %String, Flg As %String) As %Query(ROWSPEC = "RowId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String,StatusEvaId:%String,StatusEvaDesc:%String,MainTypeId:%String,MainType:%String,MainNo:%String,MainDate:%String,MainORVolFlag:%String,MainId:%String,VolId:%String,MainStaId:%String,VolStaId:%String")
{
}

/// add parameter "DisWardID" by liuxuefeng 2009-07-14 在卷查询中，增加按照本次住院就诊的出院病区的进行筛选
ClassMethod GetExecutedStatus(JIndex, DateFrom, DateTo, UserFrom, UserTo, WorkItem, Flg, MrType, DisWardID, cLocRowid)
{
	s ret=-1
	
	s Flg=+Flg
	q:(Flg<0)||(Flg>2) ret
    q:((DateFrom="")||(DateTo="")) ret
    s:WorkItem=0 WorkItem=""
	
	//病案查询
    i ((Flg=0)||(Flg=2)) d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date))
	..i WorkItem'="" d
	...q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ...s MainId=0
    ...f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
	....s MainInfo=$g(^DHCWMRMAIN(MainId))
	....s strMrType=$p(MainInfo,"^",1) 	;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....q:strMrType'=MrType				;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....s IsMainActive=$p(MainInfo,"^",6)
	....q:IsMainActive'="Y"
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    .....s ^CacheTemp("DoStatusQuery",JIndex,0,MainId,ChildSub)=""
    .....//d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    .....//s ind=ind+1
	..e  d
	...s WorkItem=""
	...f  s WorkItem=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem)) q:WorkItem=""  d
	....q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem))
    ....s MainId=0
    ....f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId)) q:MainId=""  d
	.....s MainInfo=$g(^DHCWMRMAIN(MainId))
	.....s strMrType=$p(MainInfo,"^",1) ;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....q:strMrType'=MrType			;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....s IsMainActive=$p(MainInfo,"^",6)
	.....q:IsMainActive'="Y"
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,WorkItem,MainId,"S",ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    ......s ^CacheTemp("DoStatusQuery",JIndex,0,MainId,ChildSub)=""
    ......//d ..BuildDataStaByDatUserItm(repid, ind,MainId,ChildSub,0)
    ......//s ind=ind+1
	
	
	//病案卷查询
	i ((Flg=1)||(Flg=2)) d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date))
	..i WorkItem'="" d
	...q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ...s VolId=0
    ...f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
	....s VolInfo=$g(^DHCWMRVOL(VolId))
	....s MainId=$p(VolInfo,"^",1) 				;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....s MainInfo=$g(^DHCWMRMAIN(MainId)) 		;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....s strMrType=$p(MainInfo,"^",1) 			;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....q:strMrType'=MrType						;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	....s VolActiveFlg=$p(VolInfo,"^",7)
	....q:(VolActiveFlg="N")
	....s EpisodeId=$p(VolInfo,"^",2) 						;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
	....s PaadmCurrentWard=$p($g(^PAADM(EpisodeId)),"^",70)	;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
    ....;w !,"PaadmCurrentWard="_PaadmCurrentWard_";DisWardID="_DisWardID
    ....q:(DisWardID'="")&&(DisWardID'=PaadmCurrentWard)	;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
    ....s Loc=$p($g(^PAADM(+EpisodeId)),"^",4)
    ....q:((cLocRowid'="")&&(Loc'=cLocRowid))
    ....s ChildSub=0
    ....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,ChildSub)) q:ChildSub=""  d
    .....q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    .....s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    .....q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    .....q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    .....s ^CacheTemp("DoStatusQuery",JIndex,1,VolId,ChildSub)=""
    .....//d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    .....//s ind=ind+1
	..e  d
	...s WorkItem=""
	...f  s WorkItem=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem)) q:WorkItem=""  d
	....q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem))
    ....s VolId=0
    ....f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId)) q:VolId=""  d
	.....s VolInfo=$g(^DHCWMRVOL(VolId))
	.....s MainId=$p(VolInfo,"^",1) 				;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....s MainInfo=$g(^DHCWMRMAIN(MainId)) 		;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....s strMrType=$p(MainInfo,"^",1) 			;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....q:strMrType'=MrType						;add by liuxuefeng 2009-06-12 根据病案类型筛选病案卷
	.....s VolActiveFlg=$p(VolInfo,"^",7)
	.....q:(VolActiveFlg="N")
	.....s EpisodeId=$p(VolInfo,"^",2) 						;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
	.....s PaadmCurrentWard=$p($g(^PAADM(EpisodeId)),"^",70)	;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
    .....q:(DisWardID'="")&&(DisWardID'=PaadmCurrentWard)	;add by liuxuefeng 2009-07-21 根据出院病区筛选病案卷
    .....;w !,"PaadmCurrentWard="_PaadmCurrentWard_";DisWardID="_DisWardID
    .....s Loc=$p($g(^PAADM(+EpisodeId)),"^",4)
    .....q:((cLocRowid'="")&&(Loc'=cLocRowid))
    .....s ChildSub=0
    .....f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,WorkItem,VolId,ChildSub)) q:ChildSub=""  d
    ......q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    ......s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    ......q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    ......q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    ......s ^CacheTemp("DoStatusQuery",JIndex,1,VolId,ChildSub)=""
    ......//d ..BuildDataStaByDatUserItm(repid, ind,VolId,ChildSub,1)
    ......//s ind=ind+1
    
    q 1
}

ClassMethod QueryExecutedStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExecutedStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryExecutedStatusExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, WorkItem As %String, Flg As %String, MrType As %String, DisWardID As %String, cLocRowid As %String, PrintFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;set ^Test("QueryExecutedStatusExecute")=DateFrom_","_DateTo_","_UserFrom_","_UserTo_","_WorkItem_","_Flg_","_MrType_","_DisWardID_","_cLocRowid_","_PrintFlag
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s DateFrom=+DateFrom
	
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s DateTo=+DateTo
	
	s JIndex=$j
	k ^CacheTemp("DoStatusQuery",JIndex)
	s ret=..GetExecutedStatus(JIndex,DateFrom,DateTo,UserFrom,UserTo,WorkItem,Flg,MrType,DisWardID,cLocRowid)
	q:ret'=1 $$$OK

	s FlgInd=""
	f  s FlgInd=$o(^CacheTemp("DoStatusQuery",JIndex,FlgInd)) q:FlgInd=""  d
	.q:'$d(^CacheTemp("DoStatusQuery",JIndex,FlgInd))
	.s ParRef=0
	.f  s ParRef=$o(^CacheTemp("DoStatusQuery",JIndex,FlgInd,ParRef)) q:ParRef=""  d
	..s Childsub=$o(^CacheTemp("DoStatusQuery",JIndex,FlgInd,ParRef,""),-1)
	..q:Childsub=0
	..d ..BuildDataStaByDatUserItm(repid, ind,ParRef,Childsub,FlgInd)
	..s ind=ind+1
	
	s Cnt=ind-1					
	w:PrintFlag'="Y" "数量:"_Cnt	
	//k ^CacheTemp("DoStatusQuery",JIndex)
    q $$$OK
}

ClassMethod QueryExecutedStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExecutedStatusExecute ]
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

/// 根据时间、人员、操作项目查询病案或病案卷状态信息
/// 输入参数：开始日期，结束日期，转交人、接收人、操作项目、区分标记(0:病案,1:病案卷,2:病案和病案卷)
Query QueryExecutedStatus(DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, WorkItem As %String, Flg As %String, MrType As %String, DisWardID As %String, cLocRowid As %String, PrintFlag As %String) As %Query(ROWSPEC = "RowId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String,StatusEvaId:%String,StatusEvaDesc:%String,MainTypeId:%String,MainType:%String,MainNo:%String,MainDate:%String,MainORVolFlag:%String,MainId:%String,VolId:%String,MainStaId:%String,VolStaId:%String,PapmiNo:%String,CurrStatusDesc:%String")
{
}

ClassMethod GetCurrStatusMR(JIndex, MrTypes, Items, DateFrom, DateTo, UserFrom, UserTo, IsVol)
{
	n (JIndex,MrTypes,Items,DateFrom,DateTo,UserFrom,UserTo,IsVol)
	
	s IsVol=+IsVol
	
	;^DHCWMRMAIN(0,"SDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_Main.Rowid},"S",{ChildSub})
	i (IsVol=0)||(IsVol=1) d
	.f xDate=DateFrom:1:DateTo d
	..s xStatus=0
	..f  s xStatus=$o(^DHCWMRMAIN(0,"SDateStatus",xDate,xStatus)) q:xStatus=""  d
	...s xMainId=0
	...f  s xMainId=$o(^DHCWMRMAIN(0,"SDateStatus",xDate,xStatus,xMainId)) q:xMainId=""  d
	....;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",0,"Status",{Status_Dr},{ChildSub})
	....s xChildId=+$o(^DHCWMRMAIN(xMainId,"S",0,"Status",xStatus,""),-1)
	....q:xChildId=0
	....s yChildId=$o(^DHCWMRMAIN(xMainId,"S",xChildId))
	....q:yChildId'=""
	....s ^CacheTemp("CurrStatusQuery",JIndex,"Main",xMainId)=xMainId_"||"_xChildId
	
	;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	i (IsVol=0)||(IsVol=2) d
	.f xDate=DateFrom:1:DateTo d
	..s xStatus=0
	..f  s xStatus=$o(^DHCWMRVOL(0,"VSDateStatus",xDate,xStatus)) q:xStatus=""  d
	...s xVolId=0
	...f  s xVolId=$o(^DHCWMRVOL(0,"VSDateStatus",xDate,xStatus,xVolId)) q:xVolId=""  d
	....;^DHCWMRVOL(DHC_WMR_MainVolume.Rowid},"S",0,"Status"{Status_Dr},{ChildSub})
	....s xChildId=$o(^DHCWMRVOL(xVolId,"S",0,"Status",xStatus,""),-1)
	....q:(xChildId=0)||(xChildId="")
	....s yChildId=$o(^DHCWMRVOL(xVolId,"S",xChildId))
	....q:yChildId'=""
	....s ^CacheTemp("CurrStatusQuery",JIndex,"Vol",xVolId)=xVolId_"||"_xChildId
	
	q 1
}

ClassMethod xBuildData(repid, ind, MainId, VolId, ChildSub)
{
	n (repid, ind,MainId,VolId,ChildSub)
	
	;状态信息
	i MainId'="" d
	.s StatusInfo=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,ChildSub)
	e  d
	.s StatusInfo=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.s MainId=$p(VolumeInfo,"^",2)
	;病人基本信息
 	s PatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
 	;病案基本信息
 	s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)
 	s MrTypeId=$p(MainInfo,"^",2)
 	s MrType=$p(^DHCWMRDIC(MrTypeId),"^",3)
 	
 	Set Data=$lb("")
	set $li(Data,1)=MainId                 ;MainId
	set $li(Data,2)=VolId                  ;VolId
 	Set $li(Data,3)=MrTypeId               ;MrTypeId
 	Set $li(Data,4)=MrType                 ;MrType
 	Set $li(Data,5)=$p(MainInfo,"^",3)     ;MrNo
 	Set $li(Data,6)=$p(MainInfo,"^",9)     ;BuildDate
 	For iBuild=1:1:6 Do                    ;状态信息
 	.Set $li(Data,iBuild+6)=$p(StatusInfo,"^",iBuild)
 	For iBuild=1:1:27 Do                   ;病人基本信息
 	.Set $li(Data,iBuild+12)=$p(PatInfo,"^",iBuild)
	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryCurrStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryCurrStatusExecute(ByRef qHandle As %Binary, MrTypes As %String, Items As %String, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, IsVol As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s JIndex=$j
	k ^CacheTemp("CurrStatusQuery",JIndex)
	
	s ret=..GetCurrStatusMR(JIndex,MrTypes,Items,DateFrom,DateTo,UserFrom,UserTo,IsVol)
	q:ret'=1 $$$OK

	s MainId=""
	f  s MainId=$o(^CacheTemp("CurrStatusQuery",JIndex,"Main",MainId)) q:MainId=""  d
	.s xMainStaId=$g(^CacheTemp("CurrStatusQuery",JIndex,"Main",MainId))
	.s ChildSub=$p(xMainStaId,"||",2)
	.q:ChildSub=""
	.d ..xBuildData(repid, ind,MainId,"",ChildSub)
	.s ind=ind+1
	
	s VolId=""
	f  s VolId=$o(^CacheTemp("CurrStatusQuery",JIndex,"Vol",VolId)) q:VolId=""  d
	.s xVolStaId=$g(^CacheTemp("CurrStatusQuery",JIndex,"Vol",VolId))
	.s ChildSub=$p(xVolStaId,"||",2)
	.q:ChildSub=""
	.d ..xBuildData(repid, ind,"",VolId,ChildSub)
	.s ind=ind+1
	
	k ^CacheTemp("CurrStatusQuery",JIndex)
    q $$$OK
}

ClassMethod QueryCurrStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrStatusExecute ]
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

/// ******************************************
/// 病案当前状态查询
/// 支持多种病案多种状态同时查询
/// 参数：
/// MrTypes    病案类型字符串 例：“6^7^101”
/// Items      病案状态字符串 例：“1^2^3^4”
/// DateFrom   起始日期(操作日期)
/// DateTo     结束日期(操作日期)
/// UserFrom   转交人
/// UserTo     接收人
/// IsVol      病案/病案卷查询标记  ""--查询全部  0--查询全部  1--查询病案  2--查询卷
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRStatusInfo","QueryCurrStatus")
/// ******************************************
Query QueryCurrStatus(MrTypes As %String, Items As %String, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, IsVol As %String) As %Query(ROWSPEC = "MainId:%String,VolId:%String,MrTypeId:%String,MrType:%String,MrNo:%String,BuildDate:%String,StatusId:%String,UserFrom:%String,CurrDate:%String,CurrTime:%String,UserTo:%String,PatInfoId:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,IsActive:%String,ResumeText:%String,Papmi:%String,PatitneNO:%String")
{
}

/// Creator：    刘学峰
/// CreatDate：  2011-03-09
/// Description：构造未完成操作打印列表数据
/// Query：      QueryExecutedStatus
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。DateFrom^DateTo^UserFrom^UserTo^WorkItem^Flg^MrType^DisWardID^cLocRowid^PrintFlag
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRStatusInfo).QueryMissVolumeToPrint(itmjs,strArguments)
ClassMethod QueryExecutedStatusToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s UserFrom=$p(strArguments,"^",3)
	s UserTo=$p(strArguments,"^",4)
	s WorkItem=$p(strArguments,"^",5)
	s Flg=$p(strArguments,"^",6)
	s MrType=$p(strArguments,"^",7)
	s DisWardID=$p(strArguments,"^",8)
	s cLocRowid=$p(strArguments,"^",9)
	s PrintFlag=$p(strArguments,"^",10)

	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRStatusInfo:QueryExecutedStatus")
	d ds.Execute(DateFrom, DateTo, UserFrom, UserTo, WorkItem, Flg , MrType,DisWardID,cLocRowid,PrintFlag)
	s StartRow=4
	while(ds.Next())
	{	
	//s val=rs.GetDataByName("MainORVolFlag") s:val=0 val="病案"  s:val=1 val="病案卷"
		s MainORVolFlag=ds.Data("MainORVolFlag")
		s:MainORVolFlag=0 MainORVolFlag="病案"
		s:MainORVolFlag=1 MainORVolFlag="病案卷"			//类型
		s MainNo=ds.Data("MainNo") 								//病案号
		s PapmiNo=ds.Data("PapmiNo")						//登记号
		s MainId=ds.Data("MainId")							
		s PatName=$p(##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+MainId),"^",2) //病人姓名
		s WorkItemDesc=ds.Data("WorkItemDesc")				//操作项目
		s CurrDate=ds.Data("CurrDate")						//操作日期
		s CurrTime=ds.Data("CurrTime")						//操作时间
		s UserFromDesc=ds.Data("UserFromDesc")				//操作人
		s CurrStatusDesc=ds.Data("CurrStatusDesc")			//当前状态

		//类型,病案号,登记号,姓名,操作项目,操作日期,操作时间,操作人,当前状态
		s valCells=MainORVolFlag_$c(1)_MainNo_$c(1)_PapmiNo_$c(1)_PatName_$c(1)_WorkItemDesc_$c(1)_CurrDate_$c(1)_CurrTime_$c(1)_UserFromDesc_$c(1)_CurrStatusDesc
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s DefaultHospStr=##class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospDesc=$p(DefaultHospStr,"^",3)
	s WorkItemDesc=$p($g(^DHCWMRWITM(+WorkItem)),"^",2)
	s valCells=HospDesc_" 已完成“"_WorkItemDesc_"”明细"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="操作日期："_$zd($zdh(DateFrom,4),3)_" 至 "_$zd($zdh(DateTo,4),3)_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

}
