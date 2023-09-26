Class DHCEPRFS.BL.HISInfo.BLLISInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取待打印的检验报告的数量
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasCSLISReport("5046744")
ClassMethod HasCSLISReport(AEpisodeID As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	s ret = "0"
	s meddataSpace = "MEDDATA"
	s curNameSpace = $zu(5)
	zn meddataSpace
	
	if (hospitalFlag = "NYFY")
    {
		s ret= $$GetTSRowIDByAdmno^DHCLabAdmReport(AEpisodeID)
    }
    else
    {
		s ret= $$JudgeTSByAdmno^DHCLabAdmReport(AEpisodeID)
    }
	zn curNameSpace
	
	q ret
}

/// Desc:	获取待打印的检验输血单
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasCSLISBloodReport("11053644")
ClassMethod HasCSLISBloodReport(AEpisodeID As %String) As %String
{
	s ret = "0"
	s meddataSpace = "MEDDATA"
	s curNameSpace = $zu(5)
	zn meddataSpace
	
	s ret= $$GetTSRowIDByAdmno^DHCBldAdmReport(AEpisodeID)
	
	zn curNameSpace
	
	q ret
}

/// Desc: 2023-02-10 yangshun 判断方法修改
/// Desc:	获取待打印的检验报告的数量
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetResultCountByAdm("10325757")
ClassMethod GetResultCountByAdm(AEpisodeID As %String) As %String
{
	/**s result = ##Class(web.DHCLabResultEMR).getResultsByAdm("","",AEpisodeID)
	s resultCount = $p(result,"^",1)
	s resultCount = (+resultCount)*/
	s lisNameSpace = "dhc-lisdata"
	s curNameSpace = $zu(5)
	zn lisNameSpace
	s ret = "0"
	s rset = ##class(%ResultSet).%New("Service.LIS.Report.DHCReportFileService:QryReportFileByAdmNo")
	s sc = rset.Execute(AEpisodeID,"","","","","","","","","","","","","","","")
	While (rset.Next())
	{
		s ret = "1"
		q
	}
	d rset.%Close()
	s rset = ""
	
	zn curNameSpace
	
	
	q ret
}

/// Desc:	获取待打印的输血申请单的数量
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBloodIDCountByAdm("5046744")
ClassMethod GetBloodIDCountByAdm(AEpisodeID As %String) As %String
{
	//b "s"
	s result = ##Class(web.DHCBldPrintAppFormEMR).GetAppIDByAdm(AEpisodeID)
	s resultCount = $p(result,"^",1)
	s resultCount = (+resultCount)
	q resultCount
}

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
			s episodeDate = $zd($p($g(^PAADM(AEpiosdeID)),"^",6),3)  
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

/// 根据就诊号和起始时间查询病人检查医嘱列表
/// Input:     AEpiosdeID 就诊号
/// Input:     AStartDate 开始时间(默认为就诊时间)
/// Input:     AEndDate 结束时间(默认为当前时间)
Query SelectLISItemListByDate(EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0) As %Query(ROWSPEC = "OEordItemRowID:%String,OEordItemDesc:%String,LabEpisodeNo:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,ReceiveDate:%String,ReceiveTime:%String,AuthorisationDate:%String,AuthorisationTime:%String,ExistReport:%String")
{
}

ClassMethod SelectLISItemListByDateExecute(ByRef qHandle As %Binary, EpisodeID As %String, Begdate As %Date = 0, EndDate As %Date = 0) As %Status
{
	Set ResultSetRootNode=$i(^CacheTemp) 		//记录集的根节点
	Set Counter=0       						//统计记录数，同时为子节点
 	Set OrderInfo=""    //保存一条记录
	Set OrderId="" 
	For  set OrderId=$Order(^OEORD(0,"Adm",EpisodeID,OrderId)) Quit:OrderId=""  Do
	.Set OEOrdDate=$P(^OEORD(OrderId),"^",2)
	.;Quit:$$CheckDate()'=1   //判断医嘱时间是否在查询的时间段中
	.Set OrderSubId=""  
	.For  set OrderSubId=$Order(^OEORD(OrderId,"I",OrderSubId)) Quit:OrderSubId=""  Do
	..S DataFlag=$Data(^OEORD(OrderId,"I",OrderSubId,1))
	..Q:(DataFlag'=1)&(DataFlag'=11)
	..Set ARCItemMastStr=^OEORD(OrderId,"I",OrderSubId,1)
	..S OEOrdStatus=$P(ARCItemMastStr,"^",13)
	..Q:OEOrdStatus'=6 //如果不是已经执行的医嘱则退出
	..Set TestSetStr=^OEORD(OrderId,"I",OrderSubId,3)
	..Set ARCIMId=$Piece(ARCItemMastStr,"^",2) Quit:ARCIMId=""
	..Set ItemNameDesc=..GetLabItemNameDesc(ARCIMId) Quit:ItemNameDesc=""
	..Set OrderRowId=OrderId_"||"_OrderSubId
	..Set LabNo=$Piece(TestSetStr,"^",20)
	..Set TSRowID=$Piece(TestSetStr,"^",35)
	..Set (SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport)=""
	..I ($l(TSRowID))&&(TSRowID["||") D  
	...S DataFlag=$DATA(^TEPI($P(TSRowID,"||",1),1,$P(TSRowID,"||",2),$P(TSRowID,"||",3)))
	...Q:(DataFlag'=1)&(DataFlag'=11)
	...S TSData=^TEPI($P(TSRowID,"||",1),1,$P(TSRowID,"||",2),$P(TSRowID,"||",3))
	...S Date(1)=$P(TSData,"\",44),Time(1)=$P(TSData,"\",45)  //标本采集日期，时间
	...i $l(Date(1)) s CollectDate=$ZD(Date(1),3)
	...i $l(Time(1)) s CollectTime=$ZT(Time(1),2)
	...S Date(2)=$P(TSData,"\",21),Time(2)=$P(TSData,"\",22)  //标本接收日期，时间
	...i $l(Date(2)) s RecDate=$ZD(Date(2),3)
	...i $l(Time(2)) s RecTime=$ZT(Time(2)*60,2)
	...S Date(3)=$P(TSData,"\",4),Time(3)=$P(TSData,"\",5)    //标本审核日期，时间
	...i $l(Date(3)) s AuthorDate=$ZD(Date(3),3)
	...i $l(Time(3)) s AuthorTime=$ZT(Time(3)*60,2)
	...S ExistReport=$S($P(TSData,"\",31)="A":"Y",1:"N")   //判断时候已经审核，审核则为Y,否则为N
	...S SpeTypeDR=$P(TSData,"\",46)
	...S SpeDesc=..GetSpecimenDesc(SpeTypeDR) //获取标本描述
	..Set OrderInfo=""
	..Set OrderInfo=$lb(OrderRowId,ItemNameDesc,LabNo,SpeDesc,CollectDate,CollectTime,RecDate,RecTime,AuthorDate,AuthorTime,ExistReport) //保存医嘱套RowID,医嘱描述,标本号
    ..Set ^CacheTemp(ResultSetRootNode,Counter)=OrderInfo
    ..Set Counter=Counter+1
    
    //重置qHandle的值，方便倒序输出
    Set qHandle=$lb(ResultSetRootNode,Counter)
    Kill Counter
	Quit $$$OK
CheckDate()
    if ((Begdate=0)&&(EndDate=0)) //未指定开始时间和结束时间
    {   
	    Quit 1
	}ElseIF (((Begdate=0)&&(OEOrdDate<=EndDate))||((EndDate=0)&&(OEOrdDate>=Begdate))) //未指定开始时间或结束时间
	{  
		Quit 1
	}ElseIF ((OEOrdDate>=Begdate)&&(OEOrdDate<=EndDate)) //指定了开始时间和结束时间
	{
		Quit 1
	}
    Quit 0   //其他情况返回0
}

ClassMethod SelectLISItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	/*
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	Set:currChildNode=0 Row="",AtEnd=1
	Set:currChildNode'=0 Row=^CacheTemp(RootNode,currChildNode-1),qHandle=$lb(RootNode,currChildNode-1)
	Quit $$$OK
	*/
	
	//modified on 2010-01-13 by houj
	set RootNode=$List(qHandle,1)
	Set currChildNode=$List(qHandle,2)
	
	s currChildNode = $O(^CacheTemp(RootNode,currChildNode),-1)
	if (currChildNode="") 
	{
		s Row=""
		s AtEnd=1
		kill ^CacheTemp(RootNode)
	}
	else
	{
		s Row=^CacheTemp(RootNode,currChildNode)
		s qHandle=$lb(RootNode,currChildNode)
	}
	
	Quit $$$OK
}

ClassMethod SelectLISItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectLISItemListByDateExecute ]
{
	set RootNode=$List(qHandle,1)
	Kill ^CacheTemp(RootNode)
	Set qHandle=""
	Quit $$$OK
}

/// 获得检验项目的名称
/// [Previously private]
ClassMethod GetLabItemNameDesc(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ItemCatId=$Piece(^ARCIM(ItemId,ItemSub,1),"^",10) Quit:ItemCatId="" ""
	Quit:..GetItemOrderType(ItemCatId)'="L" ""
	Set ItemDesc=$Piece(^ARCIM(ItemId,ItemSub,1),"^",2)
	Quit ItemDesc
}

/// 获得检验项目的类别
/// [Previously private]
ClassMethod GetItemOrderType(ItemCatId As %String) As %String
{
	s OrderTypeStr=^ARC("IC",ItemCatId) Quit:OrderTypeStr="" ""
	s OrderType=$P(OrderTypeStr,"^",7)	Quit:OrderType="" ""
	Quit OrderType
}

/// 根据标本代码获取标本名称描述
/// [Previously private]
ClassMethod GetSpecimenDesc(SpecCode As %String) As %String
{
	S SpecDesc=""
	Q:'$l(SpecCode) SpecDesc
	S DataFlag=$D(^TTAB("SPEC",SpecCode))
	Q:(DataFlag'=1)&(DataFlag'=11) SpecDesc
	S SpeData=^TTAB("SPEC",SpecCode)
	S SpecDesc=$P(SpeData,"\",1)
	Q SpecDesc
}

ClassMethod GetConnectString() As %String
{
	s ret = ##class(DHCLIS.DHCOrderList).GetConnectString()
	q ret
}

/// Desc: 获取检验PDF路径，多个路径以;分隔
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetLISPDFPath("")
ClassMethod GetLISPDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
	s lisNameSpace = "dhc-lisdata"
	s curNameSpace = $zu(5)
	zn lisNameSpace
	
	s rset = ##class(%ResultSet).%New("Service.LIS.Report.DHCReportFileService:QryReportFileByAdmNo")
	s sc = rset.Execute(AEpisodeID,"","","","","","","","","","","","","","","")
	While (rset.Next())
	{
		if (ret = "") {
			s ret = rset.GetDataByName("PDFPath")
		}
		else {
			s ret = ret_";"_rset.GetDataByName("PDFPath")
		}
	}
	d rset.%Close()
	s rset = ""
	
	zn curNameSpace
	q ret
}

/// 由于lis报告的pdf路径里面有^符号，原有的分割不好使用
/// Desc: 获取检验PDF路径，按照第三方xml格式返回
/// Debug: w ##class(DHCEPRFS.BL.HISInfo).GetLISPDFPathNew("")
ClassMethod GetLISPDFPathNew(AEpisodeID As %String) As %GlobalCharacterStream
{
	s ret = ##class(%GlobalCharacterStream).%New()
	s lisNameSpace = "dhc-lisdata"
	s curNameSpace = $zu(5)
	zn lisNameSpace
	//Response/PathList/Path/FilePath
	d ret.Write("<Response><PathList>")
	s rset = ##class(%ResultSet).%New("Service.LIS.Report.DHCReportFileService:QryReportFileByAdmNo")
	s sc = rset.Execute(AEpisodeID,"","","","","","","","","","","","","","","")
	While (rset.Next())
	{
		d ret.Write("<Path><FilePath>"_rset.GetDataByName("PDFPath")_"</FilePath></Path>")
	}
	d rset.%Close()
	s rset = ""
	d ret.Write("</PathList></Response>")
	zn curNameSpace
	q ret
}

/// Desc: 按断是否有输血相关单据打印
/// Input： AEpisodeID 就诊号，ATye：01003 发血单,01007 申请单
/// Retuen: 0 不打印；1 打印
/// Debug: w ##class(DHCERFS.BL.HISInfo.BLLISInfo).HasBLDPath("","")
ClassMethod HasBLDPath(AEpisodeID As %String, AType As %String) As %String
{
	
	s pdfPaths = ..GetBLDPathByType(AEpisodeID,AType)   //申请单  
	q:(pdfPaths="") "0"
	q "1"
}

ClassMethod GetBLDPath(AEpisodeID As %String, AType As %String) As %GlobalCharacterStream
{
	s ret = ##class(%GlobalCharacterStream).%New()
	
	d ret.Write("<Response><PathList>")
	s pdfPaths = ..GetBLDPathByType(AEpisodeID,AType)   //申请单  
	s len = $L(pdfPaths,";")
	for i=1:1:len
	{
		d ret.Write("<Path><FilePath>"_$P(pdfPaths,";",i)_"</FilePath></Path>")
	}
	
	d ret.Write("</PathList></Response>")
	
	q ret
}

/// Desc:  获取输血相关
/// Debug： w ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBLDPathByType("2766","01007")  --申请单
/// Debug： w ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBLDPathByType("2766","01003")  --发血单
ClassMethod GetBLDPathByType(AEpisodeID As %String, AType As %String) As %String
{
	s ret = ""
	s lisNameSpace = "dhc-lisdata"
	s curNameSpace = $zu(5)
	zn lisNameSpace
	s ret = ""
	s rset = ##class(%ResultSet).%New("Service.BLDService.Report.DHCReportFileService:QryReportFileByAdmNo")
	s sc = rset.Execute(AEpisodeID,AType,"","","","","","","","","","","","","","")
	While (rset.Next())
	{
		if (ret="")
		{
			s ret=rset.GetDataByName("PDFPath")
		}
		else
		{
			s ret = ret_";"_rset.GetDataByName("PDFPath")
		}
	}
	d rset.%Close()
	s rset = ""
	zn curNameSpace
	q ret
}

}
