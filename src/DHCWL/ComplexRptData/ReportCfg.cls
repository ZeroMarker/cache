Import SQLUser

Class DHCWL.ComplexRptData.ReportCfg Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 根据报表定义Code查询报表的配置的统计内容
/// d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.ReportCfg","RptContentQuery","CWK","Content")
Query RptContentQuery(rptCode As %String, CondType As %String) As %Query(ROWSPEC = "statCode:%String,statDesc:%String,statType:%String") [ SqlProc ]
{
}

ClassMethod RptContentQueryExecute(ByRef qHandle As %Binary, rptCode As %String, CondType As %String) As %Status
{
	n (qHandle,rptCode,CondType)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:CondType="" $$$OK
	
	q:'$d(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"))) $$$OK
	s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"),""))
 	s rptCfgId=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
 	q:rptCfgId="" $$$OK
 	
 	i "Content"=CondType d
 	.s contentStr=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),4)
 	.f i=1:1:$l(contentStr,",") d
 	..s code=$P(contentStr,",",i)
 	..s contentId=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(code,"U"),""))
 	..s conDesc=$lg(^DHCWL.ComplexRpt.StatItemD(contentId),3)
 	..s ^CacheTemp(repid,ind)=$lb(code,conDesc,"Content")
	..s ind=ind+1
	e  i "Mode"=CondType d
 	.s contentStr=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),4)
 	.f i=1:1:$l(contentStr,",") d
 	..s code=$P(contentStr,",",i)
 	..s contentId=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(code,"U"),""))
 	..s conDesc=$lg(^DHCWL.ComplexRpt.StatItemD(contentId),3)
 	..s ^CacheTemp(repid,ind)=$lb(code,conDesc,"Content")
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod RptContentQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RptContentQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod RptContentQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RptContentQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据报表定义Code查询报表的配置条件等
/// d rs.%Print()查看值
/// d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.ReportCfg","RptCfgQuery","CWK08","Row")
Query RptCfgQuery(rptCode As %String, CondType As %String) As %Query(ROWSPEC = "statItemCode:%String,statItemDesc:%String,statItemType:%String") [ SqlProc ]
{
}

ClassMethod RptCfgQueryExecute(ByRef qHandle As %Binary, rptCode As %String, CondType As %String) As %Status
{
	n (qHandle,rptCode,CondType)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:CondType="" $$$OK
	
	s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"),""))
 	s rptCfgId=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
 	q:rptCfgId="" $$$OK
 	
 	s rowColStr=""
 	i "Row"=CondType s rowColStr=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),5)
 	e  i "Col"=CondType s rowColStr=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),6)
 	f i=1:1:$l(rowColStr,",") d
 	.s code=$P(rowColStr,",",i)
 	.s statCode=$P(code,".",1)
 	.s dimProCode=$P(code,".",2)
 	.q:dimProCode=""
 	.;s dimDr=##class(DHCWL.ComplexRptData.SaveData).GetDimByStatCode(statCode) ;维度ID
 	.s statId=##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode(statCode) ;统计项ID
 	.q:statId=""
 	.;s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),3) ;维度描述
 	.s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3) ;统计项描述
	.s dimProID=##class(DHCWL.ComplexRptData.SaveData).GetDimProByStatCode(statCode,dimProCode)
	.q:dimProID=""
	.s dimProDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
	.i dimProCode [ "(" d
	..s desc=##class(DHCWL.ComplexRptData.SaveData).GetDimProDesc(dimProCode)
	..s descStr=statDesc_"."_dimProDesc_"("_desc_")"
	.e  s descStr=statDesc_"."_dimProDesc
 	.s ^CacheTemp(repid,ind)=$lb(code,descStr,CondType)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod RptCfgQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RptCfgQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod RptCfgQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RptCfgQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据统计项的Code、维度属性code遍历所有维度属性值
/// d ##class(%ResultSet).RunQuery("DHCWL.ComplexRptData.ReportCfg","GetDimProValue","PatLoc","ItemSubGrpDesc(IPLoc)")
Query GetDimProValue(statCode As %String, dimProCode As %String, filterStr As %String = "") As %Query(ROWSPEC = "dimCode:%String,dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetDimProValueExecute(ByRef qHandle As %Binary, statCode As %String, dimProCode As %String, filterStr As %String = "") As %Status
{
	n (qHandle,statCode,dimProCode,filterStr)
 	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
    
	q:(statCode="")!(dimProCode="") $$$OK
	s dim=+##class(DHCWL.ComplexRptData.SaveData).GetDimByStatCode(statCode)
	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dim),2)
	q:dimCode="" $$$OK
	if dimProCode="ItemGrp" {
		s rs=##class(%ResultSet).%New("DHCWL.CodeCfgData.FunctionModule:GetGrpListByDimCode")
		s sc=rs.Execute(dimCode,"G")
		While rs.Next(.sc){
			s dimType=dimCode
			s dimIDV=$g(rs.Data("Code")) 
			s dimProV=$g(rs.Data("Desc"))
			continue:(dimProV'[filterStr)
			d OutPutRow
		}
	}else{
		s dimCodeStr=dimCode_":"_dimProCode
		s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
		s sc=rs.Execute(dimCodeStr)
		While rs.Next(.sc){
			s dimType=$g(rs.Data("dimType"))
			s dimIDV=$g(rs.Data("dimIDV")) 
			s dimProV=$g(rs.Data("dimProV"))
			continue:(dimProV'[filterStr)
			d OutPutRow
		}
	}
	;d rs.Close()
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutRow
	s Data=$lb(dimType,dimIDV,dimProV)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod GetDimProValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDimProValueExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDimProValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDimProValueExecute ]
{
	n (AtEnd,qHandle,Row)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
