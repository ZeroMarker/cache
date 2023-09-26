Import SQLUser

/// 卷目录查询
Class web.DHCWMRVolumeContQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

/// ****************************************
/// 入参：VolRowid,ContRowid(目录大类)
/// 根据医嘱项目 查询目录子类内容
/// ****************************************
ClassMethod GetContents(JIndex, VolRowid, ContRowid)
{
	n (JIndex, VolRowid, ContRowid)
	s ret=0
	s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	s paadm=$p(sVolume,"^",3)
	q:paadm="" ret
	q:'$d(^DHCWMRVOL(VolRowid,"ADM")) ret
	;查询必需项目子类
	;^DHCWMRCNT(0,"Req",{IsRequest},{DHC_WMR_Contents.Rowid},{ChildSub})
	i $d(^DHCWMRCNT(0,"Req","Y")) d
	.s tContRowid=0
	.f  s tContRowid=$o(^DHCWMRCNT(0,"Req","Y",tContRowid)) q:tContRowid=""  d
	..q:((ContRowid'="")&&(ContRowid'=tContRowid))
	..s ContSub=0
	..f  s ContSub=$o(^DHCWMRCNT(0,"Req","Y",tContRowid,ContSub)) q:ContSub=""  d
	...s ^CacheTemp(JIndex,"DHCWMRVolCont",tContRowid,ContSub)=""
	
	;q:ContRowid="" ret
    ;查询医嘱项目
	s VolAdmSub=0
	f  s VolAdmSub=$o(^DHCWMRVOL(VolRowid,"ADM",VolAdmSub)) q:VolAdmSub=""  d
	.s paadm=+$g(^DHCWMRVOL(VolRowid,"ADM",VolAdmSub))
	.q:'$d(^OEORD(0,"Adm",paadm))
	.s oeord=0
	.f  s oeord=$o(^OEORD(0,"Adm",paadm,oeord)) q:oeord=""  d
	..s oeoriSub=0
	..f  s oeoriSub=$o(^OEORD(oeord,"I",oeoriSub)) q:oeoriSub=""  d
	...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
	...s flag=$$CheckStatus(ItemStatDR)
	...q:flag'=0
	...s flag=$$BuildContDetail(JIndex,oeord,oeoriSub,ContRowid)
	q ret
	
CheckStatus(ItemStatDR)
    n (ItemStatDR)
    s flag=0
    s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    s:OrderStatusCode="D" flag=-1   ;停止
    s:OrderStatusCode="S" flag=-1   ;暂缓
	q flag
BuildContDetail(JIndex,oeord,oeoriSub,ContRowid)
    n (JIndex,oeord,oeoriSub,ContRowid)
    s flag=0
    s arcim=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",2)
	s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
	s ArcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
	s ordDate=$zd($p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",7),3)
	s orori=+oeord_"||"_+oeoriSub
	s ContDetail=ArcimDesc_"^"_ordDate
    
	i ContRowid'="" d
	.s ContRowid=+ContRowid
	.;s ContSub=+$p(ContSubRowid,"||",2)
	.i $d(^DHCWMRCNT(0,"ARCIM",arcim,ContRowid))  d
	..s ContSub=0
	..f  s ContSub=$o(^DHCWMRCNT(0,"ARCIM",arcim,ContRowid,ContSub)) q:ContSub=""  d
	...s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
	.i $d(^DHCWMRCNT(0,"ITEMCAT",ItmCat,ContRowid))  d
	..s ContSub=0
	..f  s ContSub=$o(^DHCWMRCNT(0,"ITEMCAT",ItmCat,ContRowid,ContSub)) q:ContSub=""  d
	...s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
	e  d
	.i $d(^DHCWMRCNT(0,"ARCIM",arcim)) d
	..s ContRowid=0
	..f  s ContRowid=$o(^DHCWMRCNT(0,"ARCIM",arcim,ContRowid)) q:ContRowid=""  d
	...s ContSub=0
	...f  s ContSubRowid=$o(^DHCWMRCNT(0,"ARCIM",arcim,ContRowid,ContSub)) q:ContSub=""  d
	....s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
	.i $d(^DHCWMRCNT(0,"ITEMCAT",ItmCat)) d
	..s ContRowid=0
	..f  s ContRowid=$o(^DHCWMRCNT(0,"ITEMCAT",ItmCat,ContRowid)) q:ContRowid=""  d
	...s ContSub=0
	...f  s ContSub=$o(^DHCWMRCNT(0,"ITEMCAT",ItmCat,ContRowid,ContSub)) q:ContSub=""  d
	....s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
    q flag
}

ClassMethod QueryContClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryContExecute(ByRef qHandle As %Binary, VolRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:'$d(^DHCWMRVOL(VolRowid)) $$$OK
	q:'$d(^DHCWMRCNT) $$$OK
	s JIndex=$j
	k ^CacheTemp(JIndex,"DHCWMRVolCont")
	s ret=..GetContents(JIndex,VolRowid,"")
	
	;s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
	s ContRowid=0
	f  s ContRowid=$o(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid)) q:ContRowid=""  d
	.s Data=$lb()
	.s $li(Data,1)=+ContRowid
	.s $li(Data,2)=$p($g(^DHCWMRCNT(+ContRowid )),"^",2)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	k ^CacheTemp(JIndex,"DHCWMRVolCont")
	Quit $$$OK
}

ClassMethod QueryContFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContExecute ]
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
/// 描述：根据卷rowid查询此卷包含的病案目录大类
/// 入参：VolRowid
/// ****************************************
Query QueryCont(VolRowid As %String) As %Query(ROWSPEC = "ContRowid:%String,ContDesc:%String")
{
}

ClassMethod QueryContSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryContSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryContSubExecute(ByRef qHandle As %Binary, VolRowid As %String, ContRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s JIndex=$j
	k ^CacheTemp(JIndex,"DHCWMRVolCont")

	s ret=..GetContents(JIndex,VolRowid,ContRowid)
	k:'$d(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid)) ^CacheTemp(JIndex,"DHCWMRVolCont")
	q:'$d(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid)) $$$OK
	
	;s ^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,orori)=ContDetail
	
	;s ContRowid=0
	;f  s ContRowid=$o(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid)) q:ContRowid=""  d
	s ContSub=0
	f  s ContSub=$o(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub)) q:ContSub=""  d
	.;"ContSubRowid,ContSubDesc,IsRequest,oeori,ArcimDesc,OrdDate"
	.s ContSubRowid=ContRowid_"||"_ContSub
	.s ContSubDesc=$p($g(^DHCWMRCNT(ContRowid,"S",ContSub)),"^",2)
	.s IsRequest=$p($g(^DHCWMRCNT(ContRowid,"S",ContSub)),"^",3)
	.s Data=$lb(ContSubRowid,ContSubDesc,IsRequest,"","","")
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.s oeori=0
	.f  s oeori=$o(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,oeori)) q:oeori=""  d
	..;s ContDetail=ArcimDesc_"^"_ordDate
	..s ContDetail=$g(^CacheTemp(JIndex,"DHCWMRVolCont",ContRowid,ContSub,oeori))
	..s ArcimDesc=$p(ContDetail,"^",1)
	..s ordDate=$p(ContDetail,"^",2)
	..s Data=$lb(ContSubRowid,"","",oeori,ArcimDesc,ordDate)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	k ^CacheTemp(JIndex,"DHCWMRVolCont")
	Quit $$$OK
}

ClassMethod QueryContSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryContSubExecute ]
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
/// 描述：根据卷rowid和目录大类rowid 查询此下包含的目录明细
/// 入参：VolRowid
///     : ContRowid
/// ****************************************
Query QueryContSub(VolRowid As %String, ContRowid As %String) As %Query(ROWSPEC = "ContSubRowid:%String,ContSubDesc:%String,IsRequest:%String,oeori:%String,ArcimDesc:%String,OrdDate:%String")
{
}

}
