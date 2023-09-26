/// Desc:       会诊事件逻辑类
/// Creator:    Donglulu
/// CreateDate: 2021-4-1
Class EMRservice.BL.Event.BLConsult Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       新增或修改会诊记录数据
/// Creator:    Donglulu
/// CreateDate: 2021-4-1
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AConsultID 会诊ID
///             AApplyDate (cache内部格式) 会诊申请日期
///             AApplyTime (cache内部格式) 会诊申请时间
///             AApplyDoctor 会诊申请医生名称
///             AFinishDate (cache内部格式) 会诊完成日期
///             AFinishTime (cache内部格式) 会诊完成时间
///             AConsultDoctor 会诊医生名称
///             AConsultType 会诊类型(单科/多科)
///             AConsultLoc 会诊科室描述
///             AApplyLoc 会诊申请科室描述
///             AConDestination 会诊目的
///             AAttitude 会诊意见
///             AConsultStatus 会诊状态(完成/取消完成)
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLConsult).SetData(48,76,"1||1","身体检查",63634,36676,"O","N","test","testDesc")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AConsultID As %String, AApplyDate As %String, AApplyTime As %String, AApplyDoctor As %String, AFinishDate As %String, AFinishTime As %String, AConsultDoctor As %String, AConsultType As %String, AConsultLoc As %String, AApplyLoc As %String, AConDestination As %String, AAttitude As %String, AConsultStatus As %String) As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||(AConsultID = "") result
		
		s eventID = ##Class(EMRservice.BL.Event.BLConsult).GetEventIDByFromCode(AConsultID)
		
		if (eventID = "")
		{
			s obj = ##Class(EMRinstance.Events.Consult).%New()
			s obj.PatientID = APatientID
			s obj.EpisodeID = AEpisodeID
			s obj.ConsultID = AConsultID
			s obj.CreateDate = $p($h,",",1)
			s obj.CreateTime = $p($h,",",2)
			s obj.IsActive = "Y"
		}
		else
		{
			s obj = ##Class(EMRinstance.Events.Consult).%OpenId(eventID)
			q:(obj = "") result
			if (AConsultStatus = "取消完成")
			{
				s obj.IsActive = "N"
			}
			else
			{
				s obj.IsActive = "Y"
			}
		}
		
		s obj.ApplyDate = AApplyDate
		s obj.ApplyTime = AApplyTime
		s obj.ApplyDoctor = AApplyDoctor
		s obj.FinishDate = AFinishDate
		s obj.FinishTime = AFinishTime
		s obj.ConsultDoctor = AConsultDoctor
		s obj.ConsultType = AConsultType
		s obj.ConsultLoc = AConsultLoc
		s obj.ApplyLoc = AApplyLoc
		s obj.ConDestination = AConDestination
		s obj.Attitude = AAttitude
		s obj.ConsultStatus = AConsultStatus
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取会诊记录
/// Creator:     Donglulu
/// CreateDate:  2021-4-8
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLConsult).GetData(4)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	s prompt = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","提示")
	s noprompt = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","不提示")
	s norelationDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","未关联")
	s relationDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","已关联")
	for
	{
		s flag = $o(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Consult).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s isLink = norelationDesc
			    	s linkInstanceID = ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkInstanceID(AEpisodeID,"Consult",rowId)
			    	s:(linkInstanceID '= "") isLink = relationDesc
			    	
			    	s applyDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.ApplyDate)_" "_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.ApplyTime)
			    	s finishDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.FinishDate)_" "_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.FinishTime)
			    	
			    	s textField = applyDateTime_"，"_obj.ConsultLoc_"，"_obj.ConsultDoctor
			    	
			    	s ConDestination = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.ConDestination)
			    	s Attitude = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Attitude)
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""ApplyDoctor"":"""_obj.ApplyDoctor_""""
			    	s result = result_",""ConsultID"":"""_obj.ConsultID_""""
			    	s result = result_",""ConsultDoctor"":"""_obj.ConsultDoctor_""""
			    	s result = result_",""ConsultType"":"""_obj.ConsultType_""""
			    	s result = result_",""ConsultLoc"":"""_obj.ConsultLoc_""""
			    	s result = result_",""ApplyLoc"":"""_obj.ApplyLoc_""""
			    	s result = result_",""ConDestination"":"""_ConDestination_""""
			    	s result = result_",""Attitude"":"""_Attitude_""""
			    	s result = result_",""ConsultStatus"":"""_obj.ConsultStatus_""""
			    	s result = result_",""ApplyDateTime"":"""_applyDateTime_""""
			    	s result = result_",""FinishDateTime"":"""_finishDateTime_""""
			    	s result = result_",""ApplyDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.ApplyDate)_""""
			    	s result = result_",""ApplyTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.ApplyTime)_""""
			    	s result = result_",""FinishDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.FinishDate)_""""
			    	s result = result_",""FinishTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.FinishTime)_""""
			    	s result = result_",""LinkInstanceID"":"""_linkInstanceID_""""
			    	s result = result_",""IsLink"":"""_isLink_""""
			    	s result = result_",""TextField"":"""_textField_""""
			    	s result = result_",""IsActive"":"""_$case(obj.IsActive,"Y":prompt,:noprompt)_""""
			    	s result = result_"}"
			    	s count = count + 1
				}
		    }
		}			
	}
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       更改已完成状态并关联病历
/// Creator:    yejian
/// CreateDate: 2018-8-29
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result
ClassMethod SetFinish(AIDs As %String, AInstanceID As %String, AUserID As %String = "") As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AIDs)
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		
		s obj = ##Class(EMRinstance.Events.Consult).%OpenId(rowId)
		continue:(obj = "")
		s fromCode = obj.ConsultID
		
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"Consult",rowId,fromCode,AUserID)
        q:(result = "0")
        
		d ##class(EMRservice.BL.Event.BLConsult).InvokInterface(fromCode,AInstanceID,AUserID)
	}
	q result
}

/// Desc:调用接口，将病历ID传回
/// Creator:Donglulu
/// CreateDate:2021-4-12
/// Input: AFromType 产品来源类型
///        AFromCode 关联产品ID
///        AInstanceID 关联病历ID
ClassMethod InvokInterface(AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	//会诊组接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCMDTInterface") = "1")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCMDTInterface||UpdMedHisInstanceId") = "1")
		{
			d ##class(web.DHCMDTInterface).UpdMedHisInstanceId(AFromCode,AInstanceID,AUserID)
		}
	}
	
	//新产品组接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCEMConsInterface") = "1")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCEMConsInterface||UpdMedHisInstanceId") = "1")
		{
			d ##class(web.DHCEMConsInterface).UpdMedHisInstanceId(AFromCode,AInstanceID)
		}
	}
}

/// Desc:       设置条目不再提示
/// Creator:    yejian
/// CreateDate: 2018-8-29
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLConsult).SetUnActive(1)
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Consult).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc:       根据FromCode获取eventID
/// Creator:    Donglulu
/// CreateDate: 2021-4-12
/// Input:      EMRinstance.Events.Consult表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLConsult).GetEventIDByFromCode(1)
ClassMethod GetEventIDByFromCode(AFromCode As %String) As %String
{
	s result = ""
	q:(AFromCode = "") result	
	s result = $o(^DHCEMRI.Events.ConsultI("IdxFromCode"," "_AFromCode,""))
	q result
}

/// Desc:       将会诊记录状态改为取消完成
/// Creator:    Donglulu
/// CreateDate: 2021-6-3
/// Input:      AConsultID 会诊ID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLConsult).CancelCompletion(48)
ClassMethod CancelCompletion(AConsultID As %String) As %String
{
		s result = "0"
		q:(AConsultID = "") result
		
		s eventID = ##Class(EMRservice.BL.Event.BLConsult).GetEventIDByFromCode(AConsultID)
		q:(eventID = "") result

		s obj = ##Class(EMRinstance.Events.Consult).%OpenId(eventID)
		q:(obj = "") result
		s obj.ConsultStatus = "取消完成"
		s obj.IsActive = "N"
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-11-22
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLConsult).SetUnActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Consult).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
