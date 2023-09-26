Class web.DHCENS.STBLL.DOCU.METHOD.DocumentRetrieval Extends (%RegisteredObject, %XML.Adaptor)
{

/// 文档检索
/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentRetrieval).test("PACS")
ClassMethod test(Type As %String) As %String
{
	//放射
	;2019-10-14 检查用
	s:Type="PACS" str="<Request><Header><SourceSystem>SYS0010</SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>0000000023</PATPatientID><PAADMVisitNumber>85964</PAADMVisitNumber><DocumentType>16</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	;2019-10-09 检验用
	;s:Type="PACS" str="<Request><Header><SourceSystem>SYS0010</SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>0000040418</PATPatientID><PAADMVisitNumber>64073</PAADMVisitNumber><DocumentType>01001</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	;s:Type="PACS" str="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>0000000002</PATPatientID><PAADMVisitNumber>5</PAADMVisitNumber><DocumentType>00</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
    //检验  
    ;s:Type="LIS" str="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>0000000012</PATPatientID><PAADMVisitNumber>19</PAADMVisitNumber><DocumentType>01</DocumentType><StartDate>2019-07-10</StartDate><EndDate>2019-08-01</EndDate><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
    ;s:Type="LIS" str="<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>0000084005</PATPatientID><PAADMVisitNumber>262</PAADMVisitNumber><DocumentType>01</DocumentType><StartDate>2019-08-01</StartDate><EndDate>2019-08-22</EndDate><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(str)
	s return=##class(%GlobalCharacterStream).%New()
	s return=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",stream)
	q return.Read(return.Size)
}

ClassMethod DocuRetrieval(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><ResultCode>-1</ResultCode><ResultContent>xml结构错误</ResultContent></Response>")
		Quit stream
	}
	else
 	{	set (PATPatientID,PAADMVisitNumber,DocumentType,DocumentFormat,StartDate,EndDate)=""
	 	set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/PATPatientID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/PAADMVisitNumber","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/DocumentType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/DocumentFormat","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentFormat=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/StartDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set StartDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/DocumentRetrievalRt/EndDate","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'=""))
		{					
			set fieldValue=tRes.GetAt(1).Value
			set EndDate=$tr(fieldValue,$c(0),"")
		}
		set stream=..getRetrieval(PATPatientID,PAADMVisitNumber,DocumentType,StartDate,EndDate,DocumentFormat)
 		Quit stream 
 	}
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// 获取报告列表
/// 文档检索
/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.DocumentRetrieval).getRetrieval("0000000055","78","00","","","xml").Read()
ClassMethod getRetrieval(PatientID As %String, AdmNo As %String, DocumentType As %String, StartDate As %String, EndDate As %String, DocumentFormat As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	
	set resObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocRetrievalResponse).%New()
	set Header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set resObj.Header=Header
	set BodyObj=##class(web.DHCENS.STBLL.DOCU.MODEL.DocuretrievalBody).%New()
	
	set DocumentsOBj=##class(web.DHCENS.STBLL.DOCU.MODEL.Retrieveal).%New()
	set inputStartDate="",inputEndDate=""
   if ((StartDate'="")&&(EndDate'="")){
		set inputStartDate=StartDate 
		set inputEndDate=EndDate 
		if inputStartDate'="" set inputStartDate=$zdh(inputStartDate,3)
		if inputEndDate'="" set inputEndDate=$zdh(inputEndDate,3)
	}
	set InputDocumentType=""
	;set:DocumentType="01002" DocumentType="01001"
	set:DocumentType="00" DocumentType="00,02001,02002,02003,02004,02005",InputDocumentType="00"
	set:DocumentType="99" DocumentType="01001,01002",InputDocumentType="99"
	set:DocumentType="03" DocumentType="02006",InputDocumentType="03"
	s DocuType="" f  set DocuType=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVisitNumberIndex",AdmNo,DocuType))  q:DocuType=""  d
	.q:((DocuType'="01001")&&(DocuType'="02001")&&(DocuType'="02002")&&(DocuType'="02003")&&(DocuType'="02004")&&(DocuType'="02005")&&(DocuType'="00")&&(DocuType'="01002")&&(DocuType'="02006"))
	.q:($l(DocumentType)=2)&&(DocumentType'[DocuType)
	.q:($l(DocumentType)=5)&&(DocumentType'[DocuType)
	.s docurowid="" f  set docurowid=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVisitNumberIndex",AdmNo,DocuType,docurowid),-1)  q:docurowid=""  d
	..s OrganId=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),4)
	..s SubsysDocumentID=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),8)
	..s VersionNumber=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),10)
	..s hosformat=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),12)
	..q:$d(DocumentRecord(OrganId,DocuType,hosformat,SubsysDocumentID))
	..s DocumentRecord(OrganId,DocuType,hosformat,SubsysDocumentID)=""
	..q:hosformat'=DocumentFormat
	..s update=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),15)
	..s:update="" update=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),17)
	..s uptime=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),16)
	..s:uptime="" uptime=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),18)
	..q:((update<inputStartDate)&&(inputStartDate'=""))
	..q:((update>inputEndDate)&&(inputEndDate'=""))
	..s HosDocumentID=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),2)
	..q:HosDocumentID=""
	..s UpdateUserCode=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),14)
	..s DocumentType1=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),9)
	..s HosPatId=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),5)
	..q:(DocumentType'[DocumentType1)
	..s orderids=""
	..set RelDocumentID=""
	..f  set RelDocumentID=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODDocumentID",HosDocumentID,RelDocumentID)) q:RelDocumentID=""  d
	...set orderid1=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelDocumentID),6)
	...if orderids="" s orderids=orderid1
	...e  s orderids=orderids_"^"_orderid1
	...s orderids=$replace(orderids,"_","||")
	..s orderidcount=$l(orderids,"^")
	..s arcDescs=""
	..f i=1:1:orderidcount  d
	...set orderid=$p(orderids,"^",i)
	...q:orderid=""
	...set ord = $P(orderid,"||",1)
	...set sub = $P(orderid,"||",2)
	...set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	...set arcimId = $P(ordstr1,"^",2)
    ...set arcSub = $P(arcimId,"||",1)
    ...set arcVer = $P(arcimId,"||",2)
    ...set arcDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
    ...if arcDescs'="" set arcDescs=arcDescs_","_arcDesc
    ...else  set arcDescs=arcDesc
	..set docuObj=##class(web.DHCENS.STBLL.DOCU.MODEL.Document).%New()
	..set docuObj.DocumentID=HosDocumentID
	..set docuObj.DocumentTitle=arcDescs  ;医嘱项名称
	..set:InputDocumentType'="" docuObj.DocumentType=InputDocumentType		;暂时默认检查结果
	..set:InputDocumentType="" docuObj.DocumentType=DocumentType		;暂时默认检查结果
	..set docuObj.DocumentPath=$lg(^Busi.ENS.EnsHOSDocumentD(docurowid),19)
	..set:docuObj.DocumentPath="" docuObj.DocumentPath="-"
	..set UpdateUserCode=$p(UpdateUserCode,"_",2)
	..set docuObj.UpdateUser=UpdateUserCode
	..set:update'="" docuObj.UpdateDate=$zd(update,3)
	..set docuObj.UpdateTime=$zt(uptime)
	..do DocumentsOBj.Documents.Insert(docuObj)
    set BodyObj.DocumentRetrievalRp=DocumentsOBj
	set count=BodyObj.DocumentRetrievalRp.Documents.Count()
	if count>0 d
	.set BodyObj.ResultCode=0
	.set BodyObj.ResultContent="成功"
	else  d
	.set BodyObj.ResultCode=-1
	.set BodyObj.ResultContent="未找到符合条件报告"	
	set resObj.Body=BodyObj
	do resObj.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// 去掉XML格式头信息
ClassMethod ClearXMLHeader(XMLString) As %String
{
	if $f(XMLString,"<?") {
		s prefixLen=$l($p(XMLString,"?>",1)_"?>")
		s XMLString=$e(XMLString,prefixLen+1,$l(XMLString))
	}
	q XMLString
}

}
