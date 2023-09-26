Import SQLUser

/// 编写者：吴玲玲
/// 编写日期：2012年8月15日
/// 功能描述：实现ICU模板分类的维护功能：包括查询，添加，更新，删除功能
/// 表：DHCICUCTemplateCat
Class web.DHCICUCTemplateCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 添加功能维护
/// d ##class(web.DHCICUCTemplateCat).AddICUCTemplateC("WAbc","胎儿异动","Y","4")	
ClassMethod AddICUCTemplateC(icuctcCode, icuctcDesc, icuctcActive, icuctcicuctscDr) As %String
{
	q:icuctcCode="" "代码不能为空!"
	q:icuctcDesc="" "描述不能为空!"
	s objICUCTemplateC = ##class(User.DHCICUCTemplateCat).%New()
	s objICUCTemplateC.ICUCTCCode=icuctcCode
	s objICUCTemplateC.ICUCTCDesc=icuctcDesc
	s objICUCTemplateC.ICUCTCActive=icuctcActive
	s objICUCTemplateSC=##class(User.DHCICUCTemplateSuperCat).%OpenId(icuctcicuctscDr)
	s objICUCTemplateC.ICUCTCICUCTSCDr=objICUCTemplateSC
	//s objICUCTemplateC.ICUCTCICUCTSCDr=icuctcicuctscDr
	s saveStatus=objICUCTemplateC.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s templateCId=objICUCTemplateC.%Id()
	d objICUCTemplateC.%Close()
	q 0
}

/// 更新功能维护
/// d ##class(web.DHCICUCTemplateCat).UpdateICUCTemplateC("5","WAbc","胎儿异动","N","6")
ClassMethod UpdateICUCTemplateC(icuctcId, icuctcCode, icuctcDesc, icuctcActive, icuctcicuctscDr) As %String
{
	q:icuctcId="" "RowId不能为空!"
	q:icuctcCode="" "代码不能为空!"
	q:icuctcDesc="" "描述不能为空!"
	//q:'##class(User.DHCICUCTemplateCat).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s objICUCTemplateC = ##class(User.DHCICUCTemplateCat).%OpenId(icuctcId)
	s objICUCTemplateC.ICUCTCCode=icuctcCode
	s objICUCTemplateC.ICUCTCDesc=icuctcDesc
	s objICUCTemplateC.ICUCTCActive=icuctcActive
	s objICUCTemplateSC=##class(User.DHCICUCTemplateSuperCat).%OpenId(icuctcicuctscDr)
	s objICUCTemplateC.ICUCTCICUCTSCDr=objICUCTemplateSC
	//s objICUCTemplateC.ICUCTCICUCTSCDr=icuctcicuctscDr
	s updateStatus=objICUCTemplateC.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s templateCId=objICUCTemplateC.%Id()
	d objICUCTemplateC.%Close()
	q 0
}

/// 删除功能维护
/// d ##class(web.DHCICUCTemplateCat).DelICUCTemplateC("1")
ClassMethod DelICUCTemplateC(icuctcId) As %String
{
	q:icuctcId="" "RowId不能为空!"
	//q:'##class(User.DHCICUCTemplateCat).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s deleteStatus=##class(User.DHCICUCTemplateCat).%DeleteId(icuctcId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// 查询功能维护
/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplateCat","FindICUCTemplateC","ICU")
Query FindICUCTemplateC(icuctcCode) As %Query(ROWSPEC = "icuctcId:%String,icuctcCode:%String,icuctcDesc:%String,icuctcActive:%String,icuctcActiveD:%String,icuctcicuctscDr:%String,icuctcicuctsc:%String") [ SqlProc ]
{
}

ClassMethod FindICUCTemplateCExecute(ByRef qHandle As %Binary, icuctcCode) As %Status
{
 	//new repid,index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	if ($g(icuctcCode)'="")  d
 	.s len=$l(icuctcCode)
 	.s icucCode=$o(^DHCICUC("TCat",0,"Code",icuctcCode),-1)
 	.f  s icucCode=$o(^DHCICUC("TCat",0,"Code",icucCode)) q:icucCode=""||($e(icucCode,1,len)'=icuctcCode)  d   //注意"||"后面的条件须加()
 	..s icuctcId=0
 	..f  s icuctcId=$o(^DHCICUC("TCat",0,"Code",icucCode,icuctcId)) q:icuctcId=""  d
 	...d SeticuctcInfo

 	e  d
 	
 	.s icucCode=""
 	.f  s icucCode=$o(^DHCICUC("TCat",0,"Code",icuctcCode))  q:icucCode=""  d
 	..s icuctcId=0
 	..f  s icuctcId=$o(^DHCICUC("TCat",0,"Code",icucCode,icuctcId)) q:icuctcId=""  d
	...d SeticuctcInfo
	
	
	Quit $$$OK
OutputRowFindICUCTemplateC
	set Data=$lb(icuctcId,icuctcCode,icuctcDesc,icuctcActive,icuctcActiveD,icuctcicuctscDr,icuctcicuctsc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
SeticuctcInfo
  	s RowId=icuctcId
 	s icuctcCode=$li(^DHCICUC("TCat",icuctcId),1)
 	s icuctcDesc=$li(^DHCICUC("TCat",icuctcId),2)
 	s icuctcActive=$li(^DHCICUC("TCat",icuctcId),3)
 	s:icuctcActive="Y" icuctcActiveD="Yes"
 	s:icuctcActive="N" icuctcActiveD="No"
 	s icuctcicuctscDr=$li(^DHCICUC("TCat",icuctcId),4)
 	s icuctcicuctsc=$li(^DHCICUC("TSCat",icuctcicuctscDr),2)
 	d OutputRowFindICUCTemplateC 
 	
 	quit
}

ClassMethod FindICUCTemplateCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCTemplateCExecute ]
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

ClassMethod FindICUCTemplateCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCTemplateCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplateCat","FindTemplateSC")
Query FindTemplateSC() As %Query(ROWSPEC = "ICUCTCDesc:%String,ICUCTCRowId:%String") [ SqlProc ]
{
}

ClassMethod FindTemplateSCExecute(ByRef qHandle As %Binary) As %Status
{
	;Quit $$$OK
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
    
	s ICUCTCRowId=0
	f  s ICUCTCRowId=$o(^DHCICUC("TSCat",ICUCTCRowId))  q:ICUCTCRowId=""  d
    .s ICUCTCDesc=$li(^DHCICUC("TSCat",ICUCTCRowId),2)
	.d OutputRow7

	Quit $$$OK
OutputRow7
	set Data=$lb(ICUCTCDesc,ICUCTCRowId)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod FindTemplateSCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateSCExecute ]
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

ClassMethod FindTemplateSCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateSCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
