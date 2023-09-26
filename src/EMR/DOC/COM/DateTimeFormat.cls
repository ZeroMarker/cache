/// 名称:	EMR.DOC.COM.DateTimeFormat
/// 描述:	时间格式公用类
/// 编写者:	yejian
/// 编写日期: 	2021-2-22
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.DateTimeFormat Extends %RegisteredObject
{

/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat()
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormatExt","Date")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormatExt","Time")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormat","Date")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormat","Time")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date","2012-01-11")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time","11:00")
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime","2012-01-11 11:00")
ClassMethod GetHISStandardDateTimeFormat(IsFormat As %String, IsDataOrTime As %String, ArgDateTimeValue As %String = "") As %String
{
	s sysDateTimeToHISFormat = ##class(EMR.OP.BL.SysOption).GetOptionValueByName("DateTimeToHISFormat","Y")
	s retvalue=""
	
	if (sysDateTimeToHISFormat="N")
	{
		if (IsFormat="ChangeToFormat")
		{
			if IsDataOrTime="Date" 
			{

				s dateHtmlToLogical=##class(websys.Conversions).DateHtmlToLogical(ArgDateTimeValue)
	
					
				s retvalue= $zd(dateHtmlToLogical,3)
			}
			elseif IsDataOrTime="Time" 
			{

					s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)
					
					s retvalue=$zt(timeHtmlToLogical,2)
			}
			elseif IsDataOrTime="DateTime"
			{
				s beChangedDateValue=$p(ArgDateTimeValue," ",1)
				
				s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
				
				s dateHtmlToLogical=##class(websys.Conversions).DateHtmlToLogical(beChangedDateValue)
				
				s dateValue=$zd(dateHtmlToLogical,3)
				
				s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(beChangedTimeValue)
				
				s timeValue=$zt(timeHtmlToLogical,2)
				
				s retvalue=dateValue_" "_timeValue
				s retvalue = ArgDateTimeValue
			}
		}
		q retvalue		
	}
	
	
	//取extjs日期时间格式
	if (IsFormat="GetFormatExt")
	{
		if IsDataOrTime="Date" {
			//----取日期时间格式
			//3 YYYY-MM-DD
			//4 DD/MM/YYYY
			s retvalueType=##class(websys.Conversions).DateFormat()
			s retvalue=$s(retvalueType="3":"Y-m-d",retvalueType="4":"d/m/Y",1:"")
		}
		elseif IsDataOrTime="Time"
		{
			/*
				1	HH:MM:SS		HMS 分割符 :   24小时格式
				2	HH:MM			HM 		分割符 :    24小时格式
				3	hh:mm:ssAM
					hh:mm:ssPM		hms 分割符 :    12小时格式
									AM为配置字符与PM配置字符
				4	hh:mmAM
					hh:mmPM			hm 分割符 :     12小时格式
									AM为配置字符与PM配置字符
			*/
			s retvalueType=##class(websys.Conversions).TimeFormat()
			s retvalue=$s(retvalueType="1":"H:i:s",retvalueType="2":"H:i",retvalueType=3:"hh:mm:ssAM",retvalueType=4:"hh:mmPM",1:"")
		}
	}
	//取完整格式
	elseif (IsFormat="GetFormat")
	{
		if IsDataOrTime="Date" {
			//----取日期时间格式
			//3 YYYY-MM-DD
			//4 DD/MM/YYYY
			s retvalueType=##class(websys.Conversions).DateFormat()
			s retvalue=$s(retvalueType="3":"YYYY-MM-DD",retvalueType="4":"DD/MM/YYYY",1:"")
		}
		elseif IsDataOrTime="Time"
		{
			/*
				1	HH:MM:SS		HMS 分割符 :   24小时格式
				2	HH:MM			HM 		分割符 :    24小时格式
				3	hh:mm:ssAM
					hh:mm:ssPM		hms 分割符 :    12小时格式
									AM为配置字符与PM配置字符
				4	hh:mmAM
					hh:mmPM			hm 分割符 :     12小时格式
									AM为配置字符与PM配置字符
			
			*/
			s retvalueType=##class(websys.Conversions).TimeFormat()
			s retvalue=$s(retvalueType="1":"HH:MM:SS",retvalueType="2":"HH:MM",retvalueType=3:"HH:MM:SSAM",retvalueType=4:"HH:MMPM",1:"")
		}
	}
	//取完整格式
	elseif (IsFormat="ChangeToSysFormat")
	{
		if IsDataOrTime="Date" 
		{
				//---日期转换
				
				/*normal to sys
				入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
				返回	M中日期数字	64338		64338		64338	ERROR
				*/
				s retvalue=##class(websys.Conversions).DateHtmlToLogical(ArgDateTimeValue)
		}
		elseif IsDataOrTime="Time" {
				//---时间转换
				
				/* normal to sys 
				入参	配置的时间格式	23:09	83340	25:67
				返回	M中时间数字		83340	83340	ERROR
				*/
				s retvalue=##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
			s dateValue=##class(websys.Conversions).DateHtmlToLogical(beChangedDateValue)	
			s timeValue=##class(websys.Conversions).TimeHtmlToLogical(beChangedTimeValue)
			s retvalue=dateValue_" "_timeValue
		}
	}
	elseif (IsFormat="ChangeToFormat")
	{
		if IsDataOrTime="Date" 
		{
			//---日期转换
			/*normal to sys
			入参	日期		2017-2-24	24/2/2017	64338	2017-23-1	
			返回	M中日期数字	64338		64338		64338	ERROR
			*/
			s dateHtmlToLogical=##class(websys.Conversions).DateHtmlToLogical(ArgDateTimeValue)
			
			/*
			入参	M中日期数字	64338		2017-2-24	9999999	
			返回	日期		2017-2-24	2017-2-24	ERROR
			*/
			s retvalue=##class(websys.Conversions).DateLogicalToHtml(dateHtmlToLogical)
		}
		elseif IsDataOrTime="Time" {
			//---时间转换
			/* normal to sys 
			入参	配置的时间格式	23:09	83340	25:67
			返回	M中时间数字		83340	83340	ERROR
			*/
			s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)
			
			
			
			/*
			入参	M中时间数字		83340	23:09	999999	
			返回	配置的时间格式	23:09	23:09	ERROR
			*/
			s retvalue=##class(websys.Conversions).TimeLogicalToHtml(timeHtmlToLogical)
		}
		elseif IsDataOrTime="DateTime"
		{
			s beChangedDateValue=$p(ArgDateTimeValue," ",1)
			s beChangedTimeValue=$p(ArgDateTimeValue," ",2)
			s dateHtmlToLogical=##class(websys.Conversions).DateHtmlToLogical(beChangedDateValue)
			s dateValue=##class(websys.Conversions).DateLogicalToHtml(dateHtmlToLogical)
			s timeHtmlToLogical=##class(websys.Conversions).TimeHtmlToLogical(beChangedTimeValue)
			s timeValue=##class(websys.Conversions).TimeLogicalToHtml(timeHtmlToLogical)
			s retvalue=dateValue_" "_timeValue
		}
	}
	q retvalue
}

/// Desc:		根据系统设置显示日期时间样式
/// Creator:     Candy 
/// CreateDate:  2018-10-16
/// Input:       ALogicalValue cache表格的日期或时间
///             AType:[date(日期),time(时间)]
/// Output:      result 转换后值
ClassMethod GetHisDateTimeFormat(ALogicalValue As %String, AType As %String) As %String
{
	s result = ""
	q:(ALogicalValue = "") result
	s sysDateTimeToHISFormat = ##class(EMR.OP.BL.SysOption).GetOptionValueByName2("DateTimeToHISFormat","Y")
	s retvalue=""
	if (sysDateTimeToHISFormat="N")
	{
		if (AType = "date")
		{
			s result = $zd(ALogicalValue,3)
		}
		else
		{
			s result = $zt(ALogicalValue,2)
		}
		q result
	}
	if (AType = "date")
	{
		s result = ##class(websys.Conversions).DateLogicalToHtml(ALogicalValue)
	}
	else
	{
		s result = ##class(websys.Conversions).TimeLogicalToHtml(ALogicalValue)
	}
	q result
}

/// Desc:      获取时间戳
/// Creator:   yejian
/// CreateDate:2022-4-20
/// Input:    dtValue 时间(66227,57202)
///           AType 时间戳类型  "ms" 毫秒   "s" 秒
/// Output:    cache日期时间
/// debug w ##class(EMR.DOC.COM.DateTimeFormat).GetTimeStamp()
ClassMethod GetTimeStamp(dtValue As %String = "", AType As %String = "") As %String
{
	s nowdate = "",timestamp = ""
		
    if ((AType="")||(AType="s")) 
    {
		s:(dtValue'="") nowdate=dtValue
	    s:(nowdate="") nowdate = $H
	    s date = $P(nowdate,",",1)
	    s time = $P(nowdate,",",2)
	   	s startdate = 47117
	  	s timestamp = (date-startdate)*86400 + time - 28800
    }
    elseif(AType = "ms")
    {
	    s:(dtValue'="") nowdate =dtValue_"."_$P($NOW(),".",2)
	    s:(nowdate="") nowdate = $NOW()
	    s date = $P(nowdate,",",1)
	    s time = $P(nowdate,",",2)
	    s second = $P(time,".",1)
		s millisecond = $e($P(time,".",2),1,3)
		s startdate = 47117
	  	s timestamp = (date-startdate)*86400 + second - 28800
		s timestamp = timestamp * 1000
		s timestamp = timestamp + millisecond
    }
    q timestamp
}

/// Desc:      时间戳转换成日期时间
/// Creator:   yejian
/// CreateDate:2022-4-20
/// Input:     ATimestamp 时间戳
///           AType 时间戳类型  "ms" 毫秒   "s" 秒
/// Output:    cache日期时间
/// Debug:     w ##class(EMR.DOC.COM.DateTimeFormat).TimestampToDateTime(1621912296,"s")
ClassMethod TimestampToDateTime(ATimestamp, AType As %String = "") As %String
{
	s timestamp = $g(ATimestamp)
	q:(timestamp = "") ""
	s:(AType = "ms") timestamp = timestamp \ 1000
	s datetime = timestamp + 4070937600
	s time = datetime # 86400
	s date = (datetime - time) / 86400
	s toDateTime = date _ "," _ time
	q toDateTime
}

/// Description:根据起始日期、起始时间、时间间隔(以秒为单位)计算截止日期、截止时间
/// Creator:   yejian
/// CreateDate:2022-4-20
/// Table:EPRinstance.EPRActionAppoint
/// Input:startDate-起始日期,startTime-起始时间,timeSpan-时间间隔
/// Output:
/// Return:截止日期和截止时间,格式为:截止日期,截止时间
/// Others:
/// Debug: w ##class(EMR.DOC.COM.DateTimeFormat).GetEndDateTime($P($H,",",1),$P($H,",",2),36000)
ClassMethod GetEndDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	//b "s"
	s curDate = (startTime+timeSpan)\86400
	if (curDate=0)
	{
		q startDate_","_(startTime+timeSpan)
	}
	else
	{
		s curTime = startTime+timeSpan-(curDate*86400)
		q startDate+curDate_","_curTime
	}
}

/// Description:将HISUI系统日期或时间配置转为YYYY-MM-DD或HH:MM:SS格式
///             HISUI日期格式 1 MM/DD/YYYY、3 YYYY-MM-DD、4 DD/MM/YYYY
///             HISUI时间格式 1 HH:MM:SS、2 HH:MM、3 HH:MM:SSAM、4 HH:MMPM 
/// Creator:   yejian
/// CreateDate:2022-4-20
/// Table:
/// Input:   AType:[Date(日期),Time(时间)] 
///          ADateOrTimeValue:日期或时间     
/// Output:  
/// Return:转换YYYY-MM-DD或HH:MM:SS格式后日期或时间值
/// Others:
/// Debug:   w ##class(EMR.DOC.COM.DateTimeFormat).GetDateTimeHtmlToLogical("Date","09/06/2021")
///          w ##class(EMR.DOC.COM.DateTimeFormat).GetDateTimeHtmlToLogical("Time","23:09")
ClassMethod GetDateTimeHtmlToLogical(AType As %String, ArgDateTimeValue As %String)
{
	s ret = ArgDateTimeValue
	if (AType="Date")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||DateHtmlToLogical")){
			s ret = ##class(websys.Conversions).DateHtmlToLogical(ArgDateTimeValue)
		}	
	}elseif(AType="Time")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("websys.Conversions||TimeHtmlToLogical")){
			s ret = ##class(websys.Conversions).TimeHtmlToLogical(ArgDateTimeValue)	
		}
	}
	q ret
}

/// Creator：     lifengbo
/// CreatDate：   2023-04-19
/// Description:  取两个时间的间隔秒
/// Input：       
/// Return:	
/// w ##class(EMR.DOC.COM.DateTimeFormat).GetDateTimeDiff("2017-11-06","12:00:59","2018-11-06","12:00:31")
ClassMethod GetDateTimeDiff(argStartDate As %String, argStartTime As %String, argEndDate As %String, argEndTime As %String) As %String
{
	Set ret = "error"
	
	Quit:(argStartDate="")||(argStartTime="")||(argEndDate="")||(argEndTime="") ret
	
	s $zt = "ERROR"
	
	s sysStartDate=##class(websys.Conversions).DateHtmlToLogical(argStartDate)
	s sysStartTime=##class(websys.Conversions).TimeHtmlToLogical(argStartTime)
		
	s sysEndDate=##class(websys.Conversions).DateHtmlToLogical(argEndDate)
	s sysEndTime=##class(websys.Conversions).TimeHtmlToLogical(argEndTime)
	if ((sysStartDate["ERROR")||(sysStartTime["ERROR")||(sysEndDate["ERROR")||(sysEndTime["ERROR"))
	{
		q "error"
	}
	Set DateDiff = (sysEndDate - sysStartDate) * 24 * 60 * 60  //秒
	
	set TimeDiff = (sysEndTime-sysStartTime)

	Set datetimeDiff = DateDiff + TimeDiff
	
	Set ret = datetimeDiff
	
	Quit ret
	
ERROR
	s $zt=""
	q "error:"_$ze
}

}
