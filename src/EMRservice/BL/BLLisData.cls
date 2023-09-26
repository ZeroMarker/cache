/// 检验
Class EMRservice.BL.BLLisData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      从数据平台取检验列表
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
///            AStartDate 开始日期
///            AEndDate   结束日期
/// Output:
/// Debug:     d ##class(%ResultSet).RunQuery("EMRservice.BL.BLLisData","GetLisDataList",861807,"","")
Query GetLisDataList(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "EpisodeDate,DeptDesc,OEordItemRowID,OEordItemDesc,LabEpisodeNo,SpecimenDesc,CollectionDate,CollectionTime,ReceiveDate,ReceiveTime,AuthorisationDate,AuthorisationTime,ExistReport,DocID")
{
}

ClassMethod GetLisDataListExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (episodeDate,deptDesc,OEordItemRowID,oEordItemDesc,labEpisodeNo,specimenDesc,collectionDate,collectionTime,receiveDate,receiveTime,authorisationDate,authorisationTime,existReport)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>99</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
		
	s reStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",paramStream)
	q:(reStream.Size <= 0) $$$OK
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
		s repParamText = "<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt>"
        s repParamText = repParamText_"<PATPatientID>"_patientNo_"</PATPatientID>"
        s repParamText = repParamText_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
        s repParamText = repParamText_"<DocumentType>"_docType_"</DocumentType>"
        s repParamText = repParamText_"<DocumentID>"_docId_"</DocumentID>"
        s repParamText = repParamText_"</DocumentSearchRt></Body></Request>"
        s repParamStream = ##Class(%GlobalCharacterStream).%New()
        d repParamStream.Write(repParamText)
		s reportStream =  ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",repParamStream)
		continue:(reportStream.Size<=220)

		s docContentStream = ##Class(%GlobalCharacterStream).%New()
		d docContentStream.CopyFrom(reportStream)
		s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.reprot)
		continue:($$$ERROR(sccontent))
		///就诊日期
		s episodeDate = $zd($p($g(^PAADM(AEpiosdeID)),"^",6),3)  
		///就诊科室
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/E0077/","text()",.result)
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) deptDesc =  result.GetAt(1).Value
		///标本号
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E07","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) labEpisodeNo = result.GetAt(1).Value
		///医嘱号对应到标本号
		s OEordItemRowID = labEpisodeNo
			
		//获取医嘱状态
		s OEordItemDR = "",OEordItemDRSub = ""
			
		s OrderRowid="",itemsub="",OEOrdStatus="",OEOrdStatusDR="",existReport=""
		if (OEordItemDR'="") 
		{
			s OrderRowid = $P(OEordItemDR,"||",1)
			s itemsub = $P(OEordItemDR,"||",2)
			s OEOrdStatusDR=$p($G(^OEORD(OrderRowid,"I",itemsub,"1")),"^",13)
			s:(OEOrdStatusDR'="") OEOrdStatus = $P($G(^OEC("OSTAT",OEOrdStatusDR)),"^",2)
			s existReport = OEOrdStatus
		}	
			
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
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E24","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) DocID = result.GetAt(1).Value			
		s data = $lb(episodeDate,deptDesc,OEordItemRowID,oEordItemDesc,labEpisodeNo,specimenDesc,collectionDate,collectionTime,receiveDate,receiveTime,authorisationDate,authorisationTime,existReport,DocID)
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
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.BL.BLLisData","GetLisDataDetial",861807,"","","416122994905")
Query GetLisDataDetial(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", ALabNo As %String = "") As %Query(ROWSPEC = "OeordID,ItemDesc,Synonym,ItemResult,ItemUnit,AbnorFlag,ItemRanges,DetailData,ResultDR")
{
}

ClassMethod GetLisDataDetialExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", ALabNo As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:((AEpiosdeID = "")) $$$OK // EH 如果不传标本号就查询全部，本来就是过滤掉的。现在要查病人这段时间的检验结果，不可能按标本号挨个调用吧
    s (oeordID,itemDesc,synonym,itemResult,itemUnit,abnorFlag,itemRanges)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>99</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)

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
		s repParamText = "<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><DocumentSearchRt>"
        s repParamText = repParamText_"<PATPatientID>"_patientNo_"</PATPatientID>"
        s repParamText = repParamText_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
        s repParamText = repParamText_"<DocumentType>"_docType_"</DocumentType>"
        s repParamText = repParamText_"<DocumentID>"_docId_"</DocumentID>"
        s repParamText = repParamText_"</DocumentSearchRt></Body></Request>"
        
        s repParamStream = ##Class(%GlobalCharacterStream).%New()
        d repParamStream.Write(repParamText)  
		
		s reportStream =  ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000045",repParamStream)
		
		continue:(reportStream.Size<=220)
		s docContentStream = ##Class(%GlobalCharacterStream).%New()
		d docContentStream.CopyFrom(reportStream)	

		s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(docContentStream,.reprot)
		continue:($$$ERROR(sccontent))
		///标本号
		s labEpisodeNo=""
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']/E07","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) labEpisodeNo = result.GetAt(1).Value
		continue:(labEpisodeNo '= ALabNo)&(ALabNo'="") // EH
			
		///医嘱号对应到标本号
		s oeordID = labEpisodeNo
			
		// 加一层S0061的循环
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061'])",.AddsubReport)
		continue:($$$ISERR(sc)||(AddsubReport.GetAt(1) = ""))
		s Addsubcount = AddsubReport.GetAt(1).Value

		for n=1:1:Addsubcount
		{	
			s (itemCode,itemDesc,synonym,itemResult,itemUnit,abnorFlag,itemRanges)=""
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061']["_n_"]/section[@code='S0062'])",.subReport)
			continue:($$$ISERR(sc)||(subReport.GetAt(1) = ""))
			s subcount = subReport.GetAt(1).Value
			// 培养类的结构单独算
			s Flag = 0
			if (subcount="0")
			{
				s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061']["_n_"]/section[@code='S0063'])",.BloodsubReport)
				continue:($$$ISERR(sc)||(BloodsubReport.GetAt(1) = ""))
				s Bloodsubcount = BloodsubReport.GetAt(1).Value
				//培养类标识符 Flag=1
				s subcount = Bloodsubcount
				s Flag = 1
			}
			for k=1:1:subcount
			{
				if (Flag '=1)
				{
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E01","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemCode = result.GetAt(1).Value
					
					///医嘱名称对应到检验子项目名称
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E02","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemDesc = result.GetAt(1).Value
					
					
					///定量结果
					s itemResult1 = "",itemResult2 = ""
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E03","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemResult1 = result.GetAt(1).Value
					///定性结果
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E05","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemResult2 = result.GetAt(1).Value
					
					///结果
					s itemResult = itemResult1_" "_itemResult2
					
					///单位
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E04","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemUnit = result.GetAt(1).Value,rptRowID = result.GetAt(1).Value
					
					///异常值		
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E07","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) abnorFlag = result.GetAt(1).Value
					s:(abnorFlag["H") abnorFlag = "偏高"
					s:(abnorFlag["L") abnorFlag = "偏低"
					s:(abnorFlag["P") abnorFlag = "阳性"
					s:(abnorFlag["Q") abnorFlag = "弱阳性"
					s:(abnorFlag["E") abnorFlag = "错误"
					///范围值
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0062']["_k_"]/E06","text()",.result)
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemRanges = result.GetAt(1).Value
				}
				s detailData = "["
				if (Flag=1)
				{
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/E01","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemCode = result.GetAt(1).Value
					
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/E02","text()",.result)			
					s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemDesc = result.GetAt(1).Value

					s (AntCode,AntName,LowRange,SenCode,SenName,Suggest,SenMethod)=""
					s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064'])",.BloodsubReport)
					continue:($$$ISERR(sc)||(BloodsubReport.GetAt(1) = ""))
					s bloodsubcount = BloodsubReport.GetAt(1).Value
					
					for j=1:1:bloodsubcount
					{
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E01","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AntCode = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E02","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) AntName = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E03","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) LowRange = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E04","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SenCode = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E05","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SenName = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E06","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Suggest = result.GetAt(1).Value
						s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0061']["_n_"]/section[@code='S0063']["_k_"]/section[@code='S0064']["_j_"]/E11","text()",.result)			
						s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SenMethod = result.GetAt(1).Value
						s:(j'=1) detailData = detailData_","
						s detailData = detailData_"{"
						s detailData = detailData_"""AntCode"":"""_AntCode_""","
						s detailData = detailData_"""AntName"":"""_AntName_""","
						s detailData = detailData_"""LowRange"":"""_LowRange_""","
						s detailData = detailData_"""ItemDesc"":"""_itemDesc_""","
						s detailData = detailData_"""SenCode"":"""_SenCode_"""," 
						s detailData = detailData_"""SenName"":"""_SenName_"""," 
						s detailData = detailData_"""Suggest"":"""_Suggest_""","
						s detailData = detailData_"""ReportDR"":"""_itemCode_""","
						s detailData = detailData_"""SenMethod"":"""_SenMethod_"""" 
						s detailData = detailData_"}"
					}
				}
				s detailData = detailData_"]"
				s data = $lb(oeordID,itemDesc,synonym,itemResult,itemUnit,abnorFlag,itemRanges,detailData,itemCode)
				s ^CacheTemp(repid,ind) = data
				s ind=ind + 1 
				s:($$$ISOK(sc)&&(result.GetAt(1)'="")) itemRanges = result.GetAt(1).Value		
			}
			//end
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
