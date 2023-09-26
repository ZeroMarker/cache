Class web.DHCENS.STBLL.UTIL.EnsLookUpTableData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2014—08-18
/// Description：源数据列表查询
/// Table：User.LookUpTableData
/// Input：为空查询全部
/// Output：返回全部
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.UTIL.EnsLookUpTableData","GetLookUpTableData","1")
Query GetLookUpTableData(Input As %String) As %Query(ROWSPEC = "rowId:%String,sourceCode:%String,sourceDesc:%String,targetCode:%String,targetDesc:%String")
{
}

ClassMethod GetLookUpTableDataExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set QHandle=$lb(0,repid,0)
	set lookUpTableDr=$p(Input,"^",1)
	set dataCode=$p(Input,"^",2)
	set dataDesc=$p(Input,"^",3)         
	set rowId=""  for  set rowId=$o(^User.EnsLookUpTDataI("lookUpTableDr",lookUpTableDr,rowId))  q:rowId=""  d
	.set sourceRowId=$lg(^User.EnsLookUpTDataD(rowId),5)
	.set targetRowId=$lg(^User.EnsLookUpTDataD(rowId),4)
	.Quit:sourceRowId=""
	.set tempStr=$g(^User.EnsSouLookUpTDataD(sourceRowId))
	.set sourceCode=$lg(tempStr,2)
	.Quit:((dataCode'="")&&(sourceCode'[dataCode))
	.set sourceDesc=$lg(tempStr,3)
	.Quit:((dataDesc'="")&&(sourceDesc'[dataDesc))
	.set tempStr=^User.EnsTarLookUpTDataD(targetRowId)
	.set targetCode=$lg(tempStr,2)
	.set targetDesc=$lg(tempStr,3)
	.set ^CacheTemp(repid,ind)=$lb(rowId,sourceCode,sourceDesc,targetCode,targetDesc)
	.set ind=ind+1		
	Quit $$$OK
}

ClassMethod GetLookUpTableDataClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLookUpTableDataFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
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
/// Table：User.LookUpTableData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).SaveLookUpTableDataInfo("9^rr^rr^rr^rr")
ClassMethod SaveLookUpTableDataInfo(Input As %String) As %String
{
	set $zt="Exception"
	ts
	set lookupTableDr=$p(Input,"^",1)
	set sourceCode=$p(Input,"^",2)
	set sourceDesc=$p(Input,"^",3)
	set sourceTableData=lookupTableDr_"^"_sourceCode_"^"_sourceDesc
	set sourceSc=##class(web.DHCENS.STBLL.UTIL.EnsSouLookUpTData).SaveSourceTableDataInfo(sourceTableData)
	if $p(sourceSc,"^",1)'=0 {
		tro
		w "{""retvalue"":""-1"",""retinfo"":"""_sourceSc_"""}"
		Quit ""
	}
	set targetCode=$p(Input,"^",4)
	set targetDesc=$p(Input,"^",5)
	set targetTableData=lookupTableDr_"^"_targetCode_"^"_targetDesc
	b ;3
	set targetSc=##class(web.DHCENS.STBLL.UTIL.EnsTarLookUpTData).SaveTargetTableDataInfo(targetTableData)
	if $p(targetSc,"^",1)'=0 {
		tro
		w "{""retvalue"":""-1"",""retinfo"":"""_targetSc_"""}"
		Quit ""
	}
	set obj=##class(User.EnsLookUpTData).%New()
	set sourceTableDr=##class(User.EnsSouLookUpTData).%OpenId($p(sourceSc,"^",2))
	set targetTableDr=##class(User.EnsTarLookUpTData).%OpenId($p(targetSc,"^",2))
	set lookUpTable=##class(User.EnsLookUpTable).%OpenId(lookupTableDr)
	set obj.sourceTableDr=sourceTableDr
	set obj.targetTableDr=targetTableDr
	set obj.lookUpTableDr=lookUpTable
	set sc=obj.%Save()
	if sc=1 {
		tc
		w "{""retvalue"":""0"",""lookuptabledata"":"""_obj.%Id()_""",""sourceTableDr"":"""_$p(sourceSc,"^",2)_""",""targetTableDr"":"""_$p(targetSc,"^",2)_"""}"
	}
	else {
		tro
		w "{""retvalue"":""-1"",""retinfo"":"""_sc_"""}"
	}
	Quit ""
Exception
	tro
	w "{""retvalue"":""-1"",""retinfo"":"""_$ze_"""}"
	Quit ""
}

/// Creator：WuXianPu
/// CreatDate：2014—08-25
/// Description：取消关联需要对照数据信息
/// Table：User.LookUpTableData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).CanCelRelevanceInfo("")
ClassMethod CanCelRelevanceInfo(Input As %String) As %String
{
	set $zt="Exception"
	set rowId=$p(Input,"^",1)
	set sc=##class(User.EnsLookUpTData).%DeleteId(rowId)
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

/// Creator：WuXianPu
/// CreatDate：2014—08-25
/// Description：关联需要对照数据信息
/// Table：User.LookUpTableData
/// Input：
/// Output：
/// Return：0^成功
/// Others：d ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).RelevanceInfo("13^110^108")
ClassMethod RelevanceInfo(Input As %String) As %String
{
	set $zt="Exception"
	set lookupTableDr=$p(Input,"^",1)
	set sourceRowId=$p(Input,"^",2)
	set targetRowId=$p(Input,"^",3)
	set obj=##class(User.EnsLookUpTData).%New()
	set sourceObj=##class(User.EnsSouLookUpTData).%OpenId(sourceRowId)
	set targetObj=##class(User.EnsTarLookUpTData).%OpenId(targetRowId)
	set lookUpTableObj=##class(User.EnsLookUpTable).%OpenId(lookupTableDr)
	set obj.lookUpTableDr=lookUpTableObj
	set obj.sourceTableDr=sourceObj
	set obj.targetTableDr=targetObj
	set sc=obj.%Save()
	if sc=1 {
		w "{""retvalue"":""0"",""retinfo"":"""_obj.%Id()_"""}"
	}
	else {
		w "{""retvalue"":""-1"",""retinfo"":"""_sc_"""}"
	}
	Quit ""
Exception
	w "{""retvalue"":""-1"",""retinfo"":"""_$ze_"""}"
	Quit ""
}

/// w ##class(web.DHCENS.STBLL.UTIL.EnsLookUpTableData).GetTarCode("主任医师","CT_Job")
ClassMethod GetTarCode(SourceCode As %String, LookUpTable As %String) As %String
{
	set $zt="Exception"
	set tableId=$O(^User.EnsLookUpTableI("lookUpTableCode",LookUpTable,""))
	Quit:tableId="" "0^"_SourceCode
	set souId=$o(^User.EnsSouLookUpTDataI("sourceCode",tableId,SourceCode,"")) 
	Quit:souId="" "0^"_SourceCode
	set tId=$o(^User.EnsLookUpTDataI("sourceTableDr",tableId,souId,""))
	Quit:tId="" "0^"_SourceCode
	set tarId=$lg(^User.EnsLookUpTDataD(tId),4)
	Quit:tarId="" "0^"_SourceCode
	set tarCode=$lg(^User.EnsTarLookUpTDataD(tarId),2)
	Quit "0^"_tarCode
Exception
	Quit "-1^"_$ze
}

}
