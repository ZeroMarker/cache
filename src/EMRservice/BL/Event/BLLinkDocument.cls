/// Desc：事件关联病历
/// Creator：Candy
/// CreateDate：2015-12-15
Class EMRservice.BL.Event.BLLinkDocument Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		根据DocId取实例
/// Creator:	Candy
/// CreateDate: 2015-11-13
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// 				AOperInfo 手术信息（手术相关界面获取手术实例表格时传入手术信息）
/// Debug：     w ##Class(EMRservice.BL.Event.BLLinkDocument).GetInstanceJson(58,76,"Save","OPERATION",4)
ClassMethod GetInstanceJson(ADocId As %String, AEpisodeId As %String, AStauts As %String, AEventType As %String, AEventId As %String, ASequence As %String, AOperInfo As %String = "") As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "")||(AEventType = "")||(AEventId = "") json
	s key = $i(^CacheTempEventInstance)
	s InstanceId = ""
	for
	{
		s InstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxEpisodeEventChartItemInstanceID"," "_AEpisodeId," "_$zcvt(AEventType,"U")," "_AEventId," "_ADocId,InstanceId))
		q:(InstanceId = "")
		s tempInstanceId = $tr(InstanceId," ","")
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
		continue:(objInstance.Status '= AStauts)
		s ecrecordId = $p(tempInstanceId,"||",1)
		s subId = $p(tempInstanceId,"||",2)
		s tempJson = ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordId,subId,"",AOperInfo)
		continue:(tempJson = "")
		s ^CacheTempEventInstance(key,objInstance.HappenDate,objInstance.HappenTime,InstanceId)= tempJson
	}
	s count = 0
	s seq = 1
	s:(ASequence = "DESC") seq = -1
	s date = ""
	for
	{
		s date = $o(^CacheTempEventInstance(key,date),seq)
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^CacheTempEventInstance(key,date,time),seq)
			q:(time = "")
			s id = ""
			for
			{
				s id = $o(^CacheTempEventInstance(key,date,time,id),seq)
				q:(id = "")
				d:(count '= 0) json.Write(",")
				s tempJson = ^CacheTempEventInstance(key,date,time,id)
				d json.Write(tempJson)
				s count = count + 1
			}
		}
	}
	q json
Error
	q ""
}

/// Desc:       保存关联文档
/// Creator:    Candy
/// CreateDate: 2015-3-25
ClassMethod SaveLinkDocumnet(AInstanceID As %String, AEventType As %String, AEventID As %String, AFromCode As %String = "", AUserID As %String = "") As %String
{
	s result = "0"
	q:(AInstanceID = "")||(AEventID = "")||(AEventType = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s $zt = "SaveLinkDocumnetError"
	
	s rowId = ""
	s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_objInstance.RealEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID," "_AInstanceID,rowId))
	if (rowId '= "")
	{
		if (objInstance.Status = "Save") 
		{
			s result = 1
			q result
		}
		else
		{
			s obj = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
		}
	}
	else
	{
	    s obj = ##Class(EMRinstance.Events.LinkDocumnents).%New()
	    s obj.EpisodeID = objInstance.RealEpisodeID
	    s obj.EventsID = AEventID
	    s obj.EventType =  AEventType
	    s obj.PatientID =  ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(objInstance.RealEpisodeID)
	    s obj.FromCode = AFromCode
	}
    s obj.InstanceID  = AInstanceID
    s obj.ChartItemID = objInstance.TheECRecord.RealChartItemID
    s obj.TitleCode = objInstance.TitleCode
    s obj.UserID = AUserID
    s:($$$ISOK(obj.%Save())) result = "1"
    q result
    
SaveLinkDocumnetError
	q "0"
}

/// Desc:       病历关联事件信息
/// Creator:    Candy
/// CreateDate: 2016-2-22
/// Input:      AInstanceID 病历ID
/// Output:     result 病历关联信息{"EventType":"Operation","EventID":"11","InstanceID":"1||1"},……
ClassMethod GetLinkDocInfo(AInstanceID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	s count = 0
	s type = ""
	for
	{
		s type = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID,type))
		q:(type = "")
		s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID,type,""))
		continue:(rowId = "")
		s objDoc = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
		continue:(objDoc = "")
		s eventIDs = ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkEventIDByInstanceID(AInstanceID,objDoc.EventType)
		s:(count '= 0) rsult = result_","
		s result = result_"{"
		s result = result_"""EventType"":"""_objDoc.EventType_""","
		s result = result_"""EventID"":"""_eventIDs_""","
		s result = result_"""InstanceID"":"""_AInstanceID_""""
		s result = result_"}"
		s count = count + 1
	}
	q result
}

/// Desc:		根据AEpisodeId、AEventType、AEventId取实例
/// Creator:    Lina
/// CreateDate: 2016-6-28
/// Input:      AEpisodeId 就诊号
///             AEventType 事件类型
///             AEventId EMRinstance.Events.CriticalValue.ID
/// Debug：     w ##Class(EMRservice.BL.Event.BLLinkDocument).GetInstanceInfo(174,"Save","CriticalValue",1)
ClassMethod GetInstanceInfo(AEpisodeId As %String, AStauts As %String, AEventType As %String, AEventId As %String) As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(AEpisodeId = "")||(AStauts = "")||(AEventType = "")||(AEventId = "") json
	s InstanceId = ""
	for
	{
		s InstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_AEpisodeId," "_$zcvt(AEventType,"U")," "_AEventId,InstanceId))
		q:(InstanceId = "")
		s tempInstanceId = $tr(InstanceId," ","")
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
		continue:(objInstance.Status '= AStauts)
		s ecrecordId = $p(tempInstanceId,"||",1)
		s subId = $p(tempInstanceId,"||",2)
		s tempJson = ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordId,subId)
		continue:(tempJson = "")
		d:(count '= 0) json.Write(",")
		d json.Write(tempJson)
		s count = count + 1
	}
	q json
Error
	q ""
}

/// Desc:       检查事件关联的病历是否已经书写
/// Creator:    Candy
/// CreateDate: 2016-11-26
/// Input:      AEpisodeID 就诊号
///             ADocID 病历目录
///             AEventType 事件类型
///             AEventID 事件ID
ClassMethod IsLinkDocumentWrited(AEpisodeID As %String, ADocID As %String, AEventType As %String, AEventID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ADocID = "")||(AEventType = "")||(AEventID = "") result
	s result = 0
	s linkInstanceId = ""
	for 
	{
		s linkInstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxEpisodeEventChartItemInstanceID"," "_AEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID," "_ADocID,linkInstanceId))
		q:(linkInstanceId = "")
		if (linkInstanceId '= "")
		{
			s tmplinkInstanceId = $tr(linkInstanceId," ")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmplinkInstanceId)
			if (objInstance '= "")
			{
				s:(objInstance.Status = "Save") result = 1
				q:(result = 1)
			}
		}
	}
	q result
}

/// Desc:删除病历时清空其它产品组ID与InstanceID关系
/// Creator:Donglulu
/// CreateDate:2021-4-12
ClassMethod DeleteData(AInstanceID As %String, AUserID As %String) As %String
{
	s result = "1"
	q:(AInstanceID = "") result
	s $zt = "DeleteDataError"
	Tstart
	s eventType = ""
	for 
	{
		s eventType = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID,eventType))
		q:(eventType = "")
		s linkID = ""
		for
		{
			s linkID = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID,eventType,linkID))
			q:(linkID = "")
			s objLink = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(linkID)
			q:(objLink = "")
			s fromType = objLink.EventType
			s fromCode = objLink.FromCode
			s eventsID = objLink.EventsID
			s sc = ##Class(EMRinstance.Events.LinkDocumnents).%DeleteId(linkID)
			s:($$$ISOK(sc) = "0") result = "-1"
			q:(result = "-1")
		    //病历删除后，将走马灯提示修改为提示状态
		  	d ..SetTipsActive(fromType,fromCode,eventsID)
			if (fromCode '= "")
			{
				s sc =  ..InvokInterface(fromType,fromCode,"",AUserID)
				s:(sc = "-1") result = "-1"
			}
			q:(result = "-1")
		}
		q:(result = "-1")
	}
	if (result = "-1")
	{
		Trollback
	}
	else
	{
		Tcommit
	}
	q result
DeleteDataError
    Trollback
    q result
}

/// Desc:调用接口，将病历ID传回
/// Creator:Donglulu
/// CreateDate:2021-4-12
/// Input: AFromType 产品来源类型
///        AFromCode 关联产品ID
///        AInstanceID 关联病历ID
ClassMethod InvokInterface(AFromType As %String, AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	s $zt = "InvokError"
	s result = 1
	if (AFromType = "CriticalValue")
	{
		d ##class(EMRservice.BL.Event.BLCriticalValue).InvokInterface(AFromCode,AInstanceID,AUserID)
	}
	elseif (AFromType = "Consult")
	{
		d ##class(EMRservice.BL.Event.BLConsult).InvokInterface(AFromCode,AInstanceID,AUserID)
	}
	elseif (AFromType = "MDTConsult")
	{
		d ##class(EMRservice.BL.Event.BLMDTConsult).InvokInterface(AFromCode,AInstanceID,AUserID)
	}
	q result
InvokError
    q "-1"
}

/// Desc:       检查事件是否已关联病历
/// Creator:	Donglulu
/// Create		Date:2021-4-12
/// Input:      AEpisodeID 就诊号
///             ADocID 病历目录
///             AEventType 事件类型
///             AEventID 事件ID
/// Debug：     w ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkInstanceID(4,"Consult",13)
ClassMethod GetLinkInstanceID(AEpisodeID As %String, AEventType As %String, AEventID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AEventType = "")||(AEventID = "") result
	
	s linkInstanceId = ""
	s linkInstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_AEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID,""))
	s result = $tr(linkInstanceId," ")
	
	q result
}

/// Desc:       获取instanceID关联AEventType的所有AEventID，以@为分隔
/// Creator:	Donglulu
/// Create		Date:2021-5-12
/// Input:      AInstanceID 实例ID
///             ADocID 病历目录
///             AEventType 事件类型
///             AEventID 事件ID
/// Debug：     w ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkEventIDByInstanceID("98||122","Consult")
ClassMethod GetLinkEventIDByInstanceID(AInstanceID As %String, AEventType As %String) As %String
{
	s result = ""
	q:(AInstanceID = "")||(AEventType = "") result
	
	s linkID = ""
	for
	{
		s linkID = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_AInstanceID," "_$zcvt(AEventType,"U"),linkID))
		q:(linkID = "")
		s objLink = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(linkID)
		q:(objLink = "")
		s tmpEventID = objLink.EventsID
		continue:(tmpEventID = "")
		s:(result '= "") result = result_"@"
		s result = result_tmpEventID
	}
	
	q result
}

/// Desc:       病历删除后，将走马灯提示修改为提示状态
/// Creator:    王煜
/// CreateDate: 2021-4-12
/// Input:      AFromType 产品来源类型
///             AFromCode 关联产品ID
///             AInstanceID 关联病历ID
ClassMethod SetTipsActive(AFromType As %String, AFromCode As %String, EventsID As %String) As %String
{
	if (AFromType = "DischargeRecord")
	{
		d ##Class(EMRservice.BL.Event.BLDischargeRecord).SetActive(EventsID)
	}
	elseif(AFromType = "InformedConsent")
	{
		d ##Class(EMRservice.BL.Event.BLInformedConsent).SetActive(EventsID)
	}
	elseif(AFromType = "BloodTransfusion")
	{
		d ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetActive(EventsID)
	}
	elseif (AFromType = "CriticalValue")
	{
		d ##Class(EMRservice.BL.Event.BLCriticalValue).SetActive(EventsID)
	}
	elseif (AFromType = "Rescue")
	{
		d ##Class(EMRservice.BL.Event.BLRescue).SetActive(EventsID)
	}
	elseif(AFromType = "Operation")
	{
		d ##class(EMRservice.BL.Event.BLOperation).SetActive(EventsID)
	}
	elseif(AFromType = "Manipulate")
	{
		d ##class(EMRservice.BL.Event.BLManipulate).SetActive(EventsID)
	}
	elseif(AFromType = "ModDiagnosis")
	{
		d ##class(EMRservice.BL.Event.BLModDiagnosis).SetActive(EventsID)
	}
	elseif(AFromType = "Consult")
	{
		d ##class(EMRservice.BL.Event.BLConsult).SetActive(EventsID)
	}
	elseif(AFromType = "MDTConsult")
	{
		d ##class(EMRservice.BL.Event.BLMDTConsult).SetActive(EventsID)
	}
}

}
