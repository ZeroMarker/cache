Class web.DHCANOPChart Extends %RegisteredObject
{

/// 获取时间线图表显示数据
/// d ##class(%ResultSet).RunQuery("web.DHCANOPChart","GetTimeLineChartData",10,"","2015-03-01~2015-03-20^2015-03-21~2015-03-31^2015-03-01~2013-03-31")
Query GetTimeLineChartData(anciId As %String, displayParaStr As %String = "", dateListStr As %String = "") As %Query(ROWSPEC = "code,desc,uom,data")
{
}

ClassMethod GetTimeLineChartDataExecute(ByRef qHandle As %Binary, anciId As %String, displayParaStr As %String = "", dateListStr As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANInquiry("TimeLine",anciId,"Para")) $$$OK
    k OtherDataList
    s OtherDataList("ANDoctor")=$g(^DHCANInquiry("CtpcpCount","ANDoctor"))
    s decimalDigits=2
    
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    k searchList,displayList,CalculateDataList,summaryTypeList
    k ^DHCANInquiry("ChartQuery","Date")
    
    d SetDisplayLevelList
    d SetSearchLevelList
    
    s firstDisplayLevel=$o(displayList(""))
    
    i displayParaStr="" s displayParaStr=$o(^DHCANInquiry("TimeLine",anciId,"Para",""))
    k chartDataList
    
    f i=1:1:$l(dateListStr,"^") d
    .s dateStr=$p(dateListStr,"^",i)
    .s ^DHCANInquiry("ChartQuery","Date",i)=dateStr
    .s dateStr=$p(dateStr,"|",1)
    .s startDate=$p(dateStr,"~",1)
    .s endDate=$p(dateStr,"~",2)
    .s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
    .s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
    .s opaInfo="",opaInfoCount=0
    .f  s opaInfo=$o(^DHCANInquiry("TimeLine",anciId,"Para",displayParaStr,opaInfo)) q:opaInfo=""  d
    ..s opaInfoCount=opaInfoCount+1
    ..s searchLevel=""
    ..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ...s levelUom="",sumType=searchList(searchLevel,"SumType")
    ...i sumType="" s sumType="OPACount"
    ...f date=startDate:1:endDate d
    ....i levelUom="" s levelUom=$o(^DHCANInquiry("TimeLine",anciId,"Data",date,opaInfo,searchLevel,"SumType",sumType,"Uom",""))
    ....s statValue=0
    ....i levelUom'="" s statValue=$g(^DHCANInquiry("TimeLine",anciId,"Data",date,opaInfo,searchLevel,"SumType",sumType,"Uom",levelUom))
    ....s chartDataList(searchLevel,opaInfoCount,i)=$g(chartDataList(searchLevel,opaInfoCount,i))+statValue
    ...s chartDataList(searchLevel,opaInfoCount,i)=+$g(chartDataList(searchLevel,opaInfoCount,i))
    ...s CalculateDataList("SumType","Default","Level",searchLevel)=+$g(chartDataList(searchLevel,opaInfoCount,i))
    ...s CalculateDataList("SumType",sumType,"Level",searchLevel)=+$g(chartDataList(searchLevel,opaInfoCount,i))
    ...s chartDataList(searchLevel)=$s(levelUom'="-":levelUom,1:"")
    ..d SetCalculateValue
    
    s i=0
    f  s i=$o(chartDataList(i)) q:i=""  d
    .s j=0
    .s dataStr=""
    .f  s j=$o(chartDataList(i,j)) q:j=""  d
    ..s m="",timedataStr=""
    ..f  s m=$o(chartDataList(i,j,m)) q:m=""  d
    ...i timedataStr'="" s timedataStr=timedataStr_","
    ...s timedataStr=timedataStr_+$g(chartDataList(i,j,m))
    ..i dataStr'="" s dataStr=dataStr_","
    ..s dataStr=dataStr_"["_timedataStr_"]"
    .s dataStr="["_dataStr_"]"
    .s code=i
    .s desc=searchList(i,"Desc")
    .s uom=chartDataList(i)
    .d OutputRowTimeLineData
    .s ifFirst=0
    
    s qHandle=$lb(0,repid,0)
    q $$$OK
    
SetDisplayLevelList()
	s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .i (anciiIsSearch&&anciiIsDisplay)  d
    ..s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    ..s anciiRefValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),19)
    ..i anciiRefValue'="" d
    ...s summaryTypeList("CalculateExpression",searchLevel)=anciiRefValue,summaryTypeList("LevelSub",searchLevel,anciiSub)=""
    ...i anciiSummaryType'="" d
    ....f i=1:1:$l(anciiSummaryType,",") d
    .....s summaryType=$p(anciiSummaryType,",",i)
    .....s summaryTypeList(searchLevel,summaryType)=""
    .....s summaryTypeList("CalculateExpression",searchLevel,summaryType)=""
    .e  i anciiIsDisplay  d
    ..s displayList(searchLevel)=$g(displayList(searchLevel))+1
    ..s displayList(searchLevel,anciiSub)=anciiDesc
    q
    
SetSearchLevelList()
	i +$o(^DHCANInquiry(anciId,"AllPath",""))>0 d
    .s anciiSub=""
    .f  s anciiSub=$o(^DHCANInquiry(anciId,"AllPath",anciiSub)) q:anciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    ..s searchList(searchLevel,"Code")="S-"_searchLevel
    ..s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ..s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    ..s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    ..s searchList(searchLevel,"Desc")=$s(anciiNote'="":anciiNote,1:anciiDesc)
    ..s searchList(searchLevel,"SumType")=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    q
    
SetCalculateValue()
	s searchLevel=""
    f  s searchLevel=$o(summaryTypeList("CalculateExpression",searchLevel)) q:searchLevel=""  d
    .s anciiSub=+$o(summaryTypeList("LevelSub",searchLevel,""))
    .s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    .s sumType=searchList(searchLevel,"SumType")
    .k expArgList
    .i sumType="" d
    ..i $g(summaryTypeList("CalculateExpression",searchLevel))'="" d
    ...m expArgList=CalculateDataList("SumType","Default","Level")
    .e  d
    ..m expArgList=CalculateDataList("SumType",sumType,"Level")
    .q:'$d(expArgList)
    .s listsearchLevel=""
    .f  s listsearchLevel=$o(searchList(listsearchLevel)) q:listsearchLevel=""  d
    ..i '$d(expArgList(listsearchLevel)) s expArgList(listsearchLevel)=0
    ..m expArgList=OtherDataList
    .
    .s singleSumUomCount=##class(web.DHCANOPStat).CalculateExpression(summaryTypeList("CalculateExpression",searchLevel),.expArgList)
    .i anciiDataField="Percentage" s singleSumUomCount=singleSumUomCount*100,sumUom="%"
    .e  i anciiDataField="Permillage" s singleSumUomCount=singleSumUomCount*1000,sumUom="‰"
    .s singleSumUomCount=$num(singleSumUomCount,decimalDigits)
    .
    .s chartDataList(searchLevel,opaInfoCount,i)=singleSumUomCount
    q

OutputRowTimeLineData
    s Data=$lb(code,desc,uom,dataStr)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetTimeLineChartDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimeLineChartDataExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetTimeLineChartDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimeLineChartDataExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取时间线图表日期序列
/// d ##class(%ResultSet).RunQuery("web.DHCANOPChart","GetChartDateList")
Query GetChartDateList() As %Query(ROWSPEC = "desc,duration")
{
}

ClassMethod GetChartDateListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    s dateitemId=""
    f  s dateitemId=$o(^DHCANInquiry("ChartQuery","Date",dateitemId)) q:dateitemId=""  d
    .s desc=$p(^DHCANInquiry("ChartQuery","Date",dateitemId),"|",2)
    .s duration=$p(^DHCANInquiry("ChartQuery","Date",dateitemId),"|",1)
    .d OutputRowChartDate
    
    q $$$OK
OutputRowChartDate
    s Data=$lb(desc,duration)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetChartDateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartDateListExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetChartDateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartDateListExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

}
