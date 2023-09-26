Class EMRservice.Ajax.eventData Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	s action = $Get(%request.Data("Action",1),"")
	if (action = "GetMessage")
	{
		d %session.Unlock(0)
	}
 	Q 1
}

ClassMethod OnPage() As %Status
{
	s result = ""
	s action = $Get(%request.Data("Action",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s eventType = $Get(%request.Data("EventType",1),"")
	if (action = "GetMessage")
	{
		s result = ..GetEventMessage(episodeId)
		w "["_result_"]"
	}
	elseif (action = "GetData")
	{
		s result = ..GetData(eventType,episodeId)
		w "["_result_"]" 
	}
	elseif (action = "GetConfig")
	{
		s result = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventConfig(episodeId,eventType)
		w result	
	}
	elseif(action = "doEvent")
	{
		s patientId = $Get(%request.Data("PatientID",1),"")		
		s selectIds = $Get(%request.Data("SelectIds",1),"")
		s instanceId = $Get(%request.Data("InstanceID",1),"")
		s result = ..DoEvent(eventType,patientId,episodeId,selectIds,instanceId)
		w result	
	}
	elseif(action = "setUnActive")
	{
		s selectIds = $Get(%request.Data("SelectIds",1),"")
		s result = ..SetUnActive(eventType,selectIds)
		w result
	}
	elseif(action = "GetEventCategory")
	{
		s result = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventCategory(episodeId,eventType)
		w result
	}
	
	Quit $$$OK
}

/// Desc:    事件提示信息
/// Creator: Candy
/// Input:   AEpisodeID 就诊号
/// Debug:   w ##Class(EMRservice.Ajax.eventData).GetEventMessage(76)
ClassMethod GetEventMessage(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	if ($d(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s criticalvalue = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("criticalvalue")
	    if (criticalvalue '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_criticalvalue
	    }
	}
	if ($d(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("BloodTransfusion")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	if ($d(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Rescue")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}	
	if ($d(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Operation")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	if ($d(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Manipulate")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	if ($d(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("ModDiagnosis")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
	if ($d(^DHCEMRI.Events.ConsultI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s consult = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("Consult")
	    if (consult '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_consult
	    }
	}
	if ($d(^DHCEMRI.Events.MDTI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s consult = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("MDTConsult")
	    if (consult '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_consult
	    }
	}
	if ($d(^DHCEMRI.Events.DischargeI("IdxEpisodeIsActive"," "_AEpisodeID," Y"))>0)
	{
		s blood = ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("DischargeRecord")
	    if (blood '= "") 
	    {
		    s:(result '= "") result = result_","
	   		s result = result_blood
	    }
	}
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
	s result = $zstrip(result,"*C")
	q result
}

/// Desc:       事件完成操作
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AEventType 事件类型
///            AEpisodeId 就诊ID
/// Output:     result
ClassMethod DoEvent(AEventType As %String, APatientId As %String, AEpisodeId As %String, ASelectIds As %String, AInstanceId As %String)
{
	s result = "0"
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMRservice.BL.Event.BLCriticalValue).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif (AEventType = "BloodTransfusion")
	{
		s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif (AEventType = "Rescue")
	{
		s result = ##Class(EMRservice.BL.Event.BLRescue).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif(AEventType = "Operation")
	{
		s result = ##class(EMRservice.BL.Event.BLOperation).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}	
	elseif(AEventType = "Manipulate")
	{
		s result = ##class(EMRservice.BL.Event.BLManipulate).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}	
	elseif(AEventType = "ModDiagnosis")
	{
		s result = ##class(EMRservice.BL.Event.BLModDiagnosis).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif(AEventType = "Consult")
	{
		s result = ##class(EMRservice.BL.Event.BLConsult).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif(AEventType = "MDTConsult")
	{
		s result = ##class(EMRservice.BL.Event.BLMDTConsult).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif(AEventType = "DischargeRecord")
	{
		s result = ##class(EMRservice.BL.Event.BLDischargeRecord).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
	}
	elseif(AEventType = "InformedConsent")
	{
		s result = ##class(EMRservice.BL.Event.BLInformedConsent).SetFinish(APatientId,AEpisodeId,ASelectIds,AInstanceId)
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
	s ^TempAID = AIDs
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

}
