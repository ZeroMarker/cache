Class EPRservice.BLL.BLEPRMessage Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// w ##Class(EPRservice.BLL.BLEPRMessage).DHCRunClassMethod("##Class(EPRservice.BLL.BLEPRMessage).CheckNewMessage")

ClassMethod DHCRunClassMethod(ActionName As %String, Param As %String = "") As %String
{
	q:ActionName="" ""
	s CommandStr="retStr="_ActionName_"("_Param_")"
	s @CommandStr
	//XECUTE CommandStr
	q retStr
}

// w ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage("1","159","消息测试1","消息测试1内容：片饿哦如我就洒到了附近啊的进来撒发动机","QUALITY")

ClassMethod SendFirstMessage(ASender As %String, AReceiver As %String, AMessageTitle As %String, AMessage As %String, AMessageSource As %String, AEpisodeID As %String, AInstanceId As %String, AEmrDocId As %String, AEntryScore As %String, AExamCount As %String, AEntryID As %String, AResumeText As %String, AResultDetailID As %String, ASendNo As %String = "1", APath As %String = "", CtLocDR As %String, AMessageType As %String = "SEND", AMessagePriority As %String = "N", AEffectiveType As %String = "L") As %String
{
	
	s:(ASender = $c(0)) ASender = ""
	s:(AReceiver = $c(0)) AReceiver = ""
	s:(AMessageTitle = $c(0)) AMessageTitle = ""
	s:(AMessage = $c(0)) AMessage = ""
	s:(AMessageSource = $c(0)) AMessageSource = ""
	q:((ASender = "") || (AReceiver = "") || (AMessageTitle = "") || (AMessage = "") || (AMessageSource = "")) "-1"
	
	s messageGroupObj = ##class(EPRinstance.EPRMessageGroup).%New()
	s messageGroupObj.UserIDS = ASender_"^"_AReceiver
	s sc = messageGroupObj.%Save()
	s messageGroupID = messageGroupObj.%Id()
	d messageGroupObj.%Close()
	
	s messageObj = ##class(EPRinstance.EPRSingleMessage).%New()
	s messageObj.CreateDate = $p($h,",",1)
	s messageObj.CreateTime = $p($h,",",2)
	s messageObj.EffectiveFlag = AEffectiveType
	s messageObj.MessagePrioriry = AMessagePriority
	s messageObj.Message = AMessage
	s messageObj.MessageTitle = AMessageTitle
	s messageObj.SenderUserID = ASender
	s messageObj.ReceiverUserID = AReceiver
	s messageObj.MessageGroupID = messageGroupID
	s messageObj.MessageType = AMessageType
	s messageObj.ReadFlag = "U"
	s messageObj.ExecuteFlag = "U"
	s messageObj.ConfirmFlag = "U"
	s messageObj.MessageSource = AMessageSource
	s messageObj.EpisodeID = AEpisodeID
	s messageObj.InstanceId = AInstanceId
	s messageObj.EmrDocId = AEmrDocId
	s messageObj.EntryScore = AEntryScore
	s messageObj.EntryID = AEntryID
	s messageObj.ExamCount = AExamCount
	s messageObj.ResumeText = AResumeText
	s messageObj.ResultDetailID = AResultDetailID
	s messageObj.SendNo = ASendNo
	s messageObj.Path=APath
	s messageObj.CtLocDR=CtLocDR
	s sc = messageObj.%Save()
	s messageID = messageObj.%Id()
	//运行态病历查询、手工评分录入页面中，发送消息给电子病历、主管主治医生时，推送数据给信息平台
	s IsSetToPortal = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("IsSetToPortal")
	s IsSetToPortal = $ZCVT(IsSetToPortal,"U")
	if (IsSetToPortal = "Y")
	{
		d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000022",messageID,"1",AEpisodeID)
	}
	d messageObj.%Close()
	q:($$$ISOK(sc)) messageID
	q "-1"
}

/// 读回调配置：EPRservice.BLL.BLEPRMessage.AReadMessage
/// w ##class(EPRservice.BLL.BLEPRMessage).AReadMessage(EpisodeId,OrdItemId,BizObjId,ReadUserRowId,ReadDate,ReadTime)
ClassMethod AReadMessage(EpisodeId As %String, OrdItemId As %String, BizObjId As %String, ReadUserRowId As %String, ReadDate As %String = "", ReadTime As %String = "") As %String
{
    s ret="-1"
    q:(BizObjId="")||(ReadUserRowId="") ret

    s ret=..ReadMessage(BizObjId,ReadUserRowId)
    q ret
}

ClassMethod ReadMessage(AMessageIDS As %String, AReadUserID As %String = "") As %String
{
	s count = $l(AMessageIDS,"^")
	for index=1:1:count
	{
		s messageID = $p(AMessageIDS,"^",index)
		s messageObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)
		q:(messageObj = "")
		q:(messageObj.ReadFlag="R")
		s messageObj.ReadFlag = "R"
		s messageObj.ReadDate = $p($h,",",1)
		s messageObj.ReadTime = $p($h,",",2)
		s messageObj.ReadUserID = AReadUserID
		s:((AReadUserID'="") && (messageObj.ReceiverUserID = "")) messageObj.ReceiverUserID = AReadUserID
		
		s sc = messageObj.%Save()
		d messageObj.%Close()
	}
	q "1"
}

ClassMethod DoneMessage(AEpisodeID As %String, AMessageIDS As %String, AExecuteUserID As %String = "", Appeal As %String = "") As %String
{
	
	TStart
	d ..ReadMessage(AMessageIDS, AExecuteUserID)
	s flag = "1"
	s count = $l(AMessageIDS,"^")
	for index=1:1:count
	{
		s messageID = $p(AMessageIDS,"^",index)
		s messageObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)
		q:(messageObj = "")
		
		s messageObj.ExecuteFlag = "E"
		s messageObj.AppealText=Appeal
		s messageObj.ExecuteDate = $p($h,",",1)
		s messageObj.ExecuteTime = $p($h,",",2)
		s messageObj.ExecuteUserID = AExecuteUserID
		s:((AExecuteUserID'="") && (messageObj.ReceiverUserID = "")) messageObj.ReceiverUserID = AExecuteUserID
		
		s sc = messageObj.%Save()
		if ($$$ISOK(sc))
		{
			s Artn=##class(websys.DHCMessageInterface).Exec("","1008","","",messageID,AExecuteUserID,"","")
			s Drtn=##class(websys.DHCMessageInterface).Exec("","1009","","",messageID,AExecuteUserID,"","")
                                                s Srtn=##class(websys.DHCMessageInterface).Exec("","1296","","",messageID,AExecuteUserID,"","")
			if ((Artn <= 0)&&(Drtn <= 0)&&(Srtn<=0))
			{
				s flag = "0"
			}
			s ret = ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageFlagByEpisodeID(AEpisodeID)
			if (ret=-1)
			{
		
				s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
				s objSpotCheck = ##Class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
				continue:(RowID="")
				s objSpotCheck.IsMessageActive = 2
				s sc = objSpotCheck.%Save()
				if ('$$$ISOK(sc))
				{
					s flag = -1
					q	
				}
			}
		}
		else
		{
			s flag = "0"
		}
		
		d messageObj.%Close()
	}
	if (flag = "0")
	{
		TRollback
		q "-1"
	}
	TCommit
	
	q "1"
}

/// ADD BY YHY
/// 2017-11-06
ClassMethod ConfirmMessage(AMessageIDS As %String, AConfirmUserID As %String = "") As %String
{
	//d ..ReadMessage(AMessageIDS, AExecuteUserID)
	s count = $l(AMessageIDS,"^")
	for index=1:1:count
	{
		s messageID = $p(AMessageIDS,"^",index)
		s messageObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)
		q:(messageObj = "")
		
		s messageObj.ConfirmFlag = "C"
		s messageObj.ConfirmDate = $p($h,",",1)
		s messageObj.ConfirmTime = $p($h,",",2)
		s messageObj.ConfirmUserID = AConfirmUserID
		//s:((AExecuteUserID'="") && (messageObj.SenderUserID = "")) messageObj.SenderUserID = AConfirmUserID
		
		s sc = messageObj.%Save()
		d messageObj.%Close()
	}
	q "1"
}

/// ADD BY YHY
/// 2018-05-15
ClassMethod CancelMessage(AMessageIDS As %String, AConfirmUserID As %String = "") As %String
{
	s ret = 0
	q:(AMessageIDS = "") ret
	s flag = 1
	TStart
	s count = $l(AMessageIDS,"^")
	for index=1:1:count
	{
		s messageID = $p(AMessageIDS,"^",index)
		s messageObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)
		q:(messageObj = "")
		s messageObj.EffectiveFlag = "T"
		s messageObj.EffectiveDate = $p($h,",",1)
		s messageObj.EffectiveTime = $p($h,",",2)
		s ResultDetailID = messageObj.ResultDetailID
		s deleteret = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).DeleteManualResult(ResultDetailID)
		s:deleteret'=1 flag=0
		q:flag=0
		s sc = messageObj.%Save()
		d messageObj.%Close()
	}
	if (flag = 1)
	{
		TCommit	
		s ret = 1
	}
	elseif (flag=0)
	{
		TRollback
		s ret = 0	
	}
	q ret
}

/// ADD BY HKY
/// 2021-02-23
ClassMethod Recallmmessage(AMessageIDS As %String, ARecallUserID As %String = "") As %String
{
	s ret = 0
	q:(AMessageIDS = "") ret
	s flag = 1
	TStart
	s count = $l(AMessageIDS,"^")
	for index=1:1:count
	{
		s messageID = $p(AMessageIDS,"^",index)
		s messageObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(messageID)
		s:(messageObj="") flag=0
		q:(messageObj = "")
		s messageObj.EffectiveFlag = "T"
		s messageObj.EffectiveDate = $p($h,",",1)
		s messageObj.EffectiveTime = $p($h,",",2)
		s EpisodeID = messageObj.EpisodeID
		s UserID=messageObj.ReceiverUserID
		s sc = messageObj.%Save()
		d messageObj.%Close()
		s linkParam = "EpisodeId="_EpisodeID
		s OtherInfoJson="{""link"":""dhc.emr.messagetab.csp"",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 黄克怡 2019-02-16
        d ##class(websys.DHCMessageInterface).Cancel(UserID,"1008",EpisodeID,"",OtherInfoJson,ARecallUserID,"","")
	}
	if (flag = 1)
	{
		TCommit	
		s ret = 1
	}
	elseif (flag=0)
	{
		TRollback
		s ret = 0	
	}
	q ret
}

/// w ##Class(EPRservice.BLL.BLEPRMessage).CheckNewMessage("5972^^")
ClassMethod CheckNewMessage(Param As %String = "") As %String
{
	s retStr=""
	s userId=$P(Param,"^",1)
	s groupId=$P(Param,"^",2)
	s ctLocId=$P(Param,"^",3)
	s nowDate=+$H
	
	s count = 0

	//有未读并长期有效则需要提示
	s rowID = ""
	for {
		s rowID = $O(^EPRinstance.EPRSingleMessageI("IdxReceiverFlagUserID", " "_userId, " N"," U"," L",rowID))
		q:(rowID = "")
			
		s count = count + 1
	}
	//没有未读长期有效，查看是否有未读的在有效期内的消息
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRQ.EPRSingleMessageI("IdxReceiverFlagUserID", " "_userId, " N"," U"," T",rowID)) 
		q:(rowID = "")
		s obj = ##class(EPRinstance.EPRSingleMessage).%OpenId(rowID)
		s effectiveDate = obj.EffectiveDate
		s effectiveTime = obj.EffectiveTime
		if ((effectiveDate > $p(nowDate,",",1)) || ((effectiveDate = $p(nowDate,",",1)) && (effectiveTime > $p(nowDate,",",2))))
		{
			//在有效期内
			s count = count + 1
		}
	}
	
	if (count > 0)
	{
		s retStr = "有"_count_"条电子病历新消息"	
	}
	q retStr
}

/// Debug: w ##class(EPRservice.BLL.BLEPRMessage).GetUserNameByUserID("5972")
ClassMethod GetUserNameByUserID(AUserID As %String) As %String
{
	s userName = ""
	//&sql(select SSUSR_Name into :userName from SQLUser.SS_User where SSUSR_RowId = :AUserID)
	q userName
}

/// Debug: d ##class(%ResultSet).RunQuery("EPRservice.BLL.BLEPRMessage","GetMessageByUserID","17314","N","","U","U","E","RECEIVE")
Query GetMessageByUserID(AUserID As %String, AMessagePrioriry As %String, ARead As %String, AExecute As %String, AConfirm As %String, AEffective As %String, AUserType As %String = "RECEIVE", ACreateDateStart As %String = "", ACreateDateEnd As %String = "", AHospitalID As %String = "", AMessageDesc As %String = "", LocID As %String = "") As %Query(ROWSPEC = "MessageID:%String,AppealText:%String,SenderUserID:%String,SenderUserName:%String,ReceiverUserID:%String,ReceiverUserName:%String,MessageTitle:%String,Message:%String,ReadFlag:%String,ReadDate:%String,ReadTime:%String,ExecuteFlag:%String,ExecuteDate:%String,ExecuteTime:%String,Effective:%String,EffectiveFlag:%String,EffectiveDate:%String,EffectiveTime:%String,CreateDate:%String,CreateTime:%String,MessageGroupID:%String,MessageType:%String,MessageSource:%String,MessagePrioriry:%String,EpisodeID:%String,InstanceId,EmrDocId,Name,ACKID:%String,Execute,PatientID,Path,CtLocName,LocID")
{
}

ClassMethod GetMessageByUserIDExecute(ByRef qHandle As %Binary, AUserID As %String, AMessagePrioriry As %String, ARead As %String, AExecute As %String, AConfirm As %String, AEffective As %String, AUserType As %String = "RECEIVE", ACreateDateStart As %String = "", ACreateDateEnd As %String = "", AHospitalID As %String = "", AMessageDesc As %String = "", LocID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	if (AUserType = "RECEIVE" )
 	{
		s DataIndex = "IdxReceiverUserID"
 	}
 	else
 	{
	 	//AUserType = "SEND"
		s DataIndex = "IdxSenderUserID"	
	}
 	
 	s TempCreateDate = ""
 	s:(ACreateDateEnd '= "") TempCreateDate = ACreateDateEnd + 1

	s Read=""
	for{
		s Read = $o(^DHCEPRQ.EPRSingleMessageI(DataIndex," "_AUserID," "_AMessagePrioriry,Read ),-1)
		q:(Read = "")
		continue:'(ARead'="")&&(ARead[$tr(Read," ",""))
		
 	for {
	 	
		s TempCreateDate = $o(^DHCEPRQ.EPRSingleMessageI(DataIndex," "_AUserID," "_AMessagePrioriry, Read, " "_AExecute, TempCreateDate),-1)
	    
		q:(TempCreateDate = "")
	    
		continue:((ACreateDateStart '= "") && (TempCreateDate < ACreateDateStart))
		
		s TempCreateTime = ""
		for {
			s TempCreateTime = $o(^DHCEPRQ.EPRSingleMessageI(DataIndex," "_AUserID," "_AMessagePrioriry, Read, " "_AExecute, TempCreateDate,TempCreateTime),-1)
			q:(TempCreateTime = "")
			
		 	s rowID = ""
		 	for { 
			 	s rowID = $o(^DHCEPRQ.EPRSingleMessageI(DataIndex," "_AUserID," "_AMessagePrioriry, Read, " "_AExecute, TempCreateDate,TempCreateTime,rowID),-1)
			 	q:(rowID = "")
				
			 	s MessageID = rowID
				s messageEObj = ##Class(EPRinstance.EPRSingleMessage).%OpenId(rowID)
	
				s ReadFlag = messageEObj.ReadFlag
				s ReadDate = messageEObj.ReadDate
				s ReadTime = messageEObj.ReadTime
				if (ReadDate '= "")
				{
					s ReadDate = $zd(ReadDate,3)
					s ReadDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ReadDate)
					s ReadTime = $zt(ReadTime,3)
					s ReadTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ReadTime)
				}
				s ExecuteFlag = messageEObj.ExecuteFlag
				s:ExecuteFlag="U" Execute = "未处理"
				s:ExecuteFlag="E" Execute = "已处理"
				Set langid=20
		        if ($d(%session)){
			    set langid=+$g(%session.Data("LOGON.LANGID"))
		        }
		        s Execute = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRinstance.EPRSingleMessage","ExecuteFlag",Execute,langid)
				s ExecuteDate = messageEObj.ExecuteDate
				s ExecuteTime = messageEObj.ExecuteTime
				s AppealText = messageEObj.AppealText
				if (ExecuteDate '= "")
				{
					s ExecuteDate = $zd(ExecuteDate,3)
					s ExecuteDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ExecuteDate)
					s ExecuteTime = $zt(ExecuteTime,3)
					s ExecuteTime =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ExecuteTime)
				}
				
				s EffectiveFlag = messageEObj.EffectiveFlag
				s EffectiveDate = messageEObj.EffectiveDate
				s EffectiveTime = messageEObj.EffectiveTime
				s Effective = "false"
				s:((EffectiveFlag = "T")&&(EffectiveDate > $p($h,",",1))) Effective = "true"
				s:((EffectiveFlag = "T")&&(EffectiveDate = $p($h,",",1))&&(EffectiveTime > $p($h,",",2))) Effective = "true"
				s:(EffectiveFlag = "L") Effective = "true"
				
				if (EffectiveDate '= "")
				{
					s EffectiveDate = $zd(EffectiveDate,3)
					s EffectiveDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",EffectiveDate)
					s EffectiveTime = $zt(EffectiveTime,3)
					s EffectiveTime =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",EffectiveTime)
				}
				
				continue:((Effective = "false") && (AEffective = "E"))
				s CreateDate = $zd(messageEObj.CreateDate,3)
				s CreateDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
				s CreateTime = $zt(messageEObj.CreateTime,3)
				s CreateTime =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",CreateTime)
				s ConfirmFlag = messageEObj.ConfirmFlag
				
				continue:(ConfirmFlag'=AConfirm)
				s SenderUserID = messageEObj.SenderUserID
				//s SenderUserName = ..GetUserNameByUserID(SenderUserID)
				s SenderUserName = $p($g(^SSU("SSUSR",SenderUserID)),"^",2)
				s ReceiverUserID = messageEObj.ReceiverUserID
				//s ReceiverUserName = ..GetUserNameByUserID(ReceiverUserID)
				s ReceiverUserName = $p($g(^SSU("SSUSR",ReceiverUserID)),"^",2)
				s Message = messageEObj.Message
				continue:(AMessageDesc'="")&&(Message'[AMessageDesc)
				s MessageTitle = messageEObj.MessageTitle
				s MessageTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRinstance.EPRSingleMessage","MessageTitle",MessageTitle,langid)
				s MessageGroupID = messageEObj.MessageGroupID
				s MessageType = messageEObj.MessageType
				s CtLocDR=messageEObj.CtLocDR
                                                               continue:(LocID'="")&&(LocID'=CtLocDR)
				s CtLocName = $p($g(^CTLOC(+CtLocDR)),"^",2)
				s:(CtLocName [ "-") CtLocName = $p(CtLocName,"-",2)
				s MessageSource = messageEObj.MessageSource
				s messageSourceID = $o(^EPRmeta.EPRMessageSourceI("IdxMain"," "_MessageSource,""))
				s messageSourceObj = ##class(EPRmeta.EPRMessageSource).%OpenId(messageSourceID)
				s MessageSource = messageSourceObj.ActionName
				s MessageSource = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRinstance.EPRSingleMessage","MessageSource",$tr(MessageSource," ",""),langid)
				s MessagePrioriry = messageEObj.MessagePrioriry
				s EpisodeID = messageEObj.EpisodeID
				s:EpisodeID'="" mCurrRow = $g(^PAADM(EpisodeID))
				//数据保护，防止出现未清数据导致的错误信息。
				continue:(mCurrRow="")
				s PAADMDepCode=$p($g(mCurrRow),"^",4)
	            s objCtLoc = $g(^CTLOC(+PAADMDepCode))
		        s HspID = $P(objCtLoc,"^",22)
		        continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)  
				s PatientID = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
				s PAPMIDR = $p($g(mCurrRow),"^",1)
				s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
				s InstanceId = messageEObj.InstanceId
				s EmrDocId = messageEObj.EmrDocId
				s ACKID = messageEObj.ACKID
	            s Path=messageEObj.Path
	            
				s data = $lb(MessageID,AppealText,SenderUserID,SenderUserName,ReceiverUserID,ReceiverUserName,MessageTitle,Message,ReadFlag,ReadDate,ReadTime,ExecuteFlag,ExecuteDate,ExecuteTime,Effective,EffectiveFlag,EffectiveDate,EffectiveTime,CreateDate,CreateTime,MessageGroupID,MessageType,MessageSource,MessagePrioriry,EpisodeID,InstanceId,EmrDocId,Name,ACKID,Execute,PatientID,Path,CtLocName,CtLocDR)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1
		 	}
		}
	 }
	 }

	Quit $$$OK
}

ClassMethod GetMessageByUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageByUserIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetMessageByUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageByUserIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug: w ##class(EPRservice.BLL.BLEPRMessage).UpdateOldQualityMessage("5972")
ClassMethod UpdateOldQualityMessage(ASender As %String, AReceiver As %String, ACreateDate As %Date, ACreateTime As %Time, AReadDate As %Date, AReadTime As %Time, AMessageTitle As %String, AMessage As %String, AMessageSource As %String, AEpisodeID As %String, AMessageType As %String = "SEND", AMessagePriority As %String = "N", AEffectiveType As %String = "L") As %String
{
	
	s messageGroupObj = ##class(EPRinstance.EPRMessageGroup).%New()
	s messageGroupObj.UserIDS = ASender_"^"_AReceiver
	s sc = messageGroupObj.%Save()
	s messageGroupID = messageGroupObj.%Id()
	d messageGroupObj.%Close()
	
	s messageObj = ##class(EPRinstance.EPRSingleMessage).%New()
	s messageObj.CreateDate = ACreateDate
	s messageObj.CreateTime = ACreateTime
	s messageObj.EffectiveFlag = AEffectiveType
	s messageObj.MessagePrioriry = AMessagePriority
	s messageObj.Message = AMessage
	s messageObj.MessageTitle = AMessageTitle
	s messageObj.SenderUserID = ASender
	s messageObj.ReceiverUserID = AReceiver
	s messageObj.MessageGroupID = messageGroupID
	s messageObj.MessageType = AMessageType
	s messageObj.ReadFlag = "U"
	s messageObj.MessageSource = "QUALITY"
	s messageObj.EpisodeID = AEpisodeID
	if (AReadDate '="")
	{
		s messageObj.ReadDate = AReadDate
		s messageObj.ReadTime = AReadTime
		s messageObj.ReadFlag = "R"	
		s messageObj.ReadUserID = AReceiver
	}
	else
	{
		s messageObj.ReadFlag = "U"	
	}
	s messageObj.ExecuteFlag = "U"	
	s sc = messageObj.%Save()
	s messageID = messageObj.%Id()
	d messageObj.%Close()
	q:($$$ISOK(sc)) messageID
	q "-1"
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityMessage","GetMessagesByEpisodeID","66")
Query GetMessagesByEpisodeID(AEpisodeID As %String, AMsgStatus As %String = "") As %Query(ROWSPEC = "RowID,CreateDate,CreateTime,CreateUserDesc,MessageBody,ReadDate,ReadTime,ReadUserDesc,ReadStatus,ExecuteDate,ExecuteTime,ExecuteUserDesc,ExecuteStatus")
{
}

ClassMethod GetMessagesByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AMsgStatus As %String = "") As %Status
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
		s CreateDate = msgObj.CreateDate
		s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
		s CreateTime = msgObj.CreateTime
		s:(CreateTime '= "") CreateTime = $zt(CreateTime,3)
		s MessageBody = msgObj.Message
		s ReadDate = msgObj.ReadDate
		s:(ReadDate '= "") ReadDate = $zd(ReadDate,3)
		s ReadTime = msgObj.ReadTime
		s:(ReadTime '= "") ReadTime = $zt(ReadTime,3)
		s SenderUserID = msgObj.SenderUserID
		s CreateUserDesc = ..GetUserNameByUserID(SenderUserID)
		s ReadUser = msgObj.ReadUserID
		s ReadUserDesc = ""
		s:(ReadUser '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUser)),"^",2)
		s ReadStatus = "未读"
		s:(msgObj.ReadFlag = "R") ReadStatus = "已读"
		s ExecuteDate = msgObj.ExecuteDate
		s:(ExecuteDate '= "") ExecuteDate = $zd(ExecuteDate,3)
		s ExecuteTime = msgObj.ExecuteTime
		s:(ExecuteTime '= "") ExecuteTime = $zt(ExecuteTime,3)
		s ExecuteUser = msgObj.ExecuteUserID
		s ExecuteUserDesc = ""
		s:(ExecuteUser '= "") ExecuteUserDesc = $p($g(^SSU("SSUSR",+ExecuteUser)),"^",2)
		s ExecuteStatus = "未执行"
		s:(msgObj.ExecuteFlag = "E") ExecuteStatus = "已执行"	
		
		s Data = $lb(RowID,CreateDate,CreateTime,CreateUserDesc,MessageBody,ReadDate,ReadTime,ReadUserDesc,ReadStatus,ExecuteDate,ExecuteTime,ExecuteUserDesc,ExecuteStatus)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetMessagesByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessagesByEpisodeIDExecute ]
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

ClassMethod GetMessagesByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessagesByEpisodeIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// s val=##class(EPRservice.BLL.BLEPRMessage).GetMesNumBySend(%session.Get("LOGON.USERID"))
/// ##class(EPRservice.BLL.BLEPRMessage).GetMesNumBySend(24062)
ClassMethod GetMesNumBySend(AUserID As %String) As %String
{
	s ret=0
	q:(AUserID="") ret
	s num=0
    s ds = ##Class(%ResultSet).%New("EPRservice.BLL.BLEPRMessage:GetMessageByUserID")
    d ds.Execute(AUserID,"N","R","E","U","E","SEND")
    while(ds.Next())
    {
    	s num=num+1
    }
    d ds.Close()
    s ret="{""count"":"_num_"}"
    q ret
}

}
