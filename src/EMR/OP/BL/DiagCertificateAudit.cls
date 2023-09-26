/// 名称:	EMR.OP.BL.DiagCertificateAudit
/// 描述:	门诊诊断证明书审核逻辑
/// 编写者：yejian
/// 编写日期: 2023-1-30
/// 产品组：电子病历产品组
Class EMR.OP.BL.DiagCertificateAudit Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取门急诊断证明书审核就诊列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPPATLIST","params":{"papmiNo":"","name":"","cardID":"","expectedLocId":"","startDate":"2020-01-25","endDate":"2023-01-30","checkStatus":"未审核","docType":"ALL"},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetOPPatList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	;s ^TempJson(0)=argInJson.%ToJSON()
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.PapmiNo = argInJson.params.papmiNo
	s objItem.Name = argInJson.params.name
	s objItem.CardID = argInJson.params.cardID
	s objItem.ExpectedLocId = argInJson.params.expectedLocId
	s startDate = argInJson.params.startDate
	s:(startDate'="") objItem.StartDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",startDate)
	s endDate = argInJson.params.endDate
	s:(endDate'="") objItem.EndDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",endDate)
	s objItem.CheckStatus = argInJson.params.checkStatus
	s objItem.DocType = argInJson.params.docType
	s objItem.Product =argInJson.product
	s page = argInJson.params.page  
    s rows=argInJson.params.rows
    s:(page'="") objItem.StartPage = rows * (page -1) + 1
	s:(page'="") objItem.EndPage = objItem.StartPage + rows -1
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetOPPatListJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	//q argOutMessage.success = ..#OK
	  	//showtype -1 不输出外层信息，只输出argOutData
	  	q ..SetOutMessage(argOutMessage,"","",-1)
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取门急诊断证明书审核就诊列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aItem 查询入参
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetOPPatListJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",count = 0, countflag = 1
	s resJson = ##class(%DynamicObject).%New()
	s jRows = ##class(%DynamicArray).%New()
    
    // 新建一个队列，为了按照就诊日期和就诊时间排序		默认查询3天内数据，如果只给了开始或者结束时间，也是给定时间的后三天后者前三天数据
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
    if (aItem.EndDate="")&&(aItem.StartDate="")
    {
		s aItem.EndDate = $p($h,",",1)
		if (aItem.StartDate="")
		{
			s aItem.StartDate = aItem.EndDate- 2
		}
	}
    s sysStdate = aItem.StartDate
    s sysEnddate = aItem.EndDate
    if (sysStdate="")&&(sysEnddate'="")
    {
		s sysStdate = sysEnddate - 2
	}
	if (sysStdate'="")&&(sysEnddate="")
    {
		s sysEnddate = sysStdate + 2
	}
	//从系统参数获取模板docid
    s DiagnoseProofDocID = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("diagnoseProofDocCode",aItem.Product)
    if (aItem.DocType="")||(aItem.DocType="ALL"){
        s DiagnoseProofDocID = DiagnoseProofDocID
    }else{
        s DiagnoseProofDocID = aItem.DocType
    }
    try
	{
		if (DiagnoseProofDocID'="")
		{
			s DiagnoseProofJson = ##class(%DynamicAbstractObject).%FromJSON(DiagnoseProofDocID)
		}
	}
	catch
	{
		s strRes= "-1^系统参数diagnoseProofDocCode非JSON格式，或未配置"
	}
	q:(strRes["-1^") strRes
    //获取是否显示所有就诊记录
    s getAllDataFlag = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("IsGetAllDataInAudit",aItem.Product,"N")
    
    // 登记号不为空，按照登记号查所有就诊记录
    if (aItem.PapmiNo'=""){
        
        s PapmiNo = $O(^PAPERi("PAPMI_PatNo",aItem.PapmiNo,""))
        q:(PapmiNo="")
        d GetAllEpisodeID
    }
    // 卡号不为空就按照卡号查
    elseif (aItem.CardID'=""){
        
        s CFRowID = ""
        for {
            s CFRowID = $O(^DHCCARDi("CF",0,"CardNo",aItem.CardID,CFRowID),-1)
            q:(CFRowID="")
            s PapmiNo = $P(^DHCCARD("CF",CFRowID),"^",4)
            q:(PapmiNo="")
            d GetAllEpisodeID
        }
    }
    // 姓名不为空就按照姓名查
    elseif (aItem.Name'=""){
        
        s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
        s PapmiNo = ""
        for {
            
            s PapmiNo = $O(^PAPERi("PAPER_PatName",$zstrip(aItem.Name,"*p"),PapmiNo),-1)
            q:(PapmiNo = "")
            d GetAllEpisodeID
        }
    }
    elseif (aItem.ExpectedLocId '= ""){
        s admDate = ""
        for
        {
            s admDate = $o(^PAADMi("CurrLoc",aItem.ExpectedLocId,admDate),-1)
            q:(admDate = "")
            continue:((sysStdate '= "")&&(sysEnddate '="")&&((admDate>sysEnddate)||(admDate<sysStdate)))
            s admTime = ""
            for
            {
                s admTime = $o(^PAADMi("CurrLoc",aItem.ExpectedLocId,admDate,admTime),-1)
                q:(admTime = "")
                s episodeid = ""
                for
                {
                    s episodeid = $o(^PAADMi("CurrLoc",aItem.ExpectedLocId,admDate,admTime,episodeid),-1)
                    q:(episodeid = "")
                    s admType = $p($g(^PAADM(episodeid)),"^",2)
                    if ((admType = "O")||(admType = "E"))
                    {
						if (getAllDataFlag '= "Y")
						{
							s episodeIdFlag = 0
							s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(episodeid)
							set iter = DiagnoseProofJson.%GetIterator()
							while iter.%GetNext(.key , .item ) {
								s doccode =key
								s docId = $o(@TILDocumentData@("IdxEpisodeRecordCodeStatus",episodeid," "_$zcvt(doccode,"U"),""))
								if (docId '= "")
								{
									s episodeIdFlag = 1
									q
								}
							}
							continue:(episodeIdFlag=0)
						}
						d EpisodeIDsArray
					}
                }
            }
        }
    }elseif (sysStdate '= "")&(sysEnddate '= ""){
        for admDate = sysStdate:1:sysEnddate {
            s episodeid = ""
            for {
                s episodeid = $o(^PAADMi("PAADM_AdmDate",admDate,episodeid))
                q:(episodeid = "")
                s admType = $p($g(^PAADM(episodeid)),"^",2)
				if ((admType = "O")||(admType = "E"))
				{
					if (getAllDataFlag '= "Y")	//如果不是查询全部数据，就只把有诊断证明书的就诊号存起来
					{
						s episodeIdFlag = 0
						s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(episodeid)
						set iter = DiagnoseProofJson.%GetIterator()
						while iter.%GetNext(.key , .item ) {
							s doccode =key
							s docId = $o(@TILDocumentData@("IdxEpisodeRecordCodeStatus",episodeid," "_$zcvt(doccode,"U"),""))
							if (docId '= "")
							{
								s episodeIdFlag = 1
								q
							}
						}
						continue:(episodeIdFlag=0)
					}
					d EpisodeIDsArray
				}
            }
       }
    }
    
    d GetSortEpisode
	
	s resJson.total = count
	s resJson.rows = jRows
    d resJson.%ToJSON(argOutData)
    q strRes

GetAllEpisodeID       
    s AdmType = "O" , episodeid = ""
    for {
        s episodeid = $O(^PAPERdr(PapmiNo,"ADM",AdmType,episodeid),-1)
        if (episodeid="") {
            if (AdmType = "O"){ 
                s AdmType = "E"
                s episodeid=""
                continue
            } 
            else { q }
        }
        // 按照时间倒叙
        d EpisodeIDsArray
    }
    
    q

EpisodeIDsArray
    s d = $P($G(^PAADM(episodeid)),"^",6)
    s t = "0000"_($P($G(^PAADM(episodeid)),"^",7))
    s e = "000000000"_episodeid
    s key = d_$E(t,$L(t)-4,$L(t))_$E(e,$L(e)-9,$L(e))
    d episodeIDs.SetAt(episodeid, key)
    q
        
GetSortEpisode        
    s key=""
    while (1){
        s key = episodeIDs.Previous(key)
        q:(key = "")
        s episodeid = episodeIDs.GetAt(key)
        //q:(countflag=1000)
        d outputrow(episodeid)
    }
    q
        
outputrow(episodeid)

    s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo) = ""
    
    s EpisodeID = episodeid
    
    s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
    
    s documentId = "", chartItemType = "", pluginType = "", status = "未创建", title = "", auditStatus = "未审核",auditDate = "",auditTime = "",serial="",isLeadframe=""
    //诊断证明书DocId 299
    s result = ##Class(%Library.ResultSet).%New("EMR.OP.BL.DiagCertificateAudit:GetDataByDocID")
	d result.Execute(EpisodeID,DiagnoseProofJson)
    While (result.Next()) {
	    s documentId = "", chartItemType = "", pluginType = "", status = "未创建", title = "", auditStatus = "未审核",auditDate = "",auditTime = "",serial="",isLeadframe=""
        s documentId = $g(result.Data("ID"))
        s chartItemType = $g(result.Data("ChartItemType"))
        s pluginType = $g(result.Data("DocumentType"))
        s status = $Case($zcvt($g(result.Data("Status")),"U"),"UNSAVE":"未保存","DELETE":"已删除","SAVE":"已保存")
        // 过滤未保存的病历记录
        continue:((getAllDataFlag '= "Y")&&(status = "未保存"))
        s tmpDocCode = $g(result.Data("DocCode"))
        s title = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(result.Data("Title"))
        
        s singFlag = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(EpisodeID,documentId)
        if (status = "已删除") {
            s auditStatus = "作废"
        } 
        else {
	        if (singFlag = 1)
	        {
		    	s status = "已签名"
		    }
            s auditRowID = $O(^EMR.OP.ExtAuditLogI("IdxdocId",documentId,""),-1)
            if (auditRowID '= "") {
                s objExtAudit = ##class(EMR.OP.ExtAuditLog).%OpenId(auditRowID)
                s:((objExtAudit.Action = "checked")&&(objExtAudit.Status = "1")) auditStatus = "已审核"
				s:((objExtAudit.Action = "refused")&&(objExtAudit.Status = "1")) auditStatus = "已拒绝"
                s auditDate = $ZD(objExtAudit.AuditDate,3)
                s auditTime = $ZT(objExtAudit.AuditTime)
            }
        }
        continue:((aItem.CheckStatus '= "")&&(aItem.CheckStatus '= "全部")&&(aItem.CheckStatus '= auditStatus))
		s serial=$g(result.Data("serial"))
		s isLeadframe=$g(result.Data("isLeadframe"))
        d json
    }
    if (result.%ROWCOUNT = 0)||(result.%ROWCOUNT = "") {
	    q:(getAllDataFlag '= "Y")
		q:((aItem.CheckStatus '= "")&&(aItem.CheckStatus '= "全部")&&(aItem.CheckStatus '= auditStatus))
        d json
    }
    s countflag = countflag + 1
    q
json
	//卡号
    s CardNo = "" //##class(EMR.DOC.HISInterface.PatientInfoAssist).GetCardNo(PapmiDR)
    s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDR,""))
    if (CFRowId '= "") {
        s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    }
    
    //姓名
    s Name = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
    
    //身份证号
    s IDCard = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).IDCard(PapmiDR)
    
    //性别
    s Gender = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
    s:(Gender'="") GenderDesc = $P(Gender,"^",3)
    
    //年龄
    s birthday = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
    s admDate = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID, "")
    s admDate = $P(admDate, ",", 1)
    s Age = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(EpisodeID,birthday,admDate,1)
    
    //就诊日期,时间
    s AdmDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
    s AdmDate = $P(AdmDateTime,",",1)
    q:((sysStdate '= "")&&(sysEnddate '="")&&((AdmDate>sysEnddate)||(AdmDate<sysStdate)))
    s AdmDate = $zd(AdmDate,3)
    
    s AdmDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)

    s AdmTime = $P(AdmDateTime,",",2)
    s AdmTime = $ZT(AdmTime)
    s AdmTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)

    //科室
    s tmpDisDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
    s DeptId = $P(tmpDisDept,"^",1)
    q:((aItem.ExpectedLocId '= "")&&(DeptId '= aItem.ExpectedLocId))
    s DeptDesc = $P(tmpDisDept,"^",3)
    
    //主管医师
    s AdmDocDesc = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
    s AdmDocDesc = $P(AdmDocDesc,"^",3)
    
    //门诊诊断
    s OPDiagStringH = ""
    s MRadm = $P($G(^PAADM(EpisodeID)),"^",61)
    /*s tmpOPDiagDict = ##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(MRadm,"","") 
    i tmpOPDiagDict'="" {
        s OPDiagLength = $L(tmpOPDiagDict,$C(1))
        f i = 1:1:OPDiagLength
        {
            s:(OPDiagStringH '= "") OPDiagStringH = OPDiagStringH_","
            s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
        }
        
    }*/
	//备注
    s OPDiagStringR =""
    //前缀 prefix
    s OPDiagStringP =""
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")	
	d obj.Execute(MRadm,"","")
	s sum = 0
	s OPDiagString = ""
	While (obj.Next())
	{
		s OPDiagStringH = obj.Data("DiagnosDesc")
		s OPDiagStringR = obj.Data("DiagnosMRDesc")
		s OPDiagStringP = obj.Data("DiagnosPrefix")
		
		s:(sum '=0) OPDiagString =OPDiagString_","
		s OPDiagString = OPDiagString_OPDiagStringP_OPDiagStringH_"("_OPDiagStringR_")"
		s sum = sum + 1
	}
	s jitem = ##class(%DynamicObject).%New()
	s jitem.PatientID = PapmiDR
	s jitem.EpisodeID = EpisodeID
	s jitem.mradm = EpisodeID
	s jitem.PAPMIName = Name
	s jitem.PAPMISex = GenderDesc
	s jitem.PAPMIIDCard = IDCard
	s jitem.PAPMIAge = Age
	s jitem.PAAdmDate = AdmDate
	s jitem.PAAdmTime = AdmTime
	s jitem.PAAdmLoc = DeptDesc
	s jitem.PAAdmDoc = AdmDocDesc
	s jitem.Diagnosis = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(OPDiagStringH)
	s jitem.DocumentID = documentId
	s jitem.ChartItemType = chartItemType
	s jitem.PluginType = pluginType
	s jitem.Status = status
	s jitem.Title = title
	s jitem.AuditStatus = auditStatus
	s jitem.AuditDate = auditDate
	s jitem.AuditTime = auditTime
	s jitem.DocCode = tmpDocCode
	s jitem.serial=serial
	s jitem.isLeadframe = isLeadframe
	s count = count + 1
	if ((aItem.StartPage <= count)&(count <= aItem.EndPage))
	{
   		d jRows.%Push(jitem)
	}
   
	q
}

/// desc:	根据就诊号和docId获取ECRecord表和instanceData表中的数据
/// d ##Class(%ResultSet).RunQuery("EMR.OP.BL.DiagCertificateAudit","GetDataByDocID",1587,299)
Query GetDataByDocID(AEpisodeID As %String, aItem As %DynamicAbstractObject) As %Query(ROWSPEC = "ID,Status,Title,ChartItemType,DocumentType,DocCode,serial,isLeadframe")
{
}

ClassMethod GetDataByDocIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, aItem As %DynamicAbstractObject) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	
	s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	set iter = aItem.%GetIterator()
	while iter.%GetNext(.key , .item ) {
		s doccode =key
		s status=""
		for
		{
			s status = $o(@TILDocumentData@("IdxEpisodeRecordCodeStatus",AEpisodeID," "_$zcvt(doccode,"U"),status))
			q:(status="")
			s docID = ""
			for
			{
				s docID = $o(@TILDocumentData@("IdxEpisodeRecordCodeStatus",AEpisodeID," "_$zcvt(doccode,"U"),status,docID))
				q:(docID="")
				s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
				q:(objDocument="")
				s objTem="",objTemCat="",strTemCId="",isLeadframe=""
				s objTem = objDocument.TemplateID
				s:(objTem'="") strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
				s:(strTemCId'="") objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)		
				s ID = docID
				s Status = objDocument.Status
				s Title = objDocument.DOCName
				s ChartItemType = objDocument.TemplateID.ChartItemType
				s serial = objDocument.Serial
				s:(objTemCat'="")&&(objTemCat.Title'="") isLeadframe = objTemCat.Title.IsLeadframe
				//指定病历实例是否有对应患者签名后的PDF文档
				s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docID, AEpisodeID)
				s DocumentType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
				d OutPut
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
    set Data=$lb(ID,Status,Title,ChartItemType,DocumentType,doccode,serial,isLeadframe)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataByDocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataByDocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:       获取门急诊断证明书审核就诊列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPPATINFO","params":{"papmiNo":"","medNo":"","name":"","idCardNo":"","cardID":"0000000010"},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetOPPatInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.PapmiNo = argInJson.params.papmiNo
	s objItem.Name = argInJson.params.name
	s objItem.CardID = argInJson.params.cardID
	s objItem.MedNo = argInJson.params.medNo
	s objItem.IDCardNo = argInJson.params.idCardNo
	s objItem.Product =argInJson.product
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetOPPatInfoJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取门急诊断证明书审核就诊列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aItem 查询入参
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetOPPatInfoJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s arrJson = ##class(%DynamicArray).%New()
    // 登记号, 病案号, 病人姓名, 病人身份证号, 病人就诊卡号
    s (PAPMINO, MedicareNo, PAPMIName, IDCardNo, CardNo) = ""
    if (aItem.PapmiNo '= "") {
        s PAPMIDR = ""
        for {
            s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",aItem.PapmiNo,PAPMIDR),-1)
            q:(PAPMIDR = "")
            s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
            continue:(PAPMINO '= aItem.PapmiNo)
            d outputrow
        }
    }elseif (aItem.MedNo '= "") {
        s PAPMIDR = ""
        for {
			s PAPMIDR = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(aItem.MedNo)
            q:(PAPMIDR = "")
            d outputrow
        }
    }elseif (aItem.Name '= "") {
        s Name = $zcvt(aItem.Name,"u")
        s PAPMIDR = ""
        for {
            s PAPMIDR = $o(^PAPERi("PAPER_PatName",$zstrip(Name,"*p"),PAPMIDR),-1)
            q:(PAPMIDR = "")
            s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
            continue:(PAPMIName '= aItem.Name)
            d outputrow
        }
    }elseif (aItem.IDCardNo '= "") {
        s PAPMIDR = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard(aItem.IDCardNo)
        q:(PAPMIDR = "")
        s IDCardNo = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
        q:(IDCardNo '= aItem.IDCardNo)
        d outputrow
    }elseif (aItem.CardID '= "") {
        s CFRowId = ""
        for {
            s CFRowId = $o(^DHCCARDi("CF",0,"CardNo",aItem.CardID,CFRowId),-1)
            q:(CFRowId = "")
            s PAPMIDR = $p($g(^DHCCARD("CF",CFRowId)),"^",4)
            q:(PAPMIDR = "")
            s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
            continue:(CardNo '= aItem.CardID)
            d outputrow
            
        }
    }
    d arrJson.%ToJSON(argOutData)
    q strRes
outputrow
    s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
    s MedicareNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByPatientID(PAPMIDR)
    s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
    s IDCardNo = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
    s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""))
    if (CFRowId '= "") {
        s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    }
    //PAPMIDR患者指针(即PatientID)
    s itemJson = ##class(%DynamicObject).%New()
    s itemJson.PAPMIDR = PAPMIDR
    s itemJson.RegNo = PAPMINO
    s itemJson.MedNo = MedicareNo
    s itemJson.PatName = PAPMIName
    s itemJson.IDCardNo = IDCardNo
    s itemJson.CardNo = CardNo
	d arrJson.%Push(itemJson)
    q
}

/// Desc:      获取文档类型
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_DOCTYPEDATA","params":{},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetDocTypeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct =argInJson.product
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetDocTypeDataJson(strProduct,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取文档类型
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetDocTypeDataJson(aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",docItems=""
	s arrJson = ##class(%DynamicArray).%New()
    //从系统参数获取模板docid
    s diagnoseProofDocCode = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("diagnoseProofDocCode",aProduct)
    if (diagnoseProofDocCode="")
    { 
	    d arrJson.%ToJSON(argOutData)
	    q strRes
    }
    s itemJson = ##class(%DynamicObject).%New()
    s itemJson.DocCode = "ALL"
    s itemJson.Desc = "全部"
    s itemJson.selected = "true"
    d arrJson.%Push(itemJson)
	try
	{
		s docItems = ##class(%DynamicAbstractObject).%FromJSON(diagnoseProofDocCode)
	}
	catch
	{
		s strRes= "-1^系统参数diagnoseProofDocCode配置的格式有误"
	}
	q:(strRes["-1^") strRes
	set iter = docItems.%GetIterator()
	while iter.%GetNext(.key , .item ) {
	    s itemJson = ##class(%DynamicObject).%New()
	    s itemJson.DocCode = key
	    s itemJson.Desc = item
	    ;s itemJson.selected = "false"
		d arrJson.%Push(itemJson)
	}
	
	d arrJson.%ToJSON(argOutData)
    q strRes
}

/// Desc:      获取审核人列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_SSUSERBYLOCID","params":{"userLocID":"114","userID":"1"},"product":"OP"}
/// 			userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetSSUserByLocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.UserID = argInJson.params.userID
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetSSUserByLocIDJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取审核人列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aItem 参数对象
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetSSUserByLocIDJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.UserLocID="") "-1^科室ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	
	// 从科室的编号开始查询所有相关的用户
	s ctloc=^CTLOC(aItem.UserLocID)
	q:ctloc="" "-1^根据科室ID获取科室信息失败"
	s ctlocName=$p(ctloc, "^", 1)
	s rowID = 0
	for {
		s rowID = $o(^SSU("SSUSR",rowID))
		q:(rowID = "")
		s user = $g(^SSU("SSUSR",+rowID))
		s usrName = $p(user,"^",1)
		s Name = $p(user,"^",2)
		s Initials = $p(user,"^",1)
		s CTPCPID = $p(user,"^",14)
		//根据资源表来判断用户科室  RB_Resource
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowID})
		if ($d(^RB("RES",0,"CTPCP",+CTPCPID,aItem.UserLocID)))
		{
			s itemJson = ##class(%DynamicObject).%New()
			s itemJson.ID=rowID
			s itemJson.Name=Initials_"-"_Name
			s:(aItem.UserID=rowID) itemJson.selected = "true"
			d arrJson.%Push(itemJson)
		}
	}
	d arrJson.%ToJSON(argOutData)
    q strRes
}

/// Desc:      获取审核日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_DIAGAUDITLOG","params":{"documentID":"1"},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetDiagAuditLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetDiagAuditLogJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取审核日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetDiagAuditLogJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.DocumentID="") "-1^文档ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()	
	s rowID = "",resData = "",count = 0
	for {
		s rowID = $O(^EMR.OP.ExtAuditLogI("IdxdocId",aItem.DocumentID,rowID))
		q:(rowID="")
		s objAuditLog = ##Class(EMR.OP.ExtAuditLog).%OpenId(rowID)
		continue:(objAuditLog.Action '= "checked")||(objAuditLog.Status '= "1")
		s AuditUser="",AuditDate = "",AuditTime = ""
		s:(objAuditLog.AuditUser'="") AuditUser = objAuditLog.AuditUser.SSUSRName
		s:(objAuditLog.AuditDate'="") AuditDate = $ZD(objAuditLog.AuditDate,3)
		s:(objAuditLog.AuditTime'="") AuditTime = $ZT(objAuditLog.AuditTime)
		s count =count+1
		s resData = "审核日期:"_AuditDate_" "_AuditTime_"  审核人:"_AuditUser
		d arrJson.%Push(resData)
	}
	s resJson = ##class(%DynamicObject).%New()
	s resJson.total =count
	s resJson.auditMessage =arrJson
	d resJson.%ToJSON(argOutData)
    q strRes
}

/// Desc:      添加审核日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"INSERT_DIAGAUDITLOG","params":{"documentID":"1","userID": "1","auditUserID":"1","status":"checked","ipAddress":"127.0.0.1"},"product":"OP"}
/// 			documentID 文档ID，userID 用户ID ，auditUserID 审核用户ID，status 审核通过checked 审核未通过 refused
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod InsertDiagAuditLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.AuditUserID = argInJson.params.auditUserID
	s objItem.Status = argInJson.params.status
	s objItem.OperateMachineIP =  argInJson.params.ipAddress
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).InsertDiagAuditLogJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       添加审核日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod InsertDiagAuditLogJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s $zt = "Error"
	q:(aItem.DocumentID="")||(aItem.UserID="")||(aItem.AuditUserID="")||(aItem.Status="") "-1^文档ID、用户ID、审核者、状态不能为空"	
	s obj=##Class(EMR.OP.ExtAuditLog).%New()
	s obj.documentID=aItem.DocumentID
	s objOUser = ##class(User.SSUser).%OpenId(aItem.UserID,0)
	s:(objOUser'="") obj.Operator = objOUser
	s objAUser = ##class(User.SSUser).%OpenId(aItem.AuditUserID,0)
	s:(objAUser'="") obj.AuditUser = objAUser
	s obj.AuditDate=$P($h,",",1)
	s obj.AuditTime=$P($h,",",2)
	s obj.Action=aItem.Status
	s obj.OperateMachineIP = aItem.OperateMachineIP
	s obj.Status="1"
	s sc = obj.%Save()
	q:($$$ISERR(sc)) "-1^"_sc
	d argOutData.Write(1)
    q strRes
Error
    q "-1^"_$zerror
}

/// Desc:      获取审核打印日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_DIAGAUDITANDPRINTLOG","params":{"documentID":"1"},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetDiagAuditAndPrintLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatListData).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.Product = argInJson.product
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.DiagCertificateAudit).GetDiagAuditAndPrintLogJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取审核打印日志
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.DiagCertificateAudit).GeDateFormatJson(.obj)
ClassMethod GetDiagAuditAndPrintLogJson(aItem As EMR.OP.DTO.PatListData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s $zt = "Error"
	q:(aItem.DocumentID="") "-1^文档ID不能为空"	
	s json = ""
	s count = 0
	k ^TempAuditLogSort
	s arrJson = ##class(%DynamicArray).%New()
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.BL.EMRLogsView:GetDetialLog")
	d ds.Execute(aItem.DocumentID,aItem.LangID)
	While (ds.Next())
	{
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.OrderID = "#count#"
		s jsonItem.LoginUserName = ds.Data("LoginUser")
		s jsonItem.OperUserName = ds.Data("OperUser")
		s jsonItem.OperDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))
		s jsonItem.OperTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OperTime"))
		s jsonItem.MachineIP = ds.Data("MachineIP")
		s actionName=""
		if (ds.Data("Action") = "打印")
		{
			s actionName = ds.Data("Action")
			s:(actionName = "") actionName = "已打印"
		}else{
			s actionName = ds.Data("Action")
		}
		s jsonItem.Action = actionName
		s jsonItem.ProductSource = ds.Data("ProductSource")
		s key =  $ZDH(ds.Data("OperDate"),3)_$ZTH(ds.Data("OperTime"),1)
		s ^TempAuditLogSort(key) = jsonItem.%ToJSON()
	}
	s rowID = ""
	for {
		s rowID = $O(^EMR.OP.ExtAuditLogI("IdxdocId",aItem.DocumentID,rowID))
		q:(rowID="")
		s objAuditLog = ##Class(EMR.OP.ExtAuditLog).%OpenId(rowID)
		q:(objAuditLog="")
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.OrderID = "#count#"
		s jsonItem.LoginUserName = $case(objAuditLog.Operator,"":"",:objAuditLog.Operator.SSUSRName)
		s jsonItem.OperUserName = $case(objAuditLog.AuditUser,"":"",:objAuditLog.AuditUser.SSUSRName)
		s jsonItem.OperDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objAuditLog.AuditDate)
		s jsonItem.OperTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objAuditLog.AuditTime)
		s jsonItem.MachineIP = objAuditLog.OperateMachineIP
		if (objAuditLog.Action = "checked")
		{
			s actionName = "已审核"
		}
		else
		{
			s actionName = "已拒绝"
		}
		s jsonItem.Action = actionName
		s jsonItem.ProductSource = "门诊诊断证明书"
		s key =  objAuditLog.AuditDate _objAuditLog.AuditTime
		s ^TempAuditLogSort(key) = jsonItem.%ToJSON()
	}
	s key = "",json = ""
	for
	{
		s key =$o(^TempAuditLogSort(key))
		q:(key="")
		s count = count +1
		s jsonData = ^TempAuditLogSort(key)
		s jsonData = ##class(%DynamicAbstractObject).%FromJSON(jsonData)
		s jsonData.OrderID = count
		d arrJson.%Push(jsonData)
	}
	d arrJson.%ToJSON(argOutData)
    q strRes
Error
    q "-1^"_$zerror
}

}
