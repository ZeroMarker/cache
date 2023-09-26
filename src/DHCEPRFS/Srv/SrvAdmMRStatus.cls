Class DHCEPRFS.Srv.SrvAdmMRStatus Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdmMRStatus";

/// Desc:	注册最终结算完成标识
/// Input:	就诊rowid、UserID
ClassMethod RegFinalAccount(ASysCode As %String, AEpisodeID As %String, AUserID As %String = "") As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(AEpisodeID,AUserID)
	q sc
}

/// Desc:	注册病历确认完成标识
/// Input：	就诊rowid、UserID
ClassMethod RegMRCompletion(ASysCode As %String, AEpisodeID As %String, AUserID As %String = "") As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID)
	q sc
}

/// Desc:	取消最终结算完成标识及病历确认完成标识
/// Input:	AEpisodeID ：就诊rowid
/// 		ACanelFinalAccount : 取消最终结算标识, 1或0
/// 		ACanelMRCompletion ：取消病历确认完成标识, 1或0
ClassMethod CancelMRStatusFlagDHC(ASysCode As %String, AEpisodeID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String, ARemark As %String, AUserID As %String = "") As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID, ACanelFinalAccount, ACanelMRCompletion, ARemark, AUserID)
	q sc
}

/// Desc:	注册病历确认完成标识及病历确认完成标识
/// Input：	就诊rowid、UserID
ClassMethod AddMRStatusFlagDHC(ASysCode As %String, AEpisodeID As %String, AUserID As %String = "") As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).AddMRStatusFlagDHC(AEpisodeID,AUserID)
	q sc
}

/// Desc:	通过就诊号获取延迟队列中的地址
/// Input：	就诊号
ClassMethod GetFilePathByEpisodeID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetFilePathByEpisodeID(AEpisodeID)
	q sc
}

/// Desc:	复核通过
/// Input:	MREpisodeID - 归档就诊rowid, UserID - 用户ID, ActionCode - 操作类型代码
ClassMethod SaveReviewedStatus(AMREpisodeID As %String, AUserID As %String, AActionCode As %String) As %String [ WebMethod ]
{
	s ret = "0"
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") ret
	s episodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
	q:(episodeID = "") ret
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(episodeID,AUserID,AActionCode)
	q ret
}

/// Desc:	复核不通过
/// Input:	MREpisodeID - 归档就诊rowid, CanelFinalAccount - 取消最终结算标识(1或0), CanelMRCompletion - 取消病历确认完成标识(1或0), UserID - 用户ID, ActionCode - 操作类型代码, MRItemIDS - 问题项目ID, Remark - 额外信息
ClassMethod CancelMRStatusFlagDHCWithItem(AMREpisodeID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String, AUserID As %String, AActionCode As %String = "", AMRItemIDS As %String = "", ARemark As %String = "") As %String [ WebMethod ]
{
	s ret = "0"
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	s:(AActionCode = $c(0)) AActionCode = ""
	s:(AMRItemIDS = $c(0)) AMRItemIDS = ""
	s:(ARemark = $c(0)) ARemark = ""
	q:(AMREpisodeID = "") ret
	s episodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
	q:(episodeID = "") ret
	
	s itemInfo = ""
	f i=1:1:$l(AMRItemIDS,"^")
	{
		s xMRItemID = $p(AMRItemIDS,"^",i)
		s objMRItem = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(xMRItemID)
		continue:(objMRItem = "")
		continue:(objMRItem.Name = "")
		if (itemInfo = "") {
			s itemInfo = objMRItem.Name
		}
		else {
			s itemInfo = itemInfo_"&&"_objMRItem.Name
		}
	}
	s backReason = ARemark
	if (itemInfo '= "") {
		if (backReason = "") {
			s backReason = "复核不通过项目:"_itemInfo
		}
		else {
			s backReason = backReason_"; "_"复核不通过项目:"_itemInfo
		}
	}
	
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(episodeID,ACanelFinalAccount,ACanelMRCompletion,"",AUserID,backReason,AActionCode)
	q ret
}

/// Desc: 查询出院病人病历状态
/// Input: 出院起始日期、截止日期、出院科室、医生提交、护士提交、是否生成、是否扫描
ClassMethod QueryMRArchiveStatus(StartDate As %String, EndDate As %String, DisDpt As %String, DocCommit As %String, NurseCommit As %String, Generated As %String, Scaned As %String, SpecCOND As %String = "") As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("DHCEPRFS.BL.BLAdmMRStatus:GetEpisodeList")
    Do result.SetArgs(StartDate,EndDate,DisDpt,DocCommit,NurseCommit,Generated,Scaned, SpecCOND)
    Quit result
}

}
