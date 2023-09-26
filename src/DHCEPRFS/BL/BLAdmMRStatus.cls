Class DHCEPRFS.BL.BLAdmMRStatus Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod SaveReviewedStatus(AEpisodeID As %String, AUserID As %String, AActionCode As %String) As %String
{
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	
	//记录这次变更
	s changeAct = ""
	s:(AActionCode = "1") changeAct = "REVIEWED"
	s:(AActionCode = "2") changeAct = "DEPTREVIEWED"
	s:(AActionCode = "3") changeAct = "QCREVIEWED"
	s changeStatus = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"COMMON")
	q:(changeStatus'= "1") "-2"
	//更新校验病人列表的复核状态
	s reviewRet = ""
	s:(AActionCode = "1") reviewRet = ..UpdateReviewStatus("F",AEpisodeID,AUserID)
	s:(AActionCode = "2") reviewRet = ..UpdateDeptReviewStatus("F",AEpisodeID,AUserID)
	s:(AActionCode = "3") reviewRet = ..UpdateQCReviewStatus("F",AEpisodeID,AUserID)
	q:(reviewRet '= "1") "-2"
	
	q "1"
}

/// Desc: 医生提交时更新复核信息
/// Input: AEpisodeID - 就诊rowid，AUserID - 操作用户ID
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmMRStatus).UpdateCheckedPatientByDoctor(AAdmMRStatusID,AEpisodeID,AUserID,ARemarks)
ClassMethod UpdateCheckedPatientByDoctor(AAdmMRStatusID As %String, AEpisodeID As %String, AUserID As %String, ARemarks As %String = "") As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	if (patRowID = "")
	{
		s createDate = $p($h,",",1)
		s createTime = $p($h,",",2)
		s patRet = ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPat(AEpisodeID,createDate,createTime,AUserID,ARemarks)
		q:(patRet '= "1") "-1"
	}
	else
	{
		s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
		if (hospitalFlag = "WLDYRM")
		{
			s obj = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
			s flagMRCompletion = obj.FlagMRCompletion
			d obj.%Close()
			if (flagMRCompletion = "")
			{
				s reviewRet = ..UpdateReviewStatus("U",AEpisodeID,AUserID)
				q:(reviewRet '= "1") "-2"
				s deptRet = ..UpdateDeptReviewStatus("U",AEpisodeID,AUserID)
				q:(deptRet '= "1") "-2"
				s qcRet = ..UpdateQCReviewStatus("U",AEpisodeID,AUserID)
				q:(qcRet '= "1") "-2"
				s qcRet = ..UpdateSubmitRemarks(ARemarks,AEpisodeID,AUserID)
				q:(qcRet '= "1") "-2"
			}
			else
			{
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
				s mrStatus = objPat.ReviewStatus
				s deptStatus = objPat.DeptReviewStatus
				s qcStatus = objPat.QCReviewStatus
				if (deptStatus = "B")
				{
					s objPat.DeptReviewStatus = "U"
					s objPat.DeptReviewDate = $p($h,",",1)
					s objPat.DeptReviewTime = $p($h,",",2)
					s objPat.DeptReviewUserID = AUserID
				}
				if (qcStatus = "B")
				{
					s objPat.QCReviewStatus = "U"
					s objPat.QCReviewDate = $p($h,",",1)
					s objPat.QCReviewTime = $p($h,",",2)
					s objPat.QCReviewUserID = AUserID
				}
				if (mrStatus = "B")
				{
					s objPat.ReviewStatus = "U"
					s objPat.ReviewDate = $p($h,",",1)
					s objPat.ReviewTime = $p($h,",",2)
					s objPat.ReviewUserID = AUserID
				}
				s objPat.Remarks = ARemarks
				s status = objPat.%Save()
				d objPat.%Close()
				if ($$$ISOK(status))
				{
					q "1"
				}
				else
				{
					q "-2"
				}
			}
		}
		else
		{
			s reviewRet = ..UpdateReviewStatus("U",AEpisodeID,AUserID)
			q:(reviewRet '= "1") "-2"
			s deptRet = ..UpdateDeptReviewStatus("U",AEpisodeID,AUserID)
			q:(deptRet '= "1") "-2"
			s qcRet = ..UpdateQCReviewStatus("U",AEpisodeID,AUserID)
			q:(qcRet '= "1") "-2"
			s remarkRet = ..UpdateSubmitRemarks(ARemarks,AEpisodeID,AUserID)
			q:(remarkRet '= "1") "-2"
		}
	}
	q "1"
}

/// Desc: 护士提交时更新复核信息
/// Input: AEpisodeID - 就诊rowid，AUserID - 操作用户ID
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmMRStatus).UpdateCheckedPatientByNurse(AAdmMRStatusID,AEpisodeID,AUserID)
ClassMethod UpdateCheckedPatientByNurse(AAdmMRStatusID As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	if (patRowID = "")
	{
		s createDate = $p($h,",",1)
		s createTime = $p($h,",",2)
		s patRet = ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPat(AEpisodeID,createDate,createTime,AUserID)
		q:(patRet '= "1") "-1"
	}
	else
	{
		s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
		if (hospitalFlag = "WLDYRM")
		{
			s obj = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
			s flagFinalAccount = obj.FlagFinalAccount
			d obj.%Close()
			if (flagFinalAccount = "")
			{
				s reviewRet = ..UpdateReviewStatus("U",AEpisodeID,AUserID)
				q:(reviewRet '= "1") "-2"
				s qcRet = ..UpdateQCReviewStatus("U",AEpisodeID,AUserID)
				q:(qcRet '= "1") "-2"
			}
			else
			{
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
				s mrStatus = objPat.ReviewStatus
				s qcStatus = objPat.QCReviewStatus
				if (mrStatus = "B")
				{
					s objPat.ReviewStatus = "U"
					s objPat.ReviewDate = $p($h,",",1)
					s objPat.ReviewTime = $p($h,",",2)
					s objPat.ReviewUserID = AUserID
				}
				if (qcStatus = "B")
				{
					s objPat.QCReviewStatus = "U"
					s objPat.QCReviewDate = $p($h,",",1)
					s objPat.QCReviewTime = $p($h,",",2)
					s objPat.QCReviewUserID = AUserID
				}
				s status = objPat.%Save()
				d objPat.%Close()
				if ($$$ISOK(status))
				{
					q "1"
				}
				else
				{
					q "-2"
				}
			}
		}
		else
		{
			s reviewRet = ..UpdateReviewStatus("U",AEpisodeID,AUserID)
			q:(reviewRet '= "1") "-2"
			s deptRet = ..UpdateDeptReviewStatus("U",AEpisodeID,AUserID)
			q:(deptRet '= "1") "-2"
			s qcRet = ..UpdateQCReviewStatus("U",AEpisodeID,AUserID)
			q:(qcRet '= "1") "-2"
		}
	}
	q "1"
}

/// Desc: 护士最终结算时检查复核列表是否存在该就诊，如果不存在则新建病人信息，如果存在则更新出院信息和复核信息
/// Input: AEpisodeID - 就诊rowid，AUserID - 操作用户ID
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmMRStatus).AddDischargePatient(AEpisodeID,AUserID)
ClassMethod AddDischargePatient(AEpisodeID As %String, AUserID As %String) As %String
{
	//新生儿不加入列表
	s motherAdmDR = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMotherAdmDR(AEpisodeID)
	q:(motherAdmDR '= "") "1"
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	if (patRowID = "")
	{
		s createDate = $p($h,",",1)
		s createTime = $p($h,",",2)
		s patRet = ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPat(AEpisodeID,createDate,createTime,AUserID)
		q:(patRet '= "1") "-1"
	}
	else
	{
		s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
		s objPat.PAAdmDepID = $p(^PAADM(AEpisodeID),"^",4)
		s objPat.CreateDate = $p($h,",",1)
		s objPat.CreateTime = $p($h,",",2)
		s objPat.CreateUserID = AUserID
		s objPat.ReviewStatus = "U"
		s objPat.ReviewDate = $p($h,",",1)
		s objPat.ReviewTime = $p($h,",",2)
		s objPat.ReviewUserID = AUserID
		s objPat.DeptReviewStatus = "U"
		s objPat.DeptReviewDate = $p($h,",",1)
		s objPat.DeptReviewTime = $p($h,",",2)
		s objPat.DeptReviewUserID = AUserID
		s objPat.QCReviewStatus = "U"
		s objPat.QCReviewDate = $p($h,",",1)
		s objPat.QCReviewTime = $p($h,",",2)
		s objPat.QCReviewUserID = AUserID
		s status = objPat.%Save()
		d objPat.%Close()
		if ($$$ISERR(status))
		{
			q "-2"
		}
	}
	
	q "1"
}

/// Desc:	注册护士提交完成标识
/// Input:	AEpisodeID - 就诊rowid
/// 		AUserID - 提交用户ID
/// Return:	1  注册护士提交完成标识成功
/// 		-1 生成或获取已创建 DHCEPRFS.INST.AdmMRStatus 对象失败
/// 		-2 更新 DHCEPRFS.INST.AdmMRStatus.FlagFinalAccount 标识失败
/// 		-3 保存操作记录失败
/// 		-4 更新复核状态失败
/// 		-100 其他
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(AEpisodeID,AUserID)
ClassMethod RegFinalAccountDHC(AEpisodeID As %String, AUserID As %String = "", AFlag As %String = "") As %String
{
	s $zt = "OnErrorRegFinalAccountDHC"
	
	//生成 AdmMRStatus 对象
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	
	//更新 DHCEPRFS.INST.AdmMRStatus.FlagFinalAccount 标识
	s updateStatus = ..UpdateFlagFinalAccount(admMRStatusID, AUserID, AFlag)
	q:(updateStatus '= "1") "-2"
	
	//保存操作记录
	s changeStatus = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,"COMPLETE","NURSE")
	q:(changeStatus'= "1") "-3"
	
	//更新复核状态
	s reviewRet = ..UpdateCheckedPatientByNurse(admMRStatusID,AEpisodeID,AUserID)
	q:(reviewRet '= "1") "-4"
	
	//新建或更新MREpisode和MRLog
	d ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	d ..RegMRAdmAndLog(AEpisodeID,"NURCONFIRM",AUserID)
	
	do ..CheckFlagAndAddTask(admMRStatusID, AUserID)
	
	q "1"
	
OnErrorRegFinalAccountDHC
	q "-100"
}

/// Desc:	注册医生提交完成标识
/// Input:	AEpisodeID - 就诊rowid
/// 		AUserID - 提交用户ID
/// 		AConfirm - Y 确认完成 N 未完成
/// Return:	1  注册医生提交完成标识成功
/// 		-1 生成或获取已创建 DHCEPRFS.INST.AdmMRStatus 对象失败
/// 		-2 更新 DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion 标识失败
/// 		-3 保存操作记录失败
/// 		-4 更新复核状态失败
/// 		-100 其他
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm)
ClassMethod RegMRCompletionDHC(AEpisodeID As %String, AUserID As %String = "", AConfirm As %String = "Y", ACheck As %String = "Y", AMessage As %String = "", AChgMarks As %String = "") As %String
{
	s $zt = "OnErrorRegMRCompletionDHC"
	
	//生成 AdmMRStatus 对象
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	
	s flag = "COMPLETE"
	s:(AConfirm = "N") flag = "NOTCONFIRM"
	if (ACheck = "N")
	{
		//保存操作记录
		s changeStatus = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,flag,"DOCTOR","N",AMessage)
		q:(changeStatus '= "1") "-3"
		q "1"
	}
	else
	{
		//更新 DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion 标识
		s updateStatus = ..UpdateFlagMRCompletion(admMRStatusID, AUserID)
		q:(updateStatus '= "1") "-2"
		
		//保存操作记录
		s changeStatus = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,flag,"DOCTOR","Y",AMessage)
		q:(changeStatus '= "1") "-3"
		
		//更新复核状态
		s reviewRet = ..UpdateCheckedPatientByDoctor(admMRStatusID,AEpisodeID,AUserID,AMessage)
		q:(reviewRet '= "1") "-4"
		
		do ..CheckFlagAndAddTask(admMRStatusID, AUserID)
	}
	
	//新建或更新MREpisode和MRLog
	d ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	d ..RegMRAdmAndLog(AEpisodeID,"DOCCONFIRM",AUserID)
	
	q "1"
	
OnErrorRegMRCompletionDHC
	q "-100"
}

/// Desc:	注册必要条件完成标识
/// Input:	AEpisodeID - 就诊rowid
/// 		AUserID - 提交用户ID
/// Return:	1  注册必要条件完成标识成功
/// 		-1 生成或获取已创建 DHCEPRFS.INST.AdmMRStatus 对象失败
/// 		-2 更新 DHCEPRFS.INST.AdmMRStatus.NecessaryCondition 标识失败
/// 		-3 保存操作记录失败
/// 		-100 其他
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegNecessaryConditionDHC(AEpisodeID,AUserID)
ClassMethod RegNecessaryConditionDHC(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnErrorRegNecessaryConditionDHC"
	
	//生成 AdmMRStatus 对象
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	
	//更新 DHCEPRFS.INST.AdmMRStatus.NecessaryCondition 标识
	s updateStatus = ..UpdateFlagNecessaryCondition(admMRStatusID, AUserID)
	q:(updateStatus '= "1") "-2"
	
	//保存操作记录
	s changeStatus = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,"COMPLETE","NECESSARY")
	q:(changeStatus'= "1") "-3"
	
	do ..CheckFlagAndAddTask(admMRStatusID, AUserID)
	
	q "1"
	
OnErrorRegNecessaryConditionDHC
	q "-100"
}

/// Desc:	获取就诊病历状态
/// Input:	AEpisodeID ：就诊rowid
/// Return:	最终结算标识是否完成^病历确认标识是否完成
/// 		共四种情况：1^1, 0^0, 1^0, 0^1
/// Debug:	w ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC("201868")
ClassMethod GetAdmMRStatusDHC(AEpisodeID As %String) As %String
{
	s flagFinalAccount = "0", flagMRCompletion = "0"
	
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s entity = ..GetAdmMRStatusEntity(AEpisodeID, sysCode)
	if (entity '= "")
	{
		if (entity.FlagFinalAccount = "1") {s flagFinalAccount = "1"}
		if (entity.FlagMRCompletion = "1") {s flagMRCompletion = "1"}
	}
	
	 s ret = flagFinalAccount_"^"_flagMRCompletion
	 q ret
}

/// Desc:	获取必要条件状态
/// Input:	AEpisodeID ：就诊rowid
/// Return:	是否需要参考必要条件
/// 		共两种情况： 1, 0
/// Debug:	w ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmNECStatusDHC("201868")
ClassMethod GetAdmNECStatusDHC(AEpisodeID As %String) As %String
{
	s necessaryCondition = "0"
	//b "s"
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s entity = ..GetAdmMRStatusEntity(AEpisodeID, sysCode)
	if (entity '= "")
	{
		if (entity.NecessaryCondition = "1") {s necessaryCondition = "1"}
	}
	
	 s ret = necessaryCondition
	 q ret
}

/// Desc:	取消最终结算完成标识及病历确认完成标识
/// Input:	AEpisodeID ：就诊rowid
/// 		ACanelFinalAccount : 取消最终结算标识, 1或0
/// 		ACanelMRCompletion ：取消病历确认完成标识, 1或0
/// Return:	1 成功, 0 失败, -1 指定就诊不存在
/// Debug:	w ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC("201868","1","1")
ClassMethod CancelMRStatusFlagDHC(AEpisodeID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String, ARemark As %String, AUserID As %String = "", AReason As %String = "", AActionCode As %String = "") As %String
{
	s $zt = "OnErrorCancelMRStatusFlagDHC"

	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"

	s objAdmMRStauts = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
	q:(objAdmMRStauts="") "0"
		
	s:(ACanelFinalAccount = "1") objAdmMRStauts.FlagFinalAccount = "0"
	s:(ACanelMRCompletion = "1") objAdmMRStauts.FlagMRCompletion = "0"
	s sc = objAdmMRStauts.%Save()
	s changeAct = ""
	if (AActionCode '= "")
	{
		s:(AActionCode = "1") changeAct = "BACK"
		s:(AActionCode = "2") changeAct = "DEPTBACK"
		s:(AActionCode = "3") changeAct = "QCBACK"
		s:(AActionCode = "5") changeAct = "RECALL"
		s:(AActionCode = "6") changeAct = "REVOKE"
	}
	else
	{
		s changeAct = "BACK"
	}
	if ($$$ISOK(sc))
	{
		s ret = ..RegMRAdmAndLog(AEpisodeID,"QCBACK",AUserID)
		if ((ACanelFinalAccount = "1")&&(ACanelMRCompletion = "1"))
		{
			s changeMRCompletion = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"DOCTOR","Y",AReason)
			q:(changeMRCompletion '= "1") "-2"
			s changeFinalAccount = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"NURSE","Y",AReason)
			q:(changeFinalAccount '= "1") "-2"
		}
		elseif (ACanelFinalAccount = "1")
		{
			s changeFinalAccount = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"NURSE","Y",AReason)
			q:(changeFinalAccount '= "1") "-2"
		}
		elseif (ACanelMRCompletion = "1")
		{
			s changeMRCompletion = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"DOCTOR","Y",AReason)
			q:(changeMRCompletion '= "1") "-2"
		}
		//更新校验病人列表的复核状态
		s reviewRet = ""
		if (AActionCode '= "")
		{
			s:(AActionCode = "1") reviewRet = ..UpdateReviewStatus("B",AEpisodeID,AUserID)
			s:(AActionCode = "2") reviewRet = ..UpdateDeptReviewStatus("B",AEpisodeID,AUserID)
			s:(AActionCode = "3") reviewRet = ..UpdateQCReviewStatus("B",AEpisodeID,AUserID)
			s:(AActionCode = "5") reviewRet = "1"
			s:(AActionCode = "6") reviewRet = "1"
		}
		else
		{
			s reviewRet = ..UpdateReviewStatus("B",AEpisodeID,AUserID)
		}
		q:(reviewRet '= "1") "-2"
	}
	else
	{
		q "0"
	}
	
	q "1"
	
OnErrorCancelMRStatusFlagDHC
	q -100
}

/// Desc:   取消必要条件完成标识
/// Input:  EpisodeID - 就诊rowid, UserID - 用户ID
/// Return: 1 成功, 0 失败, -1 指定就诊不存在
/// Debug:  w ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelNecessaryConditionDHC("93","552")
ClassMethod CancelNecessaryConditionDHC(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnErrorCancelNecessaryConditionDHC"
	
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	
	s objAdmMRStauts = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
	q:(objAdmMRStauts = "") "0"
	s objAdmMRStauts.NecessaryCondition = "0"
	s sc = objAdmMRStauts.%Save()
	s changeAct = "BACK"
	if ($$$ISOK(sc))
	{
		s changeNecessaryCondition = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,changeAct,"NECESSARY","Y","")
		q:(changeNecessaryCondition '= "1") "-2"
	}
	else
	{
		q "0"
	}
	
	q "1"
	
OnErrorCancelNecessaryConditionDHC
	q "-100"
}

/// Desc:	注册最终结算完成标识及病历确认完成标识
/// Input:	AEpisodeID ：就诊rowid
/// Return:	1 成功, 0 失败, -1 指定就诊不存在
ClassMethod AddMRStatusFlagDHC(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnErrorRegFinalAccountDHC"
	
	TSTART
	// 生成 AdmMRStatus 对象
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, sysCode)
	
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ..CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	if (admMRStatusID = "") 
	{
		TROLLBACK
		q "-1"
	}
	
	// 更新 DHCEPRFS.INST.AdmMRStatus.FlagFinalAccount 标识
	s updateStatus = ..UpdateMRStatusFlagDHC(admMRStatusID, AUserID)
	if (updateStatus '= "1")
	{
		TROLLBACK
		q "-2"
	}
	
	s addFlag = ..CheckFlagAndAddTask(admMRStatusID, AUserID)
	if (addFlag '= "1")
	{
		TROLLBACK
		q "-2"
	}
	
	s changeMRCompletion = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,"COMPLETE","DOCTOR")
	q:(changeMRCompletion '= "1") "-2"
	s changeFinalAccount = ..ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,"COMPLETE","NURSE")
	q:(changeFinalAccount '= "1") "-2" 
	
	
	TCOMMIT
	q "1"
	
OnErrorRegFinalAccountDHC
	q "-100"
}

/// Desc:	获取就诊病历状态表ID
ClassMethod GetIDByEpisode(AEpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	q:(AEpisodeID = "") ""
	
	s rowID = $O(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," "_ASysCode," "_AEpisodeID,""))
	q rowID
}

/// Desc:	创建一条就诊病历状态记录
/// Input:	APatientID 患者RowID
/// 		AEpisodeID 就诊RowID 
/// Output: DHCEPRFS.INST.AdmMRStatus.%Id() 创建的就诊病历状态记录RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).CreateAdmMRStatus("1","201868","DHC")
ClassMethod CreateAdmMRStatus(APatientID As %String, AEpisodeID As %String, ASysCode As %String) As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%New()
	s obj.SysCode = ASysCode
	s obj.PatientID = APatientID
	s obj.EpisodeID = AEpisodeID
	s now = $h
	s obj.CreateDate = $P(now, ",", 1)
	s obj.CreateTime = $P(now, ",", 2)
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	更新 DHCEPRFS.INST.AdmMRStatus.FlagFinalAccount 标识
ClassMethod UpdateFlagFinalAccount(AAdmMRStatusID As %String, AUserID As %String = "", AFlag As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
	q:(obj = "") "0"
	
	s now = $H
	s obj.FlagFinalAccount = "1"
	s obj.FlagFinalAccountDate = $p(now, ",", 1)
	s obj.FlagFinalAccountTime = $P(now, ",", 2)
	s obj.FlagFinalAccountUserID = AUserID
	s obj.FlagFinalAccountRemark = AFlag
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	更新 DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion 标识
ClassMethod UpdateFlagMRCompletion(AAdmMRStatusID As %String, AUserID As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
	q:(obj = "") "0"
	
	s now = $H
	s obj.FlagMRCompletion = "1"
	s obj.FlagMRCompletionDate = $p(now, ",", 1)
	s obj.FlagMRCompletionTime = $P(now, ",", 2)
	s obj.FlagMRCompletionUserID = AUserID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	更新 DHCEPRFS.INST.AdmMRStatus.NecessaryCondition 标识
ClassMethod UpdateFlagNecessaryCondition(AAdmMRStatusID As %String, AUserID As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
	q:(obj = "") "0"
	
	s now = $H
	s obj.NecessaryCondition = "1"
	s obj.NecessaryConditionDate = $p(now, ",", 1)
	s obj.NecessaryConditionTime = $P(now, ",", 2)
	s obj.NecessaryConditionUserID = AUserID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	更新 DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion 标识和更新 DHCEPRFS.INST.AdmMRStatus.FlagFinalAccount 标识
ClassMethod UpdateMRStatusFlagDHC(AAdmMRStatusID As %String, AUserID As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
	q:(obj = "") "0"
	
	s now = $H
	s obj.FlagMRCompletion = "1"
	s obj.FlagMRCompletionDate = $p(now, ",", 1)
	s obj.FlagMRCompletionTime = $P(now, ",", 2)
	s obj.FlagFinalAccount = "1"
	s obj.FlagFinalAccountDate = $p(now, ",", 1)
	s obj.FlagFinalAccountTime = $P(now, ",", 2)
	s obj.FlagMRCompletionUserID = AUserID
	s obj.FlagFinalAccountUserID = AUserID
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	检查所有标识符是否都已完成，若都已完成，在任务队列中添加一条待生成任务记录
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).CheckFlagAndAddTask("21029")
ClassMethod CheckFlagAndAddTask(AAdmMRStatusID As %String, AUserID As %String = "") As %String
{
	q:(AAdmMRStatusID = "") "0"
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AAdmMRStatusID)
	q:(obj = "") "0"
	s sysCode = obj.SysCode
	s episodeID = obj.EpisodeID
	
	s enableCondition = ..CheckEnableCondition(episodeID)
	q:($p(enableCondition,"^",1) = "1")&&(obj.FlagMRCompletion '= "1") "0"
	q:($p(enableCondition,"^",2) = "1")&&(obj.FlagFinalAccount '= "1") "0"
	q:($p(enableCondition,"^",3) = "1")&&(obj.NecessaryCondition '= "1") "0"
	
	s PAAdmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
	s:(PAAdmType '= "") PAAdmType = $p(PAAdmType,"^",1)
	if (PAAdmType = "O")||(PAAdmType = "E")
	{
		s completeQueueFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CompleteQueue")
		if (completeQueueFlag = "Y")  //启用延迟生成, 门急诊加入延迟队列
		{
			s retStatusQueue = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).AddStatusQueue(episodeID,"",AUserID)
			q retStatusQueue
		}
	}
	
	s AddEpisodeWhenAddQueue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AddEpisodeWhenAddQueue")
	s priority = "50"
	s result = ..CheckTaskQueueByEpisode(episodeID)
	if (result = "0")
	{
		s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode,episodeID,priority)
		if (admTaskQueueID = "")
		{
			q "0"
		}
		if (AddEpisodeWhenAddQueue = "Y")
		{
			s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(episodeID,sysCode)	
		}
	}
	else
	{
		s objTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(result)
		s schemeType = objTaskQueue.SchemeType
		if (schemeType = "")||(schemeType = $c(0))
		{
		}
		else
		{
			s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode,episodeID,priority)
			if (admTaskQueueID = "")
			{
				q "0"
			}
		}
	}
	
	s flagRelate = ##class(DHCEPRFS.BL.BLMREpisodeRelate).RegRelationByCreate(sysCode,episodeID)
	
	do ..RegMRAdmAndLog(episodeID,"CONFIRM",AUserID)
	
	q "1"
}

/// Desc:	添加任务队列启用判断条件
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).CheckEnableCondition("483")
ClassMethod CheckEnableCondition(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	//医生提交判断, 默认启用
	s enableDoctor = "1"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "LYEY")
	{
		s enableDoctor = "0"
	}
	//护士提交判断, 默认启用
	s enableNurse = "1"
	s paAdmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(AEpisodeID)
	s:(paAdmType '= "") paAdmType = $p(paAdmType,"^",1)
	if (paAdmType = "O")
	{
		s enableNurse = "0"
	}
	//必要条件判断, 默认不启用
	s enableNecessary = "0"
	s enableNecessaryConditionConfirm = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("EnableNecessaryConditionConfirm")
	if (enableNecessaryConditionConfirm = "Y")
	{
		s enableNecessary = "1"
	}
	s ret = enableDoctor_"^"_enableNurse_"^"_enableNecessary
	q ret
}

ClassMethod GetAdmMRStatusEntity(AEpisodeID As %String, ASysCode As %String = "DHC") As DHCEPRFS.Entity.EAdmMRStatus
{
	//b "s"
	s admMRStatusID = ..GetIDByEpisode(AEpisodeID, ASysCode)
	q:(admMRStatusID = "") ""
	
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
	q:(obj = "") "0"
	
	s entity = ##Class(DHCEPRFS.Entity.EAdmMRStatus).%New()
	s entity.SysCode = obj.SysCode
	s entity.PatientID = obj.PatientID
	s entity.EpisodeID = obj.EpisodeID
	s entity.CreateDate = obj.CreateDate
	s entity.CreateTime = obj.CreateTime
	s entity.FlagFinalAccount = obj.FlagFinalAccount
	s entity.FlagFinalAccountDate = obj.FlagFinalAccountDate
	s entity.FlagFinalAccountTime = obj.FlagFinalAccountTime
	s entity.FlagFinalAccountUserID = obj.FlagFinalAccountUserID
	s entity.FlagMRCompletion = obj.FlagMRCompletion
	s entity.FlagMRCompletionDate = obj.FlagMRCompletionDate
	s entity.FlagMRCompletionTime = obj.FlagMRCompletionTime
	s entity.FlagMRCompletionUserID = obj.FlagMRCompletionUserID
	s entity.NecessaryCondition = obj.NecessaryCondition
	s entity.NecessaryConditionDate = obj.NecessaryConditionDate
	s entity.NecessaryConditionTime = obj.NecessaryConditionTime
	s entity.NecessaryConditionUserID = obj.NecessaryConditionUserID
	
	q entity
}

ClassMethod RegMRAdmAndLog(AEpisodeID, AMRAction, AUserID = "") As %String
{
	s $zt = "OnErrorRegMRAdmAndLog"
	
	//注册更新MREpisode已提前到医生或护士提交，所以此处仅进行或者mrEpisodeID
	//s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	s mrEpisodeID = ""
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
	if (mrEpisodeID '= "")
	{
		//进行自动回收,只有提交动作才进行回收，退回QCBACK仅写日志
		s autoRetrieve = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AutoRetrieve")
		if ((autoRetrieve = "Y") && (AMRAction = "CONFIRM"))
		{
			s ret = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).OperationByEpisodeID(AEpisodeID,AUserID)
			if (ret ="1")
			{
				s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,"RETRIEVEOK",AUserID)
			}
			else
			{
				s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,"RETRIEVEERROR",AUserID)
			}
		}
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,AMRAction,AUserID)
		q sc
	}
	else
	{
		q "0"
	}
OnErrorRegMRAdmAndLog
	q "0"
}

ClassMethod RegOldConfirmMRAdmAndLog(AEpisodeID, AUserID = "") As %String
{
	s $zt = "OnErrorRegMRAdmAndLog"

	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddOldConfirmLogDetail(mrEpisodeID,AUserID)
		q sc
	}
	else
	{
		q "0"
	}
OnErrorRegMRAdmAndLog
	q "0"
}

ClassMethod ChangeLog(AEpisodeID As %String, AUserID As %String, AAdmMRStatusID As %String, ASysCode As %String, AFlagFinalAccountChange As %String, AType As %String, AAct As %String = "Y", AMessage As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.AdmMRStatusLog).%New()
	s obj.AdmMRStatusID = AAdmMRStatusID
	s obj.EpisodeID = AEpisodeID
	s obj.ChangeUserID = AUserID
	s obj.SysCode = ASysCode
	s obj.ChangeAct = AFlagFinalAccountChange
	s obj.ChangeDate = $p($h,",",1)
	s obj.ChangeTime = $p($h,",",2)
	s obj.Type = AType
	s obj.Act = AAct
	s obj.Message = AMessage
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc:	七天自动提交医生病历完成
/// Return:	count是医生完成成功的总数。
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).AutomaticMRComplete()
ClassMethod AutomaticMRComplete() As %String
{
	s result = 0
	s count = 0
	
	s timeSpan = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AutoMRCompleteTimeSpan")
	q:(timeSpan = "") count
	//b "s"
	s countA = ..MRComplete("0",timeSpan)
	s countB = ..MRComplete("",timeSpan)
	s count = (+countA)+(+countB)
	q count
}

/// Desc:	根据医生完成的标识和指定的天数来自动提交医生病历完成
/// Return:	count是医生完成成功的总数。
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).MRComplete("","7")
ClassMethod MRComplete(AFlagMRCompletion As %String, ATimeSpan As %String) As %String
{
	s count = 0
	s result = 0
	
	s accountDate = $p($h,",",1)-ATimeSpan
	for {
		s accountDate = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxFlagFinalAccount"," "_AFlagMRCompletion," 1",accountDate),-1)
		q:(accountDate = "")
		s accountDateTime = ""
		for{
			s accountDateTime =  $o(^DHCEPRFS.INST.AdmMRStatusI("IdxFlagFinalAccount"," "_AFlagMRCompletion," 1", accountDate,accountDateTime))
			q:(accountDateTime = "")
			s rowID = ""
			for{
				s rowID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxFlagFinalAccount"," "_AFlagMRCompletion," 1",accountDate,accountDateTime,rowID))
				q:(rowID = "")
				
				s obj = ##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(rowID)
				s EpisodeID = obj.EpisodeID
				s result = ..RegMRCompletionDHC(EpisodeID,"","")
				if (result = 1)
				{				
					s count = count +1
				}

			}
		}
	}
	q count
}

/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).CheckTaskQueueByEpisode("114")
ClassMethod CheckTaskQueueByEpisode(AEpisode As %String) As %String
{
	s result = "0"
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmTaskQueueI("IdxEpisode"," "_AEpisode,""))
	if (rowID = "")
	{
	}
	else
	{
		s result = rowID
	}
	q result
}

/// Desc:此需求针对宁医，要求当天出院两天后的自动提交
/// Return:	count是加入队列的总数。
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).AutoComplete()
ClassMethod AutoComplete() As %String
{
	s count = 0
	
	s AutoDate = $p($h,",",1)-3
	for {
		s AutoDate = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",AutoDate),-1)
		q:(AutoDate="")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",AutoDate,rowID))
			q:(rowID ="")
			s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
			s episodeID = ""
			s episodeID = obj.EpisodeID
			s userID = obj.UserID
			s result = ..MRCompleteByEpisodeID(episodeID,userID)
			if (result = 1)
			{	
				s obj.CreateFlag = "1"
				s sc = obj.%Save()
				if ($$$ISOK(sc))
				{			
					s count = count +1
				}
			}
		}
	}
	q count
}

/// Desc:	七天自动提交
/// Return:	count是医生完成成功的总数。
/// Debug:	w ##Class(DHCEPRFS.BL.BLAdmMRStatus).AutoMRComplete()
ClassMethod AutoMRComplete() As %String
{
	s countA = 0
	s countB = 0
	
	s firstTimeSpan = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AutoCompleteFirstTimeSpan")
	q:(firstTimeSpan = "") "0"
	s secondTimeSpan = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AutoCompleteSecondTimeSpan")
	q:(secondTimeSpan = "") "0"
	
	s firstTimeSpan = +firstTimeSpan
	s secondTimeSpan = +secondTimeSpan
	
	s firstDate = $p($h,",",1)-firstTimeSpan
	s:(firstDate '="") firstDate=$zd(firstDate,3)
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByDisDate")
	d result.Execute(firstDate)
	while(result.Next())
	{
		s PAADMRowID = $g(result.Data("EpisodeID"))
		s episodeID = PAADMRowID
    	//是否是取消的就诊
    	s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode(episodeID)
    	continue:(flag = "c")
    	continue:(flag = "C")
    	//是否住院的就诊（去除门诊急诊）
    	s paadmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
    	s:(paadmType '="") paadmType = $p(paadmType,"^",1)
    	continue:(paadmType '= "I")
    	do ..MRCompleteByEpisodeID(episodeID)
		
		s rowID = ""
		s rowID = $o(^DHCEPRFS.INST.AutoCompleteI("IdxEpisodeID"," "_episodeID,rowID))
		if (rowID ="")
		{
			s obj = ##class(DHCEPRFS.INST.AutoCompleteStatus).%New()
			s obj.EpisodeID = episodeID
			s obj.ActDate = $p($h,",",1)  
			s obj.ActTime = $p($h,",",2)
			s obj.ActCount = 1
			s obj.DisDateTime = firstDate
			s sc = obj.%Save()
			if ($$$ISOK(sc))
			{
				s countA = countA +1
			}
		}
		else
		{
			s obj = ##class(DHCEPRFS.INST.AutoCompleteStatus).%OpenId(rowID)
			s obj.EpisodeID = episodeID
			s obj.ActDate = $p($h,",",1)  
			s obj.ActTime = $p($h,",",2)
			s obj.ActCount = 1
			s obj.DisDateTime = firstDate
			s sc = obj.%Save()
			if ($$$ISOK(sc))
			{
				s countA = countA +1
			}
		}		
	}
    
    s second = $p($h,",",1)-secondTimeSpan
    for {
	    s second = $o(^DHCEPRFS.INST.AutoCompleteI("IdxMain",1,second),-1)
	    q:(second ="")
	    s rowIDAuto = ""
	    for {
		    s rowIDAuto = $o(^DHCEPRFS.INST.AutoCompleteI("IdxMain",1,second,rowIDAuto))
		    q:(rowIDAuto = "")
	    	s objSecond = ##class(DHCEPRFS.INST.AutoCompleteStatus).%OpenId(rowIDAuto)
	    	s secondEpisodeID = objSecond.EpisodeID
	    	do ..MRCompleteByEpisodeID(secondEpisodeID)
	    	s objSecond.ActCount =2
	   		s objSecond.ActDate = $p($h,",",1)  
			s objSecond.ActTime = $p($h,",",2)
			s sc = objSecond.%Save()
			if ($$$ISOK(sc))
			{
				s countB = countB +1
			}
	    }
    }   
    q countA_"^"_countB
}

ClassMethod MRCompleteByEpisodeID(AEpisodeID As %String, AUserID As %String = "") As %String
{
	TSTART
    s CreateStatus = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50","","N","","","")
    
    if (CreateStatus = "")
    {
	    TROLLBACK
	    q "0"
    }
    
    s PAAdmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(AEpisodeID)
	s:(PAAdmType '= "") PAAdmType = $p(PAAdmType,"^",1)		
    //s PAAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
    s ret = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("EnableAutoAddNewBorn")
    
    if (ret = "Y")&&(PAAdmType = "I")
	{
		s flag = "1"
		//将新生儿加入队列生成
		s childEpisodeList = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetChildEpisodeIDByAdm(AEpisodeID)
		for i=1:1:$l(childEpisodeList,"^")
		{
			s childEpisodeID = $p(childEpisodeList,"^",i)
			
			s result = ..CheckTaskQueueByEpisode(childEpisodeID)
			if (result="0")
			{	
				s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC", childEpisodeID, "50")
				if (admTaskQueueID = "")
				{
					s flag = "0"
					BREAK
				}
			}
			else
			{
				s objChildTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(result)
				s childSchemeType = objChildTaskQueue.SchemeType
		
				if (childSchemeType = "")||(childSchemeType = $c(0))
				{
				}
				else
				{
					s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC", childEpisodeID, "50")
					if (admTaskQueueID = "")
					{
						s flag = "0"
						BREAK
					}
				}	
			}			
		}
		if (flag = "0")
		{
			TROLLBACK
	    	q "0"
		}
	}
	TCOMMIT
	q "1"
}

/// Desc: 更新校验病人列表的复核状态
ClassMethod UpdateReviewStatus(AReviewStatus As %String, AEpisodeID As %String, AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	q:(rowID = "") "0"
	s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	
	s objPat.ReviewStatus = AReviewStatus
	s objPat.ReviewDate = $p($h,",",1)
	s objPat.ReviewTime = $p($h,",",2)
	s objPat.ReviewUserID = AUserID
	
	s status = objPat.%Save()
	d objPat.%Close()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc: 更新校验病人列表的科室复核状态
ClassMethod UpdateDeptReviewStatus(ADeptStatus As %String, AEpisodeID As %String, AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	q:(rowID = "") "0"
	s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	
	s objPat.DeptReviewStatus = ADeptStatus
	s objPat.DeptReviewDate = $p($h,",",1)
	s objPat.DeptReviewTime = $p($h,",",2)
	s objPat.DeptReviewUserID = AUserID
	
	s status = objPat.%Save()
	d objPat.%Close()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc: 更新校验病人列表的质控科复核状态
ClassMethod UpdateQCReviewStatus(AQCDeptStatus As %String, AEpisodeID As %String, AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	q:(rowID = "") "0"
	s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	
	s objPat.QCReviewStatus = AQCDeptStatus
	s objPat.QCReviewDate = $p($h,",",1)
	s objPat.QCReviewTime = $p($h,",",2)
	s objPat.QCReviewUserID = AUserID
	
	s status = objPat.%Save()
	d objPat.%Close()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

///  Debug: w ##class(DHCEPRFS.BL.BLAdmMRStatus).AutoFinishMRBack()
ClassMethod AutoFinishMRBack() As %String
{
	s timeSpan = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AutoFinishMRBackTimeSpan")
	q:(timeSpan = "") "0"
	s count = 0 
	
	s backDate = $p($h,",",1) - timeSpan
	s backTime = ""
	f {
		s backTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxReviewTime"," B",backDate,backTime))
		q:(backTime = "")
		s rowID = ""
		f {
			s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxReviewTime"," B",backDate,backTime,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
			s episodeID = obj.EpisodeID
			d obj.%Close()
			s commitRet = ..RegMRCompletionDHC(episodeID,"")
			//s deptReviewRet = ..SaveDeptReviewed(episodeID,"")
			if ((commitRet = "1")&&(deptReviewRet = "1"))
			{
				s count = count + 1
			}
		}
	}
	q count
}

/// Desc: 添加提交备注
/// Desc: w ##class(DHCEPRFS.BL.BLAdmMRStatus).AddSubmitRemarks("159","test1","测试备注")
ClassMethod AddSubmitRemarks(AUserID As %String, ARemarksDesc As %String, ARemarks As %String) As %String
{
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	s remarksCode = AUserID_"_"_date_"_"_time
	
	s obj = ##class(DHCEPRFS.INST.SubmitRemarks).%New()
	
	s obj.RemarksCode = remarksCode
	s obj.RemarksDesc = ARemarksDesc
	s obj.Remarks = ARemarks
	s obj.Available = "Y"
	s obj.CreateDate = date
	s obj.CreateTime = time
	s obj.CreateUserID = AUserID
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

/// Desc: 修改提交备注
/// Debug:	w ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveSubmitRemarks("1","测试修改")
ClassMethod SaveSubmitRemarks(ARemarksID As %String, ARemarks As %String) As %String
{
	q:(ARemarksID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.SubmitRemarks).%OpenId(ARemarksID)
	s obj.Remarks = ARemarks
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

/// Desc: 删除提交备注，置为不可用
/// Debug: w ##class(DHCEPRFS.BL.BLAdmMRStatus).RemoveSubmitRemarks("1")
ClassMethod RemoveSubmitRemarks(ARemarksID As %String)
{
	q:(ARemarksID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.SubmitRemarks).%OpenId(ARemarksID)
	s obj.Available = "N"
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

/// Desc: 查询提交备注
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmMRStatus","LoadSubmitRemarks","159")
Query LoadSubmitRemarks(AUserID As %String) As %Query(ROWSPEC = "RemarksID:%String,RemarksCode:%String,RemarksDesc:%String,Remarks:%String")
{
}

ClassMethod LoadSubmitRemarksExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s date = ""
	f {
		s date = $o(^DHCEPRFS.INST.SubmitRemarksI("IdxMain"," Y"," "_AUserID,date))
		q:(date = "")
		s time = ""
		f {
			s time = $o(^DHCEPRFS.INST.SubmitRemarksI("IdxMain"," Y"," "_AUserID,date,time))
			q:(time = "")	
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.SubmitRemarksI("IdxMain"," Y"," "_AUserID,date,time,rowID))
				q:(rowID = "")		
				s obj = ##class(DHCEPRFS.INST.SubmitRemarks).%OpenId(rowID)
				s remarksCode = obj.RemarksCode
				s remarksDesc = obj.RemarksDesc
				s:(remarksDesc'="") remarksDesc=##class(DHCEPRFS.Util.StringHelper).ConvertJSONSpecialChar(remarksDesc)
				s remarks = obj.Remarks
				s:(remarks'="") remarks=##class(DHCEPRFS.Util.StringHelper).ConvertJSONSpecialChar(remarks)
				s ^CacheTemp(repid,ind) = $lb(rowID,remarksCode,remarksDesc,remarks)
				s ind = ind + 1
			}	
		}	
	}
	
	q $$$OK
}

ClassMethod LoadSubmitRemarksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadSubmitRemarksExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LoadSubmitRemarksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadSubmitRemarksExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 更新校验病人列表的备注
ClassMethod UpdateSubmitRemarks(ARemarks As %String, AEpisodeID As %String, AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	q:(rowID = "") "0"
	s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	
	s objPat.Remarks = ARemarks
	
	s status = objPat.%Save()
	d objPat.%Close()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// w ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateErrorEpisode("601")
ClassMethod UpdateErrorEpisode(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") "0"
	
	s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
	q:(patientID = "") ""
	
	s AMedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
	q:(AMedRecordNo ="")
	
	s id =""
	s isHIS = ""
	&sql(select IsHISMedRecord into :isHIS from DHCEPRFS_INST.MRMedRecord where MedRecordNo = :AMedRecordNo)
	q:(isHIS '= "N")
	&sql(select ID into :id from DHCEPRFS_INST.MRMedRecord where MedRecordNo = :AMedRecordNo)
	q:(id = "")
	

	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(id)
	s obj.IsHISMedRecord = ""
	s obj.LastModifyDate = $P($h, ",", 1)
	s obj.LastModifyTime = $p($h, ",", 2)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "-1"
	}
}

/// 更正协和历史错误就诊号
/// debug:w ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateHistoryEpisode()
ClassMethod UpdateHistoryEpisode() As %String
{
	s countA = 0
	s countB = 0
	s sysCode = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("SysCode")
	s medRecordNo = ""
	for {
		s medRecordNo = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," "_sysCode," N",medRecordNo))
		q:(medRecordNo="")		
		s mrMedRecordNo = ""
		for {
			s mrMedRecordNo = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," "_sysCode," N",medRecordNo,mrMedRecordNo))
			q:(mrMedRecordNo = "")
			
			s objMRMed = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordNo)
			s MedRecordID = objMRMed.MedRecordNo
			
			s papmi = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByMedRecord(MedRecordID)
			q:(papmi = "")
			s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByPAPMI")
			d result.Execute(papmi)
			
			while(result.Next())
			{
				//b "s"
				s episodeID = $g(result.Data("EpisodeID"))
				s PAdmDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(episodeID)
				s PDisDate= ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
				s:(PDisDate '="") PDisDate = $p(PDisDate,",",1)
				s mrEpisodeID = ""
				for {
					s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_mrMedRecordNo,mrEpisodeID))
					q:(mrEpisodeID ="")
					s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					s episodeID = obj.EpisodeID
					s admDate = obj.AdmDate
					s disDate = obj.DisDate
					if ((admDate =PAdmDate)&&(disDate=PDisDate))
					{
						s obj.EpisodeID = PAAdm
						s sc = obj.%Save()
						s countA = countA+1
					}				
				}
				//重新注册此就诊PAAdm
				s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(PAAdm)
				q:(patientID = "")
				s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeID(patientID, PAAdm, sysCode)	
				s countB = countB +1
			}
		}	
	}
	
	q countA_"^"_countB
}

/// Desc: 获取上次提交的备注信息
/// Debug: w ##class(DHCEPRFS.BL.BLAdmMRStatus).GetLastSubmitRemarks("601")
ClassMethod GetLastSubmitRemarks(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ""
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s remarks = objPat.Remarks
	d objPat.%Close()
	q:(remarks = "") ""
	s ret = $p(remarks,"#",1)
	q ret
}

/// Desc: 查询纸质病历项目
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmMRStatus","GetPaperItems","601")
Query GetPaperItems(AEpisodeID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemName:%String,ItemDesc:%String,IsChecked:%String,ItemPages:%String")
{
}

ClassMethod GetPaperItemsExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s lastFlag = "0"
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	if (patRowID '= "")
	{
		s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
		s remarks = objPat.Remarks
		d objPat.%Close()
		if (remarks '= "")
		{
			s lastItems = $p(remarks,"@",2)
			s:(lastItems '= "") lastFlag = "1"
		}
	}
	s typeParams = ""
	f {
		s typeParams = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS",typeParams))
		q:(typeParams = "")
		s rowID = ""
		f {
			s rowID = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS",typeParams,rowID))
			q:(rowID = "")	
			s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s code = objItem.Code
			s name = objItem.Name
			s desc = objItem.Description
			d objItem.%Close()
			s isChecked = "0"
			s rowPages = ""
			if (lastFlag = "1")
			{
				f i=1:1:$l(lastItems,"^")
				{
					s itemInfo = $p(lastItems,"^",i)
					s itemID = $p(itemInfo,"||",1)
					s itemPages = $p(itemInfo,"||",2)
					if (itemID = rowID)
					{
						s isChecked = "1"
						s rowPages = itemPages
					}
				}
			}
				
			s ^CacheTemp(repid,ind) = $lb(rowID,code,name,desc,isChecked,rowPages)
			s ind = ind + 1	
		}	
	}
	q $$$OK
}

ClassMethod GetPaperItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaperItemsExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaperItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaperItemsExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFilePathByEpisodeID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") ""
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxEpisodeID"," "_AEpisodeID,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
	q obj.FilePath
}

ClassMethod LateToCreate(AEpisodeID As %String, AMRItemID As %String) As %String
{
	s taskExecID = ""
    s taskExecID = $o(^DHCEPRFS.INST.AdmTaskExecI("IdxEpisode"," "_AEpisodeID,taskExecID))
    s taskSucceedID = ""
    s taskSucceedID = $o(^DHCEPRFS.INST.AdmTaskSucceedI("IdxEpisodeID"," "_AEpisodeID,taskSucceedID))
    if (taskExecID '="")||(taskSucceedID '= "")
    {
    	s rowID = ""
    	s rowID = $o(^DHCEPRFS.META.LateToCreateI("IdxMRItem"," "_AMRItemID,rowID))
    	if (rowID '="")
    	{
	    	s objCreateType = ##class(DHCEPRFS.META.LateToCreate).%OpenId(rowID)
	    	s CreateType = objCreateType.CreateType
	    	d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50",CreateType)
    	}
    }
}

/// Debug: w ##class(DHCEPRFS.BL.BLAdmMRStatus).AutoCompleteOutHospital()
ClassMethod AutoCompleteOutHospital() As %String
{
	s countA = 0
	s countB = 0
	
	s CompleteOutHospitalDay = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CompleteOutHospitalDay")
	s CompleteOutHospitalItemID = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CompleteOutHospitalItemID")
	
	s date = $p($h,",",1)-CompleteOutHospitalDay
	s:(date '= "") date=$zd(date,3)
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByAdmDate")
	d result.Execute(date)
	while(result.Next())
	{
		s PAADMRowID = $g(result.Data("EpisodeID"))
		s episodeID = PAADMRowID
		//是否是取消的就诊
		s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode(episodeID)
		continue:(flag = "c")
		continue:(flag = "C")
		s paadmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
		s:(paadmType '= "") paadmType = $p(paadmType,"^",1)
		s paadmType = $ZCVT(paadmType,"U")
		continue:(paadmType '= "O")&&(paadmType '= "E")
		
		s rowID = ""
		s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxEpisodeID"," "_episodeID,rowID))
		if (rowID = "")
		{
			s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%New()
			s obj.EpisodeID = episodeID
			s obj.ActDate = $p($h,",",1)  
			s obj.ActTime = $p($h,",",2)
			s obj.CreateFlag = "0"
			s obj.SchemeType = "OUTHOSPITAL"
			s sc = obj.%Save()
			if ($$$ISOK(sc))
			{
				s countA = countA +1
			}
		}
		else
		{
			s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
			s obj.EpisodeID = episodeID
			s obj.ActDate = $p($h,",",1)  
			s obj.ActTime = $p($h,",",2)
			s obj.CreateFlag = "0"
			s obj.SchemeType = "OUTHOSPITAL"
			s sc = obj.%Save()
			if ($$$ISOK(sc))
			{
				s countA = countA +1
			}
		}
	}
	s second = $p($h,",",1)+1
	for {
		s second = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",second),-1)
		q:(second = "")
		s rowIDAuto = ""
		for {
			s rowIDAuto = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",second,rowIDAuto))
			q:(rowIDAuto = "")
			s objSecond = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowIDAuto)
			s secondEpisodeID = objSecond.EpisodeID
			
			s flagItem = "0"
			for i=1:1:$l(CompleteOutHospitalItemID,"^")
			{
				s itemID = $p(CompleteOutHospitalItemID,"^",i)
				s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemID)
				s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(secondEpisodeID,objItem.TypeParams)
				if (ret '= "0")
				{
					s flagItem = "1"
				}
			}
			continue:(flagItem = "0")
			s schemeType = objSecond.SchemeType
			
			s CreateStatus = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",secondEpisodeID,"45",schemeType,"N","","","")
			if (CreateStatus '= "")
			{ 
				s objSecond.CreateFlag = "1"
				s objSecond.ActDate = $p($h,",",1)  
				s objSecond.ActTime = $p($h,",",2)
				s sc = objSecond.%Save()
				if ($$$ISOK(sc))
				{
					s countB = countB +1
				}
			}
			s addPatRet = ..AddOEPatientAndMRComplete(secondEpisodeID,"SYS")
		}
	}
	q countA_"^"_countB
}

/// Desc: 门急诊加入复核列表并更新医生提交标识
/// Debug: w ##Class(DHCEPRFS.BL.BLAdmMRStatus).AddOEPatientAndMRComplete(490,"SYS")
ClassMethod AddOEPatientAndMRComplete(AEpisodeID As %String, AUserID As %String) As %String
{
	//生成 AdmMRStatus 对象
	s sysCode = ##Class(DHCEPRFS.Const.SysCode).DHC()
	s admMRStatusID = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetIDByEpisode(AEpisodeID, sysCode)
	if (admMRStatusID = "")
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		s admMRStatusID = ##class(DHCEPRFS.BL.BLAdmMRStatus).CreateAdmMRStatus(patientID, AEpisodeID, sysCode)
	}
	q:(admMRStatusID = "") "-1"
	//加入复核列表
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	if (patRowID = "")
	{
		s createDate = $p($h,",",1)
		s createTime = $p($h,",",2)
		s patRet = ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPat(AEpisodeID,createDate,createTime,AUserID)
		q:(patRet '= "1") "-1"
	}
	//更新DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion标识
	s updateStatus = ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateFlagMRCompletion(admMRStatusID, AUserID)
	q:(updateStatus '= "1") "-2"
	//记录这次变更
	s changeStatus = ##class(DHCEPRFS.BL.BLAdmMRStatus).ChangeLog(AEpisodeID,AUserID,admMRStatusID,sysCode,"COMPLETE","DOCTOR")
	q:(changeStatus '= "1") "-2"
	
	q "1"
}

/// Debug: w ##class(DHCEPRFS.BL.BLAdmMRStatus).FillUpCompleteOutHospital("2018-05-01","2018-05-02")
ClassMethod FillUpCompleteOutHospital(AStartDate As %String, AEndDate As %String) As %String
{
	q:(AStartDate = "") ""
	q:(AEndDate = "") ""
	s countA = 0
	s countB = 0
	s CompleteOutHospitalItemID = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CompleteOutHospitalItemID")
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	for date = startDate:1:endDate
	{
		s tempDate = ""
		s:(date '= "") tempDate=$zd(date,3)
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByAdmDate")
		d result.Execute(tempDate)
		while(result.Next())
		{
			s PAADMRowID = $g(result.Data("EpisodeID"))
			s episodeID = PAADMRowID
			//是否是取消的就诊
			s flag = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetVisitStatusByEpisode(episodeID)
			continue:(flag = "c")
			continue:(flag = "C")
			s paadmType = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(episodeID)
			s:(paadmType '= "") paadmType = $p(paadmType,"^",1)
			s paadmType = $ZCVT(paadmType,"U")
			continue:(paadmType '= "O")&&(paadmType '= "E")
			
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxEpisodeID"," "_episodeID,rowID))
			if (rowID = "")
			{
				s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%New()
				s obj.EpisodeID = episodeID
				s obj.ActDate = $p($h,",",1)  
				s obj.ActTime = $p($h,",",2)
				s obj.CreateFlag = "0"
				s obj.SchemeType = "OUTHOSPITAL"
				s sc = obj.%Save()
				if ($$$ISOK(sc))
				{
					s countA = countA +1
				}
			}
			else
			{
				s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
				s obj.EpisodeID = episodeID
				s obj.ActDate = $p($h,",",1)  
				s obj.ActTime = $p($h,",",2)
				s obj.CreateFlag = "0"
				s obj.SchemeType = "OUTHOSPITAL"
				s sc = obj.%Save()
				if ($$$ISOK(sc))
				{
					s countA = countA +1
				}
			}
		}
	}
	s second = $p($h,",",1)+1
	for {
		s second = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",second),-1)
		q:(second = "")
		s rowIDAuto = ""
		for {
			s rowIDAuto = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxMain"," 0",second,rowIDAuto))
			q:(rowIDAuto = "")
			s objSecond = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowIDAuto)
			s secondEpisodeID = objSecond.EpisodeID
			
			s flagItem = "0"
			for i=1:1:$l(CompleteOutHospitalItemID,"^")
			{
				s itemID = $p(CompleteOutHospitalItemID,"^",i)
				s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemID)
				s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(secondEpisodeID,objItem.TypeParams)
				if (ret '= "0")
				{
					s flagItem = "1"
				}
			}
			continue:(flagItem = "0")
			s schemeType = objSecond.SchemeType
			
			s CreateStatus = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",secondEpisodeID,"45",schemeType,"N","","","")
			if (CreateStatus '= "")
			{ 
				s objSecond.CreateFlag = "1"
				s objSecond.ActDate = $p($h,",",1)  
				s objSecond.ActTime = $p($h,",",2)
				s sc = objSecond.%Save()
				if ($$$ISOK(sc))
				{
					s countB = countB +1
				}
			}
		}
	}
	q countA_"^"_countB
}

/// Debug:	d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmMRStatus","GetEpisodeList","2019-03-03","2021-01-01","","","","","")
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmMRStatus","GetEpisodeList","2019-03-03","2021-01-01","a","a","a","a","a","{""RegNo"":""1588""}")
Query GetEpisodeList(AStartDate As %String, AEndDate As %String, ADisDept As %String, ADocCommited As %String, ANurseCommited As %String, AGenerated As %String, AScanned As %String, ASpecCOND As %String = "") As %Query(ROWSPEC = "PatientName:%String,EpisodeNum:%String,DisDept:%String,DisDate:%String,InDept:%String,InDate:%String,PapmiNo:%String,Gender:%String,Age:%String,MainDoc:%String,MainRes:%String,DocCommited:%String,NurseCommited:%String,Generated:%String,Scanned:%String,DocCommitedDate:%String,NurseCommitedDate:%String,Transfer:%String,AutoCount:%String,ScanCount:%String,NoPaperRatio:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADisDept As %String, ADocCommited As %String, ANurseCommited As %String, AGenerated As %String, AScanned As %String, ASpecCOND As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	Set:(ASpecCOND = $CHAR(0)) ASpecCOND = ""
	If (ASpecCOND '= "")
	{
		Set jObj = ##class(%DynamicObject).%FromJSON(ASpecCOND)
		/*
		{
			"RegNo": "1111111",
			"MedRecordNo": "demo",
			"PatientName": ""
		}
		Write ##class(%DynamicObject).%FromJSON("{""RegNo"": ""1111111"",""MedRecordNo"": ""111111o"",""PatientName"": ""demo""}")
		*/
		Set (cRegNo,cMedRecordNo,cPatientName) = ""
		Set conds = jObj.%GetIterator()
		While conds.%GetNext(.key,.val) {
			Set:(key="RegNo") cRegNo = val
			Set:(key="MedRecordNo") cMedRecordNo = val
			Set:(key="PatientName") cPatientName = val
		}
		
		If (cRegNo'="") {
			Set cRegNo = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AddZero(cRegNo)
			Set PAPMI = $ORDER(^PAPERi("PAPMI_PatNo",cRegNo,""))
			Quit:(PAPMI = "") $$$OK
			Do GetByPAMI 
		}
		ElseIf (cMedRecordNo '= "")
		{
			Set PAPMIS = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(cMedRecordNo)
			For index=1:1:$l(PAPMIS,"^")
			{
				Set PAPMI = $p(PAPMIS,"^",index)
				Continue:(PAPMI = "")
				Do GetByPAMI
			}
		}
		ElseIf (cPatientName '= "")
		{
			Set PAPMI = ""
			For {
				Set PAPMI = $ORDER(^PAPERi("PAPER_PatName",cPatientName,PAPMI))
				Quit:(PAPMI = "")
				Do GetByPAMI
			}
		}
	} Else {
		s startDate = $zdh(AStartDate,3)
		s endDate = $zdh(AEndDate,3)
		for date=startDate:1:endDate
		{
			s PAADMrowId = ""
			for{
				s PAADMrowId = $O(^PAADMi("DischDate",date,PAADMrowId))
				q:(PAADMrowId="")
				d GetEpisodeList
			}
		}
	}
	q $$$OK

GetByPAMI
	Set AdmType = ""
	For {
		Set AdmType = $ORDER(^PAPERdr(PAPMI,"ADM",AdmType))
		Quit:((AdmType = "")) //||(AdmType = "O")||(AdmType = "E")
		Set PAADMrowId = ""
		For {
			Set PAADMrowId = $ORDER(^PAPERdr(PAPMI,"ADM",AdmType,PAADMrowId))
			Quit:(PAADMrowId = "")
			Set date = $PIECE($GET(^PAADM(PAADMrowId)),"^",6)
			Do GetEpisodeList
		}
	}
	Quit
	
GetEpisodeList
	Quit:(PAADMrowId="")
	s PatientId = $P($g(^PAADM(PAADMrowId)),"^",1)
	
	s PapmiNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiNo(PatientId)
	
	s Gender = $P(##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(PatientId),"^",3)
	
	s PatientName = $P($G(^PAPER(PatientId,"ALL")),"^",1)
	
	s EpisodeId = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(PatientId,"",PAADMrowId)
	
	s AdmDate = $zd(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(PAADMrowId),3)
	
	//s Age = $P(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAge(PAADMrowId),"^",1)
	Set AgeStr = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAge(PAADMrowId)
	Set ageYears = $PIECE(AgeStr,"^",1)
	Set ageMonths = $PIECE(AgeStr,"^",2)
	Set ageDays = $PIECE(AgeStr,"^",3)
	Set Age = ""
	If (ageYears'="") {
		Set Age = ageYears
	} Else {
		Set Age = ageMonths_"月"_ageDays_"天"
	}
	
	s AdmDept = $P(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(PAADMrowId),"^",3)
	
	//需自行增加取单个术语集方法
	s DisResult = "" //##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(PAADMrowId,"HDSD00.11.024","0")
	Set DisResult = ##class(EMRservice.HISInterface.PatientInfoAssist).OutDiagnos1(PAADMrowId)
	Set:(DisResult'="") DisResult = $PIECE(DisResult,"^",3)
	s Transfer = "否"
	
	s:(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).TransDeptDetail(PAADMrowId)'="") Transfer = "是"
	
	s scaninfo = ##Class(DHCEPRFS.BI.BIToEMR).GetNoPaperRatio(PAADMrowId)
	s NopageRatio = $P(scaninfo,"^",3)
	
	s DisDeptObj = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(PAADMrowId)
	
	s TDisDept = $p(DisDeptObj,"^",1)
	s DisDept = $P(DisDeptObj,"^",3)
	s Generate = "1"
	//s eprStatus = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(PAADMrowId)
	//s:(+$p(eprStatus,"^",3)=1) Generate = "1"
	s:(+$P(scaninfo,"^",2)=0) Generate = "0"
	s Scan = "1" 
	s epid = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAADMrowId,"DHC")
	try
	{
		s:(##Class(DHCEPRFS.BL.BLMRLog).GetScanIsConfirm(epid)=0) Scan = "0" 
	}catch
	{
		s Scan = "0"
	}
	
	if (((ADisDept="a") || (ADisDept=TDisDept)) && ((AScanned = "a") || (AScanned = Scan)) && ((AGenerated = "a") || (AGenerated = Generate)))
	{
		s rowId = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_PAADMrowId,""))
		
		s MainDoc = $P(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDoctor(PAADMrowId),"^",3)
		s DocCommit = "0"
		s NurseCommit = "0"
		//s Generate = "0"
		//s Scan = "0"
		s DocCommitedDate = ""
		s NurseCommitedDate = ""
		
		if (rowId = "")
		{
			if ((ADocCommited="1") || (ANurseCommited = "1") || (AGenerated = "1") || (AScanned = "1")) {}
			else
			{
				s DocCommitedDate = ""
				s NurseCommitedDate = ""
				s ^CacheTemp(repid,ind) = $lb(PatientName,EpisodeId,DisDept,$ZDATE(date,3),AdmDept,AdmDate,PapmiNo,Gender,Age,MainDoc,DisResult,DocCommit,NurseCommit,Generate,Scan,DocCommitedDate,NurseCommitedDate,Transfer,$P(scaninfo,"^",2),$P(scaninfo,"^",1),NopageRatio)
				s ind = ind + 1
			}
		}
		else
		{
			if ((ADocCommited="a") && (ANurseCommited ="a") && (AGenerated ="a") && (AScanned ="a"))
			{
				s obj = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(rowId)
				s:(obj.FlagMRCompletion =1) DocCommit = "1"
				s:(obj.FlagFinalAccount = 1) NurseCommit = "1"
				s DocCommitedDate = obj.FlagMRCompletionDate_" "_obj.FlagMRCompletionTime
				s:(DocCommitedDate'="") DocCommitedDate = $zd(DocCommitedDate,3)
				s:(DocCommitedDate = "1840-12-31") DocCommitedDate = ""
				s NurseCommitedDate = obj.FlagFinalAccountDate_" "_obj.FlagFinalAccountTime
				s:(NurseCommitedDate'="") NurseCommitedDate = $zd(NurseCommitedDate,3)
				s:(NurseCommitedDate="1840-12-31") NurseCommitedDate = ""
				s ^CacheTemp(repid,ind) = $lb(PatientName,EpisodeId,DisDept,$ZDATE(date,3),AdmDept,AdmDate,PapmiNo,Gender,Age,MainDoc,DisResult,DocCommit,NurseCommit,Generate,Scan,DocCommitedDate,NurseCommitedDate,Transfer,$P(scaninfo,"^",2),$P(scaninfo,"^",1),NopageRatio)
				s ind = ind + 1
			}
			else
			{
				s obj = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(rowId)
				s:(obj.FlagMRCompletion =1) DocCommit = "1"
				if ((ADocCommited="a") || (ADocCommited = DocCommit))
				{
					s:(obj.FlagFinalAccount = 1) NurseCommit = "1"
					if ((ANurseCommited="a") || (ANurseCommited = NurseCommit))
					{
						s DocCommitedDate = obj.FlagMRCompletionDate_" "_obj.FlagMRCompletionTime
						s:(DocCommitedDate'="") DocCommitedDate = $zd(DocCommitedDate,3)
						s:(DocCommitedDate = "1840-12-31") DocCommitedDate = ""
						s NurseCommitedDate = obj.FlagFinalAccountDate_" "_obj.FlagFinalAccountTime
						s:(NurseCommitedDate'="") NurseCommitedDate = $zd(NurseCommitedDate,3)
						s:(NurseCommitedDate="1840-12-31") NurseCommitedDate = ""
						s ^CacheTemp(repid,ind) = $lb(PatientName,EpisodeId,DisDept,$ZDATE(date,3),AdmDept,AdmDate,PapmiNo,Gender,Age,MainDoc,DisResult,DocCommit,NurseCommit,Generate,Scan,DocCommitedDate,NurseCommitedDate,Transfer,$P(scaninfo,"^",2),$P(scaninfo,"^",1),NopageRatio)
						s ind = ind + 1
					}
				}
			}
		}
	}
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
		kill ^CacheTemp(repid)
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
