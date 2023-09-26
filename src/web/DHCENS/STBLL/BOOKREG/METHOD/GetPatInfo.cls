/// 患者基本信息
Class web.DHCENS.STBLL.BOOKREG.METHOD.GetPatInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lyh
/// CreatDate：2016-07-07
/// Description：获取患者基本信息
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.GetPatInfo).GetPatInfo("<Request><Header><SourceSystem/><MessageID/></Header><Body><PatientInfo><TradeCode>3300</TradeCode><TransactionId/><ExtOrgCode/><ClientType/><TerminalID/><HospitalId/><ExtUserID/><PatientCard/><CardType/><PatientID>0000000001</PatientID><Phone/><IDCardType/><IDNo/><PatientName/></PatientInfo></Body></Request>")
ClassMethod GetPatInfo(InputStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	;s InputStream=##class(%GlobalCharacterStream).%New()
	;d InputStream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><PatientInfo><TradeCode>3300</TradeCode><TransactionId></TransactionId><ExtOrgCode>HLST</ExtOrgCode><ClientType>HLST</ClientType><TerminalID>172.18.165.186</TerminalID><HospitalId>65</HospitalId><ExtUserID>hlst</ExtUserID><PatientCard>0000000099</PatientCard><CardType>02</CardType><PatientID></PatientID><Phone></Phone><IDCardType></IDCardType><IDNo></IDNo><PatientName></PatientName></PatientInfo></Body></Request>")
	s tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	s Response=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Response).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s Response.header=header
	s repBody=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepBody).%New()
	b ;lyh 0
	if $$$ISERR(tSC) {
		s repBody.ResultCode="-1"
		s repBody.ResultContent=tSC
		s Response.body=repBody
	}else{
		s (TradeCode,TransactionId,ExtOrgCode,ClientType,TerminalID)=""
		s (HospitalId,ExtUserID,PatientCard,CardType,PatientID)=""
		s (Phone,IDCardType,IDNo,PatientName)=""
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/TradeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TradeCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/TransactionId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TransactionId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/ExtOrgCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtOrgCode=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/ClientType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ClientType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/TerminalID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s TerminalID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/HospitalId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s HospitalId=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/ExtUserID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s ExtUserID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/PatientCard","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PatientCard=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/CardType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s CardType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/PatientID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PatientID=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/Phone","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s Phone=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/IDCardType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s IDCardType=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/IDNo","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s IDNo=$tr(fieldValue,$c(0),"")
		}
		s tSC=tDocument.EvaluateExpression("/Request/Body/PatientInfo/PatientName","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			s fieldValue=tRes.GetAt(1).Value
			s PatientName=$tr(fieldValue,$c(0),"")
		}
		
		// 解析完之后调用接口方法
		//<Request><TradeCode>3300</TradeCode><ExtUserID>demo</ExtUserID><PatientCard>001000001916</PatientCard><CardType>04</CardType><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><PatientID></PatientID><TerminalID></TerminalID></Request>
		s reqObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.ReqGetPatInfo).%New()
		s reqObj.TradeCode=TradeCode
		s reqObj.ExtUserID=ExtUserID
		s reqObj.PatientCard=PatientCard
		s reqObj.CardType=CardType
		s reqObj.TransactionId=TransactionId
		s reqObj.ExtOrgCode=ExtOrgCode
		s reqObj.ClientType=ClientType
		s reqObj.TerminalID=TerminalID
		s reqObj.HospitalId=HospitalId
		s reqObj.PatientID=PatientID
		d reqObj.XMLExportToString(.str)
		b ;lyh 1
		s repObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatInfo(str)
		// 未判断必填项
		s repPatObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RepGetPatInfo).%New()
		s repPatObj.PatientID=repObj.PatientID
		s repPatObj.PatientName=repObj.PatientName
		s repPatObj.SexCode=repObj.SexCode
		s repPatObj.Sex=repObj.Sex
		s repPatObj.DOB=repObj.DOB
		s repPatObj.DocumentID=repObj.DocumentID
		s repPatObj.Address=repObj.Address
		s repPatObj.IDTypeCode=repObj.IDTypeCode
		s repPatObj.IDType=repObj.IDTypeDesc
		s repPatObj.IDNo=repObj.IDNo
		s repPatObj.YBFlag=""	//?
		s repPatObj.PatType=""	//?
		s repPatObj.Mobile=repObj.Mobile
		s repPatObj.InsureCardNo=repObj.InsureCardNo
		s repBody.GetPatInfo=repPatObj
		s repBody.ResultCode=repObj.ResultCode
		s repBody.ResultContent=repObj.ResultContent
		s Response.body=repBody
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

}
