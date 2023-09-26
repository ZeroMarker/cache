/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 化疗药品维护
Class DHCDoc.Chemo.CFG.DrugDic Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).Save("","1||1^1^1")
ClassMethod Save(DID, mList)
{
	s Arcim=$p(mList,"^",1)
	s Active=$p(mList,"^",2)
	s DName=$p(mList,"^",3)
	s DHosp=$p(mList,"^",4)
	
	i DID="" {
		;Q:$d(^CF.DOC.Chemo.DrugDicI("Arcim",Arcim)) "-2"
		Q:$d(^CF.DOC.Chemo.DrugDicI("HospArcim",DHosp,Arcim)) "-2"
		s a=##class(User.ChemoDrugDic).%New()
	} else {
		s a=##class(User.ChemoDrugDic).%OpenId(DID)
		s oldArcim=a.DArcimDRGetObjectId()
		s oldHosp=a.DHospGetObjectId()
		Q:$d(^CF.DOC.Chemo.DrugDicI("Arcim",Arcim))&&(oldArcim'=Arcim)&&(oldHosp'=DHosp) "-2"
	}
	d a.DArcimDRSetObjectId(Arcim)
	d a.DHospSetObjectId(DHosp)
	s a.DName=DName
	s a.DActive=Active
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-101"
	}
	//Q a.%Id()
	Q 0
}

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).DeleteTPL("")
ClassMethod Delete(DID As %String)
{
	Q:DID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_DrugDic WHERE D_ID=:DID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 查询
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.DrugDic","QryDrug","RD")
Query QryDrug(InDesc = "", InHosp = "") As %Query(ROWSPEC = "id,arcim,arcimCode,arcimDesc,seqno,active,name")
{
}

ClassMethod QryDrugExecute(ByRef qHandle As %Binary, InDesc = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^CF.DOC.Chemo.DrugDicD(id)) q:id=""  d
 	.s arcim=$p(^CF.DOC.Chemo.DrugDicD(id),"^",1)
 	.;q:(InHosp'="")&&(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",arcim,InHosp)="N")
 	.s seqno=$p(^CF.DOC.Chemo.DrugDicD(id),"^",2)
 	.s active=$p(^CF.DOC.Chemo.DrugDicD(id),"^",3)
 	.s name=$p(^CF.DOC.Chemo.DrugDicD(id),"^",4)
 	.s hosp=$p(^CF.DOC.Chemo.DrugDicD(id),"^",5)
 	.q:hosp'=InHosp
 	.s isExit=..IsExit(arcim,InDesc)
 	.q:isExit=1
 	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,arcim,arcimCode,arcimDesc,seqno,active,name)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDrugExecute ]
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

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 查询医嘱项
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.DrugDic","FindMasterItem")
Query FindMasterItem(arcimdesc As %String = "", InType As %String = "", HospId = "", InOrderCate = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String,factor,stock")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String = "", InType As %String = "", HospId = "", InOrderCate = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    //s HospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
    //i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..;s HosipitalStr=##class(web.DHCDocOrderEntry).ArcimCanUserHosipital(ArcimDR)
	..;Q:(("^"_HosipitalStr_"^")'[("^"_HospId_"^"))&&(HosipitalStr'="")&&(HospId'="")
	..Q:(HospId'="")&&(##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,HospId)="N")
	..s Flag=0
	..s factor="",stock=""
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s OutArcimDesc=ArcimDesc
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..s itemDr=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",10)
    ..q:itemDr=""
    ..s orderType=$p(^ARC("IC",itemDr),"^",7)
    ..s orderCate=$p(^ARC("IC",itemDr),"^",8)
    ..q:orderCate=""
    ..s orderCateDesc=$p(^OEC("ORCAT",orderCate),"^",2)
    ..q:(InOrderCate'="")&&(InOrderCate'=orderCateDesc)
    ..Q:(InType'="")&&(InType'=orderType)
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 d output3
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output3
	set Data=$lb(OutArcimDesc,ArcimDR,factor,stock)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 药品是否包含该别名
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).HasAlias("1||1","RD")
ClassMethod HasAlias(ArcimDR, Desc)
{
	s mRtn=0
	Q:(ArcimDR="")||(Desc="") mRtn
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s AlisDR=""
	f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	.s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	.i AlisDesc[Desc s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-24
/// DESC: 是否退出
/// IN  : 
/// OUT : 1退出
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).IsExit()
ClassMethod IsExit(ArcimDR, Desc)
{
	Q:(ArcimDR="") 1
	Q:(Desc="") 0
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s ARC=+ArcimDR,VER=$P(ArcimDR,"||",2)
 	s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
 	s arcimDesc=$$ALPHAUP^SSUTIL4(arcimDesc)
 	s HasAlias=..HasAlias(ArcimDR, Desc)
 	i ((arcimDesc'[Desc)&&(HasAlias=0)) {
	 	Q 1
	 }
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-07
/// DESC: 获得化疗药品简写
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).GetDrugSimpleName("1||1")
ClassMethod GetDrugSimpleName(ArcimDR, InHsop = "")
{
	s mRtn=""
	Q:ArcimDR="" mRtn
	i InHsop="" {
		s ID=$O(^CF.DOC.Chemo.DrugDicI("Arcim",ArcimDR,""))
		Q:ID="" mRtn
	} else {
		s ID=$O(^CF.DOC.Chemo.DrugDicI("HospArcim",InHsop,ArcimDR,""))
		Q:ID="" mRtn
	}
	s active=$p(^CF.DOC.Chemo.DrugDicD(ID),"^",3)
	Q:active=0 mRtn
	s mRtn=$p(^CF.DOC.Chemo.DrugDicD(ID),"^",4)
		
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-12-05
/// DESC: 清楚数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.DrugDic).ClearData()
ClassMethod ClearData()
{
	&SQL(TRUNCATE TABLE SQLUser.Chemo_DrugDic)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Bed)
	Q 1
}

}
