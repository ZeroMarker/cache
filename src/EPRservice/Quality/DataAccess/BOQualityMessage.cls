Class EPRservice.Quality.DataAccess.BOQualityMessage Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityMessageInfo";

Query GetMessageList(AFromDate As %String, AToDate As %String, AKeyWord As %String) As %Query(ROWSPEC = "MessageBody,CreateDate,CreateTime,CreateUserDesc,LinkCount,MessageID")
{
}

ClassMethod GetMessageListExecute(ByRef qHandle As %Binary, AFromDate As %String, AToDate As %String, AKeyWord As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s FromDate	= $g(AFromDate)
	s ToDate	= $g(AToDate)
	s FromDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(FromDate)," ",1)
	s ToDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ToDate)," ",1)
	s:(FromDate = "") FromDate = $h - 7
	s:(ToDate = "") ToDate = $p($h,",",1)
	
	s Date = FromDate -1
	for {
		s Date = $o(^DHCEPRQ.EPRSingleMessageI("IdxCreateDateTime",Date))
		q:(Date > ToDate)
		s Time = ""
		for {
			s Time = $o(^DHCEPRQ.EPRSingleMessageI("IdxCreateDateTime",Date,Time))
			q:(Time = "")
			s messageID = ""
			for {
				s messageID = $o(^DHCEPRQ.EPRSingleMessageI("IdxCreateDateTime",Date,Time,messageID))
				q:(messageID = "")
				s objMessage = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)	
				continue:(objMessage = "")
			    continue:(objMessage.EffectiveFlag="T")
				s CreateDate = objMessage.CreateDate
				s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
				s CreateTime = objMessage.CreateTime
				s:(CreateTime '= "") CreateTime = $zt(CreateTime,1)
				s CreateUserDR = objMessage.SenderUserID
				s CreateUserDesc = ""
				s:(CreateUserDR '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+CreateUserDR)),"^",2)
				s MessageBody = objMessage.Message
				continue:(AKeyWord '= "")&&(MessageBody '[ AKeyWord)
			
				s MsgCount = objMessage.SendNo
				//&sql(SELECT COUNT(MessageDR) INTO:MsgCount FROM EPRinstance_Quality.QualityMessageRecipient WHERE MessageDR = :MessageID)
			
				s Data = $lb(MessageBody,CreateDate,CreateTime,CreateUserDesc,MsgCount,MessageID)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}
		}	
	}
	
	q $$$OK
}

ClassMethod GetMessageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetMessageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityMessage","GetMessagesByEpisodeID","66")
Query GetMessagesByEpisodeID(AEpisodeID As %String, AMsgStatus As %String = "", AAction As %String = "") As %Query(ROWSPEC = "RowID,CreateDate,CreateTime,CreateUserDesc,MessageBody,ReadDate,ReadTime,ReadUserDesc,ReadStatus,ExecuteDate,ExecuteTime,ExecuteUserDesc,ExecuteStatus,EntryID,EntryScore,ExamCount,ResumeText,ReceiverUserDesc,ConfirmStatus,MessageTitle")
{
}

ClassMethod GetMessagesByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AMsgStatus As %String = "", AAction As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s EpisodeID = $g(AEpisodeID)
	q:(EpisodeID="") $$$OK
	
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_EpisodeID,RowID),-1)
		q:RowID=""
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		continue:(msgObj.EffectiveFlag="T")
		s MessageTitle=msgObj.MessageTitle
		//环节质控
		continue:(AAction="A")&&(MessageTitle'["环节")
		//科室终末质控、院级终末质控、首页质控、编目质控
		continue:(AAction="D")&&(MessageTitle'["终末")&&(MessageTitle'["首页")&&(MessageTitle'["编目")
		s CreateDate = msgObj.CreateDate
		s:(CreateDate '= "") CreateDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
		s CreateTime = msgObj.CreateTime
		s:(CreateTime '= "") CreateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",CreateTime)
		s MessageBody = msgObj.Message
		s ReadDate = msgObj.ReadDate
		s:(ReadDate '= "") ReadDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ReadDate)
		s ReadTime = msgObj.ReadTime
		s:(ReadTime '= "") ReadTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ReadTime)
		s SenderUserID = msgObj.SenderUserID
		//s CreateUserDesc = ##class(EPRservice.BLL.BLEPRMessage).GetUserNameByUserID(SenderUserID)
		s:(SenderUserID '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+SenderUserID)),"^",2)
		s ReadUser = msgObj.ReadUserID
		s ReadUserDesc = ""
		s:(ReadUser '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUser)),"^",2)
		s ReadStatus = "未读"
		s:(msgObj.ReadFlag = "R") ReadStatus = "已读"
		s ExecuteDate = msgObj.ExecuteDate
		s:(ExecuteDate '= "") ExecuteDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ExecuteDate)
		s ExecuteTime = msgObj.ExecuteTime
		s:(ExecuteTime '= "") ExecuteTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ExecuteTime)
		s ExecuteUser = msgObj.ExecuteUserID
		s ExecuteUserDesc = ""
		s:(ExecuteUser '= "") ExecuteUserDesc = $p($g(^SSU("SSUSR",+ExecuteUser)),"^",2)
		s ExecuteStatus = "未处理"
		s:(msgObj.ExecuteFlag = "E") ExecuteStatus = "已处理"
		continue:(AMsgStatus'="")&&(msgObj.ExecuteFlag'=AMsgStatus)
		s EntryID = msgObj.EntryID
		s EntryScore = msgObj.EntryScore
		s ExamCount = msgObj.ExamCount
		s ResumeText = msgObj.ResumeText
		s ConfirmStatus="未确认"
		s:(msgObj.ConfirmFlag="C") ConfirmStatus="已确认"
		s ReceiverUser=msgObj.ReceiverUserID
		s ReceiverUserDesc = ""
		s:(ReceiverUser '= "") ReceiverUserDesc = $p($g(^SSU("SSUSR",+ReceiverUser)),"^",2)
		s MessageTitle=msgObj.MessageTitle
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s ExecuteStatus = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRinstance.EPRSingleMessage","ExecuteFlag",ExecuteStatus,langid)
		s Data = $lb(RowID,CreateDate,CreateTime,CreateUserDesc,MessageBody,ReadDate,ReadTime,ReadUserDesc,ReadStatus,ExecuteDate,ExecuteTime,ExecuteUserDesc,ExecuteStatus,EntryID,EntryScore,ExamCount,ResumeText,ReceiverUserDesc,ConfirmStatus,MessageTitle)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetMessagesByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessagesByEpisodeIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetMessagesByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessagesByEpisodeIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).CreateQualityMessages("Test Message^65|66|67^83")
ClassMethod CreateQualityMessages(AParams As %String) As %String
{
	s ret = 0, flag = 1
	q:(AParams = "") ret
	
	s MessageBody  = $p(AParams,"^",1)
	s MessageBody = ##Class(EPRservice.Util.CharacterEncoding).UnEscape(MessageBody)
	s EpisodeIDs   = $p(AParams,"^",2)
	s CreateUserID = $p(AParams,"^",3)
	/*
	TStart
		
	s objMessage = ##Class(EPRinstance.Quality.QualityMessage).%New()
	s objMessage.CreateDate = $p($h,",",1)
	s objMessage.CreateTime = $p($h,",",2)
	s objMessage.CreateUserDR = CreateUserID
	s objMessage.MessageBody = MessageBody
	
	if '(objMessage.%Save())
 	{
	 	TRollBack
 		q ret
 	} 
 	
 	s MessageID = objMessage.%Id()
 	
 	d objMessage.%Close()
 	*/
 	s EpisodeIDList = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EpisodeIDs,"|")
 	for i = 1:1:$listlength(EpisodeIDList)
	{
		s EpisodeID = $listget(EpisodeIDList,i)
		continue:(EpisodeID = "")
		
		//发给医生
		s mainDocUserID = ##Class(EPRservice.Quality.DataGather.EPRInfo).GetMainDocIDByEpisodeID(EpisodeID)
		s attendDocUserID = ##Class(EPRservice.Quality.DataGather.EPRInfo).GetAttendDocIDByEpisodeID(EpisodeID)
		s params = MessageBody_"^"_EpisodeID_"^"_mainDocUserID_"^"_attendDocUserID_"^"_CreateUserID
		d ..CreateQualityMessagesToDoc(params,$listlength(EpisodeIDList))
		
		//s objRecipient = ##Class(EPRinstance.Quality.QualityMessageRecipient).%New()
 		//s objRecipient.EpisodeID = EpisodeID
 		//s objRecipient.MessageDR = MessageID
		
		//if '(objRecipient.%Save())
	 	//{
		// 	s flag = 0
	 	//	q
	 	//} 
	}	
 	
 	//if (flag = 0)
 	//{
	//	TRollBack 	
	//}
	//else
	//{
	//	TCommit
		s ret = 1	
	//}
	
	q ret
}

/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).CreateQualityMessagesToDoc("%u8840%u578B%u3001rh%u4E66%u5199%u6709%u9519%u8BEF%7B-10%u5206%7D^373^159^158^9")
ClassMethod CreateQualityMessagesToDoc(AParams As %String, AAction As %String = "", ASendNo As %String = "1") As %String
{
	//s ^CacheTemp("debug","Y","CreateQualityMessagesToDoc") = AParams
	s ret = 0, flag = 1
	q:(AParams = "") ret
	//s AParams =  $p(AParams,"||",1)
	s MessageBody  = $p(AParams,"^",1)
	s MessageBody = ##Class(EPRservice.Util.CharacterEncoding).UnEscape(MessageBody)
	s EpisodeID = $p(AParams,"^",2)
	s MainDocID = $p(AParams,"^",3)
	s AttendDocID = $p(AParams,"^",4)
	s CreateUserID = $p(AParams,"^",5)
	s InstanceId = $p(AParams,"^",6)
	s EmrDocId= $p(AParams,"^",7)
	s EntryScore = $p(AParams,"^",8)
	s ExamCount = $p(AParams,"^",9)
	s EntryID = $p(AParams,"^",10)
	s ResumeText = $p(AParams,"^",11)
	s:(ResumeText'="") MessageBody = MessageBody_"备注："_ResumeText
	s ResultDetailID = $p(AParams,"^",12)
	s Path=$p(AParams,"^",13)
	s CtLocDR=$p(AParams,"^",14)
	s UserID = ""
	s UserID = $o(^SSU("SSUSR",0,"CTPCP",MainDocID,UserID))
	s linkParam = "EpisodeId="_EpisodeID
	if ((MainDocID '= "")&&(AAction'["S"))
	{
		
		if (AAction = "A")
		{                                                                      
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"环节质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1008",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
		}
		elseif (AAction="D")
		{
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"终末质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1009",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27

		}elseif (AAction="MD")
		{
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"科室终末质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1009",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27

		}elseif (AAction="O")  //增加门诊消息
		{
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"门诊质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1008",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")
		}
		/*
		if (AAction = "A")
		{
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1008",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
		}
		elseif (AAction="D")
		{
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1009",CreateUserID,EpisodeID,"",UserID,OtherInfoJson)   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
		}*/
	}

	elseif ((MainDocID '= "")&&(AAction["S"))
	{
		if (AAction="BSF")
		{
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"编目质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1296",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27

		}else{
			s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,UserID,"首页质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
			s URL="dhc.emr.messagetab.csp?MessageID="_messageID
			s OtherInfoJson="{""link"":"""_URL_""",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 牛才才 2017-6-27
			d ##class(websys.DHCMessageInterface).Send(MessageBody,"1296",CreateUserID,EpisodeID,"",UserID,OtherInfoJson,"","","")   //增加后面三个参数ToLocRowId:接收消息的科室Id、EffectiveDays:消息有效天数、CreateLoc:发送者科室，add by 牛才才 2017-6-27
		}
	}
	if (AttendDocID '= "")
	{
		s MainDocName = ""
		if (MainDocID '= "")
		{
			s MainDocName=$p($g(^CTPCP(MainDocID,1)),"^",2)
		}
		s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(CreateUserID,AttendDocID,"医生《"_MainDocName_"》的质控消息",MessageBody,"QUALITY",EpisodeID,InstanceId,EmrDocId,EntryScore,ExamCount,EntryID,ResumeText,ResultDetailID,ASendNo,Path,CtLocDR)
		d ##class(websys.DHCMessageInterface).Send(MessageBody,"1008",CreateUserID,EpisodeID,"",AttendDocID,OtherInfoJson)
	}
	q "1"
}

/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).UpdateMessageRecipient("2","83")
ClassMethod UpdateMessageRecipient(ARecipientID As %String, AReadUserID As %String) As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).ReadMessage(ARecipientID,AReadUserID)
 	q ret
}

/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).UpdateMessageRecipient("2","83")
ClassMethod UpdateMessageDone(ARecipientID As %String, AReadUserID As %String) As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).DoneMessage(ARecipientID,AReadUserID)
 	q ret
}

/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetUnreadMsgCountByEpisodeID(201864)
ClassMethod GetUnreadMsgCountByEpisodeID(AEpisodeID As %String) As %Integer
{
	s ret = 0
	/*
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_AEpisodeID,RowID))
		q:(RowID = "")
	
		s objRecipient = $g(^DHCEPRQ.QualityMsgRecD(RowID))
		
		s ReadDate = $list(objRecipient,4)
		s ReadTime = $list(objRecipient,5)
		s ReadUserDR = $list(objRecipient,6)

		if (ReadDate = "") && (ReadTime = "") && (ReadUserDR = "")
		{
			s ret = ret + 1	
		}
	}
	*/
	//&sql(select count(*) into :ret from EPRinstance.EPRSingleMessage where EpisodeID = :AEpisodeID AND ReadFlag = "U")
	q ret
}

/// craater:  YHY
/// Create Date:	2017-06-12
/// Description:	根据就诊号查询环节质控消息状态
/// Return:         0:无缺陷  -1:有缺陷全部处理  >0:有缺陷
/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageFlagByEpisodeID(112)
ClassMethod GetMessageFlagByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = 0
	s RowID = ""
	s result = ""
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_AEpisodeID,RowID),-1)
		q:RowID=""
		s result = 1
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		s MsgStatus = msgObj.ExecuteFlag 
		continue:MsgStatus="E"
		s ret = ret + 1
	}
	s:((result=1)&&(ret=0)) ret = -1
	q ret
}

/// craater:  YHY
/// Create Date:	2017-06-12
/// Description:	根据就诊号Entryid 查询消息状态
/// Return:         0:无缺陷  -1:有缺陷全部处理  >0:有缺陷
/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageFlagByEpisodeIDEntryID(112)
ClassMethod GetMessageFlagByEpisodeIDEntryID(AEpisodeID As %String, AEntryID As %String) As %String
{
	
	s RowID = ""
	s result = ""
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeIDEntryID"," "_AEpisodeID," "_AEntryID,RowID),-1)
		q:RowID=""
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		s MsgStatus = msgObj.ExecuteFlag 
		s Confim = msgObj.ConfirmFlag
		s:MsgStatus="E" result="处理"_"^"_RowID
		s:MsgStatus'="E" result="缺陷"_"^"_RowID
		s:Confim="C" result="完成"_"^"_RowID
		//b ;1
	}
	
	q result
}

/// craater:  YHY
/// Create Date:	2017-06-12
/// Description:	根据就诊号查询首页缺陷个数
/// Return:         0:无缺陷  -1:有缺陷全部处理  >0:有缺陷
/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetSMessageFlagByEpisodeID(17933720)
ClassMethod GetSMessageFlagByEpisodeID(AEpisodeID As %String, Action As %String) As %String
{
	s ret = 0
	s RowID = ""
	s result = ""
	k ^CacheTemp("DHCEPRQQualitySY")
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_AEpisodeID,RowID))
		q:RowID=""
		s result = 1
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		s MsgStatus = msgObj.ConfirmFlag
		s entryid = msgObj.EntryID
		s resumetext = msgObj.ResumeText
		s:resumetext="" resumetext=1
		s ResultDetailID=msgObj.ResultDetailID
		s action=$list($g(^DHCEPRQ.QualityResultD($p(ResultDetailID,"||",1))),15)
		continue:(Action'="")&&(Action'=action)
		s:$l(resumetext="")>100 resumetext=$e(resumetext,1,100)
		continue:MsgStatus="C"
		continue:(msgObj.MessageTitle'["首页")
		
		s ^CacheTemp("DHCEPRQQualitySY",AEpisodeID,entryid,resumetext)=AEpisodeID
		//s ret = ret + 1
	}
	
	s Entryid = ""
	for {
		s Entryid = $o(^CacheTemp("DHCEPRQQualitySY",AEpisodeID,Entryid))
		q:Entryid=""
		s Resumetext = ""
		for {
			s Resumetext = $o(^CacheTemp("DHCEPRQQualitySY",AEpisodeID,Entryid,Resumetext))
			q:Resumetext=""
			s ret = ret + 1
		}
	}
	s:((result=1)&&(ret=0)) ret = 0
	q ret
}

/// Create Date:	2022-08-09
/// Description:	根据就诊号查询首页缺陷总数、未处理数
/// Return:         Total 首页缺陷总数 QNum 未处理数
/// w ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetSMessageTotalByEpisodeID(621,"KS")
ClassMethod GetSMessageTotalByEpisodeID(AEpisodeID As %String, Action As %String = "") As %String
{
	s ret = 0
	s RowID = ""
	s result = "",Total=0,QNum=0
	k ^CacheTemp("DHCEPRQQualitySY")
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_AEpisodeID,RowID))
		q:RowID=""
		s result = 1
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		s MsgStatus = msgObj.ConfirmFlag
		s entryid = msgObj.EntryID
		s ResultDetailID=msgObj.ResultDetailID
		continue:ResultDetailID=""
		s action=$list($g(^DHCEPRQ.QualityResultD($p(ResultDetailID,"||",1))),15)
		continue:(Action'="")&&(Action'=action)
		s resumetext = msgObj.ResumeText
		s:resumetext="" resumetext=1
		s:$l(resumetext="")>100 resumetext=$e(resumetext,1,100)
		continue:(msgObj.MessageTitle'["首页")
		s Total=Total+1
		continue:MsgStatus="C"
		s ^CacheTemp("DHCEPRQQualitySY",AEpisodeID,ResultDetailID)=AEpisodeID
		
	}
	
	s DetailID = ""
	for {
		s DetailID = $o(^CacheTemp("DHCEPRQQualitySY",AEpisodeID,DetailID))
		q:DetailID=""
		s QNum = QNum + 1
		
	}
	s result=Total_"^"_QNum
	q result
}

/// creator:lingchen
/// 获取最新的病程记录
ClassMethod GetEMRRecordInfo(AEpsoidID, ACategoryID As %String) As %String
{
	s ret = ""
	q:(""=AEpsoidID)||(""=ACategoryID) ret
	s ECRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpsoidID, " "_ACategoryID, ""))
	q:(""=ECRecordID) ret
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ECRecordID)
	s count = objECRecord.InstanceCount
	
	for 
	{
		q:(0=count)
		s objInstance = objECRecord.Instances.GetAt(count)
		if ("Save" = objInstance.Status)
		{
			s createDT = $ZD(objInstance.CreateDate, 3)_" "_$ZT(objInstance.CreateTime, 1)
			s title = objInstance.Title
			s ret = createDT_" "_title
			q
		}
		s count = count -1
	}
	q ret
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityMessage","GetMessageNewByEpisodeID","66")
Query GetMessageNewByEpisodeID(AEpisodeID As %String, AMsgStatus As %String = "") As %Query(ROWSPEC = "RowID,CreateDateTime,CreateUserDesc,MessageBody,ExecuteDateTime,ExecuteUserDesc,ExecuteStatus,StructName,EntryScore,ExamCount,ResumeText,Score")
{
}

ClassMethod GetMessageNewByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AMsgStatus As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s EpisodeID = $g(AEpisodeID)
	q:(EpisodeID="") $$$OK
	
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_EpisodeID,RowID),-1)
		q:RowID=""
		s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
		q:msgObj=""
		s EffectiveFlag = msgObj.EffectiveFlag
		continue:EffectiveFlag="T"
		s CreateDate = msgObj.CreateDate
		s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
		s CreateTime = msgObj.CreateTime
		s:(CreateTime '= "") CreateTime = $zt(CreateTime)
		s CreateDateTime = CreateDate_" "_CreateTime
		s MessageBody = msgObj.Message
		s ResumeText = msgObj.ResumeText
		s:(MessageBody'["备注") MessageBody= MessageBody_" 备注："_ResumeText
		s ReadDate = msgObj.ReadDate
		s:(ReadDate '= "") ReadDate = $zd(ReadDate,3)
		s ReadTime = msgObj.ReadTime
		s:(ReadTime '= "") ReadTime = $zt(ReadTime)
		s SenderUserID = msgObj.SenderUserID
		//s CreateUserDesc = ##class(EPRservice.BLL.BLEPRMessage).GetUserNameByUserID(SenderUserID)
		s:(SenderUserID '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+SenderUserID)),"^",2)
		s ReadUser = msgObj.ReadUserID
		s ReadUserDesc = ""
		s:(ReadUser '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUser)),"^",2)
		s ReadStatus = "未读"
		s:(msgObj.ReadFlag = "R") ReadStatus = "已读"
		s ExecuteDate = msgObj.ExecuteDate
		s:(ExecuteDate '= "") ExecuteDate = $zd(ExecuteDate,3)
		s ExecuteTime = msgObj.ExecuteTime
		s:(ExecuteTime '= "") ExecuteTime = $zt(ExecuteTime)
		s ExecuteDateTime = ExecuteDate_" "_ExecuteTime
		s ExecuteUser = msgObj.ExecuteUserID
		s ExecuteUserDesc = ""
		s:(ExecuteUser '= "") ExecuteUserDesc = $p($g(^SSU("SSUSR",+ExecuteUser)),"^",2)
		s ExecuteStatus = "未执行"
		s:(msgObj.ExecuteFlag = "E") ExecuteStatus = "已执行"
		continue:(AMsgStatus'="")&&(msgObj.ExecuteFlag'=AMsgStatus)
		s EntryID = msgObj.EntryID
		s StructID = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructByID(EntryID)
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructID) 
		s EntryScore = msgObj.EntryScore
		s ExamCount = msgObj.ExamCount
		s Score = ""
		s:(ExamCount'="")&&(ExamCount>1) Score = EntryScore*ExamCount
		s:(ExamCount=1) Score = EntryScore
		
		s Data = $lb(RowID,CreateDateTime,CreateUserDesc,MessageBody,ExecuteDateTime,ExecuteUserDesc,ExecuteStatus,StructName,EntryScore,ExamCount,ResumeText,Score)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetMessageNewByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageNewByEpisodeIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetMessageNewByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageNewByEpisodeIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Des:		获取消息流程图信息
/// Creator:	QY
/// Input:		MessageId
/// Optput:		发送、阅读、处理、修复信息
/// Debug:		##class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageStepByMesId(23)
ClassMethod GetMessageStepByMesId(AMessageId As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AMessageId = "") json
	
	s objMessage = ##Class(EPRinstance.EPRSingleMessage).%OpenId(AMessageId)
	q:(objMessage = "") json
	
	// 发送
	s SenderUserID = objMessage.SenderUserID
	s SenderUserobj = ##Class(User.SSUser).%OpenId(SenderUserID)
	s SenderUser = SenderUserobj.SSUSRName
	s CreateDate = $zd(objMessage.CreateDate,3)
	s CreateTime = $zt(objMessage.CreateTime)
	s CreateDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
	//s doc = AYU
	s ReceiverUserID = objMessage.ReceiverUserID
	s ReceiverUserobj = ##Class(User.SSUser).%OpenId(ReceiverUserID)
	s ReceiverUser = ReceiverUserobj.SSUSRName
		
	// 医生阅读
	s ReadUserID = objMessage.ReadUserID
	if (ReadUserID="")
	{

		s ReadUser = ""
		s ReadDate = ""
		s ReadTime = ""
	}
	else
	{
	s ReadUserobj = ##Class(User.SSUser).%OpenId(ReadUserID)
	s ReadUser = ReadUserobj.SSUSRName
	s ReadDate = $zd(objMessage.ReadDate,3)
	s ReadTime = $zt(objMessage.ReadTime)
	s ReadDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ReadDate)
	}

	// 医生处理
	s ExecuteUserID = objMessage.ExecuteUserID
	if (ExecuteUserID="")
	{
		s ExecuteUser = ""
		s ExecuteDate = ""
		s ExecuteTime = ""
	}
	else
	{
		s ExecuteUserobj = ##Class(User.SSUser).%OpenId(ExecuteUserID)
		s ExecuteUser = ExecuteUserobj.SSUSRName
		s ExecuteDate = $zd(objMessage.ExecuteDate,3)
		s ExecuteTime = $zt(objMessage.ExecuteTime)
		s ExecuteDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ExecuteDate)
	}
	
	// 确认修复
	s ConfirmUserID = objMessage.ConfirmUserID
	if (ConfirmUserID="")
	{
		s ConfirmUser = ""
		s ConfirmDate = ""
		s ConfirmTime = ""
	}
	else
	{
		s ConfirmUserobj = ##Class(User.SSUser).%OpenId(ConfirmUserID)
		s ConfirmUser = ConfirmUserobj.SSUSRName
		s ConfirmDate = $zd(objMessage.ConfirmDate,3)
		s ConfirmTime = $zt(objMessage.ConfirmTime)
		s ConfirmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ConfirmDate)
	}
	
	s tjson = ""
	s tjson = tjson_"{"
	s tjson = tjson_"""title"":"""_"发送"_""""
	s tjson = tjson_",""context"":"""_"<div>操作人:"_SenderUser_"</div><div>"_CreateDate_" "_CreateTime_"</div>"_""""
	s tjson = tjson_"},"
	s tjson = tjson_"{"
	s tjson = tjson_"""title"":"""_"阅读"_""""
	s:(ReadUser="") tjson = tjson_",""context"":"""_""_""""
	s:(ReadUser'="") tjson = tjson_",""context"":"""_"<div>操作人:"_ReadUser_"</div><div>"_ReadDate_" "_ReadTime_"</div>"_""""
	s tjson = tjson_"},"
	s tjson = tjson_"{"
	s tjson = tjson_"""title"":"""_"处理"_""""
	s:(ExecuteUser="") tjson = tjson_",""context"":"""_""_""""
	s:(ExecuteUser'="") tjson = tjson_",""context"":"""_"<div>操作人:"_ExecuteUser_"</div><div>"_ExecuteDate_" "_ExecuteTime_"</div>"_""""
	s tjson = tjson_"},"
	s tjson = tjson_"{"
	s tjson = tjson_"""title"":"""_"确认"_""""
	s:(ConfirmUser="") tjson = tjson_",""context"":"""_""_""""
	s:(ConfirmUser'="") tjson = tjson_",""context"":"""_"<div>操作人:"_ConfirmUser_"</div><div>"_ConfirmDate_" "_ConfirmTime_"</div>"_""""
	s tjson = tjson_"}"
	
	s tjson = $ZSTRIP(tjson,"*C")	
	s tjson="["_tjson_"]"	
		
	d json.Write(tjson)
	q json
}

}
