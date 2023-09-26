Class dhcinterface.TeleClient Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// New对帐明细(测试用,实际发起方是114)
ClassMethod CheckInAccountDetailInfo(TransactionId As %String, UserID As %String, ClientAddress As %String, CheckId As %String) As %String
{
	s XmlStr="<Request>"
	_"<TransactionId>"_TransactionId_"</TransactionId>"
	_"<UserID>"_UserID_"</UserID>"
	_"<ClientAddress>"_ClientAddress_"</ClientAddress>"
	_"<CheckId>"_CheckId_"</CheckId>"
	_"</Request>"
	w XmlStr,!
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.CheckInAccountDetailInfo(XmlStr)
		w MsgXml
	}
	
	/*
	/<Request>
	<TransactionId></TransactionId>
	<UserID></UserID>
	<ClientAddress></ClientAddress>
	<CheckId></CheckId>
	</Request>
	*/
}

/// 对帐确认(测试用,实际发起方是HIS)
ClassMethod ConfirmCheckInAccountInfo(TransactionId As %String, UserID As %String, ClientAddress As %String, CheckId As %String) As %String
{
	s XmlStr="<Request>"
	s XmlStr=XmlStr_"<TransactionId>"_TransactionId_"</TransactionId>"
	s XmlStr=XmlStr_"<UserID>"_UserID_"</UserID>"
	s XmlStr=XmlStr_"<ClientAddress>"_ClientAddress_"</ClientAddress>"
	s XmlStr=XmlStr_"<CheckId>"_CheckId_"</CheckId>"
	s XmlStr=XmlStr_"</Request>"
	;s serviceobj=##Class(dhcservice.TeleService).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.ConfirmCheckInAccountInfo(XmlStr)
		s ^CACHETMPTML("114","ConfirmCheckInAccountInfo","HISReturnMsg")=MsgXml
	}else{
		w "in"
	}
	
	/*
	s XmlStr="<Request><TransactionId>"_TransactionId_"</TransactionId></Request>"
	s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.cancelRegistration(XmlStr)
		w MsgXml
	}
	*/
}

/// New 将Xml串中的TransactionId节点值取出
ClassMethod GetTransactionIdByXml(XmlString As %String, MsgMode As %String) As %String
{
	s:MsgMode="" MsgMode="SendMsg"
	if ((MsgMode'="SendMsg")&&(MsgMode="ReturnMsg"))
	{
		Quit ""
	}
	Set getreader = ##class(%XML.Reader).%New()
	Set sc=getreader.OpenString(XmlString)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
	Do getreader.Correlate("Request","dhcinterface."_MsgMode)
	s outTransId=""
	While getreader.Next(.gettelepara,.sc)  {
		s outTransId=gettelepara.TransactionId
	}
	Quit outTransId
}

/// New接收对帐明细信息
ClassMethod ReceiveErrorCheckDetailInfo(TransactionId As %String, UserID As %String, ClientAddress As %String, CheckId As %String) As %String
{
	
	s XmlStr="<Request>"
	_"<TransactionId>"_TransactionId_"</TransactionId>"
	_"<UserID>"_UserID_"</UserID>"
	_"<ClientAddress>"_ClientAddress_"</ClientAddress>"
	_"<CheckId>"_CheckId_"</CheckId>"
	_"</Request>"
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.cancelRegistration(XmlStr)
		w MsgXml
	}
	/*
	/	<TransactionId></TransactionId>
	<UserID></UserID>
	<ClientAddress></ClientAddress>
	<CheckId></CheckId>
	*/
}

/// New传对帐信息(本地调用)
ClassMethod SendCheckInAccountInfo(Date As %Date) As %String
{
	s WorkInfoXml=##Class(dhcinterface.TeleReg).SendCheckInAccountInfo(Date)
	s ResultCode=""
	s ^CACHETMPTML("114","SendCheckInAccountInfo","SendMsg")=WorkInfoXml
	i (WorkInfoXml'=""){
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		if $IsObject(serviceobj){
			
			s MsgXml=serviceobj.SendCheckInAccountInfo(WorkInfoXml)
			s ^CACHETMPTML("114","SendCheckInAccountInfo","ReturnMsg")=MsgXml
			
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
		}
	}
	
	Quit ResultCode
}

/// New违约通知(本地调用)
ClassMethod SendOverdueInfo(ApptIdStr As %String) As %String
{
	q ""
	s WorkInfoXml=##Class(dhcinterface.TeleReg).SendOverdueInfo(ApptIdStr)
	s ResultCode=""
	s ^CACHETMPTML("114","SendOverdueInfo","SendMsg")=WorkInfoXml
	i (WorkInfoXml'=""){
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		if $IsObject(serviceobj){
			;s MsgXml=serviceobj.SendOverdueInfo(WorkInfoXml)
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for i=1:1:3 {
				;w "Send:",i,!
				Do SendMsg
				;s MsgXml=serviceobj.SendOverdueInfo(WorkInfoXml)
				if (MsgXml'=""){q} 
			}
			if (MsgXml=""){q "-1"}
			;Set ^zhou("notifyStopWork")=MsgXml

			;Set ^zhou("SendOverdueInfo")=MsgXml
			s ^CACHETMPTML("114","SendOverdueInfo","ReturnMsg")=MsgXml
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.SendOverdueInfo(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 ;w
 QUIT
}

/// 取消预约(测试用,实际发起方是114)
ClassMethod cancelRegistration(TransactionId As %String) As %String
{
	s XmlStr="<Request><TransactionId>"_TransactionId_"</TransactionId></Request>"
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.cancelRegistration(XmlStr)
		w MsgXml
	}
}

/// 验证用户信息(测试用,实际发起方是114)
ClassMethod checkUserInfo(PatientCard As %String) As %String
{
	
	s XmlStr="<Request><PatientCard>"_PatientCard_"</PatientCard></Request>"
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.checkUserInfo(XmlStr)
		w MsgXml
	}
}

/// New验证用户信息(测试用,实际发起方是114)
ClassMethod checkUserInfoNew(PatientCard As %String, CardType As %String) As %String
{
	
	s XmlStr="<Request>"
	_"<PatientCard>"_PatientCard_"</PatientCard>"
	_"<CardType>"_CardType_"</CardType></Request>"
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.checkUserInfo(XmlStr)
		w MsgXml
	}
}

/// 确认挂号(测试用,实际发起方是114)
ClassMethod confirmRegistration(PatientID As %String, RBASId As %String, TransactionId As %String) As %String
{
	s XmlStr="<Request><PatientID>"_PatientID_"</PatientID><RBASId>"_RBASId_"</RBASId><TransactionId>"_TransactionId_"</TransactionId></Request>"
	w XmlStr,!
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.confirmRegistration(XmlStr)
		
	}
}

/// 取公告信息(测试用,实际发起方是114)
ClassMethod getBulletinInfo() As %String
{
	s ResultCode=""
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		s MsgXml=serviceobj.getBulletinInfo()
		;Set ^zhou("getBulletinInfo")=MsgXml
		s ^CACHETMPTML("114","getBulletinInfo","HISReturnMsg")=MsgXml
		Set reader = ##class(%XML.Reader).%New()
		Set sc=reader.OpenString(MsgXml)
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
		Do reader.Correlate("Response","dhcinterface.ReturnMsg")
		While reader.Next(.person,.sc)  {
			  s ErrorMsg=person.ErrorMsg
			  s ResultCode=person.ResultCode
		}
	}
	Quit ResultCode
}

/// 换诊通知(本地调用)
ClassMethod notifyChangeWork(OldRBASId As %String, NewRBASId As %String) As %String
{
	s WorkInfoXml=##Class(dhcinterface.TeleReg).notifyChangeWork(OldRBASId,NewRBASId,"")
	s ResultCode=""
	;s ^zhou("WorkInfoXml")=WorkInfoXml
	s ^CACHETMPTML("114","notifyChangeWork","SendMsg")=WorkInfoXml
	i (WorkInfoXml'=""){
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		if $IsObject(serviceobj){
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for i=1:1:3 {
				;w "Send:",i,!
				Do SendMsg
				;s MsgXml=serviceobj.notifyChangeWork(WorkInfoXml)
				if (MsgXml'=""){q} 
			}
			if (MsgXml=""){q "-1"}
			;Set ^zhou("notifyChangeWork")=MsgXml
			s ^CACHETMPTML("114","notifyChangeWork","ReturnMsg")=MsgXml
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
			s saveTransId=..GetTransactionIdByXml(WorkInfoXml,"SendMsg")
			s saveTransId=##class(dhcinterface.TeleReg).writeLog("Update",saveTransId,"notifyGetNumber",WorkInfoXml,MsgXml,0,"","")
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.notifyChangeWork(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 QUIT
}

/// 取号通知(本地调用)
ClassMethod notifyGetNumber(TransactionId As %String) As %String
{
	s WorkInfoXml=##Class(dhcinterface.TeleReg).notifyGetNumber(TransactionId)
	;s WorkInfoXml="<Request><HospitalId></HospitalId></Request>"
	s ^CACHETMPTML("114","notifyGetNumber","SendMsg")=WorkInfoXml
	s ResultCode=""
	i (WorkInfoXml'=""){
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		if $IsObject(serviceobj){
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for ii=1:1:3 {
				;w "Send:",ii,!
				Do SendMsg
				s MsgXml=serviceobj.notifyGetNumber(WorkInfoXml)
				if (MsgXml'=""){q} 
			}
			if (MsgXml=""){q "-1"}
			;Set ^zhou("notifyGetNumber")=MsgXml
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			s ^CACHETMPTML("114","notifyGetNumber","ReturnMsg")=MsgXml
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
			s saveTransId=..GetTransactionIdByXml(WorkInfoXml,"SendMsg")
			s saveTransId=##class(dhcinterface.TeleReg).writeLog("Update",saveTransId,"notifyGetNumber",WorkInfoXml,MsgXml,0,"","")
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.notifyGetNumber(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 ;w
 QUIT
}

/// 停诊通知(本地调用)
ClassMethod notifyStopWork(RBASId As %String) As %String
{
	s WorkInfoXml=##Class(dhcinterface.TeleReg).notifyStopWork(RBASId)
	s ^CACHETMPTML("114","notifyStopWork","SendMsg")=WorkInfoXml
	s ResultCode=""
	i (WorkInfoXml'=""){
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		if $IsObject(serviceobj){
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for i=1:1:3 {
				;s ^CACHETMPTML("Stop"_i)=i
				;w "Send:",i,!
				Do SendMsg
				;s MsgXml=serviceobj.notifyStopWork(WorkInfoXml)
				if (MsgXml'=""){q} 
			}
			if (MsgXml=""){q "-1"}
			;Set ^zhou("notifyStopWork")=MsgXml
			s ^CACHETMPTML("114","notifyStopWork","ReturnMsg")=MsgXml
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
			s saveTransId=..GetTransactionIdByXml(WorkInfoXml,"SendMsg")
			s saveTransId=##class(dhcinterface.TeleReg).writeLog("Update",saveTransId,"notifyGetNumber",WorkInfoXml,MsgXml,0,"","")
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.notifyStopWork(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 QUIT
}

/// 根据发送记录日志?重新发送排班信息(本地调用)
ClassMethod reSendUpdateWorkInfo(WorkInfoXml As %String) As %String
{
	;s ^CACHETMPTML("114","reSendUpdateWorkInfo","SendMsg")=WorkInfoXml
	s ResultCode=0
	i (WorkInfoXml'=""){
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		if $IsObject(serviceobj){
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for i=1:1:3 {
				;w "Send:",i,!
				Do SendMsg
				;s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
				if (MsgXml'=""){q}
			}
			if (MsgXml=""){q "-1"}
			//s ^zhou("updateWorkInfo")=MsgXml
			;s ^CACHETMPTML("114","reSendUpdateWorkInfo","ReturnMsg")=MsgXml
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 QUIT
}

/// 重发换诊通知(本地调用)
ClassMethod reSendnotifyChangeWork(reWorkInfoXml As %String) As %String
{
	s WorkInfoXml=reWorkInfoXml
	s ResultCode=""
	i (WorkInfoXml'=""){
		s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
		;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()
		if $IsObject(serviceobj){
			NEW $ESTACK
			SET $ZTRAP="OnSendMsgError"
			s MsgXml=""
			for i=1:1:3 {
				;w "Send:",i,!
				Do SendMsg
				;s MsgXml=serviceobj.notifyChangeWork(WorkInfoXml)
				if (MsgXml'=""){q} 
			}
			if (MsgXml=""){q "-1"}
			Set reader = ##class(%XML.Reader).%New()
			Set sc=reader.OpenString(MsgXml)
			If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
			Do reader.Correlate("Response","dhcinterface.ReturnMsg")
			While reader.Next(.person,.sc)  {
			   s ErrorMsg=person.ErrorMsg
			   s ResultCode=person.ResultCode
			}
			s saveTransId=..GetTransactionIdByXml(WorkInfoXml,"SendMsg")
		}
	}
	Quit ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.notifyChangeWork(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 QUIT
}

/// 测试用
ClassMethod testGetAllTransID(testStartDate As %String, testEndDate As %String) As %String
{
	s aa=""
	s iDate=0+testStartDate
	s jj=0
	for ii=1:1:^User.DHCTeleTransactionD
	{
		s indexaa=""
		//&sql(select tt_transactionid into :indexaa from sqluser.dhc_teletransaction where ID=:ii and  tt_transactiondate=:iDate)   by gry
		if (indexaa'=""){
			s jj=jj+1
			q:jj>50
			s aa=aa_","_indexaa
		}
		w:indexaa'="" indexaa,!
	}
	q aa
}

/// 发送排班信息(本地调用)
ClassMethod updateSingleWorkInfo(RBASId As %String) As %String
{
	;w ##class(dhcinterface.TeleClient).updateSingleWorkInfo("599||1")
	s ^zhou("updateSingleWorkInfo")=RBASId
	set schedule=##class(User.RBApptSchedule).%OpenId(RBASId)
	set ASDate=schedule.ASDate
	d schedule.%Close()
	;发送要判断周期
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	if AppDaysLimit="" s AppDaysLimit=7
	i ASDate>(+$H+AppDaysLimit) Q 0
	
	s ResultCode=0
	s WorkInfoXml=##Class(dhcinterface.TeleReg).GetSingleWorkInfo(RBASId,"")
	if WorkInfoXml="" Q 0
	s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	if $IsObject(serviceobj){
		/*
		While (WorkInfoXml.AtEnd = 0) {
			;s IOStrLen=2000
			s mystr=WorkInfoXml.Read()
			w mystr
		}
		*/
		NEW $ESTACK
		SET $ZTRAP="OnSendMsgError"
		s MsgXml=""
		for i=1:1:3 {
			Do SendMsg
			if (MsgXml'=""){q}
		}
		if (MsgXml=""){q "-1"}

		Set reader = ##class(%XML.Reader).%New()
		Set sc=reader.OpenString(MsgXml)
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
		Do reader.Correlate("Response","dhcinterface.ReturnMsg")
		While reader.Next(.person,.sc)  {
		   s pResult=person.Result
		   if (pResult'="") {s ResultCode="-2" q}
		   s ErrorMsg=person.ErrorMsg
		   s ResultCode=person.ResultCode
		   if ResultCode=1 quit
		}
	}
	q ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ; WRITE "$ECODE= ",$ECODE,!
 QUIT
}

/// 发送排班信息(本地调用)
ClassMethod updateWorkInfoOld(StartDate As %Date, EndDate As %Date) As %String
{
	;w ##class(dhcinterface.TeleClient).updateWorkInfo(61285,61285)
	s ResultCode=0
 //for WorkStartDate=StartDate:1:EndDate {;按天发
	s WorkInfoXml=##Class(dhcinterface.TeleReg).GetWorkInfo(StartDate,EndDate,"")

	;s ^CACHETMPTML("114","updateWorkInfo","SendMsg")= WorkInfoXml
	;****************************************** Zhaoym
	;s serviceobj=##Class(dhcserviceclient.DataServiceSoap).%New()
	s serviceobj=##Class(dhcserviceclient.BSTServiceSoap).%New()
	;******************************************
	;s serviceobj=##Class(dhcserviceclient.TeleServiceSoap).%New()

	if $IsObject(serviceobj){
		/*
		While (WorkInfoXml.AtEnd = 0) {
			;s IOStrLen=2000
			s mystr=WorkInfoXml.Read()
			w mystr
		}
		*/
		NEW $ESTACK
		SET $ZTRAP="OnSendMsgError"
		s MsgXml=""
		for i=1:1:3 {
			;w "Send:",i,!
			Do SendMsg
			;s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
			if (MsgXml'=""){q}
		}
		if (MsgXml=""){q "-1"}
		;s ^zhou("updateWorkInfo")=MsgXml
		s ^CACHETMPTML("114","updateWorkInfo","ReturnMsg")=MsgXml
		Set reader = ##class(%XML.Reader).%New()
		Set sc=reader.OpenString(MsgXml)

		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
		Do reader.Correlate("Response","dhcinterface.ReturnMsg")
		While reader.Next(.person,.sc)  {
		   s pResult=person.Result
		   if (pResult'="") {s ResultCode="-2" q}
		   s ErrorMsg=person.ErrorMsg
		   s ResultCode=person.ResultCode
		   if ResultCode=1 quit
		}
	}
 //}
	q ResultCode
SendMsg
	SET $ECODE=""
	s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
	Quit
OnSendMsgError
 ;WRITE "OnError $ESTACK= ",$ESTACK,!   // 1
 ;WRITE "$ECODE= ",$ECODE,!
 QUIT
}

ClassMethod updateWorkInfo(StartDate As %Date, EndDate As %Date) As %String
{
	s WorkInfoXml=##Class(dhcinterface.TeleReg).GetWorkInfo(StartDate,EndDate,"")
	s serviceobj=##Class(dhcserviceclient.BSTServiceSoap).%New()
	s MsgXml=serviceobj.updateWorkInfo(WorkInfoXml)
    q MsgXml
}

}
