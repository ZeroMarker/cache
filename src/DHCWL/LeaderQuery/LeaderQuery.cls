Class DHCWL.LeaderQuery.LeaderQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator by lhh (add parameter:dept by yw)
/// Desc:根据日期范围获得指标数据，日期范围有的可以根据日期类型计数出来，就不需给出了
/// Input:  kpiId:指标id或code；startDate：统计的开始日期，endDate：统计的截止日期，日期格式自定，年月日直接只要有分隔符就可以，也可以是2012Y,2012Q1,或2012-02；isRealData：0或1代表是否为实时数据
/// 可以根据类型计数范围的有：今天，昨天，上周，上月，去年，当月，当年。（都是基于服务器当前日期来计算的）
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","RegLocOpNums:Loc","2012-10-01","2013-10-01","freeDateChoice",)
/// Others：按照区间,指标,维汇总
/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","16","2012-10-01","2013-11-21","freeDateChoice","C")
/// d ##class(%ResultSet).RunQuery("DHCWL.LeaderQuery.LeaderQuery","QueryMKPIByDate","RegLocOpNums1","2011-09-01","2011-09-30","byMonth","C",100)
Query QueryMKPIByDate(kpi As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", dept) As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMKPIByDateExecute(ByRef qHandle As %Binary, kpi As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", dept) As %Status
{
 n (qHandle, startDate,endDate,choiceType,kpi,isRealData,dept)
 q:startDate="" $$$OK
 q:endDate="" $$$OK
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 d ##class(DHCWL.MKPIService.SetKPIData).ResovleAccessRlue(kpi,isRealData,.resolve) //firstly resolve the param
 i $g(endDate)="" s endDate=$g(startDate)
 s monthId=##class(DHCWL.MKPIService.DateUtil).GetMonthIdByName($g(startDate)_":"_$g(endDate),":",$g(choiceType)) ;实际日期转换成连续的MonthId
 q:monthId="" $$$OK
 k ^TEMPDHCWLKPIDATA("G",$j)
 s st=##class(DHCWL.MKPIService.SetKPIData).GetMutiMonKPIData(monthId,kpi,isRealData)
 s monId="" f  s monId=$o(^TEMPDHCWLKPIDATA("G",$j,monId)) q:monId=""  d
 .s kpiId="" f  s kpiId=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId)) q:kpiId=""  d
 ..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiId),2),kpiDes=$lg(^DHCWL.MKPI.MKPID(kpiId),3)
 ..i monId=0 s monDesc="",monCode=""
 ..e  s monDesc=$li(^DHCWL.MKPI.MonthsD(monId),3),monCode=$li(^DHCWL.MKPI.MonthsD(monId),5)
 ..s dimList="" f  s dimList=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimList)) q:dimList=""  d
 ...s dimDep=$P(dimList,",",1)
 ...q:(dept'="")&&(dept'=dimDep)
 ...s value=^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimList),pos=$o(^TEMPDHCWLKPIDATA("G",$j,monId,kpiId,dimList,""))
 ...s resolvedDimList=##class(DHCWL.MKPIService.SetKPIData).ResolveDim(kpiId,pos,.resolve,dimList,.proValueArr)  //add from 3.0
 ...s testTotal=$g(testTotal)+value
 ...//resolved dimValue combo
 ...i $d(proValueArr("OK"))'=0 d
 ....s deliInd="" f  s deliInd=$o(proValueArr("OK",deliInd)) q:deliInd=""  d
 .....s order="" f  s order=$o(proValueArr("OK",deliInd,order)) q:order=""  d
 ......s $p(resolvedDimList,",",order)=proValueArr("OK",deliInd,order)
 .....d outputRowBD2
 ...e  d outputRowBD2
 k ^TEMPDHCWLKPIDATA("G",$j)
 ;w "@testTotal=============="_testTotal,!
 ;b ;y
 Quit $$$OK
outputRowBD2
 s row=$listbuild(monId,monDesc,kpiId,kpiCode,kpiDes,dimList,resolvedDimList,value)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryMKPIByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	;q ..QueryKPIDataByMultiDateClose(qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMKPIByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	;q ..QueryKPIDataByMultiDateFetch(qHandle,Row,AtEnd)
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
