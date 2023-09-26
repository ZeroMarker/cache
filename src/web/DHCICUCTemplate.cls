Import SQLUser

Class web.DHCICUCTemplate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetTemplateSuperCatsByLocId(locId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   ICUCTSC_Code As Code,
	   ICUCTSC_Desc As Description,
	   ICUCTSC_Active As Active,
	   ICUCTSC_Ctloc_Dr As LocationId
	   FROM DHC_ICUC_TemplateSuperCat
	   Where ICUCTSC_Ctloc_Dr=:locId
}

Query GetAllTemplateCat() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   ICUCTC_Code As Code,
	   ICUCTC_Desc As Description,
	   ICUCTC_Active As Active,
	   ICUCTC_ICUCTSC_Dr As TemplateSuperCatId
	   FROM DHC_ICUC_TemplateCat
}

Query GetAllTemplate() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   ICUCT_Code As Code,
	   ICUCT_Desc As Description,
	   ICUCT_Active As Active,
	   ICUCT_ICUCTC_Dr As TemplateCatId,
	   ICUCT_Data As Content
	   FROM DHC_ICUC_Template
}

ClassMethod InsertTemplateSuperCat(code As %String, desc As %String, active As %String, locationId As %String) As %String
{
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:locationId="" "登陆位置ID不能为空"
	
	k PLIST
	TSTART
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=locationId
	&SQL(insert into DHC_ICUC_TemplateSuperCat Values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateTemplateSuperCat(id As %String, code As %String, desc As %String, active As %String, locationId As %String) As %String
{
	q:id="" "ID不能为空"
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:locationId="" "登陆位置ID不能为空"
	
	K PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=locationId
	&SQL(update DHC_ICUC_TemplateSuperCat Values:PLIST() Where %ID=:id)
	q SQLCODE
}

ClassMethod DeleteTemplateSuperCat(id As %String) As %String
{
	i id'=""  d
	.&SQL(delete from DHC_ICUC_TemplateSuperCat where %ID=:id)
	q SQLCODE
}

ClassMethod InsertTemplateCat(code As %String, desc As %String, active As %String, templateSuperCatId As %String) As %String
{
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:templateSuperCatId="" "大类ID不能为空"
	
	k PLIST
	TSTART
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=templateSuperCatId
	&SQL(insert into DHC_ICUC_TemplateCat Values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateTemplateCat(id As %String, code As %String, desc As %String, active As %String, templateSuperCatId As %String) As %String
{
	q:id="" "ID不能为空"
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:templateSuperCatId="" "大类ID不能为空"
	
	K PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=templateSuperCatId
	&SQL(update DHC_ICUC_TemplateCat Values:PLIST() Where %ID=:id)
	q SQLCODE
}

ClassMethod DeleteTemplateCat(id As %String) As %String
{
	i id'=""  d
	.&SQL(delete from DHC_ICUC_TemplateCat where %ID=:id)
	q SQLCODE
}

ClassMethod InsertTemplate(code As %String, desc As %String, active As %String, templateCatId As %String, content As %String) As %String
{
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:templateCatId="" "大类ID不能为空"
	
	k PLIST
	TSTART
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=templateCatId
	s PLIST(6)=content
	&SQL(insert into DHC_ICUC_Template Values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateTemplate(id As %String, code As %String, desc As %String, active As %String, templateCatId As %String, content As %String) As %String
{
	q:id="" "ID不能为空"
	q:code="" "代码不能为空"
	q:desc="" "名称不能为空"
	q:active="" "激活状态不能为空"
	q:templateCatId="" "大类ID不能为空"
	
	K PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=active
	s PLIST(5)=templateCatId
	s PLIST(6)=content
	&SQL(update DHC_ICUC_Template Values:PLIST() Where %ID=:id)
	q SQLCODE
}

ClassMethod DeleteTemplate(id As %String) As %String
{
	i id'=""  d
	.&SQL(delete from DHC_ICUC_Template where %ID=:id)
	q SQLCODE
}

/// 添加功能维护
/// d ##class(web.DHCICUCTemplate).AddICUCTemplate("AHmn","羊水破裂","Y","5")	
ClassMethod AddICUCTemplate(icuctCode, icuctDesc, icuctActive, icucticuctcDr) As %String
{
	q:icuctCode="" "代码不能为空!"
	q:icuctDesc="" "描述不能为空!"
	s objICUCTemplate = ##class(User.DHCICUCTemplate).%New()
	s objICUCTemplate.ICUCTCode=icuctCode
	s objICUCTemplate.ICUCTDesc=icuctDesc
	s objICUCTemplate.ICUCTActive=icuctActive
	s objICUCTemplateC=##class(User.DHCICUCTemplateCat).%OpenId(icucticuctcDr)
	s objICUCTemplate.ICUCTICUCTCDr=objICUCTemplateC
	//s objICUCTemplate.ICUCTICUCTSCDr=icucticuctscDr
	s saveStatus=objICUCTemplate.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s templateId=objICUCTemplate.%Id()
	d objICUCTemplate.%Close()
	q 0
}

/// 更新功能维护
/// d ##class(web.DHCICUCTemplate).UpdateICUCTemplate("3","AHmn","羊水破裂","N","5")
ClassMethod UpdateICUCTemplate(icuctId, icuctCode, icuctDesc, icuctActive, icucticuctcDr) As %String
{
	q:icuctId="" "RowId不能为空!"
	q:icuctCode="" "代码不能为空!"
	q:icuctDesc="" "描述不能为空!"
	//q:'##class(User.DHCICUCTemplate).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s objICUCTemplate = ##class(User.DHCICUCTemplate).%OpenId(icuctId)
	s objICUCTemplate.ICUCTCode=icuctCode
	s objICUCTemplate.ICUCTDesc=icuctDesc
	s objICUCTemplate.ICUCTActive=icuctActive
	s objICUCTemplateC=##class(User.DHCICUCTemplateCat).%OpenId(icucticuctcDr)
	s objICUCTemplate.ICUCTICUCTCDr=objICUCTemplateC
	//s objICUCTemplate.ICUCTICUCTCDr=icucticuctcDr
	s updateStatus=objICUCTemplate.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s templateId=objICUCTemplate.%Id()
	d objICUCTemplate.%Close()
	q 0
}

/// 删除功能维护
/// d ##class(web.DHCICUCTemplate).DelICUCTemplate("1")
ClassMethod DelICUCTemplate(icuctId) As %String
{
	q:icuctId="" "RowId不能为空!"
	//q:'##class(User.DHCICUCTemplate).%ExistsId(templateId) "模板码表指针无对应记录!" 
	s deleteStatus=##class(User.DHCICUCTemplate).%DeleteId(icuctId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// 查询功能维护
/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplate","FindICUCTemplate","")
Query FindICUCTemplate(icuctCode) As %Query(ROWSPEC = "icuctId:%String,icuctCode:%String,icuctDesc:%String,icuctActive:%String,icuctActiveD:%String,icucticuctcDr:%String,icucticuctc:%String") [ SqlProc ]
{
}

ClassMethod FindICUCTemplateExecute(ByRef qHandle As %Binary, icuctCode) As %Status
{
 	//new repid,index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	if ($g(icuctCode)'="")  d
 	.s len=$l(icuctCode)
 	.s icuCode=$o(^DHCICUC("Template",0,"Code",icuctCode),-1)
 	.f  s icuCode=$o(^DHCICUC("Template",0,"Code",icuCode)) q:icuCode=""||($e(icuCode,1,len)'=icuctCode)  d   //注意"||"后面的条件须加()
 	..s icuctId=0
 	..f  s icuctId=$o(^DHCICUC("Template",0,"Code",icuCode,icuctId)) q:icuctId=""  d
 	...d SeticuctInfo

 	e  d
 	
 	.s icuCode=""
 	.f  s icuCode=$o(^DHCICUC("Template",0,"Code",icuctCode))  q:icuCode=""  d
 	..s icuctId=0
 	..f  s icuctId=$o(^DHCICUC("Template",0,"Code",icuCode,icuctId)) q:icuctId=""  d
	...d SeticuctInfo
	
	
	Quit $$$OK
OutputRowFindICUCTemplate
	set Data=$lb(icuctId,icuctCode,icuctDesc,icuctActive,icuctActiveD,icucticuctcDr,icucticuctc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
SeticuctInfo
  	s RowId=icuctId
 	s icuctCode=$li(^DHCICUC("Template",icuctId),1)
 	s icuctDesc=$li(^DHCICUC("Template",icuctId),2)
 	s icuctActive=$li(^DHCICUC("Template",icuctId),3)
 	s:icuctActive="Y" icuctActiveD="Yes"
 	s:icuctActive="N" icuctActiveD="No"
 	s icucticuctcDr=$li(^DHCICUC("Template",icuctId),4)
 	s icucticuctc=$li(^DHCICUC("TCat",icucticuctcDr),2)
 	d OutputRowFindICUCTemplate 
 	
 	quit
}

ClassMethod FindICUCTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCTemplateExecute ]
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

ClassMethod FindICUCTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCTemplateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCTemplate","FindTemplateC")
Query FindTemplateC() As %Query(ROWSPEC = "ICUCTDesc:%String,ICUCTRowId:%String") [ SqlProc ]
{
}

ClassMethod FindTemplateCExecute(ByRef qHandle As %Binary) As %Status
{
	;Quit $$$OK
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
    
	s ICUCTRowId=0
	f  s ICUCTRowId=$o(^DHCICUC("TCat",ICUCTRowId))  q:ICUCTRowId=""  d
    .s ICUCTDesc=$li(^DHCICUC("TCat",ICUCTRowId),2)
	.d OutputRow7

	Quit $$$OK
OutputRow7
	set Data=$lb(ICUCTDesc,ICUCTRowId)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod FindTemplateCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateCExecute ]
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

ClassMethod FindTemplateCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
