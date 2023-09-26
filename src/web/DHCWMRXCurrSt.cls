Import SQLUser

/// 当前状态查询
Class web.DHCWMRXCurrSt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 106;

ClassMethod GetRows(JIndex, MrTypeDr, ItemDr, DetailDr, sValue, FromDate, ToDate, QryType, IsCurrSta)
{
	n (JIndex, MrTypeDr, ItemDr, DetailDr, sValue, FromDate, ToDate,QryType,IsCurrSta)
	s ret=0
	k ^CacheTemp("DHCWMRCurrRow",JIndex)
	
	q:(MrTypeDr="")||(ItemDr="")||(DetailDr="") ret
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s FromDate=+FromDate
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s ToDate=+ToDate
	
	;^DHCWMRMAIN(0,"SDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_Main.Rowid},"S",{ChildSub})
	i (QryType="")||(QryType="0") d
	.f tmpDate=FromDate:1:ToDate  d
	..q:'$d(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemDr))
	..s MainRowid=0
	..f  s MainRowid=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemDr,MainRowid)) q:MainRowid=""  d
	...s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
	...q:sTempMain=""
	...s xMrType=$p(sTempMain,"^",2)
	...q:MrTypeDr'=xMrType
	...s sTempIsActive=$p(sTempMain,"^",7)
	...q:(sTempIsActive'="Y")
	...//q:'$d(^DHCWMRMAIN(MainRowid,"Status",ItemDr))    ;有此操作项
	...//************add by zf 2009-04-07****************
	...s tmpSub="",CurrItem=""
    ...f  s tmpSub=$o(^DHCWMRMAIN(MainRowid,"S",tmpSub),-1) q:((+tmpSub)=0)||(CurrItem'="")  d
    ....s tmpStatus=$g(^DHCWMRMAIN(MainRowid,"S",tmpSub))
    ....q:$p(tmpStatus,"^",3)<1
    ....s CurrItem=$p(tmpStatus,"^",1)
    ...q:(IsCurrSta="Y")&&(ItemDr'=CurrItem)   //最后一个有效的状态就是当前状态
    ...//************************************************
	...//s stSub=$o(^DHCWMRMAIN(MainRowid,"S",""),-1)
	...//q:'$d(^DHCWMRMAIN(MainRowid,"Status",ItemDr,stSub))   ;最后一个操作项
	...s stSub=0
	...f  s stSub=$o(^DHCWMRMAIN(0,"SDateStatus",tmpDate,ItemDr,MainRowid,"S",stSub)) q:stSub=""  d
	....s dtlSub=0
	....f  s dtlSub=$o(^DHCWMRMAIN(MainRowid,"S",stSub,"D",dtlSub)) q:dtlSub=""  d
	.....s TmpDtlDr=$p($g(^DHCWMRMAIN(MainRowid,"S",stSub,"D",dtlSub)),"^",1)
	.....q:(TmpDtlDr'=DetailDr)
	.....s TmpValue=$p($g(^DHCWMRMAIN(MainRowid,"S",stSub,"D",dtlSub)),"^",2)
	.....s:'$d(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)) ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)=0
	.....s dtlCount=+$g(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue))
	.....s ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)=dtlCount+1
	.....s MainRet=MainRowid_"||"_stSub_"||"_dtlSub
	.....s VolRet=""
	.....;s:(sValue="")&(TmpValue'="") ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,dtlCount)=MainRet_"^"_VolRet
	.....s:(sValue'="")&(sValue=TmpValue) ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,dtlCount)=MainRet_"^"_VolRet
	
	
	;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	i (QryType="")||(QryType="1") d
	.f tmpDate=FromDate:1:ToDate  d
	..q:'$d(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr))
	..s VolRowid=0
	..f  s VolRowid=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr,VolRowid)) q:VolRowid=""  d
	...s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	...q:sVolume=""
	...s IsActive=$p(sVolume,"^",8)
	...q:IsActive'="Y"
	...s xMainId=$p(sVolume,"^",2)
	...s xMain=##class(web.DHCWMRMainCtl).GetMainById(+xMainId)
	...q:xMain=""
	...s xMrType=$p(xMain,"^",2)
	...q:MrTypeDr'=xMrType
	...s xIsActive=$p(xMain,"^",7)
	...q:(xIsActive'="Y")
	...//q:'$d(^DHCWMRVOL(VolRowid,"S",ItemDr))
	...//************add by zf 2009-04-07****************
    ...s tmpSub="",CurrItem=""
    ...f  s tmpSub=$o(^DHCWMRVOL(VolRowid,"S",tmpSub),-1) q:((+tmpSub)=0)||(CurrItem'="")  d
    ....s tmpStatus=$g(^DHCWMRVOL(VolRowid,"S",tmpSub))
    ....q:$p(tmpStatus,"^",3)<1
    ....s CurrItem=$p(tmpStatus,"^",1)
    ...q:(IsCurrSta="Y")&&(ItemDr'=CurrItem)   //最后一个有效的状态就是当前状态
    ...//************************************************
	...//s stSub=$o(^DHCWMRVOL(VolRowid,"S",""),-1)
	...//q:'$d(^DHCWMRVOL(+VolRowid,"S",0,"Status",ItemDr,stSub))
	...s stSub=0
	...f  s stSub=$o(^DHCWMRVOL(0,"VSDateStatus",tmpDate,ItemDr,VolRowid,stSub)) q:stSub=""  d
	....s dtlSub=0
	....f  s dtlSub=$o(^DHCWMRVOL(VolRowid,"S",stSub,"D",dtlSub)) q:dtlSub=""  d
	.....s TmpDtlDr=$p($g(^DHCWMRVOL(VolRowid,"S",stSub,"D",dtlSub)),"^",1)
	.....q:(TmpDtlDr'=DetailDr)
	.....s TmpValue=$p($g(^DHCWMRVOL(VolRowid,"S",stSub,"D",dtlSub)),"^",2)
	.....s:'$d(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)) ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)=0
	.....s dtlCount=+$g(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue))
	.....s ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)=dtlCount+1
	.....s MainRet=""
	.....s VolRet=VolRowid_"||"_stSub_"||"_dtlSub
	.....;s:(sValue="")&(TmpValue'="") ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,dtlCount)=MainRet_"^"_VolRet
	.....s:(sValue'="")&(sValue=TmpValue) ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,dtlCount)=MainRet_"^"_VolRet
	
	q ret
}

ClassMethod QueryByStaDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByStaDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByStaDtlExecute(ByRef qHandle As %Binary, MrTypeDr As %String, ItemDr As %String, DetailDr As %String, FromDate As %String, ToDate As %String, QryType As %String, IsCurrSta As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:((MrTypeDr="")||(ItemDr="")||(DetailDr="")) $$$OK
	q:(FromDate="")||(ToDate="") $$$OK
	
	s JIndex=$j
	k ^CacheTemp("DHCWMRCurrRow",JIndex)
	s ret=..GetRows(JIndex,MrTypeDr,ItemDr,DetailDr,"",FromDate,ToDate,QryType,IsCurrSta)
	
	;s ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)=dtlCount+1
	s TmpValue=""
	f  s TmpValue=$o(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)) q:TmpValue=""  d
	.s Data=$lb()
	.s $li(Data,1)=TmpValue
	.s $li(Data,2)=+$g(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue))
	.s $li(Data,3)=MrTypeDr
	.s $li(Data,4)=ItemDr
	.s $li(Data,5)=DetailDr
	.s $li(Data,6)=FromDate
	.s $li(Data,7)=ToDate
	.s $li(Data,8)=QryType
	.s $li(Data,9)=IsCurrSta
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	//k ^CacheTemp("DHCWMRCurrRow",JIndex)
	Quit $$$OK
}

ClassMethod QueryByStaDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByStaDtlExecute ]
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

/// 描述：根据病案类型，操作状态，附加项
/// 入参：MrTypeDr, ItemDr, DetailDr
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRXCurrSt","QueryByStaDtl","","","","","","","")
Query QueryByStaDtl(MrTypeDr As %String, ItemDr As %String, DetailDr As %String, FromDate As %String, ToDate As %String, QryType As %String, IsCurrSta As %String) As %Query(ROWSPEC = "DtlValue:%String,DtlValueCount:%String,MrTypeDr:%String,ItemDr:%String,DetailDr:%String,FromDate:%String,ToDate:%String,QryType:%String,IsCurrSta:%String")
{
}

ClassMethod BuildDataDetail(repid, ind, MainRet, VolRet)
{
	n (repid,ind,MainRet,VolRet)
	
	s MainId="",VolId="",MainStaId="",VolStaId=""
	i MainRet'="" d     //病案
	.s MainId=$p(MainRet,"||",1)
	.s ChildSub=$p(MainRet,"||",2)
	.s StatusInfo=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,ChildSub)
	.s MainStaId=$p(StatusInfo,"^",1)
	i VolRet'="" d     //病案卷
	.s VolId=$p(VolRet,"||",1)
	.s ChildSub=$p(VolRet,"||",2)
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
 	set ItemTypeDesc=""
 	set ItemTypeId=+$p(WorkItem,"/",2)
 	Set:ItemTypeId'=0 ItemTypeDesc=$p($g(^DHCWMRDIC(ItemTypeId)),"^",3)
 	Set $li(Data,15)=ItemTypeDesc           ;SysOperDesc
 	
 	//如果为病案卷查询显示最后一次评价的信息
 	//如果为病案查询显示空
 	s StatusEvaInfo=$g(StatusEvaInfo)
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
 	s:VolId'="" Flag=1
 	s:VolId="" Flag=0
 	set $li(Data,22)=Flag                   ;区分标记 0--病案   1--病案卷
 	Set $li(Data,23)=MainId                 ;MainId
 	Set $li(Data,24)=VolId                  ;VolId
 	Set $li(Data,25)=MainStaId              ;MainStaId
 	Set $li(Data,26)=VolStaId               ;VolStaId
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod GetMRInfo(MainId, VolId)
{
	n (MainId, VolId)
	s ret=$lb()
	
	s (MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)=""
	
	i MainId'="" d
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.s Papmi=$p(tmpMain,"^",3)
	.q:Papmi=""
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
    .s IsDeath=$s(IsDeath="Y":"已故",1:"")
	.s RegNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)
    .s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
    .s MrTypeId=$p(tmpMain,"^",1)
    .s MrTypeDesc=$s(MrTypeId'="":$p($g(^DHCWMRDIC(+MrTypeId)),"^",3),1:"")
    .s MrNo=$p(tmpMain,"^",2)
    .s tmpSub="",CurrItem=""
    .f  s tmpSub=$o(^DHCWMRMAIN(MainId,"S",tmpSub),-1) q:((+tmpSub)=0)||(CurrItem'="")  d
    ..s tmpStatus=$g(^DHCWMRMAIN(MainId,"S",tmpSub))
    ..q:$p(tmpStatus,"^",3)<1
    ..s CurrStatusId=$p(tmpStatus,"^",1)
    ..s CurrStatusDesc=$p($g(^DHCWMRWITM(+CurrStatusId)),"^",2)
    .s ret=$lb(MainId,VolId,MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)
	
	i VolId'="" d
	.s tmpVol=$g(^DHCWMRVOL(+VolId))
	.q:tmpVol=""
	.s MainId=$p(tmpVol,"^",1)
	.s tmpMain=$g(^DHCWMRMAIN(+MainId))
	.s Paadm=$p(tmpVol,"^",2)
	.s tmpADM=$g(^PAADM(+Paadm))
	.s Papmi=$p(tmpADM,"^",1)
	.s CurrStatusId=$p(tmpVol,"^",6)
	.s CurrStatusDesc=$p($g(^DHCWMRWITM(+CurrStatusId)),"^",2)
	.s LocId=$p(tmpADM,"^",4)
	.s LocDesc=$s(LocId'="":$p($g(^CTLOC(+LocId)),"^",2),1:"")
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s WardId=$p(tmpADM,"^",70)
	.s WardDesc=$s(WardId'="":$p($g(^PAWARD(+WardId)),"^",2),1:"")
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s AdmDate=$zd($p(tmpADM,"^",6),3)
	.s AdmTime=$zt($p(tmpADM,"^",7),2)
    .s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    .s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
    .s IsDeath=$s(IsDeath="Y":"已故",1:"")
	.s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
    .s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
    .s MrTypeId=$p(tmpMain,"^",1)
    .s MrTypeDesc=$s(MrTypeId'="":$p($g(^DHCWMRDIC(+MrTypeId)),"^",3),1:"")
    .s MrNo=$p(tmpMain,"^",2)
    .s IPNo=$p(tmpADM,"^",81)
	.s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	.s:$p(Hosp,"/",4)="ChengDu_HX" MrNo=IPNo
    .s ret=$lb(MainId,VolId,MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)
    
    q ret
}

ClassMethod QueryByStaDtlValClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByStaDtlValExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByStaDtlValExecute(ByRef qHandle As %Binary, MrTypeDr As %String, ItemDr As %String, DetailDr As %String, sValue As %String, FromDate As %String, ToDate As %String, QryType As %String, IsCurrSta As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:((MrTypeDr="")||(ItemDr="")||(DetailDr="")||(sValue="")) $$$OK
	q:(FromDate="")||(ToDate="") $$$OK
	
	s JIndex=$j
	k ^CacheTemp("DHCWMRCurrRow",JIndex)
    s ret=..GetRows(JIndex,MrTypeDr,ItemDr,DetailDr,sValue,FromDate,ToDate,QryType,IsCurrSta)
	
	;s ^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,dtlCount)=MainRet_"^"_VolRet
	s TmpValue=""
	f  s TmpValue=$o(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue)) q:TmpValue=""  d
	.s num=""
	.f  s num=$o(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,num)) q:num=""  d
	..s Ret=$g(^CacheTemp("DHCWMRCurrRow",JIndex,TmpValue,num))
	..s MainRet=$p(Ret,"^",1)
	..s VolRet=$p(Ret,"^",2)
	..s MainID=$p(MainRet,"||",1)
	..s VolID=$p(VolRet,"||",1)
	..s Data=..GetMRInfo(MainID,VolID)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	//k ^CacheTemp("DHCWMRCurrRow",JIndex)
	Quit $$$OK
}

ClassMethod QueryByStaDtlValFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByStaDtlValExecute ]
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

/// ****************************************
/// 描述：根据病案类型，操作状态，附加项，附加项值 查询此下包含的目录明细
/// 入参：MrTypeDr, ItemDr, DetailDr，sValue，FromDate，ToDate，QryType，IsCurrSta
/// ****************************************
/// Query QueryByStaDtlVal(MrTypeDr As %String, ItemDr As %String, DetailDr As %String, sValue As %String, FromDate As %String, ToDate As %String, QryType As %String, IsCurrSta As %String) As %Query(ROWSPEC = "RowId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String,StatusEvaId:%String,StatusEvaDesc:%String,MainTypeId:%String,MainType:%String,MainNo:%String,MainDate:%String,MainORVolFlag:%String,MainId:%String,VolId:%String,MainStaId:%String,VolStaId:%String")
Query QueryByStaDtlVal(MrTypeDr As %String, ItemDr As %String, DetailDr As %String, sValue As %String, FromDate As %String, ToDate As %String, QryType As %String, IsCurrSta As %String) As %Query(ROWSPEC = "MainId:%String,VolId:%String, MrTypeId:%String, MrTypeDesc:%String,MrNo:%String,RegNo:%String,PatName:%String,IsDeath:%String,Papmi:%String,Paadm:%String,LocId:%String,LocDesc:%String,WardId:%String,WardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,CurrStatusId:%String,CurrStatusDesc:%String")
{
}

}
