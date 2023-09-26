/// 名称: DHCMed.CCService.ItemCatSrv
/// 描述: DHCMed.CC.ItemCat 监控项目大类表常用方法
/// 编写者：liuyh
/// 编写日期: 2010-04-27
Class DHCMed.CCService.ItemCatSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lyh
/// CreatDate：   2010-04-27
/// Description:  查询监控项目大类信息
/// Table：       DHCMed.CC.ItemCat
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ItemCatSrv","QueryItemCatInfo","")
Query QueryItemCatInfo(ICCode As %String) As %Query(ROWSPEC = "rowid:%String,ICCode:%String,ICDesc:%String,SubjectDr:%String,title:%String")
{
}

ClassMethod QueryItemCatInfoExecute(ByRef qHandle As %Binary, ICCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.CC.ItemCatD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemCat).%OpenId(rowid)
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ICCode
	.q:((ICCode'="")&(obj.ICCode'[ICCode))
	.s $li(data,3)=obj.ICDesc
	.s SubjectDr=obj.SubjectDr
	.s SubObj=##class(DHCMed.CC.Subject).%OpenId(SubjectDr)
	.q:'$IsObject(SubObj)
	.s $li(data,4)=obj.SubjectDr
	.s $li(data,5)=SubObj.Title
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
    .do SubObj.%Close()
	q $$$OK
}

ClassMethod QueryItemCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItemCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemCatInfoExecute ]
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

/// Creator：     lyh
/// CreatDate：   2010-04-27
/// Description:  查询监控项目子类信息
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       ICRowid : 监控项目大类Rowid
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.ItemCatSrv","QueryItemSubCatInfo",1)
Query QueryItemSubCatInfo(ICRowid As %String) As %Query(ROWSPEC = "rowid:%String,ISCCode:%String,ISCDesc:%String,ISCCatDr:%String,ICDesc:%String")
{
}

ClassMethod QueryItemSubCatInfoExecute(ByRef qHandle As %Binary, ICRowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.CC.ItemSubCatD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.ItemSubCat).%OpenId(rowid)
	.q:ICRowid'=obj.ISCCatDr
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ISCCode
	.s $li(data,3)=obj.ISCDesc
	.s $li(data,4)=obj.ISCCatDr
	.q:+obj.ISCCatDr=0
	.s ICRet=##Class(DHCMed.CC.ItemCat).GetObjById(+obj.ISCCatDr)
	.q:ICRet=""
	.s $li(data,5)=ICRet.ICDesc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryItemSubCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemSubCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItemSubCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemSubCatInfoExecute ]
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

/// Creator：     lyh
/// CreatDate：   2010-04-28
/// Description:  根据项目大类ID删除项目大类及对应的项目子类
/// Table：       DHCMed.CC.ItemCat,DHCMed.CC.ItemSubCat
/// Input：       ICId  项目大类Id
///              
/// Return：      返回是否成功标志 1:成功   0:失败
/// w ##class(DHCMed.CCService.ItemCatSrv).DelInfoFromICId(1)
ClassMethod DelInfoFromICId(ICId As %String) As %String
{
	new (ICId)
	set ret=0,rowid="",ISCCode=""
	set $ZT="Error"
	TStart
	set ret=##class(DHCMed.CC.ItemCat).DeleteById(ICId)
	if ret<0 TRollback
	
	set ISCCode=$tr($o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ICId," "_ISCCode))," ","")
	while ISCCode'=""
	{
		set rowid=$o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ICId," "_ISCCode,""))
		set ISCCode=$tr($o(^DHCMed.CC.ItemSubCatI("ISCCodeIndex",ICId," "_ISCCode))," ","")
		quit:rowid=""
		set ret=##class(DHCMed.CC.ItemSubCat).DeleteById(rowid)
		if ret<0 TRollback
	}
	TCommit
	set ret=1
	quit ret
Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

}
