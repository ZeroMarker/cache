/// creator:guorongyong
/// date:20100806
/// desc:因为web.DHCOEOrdItem类太大，此类用以扩展医嘱相关的查询Query,以及封装原系统的Query
/// 适用：此类为新增，现适用所有，待扩展
Class web.DHCOEOrdItemQuery Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// Creator:      郭荣勇
/// CreatDate:    2010.03.15
/// Description:  替换原本次医嘱医嘱项查询Query,根据登录语言显示不同语言的医嘱描述
/// Table:        OE_OrdItem,OEC_OrderStatus
ClassMethod ProfileListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ProfileListExecute ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ProfileListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", par As %String = "", dfrom As %String = "", dto As %String = "", categ As %String = "", stat As %String = "", result As %String = "", vis As %String = "", dsfrom As %String = "", dsto As %String = "", cptype As %String = "", hospitallist As %String = "", EpisodeAll As %String = "", OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 Set rset=##Class(%ResultSet).%New("web.EPVisitNumber:ProfileList")
	do rset.Execute(TSRTITM,TSRTORD,par,dfrom,dto,categ,stat,result,vis,dsfrom,dsto,cptype,hospitallist,EpisodeAll,OrderSubcategories,ExcludeCurrentEpisode)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s Data=""
		for i=1:1:columns {
			s $List(Data,i)=rset.GetData(i)
		}
		s ID=$List(Data,1)
		s ARCIMRowId=$P($g(^OEORD(+ID,"I",$P(ID,"||",2),1)),"^",2)
		s ARCIMAbbrev=$P($g(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1)),"^",3)
		s $List(Data,6)=ARCIMAbbrev
		d OutputRow    
	}
	d rset.Close()
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod ProfileListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProfileListExecute ]
{
 Set AtEnd=$LIST(QHandle,1)
 Set repid=$LIST(QHandle,2)
 Set ind=$LIST(QHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpItmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpItmFetch ]
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:      周志强
/// CreatDate:    2010.03.21
/// Description:  替换医嘱模板维护的医嘱项查询Query,因为字符集的问题造成参数错误无法翻页
/// Table:        OE_OrdItem,OEC_OrderStatus
ClassMethod LookUpItmExecute(ByRef QHandle As %Library.Binary, Order As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", Pharm As %Library.String = "", Param As %Library.String = "", Hospital As %Library.String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	Set rset=##class(%ResultSet).%New("web.OEOrdItem.LookUpItm")
	Set Order=##class(web.DHCDocUtil).UnEscape(Order)
	Set Category=##class(web.DHCDocUtil).UnEscape(Category)
	Set SubCategory=##class(web.DHCDocUtil).UnEscape(SubCategory)
	Set TYPE=##class(web.DHCDocUtil).UnEscape(TYPE)
	Set LUCategoryDesc=##class(web.DHCDocUtil).UnEscape(LUCategoryDesc)
	Set LUSubCategoryDesc=##class(web.DHCDocUtil).UnEscape(LUSubCategoryDesc)
	d rset.Execute(Order, GroupID, Category, SubCategory, TYPE, LUCategoryDesc, LUSubCategoryDesc, EpisodeID, BillingGrp, BillingSubGrp, DateRestriction, OrdCatGrp, Pharm, Param, Hospital)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s Data=""
		for i=1:1:columns {
			s $List(Data,i)=rset.GetData(i)
		}
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
	 }
	d rset.Close()
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpItmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpItmExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2010.08.06
/// Description:  替换原医嘱大类的查询Query,因为字符集的问题造成参数错误无法翻页
/// Table:        OEC_OrderCategory
ClassMethod LookUpCatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpCatExecute ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpCatExecute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SSGRP As %Library.String = "", FilterBy As %Library.String = "", EpisodeID As %Library.String = "", OrdCatGrp As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	Set rset=##class(%ResultSet).%New("web.OECOrderCategory:LookUpCat")
	Set Category=##class(web.DHCDocUtil).UnEscape(Category)
	d rset.Execute(Category, SSGRP, FilterBy, EpisodeID, OrdCatGrp)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s Data=""
		for i=1:1:columns {
			s $List(Data,i)=rset.GetData(i)
		}
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
	 }
	d rset.Close()
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpCatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCatExecute ]
{
 Set AtEnd=$LIST(QHandle,1)
 Set repid=$LIST(QHandle,2)
 Set ind=$LIST(QHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2010.08.06
/// Description:  替换原医嘱子类的查询Query,因为字符集的问题造成参数错误无法翻页
/// Table:        ARC_ItemCat
ClassMethod LookUpSubCatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpSubCatExecute ]
{
 Set repid=$LIST(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpSubCatExecute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SubCategory As %String = "", EpisodeID As %Library.String = "", OrdCatGrp As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	Set rset=##class(%ResultSet).%New("web.ARCItemCat:LookUpSubCat")
	Set Category=##class(web.DHCDocUtil).UnEscape(Category)
	Set SubCategory=##class(web.DHCDocUtil).UnEscape(SubCategory)
	
	d rset.Execute(Category, SubCategory, EpisodeID, OrdCatGrp)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s Data=""
		for i=1:1:columns {
			s $List(Data,i)=rset.GetData(i)
		}
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
	 }
	d rset.Close()
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpSubCatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpSubCatExecute ]
{
 Set AtEnd=$LIST(QHandle,1)
 Set repid=$LIST(QHandle,2)
 Set ind=$LIST(QHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2010.10.08
/// Description:  移植原web.DHCDocOrdRecDepPatientList(浙江衢州,上海东方)的医嘱查询Query
/// Table:        ARC_ItmMast,ARC_ALIAS
ClassMethod orderlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = orderlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod orderlookupExecute(ByRef qHandle As %Binary, desc As %String, HospID = "") As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare orderc cursor  for 
	select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc,alias_arcim_dr->arcim_code
    from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	&sql(open orderc)
	f  &sql(fetch orderc into :orderrowid,:orderdesc,:ordercode) q:SQLCODE  d
	.q:orderdesc=""
	.q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",orderrowid,HospID)="N"
 	.Do OutputRow3 	 	
 	&sql(close orderc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(orderdesc,orderrowid,ordercode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod orderlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = orderlookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator:      郭荣勇
/// CreatDate:    2010.10.08
/// Description:  移植原web.DHCDocOrdRecDepPatientList(浙江衢州,上海东方)的医嘱查询Query
/// Table:        ARC_OrdSets,ARC_ALIAS
ClassMethod orderarcoslookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = orderarcoslookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod orderarcoslookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ordercarcos cursor  for 
	select distinct ALIAS_ARCOS_DR,ALIAS_ARCOS_DR->ARCOS_Desc,ALIAS_ARCOS_DR->ARCOS_Code
    from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	&sql(open ordercarcos)
	f  &sql(fetch ordercarcos into :orderrowid,:orderdesc,:ordercode) q:SQLCODE  d
	.q:orderdesc=""
 	.Do OutputRow4 	 	
 	&sql(close ordercarcos)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(orderdesc,orderrowid,ordercode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod orderarcoslookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = orderarcoslookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// Creator:      郭荣勇
/// CreatDate:    2012.02.25
/// Description:  得到图标"存在未审核的医嘱"的医嘱记录
/// Table:        OE_OrdItem,ARC_ItmMast
ClassMethod ExistUnVerifyOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExistUnVerifyOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ExistUnVerifyOrdExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s OrdItemStr=##class(web.DHCOEOrdItem).GetUnActiveOrderItems(EpisodeID,"")
	i ($P(OrdItemStr,"^",1)="TIMEOUT") {
		s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
		s OrdItemStr=$g(^TMPExistUnActiveOrder("UnActive",OrderRowid))
	}
	s del="^"
	for i=1:1:$L(OrdItemStr,del) {
	 	s orderitem=$P(OrdItemStr,del,i)
	 	s OEItemID=$P(orderitem,"*",2)
	 	s arcim=$P(orderitem,"*",1)
	 	Continue:arcim=""
	 	s OrdId1=$p(OEItemID,"||",1),OrdId2=$p(OEItemID,"||",2)
	 	Continue:OEItemID=""
		s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
		s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
		s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
		s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
		s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
		s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
		s ArcimId=$p(ordstr1,del,2)
		Continue:ArcimId=""
		s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
		s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId , $H, "", "","", "")
		s ArcPrice=$j($p(ArcPrice,"^",1),3,4)
		s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
		i ($g(arctype)="R") d
		.s oeori=OrdId1_"||"_OrdId2
		.s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
		.q:dis=""
		.q:'$d(^DHCOEDISQTY(dis))
		.s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
		e  d
		.s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
		s PoisonRowid1=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimId)
		s PoisonCode=""
		i PoisonRowid1'="" s PoisonCode=$P(^PHCPO(PoisonRowid1),"^",2)
		s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
		s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
		s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
		s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
		s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
		s PrescNo=$p(ordstr1,del,14)
		s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3)
		s OrdcatDR=""
		s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
		s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
		s OrderSeqNo=$p(ordstr3,del,4)
		s CurrPoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimId)
		s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
		s Priority=$p(ordstr1,del,8)
		s:$g(Priority)="" Priority=""
		s:$g(Priority)'="" Priority=$p(^OECPR(Priority),del,2)
		s PHFreq=$p(ordstr2,del,4)
		s:($g(PHFreq)'="")&&($d(^PHCFR(PHFreq))) PHFreq=$p(^PHCFR(PHFreq),del,1)
		s:$g(PHFreq)="" PHFreq=""
		s Instr=$p(ordstr2,del,7)
		s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,2)
		s:$g(Instr)="" Instr=""
		s instr1=$P(Instr,"-",2)
		i instr1'="" s Instr=instr1
		s OrdStatus=$p(ordstr1,del,13)  //医嘱状态
		s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),del,2)
		s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
		s Dura=$p(ordstr2,del,6)
		s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),del,3)
		s:$g(Dura)="" Dura=""
		s doctor=$p(ordstr1,del,11)
		s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
		s:$g(doctor)="" doctor=""
		s QtyPackUOM=$p(ordstr9,del,4)
		s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
		s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
		
		s HaveDispensing=0,dstatus=""
		s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
		.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
		.s HaveDispensing=1
		i HaveDispensing=1 d
		.i dstatus="C" s dstatus="已发"
		.i dstatus="P" s dstatus="未发"
		.i dstatus=""  s dstatus="未打包"
		;条码号,标本
		s LabEpisodeNo=$p(ordstr3,del,20) ;
		s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
		;停医嘱日期,停医嘱时间
		s OrdXDate=$p(ordstr3,del,34)
		if OrdXDate'="" s OrdXDate=$zd(OrdXDate,3)
		s OrdXTime=$p(ordstr2,del,15)
		if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
		;皮试,皮试备注,备注,
		s OrdSkinTest=$p(ordstr5,del,2)
		s OrdAction=$p(ordstr11,del,21)
		i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
		s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
		s OrdBilled=$p(ordstr3,"^",5)
		s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
		s OrdSkinTestResult=""
		i OrdSkinTest="Y" d
		.i abnorm="Y" s OrdSkinTestResult="阳性"
		.e  s OrdSkinTestResult="阴性"
		s ReLoc=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
		If ReLoc'="" Set ReLoc=$P($P($G(^CTLOC(ReLoc)),"^",2),"-",2)
		s LabNo=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",20)
		s UserDepart="" 
		s UserDepartDr=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
		i UserDepartDr'="" s UserDepart=$P($P($G(^CTLOC(UserDepartDr)),"^",2),"-",2)
		s UserAdd=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
		If UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
		s XUser=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",29)
		if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
		s EndDate=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",9)
		s EndTime=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",10)
		If EndDate'="" Set EndDate=$ZD(EndDate,3)
		If EndTime'="" Set EndTime=..%ZT(EndTime,1)
		s CoverMainInsur=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",3)
		s BillTypeRowid=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",18)
		s BillType=""
		If BillTypeRowid'=""  Set BillType=$P($G(^PAC("ADMREA",BillTypeRowid)),"^",2)
		s Data=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,Pqty,ArcPrice,PoisonCode,ReLoc,OEItemID,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod ExistUnVerifyOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExistUnVerifyOrdExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query ExistUnVerifyOrd(EpisodeID As %String) As %Query(ROWSPEC = "OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,OrderSeqNo,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,Pqty,ArcPrice,PoisonCode,ReLoc,OEItemID,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType")
{
}

Query orderarcoslookup(desc As %String) As %Query(ROWSPEC = "order:%String,orderid:%String,ordercode:%String")
{
}

Query orderlookup(desc As %String, HospID = "") As %Query(ROWSPEC = "order:%String,orderid:%String,ordercode:%String")
{
}

Query LookUpSubCat(Category As %Library.String, SubCategory As %Library.String, EpisodeID As %Library.String, OrdCatGrp As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "subCatDesc:%String,subCatRowID:%String,subCatCode:%String")
{
}

Query LookUpCat(Category As %Library.String, SSGRP As %Library.String, FilterBy As %Library.String, EpisideID As %Library.String, OrdCatGrp As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "catDesc:%String,HIDDEN:%String,Code:%String")
{
}

Query LookUpItm(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, LUCategoryDesc As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, DateRestriction As %Library.String, OrdCatGrp As %Library.String, Pharm As %Library.String, Param As %Library.String, Hospital As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query ProfileList(TSRTITM, TSRTORD, par As %String, dfrom As %String, dto As %String, categ As %String, stat As %String, result As %String, vis As %String, dsfrom As %String, dsto As %String, cptype As %String, hospitallist As %String, EpisodeAll As %String, OrderSubcategories As %String = "", ExcludeCurrentEpisode As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Dosage,Duration,Frequency,FullDetails,OrderName,Instruction,Priority,SequenceNumber,Status,StatusCode,StartDate,Notes,UnitOfMeasure,Paid,PathwayStep,DCDate,DCTime,PatientShare,ExecutionTimes,Specimens,LabEpisNo,OrderType,OrderCat,OrderMsg,DefDurID,OEItemMstID,OrderDoc,ReceivLoc,Group,DateOrdered,TimeOrdered,SpecimenCDate,SpecimenCTime,LabRecDate,LabRecTime,LUUser,LUTime,LUDate,MealTime,Modifiers,RadStatus,RefDoctor:%String,MealType:%String,SpecimenADate,SpecimenATime,StartTime,DayBookAccNums,DayBookSpecs,EpisodeID,LinkedTo,LinkedToItmID,LinkedArcimID,OrdItmEpisodeID,RadSeriesNo:%String,VarianceReason:%String,OrdEndDate:%String,OrdEndTime:%String,Alerts:%String,ReasonForOverride:%String,AuthorisingClinician:%String, PAADMDEpisDate, PAADMEpisType, PAPMIName, PAPMIName2,PAPMIName3,PAPMIDOB,PAPMISex,PatRegNo,MRN,PAADMConsDR,PAADMUnit,PAADMWard, PAADMBed, PAADMClinic, OrderCode, OrderLink, intMRN, TotalDosage, Hospital, Specialty, CollectedBy:%String,StartHour,ExeTime,ExeDate,DCUser,Quantity,PAADMRoom,DocumentList:%String,mradmdr,ResultAvailableDate:%Date,Ingredients,PharmacyStatus,PrescriptionNo,ToothLocation,drugDESC,OrderNotes:%String,OrderSet:%String,PAADMEpisNo:%String,DiscClasDesc,GenDrugDetails,Payor,Plan,Price,OverrideRowID,PrioColour,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,NoResultReas,MaxRep")
{
}

}
