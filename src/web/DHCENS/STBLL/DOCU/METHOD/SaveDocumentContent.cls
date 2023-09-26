Class web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent Extends (%RegisteredObject, %XML.Adaptor)
{

/// s tempString =$zcvt(tempString,"O","UTF8")
/// s tempString=$System.Encryption.Base64Encode(tempString)
/// w ##class(hdc.Entity.Method.HOSDocument).SaveHOSDocumentImage()
/// Creator:lipan
/// CreateDate:2018-12-03
/// Desc:保存文档信息
/// Input:文档信息:inputContent
/// Return:
/// 保存文档
ClassMethod SaveHOSDocumentImage(inputContent As %GlobalCharacterStream) As %String
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	d inputContent.Rewind()
	if $$$ISERR(tSC) {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_tSC_"]]></ResultContent></Body></Response>"
	}else{

		set OrganizationCode=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OrganizationCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OrganizationCode=$tr(fieldValue,$c(0),"")
		}
		set hosPATPatientID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hosPATPatientID=$tr(fieldValue,$c(0),"")
		}
		set hosPAADMVisitNumber=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hosPAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set DocumentType="",DocumentCate=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentType","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentType=$tr(fieldValue,$c(0),"")
			set DocumentCate=$e(DocumentType,1,2)
		}
		set DocumentID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentID=$tr(fieldValue,$c(0),"")
		}
		set DocumentContent=""		
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentContent","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentContent=fieldValue
		}

		set UpdateUserCode=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set UpdateDate=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set UpdateTime=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}
		set DocumentPath=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/DocumentPath","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set DocumentPath=$tr(fieldValue,$c(0),"")
		}
		set hospRisExamId=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospRisExamId=$tr(fieldValue,$c(0),"")
		}
		set hospSpecimenID=""	
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set hospSpecimenID=$tr(fieldValue,$c(0),"")
		}
		set BusinessFieldCode=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/BusinessFieldCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set BusinessFieldCode=$tr(fieldValue,$c(0),"")
		}
		
		set HosOrderItemIDStr=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/OEORIOrderItemID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set HosOrderItemIDStr=$tr(fieldValue,$c(0),"")
			if (DocumentCate="02") {
				if HosOrderItemIDStr["_"{
					set HosOrderItemIDStr=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(HosOrderItemIDStr,"_","||")
				}
			}
		}
		set HospitalCode="" 
		set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt/HospitalCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set HospitalCode=$tr(fieldValue,$c(0),"")
		}
		Quit:BusinessFieldCode="" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>业务域代码不能为空</ResultContent></Body></Response>"	
		/*if HospitalCode="" {
			set HospitalCode=##class(hdc.Dao.CTHospital).HospitalCode(BusinessFieldCode)
		}
		else {
			set HospitalCode=BusinessFieldCode_"_"_HospitalCode
		}*/	
			
		Quit:HospitalCode="" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>院区代码不能为空</ResultContent></Body></Response>"
		set patientId=""
		if hosPATPatientID'=""{
        	set patientId=$o(^PAPERi("PAPMI_PatNo",hosPATPatientID,""))
		}
		Quit:patientId="" "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>登记号为: "_hosPATPatientID_"的病人在HIS不存在</ResultContent></Body></Response>"
		Quit:hosPAADMVisitNumber="" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>就诊号为: "_hosPAADMVisitNumber_"的就诊号在HIS不存在</ResultContent></Body></Response>"
		if (DocumentCate="01"){
			if hospSpecimenID'=""{
				
			    s OrdId=$o(^OEORD(0,"EpisNo",hospSpecimenID,""))	
				q:OrdId="" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>条码号"_hospSpecimenID_"在OE_OrdItem表中不存在</ResultContent></Body></Response>"
			}
		}
		
		;set ord = $P(HosOrderItemIDStr,"||",1)
		;set sub = $P(HosOrderItemIDStr,"||",2)	
		;set ordstr1 = $g(^OEORD(ord,"I",sub,1))
		;set ordStatusRowID = $P(ordstr1,"^",13)
		;Quit:ordStatusRowID'="6" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱状态为非执行状态，不能保存报告</ResultContent></Body></Response>"
		
		ts
		if DocumentContent'=""{
			set curversion=""
			set lastversion=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex",HospitalCode,DocumentType,"xml",DocumentID,""),-1)
			if lastversion=""{
				s curversion=1
			}else{
				s curversion=lastversion+1
			}
			
			//处理xml超长问题
			Set DocString=""
			If $isobject(DocumentContent) = 1 {
		         Set len = DocumentContent.Size
		         Do DocumentContent.Rewind()
		         Set DocString = DocumentContent.Read(.len, .st)
		    
			} else {
		         Set DocString = DocumentContent
			}
			set DocumentContent=$SYSTEM.Encryption.Base64Decode(DocString)
			//set DocumentContent=##class(hdc.Db.Eval).EvalXML(DocumentContent)
			set DocumentContent=$zcvt(DocumentContent,"I","UTF8")
			set stream=##class(%GlobalCharacterStream).%New()
		    s:DocumentContent["<?xml version=""1.0"" encoding=""UTF-8""?>" DocumentContent=$e(DocumentContent,39,$l(DocumentContent))
			d stream.Write(DocumentContent)
			if (DocumentCate="01") {
				set tSC=##class(web.DHCENS.STBLL.LIS.METHOD.LISReportResult).InsertLISReportResultObj(BusinessFieldCode,HospitalCode,hosPATPatientID,hosPAADMVisitNumber,stream,DocumentType,.LisReportID)
				b ;tSC LisReport
				if $p(tSC,"^",1)'=1 {
					tro
					set faCount=faCount+1
					set faInfo="保存检验结构化数据失败，HOSDSerialNumber："_DocumentID_"错误,原因："_$p(tSC,"^",2)_";"
					Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}
			}
			
			if ((DocumentCate="02")&&(DocumentType'="02006")) {
				set tSC=##class(web.DHCENS.STBLL.RIS.METHOD.SaveRisReport).SaveRisReportResult(stream,patientId,hosPAADMVisitNumber,.RISReportID)
				set ^templj("ris")=tSC
				b ;tSC RisReport
				if $p(tSC,"^",1)'=1 {
					tro
					set faCount=faCount+1
					set faInfo="保存检查结构化数据失败，HOSDSerialNumber："_DocumentID_"错误,原因："_$p(tSC,"^",2)_";"
					Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}
			}
			set SerialNumber=DocumentType_"_"_DocumentID_"_"_curversion_".xml"
			set xmlSerialNumber=SerialNumber
			set pTarget=##class(User.EnsHOSDocument).%New()
			set pTarget.HOSDSerialNumber=xmlSerialNumber
			set pTarget.HOSDOrganId=HospitalCode
			d pTarget.HOSDPatientIDSetObjectId(patientId)
			d pTarget.HOSDVisitNumberSetObjectId(hosPAADMVisitNumber) 
			set pTarget.HOSDManufacturerID="00001"
			set pTarget.HOSDSubsysDocumentID=DocumentID
			set pTarget.HOSDClassificationCode=DocumentType
			set pTarget.HOSDTemplateVersionNumber=curversion
			set pTarget.HOSDTypeCode="1"	
			set pTarget.HOSDFormat="xml"		
			set pTarget.HOSDStatus="1"
			set:UpdateUserCode'="" UpdateUserCode=BusinessFieldCode_"_"_UpdateUserCode	
			set pTarget.HOSDUpdateUserCode=UpdateUserCode	
			set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)			
			set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)		
			set pTarget.HOSDUrl=""
			d stream.Rewind()
			d (pTarget.HOSDCContent).CopyFrom(stream)
			set tSC=pTarget.%Save()
			
			if $$$ISOK(tSC) {
		    	set XMLDocumentID = pTarget.HOSDDocumentID
				d pTarget.%Close()
			}else {
				tro
				s faInfo = "-1^保存xml时Hos_Document表失败,原因: "_$SYSTEM.Status.GetErrorText(tSC)
				q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
			}
			
			b ;01?
			if (DocumentCate="01"){
				s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(XMLDocumentID,LisReportID,"","xml",HosOrderItemIDStr,"",hospSpecimenID)
				 b ;tSC RelOrderDocument
				  if $p(tSC,"^",1)'=1{
					tro
					set faInfo="保存xml时Rel_OrderDocument表失败"_$p(tSC,"^",2)
					q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}
				
			}
			if ((DocumentCate="02")&&(DocumentType'="02006")){
				s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(XMLDocumentID,"",RISReportID,"xml",HosOrderItemIDStr,hospRisExamId,"")
				b ;tSC RelOrderDocument
				if $p(tSC,"^",1)'=1{
					tro
					set faInfo="保存xml时Rel_OrderDocument表失败"_$p(tSC,"^",2)
					q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}
			}
			if (DocumentType="02006"){
				s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(XMLDocumentID,"","","xml",HosOrderItemIDStr,hospRisExamId,"")
				b ;tSC RelOrderDocument
				if $p(tSC,"^",1)'=1{
					tro
					set faInfo="保存xml时Rel_OrderDocument表失败"_$p(tSC,"^",2)
					q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}
			}
			
		}
 
		if (DocumentPath'=""){
			set curversion=""
			set lastversion=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex",HospitalCode,DocumentType,"pdf",DocumentID,""),-1)
			if lastversion=""{
				s curversion=1
			}else{
				s curversion=lastversion+1
			}
			set SerialNumber=DocumentType_"_"_DocumentID_"_"_curversion_".pdf"
			set pdfSerialNumber=SerialNumber
			set pTarget=##class(User.EnsHOSDocument).%New()
			set pTarget.HOSDSerialNumber=pdfSerialNumber
			set pTarget.HOSDOrganId=HospitalCode
			d pTarget.HOSDPatientIDSetObjectId(patientId)
			d pTarget.HOSDVisitNumberSetObjectId(hosPAADMVisitNumber) 
			set pTarget.HOSDManufacturerID="00001"
			set pTarget.HOSDSubsysDocumentID=DocumentID
			set pTarget.HOSDClassificationCode=DocumentType
			set pTarget.HOSDTemplateVersionNumber=curversion
			set pTarget.HOSDTypeCode="1"	
			set pTarget.HOSDFormat="pdf"		
			set pTarget.HOSDStatus="1"
			set:UpdateUserCode'="" UpdateUserCode=BusinessFieldCode_"_"_UpdateUserCode		
			set pTarget.HOSDUpdateUserCode=UpdateUserCode		
			set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)			
			set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)		
			set pTarget.HOSDUrl=DocumentPath
		    set tSC=pTarget.%Save()
			if $$$ISOK(tSC) {
		    	set PDFDocumentID = pTarget.HOSDDocumentID
				d pTarget.%Close()
			}else {
				tro
				s faInfo = "-1^保存pdf时Hos_Document表失败,原因: "_$SYSTEM.Status.GetErrorText(tSC)
				q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
			}
		
			if ((DocumentCate'="03")&&(DocumentCate'="04")&&(DocumentCate'="06")&&(DocumentCate'="08")){
				s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.HOSDocument).SelectHOSDDocumentIDBySubsysDocuID(HospitalCode,DocumentType,"xml",DocumentID)  //查找xml文档是否已经存了,如果已经存了返回XMLDocumentID
			    b ;;;0001
			    if $p(tSC,"^",1)'=1{
			    	tro
				    q "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_$p(tSC,"^",2)_"]]></ResultContent></Body></Response>"
			    }
				s xmlDocumentID=$p(tSC,"^",2)  //如果xmlDocumentID为空，说明没有回传xml文档，或者没有保存成功,所以就找不出LISReportID	
				if (DocumentCate="01"){
					s LisReportID=""
					if xmlDocumentID'=""{              
						s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).SelectLisReportIDByDocumentID(xmlDocumentID)  //根据XMLDocumentID获取LISReportID
						b ;;0002
						if $p(tSC,"^",1)'=1{
							tro
							q "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_$p(tSC,"^",2)_"]]></ResultContent></Body></Response>"
						}
						s LisReportID=$p(tSC,"^",2)
						b ;lisreportid
					}
					s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(PDFDocumentID,LisReportID,"","pdf",HosOrderItemIDStr,"",hospSpecimenID)
					b ;;0003
					  if $p(tSC,"^",1)'=1{
						tro
						set faInfo="保存pdf时Rel_OrderDocument表失败"_$p(tSC,"^",2)
						q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
					}
					
				}
				if ((DocumentCate="02")&&(DocumentType'="02006")){
					s RisReportID=""
					if xmlDocumentID'=""{
						s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).SelectRisReportIDByDocumentID(xmlDocumentID)
						b ;;0004
						if $p(tSC,"^",1)'=1{
							tro
							q "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_$p(tSC,"^",2)_"]]></ResultContent></Body></Response>"
						}
						s RisReportID=$p(tSC,"^",2)
					}
					s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(PDFDocumentID,"",RisReportID,"pdf",HosOrderItemIDStr,hospRisExamId,"")
					b ;;0005
					if $p(tSC,"^",1)'=1{
						tro
						set faInfo="保存pdf时Rel_OrderDocument表失败"_$p(tSC,"^",2)
						q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
					}
				}
				if (DocumentType="02006"){
					s RisReportID=""
					if xmlDocumentID'=""{
						s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).SelectRisReportIDByDocumentID(xmlDocumentID)
						b ;;0004
						if $p(tSC,"^",1)'=1{
							tro
							q "<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_$p(tSC,"^",2)_"]]></ResultContent></Body></Response>"
						}
					}
					s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(PDFDocumentID,"","","pdf",HosOrderItemIDStr,hospRisExamId,"")
					b ;;0005
					if $p(tSC,"^",1)'=1{
						tro
						set faInfo="保存pdf时Rel_OrderDocument表失败"_$p(tSC,"^",2)
						q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
					}
				}
			}
			else {
				s tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.RelOrderDocument).RelOrderDocumentInsert(PDFDocumentID,"","","pdf","","","")
				b ;;0005
				if $p(tSC,"^",1)'=1{
					tro
					set faInfo="保存pdf时Rel_OrderDocument表失败"_$p(tSC,"^",2)
					q "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_faInfo_"]]></ResultContent></Body></Response>"
				}	
			}
		
		}
	
		tc

		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>1^成功数量</ResultContent></Body></Response>"
	}
	
		
Exception
	tro
	b ;ze
	Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent><![CDATA["_$ze_"]]></ResultContent></Body></Response>"
}

ClassMethod base64(srcStream As %Stream.TmpCharacter) As %GlobalCharacterStream
{
	s tarStream=##class(%Stream.TmpCharacter).%New()
	s tLen=3*1000
	while 'srcStream.AtEnd{
		s tmpStr=srcStream.Read(tLen)
		s tmpStr=$zcvt(tmpStr,"O","UTF8")
		s encodeStr=$system.Encryption.Base64Encode(tmpStr)
		d tarStream.Write(encodeStr)
	}
	   
	q tarStream
}

/// Creator：ZhangXinying
/// CreatDate：2020—07-08
/// Description：保存以xml格式传入的检查、检验、病理结果信息(其中报告内容以base64加密),生成文档和结构化存储表，如果DocumentContent不为空，则生成xml文档，如果DocumentPath不为空，则根据url文件名后缀生成相应记录
/// Table：Ens_HOSDocument,Ens_RelOrderDocument,Ens_LISReportResult,Ens_LISItemResult,Ens_LISItemResSen,Ens_LISItemResRst,Ens_RISReportResult,Ens_RISItemResult
/// Input：xml流格式的检查、检验、病理结果
/// Return：1：创建成功，-1：失败原因
ClassMethod SaveXMLResult(inputContent As %GlobalCharacterStream) As %String
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_tSC_"</ResultContent></Body></Response>"
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body","count(RegisterDocumentRt)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>信息为空</ResultContent></Body></Response>"
			for i=1:1:hsCount {	
				set DocumentID=""
				set PATPatientID=""
				set PAADMVisitNumber=""
				set OrganizationCode=""	
				set DocumentType=""
				set UpdateUserCode=""
				set UpdateDate=""
				set UpdateTime=""
				set DocumentPath=""
				set DocumentContent=""
				set OEORIOrderItemID=""
				set RISRExamID=""
				set SpecimenID=""
				set DocumentPath=""
				set DocumentPicPath=""
				// 来源系统的文档流水号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentID=$tr(fieldValue,$c(0),"")
				}
				// 患者主索引
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/PATPatientID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PATPatientID=$tr(fieldValue,$c(0),"")
				}
				// 就诊号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/PAADMVisitNumber","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
				}	
				// 医疗机构编码
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/OrganizationCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OrganizationCode=$tr(fieldValue,$c(0),"")
				}	
				// 文档类别
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentType","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentType=$tr(fieldValue,$c(0),"")
				}
				// 最后更新人编码	
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateUserCode=$tr(fieldValue,$c(0),"")
				}	
				// 结果更新日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}
				// 结果更新时间
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				// LIS或PACS提供的报告链接
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentPath","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentPath=$tr(fieldValue,$c(0),"")
				}
				// LIS或PACS提供的图像链接
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentPicPath","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set DocumentPicPath=$tr(fieldValue,$c(0),"")
				}
				// base加密过的检查/检验报告
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/DocumentContent","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set DocumentContent=tRes.GetAt(1).Value
					;set DocumentContent=$tr(fieldValue,$c(0),"")
				}
				// 医嘱号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/OEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}	
				// 检查号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/RISRExamID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set RISRExamID=$tr(fieldValue,$c(0),"")
				}
				// 样本号
				set tSC=tDocument.EvaluateExpression("/Request/Body/RegisterDocumentRt["_i_"]/SpecimenID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set SpecimenID=$tr(fieldValue,$c(0),"")
				}	
				if DocumentContent'=""{
					set DocumentIndex=DocumentType_"_"_DocumentID_".xml" 
					set tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetDocRowIdByDocNum(DocumentIndex,.id)
					continue:tSC'=1
					// 文档尚未存储
					if id="" {
						set pTarget=##class(User.EnsHOSDocument).%New()
						set pTarget.HOSDSerialNumber=DocumentIndex
						set pTarget.HOSDFormat="xml"
						// 患者基本信息表的rowId
						set patRowId=""
						set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
						d pTarget.HOSDPatientIDSetObjectId(patRowId)
						// 患者就诊表的rowId
						set admRowId=""
						set admRowId=PAADMVisitNumber
						//set admRowId=$o(^PAADMi("No",PAADMVisitNumber,admRowId))
						d pTarget.HOSDVisitNumberSetObjectId(admRowId)
						//医疗机构编码
						set pTarget.HOSDOrganId=OrganizationCode
						//文档来源
						set pTarget.HOSDManufacturerID="00001"
						//子系统内文档的唯一标识(===XML中的文档流水号)
						set pTarget.HOSDSubsysDocumentID=DocumentID
						//文档类型
						set pTarget.HOSDClassificationCode=DocumentType
						//文档版本号
						set pTarget.HOSDTemplateVersionNumber="V1.0"
						//文档类型编码
						set pTarget.HOSDTypeCode="1"
						//文档状态码
						set pTarget.HOSDStatus="1"
						set pTarget.HOSDUpdateUserCode=UpdateUserCode
						set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)		
						set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
						;set pTarget.HOSDUrl=DocumentPath //当文档类型为XML时，不传URL字段的值和图像路径的值
						;set pTarget.HOSDCPicUrl=DocumentPicPath
						set xmlString=""
						// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
						if $ISObject(DocumentContent){
							Set len = DocumentContent.Size
					    	Do DocumentContent.Rewind()
					    	Set xmlString = DocumentContent.Read(.len, .st)
						}else{
							set xmlString=DocumentContent
						}
						set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
						set xmlString=$zcvt(xmlString,"I","UTF8")
						do pTarget.HOSDCContent.Write(xmlString)
						set tSC=0
						ts
						set tSC = pTarget.%Save()
						if $$$ISOK(tSC) {
						//HOSDocument的RowID
						set HOSDRowID = pTarget.%Id()
						set:OEORIOrderItemID["_" OEORIOrderItemID=$replace(OEORIOrderItemID,"_","||")
						set OrdLen=$l(OEORIOrderItemID,"^")
						set ordIndex=0
						for
						{
							set ordIndex=ordIndex+1
							Quit:(ordIndex>OrdLen)
							// 文档存储成功后，新建文档关联表，存储医嘱等相关信息
							set relDocObj=##class(User.EnsRelOrderDocument).%New()
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号与就诊表核对
							set OrderItemID=$p(OEORIOrderItemID,"^",ordIndex)
							set ordId=$p(OrderItemID,"||",1) //医嘱主表的rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) //通过医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(HOSDRowID),2)
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
						set ResultCode="",ResultContent=""
						if (DocumentType="01001")||(DocumentType="01002") //检验报告、微生物检验报告
						{
							set ParseLISReportRet=##class(%GlobalCharacterStream).%New()
							set ParseLISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParseLISReport(inputContent)	
							set ResultCode=..GetResultCode(ParseLISReportRet)
							set ResultContent=..GetResultContent(ParseLISReportRet)
						}
						if (DocumentType="02001")||(DocumentType="02002")||(DocumentType="02003")||(DocumentType="02004")||(DocumentType="02005") //文档类型02001-02006分别为放射,超声,内镜,心电,核医学,病理报告
						{
							set ParsePACSReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePACSReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePACSReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePACSReportRet)
							set ResultContent=..GetResultContent(ParsePACSReportRet)
						}
						if (DocumentType="02006") //病理报告
						{
							set ParsePISReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePISReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePISReportRet)
							set ResultContent=..GetResultContent(ParsePISReportRet)
						}
						if ($e(DocumentType,1,2)="04")||($e(DocumentType,1,2)="05") //手麻单 
						{
							set ResultCode="0",ResultContent="成功"	
						}
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)&&(ResultCode="0")){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
				}
				// 文档已存在进行更新 id不为空
				else { 
					set pTarget=##class(User.EnsHOSDocument).%OpenId(id)
					
					set pTarget.HOSDSerialNumber=DocumentType_"_"_DocumentID_".xml"
					set pTarget.HOSDFormat="xml"
				
					// 患者基本信息表rowId
					set patRowId=""
					set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
					d pTarget.HOSDPatientIDSetObjectId(patRowId)
					 // 患者就诊表rowId
					set admRowId=""
					set admRowId=PAADMVisitNumber
					d pTarget.HOSDVisitNumberSetObjectId(admRowId)
					set pTarget.HOSDOrganId=OrganizationCode
					set:pTarget.HOSDManufacturerID="" pTarget.HOSDManufacturerID=2
					set pTarget.HOSDSubsysDocumentID=DocumentID
					set pTarget.HOSDClassificationCode=DocumentType
					set pTarget.HOSDTemplateVersionNumber="V1.0"
					set pTarget.HOSDTypeCode="1"
					set pTarget.HOSDStatus="1"
					set pTarget.HOSDUpdateUserCode=UpdateUserCode
					set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)			
					set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
					;set pTarget.HOSDUrl=DocumentPath //当文档类型为XML时，不传URL字段的值和图像路径的值
					;set pTarget.HOSDCPicUrl=DocumentPicPath
					set xmlString=""
					// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
					if $ISObject(DocumentContent){
						Set len = DocumentContent.Size
					    Do DocumentContent.Rewind()
					    Set xmlString = DocumentContent.Read(.len, .st)
					}else{
						set xmlString=DocumentContent
					}
					set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
					set xmlString=$zcvt(xmlString,"I","UTF8")
					do pTarget.HOSDCContent.Write(xmlString)
					set tSC=0
					ts
					set tSC = pTarget.%Save()
					if $$$ISOK(tSC) {
						// 文档内容更新成功后，更新文档关联表
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(id),2)
						set relDocRowId=""
						for     
						{
							set relDocRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODDocumentID",documentId,relDocRowId))
							q:relDocRowId=""
							set relDocObj=##class(User.EnsRelOrderDocument).%OpenId(relDocRowId)
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号
							set ordId=$p(OEORIOrderItemID,"||",1) // 医嘱主表rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) // 根据医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}
							else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OEORIOrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID						
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
						set ResultCode="",ResultContent=""
						if (DocumentType="01001")||(DocumentType="01002") //检验报告、微生物检验报告
						{
							set ParseLISReportRet=##class(%GlobalCharacterStream).%New()
							set ParseLISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParseLISReport(inputContent)	
							set ResultCode=..GetResultCode(ParseLISReportRet)
							set ResultContent=..GetResultContent(ParseLISReportRet)
						}
						if (DocumentType="02001")||(DocumentType="02002")||(DocumentType="02003")||(DocumentType="02004")||(DocumentType="02005") //文档类型02001-02006分别为放射,超声,内镜,心电,核医学
						{
							set ParsePACSReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePACSReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePACSReport(inputContent)
							set ResultCode=..GetResultCode(ParsePACSReportRet)
							set ResultContent=..GetResultContent(ParsePACSReportRet)
						}
						if (DocumentType="02006") //病理报告
						{
							set ParsePISReportRet=##class(%GlobalCharacterStream).%New()
							set ParsePISReportRet=##class(web.DHCENS.STBLL.Method.PostReportInfo).ParsePISReport(inputContent)	
							set ResultCode=..GetResultCode(ParsePISReportRet)
							set ResultContent=..GetResultContent(ParsePISReportRet)
						}
						if ($e(DocumentType,1,2)="04")||($e(DocumentType,1,2)="05") //手麻单 
						{
							set ResultCode="0",ResultContent="成功"	
						}
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)&&(ResultCode="0")){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
				  }	
				}
				///文档路径不为空，按文档类型插入文档表、医嘱文档关联表
				if DocumentPath'=""
				{
					s DocumentIndex="",DocumentFormat=""
					if DocumentPath[".pdf" {
						s DocumentIndex=DocumentType_"_"_DocumentID_".pdf"
						s DocumentFormat="pdf"
					}
					if DocumentPath[".jpg" {
						s DocumentIndex=DocumentType_"_"_DocumentID_".jpg"
						s DocumentFormat="jpg"
					}
					if DocumentPath[".html" {
						s DocumentIndex=DocumentType_"_"_DocumentID_".html" 	
						s DocumentFormat="html"
					}
					set tSC=##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent83).GetDocRowIdByDocNum(DocumentIndex,.id)
					continue:tSC'=1
					// 文档尚未存储 path
					if id="" {
						set pTarget=##class(User.EnsHOSDocument).%New()
						set pTarget.HOSDSerialNumber=DocumentIndex
						set pTarget.HOSDFormat=DocumentFormat
						// 患者基本信息表的rowId
						set patRowId=""
						set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
						d pTarget.HOSDPatientIDSetObjectId(patRowId)
						// 患者就诊表的rowId
						set admRowId=""
						set admRowId=PAADMVisitNumber
						//set admRowId=$o(^PAADMi("No",PAADMVisitNumber,admRowId))
						d pTarget.HOSDVisitNumberSetObjectId(admRowId)
						//医疗机构编码
						set pTarget.HOSDOrganId=OrganizationCode
						//文档来源
						set pTarget.HOSDManufacturerID="00001"
						//子系统内文档的唯一标识(===XML中的文档流水号)
						set pTarget.HOSDSubsysDocumentID=DocumentID
						//文档类型
						set pTarget.HOSDClassificationCode=DocumentType
						//文档版本号
						set pTarget.HOSDTemplateVersionNumber="V1.0"
						//文档类型编码
						set pTarget.HOSDTypeCode="1"
						//文档状态码
						set pTarget.HOSDStatus="1"
						set pTarget.HOSDUpdateUserCode=UpdateUserCode
						set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)		
						set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
						set pTarget.HOSDUrl=DocumentPath
						set pTarget.HOSDCPicUrl=DocumentPicPath
						set xmlString=""
						// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
						/*
						if $ISObject(DocumentContent){
							Set len = DocumentContent.Size
						    Do DocumentContent.Rewind()
					    	Set xmlString = DocumentContent.Read(.len, .st)
						}else{
							set xmlString=DocumentContent
						}
						set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
						set xmlString=$zcvt(xmlString,"I","UTF8")
						do pTarget.HOSDCContent.Write(xmlString)
						*/
						set tSC=0
						ts
						set tSC = pTarget.%Save()
						if $$$ISOK(tSC) {
						//HOSDocument的RowID
						set HOSDRowID = pTarget.%Id()
						set:OEORIOrderItemID["_" OEORIOrderItemID=$replace(OEORIOrderItemID,"_","||")
						set OrdLen=$l(OEORIOrderItemID,"^")
						set ordIndex=0
						for
						{
							set ordIndex=ordIndex+1
							Quit:(ordIndex>OrdLen)
							// 文档存储成功后，新建文档关联表，存储医嘱等相关信息
							set relDocObj=##class(User.EnsRelOrderDocument).%New()
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号与就诊表核对
							set OrderItemID=$p(OEORIOrderItemID,"^",ordIndex)
							set ordId=$p(OrderItemID,"||",1) //医嘱主表的rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) //通过医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(HOSDRowID),2)
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
	
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
				}
				// 文档已存在进行更新 id不为空 path
				else { 
					set pTarget=##class(User.EnsHOSDocument).%OpenId(id)
					
					set pTarget.HOSDSerialNumber=DocumentIndex
					set pTarget.HOSDFormat=DocumentFormat
				
					// 患者基本信息表rowId path
					set patRowId=""
					set patRowId=$o(^PAPERi("PAPMI_PatNo",PATPatientID,patRowId))
					d pTarget.HOSDPatientIDSetObjectId(patRowId)
					 // 患者就诊表rowId
					set admRowId=""
					set admRowId=PAADMVisitNumber
					d pTarget.HOSDVisitNumberSetObjectId(admRowId)
					set pTarget.HOSDOrganId=OrganizationCode
					set:pTarget.HOSDManufacturerID="" pTarget.HOSDManufacturerID=2
					set pTarget.HOSDSubsysDocumentID=DocumentID
					set pTarget.HOSDClassificationCode=DocumentType
					set pTarget.HOSDTemplateVersionNumber="V1.0"
					set pTarget.HOSDTypeCode="1"
					set pTarget.HOSDStatus="1"
					set pTarget.HOSDUpdateUserCode=UpdateUserCode
					set:UpdateDate'="" pTarget.HOSDUpdateDate=$zdh(UpdateDate,3)			
					set:UpdateTime'="" pTarget.HOSDUpdateTime=$zth(UpdateTime,1)
					set pTarget.HOSDUrl=DocumentPath
					set pTarget.HOSDCPicUrl=DocumentPicPath
					set xmlString=""
					// 若文档内容超长，则用xpath解析时自动存储为流的形式，在解密前需要先转换为字符串格式
					/*
					if $ISObject(DocumentContent){
						Set len = DocumentContent.Size
					    Do DocumentContent.Rewind()
					    Set xmlString = DocumentContent.Read(.len, .st)
					}else{
						set xmlString=DocumentContent
					}
					set xmlString=$SYSTEM.Encryption.Base64Decode(xmlString)
					set xmlString=$zcvt(xmlString,"I","UTF8")
					do pTarget.HOSDCContent.Write(xmlString)
					*/
					set tSC=0
					ts
					set tSC = pTarget.%Save()
					if $$$ISOK(tSC) {
						// 文档内容更新成功后，更新文档关联表
						//文档ID与HOS_Document的主键一致 
					    set documentId=$lg(^Busi.ENS.EnsHOSDocumentD(id),2)
						set relDocRowId=""
						for     
						{
							set relDocRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("INDEXODDocumentID",documentId,relDocRowId))
							q:relDocRowId=""
							set relDocObj=##class(User.EnsRelOrderDocument).%OpenId(relDocRowId)
							// 患者基本信息表rowId
							d relDocObj.RelODPatientIDSetObjectId(patRowId)
							// 就诊表rowId
							d relDocObj.RelODVisitNumberSetObjectId(admRowId)
							// 医嘱号
							set ordId=$p(OEORIOrderItemID,"||",1) // 医嘱主表rowId
							set admRowId1=$p($g(^OEORD(ordId)),"^",1) // 根据医嘱主表找见的就诊表rowId
							if (admRowId1'=admRowId){
								set ordFlag=0
								if faInfo'="" {
									s faInfo=faInfo_"#"_"就诊号与医嘱号不匹配"
									}
								else {
									s faInfo="就诊号与医嘱号不匹配"
									}
							}
							else{
								set ordFlag=1	
								d relDocObj.RelODOrderItemIDSetObjectId(OEORIOrderItemID)
							}
						}
						set relDocObj.RelODRisExamID=RISRExamID
						set relDocObj.RelODSpecimenID=SpecimenID						
						set relDocObj.RelODDocumentID=documentId
						set relDocObj.RelODDocumentType=pTarget.HOSDFormat
						set reltSC=relDocObj.%Save()
					
						if $$$ISOK($$$ISOK(reltSC))&&($$$ISOK(ordFlag)){
							tc
							set relRowId=relDocObj.%Id()
							set suCount=suCount+1
						}else{	
							set faCount=faCount+1
							set faInfo=faInfo_"#"_ResultContent
							tro
						}
						d relDocObj.%Close()
					}
					else {
						tro
					}
					d pTarget.%Close()	
					}	
				}			
			}
		}
	}
	if ((faCount>0)||(suCount=0)) {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>成功数量："_suCount_",失败数量："_faCount_",失败内容："_faInfo_"</ResultContent></Body></Response>"
		
	}
	else {
		Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>"
		
	}
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	Quit "<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>"
}

ClassMethod GetResultCode(ResultStream As %GlobalCharacterStream) As %String
{
	set $zt="Err"
	set ResultCode=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResultStream,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		set fieldValue=tRes.GetAt(1).Value
		set ResultCode=$tr(fieldValue,$c(0),"")
	}
	q ResultCode
Err
	q "-1^"_$ze
}

ClassMethod GetResultContent(ResultStream As %GlobalCharacterStream) As %String
{
	set $zt="Err"
	set ResultContent=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResultStream,.tDocument)
	set tSC=tDocument.EvaluateExpression("/Response/Body/ResultContent","text()",.tRes)					
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
		set fieldValue=tRes.GetAt(1).Value
		set ResultContent=$tr(fieldValue,$c(0),"")
	}
	q ResultContent
Err
	q "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.SaveDocumentContent).test()
ClassMethod test() As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	;d stream.Write("<Request><Header><SourceSystem>SYS0005</SourceSystem><MessageID>PACS</MessageID></Header><Body><RegisterDocumentRt><OrganizationCode>00001</OrganizationCode><PATPatientID>0005473118</PATPatientID><PATPatientName>胡艳娥</PATPatientName><PAADMVisitNumber>79641</PAADMVisitNumber><RISRExamID>APPI2019091000416</RISRExamID><SpecimenID>APPI2019091000416</SpecimenID><OEORIOrderItemID>76347_9</OEORIOrderItemID><DocumentType>02002</DocumentType><DocumentID>F_BG2019091000174_085302</DocumentID><DocumentPath>ftp://ftpdh:ftpdh@192.168.0.35/pdfdata/2019/09/10/F_BG2019091000174_085302.pdf</DocumentPath><UpdateUserCode>8933</UpdateUserCode><UpdateDate>2019-09-10</UpdateDate><UpdateTime>08:55:21</UpdateTime><DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxjbGluaWNhbERvY3VtZW50Pg0KPGRvY3VtZW50SGVhZGVyPg0KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gDQoJPHR5cGVJZD48L3R5cGVJZD4gPCEtLeaWh+aho+exu+Weiy0tPg0KICA8dGVtcGxhdGU+PC90ZW1wbGF0ZT4gPCEtLeaooeadv0lE5Y+K54mI5pys5Y+3LS0+DQogICAgPGlkPjwvaWQ+ICA8IS0t5paH5qGj5rWB5rC05Y+3LS0+ICAgICAgICAgIA0KICAgIDx0aXRsZT7mo4Dmn6XmiqXlkYo8L3RpdGxlPg0KCTxlZmZlY3RpdmVUaW1lPjwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiANCgk8Y29uZmlkZW50aWFsaXR5IGNvZGU9Iue6p+WIq+S7o+eggSIgPjwvY29uZmlkZW50aWFsaXR5PiAgPCEtLeS/neWvhue6p+WIqy0tPg0KCTx2ZXJzaW9uTnVtYmVyPjwvdmVyc2lvbk51bWJlcj4gICA8IS0t5paH5qGj54mI5pys5Y+3LS0+DQoJPGF1dGhvciBpZD0i5Yy755Sf57yW5Y+3Ij48L2F1dGhvcj4JPCEtLeaWh+aho+WIm+S9nOiAhS0tPg0KCTxjdXN0b2RpYW4+PC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4NCgk8cGF0aWVudD4NCgkJPG1lZGljYXJlTm8+PC9tZWRpY2FyZU5vPiAgPCEtLeS9j+mZouWPty0tPg0KCQk8YWRtdmlzaXRObz48L2FkbXZpc2l0Tm8+ICA8IS0t5bCx6K+K5Y+3LS0+DQoJCTxtZWRSZWNvcmRObz48L21lZFJlY29yZE5vPiAgPCEtLeeXheahiOWPty0tPg0KCQk8aGVhbHRoQ2FyZE5vPjwvaGVhbHRoQ2FyZE5vPiAgPCEtLeWBpeW6t+WNoeWPty0tPg0KCQk8Y2VydGlmaWNhdGU+DQoJCQk8bmFtZSBjb2RlPSLor4Hku7bnsbvlnovku6PnoIEiPjwvbmFtZT4NCgkJCTx2YWx1ZT48L3ZhbHVlPg0KCQk8L2NlcnRpZmljYXRlPg0KCQk8YWRkciBkZXNjPSLnjrDkvY/lnYAiPg0KCQkJPHRleHQ+PC90ZXh0Pg0KCQkJPGhvdXNlTnVtYmVyPjwvaG91c2VOdW1iZXI+DQoJCQk8c3RyZWV0TmFtZT48L3N0cmVldE5hbWU+DQoJCQk8dG93bnNoaXA+PC90b3duc2hpcD4NCgkJCTxjb3VudHk+PC9jb3VudHk+DQoJCQk8Y2l0eT48L2NpdHk+DQoJCQk8c3RhdGU+PC9zdGF0ZT4NCgkJCTxwb3N0YWxDb2RlPjwvcG9zdGFsQ29kZT4NCgkJPC9hZGRyPg0KCQk8bmFtZT48L25hbWU+DQoJCTx0ZWxlY29tPjwvdGVsZWNvbT4NCgkJPGFkbWluaXN0cmF0aXZlR2VuZGVyIGNvZGU9IjEiID48L2FkbWluaXN0cmF0aXZlR2VuZGVyPg0KCQk8bWFyaXRhbFN0YXR1cyBjb2RlPSIyMCI+PC9tYXJpdGFsU3RhdHVzPg0KCQk8ZXRobmljR3JvdXAgY29kZT0iMDEiPjwvZXRobmljR3JvdXA+DQoJCTxhZ2UgdW5pdD0i5bKBIiB2YWx1ZT0iNjAiLz4NCgk8L3BhdGllbnQ+DQoJPHBhcnRpY2lwYW50Pg0KCQk8Y29kZSBjb2RlPSIxIj48L2NvZGU+DQogICAgICAgIDxhZGRyIGRlc2M9IuiBlOezu+S6uuWcsOWdgCI+CQ0KCQkJCTx0ZXh0PjwvdGV4dD4NCgkJCQk8aG91c2VOdW1iZXI+PC9ob3VzZU51bWJlcj4NCgkJCQk8c3RyZWV0TmFtZT48L3N0cmVldE5hbWU+DQoJCQkJPHRvd25zaGlwPjwvdG93bnNoaXA+DQoJCQkJPGNvdW50eT48L2NvdW50eT4NCgkJCQk8Y2l0eT48L2NpdHk+DQoJCQkJPHN0YXRlPjwvc3RhdGU+DQoJCQkJPHBvc3RhbENvZGU+PC9wb3N0YWxDb2RlPg0KCQk8L2FkZHI+DQoJCTx0ZWxlY29tPjwvdGVsZWNvbT4NCgkJPG5hbWU+PC9uYW1lPg0KCTwvcGFydGljaXBhbnQ+DQo8L2RvY3VtZW50SGVhZGVyPg0KPHN0cnVjdHVyZWRCb2R5Pg0KCTxFMDAwNCBkZXNjPSLlp5PlkI0iPuiDoeiJs+WopTwvRTAwMDQ+DQoJPEUwMDA1IGRlc2M9IuaAp+WIq+S7o+eggSI+MjwvRTAwMDU+DQoJPEUwMDA2IGRlc2M9IuaAp+WIq+aPj+i/sCI+5aWzPC9FMDAwNj4NCgk8RTAwMDggZGVzYz0i5bm06b6EIj41My4wMDwvRTAwMDg+DQoJPEUwMTQ4IGRlc2M9IueXheS6uuexu+Wei+S7o+eggSI+TzwvRTAxNDg+DQoJPEUwMTQ5IGRlc2M9IueXheS6uuexu+Wei+WQjeensCI+6Zeo6K+KPC9FMDE0OT4NCgk8RTAxNTYgZGVzYz0i56eR5a6kaWQiPjwvRTAxNTY+DQoJPEUwMDc3IGRlc2M9IuenkeWupCI+PC9FMDA3Nz4NCgk8RTAwMDIgZGVzYz0i5L2P6Zmi5Y+3Ij4wMDA1NDczMTE4PC9FMDAwMj4NCgk8RTAwMDAgZGVzYz0i6Zeo6K+K5Y+3Ij4wMDA1NDczMTE4PC9FMDAwMD4NCgk8RTAxNTQgZGVzYz0i55eF5bqKaWQiPjwvRTAxNTQ+DQoJPEUwMDc1IGRlc2M9IueXheW6iiI+PC9FMDA3NT4NCgk8c2VjdGlvbiBjb2RlPSJTMDA0OCIgZGVzYz0i6K+K5patIj4NCiAgICA8dGV4dD48L3RleHQ+ICA8IS0t6K+K5pat55qE6K+m57uG5L+h5oGvLS0+DQoJCTxFMDcgZGVzYz0i5Yy755Sf5aGr5YaZ55qE6K+K5patIj48L0UwNz4NCgkJPEUwMSBkZXNjPSLor4rmlq3lkI3np7AiPjwvRTAxPg0KCQk8RTAyIGRlc2M9IuiviuaWreS7o+eggSI+PC9FMDI+DQoJPC9zZWN0aW9uPg0KCTxzZWN0aW9uIGNvZGU9IlMwMDc2IiBkZXNjPSLmo4Dmn6XorrDlvZUiPg0KICAgIDx0ZXh0PjwvdGV4dD4gIDwhLS3mo4Dmn6XorrDlvZXnmoTor6bnu4bkv6Hmga8tLT4NCgkJPEUwMSBkZXNjPSLmo4Dmn6Xlj7ciPkFQUEkyMDE5MDkxMDAwNDE2PC9FMDE+DQoJCTxFMDIgZGVzYz0i5qOA5p+l6K6+5aSH57yW56CBIj48L0UwMj4NCgkJPEUwMyBkZXNjPSLmo4Dmn6Xorr7lpIflkI3np7AiPkFMT0tBKOS8muiviuWupCk8L0UwMz4NCgkJPEUwNCBkZXNjPSLmo4Dmn6Xpg6jkvY3ku6PnoIEiPjwvRTA0Pg0KCQk8RTA1IGRlc2M9IuajgOafpemDqOS9jeWQjeensCI+6IKd6IOG6IS+6IOwPC9FMDU+DQoJCTxFMDYgZGVzYz0i5qOA5p+l6YOo5L2N5Yy755Sf5omL5YaZIj7ogp3og4bohL7og7A8L0UwNj4NCgkJPEUwNyBkZXNjPSLmo4Dmn6Xpg6jkvY0iPjwvRTA3Pg0KCQk8RTA4IGRlc2M9IuajgOafpeaJgOingSI+6IKdICDohI/vvJrlvaLmgIHlpKflsI/mraPluLjvvIzooqvohpzlhYnmu5HvvIzogp3lj7Plj7blj6/op4HlpKflsI/nuqY3eDZtbeeojemrmOWbnuWjsO+8jOi+ueeVjOa4he+8jOWGheWbnuWjsOWwmuWdh+WMgO+8jENERkk65pyq6KeB5piO5pi+6KGA5rWB5L+h5Y+344CC5L2Z6IKd5a6e6LSo5YWJ54K55YiG5biD5Z2H5YyA77yM6IKd5YaF566h6YGT57q555CG5riF77yM6Zeo6Z2Z6ISJ5Li75bmy5YaF5b6EMTBtbeOAggogICAg6IOGICDlm4rvvJrlpKflsI82NXgyNW1t77yM5aOB5q+b57OZ77yM5ZuK5YaF5pyq6KeB5piO5pi+5byC5bi45Zue5aOw44CCCiAgICDohL4gIOiEj++8muWOmjI3bW3vvIzplb85Nm1t44CC6IS+6Zeo5aSE5Y+v6KeB5aSn5bCP57qmMjB4MTNtbeexu+iEvuagt+WbnuWjsOOAggogICAg6IOwICDohbrvvJrlvaLmgIHlpKflsI/mraPluLjvvIzlm57lo7DlnYfljIDjgII8L0UwOD4NCgkJPEUwOSBkZXNjPSLmo4Dmn6Xnu5PmnpwiPuiCneWGheeojemrmOWbnuWjsO+8iOiAg+iZkeihgOeuoeeYpO+8iQrog4blm4rlo4Hmr5vns5kK5Ymv6IS+PC9FMDk+DQoJCTxFMTAgZGVzYz0i5qOA5p+l5Yy75biI5Luj56CBIj48L0UxMD4NCgkJPEUxMSBkZXNjPSLmo4Dmn6XljLvluIjlp5PlkI0iPjwvRTExPg0KCQk8RTEyIGRlc2M9IuWuoeaguOWMu+W4iOS7o+eggSI+ODkzMzwvRTEyPg0KCQk8RTEzIGRlc2M9IuWuoeaguOWMu+W4iOWnk+WQjSI+6aqI5p6X6JCNPC9FMTM+DQoJCTxFMTQgZGVzYz0i6K6w5b2V6ICF5Luj56CBIj44OTMzPC9FMTQ+DQoJCTxFMTUgZGVzYz0i6K6w5b2V6ICF5aeT5ZCNIj7pqojmnpfokI08L0UxNT4NCgkJPEUxNiBkZXNjPSLmo4Dmn6Xml6XmnJ8iPjwvRTE2Pg0KCQk8RTE3IGRlc2M9IuajgOafpeaXtumXtCI+PC9FMTc+DQoJCTxFMTggZGVzYz0i5oql5ZGK5Y+3Ij5CRzIwMTkwOTEwMDAxNzQ8L0UxOD4NCgkJPEUxOSBkZXNjPSLlrqHmoLjml6XmnJ8iPjIwMTktMDktMTA8L0UxOT4NCgkJPEUyMCBkZXNjPSLlrqHmoLjml7bpl7QiPjA4OjUyOjU0PC9FMjA+DQoJCTxFMjEgZGVzYz0i5qOA5p+l6aG555uu5o+P6L+wIj5VUzwvRTIxPg0KCQk8RTIyIGRlc2M9IuajgOafpeaWueazleaPj+i/sCI+PC9FMjI+DQoJCTxFMjMgZGVzYz0i5oql5ZGK5pel5pyfIj4yMDE5LTA5LTEwPC9FMjM+DQoJCTxFMjQgZGVzYz0i5oql5ZGK5pe26Ze0Ij4wODo0ODo0NjwvRTI0Pg0KCQk8RTI1IGRlc2M9IuWMu+WYseWPtyI+NzYzNDdfOTwvRTI1Pg0KCTwvc2VjdGlvbj4NCjwvc3RydWN0dXJlZEJvZHk+DQo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode>HNZYYDXDYFSYY</HospitalCode><PAADMEncounterTypeCode>O</PAADMEncounterTypeCode></RegisterDocumentRt></Body></Request>")
	d stream.Write("<Request>   <Header>     <SourceSystem>SYS0003</SourceSystem> <!--来源系统代码-->      <MessageID>MES0011</MessageID> <!--消息ID-->   </Header>    <Body>  <RegisterDocumentRt>      <BusinessFieldCode>00001</BusinessFieldCode> <!--业务域，默认传00001-->        <HospitalCode>DHSZHYYZY</HospitalCode> <!--医院代码-->      <OrganizationCode>91320991596942997F</OrganizationCode> <!--组织代码-->        <PATPatientID>0000000060</PATPatientID> <!--患者主索引（取登记号）-->      <PATPatientName>易林达</PATPatientName> <!--患者姓名-->        <PAADMVisitNumber>92</PAADMVisitNumber> <!--就诊号-->        <RISRExamID>1584-17-02</RISRExamID> <!--检查号-->        <SpecimenID></SpecimenID> <!--标本号（条码号）-->        <OEORIOrderItemID>77||26</OEORIOrderItemID> <!--医嘱ID-->        <DocumentType>02002</DocumentType>        <!--文档类型  检验：01001检验报告，01002微生物检验报告		检查：02001放射，02002超声，02003内镜，02004心电，02005核医学		病理：02006病理		手术：04001麻醉记录单；04003麻醉术前访视单；04004麻醉术后访视单；04005苏醒记录单；04006局麻手术安全核查表；04007手术安全核查表；04008术前术后护理访视记录单；04009手术护理记录单；04010手术风险评估表；04011术后镇痛记录单；04012门诊麻醉记录单；		重症：05001重症医学科护理记录单；05002CRRT治疗记录单-->        <DocumentID>LIS0000000060IP92GDYPSSCS</DocumentID> <!--文档ID-->        <DocumentContent>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxjbGluaWNhbERvY3VtZW50Pg0KPGRvY3VtZW50SGVhZGVyPg0KICAgIDxyZWFsbUNvZGU+PC9yZWFsbUNvZGU+IDwhLS3kvb/nlKjojIPlm7QtLT4gDQoJPHR5cGVJZD48L3R5cGVJZD4gPCEtLeaWh+aho+exu+Weiy0tPg0KCTx0ZW1wbGF0ZS8+IDwhLS3mqKHmnb9JROWPiueJiOacrOWPty0tPg0KICAgIDxpZD48L2lkPiAgPCEtLeaWh+aho+a1geawtOWPty0tPiAgICAgICAgICANCiAgICA8dGl0bGU+5qOA5p+l5oql5ZGKPC90aXRsZT4NCgk8ZWZmZWN0aXZlVGltZT4yMDIwMDcxNTE0MDY1OTwvZWZmZWN0aXZlVGltZT4gPCEtLeaWh+aho+eUn+aIkOaXtumXtC0tPiANCgk8Y29uZmlkZW50aWFsaXR5IGNvZGU9Iue6p+WIq+S7o+eggSIgPue6p+WIq+WQjeensDwvY29uZmlkZW50aWFsaXR5PiAgPCEtLeS/neWvhue6p+WIqy0tPg0KCTx2ZXJzaW9uTnVtYmVyPjEuMDwvdmVyc2lvbk51bWJlcj4gICA8IS0t5paH5qGj54mI5pys5Y+3LS0+DQoJPGF1dGhvciBpZD0i5Yy755Sf57yW5Y+3Ij7liJjlu7rmmKU8L2F1dGhvcj4gPCEtLeaWh+aho+WIm+S9nOiAhS0tPg0KCTxjdXN0b2RpYW4+REhTWkhZWVpZPC9jdXN0b2RpYW4+CTwhLS3kv53nrqHmnLrmnoQtLT4NCgk8cGF0aWVudD4NCgkJPG1lZGljYXJlTm8+MTAwMDI5PC9tZWRpY2FyZU5vPiAgPCEtLeS9j+mZouWPty0tPg0KCQk8YWRtdmlzaXRObz45MjwvYWRtdmlzaXRObz4gIDwhLS3lsLHor4rlj7ctLT4NCgkJPG1lZFJlY29yZE5vPjEwMDAyOTwvbWVkUmVjb3JkTm8+ICA8IS0t55eF5qGI5Y+3LS0+DQoJCTxoZWFsdGhDYXJkTm8+PC9oZWFsdGhDYXJkTm8+ICA8IS0t5YGl5bq35Y2h5Y+3LS0+DQoJCTxjZXJ0aWZpY2F0ZT4NCgkJCTxuYW1lIGNvZGU9IuivgeS7tuexu+Wei+S7o+eggSI+6Lqr5Lu96K+BPC9uYW1lPg0KCQkJPHZhbHVlPjwvdmFsdWU+DQoJCTwvY2VydGlmaWNhdGU+DQoJCTxhZGRyIGRlc2M9IueOsOS9j+WdgCI+DQoJCQk8dGV4dD7msrPljJfnnIHkv53lrprluILljJfluILljLrkuK3ljY7ot6/ooZfpgZM8L3RleHQ+DQoJCQk8aG91c2VOdW1iZXI+IDwvaG91c2VOdW1iZXI+DQoJCQk8c3RyZWV0TmFtZT48L3N0cmVldE5hbWU+DQoJCQk8dG93bnNoaXA+5Lit5Y2O6Lev6KGX6YGTPC90b3duc2hpcD4NCgkJCTxjb3VudHk+5YyX5biC5Yy6PC9jb3VudHk+DQoJCQk8Y2l0eT7kv53lrprluII8L2NpdHk+DQoJCQk8c3RhdGU+5rKz5YyX55yBPC9zdGF0ZT4NCgkJCTxwb3N0YWxDb2RlPjwvcG9zdGFsQ29kZT4NCgkJPC9hZGRyPg0KCQk8bmFtZT7mmJPmnpfovr48L25hbWU+DQoJCTx0ZWxlY29tPjE2NTMyMjg3NjY2PC90ZWxlY29tPg0KCQk8YWRtaW5pc3RyYXRpdmVHZW5kZXIgY29kZT0iMCIgPueUtzwvYWRtaW5pc3RyYXRpdmVHZW5kZXI+DQoJCTxtYXJpdGFsU3RhdHVzIGNvZGU9IjIwIj7mnKrlqZo8L21hcml0YWxTdGF0dXM+DQoJCTxldGhuaWNHcm91cCBjb2RlPSIwMSI+5rGJ5pePPC9ldGhuaWNHcm91cD4NCgkJPGFnZSB1bml0PSLlsoEiIHZhbHVlPSI0Ii8+DQoJPC9wYXRpZW50Pg0KCTxwYXJ0aWNpcGFudD4NCgkJPGNvZGUgY29kZT0iMSI+54i25a2QPC9jb2RlPg0KICAgICAgICA8YWRkciBkZXNjPSLogZTns7vkurrlnLDlnYAiPgkNCgkJCQk8dGV4dD7msrPljJfnnIHkv53lrprluILljJfluILljLrkuK3ljY7ot6/ooZfpgZM8L3RleHQ+DQoJCQk8aG91c2VOdW1iZXI+IDwvaG91c2VOdW1iZXI+DQoJCQk8c3RyZWV0TmFtZT4gPC9zdHJlZXROYW1lPg0KCQkJPHRvd25zaGlwPuS4reWNjui3r+ihl+mBkzwvdG93bnNoaXA+DQoJCQk8Y291bnR5PuWMl+W4guWMujwvY291bnR5Pg0KCQkJPGNpdHk+5L+d5a6a5biCPC9jaXR5Pg0KCQkJPHN0YXRlPuays+WMl+ecgTwvc3RhdGU+DQoJCQk8cG9zdGFsQ29kZT48L3Bvc3RhbENvZGU+DQoJCTwvYWRkcj4NCgkJPHRlbGVjb20+IDE2NTMyMjg3NjY2IDwvdGVsZWNvbT4NCgkJPG5hbWU+5piT5oSPPC9uYW1lPg0KCTwvcGFydGljaXBhbnQ+DQo8L2RvY3VtZW50SGVhZGVyPg0KPHN0cnVjdHVyZWRCb2R5Pg0KCTxFMDAwNCBkZXNjPSLlp5PlkI0iPuaYk+ael+i+vjwvRTAwMDQ+DQoJPEUwMDA1IGRlc2M9IuaAp+WIq+S7o+eggSI+MTwvRTAwMDU+DQoJPEUwMDA2IGRlc2M9IuaAp+WIq+aPj+i/sCI+55S3PC9FMDAwNj4NCgk8RTAwMDggZGVzYz0i5bm06b6EIj405bKBNeaciDwvRTAwMDg+DQoJPEUwMTQ4IGRlc2M9IueXheS6uuexu+Wei+S7o+eggSI+STwvRTAxNDg+DQoJPEUwMTQ5IGRlc2M9IueXheS6uuexu+Wei+WQjeensCI+5L2P6ZmiPC9FMDE0OT4NCgk8RTAxNTYgZGVzYz0i56eR5a6kaWQiPlpZWlkwMTg8L0UwMTU2Pg0KCTxFMDA3NyBkZXNjPSLnp5HlrqQiPuiCneiDhuWkluenkTwvRTAwNzc+DQoJPEUwMDAyIGRlc2M9IuS9j+mZouWPtyI+MTAwMDI5PC9FMDAwMj4NCgk8RTAwMDAgZGVzYz0i6Zeo6K+K5Y+3Ij48L0UwMDAwPg0KCTxFMDE1NCBkZXNjPSLnl4XluoppZCI+MDc8L0UwMTU0Pg0KCTxFMDA3NSBkZXNjPSLnl4XluooiPjA3PC9FMDA3NT4NCgk8c2VjdGlvbiBjb2RlPSJTMDA0OCIgZGVzYz0i6K+K5patIj4NCgkJPHRleHQvPiAgPCEtLeiviuaWreeahOivpue7huS/oeaBry0tPg0KCQk8RTA3IGRlc2M9IuWMu+eUn+Whq+WGmeeahOiviuaWrSI+6IOG5oC7566h57uT55+z5Ly06IOG566h54KOPC9FMDc+DQoJCTxFMDEgZGVzYz0i6K+K5pat5ZCN56ewIj7og4bmgLvnrqHnu5Pnn7PkvLTog4bnrqHngo48L0UwMT4NCgkJPEUwMiBkZXNjPSLor4rmlq3ku6PnoIEiPks4MC4zMDI8L0UwMj4NCgk8L3NlY3Rpb24+DQoJPHNlY3Rpb24gY29kZT0iUzAwNzYiIGRlc2M9IuajgOafpeiusOW9lSI+DQoJCTx0ZXh0Lz4gIDwhLS3mo4Dmn6XorrDlvZXnmoTor6bnu4bkv6Hmga8tLT4NCgkJPEUwMSBkZXNjPSLmo4Dmn6Xlj7ciPjE1ODQtMTctMDI8L0UwMT4NCgkJPEUwMiBkZXNjPSLmo4Dmn6Xorr7lpIfnvJbnoIEiPjMzMzQ8L0UwMj4NCgkJPEUwMyBkZXNjPSLmo4Dmn6Xorr7lpIflkI3np7AiPlNpbWVucyDotoXlo7A8L0UwMz4NCgkJPEUwNCBkZXNjPSLmo4Dmn6Xpg6jkvY3ku6PnoIEiPuS4iuiFuemDqDwvRTA0Pg0KCQk8RTA1IGRlc2M9IuajgOafpemDqOS9jeWQjeensCI+5LiK6IW56YOoPC9FMDU+DQoJCTxFMDYgZGVzYz0i5qOA5p+l6YOo5L2N5Yy755Sf5omL5YaZIj7kuIrohbnpg6g8L0UwNj4NCgkJPEUwNyBkZXNjPSLmo4Dmn6Xpg6jkvY0iPuS4iuiFuemDqDwvRTA3Pg0KCQk8RTA4IGRlc2M9IuajgOafpeaJgOingSI+6IKd6ISP5b2i5oCB5aSn5bCP5q2j5bi477yM6KKr6Iac5YWJ5ruR77yM5a6e6LSo5Zue5aOw57uG5a+G5aKe5by677yM6IKd5YaF566h6YGT5pi+56S65qyg5riF5pmw77yM6Zeo6ISJ5YaF5b6E5q2j5bi444CC6IOG5ZuK5b2i5oCB5aSn5bCP5q2j5bi477yM5aOB57KX57OZ77yM6IOG5ZuK5bqV6YOo5Y+v6KeB5LiA5aSn5bCP57qmMC43KjAuNmNt55qE5YGP5L2O5Zue5aOw57uT6IqC77yM6L6555WM5riF5pmw77yM5b2i5oCB6KeE5pW077yM6IWU5YaF5pyq6KeB5byC5bi444CC6IKd5YaF6IOG566h5omp5byg77yM566h6IWU5YaF6KeB5aSa5Y+R5Lqu54K577yM5aSn5bCP57qmNW1tKjVtbe+8jOiCneWkluiDhueuoeWGheW+hOaJqeW8oO+8jOeuoeiFlOWGheacquWkmuWPkeS6rueCue+8jOWkp+Wwj+e6pjJtbSozbW3jgILog7DlvaLmgIHlpKflsI/mraPluLjvvIzlrp7otKjlm57lo7DlnYfljIDvvIzkuLvog7DnrqHml6DmianlvKDjgILohL7ljprmraPluLjvvIzogovkuIvmnKrmjqLlj4rvvIzlrp7otKjlm57lo7DlnYfljIDjgII8L0UwOD4NCgkJPEUwOSBkZXNjPSLmo4Dmn6Xnu5PmnpwiPuiEguiCquiCneiDhuWbiuWjgeeyl+ezme+8jOiDhuWbiuWjgeWGheWxgOmZkOaAp+mahui1t++8jOiDhueuoeaJqeW8oOacieWkmuWPkeS6rueCue+8jOiAg+iZkeiDhuaAu+euoee7k+efs+S8tOiDhuWbiueCju+8jOiDhuWbiuiFuuiCjOeXh+OAguiDsOiEvuacquingeaYjuaYvuW8guW4uDwvRTA5Pg0KCQk8RTEwIGRlc2M9IuajgOafpeWMu+W4iOS7o+eggSI+UklTPC9FMTA+DQoJCTxFMTEgZGVzYz0i5qOA5p+l5Yy75biI5aeT5ZCNIj5SSVM8L0UxMT4NCgkJPEUxMiBkZXNjPSLlrqHmoLjljLvluIjku6PnoIEiPjA0NTI8L0UxMj4NCgkJPEUxMyBkZXNjPSLlrqHmoLjljLvluIjlp5PlkI0iPuabueWQr+engDwvRTEzPg0KCQk8RTE0IGRlc2M9IuiusOW9leiAheS7o+eggSI+ODAxMzwvRTE0Pg0KCQk8RTE1IGRlc2M9IuiusOW9leiAheWnk+WQjSI+5YiY5bu65pilPC9FMTU+DQoJCTxFMTYgZGVzYz0i5qOA5p+l5pel5pyfIj4yMDIwLTA3LTE1PC9FMTY+DQoJCTxFMTcgZGVzYz0i5qOA5p+l5pe26Ze0Ij4wOTowNTwvRTE3Pg0KCQk8RTE4IGRlc2M9IuaKpeWRiuWPtyI+MTU4NC0xNy0wMi0yMDIwMDcxNTE0MzY8L0UxOD4NCgkJPEUxOSBkZXNjPSLlrqHmoLjml6XmnJ8iPjIwMjAtMDctMTU8L0UxOT4NCgkJPEUyMCBkZXNjPSLlrqHmoLjml7bpl7QiPjE0OjM2PC9FMjA+DQoJCTxFMjEgZGVzYz0i5qOA5p+l6aG555uu5o+P6L+wIj7ml6A8L0UyMT4NCgkJPEUyMiBkZXNjPSLmo4Dmn6Xmlrnms5Xmj4/ov7AiPuaXoDwvRTIyPg0KCQk8RTIzIGRlc2M9IuaKpeWRiuaXpeacnyI+MjAyMC0wNy0xNTwvRTIzPg0KCQk8RTI0IGRlc2M9IuaKpeWRiuaXtumXtCI+MTQ6MzY8L0UyND4NCgkJPEUyNSBkZXNjPSLljLvlmLHlj7ciPjc3fHwyNjwvRTI1Pg0KCTwvc2VjdGlvbj4NCjwvc3RydWN0dXJlZEJvZHk+DQo8L2NsaW5pY2FsRG9jdW1lbnQ+</DocumentContent>      <!--文档内容：需要对文档内容进行base64加密处理，使用UTF-8编码方式--><DocumentPath>http://172.18.18.140/weblink/0000000060/IP0000000033002.html</DocumentPath> <!--文档路径-->        <UpdateUserCode>RIS</UpdateUserCode> <!--更新人代码-->  <UpdateDate>2020-07-15</UpdateDate> <!--更新日期yyyy-MM-dd-->        <UpdateTime>14:03</UpdateTime> <!--更新日期hh24:mi-->    </RegisterDocumentRt>   </Body></Request>")
	;s xx=..SaveHOSDocumentImage(stream)
	s xx=..SaveXMLResult(stream)
	q xx
}

}
