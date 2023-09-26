/// Class Name:	 	EPRservice.Quality.CheckRule.Course
/// Description: 	可重复模板相关数据
/// Author: 	 	Zuoxiang Xie
/// Create Date: 	2010-05-10
Class EPRservice.Quality.CheckRule.Course Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	取可重复模板发生日期时间 "\"分割(日期和时间空格分割);
/// Input:	AEpisodeID	: 就诊号
/// 		ATitles		: StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题
/// 		AStartDate	: 开始日期 "2009-05-23"
/// 		AStartTime	: 开始时间 "21:32:10"
/// 		AEndDate	: 结束日期 "2009-05-23"
/// 		AEndTime	: 结束时间 "21:32:10"
/// Output:	ret = 发生日期时间
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime("2482807","337|抢救记录\交班记录","","","","")
ClassMethod GetMultiTemHaDateTime(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %String
{
	s ret = "0^"
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	/*
	//只检查在可重复模板固定标题使用后入院的病历
	s flag = ..CheckMultiTitleStartDate(AEpisodeID)  
	q:(flag < 0) ret
	*/
	
	s flag = 0
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "")
		
		/*
		//判断可重复模板目录是否符合检查条件
		s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightMultiCatalog(AEpisodeID,StructID)
		continue:(flag < 0) 
		*/
		
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		continue:(CategoryID = "")
		
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		if (TitleList '= "")
		{
			for IndSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,IndSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title)
				While(ds.Next())
				{
					s MultiDataInfo = ds.Data("MultiDataInfo")
					s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
					s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
					continue:(HappenDate = "")||(HappenTime = "")
					
					s HappenDateTime = $zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
					
					s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDateTime) = ""
				}
				d ds.Close()
			}
		}
		else
		{
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			While(ds.Next())
			{
				s MultiDataInfo = ds.Data("MultiDataInfo")
				s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
				s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
				continue:(HappenDate = "")||(HappenTime = "")
				
				s HappenDateTime = $zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
				s HappenDateTime = HappenDate_" "_HappenTime
				s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDateTime) = ""
			}
			d ds.Close()
		}
	}
	q:(flag '= 1) ret
	
	s Data = ""
	s HDateTime = ""
	for {
		s HDateTime = $o(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HDateTime)) 
		q:(HDateTime = "") 
		
		s DateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(HDateTime)
		
		s Data = Data_$lb(DateTime)
	}
	
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	s:(Data '= "") Data = ##Class(EPRservice.Quality.CommonHelper).GetListToString(Data,"\")
	s ret = "1^"_Data
	q ret
}

/// Desc:	取可重复模板发生日期,多次用"\"分割;
/// Input: 	AEpisodeID    : 就诊号
/// 		ATitles       : StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
/// Output: ret = 发生日期
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDate("2482807","337|抢救记录\交班记录","","","","")
ClassMethod GetMultiTemHaDate(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %String
{
	s ret = "0^"
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	/*
	s flag=..CheckMultiTitleStartDate(AEpisodeID)  //只检查在可重复模板固定标题使用后入院的病历
	q:flag<0 ret
	*/
		
	s flag = 0
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","HappenDate",UniqueKey)
	
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles)
	{
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "")
		
		/*
		s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightMultiCatalog(EpisodeID,CatalogID)
		continue:(flag < 0)  //flag<0表示目录不符合检查条件
		*/
		
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		continue:(CategoryID = "")

		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		if (TitleList '= "")
		{
			for indSub = 1:1:$listlength(TitleList)
			{
				s Title = $listget(TitleList,indSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title)
				while(ds.Next())
				{
					s MultiDataInfo = ds.Data("MultiDataInfo")
					s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
					continue:(HappenDate = "")
					s HappenDate = $zd(HappenDate,3)
					s ^CacheTemp("EPRQuality","HappenDate",UniqueKey,HappenDate) = ""
				}
				d ds.Close()
			}
		} 
		else 
		{ 
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			while(ds.Next())
			{
				s MultiDataInfo = ds.Data("MultiDataInfo")
				s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
				continue:(HappenDate = "")
				s HappenDate = $zd(HappenDate,3)
				s ^CacheTemp("EPRQuality","HappenDate",UniqueKey,HappenDate) = ""
			}
			d ds.Close()
		}
	}
		
	q:(flag '= 1) ret
	
	s Data = ""
	s HDate = ""
	for {
		s HDate = $o(^CacheTemp("EPRQuality","HappenDate",UniqueKey,HDate)) 
		q:(HDate = "")
		
		s Date = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(HDate)
		s Date = $p(Date," ",1)
		
		s Data = Data_$lb(Date)
	}
	
	k ^CacheTemp("EPRQuality","HappenDate",UniqueKey)
	
	s:(Data '= "") Data = ##Class(EPRservice.Quality.CommonHelper).GetListToString(Data,"\")
	s ret="1^"_Data
	q ret
}

/// Desc: 	取可重复模板记录数量;
/// Input:	AEpisodeID    : 就诊号
/// 		ATitles       : 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
/// Output:	ret = 发生次数
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount("2482807","337|抢救记录\交班记录","","","","")
ClassMethod GetMultiTemReCount(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AIsEqual As %String = "N") As %String
{
	s ret = "0^", Count = 0
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	/*
	//只检查在可重复模板固定标题使用后入院的病历
	s flag = ..CheckMultiTitleStartDate(AEpisodeID)  
	q:(flag < 0) ret
	*/
	
	s flag = 0
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "")
		
		//判断可重复模板目录是否符合检查条件
		//s flag = ##Class(EPRservice.Quality.CheckRule.Category).IsRightMultiCatalog(AEpisodeID,StructID)
		//continue:(flag < 0)  
		
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		if (TitleList '= "")
		{
			for indSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,indSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title)
				While(ds.Next())
				{
					s MultiDataInfo = ds.Data("MultiDataInfo")
					s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
					s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
					continue:(HappenDate = "")||(HappenTime = "")
					
					//要求标题全匹配
					continue:(AIsEqual = "Y")&&($p(MultiDataInfo,$c(1),3)=Title)
					
					s Count = Count + 1
				}
				d ds.Close()
			}
		}
		else
		{
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			While(ds.Next())
			{
				s MultiDataInfo = ds.Data("MultiDataInfo")
				s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
				s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
				continue:(HappenDate = "")||(HappenTime = "")
				
				//要求标题全匹配
				continue:(AIsEqual = "Y")&&($p(MultiDataInfo,$c(1),3)=Title)
				
				s Count = Count + 1
			}
			d ds.Close()
		}
	}
	
	q:(flag '= 1) ret
	s ret = "1^"_Count
	q ret
}

/// Desc:	可重复模板标题升级后才能启用可重复模板相关的检查标准;
/// Input:	AEpisodeID为患者就诊号;
/// Return:	ret=-1:不检查; ret=1:检查;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).CheckMultiTitleStartDate("201865")
ClassMethod CheckMultiTitleStartDate(AEpisodeID As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRM.QualityParamsI("IdxCode","EPRMultiTitleStartDate",""))
	q:(RowID = "") ret
	
	s StartDate = $list($g(^DHCEPRM.QualityParamsD(RowID)),2)
	s StartDate = $tr(StartDate,"""","")
	q:(StartDate = "") ret
	
	s:(StartDate["-") StartDate = $zdh(StartDate,3)
	s:(StartDate["/") StartDate = $zdh(StartDate,4)
	s StartDate = +StartDate
	
	s AdmDate = +$p($g(^PAADM(AEpisodeID)),"^",6)
	s:(AdmDate - StartDate > 0) ret = 1
	q ret
}

/// Desc:	取可重复模板按发生日期计算的记录数
/// Input:	AEpisodeID	: 就诊号
/// 		ATitles		: StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题
/// 		AStartDate	: 开始日期 "2009-05-23"
/// 		AStartTime	: 开始时间 "21:32:10"
/// 		AEndDate	: 结束日期 "2009-05-23"
/// 		AEndTime	: 结束时间 "21:32:10"
/// Output:	返回%ArrayOfDataTypes, 其Key为发生日期时间，键值为对应日期书写的记录数
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiCountByHappenDate("2482807","337|抢救记录\交班记录","","","","")
ClassMethod GetMultiCountByHappenDate(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %ArrayOfDataTypes
{
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	
	q:(AEpisodeID = "")||(ATitles = "") retArray
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) retArray
	
	
	s flag = 0
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "")
		
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		continue:(CategoryID = "")
		
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		if (TitleList '= "")
		{
			for IndSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,IndSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title)
				While(ds.Next())
				{
					s MultiDataInfo = ds.Data("MultiDataInfo")
					s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
					s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
					continue:(HappenDate = "")||(HappenTime = "")
					
					s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDate) = $g(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDate)) + 1
				}
				d ds.Close()
			}
		}
		else
		{
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			While(ds.Next())
			{
				s MultiDataInfo = ds.Data("MultiDataInfo")
				s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期
				s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间
				continue:(HappenDate = "")||(HappenTime = "")
				
				s ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDate) = $g(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HappenDate)) + 1
			}
			d ds.Close()
		}
	}
	q:(flag '= 1) retArray
	
	
	s HDate = ""
	for {
		s HDate = $o(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HDate)) 
		q:(HDate = "") 
		
		s count = $g(^CacheTemp("EPRQuality","HappenDateTime",UniqueKey,HDate)) 
		d retArray.SetAt(count, HDate)
	}
	
	k ^CacheTemp("EPRQuality","HappenDateTime",UniqueKey)
	
	q retArray
}

/// Desc:根据病历操作日志的操作状态获取病历完成时间
/// Creator:Candyxu
/// Createdate:2013-01-16
/// Input:AEpisodeID 就诊号,APrintDocID 目录展现结构对应打印模板的ID, AEPRNum (唯一模板值为1,可重复模板值为记录号,AAction操作类型
/// OutPut:ActionTime 操作时间  格式 (日期^日间)
/// debug:w ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionTime(4,114,1,"提交")
ClassMethod GetEPRLogsActionTime(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String, AAction As %String) As %String
{
	s ActionTime = "" 
	q:((AEpisodeID = "")|| (APrintDocID = "") || (AEPRNum = ""))
	if (AAction = "完成")
	{
		s ActionTime = ..IsRecordFinished(AEpisodeID,APrintDocID,AEPRNum)
	}elseif (AAction = "提交")
	{
		s ActionTime = ..IsRecordCommited(AEpisodeID,APrintDocID,AEPRNum)
	}elseif (AAction = "打印")
	{
		s ActionTime = ..IsRecordPrinted(AEpisodeID,APrintDocID,AEPRNum)
	}
    
	q ActionTime
}

/// Desc:是否完成
/// Creator:Candyxu
/// CreateDate:2013-08-21
/// Input:AEpisodeID 就诊号,APrintDocID 目录展现结构对应打印模板的ID, AEPRNum (唯一模板值为1,可重复模板值为记录号
/// Output:病历完成的操作时间，没有完成为空
/// Debug: w ##Class(EPRservice.Quality.CheckRule.Course).IsRecordFinished(4,114,1)
ClassMethod IsRecordFinished(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")|| (APrintDocID = "") || (AEPRNum = ""))
	s logs = "", log = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	q:(logs = "") result
	
	s log = logs.GetFinalLog()
	q:(log = "") result
	q:($zcvt(log.FinalStatus,"U") = "UNFINISHED") result
	s count = logs.Log.Count()
	for i = count:-1:1 
	{
		s log = logs.Log.GetAt(i)
		continue:(log = "")
		if ($zcvt(log.FinalStatus,"U") = "FINISHED")
		{
		    s:(log.OperateDate'="") operDate = $ZD(log.OperateDate, 3)
  		    s:(log.OperateTime'="") operTime = $ZT(log.OperateTime, 1)
		    s result = operDate_"^"_operTime
		    q	
		}
	}
    q result
}

/// Desc:病历是否提交
/// Creator:Candyxu
/// CreateDate:2013-08-21
/// Input:AEpisodeID 就诊号,APrintDocID 目录展现结构对应打印模板的ID, AEPRNum (唯一模板值为1,可重复模板值为记录号
/// Output:病历提交的操作时间，没有完成为空
/// Debug:w ##Class(EPRservice.Quality.CheckRule.Course).IsRecordCommited(4,114,1)
ClassMethod IsRecordCommited(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")|| (APrintDocID = "") || (AEPRNum = ""))
	s logs = "", log = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	q:(logs = "") result
	
	s log = logs.GetFinalLog()
	q:(log = "") result
	
	q:($zcvt(log.FinalStatus,"U") = "UNFINISHED") result
	q:($zcvt(log.FinalStatus,"U") = "FINISHED") result
	s count = logs.Log.Count()
	for i = count:-1:1 
	{
		s log = logs.Log.GetAt(i)
		continue:(log = "") 
		if ($zcvt(log.FinalStatus,"U") = "COMMITED")
		{
		    s:(log.OperateDate'="") operDate = $ZD(log.OperateDate, 3)
  		    s:(log.OperateTime'="") operTime = $ZT(log.OperateTime, 1)
		    s result = operDate_"^"_operTime
		    q	
		}
	}
    q result
}

/// Desc:是否已经打印
/// Creator:Candyxu
/// CreateDate:2013-08-21
/// Input:AEpisodeID 就诊号,APrintDocID 目录展现结构对应打印模板的ID, AEPRNum (唯一模板值为1,可重复模板值为记录号
/// Output:病历第一次打印的操作时间，没有完成为空
/// Debug:w ##Class(EPRservice.Quality.CheckRule.Course).IsRecordPrinted(4,114,1)
ClassMethod IsRecordPrinted(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")|| (APrintDocID = "") || (AEPRNum = ""))
	s logs = "", log = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	q:(logs = "") result
	s count = logs.Log.Count()
	for i = 1:1:count 
	{
		s log = logs.Log.GetAt(i)
		continue:(log = "") 
		if ($zcvt(log.Action,"U") = "PRINT")
		{
		    s:(log.OperateDate'="") operDate = $ZD(log.OperateDate, 3)
  		    s:(log.OperateTime'="") operTime = $ZT(log.OperateTime, 1)
		    s result = operDate_"^"_operTime
		    q	
		}
	}
    q result
}

/// Desc:根据病历操作日志的操作状态获取病历完成数目
/// Creator:Candyxu
/// Createdate:2013-3-21
/// Input:AEpisodeID 就诊号,ATitle标题(多个用"\"分隔),AStartDate 开始日期,AStartTime 开始时间,AEndDate 结束日期,AEndTime结束时间
/// AStructID 模板对应质控结构ID,APrintDocID 目录展现结构对应打印模板ID,AAction 操作类型(完成,提交,打印)
/// OutPut:count|times 完成记录的数目|发生时间
/// debug:w ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(67,"",348,116,"提交")
ClassMethod GetEPRLogsActionCount(AEpisodeID As %String, ATitle As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AStructID As %String, APrintDocID As %String, AAction As %String) As %String
{
	s count = 0,actionTimes = ""
	s objStruct = $g(^DHCEPRM.QualityStructD(+AStructID))
	q:(objStruct = "") count
	s CategoryID = $list(objStruct,5)
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
	s TitleList = ""
	s:(ATitle '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitle,"\")
	if (TitleList '= "")
	{ 
	    for indSub = 1:1:$listlength(TitleList) 
	    {
		   s Title = $listget(TitleList,indSub)
		   continue:(Title = "")
	       d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title)
	       While(ds.Next())
	       {
	           s MultiDataInfo = ds.Data("MultiDataInfo")
		       s EPRNum = $p($p(MultiDataInfo,$c(1),2),"||",2)
		       s PDateTime = ..GetEPRLogsActionTime(AEpisodeID,APrintDocID,EPRNum,AAction)	
		       continue:(PDateTime = "")
		       s count = count + 1
		       s actionTimes = actionTimes_"\"_PDateTime
	       }
	    }
	}else
	{
	  d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
	  While(ds.Next())
	  {
	      s MultiDataInfo = ds.Data("MultiDataInfo")
		  s EPRNum = $p($p(MultiDataInfo,$c(1),2),"||",2)
		  s PDateTime = ..GetEPRLogsActionTime(AEpisodeID,APrintDocID,EPRNum,AAction)	
		  continue:(PDateTime = "")
		  s count = count + 1
		  s actionTimes = actionTimes_"\"_PDateTime
	   }		
	}
	q count_"|"_actionTimes
}

/// Desc:按日期类型取可重复模板数据
/// Creator:Candyxu
/// Createdate:2013-02-20
/// Input:	AEpisodeID    : 就诊号
/// 		ATitles       : 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
///         AIsEqual
///         ATimeType     : 按时间取数据（创建时间 C  发生时间 H  修改时间 M）
/// Output:	ret = 发生次数
/// Debug:w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(35,"348|日常病程记录",62860,41909,62870,62082,"N","C")	
ClassMethod GetMultiRecordByTimeType(AEpisodeID As %String, ATitles As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AIsEqual As %String = "N", ATimeType As %String = "H") As %String
{
	s ret = "0^", Count = 0
	q:(AEpisodeID = "")||(ATitles = "") ret
	q:($d(AEpisodeID) = 0)||($d(ATitles) = 0) ret
	
	s flag = 0
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	for Ind = 1:1:$listlength(lstTitles) {
		s ArrTitle = $listget(lstTitles,Ind)
		s StructID = $p(ArrTitle,"|",1)
		s Titles = $p(ArrTitle,"|",2)
		continue:(StructID = "") 
		
		s TitleList = "", flag = 1
		s:(Titles '= "") TitleList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Titles,"\")
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataByTimeFlag")
		if (TitleList '= "")
		{
			for indSub = 1:1:$listlength(TitleList) {
				s Title = $listget(TitleList,indSub)
				continue:(Title = "")
				
				d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,Title,ATimeType)
				While(ds.Next())
				{
					s MultiDataInfo = ds.Data("MultiDataInfo")
                    s TempDate = "",TempTime = ""
                    if ($Zcvt(ATimeType,"U") = "C")   //创建时间
                    {
	                    s TempDate = $p(MultiDataInfo,$c(1),4)
	                    s TempTime = $p(MultiDataInfo,$c(1),5)
	                } elseif($zcvt(ATimeType,"U")= "H")    //发生时间
	                {
		                s TempDate = $p(MultiDataInfo,$c(1),9)
	                    s TempTime = $p(MultiDataInfo,$c(1),10)
	                
		            }                 
					continue:(TempDate = "")||(TempTime = "")
					
					//要求标题全匹配
					continue:(AIsEqual = "Y")&&($p(MultiDataInfo,$c(1),3)=Title)
					
					s Count = Count + 1
				}
				d ds.Close()
			}
		}
		else
		{
			d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
			While(ds.Next())
			{
				s MultiDataInfo = ds.Data("MultiDataInfo")
	            s TempDate = "",TempTime = ""
                if ($Zcvt(ATimeType,"U") = "C")   //创建时间
                {
	               s TempDate = $p(MultiDataInfo,$c(1),4)
	               s TempTime = $p(MultiDataInfo,$c(1),5)
	            } elseif($zcvt(ATimeType,"U")= "H")    //发生时间
	            {
		           s TempDate = $p(MultiDataInfo,$c(1),9)
	               s TempTime = $p(MultiDataInfo,$c(1),10)
	                
		        }                   
			    continue:(TempDate = "")||(TempTime = "")
				
				//要求标题全匹配
				continue:(AIsEqual = "Y")&&($p(MultiDataInfo,$c(1),3)=Title)
				
				s Count = Count + 1
			}
			d ds.Close()
		}
	}
	
	q:(flag '= 1) ret
	s ret = "1^"_Count
	q ret
}

/// Desc: 	记录时间与发取可重复模板记录数量;LFB
/// Input:	AEpisodeID    : 就诊号
/// 		ATitles       : 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
/// Output:	ret = 发生次数
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal("2482807","337","","","","")
/// ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal(4,817,63249,"66300",63250,"81408","E6381\E6394\E6407",48)
/// ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal(4,817,63210,"66211",63250,"81408","E6381\E6394\E6407",48)
/// ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal(4,817,63249,"66300",63250,"81408","E6381\E6394\E6407",48)
ClassMethod GetMultiTimeIllegal(AEpisodeID As %String, AStructID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AElements As %String, AHour As %String = 48) As %String
{
	s ret = "0^", Count = 0,errorInfo=" "
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	
	s flag = 0
	s lstStructIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AStructID,"#")
	for Ind = 1:1:$listlength(lstStructIDs) {
		
		s StructID =  $listget(lstStructIDs,Ind)
		continue:(StructID = "")
		
		
		s flag = 1
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		
		d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
	
		While(ds.Next())
		{
			s MultiDataInfo = ds.Data("MultiDataInfo")
			s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期   sys
			s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间	sys
			
			continue:(HappenDate = "")||(HappenTime = "")
				
			s InstanceDataID=$p(MultiDataInfo,$c(1),2)   //InstancedataID
			s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElements,InstanceDataID)
	   		
	   		s ElementData = ^CacheTemp("EPRQualityTplValue")
	   		
	  		k ^CacheTemp("EPRQualityTplValue") 
	     
	   		//将多个对象转换为字符串 多个日常兼容 
	   		s ElementData =##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"#","Y")
			
			//转换为系统时间格式
			s ElementData=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData)
			
			//计算时间差值
			//w ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap("63169 58532","63169 58531")
			//时间存在空值不判断返回 0
			s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(HappenDate_" "_HappenTime,ElementData)
			
			//判定时间差是否大于 AHour
			continue:(timeGap<=AHour)
				
			s Count = Count + 1
			s errorInfo=errorInfo_$zd(HappenDate,3)_" "_$zt(HappenTime,1)_","
		}
		d ds.Close()
	}

	q:(flag '= 1) ret
	s ret = "1^"_Count_"^"_errorInfo
	q ret
}

/// Desc: 	日常病程内容少于20个字，且创建超过24小时提示
/// Input:	AEpisodeID    : 就诊号
/// 		ATitles       : 格式(质控结构ID|模板标题\模板标题#质控结构ID|模板标题\模板标题)
/// 		AStartDate    : 开始日期 "2009-05-23"
/// 		AStartTime    : 开始时间 "21:32:10"
/// 		AEndDate      : 结束日期 "2009-05-23"
/// 		AEndTime      : 结束时间 "21:32:10"
/// Output:	ret = 发生次数
/// ##Class(EPRservice.Quality.CheckRule.Course).GetMultiContentIllegal(4,817,63249,"66300",63250,"81408","E6379\E6392\E6405",20)
/// ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal(4,817,63249,"66300",63250,"81408","E6381\E6394\E6407",48)
ClassMethod GetMultiContentIllegal(AEpisodeID As %String, AStructID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AElements As %String, AWordCount As %String = 20) As %String
{
	s ret = "0^", Count = 0,errorInfo=" "
	q:(AEpisodeID = "")||(AStructID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AStructID) = 0) ret
	
	
	s flag = 0
	s lstStructIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AStructID,"#")
	for Ind = 1:1:$listlength(lstStructIDs) {
		
		s StructID =  $listget(lstStructIDs,Ind)
		continue:(StructID = "")
		
		
		s flag = 1
		
		s objStruct = $g(^DHCEPRM.QualityStructD(+StructID))
		s IsActive = $list(objStruct,8)
		continue:($zcvt(IsActive,"U") '= "Y")
		
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		
		d ds.Execute(AEpisodeID,CategoryID,AStartDate,AStartTime,AEndDate,AEndTime,"")
		//d ds.Execute(AEpisodeID,CategoryID,63211,"53364",63249,"82978","")
		While(ds.Next())
		{
			
			s MultiDataInfo = ds.Data("MultiDataInfo")
			s HappenDate = $p(MultiDataInfo,$c(1),7)   //发生日期   sys
			s HappenTime = $p(MultiDataInfo,$c(1),8)   //发生时间	sys
			
			continue:(HappenDate = "")||(HappenTime = "")
			//增发生时间与当前时间不足24小时不检查
			continue:(HappenDate+1>+$h)||((HappenDate+1=+$h)&&(HappenTime>$p($h,",",2)))
			s InstanceDataID=$p(MultiDataInfo,$c(1),2)   //InstancedataID
			//病历可重复模板数据E单元
			//##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(14766325,"E6379\E6392\E6405","11394958||1")
			s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElements,InstanceDataID)

	     	
	     	s WordCount=$l($tr(ElementData," ",""))
		    continue:( WordCount > AWordCount )
		    //根据回车换行判断字数
		    			
			s Count = Count + 1
			s errorInfo=errorInfo_$zd(HappenDate,3)_" "_$zt(HappenTime,1)_","
		}
		d ds.Close()
	}

	q:(flag '= 1) ret
	s ret = "1^"_Count_"^"_errorInfo
	q ret
}

}
