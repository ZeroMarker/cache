Class web.DHCENS.STBLL.UTIL.EnsTarLookUpTData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：源数据列表查询
/// Table：User.EnsTarLookUpTData
/// Input：为空查询全部
/// Output：返回全部
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsTarLookUpTData","GetTargetLookUpTableData","49")
Query GetTargetLookUpTableData(Input As %String) As %Query(ROWSPEC = "rowId:%String,targetCode:%String,targetDesc:%String")
{
}

ClassMethod GetTargetLookUpTableDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set lookUpTableDr=$p(Input,"^",1)
	set dataCode=$p(Input,"^",2)
	set dataDesc=$p(Input,"^",3)
	set targetCode=""  for  set targetCode=$o(^User.EnsTarLookUpTDataI("targetCode",lookUpTableDr,targetCode))  q:targetCode=""  d
	.set rowId=""  for  set rowId=$o(^User.EnsTarLookUpTDataI("targetCode",lookUpTableDr,targetCode,rowId))  q:rowId=""  d
	..set tempStr=^User.EnsTarLookUpTDataD(rowId)
	..set targetCode=$lg(tempStr,2)
	..Quit:((dataCode'="")&&(targetCode'[dataCode))
	..set targetDesc=$lg(tempStr,3)
	..Quit:((dataDesc'="")&&(targetDesc'[dataDesc))
	..set ^CacheTemp(repid,ind)=$lb(rowId,targetCode,targetDesc)
	..set ind=ind+1		
	Quit $$$OK
}

ClassMethod GetTargetLookUpTableDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTargetLookUpTableDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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
/// Table：User.EnsTarLookUpTData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsTarLookUpTData).SaveTargetTableDataInfo("")
ClassMethod SaveTargetTableDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	set rowId=$o(^User.EnsTarLookUpTDataI("targetCode",$p(Input,"^",1),$p(Input,"^",2),""))
	if rowId'=""  {
		Quit "0^"_rowId
	}
	else {
		set obj=##class(User.EnsTarLookUpTData).%New()
		set obj.targetCode=$p(Input,"^",2)
		set obj.targetDesc=$p(Input,"^",3)
		set targetDr=$p(Input,"^",1)
		set lookUpTable=##class(User.EnsLookUpTable).%OpenId(targetDr)
		set obj.targetTableDr=lookUpTable
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
/// Table：User.EnsTarLookUpTData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsTarLookUpTData).DeleteTargetTableDataInfo("")
ClassMethod DeleteTargetTableDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	set ^wudi(1)=Input
	set nodeId=$p(Input,"^",1)
	set targetId=$p(Input,"^",2)
	set rowId=$o(^User.EnsLookUpTDataI("targetTableDr",nodeId,targetId,""))
	if rowId'=""  {
		w "{""retvalue"":""-1"",""retinfo"":""目标数据已被使用""}"
	}
	else {
		set sc=##class(User.EnsTarLookUpTData).%DeleteId(targetId)
		if sc=1 {
			w "{""retvalue"":""0"",""retinfo"":""成功""}"
		}
		else {
			w "{""retvalue"":""-1"",""retinfo"":"""_sc_"""}"
		}
	}
	Quit ""
Exception
	w "{""retvalue"":""-1"",""retinfo"":"""_$ze_"""}"
	Quit ""
}

}
