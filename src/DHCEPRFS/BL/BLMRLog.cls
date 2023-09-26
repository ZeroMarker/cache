Class DHCEPRFS.BL.BLMRLog Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	增加日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail("1","CATALOG","2583")
/// 		w ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail("332592","CREATE","2583")
ClassMethod AddNormalLogDetail(AMREpisodeID As %String, AMRAction As %String, AActUserID As %String) As %String
{
	s ret = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, "0","0","0","")
	q ret
}

/// Desc:	增加"病历检查"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddCreateCheckLogDetail("332592","2583","3","28")
ClassMethod AddCreateCheckLogDetail(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AMRItemID As %String) As %String
{
	TSTART
	s $zt = "OnAddCCLogDtlErrorHandler"
	
	s AMRAction = "CREATECHECK"
	s detailType = "MRITEMID"
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, "0","0","0","")
	if (retLogDetailID = "") 
	{
		TROLLBACK
		q ""
	}
	else
	{
		s detailVersion = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMRItem(AMREpisodeID,AMRItemID)
		s retLogDetailSubID = ..AddMRLogDtlSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,detailType,AMRItemID,detailVersion)
		if (retLogDetailSubID = "") 
		{
			TROLLBACK
			q ""
		}
		s retLogDtlFinalID = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
		if (retLogDtlFinalID = "") 
		{
			TROLLBACK
			q ""
		}
		s retLogDtlFinalSubID = ..AddLogDtlFinalSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,retLogDtlFinalID,detailType,AMRItemID,detailVersion)
		if (retLogDtlFinalSubID = "") 
		{
			TROLLBACK
			q ""
		}
	}
	TCOMMIT
	q retLogDetailID
OnAddCCLogDtlErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	批量增加一次就诊的"病历生成"日志明细子表
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogAll("10","159")
ClassMethod AddCreateLogAll(AInputParams As %String, AUserID As %String, APageCount As %String, ASchemeType As %String = "") As %String
{
	if (AInputParams = $c(0)) s AInputParams = ""
	q:(AInputParams = "") "0"
	s flag = "true"
	s:(ASchemeType = $c(0)) ASchemeType = ""
	s AMRAction = "CREATE"
	if (ASchemeType '= "")
	{
		s AMRAction = "DELAYCREATE"
	}
	s ADetailType = "MRITEMID"

	TSTART
	s $zt = "OnAddCAllLogDtlErrorHandler"
	
	s mrLogDetailID = ""
	for i=1:1:$l(AInputParams,"#")
	{
		s aParam = $p(AInputParams,"#",i)
		s AEpisodeID = $p(aParam,"|",1)	
		s ASysCode = $p(aParam,"|",2) 
		s AMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
		if (AMREpisodeID = "")
		{
			s flag = "false"
			q	
		}
		s ATypeID = $p(aParam,"|",3)
		s APrintDocID = $p(aParam,"|",4)
		s ATotalPages = $p(aParam,"|",5)
		s ALogicID = $p(aParam,"|",6)
		s ALogicPath = $p(aParam,"|",7)
		s ASchemeType = $p(aParam,"|",8)
		
		s AMRItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType(ATypeID,APrintDocID)
		if (AMRItemID = "")
		{
			s flag = "false"
			q	
		}
		
		if (i = 1)
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AUserID, APageCount, "0", "0", "", AMRAction, ADetailType, AMRItemID,"TRUE","","")
		}
		else
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AUserID, APageCount, "0", "0", "", AMRAction, ADetailType, AMRItemID,"FALSE",mrLogDetailID,"")
		}
		if (mrLogDetailID = "")
		{
			s flag = "false"
			q	
		}
	}
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddCAllLogDtlErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	批量增加一次就诊的"扫描","扫描分类"日志明细子表
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogAll("166137","2501","4","118|120","SCAN","")
ClassMethod AddScanLogAll(AMREpisodeID As %String, AUserID As %String, APageCount As %String, AMRItemIDS As %String, AMRAction = "SCAN", AMRMedRecordID As %String = "", AIP As %String = "") As %String
{
	s flag = "true"
	s ADetailType = "MRITEMID"

	TSTART
	s $zt = "OnAddSAllLogDtlErrorHandler"
	
	s mrLogDetailID = ""
	for i=1:1:$l(AMRItemIDS,"|")
	{
		s AMRItemID = $p(AMRItemIDS,"|",i)

		if (AMRItemID = "")
		{
			s flag = "false"
			q	
		}
		
		if (i = 1)
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AUserID, APageCount, "0", "0", "", AMRAction, ADetailType, AMRItemID,"TRUE","","","",AMRMedRecordID,AIP)
		}
		else
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AUserID, APageCount, "0", "0", "", AMRAction, ADetailType, AMRItemID,"FALSE",mrLogDetailID,"","",AMRMedRecordID,AIP)
		}
		if (mrLogDetailID = "")
		{
			s flag = "false"
			q	
		}
	}
	if (flag = "true")
	{
		if (AMRAction = "SCAN")||(AMRAction = "ARRANGE")
		{
			s result = ##Class(DHCEPRFS.BL.BLMRLog).AddScanNeedArrangeLog(AMREpisodeID,AMRMedRecordID,AUserID,APageCount,AMRAction,mrLogDetailID,AIP)
			if (result = "1")
			{
				TCOMMIT
		
				q "1"
			}
			else
			{
				TROLLBACK
	  			q "0"
			}
		}
		else
		{
			TCOMMIT
		
			q "1"
		}	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddSAllLogDtlErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	增加"病历打印"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogDetail("1","2583","10","0.8","1")
ClassMethod AddPrintLogAll(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AActPrice As %String, AActSchemeID As %String, ARemark As %String, AMRItemIDS As %String, AName As %String = "", ARelationship As %String = "", AContact As %String = "", AIDNumber As %String = "", AIP As %String = "", APrintPurposeDesc As %String = "", APrintPurposeCode As %String = "") As %String
{
	s flag = "true"
	s AMRAction = "PRINT"
	s ADetailType = "MRITEMID"

	TSTART
	s $zt = "OnAddPAllLogDtlErrorHandler"
	s mrLogDetailID = ""
	for i=1:1:$l(AMRItemIDS,"|")
	{
		s params = $p(AMRItemIDS,"|",i)
		s AMRItemID = $p(params,"@",1)
		s ADetailVersion = $p(params,"@",2)
		s APageRange = $p(params,"@",3)

		if (AMRItemID = "")
		{
			s flag = "false"
			q	
		}
		
		if (i = 1)
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, ARemark, AMRAction, ADetailType, AMRItemID,"TRUE","",ADetailVersion,APageRange,"",AIP)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
			s ret = ..AddPrintInfo(mrLogDetailID,AMREpisodeID,AName,ARelationship,AContact,AIDNumber,ARemark,APrintPurposeDesc,APrintPurposeCode)
			if (ret = "-1")
			{
				s flag = "false"
				q			
			}
		}
		else
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, ARemark, AMRAction, ADetailType, AMRItemID,"FALSE",mrLogDetailID,ADetailVersion,APageRange,"",AIP)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
		}
	}

	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddPAllLogDtlErrorHandler
	TROLLBACK
	q ""
}

ClassMethod AddPrintInfo(AMRLogDetailID As %String, AMREpisodeID As %String, AName As %String, ARelationship As %String, AContact As %String, AIDNumber As %String, ARemarks As %String = "", APrintPurposeDesc As %String = "", APrintPurposeCode As %String = "") As %String
{
	s obj = ##class(DHCEPRFS.INST.PrintInfo).%New()
	s obj.MRLogDetailID = AMRLogDetailID
	s obj.MREpisodeID = AMREpisodeID
	s obj.Name = AName
	s obj.Relationship = ARelationship
	s obj.IDNumber = AIDNumber
	s obj.Contact = AContact
	s obj.Remarks = ARemarks
	s obj.PrintPurposeCode = APrintPurposeCode
	s obj.PrintPurposeDesc = APrintPurposeDesc
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()		
	}
	else
	{
		q "-1"
	}
}

ClassMethod AddLogDetailWOT(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AActPrice As %String, AActSchemeID As %String, ARemark As %String, AMRAction As %String = "", ADetailType As %String = "", AMRItemID As %String = "", ANeedCreateDetail As %String = "", AMRLogDetailID As %String = "", ADetailVersion As %String = "", APageRange As %String = "", AMRMedRecordID As %String = "", AIP As %String = "") As %String
{
	if (ANeedCreateDetail = "TRUE")
	{
		s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, AActPages,AActPrice,AActSchemeID,ARemark,AMRMedRecordID,AIP)
	}
	else
	{
		s retLogDetailID = AMRLogDetailID	
	}
	
	
	if (retLogDetailID = "") 
	{
		q ""
	}
	else
	{
		s retLogDtlFinalID = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID,AMRMedRecordID)
		if (retLogDtlFinalID = "") 
		{
			q ""
		}
		s:(AMRItemID = $c(0)) AMRItemID = ""
		if (AMRItemID '= "")
		{
			s:(ADetailVersion = $c(0)) ADetailVersion = ""
			if (ADetailVersion = "")
			{
				s type = ""
				s id = AMREpisodeID
				s:(AMRMedRecordID '= "") id = AMRMedRecordID
				s:(AMRMedRecordID '= "") type = "MEDRECORD"
				s detailVersion = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMRItem(id,AMRItemID,type)
			}
			else
			{
				s detailVersion = ADetailVersion
			}
			s retLogDetailSubID = ..AddMRLogDtlSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,ADetailType,AMRItemID,detailVersion,APageRange,AMRMedRecordID)
			if (retLogDetailSubID = "") 
			{
				q ""
			}
			s retLogDtlFinalSubID = ..AddLogDtlFinalSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,retLogDtlFinalID,ADetailType,AMRItemID,detailVersion,APageRange,AMRMedRecordID)
			if (retLogDtlFinalSubID = "") 
			{
				q ""
			}
		}
	}
	
	q retLogDetailID
}

/// Desc:	增加"病历生成"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogDetail("1","2583",12)
ClassMethod AddCreateLogDetail(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AMRItemID As %String = "") As %String
{
	TSTART
	s $zt = "OnAddCLogDtlErrorHandler"
	s AMRAction = "CREATE"
	s detailType = "MRITEMID"
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, AActPages,"0","0","")
	if (retLogDetailID = "") 
	{
		TROLLBACK
		q ""
	}
	else
	{
		s retLogDtlFinalID = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
		if (retLogDtlFinalID = "") 
		{
			TROLLBACK
			q ""
		}
		s:(AMRItemID = $c(0)) AMRItemID = ""
		if (AMRItemID '= "")
		{
			s detailVersion = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMRItem(AMREpisodeID,AMRItemID)
			s retLogDetailSubID = ..AddMRLogDtlSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,detailType,AMRItemID,detailVersion)
			if (retLogDetailSubID = "") 
			{
				TROLLBACK
				q ""
			}
			s retLogDtlFinalSubID = ..AddLogDtlFinalSub(AMREpisodeID, AMRAction,AActUserID,retLogDetailID,retLogDtlFinalID,detailType,AMRItemID,detailVersion)
			if (retLogDtlFinalSubID = "") 
			{
				TROLLBACK
				q ""
			}
		}
	}
	
	TCOMMIT
	q retLogDetailID
OnAddCLogDtlErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	增加"老病历确认"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddOldConfirmLogDetail("1")
ClassMethod AddOldConfirmLogDetail(AMREpisodeID As %String, AActUserID As %String) As %String
{
	s AMRAction = "OLDCONFIRM" 
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, "0","0","0","")
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加"老病历生成"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddOldCreateLogDetail("1")
ClassMethod AddOldCreateLogDetail(AEpisodeID As %String) As %String
{
	s AMRAction = "OLDCREATE"
	s AMREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,""))
	q:(AMREpisodeID = "") "-1"
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, "", "0","0","0","")
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加"确认扫描"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddConfirmScanLogDetail("1","2583","12")
ClassMethod AddConfirmScanLogDetail(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AIP As %String = "") As %String
{
	s AMRAction = "CONFIRMSCAN"
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, AActPages, "0", "0","","",AIP)
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加"删除扫描"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogDetail("1","2583","12")
ClassMethod AddScanDeleteLogDetail(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AIP As %String = "") As %String
{
	s AMRAction = "SCANDELETE"
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, AActPages, "0", "0","","",AIP)
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加"就诊装箱"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddOldConfirmLogDetail("1")
ClassMethod AddAdm2BoxLogDetail(AMREpisodeID As %String, AActUserID As %String) As %String
{
	s AMRAction = "ADDADM2BOX" 
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, "0","0","0","")
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加"修改就诊装箱"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddOldConfirmLogDetail("1")
ClassMethod ModifyAdm2BoxLogDetail(AMREpisodeID As %String, AActUserID As %String) As %String
{
	s AMRAction = "MODIFYADM2BOX" 
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, "0","0","0","")
	if (retLogDetailID '= "")
	{
		s ret2 = ..AddLogDtlFinal(AMREpisodeID, AMRAction, retLogDetailID)
	}
	
	q retLogDetailID
}

/// Desc:	增加日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetail("1","CREATE","2583","10","0","0")
ClassMethod AddMRLogDetail(AMREpisodeID As %String, AMRAction As %String, AActUserID As %String, AActPages As %String, AActPrice As %String, AActSchemeID As %String, ARemark As %String = "", AMRMedRecordID As %String = "", AIP As %String = "") As %String
{
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)

	if (AMRMedRecordID '= "")
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMRMedRecord"," "_AMRMedRecordID,""))
	}
	else
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))	
	}

	if (mrLogID = "")
	{
		s prevStatus = "INITIALIZED"
		s postStatus = ##Class(DHCEPRFS.BL.BLMRTransition).GetPostStatus(prevStatus,AMRAction)
		s mrLogID = ..CreateMRLog(AMREpisodeID, postStatus, nowDate, nowTime, AActUserID, AActPages, AMRAction, AMRMedRecordID)
		q:(mrLogID="") ""
		
		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
		q:(objMRLog="") ""
	}
	else
	{
		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
		q:(objMRLog="") ""
		
		s prevStatus = objMRLog.MRStatus
		s postStatus = ##Class(DHCEPRFS.BL.BLMRTransition).GetPostStatus(prevStatus,AMRAction)
		
		s objMRLog.MRStatus = postStatus
		s objMRLog.ModifyDate = nowDate
		s objMRLog.ModifyTime = nowTime
		s objMRLog.ModifyUserID = AActUserID
		if ((AMRAction = "CREATE")||(AMRAction = "DELAYCREATE"))
		{
			s objMRLog.GenPages = AActPages
		}
		elseif (AMRAction = "SCAN")||(AMRAction = "ARRANGE")
		{
			s objMRLog.ScanPages = AActPages
		}
	}
	
	s isPageAction = ##Class(DHCEPRFS.BL.BLMRTransition).IsPageAction(AMRAction,objMRLog.PageStatus)
	if (isPageAction = "1")
	{
		s pagePostStatus = ##Class(DHCEPRFS.BL.BLMRTransition).GetPagePostStatus(objMRLog.PageStatus,AMRAction,objMRLog.MREpisodeID)
		s objMRLog.PageStatus = pagePostStatus
		s objMRLog.PageModifyDate = nowDate
		s objMRLog.PageModifyTime = nowTime
		s objMRLog.PageModifyUserID = AActUserID
	}
	
	s mrLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%New()
	s mrLogDetail.DetailNum = objMRLog.TheMRLogDetail.Count() + 1
	if (AMRMedRecordID '= "")
	{
		s mrLogDetail.MREpisodeID = ""
		s mrLogDetail.MRMedRecordID = AMRMedRecordID	
	}
	else
	{
		s mrLogDetail.MREpisodeID = AMREpisodeID
		s mrLogDetail.MRMedRecordID = ""
	}
	s mrLogDetail.PrevStatus = prevStatus
	s mrLogDetail.PostStatus = postStatus
	s mrLogDetail.MRAction = AMRAction
	s mrLogDetail.ActDate = nowDate
	s mrLogDetail.ActTime = nowTime
	s mrLogDetail.ActUserID = AActUserID
	s mrLogDetail.ActPages = AActPages
	s mrLogDetail.ActPrice = AActPrice
	s mrLogDetail.ActSchemeID = AActSchemeID
	s mrLogDetail.Remark = ARemark
	s mrLogDetail.TheMRLog = objMRLog
	s mrLogDetail.IP = AIP
	
	s sc = objMRLog.%Save()
	if ($$$ISOK(sc))
	{
		q mrLogDetail.%Id()		
	}
	else
	{
		q ""
	}
}

/// Desc:	增加日志子明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetailSub("1","CREATE","2583","10","0","0")
ClassMethod AddMRLogDtlSub(AMREpisodeID As %String, AMRAction As %String, AActUserID As %String, AMRLogDetailID As %String, ADetailType As %String, AMRItemID As %String, ADetailVersion As %String, APageRange As %String = "", AMRMedRecordID As %String = "") As %String
{
	//b "s"
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	s mrLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(AMRLogDetailID)
	
	s mrLogDetailSub = ##Class(DHCEPRFS.INST.MRLogDetailSub).%New()
	s mrLogDetailSub.TheMRLogDetail = mrLogDetail
	s mrLogDetailSub.DetailNum = mrLogDetail.TheMRLogDetailSub.Count() + 1
	if (AMRMedRecordID '= "")
	{
		s mrLogDetailSub.MREpisodeID = ""
		s mrLogDetailSub.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s mrLogDetailSub.MREpisodeID = AMREpisodeID
		s mrLogDetailSub.MRMedRecordID = ""
	}
	s mrLogDetailSub.MRAction = AMRAction
	s mrLogDetailSub.ActUserID = AActUserID
	s mrLogDetailSub.CreateDate = nowDate
	s mrLogDetailSub.CreateTime = nowTime
	s mrLogDetailSub.DetailType = ADetailType
	s mrLogDetailSub.DetailID = AMRItemID
	s mrLogDetailSub.DetailVersion = ADetailVersion
	s mrLogDetailSub.PageRange = APageRange
	
	s sc = mrLogDetail.%Save()
	if ($$$ISOK(sc))
	{
		q mrLogDetailSub.%Id()		
	}
	else
	{
		q ""
	}
}

/// Desc:	获取日志ID
ClassMethod GetMRLogID(AMREpisodeID As %String) As %String
{
	s rowID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q rowID
}

/// Desc:	创建MRLog
ClassMethod CreateMRLog(AMREpisodeID As %String, AMRStatus As %String, AActDate As %String, AActTime As %String, AActUserID As %String, AActPages As %String, AMRAction As %String, AMRMedRecordID As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.INST.MRLog).%New()
	if (AMRMedRecordID '= "")
	{
		s obj.MREpisodeID = ""
		s obj.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s obj.MREpisodeID = AMREpisodeID
		s obj.MRMedRecordID = ""		
	}

	s obj.MRStatus = AMRStatus
	s obj.CreateDate = AActDate
	s obj.CreateTime = AActTime
	s obj.CreateUserID = AActUserID
	s obj.ModifyDate = AActDate
	s obj.ModifyTime = AActTime
	s obj.ModifyUserID = AActUserID
	if ((AMRAction = "CREATE")||(AMRAction = "DELAYCREATE"))
	{
		s obj.GenPages = AActPages
		s obj.ScanPages = "0"
	}
	elseif (AMRAction = "SCAN")||(AMRAction = "ARRANGE")
	{
		s obj.GenPages = "0"
		s obj.ScanPages = AActPages
	}
	else
	{
		s obj.GenPages = "0"
		s obj.ScanPages = "0"
	}
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	更新MRLog
ClassMethod UpdateMRLog(AMRLogID, AMRStatus, AActDate, AActTime, AActUserID, AActPages, AMRAction) As %String
{
}

/// Desc:	增加日志(最终记录)
ClassMethod AddLogDtlFinal(AMREpisodeID As %String, AMRAction As %String, ALogDetailID As %String, AMRMedRecordID As %String = "") As %String
{
	q:(ALogDetailID="") ""
	
	if (AMRMedRecordID '= "")
	{
		s logDtlFinalID = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRMedRecord"," "_AMRMedRecordID," "_AMRAction,""))
	}
	else
	{
		s logDtlFinalID = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMain"," "_AMREpisodeID," "_AMRAction,""))	
	}

	if (logDtlFinalID = "")
	{
		s objLogDtlFinal = ##Class(DHCEPRFS.INST.MRLogDtlFinal).%New()
		s objLogDtlFinal.CreateDate = $p($h,",",1)
		s objLogDtlFinal.CreateTime = $p($h,",",2)
	}
	else
	{
		s objLogDtlFinal = ##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(logDtlFinalID)
	}
	
	s objLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(ALogDetailID)
	
	s objLogDtlFinal.DetailNum = objLogDetail.DetailNum
	s objLogDtlFinal.MRAction = objLogDetail.MRAction
	s objLogDtlFinal.PrevStatus = objLogDetail.PrevStatus
	s objLogDtlFinal.PostStatus = objLogDetail.PostStatus
	s objLogDtlFinal.ActUserID = objLogDetail.ActUserID
	s objLogDtlFinal.ActDate = objLogDetail.ActDate
	s objLogDtlFinal.ActTime = objLogDetail.ActTime
	s objLogDtlFinal.ActPages = objLogDetail.ActPages
	s objLogDtlFinal.ActPrice = objLogDetail.ActPrice
	s objLogDtlFinal.ActSchemeID = objLogDetail.ActSchemeID
	s objLogDtlFinal.Remark = objLogDetail.Remark
	s objLogDtlFinal.TheMRLogID = $p(ALogDetailID,"||",1)
	if (AMRMedRecordID '= "")
	{
		s objLogDtlFinal.MREpisodeID = ""
		s objLogDtlFinal.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s objLogDtlFinal.MREpisodeID = AMREpisodeID
		s objLogDtlFinal.MRMedRecordID = ""	
	}
	
	s sc = objLogDtlFinal.%Save()
	if ($$$ISOK(sc))
	{
		q objLogDtlFinal.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	增加最终日志子明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddMRLogDetail("1","CREATE","2583","10","0","0")
ClassMethod AddLogDtlFinalSub(AMREpisodeID As %String, AMRAction As %String, AActUserID As %String, AMRLogDetailID As %String, AMRLogDtlFinalID As %String, ADetailType As %String, AMRItemID As %String, ADetailVersion As %String, APageRange As %String = "", AMRMedRecordID As %String = "") As %String
{
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	s mrLogDtlFinal = ##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(AMRLogDtlFinalID)
	//b "s"
	s mrLogDtlFinalSubID = $o(^DHCEPRFS.INST.MRLogDtlFSubI("IdxMain",AMRLogDtlFinalID," "_AMRAction," "_ADetailType," "_AMRItemID,""))
	if (mrLogDtlFinalSubID = "")
	{
		s mrLogDtlFinalSub = ##Class(DHCEPRFS.INST.MRLogDtlFinalSub).%New()
		s mrLogDtlFinalSub.CreateDate = nowDate
		s mrLogDtlFinalSub.CreateTime = nowTime
	}
	else
	{
		s mrLogDtlFinalSub = ##Class(DHCEPRFS.INST.MRLogDtlFinalSub).%OpenId(AMRLogDtlFinalID_"||"_mrLogDtlFinalSubID)
	}
	
	s mrLogDtlFinalSub.TheMRLogDtlFinal = mrLogDtlFinal
	s mrLogDtlFinalSub.DetailNum = mrLogDtlFinal.TheMRLogDtlFinalSub.Count() + 1
	if (AMRMedRecordID '= "")
	{
		s mrLogDtlFinalSub.MREpisodeID = ""
		s mrLogDtlFinalSub.MRMedRecordID = AMRMedRecordID
	}
	else
	{
		s mrLogDtlFinalSub.MREpisodeID = AMREpisodeID
		s mrLogDtlFinalSub.MRMedRecordID = ""	
	}

	s mrLogDtlFinalSub.MRAction = AMRAction
	s mrLogDtlFinalSub.ActUserID = AActUserID
	s mrLogDtlFinalSub.ModifyDate = nowDate
	s mrLogDtlFinalSub.ModifyTime = nowTime
	s mrLogDtlFinalSub.DetailType = ADetailType
	s mrLogDtlFinalSub.DetailID = AMRItemID
	s mrLogDtlFinalSub.DetailVersion = ADetailVersion
	s mrLogDtlFinalSub.PageRange = APageRange
	s mrLogDtlFinalSub.TheMRLogDetailID = AMRLogDetailID
	
	s sc = mrLogDtlFinal.%Save()
	if ($$$ISOK(sc))
	{
		q mrLogDtlFinalSub.%Id()		
	}
	else
	{
		q ""
	}
}

/// Desc:	获取
ClassMethod GetMRLogDtlFinalID(AMREpisodeID, AMRAction) As %String
{
	s rowID = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMain"," "_AMREpisodeID," "_AMRAction,""))
	q rowID
}

/// Desc:	PDF病历是否已经离线成功
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).IsRecordCreated("5482366")
ClassMethod IsRecordCreated(AEpisodeID) As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID="") "0"
	
	s mrLogID = ..GetMRLogID(mrEpisodeID)
	q:(mrLogID="") "0"
	
	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	q:(objMRLog="") "0"
	
	s status = objMRLog.MRStatus
	s objMRLog = ""
	
	q:(status = "INITIALIZED") "0"
	q:(status = "CONFIRMED") "0"
	
	q "1"
}

/// add by YHY
/// Desc:科室审核通过
/// 返回值: DEPTREVIEWED:审核通过  0:未审核  2:病案室审核退回  INITIALIZED:科室审核退回
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed("15784110")
ClassMethod IsRecordPassed(AEpisodeID) As %String
{
	s status = ##class(DHCWMR.IO.ToEmrSrv).GetMrCurrStatus(AEpisodeID)
	q:(status = "病历复核不通过") "2"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID="") "0"
	

	
	//审核通过只需要判断是否有审核通过，若有审核通过，并且最后一次科室或病案审核后无科室退回或者病案退回则审核通过
	//先判断科室通过后有没有病案通过
	s ret = ..CheckTwoAction(mrEpisodeID,"DEPTREVIEW","REVIEW")
	if ($p(ret,"^",1) = "1")
	{
		//科室通过,病案通过,且病案通过在科室通过后
		if (($p(ret,"^",2) = "1") && ($p(ret,"^",3) = "1"))
		{
			s ret1 = ..CheckTwoAction(mrEpisodeID,"REVIEW","DEPTQCBACK")
			s ret2 = ..CheckTwoAction(mrEpisodeID,"REVIEW","QCBACK")
		}
		//无病案通过或者病案通过在科室通过前
		else
		{
			//是否有退回
			s ret1 = ..CheckTwoAction(mrEpisodeID,"DEPTREVIEW","DEPTQCBACK")
			s ret2 = ..CheckTwoAction(mrEpisodeID,"DEPTREVIEW","QCBACK")
		}	
	} 
	else
	{
		//无科室通过，判断是否有病案通过，并通过后是否有退回
		s ret1 = ..CheckTwoAction(mrEpisodeID,"REVIEW","DEPTQCBACK")
		s ret2 = ..CheckTwoAction(mrEpisodeID,"REVIEW","QCBACK")
	}

	s flag = "false"
	//有退回发生
	if (($p(ret1,"^",2)= "1") || ($p(ret2,"^",2)= "1"))
	{
		//退回在最后一次通过前，则为通过
		if (($p(ret1,"^",3) = "0") && ($p(ret2,"^",3)="0"))
		{
			//判断是否仅仅存在退回而没有通过
			if ($p(ret1,"^",1)= "1") 
			{
				q "DEPTREVIEWED"
			}
			else
			{
				//有退回，没有通过，需判读医生提交
				s flag = "true"	
			}
		}
		//退回在最后一次通过后，需判断医生提交
		else
		{
			s flag = "true"	
		}
	}
	else
	{
		//无退回发生
		//有通过
		if (($p(ret1,"^",1)= "1") || ($p(ret2,"^",1)= "1"))
		{
			q "DEPTREVIEWED"
		}
		//无通过，需判断医生提交
		else
		{
			s flag = "true"	
		}
	}
	
	if (flag = "true")
	{
		//此处已不用考虑通过，仅剩余退回和需审核
		
		//病案审核退回，需比较退回后是否再次提交
		s ret = ..CheckActionAndStatus(AEpisodeID,"QCBACK")
		//发生病案审核退回，并且之后没有医生提交，则是审核退回
		q:($p(ret,"^",1) = "1")&&($p(ret,"^",3) = "0") "2" 
	
		//科室审核退回，需要比较退回后是否再次提交
		s ret = ..CheckActionAndStatus(AEpisodeID,"DEPTQCBACK")
		//发生科室审核退回，并且之后没有医生提交，则是审核退回
		q:($p(ret,"^",1) = "1")&&($p(ret,"^",3) = "0") "INITIALIZED" 
	
	}
	//其他情况均需要审核
	q "0"
	
	/*
	
		s mrLogID = ..GetMRLogID(mrEpisodeID)
	q:(mrLogID="") "0"
	
	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	q:(objMRLog="") "0"
	
	s status = objMRLog.MRStatus
	s objMRLog = ""
	q:(status = "CREATED") "0"  
	q:(status = "CONFIRMED") "0"
	
	q status
	*/
}

/// Desc: 判断A事件是否有，医生提交是否有，并且A事件后是否发生医生提交
/// Output: 1^1^1，第一位表示A 1-有，0-无，第二位表示B 1-有，0-无，当前两位为1第三位才有意义，第三位表示A事件后是否发生B，有-1，无-0
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).CheckActionAndStatus("15945832","DEPTREVIEW")
ClassMethod CheckActionAndStatus(AEpisodeID As %String, AAction As %String)
{
	s ret1 = "0"
	s ret2 = "0"
	s ret3 = "0"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))	
	
	q:(mrLogID = "") ret1_"^"_ret2_"^"_ret3
	
	//最后一个事件
	s mrLogDetailID = ""
	s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_$zcvt(AAction,"u"),mrLogDetailID),-1)
	s:((mrLogDetailID '= "") && (mrLogDetailID '= $c(0))) ret1 = "1"
	
	//医生最后一次提交
	s admMRStatusID = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,admMRStatusID))
	//不存在说明没有提交过，可提交
	q:(admMRStatusID = "") ret1_"^"_ret2_"^"_ret3
	//存在，取医生是否提交
	s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
	s flagMRCompletion = objAdmMRStatus.FlagMRCompletion
	if ((flagMRCompletion = "") || (flagMRCompletion = $c(0)))
	{
		//医生未提交过，可提交
		q ret1_"^"_ret2_"^"_ret3
	}
	else
	{
		s ret2 = "1"	
	}
	
	if ((ret1 = "1") && (ret2 = "1"))
	{
		//事件A发生日期时间	
		s objA = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailID)
		s actionADate = objA.ActDate
		s actionATime = objA.ActTime
		//医生提交日期时间
		s commitDate = objAdmMRStatus.FlagMRCompletionDate
		s commitTime = objAdmMRStatus.FlagMRCompletionTime	
		
		s:(actionADate < commitDate) ret3 = "1"
		s:((actionADate = commitDate) && (actionATime < commitTime)) ret3 = "1"
	}
	q ret1_"^"_ret2_"^"_ret3
}

/// Desc: 判断A事件是否有，B事件是否有，并且A事件后是否发生B事件
/// Output: 1^1^1，第一位表示A 1-有，0-无，第二位表示B 1-有，0-无，当前两位为1第三位才有意义，第三位表示A事件后是否发生B，有-1，无-0
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).CheckTwoAction("858","REVIEW","SCAN")
ClassMethod CheckTwoAction(AMREpisodeID As %String, AActionA As %String, AActionB As %String)
{
	s ret1 = "0"
	s ret2 = "0"
	s ret3 = "0"
	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))	
	
	q:(mrLogID = "") ret1_"^"_ret2_"^"_ret3
	
	//最后一个事件A
	s mrLogDetailAID = ""
	s mrLogDetailAID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_$zcvt(AActionA,"u"),mrLogDetailAID),-1)
	s:((mrLogDetailAID '= "") && (mrLogDetailAID '= $c(0))) ret1 = "1"
	
	//最后一个事件B
	s mrLogDetailBID = ""
	s mrLogDetailBID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_$zcvt(AActionB,"u"),mrLogDetailBID),-1)
	s:((mrLogDetailBID '= "") && (mrLogDetailBID '= $c(0))) ret2 = "1"
	
	if ((ret1 = "1") && (ret2 = "1"))
	{
		//事件A发生日期时间	
		s objA = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailAID)
		s actionADate = objA.ActDate
		s actionATime = objA.ActTime
		//事件B发生日期时间
		s objB = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailBID)
		s actionBDate = objB.ActDate
		s actionBTime = objB.ActTime	
		
		s:(actionADate < actionBDate) ret3 = "1"
		s:((actionADate = actionBDate) && (actionATime < actionBTime)) ret3 = "1"
	}
	q ret1_"^"_ret2_"^"_ret3
}

/// Desc:	是否已经扫描过（入参EpisodeID）
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).HasScannedByEpisodeID("1")
ClassMethod HasScannedByEpisodeID(AEpisodeID As %String) As %String
{
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC", " "_AEpisodeID,""))
	q:(mrEpisodeID = "") "0"
	q ..HasScanned(mrEpisodeID)
}

/// Desc:	是否已经扫描过
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).HasScanned("1")
ClassMethod HasScanned(AMRID As %String, AType As %String = "") As %String
{
	if (AType '= "")
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMRMedRecord"," "_AMRID,""))
	}
	else
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMRID,""))	
	}

	q:(mrLogID = "") "0"
	
	s mrLogDetailSubID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," SCAN",""))
	q:(mrLogDetailSubID = "") "0"
	
	q "1"
}

/// Desc:	是否已经打印过（入参EpisodeID）
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).HasPrintedByEpisodeID("1")
ClassMethod HasPrintedByEpisodeID(AEpisodeID As %String) As %String
{
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC", " "_AEpisodeID,""))
	q:(mrEpisodeID = "") "0"
	q ..HasPrinted(mrEpisodeID)
}

/// Desc:	是否已经打印过
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).HasPrinted("1")
ClassMethod HasPrinted(AMREpisodeID As %String) As %String
{
	s mrLogID = ..GetMRLogID(AMREpisodeID)
	q:(mrLogID = "") "0"
	
	s mrLogDetailSubID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," PRINT",""))
	q:(mrLogDetailSubID = "") "0"
	
	q "1"
}

ClassMethod GeCheckScanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GeCheckScanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GeCheckScanListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String = "", AUserName As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	q:(AStartDate = "")
	q:(AEndDate = "")
	s AStartDate = $zdh(AStartDate,3)
	s AEndDate = $zdh(AEndDate,3)
	
 	if (AMedRecordNo '= "")
 	{
	 	s mrEpisodeID = ""
	 	for {
	 		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordNo,mrEpisodeID))
	 		q:(mrEpisodeID = "")
	 		s mrLogID = ""
	 		for {
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID, mrLogID))
				q:(mrLogID="")
				s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,subID))	
					q:(subID="")	
					s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
					continue:(objMRLogDetail="") 
					continue:(objMRLogDetail.MRAction '= "REVIEW")
					continue:((objMRLogDetail.ActDate < AStartDate) || (objMRLogDetail.ActDate > AEndDate))	
			
					s actDate = objMRLogDetail.ActDate
					s actTime = objMRLogDetail.ActTime
					
					s mrLogDetailID = mrLogID_"||"_subID
	 				
	 				d OutputGeCheckScanList(mrLogID,mrLogDetailID,actDate,actTime,AUserName)  
				}
			}
		}
	}
	else
	{
		s date = ""
 		for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
	 			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," REVIEW",date,time))
	 			q:(time = "")
	 			s mrLogID = ""
	 			for {
	 				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," REVIEW",date,time,mrLogID))
	 				q:(mrLogID = "")
	 				s subID = ""
	 				for {
		 				s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," REVIEW",date,time,mrLogID,subID))
	 					q:(subID = "")
	 					s mrLogDetailID = mrLogID_"||"_subID
	 				
	 					d OutputGeCheckScanList(mrLogID,mrLogDetailID,date,time,AUserName)  
	 				}
	 			}
	 		} 
 		}
	}
 	q $$$OK
 	
 	
OutputGeCheckScanList(mrLogID,mrLogDetailID,date,time,AUserName)
	
	s objMRLog = ##class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	s mrEpisodeID = objMRLog.MREpisodeID
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	s objMRLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
	s reviewUserID = objMRLogDetail.ActUserID
	s reviewUserName = ""
	if (reviewUserID '= "")
	{   
		if ($p(reviewUserID,"^",1) = "TEMP")
    	{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(reviewUserID,"^",2))
			s reviewUserName = objUser.UserName    
		}
		else
		{
    		s reviewUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(reviewUserID)
		}	
	}
	
	s MedRecordNo = objMREpisode.MedRecordNo 
	s DisDateTime = ""
	s DisDate = objMREpisode.DisDate
	s DisTime = objMREpisode.DisTime
	//可能在生成时出院日期为空（没办出院），则此时在扫描查询时存在这种情况则更新就诊信息（扫描时一般已办出院）
	if ((DisDate = "") || (DisDate = $c(0)))
	{
		d objMREpisode.%Close()
		d ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisodeData(mrEpisodeID)
		s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)  
		s DisDate = objMREpisode.DisDate
		s DisTime = objMREpisode.DisTime
	}

	if (DisDate '= "") s DisDateTime = $zd(DisDate,3)
	if (DisTime '= "") s DisDateTime = DisDateTime_" "_$zt(DisTime,3)
    s DisLoc = objMREpisode.DisLoc
    s mrPatientID = objMREpisode.MRPatientID
	
    s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
    s Name = objMRPatient.Name
    
    s ReviewDateTime = ""
    if (date '= "") s ReviewDateTime = $zd(date,3)
	if (time '= "") s ReviewDateTime = ReviewDateTime_" "_$zt(time,3)
	//b "s"
	//最后一次扫描
	s scanUser = ""
	s scanDateTime = ""
	s scanLogSub = ""
	
	s scanLogSub = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," SCAN",scanLogSub),-1)
	if (scanLogSub '= "")
	{	
		s scanLogDetail = mrLogID_"||"_scanLogSub
		s objScanLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(scanLogDetail)
		s scanUserID = objScanLogDetail.ActUserID
		if (scanUserID '= "")
		{   
			if ($p(scanUserID,"^",1) = "TEMP")
    		{
				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(scanUserID,"^",2))
				s scanUser = objUser.UserName    
			}
			else
			{
    			s scanUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(scanUserID)
			}	
		}

		s scanDate = objScanLogDetail.ActDate
		s scanTime = objScanLogDetail.ActTime
		s:(scanDate '= "") scanDateTime = $zd(scanDate,3)_" "_$zt(scanTime,3)
	}
	
	if ((AUserName '= "") && (AUserName '= scanUser))
	{
		q	
	}
	
    s ^CacheTemp(repid,ind) = $lb(mrEpisodeID,MedRecordNo,Name,DisLoc,DisDateTime,reviewUserName,ReviewDateTime,scanUser,scanDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GeCheckScanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GeCheckScanListExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	获取待扫描的患者列表(已复核或者已编目过但未进行过病历扫描的患者，因为编目和扫描并行，所以看当前状态为复核或者编目的都是应该扫描的，而复核或编目后扫描状态都改为SCANNED)
/// 		一般来说，是获取在指定日期内编目过但未进行过病历扫描的患者，此患者当前状态为“病案编目”
/// Input：	AStartDate 	起始日期(Cache内部格式)，起始日期筛选的是编目日期
/// 		AEndDate 	结束日期(Cache内部格式)，结束日期筛选的是编目日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GeCheckScanList","2017-07-21","2017-07-21","91224439","")
Query GeCheckScanList(AStartDate As %String, AEndDate As %String, AMedRecordNo As %String = "", AUserName As %String = "") As %Query(ROWSPEC = "MREpisodeID:%String,MedRecordNo:%String,Name:%String,DisLoc:%String,DisDateTime:%String,ReviewUserName:%String,ReviewDateTime:%String,ScanUserName:%String,ScanDateTime:%String")
{
}

ClassMethod GetToBeScannedPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToBeScannedPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetToBeScannedPatExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ANeedRescan As %String = "", AUserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s mrLogID = ""
 	for {
	 	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxPageStatus"," TOSCAN",mrLogID))
	 	q:(mrLogID = "")
	 	
	 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	 	q:(objMRLog = "")
	 	
	 	s actDate = objMRLog.PageModifyDate
	 	s actUser = objMRLog.PageModifyUserID
	 	
	 	continue:(AStartDate '= "")&&(AStartDate > actDate)
	 	continue:(AEndDate '= "")&&(AEndDate < actDate)
	 	continue:(AUserID '= "")&&(AUserID '= actUser)
	 				
		s:(actDate'="")&&(actDate'=$c(0)) actDate = $zd(actDate,3) 	
		s:(actUser'="") actUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUser) 	
		
	 	s mrEpisodeID = objMRLog.MREpisodeID
	 	d OutputToBeScannedPat(mrEpisodeID,actUser,actDate)   
 	}
 	q $$$OK
	/*
	d GetToBeScannedPat("CATALOGED","CATALOG")
	d GetToBeScannedPat("REVIEWED","REVIEW")
 	
 	q $$$OK
 
GetToBeScannedPat(flagStatus,flagAction)
 	s mrLogID = ""
 	for {
	 	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMRStatus"," "_flagStatus,mrLogID))
	 	q:(mrLogID = "")
	 	
	 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	 	q:(objMRLog = "")
	 	
	 	
	 	s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_flagAction,""),-1)
		continue:(subID = "")
		
		s mrLogDetailID = mrLogID_"||"_subID
		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
		continue:(objMRLogDetail="")
		
		s catalogUser = objMRLogDetail.ActUserID
		s catalogUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(catalogUser) 	
		s catalogDate = objMRLogDetail.ActDate
		s:(catalogDate'="")&&(catalogDate'=$c(0)) catalogDate = $zd(catalogDate,3) 	
		 
	 	if (AStartDate '= "")||(AEndDate '= "")
	 	{
		 	//s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_flagAction,""),-1)
		 	//s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
		 	if (objMRLogDetail '= "")
		 	{
	 			continue:(AStartDate '= "")&&(AStartDate > objMRLogDetail.ActDate)
	 			continue:(AEndDate '= "")&&(AEndDate < objMRLogDetail.ActDate)
		 	}
	 	}
	 	
	 	//判断是否之前扫描过
		s userID = ""
		&sql(select ActUserID into :userID from DHCEPRFS_INST.MRLogDetail where TheMRLog = :mrLogID AND MRAction = "SCAN")

	 	if (ANeedRescan = "")
	 	{
	 		//已扫描过跳过
	 		continue:(userID '= "")
	 	}
	 	else
	 	{
			continue:(userID = "")
			continue:(userID '= AUserID)
			s count = 0
			&sql(select count(*) into :count from DHCEPRFS_INST.MRLogDetail where TheMRLog = :mrLogID AND MRAction = "CONFIRMSCAN")
			continue:(count '= 0)
		}
	 	s mrEpisodeID = objMRLog.MREpisodeID
	 	d OutputToBeScannedPat(mrEpisodeID,catalogUser,catalogDate)   
 	}
 	*/
 	
 	
OutputToBeScannedPat(mrEpisodeID,catalogUser,catalogDate)
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s DeathDate=##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetDeathDate(mrEpisodeID)
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    s LastReview = ##Class(DHCEPRFS.BL.BLMRLog).GetLastOpNameAndDate(mrEpisodeID,"REVIEW")
	s LastReviewOperator = $p(LastReview,"^",1)
   	s LastReviewDateTime = $p(LastReview,"^",2)
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate,catalogUser,catalogDate,LastReviewOperator,LastReviewDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GetToBeScannedPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToBeScannedPatExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	获取待扫描的患者列表(已复核或者已编目过但未进行过病历扫描的患者，因为编目和扫描并行，所以看当前状态为复核或者编目的都是应该扫描的，而复核或编目后扫描状态都改为SCANNED)
/// 		一般来说，是获取在指定日期内编目过但未进行过病历扫描的患者，此患者当前状态为“病案编目”
/// Input：	AStartDate 	起始日期(Cache内部格式)，起始日期筛选的是编目日期
/// 		AEndDate 	结束日期(Cache内部格式)，结束日期筛选的是编目日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetToBeScannedPat","","")
Query GetToBeScannedPat(AStartDate As %String, AEndDate As %String, ANeedRescan As %String = "", AUserID As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String,CatalogUser:%String,CatalogDate:%String,LastReviewOperator:%String,LastReviewDateTime:%String")
{
}

ClassMethod GetToBeArrangedPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToBeArrangedPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetToBeArrangedPatExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s mrLogID = ""
 	for {
	 	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxPageStatus"," SCANNED",mrLogID))
	 	q:(mrLogID = "")
	 	
	 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	 	q:(objMRLog = "")
	 	
	 	s actDate = objMRLog.PageModifyDate
	 	s actTime = objMRLog.PageModifyTime
	 	s actUser = objMRLog.PageModifyUserID
	 	
	 	continue:(AStartDate '= "")&&(AStartDate > actDate)
	 	continue:(AEndDate '= "")&&(AEndDate < actDate)
	 	continue:(AUserID '= "")&&(AUserID '= actUser)
	 				
	 	s mrEpisodeID = objMRLog.MREpisodeID
	 	d OutputToBeArrangedPat(mrEpisodeID,actDate,actTime)   
 	}
 	
 	q $$$OK
 	
 	
OutputToBeArrangedPat(mrEpisodeID,actDate,actTime)
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s DeathDate=##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetDeathDate(mrEpisodeID)
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()

    s:(actDate '= "") actDate = $zd(actDate,3)
    s:(actTime '= "") actTime = $zt(actTime,3)
    s actDateTime = actDate_" "_actTime
    
    s LastReview = ##Class(DHCEPRFS.BL.BLMRLog).GetLastOpNameAndDate(mrEpisodeID,"REVIEW")
	s LastReviewOperator = $p(LastReview,"^",1)
   	s LastReviewDateTime = $p(LastReview,"^",2)
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate,actDateTime,LastReviewOperator,LastReviewDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GetToBeArrangedPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToBeArrangedPatExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	获取待分类的患者列表(已扫描过但未进行过扫描分类的患者)
/// 		一般来说，是获取指定用户在指定日期段内扫描过但未进行过扫描分类的患者，此患者当前状态为“病历扫描”
/// Input：	AStartDate 	起始日期(Cache内部格式)，起始日期筛选的是病历扫描日期
/// 		AEndDate 	结束日期(Cache内部格式)，结束日期筛选的是病历扫描日期
/// 		AUserID		病历扫描用户ID，病历扫描用户ID筛选的病历扫描者
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetToBeArrangedPat","","","2583")
Query GetToBeArrangedPat(AStartDate As %String, AEndDate As %String, AUserID As %String) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String,ScanDateTime:%String,LastReviewOperator:%String,LastReviewDateTime:%String")
{
}

ClassMethod GetToBeMergedPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToBeMergedPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetToBeMergedPatExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagStatus = "ARRANGED"
 	s flagAction = "ARRANGE"
 	
 	s mrLogID = ""
 	for {
	 	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxPageStatus"," ARRANGED",mrLogID))
	 	q:(mrLogID = "")
	 	
	 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
	 	q:(objMRLog = "")
	 	
	 	s actDate = objMRLog.PageModifyDate
	 	s actUser = objMRLog.PageModifyUserID
	 	
	 	continue:(AStartDate '= "")&&(AStartDate > actDate)
	 	continue:(AEndDate '= "")&&(AEndDate < actDate)
	 	continue:(AUserID '= "")&&(AUserID '= actUser)
	 					
	 	s mrEpisodeID = objMRLog.MREpisodeID
	 	d OutputToBeMergedPat(mrEpisodeID)   
 	}
 	
 	q $$$OK
 	
 	
OutputToBeMergedPat(mrEpisodeID)
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s DeathDate=##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetDeathDate(mrEpisodeID)	//DeathDate 6.2
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    s LastReview = ##Class(DHCEPRFS.BL.BLMRLog).GetLastOpNameAndDate(mrEpisodeID,"REVIEW")
	s LastReviewOperator = $p(LastReview,"^",1)
   	s LastReviewDateTime = $p(LastReview,"^",2)
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate,LastReviewOperator,LastReviewDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GetToBeMergedPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToBeMergedPatExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	获取待病历合并的患者列表(已分类过但未进行过病历合并的患者)
/// 		一般来说，是获取指定用户在指定日期段内分类过但未进行过病历合并的患者，此患者当前状态为“病历分类”
/// Input：	AStartDate 	起始日期(Cache内部格式)，起始日期筛选的是病历分类日期
/// 		AEndDate 	结束日期(Cache内部格式)，结束日期筛选的是病历分类日期
/// 		AUserID		病历扫描用户ID，病历扫描用户ID筛选的病历分类者
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetToBeMergedPat","","","")
Query GetToBeMergedPat(AStartDate As %String, AEndDate As %String, AUserID As %String) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String,LastReviewOperator:%String,LastReviewDateTime:%String")
{
}

/// Debug d ##class(DHCEPRFS.BL.BLMRLog).GetScanEpisodeCountList("2014-01-01","2014-12-31")
ClassMethod GetScanEpisodeCountList(AStartDate As %String, AEndDate As %String) As %String
{
	s startDate = AStartDate
	s endDate = AEndDate
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	s:(AStartDate '= "") AStartDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") AEndDate = $zdh(AEndDate,3)
	s roleRowID = ""
	s roleRowID = $o(^DHCEPRFS.META.QueryRoleI("IdxRoleName"," SCANOPERATOR",roleRowID))
	q:(roleRowID = "") "-2"
	
	s userRoleID = ""
	for {
		s userRoleID = $o(^DHCEPRFS.META.QueryUserRoleD(userRoleID))
		q:(userRoleID = "")
		s objUserRole = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleID)
		s roleID = objUserRole.RoleID
		continue:(roleRowID '= roleID)
		
		s userID = objUserRole.UserID
		continue:(userID = "")
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(userID)
		continue:(objUser = "")
		s SSUserID = objUser.SSUserID
		s UserName = objUser.UserName
		

		s count = ..GetScanEpisodeCount(AStartDate,AEndDate,SSUserID)
		s pageCount = ..GetScanPageCount(AStartDate,AEndDate,SSUserID)
		s:(SSUserID = "4824") pageCount = count
		w !,SSUserID_" "_UserName_" 在 "_startDate_" 到 "_endDate_" 扫描份数："_count_" 扫描总页数："_pageCount
	}
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetScanEpisodeCount("","","4198")
ClassMethod GetScanEpisodeCount(AStartDate As %Date, AEndDate As %Date, AUserID As %String) As %String
{
	s count = 0
	s flagAction = "SCAN"
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID))	
		q:(mrEpisodeID = "")
		s flag = "false"
		s date = AStartDate
		for {
			s date = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date))	
			q:(date = "")
			q:((AEndDate '= "") && (date > AEndDate))
			s time = ""
			for {
				s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date,time))	
				q:(time = "")
				s rowID = ""
				for {
					s rowID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date,time,rowID))		
					q:(rowID = "")
					s count = count + 1
					s flag = "true"
					q
				}
				q:(flag = "true")
			}
			q:(flag = "true")
		}
	}
	q count
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetScanPageCount("","","4824")
ClassMethod GetScanPageCount(AStartDate As %Date, AEndDate As %Date, AUserID As %String) As %String
{
	s count = 0
	s flagAction = "SCAN"
	s mrEpisodeID = ""

	for {
		s mrEpisodeID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID))	
		q:(mrEpisodeID = "")
		s date = AStartDate
		for {
			s date = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date))	
			q:(date = "")
			q:((AEndDate '= "") && (date > AEndDate))
			s time = ""
			for {
				s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date,time))	
				q:(time = "")
				s rowID = ""
				for {
					s rowID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date,time,rowID))		
					q:(rowID = "")
					
					s subID = ""
					for {
						s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxUserMREpisode"," "_flagAction," "_AUserID,mrEpisodeID,date,time,rowID,subID))		
						q:(subID = "")
						s obj = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID_"||"_subID)
						s actPage = obj.ActPages
						s count = (+count) + (+actPage)
					}
				}
			}
		}
	}
	q count
}

/// Desc:	获取扫描记录
/// Input：	AStartDate 	起始日期(Cache内部格式)
/// 		AEndDate 	结束日期(Cache内部格式)
/// 		AUserID		用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanLog","63121","63125","","0")
Query GetScanLog(AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID,ScanPages,ScanDate")
{
}

ClassMethod GetScanLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagAction = "SCAN"
 	
 	for date = AStartDate:1:AEndDate
 	{
	 	s time = ""
	 	for {
	 		s time = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRAction"," "_flagAction,date,time))
	 		q:(time ="")
	 	
	 		s detailLogFinalID = ""
	 		for {
		 		s detailLogFinalID = $O(^DHCEPRFS.INST.MRLogDtlFinalI("IdxMRAction"," "_flagAction,date,time,detailLogFinalID))
	 			q:(detailLogFinalID ="")
	 			
	 			s objDetailLogFinal = ##Class(DHCEPRFS.INST.MRLogDtlFinal).%OpenId(detailLogFinalID)
	 			continue:(objDetailLogFinal="")
	 			
	 			s mrEpisodeID = objDetailLogFinal.MREpisodeID
	 			s actUserID = objDetailLogFinal.ActUserID
	 			continue:((AUserID'="")&&(AUserID'=actUserID))
	 			
	 			s actPages = objDetailLogFinal.ActPages
	 			s actDate = objDetailLogFinal.ActDate
	 		
	 			d OutputScanLog(mrEpisodeID,actUserID,actPages,actDate)   
	 		}
	 	}
 	}
 	
 	q $$$OK
 	
 	
OutputScanLog(mrEpisodeID,actUserID,actPages,actDate)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") s actDate = $zd(actDate,3)
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actPages,actDate)
	s ind = ind + 1
	
	quit
}

ClassMethod GetScanLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取打印记录
/// Input：	AStartDate 	起始日期(Cache内部格式)
/// 		AEndDate 	结束日期(Cache内部格式)
/// 		AUserID		用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintLog","63101","63125","","0")
Query GetPrintLog(AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,PrintUserID,PrintPages,PrintDate,UnitPrice,TotPrice")
{
}

ClassMethod GetPrintLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, ANeedSummarization As %String = "0") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagAction = "PRINT"
 	
 	for date = AStartDate:1:AEndDate
 	{
	 	s time = ""
	 	for {
		 	s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
			 	s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
			 	for {
				 	s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 	q:(subID="")
				 	
				 	s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	continue:(objMRLogDetail="")
				 	
				 	s actUserID = objMRLogDetail.ActUserID
				 	continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 	s actPages = objMRLogDetail.ActPages
				 	s actDate = objMRLogDetail.ActDate
				 	s actPrice = objMRLogDetail.ActPrice
				 	
				 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 	s mrEpisodeID = objMRLog.MREpisodeID
				 	
				 	do OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice)  
			 	}
		 	}
	 	}
 	}
 	
 	q $$$OK
 	
 	
OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") s actDate = $zd(actDate,3)
    s totPrice = actPrice * actPages
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actPages,actDate,actPrice,totPrice)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetUserIDByUserName","%")
Query GetUserIDByUserName(AUserName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "UserID:%String,UserName:%String,UserInitials:%String,SSUserID:%String")
{
	SELECT ID,UserName,UserCode,SSUserID
	FROM DHCEPRFS_META.QueryUser 
	WHERE UserName LIKE :AUserName
}

/// Desc:	获取打印记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserID		用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintLogByUser","2014-1-13","2014-1-13","张红艳","90387872")
Query GetPrintLogByUser(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,PrintUserID:%String,PrintUserName:%String,PrintPages:%String,PrintDateTime:%String,UnitPrice:%String,PrintIP:%String,TotPrice:%String,PrintName:%String,PrintRelationship:%String,PrintIDNumber:%String,PrintContact:%String,MRLogDetailID:%String")
{
}

ClassMethod GetPrintLogByUserExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	 	
 	s flagAction = "PRINT"
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	
 	if (AUserName '= "")
 	{
	 	s userID = ""
	 	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 	s sc = rset.Execute(AUserName)
	 	while (rset.Next())
	 	{
		 	s SSUserID = rset.Data("SSUserID")	
		 	s userID = ""
		 	if ((SSUserID = "") || (SSUserID = $c(0)))
		 	{
				s userID = "TEMP^"_rset.Data("UserID") 	
			}
			else
			{
				s userID = SSUserID	
			}

 			for date = AStartDate:1:AEndDate
 			{
	 			s time = ""
	 			for {
		 			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time))
		 			q:(time="")
		 	
		 			s mrLogID = ""
		 			for {
			 			s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID))
			 			q:(mrLogID="")
			 		
			 			s subID = ""
			 			for {
				 			s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID,subID))
				 			q:(subID="")
				 	
				 			s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 			continue:(objMRLogDetail="")
				 	
				 			s actUserID = userID
 
				 			s actPages = objMRLogDetail.ActPages
				 			s actDate = objMRLogDetail.ActDate
				 			s actTime = objMRLogDetail.ActTime
				 			s actPrice = objMRLogDetail.ActPrice
				 			s actIP = objMRLogDetail.IP
				 	
				 			s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 			s mrEpisodeID = objMRLog.MREpisodeID
				 			if (AMedRecordID '= "")
				 			{
					 			b "s"
				 				s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				 				s medRecordNo = mrEpisodeObj.MedRecordNo
				 				continue:(medRecordNo '= AMedRecordID)
				 			}
				 	
				 			do OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice,actIP,mrLogID_"||"_subID)  
			 			}
		 			}
	 			}
 			}
	 	}
	 	d rset.Close()
 	}
 	elseif (AMedRecordID '= "")
 	{
	 	s mrEpisodeID = ""
	 	for {
	 		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordID,mrEpisodeID))
	 		q:(mrEpisodeID = "")
	 		s mrLogID = ""
	 		for {
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID, mrLogID))
				q:(mrLogID="")
				s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,subID))	
					//b "s"
					q:(subID="")	
					s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
					continue:(objMRLogDetail="") 
					continue:(objMRLogDetail.MRAction '= flagAction)
					continue:((objMRLogDetail.ActDate < AStartDate) || (objMRLogDetail.ActDate > AEndDate))	
			
					s actUserID = objMRLogDetail.ActUserID
					s actPages = objMRLogDetail.ActPages
					s actDate = objMRLogDetail.ActDate
					s actTime = objMRLogDetail.ActTime
					s actPrice = objMRLogDetail.ActPrice
					s actIP = objMRLogDetail.IP
					s mrEpisodeID = mrEpisodeID
				 					
					do OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice,actIP,mrLogID_"||"_subID) 
				}
			}
		}
	}
	else
	{
	 	for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 		q:(time="")
		 	
		 		s mrLogID = ""
		 		for {
			 		s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 		q:(mrLogID="")
			 	
			 		s subID = ""
			 		for {
				 		s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 		q:(subID="")
				 	
				 		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 		continue:(objMRLogDetail="")
				 	
				 		s actUserID = objMRLogDetail.ActUserID
				 		//continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 		s actPages = objMRLogDetail.ActPages
				 		s actDate = objMRLogDetail.ActDate
				 		s actTime = objMRLogDetail.ActTime
				 		s actPrice = objMRLogDetail.ActPrice
				 		s actIP = objMRLogDetail.IP
				 	
				 		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 		s mrEpisodeID = objMRLog.MREpisodeID
				 	
				 		do OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice,actIP,mrLogID_"||"_subID)  
			 		}
		 		}
	 		}
 		}	
	}
 	
 	q $$$OK
 	
 	
OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice,actIP,mrLogDetailID)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    s actUserName = ""
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    s totPrice = actPrice * actPages
    
    s PrintName = ""
    s PrintRelationship = ""
    s PrintIDNumber = ""
    s PrintContact = ""
    s printInfoRowID = ""
    s printInfoRowID = $o(^DHCEPRFS.INST.PrintInfoI("IdxMRLogDetailID"," "_mrLogDetailID,printInfoRowID))
	if (printInfoRowID '= "")
	{
		s objPrintInfo = ##class(DHCEPRFS.INST.PrintInfo).%OpenId(printInfoRowID)
		s PrintName = objPrintInfo.Name
		s PrintRelationship = objPrintInfo.Relationship
		s PrintIDNumber = objPrintInfo.IDNumber
		s PrintContact = objPrintInfo.Contact
	}
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,actPages,actDateTime,actPrice,actIP,totPrice,PrintName,PrintRelationship,PrintIDNumber,PrintContact,mrLogDetailID)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintLogByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintLogByUserExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintLogByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintLogByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取某条打印记录细节
/// Input：	AMRLogDetailID 	
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintLogDetail","12||36")
Query GetPrintLogDetail(AMRLogDetailID As %String) As %Query(ROWSPEC = "MRLogDetailSubID:%String,DetailType:%String,MRItemID:%String,DetailVersion:%String,PageRange:%String,MRItemName:%String,MRItemCode:%String,MRItemDesc:%String")
{
}

ClassMethod GetPrintLogDetailExecute(ByRef qHandle As %Binary, AMRLogDetailID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 		
 	s mrLogID = $p(AMRLogDetailID,"||",1)
 	s mrLogDetailID = $p(AMRLogDetailID,"||",2)
 	
 	s detailNum = ""
 	for {
		s detailNum = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum))
		q:(detailNum = "")
		//b "s"
		s subID = ""
		for {
			s subID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum,subID))
			q:(subID = "")
			s mrLogDetailSubID = AMRLogDetailID_"||"_subID
			s obj = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogDetailSubID)
			s DetailType = obj.DetailType
			if (DetailType = "MRITEMID")
			{
				s MRItemID = obj.DetailID
				s DetailVersion = obj.DetailVersion	
				s PageRange = obj.PageRange
				s MRItemName = ""
				s MRItemCode = ""
				s MRItemDesc = ""
				if (MRItemID '= "")
				{
					s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(MRItemID)
					s MRItemName = objMRItem.Name
					s MRItemCode = objMRItem.Code
					s MRItemDesc = objMRItem.Description
				}
				
				s ^CacheTemp(repid,ind) = $lb(mrLogDetailSubID,DetailType,MRItemID,DetailVersion,PageRange,MRItemName,MRItemCode,MRItemDesc)
				s ind = ind + 1
			}
		}	
	}
 	
 	q $$$OK
 	
 	
OutputPrintLog(mrEpisodeID,actUserID,actPages,actDate,actPrice,mrLogDetailID)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    s actUserName = ""
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    s totPrice = actPrice * actPages
    
    s PrintName = ""
    s PrintRelationship = ""
    s PrintIDNumber = ""
    s PrintContact = ""
    s printInfoRowID = ""
    s printInfoRowID = $o(^DHCEPRFS.INST.PrintInfoI("IdxMRLogDetailID"," "_mrLogDetailID,printInfoRowID))
	if (printInfoRowID '= "")
	{
		s objPrintInfo = ##class(DHCEPRFS.INST.PrintInfo).%OpenId(printInfoRowID)
		s PrintName = objPrintInfo.Name
		s PrintRelationship = objPrintInfo.Relationship
		s PrintIDNumber = objPrintInfo.IDNumber
		s PrintContact = objPrintInfo.Contact
	}
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,actPages,actDateTime,actPrice,totPrice,PrintName,PrintRelationship,PrintIDNumber,PrintContact,mrLogDetailID)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintLogDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintLogDetailExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintLogDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintLogDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取扫描记录 - 从MRLogDtlFinal表中取数据，表明对一次就诊只取最后一次扫描记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserID		用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanLogByUser","2015-01-01","2015-05-15","","Z203899","")
Query GetScanLogByUser(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String = "", AScan As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID:%String,ScanUserName:%String,roleName:%String,ScanPages:%String,ScanDateTime:%String,EpisodeCount:%String,MedRecordCount:%String")
{
}

ClassMethod GetScanLogByUserExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String = "", AScan As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	k ^CacheTemp(repid,"dhceprfs","getscanlog")
	s flagActionStr = "SCAN^SCANDELETE^SCANMEDRECORD"
	if (AType '= "")
	{
		if (AType = "SCAN^SCANDELETE")
		{
			s flagActionStr = "SCAN^SCANDELETE^SCANMEDRECORD"
		}
		else
		{
			s flagActionStr = AType
		}
	}
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	s:(AScan = $c(0)) AScan = ""
 	
 	for index = 1:1:$l(flagActionStr,"^")
 	{
	 	s flagAction = $p(flagActionStr,"^",index)
 		if (AUserName '= "")
 		{
	 		s userID = ""
	 		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 		s sc = rset.Execute(AUserName)
	 		while (rset.Next())
	 		{
		 		s SSUserID = rset.Data("SSUserID")	
		 		s userID = ""
		 		if ((SSUserID = "") || (SSUserID = $c(0)))
		 		{
					s userID = "TEMP^"_rset.Data("UserID") 	
				}
				else
				{
					s userID = SSUserID	
				}
				
				s userRoleRowID = rset.Data("UserID")
				s userrowID = ""
				s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
				q:(userrowID="")
				s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 				s roleID = userRoleObj.RoleID
 				s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 				s roleName = queryRoleObj.RoleDesc
 				if (AScan '= "")&&(AScan '= $c(0))
 				{
	 				if (roleID '= AScan)
	 				{
		 				continue
	 				}
 				}
			
 				for date = AStartDate:1:AEndDate
 				{
	 				s time = ""
	 				for {
		 				s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time))
		 				q:(time="")
		 			
		 				s mrLogID = ""
		 				for {
			 				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID))
			 				q:(mrLogID="")
			 			
			 				s subID = ""
			 				for {
				 				s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID,subID))
			 					q:(subID="")
			 				
			 					s mrLogDetailID = mrLogID_"||"_subID
				 	
				 				s objMRLogDtl = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
				 				continue:(objMRLogDtl="")
				 	
				 				s actUserID = userID
 
				 				s actPages = objMRLogDtl.ActPages
				 				continue:(actPages="0")
				 				s actDate = objMRLogDtl.ActDate
				 				s actTime = objMRLogDtl.ActTime
				 				s mrEpisodeID = objMRLogDtl.MREpisodeID
				 	
				 				if (AMedRecordID '= "")
				 				{
				 					s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				 					s medRecordNo = mrEpisodeObj.MedRecordNo
				 					continue:(medRecordNo '= AMedRecordID)
				 				
					 			}
								s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 				s mrMedRecordID = objMRLog.MRMedRecordID
				 				s mrEpisodeID = objMRLog.MREpisodeID
				 				if (mrEpisodeID = "")
				 				{
					 				do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 			}
					 			else
					 			{
				 					do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 			} 
			 				}
		 				}
	 				}
 				}
	 		}
	 		d rset.Close()
 		}
 		elseif (AMedRecordID '= "")
 		{
	 		s mrEpisodeID = ""
	 		for {
	 			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordID,mrEpisodeID))
	 			q:(mrEpisodeID = "")
	 			s mrLogID = ""
	 			for {
					s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID, mrLogID))
					q:(mrLogID="")
					s subID = ""
					for {
						s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,subID))	
						q:(subID="")	
						s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
						continue:(objMRLogDetail="") 
						continue:(objMRLogDetail.MRAction '= flagAction)
						continue:((objMRLogDetail.ActDate < AStartDate) || (objMRLogDetail.ActDate > AEndDate))	
			
						s actUserID = objMRLogDetail.ActUserID
						s actPages = objMRLogDetail.ActPages
						continue:(actPages="0")
						s actDate = objMRLogDetail.ActDate
						s actTime = objMRLogDetail.ActTime
						s mrEpisodeID = mrEpisodeID
				 		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 		s mrMedRecordID = objMRLog.MRMedRecordID
				 		s mrEpisodeID = objMRLog.MREpisodeID
				 		
				 		
				 		s userRoleRowID = ""
						if ($p(actUserID,"^",1) = "TEMP")
    					{
							s userRoleRowID =$p(actUserID,"^",2)  
						}
						else
						{
    						s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    						q:(userRoleRowID="")
						}
						s userrowID = ""
						s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
						q:(userrowID="")
						s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 						s roleID = userRoleObj.RoleID
 						s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 						s roleName = queryRoleObj.RoleDesc
 						if (AScan '= "")&&(AScan '= $c(0))
 						{
	 						if (roleID '= AScan)
	 						{
		 						continue
	 						}
 						}
				 		
				 		
				 		if (mrEpisodeID = "")
				 		{
					 		do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 	}
					 	else
					 	{
				 			do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 	} 
					}
				}
			}
		}
		else
		{
	 		for date = AStartDate:1:AEndDate
 			{
	 			s time = ""
	 			for {
		 			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 			q:(time="")
		 	
		 			s mrLogID = ""
		 			for {
				 		s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 			q:(mrLogID="")
			 	
			 			s subID = ""
				 		for {
					 		s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 			q:(subID="")
				 	
				 			s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 			continue:(objMRLogDetail="")
				 	
				 			s actUserID = objMRLogDetail.ActUserID
				 			//continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 			s actPages = objMRLogDetail.ActPages
				 			continue:(actPages="0")
				 			s actDate = objMRLogDetail.ActDate
				 			s actTime = objMRLogDetail.ActTime
				 	
				 			s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 			s mrEpisodeID = objMRLog.MREpisodeID
				 			s mrMedRecordID = objMRLog.MRMedRecordID
				 			
				 			
				 			s userRoleRowID = ""
							if ($p(actUserID,"^",1) = "TEMP")
    						{
								s userRoleRowID =$p(actUserID,"^",2) 
							}
							else
							{
    							s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    							q:(userRoleRowID="")
							}
							s userrowID = ""
							s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
							q:(userrowID="")
							s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 							s roleID = userRoleObj.RoleID
 							s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 							s roleName = queryRoleObj.RoleDesc
 							if (AScan '= "")&&(AScan '= $c(0))
 							{
	 							if (roleID '= AScan)
	 							{
		 							continue
	 							}
 							}
				 			
				 			
				 			if (mrEpisodeID = "")
				 			{
					 			do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 		}
					 		else
					 		{
				 				do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 		} 
			 			}
		 			}
	 			}
 			}	
		}
 	}
 	
 	s count = 0
 	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^CacheTemp(repid,"dhceprfs","getscanlog","MREpisodeID",mrEpisodeID))
		q:(mrEpisodeID = "")
		s count = count + 1	
	}
	s episodeCount = count 
	
	s count = 0
	s medRecordNo = ""
	for {
		s medRecordNo = $o(^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",medRecordNo))
		q:(medRecordNo = "")
		s count = count + 1	
	}
	s medRecordCount = count
	
 	s ^CacheTemp(repid,ind) = $lb("","","","","","","","","","","","","",0,"",episodeCount,medRecordCount)
	s ind = ind + 1
	
 	k ^CacheTemp(repid,"dhceprfs","getscanlog")
 	
 	q $$$OK
 	
 	
OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s ^CacheTemp(repid,"dhceprfs","getscanlog","MREpisodeID",mrEpisodeID) = mrEpisodeID
	
	s MedRecordNo = objEpisode.MedRecordNo 
	if (MedRecordNo '= "")
	{
		s ^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",MedRecordNo) = MedRecordNo
	}
	
	s AdmDateTime = ""
	s DisDateTime = ""
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,roleName,actPages,actDateTime,"","")
	s ind = ind + 1
	
	quit
	
OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
	s objMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
	q:(objMedRecord = "")
	
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s MedRecordNo = objMedRecord.MedRecordNo
	s ^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",MedRecordNo) = MedRecordNo

	s MrPatientID = objMedRecord.MRPatientID

    d objMedRecord.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,"",MedRecordNo,Name,Birthday,Sex,"","","","",actUserID,actUserName,roleName,actPages,actDateTime,"","")
	s ind = ind + 1
	
	quit
}

ClassMethod GetScanLogByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanLogByUserExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanLogByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanLogByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:取患者当前状态
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetStatus(1)
ClassMethod GetStatus(AMREpisodeID As %String) As %String
{
	s status = ""
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") status
	s rowID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(rowID = "") status
	s objLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(rowID)
	q:(objLog = "") status
	s rowID = $o(^DHCEPRFS.META.MRStatusI("IdxMain"," "_objLog.MRStatus,""))
	q:(rowID = "") status
	s objStatus = ##Class(DHCEPRFS.META.MRStatus).%OpenId(rowID)
	q:(objStatus = "") status
	s status = objStatus.StatusName
	q status
}

/// Desc:取患者当前状态
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetStatus(1)
ClassMethod GetAllStatus(AMREpisodeID As %String) As %String
{
	s status = ""
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") status
	s rowID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(rowID = "") status
	s objLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(rowID)
	q:(objLog = "") status
	
	s mrStatus = ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc(objLog.MRStatus)
	s mrPageStatus = ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc(objLog.PageStatus)
	q mrStatus_"|"_mrPageStatus
}

/// Desc:取患者最后复核者和复核时间
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetLastOpNameAndDate(100114,"REVIEW")
ClassMethod GetLastOpNameAndDate(AMREpisodeID As %String, AAction As %String) As %String
{
	s status = "^"
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") status
	s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(mrLogID = "") status
	
	s subID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_AAction,""),-1)
	q:(subID = "") status
	
	s mrLogDetailID = mrLogID_"||"_subID
	s obj = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
	q:(obj = "") status
	s date = obj.ActDate
	s:(date '= "") date = $zd(date,3)
	s time = obj.ActTime
	s:(time '= "") time = $zt(time,3)
	s userID = obj.ActUserID
	s userName = $p($g(^SSU("SSUSR",userID)),"^",2)
	s status = userName_"^"_date_" "_time
	q status
}

/// Desc:取患者当前状态
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetStatusCode(1)
ClassMethod GetAllStatusCode(AMREpisodeID As %String) As %String
{
	s status = ""
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") status
	s rowID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(rowID = "") status
	s objLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(rowID)
	q:(objLog = "") status
	
	q objLog.MRStatus_"|"_objLog.PageStatus
}

/// Desc: 取扫描人和扫描时间
/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetScanData("31909")
ClassMethod GetScanData(AMREpisodeID As %String) As %String
{
	s result = ""
	s flagAction = "SCAN"
	q:(AMREpisodeID = "") result
	s LogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(LogID = "") result
	s DetailID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",LogID," "_flagAction,""),-1)
	q:(DetailID = "") result
	s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(LogID_"||"_DetailID)
	q:(objMRLogDetail = "") result
	s scanUser = objMRLogDetail.ActUserID
	//s scanUser = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(scanUser) 
	s scanUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetQueryUserName(scanUser)
	s scanDate = objMRLogDetail.ActDate
	s:(scanDate'="")&&(scanDate'=$c(0)) scanDate = $zd(scanDate,3)
	s scanTime = objMRLogDetail.ActTime
	s:(scanTime'="")&&(scanTime'=$c(0)) scanTime = $zt(scanTime,3)
	s result = scanUserName_"^"_scanDate_"^"_scanTime
	q result
}

/// Desc:	更新病案管理状态
ClassMethod UpdateWMRScanStatus(AMREpisodeID As %String, AUserID As %String, AScanPages) As %String
{
	s wmrScanItemID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("WMRScanItemID")
	q:(wmrScanItemID = "")||(wmrScanItemID = $c(0))||(wmrScanItemID = "NULL") "1"

	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") "-1"
	
	s episodeID = objMREpisode.EpisodeID
	s dtlList = ""
	s sc = ##Class(DHCEPRFS.BL.HISInfo.BLWMRInfo).UpdateStatus(episodeID, wmrScanItemID, AUserID, dtlList)
	q sc
}

/// Desc:	更新病案管理状态
ClassMethod UpdateWMRPrintStatus(AMREpisodeID As %String, AUserID As %String, APrintCharge As %String) As %String
{
	s wmrPrintItemID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("WMRPrintItemID")
	q:(wmrPrintItemID = "")||(wmrPrintItemID = $c(0))||(wmrPrintItemID = "NULL") "1"

	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") "-1"
	
	s episodeID = objMREpisode.EpisodeID
	s dtlList = "PrintCharge^"_APrintCharge
	s sc = ##Class(DHCEPRFS.BL.HISInfo.BLWMRInfo).UpdateStatus(episodeID, wmrPrintItemID, AUserID, dtlList)
	q sc
}

/// Desc: 取扫描人和扫描时间
/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetMRLog("7876506")
ClassMethod GetMRLog(AEpisodeID As %String) As %String
{
	//b "s"
	s result = ""
	q:(AEpisodeID = "") result
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,""))
	q:(mrEpisodeID = "") result
	s logID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))
	q:(logID = "") result
	s detailNum = ""
	s detailID = ""
	for {
		s detailNum = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",logID,detailNum)) 	
		q:(detailNum = "")
		s detailID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",logID,detailNum,""))
		q:(detailID = "")
		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(logID_"||"_detailID)
		q:(objMRLogDetail = "")
		s userID = objMRLogDetail.ActUserID
		s userName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(userID) 
		s opDate = objMRLogDetail.ActDate
		s:(opDate'="")&&(opDate'=$c(0)) opDate = $zd(opDate,3)	
		s opTime = objMRLogDetail.ActTime
		s:(opTime'="")&&(opTime'=$c(0)) opTime = $zt(opTime,3)
		s actionCode = objMRLogDetail.MRAction
		s actionID = $o(^DHCEPRFS.META.MRActionI("IdxMain"," "_actionCode,""))
		s objMRAction = ##Class(DHCEPRFS.META.MRAction).%OpenId(actionID)
		s actionDesc = objMRAction.ActionName
		if (result = "")
		{
			s result = userID_"^"_userName_"^"_opDate_"^"_opTime_"^"_actionCode_"^"_actionDesc	
		}
		else
		{
			s result = result_"|"_userID_"^"_userName_"^"_opDate_"^"_opTime_"^"_actionCode_"^"_actionDesc
		}
	}

	q result
}

ClassMethod CheckAction(AID As %String, AAction As %String, AType As %String = "") As %String
{
	s ret = ""
	if (AType '= "")
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMRMedRecord"," "_AID,""))		
	}
	else
	{
		s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AID,""))	
	}
	q:(mrLogID = "") ret
	
	s mrLogDetailID = ""
	s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_$zcvt(AAction,"u"),mrLogDetailID))
	if (mrLogDetailID = "")
	{
		q "0"	
	}
	else
	{
		q "1"	
	}
}

ClassMethod CheckActionEpisode(AEpisodeID As %String, AAction As %String) As %String
{
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(MREpisodeID = "") "0"
	s ret = ..CheckAction(MREpisodeID,AAction)
	q ret
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(214377)
ClassMethod IsPrinted(AMREpisodeID As %String) As %String
{
	s ret = "0"
	s mrLogID = ..GetMRLogID(AMREpisodeID)
	q:(mrLogID = "") ret
	s mrLogDetailID = ""
	
	s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," PRINT",mrLogDetailID))
	q:(mrLogDetailID = "") ret
		
	s ret = "1"
	q ret
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).CheckPrint(214377)
ClassMethod CheckPrint(AMREpisodeID As %String) As %String
{
	s ret = "0"
	s mrLogID = ..GetMRLogID(AMREpisodeID)
	q:(mrLogID = "") ret
	
	s mrLogDetailID = ""
	for {
		s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," PRINT",mrLogDetailID))
		q:(mrLogDetailID = "")
	
		s detailNum = ""
		for {
			s detailNum = $O(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum))
			q:(detailNum = "")
		
			s sub = $O(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum,""))
			s mrLogDetailSubID = mrLogID_"||"_mrLogDetailID_"||"_sub
		
			s obj = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogDetailSubID)
			if (obj.DetailType = "MRITEMID")
			{
				s mrItemID = obj.DetailID
				s detailVersion = obj.DetailVersion	
				s maxDetailVersion = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByMRItem(AMREpisodeID,mrItemID)
				//扫描合并会导致detailVersion的值为-1
				if ((detailVersion '= maxDetailVersion) && (detailVersion '= "-1"))
				{
					s ret = "1"
					q
				}
			}
		}
		q:(ret = "1")
	}
	q ret
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetMREpisodePrintLog","8")
Query GetMREpisodePrintLog(AMREpisodeID As %String) As %Query(ROWSPEC = "MRLogDetailID:%String,MRPatientID:%String,MREpisodeID:%String,PrintDate:%String,PrintUserID:%String,PrintUserName:%String,PrintPages:%String,UnitPrice:%String,TotPrice:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String")
{
}

ClassMethod GetMREpisodePrintLogExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagAction = "PRINT"
 	s mrLogID = ..GetMRLogID(AMREpisodeID)
		 	
	s subID = ""
	for {
		//b "s"
		s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," "_flagAction,subID))
		q:(subID = "")
		s mrLogDetailID = mrLogID_"||"_subID
				 	
		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
		continue:(objMRLogDetail="")
				 	
		s actUserID = objMRLogDetail.ActUserID
		s actUserName = ""
		&sql(select SSUSR_Name into :actUserName from SQLUser.SS_User where SSUSR_RowId = :actUserID)
				 	 
		s actPages = objMRLogDetail.ActPages
		s actDate = objMRLogDetail.ActDate
		s actTime = objMRLogDetail.ActTime
		s actPrice = objMRLogDetail.ActPrice
				 	
		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
		s mrEpisodeID = objMRLog.MREpisodeID
		
		s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
	    q:(objEpisode = "")
		s MedRecordNo = objEpisode.MedRecordNo 
	    s AdmDate = objEpisode.AdmDate
	    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
		s AdmTime = objEpisode.AdmTime
		s DisDate = objEpisode.DisDate
		if DisDate '= "" s DisDateTime = $zd(DisDate,3)
		s DisTime = objEpisode.DisTime
		s AdmLoc = objEpisode.AdmLoc
	    s DisLoc = objEpisode.DisLoc
	    s MainDiagDesc = ""
	    s MrPatientID = objEpisode.MRPatientID
	    d objEpisode.%Close()
	
	    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
	    s Name = objPatient.Name
	    s Birthday = objPatient.Birthday
	    if Birthday '= "" s Birthday = $zd(Birthday,3)
	    s Age = objPatient.Age	
	    s Sex = objPatient.Gender
	    s HouseAddress = objPatient.HouseAddress
	    s LinkName = objPatient.LinkName	
	    s LinkRelation = objPatient.LinkRelation
	    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
	    d objPatient.%Close()
    
	    if (actDate '= "") s actDate = $zd(actDate,3)
	    if (actTime '= "") s actTime = $zt(actTime,3)
	    s actDate = actDate_" "_actTime
	    
	    s totPrice = actPrice * actPages
    
	    s ^CacheTemp(repid,ind) = $lb(mrLogDetailID,MrPatientID,mrEpisodeID,actDate,actUserID,actUserName,actPages,actPrice,totPrice,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc)
		s ind = ind + 1
		 	
 	}
 	
 	q $$$OK
}

ClassMethod GetMREpisodePrintLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMREpisodePrintLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetMREpisodePrintLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMREpisodePrintLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AddScanLog(AMREpisodeID As %String, AMRAction As %String, AActUserID As %String, AActPages As %String, AIP As %String = "") As %String
{
	s AActPrice = 0, AActSchemeID = 0, ARemark = ""
	
	s retLogDetailID = ..AddMRLogDetail(AMREpisodeID, AMRAction, AActUserID, AActPages,AActPrice,AActSchemeID,ARemark,"",AIP)
	q:(retLogDetailID="") "0"
	
	s retLogDtlFinalID = ..AddLogDtlFinal(AMREpisodeID , AMRAction, retLogDetailID)
	q:(retLogDtlFinalID="") "0"
	
	q "1"
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetNeedArrangeList","2015-1-1","2015-5-19")
Query GetNeedArrangeList(AStartDate As %String, AEndDate As %String, AScan As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID:%String,ScanUserName:%String,roleName:%String,ScanPages:%String,ScanDateTime:%String")
{
}

ClassMethod GetNeedArrangeListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AScan As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	s flagAction = "SCAN"

 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AScan = $c(0)) AScan = ""
 	
	for date = AStartDate:1:AEndDate
 	{
	 	s time = ""
	 	for {
		 	s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 	q:(subID="")
				 	
				 	s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	continue:(objMRLogDetail="")
				 	
				 	s actUserID = objMRLogDetail.ActUserID
				 	//continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 	s actPages = objMRLogDetail.ActPages
				 	continue:(actPages="0")
 				 	s actDate = objMRLogDetail.ActDate
				 	s actTime = objMRLogDetail.ActTime
				 	
				 	s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 	s mrEpisodeID = objMRLog.MREpisodeID
				 	
				 	//在FileTemporary中查找未分类就诊记录 2021.3.3
				 	s temporaryCount=0
				 	&sql(SELECT count(*) INTO temporaryCount FROM dhceprfs_inst.FileTemporary WHERE MREpisodeID = :mrEpisodeID AND Status='0')
				 	continue:(temporaryCount=0)
				 	
				 	/*
					s versionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID, "0",""))
					continue:(versionID = "")
	
					s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS"," 0",""))
	
					s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_versionID," "_mrItemID,""))
					continue:(mrVerItemID = "")
					*/
					
					s userRoleRowID = ""
					if ($p(actUserID,"^",1) = "TEMP")
    				{
						s userRoleRowID =$p(actUserID,"^",2)  
					}
					else
					{
    					s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    					q:(userRoleRowID = "")
					}
					s userrowID = ""
					s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
					q:(userrowID = "")
					s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 					s roleID = userRoleObj.RoleID
 					s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 					s roleName = queryRoleObj.RoleDesc
 					if (AScan '= "")&&(AScan '= $c(0))
 					{
	 					if (roleID '= AScan)
	 					{
		 					continue
	 					}
 					}
 					
				 	
				 	do OutputNeedArrangeLog(mrEpisodeID,actUserID,actPages,actDate,actTime,roleName)  
	 			}
 			}	
		}
 	}
 	q $$$OK
 	
 	
OutputNeedArrangeLog(mrEpisodeID,actUserID,actPages,actDate,actTime,roleName)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	s MedRecordNo = objEpisode.MedRecordNo 
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,roleName,actPages,actDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GetNeedArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNeedArrangeListExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetNeedArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNeedArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取扫描记录 - 从MRLogDtlFinal表中取数据，表明对一次就诊只取最后一次扫描记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserID		用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanIDList","2015-06-01","2015-07-15","","")
Query GetScanIDList(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID:%String,ScanUserName:%String,roleName:%String,ScanDateTime:%String")
{
}

ClassMethod GetScanIDListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	s flagAction = "ARRANGE"
 	s IDSMrItemID = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ScanID")
 	s:(AScan = $c(0)) AScan = ""
 	
 	if (AUserName '= "")
 	{
	 	s userID = ""
	 	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 	s sc = rset.Execute(AUserName)
	 	while (rset.Next())
	 	{
		 	s SSUserID = rset.Data("SSUserID")	
		 	s userID = ""
		 	if ((SSUserID = "") || (SSUserID = $c(0)))
		 	{
				s userID = "TEMP^"_rset.Data("UserID") 	
			}
			else
			{
				s userID = SSUserID	
			}
			
			s userrowID = rset.Data("UserID")
			s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 			s roleID = userRoleObj.RoleID
 			s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 			s roleName = queryRoleObj.RoleDesc
 			if (AScan '= "")&&(AScan '= $c(0))
 			{
	 			if (roleID '= AScan)
	 			{
		 			continue
	 			}
 			}
			
			
			
 			for date = AStartDate:1:AEndDate
 			{
	 			s time = ""
	 			for {
		 			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time))
		 			q:(time="")
		 			
		 			s mrLogID = ""
		 			for {
			 			s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID))
			 			q:(mrLogID="")
			 			
			 			s subID = ""
			 			for {
				 			s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID,subID))
			 				q:(subID="")
			 				
			 				s mrLogDetailID = mrLogID_"||"_subID
				 	
				 			s objMRLogDtl = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
				 			continue:(objMRLogDtl="")
				 	
				 			s actUserID = userID
 
				 			s actPages = objMRLogDtl.ActPages
				 			continue:(actPages="0")
				 			s actDate = objMRLogDtl.ActDate
				 			s actTime = objMRLogDtl.ActTime
				 			s mrEpisodeID = objMRLogDtl.MREpisodeID
				 	
				 			if (AMedRecordID '= "")
				 			{
				 				s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				 				s medRecordNo = mrEpisodeObj.MedRecordNo
				 				continue:(medRecordNo '= AMedRecordID)
				 
					 		}
							
							s detailNum = ""
							s detailNum = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum))
							continue:(detailNum = "")

							s detailSubID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum,""))
							continue:(detailSubID = "")
						
							s objDetailSub = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogID_"||"_subID_"||"_detailSubID)
							s actDate = objDetailSub.CreateDate
							s actTime = objDetailSub.CreateTime
							
				 			do OutputScanIDLog(mrEpisodeID,actUserID,actPages,actDate,roleName)  
			 			}
		 			}
	 			}
 			}
	 	}
	 	d rset.Close()
 	}
 	elseif (AMedRecordID '= "")
 	{
	 	s mrEpisodeID = ""
	 	for {
	 		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordID,mrEpisodeID))
	 		q:(mrEpisodeID = "")
	 		s mrLogID = ""
	 		for {
				s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID, mrLogID))
				q:(mrLogID="")
				s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,subID))	
					q:(subID="")	
					s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
					continue:(objMRLogDetail="") 
					continue:(objMRLogDetail.MRAction '= flagAction)
					continue:((objMRLogDetail.ActDate < AStartDate) || (objMRLogDetail.ActDate > AEndDate))	
			
					s actUserID = objMRLogDetail.ActUserID
					s actPages = objMRLogDetail.ActPages
					continue:(actPages="0")
					s actDate = objMRLogDetail.ActDate
					s actTime = objMRLogDetail.ActTime
					s mrEpisodeID = mrEpisodeID
				 		
				 	s detailNum = ""
					s detailNum = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum))
					continue:(detailNum = "")
							
					s detailSubID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum,""))
					continue:(detailSubID = "")
						
					s objDetailSub = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogID_"||"_subID_"||"_detailSubID)
					s actDate = objDetailSub.CreateDate
					s actTime = objDetailSub.CreateTime	
					
					s userRoleRowID = ""
					if ($p(actUserID,"^",1) = "TEMP")
    				{
						s userRoleRowID =$p(actUserID,"^",2)  
					}
					else
					{
    					s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    					q:(userRoleRowID="")
					}
					s userrowID = ""
					s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
					q:(userrowID="")
					s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 					s roleID = userRoleObj.RoleID
 					s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 					s roleName = queryRoleObj.RoleDesc
 					if (AScan '= "")&&(AScan '= $c(0))
 					{
	 					if (roleID '= AScan)
	 					{
		 					continue
	 					}
 					}
					
					
					do OutputScanIDLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
				}
			}
		}
	}
	else
	{
	 	for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 		q:(time="")
		 	
		 		s mrLogID = ""
		 		for {
				 	s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 		q:(mrLogID="")
			 	
			 		s subID = ""
				 	for {
					 	s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 		q:(subID="")
				 	
				 		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 		continue:(objMRLogDetail="")
				 	
				 		s actUserID = objMRLogDetail.ActUserID
				 		//continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 		s actPages = objMRLogDetail.ActPages
				 		continue:(actPages="0")
				 		//s actDate = objMRLogDetail.ActDate
				 		//s actTime = objMRLogDetail.ActTime
				 	
				 		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 		s mrEpisodeID = objMRLog.MREpisodeID
				 	
				 		//b "s"
				 		s detailNum = ""
						s detailNum = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum))
						continue:(detailNum = "")
						
						s detailSubID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxDetail",mrLogID,subID," MRITEMID"," "_IDSMrItemID,detailNum,""))
						continue:(detailSubID = "")
						
						s objDetailSub = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogID_"||"_subID_"||"_detailSubID)
						s actDate = objDetailSub.CreateDate
						s actTime = objDetailSub.CreateTime
						
						
						s userRoleRowID = ""
						if ($p(actUserID,"^",1) = "TEMP")
    					{
							s userRoleRowID =$p(actUserID,"^",2)  
						}
						else
						{
    						s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    						q:(userRoleRowID = "")
						}
						s userrowID = ""
						s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
						q:(userrowID = "")
						s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 						s roleID = userRoleObj.RoleID
 						s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 						s roleName = queryRoleObj.RoleDesc
 						if (AScan '= "")&&(AScan '= $c(0))
 						{
	 						if (roleID '= AScan)
	 						{
		 						continue
	 						}
 						}
						
				 		do OutputScanIDLog(mrEpisodeID,actUserID,actPages,actDate,roleName)  
			 		}
		 		}
	 		}
 		}	
	}
 	
 	q $$$OK
 	
 	
OutputScanIDLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s MedRecordNo = objEpisode.MedRecordNo 

    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,roleName,actDateTime)
	s ind = ind + 1
	
	quit
}

ClassMethod GetScanIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanIDListExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanIDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	增加按照MRItem类型统计打印页数查询 杨鹏 2015.09.12
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintPagesByMRItem","2011-06-01","2015-09-15")
/// SQL Check:  
/// SELECT a.DetailId,B.Name,count(*)  FROM DHCEPRFS_INST.MRLogDetailSub A
/// 	LEFT JOIN DHCEPRFS_META.MRItem B ON A.DetailId=B.ID
/// 	WHERE MRAction="PRINT" AND 
/// 	CreateDate>='2011-06-01' AND CreateDate<='2015-09-15'
/// 	AND PageRange<>''
/// 	GROUP BY a.DetailId,B.Name 
Query GetPrintPagesByMRItem(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MRItemId:%String,MRItemName:%String,Count:%String,Pages:%String")
{
}

ClassMethod GetPrintPagesByMRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintPagesByMRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintPagesByMRItemExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

 	//将日期格式转换为数字
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s flagAction = " PRINT"
 	
 	//初始化临时global。
 	//用^CacheTemp(repid,"MRItem",DetailId,"Count"/"Pages")用以存储打印次数和页数
 	k ^CacheTemp(repid,"MRItem")
 	//按照时间循环
 	s date=AStartDate-1	//首次按照开始日期-1开始往前走
 	for {
	 	//日期按照索引走 
	 	s date=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date))
	 	//b "01"
	 	q:(date="")||(date>AEndDate)	//为空或者Date>EndDate结束循环
	 	s LogId=""
	 	for {
	 		s LogId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId))
	 		q:(LogId="")
	 		s DetailId=""
	 		for {
		 		s DetailId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId,DetailId))
		 		q:(DetailId="")
		 		s SubId=""
		 		for {
			 		s SubId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId,DetailId,SubId))
			 		q:(SubId="")
			 		s subObj=##Class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(LogId_"||"_DetailId_"||"_SubId)
			 		if (subObj.PageRange'="") //判断为打印且页数不为空
			 		{
				 		if ($d(^CacheTemp(repid,"MRItem",subObj.DetailID,"Count"))="0") //如果不存在，就赋初值0
				 		{s MRItemCount=0}
					 	else
					 	{  
					 		s MRItemCount=^CacheTemp(repid,"MRItem",subObj.DetailID,"Count") 
					 	}
				 		s ^CacheTemp(repid,"MRItem",subObj.DetailID,"Count")=MRItemCount+1
				 		
				 		//处理页数
				 		s Pages=0
				 		if (subObj.PageRange["-")
				 		{
					 		s Pages=$p(subObj.PageRange,"-",2)-$p(subObj.PageRange,"-",1)+1
					 	}
					 	else
					 	{
						 	s Pages=subObj.PageRange
						}
						if ($d(^CacheTemp(repid,"MRItem",subObj.DetailID,"Pages"))="0") //如果不存在，就赋初值0
						{s MRItemPages=0}
						else
						{s MRItemPages=^CacheTemp(repid,"MRItem",subObj.DetailID,"Pages")}
				 		s ^CacheTemp(repid,"MRItem",subObj.DetailID,"Pages")=MRItemPages+Pages
			 		 }
		 		} //sub end
	 		} //detail end
	 	} //log end
	 	
	 	
	} //date end
	
	
	//取临时数组值返回到结果集
	s tmpDetailId=""
	for
	{
		set tmpDetailId=$O(^CacheTemp(repid,"MRItem",tmpDetailId))
		q:(tmpDetailId="")
		//DetailId,Count,Pages
		do OutputToBeArrangedPat(tmpDetailId,^CacheTemp(repid,"MRItem",tmpDetailId,"Count"),
								^CacheTemp(repid,"MRItem",tmpDetailId,"Pages"))
		
	}
	
	//清除临时运算数组
	k ^CacheTemp(repid,"MRItem")
	//b "01"
 	q $$$OK

OutputToBeArrangedPat(DetailId,Count,Pages)
	
	s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(DetailId)
	if (objMRItem="")
		{s detailName = DetailId}
	else
		{
			s detailName = objMRItem.Name
			d objMRItem.%Close()
		}
	
    s ^CacheTemp(repid,ind) = $lb(DetailId,detailName,Count,Pages)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintPagesByMRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintPagesByMRItemExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	增加按照MRItem类型查询 杨鹏 2015.09.13
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 			AMRItemId	归档病历编码
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintDetailByMRItem","2011-06-01","2015-09-15","4")
/// SQL check:
/// SELECT A.* FROM DHCEPRFS_INST.MRLogDetailSub A
/// WHERE MRAction="PRINT" AND 
/// 	CreateDate>='2011-06-01' AND CreateDate<='2015-09-15'
/// 	AND PageRange<>'' AND DetailId='4'
Query GetPrintDetailByMRItem(AStartDate As %String, AEndDate As %String, AMRItemId As %String) As %Query(ROWSPEC = "ActUserID:%String,ActUserName:%String,CreateDateTime:%String,MedRecordNo:%String,PatientName:%String,AdmDate:%String,DisDate:%String,DisLoc:%String,PageRange:%String,PageCount:%String")
{
}

ClassMethod GetPrintDetailByMRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDetailByMRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintDetailByMRItemExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AMRItemId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

 	//将日期格式转换为数字
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s flagAction = " PRINT"
 	
 	//按照时间循环
 	s date=AStartDate-1
 	for {
 		s date=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date))
 		q:(date="")||(date>AEndDate)	//为空或者Date>EndDate结束循环
	 	s LogId=""
	 	for {
	 		s LogId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId))
	 		q:(LogId="")
	 		s DetailId=""
	 		for {
		 		s DetailId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId,DetailId))
		 		q:(DetailId="")
		 		s SubId=""
		 		for {
			 		s SubId=$o(^DHCEPRFS.INST.MRLogDetailSubI("IdxCreateDate",flagAction,date,LogId,DetailId,SubId))
			 		q:(SubId="")
			 		s subObj=##Class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(LogId_"||"_DetailId_"||"_SubId)
			 		if (subObj.PageRange'="") && (subObj.DetailID=AMRItemId) //判断为打印且页数不为空
			 		{
				 		//处理页数
				 		s Pages=0
				 		if (subObj.PageRange["-")
				 		{ s Pages=$p(subObj.PageRange,"-",2)-$p(subObj.PageRange,"-",1)+1}
					 	else
					 	{s Pages=subObj.PageRange}
						
						do OutputToBeArrangedPat(subObj.ActUserID,$zd(subObj.CreateDate,3)_" "_$zt(subObj.CreateTime,3),
							subObj.MREpisodeID,subObj.PageRange,Pages)
						
			 		 }
		 		} //sub end
	 		} //detail end
	 	} //log end
	 	
	 	
	} //date end

 	q $$$OK

OutputToBeArrangedPat(ActUserID,CreateDateTime,MREpisodeID,PageRange,PageCount)
	//"ActUserID:%String,ActUserName:%String,CreateDateTime:%String,MREpisodeID:%String,MRPatientID:%String,
	//PatientName:%String,PageRange:%String,PageCount:%String,MedRecordNo:%String,AdmDate:%String,DisDate:%String,DisLoc:%String"
	if ($p(ActUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(ActUserID,"^",2))
		s ActUserName = objUser.UserName    
	}
	else
	{
    	s ActUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(ActUserID)
	}
	//取得病历表对象--取得病人号和病人姓名
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	if (objEpisode="")
	{
		s MRPatientID=""
		s PatientName=""
		s MedRecordNo=""
		s AdmDate=""
		s DisDate=""
		s DisLoc=""
	}
	else
	{
		s MRPatientID=objEpisode.MRPatientID
		s objPatient=##Class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		s PatientName=objPatient.Name
		s MedRecordNo=objEpisode.MedRecordNo
		s AdmDate=$zd(objEpisode.AdmDate,3)
		if (objEpisode.DisDate="")
		{s DisDate=""}
		else
		{s DisDate=$zd(objEpisode.DisDate,3)}
		s DisLoc=objEpisode.DisLoc
	}

    s ^CacheTemp(repid,ind) = $lb(ActUserID,ActUserName,CreateDateTime,MedRecordNo,
    		PatientName,AdmDate,DisDate,DisLoc,PageRange,PageCount)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintDetailByMRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDetailByMRItemExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	病历示踪模块增加按照病案号、登记号、姓名查询病人信息 杨鹏 2015.10.8
/// Input：	AQueryType 		查询方式 1=病案号 2=登记号 3=姓名
/// 		AQueryContent 	结束日期
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).GetPatientInfoForMRTrack("3","刘杰")
/// SQL check:
ClassMethod GetPatientInfoForMRTrack(AQueryType As %String, AQueryContent As %String) As %String
{
	s MRPatientIDList = ""
	
	if (AQueryType="1")
	{
		s MRMedRecordID=$o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," " _ AQueryContent,""))
		q:(MRMedRecordID = "") ""
		
		s objMRMedRecord=##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
		s MRPatientIDList=objMRMedRecord.MRPatientID
	}
	elseif (AQueryType="2")
	{
		s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," " _ AQueryContent,""))
		q:(MRPatientID = "") ""
		
		s objMRMedRecord=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		s MRPatientIDList=objMRMedRecord.%Id()
	}
	elseif (AQueryType="3")	//姓名查询 可能多个
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName"," " _ $zcvt(AQueryContent,"U"),MRPatientID))
			q:(MRPatientID="")
			
			if (MRPatientIDList = "") 
			{	s MRPatientIDList = MRPatientID}
			else 
			{	s MRPatientIDList = MRPatientIDList_"^"_MRPatientID}
		}
	}
	
	q:(MRPatientIDList="") ""
		
	s retStr = $$GetInfoByPatientIDList(MRPatientIDList)
	q retStr
	
	
GetInfoByPatientIDList(MRPatientIDList)
	s hash = ##class(%ArrayOfDataTypes).%New()
	s mrEpisodeIDList = ##Class(%ListOfDataTypes).%New()
	
	s count = $L(MRPatientIDList,"^")
	//b
	for i = 1:1:count
	{
		s oneMRPatientID = $P(MRPatientIDList,"^",i)
		s oneMREpisodeID=""
		for { //循环取得每个MRPatientID对应的Episode信息
			s oneMREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," " _ oneMRPatientID,oneMREpisodeID))
			q:oneMREpisodeID=""
			
			continue:(hash.GetAt(oneMREpisodeID) '= "")
			d hash.SetAt(oneMREpisodeID,oneMREpisodeID)
			d mrEpisodeIDList.Insert(oneMREpisodeID)
			
			s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(oneMREpisodeID)
			
			s motherEpisodeID = objMREpisode.MotherEpisodeID
			if (motherEpisodeID '="") 
			{s motherMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(motherEpisodeID,"DHC")}
			else
			{s motherMREpisodeID = ""}
			s childrenMREpisodeIDS = ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByMRAdmID(oneMREpisodeID)
			continue:(motherMREpisodeID="")&&(childrenMREpisodeIDS="")
			
			s releatedIDList = 	motherMREpisodeID_"^"_childrenMREpisodeIDS
			if (releatedIDList '= "")
			{
				for j=1:1:$l(releatedIDList,"^")
				{						
					s releatedID = $p(releatedIDList,"^",j)
					continue:(releatedID="")
					continue:(hash.GetAt(releatedID) '= "")
					
					d hash.SetAt(releatedID,releatedID)
					d mrEpisodeIDList.Insert(releatedID)
				}
			}
		}
	}
	
	q:(mrEpisodeIDList.Size=0) ""
	
	s retStr = ""
	
	//b
	for k = 1:1:mrEpisodeIDList.Size
	{
		s mrEpisodeID = mrEpisodeIDList.GetAt(k)
		s childMREpisodeID = mrEpisodeID
		
		s objChildMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s childMRPatientID = objChildMREpisode.MRPatientID
		s objChildMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(childMRPatientID)
		s childName = objChildMRPatient.Name
		if (objChildMRPatient.Birthday'="") {s childBirthday=$zd(objChildMRPatient.Birthday,3)} else {s childBirthday=""}
		s childRegNo=objChildMRPatient.RegNo
		if (objChildMREpisode.AdmDate'="") {s childAdmDate=$zd(objChildMREpisode.AdmDate,3)} else {s childAdmDate=""}
		if (objChildMREpisode.DisDate'="") {s childDisDate=$zd(objChildMREpisode.DisDate,3)} else {s childDisDate=""}
		s childDisLoc=objChildMREpisode.DisLoc
		s childMedRecordNo=objChildMREpisode.MedRecordNo
		s childEpisodeID=objChildMREpisode.EpisodeID
										
		s RegNo = $$GetMotherRegNo(objChildMREpisode.MotherEpisodeID)
		s RegNoChild = $$GetChildRegNo(mrEpisodeID)
				
		if retStr '= "" {s retStr = retStr_"~"}
		s retStr = retStr_childMRPatientID _ "^" _ childName _ "^" _ childBirthday _ "^" _ childAdmDate _ "^" _
					childDisDate _ "^" _ childDisLoc _ "^" _ childRegNo _ "^" _ childMedRecordNo _ "^" _ childEpisodeID _ "^" _ childMREpisodeID _ "^" _ RegNo_"^"_RegNoChild
	}
	
	quit $tr(retStr,$char(0),"")
	
GetMotherRegNo(MotherEpisodeID)
	q:(MotherEpisodeID = "") ""
	s motherMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(MotherEpisodeID,"DHC")
	q:(motherMREpisodeID = "") ""
	s objMother = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(motherMREpisodeID)
	q:(objMother="") ""
	s objMotherPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(objMother.MRPatientID)
	q objMotherPatient.RegNo
	
GetChildRegNo(mrEpisodeID)
	s childReg = ""
	
	s childList = ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByMRAdmID(mrEpisodeID)
	q:(childList="") childReg
	
	s childCount = $L(childList,"^")
	for m = 1:1:childCount
	{
		s objChild = ##Class(DHCEPRFS.INST.MREpisode).%OpenId($p(childList,"^",m))
		continue:(objChild="")
		
		s objChildPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(objChild.MRPatientID)
		if (childReg '= "") s childReg = childReg_" "
		s childReg = childReg_objChildPatient.RegNo
	}
	q childReg
	
	/*
	s hash = ##class(%ArrayOfDataTypes).%New()
	
	s MRPatientID=""	//Patient表ID
	
	//取得MRPatientID或MRPatientID数组
	if (AQueryType="1")	//病案号查询  // 改为从MedRecord取得MRPatientID DHCEPRFS.INST.MRMedRecord
	{
		s MRMedRecordID=""
		s MRMedRecordID=$o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," " _ AQueryContent,MRMedRecordID))
		if (MRMedRecordID="")
		{
			s MRPatientID=""
		}
		else
		{
			s objMRMedRecord=##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
			s MRPatientID=objMRMedRecord.MRPatientID
		}
	}
	
	//w "病案号查询:" _ MRPatientID,!
	if (AQueryType="2")	//登记号查询
	{
		s MRPatientID=""
		s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," " _ AQueryContent,MRPatientID))
	}
	
	if (AQueryType="3")	//姓名查询 可能多个
	{
		s nameId=""
		for {
			s nameId=$o(^DHCEPRFS.INST.MRPatientI("IdxName"," " _ AQueryContent,nameId))
			q:nameId=""
			s MRPatientID=MRPatientID _ nameId _"^"
		}
	}
	
	//通过MRPatientID 查询详细信息 MRPatientID,Name,Birthday,AdmDate,DisDate,DisLoc,RegNo,MedRecordNo,EpisodeID,MREpisodeID
	s retStr=""
	for i=1:1:$l(MRPatientID,"^")
	{	//循环取得每个MRPatientID
		s oneMRPatientID=$p(MRPatientID,"^",i)
		q:oneMRPatientID=""
		s objMRPatient=##Class(DHCEPRFS.INST.MRPatient).%OpenId(oneMRPatientID)
		
		s Name=objMRPatient.Name
		if (objMRPatient.Birthday'="") {s Birthday=$zd(objMRPatient.Birthday,3)} else {s Birthday=""}
		s RegNo=objMRPatient.RegNo
		
		s oneMREpisodeID=""
		for { //循环取得每个MRPatientID对应的Episode信息
			s oneMREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," " _ oneMRPatientID,oneMREpisodeID))
			q:oneMREpisodeID=""
			s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(oneMREpisodeID)
			if (objMREpisode.AdmDate'="") {s AdmDate=$zd(objMREpisode.AdmDate,3)} else {s AdmDate=""}
			if (objMREpisode.DisDate'="") {s DisDate=$zd(objMREpisode.DisDate,3)} else {s DisDate=""}
			s DisLoc=objMREpisode.DisLoc
			s MedRecordNo=objMREpisode.MedRecordNo
			s EpisodeID=objMREpisode.EpisodeID
			s MREpisodeID=oneMREpisodeID
				
			//增加母亲附属小孩
			s childrenMREpisodeIDS = ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByMRAdmID(MREpisodeID)
			if (childrenMREpisodeIDS '= "")
			{
				for index=1:1:$l(childrenMREpisodeIDS,"^")
				{
					s childMREpisodeID = $p(childrenMREpisodeIDS,"^",index)
					if (childMREpisodeID = "212238")
					{
						b "s"	
					}
					s objChildMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(childMREpisodeID)
					s childMRPatientID = objChildMREpisode.MRPatientID
					s objChildMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(childMRPatientID)
					s childName = objChildMRPatient.Name
					if (objChildMRPatient.Birthday'="") {s childBirthday=$zd(objChildMRPatient.Birthday,3)} else {s childBirthday=""}
					s childRegNo=objChildMRPatient.RegNo
					if (objChildMREpisode.AdmDate'="") {s childAdmDate=$zd(objChildMREpisode.AdmDate,3)} else {s childAdmDate=""}
					if (objChildMREpisode.DisDate'="") {s childDisDate=$zd(objChildMREpisode.DisDate,3)} else {s childDisDate=""}
					s childDisLoc=objChildMREpisode.DisLoc
					s childMedRecordNo=objChildMREpisode.MedRecordNo
					s childEpisodeID=objChildMREpisode.EpisodeID
					if (hash.GetAt(childMREpisodeID) = "")
					{
						d hash.SetAt(childMREpisodeID,childMREpisodeID)
			
						s retStr=retStr _ childMRPatientID _ "^" _ childName _ "^" _ childBirthday _ "^" _ childAdmDate _ "^" _
							childDisDate _ "^" _ childDisLoc _ "^" _ childRegNo _ "^" _ childMedRecordNo _ "^" _ childEpisodeID _ "^" _ childMREpisodeID _ "^" _ RegNo_ "^~"
					}
				}
			}
			
			//增加孩子的母亲
			s motherEpisodeID = objMREpisode.MotherEpisodeID
			if (motherEpisodeID '= "")
			{
				s motherMREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(motherEpisodeID,"DHC")
				if (motherMREpisodeID '= "")
				{
					s objMotherMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(motherMREpisodeID)
					s motherMRPatientID = objMotherMREpisode.MRPatientID
					s objMotherMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(motherMRPatientID)
					s motherName = objMotherMRPatient.Name
					if (objMotherMRPatient.Birthday'="") {s motherBirthday=$zd(objMotherMRPatient.Birthday,3)} else {s motherBirthday=""}
					s motherRegNo=objMotherMRPatient.RegNo
					if (objMotherMREpisode.AdmDate'="") {s motherAdmDate=$zd(objMotherMREpisode.AdmDate,3)} else {s motherAdmDate=""}
					if (objMotherMREpisode.DisDate'="") {s motherDisDate=$zd(objMotherMREpisode.DisDate,3)} else {s motherDisDate=""}
					s motherDisLoc=objMotherMREpisode.DisLoc
					s motherMedRecordNo=objMotherMREpisode.MedRecordNo
					s motherEpisodeID=objMotherMREpisode.EpisodeID
					if (hash.GetAt(motherMREpisodeID) = "")
					{
						d hash.SetAt(motherMREpisodeID,motherMREpisodeID)
			
						s retStr=retStr _ motherMRPatientID _ "^" _ motherName _ "^" _ motherBirthday _ "^" _ motherAdmDate _ "^" _
							motherDisDate _ "^" _ motherDisLoc _ "^" _ motherRegNo _ "^" _ motherMedRecordNo _ "^" _ motherEpisodeID _ "^" _ motherMREpisodeID _ "^^" _ RegNo_ "~"	
					}
				}
			}
			
			//组串，输出
			if (hash.GetAt(MREpisodeID) = "")
			{
				d hash.SetAt(MREpisodeID,MREpisodeID)
			
				s retStr=retStr _ oneMRPatientID _ "^" _ Name _ "^" _ Birthday _ "^" _ AdmDate _ "^" _
					DisDate _ "^" _ DisLoc _ "^" _ RegNo _ "^" _ MedRecordNo _ "^" _ EpisodeID _ "^" _ MREpisodeID _ "^^~"
			}
		}
	}
	q $tr(retStr,$char(0),"")
	*/
}

/// Desc:	病历示踪模块增加按照病案号、登记号、姓名查询病人信息 杨鹏 2015.10.8
/// Input：	AMREpisodeID 		病案就诊ID
/// 		AEpisodeID 	就诊号
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetMRTrackInfoByEpisode","332592","9777617")
/// SQL check:
Query GetMRTrackInfoByEpisode(AMREpisodeID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "StatusName:%String,UserDateTime:%String,UserName:%String,Note:%String")
{
}

ClassMethod GetMRTrackInfoByEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRTrackInfoByEpisodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMRTrackInfoByEpisodeExecute(ByRef qHandle As %Binary, AMREpisodeID As %String, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	//如果AEpisodeID为空，从MREpisodeID取EpisodeID
	if (((AEpisodeID="")||(AEpisodeID=$c(0)))&&(AMREpisodeID'=""))
	{
		s AEpisodeID=##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
	}
	//第0部分：从AdmStatus 获取病例完成信息 1 变 2 记录
	// 病历完成 FlagMRCompletionDate	FlagMRCompletionTime	FlagMRCompletionUserID ，病历完成 /医生
	//最终结算 FlagFinalAccount	FlagFinalAccountDate	FlagFinalAccountTime	FlagFinalAccountUserID，最终结算 //护士
	
	//syscode & EpisodeID is unique ,所以可以取出唯一ID
	s AdmMRStatusLogID = ""
	for {
		s AdmMRStatusLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxEpisodeID"," DHC"," " _ AEpisodeID,AdmMRStatusLogID))
		q:(AdmMRStatusLogID = "")
		
		s objAdmMRStatusLog=##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(AdmMRStatusLogID)
		if (objAdmMRStatusLog '= "")
		{
			s oneActDate = $zd(objAdmMRStatusLog.ChangeDate ,3)
			s oneActTime = $zt(objAdmMRStatusLog.ChangeTime ,1)
			s oneActDateTime = oneActDate_" "_oneActTime
			s oneUserID = objAdmMRStatusLog.ChangeUserID
			s oneUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(oneUserID)
			s oneAct = objAdmMRStatusLog.ChangeAct
			s oneType = objAdmMRStatusLog.Type
			
			if (oneType = "DOCTOR")
			{
				s oneType = "(医生)"	
			}
			else
			{
				s oneType = "(护士)"	
			}
			
			if (oneAct = "COMPLETE")
			{
				s oneAct = "完成"	
			}
			else
			{
				s oneAct = "科室质控退回"	
			}
			
			s oneStatusName=oneAct_" "_oneType
			
			s oneNote=oneType_" "_oneAct
			do OutputToBeArranged(oneStatusName,oneActDateTime,oneUserName,oneNote)


		}
	}
	/*
	//第一部分:调用接口--DHCEPRFS.BL.HISInfo.BLWMRInfo->GetMrStatusString(EpisodeID) 取老病案信息
	// 增加 AdmStatus 1 变 2 记录 //病历完成 FlagMRCompletionDate	FlagMRCompletionTime	FlagMRCompletionUserID ，病历完成 /医生
	// 最终结算 FlagFinalAccount	FlagFinalAccountDate	FlagFinalAccountTime	FlagFinalAccountUserID，最终结算 //护士
	s ret1=##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMrStatusString(AEpisodeID)
	s i=0
	for i=1:1:$l(ret1,$c(1))
	{
		s ret1Part=$p(ret1,$c(1),i)
		q:ret1Part=""
		//w ret1
		do OutputToBeArranged($p(ret1Part,"^",1),$p(ret1Part,"^",2) _ " " _ $p(ret1Part,"^",3) ,$p(ret1Part,"^",4),"病案流通")
	}
	*/
	//w "1 step finished"
	//第二部分:来源于新病案借阅日志 AppointStatus in ("F","D") 授权类型(N:正常未授权; R:拒绝; F:完成授权; D:以默认权限通过)
	//需要其他限定条件吗？ R 也应该显示
	s AuthorGroupID=""
	for {	//单层循环取得EpisodeID 对应的FSAuthorizationGroupID借阅信息
		s AuthorGroupID=$o(^DHCEPRRBAC.INST.FSAuthI("IdxEpisode"," " _ AEpisodeID ,AuthorGroupID))
		//w "AuthorGroupID=" _ AuthorGroupID
		q:AuthorGroupID=""
		s objAuthorGroup=##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AuthorGroupID)
		
		if ((objAuthorGroup.AppointStatus ="R") || (objAuthorGroup.AppointStatus ="F") || (objAuthorGroup.AppointStatus ="D"))	//判断状态
		{
			
			s oneStatusName="借阅授权"
			if ((objAuthorGroup.AppointStatus ="R") || (objAuthorGroup.AppointStatus ="F"))	//拒绝或完成授权采用批准时间
			{	
				s oneAppointDate = $zd(objAuthorGroup.AppointDate,3)
				s oneAppointTime = $zt(objAuthorGroup.AppointTime,1)
			}
			else	//D:以默认权限通过 使用RequestDate
			{
				s oneAppointDate = $zd(objAuthorGroup.RequestDate ,3)
				s oneAppointTime = $zt(objAuthorGroup.RequestTime,1)
			}
			s oneAppointDateTime = oneAppointDate _" "_ oneAppointTime
			s oneUserName=$p($g(^SSU("SSUSR",objAuthorGroup.RequestUserID)),"^",2)
			if (objAuthorGroup.AppointStatus ="R") { s oneNote="借阅(拒绝)" }			
			if (objAuthorGroup.AppointStatus ="F") { s oneNote="借阅(授权通过)" }
			if (objAuthorGroup.AppointStatus ="D") { s oneNote="借阅(默认权限通过)" }

			do OutputToBeArranged(oneStatusName,oneAppointDateTime,oneUserName,oneNote)
		}
	}
	
	//w "2 step finished"
	//第三部分:来源于病案DHCEPRFS.INST.MRLogDetail
	s MRLogID=""
	s MRLogID=$o(^DHCEPRFS.INST.MRLogI("IdxMain"," " _ AMREpisodeID,""))
	
	if (MRLogID=""){quit $$$OK}
	
	//从DHCEPRFS.INST.MRLogDetail 取数据
	s MRLogDetailchildsub=""	//子ID
	s MRLogDetailDetailNum=""	//DetailNum
	for {
		s MRLogDetailDetailNum=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum))	//取得DetailNum
		q:MRLogDetailDetailNum=""
		//因MRLogID 和 MRLogDetailDetailNum 是Unique，所以单条取childsub
		s MRLogDetailchildsub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum,""))
		q:MRLogDetailchildsub=""
		
		s objLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(MRLogID _ "||" _ MRLogDetailchildsub)
		//b "1000"
		s MRActionID=$o(^DHCEPRFS.META.MRActionI("IdxMain"," " _ objLogDetail.MRAction,""))
		
		//w "MRAction=" _ objLogDetail.MRAction _ "LogDetailID=" _MRLogID _ "||" _ MRLogDetailchildsub
		s objMRAction=##class(DHCEPRFS.META.MRAction).%OpenId(MRActionID)
		
		s actionCode = objMRAction.ActionCode
		//科室退回已经在第一步中考虑了，此处再统计则重复
		continue:(actionCode = "DEPTQCBACK")
		continue:(actionCode = "NUSDEPTQCBACK")
		
		if (objMRAction'=""){s oneStatusName=objMRAction.ActionName} else { s oneStatusName=""}
		s oneActDate = $zd(objLogDetail.ActDate ,3)
		s oneActTime = $zt(objLogDetail.ActTime ,1)
		s oneActDateTime = oneActDate_" "_oneActTime
		if ($p(objLogDetail.ActUserID ,"^",1) = "TEMP")
    	{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(objLogDetail.ActUserID,"^",2))
			s oneUserName = objUser.UserName    
		}
		else
		{
    		s oneUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(objLogDetail.ActUserID)
		}
		if (objMRAction'=""){ s oneNote=objMRAction.CategoryName } else { s oneNote="病案处理" }
		
		do OutputToBeArranged(oneStatusName,oneActDateTime,oneUserName,oneNote)
	}	
	q $$$OK

OutputToBeArranged(StatusName,UserDateTime,UserName,Note)
	
	s ^CacheTemp(repid,ind) = $lb(StatusName,UserDateTime,UserName,Note)
	s ind = ind + 1
	
	quit
}

ClassMethod GetMRTrackInfoByEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRTrackInfoByEpisodeExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	按照日期查询打印方案的打印次数及金额 杨鹏 2015.11.9
/// Input：	AMREpisodeID 		病案就诊ID
/// 		AEpisodeID 	就诊号
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).GetPrintPagesGroupByPrintScheme("2015-11-09","2015-11-09")
/// SQL check:
ClassMethod GetPrintPagesGroupByPrintScheme(ABeginDate As %String, AEndDate As %String) As %String
{
	//将日期格式转换为数字
	s BeginDate=$zdh(ABeginDate,3)
	s EndDate=$zdh(AEndDate,3)
	
	//定义三个Array
	s arrCount=##class(%ArrayOfDataTypes).%New()	//人次
	s arrPages=##class(%ArrayOfDataTypes).%New()	//页数
	s arrAmount=##class(%ArrayOfDataTypes).%New()	//金额
	
	for date = BeginDate:1:EndDate
 	{
		s time = ""
	 	for {
			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID,subID))
				 	q:(subID="") 
				 	
				 	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	
				 	if (arrCount.IsDefined(objMRLogDetail.ActSchemeID)="0")
				 	{
					 	d arrCount.SetAt(1,objMRLogDetail.ActSchemeID)
				 		d arrPages.SetAt(objMRLogDetail.ActPages,objMRLogDetail.ActSchemeID)
				 		d arrAmount.SetAt(objMRLogDetail.ActPages*objMRLogDetail.ActPrice
				 		  									,objMRLogDetail.ActSchemeID)
				 	}
				 	else
				 	{
						 d arrCount.SetAt(arrCount.GetAt(objMRLogDetail.ActSchemeID)+1,objMRLogDetail.ActSchemeID)
						 d arrPages.SetAt(arrPages.GetAt(objMRLogDetail.ActSchemeID)+objMRLogDetail.ActPages,
						 					objMRLogDetail.ActSchemeID)
						 d arrAmount.SetAt(arrAmount.GetAt(objMRLogDetail.ActSchemeID)+(objMRLogDetail.ActPages*objMRLogDetail.ActPrice)
											,objMRLogDetail.ActSchemeID)
					}

				}
		 	}
	 	}	
 	}
 	
 	//循环结束
 	s strReturn=""
 	s SchemeID=""
	for {
		s SchemeID=arrCount.Next(SchemeID)
	 	q:SchemeID=""
	 	s objPrintScheme=##class(DHCEPRFS.META.PrintScheme).%OpenId(SchemeID)
	 	
	 	s strReturn=strReturn_SchemeID_"^"_objPrintScheme.SchemeName_"^"_arrCount.GetAt(SchemeID)_"^"
	 				_arrPages.GetAt(SchemeID)_"^"_arrAmount.GetAt(SchemeID)_"~"
	 	
	}
	
	q strReturn
}

/// Desc:	
/// Input：	APrintLogStr="PMREpisodeID^PActUserID^PActPages^PActPrice^PActSchemeID^PRemark^PMRItemIDS^PName^PRelationship^PContact^PIDNumber^PPrintTimes~"
/// 		AFootChargeStr="MREpisodeID^MRMedRecordID^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID^Quan^Price^Amount~"
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).GetPrintPagesGroupByPrintScheme("2015-11-09","2015-11-09")
ClassMethod SavePrintLogAndCharge(AMRPatientID As %String, ATotalAmount As %String, AActUserID As %String, AFootChargeStr As %String, APrintLogStr As %String) As %String
{
	s flag = "true"
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	TSTART	//开始事务
	s $zt = "OnSaveChargeEHandler"
	
	//新增收费主表
	s objPrintCharge =##class(DHCEPRFS.INST.MRPrintCharge).%New()
	s objPrintCharge.FootDate=nowDate
	s objPrintCharge.FootTime =nowTime
	s objPrintCharge.MRPatientID =AMRPatientID
	s objPrintCharge.BeginActDate=nowDate
	s objPrintCharge.BeginActTime=nowTime
	s objPrintCharge.TotalAmount =ATotalAmount
	s objPrintCharge.ActUserID =AActUserID

	s sc=objPrintCharge.%Save()
	
	if ($$$ISOK(sc))
	{/*do nothing*/}
	else
	{
		TROLLBACK
		q "0"
	}
	s ChargeDetailDetailNum=1
	//循环增加LogDetail表
	for i=1:1:$l(APrintLogStr,"~")	//每一次打印
	{
		s onePringLog=$p(APrintLogStr,"~",i)	//取每一次打印数据
		//"PMREpisodeID^PActUserID^PActPages^PActPrice^PActSchemeID^PRemark^PMRItemIDS^PName^PRelationship^PContact^PIDNumber^PPrintTimes~"
		s PPrintTimes=$p(onePringLog,"^",12)
		for j=1:1:PPrintTimes		//每一次打印的打印次数
		{
			//增加打印日志
			s mrLogDetailID=..AddPrintLogAllWOT($p(onePringLog,"^",1),$p(onePringLog,"^",2),$p(onePringLog,"^",3),$p(onePringLog,"^",4),
					$p(onePringLog,"^",5),$p(onePringLog,"^",6),$p(onePringLog,"^",7),$p(onePringLog,"^",8),$p(onePringLog,"^",9),
					$p(onePringLog,"^",10),$p(onePringLog,"^",11))
			if (mrLogDetailID="")
			{
				s flag="false"
				q
			}
			//增加结算子表记录
			s objPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
			s objPrintChargeDetail.MREpisodeID=$p(onePringLog,"^",1)
			s objPrintChargeDetail.MRMedRecordID=""
			s objPrintChargeDetail.PrintTime=nowTime
			s objPrintChargeDetail.ChargeTypeCode="30"
			s objPrintChargeDetail.MRLogDetailID=mrLogDetailID
			s objPrintChargeDetail.Quan=$p(onePringLog,"^",3)
			s objPrintChargeDetail.Price=$p(onePringLog,"^",4)
			s objPrintChargeDetail.Amount=$p(onePringLog,"^",3)*$p(onePringLog,"^",4)
			s objPrintChargeDetail.DetailNum=ChargeDetailDetailNum	//序号
			s ChargeDetailDetailNum=ChargeDetailDetailNum+1
			s objPrintChargeDetail.TheMRPrintCharge=objPrintCharge
			s sc=objPrintChargeDetail.%Save()
			if ($$$ISOK(sc))
			{/*do nothing*/}
			else
			{
				s flag="false"
				q
			}
		}
		if (flag="false")
		{
			q
		}
	}
	
	if (flag = "false")
	{
		TROLLBACK
	  	q "0"
	}	
	//循环增加ChageDetail表（邮寄费和基础费）
	//AFootChargeStr="MREpisodeID^MRMedRecordID^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID^Quan^Price^Amount~"
	for i=1:1:$l(AFootChargeStr,"~")	//每一次打印
	{
		s oneFootCharge=$p(AFootChargeStr,"~",i)
		//增加结算子表记录
		s objPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
		s objPrintChargeDetail.MREpisodeID=$p(oneFootCharge,"^",1)
		s objPrintChargeDetail.MRMedRecordID=""
		s objPrintChargeDetail.PrintTime=nowTime
		s objPrintChargeDetail.ChargeTypeCode=$p(oneFootCharge,"^",4)
		s objPrintChargeDetail.MRLogDetailID=""
		s objPrintChargeDetail.Quan=$p(oneFootCharge,"^",7)
		s objPrintChargeDetail.Price=$p(oneFootCharge,"^",8)
		s objPrintChargeDetail.Amount=$p(oneFootCharge,"^",9)
		s objPrintChargeDetail.DetailNum=ChargeDetailDetailNum	//序号
		s ChargeDetailDetailNum=ChargeDetailDetailNum+1
		s objPrintChargeDetail.TheMRPrintCharge=objPrintCharge
		s sc=objPrintChargeDetail.%Save()
		if ($$$ISOK(sc))
		{/*do nothing*/}
		else
		{
			s flag="false"
			q
		}
	}

	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnSaveChargeEHandler
	TROLLBACK
	q "0"
}

/// Desc:	增加"病历打印"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogAllWOT("1","2583","10","0.8","1")
ClassMethod AddPrintLogAllWOT(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, AActPrice As %String, AActSchemeID As %String, ARemark As %String, AMRItemIDS As %String, AName As %String = "", ARelationship As %String = "", AContact As %String = "", AIDNumber As %String = "") As %String
{
	s flag = "true"
	s AMRAction = "PRINT"
	s ADetailType = "MRITEMID"

	s mrLogDetailID = ""
	for i=1:1:$l(AMRItemIDS,"|")
	{
		s params = $p(AMRItemIDS,"|",i)
		s AMRItemID = $p(params,"@",1)
		s ADetailVersion = $p(params,"@",2)
		s APageRange = $p(params,"@",3)

		if (AMRItemID = "")
		{
			s flag = "false"
			q	
		}
		
		if (i = 1)
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, ARemark, AMRAction, ADetailType, AMRItemID,"TRUE","",ADetailVersion,APageRange)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
			s ret = ..AddPrintInfo(mrLogDetailID,AMREpisodeID,AName,ARelationship,AContact,AIDNumber)
			if (ret = "-1")
			{
				s flag = "false"
				q			
			}
		}
		else
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, ARemark, AMRAction, ADetailType, AMRItemID,"FALSE",mrLogDetailID,ADetailVersion,APageRange)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
		}
	}

	if (flag = "true")
	{
		q mrLogDetailID
	}
  	else
  	{
	  	q ""
  	}	
OnAddPAllLogDtlErrorHandler
	q ""
}

/// Desc：获取扫描操作者
/// Creator：LiuShuang
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanOperator")
Query GetScanOperator() As %Query(ROWSPEC = "ID:%String,UserName:%String")
{
}

ClassMethod GetScanOperatorExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems")
 	
 	s BaseRoleID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("ScanOperatorBaseRoleID")
 	q:(BaseRoleID = "") $$$OK
 	s rowID = ""
 	for
 	{
	 	s rowID = $o(^DHCEPRFS.META.QueryRoleD(rowID))
	 	q:(rowID="")
	 	s RoleDesc = ""
 		s RoleID = ""
 		s obj = ##class(DHCEPRFS.META.QueryRole).%OpenId(rowID)
 		s ParentID = obj.ParentID
 		if (rowID '=BaseRoleID)
 		{
	 		if (ParentID '= "")||(ParentID '= $c(0))
	 		{
		 		for i = 1:1:$L(ParentID,"^")
		 		{
			 		s parentRoleID = $p(ParentID,"^",i)
			 		if (parentRoleID = BaseRoleID )
			 		{
				 		s ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID) = rowID
			 		}
		 		}
	 		}
 		}
 		else
 		{
	 		s ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID) = rowID
 		}	
 	}
 	s rowID = ""
 	s queryRowID = ""
 	for
 	{
 		s rowID = $o(^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID))
 		q:(rowID = "")
 		
 		for
 		{
 			s queryRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxRoleID"," "_rowID,queryRowID))
 			q:(queryRowID = "")
 		
 			s objQueryUser = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(queryRowID)
 			s queryUserID = objQueryUser.UserID
 		
 			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(queryUserID)
 			continue:(objUser = "")
 		
 			s ID = queryUserID
 			s UserName = objUser.UserName
 	
 			s data = $lb(ID,UserName)
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1
 		}
 	}
	
	Quit $$$OK
}

ClassMethod GetScanOperatorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanOperatorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScanOperatorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanOperatorExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc：获取基角色已经继承于基角色的角色
/// Creator：LiuShuang
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetAllRoleItems")
Query GetAllRoleItems() As %Query(ROWSPEC = "RoleID:%String,RoleDesc:%String")
{
}

ClassMethod GetAllRoleItemsExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems")
 	
 	s ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",0) = ""_"^"_""
 	s BaseRoleID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("ScanOperatorBaseRoleID")
 	q:(BaseRoleID = "") $$$OK
 	s rowID = ""
 	for
 	{
	 	s rowID = $o(^DHCEPRFS.META.QueryRoleD(rowID))
	 	q:(rowID="")
	 	s RoleDesc = ""
 		s RoleID = ""
 		s obj = ##class(DHCEPRFS.META.QueryRole).%OpenId(rowID)
 		s ParentID = obj.ParentID
 		if (rowID '=BaseRoleID)
 		{
	 		if (ParentID '= "")||(ParentID '= $c(0))
	 		{
		 		for i = 1:1:$L(ParentID,"^")
		 		{
			 		s parentRoleID = $p(ParentID,"^",i)
			 		if (parentRoleID = BaseRoleID )
			 		{
				 		s ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID) = rowID_"^"_obj.RoleDesc
			 		}
		 		}
	 		}
 		}
 		else
 		{
	 		s ^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID) = rowID_"^"_obj.RoleDesc
 		}	
 	}
 	s rowID = ""
 	for
 	{
 		s rowID = $o(^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID))
 		q:(rowID = "")
 		
 		s RoleID = $p(^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID),"^",1)
		s RoleDesc = $p(^CacheTemp("DHCEPRFS","BLMRLog","GetAllRoleItems",rowID),"^",2)
 	
 		s data = $lb(RoleID,RoleDesc)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
 	}
	
	Quit $$$OK
}

ClassMethod GetAllRoleItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllRoleItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllRoleItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllRoleItemsExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	扫描日志总汇
/// Creator：LiuShuang
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanLogSummary","2015-01-01","2016-05-01","","","","")
Query GetScanLogSummary(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String, AScan As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID:%String,ScanUserName:%String,roleName:%String,ScanPages:%String,ScanDateTime:%String,EpisodeCount:%String,MedRecordCount:%String")
{
}

ClassMethod GetScanLogSummaryExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String, AScan As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	k ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary")
	k ^CacheTemp(repid,"dhceprfs","getscanlog")

	s flagActionStr = "SCAN^SCANDELETE^SCANMEDRECORD"
	if (AType '= "")
	{
		if (AType = "SCAN^SCANDELETE")
		{
			s flagActionStr = "SCAN^SCANDELETE^SCANMEDRECORD"
		}
		else
		{
			s flagActionStr = AType
		}
	}

 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	s:(AScan = $c(0)) AScan = ""
 	
 	for index = 1:1:$l(flagActionStr,"^")
 	{
	 	s flagAction = $p(flagActionStr,"^",index)
 		if (AUserName '= "")
 		{
	 		s userID = ""
	 		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 		s sc = rset.Execute(AUserName)
	 		while (rset.Next())
	 		{
		 		s SSUserID = rset.Data("SSUserID")	
		 		s userID = ""
		 		if ((SSUserID = "") || (SSUserID = $c(0)))
		 		{
					s userID = "TEMP^"_rset.Data("UserID") 	
				}
				else
				{
					s userID = SSUserID	
				}
				
				s userRoleRowID = rset.Data("UserID")
				s userrowID = ""
				s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
				q:(userrowID="")
				s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 				s roleID = userRoleObj.RoleID
 				s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 				s roleName = queryRoleObj.RoleDesc
 				if (AScan '= "")&&(AScan '= $c(0))
 				{
	 				if (roleID '= AScan)
	 				{
		 				continue
	 				}
 				}
			
 				for date = AStartDate:1:AEndDate
 				{
	 				s time = ""
	 				for {
		 				s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time))
		 				q:(time="")
		 			
		 				s mrLogID = ""
		 				for {
			 				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID))
			 				q:(mrLogID="")
			 			
			 				s subID = ""
			 				for {
				 				s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_userID,date,time,mrLogID,subID))
			 					q:(subID="")
			 				
			 					s mrLogDetailID = mrLogID_"||"_subID
				 	
				 				s objMRLogDtl = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogDetailID)
				 				continue:(objMRLogDtl="")
				 	
				 				s actUserID = userID
 
				 				s actPages = objMRLogDtl.ActPages
				 				continue:(actPages="0")
				 				s actDate = objMRLogDtl.ActDate
				 				s actTime = objMRLogDtl.ActTime
				 				s mrEpisodeID = objMRLogDtl.MREpisodeID
				 	
				 				if (AMedRecordID '= "")
				 				{
				 					s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				 					s medRecordNo = mrEpisodeObj.MedRecordNo
				 					continue:(medRecordNo '= AMedRecordID)
				 				
					 			}
								s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 				s mrMedRecordID = objMRLog.MRMedRecordID
				 				s mrEpisodeID = objMRLog.MREpisodeID
				 				if (mrEpisodeID = "")
				 				{
					 				do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 			}
					 			else
					 			{
				 					do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 			} 
			 				}
		 				}
	 				}
 				}
	 		}
	 		d rset.Close()
 		}
 		elseif (AMedRecordID '= "")
 		{
	 		s mrEpisodeID = ""
	 		for {
	 			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordID,mrEpisodeID))
	 			q:(mrEpisodeID = "")
	 			s mrLogID = ""
	 			for {
					s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID, mrLogID))
					q:(mrLogID="")
					s subID = ""
					for {
						s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,subID))	
						q:(subID="")	
						s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
						continue:(objMRLogDetail="") 
						continue:(objMRLogDetail.MRAction '= flagAction)
						continue:((objMRLogDetail.ActDate < AStartDate) || (objMRLogDetail.ActDate > AEndDate))	
			
						s actUserID = objMRLogDetail.ActUserID
						s actPages = objMRLogDetail.ActPages
						continue:(actPages="0")
						s actDate = objMRLogDetail.ActDate
						s actTime = objMRLogDetail.ActTime
						s mrEpisodeID = mrEpisodeID
				 		s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 		s mrMedRecordID = objMRLog.MRMedRecordID
				 		s mrEpisodeID = objMRLog.MREpisodeID
				 		
				 		
				 		s userRoleRowID = ""
						if ($p(actUserID,"^",1) = "TEMP")
    					{
							s userRoleRowID =$p(actUserID,"^",2)  
						}
						else
						{
    						s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    						q:(userRoleRowID="")
						}
						s userrowID = ""
						s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
						q:(userrowID="")
						s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 						s roleID = userRoleObj.RoleID
 						s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 						s roleName = queryRoleObj.RoleDesc
 						if (AScan '= "")&&(AScan '= $c(0))
 						{
	 						if (roleID '= AScan)
	 						{
		 						continue
	 						}
 						}
				 		
				 		
				 		if (mrEpisodeID = "")
				 		{
					 		do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 	}
					 	else
					 	{
				 			do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 	} 
					}
				}
			}
		}
		else
		{
	 		for date = AStartDate:1:AEndDate
 			{
	 			s time = ""
	 			for {
		 			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time))
		 			q:(time="")
		 	
		 			s mrLogID = ""
		 			for {
				 		s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID))
			 			q:(mrLogID="")
			 	
			 			s subID = ""
				 		for {
					 		s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," "_flagAction,date,time,mrLogID,subID))
				 			q:(subID="")
				 	
				 			s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 			continue:(objMRLogDetail="")
				 	
				 			s actUserID = objMRLogDetail.ActUserID
				 			//continue:((AUserID '= "")&&(AUserID '= actUserID))
				 	 
				 			s actPages = objMRLogDetail.ActPages
				 			continue:(actPages="0")
				 			s actDate = objMRLogDetail.ActDate
				 			s actTime = objMRLogDetail.ActTime
				 	
				 			s objMRLog = ##Class(DHCEPRFS.INST.MRLog).%OpenId(mrLogID)
				 			s mrEpisodeID = objMRLog.MREpisodeID
				 			s mrMedRecordID = objMRLog.MRMedRecordID
				 			
				 			
				 			s userRoleRowID = ""
							if ($p(actUserID,"^",1) = "TEMP")
    						{
								s userRoleRowID =$p(actUserID,"^",2) 
							}
							else
							{
    							s userRoleRowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_actUserID,""))
    							q:(userRoleRowID="")
							}
							s userrowID = ""
							s userrowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_userRoleRowID,""))
							q:(userrowID="")
							s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userrowID)
 							s roleID = userRoleObj.RoleID
 							s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 							s roleName = queryRoleObj.RoleDesc
 							if (AScan '= "")&&(AScan '= $c(0))
 							{
	 							if (roleID '= AScan)
	 							{
		 							continue
	 							}
 							}
				 			
				 			
				 			if (mrEpisodeID = "")
				 			{
					 			do OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
					 		}
					 		else
					 		{
				 				do OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
					 		} 
			 			}
		 			}
	 			}
 			}	
		}
 	}
 	
 	s count = 0
 	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^CacheTemp(repid,"dhceprfs","getscanlog","MREpisodeID",mrEpisodeID))
		q:(mrEpisodeID = "")
		s count = count + 1	
	}
	s episodeCount = count 
	
	s count = 0
	s medRecordNo = ""
	for {
		s medRecordNo = $o(^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",medRecordNo))
		q:(medRecordNo = "")
		s count = count + 1	
	}
	s medRecordCount = count
	
	s userRowID = ""
 	for
 	{
 		s userRowID = $o(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID))
 		q:(userRowID = "")
 		s rowID = ""
 		for
 		{
	 		s rowID = $o(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID))
	 		q:(rowID = "")
 			s MrPatientID = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",1)
 			s mrEpisodeID = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",2)
 			s MedRecordNo = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",3)
 			s Name = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",4)
 			s Birthday = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",5)
 			s Sex = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",6)
 			s AdmDateTime = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",7)
 			s DisDateTime = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",8)
 			s AdmLoc = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",9)
 			s DisLoc = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",10)
 			s ActUserID = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",11)
 			s actUserName = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",12)
 			s roleName = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",13)
 			s actPages = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",14)
 			s actDateTime = $p(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",userRowID,rowID),"|",15)
	
 			s ^CacheTemp(repid,ind) = $lb(MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,ActUserID,actUserName,roleName,actPages,actDateTime,"","")
			s ind = ind + 1
 		}
 	}
 	
 	s ^CacheTemp(repid,ind) = $lb("","","","","","","","","","","","","",0,"",episodeCount,medRecordCount)
 	s ind = ind + 1
 	
 	k ^CacheTemp(repid,"dhceprfs","getscanlog")
 	k ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary")
 	
 	q $$$OK
 	
 	
OutputMREpisodeIDScanLog(mrEpisodeID,actUserID,actPages,actDate,roleName) 
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s MedRecordNo = objEpisode.MedRecordNo 
	s ^CacheTemp(repid,"dhceprfs","getscanlog","MREpisodeID",mrEpisodeID) = mrEpisodeID
	s ^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",MedRecordNo) = MedRecordNo
    s AdmDate = objEpisode.AdmDate
    s AdmDateTime = ""
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	s DisDateTime = ""
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    if ($d(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,mrEpisodeID)))
    {	
    	
        s actPagesAct = +actPages+$P(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,mrEpisodeID),"|",14)	
    	s ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,mrEpisodeID) = MrPatientID_"|"_mrEpisodeID_"|"_MedRecordNo_"|"_Name_"|"_Birthday_"|"_Sex_"|"_AdmDateTime_"|"_DisDateTime_"|"_AdmLoc_"|"_DisLoc_"|"_actUserID_"|"_actUserName_"|"_roleName_"|"_actPagesAct_"|"_actDateTime
		//b "01"
	}
	else
	{
		s ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,mrEpisodeID) = MrPatientID_"|"_mrEpisodeID_"|"_MedRecordNo_"|"_Name_"|"_Birthday_"|"_Sex_"|"_AdmDateTime_"|"_DisDateTime_"|"_AdmLoc_"|"_DisLoc_"|"_actUserID_"|"_actUserName_"|"_roleName_"|"_actPages_"|"_actDateTime
		//b "02"
	}
    
	
	quit
	
OutputMRMedRecordIDScanLog(mrMedRecordID,actUserID,actPages,actDate,roleName) 
	s objMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
	q:(objMedRecord = "")
	
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s MedRecordNo = objMedRecord.MedRecordNo
	s ^CacheTemp(repid,"dhceprfs","getscanlog","MedRecordNo",MedRecordNo) = MedRecordNo

	s MrPatientID = objMedRecord.MRPatientID

    d objMedRecord.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objPatient.MedRecordNo
    d objPatient.%Close()
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    if ($d(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,MedRecordNo)))
	{
		s actPagesAct = +actPages+$P(^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,MedRecordNo),"|",14)
		s ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,MedRecordNo) = MrPatientID_"||"_MedRecordNo_"|"_Name_"|"_Birthday_"|"_Sex_"|"_""_"|"_""_"|"_""_"|"_""_"|"_actUserID_"|"_actUserName_"|"_roleName_"|"_actPagesAct_"|"_actDateTime
	}
	else
	{
		s ^CacheTemp(repid,"DHCEPRFS","BLMRLog","GetScanLogSummary",actUserID,MedRecordNo) = MrPatientID_"||"_MedRecordNo_"|"_Name_"|"_Birthday_"|"_Sex_"|"_""_"|"_""_"|"_""_"|"_""_"|"_actUserID_"|"_actUserName_"|"_roleName_"|"_actPages_"|"_actDateTime
	}
	
	quit
}

ClassMethod GetScanLogSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanLogSummaryExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanLogSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanLogSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 操作员扫描工作量汇总
/// Input: AStartDate 查询起始日期,AEndDate 查询结束日期
/// Debug:d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanWorkload","2016-9-1","2016-9-2")
Query GetScanWorkload(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "ScanUserID:%String,ScanUserName:%String,ScanPages:%String,ScanTimes:%String,EpisodeCount:%String,MedRecordCount:%String")
{
}

ClassMethod GetScanWorkloadExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	k ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload")
 	
 	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	s dateNow = $p($h,",",1)
	if ((AStartDate = "") || (AEndDate = ""))
	{
		s startDate = dateNow
		s endDate = dateNow
	}
	else
	{
		s startDate = $zdh(AStartDate,3)
 		s endDate = $zdh(AEndDate,3)
	}
 	
 	s sumPages = 0
 	s sumTimes = 0
 	
 	s userRowID = ""
	f {
		s userRowID = $o(^DHCEPRFS.META.QueryUserD(userRowID))
		q:(userRowID = "")
		s objQueryUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(userRowID)
		s userCode = objQueryUser.UserCode
		s userName = objQueryUser.UserName
		s userType = objQueryUser.Type
		if (userType = "TEMP")
		{
			s actUserID = " TEMP^"_userRowID
		}
		else
		{
			s actUserID = " "_objQueryUser.SSUserID
		}
		d objQueryUser.%Close()
		d GetMRLogDetail
	}
	
 	s count = 0
 	s mrEpisodeID = ""
	f {
		s mrEpisodeID = $o(^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","EpisodeList",mrEpisodeID))
		q:(mrEpisodeID = "")
		s count = count+1	
	}
	s sumEpisodeCount = count 
	
	s count = 0
	s medRecordNo = ""
	f {
		s medRecordNo = $o(^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MRList",medRecordNo))
		q:(medRecordNo = "")
		s count = count+1	
	}
	s sumMRCount = count
	
 	s ^CacheTemp(repid,ind) = $lb("","总计",sumPages,sumTimes,sumEpisodeCount,sumMRCount)
 	s ind = ind + 1
 	k ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload")
 	q $$$OK
GetMRLogDetail
	s scanPages = 0
	s scanTimes = 0
	f date = startDate:1:endDate
	{
		s time = ""
		f {
			s time = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," SCAN",actUserID,date,time))
			q:(time = "")
			s mrLogID = ""
		 	f {
				s mrLogID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," SCAN",actUserID,date,time,mrLogID))
			 	q:(mrLogID = "")
			 	s subID = ""
				f {
					s subID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," SCAN",actUserID,date,time,mrLogID,subID))
				 	q:(subID = "")
				 			
				 	s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	s actPages = objMRLogDetail.ActPages
				 	s scanPages = scanPages+actPages
				 	s scanTimes = scanTimes+1
				 	s mrEpisodeID = objMRLogDetail.MREpisodeID
				 	s mrMedRecordID = objMRLogDetail.MRMedRecordID
				 	d objMRLogDetail.%Close()
				 	if (mrEpisodeID = "")
				 	{
					 	s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
					 	q:(objMRMedRecord = "")
					 	s medRecordNo = objMRMedRecord.MedRecordNo
					 	if (medRecordNo '= "")
					 	{
					 		s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MRList",medRecordNo) = medRecordNo
					 		s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MedRecordNo",userRowID,medRecordNo) = medRecordNo					 	
					 	}
					 	d objMRMedRecord.%Close()
				 	}
				 	else
				 	{
					 	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					 	q:(objEpisode = "")
					 	s medRecordNo = objEpisode.MedRecordNo 
						s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","EpisodeList",mrEpisodeID) = mrEpisodeID
						s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MREpisodeID",userRowID,mrEpisodeID) = mrEpisodeID
						if (medRecordNo '="")
						{
							s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MRList",medRecordNo) = medRecordNo					
							s ^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MedRecordNo",userRowID,medRecordNo) = medRecordNo
						}
						d objEpisode.%Close()
				 	}
				 }
		 	}
		}
	}
	d GetCount
	s sumPages = sumPages+scanPages
	s sumTimes = sumTimes+scanTimes
	s ^CacheTemp(repid,ind) = $lb(userCode,userName,scanPages,scanTimes,episodeCount,medRecordCount)
 	s ind = ind + 1
 	q
GetCount
 	s count = 0
 	s mrEpisodeID = ""
	f {
		s mrEpisodeID = $o(^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MREpisodeID",userRowID,mrEpisodeID))
		q:(mrEpisodeID = "")
		s count = count+1	
	}
	s episodeCount = count 
	
	s count = 0
	s medRecordNo = ""
	f {
		s medRecordNo = $o(^CacheTemp(repid,"DHCEPRFS","GetScanWorkload","MedRecordNo",userRowID,medRecordNo))
		q:(medRecordNo = "")
		s count = count+1	
	}
	s medRecordCount = count
	q
}

ClassMethod GetScanWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanWorkloadExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanWorkloadExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetLogByMedRecordRange","500300","500400")
Query GetLogByMedRecordRange(AStartMedRecordNo As %String, AEndMedRecordNo As %String) As %Query(ROWSPEC = "MedRecordNo:%String,MRMedRecordID:%String,EpisodeID:%String,MREpisodeID:%String,Name:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,IsScan:%String")
{
}

ClassMethod GetLogByMedRecordRangeExecute(ByRef qHandle As %Binary, AStartMedRecordNo As %String, AEndMedRecordNo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
 	s:(AStartMedRecordNo = $c(0)) AStartMedRecordNo = ""
 	s:(AEndMedRecordNo = $c(0)) AEndMedRecordNo = ""

 	//以字母开头，需要减一
 	s First = +$e(AStartMedRecordNo,1,1)
 	if (First = 0)
 	{
 		s No = +$e(AStartMedRecordNo,2,$l(AStartMedRecordNo)) - 1
 		//补0
 		s add0 = $l(AStartMedRecordNo) - $l(No) - 1
 		for index=1:1:add0
 		{
			s No = "0"_No 	
		}
 		s MedRecordNo = " "_$e(AStartMedRecordNo,1,1)_No
 	}
 	else
 	{
		s MedRecordNo = AStartMedRecordNo 	
	}
 	

	for {
		s MedRecordNo = $O(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC",MedRecordNo))
		q:(MedRecordNo = "")
		
		s EndNo = +$e(AEndMedRecordNo,2,$l(AEndMedRecordNo))
		s MedRecordNoTrim = $tr(MedRecordNo," ","")
		s No = +$e(MedRecordNoTrim,2,$l(MedRecordNoTrim))
		q:(No > EndNo)
		
		s mrMedRecordID = ""
		for {
			s mrMedRecordID = $O(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC",MedRecordNo,mrMedRecordID))
			q:(mrMedRecordID = "")			
			
			s mrEpisodeID = ""
			for {
				s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_mrMedRecordID,mrEpisodeID))
				q:(mrEpisodeID = "")
				do OutputLogMedRecordRange(mrEpisodeID,mrMedRecordID)  
		
		 	}
	 	}
	}

	q $$$OK
 	
 	
OutputLogMedRecordRange(mrEpisodeID,mrMedRecordID) 
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objEpisode = "")
 
 	s EpisodeID = objEpisode.EpisodeID
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    s EpisodeID = objEpisode.EpisodeID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    d objPatient.%Close()
    
    //是否扫描
    s isScan = ..CheckAction(mrEpisodeID,"SCAN")
    if (isScan = "1")
    {
		s isScanDesc = "已扫描"    
	}
	else
	{
		s isScanDesc = "" 
	}
    
	s ^CacheTemp(repid,ind) = $lb(MedRecordNoTrim,mrMedRecordID,EpisodeID,mrEpisodeID,Name,AdmDateTime,DisDateTime,AdmLoc,DisLoc,isScanDesc)
	s ind = ind + 1
	
	quit
}

ClassMethod GetLogByMedRecordRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogByMedRecordRangeExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetLogByMedRecordRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogByMedRecordRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug：	s a = ^CacheTemp("dhceprfs-debug-yang-2016-11-17")
/// 			do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetInputHistoryLog","2016-11-1","2016-11-19","","")
Query GetInputHistoryLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As %Query(ROWSPEC = "MRPatientID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,ScanUserID:%String,ScanUserName:%String,ScanDateTime:%String,RoleName:%String,EpisodeID:%String,MREpisodeID:%String,AType:%String,MedRecordCount:%String,EpisodeCount:%String")
{
}

ClassMethod GetInputHistoryLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	k ^CacheTemp(repid,"dhceprfs","GetInputHLog")
	
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	
 	if (AUserName '= "")
 	{
	 	s userID = ""
	 	s userID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserName"," HIS"," "_$zcvt(AUserName,"U"),userID))
	 	if (userID = "")
	 	{
			s userID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserName"," TEMP"," "_$zcvt(AUserName,"U"),userID))	
		}
			
 		for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.InputMedLogI("IdxUserID"," "_userID," "_userID,date,time))
		 		q:(time="")
		 			
		 		s rowID = ""
		 		for {
			 		s rowID = $O(^DHCEPRFS.INST.InputMedLogI("IdxUserID"," "_userID," "_userID,date,time,rowID))
			 		q:(rowID="")
				 	
				 	s obj = ##Class(DHCEPRFS.INST.InputMedLog).%OpenId(rowID)
				 	//continue:(obj.AType '= "MEDRECORD")
				 	s type = obj.AType
				 	s actUserID = userID
 
				 	s actDate = obj.ActiveDate
				 	s actTime = obj.ActiveTime
				 	s mrMedRecordID = obj.MRMedRecordNo
				 	s medRecordNo = obj.MedRecordNo
					s episodeID = obj.EpisodeID
				 	s mrEpisodeID = obj.MREpisodeID
				 			
				 	do OutputInputHLog(rowID,type,actUserID,actDate,actTime,mrMedRecordID,medRecordNo,episodeID,mrEpisodeID)  
	 			}
 			}
	 	}
 	}
 	elseif (AMedRecordID '= "")
 	{
	 	for date = AStartDate:1:AEndDate
 		{
 			s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.InputMedLogI("IdxMedRecordNo"," "_AMedRecordID,date,time))
		 		q:(time="")
				
				s rowID = ""
				for {
					s rowID = $O(^DHCEPRFS.INST.InputMedLogI("IdxMedRecordNo"," "_AMedRecordID,date,time,rowID))
					q:(rowID="")
					
					s obj = ##Class(DHCEPRFS.INST.InputMedLog).%OpenId(rowID)
				 	//continue:(obj.AType '= "EPISODE")
				 	s type = obj.AType
				 	s actUserID = obj.UserID
				 	s actDate = obj.ActiveDate
				 	s actTime = obj.ActiveTime
				 	s mrMedRecordID = obj.MRMedRecordNo
				 	s medRecordNo = obj.MedRecordNo
				 	s episodeID = obj.EpisodeID
				 	s mrEpisodeID = obj.MREpisodeID
							
				 	do OutputInputHLog(rowID,type,actUserID,actDate,actTime,mrMedRecordID,medRecordNo,episodeID,mrEpisodeID) 
	 			}
 			}
	 	}
	}
	else
	{
	 	for date = AStartDate:1:AEndDate
 		{
 			s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.InputMedLogI("IdxDateTime",date,time))
		 		q:(time="")
				
				s rowID = ""
				for {
					s rowID = $O(^DHCEPRFS.INST.InputMedLogI("IdxDateTime",date,time,rowID))
					q:(rowID="")
					
					s obj = ##Class(DHCEPRFS.INST.InputMedLog).%OpenId(rowID)
				 	//continue:(obj.AType '= "EPISODE")
				 	
				 	s type = obj.AType
				 	s actUserID = obj.UserID
				 	s actDate = obj.ActiveDate
				 	s actTime = obj.ActiveTime
				 	s mrMedRecordID = obj.MRMedRecordNo
				 	s medRecordNo = obj.MedRecordNo
				 	s episodeID = obj.EpisodeID
				 	s mrEpisodeID = obj.MREpisodeID
							
				 	do OutputInputHLog(rowID,type,actUserID,actDate,actTime,mrMedRecordID,medRecordNo,episodeID,mrEpisodeID)  
	 			}
 			}
	 	}
	}
 	
 	s count = 0
 	s EpisodeID = ""
	for {
		s EpisodeID = $o(^CacheTemp(repid,"dhceprfs","GetInputHLog","EpisodeID",EpisodeID))
		q:(EpisodeID = "")
		s count = count + 1	
	}
	s episodeCount = count 
	
	s count = 0
	s MedRecordNo = ""
	for {
		s MedRecordNo = $o(^CacheTemp(repid,"dhceprfs","GetInputHLog","MedRecordNo",MedRecordNo))
		q:(MedRecordNo = "")
		s count = count + 1	
	}
	s medRecordCount = count
	
    s ^CacheTemp(repid,ind) = $lb("","","","","","","","","","","","","","","","",medRecordCount,episodeCount)
	s ind = ind + 1
	
 	k ^CacheTemp(repid,"dhceprfs","GetInputHLog")
 	
 	q $$$OK
 	
 	
OutputInputHLog(rowID,type,actUserID,actDate,actTime,mrMedRecordID,medRecordNo,episodeID,mrEpisodeID) 
	//检查是否是最后一次修改,工作量算到最后一次修改上
	if (type = "MEDRECORD")
	{
		s lastRowID = ""
		s lastDate = $p($h,",",1) + 1
		s lastDate = $o(^DHCEPRFS.INST.InputMedLogI("IdxMedRecordNo"," "_medRecordNo,lastDate),-1)
		s lastTime = ""
		s lastTime = $o(^DHCEPRFS.INST.InputMedLogI("IdxMedRecordNo"," "_medRecordNo,lastDate,lastTime),-1)
		s lastRowID = $o(^DHCEPRFS.INST.InputMedLogI("IdxMedRecordNo"," "_medRecordNo,lastDate,lastTime,lastRowID),-1)
		q:(lastRowID '= rowID)
		
		s ^CacheTemp(repid,"dhceprfs","GetInputHLog","MedRecordNo",medRecordNo) = medRecordNo
	}
	else
	{
		s lastRowID = ""
		s lastDate = $p($h,",",1) + 1
		s lastDate = $o(^DHCEPRFS.INST.InputMedLogI("IdxEpisodeID"," "_episodeID,lastDate),-1)
		s lastTime = ""
		s lastTime = $o(^DHCEPRFS.INST.InputMedLogI("IdxEpisodeID"," "_episodeID,lastDate,lastTime),-1)
		s lastRowID = $o(^DHCEPRFS.INST.InputMedLogI("IdxEpisodeID"," "_episodeID,lastDate,lastTime,lastRowID),-1)
		q:(lastRowID '= rowID)	
		q:($e(episodeID,1,2) '= "VE")	
		
		s ^CacheTemp(repid,"dhceprfs","GetInputHLog","EpisodeID",episodeID) = episodeID
	}
	
	s objQueryUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(actUserID)			 		
	s userRoleID = ""
	s userRoleID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_actUserID,userRoleID))
	q:(userRoleID="")
	s objUserRole = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleID)
 	s roleID = objUserRole.RoleID
 	s objRole = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s roleName = objRole.RoleDesc
 	if (AScan '= "")&&(AScan '= $c(0))
 	{
	 	if (roleID '= AScan)
	 	{
			q
	 	}
 	}
	
	s actUserName = objQueryUser.UserName

	s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
	s mrPatientID = objMRMedRecord.MRPatientID
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
    s Name = objPatient.Name
    s Birthday = objPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    
    if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
    
    s objEpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    s AdmDateTime = ""
	s DisDateTime = ""
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objEpisode.DisTime
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    
    s ^CacheTemp(repid,ind) = $lb(mrPatientID,medRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc,actUserID,actUserName,actDateTime,roleName,episodeID,mrEpisodeID,type,"","")
	s ind = ind + 1
	
	quit
}

ClassMethod GetInputHistoryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInputHistoryLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetInputHistoryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInputHistoryLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveHistoryInputLog(AUserID As %String, AType As %String, AOperatorType As %String, AMedRecordNo As %String, AMRMedRecordNo As %String, AEpisodeID As %String = "", AMREpisodeID As %String = "") As %String [ WebMethod ]
{
	//以MREpisode为准来取就诊号
	if (AMREpisodeID '= "")
	{
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
		s AEpisodeID = objMREpisode.EpisodeID	
	}
	
	s obj = ##class(DHCEPRFS.INST.InputMedLog).%New()
	s obj.ActiveDate = $p($h,",",1)
	s obj.ActiveTime = $p($h,",",2)
	s obj.ActiveType = AOperatorType
	s obj.AType = AType
	s obj.EpisodeID = AEpisodeID
	s obj.MedRecordNo = AMedRecordNo
	s obj.MREpisodeID = AMREpisodeID
	s obj.MRMedRecordNo = AMRMedRecordNo
	s obj.UserID = AUserID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// w ##Class(DHCEPRFS.BL.BLMRLog).TestGetLogByRange()
ClassMethod TestGetLogByRange()
{
	s entity = ##class(DHCEPRFS.Entity.ELogByRange).%New()
	s entity.MedRecordStart = "J505939"	
	s entity.MedRecordEnd = "J515939"
	//s entity.DisDateStart = "2016-1-1"	
	//s entity.DisDateEnd = "2016-1-7"
	
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetLogByRange")
	d obj.Execute(entity)
	while (obj.Next())
	{
		w !,obj.Data("MREpisodeID")_" "_obj.Data("Name")_" "_obj.Data("MedRecordNo")
	}
}

/// Desc:	获取扫描记录 - 从MRLogDtlFinal表中取数据，表明对一次就诊只取最后一次扫描记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserID		用户ID
/// 			s a = ##class(DHCEPRFS.Entity.ELogByRange).%New()
/// 			s a.MedRecordStart = "J472794"
/// 			s a.MedRecordEnd = "J472794"
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetLogByRange",a)
Query GetLogByRange(AParam As DHCEPRFS.Entity.ELogByRange) As %Query(ROWSPEC = "MedRecordNo:%String,MRMedRecordID:%String,EpisodeID:%String,MREpisodeID:%String,Name:%String,AdmDateTime:%String,DisDateTime:%String,DocDisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,IsScan:%String")
{
}

ClassMethod GetLogByRangeExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.ELogByRange) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	s AStartMedRecordNo = AParam.MedRecordStart
	s AEndMedRecordNo = AParam.MedRecordEnd
	s AStartDisDate = AParam.DisDateStart
	s AEndDisDate = AParam.DisDateEnd
	
 	s:(AStartMedRecordNo = $c(0)) AStartMedRecordNo = ""
 	s:(AEndMedRecordNo = $c(0)) AEndMedRecordNo = ""
 	s:(AStartDisDate = $c(0)) AStartDisDate = ""
 	s:(AEndDisDate = $c(0)) AEndDisDate = ""
 	
 	if ((AStartDisDate '= "") && (AEndDisDate '= ""))
 	{
	 	s startDate = $zdh(AStartDisDate,3)
	 	s endDate = $zdh(AEndDisDate,3)
	 	s date = startDate - 1
	 	for {
		 	s date = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisDateDoc",date))
		 	q:(date = "")
		 	q:(date > endDate)
			s mrPatientID = ""
			for {
				//b "s"
				s mrPatientID = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisDateDoc",date,mrPatientID))
				q:(mrPatientID = "")
				s mrEpisodeID = ""
				for {
					s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxDisDateDoc",date,mrPatientID,mrEpisodeID))
					q:(mrEpisodeID = "")
					s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    				q:(objEpisode = "")
    				s mrMedRecordID = objEpisode.MRMedRecordID
    				s medRecordNo = objEpisode.MedRecordNo
					do OutputLogRange(objEpisode,mrEpisodeID,mrMedRecordID,medRecordNo)  
				}
			}
	 	}
 	}
 	elseif ((AStartMedRecordNo '= "") && (AEndMedRecordNo '= ""))
 	{
 		//b "s"
 		//以字母开头，需要减一
 		s No = +$e(AStartMedRecordNo,2,$l(AStartMedRecordNo)) - 1
 		//b "s"
 		//补0
 		s add0 = $l(AStartMedRecordNo) - $l(No) - 1
 		for index=1:1:add0
 		{
			s No = "0"_No 	
		}
 		s MedRecordNo = " "_$e(AStartMedRecordNo,1,1)_No
		for {
			//b "s"
			s MedRecordNo = $O(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC",MedRecordNo))
			q:(MedRecordNo = "")
		
			s EndNo = +$e(AEndMedRecordNo,2,$l(AEndMedRecordNo))
			s MedRecordNoTrim = $tr(MedRecordNo," ","")
			//因为录入了几个比所有病案号都大一位的错误的病案号，而病案号索引是按照字母顺序，所以比如Z1234的下一个病案号是Z12345而不是Z1235，修改逻辑，下一个病案号比最大的位数还大，则跳过不退出
			continue:($l(MedRecordNoTrim) > $l(AEndMedRecordNo))
			s No = +$e(MedRecordNoTrim,2,$l(MedRecordNoTrim))
			q:(No > EndNo)
		
			s mrMedRecordID = ""
			for {
				s mrMedRecordID = $O(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC",MedRecordNo,mrMedRecordID))
				q:(mrMedRecordID = "")			
			
				s mrEpisodeID = ""
				for {
					//b "s"
					s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo",MedRecordNo,mrEpisodeID))
					q:(mrEpisodeID = "")
					s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    				q:(objEpisode = "")
					do OutputLogRange(objEpisode,mrEpisodeID,mrMedRecordID,MedRecordNoTrim)  
				}
		 	}
	 	}
	}

	q $$$OK
 	
 	
OutputLogRange(objEpisode,mrEpisodeID,mrMedRecordID,medRecordNo) 
 	s EpisodeID = objEpisode.EpisodeID
    s AdmDate = objEpisode.AdmDate
    if (AdmDate '= "") 
    {
	    s AdmDateTime = $zd(AdmDate,3)
    }
    else
    {
		s AdmDateTime = ""    
	}
	s AdmTime = objEpisode.AdmTime
	s DisDate = objEpisode.DisDate
	if (DisDate '= "")
	{ 
		s DisDateTime = $zd(DisDate,3)
	}
	else
	{
		s DisDateTime = "" 	
	}
	s DisTime = objEpisode.DisTime
	s DisDateDoc = objEpisode.DisDateDoc
	if (DisDateDoc '= "")
	{ 
		s DisDateTimeDoc = $zd(DisDateDoc,3)
	}
	else
	{
		s DisDateTimeDoc = ""
	}
	s DisTimeDoc = objEpisode.DisTimeDoc
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objEpisode.MRPatientID
    s EpisodeID = objEpisode.EpisodeID
    d objEpisode.%Close()
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    d objPatient.%Close()
    
    //是否扫描
    s isScan = ..CheckAction(mrEpisodeID,"SCAN")
    //北京妇产，只有分类了病案首页才算已扫描
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if (hospitalFlag = "FCYY")
    {
		if (isScan = "1")
		{
			s isScan = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(mrEpisodeID,"119")	
		}    
	}
    if (isScan = "1")
    {
		s isScanDesc = "已扫描"    
	}
	else
	{
		s isScanDesc = "" 
	}
    
	s ^CacheTemp(repid,ind) = $lb(medRecordNo,mrMedRecordID,EpisodeID,mrEpisodeID,Name,AdmDateTime,DisDateTime,DisDateTimeDoc,AdmLoc,DisLoc,isScanDesc)
	s ind = ind + 1
	
	quit
}

ClassMethod GetLogByRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogByRangeExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetLogByRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogByRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetInputHistoryMedRecordCount("2010-1-1","2016-11-3")
ClassMethod GetInputHistoryMedRecordCount(AStartDate As %String, AEndDate As %String)
{
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s count = 0
	s date = startDate - 1
	for {
		s date = $o(^DHCEPRFS.INST.MRMedRecordI("IdxCreateDate",date))
		q:(date = "")
		q:(date > endDate)
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxCreateDate",date,rowID))
			q:(rowID = "")
			
			s obj = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(rowID)
			s isHIS = obj.IsHISMedRecord
			
			if (isHIS = "N")
			{
				s count = count + 1	
			}	
		}
	}
	
	q count
}

/// debug: w ##class(DHCEPRFS.BL.BLMRLog).GetInputHistoryEpisodeCount("2010-1-1","2016-11-3")
ClassMethod GetInputHistoryEpisodeCount(AStartDate As %String, AEndDate As %String)
{
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s count = 0
	s date = startDate - 1
	
	for {
		s date = $o(^DHCEPRFS.INST.MREpisodeI("IdxCreateDate",date))
		q:(date = "")
		q:(date > endDate)
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxCreateDate",date,rowID))
			q:(rowID = "")
		
			s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
			s episodeID = obj.EpisodeID
		
			if ($e(episodeID,1,2) = "VE")
			{
				s count = count + 1	
			}	
		}
	}
	
	q count
}

/// Desc:	获取所有分院
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).GetAllSubHospital()
ClassMethod GetAllSubHospital() As %String
{
	s ret=""
	s HospitalDR=""
	for 
	{
		s HospitalDR=$o(^CT("HOSP",HospitalDR))
		q:(HospitalDR="")
		s HospitalName=$p($g(^CT("HOSP",HospitalDR)),"^",2)
		if (ret="")
		{
			s ret=HospitalDR_"^"_HospitalName
		}
		else
		{
			s ret=ret_"|"_HospitalDR_"^"_HospitalName
		}
	}
	q ret
}

ClassMethod GetPrintPagesGroupBySubHos(ABeginDate As %String, AEndDate As %String, ASubHospitalID As %String) As %String
{
	//将日期格式转换为数字
	s BeginDate=$zdh(ABeginDate,3)
	s EndDate=$zdh(AEndDate,3)
	
	//定义三个Array
	s arrCount=##class(%ArrayOfDataTypes).%New()	//人次
	s arrPages=##class(%ArrayOfDataTypes).%New()	//页数
	s arrAmount=##class(%ArrayOfDataTypes).%New()	//金额
	
	for date = BeginDate:1:EndDate
 	{
		s time = ""
	 	for {
			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID,subID))
				 	q:(subID="") 
				 	
				 	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	
				 	//增加判断分院
				 	if (ASubHospitalID'="0") //0 为全部分院 
				 	{
					 	s MREpisodeID=objMRLogDetail.MREpisodeID
						s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	
						s DisLocID=objMREpisode.DisLocID
						q:(DisLocID = "")

						s HospitalDR=$p($g(^CTLOC(DisLocID)),"^",22)
						q:(HospitalDR'=ASubHospitalID)	
				 	}
				 	
				 	if (arrCount.IsDefined(objMRLogDetail.ActSchemeID)="0")
				 	{
					 	d arrCount.SetAt(1,objMRLogDetail.ActSchemeID)
				 		d arrPages.SetAt(objMRLogDetail.ActPages,objMRLogDetail.ActSchemeID)
				 		d arrAmount.SetAt(objMRLogDetail.ActPages*objMRLogDetail.ActPrice
				 		  									,objMRLogDetail.ActSchemeID)
				 	}
				 	else
				 	{
						 d arrCount.SetAt(arrCount.GetAt(objMRLogDetail.ActSchemeID)+1,objMRLogDetail.ActSchemeID)
						 d arrPages.SetAt(arrPages.GetAt(objMRLogDetail.ActSchemeID)+objMRLogDetail.ActPages,
						 					objMRLogDetail.ActSchemeID)
						 d arrAmount.SetAt(arrAmount.GetAt(objMRLogDetail.ActSchemeID)+(objMRLogDetail.ActPages*objMRLogDetail.ActPrice)
											,objMRLogDetail.ActSchemeID)
					}

				}
		 	}
	 	}	
 	}
 	
 	//循环结束
 	s strReturn=""
 	s SchemeID=""
	for {
		s SchemeID=arrCount.Next(SchemeID)
	 	q:SchemeID=""
	 	s objPrintScheme=##class(DHCEPRFS.META.PrintScheme).%OpenId(SchemeID)
	 	
	 	s strReturn=strReturn_SchemeID_"^"_objPrintScheme.SchemeName_"^"_arrCount.GetAt(SchemeID)_"^"
	 				_arrPages.GetAt(SchemeID)_"^"_arrAmount.GetAt(SchemeID)_"~"
	 	
	}
	
	q strReturn
}

/// Desc:	通过日志汇总打印工作量
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetPrintTotalFromLog","2016-10-01","2016-12-20","")
Query GetPrintTotalFromLog(ABeginDate As %String, AEndDate As %String, ASubHospitalID As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String,EpisodeCount:%Integer,PagesCount:%Integer,TotAmount:%Float")
{
}

ClassMethod GetPrintTotalFromLogExecute(ByRef qHandle As %Binary, ABeginDate As %String, AEndDate As %String, ASubHospitalID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	//将日期格式转换为数字
	s BeginDate=$zdh(ABeginDate,3)
	s EndDate=$zdh(AEndDate,3)
	
	//定义三个Array
	s arrCount=##class(%ArrayOfDataTypes).%New()	//人次
	s arrPages=##class(%ArrayOfDataTypes).%New()	//页数
	s arrAmount=##class(%ArrayOfDataTypes).%New()	//金额
	
	for date = BeginDate:1:EndDate
 	{
		s time = ""
	 	for {
			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID,subID))
				 	q:(subID="") 
				 	
				 	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	
				 	//增加判断分院
				 	if (ASubHospitalID'="0") //0 为全部分院 
				 	{
					 	s MREpisodeID=objMRLogDetail.MREpisodeID
						s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	
						s DisLocID=objMREpisode.DisLocID
						q:(DisLocID = "")

						s HospitalDR=$p($g(^CTLOC(DisLocID)),"^",22)
						q:(HospitalDR'=ASubHospitalID)	
				 	}
				 	
				 	if (arrCount.IsDefined(objMRLogDetail.ActUserID)="0")
				 	{
					 	d arrCount.SetAt(1,objMRLogDetail.ActUserID)
				 		d arrPages.SetAt(objMRLogDetail.ActPages,objMRLogDetail.ActUserID)
				 		d arrAmount.SetAt(objMRLogDetail.ActPages*objMRLogDetail.ActPrice
				 		  									,objMRLogDetail.ActUserID)
				 	}
				 	else
				 	{
						 d arrCount.SetAt(arrCount.GetAt(objMRLogDetail.ActUserID)+1,objMRLogDetail.ActUserID)
						 d arrPages.SetAt(arrPages.GetAt(objMRLogDetail.ActUserID)+objMRLogDetail.ActPages,
						 					objMRLogDetail.ActUserID)
						 d arrAmount.SetAt(arrAmount.GetAt(objMRLogDetail.ActUserID)+(objMRLogDetail.ActPages*objMRLogDetail.ActPrice)
											,objMRLogDetail.ActUserID)
					}

				}
		 	}
	 	}	
 	}
 	
 	//循环结束
 	s strReturn=""
 	s strUserID=""
	for {
		s strUserID=arrCount.Next(strUserID)
	 	q:strUserID=""
	 	s ActUserName=""
		if ($p(strUserID ,"^",1) = "TEMP")
		{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(strUserID,"^",2))
			s ActUserName = objUser.UserName    
		}
		else
		{
			s ActUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(strUserID)
		}
		s ^CacheTemp(repid,ind) = $lb(strUserID,ActUserName,arrCount.GetAt(strUserID),arrPages.GetAt(strUserID),arrAmount.GetAt(strUserID))
		s ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod GetPrintTotalFromLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintTotalFromLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintTotalFromLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintTotalFromLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug w ##class(DHCEPRFS.BL.BLMRLog).AddScanNeedArrangeLog("31","","159","-3","SCAN","43||22")
ClassMethod AddScanNeedArrangeLog(AMREpisodeID As %String, AMRMedRecordID As %String, AActUserID As %String, AActPages As %String, AMRAction As %String, AMRLogDetailID As %String, AIP As %String) As %String
{
	s rowID = ""
	if (AMREpisodeID '= "")
	{
		s rowID = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnEpisodeID"," "_AMREpisodeID,rowID))
		if (rowID ="")
		{
			s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%New()
			s obj.MREpisodeID = AMREpisodeID
			s obj.MRMedRecordID = AMRMedRecordID
			s obj.UserID = AActUserID
			s obj.IP = AIP
			s obj.ActDate = $p($h,",",1)
			s obj.ActTime = $p($h,",",2)
			if (AMRAction="SCAN")
			{
				s obj.ScanPage = +AActPages
				s obj.NeedArrange = "Y"
			}
			else
			{
				s obj.ArrangePage = +AActPages
			}
			s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
			s obj.MedRecordID = objEpisode.MedRecordNo
			s objSub = ##class(DHCEPRFS.INST.ScanNeedArrangeSub).%New()
			s objSub.ScanNeedArrangeLog = obj
			s objSub.MRLogDetail = AMRLogDetailID
			if (AMRAction="SCAN")
			{
				s objSub.ScanPage = +AActPages
			}
			else
			{
				s objSub.ArrangePage = +AActPages
			}
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
		else
		{
			s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
			s obj.MRMedRecordID = AMRMedRecordID
			s obj.UserID = AActUserID
			s obj.IP = AIP
			s obj.ActDate = $p($h,",",1)
			s obj.ActTime = $p($h,",",2)
			if (AMRAction="SCAN")
			{
				s obj.ScanPage = obj.ScanPage+(+AActPages)
			}
			else
			{
				s obj.ArrangePage = obj.ArrangePage+(+AActPages)
			}
			if (obj.ScanPage >obj.ArrangePage)
			{
				s obj.NeedArrange = "Y"
			}
			else
			{
				s obj.NeedArrange = "N"
			}
			s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
			s obj.MedRecordID = objEpisode.MedRecordNo
			s objSub = ##class(DHCEPRFS.INST.ScanNeedArrangeSub).%New()
			s objSub.ScanNeedArrangeLog = obj
			s objSub.MRLogDetail = AMRLogDetailID
			if (AMRAction="SCAN")
			{
				s objSub.ScanPage = +AActPages
			}
			else
			{
				s objSub.ArrangePage = +AActPages
			}
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
	}
	else
	{
		if (AMRMedRecordID '="")
		{
			s rowID = $o(DHCEPRFS.INST.ScanArrangeI("IdxOnMedRecordID"," "_AMRMedRecordID,rowID))
			if (rowID ="")
			{
				s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%New()
				s obj.MREpisodeID = AMREpisodeID
				s obj.MRMedRecordID = AMRMedRecordID
				s obj.UserID = AActUserID
				s obj.IP = AIP
				s obj.ActDate = $p($h,",",1)
				s obj.ActTime = $p($h,",",2)
				if (AMRAction="SCAN")
				{
					s obj.ScanPage = +AActPages
					s obj.NeedArrange = "Y"
				}
				else
				{
					s obj.ArrangePage = +AActPages
				}
				s objSub = ##class(DHCEPRFS.INST.ScanNeedArrangeSub).%New()
				s objSub.ScanNeedArrangeLog = obj
				s objSub.MRLogDetail = AMRLogDetailID
				if (AMRAction="SCAN")
				{
					s objSub.ScanPage = +AActPages
				}
				else
				{
					s objSub.ArrangePage = +AActPages
				}
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
			else
			{
				s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
				s obj.MREpisodeID = AMREpisodeID
				s obj.UserID = AActUserID
				s obj.IP = AIP
				s obj.ActDate = $p($h,",",1)
				s obj.ActTime = $p($h,",",2)
				if (AMRAction="SCAN")
				{
					s obj.ScanPage = obj.ScanPage+(+AActPages)
				}
				else
				{
					s obj.ArrangePage = obj.ArrangePage+(+AActPages)
				}
				if (obj.ScanPage >obj.ArrangePage)
				{
					s obj.NeedArrange = "Y"
				}
				else
				{
					s obj.NeedArrange = "N"
				}
				s objSub = ##class(DHCEPRFS.INST.ScanNeedArrangeSub).%New()
				s objSub.ScanNeedArrangeLog = obj
				s objSub.MRLogDetail = AMRLogDetailID
				if (AMRAction="SCAN")
				{
					s objSub.ScanPage = +AActPages
				}
				else
				{
					s objSub.ArrangePage = +AActPages
				}
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
		}
		else
		{
			q "0"
		}
	}
}

/// Desc：获取扫描用户
/// Creator：LiuShuang
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanUser")
Query GetScanUser() As %Query(ROWSPEC = "userID:%String,userName:%String,userCode:%String")
{
}

ClassMethod GetScanUserExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser")
 	
 	s ^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",0) = ""_"|"_""_"|"_""
 	s rowID = ""
 	for
 	{
	 	s rowID = $o(^DHCEPRFS.INST.ScanArrangeD(rowID))
	 	q:(rowID="")
 		s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
 		s UserID = obj.UserID
 		if ($d(^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",UserID)))
 		{
 		}
 		else
 		{
	 		s userName = ""
	 		if ($p(UserID,"^",1)="TEMP")
	 		{
		 		//b "s"
		 		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(UserID,"^",2))
		 		s userName = objUser.UserName
		 		s userCode = objUser.UserCode
	 		}
	 		else
	 		{
		 		//b "s"
		 		s rowIDUser = ""
		 		s rowIDUser = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_UserID,rowIDUser))
		 		if (rowIDUser '="")
		 		{
			 		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(rowIDUser)
			 		s userName = objUser.UserName
			 		s userCode = objUser.UserCode
		 		}
	 		} 		
	 		s ^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",UserID) = UserID_"|"_userName_"|"_userCode
 		}	
 	}
 	
 	
 	s rowID = ""
 	for
 	{
 		s rowID = $o(^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",rowID))
 		q:(rowID = "")
 		
 		s UserID = $p(^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",rowID),"|",1)
		s userName = $p(^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",rowID),"|",2)
		s userCode = $p(^CacheTemp("DHCEPRFS","BLMRLog","GetScanUser",rowID),"|",3)
 	
 		s data = $lb(UserID,userName,userCode)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
 	}
 	
	
	Quit $$$OK
}

ClassMethod GetScanUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScanUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanUserExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc：获取待分类项目
/// Creator：LiuShuang
/// w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanNeedArrange","159")
Query GetScanNeedArrange(AuserID As %String = "") As %Query(ROWSPEC = "MedRecordNo:%String,MRMedRecordID:%String,MREpisodeID:%String,userName:%String,userCode:%String,actionDate:%String,actionTime:%String,MRPatientID:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String,MainDiagDesc:%String,DeathDate:%String,ScanerName:%String,ScanDateTime:%String,LastStatus:%String,LastMrStatus:%String,LastMrStatusDateTime:%String,LastMrStatusOperator:%String,LastReviewOperator:%String,LastReviewDateTime:%String")
{
}

ClassMethod GetScanNeedArrangeExecute(ByRef qHandle As %Binary, AuserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	if (AuserID = "")
 	{
		s actDate = ""
		for {
			s actDate = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnAllActDate"," Y",actDate))
			q:(actDate="")
			s actTime = ""
			for {
				s actTime = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnAllActDate"," Y",actDate,actTime))
				q:(actTime = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnAllActDate"," Y",actDate,actTime,rowID))
					q:(rowID = "")
		 			s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
		 			s MedRecordID = obj.MedRecordID
		 			s MRMedRecordID = obj.MRMedRecordID
		 			s MREpisodeID = obj.MREpisodeID
		 			s userID = obj.UserID
		 			//s lockStatus = obj.LockStatus
		 			s actionDate = ""
		 			if (actDate '= "")
		 			{
			 			s actionDate = $zd(actDate,3)
		 			}
		 			s actionTime = ""
		 			if (actTime '="")
		 			{
			 			s actionTime = $zt(actTime,1)
		 			}
		 			s userName = ""
	 				if ($p(userID,"^",1)="TEMP")
	 				{
		 				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(userID,"^",2))
		 				s userName = objUser.UserName
		 				s userCode = objUser.UserCode
	 				}
	 				else
	 				{
		 				s rowIDUser = ""
		 				s rowIDUser = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_userID,rowIDUser))
		 				if (rowIDUser '="")
		 				{
			 				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(rowIDUser)
			 				s userName = objUser.UserName
			 				s userCode = objUser.UserCode
		 				}
	 				} 
	 		
	 				s EP = ##Class(DHCEPRFS.Entity.EPatientInfoQueryPara).%New()
					s EP.MedRecordNo = MedRecordID
					s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLPatientInfo:GetPatientInfo")
					s sc = result.Execute(EP)
			
					While (result.Next())
 					{
	 					if (MREpisodeID = $g(result.Data("MREpisodeID")))
	 					{
							s MRPatientID =$g(result.Data("MRPatientID"))
							s Name =$g(result.Data("Name"))
							s Birthday =$g(result.Data("Birthday"))
							s Age =$g(result.Data("Age"))
							s Sex =$g(result.Data("Sex"))
							s HouseAddress =$g(result.Data("HouseAddress"))
							s LinkName =$g(result.Data("LinkName"))
							s LinkRelation =$g(result.Data("LinkRelation"))
							s AdmDateTime =$g(result.Data("AdmDateTime"))
							s DisDateTime =$g(result.Data("DisDateTime"))
							s AdmInLoc =$g(result.Data("AdmInLoc"))
							s DischgrgeLoc =$g(result.Data("DischgrgeLoc"))
							s MainDiagDesc =$g(result.Data("MainDiagDesc"))
							s DeathDate =$g(result.Data("DeathDate"))
							s ScanerName =$g(result.Data("ScanerName"))
							s ScanDateTime =$g(result.Data("ScanDateTime"))
							s LastStatus =$g(result.Data("LastStatus"))
							s LastMrStatus =$g(result.Data("LastMrStatus"))
							s LastMrStatusDateTime =$g(result.Data("LastMrStatusDateTime"))
							s LastMrStatusOperator =$g(result.Data("LastMrStatusOperator"))
							s LastReviewOperator =$g(result.Data("LastReviewOperator"))
							s LastReviewDateTime =$g(result.Data("LastReviewDateTime"))
 						}
 					}
			
					s data = $lb(MedRecordID,MRMedRecordID,MREpisodeID,userName,userCode,actionDate,actionTime,MRPatientID,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmInLoc,DischgrgeLoc,MainDiagDesc,DeathDate,ScanerName,ScanDateTime,LastStatus,LastMrStatus,LastMrStatusDateTime,LastMrStatusOperator,LastReviewOperator,LastReviewDateTime) 
					s ^CacheTemp(repid,ind)=data
					s ind=ind+1		
	 			}
	 		}
	 	}
 	}
 	else
 	{
	 	s actDate = ""
	 	for {
		 	s actDate = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnActDate"," Y"," "_AuserID,actDate))
		 	q:(actDate = "")
		 	s actTime = ""
		 	for {
			 	s actTime = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnActDate"," Y"," "_AuserID,actDate,actTime))
			 	q:(actTime = "")
			 	s rowID = ""
			 	for {
				 	s rowID = $o(^DHCEPRFS.INST.ScanArrangeI("IdxOnActDate"," Y"," "_AuserID,actDate,actTime,rowID))
				 	q:(rowID = "")
		 			s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
		 			s MedRecordID = obj.MedRecordID
		 			s MRMedRecordID = obj.MRMedRecordID
		 			s MREpisodeID = obj.MREpisodeID
		 			s userID = obj.UserID
		 			//s lockStatus = obj.LockStatus
		 			s actionDate =""
		 			if (actDate '= "")
		 			{
			 			s actionDate = $zd(actDate,3)
		 			}
		 			s actionTime = ""
		 			if (actTime '="")
		 			{
			 			s actionTime = $zt(actTime,1)
		 			}
		 			s userName = ""
	 				if ($p(userID,"^",1)="TEMP")
	 				{
		 				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(userID,"^",2))
		 				s userName = objUser.UserName
		 				s userCode = objUser.UserCode
	 				}
	 				else
	 				{
		 				s rowIDUser = ""
		 				s rowIDUser = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_userID,rowIDUser))
		 				if (rowIDUser '="")
		 				{
			 				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(rowIDUser)
			 				s userName = objUser.UserName
			 				s userCode = objUser.UserCode
		 				}
	 				}
	 		
	 				s EP = ##Class(DHCEPRFS.Entity.EPatientInfoQueryPara).%New()
					s EP.MedRecordNo = MedRecordID
					s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLPatientInfo:GetPatientInfo")
					s sc = result.Execute(EP)
	 		
	 				While (result.Next())
 					{
	 					if (MREpisodeID = $g(result.Data("MREpisodeID")))
	 					{
							s MRPatientID =$g(result.Data("MRPatientID"))
							s Name =$g(result.Data("Name"))
							s Birthday =$g(result.Data("Birthday"))
							s Age =$g(result.Data("Age"))
							s Sex =$g(result.Data("Sex"))
							s HouseAddress =$g(result.Data("HouseAddress"))
							s LinkName =$g(result.Data("LinkName"))
							s LinkRelation =$g(result.Data("LinkRelation"))
							s AdmDateTime =$g(result.Data("AdmDateTime"))
							s DisDateTime =$g(result.Data("DisDateTime"))
							s AdmInLoc =$g(result.Data("AdmInLoc"))
							s DischgrgeLoc =$g(result.Data("DischgrgeLoc"))
							s MainDiagDesc =$g(result.Data("MainDiagDesc"))
							s DeathDate =$g(result.Data("DeathDate"))
							s ScanerName =$g(result.Data("ScanerName"))
							s ScanDateTime =$g(result.Data("ScanDateTime"))
							s LastStatus =$g(result.Data("LastStatus"))
							s LastMrStatus =$g(result.Data("LastMrStatus"))
							s LastMrStatusDateTime =$g(result.Data("LastMrStatusDateTime"))
							s LastMrStatusOperator =$g(result.Data("LastMrStatusOperator"))
							s LastReviewOperator =$g(result.Data("LastReviewOperator"))
							s LastReviewDateTime =$g(result.Data("LastReviewDateTime"))
 						}
 					}
			
	 				s data = $lb(MedRecordID,MRMedRecordID,MREpisodeID,userName,userCode,actionDate,actionTime,MRPatientID,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmInLoc,DischgrgeLoc,MainDiagDesc,DeathDate,ScanerName,ScanDateTime,LastStatus,LastMrStatus,LastMrStatusDateTime,LastMrStatusOperator,LastReviewOperator,LastReviewDateTime) 
					s ^CacheTemp(repid,ind)=data
					s ind=ind+1				 	
	 			}
	 		}
	 	}
 	} 			
	Quit $$$OK
}

ClassMethod GetScanNeedArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanNeedArrangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScanNeedArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanNeedArrangeExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	增加"病历导出"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddExportLog("99","2583","10","0","8|28","127.0.0.1")
ClassMethod AddExportLog(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, ADetailVersion As %String, AMRVerItemIDS As %String, AIP As %String) As %String
{
	s flag = "true"
	s AMRAction = "EXPORT"
	s ADetailType = "MRITEMID"

	s AActPrice=0
	s AActSchemeID=""
	s ARemark=""
	s APageRange=""
	TSTART
	s $zt = "OnAddExportLogAllErrHandler"
	s mrLogDetailID = ""
	for i=1:1:$l(AMRVerItemIDS,"^")
	{
		s AMRVerItemID = $p(AMRVerItemIDS,"^",i)
		
		if (AMRVerItemID = "")
		{
			s flag = "false"
			q	
		}
		
		s objMRVerItem=##class(DHCEPRFS.INST.MRVerItem).%OpenId(AMRVerItemID)
		s AMRItemID=objMRVerItem.MRItemID
		
		if (i = 1)
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, 
						ARemark, AMRAction, ADetailType, AMRItemID,"TRUE",mrLogDetailID,ADetailVersion,APageRange,"",AIP)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
		}
		else
		{
			s mrLogDetailID = ..AddLogDetailWOT(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, 
						ARemark, AMRAction, ADetailType, AMRItemID,"FALSE",mrLogDetailID,ADetailVersion,APageRange,"",AIP)
			if (mrLogDetailID = "")
			{
				s flag = "false"
				q	
			}
		}
	}

	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddExportLogAllErrHandler
	TROLLBACK
	q ""
}

/// Desc:	获取导出日志
/// Input：	AStartDate 	起始日期(Cache内部格式)
/// 		AEndDate 	结束日期(Cache内部格式)
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetExportLog","2017-01-01","2017-05-20","","500307")
Query GetExportLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordNO As %String) As %Query(ROWSPEC = "MRLogDetailID:%String,ActDate:%String,ActTime:%String,MRPatientID:%String,MREpisodeID:%String,EpisodeID:%String,MedRecordNo:%String,Name:%String,Sex:%String,AdmDate:%String,DisDate:%String,AdmLoc:%String,DisLoc:%String,ExportUserID:%String,ExportUserName:%String")
{
}

ClassMethod GetExportLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordNO As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagAction = " EXPORT"
 	//将日期格式转换为数字
	s AStartDate=$zdh(AStartDate,3)
	s AEndDate=$zdh(AEndDate,3)
	
	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordNO = $c(0)) AMedRecordNO = ""
	
	//操作员
	if (AUserName '= "")
	{
		s userID = ""
	 	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 	s sc = rset.Execute(AUserName)
	 	while (rset.Next())
	 	{
		 	s SSUserID = rset.Data("SSUserID")	
		 	s userID = ""
		 	if ((SSUserID = "") || (SSUserID = $c(0)))
		 	{
				s userID = "TEMP^"_rset.Data("UserID") 	
			}
			else
			{
				s userID = SSUserID	
			}
			for date = AStartDate:1:AEndDate
			{
				s time=""
				for
				{
					s time=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID",flagAction," "_userID,date,time))
					q:(time="")
					s mrLogID=""
					for
					{
						s mrLogID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID",flagAction," "_userID,date,time,mrLogID))
						q:(mrLogID="")
						s detailID=""
						for
						{
							s detailID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID",flagAction," "_userID,date,time,mrLogID,detailID))
							q:(detailID="")
							s objMRLogDetail=##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_detailID)
							do OutputExportLog(objMRLogDetail.%Id(),objMRLogDetail.MREpisodeID,objMRLogDetail.ActUserID,objMRLogDetail.ActDate,objMRLogDetail.ActTime)
						}
					}
				}
			}
	 	}
	}
	elseif (AMedRecordNO'= "")
	{
		s mrEpisodeID=""
		for
		{
			s mrEpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo", " "_AMedRecordNO,mrEpisodeID))
			q:(mrEpisodeID="")
			s mrLogID=""
			for
			{
				s mrLogID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_mrEpisodeID ,flagAction,mrLogID))
				q:(mrLogID="")
				s detailID=""
				for
				{
					s detailID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_mrEpisodeID,flagAction,mrLogID,detailID))
					q:(detailID="")
					s objMRLogDetail=##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_detailID)
					if ((objMRLogDetail.ActDate>=AStartDate)&&(objMRLogDetail.ActDate<=AEndDate))
					{
						do OutputExportLog(objMRLogDetail.%Id(),objMRLogDetail.MREpisodeID,objMRLogDetail.ActUserID,objMRLogDetail.ActDate,objMRLogDetail.ActTime)
					}
				}
			}
		}
	}
	else
	{
		for date = AStartDate:1:AEndDate
		{
			s time=""
			for
			{
				s time=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction",flagAction,date,time))
				q:(time="")
				s mrLogID=""
				for
				{
					s mrLogID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction",flagAction,date,time,mrLogID))
					q:(mrLogID="")
					s detailID=""
					for
					{
						s detailID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction",flagAction,date,time,mrLogID,detailID))
						q:(detailID="")
						s objMRLogDetail=##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_detailID)
						do OutputExportLog(objMRLogDetail.%Id(),objMRLogDetail.MREpisodeID,objMRLogDetail.ActUserID,objMRLogDetail.ActDate,objMRLogDetail.ActTime)
					}
				}
			}
		}
	}
 	q $$$OK
 	
 	
OutputExportLog(MRLogDetailID,MREpisodeID,ActUserID,ActDate,ActTime)  
	s objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
    q:(objEpisode = "")
    s MrPatientID = objEpisode.MRPatientID
	s MedRecordNo = objEpisode.MedRecordNo 
	s EpisodeID=objEpisode.EpisodeID
    s AdmDate = objEpisode.AdmDate
    if AdmDate '= "" s AdmDate = $zd(AdmDate,3)
	s DisDate = objEpisode.DisDate
	if DisDate '= "" s DisDate = $zd(DisDate,3)
	s AdmLoc = objEpisode.AdmLoc
    s DisLoc = objEpisode.DisLoc
    d objEpisode.%Close()
	
	s strActDate=$zd(ActDate,3)
	s strActTime=$zt(ActTime,1)
	if ($p(ActUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(ActUserID,"^",2))
		s ActUserName = objUser.UserName    
	}
	else
	{
    	s ActUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(ActUserID)
	}	
	
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objPatient.Name
    s Sex = objPatient.Gender
    d objPatient.%Close()
	
    s ^CacheTemp(repid,ind) = $lb(MRLogDetailID,strActDate,strActTime,MrPatientID,MREpisodeID,EpisodeID,MedRecordNo,Name,Sex,AdmDate,DisDate,AdmLoc,DisLoc,ActUserID,ActUserName)
	s ind = ind + 1
	
	quit
}

ClassMethod GetExportLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExportLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetExportLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExportLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	获取导出日志明细项目
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetExportLogDetail","")
Query GetExportLogDetail(AMRLogDetailID As %String) As %Query(ROWSPEC = "MRItemID:%String,MRItemName:%String")
{
}

ClassMethod GetExportLogDetailExecute(ByRef qHandle As %Binary, AMRLogDetailID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s flagAction = " EXPORT"
	
	s mrLogID = $p(AMRLogDetailID,"||",1)
 	s mrLogDetailID = $p(AMRLogDetailID,"||",2)
 	
 	s detailNum = ""
 	for 
 	{
		s detailNum = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum))
		q:(detailNum = "")
		s subID = ""
		s subID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,mrLogDetailID,detailNum,subID))
		q:(subID = "")
		s mrLogDetailSubID = AMRLogDetailID_"||"_subID
		s obj = ##class(DHCEPRFS.INST.MRLogDetailSub).%OpenId(mrLogDetailSubID)
		s mrItemID=obj.DetailID
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
		s mrItemName=objMRItem.Name
    	s ^CacheTemp(repid,ind) = $lb(mrItemID,mrItemName)
		s ind = ind + 1
 	}
 	q $$$OK
}

ClassMethod GetExportLogDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExportLogDetailExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetExportLogDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExportLogDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Test() As %String
{
	s count = 0
	s rowID = ""
 	for
 	{
	 	//b "s"
	 	s rowID = $o(^DHCEPRFS.INST.ScanArrangeD(rowID))
	 	q:(rowID="")
	 	
	 	s scanArrangeSub = ""
		s scanArrangeSub = $o(^DHCEPRFS.INST.ScanArrangeSubI("IdxMain",rowID,scanArrangeSub),-1)
		if (scanArrangeSub '= "")
		{
			s rowIDSub = rowID_"||"_scanArrangeSub
			s objSub = ##class(DHCEPRFS.INST.ScanNeedArrangeSub).%OpenId(rowIDSub)
			s MRLogDetail = objSub.MRLogDetail
			s objMRLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(MRLogDetail)
			s actDate = objMRLogDetail.ActDate
			s actTime = objMRLogDetail.ActTime
			
			s obj = ##class(DHCEPRFS.INST.ScanNeedArrangeLog).%OpenId(rowID)
			s obj.ActDate = actDate
			s obj.ActTime = actTime
			s sc = obj.%Save()
			if ($$$ISOK(sc))
			{
				s count = count+1
			}
		}
 	}
 	q count
}

/// Desc:取患者病历最新状态
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetLastStatus(21)
ClassMethod GetLastStatus(AMREpisodeID As %String) As %String
{
	s status = ""
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") status
	s rowID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_AMREpisodeID,""))
	q:(rowID = "") status
	s statusCode1=""
	s statusCode2=""
	s DetailNum=""
	s i=0
	for {
		s DetailNum=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",rowID,DetailNum),-1)
		q:(DetailNum="")
		s i=i+1
		s childSub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",rowID,DetailNum,""))
		s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(rowID_"||"_childSub)
		if (i=1)	//最新的一条
		{
			//如果不是扫描、分类、替换、编目
			if ((objMRLogDetail.MRAction="SCAN")||(objMRLogDetail.MRAction="ARRANGE")||(objMRLogDetail.MRAction="REPLACE")||(objMRLogDetail.MRAction="CATALOG")) 
			{}
			else
			{
				s statusCode1=objMRLogDetail.MRAction
				q
			}
		}
		//扫描\分类\替换
		if ((objMRLogDetail.MRAction="SCAN")||(objMRLogDetail.MRAction="ARRANGE")||(objMRLogDetail.MRAction="REPLACE"))
		{
			if (statusCode1="")
			{
				s statusCode1=objMRLogDetail.MRAction
			}
		}
		if (objMRLogDetail.MRAction="CATALOG")	//病案编目
		{
			if (statusCode2="")
			{
				s statusCode2=objMRLogDetail.MRAction
			}
		}
		
		//status1和status2都有值退出循环
		q:((statusCode1'="")&&(statusCode2'="")) 
	}
	s statusDesc1=..GetMRActionName(statusCode1)
	s statusDesc2=..GetMRActionName(statusCode2)
	if (statusDesc2="")
	{
		q statusDesc1
	}
	else
	{
		q statusDesc1_"|"_statusDesc2
	}
}

/// Desc:根据ActionCode取名称
/// Debug:w ##Class(DHCEPRFS.BL.BLMRLog).GetMRActionName("REVIEW")
ClassMethod GetMRActionName(AActionCode As %String) As %String
{
	q:(AActionCode="") ""
	s MRActionID = $o(^DHCEPRFS.META.MRActionI("IdxMain"," "_AActionCode,""))
	q:(MRActionID="") ""
	s objMRAction = ##Class(DHCEPRFS.META.MRAction).%OpenId(MRActionID)
	q objMRAction.ActionName
}

/// Desc:	通过日志汇总每个操作者的打印工作量
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetUserPrintTotalFromLog","2016-10-01","2016-12-20","")
Query GetUserPrintTotalFromLog(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String,PrintCount:%Integer,Proportion:%String")
{
}

ClassMethod GetUserPrintTotalFromLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	//将日期格式转换为数字
	s StartDate=$zdh(AStartDate,3)
	s EndDate=$zdh(AEndDate,3)
	
	s arrCount=##class(%ArrayOfDataTypes).%New()
	k ^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog")
	
	for date = StartDate:1:EndDate
 	{
		s time = ""
	 	for {
			s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time))
		 	q:(time="")
		 	
		 	s mrLogID = ""
		 	for {
				s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID))
			 	q:(mrLogID="")
			 	
			 	s subID = ""
				for {
					s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRAction"," PRINT",date,time,mrLogID,subID))
				 	q:(subID="") 
				 	
				 	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 	

				 	s actUserID = objMRLogDetail.ActUserID
				 	s mrEpisodeID = objMRLogDetail.MREpisodeID
				 	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				 	continue:(objMREpisode = "")
				 	s mrPatient = objMREpisode.MRPatientID
				 	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatient)
				 	continue:(objMRPatient = "")
				 	s regNo = objMRPatient.RegNo
				 	
				 	if ($d(^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID)))
				 	{
					 	if ('$d(^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID,regNo)))
					 	{
						 	s ^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID,regNo) = actUserID_"^"_date_"^"_regNo
					 	}
				 	}
				 	else
				 	{
					 	s ^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID,regNo) = actUserID_"^"_date_"^"_regNo
				 	}				 	
				}
		 	}
	 	}	
 	}

	s countAll = 0
 	s date = ""
 	for {
	 	s date = $o(^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date))
	 	q:(date = "")
	 	
	 	s actUserID = ""
	 	for {
		 	s actUserID = $o(^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID))
		 	q:(actUserID = "")
		 	
		 
		 	s regNo = ""
		 	for {
			 	s regNo = $o(^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog",date,actUserID,regNo))
			 	q:(regNo ="")
			 	
			 	s countAll = countAll+1
			 	if (arrCount.IsDefined(actUserID)="0")
				{
					d arrCount.SetAt(1,actUserID)
				}
				else
				{
					d arrCount.SetAt(arrCount.GetAt(actUserID)+1,actUserID)
				}
			 	
		 	}		 	
	 	}
 	}
 	
 	//循环结束
 	s strUserID=""
	for {
		s strUserID=arrCount.Next(strUserID)
	 	q:(strUserID = "")
	 	
	 	s ActUserName=""
		if ($p(strUserID ,"^",1) = "TEMP")
		{
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(strUserID,"^",2))
			s ActUserName = objUser.UserName    
		}
		else
		{
			s ActUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(strUserID)
		}
		s proportion = 0
		if (countAll =0)
		{
			
		}
		else
		{
			s proportion = arrCount.GetAt(strUserID)/countAll
			s proportion = $e(proportion,1,5)
		}
		s ^CacheTemp(repid,ind) = $lb(strUserID,ActUserName,arrCount.GetAt(strUserID),proportion*100_"%")
		s ind = ind + 1
	}
	
	k ^CacheTemp("DHCEPRFS-Output","BL","BLMRLog","GetUserPrintTotalFromLog")
	
	Quit $$$OK
}

ClassMethod GetUserPrintTotalFromLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserPrintTotalFromLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetUserPrintTotalFromLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserPrintTotalFromLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	通过日志汇总操作者的打印工作量（提供给病案工作量统计）
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserID 	用户ID
/// Debug：	w ##class(DHCEPRFS.BL.BLMRLog).GetPrintCountByUser("2020-01-01","2020-05-01","12109")
ClassMethod GetPrintCountByUser(AStartDate As %String, AEndDate As %String, AUserID As %String) As %String
{
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	&sql(select count(*) into :CountNum from DHCEPRFS_INST.MRLogDetail where MRAction = "PRINT"  AND ActDate >= :StartDate AND ActDate <= :EndDate AND ActUserID = :AUserID )
	q CountNum
}

/// 根据就诊获取所有扫描项，和页数
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetScanItemsByMREpisodeID","4675872")
Query GetScanItemsByMREpisodeID(AMREpisdoeID As %String) As %Query(ROWSPEC = "MRItemID:%String,ItemDesc:%String,Pages:%String")
{
}

ClassMethod GetScanItemsByMREpisodeIDExecute(ByRef qHandle As %Binary, AMREpisdoeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1	
 	
 	q:(AMREpisdoeID = "") $$$OK

	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisdoeID)
	s MRVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisdoeID,"0")
	//b ;
 	q:(MRVersionID = "") $$$OK

 	s MRItemID=""
	for{
	 	s MRItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID))
	 	//b ;MRItemID
	 	q:(MRItemID = "")
	 	s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId($tr(MRItemID," ",""))
	 	continue:($ZCVT(objMRItem.Type,"U")'= "PS")
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, MRItemID, ""))
		//b ;mrVerItemID
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		s mrItemID = $tr(MRItemID," ","")
		s mrItemName = objMRItem.Name
		s pages = objMRVerItem.TotCount

		
		s ^CacheTemp(repid,ind) = $lb(mrItemID,mrItemName,pages)
		s ind = ind + 1
		
 	}
 	
 	q $$$OK
}

ClassMethod GetScanItemsByMREpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserPrintTotalFromLogExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetScanItemsByMREpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserPrintTotalFromLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Create: 2021-12-30 yangshun 给定病案号与日期，查看扫描上传日志结果
/// Debug: w ##class(DHCEPRFS.BL.BLMRLog).GetScanLogByMedRecords("H5004877^Y^H1734875","2021-12-22")
ClassMethod GetScanLogByMedRecords(AMedRecords As %String, AActDate As %String = "") As %String
{
	q:(AMedRecords="") ""
	i (AActDate="")
	{
		s AActDate = $P($H,",",1)
	}
	else
	{
		s AActDate = $zdh(AActDate,3)
	}
	s res = ""
	s count = 0
	s i = 1
	f
	{
		s tmpMedRecordID = $P(AMedRecords,"^",i)
		q:(tmpMedRecordID="")
		s i = i+1
		&sql(SELECT COUNT(*) INTO :count FROM dhceprfs_inst.scanneedarrangelog WHERE MedRecordID=:tmpMedRecordID AND ActDate=:AActDate)
		i (count'=0)
		{
			s res = res_"1^"
		}
		else
		{
			s res = res_"0^"
		}
	}
	s res = $E(res,0,*-1)
	q res
}

}
