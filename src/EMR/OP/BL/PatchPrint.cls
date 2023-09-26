/// 名称:	EMR.OP.BL.PatchPrint
/// 描述:	门诊病历补打
/// 编写者：yejian
/// 编写日期: 2023-1-30
/// 产品组：电子病历产品组
Class EMR.OP.BL.PatchPrint Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取门急病历补打列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPPATCHPRINT","params":{"papmiNo":"","name":"","cardID":"","startDate":"2023-03-08","endDate":"2023-03-14","page":"1","rows":"10"},"product":"OP"}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetOPPatchPrint(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.PatchPrintData).%New()
	s objItem.PapmiNo = argInJson.params.papmiNo
	s objItem.Name = argInJson.params.name
	s objItem.CardID = argInJson.params.cardID
	s startDate = argInJson.params.startDate
	s:(startDate'="") objItem.StartDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",startDate)
	s endDate = argInJson.params.endDate
	s:(endDate'="") objItem.EndDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",endDate)
	s objItem.Product =argInJson.product
	s page = argInJson.params.page  
    s rows=argInJson.params.rows
    s:(page'="") objItem.StartPage = rows * (page -1) + 1
	s:(page'="") objItem.EndPage = objItem.StartPage + rows -1
    s strRes = ##Class(EMR.OP.BL.PatchPrint).GetOPPatchPrintJson(objItem,.argOutData)
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

/// Desc:       获取门急病历补打列表
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aItem 查询入参
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.PatchPrint).GeDateFormatJson(.obj)
ClassMethod GetOPPatchPrintJson(aItem As EMR.OP.DTO.PatchPrintData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",count = 0
	s resJson = ##class(%DynamicObject).%New()
	s jRows = ##class(%DynamicArray).%New()
    
    if (aItem.PapmiNo="")&&(aItem.CardID="")&&(aItem.Name="")
    {
	    s resJson.total = count
		s resJson.rows = jRows
    	d resJson.%ToJSON(argOutData)
    	q strRes
    }
	s StartDate = $Case(aItem.StartDate,"":$p($h,",",1),:aItem.StartDate)
	s EndDate = $Case(aItem.EndDate,"":$p($h,",",1),:aItem.EndDate)
	// 新建一个队列，为了按照就诊日期和就诊时间排序
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	
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
		s PapmiNo = ""
		for {
			s PapmiNo = $O(^PAPERi("PAPER_PatName",$zstrip($zcvt(aItem.Name,"U"),"*p"),PapmiNo),-1)
			q:(PapmiNo = "")
			d GetAllEpisodeID
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
        //过滤退号就诊
        s admStatus = $p($g(^PAADM(episodeid)),"^",20)
        continue:(admStatus = "C")
		// 按照时间倒叙
		s Time = "000000"_$P($G(^PAADM(episodeid)),"^",7)
		s Time = $E(Time,$L(Time)-5,$L(Time))
		s Date = $P($G(^PAADM(episodeid)),"^",6)
		s key = Date_Time
		continue:(Date < StartDate)
		continue:(Date > EndDate)
 		d episodeIDs.SetAt(episodeid, key)
 	}
 	q
	 	
GetSortEpisode	
	s key=""
	while (1){
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeid=episodeIDs.GetAt(key)
		
		d outputrow(episodeid)	
	}
	q
		
outputrow(episodeid)

	s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo,RegNo, pluginType,serial,isLeadframe) = ""
	s EpisodeID=episodeid
	s PapmiDR = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	//卡号
	s CardNo = aItem.CardID
	//病案号
	s RegNo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	//姓名
	s Name=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Name(PapmiDR)
	//性别
	s Gender=##Class(EMR.DOC.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
	s:(Gender'="") GenderDesc = $P(Gender,"^",3)
	//年龄
	s birthday = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	s admDate = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID, "")
	s admDate = $P(admDate, ",", 1)
	s Age = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(PapmiDR,EpisodeID,"","")
	//就诊日期,时间
	s AdmDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
	s AdmDate = $P(AdmDateTime,",",1)
	s AdmDate = $zd(AdmDate,3)
	s AdmTime = $P(AdmDateTime,",",2)
	s AdmTime = $ZT(AdmTime)
	//科室
	s tmpDisDept=##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
	s DeptDesc = $P(tmpDisDept,"^",3)
	//主管医师
	s AdmDocDesc = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
	s AdmDocDesc = $P(AdmDocDesc,"^",3)
	//门诊诊断
	s OPDiagStringH = ""
    s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s tmpOPDiagDict = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRDiagnoseList(mradm,2,"OP")
	i tmpOPDiagDict'="" {
		s OPDiagLength = $L(tmpOPDiagDict,$C(1))
		f i = 1:1:OPDiagLength
		{
			s:(OPDiagStringH'="") OPDiagStringH = OPDiagStringH_","
			s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
		}
	}
	s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(EpisodeID)
	s TILDocumentPrint = ##Class(EMR.DAO.DocumentPrintRecord).GetTureIndexLocation(EpisodeID)
	s flag = "N",ret = "",AStatus = "Save",AEpisodeID =""
	//循环获取保存状态下的实例ID
	s date = ""
	for
	{
		s date = $o(@TILDocumentData@("IdxEpisodeStatusHDT",EpisodeID," "_$zcvt(AStatus,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(@TILDocumentData@("IdxEpisodeStatusHDT",EpisodeID," "_$zcvt(AStatus,"U"),date,time))
			q:(time = "")
			s documentID = ""
			for
			{
				s documentID = $o(@TILDocumentData@("IdxEpisodeStatusHDT",EpisodeID," "_$zcvt(AStatus,"U"),date,time,documentID))
				q:(documentID = "")
				//实例信息
				s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
				q:(objDocument="")
                //打印次数
			 	s PrintNum=0
			 	s PrintNumID=""
			 	for {
				 	s PrintNumID=$o(@TILDocumentPrint@("IdxDocumentID",documentID,PrintNumID))
				 	q:(PrintNumID="")
				 	s PrintNum=PrintNum+1
			 	}
				 	
			 	//打印信息
			 	s (PrintRowId,PrintDate,PrintTime,PrintIp,PrintUserID,userName,pluginType,serial,isLeadframe) = ""
			 	
			 	s PrintRowId = $o(@TILDocumentPrint@("IdxDocumentIDType",documentID," PATCH",PrintRowId),-1)
			 	s:(PrintRowId="") PrintRowId = $o(@TILDocumentPrint@("IdxDocumentIDType",documentID," SELFPRINT",PrintRowId),-1)
		    	if (PrintRowId = "") {
			    	s PrintInfo = "未打印"
			    }else {
				 	s printobj = ##class(EMR.DAO.DocumentPrintRecord).doOpenByID(EpisodeID,PrintRowId)
				 	s PrintDate = $Case(printobj.PrintDate,"":"",:$zd(printobj.PrintDate,3))
				 	s PrintTime = $Case(printobj.PrintTime,"":"",:$zt(printobj.PrintTime))
				 	s PrintIp = printobj.OperateMachineIP
				 	s userName =$case(printobj.PrintUserID,"":"",:printobj.PrintUserID.SSUSRName)
					s PrintInfo = "已打印"_PrintNum_"次|打印日期:"_PrintDate_"|打印时间:"_PrintTime_"|IP:"_PrintIp_"|打印者:"_userName
			 	}
						 	
			 	
				s objTem="",objTemCat="",strTemCId="",isLeadframe="",PageNum = ""
				s objTem = objDocument.TemplateID
				s:(objTem'="") strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
				s:(strTemCId'="") objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)		
				s Title = objDocument.DOCName
				s ChartItemType = objDocument.TemplateID.ChartItemType
				s serial = objDocument.Serial
				s:(objTemCat'="")&&(objTemCat.Title'="") isLeadframe = objTemCat.Title.IsLeadframe
				//指定病历实例是否有对应患者签名后的PDF文档
				s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(documentID, EpisodeID)
				s DocumentType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
			 	s PageNum = ""
		 		s InsText = objDocument.DOCName
		 		s CreateUserName = $case(objDocument.CreateUser,"":"",:objDocument.CreateUser.SSUSRName)
			 						    	
	    		//是否允许多选打印标志 1允许 0不允许
		    	s IsAllowCheckPrint ="1"
				if (AEpisodeID = EpisodeID) {
					s jitem = ##class(%DynamicObject).%New()
					s jitem.PatientID=""
					s jitem.EpisodeID=""
					s jitem.mradm=""
					s jitem.RegNo=""
					s jitem.PAPMIName=""
					s jitem.PAPMISex=""
					s jitem.PAPMIAge=""
					s jitem.PAAdmDate=""
					s jitem.PAAdmTime=""
					s jitem.PAAdmLoc=""
					s jitem.PAAdmDoc=""
					s jitem.Diagnosis=""
					s jitem.DocumentID=documentID
					s jitem.PageNum=""
					s jitem.IsAllowCheckPrint=IsAllowCheckPrint
					s jitem.CreateUserName=CreateUserName
					s jitem.Text=InsText
					s jitem.PrintInfo=PrintInfo
					s jitem.PluginType = DocumentType
					s jitem.serial=serial
					s jitem.isLeadframe = isLeadframe
					s count = count + 1
					if ((aItem.StartPage <= count)&(count <= aItem.EndPage))
					{
				   		d jRows.%Push(jitem)
					}
				} else {
					s jitem = ##class(%DynamicObject).%New()
					s jitem.PatientID=PapmiDR
					s jitem.EpisodeID=EpisodeID
					s jitem.mradm=EpisodeID
					s jitem.RegNo=RegNo
					s jitem.PAPMIName=Name
					s jitem.PAPMISex=GenderDesc
					s jitem.PAPMIAge=Age
					s jitem.PAAdmDate=AdmDate
					s jitem.PAAdmTime=AdmTime
					s jitem.PAAdmLoc=DeptDesc
					s jitem.PAAdmDoc=AdmDocDesc
					s jitem.Diagnosis=OPDiagStringH
					s jitem.DocumentID=documentID
					s jitem.PageNum=""
					s jitem.IsAllowCheckPrint=IsAllowCheckPrint
					s jitem.CreateUserName=CreateUserName
					s jitem.Text=InsText
					s jitem.PrintInfo=PrintInfo
					s jitem.PluginType = DocumentType
					s jitem.serial=serial
					s jitem.isLeadframe = isLeadframe
            		s AEpisodeID = EpisodeID
            		s count = count + 1
					if ((aItem.StartPage <= count)&(count <= aItem.EndPage))
					{
				   		d jRows.%Push(jitem)
					}				
				}        
			}
		}			    
	}
	q
}

/// Desc:       获取浏览URL地址
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPPRINTBROWSEURL","product":"OP","params":{"documentID":"1"}}
/// 			documentID 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetOPPrintBrowseUrl(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID = argInJson.params.documentID
	s product =argInJson.params.product
    s strRes = ##Class(EMR.OP.BL.PatchPrint).GetOPPrintBrowseUrlJson(documentID,product,.argOutData)
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

/// Desc:       获取浏览URL地址
/// Creator:    yejian
/// CreateDate: 2022-12-7
/// Table:		
/// Input:   	aENDocumentID 加密的文档ID
/// 			aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.PatchPrint).GeDateFormatJson(.obj)
ClassMethod GetOPPrintBrowseUrlJson(aDocumentID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(""=aDocumentID) "-1^文档ID不能为空"
	//获取解密文档ID
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(""=objDoc) "-1^文档ID获取文档失败"
	//获取业务活动记录ID
	s recordID = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objDoc.TemplateCategoryID)
	s objRecord = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(recordID)
	q:(objRecord="") "-1^获取业务活动记录失败"
	s serial = objDoc.Serial
	s leadframe = $case(objRecord.Title.IsLeadframe,"1":objRecord.Title.IsLeadframe,:"0")
	//指定病历实例是否有对应患者签名后的PDF文档
	s EpisodeID = objDoc.EpisodeID.%Id()
	s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(aDocumentID, EpisodeID)
	s pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
	;emr.bs.op.browse.csp?documentID=&pluginType=&serial=&leadframe=&product=
	s refData = """emr.bs.op.browse.csp?documentID="_aDocumentID_"&serial="_serial_"&leadframe="_leadframe_"&pluginType="_pluginType_"&product=OP"""
	d argOutData.Write(refData)
	q strRes
}

}
