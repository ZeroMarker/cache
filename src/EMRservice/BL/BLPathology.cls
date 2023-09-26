/// Desc:       病理信息
/// Creator:    Candy
/// CreateDate: 2016-8-24
Class EMRservice.BL.BLPathology Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      从数据平台取病理列表
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
/// Debug:     d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPathology","GetDataList",9569218,"","")
Query GetDataList(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Query(ROWSPEC = "EpisodeID,ClinicDiag,ClinicRecord,AppDate,AppTime,SpeInfo,tmid,ordername,Diagnosis,Seeing,RptDate,RptTime,PathId,SamplingDate,InspectionDate")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "", AFlagID As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (ClinicDiag,ClinicRecord,AppDate,AppTime,SpeInfo,tmid,ordername,Diagnosis,Seeing,RptDate,RptTime,PathId)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
    
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DocumentRetrievalRt>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_AEpiosdeID_"</PAADMVisitNumber>"
	s paramxml = paramxml_"<DocumentType>03</DocumentType><DocumentFormat>xml</DocumentFormat></DocumentRetrievalRt></Body></Request>"
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
	
	//s reStream = ##Class(%GlobalCharacterStream).%New()
	//d reStream.Write("<Response><Header><SourceSystem>数据中心</SourceSystem><MessageID>7</MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><DocumentRetrievalRp><Documents><Document><DocumentID>5235</DocumentID><DocumentPath></DocumentPath><DocumentTitle>经直肠超声检查</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>13:38:00</UpdateTime></Document><Document><DocumentID>5239</DocumentID><DocumentPath></DocumentPath><DocumentTitle>四肢多普勒血流图</DocumentTitle><DocumentType>02</DocumentType><UpdateUser>demo</UpdateUser><UpdateDate>2016-08-11</UpdateDate><UpdateTime>14:27:20</UpdateTime></Document></Documents></DocumentRetrievalRp></Body></Response>")	
	
	s reStream = ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000044",paramStream)
	q:(($p(reStream,"^",1)=-1)||(reStream.Size <= 0)) $$$OK 

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
		//b ;do reportStream.OutputToDevice()
		continue:(reportStream.Size<=0)		

		s sccontent = ##class(%XML.XPATH.Document).CreateFromStream(reportStream,.reprot)
		continue:($$$ERROR(sccontent))
		
		s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody","count(section[@code='S0141'])",.result)
		continue:($$$ISERR(sc)||(result.GetAt(1) = ""))
		s subcount = result.GetAt(1).Value
		for k=1:1:subcount
		{
			//申请号
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E01","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) tmid = result.GetAt(1).Value,rptRowID = result.GetAt(1).Value
			continue:((AFlagID '= "")&&(tmid '= AFlagID))
			continue:((AFlagID = "")&&(k '= "1"))
			
			//临床诊断
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E20","text()",.result)
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ClinicDiag =  result.GetAt(1).Value
			
			//标本信息
			//取材部位名称
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E14","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SpeInfo = result.GetAt(1).Value
			
			//临床病历
			//s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E21","text()",.result)
			//s:($$$ISOK(sc)&&(result.GetAt(1)'="")) ClinicRecord =  result.GetAt(1).Value
			
			//申请日期(平台未返回)
			s AppDate = ""
						
			//申请时间(平台未返回)
			s AppTime = ""
			
			//取样日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E10","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) SamplingDate = result.GetAt(1).Value
			
			//送检日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E15","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) InspectionDate = result.GetAt(1).Value
			
			//医嘱项
			s ordername = docTitle
			
			//病理诊断
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E22","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Diagnosis = result.GetAt(1).Value
			
			//检查所见
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E21","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) Seeing = result.GetAt(1).Value
			
			//发报告日期
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E18","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) RptDate = result.GetAt(1).Value
			
			//发报告时间
			s RptTime = ""
			
			//病理号
			s sc = reprot.EvaluateExpression("/clinicalDocument/structuredBody/section[@code='S0141']["_k_"]/E02","text()",.result)			
			s:($$$ISOK(sc)&&(result.GetAt(1)'="")) PathId = result.GetAt(1).Value
			
			s data = $lb(AEpiosdeID,ClinicDiag,ClinicRecord,AppDate,AppTime,SpeInfo,tmid,ordername,Diagnosis,Seeing,RptDate,RptTime,PathId,SamplingDate,InspectionDate)
			s ^CacheTemp(repid,ind) = data
			s ind=ind + 1 
		}

	}
	Quit $$$OK
}

ClassMethod GetDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
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
