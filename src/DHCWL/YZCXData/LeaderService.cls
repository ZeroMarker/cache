Class DHCWL.YZCXData.LeaderService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator?      yw
/// CreatDate?    2015-05 edit by czx in 2017-01-24
/// description:  查询院长查询在院人数(yesterday,lastWeek,lastMonth,lastQua,lastyear,freeDateChoice)
///               (当日期为昨天、上周、上月、上季、自由日期时, 需要取不同时间段的最后一天在院人数,固定床位数)
/// Table?        DHCWL_MKPI.DHCWLMKPI:指标表
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       
/// d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.LeaderService","QueryMKPIByDate","KLQ0008,KLQ0011","2017-01-24","2017-01-24","lastWeek","")
Query QueryMKPIByDate(kpi2 As %Text, startDate As %String, endDate As %String, choiceType = "freeDateChoice", isRealData = "", filterRule As %Text = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryMKPIByDateExecute(ByRef qHandle As %Binary, kpi2 As %Text, startDate As %String, endDate As %String, choiceType = "freeDateChoice", isRealData = "", filterRule As %Text = "") As %Status
{
	n (qHandle,kpi2,startDate,endDate,choiceType,isRealData,filterRule)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
	s initStartDate=startDate
	
    s kipLen=$l(kpi2,",")
    f i=1:1:kipLen { 
    	s kpiDet=$P(kpi2,",",i)
        ;i kpiDet="KLQ0011" b ;999
    	i (kpiDet="KLQ0008")||(kpiDet="KLQ0011") {
    		s dateStr=startDate_":"_endDate
			s retDate=##class(DHCWL.MKPIService.DateUtil).GetScopeByMonthName(dateStr,,choiceType)
			s startDate=$p(retDate,":",1)
			s endDate=$p(retDate,":",2)
			s startDate=endDate
	    }
	    /*
	    i (kpiDet'="KLQ0008")&&(choiceType'="freeDateChoice") {
    		s dateStr=startDate_":"_endDate
			s retDate=##class(DHCWL.MKPIService.DateUtil).GetScopeByMonthName(dateStr,,choiceType)
			s startDate=$p(retDate,":",1)
			s endDate=$p(retDate,":",2)
	    }
	    */

	    ;w "kpiDet="_kpiDet_"^"_startDate_"^"_endDate,!
	    s choiceType="freeDateChoice"
		set rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
		set sc=rs.Execute(kpiDet,startDate,endDate,choiceType,isRealData,filterRule)
		While rs.Next(.sc) { 
	    	s monId=$g(rs.Data("monId"))
	    	s monDesc=$g(rs.Data("monDesc"))	    
	    	s kpiId=$g(rs.Data("kpiId"))
	    	s kpiCode=$g(rs.Data("kpiCode"))
	    	s kpiDesc=$g(rs.Data("kpiDesc"))
	    	s dimId=$g(rs.Data("dimId"))
	    	s dimDesc=$g(rs.Data("dimDesc"))
	    	s value=$g(rs.Data("value"))
	    	d OutputRow2 
    	}
    	;s startDate=initStartDate
      
    }
	Quit $$$OK
	
	
OutputRow2
    s data=$lb(monId,monDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,value)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryMKPIByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryMKPIByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMKPIByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
