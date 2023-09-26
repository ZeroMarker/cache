Class web.DHCENS.STBLL.DOCU.METHOD.HOSDocument Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.HOSDocument).HOSDocument("9090257")
/// w ##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000037","9082806")
/// 电子病历文档图片获取
ClassMethod HOSImageDocument(admRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DOCU.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	
	set body=##class(web.DHCENS.STBLL.DOCU.MODEL.Body).%New()

	///  电子病历提供获取图片路径方法（排序后图片）
	set inputContent=##class(EPRservice.BIL.BIRecordImage).GetImageByAdm2(admRowId)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set patRowId=$p($g(^PAADM(admRowId)),"^",1)
		set PAPATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
		
		
		set tSC=tDocument.EvaluateExpression("/MedRecordList","count(Record)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {	
				set imageStr="",HOSDTypeCode=""
				set tSC=tDocument.EvaluateExpression("/MedRecordList/Record["_i_"]/PathList","count(Path)",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
					set hsCount=tRes.GetAt(1).Value
					Quit:hsCount="0" 
					for j=1:1:hsCount {	
						set tSC=tDocument.EvaluateExpression("/MedRecordList/Record["_i_"]/PathList/Path["_j_"]","text()",.tRes)					
						if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
							set fieldValue=tRes.GetAt(1).Value							
							set fieldValue=$tr(fieldValue,$c(0),"")
							//ftp路径地址
							//set fieldValue="ftp://用户名:密码@10.0.11.24/dhcepr"_fieldValue
							set fieldValue="ftp://administrator:nyfyhis20081@10.0.11.24/"_fieldValue
						}
						set:imageStr'="" imageStr=imageStr_","_fieldValue
						set:imageStr="" imageStr=fieldValue
					}
					set tSC=tDocument.EvaluateExpression("/MedRecordList/Record["_i_"]/Id","text()",.tRes)
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
						set fieldValue=tRes.GetAt(1).Value
						set HOSDTypeCode=$tr(fieldValue,$c(0),"")
					}
				}
				set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.HOSDocument).%New()
				set obj.OrganizationCode="ORG0000005"
				set obj.PATPatientID=PAPATPatientID
				set obj.PAADMVisitNumber=admRowId
				set obj.RISRExamID=""
				set obj.SpecimenID=""
				set obj.OEORIOrderItemID=""
				set obj.DocumentType=HOSDTypeCode
				set obj.DocumentID=""
				set obj.DocumentPath=imageStr
				set obj.UpdateUserCode="-"
				set obj.UpdateDate=$zd(+$h,3)
				set obj.UpdateTime=$zt($p($h,",",2),3)
				d body.hosDocuments.Insert(obj)
			}
		}
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	Quit "-1^"_$ze
}

/// 文档检索
ClassMethod DocumentRetrieval(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set soap=##class(web.DHCENS.STBLL.DOCU.SOAP.PUB0007Soap).%New()
	set soap.Timeout=10
	set result=soap.HOSDocumentRetrieval("S0034",Input)
	Quit result
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>没有符合条件的文档"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

/// 文档调阅
ClassMethod DocumentSearch(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set soap=##class(web.DHCENS.STBLL.DOCU.SOAP.PUB0007Soap).%New()
	set soap.Timeout=2
	set result=soap.HOSDocumentSearch("S0035",Input)
	Quit result
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>文档内容为空"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

/// 文档注册
ClassMethod RegisterDocument(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set (resultCode1,resultCode2)=""
	// 手麻组
	set outputString=##class(web.DHCCLImportData).GetDataFromPF(Input)
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(outputString)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(stream,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败</ResultContent></Body></Response>")
	}else{
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set resultCode1=tRes.GetAt(1).Value
		}
	}
	// 医政组
	set outputString=##class(DHCMed.DCEns.LIS.TSResultByLIS).GetDataFromPF(Input)
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(outputString)
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(stream,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败</ResultContent></Body></Response>")
	}else{
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set resultCode2=tRes.GetAt(1).Value
		}
	}
	set stream=##class(%GlobalCharacterStream).%New()
	if ((resultCode1="0")&&(resultCode2="0")) {
		d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
	}
	else {
		d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>resultCode1:"_resultCode1_",resultCode2:"_resultCode2_"</ResultContent></Body></Response>")
	}
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

/// 获取文档概要信息
ClassMethod HOSAbstractDocument(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DOCU.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header

	set body=##class(web.DHCENS.STBLL.DOCU.MODEL.Body).%New()
	set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.HOSDocument).%New()
	
	if $p(Input,"^",1)="门诊病历" {		
		set tempString=Input.Read()
		set admRowId=$p($p(tempString,"<admvisitNo>",2),"</admvisitNo>",1)
	}
	elseif $p(Input,"^",1)="00" {
		set RARRowid=$o(^DHCPACRegInfoi("StudyNo",$p(Input,"^",2),""))
		set admRowId=$p(^DHCPACRegInfo(RARRowid),"^",10) //"就诊号"
		set obj.RISRExamID=$p(Input,"^",2)
	}
	elseif $p(Input,"^",1)="99" {
		set labno=+$p(Input,"^",2)
		set ordRowId=$O(^OEORD(0,"EpisNo",labno,""))
	    set admRowId = $P($g(^OEORD(ordRowId)),"^",1)
		set obj.SpecimenID=+$p(Input,"^",2)
	}
	elseif $p(Input,"^",1)="43" {		
		set admRowId=$p(Input,"^",2)
	}
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set PAPATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set obj.OrganizationCode="ORG0000005"
	set obj.PATPatientID=PAPATPatientID
	set obj.PAADMVisitNumber=admRowId
	set obj.OEORIOrderItemID=""
	//类型
	set obj.DocumentType=$p(Input,"^",1)
	set obj.DocumentID=$p(Input,"^",2)
	//pdf路径
	set obj.DocumentPath=""
	set obj.UpdateUserCode="-"
	set obj.UpdateDate=$zd(+$h,3)
	set obj.UpdateTime=$zt($p($h,",",2),3)
	d body.hosDocuments.Insert(obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	Quit "-1^"_$ze
}

}
