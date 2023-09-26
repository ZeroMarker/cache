/// 名称:	EMR.DOC.HISInterface.PacsDataSrv
/// 描述:	数据平台检查接口业务类
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.DOC.HISInterface.PacsDataSrv Extends %RegisteredObject
{

/// Desc:       获取检查医嘱列表（HIS）
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      episodeId 就诊号
///             tmpStDate 就诊开始时间
/// 			tmpEndDate 就诊结束时间
/// OutPut:    	%Library.ResultSet 查询列表
/// debug:     	d ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectPACSItemListByDate()
ClassMethod SelectPACSItemListByDate(episodeId As %String, tmpStDate As %DateTime, tmpEndDate As %DateTime) As %Library.ResultSet
{
	s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
	d ds.Execute(episodeId,tmpStDate,tmpEndDate)
	q ds
}

/// Desc:       获取检查医嘱列表（HSBToHis）
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      episodeId 就诊号
///             tmpStDate 就诊开始时间
/// 			tmpEndDate 就诊结束时间
/// OutPut:    	%Library.ResultSet 查询列表
/// debug:     	d ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectPACSItemListData()
ClassMethod SelectPACSItemListData(episodeId As %String, tmpStDate As %DateTime, tmpEndDate As %DateTime) As %Library.ResultSet
{
	s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
	d ds.Execute(episodeId,tmpStDate,tmpEndDate)
	q ds
}

/// Desc:       查询检查报告（HIS）
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aOEItemRowID 医嘱rowID
/// OutPut:    	%Library.ResultSet 查询列表
/// debug:     	d ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportByOeordID()
ClassMethod SelectReportByOeordID(aOEItemRowID As %String) As %Library.ResultSet
{
	s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
	d ds.Execute(aOEItemRowID)
	q ds
}

/// Desc:       查询检查报告（HSBToHis）
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aOEItemRowID 医嘱rowID
/// OutPut:    	%Library.ResultSet 查询列表
/// debug:     	d ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportData()
ClassMethod SelectReportData(aOEItemRowID As %String) As %Library.ResultSet
{
	s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
	d ds.Execute(aOEItemRowID)
	q ds
}

/// Desc:      从数据平台取检查列表(数据平台)
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
/// Debug:     d ##class(%ResultSet).RunQuery("EMR.DOC.HISInterface.PacsDataSrv","GetPacsDataList",954540,"","")
Query GetPacsDataList(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Query(ROWSPEC = "EpisodeDate,DeptDesc,ItemName,OrdCreateDate,OrdCreateTime,OEOrdItemDR,RptRowID,RrtDate,RrtTime,ExamDesc,strResult,strOrderName,OEOrdStatus,DocID")
{
}

ClassMethod GetPacsDataListExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (episodeDate,deptDesc,itemName,OEOrdItemDR,rptRowID,rptDate,rptTime,examDesc,strResult,strOrderName)=""
    s patientId = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>00</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
	
	s reStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",paramStream)
	q:(reStream.Size <= 220) $$$OK

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
		s OEOrdItemDR="" // 
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E01","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) rptRowID = result.GetAt(1).Value
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E25","text()",.result)
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) OEOrdItemDR = result.GetAt(1).Value
		continue:((AFlagID '= "")&&(OEOrdItemDR '= AFlagID))
		s OEOrdStatus = ""
		if (OEOrdItemDR["-")
		{
			s OrderRowid="",itemsub="",OEOrdStatus="",OEOrdStatusDR=""
			s OrderRowid = $P(OEOrdItemDR,"-",1)
			s itemsub = $P(OEOrdItemDR,"-",2)
			s OEOrdStatusDR=$p($G(^OEORD(OrderRowid,"I",itemsub,"1")),"^",13)
			s:(OEOrdStatusDR'="") OEOrdStatus = $P(^OEC("OSTAT",OEOrdStatusDR),"^",2)
		}
		elseif (OEOrdItemDR["||")
		{
			s OrderRowid="",itemsub="",OEOrdStatus="",OEOrdStatusDR=""
			s OrderRowid = $P(OEOrdItemDR,"||",1)
			s itemsub = $P(OEOrdItemDR,"||",2)
			s OEOrdStatusDR=$p($G(^OEORD(OrderRowid,"I",itemsub,"1")),"^",13)
			s:(OEOrdStatusDR'="") OEOrdStatus = $P(^OEC("OSTAT",OEOrdStatusDR),"^",2)
		}
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/E0077/","text()",.result)
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) deptDesc =  result.GetAt(1).Value

		s episodeDate = $zd($p($g(^PAADM(AEpiosdeID)),"^",6),3)  
		s OrdCreateDate = docUpdateDate
		s OrdCreateTime = docUpdateTime
		s itemName = docTitle
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E23","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) rptDate = result.GetAt(1).Value
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E24","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) rptTime = result.GetAt(1).Value
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E08","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) examDesc = result.GetAt(1).Value
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E09","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) strResult = result.GetAt(1).Value
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0048']/text","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) strResult = result.GetAt(1).Value

		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0076']/E22","text()",.result)			
		s:($$$ISOK(sc)&&(result.GetAt(1)'="")) strOrderName = result.GetAt(1).Value
		
		s data = $lb(episodeDate,deptDesc,itemName,OrdCreateDate,OrdCreateTime,OEOrdItemDR,rptRowID,rptDate,rptTime,examDesc,strResult,strOrderName,OEOrdStatus,docId)
		s ^CacheTemp(repid,ind) = data
		s ind=ind + 1 
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
