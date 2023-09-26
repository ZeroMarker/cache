Class DtPortal.TEST Extends %Persistent
{

//MD16.01.04查询本月二次手术主诊组人数

//d ##class(%ResultSet).RunQuery("DtPortal.MD.MD16TwiceOpration","MainDocData","2016-06-16","2016-06-16","276")

Query MainDocData(startDate As %String, endDate As %String, LocId As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As DtPortal.Query(ROWSPEC = "DocGroupDesc,num") [ SqlProc ]
{
}

ClassMethod MainDocDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, LocId As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "") As %Status
{
	n (qHandle,startDate,endDate,LocId,dateType,kpiRule,filterRule,mode,contract)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	set Count=0
	 k ^TEMPDHCWL($j)
	;s startDate="2014-09-01"
	;s startDate=$zd($p($h,",",1),3)
	s endDate=startDate
    s mode="R"
	s dateType="byMonth"
	s kpiRule="KPSCQ016"
	s filterRule="KPSCQ016:({loc}="_LocId_")"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s LOCID=rs.Data("dimIdCol1")
		s DocID=rs.Data("dimIdCol2")
		;b ;11
        s ^TEMPDHCWL($j,"OpDocNum",DocID)=$g(^TEMPDHCWL($j,"OpDocNum",DocID))+rs.Data("kpiValueCol1")
	}
	S DocID=""
	  f  s DocID=$o(^TEMPDHCWL($j,"OpDocNum",DocID)) q:DocID=""  d
	  .s docidn=$tr($p($g(^CTPCP(DocID,1)),"^",1),"-","")
	  .s DocGroupStr=##class(DtPortal.MD.MD17Deaths).GetMUDocHead(docidn)
      .s DocGroupID=$p(DocGroupStr,"^",1)
      .s DocGroupDesc=$p(DocGroupStr,"^",2)
      .s num=$g(^TEMPDHCWL($j,"OpDocNum",DocID))
      
	.s ^||CacheTemp(repid,ind)=$lb(DocGroupDesc,num)
 	.s ind=ind+1
 	 k ^TEMPDHCWL($j)
	Quit $$$OK
}

Storage Default
{
<Data name="TESTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DtPortal.TESTD</DataLocation>
<DefaultData>TESTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DtPortal.TESTD</IdLocation>
<IndexLocation>^DtPortal.TESTI</IndexLocation>
<StreamLocation>^DtPortal.TESTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
