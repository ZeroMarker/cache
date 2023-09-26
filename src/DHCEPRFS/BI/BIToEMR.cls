Class DHCEPRFS.BI.BIToEMR Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	申请授权
/// Input:	EpisodeID -就诊号; ApplyUserID 申请操作员编码 ;AuthorizeUserID 授权操作员编码,
/// 			StartDate 起始日期,StartTime 起始时间;EndDate 截止日期,EndTime 截止时间
/// Return：1 OK 0 ERROR
/// Debug:	w ##Class(DHCEPRFS.BI.BIToEMR).ApplyAuthorization("573","072","072",$zdh("2016-11-01",3),$zth("10:00:00"),$zdh("2016-11-13",3),$zth("10:00:00"))
ClassMethod ApplyAuthorization(EpisodeID As %String, ApplyUserID As %String, AuthorizeUserID As %String, StartDate As %Date, StartTime As %Time, EndDate As %Date, EndTime As %Time) As %String
{
	//取当前时间
	s nowDate = $p($h,",",1)
	s nowTime=$p($h,",",2)
	s objEMRAuthorization=##class(DHCEPRFS.INST.EMRAuthorization).%New()
	s objEMRAuthorization.EpisodeID=EpisodeID
	s objEMRAuthorization.ActDate=nowDate
	s objEMRAuthorization.ActTime=nowTime
	s objEMRAuthorization.ApplyUserID=ApplyUserID
	s objEMRAuthorization.AuthorizeUserID=AuthorizeUserID
	s objEMRAuthorization.StartDate=StartDate
	s objEMRAuthorization.StartTime=StartTime
	s objEMRAuthorization.EndDate=EndDate
	s objEMRAuthorization.EndTime=EndTime
	s objEMRAuthorization.AutoCommitFlag="0"
	s objEMRAuthorization.FinishFlag="0"
	
	s sc=objEMRAuthorization.%Save()
	
	if ($$$ISOK(sc))
	{	q "1"	}
	else
	{	q "0"	}
}

/// Desc:	自动处理未完成的授权
/// Input:	
/// Return：
/// Debug:	w ##Class(DHCEPRFS.BI.BIToEMR).AutoProcessAuthorization()
ClassMethod AutoProcessAuthorization() As %String
{
	//取当前时间
	s nowDate = $p($h,",",1)
	s nowTime=$p($h,",",2)
	
	s EMRAuthorizationID=""
	for
	{
		s EMRAuthorizationID=$o(^DHCEPRFS.INST.EMRAuthorI("IdxFinishFlag"," 0",EMRAuthorizationID))
		q:(EMRAuthorizationID="")
		
		s objEMRAuthorization=##class(DHCEPRFS.INST.EMRAuthorization).%OpenId(EMRAuthorizationID)
		continue:(objEMRAuthorization.EndDate > nowDate)	//结束日期>当前日期 
		continue:(objEMRAuthorization.EndDate = nowDate)&&(objEMRAuthorization.EndTime>nowTime) //结束日期=当前日期，结束时间>当前时间
		
		s AdmMRStatusID = $O(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_objEMRAuthorization.EpisodeID,""))
		continue:(AdmMRStatusID="")
		s objAdmMRStatus=##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(AdmMRStatusID)
		if (objAdmMRStatus.FlagMRCompletion="1") //如果医生已提交 
		{
			s objEMRAuthorization.FinishFlag="1"
			s objEMRAuthorization.ProcessDate=nowDate
			s objEMRAuthorization.ProcessTime=nowTime
			s sc=objEMRAuthorization.%Save()
		}
		else
		{
			//如果医生未提交
			//提交
			s ret=##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(objEMRAuthorization.EpisodeID,objEMRAuthorization.ApplyUserID,"")
			continue:(ret'="1")	//医生提交失败,忽略本条
			s objEMRAuthorization.AutoCommitFlag="1"
			s objEMRAuthorization.FinishFlag="1"
			s objEMRAuthorization.ProcessDate=nowDate
			s objEMRAuthorization.ProcessTime=nowTime
			s sc=objEMRAuthorization.%Save()
		}
	}
	
	q ""
}

/// Desc:   注册必要条件完成标识
/// Input:  EpisodeID - 就诊rowid, UserID - 用户ID
/// Return: return=1:成功, return<1:失败
/// Debug:  w ##Class(DHCEPRFS.BI.BIToEMR).RegNecessaryConditionDHC(AEpisodeID,AUserID)
ClassMethod RegNecessaryConditionDHC(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegNecessaryConditionDHC(AEpisodeID,AUserID)
	q ret
}

/// Desc:   获取就诊患者是否有扫描未分类的项目
/// Creator：     yangpeng
/// CreatDate：   2021-7-30
/// Input:  EpisodeID - 就诊rowid
/// Return: return=0:无, return=1:有
/// Debug:  w ##Class(DHCEPRFS.BI.BIToEMR).IsHaveScanTemp(AEpisodeID)
ClassMethod IsHaveScanTemp(AEpisodeID As %String) As %String
{
	s result = "0"
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s FileTemporaryID = ""
 	for { 
	 	s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_MREpisodeID,FileTemporaryID))
	 	q:(FileTemporaryID = "")
	 	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
	 	if ( objFileTemporary.Status = "0" )
	 	{
			s result = "1"
			q
		}
	}
	q result
}

/// Desc:  通过就诊号获取扫描病案的分类页数
/// Creator：     yangpeng
/// CreatDate：   2021-7-30
/// Input: AEpisodeID - 就诊rowid
/// Return: 总页数_"|"_TypeParam_"^"_MRItemName_"^"_页数_# 多行分隔符
/// Debug： w ##Class(DHCEPRFS.BI.BIToEMR).GetScanPageCount("1")
ClassMethod GetScanPageCount(AEpisodeID As %String) As %String
{
	s ret = ""
	s MREpisodeID=##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s MRVersionID=##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(MREpisodeID)
	
	s TotCount = 0
	s MRVerItemID = ""
	s MRItemID = ""
	for {
		s MRItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID))
		q:(MRItemID="")
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId($tr(MRItemID," ",""))
		continue:(objMRItem.Type'="PS")	//非扫描，忽略
		s MRVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID,""))
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(MRVerItemID)
		s TotCount = TotCount + objMRVerItem.TotCount
		s oneItemRet = objMRItem.TypeParams_"^"_objMRItem.Name_"^"_objMRVerItem.TotCount
		if (ret = "")
		{
			s ret=oneItemRet
		}
		else
		{
			s ret=ret_"#"_oneItemRet
		}
	}
	s ret = TotCount_"|"_ret
	q ret
}

/// Desc:  通过就诊号获取本次就诊病历是否已经封存
/// Creator：     yangpeng
/// CreatDate：   2021-8-10
/// Input: 		  AEpisodeID - 就诊rowid
/// Return: 封存标志(0或1)^封存日期(yyyy-mm-dd)^封存时间(hh24:mi:ss)
/// Debug： w ##Class(DHCEPRFS.BI.BIToEMR).GetSealUpStatus("1")
ClassMethod GetSealUpStatus(AEpisodeID As %String) As %String
{
	s ret ="0^"
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(MREpisodeID = "") ret
	s SealNo=""
	for {
		s SealNo=$o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo"," "_MREpisodeID,SealNo))
		q:(SealNo = "")
		s MRSealUpID=$o(^DHCEPRFS.INST.MRSealUpI("IdxOnSealNo"," "_MREpisodeID,SealNo,""))	//Unique
		s objMRSealUp=##class(DHCEPRFS.INST.MRSealUp).%OpenId(MRSealUpID)
		if (objMRSealUp.SealStatus = "SEALED")
		{
			s ret="1"_"^"_$zd(objMRSealUp.SealUpDate,3)_"^"_$zt(objMRSealUp.SealUpTime,1)
			q
		}
	}
	q ret
}

/// Desc:	科室质控回置医生/护士提交状态
/// Input:	EpisodeID : 就诊rowid
/// 			UserID : 用户ID
/// 		ACanelFinalAccount - 是否撤销护士提交(0 否,1 是)
/// 			ACanelMRCompletion - 是否撤销医生提交(0 否,1 是)
/// Return:	return=1:成功, return<1:失败
/// Debug:	w ##class(DHCEPRFS.BI.BIToEMR).SetDeptFailFlag(AEpisodeID,AUserID,"0","1")
ClassMethod SetDeptFailFlag(AEpisodeID As %String, AUserID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ACanelFinalAccount,ACanelMRCompletion,"",AUserID,"","2") 
	q ret
}

/// Desc: 无纸化率 参考GetScanPageCount YS 2021-10-28
ClassMethod GetNoPaperRatio(AEpisodeID As %String) As %String
{
	s ret = ""
	s MREpisodeID=##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s MRVersionID=##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(MREpisodeID)
	
	s TotCount = 0
	s ScanCount = 0
	s MRVerItemID = ""
	s MRItemID = ""	
	for {
		//w TotCount,!
		s MRItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID))
		q:(MRItemID="")
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId($tr(MRItemID," ",""))
		s MRVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID,""))
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(MRVerItemID)
		
		 i (objMRItem.Type="PS")
		 {
			s ScanCount = ScanCount + objMRVerItem.TotCount
		 }
		 else
		 {
			 s TotCount = TotCount + objMRVerItem.TotCount
		}
	}
	q:((TotCount+ScanCount) = 0) "0^0^0"
	q ScanCount_"^"_TotCount_"^"_$FN((TotCount/(TotCount+ScanCount))*100,"",2)
}

/// Desc: 获取患者的特殊病历标识记录
/// Return: 特殊病历类型代码^特殊病历类型名称^操作人^操作时间|特殊病历类型代码^特殊病历类型名称^操作人^操作时间
/// Creator: yangshun
/// Debug: w ##class(DHCEPRFS.BI.BIToEMR).GetAdvancedSecuritysByAdmNo("")
ClassMethod GetAdvancedSecuritysByAdmNo(ASysCode As %String, AEpisodeID As %String)
{
	s ret = ""
	s type = ""
	for
	{
		s type = $O(^DHCEPRRBAC.META.ASecurityI("IdxSealType"," "_ASysCode, " "_AEpisodeID,type))
		q:(type="")
		s id = $O(^DHCEPRRBAC.META.ASecurityI("IdxSealType"," "_ASysCode, " "_AEpisodeID,type,""))
		q:(id="")
		s advancedSecurityObj = ##class(DHCEPRRBAC.META.AdvancedSecurity).%OpenId(id)
		q:(advancedSecurityObj="")
		s typeCode = advancedSecurityObj.Type
		s typeID = $O(^DHCEPRFS.META.ASTypeI("IdxCode",type,""))
		continue:(typeID="")
		s typeObj = ##class(DHCEPRFS.META.ASType).%OpenId(typeID)
		s typeName = typeObj.Name
		s actUserID = advancedSecurityObj.UserID
		s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
		s actDateTime = $zd(advancedSecurityObj.ActionDate,3)_" "_$zt(advancedSecurityObj.ActionTime)
		if (ret="")
		{
			s ret = typeCode_"^"_typeName_"^"_actUserName_"^"_actDateTime
		}
		else
		{
			s ret = ret_"|"_typeCode_"^"_typeName_"^"_actUserName_"^"_actDateTime
		}
	}
	q ret
}

}
