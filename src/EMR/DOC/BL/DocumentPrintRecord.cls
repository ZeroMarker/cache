/// 名称:	EMR.DOC.BL.DocumentPrintRecord
/// 描述:	文档打印业务逻辑类
/// 编写者：yejian
/// 编写日期: 2022-12-9
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DocumentPrintRecord Extends EMR.DOC.COM.ActionBase
{

/// Desc:       打印病历（自助、归档文档ID加密传输）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR.DB.DocumentPrintRecord 打印表,EMR_DB.EMRlogs日志表
/// Input:      argInJson  命令参数 {"action":"PRINT_ENCDOCUMENT","params":{"documentID":[35],"userID":"6","userLocID":"6","printType":"SELFPRINT","pmdType":"EMR","pmdCode":"","ipAddress":"127.0.0.1","creatorName":"自助打印名称","pluginType":"WORD"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PrintEncDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentPrintRecord).%New()
	s dtoItem.DocumentID = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(argInJson.params.documentID)
	s dtoItem.PrintUserID = argInJson.params.userID
	s dtoItem.OperateMachineIP =argInJson.params.ipAddress
	s dtoItem.PrintType = argInJson.params.printType
    s dtoItem.PrintCode = argInJson.params.pmdCode
    s dtoItem.PrintStatus ="Printed"
    s dtoItem.RecordType = $case(argInJson.params.pluginType,"":"WORD",:argInJson.params.pluginType)
    s dtoItem.PrintDate = $p($h,",",2)
    s dtoItem.PrintTime = $p($h,",",1)
    
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.Action = "print"
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = argInJson.params.userID
	s dtoItemLog.OperateUserID = argInJson.params.userID
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = argInJson.params.pmdType
    s strRes = ##Class(EMR.DOC.BL.DocumentPrintRecord).PrintDocumentJson(dtoItem,dtoItemLog,argInData,.argOutData)
	if (strRes '[ "-1")
	{ 
		d argOutData.Write(""""_strRes_"""")
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
		s strErr=dtoItem.ID_" "_strErr
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

/// Desc:       打印病历
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR.DB.DocumentPrintRecord 打印表,EMR_DB.EMRlogs日志表
/// Input:      argInJson  命令参数 {"action":"PRINT_DOCUMENT","params":{"documentID":[35],"userID":"6","userLocID":"6","printType":"SELFPRINT","pmdType":"EMR","pmdCode":"","ipAddress":"127.0.0.1","creatorName":"自助打印名称","pluginType":"WORD"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PrintDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentIDs = argInJson.params.documentID
	s dtoItem = ##class(EMR.DOC.DTO.DocumentPrintRecord).%New()
	s dtoItem.PrintUserID = argInJson.params.userID
	s dtoItem.OperateMachineIP =argInJson.params.ipAddress
	s dtoItem.PrintType = argInJson.params.printType
    s dtoItem.PrintCode = argInJson.params.pmdCode
    s dtoItem.PrintStatus ="Printed"
    s dtoItem.RecordType = $case(argInJson.params.pluginType,"":"WORD",:argInJson.params.pluginType)
    s dtoItem.PrintDate = $p($h,",",1)
    s dtoItem.PrintTime = $p($h,",",2)
    
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.Action = "print"
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = argInJson.params.userID
	s dtoItemLog.OperateUserID = argInJson.params.userID
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = argInJson.params.pmdType
    s strRes = ##Class(EMR.DOC.BL.DocumentPrintRecord).PrintDocumentJson(documentIDs,dtoItem,dtoItemLog,argInData,.argOutData)
	if (strRes '[ "-1")
	{ 
		d argOutData.Write(""""_strRes_"""")
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
		s strErr=dtoItem.ID_" "_strErr
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

/// Desc:       打印病历
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      arrIDs 文档ID集合
/// 			dtoInData 打印对象，
/// 			dtoLog 日志对象
/// 			argInData 病历流数据
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^错误提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentPrintRecord).SaveDocumentJson("","",.argOutData)
ClassMethod PrintDocumentJson(arrIDs As %DynamicAbstractObject, dtoInData As EMR.DOC.DTO.DocumentPrintRecord, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1",documentID=""
	q:((arrIDs="")||(arrIDs.%Size()=0)) "-1^实例ID不能为空"
	Tstart
	s items =arrIDs.%GetIterator()
	while items.%GetNext(.index , .jItem)
	{
		q:(jItem="")
		s dtoInData.DocumentID = jItem
		s documentID = dtoInData.DocumentID
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(documentID)
		if (objDocument = "")
		{
			s strRes= "-1^获取实例对象失败"
			q
		}
		s templateID = objDocument.TemplateID.%Id()
		s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(templateID)
		if (objTemplate = "")
		{
			s strRes= "-1^获取模板数据失败"
			q
		}
		continue:(objTemplate.TempPublishVersion="")

	    //保存数据
		s resPrint = ##Class(EMR.DOC.BL.DocumentPrintRecord).CreatePrintRecord(dtoInData)
		if (resPrint [ "-1^")
		{
			s strRes= resPrint
		}
		//添加日志
		s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
	    if ($p(logStatus,"^",1) = "-1")
		{
			s strRes= "-1^添加日志失败"
		}
	}
	if (strRes["-1^")
	{
		Trollback
		q strRes
	}
	TCOMMIT
	q strRes
OPRecordError
	Trollback
    q "-1^"_documentID_"^"_$zerror
}

/// Desc:       创建打印记录
/// Creator:    yejian
/// CreateDate: 2022-12-9
/// Input:      dtoInData 打印对象，
/// Return：    strRes 0:失败  成功:rowID
/// OutPut:     成功 返回记录ID，
/// 			失败 -1^错误提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// Debug：     w ##class(EMR.DOC.BL.DocumentPrintRecord).CreatePrintRecord("")
ClassMethod CreatePrintRecord(aInData As EMR.DOC.DTO.DocumentPrintRecord) As %String
{
	s strRes = 0
	q:(aInData.DocumentID = "") "-1^文档ID不能为空"
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aInData.DocumentID)
	q:(objDoc = "") "-1^根据文档ID获取文档实例失败"
	s EpisodeID = objDoc.EpisodeID.%Id()
	s objPrint = ##class(EMR.DAO.DocumentPrintRecord).doCreateInstance(EpisodeID)
	s objPrint.PrintDate = aInData.PrintDate
	s objPrint.PrintTime = aInData.PrintTime
	s objOUser = ##class(User.SSUser).%OpenId(aInData.PrintUserID,0)
	s:(objOUser'="") objPrint.PrintUserID = objOUser
	s objPrint.PrintType = aInData.PrintType
	s objPrint.PrintStatus = aInData.PrintStatus
	s objPrint.PrintCode = aInData.PrintCode
	s objPrint.OperateMachineIP = aInData.OperateMachineIP
	s objPrint.CreateName = aInData.CreateName
	s objPrint.DocumentID = objDoc
	s objPrint.ListNo = objDoc.ListNo
	s objPrint.HappenDate = objDoc.HappenDate
	s objPrint.HappenTime = objDoc.HappenTime
	s objPrint.PrintTemplateID =objDoc.TemplateID
    s objPrint.PrintTemplateVersion = objDoc.TemplateVersion
	s objPrint.RecordType = aInData.RecordType
	s objPrint.EpisodeID = objDoc.EpisodeID
	s objPrint.DOCCategoryCode = objDoc.DOCCategoryCode
	s objPrint.DOCCode = objDoc.DOCCode
	s sc = objPrint.%Save()
	q:($$$ISERR(sc)) "-1^保存打印记录信息失败"
	s strRes = objPrint.%Id()
	q strRes
}

/// Desc:       获取最新的打印记录
/// Creator:    yejian
/// CreateDate: 2023-4-27
/// Table:		EMR.DAO.DocumentPrintRecord 打印记录
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_LASTPRINTDATA","params":{"documentID":"1","langID":"20"}}
/// 			userLocID 科室ID，userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLastPrintData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DocumentPrintRecord).%New()
	s objItem.Product = argInJson.product
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.LangID = $case(argInJson.params.langID,"":20,:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintDataJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取最新的打印记录
/// Creator:    yejian
/// CreateDate: 2023-4-27
/// Input:      aItem 打印对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintDataJson("YS01")
ClassMethod GetLastPrintDataJson(aItem As EMR.DOC.DTO.DocumentPrintRecord, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.DocumentID="") "-1^文档ID不能为空"
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc = "") "-1^根据文档ID获取文档实例失败"
	s aItem.DOCCategoryCode = objDoc.DOCCategoryCode
	s aItem.EpisodeID = objDoc.EpisodeID.%Id()
	//获取最新打印记录ID
	s lastPrintID = ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintID(aItem.DocumentID)
	q:(lastPrintID["-1^") lastPrintID
	if (lastPrintID="")
	{ 
		d argOutData.Write("""")
		q strRes
	}
	s objPrint = ##class(EMR.DAO.DocumentPrintRecord).doOpenByID(aItem.EpisodeID,lastPrintID)
	q:(objPrint="") "-1^根据打印ID获取打印数据失败"
	s jsonRes  = ##class(%DynamicObject).%New()
	if (objPrint.ModifyDocumentIDs'="")
	{
		
		s count = $l(objPrint.ModifyDocumentIDs,"^")
		s modifyJson = ##class(%DynamicArray).%New()
		for i=1:1:count
		{
			s curId = $p(objPrint.ModifyDocumentIDs,"^",i)
			continue:(curId="")
			s itemDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(curId)
			continue:(itemDoc="")
			s modifyItem= ##class(%DynamicObject).%New()
			s modifyItem.documentID = curId
			s modifyItem.docName = itemDoc.DOCName
			s modifyItem.happenDate = $case(itemDoc.HappenDate,"":"",:$zd(itemDoc.HappenDate,3)_" "_$zt(itemDoc.HappenTime,1))
			d modifyJson.%Push(modifyItem)
		}
		s:(modifyJson.%Size()>0) jsonRes.modifyDocument = modifyJson
	} 
    else
    {
	    s jsonRes.documentID = objPrint.DocumentID.%Id()
    }
	d jsonRes.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取最新的打印记录ID
/// Creator:    yejian
/// CreateDate: 2023-4-27
/// Input:      aDocumentID 文档ID
/// Output:     成功：空值或最新打印记录ID， 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintID("1")
ClassMethod GetLastPrintID(aDocumentID As %String) As %String
{
	s strRes = ""
	q:(aDocumentID="") "-1^文档ID不能为空"
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc = "") "-1^根据文档ID获取文档实例失败"
	s strDOCCategoryCode = objDoc.DOCCategoryCode
	s strEpisodeID = objDoc.EpisodeID.%Id()
	s TILDocumentPrintRecord = ##class(EMR.DAO.DocumentPrintRecord).GetTureIndexLocation(strEpisodeID)
	//取最新的打印日期
	s printDate = $o(@TILDocumentPrintRecord@("IdxDOCCodePrintDT",strEpisodeID," "_$zcvt(strDOCCategoryCode,"U"),""),-1)
	q:(printDate="") ""

	//取最新的打印时间
	s printTime = $o(@TILDocumentPrintRecord@("IdxDOCCodePrintDT",strEpisodeID," "_$zcvt(strDOCCategoryCode,"U"),printDate,""),-1)
	q:(printTime="") ""
	
	//取最新的打印ID
	s strRes = $o(@TILDocumentPrintRecord@("IdxDOCCodePrintDT",strEpisodeID," "_$zcvt(strDOCCategoryCode,"U"),printDate,printTime,""),-1)
	q strRes
}

/// Desc:       保存更新最新打印记录修改文档ID
/// Creator:    yejian
/// CreateDate: 2023-4-27
/// Input:      aDocumentID 文档ID
/// Output:     成功：空值或最新打印记录ID， 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintID("1")
ClassMethod SaveLastModifyDocument(aDocumentID As %String, aEpisodeID As %String) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
	q:(aDocumentID="") "-1^文档ID不能为空"
	//获取最新打印记录ID
	s lastPrintID = ##Class(EMR.DOC.BL.DocumentPrintRecord).GetLastPrintID(aDocumentID)
	q:(lastPrintID["-1^") lastPrintID
	q:(lastPrintID="") strRes
	s objPrint = ##class(EMR.DAO.DocumentPrintRecord).doOpenByID(aEpisodeID,lastPrintID)
	q:(objPrint="") "-1^根据打印ID获取打印数据失败"
	s modifyIDs = "^"_objPrint.ModifyDocumentIDs_"^"
	s curDocID ="^"_aDocumentID_"^"
	q:(modifyIDs [ curDocID) strRes
	s objPrint.ModifyDocumentIDs =$CASE(objPrint.ModifyDocumentIDs,"":aDocumentID,:objPrint.ModifyDocumentIDs_"^"_aDocumentID)
	s sc = objPrint.%Save()
	s:($$$ISERR(sc)) strRes = "-1^更新最新打印记录失败"
	q strRes
}

/// Desc:      根据分类编码获取打印次数
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aDocCode 业务活动记录编码
/// 			EpisodeId 就诊号
/// OutPut:     返回打印数次，否则 0
/// Debug:      w ##class(EMR.DOC.BL.DocumentPrintRecord).GetPrintCount("68","603")
ClassMethod GetPrintCount(ADocCategoryCode As %String, AEpisodeID As %String) As %String
{
	s strRes = 0
	q:(AEpisodeID="")||(ADocCategoryCode="") strRes
	s ADocCategoryCode = $zcvt(ADocCategoryCode,"U")
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	s TILDocumentPrintRecord = ##class(EMR.DAO.DocumentPrintRecord).GetTureIndexLocation(AEpisodeID)
	s docID = ""
	for
	{
		s docID = $o(@TILInstaneData@("IdxEpisodeDOCCCodeStatus",AEpisodeID," "_ADocCategoryCode," SAVE",docID))
	    q:(docID = "") 
		//取最新的打印日期
		s printID = $o(@TILDocumentPrintRecord@("IdxDocumentID",docID,""))
    	s:(printID'="") strRes=strRes+1
	}
	q strRes
}

}
