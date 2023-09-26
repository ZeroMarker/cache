Class DHCEPRFS.BI.BIToHIS Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	获取PDF路径
/// Input: AEpisodeID - 就诊rowid, AMRItemIDS - 归档项目ID的串
/// Return:	PDF路径
/// Debug：	w ##Class(DHCEPRFS.BI.BIToHIS).GetPDFPathByItemID("330","2")
ClassMethod GetPDFPathByItemID(AEpisodeID As %String, AMRItemIDS As %String) As %String
{
	s ftpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("FTPConfig")
	s ret = ""
	
	for index=1:1:$l(AMRItemIDS,"^")
	{
		s oneMRItemID = $p(AMRItemIDS,"^",index)
		s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,oneMRItemID)	
		continue:(mrVerItemID="")
		s detailNum = ""
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
		continue:(detailNum="")
		s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, ""))	
		continue:(subID="")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		if (ret = "")
		{
			s ret = "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_FileLocPath	
		}
		else
		{
			s ret = ret_"^"_"ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_FileLocPath	
		}
	}
	
	q ret
}

/// Desc:	PDF病历是否已经离线成功
/// Input: AEpisodeID - 就诊rowid
/// Return:	0 未生成
/// 		1  注册最终结算完成标识成功
/// Debug：	w ##Class(DHCEPRFS.BI.BIToHIS).IsRecordCreated(AEpisodeID)
ClassMethod IsRecordCreated(AEpisodeID As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLMRLog).IsRecordCreated(AEpisodeID)
	
	if (ret = "1")
	{
		s retPIS = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPathologyInfo(AEpisodeID)
		q:(retPIS = "0") "1"
		q "0"
	}
	q ret
}

/// Desc:	PDF病历是否打印
/// Input: AEpisodeID - 就诊rowid
/// Return:	0 未打印
/// 		1 已打印
/// Debug：	w ##Class(DHCEPRFS.BI.BIToHIS).IsRecordCreated(AEpisodeID)
ClassMethod IsRecordPrinted(AEpisodeID As %String) As %String
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID="") "0"
	
	s ret = ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(mrEpisodeID)
	
	q ret
}

/// Desc:	注册医生提交完成标识
/// Input:	EpisodeID - 就诊rowid, UserID - 提交用户ID, Confirm - Y 确认完成 N 未完成
/// Return:	return=1:成功, return<1:失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToHIS).RegMRCompletionDHC(11141404,111,"Y")
ClassMethod RegMRCompletionDHC(AEpisodeID As %String, AUserID As %String = "", AConfirm As %String = "N") As %String
{
	s ACheck = AConfirm
	s message = ""
	s retPIS = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPathologyInfo(AEpisodeID)
	if (retPIS = "1")
	{
		//有病理不生成
		s message = "HasPIS"
		s ACheck = "N"
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	//检查是否有 出院记录，死亡记录，产科出院记录，24小时入出院记录，24小时入死亡记录
	//若都没有则不生成
	//有出院记录
	s check = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,"88")
	if (check = "1")
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	//有死亡记录
	s check = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,"90")
	if (check = "1")
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	//产科出院记录
	s check = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,"165")
	if (check = "1")
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	//24小时入出院记录
	s check = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,"97")
	if (check = "1")
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	//24小时入死亡记录
	s check = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,"98")
	if (check = "1")
	{
		s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
		q ret
	}
	
	s message = "NoOutOrDeadRecord"
	s ACheck = "N"
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,AConfirm,ACheck,message)
	q ret
}

/// Desc:	注册护士提交完成标识
/// Input:	EpisodeID - 就诊rowid, UserID - 提交用户ID
/// Return:	return=1:成功, return<1:失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToHIS).RegFinalAccountDHC(AEpisodeID,AUserID)
ClassMethod RegFinalAccountDHC(AEpisodeID As %String, AUserID As %String = "") As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(AEpisodeID,AUserID)
	q ret
}

}
