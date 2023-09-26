/// 类名: web.eprajax.reference.refjournal
/// 描述: 取得患者病历引用操作日志
/// 编写者: Kumon Xie
/// 编写日期: 2011-05-29
Class web.eprajax.reference.refjournal Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//获取从前端传过来的参数
	s refType = $g(%request.Data("RefType",1),"-1")
	//s action = $g(%request.Data("Action",1),"-1")
	s userID = $g(%request.Data("UserID",1),"-1")
	s episodeID = $g(%request.Data("EpisodeID",1),"-1")
	
	//s ^CacheTemp("EPRReference","web.eprajax.reference.refjournal","Parameters") = refType_"^"_episodeID_"^"_userID
	
	w "["
	
	w ..GetEpisodeRefLogs(refType,episodeID,userID)
	
	w "]"
	
	q $$$OK
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-15
/// Description:获取历次就诊病历引用日志	
/// Table:		无
/// Input:		AType为病历引用类型(Single:唯一模板病历引用;Multiple:历次模板病历引用)
/// 			AEpsiodeID为当前就诊指针;
/// 			AUserID为当前进行病历引用操作的用户RowID;
/// Output:		无
/// Return:		病历引用日志JSON串
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refjournal).GetEpisodeRefLogs("Single",201871,"3928")
ClassMethod GetEpisodeRefLogs(AType As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s isFirst = 1
	s logString = ""
	s blankPrtTemplateDocID = ""
	for {
		s blankPrtTemplateDocID = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID,blankPrtTemplateDocID))
		q:(blankPrtTemplateDocID = "")

		s prtTemplateDocID = $tr(blankPrtTemplateDocID," ","")
		s prtTemplateType = ##Class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateType(prtTemplateDocID)
		continue:(prtTemplateType '= $g(AType))
		
		if (prtTemplateType = "Single")
		{
			s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID,blankPrtTemplateDocID,1,""))
			continue:(eprLogsRowID = "")

			s ret = ..GetLogsByIDAndAction(eprLogsRowID,AType)
			if ($p(ret,"^",1) > 0)
			{
				if (isFirst = 0)
				{
					s logString = logString_","	
				}	
				s logString = logString_$p(ret,"^",2)
				s isFirst = 0	
			}	
		}
		else
		{
			s isSecond = 1
			s listNo = ""
			for {
				s listNo = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID,blankPrtTemplateDocID,listNo))
				q:(listNo = "")
				
				s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID,blankPrtTemplateDocID,listNo,""))
				continue:(eprLogsRowID = "")
			
				s ret = ..GetLogsByIDAndAction(eprLogsRowID,AType)
				if ($p(ret,"^",1) > 0)
				{
					if (isSecond = 0)
					{
						s logString = logString_","	
					}
					s logString = logString_$p(ret,"^",2)	
					s isSecond = 0	
				} 
			}	
		}
		
		if (isFirst = 0)&&(AType '= "Single") 
		{
			s logString = logString_","	
		}	 
	}
	
	q logString
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-15
/// Description:根据日志RowID和类型获取操作日志信息	
/// Table:		无
/// Input:		AEPRLogsRowID为日志记录RowID;
/// 			AEPRType为病历模板类型(Single:唯一模板;Multiple:可重复模板)
/// Output:		无
/// Return:		病历引用操作日志信息JSON串
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refjournal).GetLogsByIDAndAction(51,"Single")
ClassMethod GetLogsByIDAndAction(AEPRLogsRowID As %String, AEPRType As %String) As %String
{
	s logString = ""
	s (ret, logCount) = 0
	
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(AEPRLogsRowID)
	q:(objEPRLogs = "") ret
	
	s count = objEPRLogs.Log.Count()
	q:(count = 0) ret
	
	s listNo = objEPRLogs.EPRNum
	s eprDocID = objEPRLogs.EPRDocID
	s episodeID = objEPRLogs.EpisodeID
	
	s isFirstNode = 1
	for i = 1:1:count 
	{
		s log = objEPRLogs.Log.GetAt(i)
		continue:(log = "")
		
		s actionCode = log.Action
		 
		if (AEPRType = "Single")
		{
			if '(($zcvt(actionCode,"l") = "reference")||($zcvt(actionCode,"l") = "refcomplete"))
			{
				continue	
			}
		}elseif (AEPRType = "Multiple")
		{
			if ($zcvt(actionCode,"l") '= "refcomplete")
			{
				continue	
			}	
		}
		
		s (actionCNName,statusCNName,operDate,operTime) = ""
		&sql(select top 1 ActionName into :actionCNName from EPRmeta.EPRAction where ActionCode = :actionCode)
		
		s templateID = log.TemplateID
		s userName = log.OperateUserName
		s statusCode = log.FinalStatus
		s userName = $tr(userName,$c(13),"")
		s userName = $tr(userName,$c(10),"")
		s:(log.OperateDate '= "") operDate = $zd(log.OperateDate, 3)
		s:(log.OperateTime '= "") operTime = $zt(log.OperateTime, 1)
		s tCategoryID = $list($g(^DHCEPRM.TemplateD(templateID)),7)
		s tCategoryName = $list($g(^DHCEPRM.TemplateCategoryD(tCategoryID)),3)
		s title = tCategoryName
		s:(AEPRType '= "Single") title = ..GetMultipleTitle(episodeID,eprDocID,listNo)
		&sql(select top 1 StatusName into :statusCNName from EPRmeta.EPRStatus where StatusCode = :statusCode)
		
		s logCount = logCount + 1
		
		if (isFirstNode = 0)
		{
			s logString = logString_","
		}
		s logString = logString_"{Title:'"_title_"'"_",Status:'"_statusCNName_"',RefDate:'"_operDate_"',RefTime:'"_operTime_"',RefUser:'"_userName_"'}"
		
		s isFirstNode = 0
	}
	
	s ret = logCount_"^"_logString
	q ret
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-15
/// Description:获取可重复模板的标题;	
/// Table:		无
/// Input:		AEpisodeID为患者当前就诊指针;
/// 			APrintTemplateDocID为打印模板Doc ID,为EPRTemplateCategory表中类型为PrtTemplate记录的RowID;
/// 			AListNo为可重复模板编号;
/// Output:		无
/// Return:		可重复模板标题;
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refjournal).GetMultipleTitle(201871,24,1)
ClassMethod GetMultipleTitle(AEpiosdeID As %String, APrintTemplateDocID As %String, AListNo As %String) As %String
{
	s ret = ""
	q:($g(AEpiosdeID) = "")||($g(APrintTemplateDocID) = "")||($g(AListNo) = "") ret	
	
	s chartItemID = "ML"_APrintTemplateDocID
	
	s ecrecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpiosdeID," "_chartItemID,""))
	q:(ecrecordID = "") ret
	
	s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecrecordID," "_AListNo,""))
	q:(childSub = "") ret
	
	s instanceID = ecrecordID_"||"_childSub
	
	s objInstanceData = ##Class(EPRinstance.InstanceData).%OpenId(instanceID)
	q:(objInstanceData = "") ret
	
	s title = objInstanceData.Title
	s ret = title
	q ret
}

}
