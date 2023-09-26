/// 名称:		EMR.DOC.BL.Lock
/// 描述:		病历锁业务逻辑实现
/// 编写者:		yejian
/// 编写日期: 	2023-5-8
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.Lock Extends EMR.DOC.COM.ActionBase
{

/// Desc:       判断是否病历加锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input:      argInJson  命令参数 {"action":"HAS_LOCKED","params":{"documentID":"1","userID":"18881","userLocID":"191","ipAddress":"192.168.100.35","sessionID":"NpHHr531ZF"},"product":"OP"}
/// 			documentID 文档ID
/// 			userID 用户ID
/// 			userLocID 科室ID
/// 			ipAddress IP地址	
/// 			sessionID sessionID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod HasLocked(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.Lock).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.ComputerIP = argInJson.params.ipAddress
	s objItem.SessionID = argInJson.params.sessionID
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Lock).HasLockedJson(objItem,.argOutData)
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

/// Desc:       判断是否病历加锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Lock).GetUserDataJson("10209",.obj)
ClassMethod HasLockedJson(aLock As EMR.DOC.DTO.Lock, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",lockMessage="",hasLock="false",locDocumentID = "",objLock="",rowId=""
	q:(aLock="")||(aLock.DocumentID="") "-1^文档ID不能为空"
    s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aLock.DocumentID)
    q:(objDoc="") "-1^根据文档ID获取文档对象失败"
	s aLock.EpisodeID = objDoc.EpisodeID.%Id()
	s rowId = $o(^EMR.GB.LockI("IdxMain",aLock.DocumentID,""))
	s:(rowId'="") objLock = ##class(EMR.GB.Lock).%OpenId(rowId)
	s resJson = ##class(%DynamicObject).%New()
	
	//该病历正被编辑:(医生01|内分泌科|ye-workcp|192.168.3.80|2023-05-08 20:03:59)
	if (objLock'="")
	{
		s lockMessage = "该病历正被编辑:("_objLock.UserID.SSUSRName_"|"_objLock.UserLocID.CTLOCDesc_"|"_objLock.ComputerIP_"|"_$zd(objLock.LockDate,3)_" "_$zt(objLock.LockTime,1)_")"
		s hasLock = "true"
		s locDocumentID= aLock.DocumentID
	}
	s resJson.hasLocked = hasLock
	s resJson.lockMessage = lockMessage
	s resJson.lockedID = rowId
	s resJson.documentID = locDocumentID
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       病历加锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input:      argInJson  命令参数 {"action":"DOC_LOCK","params":{"documentID":"1","userID":"18881","userLocID":"191","ipAddress":"192.168.100.35","sessionID":"NpHHr531ZF"},"product":"OP"}
/// 			documentID 文档ID
/// 			userID 用户ID
/// 			userLocID 科室ID
/// 			ipAddress IP地址	
/// 			sessionID sessionID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DocLock(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.Lock).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.ComputerIP = argInJson.params.ipAddress
	s objItem.SessionID = argInJson.params.sessionID
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Lock).DocLockJson(objItem,.argOutData)
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

/// Desc:       病历加锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Lock).GetUserDataJson("10209",.obj)
ClassMethod DocLockJson(aLock As EMR.DOC.DTO.Lock, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",lockMessage="",resData = "1"
	q:(aLock="")||(aLock.DocumentID="") "-1^文档ID不能为空"
	q:(aLock.UserID="") "-1^用户ID不能为空"
	s objUser = ##class(User.SSUser).%OpenId(aLock.UserID,0)
	q:(objUser="") "-1^根据用户ID获取用户对象失败"
	q:(aLock.UserLocID="") "-1^科室ID不能为空"
	s objCTLoc = ##class(User.CTLoc).%OpenId(aLock.UserLocID,0)
	q:(objCTLoc="") "-1^根据科室ID获取科室对象失败"
    s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aLock.DocumentID)
    q:(objDoc="") "-1^根据文档ID获取文档对象失败"
	s aLock.EpisodeID = objDoc.EpisodeID.%Id()
	s type =  $p(^PAADM(aLock.EpisodeID),"^",2)
	s aLock.Type = $case(type,"I":"IP","O":"OP","E":"EP")
	s lockId = $o(^EMR.GB.LockI("IdxMain",aLock.DocumentID,""))
	if (lockId'="")
	{ 
		s objLock = ##class(EMR.GB.Lock).%OpenId(lockId)
		s lockMessage = "该病历正被编辑:("_objLock.UserID.SSUSRName_"|"_objLock.UserLocID.CTLOCDesc_"|"_objLock.ComputerIP_"|"_$zd(objLock.LockDate,3)_" "_$zt(objLock.LockTime,1)_")"
		q "-1^"_lockMessage
	}
	else
	{
		s objLock = ##class(EMR.GB.Lock).%New()
		s objLock.DocumentID = aLock.DocumentID
		s objLock.EpisodeID = objDoc.EpisodeID
		s objLock.ComputerIP = aLock.ComputerIP
		s objLock.ComputerName = aLock.ComputerName
		s objLock.Product = aLock.Type
		s objLock.SessionID = aLock.SessionID
		s objLock.DOCCategoryCode = objDoc.DOCCategoryCode
		s objLock.DOCCode = objDoc.DOCCode
		s objLock.TemplateID = objDoc.TemplateID
		s objLock.UserID = objUser
		s objLock.UserLocID = objCTLoc
		s objLock.LockDate = $p($h,",",1)
    	s objLock.LockTime = $p($h,",",2)
    	s sc = objLock.%Save()
    	//保存失败返回0
    	s:($$$ISERR(sc)) resData = "0"
	}
	d argOutData.Write(resData)
	q strRes
}

/// Desc:       病历解锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input:      argInJson  命令参数 {"action":"UN_LOCK","params":{"documentID":"1","sessionID":"NpHHr531ZF"},"product":"OP"}
/// 			documentID 文档ID	
/// 			sessionID sessionID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UnLock(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.Lock).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.SessionID = argInJson.params.sessionID
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Lock).UnLockJson(objItem,.argOutData)
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

/// Desc:       病历解锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 0, -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Lock).UnLockJson("10209",.obj)
ClassMethod UnLockJson(aLock As EMR.DOC.DTO.Lock, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",resData = "1"
	q:(aLock="")||((aLock.DocumentID="")&&(aLock.SessionID="")) "-1^文档ID或SessionID不能为空"
    if (aLock.DocumentID'="")
    {
	    s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aLock.DocumentID)
	    q:(objDoc="") "-1^根据文档ID获取文档对象失败"
		s aLock.EpisodeID = objDoc.EpisodeID.%Id()
		s rowId = $o(^EMR.GB.LockI("IdxMain",aLock.DocumentID,""))
		if (rowId'="")
		{
			s sc = ##Class(EMR.GB.Lock).%DeleteId(rowId)
			s:($$$ISERR(sc)) resData = "0"
		}
    }
    elseif(aLock.SessionID'="")
    {
	    s sessionID = aLock.SessionID
	    &sql(DELETE FROM EMR_GB.Lock WHERE SessionID =:sessionID)
	    if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			s resData = "0"
		}
    }
	d argOutData.Write(resData)
	q strRes
}

/// Desc:       是否刷新病历
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input:      argInJson  命令参数 {"action":"ISREFRESH_DOCUMENT","product":"OP","params":{"documentID":"218","pOperateDateTime":"","status":"created"}}
/// 			documentID 文档ID	
/// 			sessionID sessionID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod IsRefreshDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.Lock).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.PStatus = argInJson.params.status
	s PModifyDateTime = argInJson.params.pOperateDateTime //需要处理时间格式
	s:(PModifyDateTime'="") objItem.PModifyDate =$ZDH(PModifyDateTime,3)
 	s:(PModifyDateTime'="") objItem.PModifyTime =$ZTH($P(PModifyDateTime," ",2),1)
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Lock).IsRefreshDocumentJson(objItem,.argOutData)
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

/// Desc:       病历解锁
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 0, -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Lock).UnLockJson("10209",.obj)
ClassMethod IsRefreshDocumentJson(aLock As EMR.DOC.DTO.Lock, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1",strStatus = "",strDocumentID= ""
	q:(aLock="")||(aLock.DocumentID="") "-1^文档ID不能为空"
	s resJson = ##class(%DynamicObject).%New()
	s rowId = $o(^EMR.GB.LockI("IdxMain",aLock.DocumentID,""))
	
	//病历锁定 1，未锁定 0,不刷新 -1
	if (rowId'="")
	{
		s resJson.locked = "1"
		d resJson.%ToJSON(argOutData)
		q strRes
	}
	else
	{
		
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aLock.DocumentID)
		q:(objDocument="") "-1^获取文档实例失败"
		s aLock.EpisodeID = objDocument.EpisodeID.%Id()
		//是否刷新病历
		if (aLock.PModifyDate=objDocument.ModifyDate)&&(aLock.PModifyTime=objDocument.ModifyTime)
		{
			s resJson.locked = "-1"
			d resJson.%ToJSON(argOutData)
			q strRes
		}
		s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(aLock.EpisodeID)
		s objTem = objDocument.TemplateID
		q:(objTem="") "-1^获取模板对象失败"
		s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
		q:(strTemCId="") "-1^获取业务活动记录失败"
		s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
		s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
		//指定病历实例是否有对应患者签名后的PDF文档
		s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(aLock.DocumentID, aLock.EpisodeID)			
		s resJson.locked = "0"
		s objJson = ##class(%DynamicObject).%New()
		//如果删除，获取保存状态的文档ID
		if (objDocument.Status="Delete")
		{
			s strDocumentID = $O(@TILDocumentData@("IdxEpisodeDOCCCodeStatus",aLock.EpisodeID," "_$zcvt(objDocument.DOCCategoryCode,"U")," SAVE",""),-1)
			s objJson.documentID = strDocumentID
		}
		else
		{
			s objJson.documentID = objDocument.%Id()
		}
		s objJson.docName = objDocument.DOCName
		s objJson.docCode = objDocument.DOCCode
		s objJson.docCategoryCode = objDocument.DOCCategoryCode
		s objJson.docCategoryName = objDocCTem.EMRName
		s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
		s objJson.templateID = objDocument.TemplateID.%Id()
		s objJson.serial = objDocument.Serial
		s objJson.isLeadframe = objTemCat.Title.IsLeadframe
		s objJson.isMutex = objTemCat.Title.IsMutex
		s objJson.chartItemType = objTem.ChartItemType
		s objJson.pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
		s objJson.status = objDocument.Status
		s objJson.eventID = ""
		s objJson.eventType = ""
		s objJson.sourceID = objDocument.SourceID
		s objJson.sourceType = objDocument.SourceType
		s resJson.docData =objJson

	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:      获取锁列表数据
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_LOCKLIST","product":"OP","params":{"userName":"1219","ipAddress":"127.0.0.1","docName":"","type":"OP","langID":"20"}}
/// 			documentID 文档ID
/// 			userID 用户ID
/// 			userLocID 科室ID
/// 			ipAddress IP地址	
/// 			sessionID sessionID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLockList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.Lock).%New()
	s objItem.UserName = argInJson.params.userName
	s objItem.ComputerIP = argInJson.params.ipAddress
	s objItem.DocName = argInJson.params.docName
	s objItem.Type = argInJson.params.type
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
	s objItem.Product = argInJson.product
	
	s page = argInJson.params.page  
    s rows=argInJson.params.rows
    s:(page'="") objItem.StartPage = rows * (page -1) + 1
	s:(page'="") objItem.EndPage = objItem.StartPage + rows -1
    s strRes = ##Class(EMR.DOC.BL.Lock).GetLockListJson(objItem,.argOutData)
	//1 添加成功
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

/// Desc:       获取锁列表数据
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Lock).GetUserDataJson("10209",.obj)
ClassMethod GetLockListJson(aLock As EMR.DOC.DTO.Lock, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",resData = "1",objJson= "",count = 0
	s resJson = ##class(%DynamicObject).%New()
	s arrJson = ##class(%DynamicArray).%New()
	s rowId = ""
	for
	{
		s rowId = $o(^EMR.GB.LockD(rowId))
		q:(rowId="")
		s objLock = ##class(EMR.GB.Lock).%OpenId(rowId)
		continue:(objLock="")
		//就诊类型不为空，过滤用户
		continue:((aLock.Type'="")&&(aLock.Type'=objLock.Product))
		//用户名不为空，过滤用户名
		continue:((aLock.UserName'="")&&(aLock.UserName'=objLock.UserID.SSUSRName))
		//ip不为空，过滤IP
		continue:((aLock.ComputerIP '= "")&&(aLock.ComputerIP '= objLock.ComputerIP))
		s docName = ""
		s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(objLock.DocumentID)
	    s:(objDoc'="") docName= ##class(EMR.DOC.TOOL.Translation).Get("EMRTrans",objDoc.DOCName) 
		// 病历名称不为空，过滤
		continue:((aLock.DocName '= "")&&(docName '[ aLock.DocName))
		s itemJson = ##class(%DynamicObject).%New()
		s itemJson.ID = rowId
		//文档ID
		s itemJson.documentID = objLock.DocumentID
		s itemJson.UserID = objLock.UserID.%Id()
		s itemJson.UserCode = objLock.UserID.SSUSRInitials
		s itemJson.UserName = objLock.UserID.SSUSRName
		s HISFormatLockDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objLock.LockDate)
		s HISFOrmatLockTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objLock.LockTime)
		s itemJson.LockDateTime = HISFormatLockDate_" "_HISFOrmatLockTime
		s itemJson.EpisodeID = objLock.EpisodeID.%Id()
		//业务活动记录分类编码
		s itemJson.DOCCategoryCode =objLock.DOCCategoryCode
		//业务活动记录编码
		s itemJson.DOCCode = objLock.DOCCode
	    //病历标题
	    s itemJson.DocName = docName
		//模板ID
		s itemJson.TemplateID = objLock.TemplateID.%Id()
		//模板ID
		s itemJson.Computer = objLock.ComputerIP
		s itemJson.type = $case(objLock.Product,"OP":"门诊","IP":"住院","EP":"急诊")
		//分页处理
		s count = count + 1
		if ((aLock.StartPage <= count)&(count <= aLock.EndPage))
		{
			d arrJson.%Push(itemJson)
		}
	}
	s resJson.total = count
	s resJson.rows = arrJson
    d resJson.%ToJSON(argOutData)
	q strRes
Error
	q "-1^"_"获取加锁数据失败:"_$zerror
}

}
