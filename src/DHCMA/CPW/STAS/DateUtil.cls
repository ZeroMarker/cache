/// 名称: DHCMA.CPW.STAS.DateUtil
/// 描述: 日期工具类
/// 编写者：yk
/// 编写日期: 2021-11-02
Class DHCMA.CPW.STAS.DateUtil Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 返回某日期当月第一天
/// w ##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthFirstDay("2020-10-20")
ClassMethod GetCurMonthFirstDay(aDate As %String, aIsLogical As %String = "0") As %String
{
	New (aDate,aIsLogical)
	Set return=""
	Quit:aDate="" return=""
	
	Set aDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set:aDate["-" return=$p(aDate,"-",1)_"-"_$p(aDate,"-",2)_"-"_"01"
	Set:aDate["/" return="01"_"/"_$p(aDate,"/",2)_"/"_$p(aDate,"/",3)
	
	Set:aIsLogical&&(return["-") return=$zdh(return,3)
	Set:aIsLogical&&(return["/") return=$zdh(return,4)
	Quit return
}

/// 返回某日期当月最后一天
/// w ##class(DHCMA.CPW.STAS.DateUtil).GetCurMonthLastDay("2020-10-20")
ClassMethod GetCurMonthLastDay(aDate As %String, aIsLogical As %String = "0") As %String
{
	New (aDate,aIsLogical)
	Set return=""
	Quit:aDate="" return=""
	
	Set aDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set CurFirstDay=..GetCurMonthFirstDay(aDate,1)
	Set NextFirstDay=..GetCurMonthFirstDay(CurFirstDay+31,1)
	Set return=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(NextFirstDay-1)
	Set:aIsLogical&&(return["-") return=$zdh(return,3)
	Set:aIsLogical&&(return["/") return=$zdh(return,4)
	Quit return
}

/// 返回两个日期是否是相邻月份
/// w ##class(DHCMA.CPW.STAS.DateUtil).IsNearMonth("2020-10-20","2020-12-09")
ClassMethod IsNearMonth(aFromDate As %String, aToDate As %String) As %String
{
	New (aFromDate,aToDate)
	Set return=0
	Quit:(aFromDate="")||(aToDate="") return
	
	Set FromLastDay=..GetCurMonthLastDay(aFromDate,1)
	Set ToFirstDay=..GetCurMonthFirstDay(aToDate,1)
	Set:ToFirstDay=(FromLastDay+1) return=1
	Quit return
}

/// 返回两个月份中间间隔的整月月份
/// w ##class(DHCMA.CPW.STAS.DateUtil).GetIntervalMonthList("2020-10-02","2020-11-09")
ClassMethod GetIntervalMonthList(aFromDate As %String, aToDate As %String) As %Library.List
{
	New (aFromDate,aToDate)
	Set return=""
	Quit:aFromDate=""||aToDate="" return
	
	Set aFromLogicDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToLogicDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	
	Set FromFirstDay=..GetCurMonthFirstDay(aFromDate,1)
	If FromFirstDay'=aFromLogicDate {
		 Set FromLastDay=..GetCurMonthLastDay(aFromDate,1)
		 Set xDate=FromLastDay+1
	}Else{
		 Set xDate=FromFirstDay	
	}
	
	Set ToLastDay = ..GetCurMonthLastDay(aToDate,1)
	If ToLastDay'=aToLogicDate{
		Set ToFirstDay=..GetCurMonthFirstDay(aToDate,1)
	}Else{
		Set ToFirstDay=ToLastDay+1
	}
		
	Set MonthList=""
	while(xDate<ToFirstDay){
		Set MonthList=MonthList_$lb($zdt(xDate,3))
		Set xDate=..GetCurMonthFirstDay(xDate+31,1)
	}
	
	Quit MonthList
}

/// Creator：     ShenC
/// CreatDate：   2021-06-02
/// Description:  加载最近10年
/// Table：       
/// Input:        aYear： 多个医院用"|"连接
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.STAS.DateUtil","QryYear1")
Query QryYear() As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryYearExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//日期
	Set Year=$p($zd(+$h,3),"-",1)

	For xYear=Year:-1:(Year-9){
		Set Data=$lb(xYear,xYear_"年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryYearExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     ShenC
/// CreatDate：   2021-06-02
/// Description:  加载月/季度
/// Table：       
/// Input:        aTypeID： 1:月,2:季度,3:年
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.STAS.DateUtil","QryMonth",1)
Query QryMonth(aTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryMonthExecute(ByRef qHandle As %Binary, aTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if ((aTypeID="")||(aTypeID=1)){
		Set Data=$lb(1,"1月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(2,"2月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(3,"3月")
		Set ^CacheTemp(repid,ind)=Data
   	 	Set ind=ind+1	
    	Set Data=$lb(4,"4月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(5,"5月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(6,"6月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(7,"7月")
		Set ^CacheTemp(repid,ind)=Data
   	 	Set ind=ind+1
   	 	Set Data=$lb(8,"8月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(9,"9月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(10,"10月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb(11,"11月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
   	 	Set Data=$lb(12,"12月")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	if ((aTypeID="")||(aTypeID=2)){
		Set Data=$lb("JD1","一季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD2","二季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD3","三季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
    	Set Data=$lb("JD4","四季度")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
    if ((aTypeID="")||(aTypeID=3)){
		Set Data=$lb("BN1","上半年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
     	Set Data=$lb("BN2","下半年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
     	Set Data=$lb("QN","全年")
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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
