/// Desc:    消息业务类处理
/// Creator: Candy
Class EMRservice.BL.BLMessage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:    添加或修改消息
/// Return:  返回插入数据表的ID
/// Creator: Candy
ClassMethod SetMessage(AInstanceID As %String, AMessage As %String, AMessageTitle As %String, AMessageType As %String, AReceiver As %String, ASender As %String)
{
	s result = ""
	q:(AInstanceID = "")||(AMessage = "")||(ASender = "")||(AReceiver = "") result
	s obj = ##Class(EMRinstance.MessageList).%New()
	s obj.SendDate = $p($h,",",1)
	s obj.SendTime = $p($h,",",2)
	s obj.InstanceID = AInstanceID
	s obj.Message = AMessage
	s obj.MessageTitle = AMessageTitle
	s obj.MessageType = AMessageType
	s obj.Receiver = AReceiver
	s obj.Sender = ASender
	s obj.Status = "1"
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

/// Desc:       发送消息
/// Creaotr:    Candyxu
/// Input:      argUserID 用户ID
///             argInstanceID 实例ID
///             argSignLevel 签名级别
/// Debug:      w ##Class(EMRservice.BL.BLMessage).SendSignMessage("105","1||4","All")
ClassMethod SendSignMessage(argUserID As %String, argInstanceID As %String, argSignLevel As %String, argUserLocId As %String = "") As %String
{
	s result = ""
	q:(argUserID = "")||(argInstanceID = "")||(argSignLevel = "") result
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(obj = "") result
	//增加消息ID为1104的消息处理
	d ..SendMECTMessage(argUserID,argInstanceID,argSignLevel,argUserLocId)
	s checkresult = ..CanSendMessage(argSignLevel,obj.TitleCode)
	q:(checkresult = 0) result
	s patientId = obj.TheECRecord.PatientID
	s episodeId = obj.TheECRecord.RealEpisodeID
	s docId = obj.TheECRecord.RealChartItemID
	k obj
	s messageBody = "申请签名"
	s superDoc =..GetSuperiorDoc(episodeId,argUserID,argUserLocId,argInstanceID)
	q:(superDoc = "") result
	//非HISUI版
	//s url="emr.record.interface.csp?PatientID="_patientId_"&EpisodeID="_episodeId_"&DocID="_docId_"&InstanceID="_argInstanceID
	//HISUI版，重新发送消息生效
	s url="emr.interface.ip.main.csp?EpisodeID="_episodeId_"&DocID="_docId_"&InstanceID="_argInstanceID_"&FromType=EMR&FromCode="
	
	s result = 0
	s rems = ##Class(EMRservice.BL.BLMessage).SetMessage(argInstanceID,messageBody,"申请签名","check",superDoc,argUserID)
	q:(rems = "") result
	s OtherInfoJson="{""link"":"""_url_""",""dialogWidth"":""1400"",""dialogHeight"":""900"",""BizObjId"":"""_rems_"""}"
	s reInterface =  ##class(websys.DHCMessageInterface).Send(messageBody,"1052",argUserID,episodeId,"",superDoc,OtherInfoJson)
	q:($p(reInterface,"^",1) < 0) result
	
	s result = 1	
	q result
}

/// Desc:    检查发送消息
/// Creator: Candy
/// Debug:   w ##Class(EMRservice.BL.BLMessage).CanSendMessage(1,"")
ClassMethod CanSendMessage(AAction As %String, ATitleCode As %String) As %String
{
	s result = 0
	q:(AAction = "")&&(ATitleCode = "") result
	s messageScheme = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SendMessage")
	q:((messageScheme = "")||(messageScheme = $c(0))) result 
	s stream = ##Class(%GlobalCharacterStream).%New()
	d stream.Write(messageScheme)
	s sc =##class(%XML.XPATH.Document).CreateFromStream(stream,.documentList)
	q:($$$ERROR(sc)) result 
	if (AAction '= "")
	{
		s sc = documentList.EvaluateExpression("/event/sign/actions","count(action)",.actionNode)
		q:($$$ERROR(sc)||(actionNode.GetAt(1)="")) result
		s count = actionNode.GetAt(1).Value
		for i=1:1:count
		{
			s sc = documentList.EvaluateExpression("/event/sign/actions/action["_i_"]","text()",.action)
			continue:($$$ERROR(sc)||(action.GetAt(1)=""))
			s actionval = action.GetAt(1).Value
			if (AAction = actionval)
			{
				s result =1 
				q
			}
		}
		q:(result = 1) result
	}
	if (ATitleCode '= "")
	{
		s sc = documentList.EvaluateExpression("/event/sign/titles","count(code)",.titleNode)
		q:($$$ERROR(sc)||(titleNode.GetAt(1)="")) result
		s count = titleNode.GetAt(1).Value
		for i=1:1:count
		{
			s sc = documentList.EvaluateExpression("/event/sign/titles/code["_i_"]","text()",.code)
			continue:($$$ERROR(sc)||(code.GetAt(1)=""))
			s codeval = code.GetAt(1).Value
			if (ATitleCode = codeval)
			{
				s result =1 
				q
			}
		}
		q:(result = 1) result
	}
	q result
}

/// Desc:       发送消息
/// Creaotr:    yejian
/// Input:      argUserID 用户ID
///             argInstanceID 实例ID
///             argSignLevel 签名级别
/// Debug:      w ##Class(EMRservice.BL.BLMessage).SendSignMessage("4634","307||1","Resident","110")
ClassMethod SendMECTMessage(argUserID As %String, argInstanceID As %String, argSignLevel As %String, argUserLocId As %String = "") As %String
{
	s result = ""
	q:(argUserID = "")||(argInstanceID = "")||(argSignLevel = "") result
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(obj = "") result
	s objEvents = ##class(EMRservice.entity.EventMessage.EEvents).%New()
	s checkresult = ..GetSendMessage(argSignLevel,obj.TitleCode,obj.RealTemplateID,.objEvents)
	q:(checkresult = 0) result
	s count = objEvents.Item.Count()
	for i=1:1:count
	{
		s objItem = objEvents.Item.GetAt(i)
		if (objItem.EventID = "1104") //有新开医嘱
		{
			s patientId = obj.TheECRecord.PatientID
			s episodeId = obj.TheECRecord.RealEpisodeID
			s docId = obj.TheECRecord.RealChartItemID
			k obj
			s MECTDocIDs = ..GetMECTDocID(objItem.CTlocID)
			continue:(MECTDocIDs = "")
			s url="emr.record.interface.csp?PatientID="_patientId_"&EpisodeID="_episodeId_"&DocID="_docId_"&UserID="_argUserID_"&InstanceID="_argInstanceID
			s OtherInfoJson="{""link"":"""_url_""",""dialogWidth"":""1400"",""dialogHeight"":""900""}"
			s result = 0
			s reInterface =  ##class(websys.DHCMessageInterface).Send(objItem.MessageBoby,objItem.EventID,argUserID,episodeId,"",MECTDocIDs,OtherInfoJson)
			q:($p(reInterface,"^",1) < 0) 
			s rems = ##Class(EMRservice.BL.BLMessage).SetMessage(argInstanceID,objItem.MessageBoby,objItem.MessageBoby,"MECTCheck",MECTDocIDs,argUserID)
			q:(rems '= 1)

		}
	}
	k objEvents
	s result = 1	
	q result
}

/// Desc:    获取要发送消息体
/// Creator: yejian
/// Debug:   w ##Class(EMRservice.BL.BLMessage).GetSendMessage(1,"")
ClassMethod GetSendMessage(AAction As %String, ATitleCode As %String, AtemplateID As %String, Output AEvents As EMRservice.entity.EventMessage.EEvents) As %String
{
	s result = 0
	s messageScheme = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SendMessage")
	q:(messageScheme = "") result 
	s AEvents = ##class(EMRservice.entity.EventMessage.EEvents).%New()
	s stream = ##Class(%GlobalCharacterStream).%New()
	d stream.Write(messageScheme)
	s sc =##class(%XML.XPATH.Document).CreateFromStream(stream,.documentList)
	q:($$$ERROR(sc)) result 
	
	s sc = documentList.EvaluateExpression("/event/sign","count(item)",.aItem)
	q:($$$ERROR(sc)||(aItem.GetAt(1)="")) result
	s count = aItem.GetAt(1).Value
	for i=1:1:count
	{
		s sc = documentList.EvaluateExpression("/event/sign/item["_i_"]/eventid","text()",.aEventid)
		continue:($$$ERROR(sc)||(aEventid.GetAt(1)=""))
		s strEventid = aEventid.GetAt(1).Value
		s sc = documentList.EvaluateExpression("/event/sign/item["_i_"]/message","text()",.aMessage)
		continue:($$$ERROR(sc)||(aMessage.GetAt(1)=""))
		s strMessage = aMessage.GetAt(1).Value
		s sc = documentList.EvaluateExpression("/event/sign/item["_i_"]/templateid","text()",.aTemplateid)
		continue:($$$ERROR(sc)||(aTemplateid.GetAt(1)=""))
		s strTemplateid = aTemplateid.GetAt(1).Value
		s sc = documentList.EvaluateExpression("/event/sign/item["_i_"]/ctlocid","text()",.aCtlocid)
		continue:($$$ERROR(sc)||(aCtlocid.GetAt(1)=""))
		s strCtlocid = aCtlocid.GetAt(1).Value
		if (AtemplateID = strTemplateid)
		{
			s objEvent = ##class(EMRservice.entity.EventMessage.EEvent).%New()
			s objEvent.EventID =strEventid
			s objEvent.MessageBoby = strMessage
			s objEvent.CTlocID = strCtlocid
			d AEvents.Item.Insert(objEvent)
			s result =1 
			q
		}
	}
	q result
}

/// Desc:获取上级医师
/// Creator:Candy
/// CreateDate:2019-1-15
/// Input:  AEpisodeID  就诊号
///       AUserID 用户ID
///       ALocID 科室ID
/// Output: superiorDoc 上级医师ID     
ClassMethod GetSuperiorDoc(AEpisodeID As %String, AUserID As %String, ALocID As %String, AInstanceID As %String = "") As %String
{
	s superiorDoc = ""
	s superiorDoc = ..GetSuperiorDocBySelect(AInstanceID,AUserID)
	s:(superiorDoc = "") superiorDoc = ..GetSuperiorDocByEMR(AUserID)
	s:(superiorDoc = "") superiorDoc = ..GetSuperiorDocByDoc(AEpisodeID,AUserID)
	s:(superiorDoc = "") superiorDoc = ..GetSuperiorDocByStandard(AEpisodeID,AUserID,ALocID)
	s:(superiorDoc = "") superiorDoc = ..GetSuperiorDocByPatientEMR(AEpisodeID,AUserID)
	q superiorDoc
}

/// 从电子病历获取上级医师
ClassMethod GetSuperiorDocByEMR(argUserID As %String) As %String
{
	s result = ""
	s result = $o(^DHCEMRM.SuperDoctorI("IdxUserSuper"," "_argUserID,""))
	q result
}

/// Desc:       获得上级医师(南方医院取上级医师)
/// Creator:    Candy
/// CreateDate: 2018-3-20
/// Input:      
ClassMethod GetSuperiorDocByDoc(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AUserID = "") result
	s key = $i(^CacheTemp("GetSuperiorDoc"))
	s rowId = $o(^DHCPAAdm(0,"PAAdm",AEpisodeID,""))
	q:(rowId = "") result
	s tmpSeq = ""
	s doctorId = $P(^DHCPAAdm(rowId),"^",25)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 0
		s ^CacheTemp("GetSuperiorDoc",key,"0",userId)= "student"		
	}	
	s doctorId = $P(^DHCPAAdm(rowId),"^",26)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 0
		s ^CacheTemp("GetSuperiorDoc",key,"0",userId)= "student"
	}	
	s doctorId = $P(^DHCPAAdm(rowId),"^",27)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 0
		s ^CacheTemp("GetSuperiorDoc",key,"0",userId)= "student"
	}	
	s doctorId = $p(^PAADM(AEpisodeID),"^",9)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 1
		s ^CacheTemp("GetSuperiorDoc",key,"1",userId)= "Resident"	
	}
	s doctorId = $P(^DHCPAAdm(rowId),"^",23)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 2
		s ^CacheTemp("GetSuperiorDoc",key,"2",userId)= "Attending"
	}
	s doctorId = $P(^DHCPAAdm(rowId),"^",24)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId,""))
		s:(AUserID = userId) tmpSeq = 3
		s ^CacheTemp("GetSuperiorDoc",key,"2",userId)= "Chief"
	}
	s:(tmpSeq '= "") result = $o(^CacheTemp("GetSuperiorDoc",key,tmpSeq,""))
	k ^CacheTemp("GetSuperiorDoc",key)
	q result
}

/// Desc:      标版取上级医师
/// Creator:   Candy
/// CreateDate:2018-12-21
/// Input:	   AEpisodeID 就诊ID
///  		   AUserID  用户ID
///            ALocID 科室ID   
/// Output:    result 上级医师ID
/// Debug:     w ##Class(EMRservice.BL.BLMessage).GetSuperiorDocByStandard("1","001","1")
ClassMethod GetSuperiorDocByStandard(AEpisodeID As %String, AUserID As %String, ALocID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ALocID = "")||(AUserID = "") result
	s docs = ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("",ALocID,AEpisodeID)
	//s docs = "[{""UserID"":""001"",""UserDesc"":""qq"",""Type"":""1"",""TypeDesc"":""管床医师""},{""UserID"":""002"",""UserDesc"":"""",""Type"":""2"",""TypeDesc"":""ee""}]"
	q:(docs = "") result
	s stream =##class(%GlobalBinaryStream).%New()
	d stream.Write(docs)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s arrDocs = objJson.Deserialize(stream)
	s userType = ""
	s key = $i(^CacheTemp("GetSuperiorDoc"))
	s count = arrDocs.Count()
	for i=1:1:count
	{
		s type = arrDocs.GetAt(i).GetAt("Type")
		continue:(type = "")
		s userId = arrDocs.GetAt(i).GetAt("UserID")
		continue:(userId = "")
		s:(AUserID = userId) userType = type
		s typeDesc = arrDocs.GetAt(i).GetAt("TypeDesc")
		s ^CacheTemp("GetSuperiorDoc",key,type,userId) = typeDesc
	}
	if (userType '= "") 
	{
		s tmpType = $o(^CacheTemp("GetSuperiorDoc",key,userType))
		s:(tmpType '= "") result = $o(^CacheTemp("GetSuperiorDoc",key,tmpType,""))
	}
	k ^CacheTemp("GetSuperiorDoc",key)
	q result
}

/// Desc:通过标题配置的上级医师取上级医师(发送给查房的医师签名)
ClassMethod GetSuperiorDocBySelect(argInstanceID As %String, argUserID As %String) As %String
{
	s superDoc = ""
	s titleSuperDoc = $o(^DHCEMRI.TitleDoctorI("IdxInstanceIDUserID"," "_argInstanceID,""))
	s titleSuperDoc = $tr(titleSuperDoc," ")
	s:((titleSuperDoc '= "")&&(titleSuperDoc '= argUserID)) superDoc = titleSuperDoc
	q superDoc
}

/// Desc:获取MECT科室的人员(发送MECT科室所有人员消息)
/// Creator:   yejian
/// CreateDate:2019-1-17
/// w ##Class(EMRservice.BL.BLMessage).GetMECTDocID("110")
ClassMethod GetMECTDocID(aCTLocID As %String) As %String
{
	s result=""
	s UserID = ""
	for
	{
		s UserID = $o(^SSU("SSUSR",UserID))
		q:(UserID = "")
		s ctLocID =$p($g(^SSU("SSUSR",UserID)),"^",4) 
		s Active =$p($g(^SSU("SSUSR",UserID)),"^",19)
		if ((aCTLocID=ctLocID)&&(Active = "Y"))
		{
			if (result="")
			{
				s result=UserID
			}
	        else 
	        {
		        s result=result_"^"_UserID
		    }
		}
		
	}
	q result
}

/// Desc:       改变消息状态
/// Creator:    Donglulu
/// CreateDate: 2019-1-30
/// Input:      argUserID 用户ID
///             argInstanceID 实例ID
///             argSignLevel 签名级别
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLMessage).ChangeMessageStatus("4133","1||11")
ClassMethod ChangeMessageStatus(argUserID As %String, argInstanceID As %String) As %String
{
	q:(argUserID = "")||(argInstanceID = "")
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.MessageListI("IdxInstanceTypeReceiverStatus"," "_argInstanceID," CHECK"," "_argUserID," 1",rowId))
		q:(rowId = "")
		s objmessage = ##Class(EMRinstance.MessageList).%OpenId(rowId)
	    q:(objmessage = "")
	    s objmessage.Status = "0"
	    d objmessage.%Save()
    	d objmessage.%Close()	
		k objmessage
		
		s rtn=##class(websys.DHCMessageInterface).Exec("","1052","","",rowId,argUserID,"","")
	}
	q
}

/// Desc:       获得上级医师(电子病历设置三级医师)
/// Creator:    Donglulu
/// CreateDate: 2019-11-29
/// Input:      AEpisodeID就诊号 AUserID用户ID
/// Output:     上级医师userID 
/// Debug:      w ##Class(EMRservice.BL.BLMessage).GetSuperiorDocByPatientEMR("22","362")
ClassMethod GetSuperiorDocByPatientEMR(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AUserID = "") result
	
	s rowId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDDoctorID"," "_AEpisodeID," "_AUserID,""))
	q:(rowId = "") result
	
	s obj = ##Class(EMRinstance.PatientDoctor).%OpenId(rowId)
	q:(obj = "") result
	s levelCode = obj.DoctorLevelCode
	
	s roleLevel = $O(^DHCEMRM.PatientDoctorI("IdxLevelCodeRoleLevel"," "_$zcvt(levelCode,"U"),""))
	q:(roleLevel = "") result
	
	s superRoleLevel = $O(^DHCEMRM.PatientDoctorI("IdxRoleLevel",roleLevel))
	q:(superRoleLevel = "") result
	s superMetaID = $O(^DHCEMRM.PatientDoctorI("IdxRoleLevel",superRoleLevel,""))
	q:(superMetaID = "") result
	
	s metaObj = ##Class(EMRmeta.PatientDoctor).%OpenId(superMetaID)
	q:(metaObj = "") result
	s superLevelCode = metaObj.LevelCode
	
	s result = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDLevelDoc"," "_AEpisodeID," "_$zcvt(superLevelCode,"U"),""))
	s result = $tr(result," ","")
	q result
}

/// Desc:       删除病历时改变该实例所有消息状态
/// Creator:    Donglulu
/// CreateDate: 2020-11-3
/// Input:      argInstanceID 实例ID
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLMessage).DeleteChangeMessageStatus("1||11")
ClassMethod DeleteChangeMessageStatus(argInstanceID As %String) As %String
{
	q:(argInstanceID = "")
	s receiver = ""
	for 
	{
		s receiver = $o(^DHCEMRI.MessageListI("IdxInstanceTypeReceiverStatus"," "_argInstanceID," CHECK",receiver))
		q:(receiver = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRI.MessageListI("IdxInstanceTypeReceiverStatus"," "_argInstanceID," CHECK",receiver," 1",rowId))
			q:(rowId = "")
			s objmessage = ##Class(EMRinstance.MessageList).%OpenId(rowId)
		    q:(objmessage = "")
		    s objmessage.Status = "0"
		    d objmessage.%Save()
	    	d objmessage.%Close()	
			k objmessage
			
			s argUserID = $e(receiver,2,*)
			s rtn=##class(websys.DHCMessageInterface).Exec("","1052","","",rowId,argUserID,"","")
		}
	}
	q
}

}
