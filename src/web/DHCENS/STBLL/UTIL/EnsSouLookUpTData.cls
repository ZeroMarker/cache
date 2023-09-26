Class web.DHCENS.STBLL.UTIL.EnsSouLookUpTData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：源数据列表查询
/// Table：User.EnsSouLookUpTData
/// Input：为空查询全部
/// Output：返回全部
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsSouLookUpTData","GetSourceLookUpTableData","2")
Query GetSourceLookUpTableData(Input As %String) As %Query(ROWSPEC = "rowId:%String,sourceCode:%String,sourceDesc:%String")
{
}

ClassMethod GetSourceLookUpTableDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set lookUpTableDr=$p(Input,"^",1)
	set dataCode=$p(Input,"^",2)
	set dataDesc=$p(Input,"^",3)
	set sourceCode=""  for  set sourceCode=$o(^User.EnsSouLookUpTDataI("sourceCode",lookUpTableDr,sourceCode))  q:sourceCode=""  d
	.set rowId=""  for  set rowId=$o(^User.EnsSouLookUpTDataI("sourceCode",lookUpTableDr,sourceCode,rowId))  q:rowId=""  d
	..set tempStr=^User.EnsSouLookUpTDataD(rowId)
	..set sourceCode=$lg(tempStr,2)
	..Quit:((dataCode'="")&&(sourceCode'[dataCode))
	..set sourceDesc=$lg(tempStr,3)
	..Quit:((dataDesc'="")&&(sourceDesc'[dataDesc))
	..Quit:$d(^User.EnsLookUpTDataI("sourceTableDr",lookUpTableDr,rowId))'=0
	..set ^CacheTemp(repid,ind)=$lb(rowId,sourceCode,sourceDesc)
	..set ind=ind+1		
	Quit $$$OK
}

ClassMethod GetSourceLookUpTableDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSourceLookUpTableDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：保存需要对照数据信息
/// Table：User.EnsSouLookUpTData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsSouLookUpTData).SaveSourceTableDataInfo("")
ClassMethod SaveSourceTableDataInfo(Input As %String) As %String
{
	set $zt="Exception"	
	set rowId=$o(^User.EnsSouLookUpTDataI("sourceCode",$p(Input,"^",1),$p(Input,"^",2),""))
	if rowId'=""  {
		Quit "-1^"_$p(Input,"^",2)_"已经添加"
	}
	else {
		set obj=##class(User.EnsSouLookUpTData).%New()
		set obj.sourceCode=$p(Input,"^",2)
		set obj.sourceDesc=$p(Input,"^",3)
		set sourceDr=$p(Input,"^",1)
		set lookUpTable=##class(User.EnsLookUpTable).%OpenId(sourceDr)
		set obj.sourceTableDr=lookUpTable
		set sc=obj.%Save()
		if sc=1 {
			Quit "0^"_obj.%Id()
		}
		else {
			Quit "-1^"_sc
		}
	}
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：保存需要对照数据信息
/// Table：User.EnsSouLookUpTData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsSouLookUpTData).DeleteSourceTableDataInfo("")
ClassMethod DeleteSourceTableDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	set rowId=$p(Input,"^",1)
	set sc=##class(User.EnsSouLookUpTData).%DeleteId(rowId)
	if sc=1 {
		w "{""retvalue"":""0"",""retinfo"":""成功""}"
	}
	else {
		w "{""retvalue"":""-1"",""retinfo"":"""_sc_"""}"
	}
	Quit ""
Exception
	w "{""retvalue"":""-1"",""retinfo"":"""_$ze_"""}"
	Quit ""
}

}
