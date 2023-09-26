/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 指标类型设置
Class DHCDoc.GCPSW.CFG.KPIType Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPIType).Save("903||1")
ClassMethod Save(mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s desc=$p(mList,"^",3)
	s note=$p(mList,"^",4)
	s user=$p(mList,"^",5)
	
	i id="" {
		s a=##class(User.GCPSWKPIType).%New()
		d a.KTUserSetObjectId(user)
		s a.KTDate=+$h
		s a.KTTime=$p($h,",",2)
		i $d(^CF.DOC.GCPSW.KPITypeI("KPIType","KTCode",code)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWKPIType).%OpenId(id)
		s oldCode=a.KTCode
		i $d(^CF.DOC.GCPSW.KPITypeI("KPIType","KTCode",code)) {
			i oldCode'=code {
				Q -2	
			}
		}
	}
	s a.KTNote=note
	s a.KTCode=code
	s a.KTDesc=desc
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
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPIType).DeleteTPL("")
ClassMethod Delete(KTID As %String)
{
	Q:KTID="" 0_"^"
	s rtn=..CanBeDelete(KTID)
	q:rtn=0 "-111^已被引用，不能删除！"
	&SQL(DELETE FROM SQLUser.GCPSW_KPIType WHERE KT_ID=:KTID)
	Q:SQLCODE'=0 "-102^删除失败！"
	
	Q 0_"^"
}

/// CTOR: QP
/// DATE: 2021-08-05
/// DESC: 删除
/// IN  : 
/// OUT : 1可删除 0不可删
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.KPIType).CanBeDelete("23")
ClassMethod CanBeDelete(KTID As %String)
{
	s mRtn=1
	s PID=""
	f  s PID=$O(^CF.DOC.GCPSW.PrjD(PID)) Q:(PID="")||(mRtn=0)  D
	.s sub=""
	.f  s sub=$O(^CF.DOC.GCPSW.PrjD(PID,"K",sub)) Q:(sub="")||(mRtn=0)  D
	..s KPI=$P(^CF.DOC.GCPSW.PrjD(PID,"K",sub),"^",1)
	..i KTID=+KPI s mRtn=0

	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 查询模板类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.KPIType","QryKPIType")
Query QryKPIType() As %Query(ROWSPEC = "id,code,desc,note")
{
}

ClassMethod QryKPITypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^CF.DOC.GCPSW.KPITypeD(id)) q:id=""  d
 	.s code=$p(^CF.DOC.GCPSW.KPITypeD(id),"^",1)
 	.s desc=$p(^CF.DOC.GCPSW.KPITypeD(id),"^",2)
 	.s note=$p(^CF.DOC.GCPSW.KPITypeD(id),"^",6)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,code,desc,note)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryKPITypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKPITypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryKPITypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKPITypeExecute ]
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
