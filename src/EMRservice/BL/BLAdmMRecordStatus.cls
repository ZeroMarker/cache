Class EMRservice.BL.BLAdmMRecordStatus Extends %RegisteredObject
{

///  Desc:       添加病历全部完成信息表数据
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).AddAdmRecordStatusData("156710741","24401")
ClassMethod AddAdmRecordStatusData(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmMRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    if (AdmRecordStatusID = "")
    {
	    //插入新数据
	    s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%New()
		s AdmRecordStatus.EpisodeID = AEpisodeID
    }
    else
    {
	    //修改全部完成时间
	    s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%OpenId(AdmRecordStatusID)
	    q:(AdmRecordStatus = "") result
    }
	s AdmRecordStatus.CompletedStatus = "1" 
    s AdmRecordStatus.FinishDate = $p($h,",",1)
    s AdmRecordStatus.FinishTime = $p($h,",",2)
    s AdmRecordStatus.UserID = AUserID
    TStart
	s sc = AdmRecordStatus.%Save()
	s logResult = ##Class(EMRservice.BL.BLAdmMRecordStatusLog).AddData(AUserID,"Confirm",AdmRecordStatus.%Id())
	d ##Class(EMRservice.BL.BLApplyEdit).WithdrawAllApplyEdit(AEpisodeID)
	if (($$$ISOK(sc))&&(logResult = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	
	//推送第三方首页数据，用以编目
	//d ##Class(EMRservice.HISInterface.Ens.FPInfo).SendAdmFirstPage("")
	//调用病案接口
	s input = ##Class(%GlobalCharacterStream).%New()
	s obj = ##class(%Library.DynamicObject).%New()
	d obj.%Set("AdmID",AEpisodeID)
	d obj.%Set("OperDate",$zd($p($h,",",1),3))
	d obj.%Set("OperTime",$zt($p($h,",",2)))
	d obj.%Set("OperUser",AUserID)
	d obj.%Set("OperFlg",1)
	d input.Write(obj.%ToJSON())
	B ;input
	s aa= ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000134",input)
	//s ^gzy("aa")=aa
	b ;xxe
	q result
}

/// 传病案首页预提交记录给病案
/// w ##class(EMRservice.BL.BLAdmMRecordStatus).SendAdmFirstData(Input)
ClassMethod SendAdmFirstData(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set soap=##class(web.DHCENS.BLL.DHIIP.Soap.PUB0018Soap).%New()
	set soap.Timeout=2
	;set OutputStream=##class(%GlobalCharacterStream).%New()
	set return=soap.HIPMessageServer("MES0271",Input)
	Quit return
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^程序异常:"_$ze)
	Quit stream
}

///  Desc:       获取病历是否全部完成
///  Input:      AEpisodeID:就诊号
///  return:     result 1：全部完成   
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).GetAdmRecordStatus("20789754")
ClassMethod GetAdmRecordStatus(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmMRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s result = AdmRecordStatus.CompletedStatus
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	q result
}

///  Desc:       获取病历全部完成信息
///  Input:      AEpisodeID:就诊号
///  return:     result 提交人|提交日期 提交时间   
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).GetAdmRecordStatusMessage("230")
ClassMethod GetAdmRecordStatusMessage(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmMRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s status = AdmRecordStatus.CompletedStatus
	q:(status '= "1") result
	s username = ""
	s:(AdmRecordStatus.UserID '= "") username = ##class(EMRservice.BL.BLPowerUser).GetUserName(AdmRecordStatus.UserID)
	s completeDate = $zd(AdmRecordStatus.FinishDate,3)
  	s completeTime = $zt(AdmRecordStatus.FinishTime,1)
	s result = username_"|"_completeDate_" "_completeTime
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	q result
}

/// 更新病案质控状态
ClassMethod UpdateMCompletedStatus(AEpisodeID As %String, AUserID As %String, MCompletedStatus As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmMRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    if (AdmRecordStatusID = "")
    {
	    q result
    }
    else
    {
	    //修改全部完成时间
	    s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%OpenId(AdmRecordStatusID)
	    q:(AdmRecordStatus = "") result
    }
	s AdmRecordStatus.MCompletedStatus = MCompletedStatus 
    s AdmRecordStatus.MFinishDate = $p($h,",",1)
    s AdmRecordStatus.MFinishTime = $p($h,",",2)
    s AdmRecordStatus.MUserID = AUserID
    TStart
	s sc = AdmRecordStatus.%Save()
	s action="MConfirm"
	s:(MCompletedStatus=0) action="MRevoke"
	s logResult = ##Class(EMRservice.BL.BLAdmMRecordStatusLog).AddData(AUserID,action,AdmRecordStatus.%Id())
	if (($$$ISOK(sc))&&(logResult = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2018-09-11
///  Desc:       撤销病历全部完成
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).RevokeAdmRecordStatus("230","6")
ClassMethod RevokeAdmRecordStatus(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmMRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmMRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s AdmRecordStatus.CompletedStatus = "0" 
	
    TStart
	s sc = AdmRecordStatus.%Save()
	s logResult = ##Class(EMRservice.BL.BLAdmMRecordStatusLog).AddData(AUserID,"Revoke",AdmRecordStatus.%Id())
	if (($$$ISOK(sc))&&(logResult = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
    
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	//推送第三方首页数据，用以编目
	//d ##Class(EMRservice.HISInterface.Ens.FPInfo).SendAdmFirstPage("")
	//调用病案接口
	s input = ##Class(%GlobalCharacterStream).%New()
	s obj = ##class(%Library.DynamicObject).%New()
	d obj.%Set("AdmID",AEpisodeID)
	d obj.%Set("OperDate",$zd($p($h,",",1),3))
	d obj.%Set("OperTime",$zt($p($h,",",2)))
	d obj.%Set("OperUser",AUserID)
	d obj.%Set("OperFlg",0)
	d input.Write(obj.%ToJSON())
	B ;input
	s aa= ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000134",input)
	q result
}

///  Desc:       送病案室逻辑
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).ConfirmRecordFinished("230","33")
ClassMethod ConfirmRecordFinished(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s fsResult = "1"
	s fsFlag = ##Class(EMRservice.BL.EMRProduct).GetProductStatus("DHCEPRFS") 
	if (fsFlag = "1")
	{
		q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BL.BLAdmMRStatus") = "0") result
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BL.BLAdmMRStatus||RegMRCompletionDHC") = "0") result
	}
	TStart
	if (fsFlag = "1")
	{
		//改变医师提交状态
		s fsResult = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,"Y","Y","")
	}
	s emrFlag = ##Class(EMRservice.BL.BLAdmMRecordStatus).AddAdmRecordStatusData(AEpisodeID,AUserID)
	if ((fsResult = "1")&&(emrFlag = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
	q result
}

///  Desc:       撤销送病案室逻辑
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).RevokeConfirmRecord("230","6")
ClassMethod RevokeConfirmRecord(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	
	//已编目的不能撤销提交
	//s IsMRecordCatalogue = ##Class(EMRservice.BOPrivAssist).IsMRecordCatalogue(AEpisodeID)
	//q:(IsMRecordCatalogue = "1") "0^病案首页已编目，不能撤销提交，请申请操作权限"
	
	//出院时间大于24小时的，不能撤销提交
	//s DisTimeGap = ##Class(EMRservice.BOPrivAssist).GetDisTimeGapTest(AEpisodeID)
	//q:(DisTimeGap >= 24) "0^患者出院时间大于24小时，不能撤销提交，请申请操作权限"
	
	s fsResult = "1"
	s fsFlag = ##Class(EMRservice.BL.EMRProduct).GetProductStatus("DHCEPRFS") 
	if (fsFlag = "1")
	{
		//改变医师提交状态
		q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BI.BIToWMR") = "0") result
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BI.BIToWMR||GetMedRecordStatus") = "0") result
		s canRevokeMessage = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(AEpisodeID)
		q:($p(canRevokeMessage, "^", 3) = "1") "0^撤销送病案室失败，该病人病历归档已经生成，无法撤销，请走申请授权流程"
		q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BI.BIToWMR") = "0") result
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BI.BIToWMR||SetCheckFailFlag") = "0") result
	}
	TStart
	if (fsFlag = "1")
	{
		//s fsResult = ##Class(DHCEPRFS.BI.BIToWMR).SetDoctorBack(AEpisodeID,AUserID)
		s fsResult = ##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag(AEpisodeID, "0", "1", "",AUserID)
	}
	s emrFlag = ##Class(EMRservice.BL.BLAdmMRecordStatus).RevokeAdmRecordStatus(AEpisodeID,AUserID)
	if ((fsResult = "1")&&(emrFlag = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
	q result
}

/// Desc:  		点击“送病案室”按钮之后，判断该科室是否有关联门诊功能，是true，反之是false。
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.BL.BLAdmMRecordStatus).CheckOutCorrelation("")
ClassMethod CheckOutCorrelation(AUserLocID As %String) As %String
{
	s result = "false"
	q:(AUserLocID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BL.BLDeptList") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BL.BLDeptList||CheckOutCorrelation") = "0") result
	s canRevokeMessage = ##Class(DHCEPRFS.BL.BLDeptList).CheckOutCorrelation(AUserLocID)
	q result
}

/// 病案系统 - 更改his首页质控状态
/// w ##class(EMRservice.BL.BLAdmMRecordStatus).UpdateMCompletedStatusStream(15)
ClassMethod UpdateMCompletedStatusStream(input As %GlobalCharacterStream) As %GlobalCharacterStream
{
   s $zt="UpdateMCompletedStatusStream"
   
   s rtn="<Respones><ResultCode>0</ResultCode><ResultContent>失败</ResultContent></Response>"
   s saop=##class(%GlobalCharacterStream).%New()   
   d saop.Write(rtn)   
   
   s objInput=##class(%DynamicObject).%FromJSON(input)     
   q:'$IsObject(objInput) saop
   s EpisodeID=objInput.EpisodeID
   s UserID=objInput.UserID
   s MCompletedStatus=objInput.MCompletedStatus
   s ret=..UpdateMCompletedStatus(EpisodeID , UserID , MCompletedStatus)   
   
   s:ret=1 rtn="<Respones><ResultCode>1</ResultCode><ResultContent>成功</ResultContent></Response>"
   s saop=##class(%GlobalCharacterStream).%New()   
   d saop.Write(rtn)   
   q saop   

UpdateMCompletedStatusStream
    s err=##class(%GlobalCharacterStream).%New()
    s errstr="<Respones><ResultCode>0</ResultCode><ResultContent>程序错误："_$ze_"</ResultContent></Response>"
    d err.Write(errstr)
	q err
}

}
