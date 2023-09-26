Import SQLUSER

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 治疗记录单相关程序
/// Modify:nk 此类已废弃不用，标版删除 20201110
Class web.DHCDocCureAppUtil Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断医嘱是否是治疗项目
ClassMethod CheckItem(ItemMaststr, ItemCatId, LocId)
{
	s Flag=0
	q:(ItemMaststr="")||(LocId="") 0
	for len=1:1:$l(ItemMaststr,"^"){
		s ItemMast=$p(ItemMaststr,"^",len)
		s ItemCatId=$p($G(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1)),"^",10)
		if ($d(^DHCDocConfig("DHCDocCureClinicLoc",LocId,"ItemCat"))){
			if ($d(^DHCDocConfig("DHCDocCureClinicLoc",LocId,"ItemCat",ItemCatId))){
				if ($d(^DHCDocConfig("DHCDocCureClinicLoc",LocId,"ItemCat",ItemCatId,"Item"))){
				
					s:$d(^DHCDocConfig("DHCDocCureClinicLoc",LocId,"ItemCat",ItemCatId,"Item",ItemMast)) Flag=1
				
				}else{
					
					s Flag=1
					
				}
			}	
		}
	}
	q Flag
}

/// Creator：      郭宝平
/// CreatDate：    2015-03-03
/// Description:： 查询需要填申请单的医嘱治疗科室列表     
/// Input：         ArcimId:医嘱项ID
Query FindCureLocList(EpisodeID As %String, UserID As %String) As %Query(ROWSPEC = "CureLocId:%String,CureLocDesc:%String")
{
}

ClassMethod FindCureLocListExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureLocList",450776,"")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if EpisodeID="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    s Order=$o(^OEORD(0,"Adm",EpisodeID,""))
    if Order="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
    k ^TMP("FindCureLocList",EpisodeID)
    s CureLocStr=""
    s CureOrdCatStr=$g(^DHCDocConfig("DHCDocCureOrdCat"))
    s LocId=%session.Get("LOGON.CTLOCID")
    s ItemMastId=""  for  set ItemMastId=$o(^OEORDi(0,"ARCIM",Order,ItemMastId)) q:ItemMastId=""  d
    .s OrderSttDate=""  for  set OrderSttDate=$o(^OEORDi(0,"ARCIM",Order,ItemMastId,OrderSttDate)) q:OrderSttDate=""  d
	..s OrderChild=""  for  set OrderChild=$o(^OEORDi(0,"ARCIM",Order,ItemMastId,OrderSttDate,OrderChild)) q:OrderChild=""  d
	...s ItemMast=$p($G(^OEORD(Order,"I",OrderChild,1)),"^",2)
	...s ItemCatId=$p($G(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1)),"^",10)
	...s CheckItemFlag=..CheckItem(ItemMast,ItemCatId,LocId)
	...q:(CheckItemFlag=0)
	...s ItemStat=$p($G(^OEORD(Order,"I",OrderChild,1)),"^",13)
	...s:ItemStat'="" ItemStat=$p($g(^OEC("OSTAT",ItemStat)),"^",1)
	...q:(ItemStat'="V")
	...s UserAdd=$p($g(^OEORD(Order,"I",OrderChild,7)),"^",1)
	...q:(UserID'="")&&(UserID'=UserAdd)
	...s ItemCatRowid=$p($g(^ARCIM(+ItemMastId,$p(ItemMastId,"||",2),1)),"^",10)
	...s ReLocRowid=$p($g(^OEORD(Order,"I",OrderChild,3)),"^",6)
	...s OrderRowId=Order_"||"_OrderChild
	...s FindFlag=0
	...s DCARowId=""  for  set DCARowId=$o(^DHCDocCure(0,"OEORI",OrderRowId,DCARowId)) q:(DCARowId="")||(FindFlag=1)  d
	....s DCAStatus=$p($g(^DHCDocCure(DCARowId)),"^",4)
	....Q:DCAStatus="C"  //取消的申请单
	....s FindFlag=1
	...Q:FindFlag=1
	...b ;end
	...if CureLocStr="" s CureLocStr=ReLocRowid
	...else  if ("^"_CureLocStr_"^")'[("^"_ReLocRowid_"^") s CureLocStr=CureLocStr_"^"_ReLocRowid
	...s ^TMP("FindCureLocList",EpisodeID,ReLocRowid,OrderRowId)=""
	for i=1:1:$l(CureLocStr,"^")  d
	.s CureLocId=$p(CureLocStr,"^",i)
	.q:CureLocId=""
	.s CureLocDesc=$p($g(^CTLOC(CureLocId)),"^",2)
	.;s CureLocDesc=..TR(CureLocDesc)	
	.s CureLocDesc=..EvalJSON(CureLocDesc)	
	.Do OutputRowFindCureLocList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureLocList
	set Data=$lb($g(CureLocId),$g(CureLocDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindPatCureApplyList(EpisodeID As %String, UserID As %String) As %Query(ROWSPEC = "DCARowId:%String,DCAApplyNo:%String,DCAAppDate:%String,DCAStatus:%String")
{
}

ClassMethod FindPatCureApplyListExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindPatCureApplyList")
	s ^lttmp("FindPatCureApplyList")=EpisodeID_"^"_UserID
	Set repid=$I(^CacheTemp)
    Set ind=1
    if EpisodeID="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s DCARowId=""  for  set DCARowId=$o(^DHCDocCure(0,"Adm",EpisodeID,DCARowId)) q:(DCARowId="")  d
	.s DCAStatus=$p($g(^DHCDocCure(DCARowId)),"^",4)
	.s DCAStatus=$case(DCAStatus,"A":"申请","C":"取消","R":"接收","J":"拒收",:"")
	.s DCAApplyNo=$p($g(^DHCDocCure(DCARowId)),"^",2)
	.s DCAUserDR=$p($g(^DHCDocCure(DCARowId)),"^",5)
	.q:(UserID'="")&&(DCAUserDR'=UserID)
	.s DCAAppDate=$p($g(^DHCDocCure(DCARowId)),"^",6)
	.s DCAAppTime=$p($g(^DHCDocCure(DCARowId)),"^",7)
	.s:DCAAppDate'="" DCAAppDate=$zd(DCAAppDate,3)
	.s:DCAAppTime'="" DCAAppTime=..%ZT(DCAAppTime,1)
	.if DCAAppDate'="" s DCAAppDate=DCAAppDate_" "_DCAAppTime	
	.Do OutputRowFindPatCureApplyList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPatCureApplyList
	set Data=$lb($g(DCARowId),$g(DCAApplyNo),$g(DCAAppDate),$g(DCAStatus))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPatCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatCureApplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询治疗科室下当前未申请的或者申请单内包含的治疗项目  
/// Input：        Loc:治疗科室ID ApplyID 申请单ID 
Query FindCureItem(EpisodeID As %String, Loc As %String, ApplyID As %String = "") As %Query(ROWSPEC = "OEORIRowId:%String,ArcimDesc:%String,Price:%String,Qty:%String,Uom:%String,Sum:%String,RecLoc:%String")
{
}

ClassMethod FindCureItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, Loc As %String, ApplyID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureItem")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (EpisodeID="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
    if (Loc="")&&(ApplyID="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
    
    if ApplyID'="" 
    {
	   
	    s CureItemId=0  for  set CureItemId=$o(^DHCDocCure(ApplyID,"CureItem",CureItemId)) q:CureItemId=""  d
	    .s CureItemOEORI=$p(^DHCDocCure(ApplyID,"CureItem",CureItemId),"^")
	    .q:CureItemOEORI=""
	    .s OrdDetail=..GetOrdDetail(CureItemOEORI)
	    .s OEORIRowId=CureItemOEORI
	    .s ArcimDesc=$p(OrdDetail,"^")
	    .s Price=$p(OrdDetail,"^",13)
	    .s Qty=$p(OrdDetail,"^",4)
	    .s Uom=$p(OrdDetail,"^",3)
	    .s Sum=$p(OrdDetail,"^",5)
	    .s RecLoc=$p(OrdDetail,"^",15)
	    .Do OutputRow
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ReLocRowid=""  for  set ReLocRowid=$o(^TMP("FindCureLocList",EpisodeID,ReLocRowid)) q:ReLocRowid=""  d
    .Q:(Loc'="")&&(Loc'=ReLocRowid)
    .s OrderRowId=""  for  set OrderRowId=$o(^TMP("FindCureLocList",EpisodeID,ReLocRowid,OrderRowId)) q:OrderRowId=""  d
	..s OEORIRowId=OrderRowId
	..s OrdDetail=..GetOrdDetail(OEORIRowId)
	..s ArcimDesc=$p(OrdDetail,"^")
	..s Price=$p(OrdDetail,"^",13)
	..s Qty=$p(OrdDetail,"^",4)
	..s Uom=$p(OrdDetail,"^",3)
	..s Sum=$p(OrdDetail,"^",5)
	..s RecLoc=$p(OrdDetail,"^",16)
	..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb($g(OEORIRowId),$g(ArcimDesc),$g(Price),$g(Qty),$g(Uom),$g(Sum),$g(RecLoc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:： 查询治疗单对应的治疗项目 
/// Input：        DCARowId
Query FindApplyItemList(DCARowId As %String) As %Query(ROWSPEC = "OEORIRowId:%String,ARCIMDesc:%String,RelocId:%String,DCALocDesc:%String,DCARowId:%String")
{
}

ClassMethod FindApplyItemListExecute(ByRef qHandle As %Binary, DCARowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindApplyItemList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (DCARowId="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s sql="select DCAC_OEORI_DR AS OEORIRowId from DHC_DocCureAppCureItem where DCAC_ParRef="_DCARowId
	set rst=##class(%Library.ResultSet).%New()
	do rst.Prepare(sql)
	do rst.Execute()
	while(rst.Next())
	{
		s OEORIRowId1=rst.Data("OEORIRowId")
		i OEORIRowId1["||" d
		.s OEORIItmMastDR=$p(^OEORD($p(OEORIRowId1,"||",1),"I",$p(OEORIRowId1,"||",2),1),"^",2)
		.s ARCIMDesc=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2)
		.s OEORIRowId=OEORIRowId1
		.s RelocId=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",6)
		.s:RelocId'="" DCALocDesc=$p(^CTLOC(RelocId),"^",2)
		.d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(OEORIRowId,ARCIMDesc,RelocId,DCALocDesc,DCARowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindApplyItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApplyItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApplyItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApplyItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询病人治疗申请单列表
/// Table: 		  DHC_DocCureApp
/// Input：        cardType:卡类型ID,cardNo:卡号,patNo:登记号 sttDate:开始日期 yyyy-mm-dd endDate:结束日期 yyyy-mm-dd
/// Query FindCureApplyList(cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String) As %Query(ROWSPEC = "DCARowId:%String,RelocId:%String,Qty:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatType:%String,PatTel:%String,PatAddress:%String,DCAArcimDesc:%String,DCALocDesc:%String,DCAAppendArcimDesc:%String,DCATimes:%String,DCAUser:%String,DCAAppDate:%String,DCARemark:%String")
Query FindCureApplyList(cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String) As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatType:%String,PatTel:%String,PatAddress:%String,DCAApplyNo:%String,DCAUser:%String,DCAAppDate:%String,DCAAppPlan:%String,DCARemark:%String")
{
}

ClassMethod FindCureApplyListExecute(ByRef qHandle As %Binary, cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureApplyList",)
	Set repid=$I(^CacheTemp)
	Set ind=1
	if sttDate="" s sttDate=..%SysDate()
	else  s sttDate=$zdh(sttDate,3)
	if endDate="" s endDate=..%SysDate()
	else  s endDate=$zdh(endDate,3)
	s PatientID=""
	if (cardType'="")&&(cardNo'="") 
	{
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(cardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0")  d
		.s PatientID=$P(ret,"^",8)
	}
	if PatientID=""
	{
		if patNo'=""  d
		.Set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(patNo,"U"),0))
		b
	}
	if ((cardNo'="")||(patNo'=""))&&(PatientID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	b ;ggg
	f ApplyDate=sttDate:1:endDate  d
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",ApplyDate,DCARowId)) q:DCARowId=""  d
	..Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	..q:CureAppInfo=""
	..Set AdmId=$p(CureAppInfo,"^",1) 
	..s VisitStatus=$p($g(^PAADM(AdmId)),"^",20)
	..Q:VisitStatus'="A"
	..s myPatientID=$P(^PAADM(AdmId),"^",1)
	..q:(PatientID'="")&&(PatientID'=myPatientID)
	..d OutputRowApply
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApply
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	q:CureAppInfo=""
	Set AdmId=$p(CureAppInfo,"^",1) 
	s myPatientID=$P(^PAADM(AdmId),"^",1)
	s Patinfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(myPatientID)
	s PatNo=$p(Patinfo,"^",2)
	s PatName=$p(Patinfo,"^",3)
	s PatSex=$p(Patinfo,"^",4)
	s PatAge=$p(Patinfo,"^",5)
	s PatType=$p(Patinfo,"^",7)
	s PatTel=$p(Patinfo,"^",25)
	s PatAddress=$p(Patinfo,"^",11)
	s DCARowId=DCARowId
	s DCAApplyNo=$p(CureAppInfo,"^",2)
	S DCAUser=$p(CureAppInfo,"^",5)
	S:DCAUser'="" DCAUser=$P(^SSU("SSUSR",DCAUser),"^",2)
	S DCAAppDate=$p(CureAppInfo,"^",6)
	s DCAAppDate=$zd(DCAAppDate,3)
	s DCAAppPlan=$p(CureAppInfo,"^",11)
	S DCARemark=$p(CureAppInfo,"^",12)
	set Data=$lb(DCARowId,PatNo,PatName,PatSex,PatAge,PatType,PatTel,PatAddress,DCAApplyNo,DCAUser,DCAAppDate,DCAAppPlan,DCARemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindCardType() As %Query(ROWSPEC = "CardTypeId:%String,CardTypeDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCardType")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s myTypeID=0 f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" s Default=1
	.else  s Default=0
	.Do OutputRowCardType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCardType
	Set Data=$lb(myTypeID,mydes,Default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCardTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCardTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取治疗申请单编号
/// w ##class(web.DHCDocCureApp).GetApplyNo();
ClassMethod GetApplyNo()
{
 s Date=..%SysDate()
 l +^DHCDhcApply(Date) 
 s ind=$i(^DHCDocApply(Date))
 l -^DHCDocApply(Date) 
 s dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
 s dt=$e($tr(dt1,"/"),1,4)
 s applyno=dt_$e(100000+ind,2,6)
 q applyno
}

/// 保存治疗申请单信息
/// w ##class(web.DHCDocCureApp).SaveCureApply(^TMP("SaveCureApply"))
ClassMethod SaveCureApply(EpisodeID, UserID, cureAppId, cureItemStr, cureRemark)
{
	s ^TMP("SaveCureApply")=EpisodeID_","_UserID_","_cureAppId_","_cureItemStr_","_cureRemark
	Quit:EpisodeID="" 0
	TS
	s err=0
	if cureAppId=""
	{
		;1.新增申请单
		k PLIST
		s PLIST(2)=EpisodeID
		s PLIST(3)=..GetApplyNo()
		s PLIST(4)=""
		s PLIST(5)="A"
		s PLIST(6)=UserID
		s PLIST(7)=..%SysDate()
		s PLIST(8)=..%SysTime()
		s PLIST(12)=cureRemark
		b ;PLIST
		&sql(insert into SQLUser.DHC_DocCureApp values :PLIST())
		if SQLCODE'=0 
		{
			TRO
			s err=100
			Q err
		}
		s DCARowId=%ROWID
		for count=1:1:$l(cureItemStr,"^")
		{
			s cureItem=$p(cureItemStr,"^",count)
			if cureItem="" continue
			s CureApp=$o(^DHCDocCure(0,"OEORI",cureItem,""),-1)
			if CureApp'=""  
			{
			   s DCAStatus=$p($g(^DHCDocCure(CureApp)),"^",4)
			   b ;
			   if (DCAStatus'="")&&(DCAStatus'="C")
			   {
				  s err=100
				  Q
			   }
			}
			k PLIST
			s PLIST(0)=DCARowId
			s PLIST(3)=cureItem
			&sql(insert SQLUser.DHC_DocCureAppCureItem values :PLIST())
			if SQLCODE'=0 
			{
				s err=100
				Q 
			}
		}
		if err'=0 
		{
			TRO
			Q err
		}
	}else{
		;更新申请单
		k PLIST
		s PLIST(9)=UserID
		s PLIST(10)=..%SysDate()
		s PLIST(11)=..%SysTime()
		s PLIST(12)=cureRemark
		&sql(update SQLUser.DHC_DocCureApp values :PLIST() where DCA_RowId=:cureAppId)
		if SQLCODE'=0 
		{
			TRO
			s err=100
			Q err
		}
		
	}
	TC
  Q err
}

/// 取治疗申请单信息
/// w ##class(DHCBILLConfig.DHCBILLFIND).GetCureApply(867)
ClassMethod GetCureApply(DCARowId)
{
	Quit:DCARowId="" ""
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	Quit CureAppInfo
}

/// 取消治疗申请单  医嘱需停掉
/// w ##class(web.DHCDocCureApp).CancelCureApply(62,6)
/// 宝安中医院不停止医嘱
ClassMethod CancelCureApply(DCARowId As %String, UserID As %String)
{
	s ^TMP("DeleteCureApp")=DCARowId_"^"_UserID
	Q:DCARowId="" 0
	;已经有治疗记录的申请单不允许删除
	//&sql(select count(*) into :count from SQLUser.DHC_DocCureRecode where DCR_ParRef=:DCARowId and DCR_ChildSub>0)
	s count=0
	s DCACChildSub=0
	for{
		s DCACChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub))
		q:DCACChildSub=""
		s DCRChildSub=0
		for{
			s DCRChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Recode",DCRChildSub))
			q:DCRChildSub=""
			s count=count+1
		}
		
	}
	q:$g(count)>0 100
	//停医嘱
	/*
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	//Set DCAOEORIDR=$p(CureAppInfo,"^",7)
	//Set DCAText1=$p(CureAppInfo,"^",8) //治疗项目附加费用
	s ret=0
	s DCACChildSub=0
	for{
		s DCACChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub))
		q:DCACChildSub=""
		s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
		q:ret'=0
		if (DCAOEORIDR'=""){
			s Adm=$p(^OEORD(+DCAOEORIDR),"^")
			s AdmType=$p(^PAADM(Adm),"^",2)
			if (AdmType="I"){
				s ret=##class(appcom.OEOrdItem).UnUse(DCAOEORIDR,UserID)
			}else{
				s ret=##class(web.DHCOEOrdItem).Stop(DCAOEORIDR,UserID)
			}
		}
		
	}
	Q:ret'=0 ret
	;账单
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	*/
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status="C" where DCA_RowId=:DCARowId)
	Q SQLCODE
}

// 拒收申请单

ClassMethod RejectCureApply(DCARowId As %String, UserID As %String, Remark As %String = "")
{
	Q 0
}

Query FindApplyAppTimeRange(LocId As %String, LocRoomId As %String, AppDate As %String) As %Query(ROWSPEC = "TimeRangeDesc:%String,TimeRangeVal:%String,selected:%Boolean")
{
}

ClassMethod FindApplyAppTimeRangeExecute(ByRef qHandle As %Binary, LocId As %String, LocRoomId As %String, AppDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindApplyAppTimeRange")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (LocId="")||(LocRoomId="")||(AppDate="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s AppDate=$zdh(AppDate,3)
	s AppInfo=$g(^DHCDocConfig("DHCDocCureLocRoom",LocId,"Room",LocRoomId,"AppSet"))
	s NeedAppFlag=$p(AppInfo,"^")
	s AppStartTime=$p(AppInfo,"^",2)
	s AppTimeLength=$p(AppInfo,"^",3)
	s AppTimeRangeLimit=$p(AppInfo,"^",4)
	if NeedAppFlag'=1 Set qHandle=$lb(0,repid,0)  Quit $$$OK
	if (AppStartTime="")||(AppTimeLength="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
	k ^TMP("FindAvailApplyAppTimeRange",$j)
	s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId)) q:DCARowId=""  d
	.s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId,DCAAChildSub)) q:DCAAChildSub=""  d
	..Set DCAAData=$g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub))
	..s DCAAReqTime=$p(DCAAData,"^",6)  //预约时间段
	..s DCAAStatus=$p(DCAAData,"^",8)   //预约状态
	..q:(DCAAStatus'="A")&&(DCAAStatus'="V")&&(DCAAStatus'="")
	..s DCAARoom=$p(DCAAData,"^",14)    //预约诊室
	..Q:(LocRoomId'="")&&(LocRoomId'=DCAARoom)
	..s ^TMP("FindAvailApplyAppTimeRange",$j,DCAAReqTime)=$g(^TMP("FindAvailApplyAppTimeRange",$j,DCAAReqTime))+1
	s AppEndTime=61200  //17:00
	for AppTime=AppStartTime:AppTimeLength:AppEndTime  d
	.s AppTimeRange=..%ZT(AppTime,2)_"-"_..%ZT((AppTime+AppTimeLength),2)
	.s AppedCount=$g(^TMP("FindAvailApplyAppTimeRange",$j,AppTimeRange))
	.q:(AppTimeRangeLimit>0)&&(AppTimeRangeLimit'>AppedCount)
	.if AppTime=AppStartTime s selected=1
	.else  s selected=0
	.d OutputRowApplyAppTimeRange
	k ^TMP("FindAvailApplyAppTimeRange",$j)	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApplyAppTimeRange
	Set Data=$lb(AppTimeRange,AppTimeRange,selected)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindApplyAppTimeRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApplyAppTimeRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApplyAppTimeRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApplyAppTimeRangeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 申请单预约
/// w ##class(web.DHCDocCureApp).SaveCureApplyApp(2,43,1,"2015-01-14","06:00-06:30")
/// w ##class(web.DHCDocCureApp).SaveCureApplyApp(8,104,1,"2015-10-22","08:00-08:30",6,"449935||22")
ClassMethod SaveCureApplyApp(ApplyItemId As %String, cureRoom As %String, cureItemUseQty As %String, cureApplyAppDate As %String, cureApplyAppTimeRange As %String, UserID As %String, cureItemStr As %String) As %String
{
	s ^TMP("SaveCureApplyApp")=ApplyItemId_","_cureRoom_","_cureItemUseQty_","_cureApplyAppDate_","_cureApplyAppTimeRange_","_UserID_","_cureItemStr
	Q:(ApplyItemId="")||(cureRoom="")||(cureItemUseQty="")||(cureApplyAppDate="")||(cureApplyAppTimeRange="") 100
	Q:$zdh(cureApplyAppDate,3)<+$H 1000
	;Q:($zdh(cureApplyAppDate,3)=..%SysDate())&&(..%ZTH($p(cureApplyAppTimeRange,"-",2),2)<..%SysTime()) 2000
	TS
	s err=0
	for len=1:1:$l(cureItemStr,"^") {
	s OEORIRowId1=$p(cureItemStr,"^",len)
	s cureApplyAppTime=..%ZTH($p(cureApplyAppTimeRange,"-"),2)
	s OEORERowId=..UpdateOEORE(ApplyItemId,cureItemUseQty,cureApplyAppDate,cureApplyAppTime,OEORIRowId1)
	if (OEORERowId="100")||(OEORERowId="101"||(OEORERowId="99"))  
	{
		//TRO
		//q OEORERowId
		s err=OEORERowId
		q
	}
	if (OEORERowId'["||")  
	{
		//TRO
		//q 100
		s err=100
		q
	}
	k PLIST
	&sql(select DCAC_RowId into :DCAAParRef from SQLUser.DHC_DocCureAppCureItem where DCAC_OEORI_DR=:OEORIRowId1)
	;s PLIST(0)=ApplyItemId
	s PLIST(0)=DCAAParRef
	s PLIST(3)=OEORERowId
	s PLIST(7)=$zdh(cureApplyAppDate,3)
	s PLIST(8)=cureApplyAppTimeRange
	s PLIST(10)="A"
	s PLIST(12)=..%SysDate()
	s PLIST(13)=..%SysTime()
	s PLIST(14)=UserID
	s PLIST(16)=cureRoom
	s PLIST(17)=cureItemUseQty
	&sql(insert into SQLUser.DHC_DocCureAppArrive values :PLIST())
	if (SQLCODE'=0)
	{
		//TRO
		//Q 100
		s err=100
		q
	}
	s ApplyArriveItemId=%ROWID
	k PLIST
	;s PLIST(0)=ApplyItemId
	s PLIST(0)=DCAAParRef
	s PLIST(3)=OEORERowId
	s PLIST(6)=UserID
	s PLIST(7)=$zdh(cureApplyAppDate,3)
	s PLIST(8)=cureApplyAppTimeRange
	s PLIST(13)=ApplyArriveItemId
	&sql(insert SQLUser.DHC_DocCureRecode values :PLIST())
	if (SQLCODE'=0)
	{
		//TRO
		//Q 100
		s err=100
		q
	}
	Set CureAppInfo=$g(^DHCDocCure(ApplyItemId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	//Q 0
	}
	if err'=0 
	{
		TRO
		Q err
	}
	TC
	Q err
}

/// TransType "ADD":增加预约记录,"DELETE":"删除预约记录" 一条预约记录对应医嘱的一条执行记录
ClassMethod UpdateOEORE(ApplyItemId As %String, cureItemUseQty As %String, cureApplyAppDate As %String, cureApplyAppTime As %String, OEORIRowId As %String) As %String
{
	Q:ApplyItemId="" 100
	;s OEORIRowId=$p(^DHCDocCure(ApplyItemId),"^",7)
	Q:OEORIRowId="" 100
	s Adm=$p(^OEORD(+OEORIRowId),"^")
	s AdmType=$p(^PAADM(Adm),"^",2)
	s OrdQty=0
	&sql(select OEORI_PhQtyOrd into :OrdQty from SQLUser.OE_OrdItem where OEORI_RowId=:OEORIRowId)
	Q:OrdQty=0 100
		//新增预约记录需要判断总数
		s UsedExecQtySum=0,AvailOEORERowId=""
		s OrderExecSub=0
		for{
			s OrderExecSub=$o(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),"X",OrderExecSub))  
			Q:OrderExecSub=""
			s OEORERowId=OEORIRowId_"||"_OrderExecSub
			if (AdmType="I"){
				s OrderStatus=$p(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),"X",OrderExecSub,"BILL"),"^",1)
				s:((OrderStatus="")||(OrderStatus=1)||(OrderStatus=12))&&(AvailOEORERowId="") AvailOEORERowId=OEORERowId
			}
			else{
				s OrderStatus=$p(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),"X",OrderExecSub),"^",16)
				s:((OrderStatus="")||(OrderStatus=3))&&(AvailOEORERowId="") AvailOEORERowId=OEORERowId
			}
			q:(AvailOEORERowId'="")
			s:OrderStatus'="" OrderStatus=$p($g(^OEC("STAT",OrderStatus)),"^")
			q:(OrderStatus="D")||(OrderStatus="C")
			
		}
		b ;1
		q:AvailOEORERowId="" 99
		if AvailOEORERowId'="" 
		{ 
			if (AdmType="I"){
				s OrderStatus=$o(^OEC("OSTAT",0,"Code","E",""))
				&sql(update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=:OrderStatus where OEORE_RowId=:AvailOEORERowId)
				if SQLCODE=0 Q AvailOEORERowId
				else  Q SQLCODE
			}else{
				s ExecDate=$zdh(cureApplyAppDate,3)
				&sql(update SQLUser.OE_OrdExec set OEORE_QtyAdmin=:cureItemUseQty,OEORE_ExStDate=:ExecDate,OEORE_Billed='TB',OEORE_Order_Status_DR=1 where OEORE_RowId=:AvailOEORERowId)
				if SQLCODE=0 Q AvailOEORERowId
				else  Q SQLCODE
			}
		}
}

/// w ##class(web.DHCDocCureApp).DeleteCureApplyApp("30||1",662)
ClassMethod DeleteCureApplyApp(DCAARowId As %String, UserID As %String) As %String
{
	Q:DCAARowId="" 100
	s DCARowId=+DCAARowId
	s DCAAChildSub=$p(DCAARowId,"||",3)
	Set DCAAData=$g(^DHCDocCure(DCARowId,"CureItem",$p(DCAARowId,"||",2),"Arrive",DCAAChildSub))
	s DCAAStatus=$p(DCAAData,"^",8)   //预约状态
	q:(DCAAStatus'="A")&&(DCAAStatus'="") 101
	s ret=0
	s DCAAOEORE=$p(DCAAData,"^",1)
	if DCAAOEORE'=""  d
	.s Adm=$p(^OEORD(+DCAAOEORE),"^")
	.s AdmType=$p(^PAADM(Adm),"^",2)
	.if AdmType="I" d
	..s ExecStatus=$p(^OEORD(+DCAAOEORE,"I",$P(DCAAOEORE,"||",2),"X",$P(DCAAOEORE,"||",3)),"^",16)
	..if ExecStatus="F" s ret=102  Q
	..s OrderStatus=$o(^OEC("OSTAT",0,"Code","C",""))
	..&sql(update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=:OrderStatus where OEORE_RowId=:DCAAOEORE)
	..s ret=##class(appcom.OEOrdExec).UpdateStatus(DCAAOEORE,"D",UserID)
	..s ChildSub=0  for  s ChildSub=$o(^OEORDi(0,"OEORE",DCAAOEORE,+DCAAOEORE,ChildSub))  q:ChildSub=""  d
	...s ExeChildSub=0  for  s ExeChildSub=$o(^OEORDi(0,"OEORE",DCAAOEORE,+DCAAOEORE,ChildSub,ExeChildSub))  q:ExeChildSub=""  d
	....s SubOEORE=+DCAAOEORE_"||"_ChildSub_"||"_ExeChildSub
	....&sql(update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=:OrderStatus where OEORE_RowId=:SubOEORE)
	....s ret=##class(appcom.OEOrdExec).UpdateStatus(SubOEORE,"D",UserID)
	Q:ret'=0 ret
	;账单 
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	&sql(delete from SQLUser.DHC_DocCureAppArrive where DCAA_RowId=:DCAARowId)
	Q:SQLCODE'=0 SQLCODE
	&sql(delete from SQLUser.DHC_DocCureRecode where DCR_ParRef=:DCARowId and DCR_Text1=:DCAARowId)
	Q SQLCODE
}

/// w ##class(web.DHCDocCureApp).UpdateCureAppState("53||1||1","Cancel",6)
ClassMethod UpdateCureAppState(DCAARowIdStr As %String, OperateType As %String, UserId As %String) As %String
{
	s err=""
	TS
	for len=1:1:$l(DCAARowIdStr,"^") {
	s DCAARowId=$p(DCAARowIdStr,"^",len)
	if (DCAARowId="")||(OperateType="")||(UserId="") {
		s err=100
		q
	}
	s DCARowId=+DCAARowId
	s DCAAChildSub=$p(DCAARowId,"||",3)
	Set DCAAData=$g(^DHCDocCure(DCARowId,"CureItem",$p(DCAARowId,"||",2),"Arrive",DCAAChildSub))
	s DCAAStatus=$p(DCAAData,"^",8)   //预约状态
	if (OperateType="Arrive")&&((DCAAStatus'="A")&&(DCAAStatus'="")) {
		s err=101
		q
	}
	b ;
	if (OperateType="Cancel")&&(DCAAStatus'="V") {
		s err=102
		q
	}
	if OperateType="Arrive" s AppState="V"
	if OperateType="Cancel" s AppState="A"
	if (OperateType="Arrive")  s DCAADate=..%SysDate(),DCAATime=..%SysTime()
	else  s DCAADate="",DCAATime=""
	&sql(update  SQLUser.DHC_DocCureAppArrive set DCAA_Status=:AppState,DCAA_Date=:DCAADate,DCAA_Time=:DCAATime where DCAA_RowId=:DCAARowId)
	s err=SQLCODE
	
	}
	if err'=0 {
		TRO
		q err
	}
	TC
	q err
}

Query FindCureApplyAppList(DCARowId As %String) As %Query(ROWSPEC = "cureApplyAppId:%String,cureRoom:%String,cureItemUseQty:%String,cureApplyAppDate:%String,cureApplyAppTimeRange:%String,cureApplyAppStatus:%String")
{
}

ClassMethod FindCureApplyAppListExecute(ByRef qHandle As %Binary, DCARowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureApplyAppList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (DCARowId="") Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s DCAAChildSub=0
	for
	{
		s DCAAChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCAAChildSub))
		q:DCAAChildSub=""
		s Sub=0
		for
		{
			s Sub=$o(^DHCDocCure(DCARowId,"CureItem",DCAAChildSub,"Arrive",Sub))
			q:Sub=""
			s DCAAData=$g(^DHCDocCure(DCARowId,"CureItem",DCAAChildSub,"Arrive",Sub))
			q:DCAAData=""
			s DCAAReqDate=$p(DCAAData,"^",5)  //预约日期
			s:DCAAReqDate'="" DCAAReqDate=$zd(DCAAReqDate,3)
			s DCAAReqTime=$p(DCAAData,"^",6)  //预约时间段
			s DCAAStatus=$p(DCAAData,"^",8)   //预约状态
			s:DCAAStatus'="" DCAAStatus=$case(DCAAStatus,"A":"预约","V":"到达","C":"取消",:"")
			s DCAARoom=$p(DCAAData,"^",14)    //预约诊室
			s:DCAARoom'="" DCAARoom=$p(^CTLOC(DCAARoom),"^",2)
			s DCAAUseQty=$p(DCAAData,"^",15)    //占用治疗数量
			s DCAARowId=DCARowId_"||"_DCAAChildSub_"||"_Sub
			d OutputRowFindCureApplyAppList	
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureApplyAppList
	Set Data=$lb(DCAARowId,DCAARoom,DCAAUseQty,DCAAReqDate,DCAAReqTime,DCAAStatus)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCureApplyAppListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyAppListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyAppListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindCureApplyAppArriveList(cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String, LocID As %String) As %Query(ROWSPEC = "DCAARowId:%String,PatNo:%String,PatName:%String,PatSex :%String,PatAge:%String,PatType:%String,PatTel:%String,PatAddress:%String,DCAArcimDesc:%String,DCATimes:%String,DCAAReqDate:%String,DCAAReqTime:%String,DCAAStatus:%String,DCAADate:%String,DCAATime:%String,DCAARoom:%String,DCAAUseQty:%String")
{
}

ClassMethod FindCureApplyAppArriveListExecute(ByRef qHandle As %Binary, cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String, LocID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureApplyAppArriveList","","","0000000002","","",29)
	s ^TMP("FindCureApplyAppArriveList")=cardType_"^"_cardNo_"^"_patNo_"^"_sttDate_"^"_endDate_"^"_ LocID
	Set repid=$I(^CacheTemp)
	Set ind=1
	if sttDate="" s sttDate=..%SysDate()
	else  s sttDate=$zdh(sttDate,3)
	if endDate="" s endDate=..%SysDate()
	else  s endDate=$zdh(endDate,3)
	s PatientID=""
	if (cardType'="")&&(cardNo'="") 
	{
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(cardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0")  d
		.s PatientID=$P(ret,"^",8)
	}
	if patNo'=""  d
	.Set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(patNo,"U"),0))
	if ((cardNo'="")||(patNo'=""))&&(PatientID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	b ;sttDate
	f AppDate=sttDate:1:endDate  d
	.q:'$D(^DHCDocCure(0,"AppDate",AppDate))
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId)) q:DCARowId=""  d
	..s DCACChildSub=0 for  s DCACChildSub=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId,DCACChildSub)) q:DCACChildSub=""  d
	...s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId,DCACChildSub,DCAAChildSub)) q:DCAAChildSub=""  d
	....s DCAARowId=DCARowId_"||"_DCACChildSub_"||"_DCAAChildSub
	....d OutputRowApplyAppArrive
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApplyAppArrive
	Set CureApplyInfo=$g(^DHCDocCure(DCARowId))
	Set CureApplyAppInfo=$g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Arrive",DCAAChildSub))
	b ;4
	q:CureApplyInfo=""
	q:CureApplyAppInfo=""
	Set AdmId=$p(CureApplyInfo,"^",1) //就诊ID
	s AppPatientID=$P(^PAADM(AdmId),"^",1)
	Q:(PatientID'="")&&(AppPatientID'=PatientID)
	s Patinfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(AppPatientID)
	s PatNo=$p(Patinfo,"^",2)
	s PatName=$p(Patinfo,"^",3)
	s PatSex=$p(Patinfo,"^",4)
	s PatAge=$p(Patinfo,"^",5)
	s PatType=$p(Patinfo,"^",7)
	s PatTel=$p(Patinfo,"^",25)
	s PatAddress=$p(Patinfo,"^",11)
	Set DCATimes=$p(CureApplyInfo,"^",2) //治疗次数
	Set DCAUser=$p(CureApplyInfo,"^",3) //申请人
	Set DCAAppDate=$p(CureApplyInfo,"^",4) //申请日期
	Set DCAAppTime=$p(CureApplyInfo,"^",5) //申请时间
	Set DCARemark=$p(CureApplyInfo,"^",6) //申请备注
	Set DCAOEORIDR=$p(CureApplyInfo,"^",7) //治疗项目
	Set DCAText1=$p(CureApplyInfo,"^",8) //治疗项目附加费用
	Set:DCAAppDate'="" DCAAppDate=$zd(DCAAppDate,3)
	Set:DCAAppTime'="" DCAAppTime=..%ZT(DCAAppTime,1)
	Set:DCAUser'="" DCAUser=$P(^SSU("SSUSR",DCAUser),"^",2)
	Set DCAArcimDesc="",DCAAppendArcimDesc="",RelocId="",Qty=0
	Set:(DCAAppDate'="")&&(DCAAppTime'="") DCAAppDate=DCAAppDate_" "_DCAAppTime
	s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
	if DCAOEORIDR'="" d
	.s RelocId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
	.s Qty=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",12)
	.s ArcimRowid=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
	.s:ArcimRowid'="" DCAArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	if DCAText1'="" d
	.s ArcimRowid=$p($g(^OEORD(+DCAText1,"I",$p(DCAText1,"||",2),1)),"^",2)
	.s:ArcimRowid'="" DCAAppendArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s DCAADate=$p(CureApplyAppInfo,"^",2)  //到达日期
	s:DCAADate'="" DCAADate=$zd(DCAADate,3)
	s DCAATime=$p(CureApplyAppInfo,"^",3)  //到达时间
	s:DCAATime'="" DCAATime=..%ZT(DCAATime,2)
	s DCAAReqDate=$p(CureApplyAppInfo,"^",5)  //预约日期
	s:DCAAReqDate'="" DCAAReqDate=$zd(DCAAReqDate,3)
	s DCAAReqTime=$p(CureApplyAppInfo,"^",6)  //预约时间段
	s DCAAStatus=$p(CureApplyAppInfo,"^",8)   //预约状态
	s:DCAAStatus'="" DCAAStatus=$case(DCAAStatus,"A":"预约","V":"到达","C":"取消",:"")
	s DCAARoom=$p(CureApplyAppInfo,"^",14)    //预约诊室
	s:DCAARoom'="" DCAARoom=$p(^CTLOC(DCAARoom),"^",2)
	s DCAAUseQty=$p(CureApplyAppInfo,"^",15)    //占用治疗数量
	set Data=$lb(DCAARowId,PatNo,PatName,PatSex,PatAge,PatType,PatTel,PatAddress,DCAArcimDesc,DCATimes,DCAAReqDate,DCAAReqTime,DCAAStatus,DCAADate,DCAATime,DCAARoom,DCAAUseQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureApplyAppArriveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyAppArriveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyAppArriveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyAppArriveListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindCureWorkList(cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String, UserID As %String, LocID As %String) As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex :%String,PatAge:%String,PatType:%String,DCAArcimDesc:%String,PatientID:%String,EpisodeID:%String,DCRRowId:%String,DCAOEORIDR:%String,Num:%String,TotalNum:%String,LeftNum:%String,Price:%String,Sum:%String,Qty:%String")
{
}

ClassMethod FindCureWorkListExecute(ByRef qHandle As %Binary, cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String, UserID As %String, LocID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureWorkList","","","0000935965","2015-12-30","","","29")
	Set repid=$I(^CacheTemp)
	Set ind=1
	if sttDate="" s sttDate=..%SysDate()
	else  s sttDate=$zdh(sttDate,3)
	if endDate="" s endDate=..%SysDate()
	else  s endDate=$zdh(endDate,3)
	s PatientID=""
	if (cardType'="")&&(cardNo'="") 
	{
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(cardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0")  d
		.s PatientID=$P(ret,"^",8)
	}
	if (PatientID="")
	{
	 if patNo'=""  d
	 .Set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(patNo,"U"),0))
	}
	if ((cardNo'="")||(patNo'=""))&&(PatientID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;判断治疗科室是否需要预约,需要预约的只能查询到达的队列
	s NeedAppFlag=0
	set curelocId=$o(^DHCDocConfig("DHCDocCureLocRoom",LocID,"Room",""))
	b ;1.1
	i curelocId'="" d
	.s LocRoomConfig=$g(^DHCDocConfig("DHCDocCureLocRoom",LocID,"Room",curelocId,"AppSet"))
	.s NeedAppFlag=$p(LocRoomConfig,"^",1)
	b ;1
	if NeedAppFlag=1  d
	.f AppDate=sttDate:1:endDate  d
	..q:'$d(^DHCDocCure(0,"AppDate",AppDate))
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId)) q:DCARowId=""  d
	...Q:($G(^DHCDocCure(DCARowId))="")
	...s AdmId=$p(^DHCDocCure(DCARowId),"^",1) //就诊ID
	...q:AdmId=""
	...s VisitStatus=$p($g(^PAADM(AdmId)),"^",20)
	...Q:VisitStatus'="A"
	...s AdmType=$p($g(^PAADM(AdmId)),"^",2)
	...s FindFlag=0
	...s DCACChildSub=0 for  s DCACChildSub=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId,DCACChildSub)) q:DCACChildSub=""  d
	....s DCAAChildSub=0 for  s DCAAChildSub=$o(^DHCDocCure(0,"AppDate",AppDate,DCARowId,DCACChildSub,DCAAChildSub)) q:DCAAChildSub=""  d
	.....Set CureApplyAppInfo=$g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Arrive",DCAAChildSub))
	.....s DCAARoom=$p(CureApplyAppInfo,"^",14)
	.....s DCAAStatus=$p(CureApplyAppInfo,"^",8)
	.....q:DCAAStatus'="V"  //非到达状态的不显示
	.....;q:(LocID'="")&&(LocID'=DCAARoom)
	.....s DCRRowId=DCARowId_"||"_DCACChildSub_"||"_DCAAChildSub
	.....s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
	.....s PayStatus=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",5)
	.....;q:(AdmType'="I")&&(PayStatus'="P")
	.....d OutputRowFindCureWorkList
	else  d
	.f ApplyDate=sttDate:1:endDate  d
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",ApplyDate,DCARowId)) q:DCARowId=""  d
	...s AdmId=$p(^DHCDocCure(DCARowId),"^",1) //就诊ID
	...q:AdmId=""
	...s VisitStatus=$p($g(^PAADM(AdmId)),"^",20)
	...Q:VisitStatus'="A"
	...s AdmType=$p($g(^PAADM(AdmId)),"^",2)
	...s DCACChildSub=0 for  s DCACChildSub=$o(^DHCDocCure(0,"CureApp",DCARowId,DCACChildSub)) q:DCACChildSub=""  d
	....s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
	....s OERelocId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
	....s OrderStatus=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
	....s:OrderStatus'="" OrderStatus=$p(^OEC("OSTAT",OrderStatus),"^",1)
	....q:(OrderStatus'="V")&&(OrderStatus'="E")
	....s PayStatus=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",5)
	....;q:(AdmType'="I")&&(PayStatus'="P")
	....q:(LocID'="")&&(LocID'=OERelocId)
	....d OutputRowFindCureWorkList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureWorkList
	Set CureApplyInfo=$g(^DHCDocCure(DCARowId))
	q:CureApplyInfo=""
	Set AdmId=$p(CureApplyInfo,"^",1) //就诊ID
	s AppPatientID=$P(^PAADM(AdmId),"^",1)
	Q:(PatientID'="")&&(AppPatientID'=PatientID)
	s Patinfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(AppPatientID)
	s PatNo=$p(Patinfo,"^",2)
	s PatName=$p(Patinfo,"^",3)
	s PatSex=$p(Patinfo,"^",4)
	s PatAge=$p(Patinfo,"^",5)
	s PatType=$p(Patinfo,"^",7)
	s PatTel=$p(Patinfo,"^",25)
	s PatAddress=$p(Patinfo,"^",29)
	s TotalNum=0,Num=0,LeftNum=0
	s:$d(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X")) TotalNum=^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",0)
	if ($d(^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Recode")))
	{
		s sub=0
		for
		{
			s sub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Recode",sub))
			q:sub=""
			s Num=Num+1	
		}	
	}
	s LeftNum=TotalNum-Num
	Set DCATimes=$p(CureApplyInfo,"^",2) //治疗次数
	Set DCAUser=$p(CureApplyInfo,"^",3) //申请人
	Set DCAAppDate=$p(CureApplyInfo,"^",4) //申请日期
	Set DCAAppTime=$p(CureApplyInfo,"^",5) //申请时间
	Set DCARemark=$p(CureApplyInfo,"^",6) //申请备注
	Set DCAText1=$p(CureApplyInfo,"^",8) //治疗项目附加费用
	Set:DCAAppDate'="" DCAAppDate=$zd(DCAAppDate,3)
	Set:DCAAppTime'="" DCAAppTime=..%ZT(DCAAppTime,1)
	Set:DCAUser'="" DCAUser=$P(^SSU("SSUSR",DCAUser),"^",2)
	Set DCAArcimDesc="",DCAAppendArcimDesc="",RelocId="",Qty=0
	Set:(DCAAppDate'="")&&(DCAAppTime'="") DCAAppDate=DCAAppDate_" "_DCAAppTime
	s OrdDetail=..GetOrdDetail(DCAOEORIDR)
	s Price=$p(OrdDetail,"^",13)
	s OrdMesage=..GetOrderMesage(DCAOEORIDR)
	s Sum=$fn($P(OrdMesage,"^",11),"",2)
	s Qty=""
	if DCAOEORIDR'="" d
	.s RelocId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
	.s Qty=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",12)
	.s ArcimRowid=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
	.s:ArcimRowid'="" DCAArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	.s Sub=$o(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",0))
	.s Qty=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",Sub)),"^",4)
	if DCAText1'="" d
	.s ArcimRowid=$p($g(^OEORD(+DCAText1,"I",$p(DCAText1,"||",2),1)),"^",2)
	.s:ArcimRowid'="" DCAAppendArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s PatType=$p(Patinfo,"^",7)
	set Data=$lb(DCARowId,PatNo,PatName,PatSex,PatAge,PatType,DCAArcimDesc,AppPatientID,AdmId,DCRRowId,DCAOEORIDR,Num,TotalNum,LeftNum,Price,Sum,Qty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureWorkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 插入治疗记录数据
/// w ##class(web.DHCDocCureApp).InsertCureApplyRecode(46,2,"2015-12-29","477315||395",64,6)
ClassMethod InsertCureApplyRecode(ApplyItemId As %String, cureItemUseQty As %String, cureApplyAppDate As %String, DCAOEORIDR As %String, LocID As %String, UserID As %String, DCRContent As %String, DCRRemark As %String) As %String
{

	s ^TMP("InsertCureApplyRecode")=ApplyItemId_","_cureItemUseQty_","_cureApplyAppDate_","_LocID_","_UserID_","_DCAOEORIDR
	s OEORIRowId1=DCAOEORIDR
	;Q:OEORIRowId1="" 100
	;判断治疗科室是否需要预约,需要预约的不能直接增加治疗记录
	s NeedAppFlag=0
	set curelocId=$o(^DHCDocConfig("DHCDocCureLocRoom",LocID,"Room",""))
	i curelocId'="" d
    .s LocRoomConfig=$g(^DHCDocConfig("DHCDocCureLocRoom",LocID,"Room",curelocId,"AppSet"))
    .s NeedAppFlag=$p(LocRoomConfig,"^",1)
    Q:NeedAppFlag=1 102
    
    TS
    s cureApplyAppTime=..%SysTime()
	s OEORERowId=..UpdateOEORE(ApplyItemId,cureItemUseQty,cureApplyAppDate,cureApplyAppTime,OEORIRowId1)
	if (OEORERowId="100")||(OEORERowId="101")  
	{
		TRO
		q OEORERowId
	}
	if OEORERowId'["||"
	{
		TRO
		q 100
	}
	
	s SumUseQty=0
	k PLIST
	b ;
	&sql(select DCAC_RowId into :DCAAParRef from SQLUser.DHC_DocCureAppCureItem where DCAC_OEORI_DR=:DCAOEORIDR)
	s PLIST(0)=DCAAParRef
	s PLIST(3)=OEORERowId
	s PLIST(6)=UserID
	s PLIST(7)=$zdh(cureApplyAppDate,3)
	s PLIST(8)=..%SysTime()
	s PLIST(4)=DCRContent 
	s PLIST(12)=DCRRemark
	s PLIST(14)=LocID
	&sql(insert SQLUser.DHC_DocCureRecode values :PLIST())
	;账单 
	Set CureAppInfo=$g(^DHCDocCure(ApplyItemId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	TC
	Q SQLCODE
}

/// 删除治疗记录数据
/// w ##class(web.DHCDocCureApp).DeleteCureApplyRecode("39||1||1",29,6)
ClassMethod DeleteCureApplyRecode(DCRRowId As %String, DCAOEORIDR As %String, LocID As %String, UserID As %String) As %String
{
	Q:DCRRowId="" 100
	s ret=0
	s AdmType=""
	;判断治疗科室是否需要预约,需要预约的不能删除治疗记录
	s NeedAppFlag=0
	s RelocId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
	Q:RelocId="" 100
	if $d(^DHCDocConfig("DHCDocCureLocRoom",RelocId,"Room",LocID))  d 
	.s LocRoomConfig=$g(^DHCDocConfig("DHCDocCureLocRoom",RelocId,"Room",LocID,"AppSet"))
	.s NeedAppFlag=$p(LocRoomConfig,"^",1)
    Q:NeedAppFlag=1 102
	s CureApplyRecodeInfo=$g(^DHCDocCure(+DCRRowId,"CureItem",$P(DCRRowId,"||",2),"Recode",$P(DCRRowId,"||",3)))
	s DCAAOEORE=$p(CureApplyRecodeInfo,"^",1)
	if DCAAOEORE'=""  d
	.s Adm=$p(^OEORD(+DCAAOEORE),"^")
	.s AdmType=$p(^PAADM(Adm),"^",2)
	.if AdmType="I" d
	..s OrderStatus=$o(^OEC("OSTAT",0,"Code","C",""))
	..&sql(update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=:OrderStatus where OEORE_RowId=:DCAAOEORE)
	..s ret=##class(appcom.OEOrdExec).UpdateStatus(DCAAOEORE,"D",UserID)
	..s ChildSub=0  for  s ChildSub=$o(^OEORDi(0,"OEORE",DCAAOEORE,+DCAAOEORE,ChildSub))  q:ChildSub=""  d
	...s ExeChildSub=0  for  s ExeChildSub=$o(^OEORDi(0,"OEORE",DCAAOEORE,+DCAAOEORE,ChildSub,ExeChildSub))  q:ExeChildSub=""  d
	....s SubOEORE=+DCAAOEORE_"||"_ChildSub_"||"_ExeChildSub
	....&sql(update SQLUser.OE_OrdExecExt set OEORE_OrderStatus_DR=:OrderStatus where OEORE_RowId=:SubOEORE)
	....s ret=##class(appcom.OEOrdExec).UpdateStatus(SubOEORE,"D",UserID)
	Q:ret'=0 ret
	;账单 
	Set CureAppInfo=$g(^DHCDocCure(+DCRRowId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	if (AdmType'="I"){
	&sql(update SQLUser.OE_OrdExec set OEORE_Order_Status_DR=3 where OEORE_RowId=:DCAAOEORE)
	q:SQLCODE'=0 SQLCODE
	}
	&sql(delete from SQLUser.DHC_DocCureRecode where DCR_RowId=:DCRRowId)
	Q SQLCODE
}

/// 获取治疗记录明细
/// w ##class(web.DHCDocCureApp).GetCureApplyRecodeDetail()
ClassMethod GetCureApplyRecodeDetail(DCRRowId As %String) As %String
{
	Q:DCRRowId="" ""
	s DCARowId=+DCRRowId
	s DCRChildSub=$p(DCRRowId,"||",2)
	s CureApplyRecodeInfo=$g(^DHCDocCure(DCARowId,"Recode",DCRChildSub))
	q:CureApplyRecodeInfo="" ""
	s DCRUserDR=$p(CureApplyRecodeInfo,"^",4) //操作用户
	s DCROPDate=$p(CureApplyRecodeInfo,"^",5) //操作日期
	s DCROPTime=$p(CureApplyRecodeInfo,"^",6) //治疗时间
	s DCRLastUpdateDate=$p(CureApplyRecodeInfo,"^",7) //最后更新日期
	s DCRLastUpdateTime=$p(CureApplyRecodeInfo,"^",8) //最后更新时间
	s DCRLastUpdateUserDR=$p(CureApplyRecodeInfo,"^",9) //最后更新人
	s:DCROPDate'="" DCROPDate=$zd(DCROPDate,3)
	s:(DCROPTime'="")&&(DCROPTime'["-") DCROPTime=..%ZT(DCROPTime,1)
	s:(DCROPDate'="")&&(DCROPTime'="") DCROPDate=DCROPDate_" "_DCROPTime
	s:DCRUserDR'="" DCRUserDR=$P($g(^SSU("SSUSR",DCRUserDR)),"^",2)
	s $p(CureApplyRecodeInfo,"^",4)=DCRUserDR
	s $p(CureApplyRecodeInfo,"^",5)=DCROPDate
	s:DCRLastUpdateDate'="" DCRLastUpdateDate=$zd(DCRLastUpdateDate,3)
	s:DCRLastUpdateTime'="" DCRLastUpdateTime=..%ZT(DCRLastUpdateTime,1)
	s:(DCRLastUpdateDate'="")&&(DCRLastUpdateTime'="") DCRLastUpdateDate=DCRLastUpdateDate_" "_DCRLastUpdateTime
	s:DCRLastUpdateUserDR'="" DCRLastUpdateUserDR=$P(^SSU("SSUSR",DCRLastUpdateUserDR),"^",2)
	s $p(CureApplyRecodeInfo,"^",7)=DCRLastUpdateDate
	s $p(CureApplyRecodeInfo,"^",9)=DCRLastUpdateUserDR
	q CureApplyRecodeInfo
}

/// 保存治疗记录内容
/// w ##class(web.DHCDocCureApp).SaveCureApplyRecodeDetail("49||1||1","","1111","",6)
ClassMethod SaveCureApplyRecodeDetail(DCRRowId As %String, DCRStage As %String, DCRContent As %String, DCRRemark As %String, UserID As %String) As %String
{
	s ^TMP("SaveCureApplyRecodeDetail")=DCRRowId_","_DCRStage_","_DCRContent_","_DCRRemark_","_UserID
	Q:DCRRowId="" 100
	k OLDPLIST
	&sql(select * into :OLDPLIST() from SQLUser.DHC_DocCureRecode where DCR_RowId=:DCRRowId)
	Q:($g(OLDPLIST(7))'="")&&(OLDPLIST(7)>+$h) 101   //未到安排治疗的日期不能填写治疗记录
	;如果治疗记录需要预约,但是没有到达的,不能填写治疗记录
	s DCAAStatus=""
	if $g(OLDPLIST(3))'=""  d
	.s DCAAChildSub=$o(^DHCDocCure(0,"OEORE",OLDPLIST(3),+DCRRowId,""))
	.if DCAAChildSub'=""  d
	..s CureApplyAppInfo=$g(^DHCDocCure(+DCRRowId,"Arrive",DCAAChildSub))
	..s DCAAStatus=$p(CureApplyAppInfo,"^",8)   //预约状态 "A":"预约","V":"到达","C":"取消"
	Q:(DCAAStatus'="")&&(DCAAStatus'="V") 102
	k PLIST
	s PLIST(4)=DCRContent
	s PLIST(5)=DCRStage
	s PLIST(9)=..%SysDate()
	s PLIST(10)=..%SysTime()
	s PLIST(11)=UserID
	s PLIST(12)=DCRRemark
	s ChangeContext=""
	s count="" for  s count=$o(OLDPLIST(count)) Q:count=""  d
	.if OLDPLIST(count)'=$g(PLIST(count))  d
	..if (count=4)  d
	...i ChangeContext="" s ChangeContext="治疗记录由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	...e   s ChangeContext=ChangeContext_",治疗记录由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	..if count=5  d
	...i ChangeContext="" s ChangeContext="治疗阶段由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	...e   s ChangeContext=ChangeContext_",治疗阶段由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	..if count=12  d
	...i ChangeContext="" s ChangeContext="治疗备注由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	...e   s ChangeContext=ChangeContext_",治疗备注由:"_OLDPLIST(count)_"修改为"_PLIST(count)
	TS
	s DCRChildSub=$o(^DHCDocCure(0,"DCRText1",DCRRowId,+DCRRowId,$p(DCRRowId,"||",2),0))
	s DCRRowId=+DCRRowId_"||"_$p(DCRRowId,"||",2)_"||"_DCRChildSub
	&sql(update SQLUser.DHC_DocCureRecode values :PLIST() where DCR_RowId=:DCRRowId)
	B ;1
	if SQLCODE'=0  
	{
		TRO
		Q SQLCODE
	}
	b ;2
	k PLIST
	s PLIST(0)=DCRRowId
	s PLIST(3)=..%SysDate()
	s PLIST(4)=..%SysTime()
	s PLIST(5)=UserID
	s PLIST(6)=ChangeContext
	&sql(insert SQLUser.DHC_DocCureRecodeChange values:PLIST())
	if SQLCODE'=0  
	{
		TRO
		Q SQLCODE
	}
	b ;3
	TC
	Q 0
}

/// w ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindApplyRecodeList",11)
Query FindApplyRecodeList(DCARowId As %String) As %Query(ROWSPEC = "DCRRowId:%String,DCROPDate:%String,DCRUserDR:%String,DCRLastUpdateDate:%String,DCRLastUpdateUserDR:%String,Dura:%String,DCAArcimDesc:%String,DCAOEORIDR:%String,DCRContent:%String,DCRRemark:%String")
{
}

ClassMethod FindApplyRecodeListExecute(ByRef qHandle As %Binary, DCARowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if DCARowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s DCACSub=0 for  s DCACSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACSub)) q:DCACSub=""  d
	.s DCAASub=0 for  s DCAASub=$o(^DHCDocCure(DCARowId,"CureItem",DCACSub,"Recode",DCAASub)) q:DCAASub=""  d
	..s DCRRowId=DCARowId_"||"_DCACSub_"||"_DCAASub
	..b
	..s CureApplyRecodeInfo=$g(^DHCDocCure(DCARowId,"CureItem",DCACSub,"Recode",DCAASub))
	..b ;2
	..q:CureApplyRecodeInfo=""
	..s DCRContent=$p(CureApplyRecodeInfo,"^",2) 
	..s DCRRemark=$p(CureApplyRecodeInfo,"^",10)
	..s DCROPDate=$p(CureApplyRecodeInfo,"^",5) //操作日期
	..s DCROPTime=$p(CureApplyRecodeInfo,"^",6) //操作时间
	..s DCRUserDR=$p(CureApplyRecodeInfo,"^",4) //操作用户
	..s DCRLastUpdateDate=$p(CureApplyRecodeInfo,"^",7) //最后更新日期
	..s DCRLastUpdateTime=$p(CureApplyRecodeInfo,"^",8) //最后更新时间
	..s DCRLastUpdateUserDR=$p(CureApplyRecodeInfo,"^",9) //最后更新人
	..s DCAOEORIDR=$p(^DHCDocCure(DCARowId,"CureItem",DCACSub),"^",1)
	..s ArcimRowid=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
	..s:ArcimRowid'="" DCAArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	..s ordstr2=$g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),2))
	..s Dura=$p(ordstr2,"^",6)
	..s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),"^",2)
	..s:DCROPDate'="" DCROPDate=$zd(DCROPDate,3)
	..s:(DCROPTime'="")&&(DCROPTime'["-") DCROPTime=..%ZT(DCROPTime,1)
	..s:(DCROPDate'="")&&(DCROPTime'="") DCROPDate=DCROPDate_" "_DCROPTime
	..s:DCRUserDR'="" DCRUserDR=$P($G(^SSU("SSUSR",DCRUserDR)),"^",2)
	..s:DCRLastUpdateDate'="" DCRLastUpdateDate=$zd(DCRLastUpdateDate,3)
	..s:DCRLastUpdateTime'="" DCRLastUpdateTime=..%ZT(DCRLastUpdateTime,1)
	..s:(DCRLastUpdateDate'="")&&(DCRLastUpdateTime'="") DCRLastUpdateDate=DCRLastUpdateDate_" "_DCRLastUpdateTime
	..s:DCRLastUpdateUserDR'="" DCRLastUpdateUserDR=$P(^SSU("SSUSR",DCRLastUpdateUserDR),"^",2)
	..set Data=$lb(DCRRowId,DCROPDate,DCRUserDR,DCRLastUpdateDate,DCRLastUpdateUserDR,Dura,DCAArcimDesc,DCAOEORIDR,DCRContent,DCRRemark)
 	..Set ^CacheTemp(repid,ind)=Data
 	..Set ind=ind+1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindApplyRecodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApplyRecodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApplyRecodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApplyRecodeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(DHCBILLConfig.DHCBILLFIND).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// 2013-01-12
/// tangtao
/// 处理数据的不可见字符，ASCii表中前33位是不可见字符
/// Ext 前台在处理含不可见字符的jason数据时处理不了，查询不会显示数据，不会报错。
ClassMethod TR(Info)
{
	Quit:Info="" ""
	For i=0:1:32 Do
	.Set Info=$tr(Info,$c(i),"")
	.For j=0:1:32 Do
	..Set Info=$tr(Info,$c(i,j),"")
	
	Quit Info
}

/// 插入执行记录	
ClassMethod InsExecOEORE(OEORIRowId As %String, exDate As %String, Time, ExecQty, LinkOEORE As %String = "")
{
 s AdminQty=ExecQty
 s count=1
 s time=0 f  s time= $o(^OEORDi(0,"Date",+OEORIRowId,exDate,time)) q:time=""  d
 .s child = 0 f  s child=$o(^OEORDi(0,"Date",+OEORIRowId,exDate,time,$p(OEORIRowId,"||",2),child))  q:child=""  d
 ..s count=count+1
 if LinkOEORE="" {
 	s ret=..InsOEORE(OEORIRowId,exDate,Time,ExecQty,0,AdminQty,count,"","")
 	if +ret'=0  Q ret
 	s MastOEORERowId=$p(ret,"^",2)
 	s child=$O(^OEORDi(0,"OrdItem",+OEORIRowId,$p(OEORIRowId,"||",2),exDate,""),-1)
	if child'="" s LinkOEORE=OEORIRowId_"||"_child
 	s OEORIChildSub=0  F {
		s OEORIChildSub=$O(^OEORDi(0,"OEORI",+OEORIRowId,OEORIRowId,OEORIChildSub))
		Q:OEORIChildSub=""
		s SubRowId=+OEORIRowId_"||"_OEORIChildSub
		s itemStatDr = $p(^OEORD(+OEORIRowId,"I",OEORIChildSub,1),"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
		s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1) 
		if TItemStatCode="V"{
			
			d ..InsExecOEORE(SubRowId,exDate,Time,ExecQty,LinkOEORE)
		}
	}
	q MastOEORERowId
 }else{
	
	d ..InsOEORE(OEORIRowId,exDate,Time,ExecQty,0,AdminQty,count,LinkOEORE,"")
 }
 q 0
}

// 预约插入执行记录

ClassMethod InsOEORE(OEORIRowId, Date, Time, ExecQty, QtyOver, AdminQty, SeqNo, LinkOEORE, XTime, BillType)
{
	 ; Insert Profile Flag
	N (OEORIRowId,Date,Time,ExecQty,QtyOver,AdminQty,SeqNo,XTime,LinkOEORE)
	
	;如果本次执行记录已经生成,则退出?
 	;if $O(^OEORDi(0,"Date",+OEORIRowId,Date,Time,$P(OEORIRowId,"||",2),0)) Q 0
	;
	S OEORE(0)=OEORIRowId     
	S OEORE(26)=Date             ; OEORE_ExStDate
	S OEORE(27)=Time             ; OEORE_ExStTime
	S OEORE(16)=+ExecQty         ; OEORE_PhQtyOrd   (OEORI(29))
	S OEORE(42)=+AdminQty 		 ; OEORE_QtyAdmin    单次计费数量;add by zhouzq 2012.03.01
	S OEORE(43)="TB"
	if $g(BillType)="" {
		s OEORE(49)=$$GetDefaultBillType^DHCOEOrdExec(OEORIRowId)
	}else{
		s OEORE(49)=$g(BillType)
	}
	;小时医嘱用
	         
	if $g(XTime)'="" {
		s OEORE(63)=Date
		S OEORE(64)=XTime     ;S OEORE(36)=XTime
		s BillFlag="Y"
	}
	
	;use override qty
	;i $g(QtyOver)'="" s OEORE(16)=+QtyOver
	b ;hhhh
	Set $ZT="OnErr^DHCOEOrdExec"
	TS
	s err=0
	&SQL(Insert into OE_OrdExec Values :OEORE())
	i SQLCODE {
		s err=SQLCODE
		TRO
		Quit err
	}
	s OEORERowId=%ROWID
	s ItemStatus=$p(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),1),"^",13)
	;b ;LinkOEORE
	if $g(LinkOEORE)="" {
		&SQL(Update OE_OrdExecExt Set OEORE_OrderStatus_DR=:ItemStatus,OEORE_BlillFlag=:BillFlag Where OEORE_RowId=:OEORERowId)
	}else{
		&SQL(Update OE_OrdExecExt set OEORE_OEORE_DR=:LinkOEORE,OEORE_OrderStatus_DR=:ItemStatus,OEORE_BlillFlag=:BillFlag Where OEORE_RowId=:OEORERowId)	
	}
	i SQLCODE {
		s err=SQLCODE
		TRO
		Quit err
	}
	s err=..InsertOEDispensing(OEORERowId,SeqNo,ExecQty)
	if err {
		TRO 
		Quit err
	}
	TC
	q 0_"^"_OEORERowId
}

ClassMethod InsertOEDispensing(oeore As %String, seqno As %String, ExecQty As %String) As %String
{
	s oeitm=$P(oeore,"||",1,2)
	s arcim=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",2)
	Q:arcim="" 0
	
	;不发药的医嘱类型不用产生配药记录
	;s PriorityDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",8)
	;if ##class(appcom.OEOrdItem).ISUnDspOrderPrior(PriorityDR) Q 0
	
	s INCIrow=##class(appcom.OEDispensing).GetINCI(+arcim)
	Q:INCIrow="" 0

	s DateAdd=..%SysDate()
	s TimeAdd=..%SysTime()
	s DateExe=$P(^OEORD(+oeore,"I",$P(oeore,"||",2),"X",$P(oeore,"||",3)),"^",1)
	s TimeExe=$P(^OEORD(+oeore,"I",$P(oeore,"||",2),"X",$P(oeore,"||",3)),"^",2)

	s drgform=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",12)
	s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	s cattype=$p(^ARC("IC",arcgrp),"^",7)
	s PackQty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9)),"^",4)
	s phqtyord=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",12)
	s doseqty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",1)
	s uom=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)
	s recloc=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)
	s baseuom=$$baseuom^DHCDocOrderCommonNew(arcim)
	s FirstDayTimes=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",18)
	s:'doseqty doseqty=1 ;Dose Qty
	/*
	i cattype="R"{
		i PackQty="" {
			s dispqty=$$calcqty^DHCOEOrdItem(drgform,uom,doseqty)
			s TotalQty=dispqty
		}else{
			s convFac=##class(appcom.OEDispensing).convFac(arcim)
			s dispqty=PackQty*convFac
			s TotalQty=dispqty
		}
	}else{
		i phqtyord="" s phqtyord=1
		s dispqty=phqtyord
		s TotalQty=phqtyord
	}
	*/
	s Adm=$P(^OEORD(+oeore),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s EpLoc=admloc
	s admType=$P($g(^PAADM(Adm)),"^",2)
	if admType="I" s EpLoc=$P(^PAWARD($P($g(^PAADM(Adm)),"^",70)),"^",5)
	k OEDISP 
	s OEDISP(2)=oeitm,OEDISP(4)=oeore
	s OEDISP(5)=seqno
	s OEDISP(6)=+ExecQty,OEDISP(7)=baseuom,OEDISP(8)="TC",OEDISP(12)=+ExecQty
	s OEDISP(16)=DateAdd,OEDISP(17)=TimeAdd
	S OEDISP(3)=+ExecQty
	s OEDISP(21)=TimeExe,OEDISP(22)=DateExe
	s OEDISP(23)=EpLoc,OEDISP(24)=admloc,OEDISP(25)=recloc
	s OEDISP(27)=Adm
	s OEDISP(28)=##class(web.DHCSTCOMMONSRV).GetDspCatId(oeitm)

    &SQL(Insert into SQLUser.DHC_OEDispensing values :OEDISP())
    
    d ##class(appcom.OEDispensing).reserve(oeore,ExecQty)
    //d ..reserve(oeore,dispqty)
 	/* reserve^aOET1()已经有更新逻辑库存的处理
 	s INCILrow=$$GetINCIL(INCIrow,recloc)
 	i INCILrow'="" {
  		s err=$$UpdRes(INCILrow,TotalQty)
	}
 	*/

	Q SQLCODE
}

/// w ##class(web.DHCDocCureApp).GetOrdDetail("10||149")
ClassMethod GetOrdDetail(OEORIRowId As %String) As %String
{
   	Q:OEORIRowId="" ""
   	s OEORDRowId=+OEORIRowId
   	s OEORIChildsub=$p(OEORIRowId,"||",2)
   	s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 	s Subscript=$p(ItmMastrowid,"||",1)
 	s Version=$p(ItmMastrowid,"||",2)
 	s Phcdfdr=$p(^ARCIM(Subscript,Version,1),"^",12)
   	s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ItmMastrowid, "", "", "", "", "") 
 	s UnitPrice=$p(UnitPrice,"^",1)
 	s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 	i ARCIMDesc="" s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",3)
 	s BillingUOMdr=$p(^ARCIM(Subscript,Version,8),"^",14) //整包装单位
 	s packuom=$p(^CT("UOM",BillingUOMdr),"^",2)
 	s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 	s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 	s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 	s QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,9)),"^",4) //整包装数量
 	s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",1) //数量
 	s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
 	s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 	s UpdateDate=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",4)
 	s UpdateTime=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",5)
 	s OEORIBilled=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",5)     
 	s DoctorDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
 	i DoctorDR'="" s DoctorDesc=$p($g(^CTPCP(DoctorDR,1)),"^",2) e  s DoctorDesc=""
 	s DepProcNotes=""
 	s DepProcNotes=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DEP")),"^",1)
 	s OEORIDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",39)
 	if OEORIDR'="" s ARCIMDesc="____"_ARCIMDesc
 	if OEORIDR="" s OEORIDR=OEORDRowId_"||"_OEORIChildsub
 	i FrequenceRowid'="" s PHCFRDesc=$p($G(^PHCFR(FrequenceRowid)),"^",1)
 	s DoseUOM="" s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 	i InstructionRowid'="" s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",2) //用法
 	s DurationFactor=1
 	i DurationRowid'="" d
 	.s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
 	.s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 	s CTUOMDesc=""
 	i DoseUOM'="" s CTUOMDesc=$p($g(^CT("UOM",DoseUOM)),"^",2) //剂量单位
 	s PHCFRDesc=""
 	i FrequenceRowid'="" s PHCFRDesc=$p($g(^PHCFR(FrequenceRowid)),"^",3) //名称
 	s ReLocRowid="" s ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6) //接收科室 
 	s ReLoc="" s ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=$p(ReLoc,"-",2)
 	s DoseQty="" s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12)
 	s info=$g(ARCIMDesc)_"^"_$g(QtyPackUOM)_"^"_$g(packuom) _"^"_$g(DoseQty)_"^"_$g(CTUOMDesc)_"^"_$g(PHCINDesc)_"^"_$g(PHCFRDesc)_"^"_$zd($g(UpdateDate),3)_"^"_..%ZT($g(UpdateTime),3)_"^"_$g(DoctorDesc)_"^"_$g(DurationDesc)_"^"_""_"^"_$g(UnitPrice)_"^"_$g(OEORIDR)_"^"_$g(DepProcNotes)_"^"_$g(ReLoc)_"^"_$g(DoseQty)_"^"_OEORIBilled
	q info
}

ClassMethod GetCardTypeInfo(myTypeID As %String) As %String
{
	Q:myTypeID="" ""
	Q $g(^DHCCARDTYPEDef(myTypeID))
}

ClassMethod GetOrderMesage(OrderIDInput As %String = "") As %String
{
	s OrderID=+OrderIDInput
	s SubID=$P(OrderIDInput,"||",2) 
	Q:((OrderID="")||(SubID="")) ""
	s AdmRowID=$P($G(^OEORD(OrderID)),"^",1)
	s PatType=$P(^PAADM(AdmRowID),"^",2)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmRowID,"DHC")),"^",25)
	s GetStr=$$GetOEORIMesage(OrderID,SubID,PatType,AdmRowID)
	Q GetStr
GetOEORIMesage(OrderID,SubID,PatType,AdmRowID)
	s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2)  ;
	s statcode="V"
	s statDesc="核实"
	s TtemStat=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",13) ;OEORI_Billed
	i TtemStat'="" d
	.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	.s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2)
	;Q:($g(statcode)'="V")&&(OrderIDInput="") ""
	s OrderBilled=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",5) ;OEORI_Billed
	;Q:(OrderBilled="P")&&(OrderIDInput="") ""
	s OrderDoseUOMRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",3) ;OEORI_Unit_DR
	s ARCIMPHCDFDR=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",12) ;OEORI_ItmMast_DR->ARCIM_PHCDF_DR
	s OrderDoseQty=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",1) ;OEORI_DoseQty
	s InsType=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s OrderSttDate=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",9) ;OEORI_SttDat
	s OrderPriorRowid=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",8) ; OEORI_Priority_dr
	s OrderInstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7) ; OEORI_Instr_DR
	s OrderLinkTo=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",1)  ;OEORI_LinkToOrder
	s OEORIPrice=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",25)  ;OEORI_Price 自定义价格
	s OrderRecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6) ;OEORI_RecDep_DR
	s OEORIOEORIDR=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",39) ;OEORI_OEORI_DR ；关联医嘱ID
	s OrderRecDep=""
	if OrderRecDepRowid'="" s OrderRecDep=$P(^CTLOC(OrderRecDepRowid),"^",2)
	if OrderRecDep["-" s OrderRecDep=$P(OrderRecDep,"-",2)
	s OrderBillTypeRowid=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s OrderType=""
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) ; OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
	s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4) ;OEORIQtyPackUOM
	s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14) 
	s OrderPackUOM=""
	if ARCIMBillingUOM'="" d
	.s OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOM),"^",2)  ;OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc
	;协议单位
	s ProtocolPackUOMDR=$p($g(^OEORD(OrderID,"I",SubID,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" d
	. s ARCIMBillingUOM=ProtocolPackUOMDR
	. s OrderPackUOM=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
	;
	s OrderPrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14) ;OEORI_PrescNo
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	s OrderDurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6) ;OEORI_Durat_DR
	s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1) ;下医嘱人
	if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	s UserDepart=""  ;下医嘱科室
	s UserDepartId=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",2)
	If UserDepartId'=""  d
	.Set UserDepart=$P($G(^CTLOC(UserDepartId)),"^",2)
	.if UserDepart["-" s UserDepart=$P(UserDepart,"-",2)
	s XUser=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",29)	;停医嘱人
	if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",7)	;下医嘱日期
	if OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",17)	;下医嘱时间
	if OrderTime'="" s OrderTime=..%ZT(OrderTime,2)
	s OrderStarDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9) ;医嘱开始日期
	if OrderStarDate'="" s OrderStarDate=$zd(OrderStarDate,3)
	s OrderStarTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) ;医嘱开始时间
	if OrderStarTime'="" s OrderStarTime=..%ZT(OrderStarTime,2)
	s OrderEndDate=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",9) ;医嘱结束日期
	if OrderEndDate'="" s OrderEndDate=$zd(OrderEndDate,3)
	s OrderEndTime=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",10) ;医嘱结束时间
	if OrderEndTime'="" s OrderEndTime=..%ZT(OrderEndTime,2)
	s OrderXDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34) ;医嘱停止日期
	if OrderXDate'="" s OrderXDate=$zd(OrderXDate,3)
	s OrderXTime=$p($g(^OEORD(OrderID,"I",SubID,2)),"^",15) ;医嘱停止时间
	if OrderXTime'="" s OrderXTime=..%ZT(OrderXTime,2)
	s LabEpisodeNo=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",20) ;标本号
	s OrdLabSpec=$$GetSpecDesc(OrderID_"||"_SubID) ;标本
	s MaterialBarCode=$p($G(^OEORD(OrderID,"I",SubID,"DHC")),"^",14) ;高值条码
	s OrdSkinTest=$p($g(^OEORD(OrderID,"I",SubID,5)),"^",2) ;皮试
	s OrdAction=$p($g(^OEORD(OrderID,"I",SubID,11)),"^",21)	;皮试备注
	i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	s OrdDepProcNotes=$g(^OEORD(OrderID,"I",SubID,"DEP",1)) ;备注
	s OrdSkinTestResult=""	;皮试结果
	i OrdSkinTest="Y" d
	.s abnorm=$p($g(^OEORD(OrderID,"I",SubID,11)),"^",3)
	.i abnorm="Y" s OrdSkinTestResult="阳性"
	.i abnorm="N" s OrdSkinTestResult="阴性"
	s PriorRowid=""
	s InstrRowid=""
	s LinkTo=""
	s OEPrice=""
	s OrderBillType=""
	s Qty=##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	s ExpStr=OrderID_"||"_SubID_"^"_""_"^"_AdmRowID_"^"_OrderRecDepRowid
	;转换系数
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimID)
	s ConFac=1
	if (INCIRowid'="")&&(OrderPackUOM'="")  d
	.s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimID,INCIRowid,OrderPackUOM)
	;通过转换系数转成基本单位
	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ArcimID, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s OrderPrice=$fn($P(retPrice,"^",1),"",4)
	i OEORIPrice'="" s OrderPrice=OEORIPrice  ;如果自定义价格存在则使用自定义价格
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P($G(^PAC("ADMREA",OrderBillTypeRowid)),"^",2)
	i OrderDoseQty'="" d
	. i OrderDoseQty<1 s OrderDoseQty="0"_$number(OrderDoseQty)
	i OrderType'="R" d
	.s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	.s OrderPackQty=DoseqtySum
	;s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderPackQty'="" d
	. i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	s DepProcNotes=$g(^OEORD(OrderID,"I",SubID,"DEP",1))
	if (((OrderPackQty=0)||(OrderPackQty=""))&&(OrderType="R"))  d  ;如果没有填数量则自动计算数量
	.s Qty=##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	.s OrderPrice=$fn((OrderPrice/ConFac),"",4)  ;整包装的单价要转换
	.s DiscPrice=$fn((DiscPrice/ConFac),"",4)
	.s InsPrice=$fn((InsPrice/ConFac),"",4)
	.s PatPrice=$fn((PatPrice/ConFac),"",4)
	.s OrderPackQty=+Qty*$P(^PHCFR(OrderFreqRowid),"^",2)*$P(^PHCDU(OrderDurRowid),"^",2)
	.s OrderSum=(OrderPackQty*OrderPrice)
	.s bsUOMph=$p($g(^PHCD(+ARCIMPHCDFDR,"DF",$p(ARCIMPHCDFDR,"||",2),2)),"^",4)
	.s BaseUomDesc=$P(^CT("UOM",bsUOMph),"^",2)
	.;展示的时候单位和数量匹配
	.s OrderPackUOM=BaseUomDesc
	s OrderSum=$fn(OrderSum,"",4)
	s statcode=statcode_","_statDesc
	;按照基本单位退药单位和返回的数量单位一直
	s HaveDispensing=0,dstatus=""
	s DspConfirmQty=0     
	s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OrderID_"||"_SubID,dis)) Q:dis=""  d
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.s HaveDispensing=1
	.i dstatus="R" d                             
	..s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)  
	..s DspConfirmQty=DspConfirmQty+dconfirmqty  
	i DspConfirmQty'="" d
	.s DspConfirmQty=DspConfirmQty
	i HaveDispensing=1 d
	.i dstatus="C" s dstatus="已发"
	.i dstatus="TC" s dstatus="未发"
	.i dstatus=""  s dstatus="未打包"
	.i dstatus="R" s dstatus="已退药"
	s ValueNU=(OrderPackQty-DspConfirmQty) 
	s ValueSum=ValueNU*OrderPrice	;有效价格
	s ValueSum=$fn(ValueSum,"",4)
	s ValueNU=ValueNU_OrderPackUOM	;有效数量
	s DspConfirmQty=DspConfirmQty_OrderPackUOM ;退药数量
	;医嘱ID，医嘱名称，医嘱价格，医嘱数量，数量单位，接收科室，处方号，单价,收费状态，医嘱状态
	;医嘱有效价格(部分退药后剩下的价格,如果没有退药和医嘱价格相同),有效数量,退药数量,医嘱发药状态
	;下医嘱人,下医嘱科室,停医嘱人,
	;下医嘱日期，下医嘱时间，医嘱开始日期，遗嘱开始时间，医嘱结束日期，医嘱结束时间，医嘱停止日期，医嘱停止时间
	;标本号；标本,是否皮试标志(Y),皮试备注，皮试结果，医嘱备注
	;高值条码
	s Str=OrderID_"||"_SubID_"^"_OrderName_"^"_OrderSum_"^"_OrderPackQty_"^"_OrderPackUOM_"^"_OrderRecDep_"^"_OrderPrescNo_"^"_OrderPrice_"^"_OrderBilled_"^"_statcode
    s Str=Str_"^"_ValueSum_"^"_ValueNU_"^"_DspConfirmQty_"^"_dstatus
    s Str=Str_"^"_UserAdd_"^"_UserDepart_"^"_XUser
    s Str=Str_"^"_OrderDate_"^"_OrderTime_"^"_OrderStarDate_"^"_OrderStarTime_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderXDate_"^"_OrderXTime
    s Str=Str_"^"_LabEpisodeNo_"^"_OrdLabSpec_"^"_OrdSkinTest_"^"_OrdAction_"^"_OrdSkinTestResult_"^"_OrdDepProcNotes
    s Str=Str_"^"_MaterialBarCode_"^"_OEORIOEORIDR_"^"_OrderRecDepRowid
    Q Str
GetSpecDesc(OrderItemRowid)
 s SpecStr=""
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
 s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 . s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 . s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 . i SpecStr="" s SpecStr=SpecDesc
 . e  s SpecStr=SpecStr+","+SpecDesc
 Q SpecStr
}

Query FindCureApplyAppDoctorList(cardType As %String, cardNo As %String, patNo As %String, sttDate As %String, endDate As %String, LocID As %String) As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex :%String,PatAge:%String,PatType:%String,PatTel:%String,PatAddress:%String,DCAUser:%String,DCAAppDate:%String,DCAAppTime:%String,DCAAppPlan:%String")
{
}

ClassMethod FindCureApplyAppDoctorListExecute(ByRef qHandle As %Binary, cardType As %String, cardNo As %String = "", patNo As %String = "", sttDate As %String = "", endDate As %String = "", LocID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCureApplyAppDoctorList","","","","","",29)
	b ;
	s ^TMP("FindCureApplyAppArriveList")=cardType_"^"_cardNo_"^"_patNo_"^"_sttDate_"^"_endDate_"^"_ LocID
	Set repid=$I(^CacheTemp)
	Set ind=1
	s UserDr=%session.Get("LOGON.USERID")
	if sttDate="" s sttDate=..%SysDate()
	else  s sttDate=$zdh(sttDate,3)
	if endDate="" s endDate=..%SysDate()
	else  s endDate=$zdh(endDate,3)
	s PatientID=""
	if (cardType'="")&&(cardNo'="") 
	{
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(cardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0")  d
		.s PatientID=$P(ret,"^",8)
	}
	if patNo'=""  d
	.Set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(patNo,"U"),0))
	if ((cardNo'="")||(patNo'=""))&&(PatientID="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	For AppDate=sttDate:1:endDate
	{ 
		continue:'$D(^DHCDocCure(0,"ApplyDate1",AppDate))
		continue:'$D(^DHCDocCure(0,"ApplyDate1",AppDate,UserDr))
		s DCARowId=0
		For{
			s DCARowId=$o(^DHCDocCure(0,"ApplyDate1",AppDate,UserDr,DCARowId))
			q:DCARowId=""
			s AppInfo=^DHCDocCure(DCARowId)
			q:AppInfo=""
			Set AdmId=$p(AppInfo,"^",1) //就诊ID
			s AppPatientID=$P(^PAADM(AdmId),"^",1)
			q:(PatientID'="")&&(PatientID'=AppPatientID)
			s Patinfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(AppPatientID)
			s PatNo=$p(Patinfo,"^",2)
			s PatName=$p(Patinfo,"^",3)
			s PatSex=$p(Patinfo,"^",4)
			s PatAge=$p(Patinfo,"^",5)
			s PatType=$p(Patinfo,"^",7)
			s PatTel=$p(Patinfo,"^",25)
			s PatAddress=$p(Patinfo,"^",11)
			Set DCAUser=$p(AppInfo,"^",3) //申请人
			Set:DCAUser'="" DCAUser=$P(^SSU("SSUSR",DCAUser),"^",2)
			Set DCAAppDate=$p(AppInfo,"^",4) //申请日期
			Set DCAAppTime=$p(AppInfo,"^",5) //申请时间
			Set DCAAppPlan=$p(AppInfo,"^",11) //治疗方案
			set Data=$lb(DCARowId,PatNo,PatName,PatSex,PatAge,PatType,PatTel,PatAddress,DCAUser,DCAAppDate,DCAAppTime,DCAAppPlan)
 			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
			
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindCureApplyAppDoctorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyAppDoctorListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyAppDoctorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyAppDoctorListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryApplyList(sttDate As %String, endDate As %String, LocID As %String) As %Query(ROWSPEC = "LocDesc:%String,UserName:%String,DCAArcimDesc:%String,Qty:%String,Price:%String,sum:%String,RowId:%String")
{
}

ClassMethod QueryApplyListExecute(ByRef qHandle As %Binary, sttDate As %String = "", endDate As %String = "", LocID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","QueryApplyList","2016-01-01","","")
	s ^TMP("FindCureApplyAppArriveList")=sttDate_"^"_endDate_"^"_ LocID
	Set repid=$I(^CacheTemp)
	Set ind=1
	if sttDate="" s sttDate=..%SysDate()
	else  s sttDate=$zdh(sttDate,3)
	if endDate="" s endDate=..%SysDate()
	else  s endDate=$zdh(endDate,3)
	For AppDate=sttDate:1:endDate
	{ 
		continue:'$D(^DHCDocCure(0,"DCRDate",AppDate))
		s DCARowId=0
		For{
			s DCARowId=$o(^DHCDocCure(0,"DCRDate",AppDate,DCARowId))
			q:DCARowId=""
			s DCACChildSub=0
			For{
				s DCACChildSub=$o(^DHCDocCure(0,"DCRDate",AppDate,DCARowId,DCACChildSub))
				q:DCACChildSub=""
				s DCRChildSub=0
				For{
					s DCRChildSub=$o(^DHCDocCure(0,"DCRDate",AppDate,DCARowId,DCACChildSub,DCRChildSub))
					q:DCRChildSub=""
					s Info=^DHCDocCure(DCARowId,"CureItem",DCACChildSub,"Recode",DCRChildSub) 
					q:Info=""
					s UserDr=$p(Info,"^",4)
					s UserName=""
					s:UserDr'="" UserName=$P(^SSU("SSUSR",UserDr),"^",2)
					s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
					s:DCAOEORIDR'="" Loc=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
					s LocDesc=""
					s:Loc'="" LocDesc=$P($G(^CTLOC(Loc)),"^",2)
					s DCAArcimDesc="",ArcimRowid=""
					if DCAOEORIDR'="" {
					s ArcimRowid=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
					s:ArcimRowid'="" DCAArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
					}
					s DCROEOREDR=$p(Info,"^",1)
					s Qty=""
					s:DCROEOREDR'="" Qty=$p($g(^OEORD(+DCROEOREDR,"I",$p(DCROEOREDR,"||",2),"X",$p(DCROEOREDR,"||",3))),"^",4)
					s OrdDetail=..GetOrdDetail(DCAOEORIDR)
					s Price=$p(OrdDetail,"^",13)
					s RowId=DCARowId_"||"_DCACChildSub
					s sum=Qty*Price
					s Data=$lb(LocDesc,UserName,DCAArcimDesc,Qty,Price,sum,RowId)
    				s ^CacheTemp(repid,ind)=Data
 					s ind=ind+1 
					
				}
				
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryApplyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
