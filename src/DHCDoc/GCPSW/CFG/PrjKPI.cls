/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 项目指标
Class DHCDoc.GCPSW.CFG.PrjKPI Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPI).Save("903||1")
ClassMethod Save(PID, mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s KPI=$p(mList,"^",2)
	s Section=$p(mList,"^",3)
	s PKVal=$p(mList,"^",4)
	s Uom=$p(mList,"^",5)
	s user=$p(mList,"^",6)
	s note=$p(mList,"^",7)
	
	i id="" {
		s a=##class(User.GCPSWPrjKPI).%New(PID)
		d a.PKParRefSetObjectId(PID)
		d a.PKAddUserSetObjectId(user)
		s a.PKAddDate=+$H
		s a.PKAddTime=$p($h,",",2)
		
		i $d(^CF.DOC.GCPSW.PrjI("PrjKPI","KPI",PID,KPI)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWPrjKPI).%OpenId(id)
		s oldKPI=a.PKKPIGetObjectId()
		i $d(^CF.DOC.GCPSW.PrjI("PrjKPI","KPI",PID,KPI)) {
			i oldKPI'=KPI {
				Q -2	
			}
		}
	}
	d a.PKKPISetObjectId(KPI)
	s a.PKNote=note
	s a.PKVal=PKVal
	s a.PKKPIUom=Uom
	s a.PKSection=Section
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
/// DATE: 2020-09-09
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.PrjKPI).Delete("")
ClassMethod Delete(PKID As %String)
{
	Q:PKID="" 0
	&SQL(DELETE FROM SQLUser.GCPSW_PrjKPI WHERE PK_ID=:PKID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 查询指标
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.PrjKPI","QryKPI",1)
Query QryKPI(PID = "", KPIContent = "") As %Query(ROWSPEC = "id,KPI,KPIType,KPICode,KPIDesc,Section,Val,Uom,note")
{
}

ClassMethod QryKPIExecute(ByRef qHandle As %Binary, PID = "", KPIContent = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
 	s Sub=""
 	f  s Sub=$o(^CF.DOC.GCPSW.PrjD(PID,"K",Sub)) q:Sub=""  d
 	.s id=PID_"||"_Sub
 	.s KPI=$p(^CF.DOC.GCPSW.PrjD(PID,"K",Sub),"^",1)
 	.s KTID=+KPI,CH=$p(KPI,"||",2)
 	.s KPIType=$p(^CF.DOC.GCPSW.KPITypeD(KTID),"^",2)
 	.s KPICode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",1)
 	.s KPIDesc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",2)
 	.s Expression=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",7)
 	.s Section=$p(^CF.DOC.GCPSW.PrjD(PID,"K",Sub),"^",2)
 	.s Val=$p(^CF.DOC.GCPSW.PrjD(PID,"K",Sub),"^",3)
 	.i Expression'="" d
 	..s Expression="s Val="_Expression
	..X Expression
 	.s Uom=$p(^CF.DOC.GCPSW.PrjD(PID,"K",Sub),"^",4)
 	.s note=$p(^CF.DOC.GCPSW.PrjD(PID,"K",Sub),"^",8)
 	.s exitFlag=$$IsExit(KPIContent,KPICode,KPIDesc)
	.q:exitFlag=1
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IsExit(KPIContent,KPICode,KPIDesc)
	s mRtn=1
	q:KPIContent="" 0
	s KPIContent=$zcvt(KPIContent,"U")
	s code=$zcvt(KPICode,"U")
	s desc=$zcvt(KPIDesc,"U")
	q:code[KPIContent 0
	q:desc[KPIContent 0
	
	Q mRtn
	
output1
	Set Data=$lb(id,KPI,KPIType,KPICode,KPIDesc,Section,Val,Uom,note)
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

}
