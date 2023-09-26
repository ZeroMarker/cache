Class DHCEPRFS.BI.BIToWMR Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取病历状态，包括：最终结算是否完成、医生是否确认病历完成、病历PDF文件是否生成
/// Input:	AEpisodeID : 就诊rowid
/// Return:	最终结算是否完成^医生是否确认病历完成^病历PDF文件是否生成, 如
/// 		1^1^1	1^1^0
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus("1")
ClassMethod GetMedRecordStatus(AEpisodeID As %String) As %String
{
	s status = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	//s isPdfSucceed = ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).GetSucceedStatus(AEpisodeID)
	s isPdfSucceed = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordCreated(AEpisodeID)
	s necessaryStatu = ##Class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmNECStatusDHC(AEpisodeID)
	q status_"^"_isPdfSucceed_"^"_necessaryStatu
}

/// Desc:	获取病历状态，包括：最终结算是否完成、医生是否确认病历完成、病历PDF文件是否生成
/// Input:	AEpisodeID : 就诊rowid
/// Return:	最终结算是否完成^医生是否确认病历完成^病历PDF文件是否生成, 如
/// 		1^1^1	1^1^0
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus("1")
ClassMethod GetMedRecordStatusByMedRecordID(AMedRecordID As %String) As %String
{
	
	s status = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	//s isPdfSucceed = ##Class(DHCEPRFS.BL.BLAdmTaskSucceed).GetSucceedStatus(AEpisodeID)
	s isPdfSucceed = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordCreated(AEpisodeID)
	q status_"^"_isPdfSucceed
}

/// Desc:	病历复核失败时，回置病历状态
/// Input:	AEpisodeID 		  : 就诊rowid
/// 		AFinalAccountFlag ：是否回置最终结算标识, 1 或 0, 1表示需要回置
/// 		AMRCompletionFlag ：是否回置医生病历确认标识, 1 或 0, 1表示需要回置
/// 		ARemark			  : 复核备注信息, 可以为空
/// Return:	1 成功, 0 失败, -1 指定就诊不存在
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag("1", "1", "0", "备注信息")
ClassMethod SetCheckFailFlag(AEpisodeID As %String, ANeedCanelFinalAccountFlag As %String, ANeedCanelMRCompletionFlag As %String, ARemark As %String, AUserID As %String = "") As %Boolean
{
	s isOK = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID, ANeedCanelFinalAccountFlag, ANeedCanelMRCompletionFlag, ARemark, AUserID)
	q isOK
}

/// Desc:	设置病案编目信息
/// Input:	AEpisodeID : 就诊rowid
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).SetCatalogInfo("1")
ClassMethod SetCatalogInfo(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnErrSetCatalogInfo"

	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s AMRAction = "CATALOG"
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,AMRAction,AUserID)
		q:(sc="") "0"
		
		//更新MREpisode和MREpisodeFP表的信息
		s ret = ##class(DHCEPRFS.BL.BLUpdateMrEpisode).AddTask(mrEpisodeID,"100")
		q:(ret = "") "0"
		
		q "1"
	}
	else
	{
		q "0"
	}
	
OnErrSetCatalogInfo
	q "0"
}

/// Desc:	设置病案复核信息
/// Input:	AEpisodeID : 就诊rowid
/// 			AUserID : 操作用户ID
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).SetReviewInfo("1","159")
ClassMethod SetReviewInfo(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnErrSetReviewInfo"

	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s AMRAction = "REVIEW"
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,AMRAction,AUserID)
		q:(sc="") "0"
		
		q "1"
	}
	else
	{
		q "0"
	}
	
OnErrSetReviewInfo
	q "0"
}

/// Desc:	统计指定日期内、指定用户的扫描操作明细
/// Input:	AStartDate 	开始日期，Cache内部格式
/// 		AEndDate	结束日期，Cache内部格式
/// 		AUserID		用户RowID，如果此值为空，则查询指定日期内所有用户的扫描操作明细
/// 		ANeedSummarization ：是否需要计算扫描操作明细总和，0 不需要，1 需要
/// Return：一个自定义的%ResultSet，其返回列信息如下：
/// 		MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID,ScanPages,ScanDate
/// Debug:	s rs = ##Class(DHCEPRFS.BI.BIToWMR).GetScanLog("63117","63117","136","0")
ClassMethod GetScanLog(AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %ResultSet
{
	s rs = ##Class(%ResultSet).New("DHCEPRFS.BL.BLMRLog:GetScanLog")
	d rs.Execute(AStartDate,AEndDate,AUserID,ANeedSummarization)
	q rs
}

/// Desc:	统计指定日期内、指定用户的打印操作明细
/// Input:	AStartDate 	开始日期，Cache内部格式
/// 		AEndDate	结束日期，Cache内部格式
/// 		AUserID		用户RowID，如果此值为空，则查询指定日期内所有用户的打印操作明细
/// 		ANeedSummarization ：是否需要计算打印操作明细总和，0 不需要，1 需要
/// Return：一个自定义的%ResultSet，其返回列信息如下：
/// 		MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,PrintUserID,PrintPages,PrintDate,UnitPrice,TotPrice
/// Debug:	s rs = ##Class(DHCEPRFS.BI.BIToWMR).GetPrintLog("63117","63117","136","0")
ClassMethod GetPrintLog(AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %ResultSet
{
	s rs = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetPrintLog")
	d rs.Execute(AStartDate,AEndDate,AUserID,ANeedSummarization)
	q rs
}

/// Desc:	指定就诊是否被扫描
/// Input:	AEpisodeID - 患者就诊号
/// Return：1 - 已扫描，0 - 未扫描
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).HasScanned("")
ClassMethod HasScanned(AEpisodeID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).HasScannedByEpisodeID(AEpisodeID)
	q ret
}

/// Desc:	指定就诊是否被打印
/// Input:	AEpisodeID - 患者就诊号
/// Return：1 - 已打印，0 - 未打印
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).HasPrinted("")
ClassMethod HasPrinted(AEpisodeID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).HasPrintedByEpisodeID(AEpisodeID)
	q ret
}

/// Desc:	获取操作明细
/// Input:	AEpisodeID : 就诊rowid
/// Return：操作明细字符串，多个操作间以"|"分隔，userID^userName^opDate^opTime^actionCode^actionDesc
/// Debug:	w ##Class(DHCEPRFS.BI.BIToWMR).GetMRLog("7876506")
ClassMethod GetMRLog(AEpisodeID As %String) As %String
{
	s ret =  ##class(DHCEPRFS.BL.BLMRLog).GetMRLog(AEpisodeID)
	q ret
}

/// Desc: 获取科室复核状态
/// Input: AEpisodeID -- 就诊RowID
/// Return: F - 科室已复核，B - 科室已退回，U - 科室未复核
/// Debug: w ##class(DHCEPRFS.BI.BIToWMR).GetDeptReviewStatus("582")
ClassMethod GetDeptReviewStatus(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") "U"
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s status = objPat.DeptReviewStatus
	s date = objPat.DeptReviewDate
	s time = objPat.DeptReviewTime
	s userID = objPat.DeptReviewUserID
	d objPat.%Close()
	q status
}

/// Desc: 设置复核列表的病案室已复核状态
/// Input: AEpisodeID : 就诊RowID，AUserID : 操作用户ID
/// Debug: w ##Class(DHCEPRFS.BI.BIToWMR).SetReviewStatus("604","159")
ClassMethod SetReviewStatus(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnSetReviewStatusErrorHandler"
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s AMRAction = "REVIEW"
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,AMRAction,AUserID)
		q:(sc="") "0"
		
		// 更新校验病人列表的病案室复核状态
		s reviewRet = ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateReviewStatus("F",AEpisodeID,AUserID)
		q:(reviewRet '= "1") "0"
		
		q "1"
	}
	else
	{
		q "0"
	}
	
OnSetReviewStatusErrorHandler
	q "0"
}

/// Desc: 设置复核列表的病案室复核未通过状态
/// Input: AEpisodeID : 就诊RowID，AUserID : 操作用户ID
/// Debug: w ##Class(DHCEPRFS.BI.BIToWMR).SetQCBackStatus("603","159")
ClassMethod SetQCBackStatus(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s $zt = "OnSetQCBackStatusErrorHandler"
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s AMRAction = "QCBACK"
		s sc = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,AMRAction,AUserID)
		q:(sc="") "0"
		
		// 更新校验病人列表的病案室复核状态
		s reviewRet = ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateReviewStatus("B",AEpisodeID,AUserID)
		q:(reviewRet '= "1") "0"
		
		q "1"
	}
	else
	{
		q "0"
	}
	
OnSetQCBackStatusErrorHandler
	q "0"
}

/// Desc: 获取纸质项目
/// Input: AEpisodeID : 就诊RowID
/// Debug: w ##class(DHCEPRFS.BI.BIToWMR).GetPaperItems("615")
/// Output: 空-无纸质病历，非空-格式如下： 纸质病历项目1|页数1,纸质病历项目2|页数2,......纸质病历项目n|页数n
ClassMethod GetPaperItems(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ""
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s remarks = objPat.Remarks
	d objPat.%Close()
	s scanDesc = ""
	if (remarks '= "")
	{
		s scanItems = $p(remarks,"#",2)
		if (scanItems '= "")
		{
			f i=1:1:$l(scanItems,"^")
			{
				s itemInfo = $p(scanItems,"^",i)
				s itemID = $p(itemInfo,"||",1)
				s itemPages = $p(itemInfo,"||",2)
				s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemID)
				s itemName = objItem.Name
				d objItem.%Close()
				if (scanDesc '= "")
				{
					s scanDesc = scanDesc_","_itemName_"|"_itemPages
				}
				else
				{
					s scanDesc = itemName_"|"_itemPages
				}
			}
		}
	}
	q scanDesc
}

/// Desc:   取消必要条件完成标识
/// Input:  EpisodeID - 就诊rowid, UserID - 用户ID
/// Return: return=1:成功, return<1:失败
/// Debug:  w ##Class(DHCEPRFS.BI.BIToWMR).CancelNecessaryConditionDHC(AEpisodeID,AUserID)
ClassMethod CancelNecessaryConditionDHC(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).CancelNecessaryConditionDHC(AEpisodeID,AUserID)
	q ret
}

/// Desc: 注册归档就诊
/// Input: EpisodeID - 就诊rowid, UserID - 用户ID
/// Return: return=1:成功, return<1:失败
/// Debug: w ##Class(DHCEPRFS.BI.BIToWMR).RegisterAdm(AEpisodeID,AUserID)
ClassMethod RegisterAdm(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = "0"
	q:(AEpisodeID = "") ret
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	if (mrEpisodeID '= "")
	{
		s ret = "1"
		s retLog = ##class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(mrEpisodeID,"REGISTER",AUserID)
	}
	q ret
}

}
