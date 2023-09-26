/// 名称： EPRservice.Util.DateHelper
/// 描述:  获取系统日期，返回当前节气；根据指定日期，返回相应节气；日期为21世纪日期；
/// 创建者：牛才才
/// 创建时间：2014-08-21 
Class EPRservice.Util.DateHelper Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(EPRservice.Util.DateHelper).getJIEQIbySystemDate()
ClassMethod getJIEQIbySystemDate()
{
	s Systemdateint = +$HOROLOG
	s Systemdate = $zd(Systemdateint,3)
	s JIEQI = ..getJIEQIbyDate(Systemdate)
	q JIEQI
}

/// w ##Class(EPRservice.Util.DateHelper).getJIEQIbyDate("2014-01-03")
/// 入参ADate的形式为 2014-01-03
ClassMethod getJIEQIbyDate(ADate As %String)
{
	//节气的计算公式：[Y*D+C]-L
	//Y:年份的后两位；D=0.2422；C是变值，每个世纪的每个节气的C值均不同；L是闰年数，计算1月2月的节气时，年数应该减1
	
	s surDate = ADate
	s Year = $p(surDate,"-",1)
	s Month = $p(surDate,"-",2)
	s Day = $p(surDate,"-",3)
	
	s JIEQI = ""
	
	s Y = $e(Year,3,4)
	s D = 0.2422
	
	if (Month = "01")||(Month = "1")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s XIAOHAN = ((Y*D+5.4055)\1)-((Y-1)\4)
		if (Y = "19")
		{
			s XIAOHAN = XIAOHAN - 1
		}
		s DAHAN = ((Y*D+20.12)\1)-((Y-1)\4)
		if (Y = "82")
		{
			s DAHAN = DAHAN + 1
		}
		//判断入参的日期属于哪个节气
		if (Day < XIAOHAN)
		{
			s JIEQI = "冬至"
		}
		elseif (Day < DAHAN)
		{
			s JIEQI = "小寒"
		}
		else
		{
			s JIEQI = "大寒"
		}
		q JIEQI
	}
	elseif (Month = "02")||(Month = "2")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s LICHUN = ((Y*D+3.87)\1)-((Y-1)\4)
		
		s YUSHUI = ((Y*D+18.73)\1)-((Y-1)\4)
		if (Y = "26")
		{
			s YUSHUI = YUSHUI - 1
		}
		//判断入参的日期属于哪个节气
		if (Day < LICHUN)
		{
			s JIEQI = "大寒"
		}
		elseif (Day < YUSHUI)
		{
			s JIEQI = "立春"
		}
		else
		{
			s JIEQI = "雨水"
		}
		q JIEQI
	}
	elseif (Month = "03")||(Month = "3")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s JINGZHE = ((Y*D+5.63)\1)-((Y-1)\4)
		
		s CHUNFEN = ((Y*D+20.646)\1)-((Y-1)\4)
		if (Y = "84")
		{
			s CHUNFEN = CHUNFEN + 1
		}
		//判断入参的日期属于哪个节气
		if (Day < JINGZHE)
		{
			s JIEQI = "雨水"
		}
		elseif (Day < CHUNFEN)
		{
			s JIEQI = "惊蛰"
		}
		else
		{
			s JIEQI = "春分"
		}
		q JIEQI
	}
	elseif (Month = "04")||(Month = "4")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s QINGMING = ((Y*D+4.81)\1)-((Y-1)\4)
		
		s GUYU = ((Y*D+20.1)\1)-((Y-1)\4)
		//判断入参的日期属于哪个节气
		if (Day < QINGMING)
		{
			s JIEQI = "春分"
		}
		elseif (Day < GUYU)
		{
			s JIEQI = "清明"
		}
		else
		{
			s JIEQI = "谷雨"
		}
		q JIEQI
	}
	elseif (Month = "05")||(Month = "5")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s LIXIA = ((Y*D+5.52)\1)-((Y-1)\4)
		
		s XIAOMAN = ((Y*D+21.04)\1)-((Y-1)\4)
		if (Y = "08")
		{
			s XIAOMAN = XIAOMAN + 1
		}
		//判断入参的日期属于哪个节气
		if (Day < LIXIA)
		{
			s JIEQI = "谷雨"
		}
		elseif (Day < XIAOMAN)
		{
			s JIEQI = "立夏"
		}
		else
		{
			s JIEQI = "小满"
		}
		q JIEQI
	}
	elseif (Month = "06")||(Month = "6")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s MANGZHONG = ((Y*D+5.678)\1)-((Y-1)\4)
		
		s XIAZHI = ((Y*D+21.37)\1)-((Y-1)\4)
		//判断入参的日期属于哪个节气
		if (Day < MANGZHONG)
		{
			s JIEQI = "小满"
		}
		elseif (Day < XIAZHI)
		{
			s JIEQI = "芒种"
		}
		else
		{
			s JIEQI = "夏至"
		}
		q JIEQI
	}
	elseif (Month = "07")||(Month = "7")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s XIAOSHU = ((Y*D+7.108)\1)-((Y-1)\4)
		
		s DASHU = ((Y*D+22.83)\1)-((Y-1)\4)
		//判断入参的日期属于哪个节气
		if (Day < XIAOSHU)
		{
			s JIEQI = "夏至"
		}
		elseif (Day < DASHU)
		{
			s JIEQI = "小暑"
		}
		else
		{
			s JIEQI = "大暑"
		}
		q JIEQI
	}
	elseif (Month = "08")||(Month = "8")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s LIQIU = ((Y*D+7.5)\1)-((Y-1)\4)
		if (Y = "02")
		{
			s LIQIU = LIQIU + 1
		}
		s CHUSHU = ((Y*D+23.13)\1)-((Y-1)\4)
		//判断入参的日期属于哪个节气
		if (Day < LIQIU)
		{
			s JIEQI = "大暑"
		}
		elseif (Day < CHUSHU)
		{
			s JIEQI = "立秋"
		}
		else
		{
			s JIEQI = "处暑"
		}
		q JIEQI
	}
	elseif (Month = "09")||(Month = "9")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s BAILU = ((Y*D+7.646)\1)-((Y-1)\4)
		s QIUFEN = ((Y*D+23.042)\1)-((Y-1)\4)
		//判断入参的日期属于哪个节气
		if (Day < BAILU)
		{
			s JIEQI = "处暑"
		}
		elseif (Day < QIUFEN)
		{
			s JIEQI = "白露"
		}
		else
		{
			s JIEQI = "秋分"
		}
		q JIEQI
	}
	elseif (Month = "10")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s HANLU = ((Y*D+8.318)\1)-((Y-1)\4)
		s SHUANGJIANG = ((Y*D+23.438)\1)-((Y-1)\4)
		if (Y = "89")
		{
			s SHUANGJIANG = SHUANGJIANG + 1
		}
		//判断入参的日期属于哪个节气
		if (Day < HANLU)
		{
			s JIEQI = "秋分"
		}
		elseif (Day < SHUANGJIANG)
		{
			s JIEQI = "寒露"
		}
		else
		{
			s JIEQI = "霜降"
		}
		q JIEQI
	}
	elseif (Month = "11")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s LIDONG = ((Y*D+7.438)\1)-((Y-1)\4)
 		if (Y = "89")
		{
			s LIDONG = LIDONG + 1
		}
		s XIAOXUE = ((Y*D+22.36)\1)-((Y-1)\4)
		
		//判断入参的日期属于哪个节气
		if (Day < LIDONG)
		{
			s JIEQI = "霜降"
		}
		elseif (Day < XIAOXUE)
		{
			s JIEQI = "立冬"
		}
		else
		{
			s JIEQI = "小雪"
		}
		q JIEQI
	}
	elseif (Month = "12")
	{
		//按公式计算此月份内的两个节气的日期，有例外的情况做一下处理
 		s DAXUE = ((Y*D+7.18)\1)-((Y-1)\4)
		s DONGZHI = ((Y*D+21.94)\1)-((Y-1)\4)
		if (Y = "21")
		{
			s DONGZHI = DONGZHI - 1
		}
		//判断入参的日期属于哪个节气
		if (Day < DAXUE)
		{
			s JIEQI = "小雪"
		}
		elseif (Day < DONGZHI)
		{
			s JIEQI = "大雪"
		}
		else
		{
			s JIEQI = "冬至"
		}
		q JIEQI
	}
}

}
