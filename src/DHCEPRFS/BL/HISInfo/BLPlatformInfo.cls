Class DHCEPRFS.BL.HISInfo.BLPlatformInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 获取平台文档路径
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPlatformInfo).GetPlatformPDFPath("","")
ClassMethod GetPlatformPDFPath(AEpisodeID As %String, ATypeCode As %String) As %GlobalCharacterStream
{
	s ret = ##class(%GlobalCharacterStream).%New()
	q:(AEpisodeID= "")||(ATypeCode= "") ret
	
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	s regNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
	s strRequest = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt><PATPatientID>"_regNo_"</PATPatientID><PAADMVisitNumber>"_AEpisodeID_"</PAADMVisitNumber><DocumentType>"_ATypeCode_"</DocumentType><StartDate></StartDate><EndDate></EndDate><DocumentFormat>pdf</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s reqStream = ##class(%GlobalCharacterStream).%New()
	d reqStream.Write(strRequest)
	
	s retStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",reqStream)
	if '$IsObject(retStream)
	{
		q ret
	}
	s tSC = ##class(%XML.XPATH.Document).CreateFromStream(retStream,.tDocument)
	if ($$$ISERR(tSC))
	{
		q ret
	}
	
	s resultCode = ""
	s codeSC = tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.codeRes)
	if ($$$ISOK(codeSC)&&(codeRes.GetAt(1)'=""))
	{
		s resultCode = codeRes.GetAt(1).Value
	}
	q:(resultCode '= "0") ret
	
	d ret.CopyFrom(retStream)
	q ret
}

/// Desc: 判断是否有指定类型平台报告文档
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPlatformInfo).HasPlatformReport("18853968","01")
ClassMethod HasPlatformReport(AEpisodeID As %String, ATypeCode As %String) As %String
{
	s ret = "0"
	s retReport = ..GetPlatformPDFPath(AEpisodeID,ATypeCode)
	s:(retReport.SizeGet()>0) ret = "1"
	q ret
}

/// Desc: 测试方法
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPlatformInfo).Test("","")
ClassMethod Test(AEpisodeID As %String, ATypeCode As %String) As %String
{
	s retStream = ..GetPlatformPDFPath(AEpisodeID,ATypeCode)
	s retSize = retStream.SizeGet()
	if (retSize>0)
	{
		w "StreamSize:"_retSize,!
		s byteList = retStream.Read(12288)
		while (byteList '= "") {
			w byteList
			s byteList = ""
			s byteList = retStream.Read(12288)
		}
		w !
		q "1"
	}
	else
	{
		q "0"
	}
}

}
