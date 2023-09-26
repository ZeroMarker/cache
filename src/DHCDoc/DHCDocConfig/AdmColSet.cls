/// CTOR: QP
/// DATE: 2019-11-20
/// DESC: Page Col Setting
Class DHCDoc.DHCDocConfig.AdmColSet Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-11-22
/// DESC: 得到列信息
/// IN  :  
/// OUT :
/// w ##class(DHCDoc.DHCDocConfig.AdmColSet).GetColSetInfo("1||1||1")
ClassMethod GetColSetInfo(colid As %String = "", sp As %String = "") As %String
{
	n (colid,sp)
	s mRtn=""
	Q:colid="" ""
	i sp="" s sp="^"
	s outObj=##class(User.DHCDocOrderListSet).%OpenId(colid)
	i $ISObject(outObj) {
		s code=outObj.OLSCode
		s desc=outObj.OLSDesc
		s colWidth=outObj.OLSColWidth
		s hidden=outObj.OLSHidden
		s func=outObj.OLSExpression
		s mRtn=code_sp_desc_sp_colWidth_sp_hidden_sp_func
		d outObj.%Close()
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-11-22
/// DESC: 查询表格类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.AdmColSet","QryGridType","")
Query QryGridType(inPage As %String = "") As %Query(ROWSPEC = "id,code,desc,type")
{
}

ClassMethod QryGridTypeExecute(ByRef qHandle As %Binary, inPage As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i inPage="" {
		f  s inPage=$o(^DHCDocOG(inPage)) q:inPage=""  d
		.s sub=0
		.f  s sub=$o(^DHCDocOG(inPage,sub)) q:sub=""  d
		..d OutPutRow1
 	
 	}else {
		s sub=0
		f  s sub=$o(^DHCDocOG(inPage,sub)) q:sub=""  d
		.d OutPutRow1	
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
	Q mRtn
	
	
OutPutRow1
	s code=$p(^DHCDocOG(inPage,sub),"^",1)
	s desc=$p(^DHCDocOG(inPage,sub),"^",2)
	s type=$p(^DHCDocOG(inPage,sub),"^",3)
	s id=inPage_"||"_sub
	
	set Data=$lb(id,code,desc,type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryGridTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGridTypeExecute ]
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

ClassMethod QryGridTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGridTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-11-22
/// DESC: 查询列
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.AdmColSet","GetOrderListSet","1||1","id")
Query GetOrderListSet(DOGRowId = "", inContent = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,expression:%String,colwidth:%String,hidden:%String") [ SqlProc ]
{
}

ClassMethod GetOrderListSetExecute(ByRef qHandle As %Binary, DOGRowId As %String = "", inContent = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	s inContent=$zcvt(inContent,"U") 
	i DOGRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s OPRowId=$p(DOGRowId,"||",1)
	s child=$p(DOGRowId,"||",2)
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOLS(OPRowId,child,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",2)
 	.s expression=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",3)
 	.s colwidth=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",4)
 	.s hidden=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",5)
 	.s isExit=$$IfExit
	.q:isExit=1
 	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IfExit()
	s uCode=$zcvt(Code,"U") 
	s uDesc=$zcvt(Desc,"U")
	s uExpression=$zcvt(expression,"U") 
	s uColwidth=$zcvt(colwidth,"U")
	s mRtn=0
	I inContent'="" {
		s mRtn=1 
		i uCode[inContent s mRtn=0
		i uDesc[inContent s mRtn=0
		i uExpression[inContent s mRtn=0
		i uColwidth[inContent s mRtn=0
	}
	
	Q mRtn
OutputRow
	set Data=$lb(OPRowId_"||"_child_"||"_Rowid,Code,Desc,expression,colwidth,hidden)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderListSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrderListSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
