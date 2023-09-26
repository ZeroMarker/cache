/// 预约
Class web.DHCENS.STBLL.BOOKREG.METHOD.BookService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lyh
/// CreatDate：2016-06-30
/// Description：接收第三方预约信息
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.BookService).BookService("")
ClassMethod BookService(InputStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	;s ^TMPDHCENS("lyh","BookService",$h)=InputStream.Read()
	;d InputStream.Rewind()
	;s InputStream=##class(%GlobalCharacterStream).%New()
	;d InputStream.Write("<Request><Header><SourceSystem>CLEAR</SourceSystem><MessageID/></Header><Body><BookServiceRt><TradeCode>1000</TradeCode><ExtOrgCode>CLEA</ExtOrgCode><ClientType>CLEA</ClientType><HospitalId>HNSRM</HospitalId><ExtUserID>demo</ExtUserID><TransactionId/><RBASId>4063||51</RBASId><ScheduleItemCode>4063||51</ScheduleItemCode><CardNo>0000011111</CardNo><CardType>01</CardType><CredTypeCode/><IDCardNo/><TelePhoneNo>13526771046</TelePhoneNo><MobileNo/><PatientName/><PayFlag/><PayModeCode>01</PayModeCode><PayBankCode/><PayCardNo/><PayFee>5.5</PayFee><PayInsuFee/><PayInsuFeeStr/><PayTradeNo/><LockQueueNo/><Gender/><Address/><HISApptID/><SeqCode/><AdmitRange/></BookServiceRt></Body></Request>")
	;b ;lyh 111
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Response=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Response).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s Response.header=header
	s repBody=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBody).%New()
	if $$$ISERR(tSC) {
		s repBody.ResultCode="-1"
		s repBody.ResultContent=tSC
		s Response.body=repBody
	}else{
		s (TradeCode,ExtOrgCode,ClientType,HospitalId,ExtUserID)=""
		s (TransactionId,RBASId,LockQueueNo,CardNo,CardType)=""
		s (CredTypeCode,IDCardNo,TelePhoneNo,PatientName,Gender)=""
		s (Address,HISApptID,SeqCode,AdmitRange,PayFlag)=""
		s (PayModeCode,PayBankCode,PayCardNo,PayFee,PayInsuFee)=""
		s (PayInsuFeeStr,PayTradeNo,PayTradeStr,TradeCode,BankCode)=""
		s (BankDate,BankTradeNo,ResultCode,ResultContent,PayCardNo)=""
		s (BankAccDate,RevTranFlag,PatientID,PayAmt,OrgHISTradeNo)=""
		s (OrgPaySeqNo)=""
		s SourceSystem=""
		s tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s SourceSystem=$tr(fieldValue,$c(0),"")
		}
		s MessageID=""
		s tSC=tDocument.EvaluateExpression("/Request/Header/MessageID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s MessageID=$tr(fieldValue,$c(0),"")
		}
		
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/TradeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TradeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/ExtOrgCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtOrgCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/ClientType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ClientType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/HospitalId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s HospitalId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/ExtUserID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtUserID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/TransactionId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TransactionId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/RBASId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s RBASId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/LockQueueNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s LockQueueNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/CardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s CardNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/CardType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s CardType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/CredTypeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s CredTypeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/IDCardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s IDCardNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/TelePhoneNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TelePhoneNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PatientName","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PatientName=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/Gender","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s Gender=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/Address","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s Address=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/HISApptID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s HISApptID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/SeqCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s SeqCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/AdmitRange","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s AdmitRange=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayFlag","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayFlag=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayModeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayModeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayBankCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayBankCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayCardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayCardNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayFee","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayFee=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayInsuFee","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayInsuFee=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayInsuFeeStr","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayInsuFeeStr=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayTradeNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayTradeNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayTradeStr","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayTradeStr=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/TradeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TradeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/BankCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s BankCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/BankDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s BankDate=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/BankTradeNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s BankTradeNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/ResultCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ResultCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/ResultContent","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ResultContent=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayCardNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayCardNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/BankAccDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s BankAccDate=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/RevTranFlag","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s RevTranFlag=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PatientID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PatientID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/PayAmt","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PayAmt=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/OrgHISTradeNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s OrgHISTradeNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/BookServiceRt/OrgPaySeqNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s OrgPaySeqNo=$tr(fieldValue,$c(0),"")
		}
		// 解析完之后调用接口存储方法
		//预约存储方法
		// <Request><TradeCode>1000</TradeCode><ExtOrgCode>1001</ExtOrgCode><ClientType>WEB</ClientType><HospitalId>1001</HospitalId><ExtUserID>006338</ExtUserID><TransactionId></TransactionId><ScheduleItemCode>3549||4</ScheduleItemCode><CardNo>0000000002</CardNo><CardType>02</CardType><CredTypeCode>01</CredTypeCode><IDCardNo></IDCardNo><TelePhoneNo></TelePhoneNo><MobileNo></MobileNo><PatientName></PatientName><PayFlag></PayFlag><PayModeCode></PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayFee>7</PayFee><PayInsuFee></PayInsuFee><PayInsuFeeStr></PayInsuFeeStr><PayTradeNo></PayTradeNo><LockQueueNo></LockQueueNo><Gender></Gender><Address></Address><HISApptID></HISApptID><SeqCode></SeqCode><AdmitRange></AdmitRange><PayTradeStr></PayTradeStr></Request>
		s reqObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.BookServiceRq).%New()
		s reqObj.TradeCode=TradeCode
		s reqObj.ExtOrgCode=ExtOrgCode
		s reqObj.ClientType=ClientType
		s reqObj.HospitalId=HospitalId
		s reqObj.ExtUserID=ExtUserID
		s reqObj.TransactionId=TransactionId
		s reqObj.ScheduleItemCode=RBASId
		s reqObj.RBASId=RBASId
		s reqObj.CardNo=CardNo
		s reqObj.CardType=CardType
		s reqObj.CredTypeCode=CredTypeCode
		s reqObj.IDCardNo=IDCardNo
		s reqObj.TelePhoneNo=TelePhoneNo
		s reqObj.MobileNo=""
		s reqObj.PatientName=PatientName
		s reqObj.PayFlag=PayFlag
		s reqObj.PayModeCode=PayModeCode
		s reqObj.PayBankCode=PayBankCode
		s reqObj.PayCardNo=PayCardNo
		s reqObj.PayFee=PayFee
		s reqObj.PayInsuFee=PayInsuFee
		s reqObj.PayInsuFeeStr=PayInsuFeeStr
		s reqObj.PayTradeNo=PayTradeNo
		s reqObj.LockQueueNo=LockQueueNo
		s reqObj.Gender=Gender
		s reqObj.Address=Address
		s reqObj.HISApptID=HISApptID
		s reqObj.SeqCode=SeqCode
		s reqObj.AdmitRange=AdmitRange
		s reqObj.PayTradeStr=PayTradeStr
		d reqObj.XMLExportToString(.str)
		s repObj=##class(DHCExternalService.RegInterface.SelfRegMethods).BookService(str)
		b ;lyh 2
		// 未判断必填项
		s repBookObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBookService).%New()
		s repBookObj.SeqCode=repObj.SeqCode
		s repBookObj.OrderCode=repObj.OrderCode
		s repBookObj.AdmitRange=repObj.AdmitRange
		s repBookObj.RegFee=repObj.RegFee
		s repBookObj.AdmitAddress=repObj.AdmitAddress
		s repBookObj.OrderContent=repObj.OrderContent
		s repBookObj.TransactionId=repObj.TransactionId
		s repBody.BookService=repBookObj
		s repBody.ResultCode=repObj.ResultCode
		s repBody.ResultContent=repObj.ResultContent
		s Response.body=repBody
		s repObj=""
		s repBookObj=""
	}
	d Response.XMLExportToStream(.stream)
	b ;lyh end
	q stream
Err
	b ;lyh err
	s Response=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Response).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s Response.header=header
	s repBody=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBody).%New()
	s repBody.ResultCode="-1"
	s repBody.ResultContent=$ze
	s Response.body=repBody
	d Response.XMLExportToStream(.stream)
	q stream
}

/// Creator：lyh
/// CreatDate：2016-07-06
/// Description：接收第三方取消预约信息
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.BookService).CancelBookService("3204||2")
ClassMethod CancelBookService(InputStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Response=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Response).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s Response.header=header
	s repBody=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBody).%New()
	if $$$ISERR(tSC) {
		s repBody.ResultCode="-1"
		s repBody.ResultContent=tSC
		s Response.body=repBody
	}else{
		s (TradeCode,ExtOrgCode,ClientType,HospitalId,ExtUserID)=""
		s (TransactionId,OrderCode)=""
		s SourceSystem=""
		s tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s SourceSystem=$tr(fieldValue,$c(0),"")
		}
		s MessageID=""
		s tSC=tDocument.EvaluateExpression("/Request/Body/MessageID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s MessageID=$tr(fieldValue,$c(0),"")
		}
		
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/TradeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TradeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/ExtOrgCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtOrgCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/ClientType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ClientType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/HospitalId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s HospitalId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/ExtUserID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtUserID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/TransactionId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TransactionId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/CancelBookServiceRt/OrderCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s OrderCode=$tr(fieldValue,$c(0),"")
		}
		// 解析完之后调用接口存储方法
		s reqObj=##class(DHCExternalService.RegInterface.Entity.SelfAppt.CancelRegistrationRt).%New()
		s reqObj.TradeCode=TradeCode
		s reqObj.ExtOrgCode=ExtOrgCode
		s reqObj.ClientType=ClientType
		s reqObj.HospitalId=HospitalId
		s reqObj.ExtUserID=ExtUserID
		s reqObj.TransactionId=TransactionId
		s reqObj.OrderCode=OrderCode
		d reqObj.XMLExportToString(.str)
		// 医生站返回对象
		b ;lyh 1
		s repObj=##class(DHCExternalService.RegInterface.SelfRegMethods).CancelOrder(str)
		s repCancelBookObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepCancelBookService).%New()
		s repCancelBookObj.TransactionId=TransactionId
		s repCancelBookObj.OrderCode=OrderCode
		s repBody.CancelBookService=repCancelBookObj
		s repBody.ResultCode=repObj.ResultCode
		s repBody.ResultContent=repObj.ResultContent
		s Response.body=repBody
		s reqObj=""
		s repCancelBookObj=""
	}
	d Response.XMLExportToStream(.stream)
	b ;lyh end
	q stream
Err
	b ;lyh err
	s Response=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Response).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s Response.header=header
	s repBody=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBody).%New()
	s repBody.ResultCode="-1"
	s repBody.ResultContent=$ze
	s Response.body=repBody
	d Response.XMLExportToStream(.stream)
	q stream
}

/// w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.BookService).test1()
ClassMethod test1()
{
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem>118114</SourceSystem><MessageID>118114</MessageID></Header><Body><CancelBookServiceRt><TradeCode>1108</TradeCode><ExtOrgCode>1181</ExtOrgCode><ClientType>118114</ClientType><HospitalId>hnsrmyy</HospitalId><ExtUserID>0001</ExtUserID><TransactionId></TransactionId><OrderCode>3565||68||1</OrderCode></CancelBookServiceRt></Body></Request>")
	s result=##class(web.DHCENS.STBLL.BOOKREG.METHOD.BookService).CancelBookService(stream)
	
	b ;lyh end
}

}
