Class web.DHCBL.MKB.MKBDataStatistics Extends %RegisteredObject
{

/// 李欣 20180906
/// 数据统计存储方法
/// Flag:标识数据所属父菜单 ID:数据ID Num:数据数量
ClassMethod SaveData(Flag, ID, Num)
{
	s obj = ##class(User.MKBDataStatistics).%New()
	s obj.MKBDSDay = +$H	
	s obj.MKBDSFlag = Flag
	s obj.MKBDSID = ID
	s obj.MKBDSNum = Num
	s obj.MKBDSWeek = ..GetWeek()
	s obj.MKBDSMonth = ..GetMonth()
	d obj.%Save()
}

/// d ##class(web.DHCBL.BDP.LeeTemp).GetWeek()
ClassMethod GetWeek()
{
	s STDay = $ZDH("01/01/2018",1)
	//s Today = $ZDH("01/07/2018",1)
	s Today = +$H
	s week = (Today-STDay)\7+1
	
	q week
}

/// d ##class(web.DHCBL.BDP.LeeTemp).GetMonth()
ClassMethod GetMonth()
{
	s Today = $ZD(+$H,3) //2018-01-31
	s Year = $P(Today,"-",1)
	s Month = $P(Today,"-",2)
	
	s months = (Year-2018)*12+Month
	q months
}

/// d ##class(web.DHCBL.MKB.MKBDataStatistics).SaveForEveryDay()
ClassMethod SaveForEveryDay()
{
	s KnoMenuId = $O(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.MTM",0))
	s MapMenuId = $O(^User.BDPMenuI("UniqueCodeIndex"," DHC.BDP.MKB.KLM",0))
	s result = ""
	s MenuId = 0
	for
	{
		s MenuId = $O(^User.BDPMenuI("ParMenuIdx",KnoMenuId,MenuId))
		q:MenuId=""
		
		s MenuDesc = $LG($G(^User.BDPMenuD(MenuId)),3)
		s MenuDescU = $ZCONVERT(MenuDesc,"U")
		s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," "_MenuDescU,0))
		b:MKBTBRowId="" ;MKBTBRowId=""
		s KnoNum=0
		s MKBTRowId=0
		for
		{
			s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""
			
			s KnoNum=KnoNum+1
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""
				
				s KnoNum=KnoNum+1
				s MKBTPDRowId=0
				for
				{
					s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:MKBTPDRowId=""
					s KnoNum=KnoNum+1		
				}
			}
		}	
		
		d ..SaveData("KNO",MKBTBRowId,KnoNum)
	}	
	
	s MenuId = 0
	for
	{
		s MenuId = $O(^User.BDPMenuI("ParMenuIdx",MapMenuId,MenuId))
		q:MenuId=""
		
		s MenuDesc = $LG($G(^User.BDPMenuD(MenuId)),3)
		s MenuDescU = $ZCONVERT(MenuDesc,"U")
		s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," "_MenuDescU,0))
		b:MKBKLMBRowId="" ;MKBKLMBRowId=""
		s MapNum=0
		s MKBKLMDRowId=0
		for
		{
			s MKBKLMDRowId = $O(^User.MKBKLMappingDetailI("BaseIndex",MKBKLMBRowId,MKBKLMDRowId))
			q:MKBKLMDRowId=""
			
			s MapNum=MapNum+1	
		}	
		
		d ..SaveData("MAP",MKBKLMBRowId,MapNum)
	}
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBDataStatistics","CalDataList")
Query CalDataList() As %Query(ROWSPEC = "Type,PageName,Data,WeekData,MonthData")
{
}

ClassMethod CalDataListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	  
	s MKBTBRowId = 0
	for
	{
		;s MKBTBRowId = $O(^TMP("MKB","Kno","WeekData",MKBTBRowId))
		s MKBTBRowId = $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId))
		q:MKBTBRowId=""
		
		s WeekSub=0
		;if ($D(^TMP("MKB","Kno","WeekData",MKBTBRowId,(..GetWeek()-1)))=0)
		if ($D(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,(..GetWeek()-1)))=0)
		{
			s WeekSub =  0 ;$O(^TMP("MKB","Kno","WeekData",MKBTBRowId,..GetWeek(),0))	
		}
		else
		{
			s WeekSub = $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,..GetWeek(),0)) - $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,(..GetWeek()-1),0))
		}
		
		s MonthSub = 0
		if ($D(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,(..GetMonth()-1)))=0)
		;if ($D(^TMP("MKB","Kno","MonthData",MKBTBRowId,(..GetMonth()-1)))=0)
		{
			s MonthSub =  0 ;$O(^TMP("MKB","Kno","MonthData",MKBTBRowId,..GetMonth(),0))	
		}
		else
		{
			s MonthSub = $O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,..GetMonth(),0)) - $O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,(..GetMonth()-1),0))
		}
		
		s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
		s Type = "知识管理"
		s PageName = MKBTBDesc
		s Data = $O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,..GetMonth(),""))
		s WeekData = WeekSub
		s MonthData = MonthSub
		d OutputRow1
		;s temp = ""
		;s temp = "{""Type"":""知识管理"",""PageName"":"""_MKBTBDesc_""",""Data"":"""_$O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,..GetMonth(),""))_""",""WeekData"":"""_WeekSub_""",""MonthData"":"""_MonthSub_"""}"
		;s:result'="" result=result_","_temp
		;s:result="" result=temp
	}
	
	s MKBKLMBRowId = 0
	for
	{
		;s MKBKLMBRowId = $O(^TMP("MKB","Map","WeekData",MKBKLMBRowId))
		s MKBKLMBRowId = $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s WeekSub=0
		;if ($D(^TMP("MKB","Map","WeekData",MKBKLMBRowId,(..GetWeek()-1)))=0)
		if ($D(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,(..GetWeek()-1)))=0)
		{
			s WeekSub =  0 ;$O(^TMP("MKB","Map","WeekData",MKBTBRowId,..GetWeek(),0))	
		}
		else
		{
			s WeekSub = $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek(),0)) - $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek()-1,0))
		}
		
		s MonthSub = 0
		if ($D(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,(..GetMonth()-1)))=0)
		{
			s MonthSub =  0 ;$O(^TMP("MKB","Map","MonthData",MKBTBRowId,..GetMonth(),0))	
		}
		else
		{
			s MonthSub = $O(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,..GetMonth(),0)) - $O(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,..GetMonth()-1,0))
		}
		
		s MKBKLMBDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),3)
		s Type = "规则管理"
		s PageName = MKBKLMBDesc
		s Data = $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek(),""))
		s WeekData = WeekSub
		s MonthData = MonthSub
		d OutputRow1
		;s temp=""
		;s temp = "{""Type"":""规则管理"",""PageName"":"""_MKBKLMBDesc_""",""Data"":"""_$O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek(),""))_""",""WeekData"":"""_WeekSub_""",""MonthData"":"""_MonthSub_"""}"
		;s:result'="" result=result_","_temp
		;s:result="" result=temp
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(Type,PageName,Data,WeekData,MonthData)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod CalDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CalDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCBL.MKB.MKBDataStatistics).CalAllData()
ClassMethod CalAllData()
{
	s result=""
	;w " 管理 "_"---"_"页面"_"---"_"数据总量"_"---"_"本周数据增长"_"---"_"本月数据增长",!
	s MKBTBRowId = 0
	for
	{
		;s MKBTBRowId = $O(^TMP("MKB","Kno","WeekData",MKBTBRowId))
		s MKBTBRowId = $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId))
		q:MKBTBRowId=""
		
		s WeekSub=0
		;if ($D(^TMP("MKB","Kno","WeekData",MKBTBRowId,(..GetWeek()-1)))=0)
		if ($D(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,(..GetWeek()-1)))=0)
		{
			s WeekSub =  0 ;$O(^TMP("MKB","Kno","WeekData",MKBTBRowId,..GetWeek(),0))	
		}
		else
		{
			s WeekSub = $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,..GetWeek(),0)) - $O(^User.MKBDataStatisticsI("WeekIndex","KNO",MKBTBRowId,(..GetWeek()-1),0))
		}
		
		s MonthSub = 0
		if ($D(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,(..GetMonth()-1)))=0)
		;if ($D(^TMP("MKB","Kno","MonthData",MKBTBRowId,(..GetMonth()-1)))=0)
		{
			s MonthSub =  0 ;$O(^TMP("MKB","Kno","MonthData",MKBTBRowId,..GetMonth(),0))	
		}
		else
		{
			s MonthSub = $O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,..GetMonth(),0)) - $O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,(..GetMonth()-1),0))
		}
		
		s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
		s temp = ""
		s temp = "{""Type"":""知识管理"",""PageName"":"""_MKBTBDesc_""",""Data"":"""_$O(^User.MKBDataStatisticsI("MonthIndex","KNO",MKBTBRowId,..GetMonth(),""))_""",""WeekData"":"""_WeekSub_""",""MonthData"":"""_MonthSub_"""}"
		s:result'="" result=result_","_temp
		s:result="" result=temp
	}
	
	s MKBKLMBRowId = 0
	for
	{
		;s MKBKLMBRowId = $O(^TMP("MKB","Map","WeekData",MKBKLMBRowId))
		s MKBKLMBRowId = $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s WeekSub=0
		;if ($D(^TMP("MKB","Map","WeekData",MKBKLMBRowId,(..GetWeek()-1)))=0)
		if ($D(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,(..GetWeek()-1)))=0)
		{
			s WeekSub =  0 ;$O(^TMP("MKB","Map","WeekData",MKBTBRowId,..GetWeek(),0))	
		}
		else
		{
			s WeekSub = $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek(),0)) - $O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek()-1,0))
		}
		
		s MonthSub = 0
		if ($D(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,(..GetMonth()-1)))=0)
		{
			s MonthSub =  0 ;$O(^TMP("MKB","Map","MonthData",MKBTBRowId,..GetMonth(),0))	
		}
		else
		{
			s MonthSub = $O(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,..GetMonth(),0)) - $O(^User.MKBDataStatisticsI("MonthIndex","MAP",MKBKLMBRowId,..GetMonth()-1,0))
		}
		
		s MKBKLMBDesc = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),3)
		s temp=""
		s temp = "{""Type"":""规则管理"",""PageName"":"""_MKBKLMBDesc_""",""Data"":"""_$O(^User.MKBDataStatisticsI("WeekIndex","MAP",MKBKLMBRowId,..GetWeek(),""))_""",""WeekData"":"""_WeekSub_""",""MonthData"":"""_MonthSub_"""}"
		s:result'="" result=result_","_temp
		s:result="" result=temp
	}
	s result="["_result_"]"
	q result
}

}
