/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 项目指标子项设置
Class DHCDoc.GCPSW.CFG.PrjKPIItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPIItem).Save("1||3","^5||1||1^0^1^^1^^2")
ClassMethod Save(PKID, mList)
{
	s mRtn=0
	s PID=+PKID
	S Sub=$p(PKID,"||",2)
	s id=$p(mList,"^",1)
	s KPI=$p(mList,"^",2)
	s Section=$p(mList,"^",3)
	s PKVal=$p(mList,"^",4)
	s Uom=$p(mList,"^",5)
	s user=$p(mList,"^",6)
	s note=$p(mList,"^",7)
	s stdVal=$p(mList,"^",8)
	s rule=$p(mList,"^",9)
	s KPIType=$p(mList,"^",10)
	
	i id="" {
		s a=##class(User.GCPSWPrjKPIItem).%New(PKID)
		d a.PKIParrefSetObjectId(PKID)
		d a.PKIAddUserSetObjectId(user)
		s a.PKIAddDate=+$H
		s a.PKIAddTime=$p($h,",",2)
		
		i $d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,Sub,KPIType)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWPrjKPIItem).%OpenId(id)
		s oldKPIType=a.PKIKPITypeGetObjectId()
		i $d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPIType",PID,Sub,KPIType)) {
			i oldKPIType'=KPIType {
				Q -2	
			}
		}
	}
	d a.PKIKPISetObjectId(KPI)
	d a.PKIKPITypeSetObjectId(KPIType)
	s a.PKIKPIUom=Uom
	s a.PKIVal=PKVal
	s a.PKIStdVal=stdVal
	s a.PKINote=note
	s a.PKISection=Section
	s a.PKIRule=rule
	
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPIItem).Delete("")
ClassMethod Delete(PKIID As %String)
{
	Q:PKIID="" 0
	&SQL(DELETE FROM SQLUser.GCPSW_PrjKPIItem WHERE PKI_ID=:PKIID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 查询指标
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.PrjKPIItem","QryKPI","2||4")
Query QryKPI(PKID = "", KPIContent = "") As %Query(ROWSPEC = "id,kpi,kpiType,kpiCode,kpiName,section,Val,uom,note,stdVal,rule,ruleDesc")
{
}

ClassMethod QryKPIExecute(ByRef qHandle As %Binary, PKID = "", KPIContent = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PKID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s PID=+PKID
	S SUB=$P(PKID,"||",2)
 	s CH=""
 	f  s CH=$o(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH)) q:CH=""  d
 	.s id=PKID_"||"_CH
 	.s kpi=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",1)
 	.s kpiType=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",11)
 	.s KTID=+kpiType,KS=$p(kpiType,"||",2),KH=$p(kpi,"||",3)
 	
 	.s kpiType=$p(^CF.DOC.GCPSW.KPITypeD(KTID),"^",2)
 	.s kpiType=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS),"^",2)
 	
 	.s kpiCode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS),"^",1)	//$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K",KH),"^",1)
 	.s kpiName=kpiType	//$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",KS,"K",KH),"^",2)
 	.s section=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",2)
 	.s Val=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",3)
 	.s uom=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",4)
 	.s stdVal=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",5)
 	.s note=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",9)
 	.s rule=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",CH),"^",10)
 	.s ruleDesc=..GetRuleDesc(rule)
 	.s exitFlag=$$IsExit(KPIContent,kpiCode,kpiName)
	.q:exitFlag=1
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IsExit(KPIContent,kpiCode,kpiName)
	s mRtn=1
	q:KPIContent="" 0
	s KPIContent=$zcvt(KPIContent,"U")
	s code=$zcvt(kpiCode,"U")
	s name=$zcvt(kpiName,"U")
	q:code[KPIContent 0
	q:name[KPIContent 0
	
	Q mRtn
	
output1
	Set Data=$lb(id,kpi,kpiType,kpiCode,kpiName,section,Val,uom,note,stdVal,rule,ruleDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKPIExecute ]
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
/// DATE: 2020-09-10
/// DESC: 查询子项
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.PrjKPIItem","QryItem","1||3")
Query QryItem(PKID = "") As %Query(ROWSPEC = "id,desc,code")
{
}

ClassMethod QryItemExecute(ByRef qHandle As %Binary, PKID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PKID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s PID=+PKID
	S SUB=$P(PKID,"||",2)
 	
 	s kpi=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB),"^",1)
 	s val=$P(^CF.DOC.GCPSW.PrjD(PID,"K",SUB),"^",3)
 	s KTID=+kpi,KI=$p(kpi,"||",2)
 	s kpicode=$P(^CF.DOC.GCPSW.KPITypeD(KTID,"K",KI),"^",1)
 	i (kpicode'["Lis")||(val="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
 	f i=1:1:$l(val,",") {
		s id=$p(val,",",i)
		s KTID=+id,CH=$P(id,"||",2)
		s code=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",CH),"^",1)
		s desc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",CH),"^",2)
		d output2
	}
 	
 	
 
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output2
	Set Data=$lb(id,desc,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemExecute ]
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
/// DATE: 2020-09-10
/// DESC: 获取子项区间
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPIItem).GetSectionByCode("2||4","3||1","WhiteCell")
ClassMethod GetSectionByCode(PKID = "", ITID = "", itemCode = "")
{
	Q:(PKID="")||(ITID="")||(itemCode="") ""
	S KPI=##class(DHCDoc.GCPSW.CFG.ItemKPI).GetIdByCode(ITID,itemCode)
	q:KPI="" ""	
	S PID=+PKID,SUB=$P(PKID,"||",2)
	Q:'$d(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPI",PID,SUB,KPI)) ""
	S id=$o(^CF.DOC.GCPSW.PrjI("PrjKPIItem","KPI",PID,SUB,KPI,""))
	q:id="" ""
	s mRtn=$p(^CF.DOC.GCPSW.PrjD(PID,"K",SUB,"I",id),"^",2)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-18
/// DESC: 获取筛选值类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPIItem).GetRuleDesc("LIKE")
ClassMethod GetRuleDesc(Type As %String)
{
	s mRtn=""
	;默认为精确匹配
	;i Type="" s mRtn="精确匹配"
	
	i Type="LIKE" s mRtn="模糊匹配"
	i Type="FULL" s mRtn="精确匹配"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-18
/// DESC: 查询匹配规则
/// IN  : LIKE,FULL: 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.PrjKPIItem","QryRule")
Query QryRule() As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod QryRuleExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="LIKE",desc="模糊匹配"
 	d output4
 	s id="FULL",desc="精确匹配"
 	d output4
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output4
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRuleExecute ]
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

}
