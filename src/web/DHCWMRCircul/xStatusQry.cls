Import SQLUser

Class web.DHCWMRCircul.xStatusQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 72;

ClassMethod GetMRInfo(MainId, VolId)
{
	n (MainId, VolId)
	s ret=$lb()
	
	s (MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)=""
	
	i MainId'="" d
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.s Papmi=$p(tmpMain,"^",3)
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
    .s IsDeath=$s(IsDeath="Y":"已故",1:"")
	.s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
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

ClassMethod GetByExeStatus(JIndex, MrType, DateFrom, DateTo, UserFrom, UserTo, ItemId, QryType, IsCurrStatus)
{
	n (JIndex, MrType, DateFrom, DateTo, UserFrom, UserTo, ItemId, QryType,IsCurrStatus)
	s Count=0
	
	q:(DateFrom="")||(DateTo="")||(ItemId="")||(MrType="") Count
	
	i (QryType="")||(QryType="0") d
	.f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRMAIN(0,"SDateStatus",Date,ItemId))
    ..s MainId=0
    ..f  s MainId=$o(^DHCWMRMAIN(0,"SDateStatus",Date,ItemId,MainId)) q:MainId=""  d
	...s MainInfo=$g(^DHCWMRMAIN(MainId))
	...q:$p(MainInfo,"^",6)'="Y"
	...q:(MrType'="")&&($p(MainInfo,"^",1)'=MrType)
    ...s ChildSub=0
    ...f  s ChildSub=$o(^DHCWMRMAIN(0,"SDateStatus",Date,ItemId,MainId,"S",ChildSub)) q:ChildSub=""  d
    ....s MainStatus=$g(^DHCWMRMAIN(MainId,"S",ChildSub))
    ....q:MainStatus=""
    ....q:((UserFrom'="")&&($p(MainStatus,"^",2)'=UserFrom))
    ....q:((UserTo'="")&&($p(MainStatus,"^",5)'=UserTo))
    ....s tmpSub="",CurrItem=""
    ....f  s tmpSub=$o(^DHCWMRMAIN(MainId,"S",tmpSub),-1) q:((+tmpSub)=0)||(CurrItem'="")  d
    .....s tmpStatus=$g(^DHCWMRMAIN(MainId,"S",tmpSub))
    .....q:$p(tmpStatus,"^",3)<1
    .....s CurrItem=$p(tmpStatus,"^",1)
    ....q:(IsCurrStatus="Y")&&(ItemId'=CurrItem)   //最后一个有效的状态就是当前状态
    ....s ^CacheTemp("DoStatusQuery",JIndex,0,MainId,ChildSub)=""
    ....s Count=Count+1
    
    i (QryType="")||(QryType="1") d
    .f Date=DateFrom:1:DateTo d
	..q:'$d(^DHCWMRVOL(0,"VSDateStatus",Date,ItemId))
    ..s VolId=0
    ..f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",Date,ItemId,VolId)) q:VolId=""  d
	...s VolInfo=$g(^DHCWMRVOL(VolId))
	...q:$p(VolInfo,"^",7)'="Y"
	...s MainId=$p(VolInfo,"^",1)
	...s MainInfo=$g(^DHCWMRMAIN(+MainId))
	...q:$p(MainInfo,"^",6)'="Y"
	...q:(MrType'="")&&($p(MainInfo,"^",1)'=MrType)
    ...s tmpSub="",CurrItem=""
    ...f  s tmpSub=$o(^DHCWMRVOL(VolId,"S",tmpSub),-1) q:((+tmpSub)=0)||(CurrItem'="")  d
    ....s tmpStatus=$g(^DHCWMRVOL(VolId,"S",tmpSub))
    ....q:$p(tmpStatus,"^",3)<1
    ....s CurrItem=$p(tmpStatus,"^",1)
    ...q:(IsCurrStatus="Y")&&(ItemId'=CurrItem)   //最后一个有效的状态就是当前状态
    ...s ChildSub=0
    ...f  s ChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",Date,ItemId,VolId,ChildSub)) q:ChildSub=""  d
    ....q:'$d(^DHCWMRVOL(VolId,"S",ChildSub))
    ....s VolumeStatus=$g(^DHCWMRVOL(VolId,"S",ChildSub))
    ....q:((UserFrom'="")&&($p(VolumeStatus,"^",2)'=UserFrom))
    ....q:((UserTo'="")&&($p(VolumeStatus,"^",5)'=UserTo))
    ....s ^CacheTemp("DoStatusQuery",JIndex,1,VolId,ChildSub)=""
    ....s Count=Count+1
    
    q Count
}

ClassMethod QueryByExeStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByExeStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByExeStatusExecute(ByRef qHandle As %Binary, MrType As %String, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, ItemId As %String, QryType As %String, IsCurrStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MrType="" $$$OK
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s DateFrom=+DateFrom
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s DateTo=+DateTo
	
	s JIndex=$j
	k ^CacheTemp("DoStatusQuery",JIndex)
	s flg=..GetByExeStatus(JIndex,MrType,DateFrom,DateTo,UserFrom,UserTo,ItemId,QryType,IsCurrStatus)
	
	s flg=""
	f  s flg=$o(^CacheTemp("DoStatusQuery",JIndex,flg)) q:flg=""  d
	.s Rowid=0
	.f  s Rowid=$o(^CacheTemp("DoStatusQuery",JIndex,flg,Rowid)) q:Rowid=""  d
	..s SubId=0
	..f  s SubId=$o(^CacheTemp("DoStatusQuery",JIndex,flg,Rowid,SubId)) q:SubId=""  d
	...s:flg=0 tmpStatus=$g(^DHCWMRMAIN(Rowid,"S",SubId))  //病案状态信息
	...s:flg=1 tmpStatus=$g(^DHCWMRVOL(Rowid,"S",SubId))   //卷状态信息
	...q:tmpStatus=""
	...s StaDesc=$p($g(^DHCWMRWITM(+$p(tmpStatus,"^",1))),"^",2)
	...s UserFrom=$p($g(^SSU("SSUSR",+$p(tmpStatus,"^",2))),"^",2)
	...s DateFrom=$zd(+$p(tmpStatus,"^",3),3)
	...s DateTo=$zt(+$p(tmpStatus,"^",4),2)
	...s UserTo=$p($g(^SSU("SSUSR",+$p(tmpStatus,"^",5))),"^",2)
	...s Data1=$lb(StaDesc,UserFrom,DateFrom,DateTo,UserTo)
	...s:flg=0 Data2=..GetMRInfo(Rowid,"")  //查询病案ID查询病案信息
	...s:flg=1 Data2=..GetMRInfo("",Rowid)  //通过卷ID查询病案信息
	...s Data=Data1_Data2
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	k ^CacheTemp("DoStatusQuery",JIndex)
    q $$$OK
}

ClassMethod QueryByExeStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByExeStatusExecute ]
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

/// *****************************************************
/// 说明          : 已完成状态查询
/// 参数          : 
/// MrType        : 病案类型
/// ItemId        : 操作项ID
/// DateFrom      : 开始日期
/// DateTo        : 结束日期
/// UserFrom      : 转交人
/// UserTo        : 接收人
/// QryType       : 查询类型 “”-病案和卷  0-病案  1-卷
/// IsCurrStatus  : 是否当前状态
/// 调试          : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.xStatusQry","QueryByExeStatus","7","2009-04-05","2009-04-05","","","2","1","")
/// ******************************************************
Query QueryByExeStatus(MrType As %String, DateFrom As %String, DateTo As %String, UserFrom As %String, UserTo As %String, ItemId As %String, QryType As %String, IsCurrStatus As %String) As %Query(ROWSPEC = "StaDesc:%String,UserFrom:%String,DateFrom:%String,DateTo:%String,UserTo:%String,MainId:%String,VolId:%String, MrTypeId:%String, MrTypeDesc:%String,MrNo:%String,RegNo:%String,PatName:%String,IsDeath:%String,Papmi:%String,Paadm:%String,LocId:%String,LocDesc:%String,WardId:%String,WardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,CurrStatusId:%String,CurrStatusDesc:%String")
{
}

}
