Class web.DHCBL.KB.DHCLibExaItm Extends %RegisteredObject
{

/// Description：获取已选检查结果的串
/// Other: w ##class(web.DHCBL.KB.DHCLibExaItm).GetExamDr(69)
ClassMethod GetExamDr(InstId As %String) As %String
{
 s str=""
 if (InstId'=""){
	s EXAIRowId=0
	for
	{
		s EXAIRowId=$o(^DHCLIBEXAI(0,"Inst",InstId,EXAIRowId)) q:EXAIRowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(EXAIRowId),"^",2) //病症Dr
		s ExaCode=$p($g(^DHCEXAMINE(EXAIExamDr)),"^",1) //病症代码 
		s str="<"_ExaCode_">^"_str
	}
 }
 q str
}

/// 查询检查结果已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLibExaItm","GetExamList","129")
Query GetExamList(InstId) As %Query(ROWSPEC = "EXAIRowId,EXAIExamDr,ExaCode,ExaResult")
{
}

ClassMethod GetExamListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'=""){
	s EXAIRowId=0
	for
	{
		s EXAIRowId=$o(^DHCLIBEXAI(0,"Inst",InstId,EXAIRowId)) q:EXAIRowId=""
		s EXAIExamDr=$p(^DHCLIBEXAI(EXAIRowId),"^",2) //检查结果Dr
		s ExaCode=$p($g(^DHCEXAMINE(EXAIExamDr)),"^",1) //代码 
		s ExaResult=$p($g(^DHCEXAMINE(EXAIExamDr)),"^",2) //检查结果
		d OutputRow
	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(EXAIRowId,EXAIExamDr,ExaCode,ExaResult)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetExamListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExamListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExamListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExamListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:根据病症id删除病症
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCLibExaItm).DeleteExamData("121")
ClassMethod DeleteExamData(id As %String) As %String
{
	s return="",myInfo=""
	s sc=##class(User.DHCLibExaItm).%DeleteId(id)
	if $$$ISOK(sc){
		s result="{success:'true',info:'删除成功！'}"
	}
	else{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
