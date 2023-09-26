Class DHCEPRFS.BL.HISInfo.BLPACSInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取PDF路径，以^分割，若无PDF返回空
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetFTPPath("4550449")
ClassMethod GetFTPPath(AEpisodeID As %String) As %String
{
	s ret = ##Class(RISService.InvokeRISService).EMRGetFTPRPTURLByPaadmdr(AEpisodeID)
	s retString = ret.Read()
	s retString = $ZSTRIP(retString,"*C")
	q retString
}

/// Desc: 获取检查报告-放射PACS路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetPACSFTPPath("4550449")
ClassMethod GetPACSFTPPath(AEpisodeID As %String) As %String
{
	//平台方法注释
	//s ret = ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetRISHOSDUrl(AEpisodeID,"PACS")
	s ret = ##class(RISService.InvokeRISService).EMRGetHTTPRPTURLByPaadmdr(AEpisodeID,"PACS")
	q ret
}

/// Desc: 获取检查报告-超声ES路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetESFTPPath("4550449")
ClassMethod GetESFTPPath(AEpisodeID As %String) As %String
{
	//平台方法注释
	//s ret = ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetRISHOSDUrl(AEpisodeID,"ES")
	s ret = ##class(RISService.InvokeRISService).EMRGetHTTPRPTURLByPaadmdr(AEpisodeID,"ES")
	q ret
}

/// Desc: 获取检查报告-内镜US路径
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetUSFTPPath("4550449")
ClassMethod GetUSFTPPath(AEpisodeID As %String) As %String
{
	//平台方法注释
	//s ret = ##class(web.DHCENS.STBLL.Method.QueryReportByID).GetRISHOSDUrl(AEpisodeID,"US")
	s ret = ##class(RISService.InvokeRISService).EMRGetHTTPRPTURLByPaadmdr(AEpisodeID,"US")
	q ret
}

/// Desc:	判断是否有检查报告
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).HasPACSReport("4550449")
ClassMethod HasPACSReport(AEpisodeID As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")	
	if (hospitalFlag = "")
	{
		s ret = ..GetStudyNo(AEpisodeID)
	}
	else
	{
		s ret = ..GetFTPPath(AEpisodeID)
	}
	q ret
}

/// Desc:	获取当次就诊检查号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetStudyNo("4550449")
ClassMethod GetStudyNo(AEpisodeID As %String) As %String
{
	s studyNoList = ""
	
	s risSpace = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("RISNameSpace")
	q:(risSpace="")||(risSpace= "NULL") studyNoList

	s curNameSpace = $zu(5)
	zn risSpace
	
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryOEItemDo","QueryRptPathbyPaadm","4550449")
	Set rset = ##class(%ResultSet).%New("web.DHCRisclinicQueryOEItemDo:QueryRptPathbyPaadm")
	Set sc = rset.Execute(AEpisodeID)
	While (rset.Next()) {
		if (studyNoList = "")
		{
			s studyNoList = rset.GetDataByName("StudyNo")
		}
		else
		{	
		s studyNoList = studyNoList_"^"_rset.GetDataByName("StudyNo")
		}
	}
	do rset.%Close()
	set rset = ""

	zn curNameSpace

	q studyNoList
}

/// Desc:	获取当次就诊检查号和日期
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetStudyInfo("4550449")
ClassMethod GetStudyInfo(AEpisodeID As %String) As %String
{
	s ret = ""
	
	s OEOrdItemDRS = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetOEOrdItemDR(AEpisodeID)
	s count = $l(OEOrdItemDRS,"^")
	for index=1:1:count
	{
		s OEOrdItemDR = $p(OEOrdItemDRS,"^",index)
		q:(OEOrdItemDR = "")
		
		s risSpace = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("RISNameSpace")
		q:(risSpace="")||(risSpace= "NULL")
	
		s curNameSpace = $zu(5)
		
		zn risSpace
		
		//StudyNo^RptDate
		s studyInfo = ##class(web.DHCRisPublicInterface).GetStudyInfo(OEOrdItemDR)	
		zn curNameSpace
		if (studyInfo '= "")
		{
			s studyNo = $p(studyInfo,"^",1)
			if ($e(studyNo,1) = "E") 
			{
				s length = $l(studyNo)
				s studyNo = $e(studyNo,2,length)
			}
			
			s RptDate = $p(studyInfo,"^",2)	
			s RptDate = $tr(RptDate,"-")
			
			if (ret = "")
			{
				s ret = studyNo_"|"_RptDate	
			}	
			else
			{
				s ret = ret_"^"_studyNo_"|"_RptDate
			}
		}
	}
	
	q ret
}

/// debug: w ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetStudyInfoNew("5013935")
ClassMethod GetStudyInfoNew(AEpisodeID As %String) As %String
{
	s ret = ""
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(AEpisodeID)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(AEpisodeID)),"^",18)
	
	//十个月前日期
	s PADischgeDateStart=+PADischgeDate - 300
	s PADischgeTimeStart=PADischgeTime	

	//病人号
	s patientID = $p($g(^PAADM(AEpisodeID)),"^",1)

	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(patientID,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		    s PAAdm = $o(^PAPERdr(patientID,"ADM",AdmType,PAAdm))
		    q:(PAAdm = "")
			continue:(..CheckEpisodeCancel(PAAdm) = "1")
			continue:(..CheckAdmDate(PAAdm,PADischgeDateStart,PADischgeDate,PADischgeTimeStart,PADischgeTime,AdmType) = "invalid")
			s studyi = ""
			for {
				s studyi = $o(^DHCRBStudyi("Report-PAADMDR",PAAdm,studyi))
				q:(studyi = "")
				
				s studyNo = $p(^DHCRBStudy("Report",studyi),"^",1)
				s RptDate = $p(^DHCRBStudy("Report",studyi),"^",9)
				s RptDate = $zd(RptDate,8)
				
				if (ret = "")
				{
					s ret = studyNo_"|"_RptDate	
				}	
				else
				{
					s ret = ret_"^"_studyNo_"|"_RptDate
				}
			}
		}
	}
	
	q ret
}

/// Desc:时间是否在查询范围内
/// Creator: Candyxu
/// Create Date:2012-07-27
/// [Previously private]
/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date, TimeFrom As %Time, TimeTo As %Time, Type As %String) As %Status
{
	s AdmDate = ""
	s AdmTime = ""
	
	if ((Type = "E") || (Type = "O")){
		s AdmDate = $P($g(^PAADM(Adm)),"^",6)
		s AdmTime = $P($g(^PAADM(Adm)),"^",7)
	}
	else{
		s AdmDate = $P($g(^PAADM(Adm)),"^",17)
		s AdmTime = $P($g(^PAADM(Adm)),"^",18)	
	}

	if (DateFrom '= "")&&(AdmDate < DateFrom) q "invalid" 
	if (TimeFrom '= "")&&(AdmDate = DateFrom)&&(AdmTime < TimeFrom) q "invalid" 
	If (DateTo '= "")&&(AdmDate > DateTo) q "invalid" 
	if (TimeTo '= "")&&(AdmDate = DateTo)&&(AdmTime>TimeTo) q "invalid" 
	//出院日期为空，过滤条件截至日期不为空
	if (Type = "out")&&(DateTo '= "") && (AdmDate = "") q "invalid"
	q "valid"
}

ClassMethod CheckEpisodeCancel(AEpisodeID As %String) As %String
{
	s ret = 0
	s flag = $p($g(^PAADM(AEpisodeID)),"^",20)
	s:(flag = "c") ret = 1
	q ret
}

/// Desc:      从数据平台取检查医嘱
/// Creator:   Candy
/// CreateDate:2016-8-16
/// Input:     AEpiosdeID 就诊号
/// Input:     AStartDate 开始时间
/// Input:     AEndDate 结束时间
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
	b
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

			s episodeDate = $zd($p($g(^PAADM(AEpiosdeID)),"^",6),3)  
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

/// 从检验检查组根据就诊号和起始时间查询病人检查医嘱列表
/// Input:     AEpiosdeID 就诊号
/// Input:     AStartDate 开始时间(默认为就诊时间)
/// Input:     AEndDate 结束时间(默认为当前时间)
Query SelectPACSItemListByDate(paadmdr As %String, StDate As %String, EndDate As %String, ArcItemDRParm As %String) As %Query(ROWSPEC = "ItemName:%String,OrdCreateDate:%String,OrdCreateTime:%String,OEOrdItemDR:%String,RptRowID:%String,RrtDate:%String,RrtTime:%String,ReportNo:%String")
{
}

ClassMethod SelectPACSItemListByDateExecute(ByRef qHandle As %Binary, paadmdr As %String, StDate As %String, EndDate As %String) As %Status
{
   
	//d ##class(%ResultSet).RunQuery("web.DHCRisclinicQueryEPR","SelectPACSItemListByDate","389","61151","61181")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	
	if $g(paadmdr)="" Set paadmdr=%request.Get("EpisodeID")
	i $g(paadmdr)="" Quit $$$OK
 	
 	s StDate=$p(StDate,$c(0))
 	
	s EndDate=$p(EndDate,$c(0))
	
	If $g(ind)="" Set ind=1
	s RegNo="",StudyNo="",strOrderName="",strDate = "",ReportRowID="",oeorditemdr=""
	
	s RptNum = 0
	s OrderRowid=""	
 	s OrderRowid=$o(^OEORD(0,"Adm",paadmdr,OrderRowid))
  	i $g(OrderRowid)="" Set qHandle=$lb(0,repid,0)
 	q:$g(OrderRowid)="" $$$OK
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",ItemStatus="N",IsIll="N"
	.s resrowid=""
	.q:(itemsub'=+itemsub) // 20121025 wangwentao add fixed ^OEORD(633889,"I","152,633889","X",0)
	.q:($d(^OEORD(OrderRowid,"I",itemsub,1))=0) // 20121025 wangwentao add fixed <UNDEFINED>^OEORD(OrderRowid,"I",itemsub,1) 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)   
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.q:$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7),"^",6)'="S"  // 20110125 wangwentao add 去掉非检查项目
	.//modify by niucaicai 2013-05-02 查询并输出下医嘱日期和下医嘱时间 start
	.//s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.//i ((Date1<StDate)!(Date1>EndDate)) q
	.//s strDate=$zd(Date1,3)
	.//s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.//s strTime=$zt(Time1)
	.s OrdCreateDate = $p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.i ((OrdCreateDate<StDate)!(OrdCreateDate>EndDate)) q
	.s OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17)
	.s OrdCreateTime=$zt(OrdCreateTime,2)
	.//modify by niucaicai 2013-05-02 查询并输出下医嘱日期和下医嘱时间 end
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ArcItemDR=$p(^OEORD(OrderRowid,"I",itemsub,"1"),"^",1)
	.//b //ArcItemDR
	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.s ReportNo=StudyNo
	.i StudyNo'="" d
	..s ReportRowID=0
	..s RptRowId=""
	..s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId),-1)  	//<2013-06-08><guozongtao><取最后一次发布的报告ID>
	..s ReportRowID=RptRowId
	..i (RptRowId '= "") d  												//<2013-06-08><guozongtao><只有发布的报告才查询出来医嘱信息>                                      	 	
	...s ReportDate=$p(^DHCRBStudy("Report",ReportRowID),"^",9)
	...s ReportTime=$p(^DHCRBStudy("Report",ReportRowID),"^",10)
	...s ReportDate=$zd(ReportDate,3)
	...s ReportTime=$zt(ReportTime)
	...d OutOEItemInfo
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutOEItemInfo
	set Data=$lb(strOrderName,OrdCreateDate,OrdCreateTime,oeorditemdr,ReportRowID,ReportDate,ReportTime,ReportNo)  //modify by niucaicai 2013-05-02 输出下医嘱日期和下医嘱时间
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelectPACSItemListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		//added on 2010-01-03 by houj -- 解决%XML.DataSet调用自定义查询无法执行Close方法
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPACSItemListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPACSItemListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
