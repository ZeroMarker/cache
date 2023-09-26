/// 名称:	EMR.DOC.BL.EMRSignDocument
/// 描述:	签名保存业务类
/// 编写者：yejian
/// 编写日期: 2022-9-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRSignDocument Extends EMR.DOC.COM.ActionBase
{

/// Desc:       医护签名保存（CA、SYS）
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"id":"6","code":"L001","elementCode": "L0001","invalidCode": "L0002","hashData":"dsdfsdfsdf","signLevel":"Resident","roleLevel":"10","levelName":"住院医师","type":"SYS","documentID":"33","userCertCode":"1050","certNo":"105","signValue":"","userID":"6","userLocID":"6","ipAddress":"127.0.0.1","pmdType":"EMR","pmdCode":"","time":"2022-9-2016:40:00"},"product":"OP","action":"SAVE_SIGNED_DOCUMENT"}
/// 			id: 签名用户ID,code:签名编码,elementCode:签名元素编码,invalidCode:失效签名编码,hashData:哈希值,	
/// 			signLevel:角色编码,roleLevel:角色等级,levelName:角色名称，type:类型（CA/SYS），documentID：文档ID，
/// 			userCertCode：用户证书标识，certNo：证书编码，signValue：CA返回的签名值，userID：登录用户id,userLocID:登录科室ID，
/// 			ipAddress：客户端IP地址，pmdType：产品标识，pmdCode：产品编码，time：签名时间			
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveSignedDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem =##class(EMR.DOC.DTO.SignData).%New()
	s objItem.Product = argInJson.product
	s objItem.SignUserID = argInJson.params.id
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.Code = argInJson.params.code
	s objItem.InvalidCode = argInJson.params.invalidCode
	s objItem.ElementCode = argInJson.params.elementCode
	s objItem.Digest = argInJson.params.hashData
	s objItem.RoleName = argInJson.params.signLevel
	s objItem.RoleDesc = argInJson.params.levelName
	s objItem.RoleLevel = argInJson.params.roleLevel
	s objItem.Type = argInJson.params.type
	s objItem.UserCertCode = argInJson.params.userCertCode
	s objItem.CertNo = argInJson.params.certNo
	s objItem.SignValue = argInJson.params.signValue
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.IPAddress = argInJson.params.ipAddress
	s objItem.PmdType = $case(argInJson.params.pmdType,"":"EMR",:argInJson.params.pmdType)
	s objItem.PmdCode = argInJson.params.pmdCode
	s signDate = argInJson.params.time
	s pModiyDate =argInJson.params.pOperateDateTime
	s objItem.SignDate=$case(signDate,"":$ZDH($ZD($h)),:$ZDH(signDate,3))
	s objItem.SignTime = $case(signDate,"":$ZTH($ZT($P($h,",",2),1)),:$ZTH($P(signDate," ",2),1))
	s:(pModiyDate'="") objItem.PModifyDate = $ZDH(pModiyDate,3)
	s:(pModiyDate'="") objItem.PModifyTime = $ZTH($P(pModiyDate," ",2),1)
	
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = argInJson.params.userID
	s dtoItemLog.OperateUserID = argInJson.params.id
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = objItem.PmdType
    s strRes = ##Class(EMR.DOC.BL.EMRSignDocument).SaveSignedDocumentJson(objItem,dtoItemLog,argInData,.argOutData)
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

/// Desc:       获取签名文档信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aItem:签名对象
/// 			dtoILog:日志对象
/// 			argInData:签名原文
/// Output:     成功：保存签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.DocumentData).GetRecordInfoJson("","")
ClassMethod SaveSignedDocumentJson(aItem As EMR.DOC.DTO.SignData, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aItem.Type="CA")&&((aItem.UserCertCode = "")||(aItem.Digest="")) "-1^用户唯一标示、签名哈希为空！"
	
	q:(argInData="")||((argInData.Size<1)) "-1^签名原文、哈希不能为空"
	q:(aItem.DocumentID = "") "-1^文档ID不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s aEpisodeID = objDoc.EpisodeID.%Id()
	
	//检查是否打开后，保存前有其他人保存（防止覆盖）
	s saveStatus=""
	s:(aItem.PModifyDate'="") saveStatus = ##Class(EMR.DOC.BL.DocumentData).CheckSaveStatus(aItem.DocumentID,aItem.PModifyDate,aItem.PModifyTime)
	q:(saveStatus["-1^") "-1^DocumentID:"_aItem.DocumentID_","_$p(saveStatus,"^",2)
	
	s action = ##Class(EMR.DOC.BL.SignRole).GetSignCode(aItem.RoleName)
	q:(action = "") "-1^DocumentID:"_aItem.DocumentID_","_action
	
	s aItem.EpisodeID = aEpisodeID
	s aItem.ListNo = objDoc.ListNo
	s aItem.DOCCode= objDoc.DOCCode
	s aItem.ActionCode = action
	k objDoc
	
	//构建保存文档需要的对象	
	s dtoInData = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoInData.ID = aItem.DocumentID
	s dtoInData.EpisodeID = aItem.EpisodeID
	s dtoInData.CreateUser = aItem.UserID
	s dtoInData.ModifyUser = aItem.UserID
	
	s $zt = "SaveSignDocError"
	Tstart
	if (aItem.Type="CA")
	{
		//调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
		s caRes = ##Class(EMR.DOC.BL.CASservice).Sign(aItem.UserCertCode, aItem.PmdType, aItem.Digest , aItem.SignValue, aItem.CertNo)
		// 签名失败回滚，返回失败信息
		if (caRes["0^")
		{
			Trollback
			q "-1^DocumentID:"_aItem.DocumentID_",CA签名失败:"_$p(caRes,"^",2)
		}
		s aItem.SignID = $p(caRes,"^",2)
		//保存医护签原文、哈希
		s strStream = ##Class(EMR.DOC.BL.DoctorSignStream).SaveDoctorSignStream(aItem.EpisodeID,aItem.SignID,aItem.DocumentID,aItem.Digest,argInData)
		if (strStream["-1^")
		{
			Trollback
			q strStream
		}
	}
	s status = ##Class(EMR.DOC.BL.DocumentData).SaveDoucmentData(dtoInData,argInData)
	if (status '= "1") 
	{
		Trollback
		q "-1^DocumentID:"_aItem.DocumentID_"保存文档失败"
	}
	//返回签名信息，成功：1^签名ID^签名日志ID，失败：-1^失败信息
	s signStatus = ##class(EMR.DOC.BL.EMRSign).SetMERSign(aItem,argInData)
	if (signStatus["-1^")
	{
		Trollback
		q "-1^DocumentID:"_aItem.DocumentID_","_$p(signStatus,"^",2)
	}   
	s dtoILog.Action = aItem.ActionCode
    s dtoILog.EMRSignID = $p(signStatus,"^",2)
    s dtoILog.EMRSignLogID = $p(signStatus,"^",3)
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	//添加日志信息
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
	if (logStatus[ "-1^")
	{
		Trollback
		q "-1^DocumentID:"_DocumentID_",logStatus:"_$p(logStatus,"^",2)
	}
	TCOMMIT
	
	/*
	s messageResult = ##Class(EMRservice.BL.BLMessage).SendSignMessage(userID,DocumentID,signLevel,userLocId)
	///诊断证明书，24小时入出院记录,死亡记录等加入归档对列 生成pdf 加入队列
	d ##Class(EMRservice.HISInterface.DHCEPRFSInfo).SetRunDocQueue(episodeID,DocumentID)
	d ##Class(EMRservice.BL.BLMessage).ChangeMessageStatus(signUserID,DocumentID)
	//注册首页数据推送队列
	d ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP(DocumentID)
	//签名后回收自动审批权限
	s withdrawApplyEdit = ##Class(EMRservice.BL.BLApplyEdit).WithdrawApplyEdit(DocumentID,userID)
	*/
 	s jsonRes = ##class(%DynamicObject).%New()
 	s jsonRes.documentID =aItem.DocumentID
 	;s jsonRes.emrSignID =$p(signStatus,"^",2)
 	;s jsonRes.emrSignLogID =$p(signStatus,"^",3)
 	s jsonRes.messageFlag=""
 	d jsonRes.%ToJSON(argOutData)
   	q "1"	
SaveSignDocError
   Trollback
   q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
Error 
    d argOutData.Write(..#NONE)
	q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
}

/// Desc:       患者签名保存
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"id":"6","code":"L0003","hashData":"dsdfsdfsdf","signLevel":"Resident","roleLevel":"10","levelName":"住院医师","type":"AnySign","documentID":"33","signValue":"","userID":"6","userLocID":"6","ipAddress":"127.0.0.1","pmdType":"EMR","pmdCode":"","time":"2022-9-2016:40:00","pOperateDateTime":"2022-9-2016:40:00","elementCode":"L0001","invalidCode":"L0002","version":"1","algorithm":"md5","eventCert":"22","tsValue":"3454745","bioFeature":"","signScript":"","headerImage":"","fingerPrint":"","signData":""},"product":"OP","action":
/// 			id: 签名用户ID,code:签名编码,elementCode:签名元素编码,invalidCode:失效签名编码,hashData:哈希值,	
/// 			signLevel:角色编码,roleLevel:角色等级,levelName:角色名称，type:类型（AnySign），documentID：文档ID，
/// 			signValue：CA返回的签名值，userID：登录用户id,userLocID:登录科室ID，pOperateDateTime 文档上次操作时间,
/// 			ipAddress：客户端IP地址，pmdType：产品标识，pmdCode：产品编码，time：签名时间，version：第三方版本,
/// 			algorithm: 记录ca的算法,eventCert:事件证书,tsValue:时间戳,bioFeature:生物特征,signScript:笔迹图,
/// 			headerImage:拍照图,fingerPrint:指纹图,signData:整个签名数据包			
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PatientSignedDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem =##class(EMR.DOC.DTO.SignData).%New()
	s objItem.Product = argInJson.product
	s objItem.SignUserID = argInJson.params.id
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.Code = argInJson.params.code
	s objItem.InvalidCode = argInJson.params.invalidCode
	s objItem.ElementCode = argInJson.params.elementCode
	s objItem.RoleName = argInJson.params.signLevel
	s objItem.RoleDesc = argInJson.params.levelName
	s objItem.RoleLevel = argInJson.params.roleLevel
	s objItem.Type = $case(argInJson.params.type,"":"AnySign",:argInJson.params.type)
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.IPAddress = argInJson.params.ipAddress
	s objItem.PmdType = $case(argInJson.params.pmdType,"":"EMR",:argInJson.params.pmdType)
	s objItem.PmdCode = argInJson.params.pmdCode
	s objItem.Digest = argInJson.params.hashData
	s objItem.SignValue = argInJson.params.signValue
	//患签数据
	s objItem.Version = argInJson.params.version
	s objItem.Algorithm = argInJson.params.algorithm
	s objItem.EventCert = argInJson.params.eventCert
	s objItem.TSValue = argInJson.params.tsValue
	
	d objItem.BioFeature.Write(argInJson.params.bioFeature)
	d objItem.SignScript.Write(argInJson.params.signScript)
	d objItem.HeaderImage.Write(argInJson.params.headerImage)
	d objItem.FingerPrint.Write(argInJson.params.fingerPrint)
	d objItem.SignData.Write(argInJson.params.signData)
	
	s signDate = argInJson.params.time
	s pModiyDate =argInJson.params.pOperateDateTime
	s objItem.SignDate=$case(signDate,"":$ZDH($ZD($h)),:$ZDH(signDate,3))
	s objItem.SignTime = $case(signDate,"":$ZTH($ZT($P($h,",",2),1)),:$ZTH($P(signDate," ",2),1))
	s:(pModiyDate'="") objItem.PModifyDate = $ZDH(pModiyDate,3)
	s:(pModiyDate'="") objItem.PModifyTime = $ZTH($P(pModiyDate," ",2),1)
	
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = argInJson.params.userID
	s dtoItemLog.OperateUserID = argInJson.params.id
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = objItem.PmdType
    s strRes = ##Class(EMR.DOC.BL.EMRSignDocument).PatientSignedDocumentJson(objItem,dtoItemLog,argInData,.argOutData)
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

/// Desc:       患者签名保存
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aItem:签名对象
/// 			dtoILog:日志对象
/// 			argInData:签名原文
/// Output:     成功：保存签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.DocumentData).GetRecordInfoJson("","")
ClassMethod PatientSignedDocumentJson(aItem As EMR.DOC.DTO.SignData, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"	
	q:(argInData="")||((argInData.Size<1)) "-1^签名原文不能为空"
	q:(aItem.DocumentID = "") "-1^文档ID不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s aEpisodeID = objDoc.EpisodeID.%Id()
	
	//检查是否打开后，保存前有其他人保存（防止覆盖）
	s saveStatus=""
	s:(aItem.PModifyDate'="") saveStatus  = ##Class(EMR.DOC.BL.DocumentData).CheckSaveStatus(aItem.DocumentID,aItem.PModifyDate,aItem.PModifyTime)
	q:(saveStatus["-1^") "-1^DocumentID:"_aItem.DocumentID_","_$p(saveStatus,"^",2)
	
	s action = ##Class(EMR.DOC.BL.SignRole).GetSignCode(aItem.RoleName)
	q:(action = "") "-1^DocumentID:"_aItem.DocumentID_","_action
	
	s aItem.EpisodeID = aEpisodeID
	s aItem.ListNo = objDoc.ListNo
	s aItem.DOCCode= objDoc.DOCCode
	s aItem.ActionCode = action
	k objDoc
	
	//构建保存文档需要的对象	
	s dtoInData = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoInData.ID = aItem.DocumentID
	s dtoInData.EpisodeID = aItem.EpisodeID
	s dtoInData.CreateUser = aItem.UserID
	s dtoInData.ModifyUser = aItem.UserID
	
	s $zt = "SaveSignDocError"
	Tstart
	
	//保存患者签数据(成功返回1^患签ID)
	s strStream = ##Class(EMR.DOC.BL.PatientSign).SavePatientSign(aItem,argInData)
	if (strStream["-1^")
	{
		Trollback
		q strStream
	}
	s aItem.SignID = $p(strStream,"^",2)
	s status = ##Class(EMR.DOC.BL.DocumentData).SaveDoucmentData(dtoInData,argInData)
	if (status '= "1") 
	{
		Trollback
		q "-1^DocumentID:"_aItem.DocumentID_"保存文档失败"
	}
	//返回签名信息，成功：1^签名ID^签名日志ID，失败：-1^失败信息
	s signStatus = ##class(EMR.DOC.BL.EMRSign).SetMERSign(aItem,argInData)
	if (signStatus["-1^")
	{
		Trollback
		q "-1^DocumentID:"_aItem.DocumentID_","_$p(signStatus,"^",2)
	}   
	s dtoILog.Action = aItem.ActionCode
    s dtoILog.EMRSignID = $p(signStatus,"^",2)
    s dtoILog.EMRSignLogID = $p(signStatus,"^",3)
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	//添加日志信息
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
	if (logStatus[ "-1^")
	{
		Trollback
		q "-1^DocumentID:"_DocumentID_",logStatus:"_$p(logStatus,"^",2)
	}
	TCOMMIT
	
	/*
	s messageResult = ##Class(EMRservice.BL.BLMessage).SendSignMessage(userID,DocumentID,signLevel,userLocId)
	///诊断证明书，24小时入出院记录,死亡记录等加入归档对列 生成pdf 加入队列
	d ##Class(EMRservice.HISInterface.DHCEPRFSInfo).SetRunDocQueue(episodeID,DocumentID)
	d ##Class(EMRservice.BL.BLMessage).ChangeMessageStatus(signUserID,DocumentID)
	//注册首页数据推送队列
	d ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP(DocumentID)
	//签名后回收自动审批权限
	s withdrawApplyEdit = ##Class(EMRservice.BL.BLApplyEdit).WithdrawApplyEdit(DocumentID,userID)
	*/
 	s jsonRes = ##class(%DynamicObject).%New()
 	s jsonRes.documentID =aItem.DocumentID
 	;s jsonRes.emrSignID =$p(signStatus,"^",2)
 	;s jsonRes.emrSignLogID =$p(signStatus,"^",3)
 	s jsonRes.messageFlag=""
 	d jsonRes.%ToJSON(argOutData)
   	q "1"	
SaveSignDocError
   Trollback
   q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
Error 
    d argOutData.Write(..#NONE)
	q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
}

/// Desc:       PDF签名保存
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"33","keyWord":"[患者签]","userID":"6","signType":""},"product":"OP","action":"PDF_PUSH_SIGN"}
/// 			documentID：文档ID，keyWord:签名关键字,userID:用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PDFPushSign(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem =##class(EMR.DOC.DTO.PDFSignData).%New()
	s objItem.Product = argInJson.product
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.KeyWord = argInJson.params.keyWord
	s objItem.SignType = argInJson.params.signType
	s objItem.Action = "patsigned"
	s objItem.StoreType = "db"
	s objItem.SignStatus = "TOSIGN"
	s objItem.IsValid = 1
	s objItem.CreateDate=$ZDH($ZD($h))
	s objItem.CreateTime = $ZTH($ZT($P($h,",",2),1))
    s strRes = ##Class(EMR.DOC.BL.EMRSignDocument).PDFPushSignJson(objItem,argInData,.argOutData)
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

/// Desc:       PDF签名保存
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aItem:签名对象
/// 			argInData:PDF签名原文
/// Output:     成功：保存签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSignDocument).PDFPushSignJson("","")
ClassMethod PDFPushSignJson(aItem As EMR.DOC.DTO.PDFSignData, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aItem.DocumentID = "") "-1^文档ID不能为空"
	if (argInData="")||((argInData.Size<100))
	{
		s resData = "0^推送PDF错误,PDF不能为空"
		d argOutData.Write(""""_resData_"""")
		q strRes
		 
	}
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s aEpisodeID = objDoc.EpisodeID.%Id()
	
	s aItem.EpisodeID = aEpisodeID
	s aItem.ListNo = objDoc.ListNo
	s aItem.DOCCode= objDoc.DOCCode
	s aItem.DOCName = objDoc.DOCName
	s aItem.DOCCategoryCode = objDoc.DOCCategoryCode
	k objDoc

	s $zt = "PDFSignDocError"
	Tstart

	s caRes = ##class(EMR.DOC.BL.CASservice).PDFSign(argInData,"EMR", aItem.DocumentID, aItem.DOCName, aItem.KeyWord, aItem.EpisodeID, aItem.UserID,aItem.SignType)
	// 签名失败回滚，返回失败信息
	if (caRes[ "-1^")
	{
		Trollback
		q caRes
	}
	s retJson = ##class(%DynamicObject).%FromJSON(caRes)
	s patPushResult = retJson.GetAt("signResult")
	s aItem.PatPushSignID = $p(patPushResult,"#",2)
	s aItem.CABusinessGUID = $p(patPushResult,"#",3)
	s aItem.UniqueDocID = $P(patPushResult,"#",4)
	
	//保存PDF原文
	s resPDF = ##Class(EMR.DOC.BL.PDFAuditSignLog).SavePDFSignData(aItem,argInData)
	if (resPDF["-1^")
	{
		Trollback
		q resPDF
	}
	TCOMMIT
 	s jsonRes = ##class(%DynamicObject).%New()
 	s jsonRes.documentID =aItem.DocumentID
 	;s jsonRes.emrSignID =$p(signStatus,"^",2)
 	;s jsonRes.emrSignLogID =$p(signStatus,"^",3)
 	s jsonRes.messageFlag=""
 	d jsonRes.%ToJSON(argOutData)
   	q "1"	
PDFSignDocError
   Trollback
   q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
Error 
    d argOutData.Write(..#NONE)
	q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
}

/// Desc:       失效签名（撤销签名）
/// Creator:    yejian
/// CreateDate: 2022-9-26
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"authenticator":[{"elementCode":"L0001","id":"6","code":"L0003","signLevel":"Resident","name":"医生01"}],"documentID":"33","userID":"6","userLocID":"6","ipAddress":"127.0.0.1","pmdType":"EMR","pmdCode":"","pOperateDateTime":"2022-9-2016:40:00"},"product":"OP","action":"REVOKE_SIGNED"}
/// 			elementCode:签名元素编码,id: 签名用户ID,code:签名编码,signLevel:失效签名编码,name:用户姓名,	
/// 			documentID：文档ID，userID：登录用户id,userLocID:登录科室ID，ipAddress：客户端IP地址，pmdType：产品标识，
/// 			pmdCode：产品编码，pOperateDateTime：病历上次操作修改时间			
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod RevokeSigned(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem =##class(EMR.DOC.DTO.SignData).%New()
	s objItem.Product = argInJson.product
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.IPAddress = argInJson.params.ipAddress
	s objItem.PmdType = $case(argInJson.params.pmdType,"":"EMR",:argInJson.params.pmdType)
	s objItem.PmdCode = argInJson.params.pmdCode
	s pModiyDate =argInJson.params.pOperateDateTime
	s:(pModiyDate'="") objItem.PModifyDate = $ZDH(pModiyDate,3)
	s:(pModiyDate'="") objItem.PModifyTime = $ZTH($P(pModiyDate," ",2),1)
	s objItem.Authenticator = argInJson.params.authenticator
	//标题相关数据
	s objItem.DoctorID = argInJson.params.doctorID
	s objItem.DoctorName = argInJson.params.doctor
	s objItem.DoctorLevelCode = argInJson.params.doctorLevelCode
	s objItem.DoctorLevel = argInJson.params.doctorLevel
	
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = argInJson.params.userID
	s dtoItemLog.OperateUserID = argInJson.params.id
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = objItem.PmdType
    s strRes = ##Class(EMR.DOC.BL.EMRSignDocument).RevokeSignedJson(objItem,dtoItemLog,argInData,.argOutData)
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

/// Desc:       失效签名（撤销签名）
/// Creator:    yejian
/// CreateDate: 2022-9-26
/// Input:      aItem:签名对象
/// 			dtoILog:日志对象
/// 			argInData:签名原文
/// Output:     成功：保存签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.DocumentData).RevokeSignedJson("","")
ClassMethod RevokeSignedJson(aItem As EMR.DOC.DTO.SignData, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	
	q:(argInData="")||((argInData.Size<1)) "-1^失效原文不能为空"
	q:(aItem.DocumentID = "") "-1^文档ID不能为空"
	q:(aItem.Authenticator.%Size()<=0) "-1^失效列表不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s aEpisodeID = objDoc.EpisodeID.%Id()
	
	//检查是否打开后，保存前有其他人保存（防止覆盖）
	s saveStatus=""
	s:(aItem.PModifyDate'="") saveStatus  = ##Class(EMR.DOC.BL.DocumentData).CheckSaveStatus(aItem.DocumentID,aItem.PModifyDate,aItem.PModifyTime)
	q:(saveStatus["-1^") "-1^DocumentID:"_aItem.DocumentID_","_$p(saveStatus,"^",2)
		
	s aItem.EpisodeID = aEpisodeID
	s aItem.ListNo = objDoc.ListNo
	s aItem.DOCCode= objDoc.DOCCode
	s aItem.ActionCode = "save"
	k objDoc
	
	//构建保存文档需要的对象	
	s dtoInData = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoInData.ID = aItem.DocumentID
	s dtoInData.EpisodeID = aItem.EpisodeID
	s dtoInData.CreateUser = aItem.UserID
	s dtoInData.ModifyUser = aItem.UserID
	
	s $zt = "SaveSignDocError"
	Tstart
	s status = ##Class(EMR.DOC.BL.DocumentData).SaveDoucmentData(dtoInData,argInData)
	if (status '= "1") 
	{
		Trollback
		q "-1^DocumentID:"_aItem.DocumentID_"保存文档失败"
	}
	//失效签名信息，成功：1^签名ID^日志ID，失败：-1^失败信息
	set iter = aItem.Authenticator.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonItem = item
		s code = jsonItem.code
		continue:(code = "")
		s id = jsonItem.id
		s elementCode = jsonItem.elementCode
		s signLevel = jsonItem.signLevel
		s name = jsonItem.name
		s signStatus = ##Class(EMR.DOC.BL.EMRSign).RevokeSign(aItem.EpisodeID,aItem.DocumentID,aItem.ListNo,code)
		if (signStatus["-1^")
		{
			s strRes= "-1^DocumentID:"_aItem.DocumentID_","_$p(signStatus,"^",2)
			q
		}   
	}
	if (strRes["-1^")
	{
		Trollback
		q strRes
	}   
	s dtoILog.Action = aItem.ActionCode
    s dtoILog.EMRSignID = $p(signStatus,"^",2)
    s dtoILog.EMRSignLogID = $p(signStatus,"^",3)
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	//添加日志信息
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
	if (logStatus[ "-1^")
	{
		Trollback
		q "-1^DocumentID:"_DocumentID_",logStatus:"_$p(logStatus,"^",2)
	}
	//更新标题关联信息
	if (aItem.DocumentID'="")&&((aItem.DoctorID'="")||(aItem.DoctorLevel'=""))
	{
		s resTitleData = ##class(EMR.DOC.BL.DocumentTitleDoctor).UpTitleDatas(aItem.EpisodeID,aItem.DocumentID,aItem.DoctorID,aItem.DoctorName,aItem.DoctorLevel,aItem.DoctorLevelCode)
		if (resTitleData["-1^")
		{
			Trollback
			q resTitleData
		}
	}
	TCOMMIT
	
 	s jsonRes = ##class(%DynamicObject).%New()
 	s jsonRes.documentID =aItem.DocumentID
 	;s jsonRes.emrSignID =$p(signStatus,"^",2)
 	;s jsonRes.emrSignLogID =$p(signStatus,"^",3)
 	s jsonRes.messageFlag=""
 	d jsonRes.%ToJSON(argOutData)
   	q "1"	
SaveSignDocError
   Trollback
   q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
Error 
    d argOutData.Write(..#NONE)
	q "-1^DocumentID:"_aItem.DocumentID_",Err:"_$zerror
}

/// Desc:       患签流数据转换()
/// Creator:    yejian
/// CreateDate: 2022-9-28 18:20:42
/// Input:      reqValue:签名数据
/// Output:     流对象
/// Debug:      w ##Class(EMR.DOC.BL.DocumentData).getReqStream("")
ClassMethod getReqStream(reqValue) As %GlobalCharacterStream
{
	s reqStream = ##Class(%GlobalCharacterStream).%New()
	q:(reqValue="") reqStream
	s clsReq = $e(reqValue,1,50)
	if ($f(clsReq,"CharacterStream")>1)
	{
		d reqStream.CopyFrom(reqValue)
	}
	else
	{
		d reqStream.Write(reqValue)
	}	
	q reqStream
}

}
