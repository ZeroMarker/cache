Class DHCEPRFS.BI.BIAdmMRStatus Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	加入待复核列表
/// Input:	AEpisodeID - 就诊rowid
/// 			AUserID - 结算用户ID
/// Debug：	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).AddDischargePatient(AEpisodeID,AUserID)
ClassMethod AddDischargePatient(AEpisodeID As %String, AUserID As %String)
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).AddDischargePatient(AEpisodeID,AUserID)
	q ret
}

ClassMethod AddCheckedPatient(AEpisodeID As %String, AUserID As %String)
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).AddDischargePatient(AEpisodeID,AUserID)
	q ret
}

/// Desc:	获取病历状态：医生是否确认病历完成标识
/// Input:	AEpisodeID : 就诊rowid
/// Return:	医生是否确认病历完成
/// 		1 或 0
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).GetMRCompletionFlag("1")
ClassMethod GetMRCompletionFlag(AEpisodeID As %String) As %String
{
	s status = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	q:(status="") "0"
	
	s flag = $p(status, "^", 2)
	q flag
}

/// Desc:	获取病历状态：最终结算完成标识状态
/// Input:	AEpisodeID : 就诊rowid
/// Return:	最终结算是否完成
/// 		1 或 0
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).GetFinalAccountFlag("1")
ClassMethod GetFinalAccountFlag(AEpisodeID As %String) As %String
{
	s status = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	q:(status="") "0"
	
	s flag = $p(status, "^", 1)
	q flag
}

/// debug: w ##Class(DHCEPRFS.BI.BIAdmMRStatus).CanCommitPDF("7901074","840")
ClassMethod CanCommitPDF(AEpisodeID, AUserID) As %Boolean
{
	//q "1"
	s flag = ##Class(DHCEPRFS.BI.BIAdmMRStatus).GetMRCompletionFlag(AEpisodeID)
	q:(flag="1") "0"
	
	s curDeptID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(AEpisodeID)
	s curDeptID = $p(curDeptID, "^", 1)
	s isDeptActive = ..IsDeptActive(curDeptID)
	q:(isDeptActive'="1") "0"
	
	//s curWardID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisWard(AEpisodeID)
	//s curWardID = $p(curWardID, "^", 1)
	//q:(curWardID '= "311") "0"
	
	q "1"
}

ClassMethod NurseCanCommitPDF(AEpisodeID, AUserID) As %Boolean
{
	q "1"
}

/// Desc:	指定科室是否开启无纸化功能
/// Input:	ACurDeptID 指定科室ID
/// Return:	1 开启， 0 未开启
/// Debug：	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).IsDeptActive("11")
ClassMethod IsDeptActive(ACurDeptID As %String) As %String
{
	s isActive = "0"
	
	q:(ACurDeptID="") isActive
	
	s fsDept = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("FSDept")
	q:(fsDept="")||(fsDept="NULL") isActive
	
	s count = $L(fsDept,"^")
	for i = 1:1:count
	{
		s deptID = $p(fsDept,"^",i)
		if (deptID = ACurDeptID)
		{
			s isActive = "1"
			q
		}
	}
	
	q isActive
}

/// Desc:	注册迟归报告生成任务队列
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLateReturningQueue("1","CREATELIS")
ClassMethod RegLateReturningQueue(AEpisodeID As %String, ASchemeType As %String) As %String
{
	s $zt = "OnErrorRegQueue"
	
	s status = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	if (status="1^1")
	{
		s sysCode = "DHC"
		s priority = "50"
		s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority, ASchemeType,"N","")
		if (admTaskQueueID = "")
		{
			q "0"
		}
		else
		{
			q "1"
		}
	}
	else
	{
		q "1" 
	}
	
OnErrorRegQueue
	q "-100"
}

/// Desc:	注册迟归报告生成任务队列不检查是否确认
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus("1","CREATELIS")
ClassMethod RegLQWOStatus(AEpisodeID As %String, ASchemeType As %String) As %String
{
	s $zt = "OnErrorRegQueue"

	s sysCode = "DHC"
	s priority = "151"
	//b "s"
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority, ASchemeType,"N","")
	if (admTaskQueueID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
	
OnErrorRegQueue
	q "-100"
}

/// Desc:	注册单项生成
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatusTemp("1","CREATELIS")
ClassMethod RegLQWOStatusTemp(AEpisodeID As %String, ASchemeType As %String) As %String
{
	s $zt = "OnErrorRegQueueTemp"

	s sysCode = "DHC"
	s priority = "65"
	//b "s"
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority, ASchemeType,"N","")
	if (admTaskQueueID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
	
OnErrorRegQueueTemp
	q "-100"
}

/// Desc:	单项生成加入到老病历队列中
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus4OLD("1","CREATETEMP01")
ClassMethod RegLQWOStatus4OLD(AEpisodeID As %String, ASchemeType As %String) As %String
{
	s $zt = "OnErrorRegQueue"

	s sysCode = "DHC"
	s priority = "45"
	//b "s"
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority, ASchemeType,"O","")
	if (admTaskQueueID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
	
OnErrorRegQueue
	q "-100"
}

/// Desc:	注册迟归报告生成任务队列不检查是否确认加入特殊队列
/// Debug:	w ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus("1","CREATELIS")
ClassMethod RegLQWOStatusSpecial(AEpisodeID As %String, ASchemeType As %String, ASpecialFlag As %String = "", ASpecialParam As %String = "") As %String
{
	s $zt = "OnErrorRegQueue"

	s sysCode = "DHC"
	s priority = "2500"
	//b "s"
	s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, AEpisodeID, priority, ASchemeType,"S","",ASpecialFlag,ASpecialParam)
	if (admTaskQueueID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
	
OnErrorRegQueue
	q "-100"
}

/// Desc: 根据质控科复核状态和病案室复核状态判断是否允许提交病历
/// Input: AEpisodeID - 就诊rowID
/// Output: "1" - 允许, "0" - 不允许
/// Debug: w ##class(DHCEPRFS.BI.BIAdmMRStatus).EnableSubmitByReview(601)
ClassMethod EnableSubmitByReview(AEpisodeID As %String) As %String
{
	s ret = "1"
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ret
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s reviewStatus = objPat.ReviewStatus
	s qcReviewStatus = objPat.QCReviewStatus
	d objPat.%Close()
	q:((reviewStatus = "B")||(qcReviewStatus = "B")) ret
	q:((reviewStatus = "F")||(qcReviewStatus = "F")) "0"
	q ret
}

/// Desc: 获取退回状态
/// Input: AEpisodeID -- 就诊RowID
/// Output: 已退回未提交 -- 退回标记^类型^退回日期^退回时间^退回操作用户ID^总退回次数^退回原因, 其他情况 -- "0"
/// Debug: w ##class(DHCEPRFS.BI.BIAdmMRStatus).GetBackInfoByEpisode(599)
ClassMethod GetBackInfoByEpisode(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") "0"
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s reviewStatus = objPat.ReviewStatus
	s qcReviewStatus = objPat.QCReviewStatus
	s deptReviewStatus = objPat.DeptReviewStatus
	q:((reviewStatus '= "B")&&(qcReviewStatus '= "B")&&(deptReviewStatus '= "B")) "0"
	s actType = "", actDate = "", actTime = "", actUserID = ""
	if (reviewStatus = "B")
	{
		s actType = "MR"
		s actDate = objPat.ReviewDate
		s actTime = objPat.ReviewTime
		s actUserID = objPat.ReviewUserID
	}
	elseif (qcReviewStatus = "B")
	{
		s actType = "QC"
		s actDate = objPat.ReviewDate
		s actTime = objPat.ReviewTime
		s actUserID = objPat.ReviewUserID
	}
	elseif (deptReviewStatus = "B")
	{
		s actType = "DEPT"
		s actDate = objPat.ReviewDate
		s actTime = objPat.ReviewTime
		s actUserID = objPat.ReviewUserID
	}
	d objPat.%Close()
	s:(actDate '= "") actDate = $zd(actDate,3)
	s:(actTime '= "") actTime = $zt(actTime)
	s backCount = ##class(DHCEPRFS.BL.BLReview).GetBackCount(AEpisodeID)
	s mrBackCount = $lg(backCount,1)
	s qcBackCount = $lg(backCount,2)
	s deptBackCount = $lg(backCount,3)
	s totalBackCount = mrBackCount + qcBackCount + deptBackCount
	s reviewMessage = ##class(DHCEPRFS.BL.BLReview).GetReviewMessage(AEpisodeID)
	s ret = "1^"_actType_"^"_actDate_"^"_actTime_"^"_actUserID_"^"_totalBackCount_"^"_reviewMessage
	q ret
}

}
