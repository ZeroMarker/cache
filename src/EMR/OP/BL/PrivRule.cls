/// 名称:	EMR.OP.BL.PrivRule
/// 描述:	门诊病历-权限规则脚本服务
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.OP.BL.PrivRule Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取权限规则
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_PRIVILEGE","params":{"DiseaseID":"0","EpisodeID":"57","HospitalID":"2","IPAddress":"192.168.1.100","documentid":["435||3"],"PatientID":"54","ProductSourceCode":"","ProductSourceType":"EMR","SessionID":"r3fg4vxMCx","SsgroupID":"29","UserCode":"YS01","UserID":"10209","UserLocID":"95","UserName":"01"},"product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
	s objItem.userid = argInJson.params.userID
	s objItem.userloc =  argInJson.params.userLocID
	s objItem.ssgroupid =  argInJson.params.ssgroupID
	s objItem.patientid =  argInJson.params.patientID
	s objItem.admid =  argInJson.params.episodeID
	s objItem.sessionid =  argInJson.params.sessionID
	s objItem.documentids =  argInJson.params.documentID
	s objItem.productcode = argInJson.product
    s strRes = ##Class(EMR.OP.BL.PrivRule).GetPrivilegeJson(objItem,.argOutData)
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

/// Desc:       获取权限规则
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.SysOption).GetPrivilegeJson(.obj)
ClassMethod GetPrivilegeJson(aPrivRule As EMR.DOC.DTO.PrivRuleData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aPrivRule.userid = "")||(aPrivRule.userloc = "")||(aPrivRule.ssgroupid = "")||(aPrivRule.admid = "")||(aPrivRule.patientid = "") strRes
	
	s arrItem = ##class(%DynamicArray).%New()
   	s documentids = aPrivRule.documentids
	set iter = documentids.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s documentID = item
        s aPrivRule.documentid = documentID
		s jsonItem  = ##class(%DynamicObject).%New()
		;s privString = "userid^"_aPrivRule.UserID_"!userloc^"_aPrivRule.UserLocID_"!ssgroupid^"_aPrivRule.SsgroupID_"!admid^"_aPrivRule.EpisodeID_"!patientid^"_aPrivRule.PatientID_"!documentid^"_documentID_"!sessionid^"_aPrivRule.SessionID
		s resJson = ##class(%DynamicObject).%New()
		s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).GetPrivRuleByType(aPrivRule,"ActionPrivilege",.resJson)
		continue:(strRes [ "-1^")
		//save^1!print^1!delete^1!check^1!recheck^0!revokcheck^0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^1!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0
		s canSave = $p(resJson.%Get("save"),"|",1)
		s cantSaveReason = $p(resJson.%Get("save"),"|",2)
		s canPrint = $p(resJson.%Get("print"),"|",1)
		s cantPrintReason = $p(resJson.%Get("print"),"|",2)
		s canDelete = $p(resJson.%Get("delete"),"|",1)
		s cantDeleteReason = $p(resJson.%Get("delete"),"|",2)
		s canCheck = $p(resJson.%Get("check"),"|",1)
		s cantCheckReason = $p(resJson.%Get("check"),"|",2)
		s canReCheck = $p(resJson.%Get("recheck"),"|",1)
		s cantReCheckReason = $p(resJson.%Get("recheck"),"|",2)
		s canRevokCheck = $p(resJson.%Get("revokcheck"),"|",1)
		s cantRevokCheckReason = $p(resJson.%Get("revokcheck"),"|",2)
		s canReference = $p(resJson.%Get("reference"),"|",1)
		s cantReferenceReason = $p(resJson.%Get("reference"),"|",2)
		s canExport = $p(resJson.%Get("export"),"|",1)
		s cantExportReason = $p(resJson.%Get("export"),"|",2)
		s canCopyPaste = $p(resJson.%Get("copypaste"),"|",1)
		s cantCopyPasteReason = $p(resJson.%Get("copypaste"),"|",2)
		s canRevise = $p(resJson.%Get("revise"),"|",1)
		s cantReviseReason = $p(resJson.%Get("revise"),"|",2)
		s canViewRevise = $p(resJson.%Get("viewrevise"),"|",1)
		s cantViewReviseReason = $p(resJson.%Get("viewrevise"),"|",2)
		s canCommit = $p(resJson.%Get("commit"),"|",1)
		s cantCommitReason = $p(resJson.%Get("commit"),"|",2)
		s canApplyEdit = $p(resJson.%Get("applyedit"),"|",1)
		s cantApplyEditReason = $p(resJson.%Get("applyedit"),"|",2)
		s canUnLock = $p(resJson.%Get("unlock"),"|",1)
		s cantUnLockReason = $p(resJson.%Get("unlock"),"|",2)
        s canAutoApply = $p(resJson.%Get("autoapply"),"|",1)
		s cantAutoApplyReason = $p(resJson.%Get("autoapply"),"|",2)
		s canPatCheck = $p(resJson.%Get("patcheck"),"|",1)
		s canPatCheckReason = $p(resJson.%Get("patcheck"),"|",2)
		s canPatReCheck = $p(resJson.%Get("patrecheck"),"|",1)
		s canPatReCheckReason = $p(resJson.%Get("patrecheck"),"|",2)
		s jsonRes  = ##class(%DynamicObject).%New()
		s jsonItem.documentID = documentID
		s jsonItem.canSave =canSave
		s jsonItem.cantSaveReason =cantSaveReason
		s jsonItem.canPrint =canPrint
		s jsonItem.cantPrintReason =cantPrintReason
		s jsonItem.canDelete =canDelete
		s jsonItem.cantDeleteReason=cantDeleteReason
		s jsonItem.canCheck=canCheck
		s jsonItem.cantCheckReason=cantCheckReason
		s jsonItem.canReCheck=canReCheck
		s jsonItem.cantReCheckReason=cantReCheckReason
		s jsonItem.canRevokCheck=canRevokCheck
		s jsonItem.cantRevokCheckReason=cantRevokCheckReason
		s jsonItem.canReference=canReference
		s jsonItem.cantReferenceReason=cantReferenceReason
		s jsonItem.canExport=canExport
		s jsonItem.cantExportReason=cantExportReason
		s jsonItem.canCopyPaste=canCopyPaste
		s jsonItem.cantCopyPasteReason=cantCopyPasteReason
		s jsonItem.canRevise=canRevise
		s jsonItem.cantReviseReason=cantReviseReason
		s jsonItem.canViewRevise=canViewRevise
		s jsonItem.cantViewReviseReason=cantViewReviseReason
		s jsonItem.canCommit=canCommit
		s jsonItem.cantCommitReason=cantCommitReason
		s jsonItem.canApplyEdit=canApplyEdit
		s jsonItem.cantApplyEditReason=cantApplyEditReason
		s jsonItem.canUnLock=canUnLock
		s jsonItem.cantUnLockReason=cantUnLockReason
        s jsonItem.canAutoApply=canAutoApply
		s jsonItem.cantAutoApplyReason=cantAutoApplyReason
		s jsonItem.canPatCheck=canPatCheck
		s jsonItem.canPatCheckReason=canPatCheckReason
		s jsonItem.canPatReCheck=canPatReCheck
		s jsonItem.canPatReCheckReason=canPatReCheckReason
		d arrItem.%Push(jsonItem)
	}
	d arrItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取加载权限规则
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"LOAD_PRIVILEGE","params":{"userID":"6","ssgroupID":"28","episodeID":"713","patientID":"259","documentID":"3","userLocID":"60"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadPrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
	s objItem.userid = argInJson.params.userID
	s objItem.userloc =  argInJson.params.userLocID
	s objItem.ssgroupid =  argInJson.params.ssgroupID
	s objItem.patientid =  argInJson.params.patientID
	s objItem.admid =  argInJson.params.episodeID
	s objItem.sessionid =  argInJson.params.sessionID
	s objItem.documentid =  argInJson.params.documentID
	s objItem.productcode = argInJson.product
    s strRes = ##Class(EMR.OP.BL.PrivRule).LoadPrivilegeJson(objItem,.argOutData)
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

/// Desc:       获取加载权限规则
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.SysOption).GetPrivilegeJson(.obj)
ClassMethod LoadPrivilegeJson(aPrivRule As EMR.DOC.DTO.PrivRuleData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s documentID = aPrivRule.documentid
    ;q:(aPrivRule.userid = "")||(aPrivRule.userloc = "")||(aPrivRule.ssgroupid = "")||(aPrivRule.admid = "")||(aPrivRule.patientid = "")||(aPrivRule.documentid = "") strRes
	s resJson = ##class(%DynamicObject).%New()
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).GetPrivRuleByType(aPrivRule,"LoadPrivilege",.resJson)
	q:(strRes ["-1^") strRes
	//save^1!print^1!delete^1!check^1!recheck^0!revokcheck^0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^1!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0
	s canView = $p(resJson.%Get("view"),"|",1)
	s cantViewReason = $p(resJson.%Get("view"),"|",2)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.documentID = documentID
	s jsonItem.canView =canView
	s jsonItem.cantViewReason =cantViewReason	
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取创建权限规则
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"LOAD_PRIVILEGE","params":{"userID":"6","ssgroupID":"28","episodeID":"713","patientID":"259","documentID":"3","userLocID":"60"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreatePrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
	s objItem.userid = argInJson.params.userID
	s objItem.userloc =  argInJson.params.userLocID
	s objItem.ssgroupid =  argInJson.params.ssgroupID
	s objItem.patientid =  argInJson.params.patientID
	s objItem.admid =  argInJson.params.episodeID
	s objItem.sessionid =  argInJson.params.sessionID
	s objItem.documentid =  argInJson.params.documentID
	s objItem.templateid = argInJson.params.templateID
	s objItem.doccode = argInJson.params.docCode
	s objItem.docname = argInJson.params.docName
	s objItem.productcode = argInJson.product
    s strRes = ##Class(EMR.OP.BL.PrivRule).CreatePrivilegeJson(objItem,.argOutData)
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

/// Desc:       获取创建权限规则
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.SysOption).GetPrivilegeJson(.obj)
ClassMethod CreatePrivilegeJson(aPrivRule As EMR.DOC.DTO.PrivRuleData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s documentID = aPrivRule.documentid
    ;q:(aPrivRule.userid = "")||(aPrivRule.userloc = "")||(aPrivRule.ssgroupid = "")||(aPrivRule.admid = "")||(aPrivRule.patientid = "")||(aPrivRule.templateid = "")||(aPrivRule.doccode = "")||(aPrivRule.docname = "") strRes
	s jsonItem  = ##class(%DynamicObject).%New()
	//如果是连续性重复模板，获取的模板ID是挂靠的第一个模板ID,根据doccode和模板名称获取挂靠的模板ID（三版规则）
	;s privString = "userid^"_aPrivRule.UserID_"!userloc^"_aPrivRule.UserLocID_"!ssgroupid^"_aPrivRule.SsgroupID_"!admid^"_aPrivRule.EpisodeID_"!patientid^"_aPrivRule.PatientID_"!documentid^!templateid^"_aPrivRule.TemplateID_"!doccode^"_aPrivRule.DocCode_"!docname^"_aPrivRule.DocName
	s resJson = ##class(%DynamicObject).%New()
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).GetPrivRuleByType(aPrivRule,"CreatePrivilege",.resJson)
	q:(strRes ["-1^") strRes
	//save^1!print^1!delete^1!check^1!recheck^0!revokcheck^0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^1!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0
	s canNew = $p(resJson.%Get("new"),"|",1)
	s cantNewReason = $p(resJson.%Get("new"),"|",2)
	s jsonRes  = ##class(%DynamicObject).%New()
	s jsonItem.documentID = documentID
	s jsonItem.canNew =canNew
	s jsonItem.canNewReason =cantNewReason	
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取浏览权限规则
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"BROWSE_PRIVILEGE","params":{"userID":"6","ssgroupID":"28","episodeID":"713","patientID":"259","documentID":"3","userLocID":"60"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBrowsePrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
	s objItem.userid = argInJson.params.userID
	s objItem.userloc =  argInJson.params.userLocID
	s objItem.ssgroupid =  argInJson.params.ssgroupID
	s objItem.patientid =  argInJson.params.patientID
	s objItem.admid =  argInJson.params.episodeID
	s objItem.sessionid =  argInJson.params.sessionID
	s objItem.documentid =  argInJson.params.documentID
	s objItem.templateid = argInJson.params.templateID
	s objItem.doccode = argInJson.params.docCode
	s objItem.docname = argInJson.params.docName
	s objItem.productcode = argInJson.product
    s strRes = ##Class(EMR.OP.BL.PrivRule).GetBrowsePrivilegeJson(objItem,.argOutData)
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

/// Desc:       获取浏览权限规则
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.SysOption).GetPrivilegeJson(.obj)
ClassMethod GetBrowsePrivilegeJson(aPrivRule As EMR.DOC.DTO.PrivRuleData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s documentID = aPrivRule.documentid
    ;q:(aPrivRule.userid = "")||(aPrivRule.userloc = "")||(aPrivRule.ssgroupid = "")||(aPrivRule.admid = "")||(aPrivRule.patientid = "")||(aPrivRule.templateid = "")||(aPrivRule.doccode = "")||(aPrivRule.docname = "") strRes
	s jsonItem  = ##class(%DynamicObject).%New()
	//如果是连续性重复模板，获取的模板ID是挂靠的第一个模板ID,根据doccode和模板名称获取挂靠的模板ID（三版规则）
	;s privString = "userid^"_aPrivRule.UserID_"!userloc^"_aPrivRule.UserLocID_"!ssgroupid^"_aPrivRule.SsgroupID_"!admid^"_aPrivRule.EpisodeID_"!patientid^"_aPrivRule.PatientID_"!documentid^!templateid^"_aPrivRule.TemplateID_"!doccode^"_aPrivRule.DocCode_"!docname^"_aPrivRule.DocName
	s resJson = ##class(%DynamicObject).%New()
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).GetPrivRuleByType(aPrivRule,"BrowsePrivilege",.resJson)
	q:(strRes ["-1^") strRes
	//save^1!print^1!delete^1!check^1!recheck^0!revokcheck^0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^1!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0
	s canView = $p(resJson.%Get("view"),"|",1)
	s cantViewReason = $p(resJson.%Get("view"),"|",2)
	s jsonRes  = ##class(%DynamicObject).%New()
	s jsonItem.canView =canView
	s jsonItem.cantViewReason =cantViewReason	
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       门诊历史病历引用权限
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"QUOTE_PRIVILEGE","params":{"userID":"6","ssgroupID":"28","episodeID":"713","patientID":"259","documentID":"3","userLocID":"60"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetQuotePrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
	s objItem.userid = argInJson.params.userID
	s objItem.userloc =  argInJson.params.userLocID
	s objItem.ssgroupid =  argInJson.params.ssgroupID
	s objItem.patientid =  argInJson.params.patientID
	s objItem.admid =  argInJson.params.episodeID
	s objItem.sessionid =  argInJson.params.sessionID
	s objItem.documentid =  argInJson.params.documentID
	s objItem.templateid = argInJson.params.templateID
	s objItem.doccode = argInJson.params.docCode
	s objItem.docname = argInJson.params.docName
	s objItem.productcode = argInJson.product
    s strRes = ##Class(EMR.OP.BL.PrivRule).GetQuotePrivilegeJson(objItem,.argOutData)
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

/// Desc:       门诊历史病历引用权限
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.SysOption).GetPrivilegeJson(.obj)
ClassMethod GetQuotePrivilegeJson(aPrivRule As EMR.DOC.DTO.PrivRuleData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s documentID = aPrivRule.documentid
    ;q:(aPrivRule.userid = "")||(aPrivRule.userloc = "")||(aPrivRule.ssgroupid = "")||(aPrivRule.admid = "")||(aPrivRule.patientid = "")||(aPrivRule.templateid = "")||(aPrivRule.doccode = "")||(aPrivRule.docname = "") strRes
	s jsonItem  = ##class(%DynamicObject).%New()
	//如果是连续性重复模板，获取的模板ID是挂靠的第一个模板ID,根据doccode和模板名称获取挂靠的模板ID（三版规则）
	;s privString = "userid^"_aPrivRule.UserID_"!userloc^"_aPrivRule.UserLocID_"!ssgroupid^"_aPrivRule.SsgroupID_"!admid^"_aPrivRule.EpisodeID_"!patientid^"_aPrivRule.PatientID_"!documentid^!templateid^"_aPrivRule.TemplateID_"!doccode^"_aPrivRule.DocCode_"!docname^"_aPrivRule.DocName
	s resJson = ##class(%DynamicObject).%New()
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).GetPrivRuleByType(aPrivRule,"ActionPrivilege",.resJson)
	q:(strRes ["-1^") strRes
	//save^1!print^1!delete^1!check^1!recheck^0!revokcheck^0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^1!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0
	s canQuote = $p(resJson.%Get("quote"),"|",1)
	s cantQuoteReason = $p(resJson.%Get("quote"),"|",2)
	s jsonRes  = ##class(%DynamicObject).%New()
	s jsonItem.canquote =canQuote
	s jsonItem.cantquoteReason =cantQuoteReason	
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

}
