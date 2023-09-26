/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 子项设置
Class DHCDoc.GCPSW.CFG.Item Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Item).Save("903||1")
ClassMethod Save(KTID, mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s desc=$p(mList,"^",3)
	s note=$p(mList,"^",4)
	s user=$p(mList,"^",5)
	s arcim=$p(mList,"^",6)
	
	i id="" {
		s a=##class(User.GCPSWItem).%New(KTID)
		d a.ITParRefSetObjectId(KTID)
		d a.ITUserSetObjectId(user)
		s a.ITDate=+$H
		s a.ITTime=$p($h,",",2)
		i $d(^CF.DOC.GCPSW.KPITypeI("Item","ITCode",KTID,code)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWItem).%OpenId(id)
		s oldCode=a.ITCode
		i $d(^CF.DOC.GCPSW.KPITypeI("Item","ITCode",KTID,code)) {
			i oldCode'=code {
				Q -2	
			}
		}
	}
	s a.ITCode=code
	s a.ITDesc=desc
	s a.ITNote=note
	//d a.ITArcimSetObjectId(arcim)
	s a.ITArcim=arcim
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
/// DATE: 2020-09-07
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Item).Delete("")
ClassMethod Delete(ITID As %String)
{
	Q:ITID="" 0
	/*&SQL(DELETE FROM SQLUser.GCPSW_ItemKPI WHERE IK_Parref=:ITID)
	i SQLCODE'=0 {
		TRO
		Q SQLCODE
	}*/
	&SQL(DELETE FROM SQLUser.GCPSW_Item WHERE IT_ID=:ITID)
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 查询指标
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Item","QryItem",1,"xx")
Query QryItem(KTID = "") As %Query(ROWSPEC = "id,code,desc,note,arcim")
{
}

ClassMethod QryItemExecute(ByRef qHandle As %Binary, KTID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i KTID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
 	s Sub=""
 	f  s Sub=$o(^CF.DOC.GCPSW.KPITypeD(KTID,"I",Sub)) q:Sub=""  d
 	.s id=KTID_"||"_Sub
 	.s code=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",Sub),"^",1)
 	.s desc=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",Sub),"^",2)
 	.s note=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",Sub),"^",6)
 	.s arcim=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",Sub),"^",7)
 	.s arcim=..GetArcimDesc(arcim)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output1
	Set Data=$lb(id,code,desc,note,arcim)
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
/// DATE: 2020-09-07
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Item).Delete("")
ClassMethod GetArcimDesc(ArcimID As %String)
{
	s mRtn=""
	Q:ArcimID="" mRtn
	f i=1:1:$l(ArcimID,",") {
		s arcim=$P(ArcimID,",",i)
		s desc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
		i mRtn="" s mRtn=desc
		e  s mRtn=mRtn_"，"_desc
	}
	Q mRtn
}

}
