Import SQLUser

/// 编写者：吴玲玲
/// 编写日期：2012年8月14日
/// 功能描述：实现ICU模板大类的维护功能：包括查询，添加，更新，删除功能
/// 表：DHCICUCTemplateSuperCat
Class web.DHCICUCTemplateSuperCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 添加功能维护
/// d ##class(web.DHCICUCTemplateSuperCat).AddICUCTemplateSC("ICUWomen","孕妇急症","Y","1")	
/// d ##class(web.DHCICUCTemplateSuperCat).AddICUCTemplateSC("ICUChild","儿童急症","N","3")
/// d ##class(web.DHCICUCTemplateSuperCat).AddICUCTemplateSC("ICUYiXing","孕妇急症","Y","11")
/// d ##class(web.DHCICUCTemplateSuperCat).AddICUCTemplateSC("ICUNose","外科急症","Y","17")
/// d ##class(web.DHCICUCTemplateSuperCat).AddICUCTemplateSC("ICUXueya","内科急症","N","15")
ClassMethod AddICUCTemplateSC(icuctscCode, icuctscDesc, icuctscActive, icuctscctlocDr) As %String
{
	q:icuctscCode="" "代码不能为空!"
	q:icuctscDesc="" "描述不能为空!"
	s objICUCTemplateSC = ##class(User.DHCICUCTemplateSuperCat).%New()
	s objICUCTemplateSC.ICUCTSCCode=icuctscCode
	s objICUCTemplateSC.ICUCTSCDesc=icuctscDesc
	s objICUCTemplateSC.ICUCTSCActive=icuctscActive
	//s objICUCTemplateSCCtloc=##class(User.CTLoc).%OpenId(icuctscctlocDr)
	//s objICUCTemplateSC.ICUCTSCCtlocDr=objICUCTemplateSCCtloc
	s objICUCTemplateSC.ICUCTSCCtlocDr=icuctscctlocDr
	s saveStatus=objICUCTemplateSC.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s templateSCId=objICUCTemplateSC.%Id()
	d objICUCTemplateSC.%Close()
	q 0
}

/// 更新功能维护
/// d ##class(web.DHCICUCTemplateSuperCat).UpdateICUCTemplateSC("1","ICUNose","外科急症","N","17")
ClassMethod UpdateICUCTemplateSC(icuctscId, icuctscCode, icuctscDesc, icuctscActive, icuctscctlocDr) As %String
{
	q:icuctscId="" "RowId不能为空!"
	q:icuctscCode="" "代码不能为空!"
	q:icuctscDesc="" "描述不能为空!"
	//q:'##class(User.DHCICUCTemplateSuperCat).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s objICUCTemplateSC = ##class(User.DHCICUCTemplateSuperCat).%OpenId(icuctscId)
	s objICUCTemplateSC.ICUCTSCCode=icuctscCode
	s objICUCTemplateSC.ICUCTSCDesc=icuctscDesc
	s objICUCTemplateSC.ICUCTSCActive=icuctscActive
	s objICUCTemplateSC.ICUCTSCCtlocDr=icuctscctlocDr
	s updateStatus=objICUCTemplateSC.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s templateSCId=objICUCTemplateSC.%Id()
	d objICUCTemplateSC.%Close()
	q 0
}

/// 删除功能维护
/// d ##class(web.DHCICUCTemplateSuperCat).DelICUCTemplateSC("1")
ClassMethod DelICUCTemplateSC(icuctscId) As %String
{
	q:icuctscId="" "RowId不能为空!"
	//q:'##class(User.DHCICUCTemplateSuperCat).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s deleteStatus=##class(User.DHCICUCTemplateSuperCat).%DeleteId(icuctscId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// 查询功能维护
/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplateSuperCat","FindICUCTemplateSC","ICU")
Query FindICUCTemplateSC(icuctscCode) As %Query(ROWSPEC = "icuctscId:%String,icuctscCode:%String,icuctscDesc:%String,icuctscActive:%String,icuctscActiveD:%String,icuctscCtlocDr:%String,icuctscCtloc:%String") [ SqlProc ]
{
}

ClassMethod FindICUCTemplateSCExecute(ByRef qHandle As %Binary, icuctscCode) As %Status
{
 	//new repid,index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	if ($g(icuctscCode)'="")  d
 	.s len=$l(icuctscCode)
 	.s icuscCode=$o(^DHCICUC("TSCat",0,"Code",icuctscCode),-1)
 	.f  s icuscCode=$o(^DHCICUC("TSCat",0,"Code",icuscCode)) q:icuscCode=""||($e(icuscCode,1,len)'=icuctscCode)  d   //注意"||"后面的条件须加()
 	..s icuctscId=0
 	..f  s icuctscId=$o(^DHCICUC("TSCat",0,"Code",icuscCode,icuctscId)) q:icuctscId=""  d
 	...d SeticuctscInfo

 	e  d
 	
 	.s icuscCode=""
 	.f  s icuscCode=$o(^DHCICUC("TSCat",0,"Code",icuctscCode))  q:icuscCode=""  d
 	..s icuctscId=0
 	..f  s icuctscId=$o(^DHCICUC("TSCat",0,"Code",icuscCode,icuctscId)) q:icuctscId=""  d
	...d SeticuctscInfo
	
	
	Quit $$$OK
OutputRowFindICUCTemplateSC
	set Data=$lb(icuctscId,icuctscCode,icuctscDesc,icuctscActive,icuctscActiveD,icuctscCtlocDr,icuctscCtloc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
SeticuctscInfo
  	s RowId=icuctscId
 	s icuctscCode=$li(^DHCICUC("TSCat",icuctscId),1)
 	s icuctscDesc=$li(^DHCICUC("TSCat",icuctscId),2)
 	s icuctscActive=$li(^DHCICUC("TSCat",icuctscId),3)
 	s:icuctscActive="Y" icuctscActiveD="Yes"
 	s:icuctscActive="N" icuctscActiveD="No"
 	s icuctscCtlocDr=$li(^DHCICUC("TSCat",icuctscId),4)
 	s icuctscCtloc=$p($g(^CTLOC(+icuctscCtlocDr)),"^",2)
 	d OutputRowFindICUCTemplateSC 
 	
 	quit
}

ClassMethod FindICUCTemplateSCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCTemplateSCExecute ]
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

ClassMethod FindICUCTemplateSCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCTemplateSCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplateSuperCat","FindCtLoc")
Query FindCtLoc() As %Query(ROWSPEC = "CTLOCDesc:%String,CTLOCRowId:%String") [ SqlProc ]
{
}

ClassMethod FindCtLocExecute(ByRef qHandle As %Binary) As %Status
{
	;Quit $$$OK
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
    
	s CTLOCRowId=0
	f  s CTLOCRowId=$o(^CTLOC(CTLOCRowId))  q:CTLOCRowId=""  d
    .s CTLOCDesc=$p(^CTLOC(CTLOCRowId),"^",2)
	.d OutputRow7

	Quit $$$OK
OutputRow7
	set Data=$lb(CTLOCDesc,CTLOCRowId)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod FindCtLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtLocExecute ]
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

ClassMethod FindCtLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
