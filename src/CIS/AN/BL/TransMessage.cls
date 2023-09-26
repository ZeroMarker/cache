Class CIS.AN.BL.TransMessage Extends %RegisteredObject
{

ClassMethod SaveMessage(opsId As %String, transFrom As %String, transTo As %String, msgType As %String, resend = "N", message As %String = "") As %String
{
	set $zt="Error"
	set msgId=""
	&sql(select RowId into :msgId from CIS_AN.transfermessage where operschedule=:opsId and messageType=:msgType)
	if (##class(CIS.AN.TransferMessage).%ExistsId(msgId))&(resend="N")&(msgType="通知接患者")
	{
		quit "E^该患者的“"_msgType_"”消息已经发送过。"	
	}
	set transMsg=##class(CIS.AN.TransferMessage).%New()
	set transMsg.TransDate=+$h
	set transMsg.TransTime=$p($h,",",2)
	set transMsg.TransFrom=transFrom
	if (transTo="")
	{
		//set transTo="8412,8554,8507,8406"	
	}
	set transMsg.TransTo=transTo
	set transMsg.Status="S"
	set transMsg.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set transMsg.MessageType=msgType
	if (message'="")
	{
		set transMsg.Message=message	
	}
	else
	{
		set messageStr=""
		set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
		set sc=rset.Execute("","","",opsId)
		while(rset.%Next())
		{
			set patInfo=rset.Get("PatName")_" "_rset.Get("PatGender")_" "_rset.Get("PatAge")_"  住院号："_rset.Get("MedcareNo")
			set location=rset.Get("WardBed")
			set sender="发送者："_(##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",transFrom))
			set anaMethod="麻醉方式："_rset.Get("PrevAnaMethodDesc")
			set messageStr="患者："_patInfo_"  病区："_location_"  手术间："_rset.Get("RoomDesc")_"  "_sender_"  "_anaMethod
			
		}	
		set transMsg.Message="【"_msgType_"】  "_messageStr
	}
	set sc=transMsg.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_transMsg.%Id()
Error
	quit "E^"_$ze
}

ClassMethod SaveMessageNew(dataPara As %String) As %String
{
	tstart
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m operData=array(dataIndex)
		set rowId=$get(operData("RowId"))
		if (##class(CIS.AN.TransferMessage).%ExistsId(rowId)=0)
		{
			set operData("TransDate")=+$h
			set operData("TransTime")=$p($h,",",2)	
		}
		set status=$get(operData("Status"))
		if (status="D")
		{
			set operData("CancelDate")=+$h
			set operData("CancelTime")=$p($h,",",2)
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod ConfirmMessage(msgId As %String, confirmUserId As %String) As %String
{
	set $zt="Error"
	quit:(##class(CIS.AN.TransferMessage).%ExistsId(msgId)=0) "E^消息记录不存在。"
	set msg=##class(CIS.AN.TransferMessage).%OpenId(msgId)
	set msg.ConfirmUser=confirmUserId
	set msg.ConfirmDate=+$h
	set msg.ConfirmTime=$p($h,",",2)
	set msg.Status="C"
	set sc=msg.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_msg.%Id()
Error
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-26
/// Description： 	查询手术等级
/// Table：        	OperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.TransMessage","FindTransMessages","2018-11-05","2018-11-05")
Query FindTransMessages(startDate As %String, endDate As %String, opsId As %String = "", messageType As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Message,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',TransFrom) As FromUserDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',TransTo) As ToUserDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ConfirmUser) As ConfirmUserDesc,
	   %ODBCOUT(TransDate)_" "_%ODBCOUT(TransTime) As TransDT,
	   %ODBCOUT(ConfirmDate)_" "_%ODBCOUT(ConfirmTime) As ConfirmDT,
	   OperSchedule,
	   Status,
	   %External(Status) As StatusDesc,
	   MessageType
	   from CIS_AN.transfermessage
	   where transdate>=%ODBCIN(:startDate)
	   and transdate<=%ODBCIN(:endDate)
	   and (OperSchedule=:opsId or :opsId is null)
	   and (MessageType=:messageType or :messageType is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-26
/// Description： 	查询手术等级
/// Table：        	OperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.TransMessage","FindTransMessages","2018-11-05","2018-11-05")
Query FindTransMessagesForPat(opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Message,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',TransFrom) As FromUserDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',TransTo) As ToUserDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ConfirmUser) As ConfirmUserDesc,
	   %ODBCOUT(TransDate)_" "_%ODBCOUT(TransTime) As TransDT,
	   %ODBCOUT(ConfirmDate)_" "_%ODBCOUT(ConfirmTime) As ConfirmDT,
	   OperSchedule,
	   Status,
	   %External(Status) As StatusDesc,
	   MessageType
	   from CIS_AN.transfermessage
	   where (OperSchedule=:opsId or :opsId is null)
}

}
