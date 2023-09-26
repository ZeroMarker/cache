Class web.DHCENS.STBLL.DOCU.METHOD.DocumentAccess Extends (%RegisteredObject, %XML.Adaptor)
{

/// 文档调阅
/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentAccess).test("LIS")
ClassMethod test(Type As %String) As %String
{
	;2019-10-14 检验用
	;s:Type="PACS" str="<Request><Header><SourceSystem>SYS0010</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt><PATPatientID>0000031748</PATPatientID><PAADMVisitNumber>205510</PAADMVisitNumber><DocumentType>01001</DocumentType><DocumentID>00000000G005191230062</DocumentID></DocumentSearchRt></Body></Request>"
	;2019-10-09
	;s:Type="PACS" str="<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt><PATPatientID>0000016269</PATPatientID><PAADMVisitNumber>22693</PAADMVisitNumber><DocumentType>01001</DocumentType><DocumentID>17288</DocumentID></DocumentSearchRt></Body></Request>"
    s:Type="LIS" str="<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt><PATPatientID>0000031748</PATPatientID><PAADMVisitNumber>205510</PAADMVisitNumber><DocumentType>01001</DocumentType><DocumentID>00000000G005191230062</DocumentID></DocumentSearchRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(str)
	s return=##class(%GlobalCharacterStream).%New()
	s return=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",stream)
   
    do return.OutputToDevice()
	q return.Read(return.Size)
}

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentAccess).DocumentAccess("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><DocumentType></DocumentType><DocumentID>90</DocumentID></DocumentSearchRt></Body></Request>")
ClassMethod DocumentAccess(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><ResultCode>-1</ResultCode><ResultContent>xml结构错误</ResultContent></Response>")
		Quit stream
	}
	else
 	{
	 	set (PATPatientID,PAADMVisitNumber,DocumentType,DocumentID,SourceSystem)=""
	 	set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystem=$tr(fieldValue,$c(0),"")
		}
	 	set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentSearchRt/PATPatientID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
	 	set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentSearchRt/PAADMVisitNumber","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
	 	set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentSearchRt/DocumentType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
		}
	 	set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentSearchRt/DocumentID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentID=$tr(fieldValue,$c(0),"")
		}
			
 	}
	set stream=..SearchReport(DocumentID,SourceSystem)

	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentAccess).SearchReport("55").Read()
ClassMethod SearchReport(DocumentID As %String, SourceSystem As %String) As %GlobalCharacterStream
{
	set stream=##class(%GlobalCharacterStream).%New()
	Quit:DocumentID="" stream
	set resObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAccessRp).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set resObj.Header=header
	set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAcess).%New()
	set DocumentsObj=##class(web.DHCENS.STBLL.DOCU.MODEL.Documents).%New()
	set DocumentObj=##class(web.DHCENS.STBLL.DOCU.MODEL.AccDocument).%New()
	set bodyObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAcessBody).%New()
	set DocumentObj.DocumentID=DocumentID
	set documentDr=$o(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",DocumentID,""))
	set reportstream=##class(%GlobalCharacterStream).%New()
	set hosobj=##class(User.EnsHOSDocument).%OpenId(documentDr)
	do reportstream.CopyFrom(hosobj.HOSDCContent)
	set reportString=reportstream.Read(reportstream.Size)
	set:SourceSystem'="02" reportString=$ZCONVERT(reportString,"O","UTF8")
	set:SourceSystem'="02" reportString=$system.Encryption.Base64Encode(reportString)
	set DocumentObj.repotUrl=hosobj.HOSDUrl
	set DocumentObj.UpdateDate=hosobj.UpdateDate
	set DocumentObj.UpdateTime=hosobj.UpdateTime
	set DocumentObj.UpdateUser=$P(hosobj.HOSDUpdateUserCode,"_",2)
	do stream.Write(reportString)
	set DocumentObj.DocumentContent=stream
	set DocumentsObj.DocumentList=DocumentObj
	set obj.Documents=DocumentsObj
	set bodyObj.DocumentSearchRp=obj
	set bodyObj.ResultCode=0
	set bodyObj.ResultContent="成功"
	set resObj.Body=bodyObj
	d resObj.XMLExportToStream(.stream1)
	Quit stream1
}

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentAccess).SearchLisReport("1801240197").Read()
ClassMethod SearchLisReport(DocumentID As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	Quit:DocumentID="" stream
	set resObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAccessRp).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set resObj.Header=header
	set bodyObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAcessBody).%New()
	set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuAcess).%New()
	set obj.DocumentID=DocumentID
	set AuthDate=$lg(^dbo.RPVisitNumberReportD(DocumentID),19)
	set:AuthDate'="" AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
	set AuthTime=$lg(^dbo.RPVisitNumberReportD(DocumentID),20)
	set:AuthTime'="" AuthTime=$zt(AuthTime)
	set obj.UpdateDate=AuthDate
	set obj.UpdateTime=AuthTime
	set obj.UpdateUser="demo"
	set XmlString=##class(web.DHCENS.STBLL.LIS.METHOD.NewReportResult).LISReportResult(DocumentID)
	//set XmlString=$ZCONVERT(XmlString,"O","UTF8")
	//set XmlString=$system.Encryption.Base64Encode(XmlString)
	
	do stream.Write(XmlString)
	set obj.DocumentContent=stream
	do bodyObj.DocumentSearchRp.Insert(obj)
	set bodyObj.ResultCode=0
	set bodyObj.ResultContent="成功"
	set resObj.Body=bodyObj
	d resObj.XMLExportToStream(.stream1)
	Quit stream1
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
