Class EMRservice.BL.Event.BLEvents Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:    事件提示信息
/// Creator: Candy
/// Input:   AEpisodeID 就诊号
/// Debug:   w ##Class(EMRservice.BL.Event.BLEvents).GetEventMessage(76)
ClassMethod GetEventMessage(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	//危急值
	if ($d(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s criticalvalue = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("criticalvalue")
	    if (criticalvalue '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_criticalvalue
	    }
	}
	//输血
	if ($d(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("BloodTransfusion")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//抢救
	if ($d(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Rescue")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}	
	//手术
	if ($d(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Operation")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//操作
	if ($d(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Manipulate")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//诊断
	if ($d(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("ModDiagnosis")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//会诊
	if ($d(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Consult")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//MDT会诊
	if ($d(^DHCEMRI.Events.MDTI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("MDTConsult")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//出院记录
	if ($d(^DHCEMRI.Events.DischargeI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("DischargeRecord")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	//特殊治疗知情同意书
	if ($d(^DHCEMRI.Events.InformedConI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("InformedConsent")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
    q result
}

/// Desc:       取事件数据
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AEventType 事件类型
///            AEpisodeId 就诊ID
/// Output:     result
/// Debug:   w ##Class(EMRservice.BL.Event.BLEvents).GetData("Consult",4)
ClassMethod GetData(AEventType As %String, AEpisodeId As %String) As %String
{
	s result = ""
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMRservice.BL.Event.BLCriticalValue).GetData(AEpisodeId)
	}
	elseif (AEventType = "BloodTransfusion")
	{
		s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).GetData(AEpisodeId)
	}
	elseif (AEventType = "Rescue")
	{
		s result = ##Class(EMRservice.BL.Event.BLRescue).GetData(AEpisodeId)
	}
	elseif(AEventType = "Operation")
	{
		s result = ##class(EMRservice.BL.Event.BLOperation).GetData(AEpisodeId)
	}
	elseif(AEventType = "Manipulate")
	{
		s result = ##class(EMRservice.BL.Event.BLManipulate).GetData(AEpisodeId)
	}
	elseif(AEventType = "ModDiagnosis")
	{
		s result = ##class(EMRservice.BL.Event.BLModDiagnosis).GetData(AEpisodeId)
	}
	elseif(AEventType = "Consult")
	{
		s result = ##class(EMRservice.BL.Event.BLConsult).GetData(AEpisodeId)
	}
	elseif(AEventType = "MDTConsult")
	{
		s result = ##class(EMRservice.BL.Event.BLMDTConsult).GetData(AEpisodeId)
	}
	elseif(AEventType = "DischargeRecord")
	{
		s result = ##class(EMRservice.BL.Event.BLDischargeRecord).GetData(AEpisodeId)
	}
	elseif(AEventType = "InformedConsent")
	{
		s result = ##class(EMRservice.BL.Event.BLInformedConsent).GetData(AEpisodeId)
	}

	q result
}

/// Desc:       事件完成操作
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AEventType 事件类型
///            AEpisodeId 就诊ID
/// Output:     result
/// Debug:     w ##Class(EMRservice.Ajax.eventData).DoEvent("Operation",1,"1||20")
ClassMethod DoEvent(AEventType As %String, ASelectIds As %String, AInstanceId As %String, AUserID As %String = "")
{
	s result = "0"
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMRservice.BL.Event.BLCriticalValue).SetFinish(ASelectIds,AInstanceId,AUserID)
	}
	elseif (AEventType = "BloodTransfusion")
	{
		s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetFinish(ASelectIds,AInstanceId)
	}
	elseif (AEventType = "Rescue")
	{
		s result = ##Class(EMRservice.BL.Event.BLRescue).SetFinish(ASelectIds,AInstanceId)
	}
	elseif(AEventType = "Operation")
	{
		s result = ##class(EMRservice.BL.Event.BLOperation).SetFinish(ASelectIds,AInstanceId)
	}	
	elseif(AEventType = "Manipulate")
	{
		s result = ##class(EMRservice.BL.Event.BLManipulate).SetFinish(ASelectIds,AInstanceId)
	}
	elseif(AEventType = "ModDiagnosis")
	{
		s result = ##class(EMRservice.BL.Event.BLModDiagnosis).SetFinish(ASelectIds,AInstanceId)
	}
	elseif(AEventType = "Consult")
	{
		s result = ##class(EMRservice.BL.Event.BLConsult).SetFinish(ASelectIds,AInstanceId,AUserID)
	}
	elseif(AEventType = "MDTConsult")
	{
		s result = ##class(EMRservice.BL.Event.BLMDTConsult).SetFinish(ASelectIds,AInstanceId,AUserID)
	}
	elseif(AEventType = "DischargeRecord")
	{
		s result = ##class(EMRservice.BL.Event.BLDischargeRecord).SetFinish(ASelectIds,AInstanceId,AUserID)
	}
	elseif(AEventType = "InformedConsent")
	{
		s result = ##class(EMRservice.BL.Event.BLInformedConsent).SetFinish(ASelectIds,AInstanceId,AUserID)
	}
	q result
}

/// Desc:       事件完成操作
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AID  rowID
/// Output:     result
ClassMethod SetUnActive(AEventType As %String, AIDs As %String) As %String
{
	s result = "0"
	q:(AEventType = "")||(AIDs = "") result
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMRservice.BL.Event.BLCriticalValue).SetUnActive(AIDs)
	}
	elseif (AEventType = "BloodTransfusion")
	{
		s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetUnActive(AIDs)
	}
	elseif (AEventType = "Rescue")
	{
		s result = ##Class(EMRservice.BL.Event.BLRescue).SetUnActive(AIDs)
	}
	elseif(AEventType = "Operation")
	{
		s result = ##Class(EMRservice.BL.Event.BLOperation).SetUnActive(AIDs)
	}
	elseif(AEventType = "Manipulate")
	{
		s result = ##Class(EMRservice.BL.Event.BLManipulate).SetUnActive(AIDs)
	}
	elseif(AEventType = "ModDiagnosis")
	{
		s result = ##Class(EMRservice.BL.Event.BLModDiagnosis).SetUnActive(AIDs)
	}
	elseif(AEventType = "Consult")
	{
		s result = ##Class(EMRservice.BL.Event.BLConsult).SetUnActive(AIDs)
	}
	elseif(AEventType = "MDTConsult")
	{
		s result = ##Class(EMRservice.BL.Event.BLMDTConsult).SetUnActive(AIDs)
	}
	elseif(AEventType = "DischargeRecord")
	{
		s result = ##Class(EMRservice.BL.Event.BLDischargeRecord).SetUnActive(AIDs)
	}
	elseif(AEventType = "InformedConsent")
	{
		s result = ##Class(EMRservice.BL.Event.BLInformedConsent).SetUnActive(AIDs)
	}
	q result
}

/// Desc:从其它产品组创建病历，存储关联关系
/// Creator:Donglulu
/// CreateDate:2021-4-12
ClassMethod SetData(AFromType As %String, AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AFromType = "")||(AFromCode = "")||(AInstanceID = "") result
	
	s eventID = ""
	if (AFromType = "CRITICAL")
	{
		s AFromType = "CriticalValue"
		s eventID = ##Class(EMRservice.BL.Event.BLCriticalValue).GetEventIDByFromCode(AFromCode)
	}
	elseif(AFromType = "CONSULTATION")
	{
		s AFromType = "Consult"
		s eventID = ##Class(EMRservice.BL.Event.BLConsult).GetEventIDByFromCode(AFromCode)
	}
	elseif(AFromType = "MDTConsult")
	{
		s eventID = ##Class(EMRservice.BL.Event.BLMDTConsult).GetEventIDByFromCode(AFromCode)
	}
	q:(eventID = "") result
	s result = ##Class(EMRservice.BL.Event.BLEvents).DoEvent(AFromType,eventID,AInstanceID,AUserID)
	q result
}

/// Desc:根据产品来源和fromCode取eventID
/// Creator:Donglulu
/// CreateDate:2021-4-12
/// Debug:   w ##Class(EMRservice.BL.Event.BLEvents).GetEventIDByFromInfo("CONSULTATION",3)
ClassMethod GetEventIDByFromInfo(AFromType As %String, AFromCode As %String) As %String
{
	s result = ""
	q:(AFromType = "")||(AFromCode = "") result
	
	s eventID = ""
	if (AFromType = "CRITICAL")
	{
		s AFromType = "CriticalValue"
		s eventID = ##Class(EMRservice.BL.Event.BLCriticalValue).GetEventIDByFromCode(AFromCode)
	}
	elseif(AFromType = "CONSULTATION")
	{
		s AFromType = "Consult"
		s eventID = ##Class(EMRservice.BL.Event.BLConsult).GetEventIDByFromCode(AFromCode)
	}
	elseif(AFromType = "MDTConsult")
	{
		s eventID = ##Class(EMRservice.BL.Event.BLMDTConsult).GetEventIDByFromCode(AFromCode)
	}
	s result = AFromType_"^"_eventID
	q result
}

}
