/// 名称: DHCWMR.SSService.HolidaysSrv
/// 描述: 节假日相关服务
/// 编写者：liyi
/// 编写日期: 2014-12-02
Class DHCWMR.SSService.HolidaysSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2014-12-02
/// Description:  节假日数据导入方法
/// Table：       DHCWMR.SSService.Holidays
/// Input：       Data：第一条||第二条||第三条.....||第n条||
/// Return：      成功：>0 , 失败：<0
/// w ##class(DHCWMR.SSService.HolidaysSrv).ImportData("^2014-01-01^H^元旦||^2014-01-26^W^春节调休||^2014-01-31^H^春节||","^","||")
ClassMethod ImportData(aInputStr As %String, aSeparate1 As %String, aSeparate2 As %String) As %String
{
	New (aInputStr,aSeparate1,aSeparate2)
	Set return="导入失败！模板数据不能为空！"
	Quit:(aInputStr="")||(aSeparate1="")||(aSeparate2="") return
	
	Set Count = $l(aInputStr,aSeparate2)-1
	
	Tstart
	
	Set Flag = 1
	For xIndex=1:1:Count {
		Set Data = $p(aInputStr,aSeparate2,xIndex)
		Set:Data="" Flag = 0
		Quit:Flag=0
		Set ret = ##class(DHCWMR.SS.Holidays).Update(Data,aSeparate1)
		Set:ret<0 Flag = 0
	}
	If Flag=0 Trollback
	
	Set:Flag=0 return ="导入失败！请检查数据！"
	Set:Flag=1 return ="导入成功！共"_Count_"条数据！"
	Quit:Flag=0 return
	
	TCommit
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-12-02
/// Description:  计算两个日期之间有多少个假日
/// Table：       DHCWMR.SSService.Holidays
/// Input：       aDateFrom , aDateTo
/// Return：      天数：Days
/// w ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays("2014-09-26","2014-10-11")
ClassMethod CountWorkDays(aDateFrom As %String, aDateTo As %String)
{
	New (aDateFrom,aDateTo)
	Set return = 0
	
	//add by mxp 2018-03-05 调用基础平台节假日统一接口
	Set CountFlag=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetHolidayCount","")
	If CountFlag=1 {
		Set return=##class(DHCWMR.IO.FromHisSrv).CountHolidayDays(aDateFrom,aDateTo)
		Quit return
	}
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateFrom>=aDateTo) return
	
	Set Sum = aDateTo-aDateFrom + 1  //两个日期之间总天数
	
	For tempDate=aDateFrom:1:aDateTo
	{
		Set week = ..CountWeek(tempDate)
		Set:((week=6)||(week=7)) Sum=Sum-1	//减去周六周天
	}
	
	For tempDate=aDateFrom:1:aDateTo
	{
		Set week = ..CountWeek(tempDate)
		if $d(^DHCWMR.SS.HolidaysI("IndexDate",tempDate))
		{
			Set HolidaysId = $o(^DHCWMR.SS.HolidaysI("IndexDate",tempDate,""))
			Quit:HolidaysId=""
			Set HolidaysType = $lg($g(^DHCWMR.SS.HolidaysD(HolidaysId)),4)
			
			Set:(HolidaysType="H")&&((week=1)||(week=2)||(week=3)||(week=4)||(week=5)) Sum = Sum -1
			Set:(HolidaysType="W")&&((week=6)||(week=7)) Sum = Sum + 1
		}
	}
	
	Set return = aDateTo-aDateFrom + 1- Sum
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-12-04
/// Description:  计算某一天是周几
/// Table：       
/// Input：       aDate
/// Return：      1,2,3,4,5,6,7
/// w ##class(DHCWMR.SSService.HolidaysSrv).CountWeek("2014-11-11")
ClassMethod CountWeek(aDate As %String)
{
	New (aDate)
	Set return = ""
	Set:aDate["-" aDate=$zdh(aDate,3)
	Set:aDate["/" aDate=$zdh(aDate,4)
	Quit:aDate="" return
	
	Set return = $zdate(aDate,10)
	Set:return=0 return = 7
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-12-01
/// Description:  查询节假日
/// Table：       DHCWMR.SS.Holidays
/// Input：       aYear：年份,aType：类型
/// Return：      
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.HolidaysSrv","QryHolidays","2014","")
Query QryHolidays(aYear As %String, aType As %String) As %Query(ROWSPEC = "ID:%String,HName:%String,Year:%String,Date:%String,TypeCode:%String,TypeDesc:%String,HAlias:%String,HolidayStr:%String")
{
}

ClassMethod QryHolidaysExecute(ByRef qHandle As %Binary, aYear As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aYear=+aYear
	Quit:$l(aYear)'=4 $$$OK
	Set:aType="A" aType=""
	
	Set aDateFrom=aYear_"-01-01"
	Set aDateFrom=$zdh(aDateFrom,3)
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCWMR.SS.HolidaysI("IndexDate",xDate))
		Quit:xDate=""
		Quit:+$zd(xDate,3)'=aYear
		
		Set xID=0
		For {
			Set xID=$o(^DHCWMR.SS.HolidaysI("IndexDate",xDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCWMR.SS.Holidays).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Name=obj.HName
			Set Date=obj.HDate
			Set Date=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(Date)
			Set Year=obj.HYear
			Set TypeCode=obj.HType
			Continue:(aType'="")&&(aType'=TypeCode)
			Set TypeDesc=$s(TypeCode="H":"节假日",TypeCode="W":"工作日",1:"")
			Set HAlias=obj.HAlias
			
			Set HolidayStr=Year_"年--"_HAlias
			Set Data=$lb(xID,Name,Year,Date,TypeCode,TypeDesc,HAlias,HolidayStr)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHolidaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHolidaysExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHolidaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHolidaysExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
