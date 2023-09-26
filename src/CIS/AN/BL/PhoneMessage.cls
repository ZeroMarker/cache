/// 手机短信
Class CIS.AN.BL.PhoneMessage Extends %RegisteredObject
{

ClassMethod SavePhoneMessage(opsId As %String, businessCode As %String, messageId As %String, content As %String, phoneNumber As %String, createUser As %String, sendFlag As %String = "Y") As %String
{
	set $zt="Error"
	tstart
	set phoneMessage="",oldPhoneMessage=""
	set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (##class(CIS.AN.PhoneMessage).%ExistsId(messageId))
	{
		set oldPhoneMessage=##class(CIS.AN.PhoneMessage).%OpenId(messageId)
		if (content'=oldPhoneMessage.Content)
		{
			set phoneMessage=##class(CIS.AN.PhoneMessage).%New()
			set phoneMessage.OperSchedule=schedule
			set phoneMessage.BusinessCode=businessCode
			set phoneMessage.CreateUser=createUser
			set phoneMessage.CreateDate=+$h
			set phoneMessage.CreateTime=$p($h,",",2)
			set phoneMessage.Status="US"
			set phoneMessage.Flag="N"
			set phoneMessage.PhoneNumber=phoneNumber
			set phoneMessage.Content=content
			
			// 作废旧的短信
			set oldPhoneMessage.Flag="C"
			set oldPhoneMessage.CancelUser=createUser
			set oldPhoneMessage.CancelDate=+$h
			set oldPhoneMessage.CancelTime=$p($h,",",2)
		}
		else
		{
			set phoneMessage=oldPhoneMessage	
		}
	}
	else
	{
		set phoneMessage=##class(CIS.AN.PhoneMessage).%New()
		set phoneMessage.OperSchedule=schedule
		set phoneMessage.BusinessCode=businessCode
		set phoneMessage.CreateUser=createUser
		set phoneMessage.CreateDate=+$h
		set phoneMessage.CreateTime=$p($h,",",2)
		set phoneMessage.Status="US"
		set phoneMessage.Flag="N"
		set phoneMessage.PhoneNumber=phoneNumber
		set phoneMessage.Content=content
	}
	
	set sc=phoneMessage.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	if ($isobject(oldPhoneMessage))
	{
		set sc=oldPhoneMessage.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}	
	}
	
	set newMessageId=phoneMessage.%Id()
	tcommit
	
	// 直接发送短信
	if (sendFlag="Y")
	{
		set res="S^"
		//set res=##class(CIS.AN.SRV.MessageService).SendPhoneMessage(newMessageId,createUser)
		quit res
	}
	
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetPhoneMessage(opsId As %String, businessCode As %String) As %String
{
	set messageId="",content="",phoneNumber="",status="",sendUser=""
	&sql(select RowId,Content,PhoneNumber,Status,SendUser into :messageId,:content,:phoneNumber,:status,:sendUser from CIS_AN.PhoneMessage where OperSchedule=:opsId and BusinessCode=:businessCode and Flag="N")
	set res=##class(%DynamicObject).%New()
	set res.MessageId=messageId
	set res.Content=content
	set res.PhoneNumber=phoneNumber
	set res.Status=status
	set res.StatusDesc=##class(CIS.AN.PhoneMessage).StatusLogicalToDisplay(status)
	set res.SendUser=sendUser
	set res.SendUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",sendUser)
	quit res.%ToJSON()
}

/// 批量发送短信
ClassMethod SendMessageList(messageList As %DynamicArray) As %String
{
	set $zt="Error"
	tstart
	//set messageList=##class(%DynamicArray).%FromJSON(messageStr)
	set iter = messageList.%GetIterator()
	set result="S^"
	while iter.%GetNext(.key , .value ) {
		set opsId=value.OPSID,businessCode=value.BusinessCode,messageId=value.MessageId,content=value.Content
		set phoneNumber=value.PatPhoneNumber,sendFlag="Y",createUser=value.CreateUser
		set result=..SendMessage(opsId,businessCode,messageId,content,phoneNumber,createUser,sendFlag)
		quit:($p(result,"^",1)'="S")
	}
	if ($p(result,"^",1)'="S")
	{
		trollback
		quit result
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// 发送短信
ClassMethod SendMessage(opsId As %String, businessCode As %String, messageId As %String, content As %String, phoneNumber As %String, createUser As %String, sendFlag As %String = "Y") As %String
{
	set phoneMessage="",oldPhoneMessage=""
	set schedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (##class(CIS.AN.PhoneMessage).%ExistsId(messageId))
	{
		set oldPhoneMessage=##class(CIS.AN.PhoneMessage).%OpenId(messageId)
		if (content'=oldPhoneMessage.Content)
		{
			set phoneMessage=##class(CIS.AN.PhoneMessage).%New()
			set phoneMessage.OperSchedule=schedule
			set phoneMessage.BusinessCode=businessCode
			set phoneMessage.CreateUser=createUser
			set phoneMessage.CreateDate=+$h
			set phoneMessage.CreateTime=$p($h,",",2)
			set phoneMessage.Status="US"
			set phoneMessage.Flag="N"
			set phoneMessage.PhoneNumber=phoneNumber
			set phoneMessage.Content=content
			
			// 作废旧的短信
			set oldPhoneMessage.Flag="C"
			set oldPhoneMessage.CancelUser=createUser
			set oldPhoneMessage.CancelDate=+$h
			set oldPhoneMessage.CancelTime=$p($h,",",2)
		}
		else
		{
			set phoneMessage=oldPhoneMessage	
		}
	}
	else
	{
		set phoneMessage=##class(CIS.AN.PhoneMessage).%New()
		set phoneMessage.OperSchedule=schedule
		set phoneMessage.BusinessCode=businessCode
		set phoneMessage.CreateUser=createUser
		set phoneMessage.CreateDate=+$h
		set phoneMessage.CreateTime=$p($h,",",2)
		set phoneMessage.Status="US"
		set phoneMessage.Flag="N"
		set phoneMessage.PhoneNumber=phoneNumber
		set phoneMessage.Content=content
	}
	
	set sc=phoneMessage.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	if ($isobject(oldPhoneMessage))
	{
		set sc=oldPhoneMessage.%Save()
		if ($System.Status.IsError(sc))
		{
			quit "E^"_$System.Status.GetErrorText(sc)	
		}	
	}
	
	set newMessageId=phoneMessage.%Id()
	
	// 直接发送短信
	if (sendFlag="Y")
	{
		set res="S^"
		set res=##class(CIS.AN.SRV.MessageService).SendPhoneMessage(newMessageId,createUser)
		quit res
	}
	
	quit "S^"
}

/// 获取短信发送记录
ClassMethod GetPhoneMessages(startDate As %String, endDate As %String, deptId As %String = "", filterDesc As %String = "", page As %String = "1", rows As %String = "50") As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	&sql(declare MsgCursor cursor for select OperSchedule,Content,SendUser,Status,%External(Status),%ODBCOUT(SendDate),%ODBCOUT(SendTime),SendResult 
		into :opsId,:content,:sendUserId,:status,:statusDesc,:sendDate,:sendTime,:sendResult
		 from CIS_AN.PhoneMessage
		 where SendDate>=:startDateH
		 and SendDate<=:endDateH
		 and (:deptId is null or OperSchedule->PatDeptID=:deptId)
		 and (:filterDesc is null or Content [ :filterDesc))
	&sql(open MsgCursor)
	set startIndex=(page-1)*rows+1,endIndex=page*rows,rowCount=0
	set messageList=##class(%DynamicArray).%New()
	for 
	{
		&sql(fetch MsgCursor)
		quit:(SQLCODE'=0)
		set rowCount=rowCount+1
		continue:(rowCount<startIndex)
		continue:(rowCount>endIndex)
		set operSchedule=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(opsId)
		set message=##class(%DynamicObject).%New()
		set message.PatDeptDesc=operSchedule.PatDeptDesc
		set message.PatName=operSchedule.PatName
		set message.PatGender=operSchedule.PatGender
		set message.RegNo=operSchedule.RegNo
		set message.PatPhoneNumber=operSchedule.PatPhoneNumber
		set message.OperDesc=operSchedule.OperDesc
		set message.OperDate=operSchedule.OperDate
		set message.Content=content
		set message.SendUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",sendUserId)
		set message.StatusDesc=statusDesc
		set DateFormat=$lg(^websys.ConfigurationD(1),10)
		set:((DateFormat="DMY")&&(sendDate'="")) sendDate=$zd($zdh(sendDate,3),4) 
		set message.SendDate=sendDate
		set message.SendDT=sendDate_" "_sendTime
		set message.SendResult=sendResult
		do messageList.%Push(message)
	}
	&sql(close MsgCursor)
	quit messageList.%ToJSON()
}

/// 获取患者短信模板
/// w ##class(CIS.AN.BL.PhoneMessage).GetPatMessageList("225")
ClassMethod GetPatMessageList(opsIdStr As %String) As %String
{
	set opsCount=$l(opsIdStr,"^")
	set messageList=##class(%DynamicArray).%New()
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,"^",i)
		//set operSchedule=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(opsId)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    	set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
		set message=##class(%DynamicObject).%New()
		set message.OPSID=opsId
		set message.PatName=operSchedule.PatName
		set message.PatGender=operSchedule.PatGender
		set dept=##class(User.CTLoc).%OpenId(operSchedule.PatDeptID)
    	set message.PatDeptDesc=dept.CTLOCDesc
		set message.RegNo=operSchedule.RegNo
		set message.OperDesc=operListObj.OperDesc
		set message.PatPhoneNumber=operSchedule.PatPhoneNumber
		set DateFormat=$lg(^websys.ConfigurationD(1),10)
		set:((DateFormat="DMY")&&(operSchedule.OperDate'="")) operSchedule.OperDate=$zd($zdh(operSchedule.OperDate,3),4) 
		set message.OperDate=operSchedule.OperDate
		//b //ccq2
		set messageFormat=##class(CIS.AN.BL.MessageTemplate).GetMessageTemplate(operSchedule.PatDeptID,"")
		set messageText=""
		
		set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		set operData=##class(%DynamicObject).%New()
		set operData.OperYear=+$p(OperDate,"-",1)
		set operData.OperMonth=+$p(OperDate,"-",2)
		set operData.OperDay=+$p(OperDate,"-",3)
		set operData.OperTime=$zt(operSchedule.OperTime,1)
		set operData.OperHour=+$p(operData.OperTime,":",1)
		set operData.OperMin=+$p(operData.OperTime,":",2)
		
		do ..GenerateMessage(messageFormat,operData,.messageText)
		set message.MessageText=messageText
		do messageList.%Push(message)
	}
	quit messageList.%ToJSON()
}

ClassMethod GenerateMessage(orderFormat As %String, operData As %DynamicObject, Output orderDesc As %String = "") As %String
{
	set matchStr="{{",matchLen=$l(matchStr)
	set leftIndex=$find(orderFormat,matchStr)
	quit:(leftIndex=0) $$$OK
	set leftIndex=leftIndex-matchLen
	set rightIndex=$find(orderFormat,"}}")
	set dataField=$extract(orderFormat,leftIndex+matchLen,rightIndex-matchLen-1)
	set dataValue=operData.%Get(dataField)
	//b //ccq3
	set $extract(orderFormat,leftIndex,rightIndex-1)=dataValue
	set orderDesc=orderFormat
	do ..GenerateMessage(orderFormat,operData,.orderDesc)
}

}
