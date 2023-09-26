/// Desc:对可重复模板的质控
/// Creator:Candyu
/// Createdate:2013-03-21
/// 001-099 时限性判断
/// 100-199 完整性判断
/// 200-299 一致性判断
Class EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 时限性判断********************************************************************************************************
/// Desc:可重复模板记录是否在规定的时间内完成(不到时限出院不质控)
///      如：入院48小时无上级医师查房记录
/// Creator:Candyu
/// Createdate:2013-03-21
/// Input：AEpisodeID:就诊号
///        ATitles:StructID|printDocID|可重复模板标题\可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	 
///        ARegDateTime:开始日期,ADisDateTime:结束日期,AHours:多少小时内完成
/// 	   AAction:操作类型(完成,提交,打印)
///        ARuleType 质控类型(B：提示)
/// OutPut：ret<0 不一致
/// Debug：	w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord001(69,"348|116|住院医师查房记录","2013-03-22 14:46:34","",2,"提交","b")
ClassMethod IsDoneRecord001(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, AHours As %String, AAction As %String, ARuleType As %String = "") As %String
{
	s ret = "0^配置错误"
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(AHours = "")||(AAction = "")) ret
	s structID = $p(ATitles,"|",1)
	s printDocID = $p(ATitles,"|",2)
	q:((structID = "")||(printDocID = "")) ret 
	s titles = $p(ATitles,"|",3)
	
	s ret = 1
	s AHours = +AHours
	s checkDateTime = $g(ADisDateTime)
	s:(checkDateTime = "") checkDateTime = $tr($h,","," ")
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime)
	q:((AHours > tmpTimeGap)&&($zcvt(ARuleType,"U") '= "B"))   //如果不是提示标准,不到时间不质控
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,titles,"","","","",structID,printDocID,AAction)
	s count = $p($g(result),"|",1)
	//没有完成
	if ((count <1)&&(AHours > tmpTimeGap)) {s ret = "-1^请在"_ $j(AHours - tmpTimeGap,1,1)_"小时内完成"_titles  q ret}
	if ((count <1)&&(AHours < tmpTimeGap)) {s ret = "-1^超"_ $j(tmpTimeGap - AHours,1,1) _"小时未完成"_titles q ret}		
	s times = $p($g(result),"|",2)
	//超时完成
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(times,"\")
	for ind = 1:1:$listlength(timeList)
	{
		s tempDateTime = $listget(timeList,ind)
		s tempDate = $p(tempDateTime,"^",1)
		continue:(tempDate ="")
		s tempTime = $p(tempDateTime,"^",2)
		s dateTime = $zd(tempDate,3)_" "_$zt(tempTime)
		s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime,ARegDateTime)
		q 
	}
	s:((AHours < timeGap)) ret = "-1^超"_ $j(timeGap - AHours,1,1)_"小时完成"_titles
	q ret
}

/// Desc:可重复模板记录是否在规定的时间内完成
///      如:判断抢救记录是否在抢救后6小时内完成 
/// Creator:Candyu
/// Createdate:2013-03-29
/// Input：AEpisodeID:就诊号
///        ATitles:StructID|printDocID|可重复模板标题\可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	 
///        ADateTimes:用"\"分隔的日期串,AHours:多少小时内完成
/// 	   AAction:操作类型(完成,提交,打印)
///        ARuleType 质控类型(B：提示)
/// OutPut：ret<0 不一致
/// Debug：	w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord002(69,"348|116|住院医师查房记录","2013-03-22 14:46:34",2,"提交","b")
ClassMethod IsDoneRecord002(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, AHours As %String, AAction As %String, ARuleType As %String = "") As %String
{
	s ret = "0^配置错误",errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(AHours = "")||(AAction = "")||(ADateTimes = "")) ret
	s structID = $p(ATitles,"|",1)
	s printDocID = $p(ATitles,"|",2)
	q:((structID = "")||(printDocID = "")) ret 
	s titles = $p(ATitles,"|",3)
	
	s ret = 1
	s AHours = +AHours
	s checkDateTime = $tr($h,","," ")
	
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTime,"\")
	s addDate = (+AHours * 3600)\86400
	s addTime = (+AHours * 3600)#86400
	for ind = 1:1:$listlength(timeList)
	{
		s tempDateTime = $listget(timeList,ind)
		s tempDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tempDateTime)
		s tempDate = $p(tempDateTime," ",1)
		continue:(tempDate ="")
		s tempTime = $p(tempDateTime," ",2)
		//是否到质控时间
		s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,tempDate_" "_tempTime)
		continue:((+tempGap < AHour) && (ARuleType '= "B")) //如果不是提示标准,不到时间不质控
	    s tempResult = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,titles,tempDate,tempTime,tempDate+addDate,tempTime+addTime,structID,printDocID,AAction)
	    continue:($p($g(tempResult),"|",1)>0)
	    if (+tempGap < AHours)
	    {
	        s errInfo = errInfo_" "_title2_"需要在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！" 
	    }else
	    {
		    s errInfo = errInfo_" "_title2_"未在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！"
		}
	    s count = count + 1
	} 
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// Desc:	交班记录后x小时内未完成接班记录 多次评分
///     	转科记录后x小时内未完成接收记录
///         ......小时内未完成......
/// Creator:Candyxu
/// Createdate:2013-03-27
/// Input: AEpisodeID 就诊号
///       ATitle1 StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	  
///       ATitle2 StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	 
///       ADisDateTime 出院时间,AHour x小时
///       AAction 操作类型,ARuleType 质控类型 (B提示)
/// Debug:w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord003(69,"348|116|日常病程","348|116|阶段小结","",24,"提交","B")
ClassMethod IsDoneRecord003(AEpisodeID As %String, ATitle1 As %String, ATitle2 As %String, ADisDateTime As %String, AHour As %String, AAction As %String, ARuleType As %String) As %String
{
	s ret = "0^配置错误", errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitle1 = "")||(ATitle2 = "")||(AHour = "")||(AAction = "")) ret
    s checkDateTime = $g(ADisDateTime)
    s:(checkDateTime = "") checkDateTime = $tr($h,","," ")
  
    s structID1 = $p(ATitle1,"|",1)
    s printDocID1 = $p(ATitle1,"|",2)
    s title1 = $p(ATitle1,"|",3)
    s structID2 = $p(ATitle2,"|",1)
    s printDocID2 = $p(ATitle2,"|",2)
    s title2 = $p(ATitle2,"|",3) 
    q:((structID1 = "")||(printDocID1 = "")||(structID2 = "")||(printDocID2 = "")) ret
     
    s ret = 1 
    s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title1,"","","","",structID1,printDocID1,AAction)
    q:(+$p($g(result),"|",1)<=0) ret
    
  	s times = $p($g(result),"|",2)
	s timeList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(times,"\") 
	s addDate = (+AHour * 3600)\86400
	s addTime = (+AHour * 3600)#86400
	for ind = 1:1:$listlength(timeList)
	{
		s tempDateTime = $listget(timeList,ind)
		s tempDate = $p(tempDateTime,"^",1)
		continue:(tempDate ="")
		s tempTime = $p(tempDateTime,"^",2)
		//是否到质控时间
		s tempGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,tempDate_" "_tempTime)
		continue:((+tempGap < AHour) && (ARuleType '= "B"))
	    s tempResult = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title2,tempDate,tempTime,tempDate+addDate,tempTime+addTime,structID2,printDocID2,AAction)
	    continue:($p($g(tempResult),"|",1)>0)
	    if (+tempGap < AHour)
	    {
	        s errInfo = errInfo_" "_title2_"需要在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！" 
	    }else
	    {
		    s errInfo = errInfo_" "_title2_"未在"_$zd(tempDate+addDate,3)_" "_$zt(tempTime+addTime)_"前完成！"
		}
	    s count = count + 1
	} 
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// 完整性判断*******************************************************************************************************
/// Desc:检查缺少几天一次的可重复模板记录(多次评分)
///      如：缺少三天一次的病程记录
/// Creator:Candyxu
/// Created:2013-01-16
/// Input:AEpisodeID:就诊号
///       ATitles:StructID|printDocID|可重复模板标题\可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)
///       ARegDateTime:入院时间,ADisDateTime:出院时间,ADays:几天一次
///       AAction:操作类型(完成,提交,打印)
/// Output: ret -1 触犯^提示信息^触犯次数
/// debug:w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord100(69,"348|住院医师查房记录","2013-03-22 14:46:34","",100,116,"提交")
ClassMethod IsDoneRecord100(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, AAction As %String) As %String
{
	s ret = "0^配置错误", errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")||(AAction = "")) ret
    s structID = $p(ATitles,"|",1)
    s printDocID = $p(ATitles,"|",2)
    q:((structID = "")||(structID = "")) ret
    s titles = $p(ATitles,"|",3)
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	
	s ret = 1
	f tmpDate = fromDate:$g(ADays):toDate 
	{
	  s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,titles,tmpDate,fromTime,tmpDate+ADays,checkTime,structID,printDocID,AAction)
	  s Tempcount = $p($g(result),"|",1)
	  continue:(Tempcount > 0) 
	  s count = count + 1
	  s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// Desc:判断告病重、告病危是否写病重、病危知情同意书(根据医嘱判断知情同意书)
/// 规则：病危患者下病危医嘱后30分钟写病危知情同意书，下病重医嘱后2小时内写病重同意书。
///      如果在一个小时内下过病危医嘱则不必写病重同意书
/// Creator:Candyxu
/// Createdate:2013-3-28
/// Input:AEpisodeID 就诊号,AOrdItems 判断的医嘱
///       ATitle StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	
///       AAction 取什么的操作时间(打印,提交,完成)
///       ATerminallyIll 病危医嘱项，当检查病重医嘱时需要检查是否下过病危医嘱
/// OutPut: -1 触犯条目,1条目检查通过
/// Debug:w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord101("4389","7791||1","抢救记录","346",559,"打印",30)
ClassMethod IsDoneRecord101(AEpisodeID As %String, AOrdItems As %String, ATitle As %String, AAction As %String, AMinutes As %String, ATerminallyIll As %String = "") As %String
{
	s ret = "0^系统配置错误"
	q:((AEpisodeID = "")||(AOrdItems = "")||(ATitle = "")||(AAction = "")||(AMinutes = "")) ret
	s structID = $p(ATitle,"|",1)
	s printDocID = $p(ATitle,"|",2)
	s title = $p(ATitle,"|",3)
	q:((structID = "")||(PrintDocID = "")) ret
	s ret = 1
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		//如果是病重医嘱，判断一个小时内是否下过病危医嘱，如果下过则不用写病重同意书
		if (ATerminallyIll '= "")
		{
		   s Flag = -1
		   s dsTerminallyIll = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
		   d dsTerminallyIll.Execute(AEpisodeID,ATerminallyIll,"","Y")
		   while(dsTerminallyIll.Next())
		   {
			   s TerminallyIllIDate = dsTerminallyIll.Data("IDate")
			   s TerminallyIllITime = dsTerminallyIll.Data("ITime")
			   if ((OrderIDate = TerminallyIllIDate) && (OrderITime - TerminallyIllITime <= 3600))
			   {
				   s Flag = 1
				   q
			   }
		   } 
		   q:(Flag = 1)
		}
		//是否按时写模板
		s count = 0
		s objStruct = $g(^DHCEPRM.QualityStructD(+structID))
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		d ds.Execute(AEpisodeID,CategoryID,"","","","",title)
		While(ds.Next())
		{
		    s MultiDataInfo = ds.Data("MultiDataInfo")
		    s EPRNum = $p($p(MultiDataInfo,$c(1),2),"||",2)
		    // 取历史记录的操作时间
		    s PDateTime = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionTime(AEpisodeID,printDocID,EPRNum,AAction)	
		    continue:(PDateTime = "")
		    s EPRDate = $p(PDateTime,"^",1)
		    s EPRTime = $p(PDateTime,"^",2)
		    if ((EPRDate = SttDate) && ((EPRTime - SttTime)/60 <= AMinutes))
		    {
			    s ret = 1
			    s count = count +1
			    q
			}
			
		}
		s:(count = 0) ret = -1
		q:(ret = -1)
	}
	q ret
}

/// Desc:病危、病重患者可重复模板数据判断(几天写一次)
/// Creator: Candyxu
/// Createdate:2013-03-28
/// Input:AEpisodeID 就诊号,AOrdItems 医嘱项
///       ATitles StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	
///       ADays 天数,AAction(提交,打印,完成)
/// Output:ret_"^"_errInfo_"^"_count 是否触犯(1:没有, 2:触发)^错误提示^触发次数
ClassMethod IsDoneRecord102(AEpisodeID As %String, AOrdItems As %String, ATitle As %String, ADays As %String, AAction As %String) As %String
{
	s ret = "0^系统配置错误",errInfo = "",count = 0
	q:((AEpisodeID = "")||(AOrdItems = "")||(ADays = "")||(AAction = "")) ret
	
	s structID = $p(ATitle,"|",1)
	s printDocID = $p(ATitle,"|",2)
	s title = $p(ATitle,"|",3)
	q:((structID = "")||(printDocID = "")) ret
	
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		s OrderDDate = dsOrder.Data("DDate")   //停止日期
		s:(OrderDDate = "") OrderDDate = $p($h,",",1)
		s OrderDTime = dsOrder.Data("DTime")   //停止时间
		s:(OrderDTime = "") OrderDTime = $p($h,",",2)
		s tepResult = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title,OrderIDate-2,OrderITime,OrderIDate,OrderITime,structID,printDocID,AAction)
		s:($p(tepResult,"|",1) <= 0) errInfo = errInfo_" 缺少"_$zd(OrderIDate,3)_"的一次记录!",OrderIDate = OrderIDate + ADays
	    f tmpDate = OrderIDate:$g(ADays):OrderDDate 
	    {
	       s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title,tmpDate,OrderITime,tmpDate+ADays,OrderDTime,structID,printDocID,AAction)	
	       continue:(+$p(result,"|",1) > 0) 
	       s count = count + 1
	       s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	    }	
	}
	if (count > 0) {s ret = -1}else{s ret =1}
	q ret_"^"_errInfo_"^"_count
}

/// Desc:根据下医嘱时间判断输写病历记录，一天不管下几次医嘱，只需要写一次记录
///      (如：输血记录，无论当天输血了多少次或者输的什么，一天只要有一次记录就可以)
/// Creator:Candyxu
/// Createdate:2013-03-28
/// Input:AEpisodeID 就诊号，AOrdItemsTime 下医嘱时间(使用公共函数)
///       ATitles StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)	
///       AAction (提交,打印,完成)
/// OutPut:ret_"^"_errInfo_"^"_count  状态_"^"_错误信息_"^"_触犯次数
ClassMethod IsDoneRecord103(AEpisodeID As %String, AOrdItemsTime As %String, ATitles As %String, AAction As %String) As %String
{
	s ret = "0^系统配置错误",errInfo = "",count = 0
	q:((AEpisodeID = "")||(AOrdItemsTime = "")||(ATitles = "")||(AAction = "")) ret
	
	s structID = $p(ATitles,"|",1)
	s printDocID = $p(ATitles,"|",2)
	s title = $p(ATitles,"|",3)
    q:((structID = "")||(printDocID = "")) ret
    
	s DateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AOrdItemsTime,"\")
	q:(DateTimes = "") ret
	s ret = 1
	s TempDate = "" 
	for i = 1:1:$listlength(DateTimes)
	{
		continue:(TempDate = $p($ListGet(DateTimes,i)," ",1))
		s TempDate = $p($ListGet(DateTimes,i)," ",1)
		s TempTime = $p($ListGet(DateTimes,i)," ",2)
		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title,TempDate,TempTime,TempDate+1,TempTime,structID,printDocID,AAction)
		s:($p(result,"|",1) <= 0) errInfo = errInfo_" 缺少"_$ZD(TempDate)_"的一次记录",ret = -1,count = count + 1
	}
    q ret_"^"_errInfo_"^"_count
}

/// Desc:检查从某时间开始X天内,每Y天至少一次的可重复模板记录
///      如:检查术后三天连续病程记录
/// Creator:Candyxu
/// Createdate:2013-03-28
/// Input:AEpisodeID 就诊号
///       ATitles StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)
///       ADateTimes 开始时间
///       ADischDateTime 出院时间,AXDays 多少天内,AYDays 每多少天内至少一次,AAction 操作类型(完成,打印,提交)
/// OutPut:ret_"^"_errInfo_"^"_count  状态_"^"_错误信息_"^"_触犯次数
/// 调试: w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.MultipleTemplate).IsDoneRecord104(67,"日常病程","2013-03-25 00:00:00","",3,1,"提交")
ClassMethod IsDoneRecord104(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, ADischDateTime As %String, AXDays As %String, AYDays As %String, AAction As %String) As %String
{
	s ret = "0^系统配置错误"
	q:((AEpisodeID="")||(ATitles="")||(ADateTimes="")||(AXDays = "")||(AYDays = "")||(AAction = "")) ret
	
	s structID = $p(ATitles,"|",1)
	s printDocID = $p(ATitles,"|",2)
	s titles = $p(ATitles,"|",3)
    q:((structID = "")||(printDocID = ""))
		
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(dischDateTime," ",1)
	s AXDays = +AXDays ,AYDays = +AYDays
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	
	s ret = 1
	for Ind=1:1:$listlength(dateTimes)
	{
	    s dateTime = $listget(dateTimes,Ind)
	    s dateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	    continue:(dateTime = "")
	    s fromDate = $p(dateTime," ",1) + 1,fromTime = 0,toDate = fromDate + AXDays, toTime = 0
		s:((checkDate '= "")&&( toDate > checkDate)) toDate = checkDate   //当出院时间大于要检查的日期时
        for tmpDate = fromDate:$g(AYDays):toDate
        {
	        s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,titles,tmpDate,fromTime,tmpDate+AYDays,toTime,structID,printDocID,AAction)
	        s Tempcount = $p($g(result),"|",1)
	        continue:(Tempcount > 0) 
	        s count = count + 1
	        s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+AYDays-1,3)_"的一次记录!"
	    }
	}
    s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// 一致性判断*******************************************************************************************************
/// Desc:交班病人接班记录数与接班记录数不一致 (可重复模板数一致性检查)
///     .....与.....不一致
/// Creator:Candyxu
/// Createdate:2013-03-27
/// Input: AEpisodeID 就诊号 
///       ATitles1 StructID|printDocID|可重复模板标题\可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)
///       ATitles2 StructID|printDocID|可重复模板标题\可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)
///       AAction:操作类型(完成,提交,打印)
/// OutPut:ret 1满足,-1不满足,0配置错误
ClassMethod IsDoneRecord200(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, AAction As %String) As %String
{
	s ret = "0^配置错误"
	q:((AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "")||(AAction = "")) ret
	s structID1 = $p(ATitles1,"|",1)
    s printDocID1 = $p(ATitles1,"|",2)
    s title1 = $p(ATitles1,"|",3)
    s structID2 = $p(ATitles2,"|",1)
    s printDocID2 = $p(ATitles2,"|",2)
    s title2 = $p(ATitles2,"|",3) 
    q:((structID1 = "")||(printDocID1 = "")||(structID2 = "")||(printDocID2 = "")) ret
    s ret = 1
    s result1 = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title1,"","","","",structID1,printDocID1,AAction)
    s count1 = $p(result1,"|",1)
    s result2 = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title2,"","","","",structID2,printDocID2,AAction)
    s count2 = $p(result2,"|",1)
    s:(count1 '= count2) ret = -1
    q ret
}

/// Desc:转科表转科次数与转科记录次数不一致 (his和可重复模板数一致性检查)
///     抢救医嘱数与抢救记录次数不一致
///     .....与.....不一致
/// Creator:Candyxu
/// Createdate:2013-03-27
/// Input: AEpisodeID 就诊号 
///       AHISCount his的记录数，通常可以由公共函数获得
///       ATitle StructID|printDocID|可重复模板标题(StructID:结构ID,printDocID:目录展现结构对应打印模板ID)
///       AAction:操作类型(完成,提交,打印)
/// Output:ret 1满足,-1不满足,0配置错误
ClassMethod IsDoneRecord201(AEpisodeID As %String, AHISCount As %String, ATitle As %String, AAction As %String) As %String
{
	s ret = "0^配置错误"
	q:((AEpisodeID = "")||(AHISCount = "")||(ATitle = "")||(AAction = "")) ret
	s structID = $p(ATitle,"|",1)
    s printDocID = $p(ATitle,"|",2)
    s title = $p(ATitle,"|",3)
    q:((structID = "")||(printDocID = "")) ret
    
    s ret = 1
    s result = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionCount(AEpisodeID,title,"","","","",structID,printDocID,AAction)
    s count = $p(result1,"|",1)
    s:(+AHISCount '= +count2) ret = -1
    q ret
}

}
