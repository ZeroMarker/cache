/// 名称:	EMR.DOC.BL.PDFAuditSignLog
/// 描述:	PDF签名业务
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PDFAuditSignLog Extends EMR.DOC.COM.ActionBase
{

/// Desc:      保存医护签数据
/// Creator:    yejian
/// CreateDate: 2022-9-22
/// Table:		
/// Input: 		aItem pdf签名对象
/// 			argInData pdf签名原文
/// Output:     成功：1^ID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.PDFAuditSignLog).SavePDFSignData()
ClassMethod SavePDFSignData(aItem As EMR.DOC.DTO.PDFSignData, argInData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.EpisodeID="") "-1^就诊号不能为空！"
	q:(aItem.DocumentID="") "-1^文档ID不能为没空"
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s objUser = ##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^根据用户ID获取用户信息失败"
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doCreateInstance(aItem.EpisodeID)
	s obj.Action = aItem.Action
	s obj.StoreType =aItem.StoreType
	s obj.SignStatus = aItem.SignStatus
	s obj.IsValid = aItem.IsValid
	s obj.DocumentID = objDoc
	s obj.ListNo = aItem.ListNo
	s obj.EpisodeID = objDoc.EpisodeID
	s obj.DOCCategoryCode = aItem.DOCCategoryCode
	s obj.DOCCode = aItem.DOCCode
	s obj.Code = ""
	s obj.KeyWord = aItem.KeyWord
	s obj.PatPushSignID = aItem.PatPushSignID
	s obj.UniqueDocID = aItem.UniqueDocID
	s obj.CABusinessGUID = aItem.CABusinessGUID
	s obj.UsrID = objUser
	s obj.CreateDate = aItem.CreateDate
	s obj.CreateTime = aItem.CreateTime
	d argInData.Rewind()
	d obj.OriginalPDFBase64.Clear()
	d obj.OriginalPDFBase64.CopyFrom(argInData)
	s sc =  obj.%Save()
	if ($$$ISERR(sc))
	{
		q "-1^DocumentID:"_aItem.DocumentID_",保存PDF签名失败,"_sc
	}
	k objDoc
	q "1^"_obj.%Id()
}

/// Desc:      加载病历的PDF文档数据
/// Creator:    yejian
/// CreateDate: 2023-1-5
/// Table:		
/// Input: 		dtoInData 文档对象		
/// Output:     argOutData pdf输出数据
/// Return:		加载病历PDF文档数据的结果，成功 1，失败 -1^失败信息
/// debug:  	w ##Class(EMR.DOC.BL.PDFAuditSignLog).LoadDocument()
ClassMethod LoadDocument(dtoInData As EMR.DOC.DTO.DocumentData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s documentID = dtoInData.DocumentIds.%Get(0)
	if (documentID = "")
	{
		q "-1^文档ID不能为空"
	}
	if (dtoInData.IsEncry="Y")
	{
		s documentID = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(documentID)
	}
	s objFData = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
	;s objFData = ##class(EMR.DB.DocumentData).%OpenId(documentID)
	q:(objFData="") "-1^文档数据对象为空"	
	s episodeID =objFData.EpisodeID.%Id()
	q:(episodeID="") "-1^文档数据的EpisodeID为空"

	s objStream = ##Class(%GlobalBinaryStream).%New()
	//数据解压缩
	s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objFData.DocumentStream.DocumentData)
	d temStream.Rewind()
	while (temStream.AtEnd = 0)
	{
		s tmpOut = temStream.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d objStream.Write(tmpUtf8)
  	} 
	s jsonDocData = ##class(%DynamicAbstractObject).%FromJSON(objStream)
	
	s TILPDFAuditSignLog = ##class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(episodeID)
	
	s id = ""
	s id = $O(@TILPDFAuditSignLog@("IdxInstance",episodeID, documentID, 1, id),-1)
	q:(id = "") "-1^PDF数据记录为空"
	
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,id)
	q:(obj="") "-1^PDF数据记录为空"
	
	q:(obj.IsValid '= "1") "-1^PDF数据签名已经失效"

	q:(obj.SignStatus = "TOSIGN") "-1^PDF数据待签名"

	q:(obj.PDFBase64.IsNull()) "-1^PDF数据流为空"
	
	s temStream = ##Class(%GlobalBinaryStream).%New()
	s retJson = ##class(%DynamicObject).%New()
	s retJson.id = documentID
	s retJson.paper = jsonDocData.paper
	d retJson.%ToJSON(temStream)
	s size = temStream.Size
	s retString = temStream.Read(size-1)
	d argOutData.Write(retString)
	d argOutData.Write(",""value"":""")

	//获取Base64格式的pdf数据流，base64数据Utf8编码与gb18030一致，不需转码
	s errMsg = ""
	while (obj.PDFBase64.AtEnd = 0) 
	{
		 d argOutData.Write(obj.PDFBase64.Read(24000)) 
	}
	d argOutData.Write("""}")
	q strRes
}

/// Desc：	指定病历实例是否有对应患者签名后的PDF文档
/// Creator:    yejian
/// CreateDate: 2022-9-22
/// Table:		
/// Input:	aDocumentID : 病历实例数据ID
/// 		aEpisodeID ：就诊rowid，可以为空，为空时，根据InstanceDataID查询相应的EpisodeID
/// Return:	指定InstanceData是否有签名PDF数据，值域：
/// 			空 ：没有pdf数据, TOSIGN 待签，SIGNED 已签名
/// 			TOSIGN ：pdf数据待签名
/// 			SIGNED : pdf数据已签名
/// Debug:	 w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus("35","")
ClassMethod GetPDFStatus(aDocumentID As %String, aEpisodeID As %String = "") As %String
{
	q:(aDocumentID = "") "-1^文档ID不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s:(aEpisodeID = "") aEpisodeID = objDoc.EpisodeID.%Id()
	
	s TILPDFAuditSignLog = ##class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(aEpisodeID)
	
	s id = ""
	s id = $O(@TILPDFAuditSignLog@("IdxInstance",aEpisodeID, aDocumentID, 1, id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus = "TOSIGN") "TOSIGN"
	q:(obj.SignStatus = "SIGNED") "SIGNED"
	
	q "SIGNED"
}

/// Desc:       获取推送签名的ID
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"6"},"product":"OP","action":"GET_PATPUSHSIGNID"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPatPushSignID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s documentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPatPushSignIDJson(strProduct,documentID,.argOutData)
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

/// Desc:       获取推送签名的ID
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aProduct :产品标识
/// 			aDocumentID : 病历实例数据ID
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFBase64Json("","")
ClassMethod GetPatPushSignIDJson(aProduct As %String, aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	q:(aDocumentID="") "-1^文档ID不能为空"

	s strRes = "1"
 	s signID = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetToSignPatPushSignID(aDocumentID)
    d:(signID '= "") argOutData.Write(signID)
    
   	q strRes
	
Error 
	q "-1^"_$zerror
}

/// Desc：	获取PDF签名推送签名ID
/// Creator:    yejian
/// CreateDate: 2022-9-22
/// Table:		
/// Input:	 aDocumentID : 病历实例数据ID
/// 		 aEpisodeID ：就诊rowid，可以为空，为空时，根据InstanceDataID查询相应的EpisodeID
/// Return:	 失败：-1^提示信息，成功：空 没有推送签名ID,id CA.DigitalSignPatPush表ID
/// Debug:	 w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetToSignPatPushSignID("35","")
ClassMethod GetToSignPatPushSignID(aDocumentID As %String, aEpisodeID As %String = "") As %String
{
	q:(aDocumentID = "") "-1^文档ID不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s:(aEpisodeID = "") aEpisodeID = objDoc.EpisodeID.%Id()
	
	s TILPDFAuditSignLog = ##class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(aEpisodeID)
	
	s id = ""
	s id = $O(@TILPDFAuditSignLog@("IdxInstance",aEpisodeID, aDocumentID, 1, id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus '= "TOSIGN") ""
	q obj.PatPushSignID
}

/// Desc:       文档是否可以做患者端PDF签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"6"},"product":"OP","action":"CAN_DOPDF_SIGN"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CanDoPDFSign(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s documentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).CanDoPDFSignJson(strProduct,documentID,.argOutData)
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

/// Desc:       文档是否可以做患者端PDF签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:	aProduct :产品标识
/// 		aDocumentID : 病历实例数据ID
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetHandSignTypeJson("","")
ClassMethod CanDoPDFSignJson(aProduct As %String, aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	s obj = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	;s obj = ##Class(EMR.DB.DocumentData).%OpenId(aDocumentID)
	if (obj = "")
	{
		s resData = "0^待签实例数据不存在["_aDocumentID_"]"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	s episodeID = obj.EpisodeID.%Id()
	s templateID = obj.TemplateID.%Id()
	s docCode = obj.DOCCode 
	if (obj.Serial = "1")
	{
		s resData = "0^不能对连续显示的病历文档做患者签名"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	s sc = ##class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(aDocumentID, episodeID)
	if (sc = "SIGNED")
	{
		s resData = "0^该文档已签名,请点击[患者重签]后,再次发起签名操作!"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	s tosignid = ##class(EMR.DOC.BL.PDFAuditSignLog).GetToSignPatPushSignID(aDocumentID, episodeID)
	if (tosignid '= "")
	{
		s resData ="0^已推送患者待签文档, 请完成患者签署, 或点击[患者重签]后, 再次发起签名操作!"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	s docWaitSign = ##class(EMR.DOC.BL.PDFAuditSignLog).IsInstWaitDocSign(aDocumentID, episodeID, docCode, obj.ListNo, templateID, obj.TemplateVersion,aProduct)
	if (docWaitSign = "1")
	{
		s resData ="0^请先完成医生签名"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	d argOutData.Write(""""_strRes_"""")
   	q strRes
	
Error 
	q "-1^"_$zerror
}

/// Desc:       文档是否已经完成医师签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:		aDocumentID 	文档ID
///  	     	aEpisodeID 		就诊号
///           	aDocCode			业务活动记录编码
///           	AListNo			文档顺序号
///  	     	ATemplateId 		模板ID
///           	ATemplateVersion 	模板版本号
/// 			aProduct :产品标识
/// Output:     成功：1 已完成签名，0 未完成
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetHandSignTypeJson("","")
ClassMethod IsInstWaitDocSign(aDocumentID As %String, aEpisodeID As %String, aDocCode As %String, aListNo As %String, aTemplateID As %String, aTemplateVersion As %String, aProduct As %String) As %String
{
	s doctorwait = 0
	q:(aDocumentID = "")||(aEpisodeID = "")||(aDocCode = "")||(aListNo = "")||(aTemplateID = "")||(aTemplateVersion = "")||(aProduct = "") "-1^参数不能为空"
	
	s log = ##class(EMR.DOC.BL.DocLog).GetLogStatus(aEpisodeID,aDocumentID)
	s statusCode=log.status
	s status=log.statusDesc
	s revokeSign = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("IsRevokeSign",aProduct,"Y")
	s hasSign = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(aEpisodeID, aDocumentID)
	s:((statusCode="finished")||(statusCode="checkedRevision")) hasSign = "0"
	
	s doctorwait = ##Class(EMR.DOC.BL.TemplateSign).GetSignWaitStatus(aTemplateID,aTemplateVersion,"MEDICAL",hasSign,aEpisodeID, aDocCode, aListNo,revokeSign)
	q doctorwait
}

/// Desc:       获取患者的PDF数据
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"34","episodeID":"6"},"product":"OP","action":"GET_PDF_BASE64"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPDFBase64(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s episodeID = argInJson.params.episodeID
	s documentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFBase64Json(strProduct,episodeID,documentID,.argOutData)
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

/// Desc:       获取患者的PDF数据
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aProduct :产品标识
/// 			aDocumentID : 病历实例数据ID
/// 			aEpisodeID : 就诊号
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFBase64Json("","")
ClassMethod GetPDFBase64Json(aProduct As %String, aDocumentID As %String, aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	q:(aDocumentID="") "-1^文档ID不能为空"
	q:(aEpisodeID="") "-1^就诊号不能为空"

	s strRes = "1"
 	s pdfInfId = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetLastValidPDFInfo(aEpisodeID, aDocumentID)
    if (pdfInfId '= "")
    {
	    s objPDFSignLog = ##Class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,pdfInfId)
	    s pdfB64= objPDFSignLog.PDFBase64
	    d argOutData.CopyFrom(pdfB64)
    }
   	q strRes
	
Error 
	q "-1^"_$zerror
}

/// Desc:		获取最后一次有效患者签名记录id
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aProduct :产品标识
/// 			aDocumentID : 病历实例数据ID
/// 			aEpisodeID : 就诊号
/// Output:    
/// Return:		成功：患者签名记录id, 即 EMR.DB.PDFAuditSignLog.ID, 空 无
///             失败：-1^错误信息
/// Debug:	w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetLastValidPDFInfo()
ClassMethod GetLastValidPDFInfo(aEpisodeID As %String, aDocumentID As %String) As %String
{
	q:(aDocumentID="") "-1^文档ID不能为空"
	q:(aEpisodeID="") "-1^就诊号不能为空"
	s id = ""
	s TILPDFSign = ##Class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(aEpisodeID)
	s id = $O(@TILPDFSign@("IdxInstance",aEpisodeID, aDocumentID, 1, id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus '= "SIGNED") ""
	q id
}

/// Desc:       获取推送签名的ID
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"35","userID":"6"},"product":"OP","action":"FETCH_SIGNRESULT"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod FetchSignResult(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s documentID = argInJson.params.documentID
	s userID = argInJson.params.userID
    s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).FetchSignResultJson(strProduct,documentID,userID,.argOutData)
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

/// Desc:       获取推送签名的ID
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aProduct :产品标识
/// 			aDocumentID : 病历实例数据ID
/// 			aUserID	:用户ID
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFBase64Json("","")
ClassMethod FetchSignResultJson(aProduct As %String, aDocumentID As %String, aUserID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aDocumentID="") "-1^文档ID不能为空"

	s obj = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(obj = "") "-1^指定实例不存在["_aDocumentID_"]"
	s episodeID =obj.EpisodeID.%Id() 
	s TILPDFAuditSignLog = ##class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(episodeID)

	s id = "", toSignID = ""
	for {
		s id = $O(@TILPDFAuditSignLog@("IdxInstance",episodeID, aDocumentID, 1, id),-1)
		q:(id = "")
		s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(episodeID,id)
		continue:(obj = "")
		continue:(obj.IsValid '= "1")
		continue:(obj.SignStatus '= "TOSIGN")
		s toSignID = id
		q
	}
	if (toSignID = "")
	{
		s resData ="0^未找到待签的推送签名记录"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(episodeID,toSignID)
	q:(obj = "") "-1^打开推送签名记录失败"
	
	s entity = ""
	s ret = ##Class(EMR.DOC.BL.CASservice).GetPushSignResult(obj.PatPushSignID,aUserID,.entity)
	q:(sc ["-1") ret	
	q:(entity = "") "-1^返回签名记录实体对象为空"
	
	s signStatus = entity.Status
	if (signStatus = "FINISH")
	{
		s ret = ##Class(EMR.DOC.BL.PDFAuditSignLog).FinishEMRPushSign(episodeID,toSignID, signStatus, entity.SignedData)
	}
	elseif (signStatus = "REFUSE")||(signStatus = "EXPIRE")
	{
		s ret = ##Class(EMR.DOC.BL.PDFAuditSignLog).RevokeEMRPushSign(episodeID,toSignID, signStatus, "", "")
	}
	elseif (signStatus = "CANCEL")
	{
		s ret =##Class(EMR.DOC.BL.PDFAuditSignLog).RevokeEMRPushSign(episodeID,toSignID, signStatus, "", aUserID)
	}
	elseif (signStatus = "TOSIGN")
	{
		s ret = "0^患者还未签署病历"
	}
	elseif (signStatus = "")
	{
		s ret = "0^文档签署状态异常【签署状态为空】"
	}
	else
	{
		s ret = "0^未知签名状态["_signStatus_"] 无法处理CA回调的签名数据"
	}
	
	q:(ret [ "-1^") ret
	
	s resData =ret
	d argOutData.Write(""""_resData_"""")    
   	q strRes
	
Error 
	q "-1^"_$zerror
}

/// Desc:       完成签名
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aEpisodeID 就诊号
/// 			auditSignLogID : 推送签名ID
/// 			signStatus	签名状态
/// 			APDFBase64Stream 签名流数据
/// 			hisUserID 用户ID
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug：	
ClassMethod FinishEMRPushSign(aEpisodeID As %String, auditSignLogID As %String, signStatus As %String, APDFBase64Stream As %GlobalCharacterStream, hisUserID As %String = "") As %String
{
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,auditSignLogID)
	s obj = ##class(EMR.DB.PDFAuditSignLog).%OpenId(auditSignLogID)
	q:(obj = "") "-1^打开电子病历患者推送签名记录失败 id["_id_"]"
	q:(obj.IsValid '= "1") "0^已设置为无效-不能再更新推送签名状态"
	q:(obj.SignStatus = "SIGNED")||(obj.SignStatus = "FINISH") "0^签名已完成-不能再更新推送签名状态"
	q:(obj.SignStatus = "REFUSE") "0^签名已拒绝-不能再更新推送签名状态"
	q:(obj.SignStatus = "CANCEL") "0^签名已取消-不能再更新推送签名状态"
	q:(obj.SignStatus = "EXPIRE") "0^签名已超时-不能再更新推送签名状态"
	
	//完成保存签名操作	
	s obj.SignStatus = "SIGNED"   //"FINISH"
	s obj.UpdateDate = $p($h,",",1)
	s obj.UpdateTime = $p($h,",",2)
	if ($isobject(APDFBase64Stream))
	{
		d obj.PDFBase64.CopyFrom(APDFBase64Stream)
	}
	s sc = obj.%Save()
	if ($$$ISERR(sc))
	{
		q "0^更新电子病历患者签名记录状态失败 id["_auditSignLogID_"]"
	}
	
	//完成保存签名操作
	s objDocument = obj.DocumentID
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = "127.0.0.1"
	s dtoItemLog.LoginUserID = hisUserID
	s dtoItemLog.OperateUserID = hisUserID
	s dtoItemLog.UserLoginLocID = ""
	s dtoItemLog.ProductSource = "EMR"
	s dtoItemLog.Action = "revokePatPushSign"
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoItemLog,objDocument)
    if (logStatus[ "-1^")
	{
		q "0^添加操作日志失败: "_$p(logStatus,"^",2)
	} 
	
	q "1^注册签名后PDF成功"
}

/// Desc: 回滚签名，包括上级医师拒签、签名任务超时、HIS端医生主动取消
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aEpisodeID 就诊号
/// 			auditSignLogID : 推送签名ID
/// 			signStatus	签名状态
/// 			cancelUserID 撤销用户
/// 			ipAddress 地址
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug：	
ClassMethod RevokeEMRPushSign(aEpisodeID As %String, auditSignLogID As %String, signStatus As %String, cancelUserID As %String = "", ipAddress As %String = "") As %String
{
	s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(aEpisodeID,auditSignLogID)
	s obj = ##class(EMR.DB.PDFAuditSignLog).%OpenId(auditSignLogID)
	q:(obj = "") "-1^打开电子病历患者推送签名记录失败 id["_id_"]"
	q:(obj.IsValid '= "1") "0^已设置为无效-不能再更新推送签名状态"
	q:(obj.SignStatus = "SIGNED")||(obj.SignStatus = "FINISH") "0^签名已完成-不能再更新推送签名状态"
	q:(obj.SignStatus = "REFUSE") "0^签名已拒绝-不能再更新推送签名状态"
	q:(obj.SignStatus = "CANCEL") "0^签名已取消-不能再更新推送签名状态"
	q:(obj.SignStatus = "EXPIRE") "0^签名已超时-不能再更新推送签名状态"
	

	//完成保存签名操作
	if (ipAddress = "")&&(%request '= "")
	{	s ipAddress = %request.CgiEnvs("SERVER_NAME") }
	
	s objDocument = obj.DocumentID
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = ipAddress
	s dtoItemLog.LoginUserID = cancelUserID
	s dtoItemLog.OperateUserID = cancelUserID
	s dtoItemLog.UserLoginLocID = ""
	s dtoItemLog.ProductSource = "EMR"
	s dtoItemLog.Action = "revokePatPushSign"
	
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoItemLog,objDocument)
    if (logStatus[ "-1^")
	{
		q "0^添加操作日志失败: "_$p(logStatus,"^",2)
	} 
	
	s obj.SignStatus = signStatus
	s obj.IsValid = "0"
	s sc = obj.%Save()
	if ($$$ISERR(sc))
	{
		q "0^更新推送签名记录状态失败"
	}
	
	q "1^success"
}

/// Desc:      取消推送签名记录
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"35","userID":"6","ipAddress":""},"product":"OP","action":"INVALID_SIGNEDPDF"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod InvalidSignedPDF(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s documentID = argInJson.params.documentID
	s userID = argInJson.params.userID
	s ipAddress = argInJson.params.ipAddress
    s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).InvalidSignedPDFJson(strProduct,documentID,userID,ipAddress,.argOutData)
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

/// Desc:       取消推送签名记录
/// Creator:    yejian
/// CreateDate: 2023-1-4
/// Input:		aProduct :产品标识
/// 			aDocumentID : 病历实例数据ID
/// 			aUserID	:用户ID
/// 			aIPAddress:地址
/// Output:     成功：1
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.PDFAuditSignLog).InvalidSignedPDFJson("","")
ClassMethod InvalidSignedPDFJson(aProduct As %String, aDocumentID As %String, aUserID As %String, aIPAddress As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aDocumentID="") "-1^文档ID不能为空"

	s objdoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objdoc = "") "-1^指定实例不存在["_aDocumentID_"]"
	s episodeID =objdoc.EpisodeID.%Id() 
	s TILPDFAuditSignLog = ##class(EMR.DAO.PDFAuditSignLog).GetTureIndexLocation(episodeID)
	
	s idList = ""
	s id = ""
	for {
		s id = $O(@TILPDFAuditSignLog@("IdxInstance",episodeID, aDocumentID, 1, id),-1)
		q:(id = "")
		s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(episodeID,id)
		continue:(obj = "")
		s idList=$case(idList,"":id,:idList_"^"_id)
	}
	if (idList = "") 
	{
		s resData ="0^未找到待签的推送签名记录"
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	s cancelStatus = "1", cacelMsg = ""
	for j = 1:1:$L(idList)
	{
		s signID = $p(idList,"^",j)
		s obj = ##class(EMR.DAO.PDFAuditSignLog).doOpenByID(episodeID,signID)
		continue:(obj = "")
		
		if (obj.PatPushSignID '= "")
		{
			s ret = ##Class(EMR.DOC.BL.CASservice).CancelPushSign(obj.PatPushSignID,aUserID)
			if ($p(ret,"^",1) '= "1")
			{
				s cancelStatus = "0"
				s cancelMsg = $p(ret,"^",2)
				q
			}
		}
		
		s obj.IsValid = "0"
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			s cancelStatus = "0"
			s cancelMsg = sc
			q
		}
	}
	
	if (cancelStatus = "0")
	{
		s resData ="-1^"_cancelMsg
		d argOutData.Write(""""_resData_"""")
		q strRes
	}
	
	//完成保存签名操作
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = aIPAddress
	s dtoItemLog.LoginUserID = aUserID
	s dtoItemLog.OperateUserID = aUserID
	s dtoItemLog.UserLoginLocID = ""
	s dtoItemLog.ProductSource = "EMR"
	s dtoItemLog.Action = "revokePatPushSign"
	
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoItemLog,objdoc)
    if (logStatus[ "-1^")
	{
		q "-1^添加操作日志失败: "_$p(logStatus,"^",2)
	} 
	s resData ="1^作废患者推送签名成功"
	d argOutData.Write(""""_resData_"""")    
   	q strRes
	
Error 
	q "-1^"_$zerror
}

}
