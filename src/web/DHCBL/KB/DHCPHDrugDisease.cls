Class web.DHCBL.KB.DHCPHDrugDisease Extends %RegisteredObject
{

/// Description：获取用法用量中已选病症的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDrugDisease).GetDiseaDr(68)
ClassMethod GetDiseaDr(InstId As %String) As %String
{
 s str=""
 if (InstId'=""){
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",InstId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3) //病症Dr
		s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",1) //病症代码 
		s str="<"_PHDISLDiseaCode_">^"_str
	}
 }
 q str
}

/// 查询用法用量中病症已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugDisease","GetDiseaList","37")
Query GetDiseaList(InstId) As %Query(ROWSPEC = "PHDDRowId,PHDDDiseaDr,PHDISLDiseaCode,PHDISLDiseaDesc")
{
}

ClassMethod GetDiseaListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'=""){
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",InstId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)  //病症Dr 
		s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",1) //病症代码 
		s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2) //病症描述
		
		d OutputRow
	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHDDRowId,PHDDDiseaDr,PHDISLDiseaCode,PHDISLDiseaDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseaListExecute ]
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
/// Other:d ##class(web.DHCBL.KB.DHCPHDrugDisease).DeleteDiseaData("121")
ClassMethod DeleteDiseaData(id As %String) As %String
{
	s result=""
	if (id'=""){
		s sc=##class(User.DHCPHDrugDisease).%DeleteId(id)
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
