Class DHCEPRFS.Srv.SrvAdmTaskQueue Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdmTaskQueue";

/// 获取待生成列表
ClassMethod GetAdmTaskQueueList(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "") As DHCEPRFS.DataSet.EAdmTaskQueueDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskQueueDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType)
	q dataset
}

/// 获取待生成列表
ClassMethod GetAdmTaskQueueListPage(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", APageCount As %String = "", APageSize As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As DHCEPRFS.DataSet.EAdmTaskQueueDS [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskQueueDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q dataset
}

ClassMethod GetAdmTaskQueueListTotalCount(ARegNo As %String, AMedRecordNo As %String, AStartDate As %String, AEndDate As %String, AType As %String = "", AEpisodeID As %String = "", APatientName As %String = "", AAdmLocID As %String = "", ADisLocID As %String = "") As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskQueue).GetAdmTaskQueueTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID)
	q ret
}

///  重新生成，在待生成列表中插入记录
ClassMethod ReCreate(AType As %String, ARecordID As %String) As %String [ WebMethod ]
{
    if ((AType = "executelist") || (AType = "normalexecutelist") || (AType = "specialexecutelist") || (AType = "greenchannelexecutelist"))
    {
        d ##class(DHCEPRFS.BL.BLAdmTaskExec).Recreate(ARecordID)
    }
    elseif ((AType = "successlist") || (AType = "normalsuccesslist") || (AType = "specialsuccesslist") || (AType = "greenchannelsuccesslist"))
    {
        d ##class(DHCEPRFS.BL.BLAdmTaskSucceed).Recreate(ARecordID)
    }
    q "1"
}

///  重新生成，加入绿色通道
ClassMethod ReCreateAdd2GreenChannel(AType As %String, ARecordID As %String) As %String [ WebMethod ]
{
	if ((AType = "greenchannelexecutelist") || (AType = "executelist") || (AType = "normalexecutelist"))
	{
		d ##class(DHCEPRFS.BL.BLAdmTaskExec).RecreateSend2GreenChannel(ARecordID)
	}
	elseif ((AType = "greenchannelsuccesslist") || (AType = "successlist") || (AType = "normalsuccesslist"))
	{
		d ##class(DHCEPRFS.BL.BLAdmTaskSucceed).RecreateSend2GreenChannel(ARecordID)
	}
	elseif ((AType = "greenchannelqueuelist") || (AType = "queuelist") || (AType = "normalqueuelist"))
	{
		d ##class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(ARecordID,"send2greenchannel")
	}
	q "1"
}

/// 	提高降低优先级
ClassMethod PriorityOperation(AdmTaskQueueID As %String, OpType As %String, APriority As %String = "") As %String [ WebMethod ]
{
	s:(APriority = $c(0)) APriority = ""
	s status = ##class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(AdmTaskQueueID,OpType,APriority)
	q status
}

/// 	新建老病历生成任务到待生成队列，优先级1000以上会由老病历生成虚拟机来生成
ClassMethod CreateOldTask(AEpisodeID As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegOldConfirmMRAdmAndLog(AEpisodeID,AUserID)
	q:(ret = "0") "-1"
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"1500","","O")
	/*
	d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishAN(AEpisodeID)
	//判断是否是产科婴儿，婴儿没有病案首页，不需要屏蔽隐私，否则队列中隐私项目为空会卡住
	//通过是否有病案号(新生婴儿没有病案号)
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMedNo(AEpisodeID)
	s:(medRecordNo = $c(0)) medRecordNo = ""
	if (medRecordNo '= "")
	{
		d ##class(DHCEPRFS.BL.BLAdmTaskQueue).CreatePrivacyLevel01("DHC",AEpisodeID,"50")
	}
			
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint(AEpisodeID)
	if (ret = "1")
	{
		d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS(AEpisodeID)	
	}
	
	s ret = ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishBUltra(AEpisodeID)
	*/
	q ret
}

ClassMethod CheckCreated(AEpisodeID As %String, ASchemeType As %String = "") As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CheckCreated(AEpisodeID,ASchemeType)
	q ret
}

ClassMethod CreateByMREpisodeID(AMREpisodeID As %String, APriority As %String = "60") As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).CreateByMREpisodeID(AMREpisodeID,APriority)
	q ret
}

/// 获取待生成列表
ClassMethod GetAdmTaskQueueListPageByParam(AParam As DHCEPRFS.Entity.EAdmTaskQueue, AType As %String = "", APageCount As %String = "", APageSize As %String = "") As DHCEPRFS.DataSet.EAdmTaskQueueDS [ WebMethod ]
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
	s dataset = ##class(DHCEPRFS.DataSet.EAdmTaskQueueDS).%New()
	d dataset.SetArgs(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,APageCount,APageSize,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q dataset
}

ClassMethod GetAdmTaskQueueListTotalCountByParam(AParam As DHCEPRFS.Entity.EAdmTaskQueue, AType As %String = "") As %String [ WebMethod ]
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
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskQueue).GetAdmTaskQueueTotalCount(ARegNo,AMedRecordNo,AStartDate,AEndDate,AType,AEpisodeID,APatientName,AAdmLocID,ADisLocID,AObservedNo,AAdmType)
	q ret
}

ClassMethod AddStatusQueue(AEpisodeID As %String, ASchemeType As %String = "") As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	q:(AEpisodeID ="") "0"
	s ret = ##class(DHCEPRFS.BL.BLAdmTaskQueue).AddStatusQueue(AEpisodeID,ASchemeType)
	q ret
}

// 重新生成加入正常生成队列

ClassMethod ReCreateAdd2Normal(AType As %String, ARecordID As %String) As %String [ WebMethod ]
{
  if ((AType = "greenchannelexecutelist"))
  {
    d ##class(DHCEPRFS.BL.BLAdmTaskExec).RecreateSend2Normal(ARecordID)
  }
  elseif ((AType = "greenchannelsuccesslist"))
  {
    d ##class(DHCEPRFS.BL.BLAdmTaskSucceed).RecreateSend2Normal(ARecordID)
  }
  elseif ((AType = "greenchannelqueuelist"))
  {
    d ##class(DHCEPRFS.BL.BLAdmTaskQueue).PriorityOperation(ARecordID,"send2normal")
  }
  q "1"
}

ClassMethod ReCreate2TaskType(AListType As %String, ARecordID As %String, ATaskType As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskQueue).ReCreate2TaskType(AListType,ARecordID,ATaskType)
}

ClassMethod CheckAdmQueueByTaskType(ATaskType As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskQueue).CheckAdmQueueByTaskType(ATaskType)
}

}
