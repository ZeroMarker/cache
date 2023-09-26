/// Desc:       资源区检验接口
/// Creator:    Candy
/// CreateDate: 2016-8-18
Class web.DHCCM.EMRservice.BL.BLLisData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      从数据平台取检验列表
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
///            AStartDate 开始日期
///            AEndDate   结束日期
/// Output:
/// Debug:     d ##class(%ResultSet).RunQuery("EMRservice.BL.BLLisData","GetLisDataList",2535,"","")
Query GetLisDataList(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "EpisodeDate,DeptDesc,OEordItemRowID,OEordItemDesc,LabEpisodeNo,SpecimenDesc,CollectionDate,CollectionTime,ReceiveDate,ReceiveTime,AuthorisationDate,AuthorisationTime,ExistReport")
{
}

ClassMethod GetLisDataListExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (episodeDate,deptDesc,oEordItemRowId,oEordItemDesc,labEpisodeNo,specimenDesc,collectionDate,collectionTime,receiveDate,receiveTime,authorisationDate,authorisationTime,existReport)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>99</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
	
	//s reStream = ##Class(%GlobalCharacterStream).%New()
	//d reStream.Write("<Response><Header><SourceSystem>数据中心</SourceSystem><MessageID>7</MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><DocumentRetrievalRp><Documents><Document><DocumentID>5235</DocumentID><DocumentPath></DocumentPath><DocumentTitle>经直肠超声检查</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>13:38:00</UpdateTime></Document><Document><DocumentID>5239</DocumentID><DocumentPath></DocumentPath><DocumentTitle>四肢多普勒血流图</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>14:27:20</UpdateTime></Document></Documents></DocumentRetrievalRp></Body></Response>")	
	
	s reStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",paramStream)
	q:(reStream.Size <= 0)
	s sc =##class(%XML.XPATH.Document).CreateFromStream(reStream,.documentList)
	q:($$$ERROR(sc)) $$$OK 
	
	s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents","count(Document)",.documentNode)
	q:($$$ERROR(sc)||(documentNode.GetAt(1)="")) $$$OK
	s dcount = documentNode.GetAt(1).Value
	for i=1:1:dcount
	{
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/DocumentID","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docId = result.GetAt(1).Value
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/DocumentType","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docType = result.GetAt(1).Value		
		s repParamText = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt>"
        s repParamText = repParamText_"<PATPatientID>"_patientNo_"</PATPatientID>"
        s repParamText = repParamText_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
        s repParamText = repParamText_"<DocumentType>"_docType_"</DocumentType>"
        s repParamText = repParamText_"<DocumentID>"_docId_"</DocumentID>"
        s repParamText = repParamText_"</DocumentSearchRt></Body></Request>"
        
        s repParamStream = ##Class(%GlobalCharacterStream).%New()
        d repParamStream.Write(repParamText)
        
        //s reportStream = ##Class(%FileBinaryStream).%New()
		//s reportStream.Filename="d:\stream.txt"    
		
		s reportStream =  ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",repParamStream)
		continue:(reportStream.Size<=0)

		s screport =##class(%XML.XPATH.Document).CreateFromStream(reportStream,.reportList)
		continue:($$$ERROR(screport))
		s scscreport = reportList.EvaluateExpression("/Response/Body/DocumentSearchRp/Documents","count(Document)",.reportNode)
		continue:($$$ERROR(scscreport)||(reportNode.GetAt(1)=""))
		s rcount = reportNode.GetAt(1).Value
		
		for j=1:1:rcount
		{
			s sc = reportList.EvaluateExpression("/Response/Body/DocumentSearchRp/Documents/Document["_j_"]/DocumentContent","text()",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s docContent = result.GetAt(1).Value
			s docContent = $System.Encryption.Base64Decode(docContent)
			s docContent = $zcvt(docContent,"I","UTF8")
			s docContentStream = ##Class(%GlobalCharacterStream).%New()
			d docContentStream.Write(docContent)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.reprot)
			continue:($$$ERROR(sccontent))
			///就诊日期
			s episodeDate = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml($p($g(^PAADM(AEpiosdeID)),"^",6))   
			///就诊科室
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/E0077/","text()",.result)
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) deptDesc =  result.GetAt(1).Value
			///标本号
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E07","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) labEpisodeNo = result.GetAt(1).Value
			///医嘱号对应到标本号
			s oEordItemRowId = labEpisodeNo
			///医嘱名称对应到检验项目名称
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E02","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) oEordItemDesc = result.GetAt(1).Value
			///标本类型
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E06","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) specimenDesc = result.GetAt(1).Value
			
			///送检日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E03","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) receiveDate = result.GetAt(1).Value
			///送检时间		
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E04","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) receiveTime = result.GetAt(1).Value
			
			///审核日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E17","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) authorisationDate = result.GetAt(1).Value,rptRowID = result.GetAt(1).Value
			///审核时间		
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E18","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) authorisationTime = result.GetAt(1).Value
		}
		s data = $lb(episodeDate,deptDesc,oEordItemRowId,oEordItemDesc,labEpisodeNo,specimenDesc,collectionDate,collectionTime,receiveDate,receiveTime,authorisationDate,authorisationTime,existReport)
		s ^CacheTemp(repid,ind) = data
		s ind=ind + 1 
	}
	Quit $$$OK
}

ClassMethod GetLisDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLisDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       检验明细表
/// Creator:    Candy
/// CreateDate: 2016-8-17
/// Input:      AEpiosdeID 就诊号
///            AStartDate 开始日期
///            AEndDate   结束日期
///            ALabNo     关联ID(用标本号)
/// Output:
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.BL.BLLisData","GetLisDataDetial",2535,"","","116081700019")
Query GetLisDataDetial(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", ALabNo As %String = "") As %Query(ROWSPEC = "OeordID,ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges")
{
}

ClassMethod GetLisDataDetialExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", ALabNo As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:((AEpiosdeID = "")||(ALabNo = "")) $$$OK
    s (oeordID,itemDesc,synonym,itemResult,itemUnit,abnorFlag,itemRanges)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>99</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
	
	//s reStream = ##Class(%GlobalCharacterStream).%New()
	//d reStream.Write("<Response><Header><SourceSystem>数据中心</SourceSystem><MessageID>7</MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><DocumentRetrievalRp><Documents><Document><DocumentID>5235</DocumentID><DocumentPath></DocumentPath><DocumentTitle>经直肠超声检查</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>13:38:00</UpdateTime></Document><Document><DocumentID>5239</DocumentID><DocumentPath></DocumentPath><DocumentTitle>四肢多普勒血流图</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>14:27:20</UpdateTime></Document></Documents></DocumentRetrievalRp></Body></Response>")	
	
	s reStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",paramStream)
	q:(reStream.Size <= 0)
	s sc =##class(%XML.XPATH.Document).CreateFromStream(reStream,.documentList)
	q:($$$ERROR(sc)) $$$OK 
	
	s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents","count(Document)",.documentNode)
	q:($$$ERROR(sc)||(documentNode.GetAt(1)="")) $$$OK
	s dcount = documentNode.GetAt(1).Value
	for i=1:1:dcount
	{
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/DocumentID","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docId = result.GetAt(1).Value
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/DocumentType","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docType = result.GetAt(1).Value		
		s repParamText = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt>"
        s repParamText = repParamText_"<PATPatientID>"_patientNo_"</PATPatientID>"
        s repParamText = repParamText_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
        s repParamText = repParamText_"<DocumentType>"_docType_"</DocumentType>"
        s repParamText = repParamText_"<DocumentID>"_docId_"</DocumentID>"
        s repParamText = repParamText_"</DocumentSearchRt></Body></Request>"
        
        s repParamStream = ##Class(%GlobalCharacterStream).%New()
        d repParamStream.Write(repParamText)
        
        //s reportStream = ##Class(%FileBinaryStream).%New()
		//s reportStream.Filename="d:\stream.txt"    
		
		s reportStream =  ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",repParamStream)
		continue:(reportStream.Size<=0)

		s screport =##class(%XML.XPATH.Document).CreateFromStream(reportStream,.reportList)
		continue:($$$ERROR(screport))
		s scscreport = reportList.EvaluateExpression("/Response/Body/DocumentSearchRp/Documents","count(Document)",.reportNode)
		continue:($$$ERROR(scscreport)||(reportNode.GetAt(1)=""))
		s rcount = reportNode.GetAt(1).Value
		
		for j=1:1:rcount
		{
			s sc = reportList.EvaluateExpression("/Response/Body/DocumentSearchRp/Documents/Document["_j_"]/DocumentContent","text()",.result)
			continue:($$$ERROR(sc)||(result.GetAt(1)=""))
			s docContent = result.GetAt(1).Value
			s docContent = $System.Encryption.Base64Decode(docContent)
			s docContent = $zcvt(docContent,"I","UTF8")
			s docContentStream = ##Class(%GlobalCharacterStream).%New()
			d docContentStream.Write(docContent)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.reprot)
			continue:($$$ERROR(sccontent))
			///标本号
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E07","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) labEpisodeNo = result.GetAt(1).Value
			q:(labEpisodeNo '= ALabNo)
			
			///医嘱号对应到标本号
			s oeordID = labEpisodeNo
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section/section[@code='S0062'])",.subReport)
			continue:($$$ISERR(sc)||(subReport.GetAt(1) = ""))
			s subcount = subReport.GetAt(1).Value
			for k=1:1:subcount
			{
				///医嘱名称对应到检验子项目名称
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section/section[@code='S0062']["_k_"]/E02","text()",.result)			
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemDesc = result.GetAt(1).Value

				///结果
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section/section[@code='S0062']["_k_"]/E05","text()",.result)			
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemResult = result.GetAt(1).Value
				
				///单位
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section/section[@code='S0062']["_k_"]/E04","text()",.result)			
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemUnit = result.GetAt(1).Value,rptRowID = result.GetAt(1).Value
				
				///异常值		
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section/section[@code='S0062']["_k_"]/E07","text()",.result)			
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) abnorFlag = result.GetAt(1).Value
			
				///范围值
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section/section[@code='S0062']["_k_"]/E06","text()",.result)			
				s data = $lb(oeordID,itemDesc,synonym,itemResult,itemUnit,abnorFlag,itemRanges)
				s ^CacheTemp(repid,ind) = data
				s ind=ind + 1 
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemRanges = result.GetAt(1).Value		
			}
		}
	}	
	Quit $$$OK
}

ClassMethod GetLisDataDetialClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisDataDetialExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLisDataDetialFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisDataDetialExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
