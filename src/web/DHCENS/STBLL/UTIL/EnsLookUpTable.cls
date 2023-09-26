Class web.DHCENS.STBLL.UTIL.EnsLookUpTable Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—11-18
/// Description：数据对照列表查询
/// Table：User.EnsLookUpTable
/// Input：为空查询全部
/// Output：返回全部
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsLookUpTable","GetLookUpTableInfoData","")
Query GetLookUpTableInfoData(Input As %String) As %Query(ROWSPEC = "id:%String,text:%String,state:%String,isParent:%String,children:%String")
{
}

ClassMethod GetLookUpTableInfoDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set ^CacheTemp(repid,ind)=$lb("TOP","值域列表","open","true","true")
	set ind=ind+1
		
	set rowId=""  for  set rowId=$o(^User.EnsLookUpTableD(rowId))  q:rowId=""  d
	.set tempInfoStr=^User.EnsLookUpTableD(rowId)
	.set lookUpTableCode=$lg(tempInfoStr,2)
	.set lookUpTableDesc=$lg(tempInfoStr,3)
	.set state="open"
	.set isParent="false"
	.set ^CacheTemp(repid,ind)=$lb(rowId,lookUpTableDesc,state,isParent)
	.set ind=ind+1		
	Quit $$$OK
}

ClassMethod GetLookUpTableInfoDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLookUpTableInfoDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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
/// Description：保存对照表信息
/// Table：DHCENSLib.User.LookUpTable
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTable).SaveLookUpTableInfo("")
ClassMethod SaveLookUpTableInfo(Input As %String) As %String
{
	set $zt="Exception"
	set obj=##class(User.EnsLookUpTable).%New()
	set obj.lookUpTableCode=$p(Input,"^",1)
	set obj.lookUpTableDesc=$p(Input,"^",2)
	set obj.lookUpTableRemarks=$p(Input,"^",3)
	set sc=obj.%Save()
	if sc=1 {
		w "{""retvalue"":""0"",""retinfo"":"""_obj.%Id()_"""}"
	}
	else {
		w "{""retvalue"":""-1"",""retinfo"":"""_sc_"""}"
	}
	Quit sc
Exception
	w "{""retvalue"":""-1"",""retinfo"":"""_$ze_"""}"
	Quit ""
}

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：删除对照表信息
/// Table：DHCENSLib.User.LookUpTable
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTable).DeleteLookUpTableInfo("47")
ClassMethod DeleteLookUpTableInfo(Input As %String) As %String
{
	set $zt="Exception"
	set sourceCode="" for  set sourceCode=$o(^User.EnsSouLookUpTDataI("sourceCode",$p(Input,"^",1),sourceCode)) q:sourceCode=""  d
	.set rowId=""
	.set rowId=$o(^User.EnsSouLookUpTDataI("sourceCode",$p(Input,"^",1),sourceCode,""))
	.set sc=##class(User.EnsSouLookUpTData).%DeleteId(rowId)
	set targetCode="" for  set targetCode=$o(^User.EnsTarLookUpTDataI("targetCode",$p(Input,"^",1),targetCode)) q:targetCode=""  d
	.set rowId=""
	.set rowId=$o(^User.EnsTarLookUpTDataI("targetCode",$p(Input,"^",1),targetCode,""))
	.set sc=##class(User.EnsTarLookUpTData).%DeleteId(rowId)
	set sc=##class(User.EnsLookUpTable).%DeleteId($p(Input,"^",1))
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
