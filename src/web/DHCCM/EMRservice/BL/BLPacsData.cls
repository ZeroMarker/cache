/// Desc:       资源区检查接口
/// Creator:    Candy
/// CreateDate: 2016-8-18
Class web.DHCCM.EMRservice.BL.BLPacsData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      从数据平台取检查列表
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
/// Debug:     d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPacsData","GetPacsDataList",2696,"","")
Query GetPacsDataList(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Query(ROWSPEC = "EpisodeDate,DeptDesc,ItemName,OrdCreateDate,OrdCreateTime,OEOrdItemDR,RptRowID,RrtDate,RrtTime,ExamDesc,strResult,strOrderName,OEOrdStatus")
{
}

ClassMethod GetPacsDataListExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (episodeDate,deptDesc,itemName,OEOrdItemDR,rptRowID,rptDate,rptTime,examDesc,strResult,strOrderName)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>00</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
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
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/DocumentTitle","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docTitle = result.GetAt(1).Value	
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/UpdateDate","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docUpdateDate = result.GetAt(1).Value	
		s sc = documentList.EvaluateExpression("/Response/Body/DocumentRetrievalRp/Documents/Document["_i_"]/UpdateTime","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s docUpdateTime = result.GetAt(1).Value		
	
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
			//转成UTF8
			s docContent = $zcvt(docContent,"I","UTF8")
			
			//docContent 是个xml，需要转译成流
			s docContentStream = ##Class(%GlobalCharacterStream).%New()
			d docContentStream.Write(docContent)
			s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.reprot)
			continue:($$$ERROR(sccontent))
			
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E01","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) OEOrdItemDR = result.GetAt(1).Value,rptRowID = result.GetAt(1).Value
			continue:((AFlagID '= "")&&(OEOrdItemDR '= AFlagID))
			s OEOrdStatus = ""
			if (OEOrdItemDR["-")
			{
			s OrderRowid="",itemsub="",OEOrdStatus="",OEOrdStatusDR=""
			s OrderRowid = $P(OEOrdItemDR,"-",1)
			s itemsub = $P(OEOrdItemDR,"-",2)
			s OEOrdStatusDR=$p(^OEORD(OrderRowid,"I",itemsub,"1"),"^",13)
			s:(OEOrdStatusDR'="") OEOrdStatus = $P(^OEC("OSTAT",OEOrdStatusDR),"^",2)
				}
			elseif (OEOrdItemDR["||")
			{
				s OrderRowid="",itemsub="",OEOrdStatus="",OEOrdStatusDR=""
				s OrderRowid = $P(OEOrdItemDR,"||",1)
				s itemsub = $P(OEOrdItemDR,"||",2)
				s OEOrdStatusDR=$p(^OEORD(OrderRowid,"I",itemsub,"1"),"^",13)
				s:(OEOrdStatusDR'="") OEOrdStatus = $P(^OEC("OSTAT",OEOrdStatusDR),"^",2)
				
				}
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/E0077/","text()",.result)
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) deptDesc =  result.GetAt(1).Value

			s episodeDate = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml($p($g(^PAADM(AEpiosdeID)),"^",6))  
			s OrdCreateDate = docUpdateDate
			s OrdCreateTime = docUpdateTime
			s itemName = docTitle
			//报告日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E23","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) rptDate = result.GetAt(1).Value
			//报告时间
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E24","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) rptTime = result.GetAt(1).Value
			
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E08","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) examDesc = result.GetAt(1).Value
			s strResult = ""
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0048']/text","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) strResult = result.GetAt(1).Value
			;s strResult = ""
			b ;000
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E22","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) strOrderName = result.GetAt(1).Value
			
			s data = $lb(episodeDate,deptDesc,itemName,OrdCreateDate,OrdCreateTime,OEOrdItemDR,rptRowID,rptDate,rptTime,examDesc,strResult,strOrderName,OEOrdStatus)
			s ^CacheTemp(repid,ind) = data
			s ind=ind + 1 
		}
	}
	Quit $$$OK
}

ClassMethod GetPacsDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPacsDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPacsDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPacsDataListExecute ]
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
