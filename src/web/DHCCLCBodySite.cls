Import SQLUser

/// creater:		zsk
/// creatDate:	2023/02/10
/// 
Class web.DHCCLCBodySite Extends %RegisteredObject
{

/// creater:		LYN
/// creatDate:	2015/06/29
/// descripation:查询诊断分类信息
/// d ##class(%ResultSet).RunQuery("web.DHCCLCBodySite","FindBodySite","","","")
Query FindBodySite(code As %String = "", desc As %String = "", locId As %String) As %Query(ROWSPEC = "rowId:%String,Code:%String,Desc:%String,LocId:%String,LocDesc:%String")
{
}

ClassMethod FindBodySiteExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "", locId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowId=0,i=0 
	f  s rowId=$o(^DHCCLC("BodySite",rowId)) q:rowId=""  d
	.s Code=$lg($g(^DHCCLC("BodySite",rowId)),1)
	.q:(code'="")&&(Code'=code)
	.s Desc=$lg($g(^DHCCLC("BodySite",rowId)),2)
	.q:(desc'="")&&(Desc'[desc)
	.s LocId=$lg($g(^DHCCLC("BodySite",rowId)),3)
	.q:(locId'="")&&(locId'=LocId)
	.s LocDesc=""
	.s:LocId'="" LocDesc=$p($g(^CTLOC(LocId)),"^",2) 
 	.Do OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(rowId,Code,Desc,LocId,LocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBodySiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBodySiteExecute ]
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

ClassMethod FindBodySiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBodySiteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creater:		zsk
/// creatDate:	2023/02/11
/// table:		DHC_CLC_BodySite
/// input:		Code:分类代码；Desc:分类名称
/// description:	插入诊断分类信息\
ClassMethod SaveBodySite(rowId As %String, Code As %String, Desc As %String, LocId As %String) As %String
{
	q:Code="" "分类代码不能为空" 
	q:Desc="" "分类名称不能为空"
	;s Code=$$ALPHAUP^SSUTIL4(Code)
    set obj=##class(User.DHCCLCBodySite).%New()
    if (rowId'="")
    {
    	set obj=##class(User.DHCCLCBodySite).%OpenId(rowId)
    }
    else
    {
    	set obj=##class(User.DHCCLCBodySite).%New()
    }
    set obj.CLCBSCode=Code
    set obj.CLCBSDesc=Desc
    set obj.CLCBSLocDr=LocId
    do obj.%Save()
    quit obj.%Id()
}

/// w ##class(web.DHCCLCBodySite).DeleteBodySite()
ClassMethod DeleteBodySite(Rowid As %String) As %String
{
	q:Rowid="" "Id不能为空"
	&SQL(delete from DHCCLC_BodySite  where CLCBS_RowId=:Rowid)
    i SQLCODE'=0  q "删除部位错误!"
    q 0
}

}
