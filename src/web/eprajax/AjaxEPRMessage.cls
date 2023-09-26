Class web.eprajax.AjaxEPRMessage Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s userID = $Get(%request.Data("UserID",1),"")
	s userType = $Get(%request.Data("UserType",1),"")
	s readFlag = $Get(%request.Data("ReadFlag",1),"")
	s executeFlag = $Get(%request.Data("ExecuteFlag",1),"")
	s effectiveFlag = $Get(%request.Data("EffectiveFlag",1),"")
	s confirmFlag = $Get(%request.Data("ConfirmFlag",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s messageIDS = $Get(%request.Data("MessageIDS",1),"")
	s Appeal=$Get(%request.Data("Appeal",1),"")
	
	s createDateStart = $Get(%request.Data("CreateDateStart",1),"")
	s createDateEnd = $Get(%request.Data("CreateDateEnd",1),"")
	
	s MessageDesc = $Get(%request.Data("MessageDesc",1),"")
	s LocID = $Get(%request.Data("LocID",1),"")
	s receiveUserID = $Get(%request.Data("ReceiveUserID",1),"")
	s messageHeader = $Get(%request.Data("MessageHeader",1),"")
	s message = $Get(%request.Data("Message",1),"")
	s messageSource = $Get(%request.Data("MessageSource",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s priority = $Get(%request.Data("Priority",1),"")
	
	s HospitalID=$g(%session.Data("LOGON.HOSPID"))
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")

	s startRow = ""
	s endRow = ""
	s:((pageSize '= "") && (pageNum '= "")) startRow = (pageNum -1)*pageSize + 1
	s:((pageSize '= "") && (pageNum '= "")) endRow = startRow + pageSize -1
        //s ^CacheTemp("debug","endRow") = userID_"^"_userType_"^"_readFlag_"^"_executeFlag_"^"_confirmFlag_"^"_effectiveFlag_"^"_createDateStart_"^"_createDateEnd_"^"_startRow_"^"_endRow
	
	if (action = "getmessage")
	{
		d ..GetMessageByUserID(userID,userType,readFlag,executeFlag,confirmFlag,effectiveFlag,createDateStart,createDateEnd,HospitalID,LocID,startRow,endRow,MessageDesc)
	}
	elseif (action = "send")
	{
		//w ##class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(userID,receiveUserID,messageHeader,message,messageSource,episodeID,"","","","","","","","1","SEND",priority,"L")
		//d ##class(websys.DHCMessageInterface).Send(message,"1008",userID,episodeID,"",receiveUserID,"","","","")
		s linkParam = "EpisodeId="_episodeID
		s messageID = ##Class(EPRservice.BLL.BLEPRMessage).SendFirstMessage(userID,receiveUserID,"质控消息",message,"QUALITY",episodeID,"","","","","","","","1","",LocID,"SEND",priority,"L")
		
		s OtherInfoJson="{""link"":""dhc.emr.messagetab.csp"",""linkParam"":"""_linkParam_""",""dialogWidth"":""1000"",""dialogHeight"":""900"",""BizObjId"":"""_messageID_"""}"          //构造OtherInfoJson时，增加BizObjId，add by 黄克怡 2019-02-16

		d ##class(websys.DHCMessageInterface).Send(message,"1008",userID,episodeID,"",receiveUserID,OtherInfoJson,"","","")
		
	}
	elseif (action = "readmessage")
	{
		w ..ReadMessage(messageIDS,userID)	
	}
	elseif (action = "donemessage")
	{
		w ..DoneMessage(episodeID,messageIDS,userID,Appeal)	
	}
	elseif (action = "confirmmessage")
	{
		w ..ConfirmMessage(messageIDS,userID)	
	}
	elseif (action = "cancelmmessage")
	{
		w ..CancelMessage(messageIDS,userID)	
	}
	elseif (action = "recallmmessage")
	{
		w ..Recallmmessage(messageIDS,userID)	
	}
	Quit $$$OK
}

/// debug: d ##class(web.eprajax.AjaxEPRMessage).GetMessageByUserID(10209,"RECEIVE","U","U","U","E","","",1,20)
/// d ##class(web.eprajax.AjaxEPRMessage).GetMessageByUserID($p(^CacheTemp("debug","endRow"),"^",1),$p(^CacheTemp("debug","endRow"),"^",2),$p(^CacheTemp("debug","endRow"),"^",3),$p(^CacheTemp("debug","endRow"),"^",4),$p(^CacheTemp("debug","endRow"),"^",5),$p(^CacheTemp("debug","endRow"),"^",6),$p(^CacheTemp("debug","endRow"),"^",7),$p(^CacheTemp("debug","endRow"),"^",8),$p(^CacheTemp("debug","endRow"),"^",9),$p(^CacheTemp("debug","endRow"),"^",10))
ClassMethod GetMessageByUserID(AUserID As %String, AUserType As %String = "RECEIVE", AReadFlag As %String = "U", AExecuteFlag As %String = "U", AConfirmFlag As %String = "U", AEffective As %String = "E", ACreateDateStart As %String = "", ACreateDateEnd As %String = "", AHospitalID As %String = "", LocID As %String = "", AStartRow As %String = "", AEndRow As %String = "", AMessageDesc As %String = "")
{
	
	s:(AStartRow '= "") AStartRow = +AStartRow
	s:(AEndRow '= "") AEndRow = +AEndRow
	s:(ACreateDateStart = $c(0)) ACreateDateStart = ""
	s:(ACreateDateEnd = $c(0)) ACreateDateEnd = ""
	s:(ACreateDateStart '= "") ACreateDateStart = $zdh(ACreateDateStart,3)
	s:(ACreateDateEnd '= "") ACreateDateEnd = $zdh(ACreateDateEnd,3)
	//b "s"
	w "{""rows"":["
	
	s count=0
	s first = 1
	s rset = ##class(%ResultSet).%New("EPRservice.BLL.BLEPRMessage:GetMessageByUserID")
	//SenderUserID:%String,SenderUserName:%String,ReceiverUserID:%String,ReceiverUserName:%String,MessageTitle:%String,Message:%String,
	//ReadFlag:%String,ReadDate:%String,ReadTime:%String,ExecuteFlag:%String,ExecuteDate:%String,ExecuteTime:%String,Effective:%String,EffectiveFlag:%String,EffectiveDate:%String,EffectiveTime:%String,
	//CreateDate:%String,CreateTime:%String,MessageGroupID:%String,MessageType:%String,MessageSource:%String,MessagePrioriry:%String,ACKID:%String
 	s sc = rset.Execute(AUserID,"E",AReadFlag,AExecuteFlag,AConfirmFlag,AEffective,AUserType,ACreateDateStart,ACreateDateEnd,AHospitalID,AMessageDesc,LocID)
 	While rset.Next()
 	{
	 	s count = count + 1
	 	//b "s"
	 	//continue:((AStartRow '= "") && (+AStartRow < count))
	 	//q:((AEndRow '= "") && (+AEndRow > count))
		if (first = 0) 
	 	{	
	 		w ","
	 	}
	 	
	 	else
	 	{
		 	s first = 0	
		}
	 	s Message=$replace((rset.Data("Message")),"""","\""")
		w "{"
		w ..TrimEnter("""MessageID"":"""_$g(rset.Data("MessageID"))_""",")
		w ..TrimEnter("""AppealText"":"""_$g(rset.Data("AppealText"))_""",")
		w ..TrimEnter("""SenderUserID"":"""_$g(rset.Data("SenderUserID"))_""",")
		w ..TrimEnter("""SenderUserName"":"""_$g(rset.Data("SenderUserName"))_""",")
		w ..TrimEnter("""ReceiverUserID"":"""_$g(rset.Data("ReceiverUserID"))_""",")
		w ..TrimEnter("""ReceiverUserName"":"""_$g(rset.Data("ReceiverUserName"))_""",")
		w ..TrimEnter("""MessageTitle"":"""_$g(rset.Data("MessageTitle"))_""",")			
		w ..TrimEnter("""Message"":"""_$g(Message)_""",")
		w ..TrimEnter("""ReadFlag"":"""_$g(rset.Data("ReadFlag"))_""",")
		w ..TrimEnter("""ReadDateTime"":"""_$g(rset.Data("ReadDate"))_" "_$g(rset.Data("ReadTime"))_""",")
		w ..TrimEnter("""ExecuteFlag"":"""_$g(rset.Data("ExecuteFlag"))_""",")
		w ..TrimEnter("""Execute"":"""_$g(rset.Data("Execute"))_""",")
		w ..TrimEnter("""ExecuteDateTime"":"""_$g(rset.Data("ExecuteDate"))_" "_$g(rset.Data("ExecuteTime"))_""",")
		w ..TrimEnter("""Effective"":"""_$g(rset.Data("Effective"))_""",")
		w ..TrimEnter("""EffectiveFlag"":"""_$g(rset.Data("EffectiveFlag"))_""",")
		w ..TrimEnter("""EffectiveDateTime"":"""_$g(rset.Data("EffectiveDate"))_" "_$g(rset.Data("EffectiveTime"))_""",")
		w ..TrimEnter("""CreateDateTime"":"""_$g(rset.Data("CreateDate"))_" "_$g(rset.Data("CreateTime"))_""",")
		w ..TrimEnter("""MessageGroupID"":"""_$g(rset.Data("MessageGroupID"))_""",")
		w ..TrimEnter("""MessageType"":"""_$g(rset.Data("MessageType"))_""",")
		w ..TrimEnter("""MessageSource"":"""_$g(rset.Data("MessageSource"))_""",")
		w ..TrimEnter("""MessagePrioriry"":"""_$g(rset.Data("MessagePrioriry"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(rset.Data("EpisodeID"))_""",")
		w ..TrimEnter("""InstanceId"":"""_$g(rset.Data("InstanceId"))_""",")
		w ..TrimEnter("""EmrDocId"":"""_$g(rset.Data("EmrDocId"))_""",")
		w ..TrimEnter("""Name"":"""_$g(rset.Data("Name"))_""",")
		w ..TrimEnter("""LocID"":"""_$g(rset.Data("LocID"))_""",")
		w ..TrimEnter("""CtLocName"":"""_$g(rset.Data("CtLocName"))_""",")
		w ..TrimEnter("""PatientID"":"""_$g(rset.Data("PatientID"))_""",")
		w ..TrimEnter("""Path"":"""_$g(rset.Data("Path"))_""",")
		w ..TrimEnter("""ACKID"":"""_$g(rset.Data("ACKID"))_"""")
		w "}"
	}
	
	s rset = ##class(%ResultSet).%New("EPRservice.BLL.BLEPRMessage:GetMessageByUserID")
 	s sc = rset.Execute(AUserID,"N",AReadFlag,AExecuteFlag,AConfirmFlag,AEffective,AUserType,ACreateDateStart,ACreateDateEnd,AHospitalID,AMessageDesc,LocID)
 	While rset.Next()
 	{
	 	s count = count + 1
	 	//b "s"
	 	//continue:((AStartRow '= "") && (+AStartRow > count))
	 	//continue:((AEndRow '= "") && (+AEndRow < count))
		if (first = 0) 
	 	{	
	 		w ","
	 	}
	 	else
	 	{
		 	s first = 0	
		}
	 	s Message=$replace((rset.Data("Message")),"""","\""")
		w "{"
		w ..TrimEnter("""MessageID"":"""_$g(rset.Data("MessageID"))_""",")
		w ..TrimEnter("""AppealText"":"""_$g(rset.Data("AppealText"))_""",")
		w ..TrimEnter("""SenderUserID"":"""_$g(rset.Data("SenderUserID"))_""",")
		w ..TrimEnter("""SenderUserName"":"""_$g(rset.Data("SenderUserName"))_""",")
		w ..TrimEnter("""ReceiverUserID"":"""_$g(rset.Data("ReceiverUserID"))_""",")
		w ..TrimEnter("""ReceiverUserName"":"""_$g(rset.Data("ReceiverUserName"))_""",")
		w ..TrimEnter("""MessageTitle"":"""_$g(rset.Data("MessageTitle"))_""",")				
		w ..TrimEnter("""Message"":"""_$g(Message)_""",")
		w ..TrimEnter("""ReadFlag"":"""_$g(rset.Data("ReadFlag"))_""",")
		w ..TrimEnter("""ReadDateTime"":"""_$g(rset.Data("ReadDate"))_" "_$g(rset.Data("ReadTime"))_""",")
		w ..TrimEnter("""ExecuteFlag"":"""_$g(rset.Data("ExecuteFlag"))_""",")
		w ..TrimEnter("""Execute"":"""_$g(rset.Data("Execute"))_""",")
		w ..TrimEnter("""ExecuteDateTime"":"""_$g(rset.Data("ExecuteDate"))_" "_$g(rset.Data("ExecuteTime"))_""",")
		w ..TrimEnter("""Effective"":"""_$g(rset.Data("Effective"))_""",")
		w ..TrimEnter("""EffectiveFlag"":"""_$g(rset.Data("EffectiveFlag"))_""",")
		w ..TrimEnter("""EffectiveDateTime"":"""_$g(rset.Data("EffectiveDate"))_" "_$g(rset.Data("EffectiveTime"))_""",")
		w ..TrimEnter("""CreateDateTime"":"""_$g(rset.Data("CreateDate"))_" "_$g(rset.Data("CreateTime"))_""",")
		w ..TrimEnter("""MessageGroupID"":"""_$g(rset.Data("MessageGroupID"))_""",")
		w ..TrimEnter("""MessageType"":"""_$g(rset.Data("MessageType"))_""",")
		w ..TrimEnter("""MessageSource"":"""_$g(rset.Data("MessageSource"))_""",")
		w ..TrimEnter("""MessagePrioriry"":"""_$g(rset.Data("MessagePrioriry"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(rset.Data("EpisodeID"))_""",")
		w ..TrimEnter("""InstanceId"":"""_$g(rset.Data("InstanceId"))_""",")
		w ..TrimEnter("""EmrDocId"":"""_$g(rset.Data("EmrDocId"))_""",")
		w ..TrimEnter("""Name"":"""_$g(rset.Data("Name"))_""",")
		w ..TrimEnter("""LocID"":"""_$g(rset.Data("LocID"))_""",")
		w ..TrimEnter("""CtLocName"":"""_$g(rset.Data("CtLocName"))_""",")
		w ..TrimEnter("""PatientID"":"""_$g(rset.Data("PatientID"))_""",")
		w ..TrimEnter("""Path"":"""_$g(rset.Data("Path"))_""",")
		w ..TrimEnter("""ACKID"":"""_$g(rset.Data("ACKID"))_"""")
		w "}"
	}

	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

ClassMethod ReadMessage(AMessageIDS As %String, AReadUserID As %String = "") As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).ReadMessage(AMessageIDS,AReadUserID)
	q ret
}

ClassMethod DoneMessage(AEpisodeID As %String, AMessageIDS As %String, AExecuteUserID As %String = "", Appeal As %String = "") As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).DoneMessage(AEpisodeID,AMessageIDS,AExecuteUserID,Appeal)
	q ret
}

ClassMethod ConfirmMessage(AMessageIDS As %String, AConfirmUserID As %String = "") As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).ConfirmMessage(AMessageIDS,AConfirmUserID)
	q ret
}

ClassMethod CancelMessage(AMessageIDS As %String, ACancelUserID As %String = "") As %String
{
	s ret = ##class(EPRservice.BLL.BLEPRMessage).CancelMessage(AMessageIDS,ACancelUserID)
	q ret
}

ClassMethod Recallmmessage(AMessageIDS As %String, ARecallUserID As %String = "") As %String
{
	
	s ret = ##class(EPRservice.BLL.BLEPRMessage).Recallmmessage(AMessageIDS,ARecallUserID)
	
	q ret
}

}
