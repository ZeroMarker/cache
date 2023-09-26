/// 名称: CT.IPMR.BTS.HolidaysSrv
/// 描述: 节假日相关服务
/// 创建者：whui
/// 创建日期: 2019-10-16
Class CT.IPMR.BTS.HolidaysSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     whui
/// CreatDate：   2019-10-16
/// Description:  查询所有待选日期
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aDateFrom：开始日期,aDateTo：结束日期
/// 				  onlyweekendflag: 仅周末标志
/// Return：      
/// do ##class(%Library.ResultSet).RunQuery("CT.IPMR.BTS.HolidaysSrv","QryAllDays","2019-01-01","2019-12-31","")
Query QryAllDays(aDateFrom As %String, aDateTo As %String, onlyweekendflag As %String = "") As %Query(ROWSPEC = "myDate:%String,whatDay:%String,Weekendflag:%String")
{
}

ClassMethod QryAllDaysExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, onlyweekendflag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Quit:aDateFrom>aDateTo $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=xDate+1
		Quit:xDate>aDateTo
		// 过滤节假日
		Continue:$d(^CT.IPMR.BT.HolidaysI("IndexDateType","H",xDate))>0
		Continue:$d(^CT.IPMR.BT.HolidaysI("IndexDateType","WEND",xDate))>0
		
		Set tmpDate=$zd(xDate,12)
		If (tmpDate="Saturday")||(tmpDate="Sunday"){
			Set Weekendflag="Y"
		}Else{
			Set Weekendflag="N"
		}
		Continue:(onlyweekendflag="Y")&&(Weekendflag'="Y")
		
		Set myDate	= ##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(xDate)
		Set whatDay	= $zd(xDate,11)
		Set:whatDay="Mon" whatDay="星期一"
		Set:whatDay="Tue" whatDay="星期二"
		Set:whatDay="Wed" whatDay="星期三"
		Set:whatDay="Thu" whatDay="星期四"
		Set:whatDay="Fri" whatDay="星期五"
		Set:whatDay="Sat" whatDay="星期六"
		Set:whatDay="Sun" whatDay="星期日"
		Set Data=$lb(myDate,whatDay,Weekendflag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAllDaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAllDaysExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAllDaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAllDaysExecute ]
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

/// Creator：     whui
/// CreatDate：   2019-10-16
/// Description:  查询节|假日
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aDateFrom：开始日期,aDateTo：结束日期	
/// 				  aType: 日期类型(H节日,WEND假日)
/// Return：      
/// do ##class(%Library.ResultSet).RunQuery("CT.IPMR.BTS.HolidaysSrv","QryHWend","2019-01-01","2019-12-31","H")
Query QryHWend(aDateFrom As %String, aDateTo As %String, aType As %String) As %Query(ROWSPEC = "ID:%String,Year:%String,Date:%String,Type:%String,Name:%String,Alias:%String,whatDay:%String")
{
}

ClassMethod QryHWendExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="")||(aType="") $$$OK
	Quit:aDateFrom>aDateTo $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^CT.IPMR.BT.HolidaysI("IndexDateType",aType,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xID = $o(^CT.IPMR.BT.HolidaysI("IndexDateType",aType,xDate,""))
		Set objHoliday = ##class(CT.IPMR.BT.Holidays).GetObjById(xID)
		Continue:'$IsObject(objHoliday)
		
		Set Year	= objHoliday.BHYear
		Set Date	= objHoliday.BHDate
		Set Type	= objHoliday.BHType
		Set Name	= objHoliday.BHName
		Set Alias	= objHoliday.BHAlias
		Set whatDay	= $zd(Date,11)
		Set:whatDay="Mon" whatDay="星期一"
		Set:whatDay="Tue" whatDay="星期二"
		Set:whatDay="Wed" whatDay="星期三"
		Set:whatDay="Thu" whatDay="星期四"
		Set:whatDay="Fri" whatDay="星期五"
		Set:whatDay="Sat" whatDay="星期六"
		Set:whatDay="Sun" whatDay="星期日"
		Set Date	= ##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(Date)
		Set Data=$lb(xID,Year,Date,Type,Name,Alias,whatDay)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHWendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHWendExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHWendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHWendExecute ]
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

/// Creator：     whui
/// CreatDate：   2019-10-21
/// Description:  初始化本年节|假日(当前,将所有周六,日(除去节日)添加到假日)
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aYear：年份
/// Return：      
/// w ##class(CT.IPMR.BTS.HolidaysSrv).InitDate()
ClassMethod InitDate(aYear As %String = "")
{
	New (aYear)	
	Set return=""
	Set:aYear="" aYear=+$zd(+$h,3)
	
	Set DateFrom	= aYear_"-01-01"
	Set DateTo		= aYear_"-12-31"
	Set DateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(DateFrom)
	Set DateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(DateTo)
	
	Set xDate = DateFrom-1
	For{
		Set xDate = xDate+1
		Quit:xDate>DateTo
		
		// 过滤节假日
		Continue:$d(^CT.IPMR.BT.HolidaysI("IndexDateType","H",xDate))>0
		Continue:$d(^CT.IPMR.BT.HolidaysI("IndexDateType","WEND",xDate))>0
		
		Set whatDay	= $zd(xDate,11)
		Continue:(whatDay'="Sat")&&(whatDay'="Sun")
		Set:whatDay="Sat" whatDay="星期六"
		Set:whatDay="Sun" whatDay="星期日"
		
		Set Id		= ""
		Set Name	= whatDay
		Set Date	= xDate
		Set Type	= "WEND"
		Set Alias	= "周末"
		
		Set InputStr = Id_"^"_Name_"^"_Date_"^"_Type_"^"_Alias
		Set flg = ##class(CT.IPMR.BT.Holidays).Update(InputStr,"^")
		Set return=flg
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-05-19
/// Description:  计算两个日期之间有多少个假日
/// Table：       CT.IPMR.BT.Holidays
/// Input：       aDateFrom , aDateTo
/// Return：      天数：Days
/// w ##class(CT.IPMR.BTS.HolidaysSrv).CountHolidays("2014-09-26","2014-10-11")
ClassMethod CountHolidays(aDateFrom As %String, aDateTo As %String)
{
	New (aDateFrom,aDateTo)
	Set return = 0
	Set CountFlag=##class(CT.IPMR.BT.Config).GetValByCode("GetHolidayCount","")
	If CountFlag=1 {
		Set return=##class(MA.IPMR.ImedicalSrv).CountHolidays(aDateFrom,aDateTo) // 调用基础平台节假日统一接口
		Quit return
	}
	Set aDateFrom = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDateTo)
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
		if $d(^CT.IPMR.BT.HolidaysI("IndexDate",tempDate))
		{
			Set HolidaysId = $o(^CT.IPMR.BT.HolidaysI("IndexDate",tempDate,""))
			Quit:HolidaysId=""
			Set objHolidays = ##class(CT.IPMR.BT.Holidays).GetObjById(HolidaysId)
			Continue:'$isobject(objHolidays)
			Set HolidaysType = objHolidays.BHType
			
			Set:(HolidaysType="H")&&((week=1)||(week=2)||(week=3)||(week=4)||(week=5)) Sum = Sum -1
			Set:(HolidaysType="WEND")&&((week=1)||(week=2)||(week=3)||(week=4)||(week=5)) Sum = Sum -1
			Set:(HolidaysType="W")&&((week=6)||(week=7)) Sum = Sum + 1
		}
	}
	
	Set return = aDateTo-aDateFrom + 1- Sum
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2020-05-19
/// Description:  计算某一天是周几
/// Table：       
/// Input：       aDate
/// Return：      1,2,3,4,5,6,7
/// w ##class(DHCWMR.SSService.HolidaysSrv).CountWeek("2014-11-11")
ClassMethod CountWeek(aDate As %String)
{
	New (aDate)
	Set return = ""
	Set aDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aDate)
	Quit:aDate="" return
	
	Set return = $zdate(aDate,10)
	Set:return=0 return = 7
	
	Quit return
}

}
