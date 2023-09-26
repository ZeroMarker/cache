/// 名称:	EMR.IP.BL.BLDocumentData
/// 描述:	住院病历 文档实例业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-21
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLDocumentData Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取实例信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetInstanceJsonByCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCategoryCode,episodeID,resultType,seq,docCode)=""
	s docCategoryCode=argInJson.params.docCategoryCode
	s episodeID=argInJson.params.episodeID
	s resultType=argInJson.params.resultType
	s seq=argInJson.params.seq
	s docCode=argInJson.params.docCode
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
	
    s strRes = ##Class(EMR.IP.BL.BLDocumentData).GetDocumentJsonByCategory(docCategoryCode,episodeID,resultType,seq,docCode,langID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","关键入参缺失",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","备注信息添加后实例保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       保存实例备注信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SetInstanceMemo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID="", memoText=""
	s documentID=argInJson.params.instanceID
	s memoText=argInJson.params.memoText
	
    s strRes = ##Class(EMR.IP.BL.BLDocumentData).SetInstanceMemoJson(documentID,memoText,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","关键入参缺失",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","备注信息添加后实例保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// /////////////////////////////////
/// JSON 组合代码
/// ////////////////////////////////
/// Desc:	
/// Input:	
/// Return:	设置状态
/// Debug:	w ##Class(EMR.IP.BL.BLPatDisease).GetPatDiseaseJson(285)
ClassMethod GetDocumentJsonByCategory(argDocCategoryCode As %String = "", argEpisodeID As %String = "", argResultType As %String = "", argSequence As %String = "", argDocCode As %String = "", argLangID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"

	s jsonArr = []
	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(argEpisodeID)
	
	s DOCCategoryCode = $zcvt(argDocCategoryCode,"U")
	s hasListNo = $O(@TILDocument@("IdxMain",argEpisodeID," "_DOCCategoryCode, ""))
	
	if (""=hasListNo) 
	{
		d jsonArr.%ToJSON(argOutData)
		q strRes
	}
	
	s listNo = ""
	for
	{
		if (argSequence="DESC")
		{
			s listNo = $O(@TILDocument@("IdxMain",argEpisodeID, " "_DOCCategoryCode, listNo),-1)
		}
		else
		{
			s listNo = $O(@TILDocument@("IdxMain",argEpisodeID, " "_DOCCategoryCode, listNo))
		}
		
		q:(listNo="")
		s docID = $O(@TILDocument@("IdxMain",argEpisodeID, " "_DOCCategoryCode, listNo,""))
		
		
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
		continue:(objDocument="")
		//删除状态排除
		continue:("Save" '= objDocument.Status)
		s objTemplate = objDocument.TemplateID
		continue:(objTemplate="")
		continue:((argDocCode'="")&&(objDocument.DOCCode'=argDocCode))
		
		//根据模板目录获取该模板的业务活动记录
		s strTemCId = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objDocument.TemplateCategoryID)
		s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
		
		
		s DocCategoryID = objTemCat.ParentID
		s objDocCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(DocCategoryID)
		
		//指定病历实例是否有对应患者签名后的PDF文档
		s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docID, argEpisodeID)
		
		s jsonSub = {}
		s jsonSub.documentID= docID
		s jsonSub.docName= objDocument.DOCName
		s jsonSub.chartItemType= objDocument.TemplateID.ChartItemType
		s jsonSub.pluginType= $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
		s jsonSub.docCategoryCode= objDocument.DOCCategoryCode
		s jsonSub.docCategoryName= objDocCategory.Name
		s jsonSub.docCode= objDocument.DOCCode
		s jsonSub.templateID= objDocument.TemplateID.%Id()
		
		s jsonSub.isLeadframe= objTemCat.Title.IsLeadframe
		s jsonSub.isMutex= objTemCat.Title.IsMutex
		s jsonSub.serial= objDocument.Serial
		s jsonSub.happendate= ##class(EMR.DOC.TOOL.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objDocument.HappenDate)
		s jsonSub.happentime=##class(EMR.DOC.TOOL.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objDocument.HappenTime)
		s jsonSub.creator= objDocument.CreateUser.SSUSRName
		s jsonSub.operator= objDocument.ModifyUser.SSUSRName
		s jsonSub.statusCode= objDocument.Status
		s jsonSub.status= $case(objDocument.Status,"Save":"保存","UnSave":"未保存","Delete":"删除",:"已保存")
		s jsonSub.printstatus=""
		s jsonSub.printDesc=""
		s jsonSub.isHasPrinted=""
		s jsonSub.summary=objDocument.Memo
		
		s jsonSub.janeSpell= ##class(web.DHCINSUPort).GetCNCODE(objDocument.DOCName,4,"")
		s jsonSub.fullFight= ##class(web.DHCINSUPort).GetCNCODE(objDocument.DOCName,3,"")
		s jsonSub.startPage=""
		s jsonSub.endPage=""
		s jsonSub.hasSign=""
		s jsonSub.createdate=##class(EMR.DOC.TOOL.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objDocument.CreateDate)
		s jsonSub.createtime=##class(EMR.DOC.TOOL.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objDocument.CreateTime)
		s revokeSign = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("IsRevokeSign",..#ProductCode,"Y")
		s hasSign = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(argEpisodeID, docID)
		s doctorwait = "" //##Class(EMR.DOC.BL.TemplateSign).GetSignWaitStatus(objDocument.TemplateID.%Id(),objDocument.TemplateVersion,"MEDICAL",hasSign,argEpisodeID, argDocCode, objDocument.ListNo,revokeSign)
		s jsonSub.doctorwait= doctorwait
		s jsonSub.doctorIsSignCA=""
		s jsonSub.episodeID= argEpisodeID
		s jsonSub.patSignStatus=""
		s jsonSub.emrSignID=""
		s jsonSub.caSignID=""
		s jsonSub.operInfo=""
		s jsonSub.templateCategoryID=objDocument.TemplateCategoryID.%Id()
		
		d jsonArr.%Push(jsonSub)
		
	}
	
	d jsonArr.%ToJSON(argOutData)
	q 1
	
Error
	s $zt =""
    q "-1^"_$zerror
}

/// Desc:	获取病历实例备注信息
/// Input:	
/// Return:	设置状态
/// Debug:	w ##Class(EMR.IP.BL.BLPatDisease).GetPatDiseaseJson(285)
ClassMethod SetInstanceMemoJson(argDocumentID As %String = "", argMemoText As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-100"
	
	q:(argDocumentID="") strRes

	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(argDocumentID)
	q:(objDocument="") strRes
	
	s objDocument.Memo=argMemoText
	s sc = objDocument.%Save()
	
	if ('$$$ISOK(sc))
	{
		d argOutData.Write("0")
		s strRes = "-200"
		q strRes
	}
	
	d argOutData.Write("1")
	q 1
Error
	s $zt =""
    q "-1^"_$zerror
}

/// /////////////////////////////////
/// 服务代码
/// ////////////////////////////////
/// w ##class(EMR.IP.BL.BLDocumentData).DebuggerData()
ClassMethod DebuggerData()
{
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(277)
	s strTemCId = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objDocument.TemplateCategoryID)
	s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
	s DocCategoryID = objTemCat.ParentID
	s objDocCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(DocCategoryID)
	w !,objDocCategory.Code
	w !,objDocCategory.Name
	w !,objDocCategory.StructType.Name
	
	w !,objDocCategory.StructType.Code
	
	w !,objDocCategory.StructType.%Id()
}

/// Desc:       获取文档创建时间
/// Creator:    lifengbo
/// CreateDate: 2023-04-04
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetInsCreateDateTime(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID=""
	s documentID=argInJson.params.instanceID
	
    s strRes = ##Class(EMR.IP.BL.BLDocumentData).GetInsCreateDateTimeJson(documentID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes [ "-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$p(strRes,"^",2),2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","GetInsCreateDateTime,未识别返回值",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取病历创建时间
/// Input:	
/// Return:	设置状态
/// Debug:	s documentID=270
/// 			s argOutData=##class(%GlobalBinaryStream).%New()
/// 			d ##Class(EMR.IP.BL.BLDocumentData).GetInsCreateDateTimeJson(documentID,.argOutData)
ClassMethod GetInsCreateDateTimeJson(argDocumentID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-1^"
	
	q:(argDocumentID="") strRes_"argDocumentID,入参未传入。"

	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(argDocumentID)
	q:(objDocument="") strRes_"文档"_argDocumentID_"未获取失败"
	
	s createDate= objDocument.CreateDate
	s createTime= objDocument.CreateTime
	s createDateTime= $zdt(createDate_","_createTime,3,1)
	d argOutData.Write(createDateTime)
	
	q 1
Error
	s $zt =""
    q "-1^"_$zerror
}

/// Desc:       获取category下连续显示的已保存的创建时间最晚的实例ID
/// Creator:    lifengbo
/// CreateDate: 2023-04-19
/// Table:		
/// Input:      argArray  命令参数 {"action":"GET_SERIALINSTIDBYCATEGORY","params":{},"product":"IP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSerialInstIDByCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCategoryCode,episodeID,resultType,seq,docCode)=""
	s docCategoryCode=argInJson.params.docCategoryCode
	s episodeID=argInJson.params.episodeID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
	
    s strRes = ##Class(EMR.IP.BL.BLDocumentData).GetSerialInstIDByCategoryJson(docCategoryCode,episodeID,langID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes ["-1^")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","代码异常:"_$p(strRes,"^",2),2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","GetSerialInstIDByCategory,存在未识别的异常返回",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常:"_$ze,2)
}

/// Desc:	获取category下连续显示的已保存的创建时间最晚的实例ID
/// Creator:    lifengbo
/// CreateDate: 2023-04-19
/// Input:	
/// Return:	设置状态
/// Debug:	s argOutData=##class(%GlobalBinaryStream).%New()
/// 		d ##Class(EMR.IP.BL.BLDocumentData).GetSerialInstIDByCategoryJson("EMR1000","1224","20",.argOutData)
ClassMethod GetSerialInstIDByCategoryJson(argDocCategoryCode As %String = "", argEpisodeID As %String = "", argLangID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "ERROR"
	s strRes = "1"
	
	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(argEpisodeID)
	
	s DOCCategoryCode = $zcvt(argDocCategoryCode,"U")
	

	s hasListNo = $O(@TILDocument@("IdxMain",argEpisodeID," "_DOCCategoryCode, ""))
	
	if (""=hasListNo) 
	{
		q strRes
	}
	
	
	s targetDocumentID = ""
	s lastCreateDate = ""
	s lastCreateTime = ""
	
	s listNo = ""
	for
	{

		s listNo = $O(@TILDocument@("IdxMain",argEpisodeID, " "_DOCCategoryCode, listNo),-1)
		q:(listNo="")
		
		s docID = $O(@TILDocument@("IdxMain",argEpisodeID, " "_DOCCategoryCode, listNo,""))
		
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
		continue:(objDocument="")
		//删除状态排除
		continue:("Save" '= objDocument.Status)
		continue:(0 = objDocument.Serial)
		
		s createDate = objDocument.CreateDate
		s createTime = objDocument.CreateTime
		
		if ((lastCreateDate= "")&&(lastCreateTime= ""))
		{
			s lastCreateDate= createDate
			s lastCreateTime= createTime
			s targetDocumentID = docID
		}
		else
		{
			s second = ##class(EMR.DOC.TOOL.DateTimeFormat).GetDateTimeDiff(lastCreateDate, lastCreateTime, createDate, createTime)
			
			if (+second>0)
			{
				s lastCreateDate = createDate
				s lastCreateTime = createTime
				s targetDocumentID = docID
			}
		}
		
	}
	if (targetDocumentID="")
	{
		q 1
	}
	
	s objTargetDocument = ##class(EMR.DAO.DocumentData).doOpenByID(targetDocumentID)
	
	//指定病历实例是否有对应患者签名后的PDF文档
	s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(targetDocumentID, argEpisodeID)
	s pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
	
	s json={}
	s json.documentID = targetDocumentID
	s json.pluginType =	pluginType
	s json.serial = objTargetDocument.Serial
	s json.isLeadframe = objTargetDocument.TemplateID.TemplateCategory.Title.IsLeadframe
	
	d json.%ToJSON(argOutData)
	
	q 1
	
ERROR
	s $zt =""
    q "-1^"_$zerror
}

}
