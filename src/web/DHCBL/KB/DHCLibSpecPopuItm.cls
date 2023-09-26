Class web.DHCBL.KB.DHCLibSpecPopuItm Extends %RegisteredObject
{

/// Description：获取用法用量中已选特殊人群的串
/// Other: w ##class(web.DHCBL.KB.DHCLibSpecPopuItm).GetPopuDr(65)
ClassMethod GetPopuDr(InstId As %String) As %String
{
 s str=""
 if (InstId'=""){
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",InstId,SPEPIRowId)) q:SPEPIRowId=""
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2) //特殊人群Dr
		s:SPEPISpecDr'="" SPECode=$p($g(^DHCSPEP(SPEPISpecDr)),"^",1) //特殊人群代码 
		s:SPEPISpecDr="" SPECode=""
		s str="<"_SPECode_">^"_str
	}
 }
 q str
}

/// 查询用法用量中特殊人群已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLibSpecPopuItm","GetPopuList","37")
Query GetPopuList(InstId) As %Query(ROWSPEC = "SPEPIRowId,SPEPISpecDr,SPECode,SPEDesc")
{
}

ClassMethod GetPopuListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'=""){
	s SPEPIRowId=0
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",InstId,SPEPIRowId)) q:SPEPIRowId=""
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)  //特殊人群Dr 		
		s:SPEPISpecDr'="" SPECode=$p($g(^DHCSPEP(SPEPISpecDr)),"^",1) //特殊人群代码 
		s:SPEPISpecDr'="" SPEDesc=$p($g(^DHCSPEP(SPEPISpecDr)),"^",2) //特殊人群描述
		s:SPEPISpecDr="" SPECode=""
		s:SPEPISpecDr="" SPEDesc=""
		if (SPEPISpecDr'="")
		{
			d OutputRow
		}
	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SPEPIRowId,SPEPISpecDr,SPECode,SPEDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPopuListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPopuListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPopuListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPopuListExecute ]
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

/// Description:根据特殊人群id删除特殊人群
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCLibSpecPopuItm).DeletePopuData("121")
ClassMethod DeletePopuData(id As %String) As %String
{
	s result=""
	if (id'=""){
		s sc=##class(User.DHCLibSpecPopuItm).%DeleteId(id)
		if $$$ISOK(sc){
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'没有选中行'}"  //返回错误信息
	}
	q result
}

}
