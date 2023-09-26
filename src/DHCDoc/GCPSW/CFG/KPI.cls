/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 指标设置
Class DHCDoc.GCPSW.CFG.KPI Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPI).Save("903||1")
ClassMethod Save(KTID, mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s name=$p(mList,"^",3)
	s complex=$p(mList,"^",4)
	s note=$p(mList,"^",5)
	s user=$p(mList,"^",6)
	s express=$p(mList,"^",7)
	
	i id="" {
		s a=##class(User.GCPSWKPI).%New(KTID)
		d a.KPIParRefSetObjectId(KTID)
		d a.KPIAddUserSetObjectId(user)
		s a.KPIAddDate=+$H
		s a.KPIAddTime=$p($h,",",2)
		
		i $d(^CF.DOC.GCPSW.KPITypeI("KPI","KPICode",KTID,code)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWKPI).%OpenId(id)
		s oldCode=a.KPICode
		i $d(^CF.DOC.GCPSW.KPITypeI("KPI","KPICode",KTID,code)) {
			i oldCode'=code {
				Q -2	
			}
		}
	}
	s a.KPICode=code
	s a.KPIName=name
	s a.KPINote=note
	s a.KPIComplex=complex
	s a.KPIExpress=express
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
/// DATE: 2020-09-03
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPI).Delete("")
ClassMethod Delete(KPIID As %String)
{
	Q:KPIID="" 0_"^"
	s rtn=..CanBeDelete(KPIID)
	q:rtn=0 "-111^已被引用，不能删除！"
	&SQL(DELETE FROM SQLUser.GCPSW_KPI WHERE KPI_ID=:KPIID)
	Q:SQLCODE'=0 "-102^删除失败！"
	
	Q 0_"^"
}

/// CTOR: QP
/// DATE: 2021-08-05
/// DESC: 删除
/// IN  : 
/// OUT : 1可删除 0不可删
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPIType).CanBeDelete("23")
ClassMethod CanBeDelete(KPIID As %String)
{
	s mRtn=1
	s PID=""
	f  s PID=$O(^CF.DOC.GCPSW.PrjD(PID)) Q:(PID="")||(mRtn=0)  D
	.s sub=""
	.f  s sub=$O(^CF.DOC.GCPSW.PrjD(PID,"K",sub)) Q:(sub="")||(mRtn=0)  D
	..s KPI=$P(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",1)
	..i KPIID=KPI s mRtn=0

	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 查询指标
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.KPI","QryKPI",1,"xx")
Query QryKPI(KTID = "", KPIContent = "") As %Query(ROWSPEC = "id,code,name,complex,note,express")
{
}

ClassMethod QryKPIExecute(ByRef qHandle As %Binary, KTID = "", KPIContent = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i KTID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
 	s Sub=""
 	f  s Sub=$o(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub)) q:Sub=""  d
 	.s id=KTID_"||"_Sub
 	.s code=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub),"^",1)
 	.s name=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub),"^",2)
 	.s complex=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub),"^",3)
 	.s note=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub),"^",7)
 	.s express=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",Sub),"^",8)
 	.s exitFlag=$$IsExit(KPIContent,code,name,note)
 	.b ;001
	.q:exitFlag=1
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IsExit(KPIContent,code,name,note)
	s mRtn=1
	q:KPIContent="" 0
	s KPIContent=$zcvt(KPIContent,"U")
	s code=$zcvt(code,"U")
	s name=$zcvt(name,"U")
	s note=$zcvt(note,"U")
	q:code[KPIContent 0
	q:name[KPIContent 0
	q:note[KPIContent 0
	
	Q mRtn
	
output1
	Set Data=$lb(id,code,name,complex,note,express)
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
