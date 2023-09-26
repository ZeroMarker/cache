/// Desc：事件关联病历
/// Creator：lifengbo
/// CreateDate：2023-05-08
Class EMR.DOC.BL.Event.LinkDocument Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		根据DocId取实例
/// Creator:	Candy
/// CreateDate: 2015-11-13
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// 				AOperInfo 手术信息（手术相关界面获取手术实例表格时传入手术信息）
/// Debug：     w ##Class(EMR.DOC.BL.Event.LinkDocument).GetInstanceJson(58,76,"Save","OPERATION",4)
ClassMethod GetInstanceJson(ADocId As %String, AEpisodeId As %String, AStauts As %String, AEventType As %String, AEventId As %String, ASequence As %String, AOperInfo As %String = "") As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "")||(AEventType = "")||(AEventId = "") json
	s key = $i(^CacheTempEventInstance)
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeId)	
	s doucmentID = ""
	for
	{
		s doucmentID = $o(@TILLinkDocument@("IdxEpisodeEventDocumentID",AEpisodeId," "_$zcvt(AEventType,"U"),AEventId,doucmentID))
		q:(doucmentID = "")

		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(AEpisodeId,doucmentID)
		continue:(objDocument.Status '= AStauts)
		
		s tempJson = ##Class(EMR.IP.BL.BLClientCategory).GetInstanceJsonByID(doucmentID,"",AOperInfo)
		continue:(tempJson = "")
		s ^CacheTempEventInstance(key,objDocument.HappenDate,objDocument.HappenTime,doucmentID)= tempJson
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
/// Creator:    lifengbo
/// CreateDate: 2023-05-09
/// w ##class(EMR.DOC.BL.Event.LinkDocument).SaveLinkDocumnet("1224","674","CriticalValue","3","1||0000000312||1","18881")
ClassMethod SaveLinkDocumnet(AEpisodeID As %String, ADocumentID As %String, AEventType As %String, AEventID As %String, AFromCode As %String = "", AUserID As %String = "") As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(ADocumentID = "")||(AEventID = "")||(AEventType = "") result
	
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	
	q:(objDocument = "") result
	s $zt = "SaveLinkDocumnetError"
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	
	
	s rowId = ""
	s rowId = $o(@TILLinkDocument@("IdxMain",AEpisodeID," "_$zcvt(AEventType,"U"),AEventID,ADocumentID,rowId))
	
	if (rowId '= "")
	{
		if (objDocument.Status = "Save") 
		{
			s result = 1
			q result
		}
		else
		{
			s obj = ##Class(EMR.DAO.Events.LinkDocument).doOpenByID(AEpisodeID,rowId)
		}
	}
	else
	{
	    s obj = ##Class(EMR.DAO.Events.LinkDocument).doCreateInstance(AEpisodeID)
	    s obj.EpisodeID = objDocument.EpisodeID
	    s obj.EventsID = AEventID
	    s obj.EventType =  AEventType
	    s obj.FromCode = AFromCode
	}
	
    s obj.DocumentID  = objDocument
    s obj.UserID = ##class(User.SSUser).%OpenId(AUserID)
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
ClassMethod GetLinkDocInfo(AEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = ""
	q:(ADocumentID = "") result
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	

	s count = 0
	s type = ""
	for
	{
		s type = $o(@TILLinkDocument@("IdxInstanceType",ADocumentID,type))
		q:(type = "")
		s rowId = $o(@TILLinkDocument@("IdxInstanceType",ADocumentID,type,""))
		continue:(rowId = "")
		s objDoc = ##Class(EMR.DAO.Events.LinkDocument).doCreateInstance(AEpisodeID,rowId)
		continue:(objDoc = "")
		s eventIDs = ##Class(EMR.DOC.BL.Event.LinkDocument).GetLinkEventIDByDocumentID(AEpisodeID, ADocumentID,objDoc.EventType)
		s:(count '= 0) rsult = result_","
		s result = result_"{"
		s result = result_"""EventType"":"""_objDoc.EventType_""","
		s result = result_"""EventID"":"""_eventIDs_""","
		s result = result_"""DocumentID"":"""_ADocumentID_""""
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
/// Debug：     w ##Class(EMR.DOC.BL.Event.LinkDocument).GetInstanceInfo(174,"Save","CriticalValue",1)
ClassMethod GetInstanceInfo(AEpisodeId As %String, AStauts As %String, AEventType As %String, AEventId As %String) As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(AEpisodeId = "")||(AStauts = "")||(AEventType = "")||(AEventId = "") json
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeId)	


	s documentId = ""
	for
	{
		s documentId = $o(@TILLinkDocument@("IdxMain",AEpisodeId," "_$zcvt(AEventType,"U")," "_AEventId,documentId))
		q:(documentId = "")
		
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(AEpisodeId,documentId)
		continue:(objDocument.Status '= AStauts)
		
		s tempJson = ##Class(EMR.IP.BL.BLClientCategory).GetInstanceJsonByID(documentId)
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
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	
	
	s result = 0
	s documentID = ""
	for 
	{
		s documentID = $o(@TILLinkDocument@("IdxEpisodeEventInstanceID",AEpisodeID," "_$zcvt(AEventType,"U"),AEventID,documentID))
		q:(documentID = "")

			
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(AEpisodeID,documentID)
		
		if (objDocument '= "")
		{
			s:(objDocument.Status = "Save") result = 1
			q:(result = 1)
		}
		
	}
	q result
}

/// Desc:删除病历时清空其它产品组ID与InstanceID关系
/// Creator:Donglulu
/// CreateDate:2021-4-12
ClassMethod DeleteData(AEpisodeID As %String, ADocumentID As %String, AUserID As %String) As %String
{
	s result = "1"
	q:(ADocumentID = "") result
	s $zt = "DeleteDataError"
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	
	
	s eventType = ""
	for 
	{
		s eventType = $o(@TILLinkDocument@("IdxInstanceType",ADocumentID,eventType))
		q:(eventType = "")
		s linkID = ""
		for
		{
			s linkID = $o(@TILLinkDocument@("IdxInstanceType",ADocumentID,eventType,linkID))
			q:(linkID = "")
			s ^CacheTemp("EMR",2)=linkID
			s objLink = ##Class(EMR.DAO.Events.LinkDocument).doOpenByID(AEpisodeID,linkID)
			s ^CacheTemp("EMR",3)=objLink
			q:(objLink = "")
			s fromType = objLink.EventType
			s fromCode = objLink.FromCode
			s eventsID = objLink.EventsID
			s sc = objLink.%DeleteId(linkID)
			s ^CacheTemp("EMR",4)=$lb(sc,eventsID)
			s:($$$ISOK(sc) = "0") result = "-1"
			q:(result = "-1")
		    //病历删除后，将走马灯提示修改为提示状态
		  	d ..SetTipsActive(AEpisodeID,fromType,fromCode,eventsID)
			if (fromCode '= "")
			{
				s sc =  ..InvokInterface(fromType,fromCode,"",AUserID)
				s:(sc = "-1") result = "-1"
			}
			q:(result = "-1")
		}
		q:(result = "-1")
	}
	q result
DeleteDataError
	s ^CacheTemp("EMR",1)=$ze
    q "-1^"_$ze
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
		d ##class(EMR.DOC.BL.Event.CriticalValue).InvokInterface(AFromCode,AInstanceID,AUserID)
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
/// Debug：     w ##Class(EMR.DOC.BL.Event.LinkDocument).GetLinkDocumentID(4,"Consult",13)
ClassMethod GetLinkDocumentID(AEpisodeID As %String, AEventType As %String, AEventID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AEventType = "")||(AEventID = "") result
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	
	
	s linkDocumentId = ""
	s linkDocumentId = $o(@TILLinkDocument@("IdxMain",AEpisodeID," "_$zcvt(AEventType,"U"), " "_AEventID,""))
	s result = linkDocumentId
	
	q result
}

/// Desc:       获取instanceID关联AEventType的所有AEventID，以@为分隔
/// Creator:	Donglulu
/// Create		Date:2021-5-12
/// Input:      AInstanceID 实例ID
///             ADocID 病历目录
///             AEventType 事件类型
///             AEventID 事件ID
/// Debug：     w ##Class(EMR.DOC.BL.Event.LinkDocument).GetLinkEventIDByInstanceID("98||122","Consult")
ClassMethod GetLinkEventIDByDocumentID(AEpisodeID As %String, ADocumentID As %String, AEventType As %String) As %String
{
	s result = ""
	q:(ADocumentID = "")||(AEventType = "") result
	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	

	s linkID = ""
	for
	{
		s linkID = $o(@TILLinkDocument@("IdxInstanceType",ADocumentID," "_$zcvt(AEventType,"U"),linkID))
		q:(linkID = "")
		s objLink = ##Class(EMR.DAO.Events.LinkDocument).doOpenByID(AEpisodeID,ADocumentID) 
		
		q:(objLink = "")
		s tmpEventID = objLink.EventsID
		
		continue:(tmpEventID = "")
		s:(result '= "") result = result_"@"
		s result = result_tmpEventID
	}
	
	q result
}

/// Desc:       病历删除后，将走马灯提示修改为提示状态
/// Creator:    王煜(lifengbo)
/// CreateDate: 2021-4-12 (2021-04-48)
/// Input:      AFromType 产品来源类型
///             AFromCode 关联产品ID
///             AInstanceID 关联病历ID
ClassMethod SetTipsActive(AEpisodeID As %String, AFromType As %String, AFromCode As %String, EventsID As %String) As %String
{

	if (AFromType = "CriticalValue")
	{
		d ##Class(EMR.DOC.BL.Event.CriticalValue).SetActive(AEpisodeID, EventsID)
	}
}

/// Desc:       病历保存时更新，关联数据
/// Creator:    lifengbo
/// CreateDate: 2023-05-08
/// Input:      dtoInData 病历文档对象
ClassMethod LinkDocumentEvent(dtoInData As EMR.DOC.DTO.DocumentData) As %String
{
	s result=1

	s event = dtoInData.EventID
	q:(event="") result
	s $zt="ERROR"
	if (event '= "")
	{
		
		s eventType =dtoInData.EventType
		s eventIds = dtoInData.EventID
		s documentID= dtoInData.ID
		s userID = dtoInData.ModifyUser.%Id()
		s episodeID = dtoInData.EpisodeID.%Id()
		
		if (eventIds '= ##Class(EMR.DOC.BL.Event.LinkDocument).GetLinkEventIDByDocumentID(episodeID,documentID,eventType))
		{
			
			s deleteFlag = ##class(EMR.DOC.BL.Event.LinkDocument).DeleteData(episodeID, documentID,userID)
		}
		
		s result = ##Class(EMR.DOC.BL.Event.Event).DoEvent(episodeID, eventType,eventIds,documentID,userID)
		
		if (result = "0")
		{
			s result="-1^事件数据更新异常"
		}
	}
	
	q result
ERROR
	s $zt=""
	q "-1^"_$ze
}

}
