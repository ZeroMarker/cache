Class EMRservice.BL.BLAdmRecordStatus Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2019-04-18
///  Desc:       送病案室逻辑
///  Input:      AEpisodeID:就诊号
///  			 AUserID:提交用户userID
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).ConfirmRecordFinished("4","10209","","EMR","")
ClassMethod ConfirmRecordFinished(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "") As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s fsResult = "1"
	s fsFlag = ##Class(EMRservice.BL.EMRProduct).GetProductStatus("DHCEPRFS") 
	TStart
	if (fsFlag = "1")
	{
		s modifiedDocIDs = ##Class(EMRservice.BL.BLAdmRecordStatus).GetModifiedDocIDs(AEpisodeID)
		//改变医师提交状态
		s fsResult = ##Class(EMRservice.HISInterface.AdmRecordStatus).RegMRCompletionDHC(AEpisodeID,AUserID,modifiedDocIDs)
		if (fsResult'="1")
		{
			//归档系统
			//-1 生成或获取已创建 DHCEPRFS.INST.AdmMRStatus 对象失败
			//-2 更新 DHCEPRFS.INST.AdmMRStatus.FlagMRCompletion 标识失败
			//-3 保存操作记录失败
			//-4 更新复核状态失败
			s:(fsResult=-1) result="0^归档系统,生成或获取已创建归档对象失败，请联系工作人员处理"
			s:(fsResult=-2) result="0^归档系统,更新归档标识失败，请联系工作人员处理"
			s:(fsResult=-3) result="0^归档系统,保存操作记录失败，请联系工作人员处理"
			s:(fsResult=-4) result="0^归档系统,更新复核状态失败，请联系工作人员处理"
			s:(fsResult=-100) result="0^归档系统,代码异常请稍后，请联系工作人员处理"
		}
	}
	s emrFlag = ##Class(EMRservice.BL.BLAdmRecordStatus).AddAdmRecordStatusData(AEpisodeID,AUserID,AIPAddress,AProductSource,ARemark)
	if ((fsResult = "1")&&(emrFlag = "1"))
	{
		TCommit
		s result = "1"
		d ##Class(EMRservice.HISInterface.AdmRecordStatus).AfterConfirmAction(AEpisodeID,AUserID)
		
		if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		{
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s:(AUserID = "Auto") AUserID = "" 
				s userName = ""
				s:(AUserID '= "") userName = $p($g(^SSU("SSUSR",AUserID)),"^",2)
				
				s JsonString="[{""OEOrdItemID"":"""_AEpisodeID_""","
				s JsonString=JsonString_"""Status"":""MRSDOC"","
				s JsonString=JsonString_"""UserID"":"""_AUserID_""","
				s JsonString=JsonString_"""UserName"":"""_userName_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream = ##class(%GlobalCharacterStream).%New()
				d objStream.Write(JsonString)
				
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		}
		
	}
	else
	{
		TRollback
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2016-07-18
///  Desc:       添加病历全部完成信息表数据
///  Input:      AEpisodeID:就诊号
///  			 AUserID:提交用户userID
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).AddAdmRecordStatusData("4","10209","","EMR","")
ClassMethod AddAdmRecordStatusData(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "") As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    if (AdmRecordStatusID = "")
    {
	    //插入新数据
	    s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%New()
		s AdmRecordStatus.EpisodeID = AEpisodeID
    }
    else
    {
	    //修改全部完成时间
	    s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	    q:(AdmRecordStatus = "") result
    }
	s AdmRecordStatus.CompletedStatus = "1" 
    s AdmRecordStatus.FinishDate = $p($h,",",1)
    s AdmRecordStatus.FinishTime = $p($h,",",2)
    s AdmRecordStatus.UserID = AUserID
    s AdmRecordStatus.IPAddress = AIPAddress
    s AdmRecordStatus.ProductSource = AProductSource
    TStart
	s sc = AdmRecordStatus.%Save()
	s logResult = ##Class(EMRservice.BL.BLAdmRecordStatusLog).AddData(AUserID,"Confirm",AdmRecordStatus.%Id(),AIPAddress,AProductSource,ARemark,"1")
	d ##class(EMRservice.Ajax.auth.authorize).withdrawByAction(AEpisodeID,"","^save^delete^new^check^")
	if (($$$ISOK(sc))&&(logResult = "1"))
	{
		TCommit
		s result = "1"
		s deleteDisWaitSubmit = ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).DeleteData(AEpisodeID)
	}
	else
	{
		TRollback
	}
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	
	// 住院病历点击提交按钮后，调用科研病历组大数据待数据采集列表接口
	d ##class(EMRservice.HISInterface.CollectDataInterface).CollectDataByComplete(AEpisodeID)
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2019-04-18
///  Desc:       撤销送病案室逻辑
///  Input:      AEpisodeID:就诊号
///  			 AUserID:提交用户userID
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  			 AAction：动作（EMRmeta.ConfirmAction表的ActionCode字段 撤销："Revoke"，退回："WithDraw"）
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).RevokeConfirmRecord("230","6")
ClassMethod RevokeConfirmRecord(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "", AAction As %String = "") As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s fsResult = "1"
	s:(AAction = "") AAction = "WithDraw"
	s fsFlag = ##Class(EMRservice.BL.EMRProduct).GetProductStatus("DHCEPRFS") 
	s qualityFlag = ##Class(EMRservice.BL.EMRProduct).GetProductStatus("QualityDepartment") 
	if (AProductSource = "EMR")
	{
		if (qualityFlag = "1")
		{
			//上了科室质控
			s canRevokeMessage = ##Class(EMRservice.HISInterface.AdmRecordStatus).GetDepDisReciveState(AEpisodeID)
			q:(canRevokeMessage = "-1") "0^撤销提交病历失败，归档判断病历是否被科室质控员签收的接口未部署，请联系工作人员处理"
			q:(canRevokeMessage = "1") "0^撤销提交病历失败，该病历已被科室质控员签收，如需修改，请申请病历召回"
		}
		elseif (fsFlag = "1")
		{
			//上了归档系统
			//改变医师提交状态
			//s canRevokeMessage = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(AEpisodeID)
			//q:($p(canRevokeMessage, "^", 3) = "1") "0^撤销提交病历失败，该病人病历归档已经生成，无法撤销，请走申请授权流程"
			s canRevokeMessage = ##Class(EMRservice.HISInterface.AdmRecordStatus).IGetMrRetrieveStatus(AEpisodeID)
			q:(canRevokeMessage = "-1") "0^撤销提交病历失败，归档判断病历是否被病案室回收的接口未部署，请联系工作人员处理"
			q:(canRevokeMessage = "1") "0^撤销提交病历失败，该病历已被病案室回收，如需修改，请联系病案室人员退回"
			q:(+canRevokeMessage = "-999") "0^撤销提交病历失败，归档判断病历是否被病案室回收的接口异常，请联系工作人员处理"
			
		}
	}
	TStart
	if (fsFlag = "1")
	{
		//s fsResult = ##Class(DHCEPRFS.BI.BIToWMR).SetDoctorBack(AEpisodeID,AUserID)
		s fsResult = ##Class(EMRservice.HISInterface.AdmRecordStatus).SetCheckFailFlag(AEpisodeID,AUserID)
		s:(+fsResult = "-1") result="0^病案归档，接口未部署或指定就诊不存在，请联系工作人员处理"
		s:(+fsResult = "-2") result="0^病案归档，更新日志失败，请联系工作人员处理"
		s:(+fsResult = "-100") result="0^病案归档，代码出现异常，请联系工作人员处理"
	}
	s emrFlag = ##Class(EMRservice.BL.BLAdmRecordStatus).RevokeAdmRecordStatus(AEpisodeID,AUserID,AIPAddress,AProductSource,ARemark,AAction)
	if ((fsResult = "1")&&(emrFlag = "1"))
	{
		TCommit
		s result = "1"
		d ##Class(EMRservice.HISInterface.AdmRecordStatus).AfterRevokeAction(AEpisodeID,AUserID)
		
		
		if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		{
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s JsonString="[{""OEOrdItemID"":"""_AEpisodeID_""","
				s JsonString=JsonString_"""Status"":""WOS"","
				s JsonString=JsonString_"""UserID"":"""_AUserID_""","
				s JsonString=JsonString_"""UserName"":"""_$p($g(^SSU("SSUSR",AUserID)),"^",2)_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream = ##class(%GlobalCharacterStream).%New()
				d objStream.Write(JsonString)
				
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		}
	}
	else
	{
		TRollback
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2018-09-11
///  Desc:       撤销病历全部完成
///  Input:      AEpisodeID:就诊号
///  			 AUserID:提交用户userID
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  			 AAction：动作（EMRmeta.ConfirmAction表的ActionCode字段 撤销："Revoke"，退回："WithDraw"）
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).RevokeAdmRecordStatus("230","6")
ClassMethod RevokeAdmRecordStatus(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "", AAction As %String = "") As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	if (AAction = "Revoke")
	{
		s completedStatus = "0" 
	}
	elseif(AAction = "WithDraw")
	{
		s completedStatus = "-1" 
	}
	elseif(AAction = "Recall")
	{
		s completedStatus = "-2" 
	}
	s AdmRecordStatus.CompletedStatus = completedStatus 
	
    TStart
	s sc = AdmRecordStatus.%Save()
	s logResult = ##Class(EMRservice.BL.BLAdmRecordStatusLog).AddData(AUserID,AAction,AdmRecordStatus.%Id(),AIPAddress,AProductSource,ARemark,completedStatus)
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
///  CreateDate: 2016-07-18
///  Desc:       获取病历是否全部完成
///  Input:      AEpisodeID:就诊号
///  return:     result 1：提交，0：撤销 -1：退回 空：未提交  
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus("230")
ClassMethod GetAdmRecordStatus(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s result = AdmRecordStatus.CompletedStatus
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2018-05-16
///  Desc:       获取病历全部完成信息
///  Input:      AEpisodeID:就诊号
///  return:     result 提交人|提交日期 提交时间   
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatusMessage("230")
ClassMethod GetAdmRecordStatusMessage(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
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

///  Creator:    lifengbo
///  CreateDate: 2022-04-28
///  Desc:       获取就诊信息
///  Input:      起始截止时间，时间格式为2022-01-01
///  return:     result array 
///  Debug:      s stream = ##Class(EMRservice.BL.BLAdmRecordStatus).GetEpisodeIDByDateFromARStatus("2022-01-01","2022-04-28")
ClassMethod GetEpisodeIDByDateFromARStatus(AStartDate As %String, AEndDate As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New() 
					
	q:(AStartDate = "") result
	q:(AEndDate = "") result 
	
	s sysStartDate = $zdh(AStartDate,3)
	s sysEndDate = $zdh(AEndDate,3)
	
	q:(sysStartDate>sysEndDate) result 
	
	for tmpDate = sysStartDate:1:sysEndDate
	{
		s tmpTime=""
		for
		{
			s tmpTime=$o(^DHCEMRI.AdmRecordStatusI("IdxDateTimeEpisodeID",tmpDate,tmpTime))	
			q:(tmpTime="")
			s tmpEpisodeID=""
			for
			{
				s tmpEpisodeID=$o(^DHCEMRI.AdmRecordStatusI("IdxDateTimeEpisodeID",tmpDate,tmpTime,tmpEpisodeID))	
				q:(tmpEpisodeID="")
				
				s tmpid=""
				for
				{
					s tmpid=$o(^DHCEMRI.AdmRecordStatusI("IdxDateTimeEpisodeID",tmpDate,tmpTime,tmpEpisodeID,tmpid))	
					q:(tmpid="")
					s objAdmRecordStatus = ""
					s objAdmRecordStatus = ##class(EMRinstance.AdmRecordStatus).%OpenId(tmpid)
					continue:(objAdmRecordStatus ="")
					
					continue:(objAdmRecordStatus.CompletedStatus'=1)
					
					s seq = +$g(seq)+1
					
					d result.SetAt(objAdmRecordStatus.EpisodeID,seq)
				}
			}
		}
	
	}
	
	q result
}

///  Creator:    lifengbo
///  CreateDate: 2022-04-28
///  Desc:       获取病历是否全部完成,完成取额外信息
///  Input:      AEpisodeID:就诊号
///  return:     result 提交 1^date time,userid,ipaddr 
/// 						撤销 0^
/// 						退回 -1^
/// 						未提交	""   
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatusInfoByEpisodeID("230")
ClassMethod GetAdmRecordStatusInfoByEpisodeID(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	
	s status = AdmRecordStatus.CompletedStatus
	s info=""
	if (status=1)
	{
		s finDate = AdmRecordStatus.FinishDate
		s finTime = AdmRecordStatus.FinishTime
		s operUserId = AdmRecordStatus.UserID
		s operIP = AdmRecordStatus.IPAddress
		s info = $zdt(finDate_","_finTime,3,1)_","_operUserId_","_operIP
	}
	
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	s result = status_"^"_info
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2022-07-22
///  Desc:       获取上次提交病历后修改病历的docid，以^分隔
///  Input:      AEpisodeID:就诊号
///  return:     上次提交病历后修改病历的docid，以^分隔
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatus).GetModifiedDocIDs("4")
ClassMethod GetModifiedDocIDs(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s completeDate = AdmRecordStatus.FinishDate
	q:(completeDate = "") result
  	s completeTime = AdmRecordStatus.FinishTime
  	q:(completeTime = "") result
  	
  	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,parentId,subId))
					q:(subId = "")
					
					s rowId = parentId_"||"_subId
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
					q:(objInstance = "")
					s modifyDate = objInstance.ModifyDate
					s modifyTime = objInstance.ModifyTime
					continue:(modifyDate < completeDate)
					continue:((modifyDate = completeDate)&&(modifyTime<completeTime))
					
					s docId = objInstance.TheECRecord.RealChartItemID
					s tmpRe = "^"_result_"^"
					s tmpDoc = "^"_docId_"^"
					continue:(tmpRe [ tmpDoc)
					s:(result '= "") result = result_"^" 
					s result = result_docId
				}
			}
		}
	}

	q result
}

}
