/// CTOR: QP
/// DATE: 2016-08-7
/// DESC: 公共类：放置医生站界面和维护界面的公共Query
Class DHCAnt.KSS.Common.Query Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DESC: 科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryAllDep","",2)
Query QryAllDep(q = "", inHosp = "") As %Query(ROWSPEC = "ULocDesc:%String,ULocID:%String")
{
}

ClassMethod QryAllDepExecute(ByRef qHandle As %Binary, q = "", inHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s inDesc=q
 	s inDesc=$zcvt(inDesc,"U")
 	s ^TEMP("LHY",11)=$LB(inDesc,inHosp)
    Set CTLOCID=0
	F  s CTLOCID=$O(^CTLOC(CTLOCID)) q:CTLOCID=""  d 
	.S locDesc=$P($G(^CTLOC(CTLOCID)),"^",2)
	.S HospDr=$P($G(^CTLOC(CTLOCID)),"^",22)
	.q:HospDr=""
	.q:(inHosp'="")&&(inHosp'=HospDr)
	.S contactName=$P($G(^CTLOC(CTLOCID)),"^",43)
	.s contactName=$zcvt(contactName,"U")
	.i locDesc["-" s locDesc=$p(locDesc,"-",2)  
	.q:((inDesc'="")&&(contactName'[inDesc))&&((inDesc'="")&&(locDesc'[inDesc))
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(locDesc,CTLOCID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAllDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryAllDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryALLPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryALLPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryALLPoisonExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryALLPoison")
	Set repid=$I(^CacheTemp)
 	s ind=1
    S poisonId=0
	F  s poisonId=$O(^PHCPO(poisonId)) q:poisonId=""  d 
	.s poisonDesc=$p($g(^PHCPO(poisonId)),"^",2) 
   	.Do OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow1
	set Data=$lb(poisonDesc,poisonId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryALLPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryALLPoisonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QryALLPoison() As %Query(ROWSPEC = "text:%String,id:%String")
{
}

ClassMethod QryAllDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryAllDocExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryAllDoc",11)
	
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
    i LocId="" d
    .s CTPCPRowid=""
    .f  s CTPCPRowid=$o(^CTPCP(CTPCPRowid))  q:CTPCPRowid=""  d
    ..s CTPCPDesc=$p($g(^CTPCP(CTPCPRowid,1)),"^",2)
    ..q:CTPCPDesc=""
    ..Do OutwardRow2
    e  d
	.s RESRowid=0
	.f  s RESRowid=$o(^RB("RES",0,"CTLOC",LocId,RESRowid)) q:RESRowid=""  d
    ..s CTPCPRowid=$P(^RB("RES",RESRowid),"^",2)
    ..s CTPCPDesc=$P($g(^CTPCP(CTPCPRowid,1)),"^",2)
    ..q:CTPCPDesc=""
   	..Do OutwardRow2
 	
 	
	Quit $$$OK
	
OutwardRow2
	set Data=$lb(CTPCPDesc,CTPCPRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAllDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatExecute ]
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

Query QryAllDoc(LocId As %String) As %Query(ROWSPEC = "text:%String,id:%String")
{
}

/// CTOR: QP
/// DATE: 2020-11-04
/// DESC: 查询剂量单位
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryDoseUom","1956||1")
Query QryDoseUom(arcim = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryDoseUomExecute(ByRef qHandle As %Binary, arcim = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i arcim="" {
	 	 Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s langid=..%LanguageID()
 	s phcdf=##class(DHCAnt.KSS.Common.Func).GetDrgForm(arcim)
 	s ph=+phcdf,cdf=$p(phcdf,"||",2)
 	
	s sub=0
	f  s sub=$o(^PHCD(ph,"DF",cdf,"EQ",sub)) q:sub=""  d
	.s euom=$p(^PHCD(ph,"DF",cdf,"EQ",sub),"^",1)
	.q:euom=""
	.s eqty=$p(^PHCD(ph,"DF",cdf,"EQ",sub),"^",2)
	.s euomDesc=$p(^CT("UOM",euom),"^",2)
	.s id=euom,text=euomDesc
	.d OutwardRow3		
 	
 	s BaseUom=""
	s BaseQty=$p($g(^PHCD(ph,"DF",cdf,2)),"^",5)
	s BaseUOMRowid=$p($g(^PHCD(ph,"DF",cdf,2)),"^",4)
	i BaseUOMRowid'="" {
		s BaseUom=$p(^CT("UOM",BaseUOMRowid),"^",2)
		s id=BaseUOMRowid,text=BaseUom
		d OutwardRow3
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow3
	Set text= ##class(User.CTUOM).GetTranByDesc("CTUOMDesc",text,langid)
	set Data=$lb(id,text)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryDoseUomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDoseUomExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDoseUomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDoseUomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-12-10
/// DESC: 查询医嘱类型
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryOrderPrior")
Query QryOrderPrior() As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryOrderPriorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s langid=..%LanguageID()
 	s id=0
 	f  s id=$o(^OECPR(id)) q:id=""  d
 	.s code=$p(^OECPR(id),"^",1)
 	.s text=$p(^OECPR(id),"^",2)
 	.s text= ##class(User.OECPriority).GetTranByDesc("OECPRDesc",text,langid)
 	.d OutwardRow4
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow4
	set Data=$lb(id,text)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryOrderPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderPriorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOrderPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-12-28
/// DESC: 医生导入模板
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryAntTPL")
Query QryAntTPL() As %Query(ROWSPEC = "C1:%String:医生工号,C2:%String:医生姓名,C3:%String:就诊类型,C4:%String:抗生素级别,C5:%String:允许类型,C6:%String:审核权限,C7:%String:院区代码")
{
}

ClassMethod QryAntTPLExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s C1="医生工号",C2="医生姓名",C3="就诊类型",C4="抗生素级别（KSS1）"
 	s C5="允许类型（A）",C6="审核权限",C7="院区代码"			
	//d OutwardRow5
 	s C1="ys01",C2="医生01",C3="O",C4="KSS1"
 	s C5="F",C6="1",C7="DHSZHYYZY"		
 	d OutwardRow5
 	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow5
	set Data=$lb(C1,C2,C3,C4,C5,C6,C7)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAntTPLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntTPLExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryAntTPLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntTPLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-01-11
/// DESC: 级别权限导入模板
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Common.Query","QryAntKssTPL")
Query QryAntKssTPL() As %Query(ROWSPEC = "C1:%String:医护级别,C3:%String:就诊类型,C4:%String:抗生素级别,C5:%String:允许类型,C6:%String:审核权限,C7:%String:院区代码")
{
}

ClassMethod QryAntKssTPLExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s C1="医护级别",C2="医护级别代码",C3="就诊类型",C4="抗生素级别（KSS1）"
 	s C5="允许类型（A）",C6="审核权限",C7="院区代码"			
	//d OutwardRow5
 	s C1="主任医师",C2="231",C3="O",C4="KSS1"
 	s C5="F",C6="1",C7="DHSZHYYZY"		
 	d OutwardRow6
 	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow6
	set Data=$lb(C1,C3,C4,C5,C6,C7)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryAntKssTPLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntKssTPLExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryAntKssTPLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntKssTPLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
