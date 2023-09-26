/// 名称:	EMR.DOC.BL.UserMessage
/// 描述:	用户信息服务
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.DOC.BL.UserMessage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取病历状态信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CURRENT_STATUS","params":{"DiseaseID":"0","EpisodeID":"57","HospitalID":"2","IPAddress":"192.168.1.100","documentID":["3"],"PatientID":"54","ProductSourceCode":"","ProductSourceType":"EMR","SessionID":"r3fg4vxMCx","SsgroupID":"29","UserCode":"YS01","UserID":"10209","UserLocID":"95","UserName":"01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCurrentStatus(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.UserMessage).%New()
	s objItem.UserID = argInJson.params.userID
	s objItem.UserLocID =  argInJson.params.userLocID
	s objItem.SsgroupID =  argInJson.params.ssgroupID
	s objItem.PatientID =  argInJson.params.patientID
	s objItem.EpisodeID =  argInJson.params.episodeID
	s objItem.SessionID =  argInJson.params.sessionID
	s objItem.DocumentID =  argInJson.params.documentID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.UserMessage).GetCurrentStatusJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取病历状态信息
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		
/// Input: 		argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.DOC.BL.UserMessage).GetPrivilegeJson(.obj)
ClassMethod GetCurrentStatusJson(aPrivRule As EMR.DOC.DTO.UserMessage, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s arrItem = ##class(%DynamicArray).%New()
   	s DocumentIDs = aPrivRule.DocumentID
	set iter = DocumentIDs.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s DocumentID = item
		s jsonItem  = ##class(%DynamicObject).%New()
		continue:(DocumentID = "")
		s objEcrecord = ""		
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(DocumentID)
		continue:(objDocument = "")
		s curName = objDocument.DOCName
		s curSerial = objDocument.Serial
		s POperateDateTime=$case(objDocument.ModifyDate,"":"",:$zd(objDocument.ModifyDate,3)_" "_$zt(objDocument.ModifyTime,1))
		s objDocument = ""		
		s result = ##Class(EMR.DOC.BL.DocLog).GetLogStatus(aPrivRule.EpisodeID,DocumentID,aPrivRule.LangID)
		s signStatus = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(aPrivRule.EpisodeID,DocumentID)
		s jsonItem.documentID =DocumentID
		s jsonItem.creator =result.creator
		s jsonItem.happenDateTime= result.happenDateTime
		s jsonItem.operator=result.Operator
		s jsonItem.operateDateTime=result.operateDateTime
		s jsonItem.curIp=result.ip
		s jsonItem.curAction=result.action
		s jsonItem.curActionDesc=result.actionDesc
		s jsonItem.curStatus=result.status
		s jsonItem.curStatusDesc=result.statusDesc
		;s jsonItem.signName=result.signName
		s jsonItem.hasSigned=signStatus
		s jsonItem.name = curName
		s jsonItem.serial = curSerial
		s jsonItem.createDateTime=result.createDateTime
        s jsonItem.pOperateDateTime=POperateDateTime
		d arrItem.%Push(jsonItem)
	}
	d arrItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取病历的创建者信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_RECORDCREATORINFO","params":{"documentID":"3"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRecordCreatorInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strDocumentID =  argInJson.params.documentID
	s strUserID =  argInJson.params.userID
	s strProduct =  argInJson.product
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.UserMessage).GetRecordCreatorInfoJson(strDocumentID,strUserID,strProduct,LangID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取病历的创建者信息
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		EMR.DB.DocumentData
/// Input: 		aDocumentID 文档ID
/// 				strProduct 项目标识
/// 				argOutData json数据
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.DOC.BL.UserMessage).GetPrivilegeJson(.obj)
ClassMethod GetRecordCreatorInfoJson(aDocumentID As %String, aUserID As %String, strProduct As %String, aLangID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aDocumentID = "") "-1^文档ID不能为空"
	q:(aUserID="") "-1^用户ID不能为空"
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDocument = "") "-1^文档ID获取文档失败"
	s createUserID = objDocument.CreateUser.SSUSRInitials
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.creatorCode =createUserID
	s jsonItem.creatorName= objDocument.CreateUser.SSUSRName
	s jsonItem.documentStatus=objDocument.Status
	s ispasswordState = "1"
	// 获取病历是否有有效签名
	s HasValidSign = ##Class(EMR.DOC.BL.PrivAssist).HasValidSign(aDocumentID)
	// 是否开启实习生创建未签名病历删除不需要输入创建者密码
	s IsPassWordByIntern = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isPassWordByIntern",strProduct,"N")
	if ((HasValidSign = "0")&&(IsPassWordByIntern = "Y"))
	{
  		s SignLevelAndDesc = ##Class(EMR.DOC.BL.UserData).GetUserDatalevel(createUserID,aLangID)
  		if ($p(SignLevelAndDesc,"^",1) = "intern")
  		{
	  		s ispasswordState = "0"
	  	} 	
  	}
  	if (ispasswordState = "0")
  	{
	  	//获取当前登录医师的人员维护类型
  		s CurrSignLevelAndDesc = ##Class(EMR.DOC.BL.UserData).GetUserDatalevel(aUserID,aLangID)
  		// 判断当前登录的医师如果是实习医师，删除病历是需要输入密码
  		if ($p(CurrSignLevelAndDesc,"^",1) = "intern")
  		{
	  		s ispasswordState = "1"
	  	}
	}
	s jsonItem.passwordState=ispasswordState
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       用户密码校验
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"VERIFY_USER","params":{"creatorCode":"3","password":"1","hospitalID":"1"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod VerifyUser(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s creatorCode =  argInJson.params.creatorCode
	s password =  argInJson.params.password
	s hospitalID = argInJson.params.hospitalID
	s strProduct =  argInJson.product
    s strRes = ##Class(EMR.DOC.BL.UserData).IsLogonValid(creatorCode,password,strProduct,hospitalID)
	//1 获取成功
	if (strRes="1")
	{ 
		d argOutData.Write("true")
	  	q argOutMessage.success = ..#OK
	}
	elseif (strRes="0")
	{ 
		d argOutData.Write("false")
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

}
