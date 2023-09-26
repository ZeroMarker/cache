Import SQLUSER

Class web.DHCANRCRiskCLass Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Table：DHC_ANRC_RiskClass,CT_Loc
/// d ##class(%ResultSet).RunQuery("web.DHCANRCRiskCLass","FindRiskClass","low","","")
Query FindRiskClass(desc As %String, code As %String = "", ctloc As %String = "") As %Query(ROWSPEC = "anrcrcId:%String,tCode:%String,tDesc:%String,tCtlocId:%String,tCtlocDesc:%String")
{
}

ClassMethod FindRiskClassExecute(ByRef qHandle As %Binary, desc As %String = "", code As %String = "", ctloc As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s ^tempck(321)=desc_"/"_code_"/"_ctloc
 	s anrcrcId="" f  s anrcrcId=$o(^DHCANRC("RiskClass",anrcrcId)) q:anrcrcId=""  d
 	.s tCode=$li(^DHCANRC("RiskClass",anrcrcId),1)
 	.q:(code'="")&(code'=tCode)
 	.s tDesc=$li(^DHCANRC("RiskClass",anrcrcId),2)
 	.q:(desc'="")&(desc'=tDesc)
 	.s tCtlocId=$li(^DHCANRC("RiskClass",anrcrcId),3)
 	.q:(ctloc'="")&(ctloc'=tCtlocId)
 	.s tCtlocDesc=""
 	.i tCtlocId=+tCtlocId s tCtlocDesc=$p(^CTLOC(tCtlocId),"^",2)
 	.d OutPutRiskClass
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutRiskClass
	set Data=$lb(anrcrcId,tCode,tDesc,tCtlocId,tCtlocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRiskClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRiskClassExecute ]
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

ClassMethod FindRiskClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRiskClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCANRRisk).InsertRiskClass("Z","中","42")
ClassMethod InsertRiskClass(tCode As %String, tDesc As %String, tCtlocId As %String) As %String
{
	q:tCode="" "Code不能为空"
	q:tDesc="" "描述不能为空"
	;q:tCtlocId="" ""  //科室为空，全院通用项目？
	
	&sql(select ANRCRC_RowId into tRowId from DHC_ANRC_RiskClass where ANRCRC_Code=:tCode and ANRCRC_Desc=:tDesc and ANRCRC_Ctloc_Dr=:tCtlocId)
	q:tRowId'="" "已存在,RowId为"_tRowId

	&sql(insert into DHC_ANRC_RiskClass set ANRCRC_Code=:tCode,ANRCRC_Desc=:tDesc,ANRCRC_Ctloc_Dr=:tCtlocId)
	q SQLCODE
}

ClassMethod DeleteRiskClass(tRowId As %String) As %String
{
	q:tRowId="" "RowId不能为空"
	
	&sql(Delete from DHC_ANRC_RiskClass where ANRCRC_RowId=:tRowId)
	q SQLCODE
}

ClassMethod UpdateRiskClass(tRowId As %String, tCode As %String, tDesc As %String, tCtlocId As %String) As %String
{
	q:tRowId="" "RowId不能为空"
	q:tCode="" "Code不能为空"
	q:tDesc="" "描述不能为空"
	
	&sql(select ANRCRC_RowId into crcRowId from DHC_ANRC_RiskClass where ANRCRC_Code=:tCode and ANRCRC_Desc=:tDesc and ANRCRC_Ctloc_Dr=:tCtlocId)
	q:crcRowId'="" "已存在,修改失败"
	
	&sql(update DHC_ANRC_RiskClass set ANRCRC_Code=:tCode,ANRCRC_Desc=:tDesc,ANRCRC_Ctloc_Dr=:tCtlocId where ANRCRC_RowId=:tRowId)	
	q SQLCODE
}

}
