/// 治疗项目设置 操作类
Class DHCDoc.DHCDocCure.CureItemSet Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询治疗项目子类下的所有治疗项目
Query FindCureItem(ItemCat As %String, ItemDesc As %String) As %Query(ROWSPEC = "Rowid:%String,ItemRowid:%String,ArcimDesc:%String,ActiveFlag:%String")
{
}

ClassMethod FindCureItemExecute(ByRef qHandle As %Binary, ItemCat As %String, ItemDesc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItem")
	s ^TMP("FindCureItem")=ItemCat_"^"_ItemDesc
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if ItemCat="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ItemMast="" f  s ItemMast=$O(^ARCIM(0,"ARCIC_DR",ItemCat,ItemMast)) q:(ItemMast="")  d
 	.s ItemSub="" f  s ItemSub=$o(^ARCIM(0,"ARCIC_DR",ItemCat,ItemMast,ItemSub)) q:(ItemSub="")  d
 	..s ItemRowid=ItemMast_"||"_ItemSub
 	..q:'$d(^ARCIM(ItemMast,ItemSub))
 	..s ArcimDesc=$p($g(^ARCIM(ItemMast,ItemSub,1)),"^",2)
 	..s ArcimDesc=$tr($tr($tr(ArcimDesc,$c(10),""),$c(13),""),"\","")
 	..q:(ItemDesc'="")&&(ArcimDesc'[ItemDesc)
 	..s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ItemRowid,"")
    ..i DDCISRowid'="" d
    ...s ActiveFlag="是"
    ...s DDCISActive=$p(^DHCDocCureItemSet(DDCISRowid),"^",10)
    ...if DDCISActive'="Y" s ActiveFlag="否"
    ..else  s ActiveFlag="否"
	..d OutputRowFindCureItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItem
	Set Data=$lb(DDCISRowid,ItemRowid,ArcimDesc,ActiveFlag)
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

Query FindCureItemCat() As %Query(ROWSPEC = "ItemCatId:%String,ItemCatDesc:%String")
{
}

ClassMethod FindCureItemCatExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItemCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat"))
 	f i=1:1:$l(DHCDocCureItemCatStr,"^")  d
 	.s ARCICRowId=$p(DHCDocCureItemCatStr,"^",i)
 	.q:ARCICRowId=""
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s ARCICDesc=##class(ext.util.String).EvalJSON(ARCICDesc)
	.Do OutputRowFindCureItemCat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItemCat
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemCatExecute ]
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

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemSet("86^6615||1^^41^^^^^^Y^Y^Y")
ClassMethod SaveCureItemSet(str As %String, HospID As %String) As %String
{
	n (str,HospID,%session)
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s ^TMP("SaveCureItemSet")=str
	Q:str="" -1
	Set DDCISRowid=$P(str,"^")
	Set ItemRowid=$P(str,"^",2)
	Set ShortName=$P(str,"^",3)
	Set ServiceGroupDR=$P(str,"^",4)
	Q:('$D(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR))) -2
	Set AutoAppFlag=$P(str,"^",5)
	Set Effect=$P(str,"^",6)
	Set Indication=$P(str,"^",7)
	Set Avoid=$P(str,"^",8)
	Set ManualApply=$P(str,"^",9)
	Set ApplyExec=$P(str,"^",10)
	Set ActiveFlag=$P(str,"^",11)
	if ActiveFlag="" s ActiveFlag="Y"
	set IPApplyExec=$P(str,"^",12)
	set RelateAssTemp=$P(str,"^",13)
	set RelateRecordTemp=$P(str,"^",14)
	K PLIST
	s PLIST(2)=ItemRowid
	s PLIST(3)=ShortName
	s PLIST(4)=ServiceGroupDR
	s PLIST(5)=AutoAppFlag
	s PLIST(6)=Effect
	s PLIST(7)=Indication
	s PLIST(8)=Avoid
	s PLIST(9)=ManualApply
	s PLIST(10)=ApplyExec
	s PLIST(11)=ActiveFlag
	s PLIST(12)=IPApplyExec
	s PLIST(13)=HospID
	s PLIST(14)=RelateAssTemp
	s PLIST(15)=RelateRecordTemp
	if DDCISRowid="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCureItemSet values :PLIST())
	}else{
		&sql(update SQLUser.DHC_DocCureItemSet values :PLIST() where DDCIS_Rowid=:DDCISRowid )
	}
	q SQLCODE
}

ClassMethod DeleteCureItemSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureItemSet where DDCIS_Rowid=:Rowid)
	 q SQLCODE
}

/// w ##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem("6040||1",3)
ClassMethod GetDDCISIDByItem(ArcimId As %String, HospID As %String)
{
	n (ArcimId,HospID,%session)
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	Q:ArcimId="" ""
	Q:HospID="" ""
	s DDCISRowid=""
	s DDCISRowid=$o(^DHCDocCureItemSet(0,"HospItmMast",HospID,ArcimId,""))
	Q DDCISRowid
}

/// w ##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByDCA("6")
ClassMethod GetDDCISIDByOrd(OrderId As %String, HospID As %String = "")
{
	n (OrderId,HospID,%session)
	s DDCISRowid=""
	;s OrderRecLocDr=$P(^OEORD(+OrderId,"I",$P(OrderId,"||",2),3),"^",6)
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	if (HospID="")&&(OrderAddDeptDr'=""){
		s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
	}
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	if ArcimId'=""{
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
	}
	Q DDCISRowid
}

/// 取治疗项目的设置信息
/// w ##class(DHCDoc.DHCDocCure.CureItemSet).GetCureItemSet("","6410||1")
ClassMethod GetCureItemSet(DDCISRowid As %String, ArcimId As %String, HospID As %String) As %String
{
	n (DDCISRowid,ArcimId,HospID,%session)
	Quit:ArcimId="" ""
	s ArcimCode=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	if DDCISRowid=""{
		s DDCISRowid=..GetDDCISIDByItem(ArcimId,HospID)
	}
	s ServiceGroupActive=1
	if DDCISRowid'="" 
	{
	   s ShortName=$p(^DHCDocCureItemSet(DDCISRowid),"^",2)
	   s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	   s ServiceGroupActive=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).CheckServiceGroupActive(ServiceGroupDR)
	   if ServiceGroupActive=0 s ServiceGroupDR=""
	   s AutoAppFlag=$p(^DHCDocCureItemSet(DDCISRowid),"^",4)
	   s Effect=$p(^DHCDocCureItemSet(DDCISRowid),"^",5)
	   s Indication=$p(^DHCDocCureItemSet(DDCISRowid),"^",6)
	   s Avoid=$p(^DHCDocCureItemSet(DDCISRowid),"^",7)
	   s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
	   s ApplyExec=$p(^DHCDocCureItemSet(DDCISRowid),"^",9)
	   s Active=$p(^DHCDocCureItemSet(DDCISRowid),"^",10)
	   s IPApplyExec=$p(^DHCDocCureItemSet(DDCISRowid),"^",11)
	   s RelateAssTemp=..GetRelateTemp(DDCISRowid,"A")
	   s RelateRecordTemp=..GetRelateTemp(DDCISRowid,"R")
	}
	s rtn=ArcimCode_"^"_ArcimDesc_"^"_$g(ShortName)_"^"_$g(ServiceGroupDR)_"^"_$g(AutoAppFlag)
	s rtn=rtn_"^"_$g(Effect)_"^"_$g(Indication)_"^"_$g(Avoid)_"^"_$g(ManualApply)_"^"_$g(ApplyExec)
	s rtn=rtn_"^"_$g(ServiceGroupActive)_"^"_$g(Active)_"^"_$g(IPApplyExec)_"^"_$g(RelateAssTemp)_"^"_$g(RelateRecordTemp)
	q rtn
}

ClassMethod GetRelateTemp(DDCISRowid As %String, TempType As %String)
{
	n (DDCISRowid,TempType,%session)
	s LANGID=..%LanguageID()
	s (NewRelateTemp,RelateTempDesc)=""
	s TempSeq=$case(TempType,"A":13,"R":14,:0) ;A:评估模板 R:治疗记录模板
	s RelateTemp=$p(^DHCDocCureItemSet(DDCISRowid),"^",TempSeq)
	if RelateTemp'=""{
		for loop=1:1:$l(RelateTemp,","){
			s mRelateTemp=$p(RelateTemp,",",loop)
			s mRelateTempDesc=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",2)
			s mRelateTempDesc=##class(User.DHCDocAppBLMap).GetTranByDesc("APPMapName",mRelateTempDesc,LANGID)
			s mRelateTempActive=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",4)
			continue:mRelateTempActive="N"
			if RelateTempDesc="" s RelateTempDesc=mRelateTempDesc
			else  s RelateTempDesc=RelateTempDesc_","_mRelateTempDesc
			if NewRelateTemp="" s NewRelateTemp=mRelateTemp
			else  s NewRelateTemp=NewRelateTemp_","_mRelateTemp
		}
	}
	s ret=NewRelateTemp ;_"^"_RelateAssTempDesc
	Q ret
}

/// Desc:保存治疗项目维护的治疗方案信息
/// Input:DDCISPRowid:治疗方案ID,若不含"||",则为新增,否则为更新
/// 	  PlanTitle:方案标题
/// 	  PlanDetail:方案内容
/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemSetPlan(92,1,2)
ClassMethod SaveCureItemSetPlan(DDCISPRowid As %String, PlanTitle As %String, PlanDetail As %String, Type As %String)
{
	Quit:DDCISPRowid="" "-100"
	set myrtn=0
	if $l(DDCISPRowid,"||")>1{
		set PlanObj=##class(User.DHCDocCureItemSetPlan).%OpenId(DDCISPRowid)
	}else{
		set PlanObj=##class(User.DHCDocCureItemSetPlan).%New(DDCISPRowid)
	}
	if $IsObject(PlanObj){
		do PlanObj.DDCISPParRefSetObjectId(DDCISPRowid)
		set PlanObj.DDCISPPlanTitle=PlanTitle
		set PlanObj.DDCISPPlanDetail=PlanDetail
		set PlanObj.DDCISPType=Type
		set sc=PlanObj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-101"
		}
	}else{
		set myrtn="-102"	
	}
	Quit myrtn
}

ClassMethod GetPlanDetailByID(DDCISPRowid As %String)
{
	set PlanObj=##class(User.DHCDocCureItemSetPlan).%OpenId(DDCISPRowid)
	if '$IsObject(PlanObj) Q ""
	set PlanDetail=PlanObj.DDCISPPlanDetail
	Quit PlanDetail
}

ClassMethod DelCureItemSetPlan(DDCISPRowid As %String)
{
	Quit:DDCISPRowid="" "-100"
	set myrtn=0
	&sql(delete SqlUser.DHC_DocCureItemSetPlan where DDCISP_Rowid=:DDCISPRowid)
	Quit SQLCODE
}

Query FindCureItemPlan(DDCISRowid As %String, Query As %String = "", Type As %String = "") As %Query(ROWSPEC = "PlanTitle:%String,PlanDetail:%String,PlanRowID:%String,PlanType:%String,PlanTypeVal:%String")
{
}

ClassMethod FindCureItemPlanExecute(ByRef qHandle As %Binary, DDCISRowid As %String, Query As %String = "", Type As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItemPlan","92")
	Set repid=$I(^CacheTemp)
    Set ind=1
    if DDCISRowid=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK    
	}
    s DDCISPChildSub=0
    for  s DDCISPChildSub=$o(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub)) Q:DDCISPChildSub=""  d
 	.s PlanTypeVal=$p(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub),"^",3)
 	.s:PlanTypeVal="" PlanTypeVal="P"
 	.Q:(Type'="")&&(Type'=PlanTypeVal)
 	.s PlanTitle=$p(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub),"^",1)
 	.s PlanTitle=##class(ext.util.String).EvalJSON(PlanTitle)
 	.s PlanDetail=$p(^DHCDocCureItemSet(DDCISRowid,"P",DDCISPChildSub),"^",2)
 	.s PlanDetail=##class(DHCDoc.DHCDocCure.Util).CureEvalJSON(PlanDetail)
 	.if (Query=1)&&($l(PlanDetail)>25) d
 	..s PlanDetail=$e(PlanDetail,1,25)_"..."
 	.s PlanRowID=DDCISRowid_"||"_DDCISPChildSub
 	.s PlanType=$case(PlanTypeVal,"N":"备注",:"方案")
	.Do OutputRowFindCureItemPlan
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCureItemPlan
	set Data=$lb($g(PlanTitle),$g(PlanDetail),PlanRowID,PlanType,PlanTypeVal)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemPlanExecute ]
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

/// Desc:保存治疗项目维护的绑定医嘱信息
/// Input:DDCISPRowid:治疗方案ID,若不含"||",则为新增,否则为更新
/// 	  AppendItemStr:绑定医嘱信息串
/// 	 
/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemAppendItem(^tmpnk("SaveCureItemAppendItem"))
ClassMethod SaveCureItemAppendItem(params As %String)
{
	s ^tmpnk("SaveCureItemAppendItem")=params
	s DDCIAIRowid=$p(params,"^",1)
	s ItemMastDr=$p(params,"^",2)
	s ItemQty=$p(params,"^",3)
	s AdmLocDr=$p(params,"^",4)
	s RecLocDr=$p(params,"^",5)
	s DefaultFlag=$p(params,"^",6)
	set myrtn=0
	set myrtn=..isExistSameItem(DDCIAIRowid,ItemMastDr)
	if +myrtn'=0{
		Q myrtn
	}
	if $l(DDCIAIRowid,"||")>1{
		set Obj=##class(User.DHCDocCureItemAppendItem).%OpenId(DDCIAIRowid)
	}else{
		set Obj=##class(User.DHCDocCureItemAppendItem).%New(DDCIAIRowid)
	}
	if $IsObject(Obj){
		do Obj.DDCIAIParRefSetObjectId(DDCIAIRowid)
		do Obj.DDCIAIItemMastDrSetObjectId(ItemMastDr)
		do Obj.DDCIAIAdmLocDrSetObjectId(AdmLocDr)
		do Obj.DDCIAIRecLocDrSetObjectId(RecLocDr)
		set Obj.DDCIAIQty=ItemQty
		set Obj.DDCIAIDefaultFlag=DefaultFlag
		set sc=Obj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-101"
		}
	}else{
		set myrtn="-102"	
	}
	Quit myrtn
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript   : 判断相同的分类，是否关联相同的医嘱子类
/// Table      ：DHC_DocCureArcCat,DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).isExistSamearcCat("^1^胆道镜^116")
ClassMethod isExistSameItem(Rowid As %String, ItemMastDr As %String) As %String
{
	n (Rowid,ItemMastDr)
	s ret=0
	s DDCIAIParRef=+Rowid
	Q:DDCIAIParRef=0 ret
	s ChildSub=""
	f  s ChildSub=$o(^DHCDocCureItemSet(DDCIAIParRef,"AI",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	.s DDCIAIRowid=DDCIAIParRef_"||"_ChildSub
	.s DDCIAIItemMastDr=$p(^DHCDocCureItemSet(DDCIAIParRef,"AI",ChildSub),"^",1)
	.Q:($l(DDCIAIRowid,"||")>1)&&(DDCIAIRowid=Rowid)
	.q:DDCIAIItemMastDr'=ItemMastDr
	.s ret="-11"
	q ret
}

ClassMethod DelCureItemAppendItem(DDCIAIRowid As %String)
{
	Quit:DDCIAIRowid="" "-100"
	set myrtn=0
	&sql(delete SqlUser.DHC_DocCureItemAppendItem where DDCIAI_Rowid=:DDCIAIRowid)
	Quit SQLCODE
}

Query FindCureItemAppendItem(DDCIAIRowid As %String, Episodeid As %String, CTLoc As %String, ProirityRowId As %String = "", OpenForAllHosp As %String = "") As %Query(ROWSPEC = "CureAppRowId:%String,CureAppItemID:%String,CureAppItemDesc:%String,CureAppItemQty:%String,CureAppItemRecLoc:%String,CureAppItemRecLocID:%String,RecLocStr:%String,Price:%String,TotalPrice:%String,CureAppItemType:%String")
{
}

ClassMethod FindCureItemAppendItemExecute(ByRef qHandle As %Binary, DDCIAIRowid As %String, Episodeid As %String, CTLoc As %String, ProirityRowId As %String = "", OpenForAllHosp As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCureItemAppendItem","11,"285","")
	s ^tmplog("FindCureItemAppendItem")=$lb(DDCIAIRowid,Episodeid,CTLoc,ProirityRowId,OpenForAllHosp)
    if DDCIAIRowid=""{
		Quit $$$OK    
	}
	s langid=..%LanguageID()
	s admType=$P($g(^PAADM(Episodeid)),"^",2)
	s admLoc=$P($g(^PAADM(Episodeid)),"^",4)
	if admType="I" {
		s PACWardID=$P($g(^PAADM(Episodeid)),"^",70)
		s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	}else{
		s EpLoc=$P($g(^PAADM(Episodeid)),"^",4)
	}
    s DDCIAIChildSub=0
    for  s DDCIAIChildSub=$o(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub)) Q:DDCIAIChildSub=""  d
 	.s AppendId=DDCIAIRowid_"||"_DDCIAIChildSub
 	.s data=$g(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
 	.s AppendItemDr=$p(data,"^",1)
 	.s AppendItem=##class(web.DHCDocOrderCommon).GetFormateOrderName(AppendItemDr)
 	.s AppendItem=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",AppendItem,langid)
 	.s AppendItem=##class(ext.util.String).EvalJSON(AppendItem)
 	.s AppendItemQty=$p(data,"^",2)
 	.s AppendAdmLocID=$p(data,"^",3)
 	.s AppendRecLocID=$p(data,"^",4)
 	.s AppendDefaultFlag=$p(data,"^",5)
 	.s RecLocStr=..GetAppendItemRecLoc(AppendItemDr,Episodeid,CTLoc,AppendRecLocID,ProirityRowId,OpenForAllHosp) //EpLoc
 	.s AppendRecLocID=$p(RecLocStr,$c(1),2)
 	.s AppendRecLoc=""
 	.s:AppendRecLocID'="" AppendRecLoc=$p(^CTLOC(AppendRecLocID),"^",2)
 	.s AppendRecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AppendRecLoc,langid)
 	.s RecLocStr=$p(RecLocStr,$c(1),1)
 	.s Price=##class(DHCDoc.DHCDocCure.Apply).GetPrice(Episodeid,AppendItemDr,AppendRecLocID,"","")
 	.s Price=$fn(Price,"",2)
 	.s TotalPrice=""
 	.if +AppendItemQty>0 d
 	..s TotalPrice=AppendItemQty*Price
 	..s TotalPrice=$fn(TotalPrice,"",2)
 	.s ItemCatDr=$p(^ARCIM(+AppendItemDr,$p(AppendItemDr,"||",2),1),"^",10)
	.s AppItemType=$P(^ARC("IC",ItemCatDr),"^",7)
	.Do OutputRowAppendItem
	Quit $$$OK
OutputRowAppendItem
	set Data=$lb(AppendId,$g(AppendItemDr),$g(AppendItem),AppendItemQty,AppendRecLoc,AppendRecLocID,RecLocStr,Price,TotalPrice,AppItemType)
 	Set qHandle($I(ind))=Data
	Quit
}

ClassMethod FindCureItemAppendItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemAppendItemExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetAppendItemRecLoc(ItemRowID As %String, EpisodeId As %String, LogDepRowid As %String, DefaultRecLoc As %String, ProirityRowId As %String = "3", ExpStr As %String = "")
{
	n (ItemRowID,ProirityRowId,EpisodeId,LogDepRowid,DefaultRecLoc,ExpStr,%session)
	s OpenForAllHosp=""
	if ExpStr'=""{
		s OpenForAllHosp=$p(ExpStr,"^",1)	
	}
	s FindExpStr="^"_OpenForAllHosp
	s LocStr=""
	s FindDefault=""
	s rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply:CombListFind")
	if rset.QueryIsValid() { 
		s Status=rset.Execute("DHCDocOrderRecLoc",ItemRowID,"",ProirityRowId,EpisodeId,LogDepRowid,"N",FindExpStr)
		if 'Status Quit
		s columns = rset.GetColumnCount()
		While (rset.Next()) {
			s Desc=rset.GetData(1)
			s Value=rset.GetData(2)	
			s selected=rset.GetData(3)
			s Code=rset.GetData(4)
			if (FindDefault="")&&(selected="1") s FindDefault=Value
			if (DefaultRecLoc'="")&&(Value=DefaultRecLoc){
				s FindDefault=Value
			}
			if LocStr=""{
				s LocStr=Desc_"^"_Value_"^"_selected_"^"_Code
			}else{
				s LocStr=LocStr_"!"_Desc_"^"_Value_"^"_selected_"^"_Code	
			}
		}
	}
	s RetLocStr=""
	if (FindDefault'="")&&(LocStr'=""){
		for i=1:1:$l(LocStr,"!"){
			s onestr=$p(LocStr,"!",i)
			s desc=$p(onestr,"^",1)
			s id=$p(onestr,"^",2)	
			s sel=$p(onestr,"^",3)
			s code=$p(onestr,"^",4)
			if (id=FindDefault) {
				s sel="1" 	
			}
			if RetLocStr=""{
				s RetLocStr=desc_"^"_id_"^"_sel_"^"_code
			}else{
				s RetLocStr=RetLocStr_"!"_desc_"^"_id_"^"_sel_"^"_code	
			}
		}
	}
	
	q RetLocStr_$c(1)_FindDefault
}

/// Descript   : 查询治疗医嘱项绑定的医嘱信息
/// Table      ：DHC_DocCureItemAppendItem
/// Input      : DDCIAIRowid 治疗医嘱项ID
/// Others     ：w ##class(DHCDoc.DHCDocCure.CureItemSet).QueryAppendItem(10,1,82) 
ClassMethod QueryAppendItem(rows, page, DDCIAIRowid) As %String
{
	s end=page*rows
	s start=(page-1)*rows+1
	if DDCIAIRowid=""{
		q ##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(0)	
	}
	
	Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
	
	k DHCDocCureArr
	s h=0,count=0
	s DDCIAIChildSub=0
    for  s DDCIAIChildSub=$o(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub)) Q:DDCIAIChildSub=""  d
 	.s data=$g(^DHCDocCureItemSet(DDCIAIRowid,"AI",DDCIAIChildSub))
 	.s AppendItemDr=$p(data,"^",1)
 	.s AppendItem=##class(web.DHCDocOrderCommon).GetFormateOrderName(AppendItemDr)
 	.s AppendItem=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",AppendItem,langid)
 	.s AppendItem=##class(ext.util.String).EvalJSON(AppendItem)
 	.s AppendItemQty=$p(data,"^",2)
 	.s AppendAdmLocID=$p(data,"^",3)
 	.s AppendAdmLoc=""
 	.s:AppendAdmLocID'="" AppendAdmLoc=$p(^CTLOC(AppendAdmLocID),"^",2)
 	.s AppendRecLocID=$p(data,"^",4)
 	.s AppendRecLoc=""
 	.s:AppendRecLocID'="" AppendRecLoc=$p(^CTLOC(AppendRecLocID),"^",2)
 	.s AppendDefaultFlag=$p(data,"^",5)
 	.s ID=DDCIAIRowid_"||"_DDCIAIChildSub
 	.s h=h+1
 	.s tempstr=ID_"^"_AppendItem_"^"_AppendItemDr_"^"_AppendItemQty_"^"_AppendAdmLoc_"^"_AppendAdmLocID
 	.s tempstr=tempstr_"^"_AppendRecLoc_"^"_AppendRecLocID_"^"_AppendDefaultFlag
	.s DHCDocCureArr(h)=tempstr
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(h)) 
		q Stream.Read()
	}
	
	///转换数据为Json格式
	s title="AppendRowID^AppendItem^AppendItemRowID^AppendQty^AppendAdmLoc^AppendAdmLocRowID^AppendRecLoc^AppendRecLocRowID^Default"
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(h))
	s index=""
	f  s index=$o(DHCDocCureArr(index)) q:index=""  d
	.s mdate=$g(DHCDocCureArr(index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	.e  d
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEndSign())
	q Stream.Read()
}

ClassMethod SaveRecordTemp(RowidStr As %String, CRTTitle As %String, CRTDetail As %String, CRTType As %String, CRTResponse As %String, CRTEffect As %String, CRTExpStr As %String = "")
{
	s ^tmplog("SaveRecordTemp")=$lb(RowidStr,CRTTitle, CRTDetail, CRTType, CRTResponse, CRTEffect, CRTExpStr)
	s RowidStrLen=$l(RowidStr,"^")
	for loop=1:1:RowidStrLen{
		s DDCRTRowid=$p(RowidStr,"^",loop)
		s ret=..SaveItemSetRecordTemp(DDCRTRowid, CRTTitle, CRTDetail, CRTType, CRTResponse, CRTEffect, CRTExpStr)	
	}
	Q ret
}

/// Desc:保存治疗项目维护的治疗记录模板信息
/// Input:DDCISPRowid:治疗记录模板ID,若不含"||",则为新增,否则为更新
/// 	  PlanTitle:治疗记录模板标题
/// 	  PlanDetail:治疗记录模板内容
/// 	  CRTExpStr:CRTSaveAs^CRTSavePointer^CRTSaveUserDr 
/// 				CRTSaveAs 保存类型 U：用户 L：科室 C：通用
/// 				CRTSavePointer 模板保存要素
/// 				CRTSaveUserDr  模板保存用户
/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveItemSetRecordTemp("103||1","","1","PTJ")
ClassMethod SaveItemSetRecordTemp(DDCRTRowid As %String, CRTTitle As %String, CRTDetail As %String, CRTType As %String, CRTResponse As %String, CRTEffect As %String, CRTExpStr As %String = "")
{
	n (DDCRTRowid, CRTTitle, CRTDetail, CRTType, CRTResponse, CRTEffect, CRTExpStr,%session)
	Quit:DDCRTRowid="" "-100"
	s CRTSaveAs=$p(CRTExpStr,"^",1)
	s CRTSavePointer=$p(CRTExpStr,"^",2)
	s CRTSaveUserDr=$p(CRTExpStr,"^",3)
	s:CRTSaveAs="" CRTSaveAs="C"
	s CRTExpJsonStr=$p(CRTExpStr,"^",4)
	s CRTMapID=$p(CRTExpStr,"^",5)
	i ($g(CRTSaveUserDr)="")&&($d(%session)) s CRTSaveUserDr=%session.Get("LOGON.USERID")
	set myrtn=0
	if $l(DDCRTRowid,"||")>1{
		set CRTObj=##class(User.DHCDocCureItemSetRecordTemp).%OpenId(DDCRTRowid)
	}else{
		set CRTObj=##class(User.DHCDocCureItemSetRecordTemp).%New(DDCRTRowid)
	}
	if $IsObject(CRTObj){
		do CRTObj.DDCRTParRefSetObjectId(DDCRTRowid)
		set CRTObj.DDCRTTitle=CRTTitle
		set CRTObj.DDCRTDetail=CRTDetail
		set CRTObj.DDCRTType=CRTType
		set CRTObj.DDCRTResponse=CRTResponse
		set CRTObj.DDCRTEffect=CRTEffect
		set CRTObj.DDCRTExpJsonStr=CRTExpJsonStr
		set CRTObj.DDCRTSaveAs=CRTSaveAs
		set CRTObj.DDCRTSavePointer=CRTSavePointer
		set CRTObj.DDCRTMapID=CRTMapID
		DO CRTObj.DDCRTSaveUserDrSetObjectId(CRTSaveUserDr)
		set sc=CRTObj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-101"
		}
	}else{
		set myrtn="-102"	
	}
	Quit myrtn
}

ClassMethod GetCRTDetailByID(DDCRTRowid As %String)
{
	set CRTObj=##class(User.DHCDocCureItemSetRecordTemp).%OpenId(DDCRTRowid)
	if '$IsObject(CRTObj) Q ""
	set Detail=CRTObj.DDCRTDetail
	set Response=CRTObj.DDCRTResponse
	set Effect=CRTObj.DDCRTEffect
	Quit Detail_"^"_Response_"^"_Effect
}

/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).GetCRTDetail("103","PTL")
ClassMethod GetCRTDetail(RowId As %String, CRTType As %String, OEORERowId As %String = "", HospId As %String = "")
{
	s ret=""
	if RowId'=""{
		s DCARowId=+RowId
	}else{
		if (OEORERowId'=""){
			s OEORIRowID=+OEORERowId_"||"_$P(OEORERowId,"||",2)
			s DCARowId=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))
		}
	}
	Quit:DCARowId="" ret
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set OrderId=$p(CureData,"^",2)
	Quit:OrderId="" ret
	Set ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	Quit:ArcimId="" ret
	s DDCISID=..GetDDCISIDByItem(ArcimId,HospId)
	Quit:DDCISID="" ret
	s Child=0
	for{
		;s Child=$o(^DHCDocCureItemSet(0,"Type",CRTType,DDCISID,"RT",Child))
		s Child=$o(^DHCDocCureItemSet(DDCISID,"RT",Child))
		Q:Child=""
		s DDCRTRowid=DDCISID_"||"_Child
		set CRTObj=##class(User.DHCDocCureItemSetRecordTemp).%OpenId(DDCRTRowid)
		if $IsObject(CRTObj){
			set Title=CRTObj.DDCRTTitle
			set Detail=CRTObj.DDCRTDetail
			set Response=CRTObj.DDCRTResponse
			set Effect=CRTObj.DDCRTEffect
			set ret=Title_"^"_Detail_"^"_Response_"^"_Effect
		}
	}
		
	
	Quit ret
}

ClassMethod DelItemSetRecordTemp(DDCRTRowid As %String)
{
	Quit:DDCRTRowid="" "-100"
	set myrtn=0
	&sql(delete SqlUser.DHC_DocCureItemSet_RecordTemp where DDCRT_Rowid=:DDCRTRowid)
	Quit SQLCODE
}

Query FindCRT(DDCISRowid As %String, Query As %String = "", SaveAs As %String = "C", Pointer As %String = "", MapID As %String = "") As %Query(ROWSPEC = "CRTTitle:%String,CRTDetail:%String,CRTRowID:%String,CRTTypeDr:%String,CRTType:%String,CRTResponse:%String,CRTEffect:%String,ArcimDesc:%String,CRTSavePointer:%String,CRTSaveUserDr:%String,CRTSaveUser:%String,CRTMapID:%String,CRTExpJsonStr:%String")
{
}

/// SaveAs  保存类型 U：用户 L：科室 C：通用
/// Pointer 模板保存要素
ClassMethod FindCRTExecute(ByRef qHandle As %Binary, DDCISRowid As %String, Query As %String = "", SaveAs As %String = "C", Pointer As %String = "", MapID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","FindCRT","143","","C")
    Set ind=0
    if DDCISRowid=""{
		Quit $$$OK    
	}
	s langid=..%LanguageID()
	s len=$l(DDCISRowid,"^")
	for loop=1:1:len{
		s aDDCISRowid=$p(DDCISRowid,"^",loop)
		if SaveAs'=""{
			s DDCISPChildSub=0
			for{
				s DDCISPChildSub=$o(^DHCDocCureItemSet(0,"RTType",SaveAs,aDDCISRowid,"RT",DDCISPChildSub)) 
				Q:DDCISPChildSub=""
				s CRTSavePointer=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",5)
			    continue:(Pointer'="")&&(CRTSavePointer'=Pointer)
			    s CRTMapID=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",7)
			    continue:(CRTMapID'=MapID)
				d GetFindCRT
			}	
		}else{
		    s DDCISPChildSub=0
		    for{
			    s DDCISPChildSub=$o(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub))
			    Q:DDCISPChildSub=""
			    s CRTSavePointer=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",5)
			    continue:(Pointer'="")&&(CRTSavePointer'=Pointer)
			    s CRTMapID=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",7)
			    continue:(MapID'="")&&(CRTMapID'=MapID)
			    d GetFindCRT
		    }
		}
	}
	Quit $$$OK
GetFindCRT
 	s CRTTitle=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",1)
 	s CRTTitle=##class(ext.util.String).EvalJSON(CRTTitle)
 	s CRTDetail=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",2)
 	s CRTDetail=##class(DHCDoc.DHCDocCure.Util).CureEvalJSON(CRTDetail)
 	s CRTDetail=$$FormatDesc(CRTDetail)
 	s CRTResponse=$g(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub,"R"))
 	s CRTResponse=##class(DHCDoc.DHCDocCure.Util).CureEvalJSON(CRTResponse)
 	s CRTResponse=$$FormatDesc(CRTResponse)
 	s CRTEffect=$g(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub,"E"))
 	s CRTEffect=##class(DHCDoc.DHCDocCure.Util).CureEvalJSON(CRTEffect)
 	s CRTEffect=$$FormatDesc(CRTEffect)
 	s CRTRowID=aDDCISRowid_"||"_DDCISPChildSub
 	s CRTType=""
 	s CRTTypeDr=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",3)
	s ArcimId=$p(^DHCDocCureItemSet(aDDCISRowid),"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s CRTSaveUserDr=$p(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub),"^",6)
	s CRTSaveUser=""
	if CRTSaveUserDr'=""{
		s CRTSaveUser=$p(^SSU("SSUSR",CRTSaveUserDr),"^",2)	
		s CRTSaveUser=##class(DHCDoc.Common.Translate).GetTransUser(CRTSaveUser,langid)
	}
	s CRTExpJsonStr=$g(^DHCDocCureItemSet(aDDCISRowid,"RT",DDCISPChildSub,"Exp"))
	Do OutputRowFindCRT
	Quit
OutputRowFindCRT
	set Data=$lb($g(CRTTitle),$g(CRTDetail),CRTRowID,CRTTypeDr,CRTType,CRTResponse,CRTEffect,ArcimDesc,CRTSavePointer,CRTSaveUserDr,CRTSaveUser,CRTMapID,CRTExpJsonStr)
	set qHandle($I(ind))=Data
	quit
FormatDesc(Desc)
	if (Query=1)&&($l(Desc)>25){
 		s Desc=$e(Desc,1,25)_"..."
	}
 	quit Desc
}

ClassMethod FindCRTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCRTExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// w ##class(DHCDoc.DHCDocCure.CureItemSet).GetCRTTypeStr()
ClassMethod GetCRTTypeStr(type As %String = "")
{
	s ret=""
	Set rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindDefineData")
	do rset.Execute("治疗工作站","治疗记录模板类型")
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s id=rset.GetData(3)
		s desc=rset.GetData(1)
		if (type="JSON"){
			if ret="" s ret=id_":"_desc
			else  s ret=ret_";"_id_":"_desc
		}else{
			if ret="" s ret=id_$c(1)_desc
			else  s ret=ret_"^"_id_$c(1)_desc
		}
	}
	d rset.Close()
	Q ret
}

ClassMethod GetDDCISRowidStr(DCAARowIdStr As %String, OEORERowIdStr As %String = "", DCRRowID As %String = "")
{
	n (OEORERowIdStr,DCAARowIdStr,DCRRowID,%session)
	s IdStr=""
	k IdArr
	if DCAARowIdStr'=""{
		for i=1:1:$L(DCAARowIdStr,"^"){
			s DCAARowId=$p(DCAARowIdStr,"^",i)
			s OrderId=$p($g(^DHCDocCure(+DCAARowId)),"^",2)
			s DDCISRowid=..GetDDCISIDByOrd(OrderId)
			continue:DDCISRowid=""
			s IdArr(DDCISRowid)=""
		}
	}elseif OEORERowIdStr'=""{
		for i=1:1:$L(OEORERowIdStr,"^"){
			s OEORERowID=$p(OEORERowIdStr,"^",i)
			s OrderId=$p(OEORERowID,"||",1,2)
			s DDCISRowid=..GetDDCISIDByOrd(OrderId)
			continue:DDCISRowid=""
			s IdArr(DDCISRowid)=""
		}
	}elseif DCRRowID'=""{
		s OrderId=$p($g(^DHCDocCure(+DCRRowID)),"^",2)
		s IdStr=..GetDDCISIDByOrd(OrderId)	
	}
	if $d(IdArr){
		s DDCISRowid=""
		for{
			s DDCISRowid=$o(IdArr(DDCISRowid))
			Q:DDCISRowid=""
			if IdStr="" s IdStr=DDCISRowid
			else  s IdStr=IdStr_"^"_DDCISRowid	
		}
	}
	Q IdStr
}

ClassMethod GetCRTTitleStr(DCRRowId As %String = "", OEORERowIDS As %String = "", DCAARowIdStr As %String = "", SaveAs As %String = "C")
{
	n (OEORERowIDS,DCRRowId,DCAARowIdStr,SaveAs,%session)
	s ret=""
	k CRTTitleArray 
	if DCAARowIdStr'=""{
		for i=1:1:$L(DCAARowIdStr,"^"){
			s DCAARowId=$p(DCAARowIdStr,"^",i)
			s OrderId=$p($g(^DHCDocCure(+DCAARowId)),"^",2)
			s DDCISRowid=..GetDDCISIDByOrd(OrderId)
			continue:DDCISRowid=""
			d GetCRT	
		}
	}elseif OEORERowIDS'=""{
		for i=1:1:$L(OEORERowIDS,"^"){
			s OEORERowID=$p(OEORERowIDS,"^",i)
			s OrderId=$p(OEORERowID,"||",1,2)
			s DDCISRowid=..GetDDCISIDByOrd(OrderId)
			continue:DDCISRowid=""
			d GetCRT	
		}
	}else{
		s OrderId=$p($g(^DHCDocCure(+DCRRowId)),"^",2)
		s DDCISRowid=..GetDDCISIDByOrd(OrderId)
		if DDCISRowid'=""{
			d GetCRT
		}
	}
	Q ret
GetCRT
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.CureItemSet:FindCRT")
	do rset.Execute(DDCISRowid,SaveAs)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s id=rset.GetData(3)
		s desc=rset.GetData(1)
		s detail=rset.GetDataByName("CRTTitle")_$c(2)_rset.GetDataByName("CRTDetail")_$c(2)_rset.GetDataByName("CRTResponse")_$c(2)_rset.GetDataByName("CRTEffect")
		continue:id=""
		continue:$d(CRTTitleArray(id))
		s CRTTitleArray(id)=desc
		if ret="" s ret=id_$c(1)_desc_$c(1)_detail
		else  s ret=ret_"^"_id_$c(1)_desc_$c(1)_detail
	}
	d rset.Close()
	Q
}

ClassMethod SaveItemSetExpValBatch(DDCISRowid As %String, Key As %String, ExpValStr As %String)
{
	s ret=0
	Quit:DDCISRowid="" "-100"
	s mlen=$l(ExpValStr,"^")
	Ts
	for loop=1:1:mlen{
		s ExpVal=$p(ExpValStr,"^",loop)
		continue:ExpVal=""
		s ret=..SaveCureItemSetExpVal(DDCISRowid,Key,ExpVal)
		if ret'=0{
			Q	
		}
	}
	if ret=0{
		Tc	
	}else{
		Tro	
	}
	Q ret
}

/// Desc:保存治疗项目关联的扩展信息
/// Input:DDCISPRowid
/// 	  Key:保存要素
/// 	  ExpVal:保存要素值^要素值对应表
/// Debug:w ##class(DHCDoc.DHCDocCure.CureItemSet).SaveCureItemSetPlan(92,1,2)
ClassMethod SaveCureItemSetExpVal(DDCISRowid As %String, Key As %String, ExpVal As %String)
{
	n (DDCISRowid,Key,ExpVal)
	Quit:DDCISRowid="" "-100"
	set myrtn=0
	set ExpValTbl=$p(ExpVal,"^",2)
	set ExpVal=$p(ExpVal,"^",1)
	s child=0
	for{
		s child=$o(^DHCDocCureItemSeti("ExpKey",DDCISRowid,Key,child))
		Q:child=""
		s KeyVal=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",2)
		if KeyVal=ExpVal{
			s myrtn="Repeat"	
			Q
		}
	}
	Q:myrtn'=0 myrtn
	
	set ExpObj=##class(User.DHCDocCureItemSetExpand).%New(DDCISRowid)
	
	if $IsObject(ExpObj){
		do ExpObj.DDCISExpParRefSetObjectId(DDCISRowid)
		set ExpObj.DDCISExpKey=Key
		set ExpObj.DDCISExpValue=ExpVal
		set ExpObj.DDCISExpValueTbl=ExpValTbl
		set sc=ExpObj.%Save()
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-101"
		}
	}else{
		set myrtn="-102"	
	}
	Quit myrtn
}

ClassMethod DelCureItemSetExpVal(DDCExpRowid As %String)
{
	Quit:DDCExpRowid="" "-100"
	set myrtn=0
	&sql(delete SqlUser.DHC_DocCureItemSet_Expand where DDCISExp_RowID=:DDCExpRowid)
	Quit SQLCODE
}

Query QueryCureItemExp(DDCISRowid As %String, Key As %String, KeyVal As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ExpRowID:%String,ExpKey:%String,ExpValue:%String,ExpKeyDesc:%String,CureItemRowID:%String,CureItemDesc:%String")
{
}

/// Desc:查询治疗项目扩展关联信息
/// Input:Key 关联保存要素
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.CureItemSet","QueryCureItemExp",299,"POAGRP")
ClassMethod QueryCureItemExpExecute(ByRef qHandle As %Binary, DDCISRowid As %String, Key As %String, KeyVal As %String = "", HospId As %String = "") As %Status
{
	s langid=..%LanguageID()
	s len=$l(Key,"^")
	for loop=1:1:len{
		s mKey=$p(Key,"^",loop)
		continue:mKey=""
		if DDCISRowid=""{
			if KeyVal'=""{
				for{
					s DDCISRowid=$o(^DHCDocCureItemSeti("KeyVal",mKey,KeyVal,DDCISRowid))
					Q:DDCISRowid=""
					s DDCISHospId=$p(^DHCDocCureItemSet(DDCISRowid),"^",12)
					continue:(DDCISHospId'=HospId)&&(HospId'="")
					s child=0
					for{
						s child=$o(^DHCDocCureItemSeti("KeyVal",mKey,KeyVal,DDCISRowid,child))
						Q:child=""
						d GetOne
					}
				}
			}
		}else{
			s child=0
			for{
				s child=$o(^DHCDocCureItemSeti("ExpKey",DDCISRowid,mKey,child))
				Q:child=""
				d GetOne
			}
		}
	}
	Quit $$$OK 
GetOne
	s mKey=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",1)
	s KeyVal=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",2)
	s KeyValTbl=$p(^DHCDocCureItemSet(DDCISRowid,"Exp",child),"^",3)
	s KeyDesc=mKey
	if mKey="POA"{
		;部位/穴位
		s KeyDesc=$lg(^User.DHCDocCurePartSetD(KeyVal),3)
	}elseif mKey="POAGRP"{
		;部位/穴位组
		s KeyDesc=$lg(^User.DHCDocCurePartGrpSetD(KeyVal),3)
	}
	;s @KeyDesc
	s DDCISItemId=$p(^DHCDocCureItemSet(DDCISRowid),"^",1)
	s DDCISDesc=$p(^ARCIM(+DDCISItemId,$p(DDCISItemId,"||",2),1),"^",2)
	s DDCISDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",DDCISDesc,langid)
	s Rowid=DDCISRowid_"||"_child
	d OutputRow
	quit
OutputRow
	s qHandle($I(ind))=$lb(Rowid,mKey,KeyVal,KeyDesc,DDCISRowid,DDCISDesc)
	quit
}

ClassMethod QueryCureItemExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCureItemExpExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

}
