Class CIS.AN.COM.DateTime Extends %RegisteredObject
{

ClassMethod ConvertToDateH(dateStr As %String, defaultVal As %String = "$H") As %String [ SqlProc ]
{
    q:((dateStr="")!(dateStr<0))&(defaultVal="") ""
    q:(dateStr="")!(dateStr<0) +$h
    s $zt="ERROR"
    i ($l(dateStr,"/")>2)&(dateStr>1900) s dateStr=$tr(dateStr,"/","-")
    i $l(dateStr,"/")>2 q $zdh(dateStr,4)
    i $l(dateStr,"-")>2 q $zdh(dateStr,3)

    q +dateStr
ERROR   ; 
    q:(defaultVal="") ""
    q +$h
}

ClassMethod ConvertToTimeH(timeStr As %String, defaultVal As %String = "$H") As %String [ SqlProc ]
{
    //q:timeStr="" $p($h,",",2)
    //i $l(timeStr,":")>1 q $zth(timeStr,3)
    //q +timeStr
    q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="") ""
    q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="0") 0
    q:((timeStr="")!(timeStr<0)!(timeStr>86399)) $p($h,",",2)
    i $l(timeStr,":")>1 d
        .s tmpHour=+$p(timeStr,":")
        .s tmpHour=$p(tmpHour,".")
        .q:(tmpHour<0)!(tmpHour>23)
        .s $p(timeStr,":")=tmpHour
        .s tmpMinute=+$p(timeStr,":",2)
        .s tmpMinute=$p(tmpMinute,".")
        .q:(tmpMinute<0)!(tmpMinute>59)
        .s $p(timeStr,":",2)=tmpMinute
        .s tmpSecond=+$p(timeStr,":",3)
        .s tmpSecond=$p(tmpSecond,".")
        .q:(tmpSecond<0)!(tmpSecond>59)
        .
        .s timeStr=$ZTH(tmpHour_":"_tmpMinute_":"_tmpSecond,3)
    q +timeStr
}

ClassMethod ConvertToDate(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
    q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,3)
	set dateValue=$zd(dateVal,3)
    q dateValue
}

ClassMethod ConvertToTime(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    q:(+dateVal=0) $zt(dateVal)
    q:((+dateVal=0)!(dateVal>86399)!(dateVal<0))&(defaultStr="") ""
    q:(+dateVal=0)!(dateVal>86399)!(dateVal<0) $zt($p($h,",",2))
    q $zt(dateVal)
}

ClassMethod ConvertToDateTime(dateVal As %String, timeVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
    quit:(+dateVal<=0)!(timeVal="") ""
    set dateStr=..ConvertToDate(dateVal,defaultStr)
    set timeStr=..ConvertToTime(timeVal, defaultStr)
    set result=dateStr
    if (timeStr'="")
    {
        if (result'="")
        {
            set result=result_" "   
        }   
        set result=result_timeStr
    }
    q result
}

ClassMethod ConvertToDateTimeH(dateTimeStr As %String, defaultStr As %String = "$h") As %String [ SqlProc ]
{
	set dateStr=$p(dateTimeStr," ",1)
	set timeStr=$p(dateTimeStr," ",2)
	set dateH=..ConvertToDateH(dateStr,defaultStr)
	set timeH=..ConvertToTimeH(timeStr,defaultStr)
	quit dateH+(timeH/100000)
}

/// 数值时间比较，source晚于target返回1，小于返回-1，相等返回0
ClassMethod CompareDateTimeS(sourceDT, targetDT) As %String [ SqlProc ]
{
    set sourceDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(sourceDT," ",1),"")
    set sourceTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(sourceDT," ",2),"")
    set targetDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(targetDT," ",1),"")
    set targetTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(targetDT," ",2),"")
    quit ..CompareDateTime(sourceDate, sourceTime, targetDate, targetTime)
}

/// 数值时间比较，source晚于target返回1，小于返回-1，相等返回0
ClassMethod CompareDateTime(sourceDate, sourceTime, targetDate, targetTime) As %String [ SqlProc ]
{
    i sourceTime="" s sourceTime=-1
    i targetTime="" s targetTime=86400
    s sourceDateTime=sourceDate+(sourceTime/100000)
    s targetDateTime=targetDate+(targetTime/100000)
    q:sourceDateTime>targetDateTime 1
    q:sourceDateTime<targetDateTime -1
    q 0
}

/// 时间差计算，返回类型type取日期"D",小时"H",分"M",秒"S"
ClassMethod CalculateDuration(sourceDate, sourceTime, targetDate, targetTime, type = "S") As %String [ SqlProc ]
{
    i sourceTime="" s sourceTime=-1
    i targetTime="" s targetTime=86400
    s durationDay=targetDate-sourceDate
    i targetTime<sourceTime s durationDay=durationDay-1,targetTime=targetTime+86400
    q:type="D" durationDay
    q:type="H" durationDay*24+((targetTime-sourceTime)\3600)
    q:type="M" durationDay*1440+((targetTime-sourceTime)\60)
    q:type="S" durationDay*86400+(targetTime-sourceTime)
    q 0
}

ClassMethod CalculateDurationS(sourceDT As %String, targetDT As %String, type = "S") As %String [ SqlProc ]
{
    set sourceDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(sourceDT," ",1),"")
    set sourceTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(sourceDT," ",2),"")
    set targetDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(targetDT," ",1),"")
    set targetTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(targetDT," ",2),"")
    quit ##class(CIS.AN.COM.DateTime).CalculateDuration(sourceDate,sourceTime,targetDate,targetTime,type)
}

/// 时间差计算，返回类型type取日期"D",小时"H",分"M",秒"S"
ClassMethod CalculateDurationNew(sourceDate, sourceTime, targetDate, targetTime, type = "S") As %String [ SqlProc ]
{
    i sourceTime="" s sourceTime=-1
    i targetTime="" s targetTime=86400
    s durationDay=targetDate-sourceDate
    i targetTime<sourceTime s durationDay=durationDay-1,targetTime=targetTime+86400
    q:type="D" durationDay
    q:type="H" durationDay*24+((targetTime-sourceTime)/3600)
    q:type="M" durationDay*1440+((targetTime-sourceTime)/60)
    q:type="S" durationDay*86400+(targetTime-sourceTime)
    q 0
}

ClassMethod CalculateDurationSNew(sourceDT As %String, targetDT As %String, type = "S") As %String [ SqlProc ]
{
    set sourceDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(sourceDT," ",1),"")
    set sourceTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(sourceDT," ",2),"")
    set targetDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(targetDT," ",1),"")
    set targetTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(targetDT," ",2),"")
    quit ##class(CIS.AN.COM.DateTime).CalculateDurationNew(sourceDate,sourceTime,targetDate,targetTime,type)
}

/// 时间差调整，入参：日期值，时间值。返回：日期值^时间值
ClassMethod DateTimeAdd(date, time, addSecond) As %String [ SqlProc ]
{
    q:date="" ""
    s adjDay=addSecond\86400
    s date=date+adjDay
    s addSecond=addSecond-(adjDay*86400)
    s time=time+addSecond
    i time>86399 s date=date+1,time=time-86400
    i time<0 s date=date-1,time=time+86400
    q date_"^"_time
}

ClassMethod CalAge(iBirth As %String, iDate As %String, ifExact = 0, retAgeType = "") As %String [ SqlProc ]
{
    i iBirth>2980000 s iBirth=""
    i iBirth<0 s iBirth=""
    q:iBirth="" ""
    s dayDiff=iDate-iBirth
    q:dayDiff<0 ""
    q:retAgeType="D" dayDiff_"日"
    s XBirth=$ZD(iBirth)
    s XToday=$ZD(iDate)
    s ageMonth=XToday-XBirth
    s ageDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s currYear=$p(XToday,"/",3) s:currYear<100 currYear=currYear+1900
    s birthYear=$p(XBirth,"/",3) s:birthYear<100 birthYear=birthYear+1900
    s ageYear=currYear-birthYear
    i ageDay<0 d
        . s ageMonth=ageMonth-1
        . s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
        . q:XToday'=2
        . s:((currYear#4)=0)&(((currYear#100)'=0)!((currYear#400)=0)) ageDay=ageDay+1
    i ageMonth<0 s ageMonth=ageMonth+12,ageYear=ageYear-1
    q:retAgeType="M" (ageYear*12+ageMonth)_"月"
    q:retAgeType="Y" ageYear_"岁"
    q:ifExact ageYear_"岁"_ageMonth_"月"_ageDay_"天"
    s retAge=""
    i (ageYear>0) d
        .s retAge=ageYear_"岁"
        .i ageYear<3 s retAge=retAge_ageMonth_"月"
    e  d
        .i (ageMonth>0) d 
            ..s retAge=ageMonth_"月"
            ..i ageMonth<3 s retAge=retAge_ageDay_"日"
        .e  d
            ..s retAge=ageDay_"日"
    q retAge
}

ClassMethod CalAgeNum(iBirth As %String, iDate As %String, ifExact = 0, retAgeType = "") As %String [ SqlProc ]
{
    i iBirth>2980000 s iBirth=""
    i iBirth<0 s iBirth=""
    q:iBirth="" ""
    s dayDiff=iDate-iBirth
    q:dayDiff<0 ""
    q:retAgeType="D" dayDiff_"日"
    s XBirth=$ZD(iBirth)
    s XToday=$ZD(iDate)
    s ageMonth=XToday-XBirth
    s ageDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s currYear=$p(XToday,"/",3) s:currYear<100 currYear=currYear+1900
    s birthYear=$p(XBirth,"/",3) s:birthYear<100 birthYear=birthYear+1900
    s ageYear=currYear-birthYear
    i ageDay<0 d
        . s ageMonth=ageMonth-1
        . s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
        . q:XToday'=2
        . s:((currYear#4)=0)&(((currYear#100)'=0)!((currYear#400)=0)) ageDay=ageDay+1
    i ageMonth<0 s ageMonth=ageMonth+12,ageYear=ageYear-1
    q:retAgeType="M" (ageYear*12+ageMonth)_"月"
    q:retAgeType="Y" ageYear
    q:ifExact ageYear_"岁"_ageMonth_"月"_ageDay_"天"
    s retAge=""
    i (ageYear>0) d
        .s retAge=ageYear_"岁"
        .i ageYear<3 s retAge=retAge_ageMonth_"月"
    e  d
        .i (ageMonth>0) d 
            ..s retAge=ageMonth_"月"
            ..i ageMonth<3 s retAge=retAge_ageDay_"日"
        .e  d
            ..s retAge=ageDay_"日"
    q retAge
}

/// Creator：        陈长青
/// CreatDate：      2017-03-21
/// Description：    获取时间的分钟数
/// Table：          
/// Input:          timeVal:时间值
/// Return：         时间分钟数(整数)
/// Debug:          w ##class(CIS.AN.COM.DateTime).GetMinutes("")
ClassMethod GetMinutes(timeVal As %String) As %Integer
{
    set timeH=..ConvertToTimeH(timeVal)
    set overplus=timeH#3600 
    set minutes=overplus\60
    quit minutes
}

/// Creator：        陈长青
/// CreatDate：      2017-03-21
/// Description：    获取时间的秒数
/// Table：          
/// Input:          timeVal:时间值
/// Return：         时间秒数(整数)
/// Debug:          w ##class(CIS.AN.COM.DateTime).GetSeconds("")
ClassMethod GetSeconds(timeVal As %String) As %Integer
{
    set timeH=..ConvertToTimeH(timeVal)
    set overPlus=timeH#3600
    set seconds=overPlus#60
    quit seconds
}

/// Creator：        陈长青
/// CreatDate：      2017-03-21
/// Description：    获取时间的小时数
/// Table：          
/// Input:          timeVal:时间值
/// Return：         时间小时数(整数)
/// Debug:          w ##class(CIS.AN.COM.DateTime).GetHours("")
ClassMethod GetHours(timeVal As %String) As %Integer
{
    set timeH=..ConvertToTimeH(timeVal)
    set hours=timeH\3600
    quit hours
}

/// Creator：        雍阳
/// CreatDate：      2018-09-25
/// Description：    标准化时间戳
/// Table：          
/// Input:          timeStamp
/// Return：         string:标准化之后的时间戳格式字符串
/// Debug:          w ##class(CIS.AN.COM.DateTime).StandardizeTimeStamp("2018-9-10 9:00")
ClassMethod StandardizeTimeStamp(timeStamp As %String) As %String
{
    if timeStamp="" quit ""
    
    set date=$piece(timeStamp," ",1)
    set time=$piece(timeStamp," ",2)
    set dateH=..ConvertToDateH(date)
    set timeH=..ConvertToTimeH(time)
    set result=$zd(dateH,3)_" "_$zt(timeH)
    quit result
}

/// Creator：        雍阳
/// CreatDate：      2018-11-07
/// Description：    判断时间值与当天时间间隔在一天以内
/// Table：          
/// Input:          
/// Return：         string:标准化之后的时间戳格式字符串
/// Debug:          w ##class(CIS.AN.COM.DateTime).AroundOneDay("2018-9-10", "9:00")
ClassMethod AroundOneDay(date As %String, time As %String) As %String [ SqlProc ]
{
    set dateH=..ConvertToDateH(date)
    set timeH=..ConvertToTimeH(time)
    set dateInterval = $h-dateH
    set timeInterval = +$p($h,",",2)-timeH
    set span= dateInterval+(0.00001*timeInterval)
    set result=(span<1)&&(span>-1)
    quit result
}

/// Creator：        雍阳
/// CreatDate：      2018-11-07
/// Description：    判断日期值是否大于等于当天日期
/// Table：          
/// Input:          
/// Return：         1:是，0:不是
/// Debug:          w ##class(CIS.AN.COM.DateTime).IsDateOverNow("2018-9-10", "9:00")
ClassMethod IsDateBeforeNow(date As %String) As %String [ SqlProc ]
{
    set dateH=..ConvertToDateH(date)
    if dateH<+$h quit 1
    else  quit 0
}

ClassMethod GetServerNow() As %String
{
    set today=+$h,now=$p($h,",",2)
    quit ..ConvertToDateTime(today,now)
}

/// Creator：        ygb
/// CreatDate：      2023-4-17
/// Description：    根据his系统配置获取日期格式
/// Table：          
/// Input:          
/// Return：         
/// Debug:          w ##class(CIS.AN.COM.DateTime).ConvertToDateHis("2018-9-10")
ClassMethod ConvertToDateHis(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
	set dateformatnum=##class(websys.Conversions).DateFormat()
	quit:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
	quit:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,dateformatnum)
	quit $zd(dateVal,dateformatnum)
}

/// Creator：        ygb
/// CreatDate：      2023-4-17
/// Description：    根据his系统配置获取时间格式
/// Table：          
/// Input:          
/// Return：         
/// Debug:          w ##class(CIS.AN.COM.DateTime).ConvertToTimeHis()
ClassMethod ConvertToTimeHis(dateVal As %String, defaultStr As %String = "$H") As %String [ SqlProc ]
{
	;set timeformat=##class(websys.Conversion).TimeFormat()
	set timeformat=2
	quit:(+dateVal=0) $zt(dateVal)
	quit:((+dateVal=0)!(dateVal>86399)!(dateVal<0))&(defaultStr="") ""
	quit:(+dateVal=0)!(dateVal>86399)!(dateVal<0) $zt($p($h,",",2),timeformat)
	quit $zt(dateVal,timeformat)
}

}
