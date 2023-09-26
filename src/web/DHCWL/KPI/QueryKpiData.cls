Class web.DHCWL.KPI.QueryKpiData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate","RegLocOpNums:Loc","2012-10-21","2012-10-21","freeDateChoice","R")
/// d ##class(%ResultSet).RunQuery("web.DHCWL.KPI.QueryKpiData","RealHisKpiQuery","16","2012-11-01","2012-11-01","freeDateChoice",,"MZDocGhf:([[{RegLoc.Loc}\[ 内科]&&[{RegLoc.Loc}\[西院]&&[{RegLoc.Loc}FirstLike特需]&&![{RegLoc.Loc}\[免疫]]||[[{RegLoc.Loc}\[ 内科]&&[{RegLoc.Loc}\[西院]&&[{RegLoc.Loc}FirstLike普通]])")
Query RealHisKpiQuery(kpi As %Text, startDate, endDate, choiceType = "freeDateChoice", isRealData = "", filterRule = "") As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDesc:%String,dimId:%String,dimDesc:%String,realValue:%Float,hisValue:%Float") [ SqlProc ]
{
}

ClassMethod RealHisKpiQueryExecute(ByRef qHandle As %Binary, kpi As %Text, startDate, endDate, choiceType = "", isRealData = "", contractType, filterRule = "") As %Status
{
	n (qHandle,kpi,startDate,endDate,choiceType,isRealData,contractType,filterRule)
	k ^temp($j)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	;w "filterRule="_filterRule,!
	s realRs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract",kpi,startDate,endDate,choiceType,isRealData_"R",contractType,filterRule)
	s hisRs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:NewQueryKpiWithContract",kpi,startDate,endDate,choiceType,isRealData,contractType,filterRule)
	While realRs.Next(.sc) {
		s ^temp($j,realRs.Data("monthId"))=realRs.Data("monDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"))=realRs.Data("kpiCode")_"||"_realRs.Data("kpiDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"))=realRs.Data("dimDesc")
		s ^temp($j,realRs.Data("monthId"),realRs.Data("kpiId"),realRs.Data("dimId"),"REAL")=realRs.Data("value")
	}
	While hisRs.Next(.sc) {
		s ^temp($j,hisRs.Data("monthId"))=hisRs.Data("monDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"))=hisRs.Data("kpiCode")_"||"_hisRs.Data("kpiDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"),hisRs.Data("dimId"))=hisRs.Data("dimDesc")
		s ^temp($j,hisRs.Data("monthId"),hisRs.Data("kpiId"),hisRs.Data("dimId"),"HIS")=hisRs.Data("value")
	}
	s monId="" f  s monId=$o(^temp($j,monId)) q:monId=""  d
	.s kpiId="" f  s kpiId=$o(^temp($j,monId,kpiId)) q:kpiId=""  d
	..s dim="" f  s dim=$o(^temp($j,monId,kpiId,dim)) q:dim=""  d
	...s rv=0,hv=0
	...i $d(^temp($j,monId,kpiId,dim,"REAL")) s rv=^temp($j,monId,kpiId,dim,"REAL")
	...i $d(^temp($j,monId,kpiId,dim,"HIS")) s hv=^temp($j,monId,kpiId,dim,"HIS")
	...s dataList=$lb(monId,^temp($j,monId),kpiId,$p(^temp($j,monId,kpiId),"||",1),$p(^temp($j,monId,kpiId),"||",2),dim,^temp($j,monId,kpiId,dim),rv,hv)
	...s ^CacheTemp(repid,ind)=dataList
 	...s ind=ind+1
	Quit $$$OK
}

ClassMethod RealHisKpiQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RealHisKpiQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^temp($j)
	Quit $$$OK
}

ClassMethod RealHisKpiQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RealHisKpiQueryExecute ]
{
	n (qHandle,Row,AtEnd)
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
