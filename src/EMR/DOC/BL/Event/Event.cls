Class EMR.DOC.BL.Event.Event Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:    事件提示信息
/// Creator: lifengbo
/// CreateDate: 2023-05-06
/// Input:   AEpisodeID 就诊号
/// Debug:   w ##Class(EMR.DOC.BL.Event.Event).GetEventMessage(76)
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
    q result
}

/// Desc:       取事件数据
/// Creator:    lifengbo
/// CreateDate: 2023-05-06
/// Input:      AEventType 事件类型
///            AEpisodeId 就诊ID
/// Output:     result
/// Debug:   w ##Class(EMR.DOC.BL.Event.Event).GetData("Consult",4)
ClassMethod GetData(AEventType As %String, AEpisodeId As %String) As %String
{
	s result = ""
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMR.DOC.BL.Event.CriticalValue).GetData(AEpisodeId)
	}

	q result
}

/// Desc:       事件完成操作
/// Creator:    lifengbo
/// CreateDate: 2023-05-06
/// Input:      AEventType 事件类型
///            AEpisodeId 就诊ID
/// Output:     result
/// Debug:     w ##Class(EMRservice.Ajax.eventData).DoEvent("Operation",1,"1||20")
ClassMethod DoEvent(AEpisodeID As %String, AEventType As %String, ASelectIds As %String, AInstanceId As %String, AUserID As %String = "")
{
	s result = "0"
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMR.DOC.BL.Event.CriticalValue).SetFinish(AEpisodeID, ASelectIds,AInstanceId,AUserID)
	}
	
	q result
}

/// Desc:       事件完成操作
/// Creator:    lifengbo
/// CreateDate: 2023-05-06
/// Input:      AID  rowID
/// Output:     result
ClassMethod SetUnActive(AEventType As %String, AIDs As %String) As %String
{
	s result = "0"
	q:(AEventType = "")||(AIDs = "") result
	if (AEventType = "CriticalValue")
	{
		s result = ##Class(EMR.DOC.BL.Event.CriticalValue).SetUnActive(AIDs)
	}
	q result
}

/// Desc:从其它产品组创建病历，存储关联关系
/// Creator:    lifengbo
/// CreateDate: 2023-05-06
ClassMethod SetData(AFromType As %String, AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AFromType = "")||(AFromCode = "")||(AInstanceID = "") result
	
	s eventID = ""
	if (AFromType = "CRITICAL")
	{
		s AFromType = "CriticalValue"
		s eventID = ##Class(EMR.DOC.BL.Event.CriticalValue).GetEventIDByFromCode(AFromCode)
	}
	q:(eventID = "") result
	s result = ##Class(EMR.DOC.BL.Event.Event).DoEvent(AFromType,eventID,AInstanceID,AUserID)
	q result
}

/// Desc:根据产品来源和fromCode取eventID
/// Creator:    lifengbo
/// CreateDate: 2023-05-06
/// Debug:   w ##Class(EMR.DOC.BL.Event.Event).GetEventIDByFromInfo("CONSULTATION",3)
ClassMethod GetEventIDByFromInfo(AFromType As %String, AFromCode As %String) As %String
{
	s result = ""
	q:(AFromType = "")||(AFromCode = "") result
	
	s eventID = ""
	if (AFromType = "CRITICAL")
	{
		s AFromType = "CriticalValue"
		s eventID = ##Class(EMR.DOC.BL.Event.CriticalValue).GetEventIDByFromCode(AFromCode)
	}
	s result = AFromType_"^"_eventID
	q result
}

}
