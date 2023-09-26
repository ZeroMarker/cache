Class DHCEPRFS.Srv.SrvAdmTaskExec Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdmTaskExec";

/// 检查是否有特殊需要重生成
ClassMethod CheckSpecialAdmTaskExec() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckSpecialAdmTaskExec()
	q ret
}

///  获取特殊的需要重生成
ClassMethod GetSpecialAdmTaskExec(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetSpecialAdmTaskExec(IP,UserID)
	q ret
}

/// 检查是否有特殊需要重生成
ClassMethod CheckSpecialTypeAdmTaskExec(ASpecialFlag As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckSpecialAdmTaskExec(ASpecialFlag)
	q ret
}

///  获取特殊的需要重生成
ClassMethod GetSpecialTypeAdmTaskExec(IP As %String, UserID As %String, ASpecialFlag As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetSpecialAdmTaskExec(IP,UserID,ASpecialFlag)
	q ret
}

/// 检查是否有错误的需要重生成
ClassMethod CheckErrorAdmTaskExec(ATimeoutInterval As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckErrorAdmTaskExec(ATimeoutInterval)
	q ret
}

///  获取错误的需要重生成
ClassMethod GetErrorAdmTaskExec(ATimeoutInterval As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetErrorAdmTaskExec(ATimeoutInterval,"true")
	q ret
}

/// 检查
ClassMethod CheckAdmTask() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckAdmTaskExec()
	q ret
}

/// 获取
ClassMethod GetAdmTask(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExec(IP,UserID)
	q entity
}

/// 检查绿色通道
ClassMethod CheckGreenChannelAdmTask() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckGreenChannelAdmTaskExec()
	q ret
}

/// 检查老病历
ClassMethod CheckOldAdmTaskExec() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CheckOldAdmTaskExec()
	q ret
}

/// 获取绿色通道
ClassMethod GetGreenChannelAdmTask(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetGreenChannelAdmTaskExec(IP,UserID)
	q entity
}

/// 获取老病历
ClassMethod GetOldAdmTaskExec(IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLAdmTaskExec).GetOldAdmTaskExec(IP,UserID)
	q entity
}

/// 过程中更新进行状态
ClassMethod UpdateAdmTaskRemark(AAdmTaskExecID As %String, ATaskRemark As %String) As %String [ WebMethod ]
{
	s status = ##Class(DHCEPRFS.BL.BLAdmTaskExec).UpdateRemark(AAdmTaskExecID, ATaskRemark)
	q status
}

/// 完全结束
ClassMethod CompleteAdmTask(AAdmTaskExecID As %String, AInputParam As %String = "") As %String [ WebMethod ]
{
	s status = ##Class(DHCEPRFS.BL.BLAdmTaskExec).CompleteTask(AAdmTaskExecID,AInputParam)
	q status
}

/// 获取正在生成列表
ClassMethod GetAdmTaskExecList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "") As DHCEPRFS.DataSet.EAdmTaskExecDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskExecDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType)
	q dataset
}

/// 获取正在生成列表
ClassMethod GetAdmTaskExecListPage(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageCount As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As DHCEPRFS.DataSet.EAdmTaskExecDS [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskExecDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q dataset
}

ClassMethod GetAdmTaskExecListTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExecTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q ret
}

/// 	提高降低优先级
ClassMethod PriorityOperation(AdmTaskExecID As %String, OpType As %String, APriority As %String = "") As %String [ WebMethod ]
{
	s:(APriority = $c(0)) APriority = ""
	s status = ##class(DHCEPRFS.BL.BLAdmTaskExec).PriorityOperation(AdmTaskExecID,OpType,APriority)
	q status
}

ClassMethod GetAdmTaskExecListTotalCountByParam(AParam As DHCEPRFS.Entity.EAdmTaskExec, AType As %String = "") As %String [ WebMethod ]
{
	s ARegNo =AParam.RegNo
	s AMedRecordNo = AParam.MedRecordNo
	s AStartDate = AParam.StartDate
	s AEndDate = AParam.EndDate
	s AEpisodeID = AParam.EpisodeID
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s APatientName = AParam.PatientName
	s AAdmLocID = AParam.AdmLocID
	s ADisLocID = AParam.DisLocID
	s AObservedNo = AParam.ObservedNo
	s AAdmType = AParam.AdmType
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskExecTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q ret
}

/// 获取正在生成列表
ClassMethod GetAdmTaskExecListPageByParam(AParam As DHCEPRFS.Entity.EAdmTaskExec, AType As %String = "", APageCount As %String = "", APageSize As %String = "") As DHCEPRFS.DataSet.EAdmTaskExecDS [ WebMethod ]
{
	s ARegNo =AParam.RegNo
	s AMedRecordNo = AParam.MedRecordNo
	s AStartDate = AParam.StartDate
	s AEndDate = AParam.EndDate
	s AEpisodeID = AParam.EpisodeID
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s APatientName = AParam.PatientName
	s AAdmLocID = AParam.AdmLocID
	s ADisLocID = AParam.DisLocID
	s AObservedNo = AParam.ObservedNo
	s AAdmType = AParam.AdmType
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskExecDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q dataset
}

/// Desc:通过ID获得平台xml传过来的MRItemID
ClassMethod GetAdmTaskXMLByID(AAdmTaskXMLInfoID As %String) As DHCEPRFS.Entity.EAdmTaskXmlInfo [ WebMethod ]
{
    q ##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskXMLByID(AAdmTaskXMLInfoID)
}

/// Desc: 获取最优先的任务，并move到生成队列
ClassMethod GetAdmTaskByTaskType(ATaskType As %String, IP As %String, UserID As %String) As DHCEPRFS.Entity.EAdmTaskExec [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskExec).GetAdmTaskByTaskType(ATaskType,IP,UserID)
}

}
