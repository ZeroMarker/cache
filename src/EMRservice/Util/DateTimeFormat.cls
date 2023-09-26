Class EMRservice.Util.DateTimeFormat Extends %RegisteredObject
{

/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat()
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormatExt","Date")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormatExt","Time")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormat","Date")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("GetFormat","Time")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date","2012-01-11")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time","11:00")
/// w ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime","2012-01-11 11:00")
ClassMethod GetHISStandardDateTimeFormat(IsFormat As %String, IsDataOrTime As %String, ArgDateTimeValue As %String = "") As %String
{
	s sysDateTimeToHISFormat = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DateTimeToHISFormat","Y")
	s retvalue=""
	
	
	
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
		if (sysDateTimeToHISFormat="N")
		{
			if (ArgDateTimeValue'="")
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
		}
		else
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
			elseif IsDataOrTime="Time" 
			{
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
	
	s sysDateTimeToHISFormat = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DateTimeToHISFormat","Y")
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

/// Creator：     lifengbo
/// CreatDate：   2023-04-19
/// Description:  取两个时间的间隔秒
/// Input：       
/// Return:	
/// w ##class(EMRservice.Util.DateTimeFormat).GetDateTimeDiff("2017-11-06","12:00:59","2018-11-06","12:00:31")
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
