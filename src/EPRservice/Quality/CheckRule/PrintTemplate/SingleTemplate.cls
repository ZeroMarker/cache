/// Desc: 对唯模板的质控
/// Creator:Candyxu
/// Createdate:
Class EPRservice.Quality.CheckRule.PrintTemplate.SingleTemplate Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Desc:判断一组PrintDocID是否完成 AAction(操作类型，比如完成，提交，打印)操作
/// Creator:Candyxu
/// Createdate:2013-03-18
/// Input:AEpisodeID 就诊号
///       ADocIDs 目录展现结构ID对应打印模板ID,多个以"^"分隔
///       AAction 操作类型(完成,提交,打印)
/// Output:tempTime 操作时间
ClassMethod GetCategoryOPTime(AEpisodeID As %String, ADocIDs As %String, AAction As %String) As %String
{
	s tempTime = ""
	q:((AEpisodeID = "")||(ADocIDs = "")||(AAction = "")) tempTime
    s lstdocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADocIDs,"^","Y")
    for ind = 1:1:$listlength(lstdocID)
    {
	    s tempdocID = $listget(lstdocID,ind)
	    s tempTime = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionTime(AEpisodeID,tempdocID,1,AAction)
	    q:( tempTime '= "") 
	}
	q tempTime
}

/// Desc:判断打印模板是否按操作类型完成
/// Creator:Candyxu
/// CreateDate:2013-03-18
/// Input:AEpisodeID 就诊号
///      ADocIDs 目录展现结构ID对应打印模板ID,多个以"^"分隔
///      AAction 操作类型(完成,提交,打印)
///      ALocIDs 不需要检查的科室以"^"分隔
/// return:ret 0 异常，-1 不满足 1 满足
/// Debug: w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.SingleTemplate).IsDoneCategory0(67,166,"提交")
ClassMethod IsDoneCategory0(AEpisodeID As %String, ADocIDs As %String, AAction As %String, ALocIDs As %String = "") As %String
{
    s ret = "0^配置错误"
    q:((AEpisodeID = "")||(ADocIDs = "")||(AAction = "")) ret
    if (ALocIDs '= "")  //判断的在科室
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)   //患者当前所在科室
		if (curAdmitLocID = "") q ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0) q ret = "1^患者当前所在科室不采用该质控项目!"	
	}
	s ret = 1
    s tempTime = ..GetCategoryOPTime(AEpisodeID,ADocIDs,AAction)
	s:(tempTime = "") ret = -1
   q ret
}

/// Desc:判断打印模板是否按操作类型完成在规定时效内完成(超时完成合格);
/// Creator:Candyxu
/// CreateDate:2013-03-18
/// Input:AEpisodeID 就诊号
///      ADocIDs 目录展现结构ID对应打印模板ID,多个以"^"分隔
///      AAction 操作类型(完成,提交,打印)
///      ARuleType 质控类型(B：提示)
///      ALocIDs 不需要检查的科室以"^"分隔
/// return:ret 0 异常，-1 不满足 1 满足
/// Debug: w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.SingleTemplate).IsDoneCategory1(67,166,time,hour,"提交","")
ClassMethod IsDoneCategory1(AEpisodeID As %String, ADocIDs As %String, ADateTime As %String, AHours As %String, AAction As %String, ARuleType As %String, ALocIDs As %String = "")
{
    s ret = "0^配置错误"
    q:((AEpisodeID = "")||(ADocIDs = "")||(AAction = "")||(ADateTime = "")||(AHours = "")) ret
    s CurrentTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)		// Format: 2010-06-17 09:38
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(CurrentTime,ADateTime)
	q:(tmpHours < 0) ret
	s ret = 1
	s AHours = +AHours
	q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) ret
	if (ALocIDs '= "")  //判断的在科室
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)   //患者当前所在科室
		if (curAdmitLocID = "") q ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0) q ret = "1^患者当前所在科室不采用该质控项目!"	
	}
	s tempTime = ..GetCategoryOPTime(AEpisodeID,ADocIDs,AAction) 
	s Interval = $j(tmpHours - AHours,1,1) 
	s:((tempTime = "")&&(AHours > tmpHours)) ret = "-1^请在"_-Interval_"小时内完成病历!"  
	s:((tempTime = "")&&(AHours < tmpHours)) ret = "-1^超"_Interval_"小时未完成!"
   q ret
}

/// Desc:判断打印模板是否按操作类型完成在规定时效内完成(超时完成不合格);
/// Creator:Candyxu
/// CreateDate:2013-03-18
/// Input:AEpisodeID 就诊号
///      ADocIDs 目录展现结构ID对应打印模板ID,多个以"^"分隔
///      AAction 操作类型(完成,提交,打印)
///      ARuleType 质控类型(B：提示)
///      ALocIDs 不需要检查的科室以"^"分隔
/// return:ret 0 异常，-1 不满足 1 满足
/// Debug: w ##Class(EPRservice.Quality.CheckRule.PrintTemplate.SingleTemplate).IsDoneCategory2(67,166,time,hour,"提交","B")
ClassMethod IsDoneCategory2(AEpisodeID As %String, ADocIDs As %String, ADateTime As %String, AHours As %String, AAction As %String, ARuleType As %String, ALocIDs As %String = "")
{
	s ret = "0^配置错误"
	q:((AEpisodeID = "")||(ADocIDs = "")||(AAction = "")||(ADateTime = "")||(AHours = "")) ret
    s CurrentTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)		// Format: 2010-06-17 09:38
	s tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(CurrentTime,ADateTime)
	q:(tmpHours < 0) ret
	s ret = 1
	s AHours = +AHours
	q:((AHours > tmpHours) && ($zcvt(ARuleType,"U") '= "B")) ret
	if (ALocIDs '= "")  //判断的在科室
	{
		s curAdmitLocID = $p($g(^PAADM(AEpisodeID)),"^",4)   //患者当前所在科室
		if (curAdmitLocID = "") q ret = "0^患者当前不属于任何一个科室,质控项目异常退出!"
		s locIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,"^","Y")
		if ($listfind(locIDs,curAdmitLocID) > 0) q ret = "1^患者当前所在科室不采用该质控项目!"	
	}
    s tempTime = ..GetCategoryOPTime(AEpisodeID,ADocIDs,AAction)
    s:(tempTime '= "") tmpHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tempTime,ADateTime)
	s Interval = $j(tmpHours - AHours,1,1) 
	s:((tempTime = "")&&(AHours > tmpHours)) ret = "-1^请在"_-Interval_"小时内完成病历!"  
	s:((tempTime = "")&&(AHours < tmpHours)) ret = "-1^超"_Interval_"小时未完成!"
	s:((tempTime '= "")&&(AHours < tmpHours)) ret = "-1^超"_Interval_"小时完成!"
   q ret
}

}
