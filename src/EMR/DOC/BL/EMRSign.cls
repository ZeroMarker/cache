/// 名称:	EMR.DOC.BL.EMRSign
/// 描述:	签名操作业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRSign Extends EMR.DOC.COM.ActionBase
{

/// Desc:       验证系统签名用户,返回用户信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userCode":"YS01","hospitalID":"1","password":"1","userID":"6","userLocID":"6","episodeID":"719"},"product":"OP","action":"GET_USERINFO"}
/// 			userID 用户ID,userCode 用户工号，hospitalID 院区ID，password 用户密码，userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUserInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.SignUser).%New()
	s objItem.Product = argInJson.product
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserID = argInJson.params.userID
	s objItem.Password = argInJson.params.password
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetUserInfoJson(objItem,.argOutData)
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

/// Desc:       验证系统签名用户,返回用户信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUser 签名用户对象
/// Output:     UserID,UserName,签名图
/// Return:     成功 1，失败 -1^失败信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetUserInfoJson("","")
ClassMethod GetUserInfoJson(aUser As EMR.DOC.DTO.SignUser, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aUser.UserCode = "") "-1^用户工号不能为空"
	
	k PLIST	
	s:(aUser.UserID="") aUser.UserID = ##class(EMR.DOC.BL.UserData).GetUserId(aUser.UserCode,aUser.Product,aUser.HospitalID)
	q:(aUser.UserID = "") "-1^获取用户ID失败"
	s objUser=##class(User.SSUser).%OpenId(aUser.UserID,0)
	q:(objUser="") "-1^获取用户失败"
    s userName = objUser.SSUSRName
	///验证用户
	if (aUser.Password '= "")
	{
		s loginValid = ##class(EMR.DOC.BL.UserData).IsLogonValid(aUser.UserCode,aUser.Password,aUser.Product,aUser.HospitalID)	
		q:(loginValid = 0) "-1^用户校验失败"
	}
	s signType = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("signType",aUser.Product,"Text")
    
	s image = ""
	if (signType = "Graph")
	{
		s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(aUser.UserID)
		if (info '= "") && (info.SignImage '= "") 
		{
			s image = $Replace($ZSTRIP(info.SignImage,"*C")," ","")
		}
	}
	
    //判断CA是否开启，最新的程序增加产品模块的判断
    s isSignGraphNoCA = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isSignGraphNoCA",aUser.Product,"Y")
    s IsCACTLoc = ##Class(EMR.DOC.BL.CASservice).IsCACTLoc(aUser.UserLocID,aUser.UserID,"",aUser.Product) 
    s IsCAUser = 1
    if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.UsrInUseInfo||GetInUsedByUserID") = 1)
    {
        s InUse = ##class(CA.UsrInUseInfo).GetInUsedByUserID(aUser.UserID)
        s:(InUse = 1) IsCAUser = 0
    }
    s:((isSignGraphNoCA = "N")&&((IsCACTLoc = 0)||(IsCAUser = 0))) signType = "Text"
    
    s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUser.UserID,aUser.EpisodeID,aUser.UserLocID,aUser.Product,aUser.LangID)
    s signLevel = $p(userLevel,"^",1)
    q:(signLevel="") "-1^请先维护用户级别!"
	s levelName = $p(userLevel,"^",2)
	s roleLevel = $p(userLevel,"^",3)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.id=aUser.UserID
	s jsonItem.name=userName
	s jsonItem.signLevel = signLevel
	s jsonItem.levelName = levelName
	s jsonItem.roleLevel = roleLevel
	s jsonItem.signSrc = image
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       验证CA签名用户,返回用户信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userCode":"YS01","userCertCode":"1050","certNo":"105","userID":"6","userLocID":"6","hospitalID":"1","episodeID":"719"},"product":"OP","action":"GET_CAUSERINFO"}
/// 			userID 用户ID,userCode 用户工号，userCertCode 用户证书标识，certNo 证书编码， hospitalID 院区ID，password 用户密码，userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCAUserInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.SignUser).%New()
	s objItem.Product = argInJson.product
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserID = argInJson.params.userID
	s objItem.UserCertCode = argInJson.params.userCertCode
	s objItem.CertNo = argInJson.params.certNo
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson(objItem,.argOutData)
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

/// Desc:       验证CA签名用户,返回用户信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUser 签名用户对象
/// Output:     UserID,UserName,level
/// Return:     成功 1，失败 -1^失败信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson("","")
ClassMethod GetCAUserInfoJson(aUser As EMR.DOC.DTO.SignUser, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aUser.UserCode = "") "-1^用户工号不能为空"
    q:(aUser.UserCertCode = "") "-1^未获取到用户证书标识"
    q:(aUser.CertNo = "") "-1^未获取到证书编码"
	
	k PLIST	
	s:(aUser.UserID="") aUser.UserID = ##class(EMR.DOC.BL.UserData).GetUserId(aUser.UserCode,aUser.Product,aUser.HospitalID)
	q:(aUser.UserID = "") "-1^获取用户ID失败"
	s objUser=##class(User.SSUser).%OpenId(aUser.UserID,0)
	q:(objUser="") "-1^获取用户失败"
    s userName = objUser.SSUSRName
 
	s signType = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("signType",aUser.Product,"Text")
	s info = ##Class(CA.UsrSignatureInfo).GetActiveBindInfoByCert(aUser.UserCertCode,aUser.CertNo)
	s image = ""
	s:(info'="") image = $Replace($ZSTRIP(info.SignImage,"*C")," ","")
	
	
    //判断CA是否开启，最新的程序增加产品模块的判断
    s isSignGraphNoCA = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isSignGraphNoCA",aUser.Product,"Y")
    s IsCACTLoc = ##Class(EMR.DOC.BL.CASservice).IsCACTLoc(aUser.UserLocID,aUser.UserID,"",aUser.Product) 
    s IsCAUser = 1
    if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.UsrInUseInfo||GetInUsedByUserID") = 1)
    {
        s InUse = ##class(CA.UsrInUseInfo).GetInUsedByUserID(aUser.UserID)
        s:(InUse = 1) IsCAUser = 0
    }
    s:((isSignGraphNoCA = "N")&&((IsCACTLoc = 0)||(IsCAUser = 0))) signType = "Text"
    
    s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUser.UserID,aUser.EpisodeID,aUser.UserLocID,aUser.Product,aUser.LangID)
    s signLevel = $p(userLevel,"^",1)
    q:(signLevel="") "-1^请先维护用户级别!"
	s levelName = $p(userLevel,"^",2)
	s roleLevel = $p(userLevel,"^",3)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.id=aUser.UserID
	s jsonItem.name=userName
	s jsonItem.signLevel = signLevel
	s jsonItem.levelName = levelName
	s jsonItem.roleLevel = roleLevel
	s jsonItem.signSrc = image
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       获取签名角色(签名、撤销签名)
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"oriSignatureLevel":"Check","episodeID":"719","userCode":"YS01","userLocID":"6","hospitalID":"1"},"product":"OP","action":"GET_SIGN_CHARACTER"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSignCharacter(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.SignUser).%New()
	s objItem.Product = argInJson.product
	s objItem.OriSignatureLevel = argInJson.params.oriSignatureLevel
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetSignCharacterJson(objItem,.argOutData)
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

/// Desc:       获取签名角色(签名、撤销签名)
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUser 签名用户对象
/// Output:     characterCode 最高级别(EMRmeta.SignRole表的RoleLevel最高)签名角色代码（EMRmeta.SignRole表的Name）
///             characterDesc 最高级别签名角色描述（EMRmeta.SignRole表的Description）
///             characterRange 签名角色范围
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson("","")
ClassMethod GetSignCharacterJson(aUser As EMR.DOC.DTO.SignUser, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aUser.UserCode = "") "-1^用户工号不能为空"
	q:(aUser.EpisodeID = "") "-1^就诊号不能为空"
	q:(aUser.UserLocID = "") "-1^科室ID不能为空"
    q:(aUser.OriSignatureLevel = "") "-1^签名角色编码不能为空"
    
    s:(aUser.UserID="") aUser.UserID = ##class(EMR.DOC.BL.UserData).GetUserId(aUser.UserCode,aUser.Product,aUser.HospitalID)
    q:(aUser.UserID = "") "-1^获取用户ID失败"
    s objUser=##class(User.SSUser).%OpenId(aUser.UserID,0)
	q:(objUser="") "-1^获取用户失败"
    s userName = objUser.SSUSRName
 	s characterRange = ##Class(EMR.DOC.BL.SignRole).GetSignCharacter(aUser)
 	q:(characterRange["-1^") characterRange
 	s jsonRange = ##class(%DynamicAbstractObject).%FromJSON(characterRange)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.name=userName
	s jsonItem.levelRange = jsonRange
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       获取文档签名角色(签名失效、留痕)
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"33","episodeID":"719","userCode":"YS01","userLocID":"6","hospitalID":"1"},"product":"OP","action":"GET_SIGN_DOCCHARACTER"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSignDocCharacter(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.SignUser).%New()
	s objItem.Product = argInJson.product
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetSignDocCharacterJson(objItem,.argOutData)
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

/// Desc:       获取文档签名角色(签名失效、留痕)
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUser 签名用户对象
/// Output:     UserID,UserName,level
///             characterCode 最高级别(EMRmeta.SignRole表的RoleLevel最高)签名角色代码（EMRmeta.SignRole表的Name）
///             characterDesc 最高级别签名角色描述（EMRmeta.SignRole表的Description）
///             characterRange 签名角色范围
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson("","")
ClassMethod GetSignDocCharacterJson(aUser As EMR.DOC.DTO.SignUser, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aUser.UserCode = "") "-1^用户工号不能为空"
	q:(aUser.EpisodeID = "") "-1^就诊号不能为空"
	q:(aUser.UserLocID = "") "-1^科室ID不能为空"
    q:(aUser.DocumentID = "") "-1^文档ID不能为空"
    s:(aUser.UserID="") aUser.UserID = ##class(EMR.DOC.BL.UserData).GetUserId(aUser.UserCode,aUser.Product,aUser.HospitalID)
    q:(aUser.UserID = "") "-1^获取用户ID失败"
    s objUser=##class(User.SSUser).%OpenId(aUser.UserID,0)
	q:(objUser="") "-1^获取用户失败"
    s userName = objUser.SSUSRName
 	s signCharacterInfo = ##Class(EMR.DOC.BL.SignRole).GetDocSignCharacter(aUser)
 	s signLevel = $p(signCharacterInfo,"^",1)
	s levelName = $p(signCharacterInfo,"^",2)
	s roleLevel = $p(signCharacterInfo,"^",3)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.name =userName
	s jsonItem.signLevel = signLevel
	s jsonItem.levelName = levelName
	s jsonItem.roleLevel = roleLevel
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       判断是否上级医师已签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userLevel":"Resident","documentID":"251"},"product":"OP","action":"IS_SUPERIORSIGN"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod IsSuperiorSign(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strDocumentID = argInJson.params.documentID
	s strUserLevel = argInJson.params.userLevel
    s strRes = ##Class(EMR.DOC.BL.EMRSign).IsSuperiorSignJson(strUserLevel,strDocumentID,.argOutData)
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

/// Desc:       判断是否上级医师已签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUserLevel 角色编码
/// 			aDocumentID 文档ID
/// Output:    1：上级已签名  0：上级未签名   
///            
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson("","")
ClassMethod IsSuperiorSignJson(aUserLevel As %String, aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aUserLevel = "")||(aDocumentID = "") "-1^文档ID、角色等级不能为空"
	s isMark = "0"
	s signLevel = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(aUserLevel)
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s aEpisodeID = objDoc.EpisodeID.%Id()
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aEpisodeID)
	s signID = ""
	for
	{
		s signID = $o(@TILEMRSign@("IdxDocument",aDocumentID,signID))
		q:(signID = "")
		s signObj = ##Class(EMR.DAO.EMRSign).doOpenByID(aEpisodeID,signID)
		q:(signObj = "")
		continue:(signObj.isValid '= "1")
		s action = signObj.Action
		continue:(action = "")
		s roleID = $o(^CF.EMR.DOC.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(roleID = "")
		s roleObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(roleID)
		continue:(roleObj = "")
		s tmpLevel = roleObj.RoleLevel
		if (tmpLevel > signLevel)
		{
			s isMark = "1"
			q
		}
	}
   	d argOutData.Write(isMark)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       检查签名权限脚本
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"action":"CHECK_PRIVILEGE","params":{"userID":"17276","signLevel":"Resident","signUserID":"","signedLength":0,"allSignLevel":[],"oriSignatureLevel":"Resident","documentID":"807","logonUserID":"18881","elementCode":"SI1684328120639"},"product":"IP"}
/// 			userID 用户ID,signLevel 签名单元最后签名的signLevel,oriSignatureLevel 签名角色编码,allSignLevel 签名单元上所有签名的角色,signUserID 签名单元最后的签名userID,signedLength 签名单元上签名的个数
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CheckPrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.SignCheck).%New()
	s objItem.Product = argInJson.product
	s objItem.UserID = argInJson.params.userID
	s objItem.SignLevel = argInJson.params.signLevel
	s objItem.OriSignLevel = argInJson.params.oriSignatureLevel
	s objItem.SignUserID = argInJson.params.signUserID
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.SignedLength = argInJson.params.signedLength
	s objItem.AllSignLevel = argInJson.params.allSignLevel
	s objItem.LogonUserID = argInJson.params.logonUserID
	s objItem.ElementCode = argInJson.params.elementCode
	
    s strRes = ##Class(EMR.DOC.BL.EMRSign).CheckPrivilegeJson(objItem,.argOutData)
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

/// Desc:       检查签名权限脚本
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aSignCheck:签名检查对象
/// Output:     成功："Append" 签名/ "Replace" 改签/无权限或者无需签名的时候返回具体原因
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetCAUserInfoJson("","")
ClassMethod CheckPrivilegeJson(aSignCheck As EMR.DOC.DTO.SignCheck, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aSignCheck.UserID = "")||(aSignCheck.SignLevel = "")||(aSignCheck.OriSignLevel = "")||(aSignCheck.DocumentID="") "-1^用户ID、签名角色、签名编码、文档ID不能为空"
	if (aSignCheck.OriSignLevel = "Check")
	{
		s highSignInfo = ##Class(EMR.DOC.BL.SignRole).GetHighSignLevel(aSignCheck.AllSignLevel)
		s highSignLevel = $p(highSignInfo, "^", 1)
		s highSignUserID = $p(highSignInfo, "^", 2)
		
		if (aSignCheck.SignedLength = "0")
		{
			s strRes = "1"
		}
		else
		{
			s charactorRoleLevel = ##Class(EMR.DOC.BL.SignRole).GetSignLevel(aSignCheck.SignLevel)
			s signRoleLevel = ##Class(EMR.DOC.BL.SignRole).GetSignLevel(highSignLevel)
			if (charactorRoleLevel > signRoleLevel)
			{
				s strRes = "1"
			}
			elseif(charactorRoleLevel = signRoleLevel)
			{
				
				s strRes = "-1^已签名,不必再签"	
			}
			else
			{
				s strRes = "-1^无权限签名"
			}
		}
	}
	else
	{
		if (aSignCheck.SignLevel = aSignCheck.OriSignLevel)
		{
			if (aSignCheck.SignedLength = 0)
			{
				//签名
				s strRes = "1"
			}
			else
			{
				s strRes = "-1^已签名,不必再签"
			}
		}
		elseif(aSignCheck.OriSignLevel = "ALL") //参与者都可以签
		{
			//签名
			s strRes = "1"
		}
		else
		{
			s strRes = "-1^无权限签名"
		}
	}
	s templateFlag = ##Class(EMR.DOC.BL.TemplateSign).CheckTemplateSign(aSignCheck)
	s:(templateFlag [ "0^") strRes="-1^"_$p(templateFlag,"^",2)
	
   	d:(strRes'["-1^") argOutData.Write(strRes)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       获取签名文档信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"33"},"product":"OP","action":"GET_RECORDINFO"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRecordInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s strDocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetRecordInfoJson(strDocumentID,.argOutData)
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
/// Input:      aDocumentID:文档ID
/// Output:     成功：签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetRecordInfoJson("","")
ClassMethod GetRecordInfoJson(aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aDocumentID = "") "-1^文档ID不能为空"
	
	s obj = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	s episodeID = obj.EpisodeID.%Id()
    s patientID = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
    s name = ##class(EMR.DOC.HISInterface.PatientInfoAssist).Name(patientID)
    s objTemCat = obj.TemplateCategoryID
    q:(objTemCat="") "-1^获取文档目录信息失败"
	s recordID = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objTemCat)
	q:(recordID="") "-1^获取文档目录信息失败"
	s objRecord =##Class(CF.EMR.DOC.TemplateCategory).%OpenId(recordID)
	s objRecordC =##Class(CF.EMR.DOC.TemplateCategory).%OpenId(objRecord.ParentID)
	q:(objRecordC="") "-1^获取文档目录信息失败"
	s subject = "姓名："_name_" 病历信息："_objRecordC.EMRName_"."_objRecord.EMRName_"."_obj.DOCName_" "_$zd(obj.HappenDate,3)_" "_$zt(obj.HappenTime,1)
    s jsonItem = ##class(%DynamicObject).%New()
    s jsonItem.subject=subject
    s jsonItem.product="EMR"
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
    d argOutData.Write(..#NONE)
	q "-1^"_$zerror
}

/// Desc:       保存签名信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aItem 签名对象
/// 			argInData 签名原文
/// Output:     成功：签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).SetMERSign("","")
ClassMethod SetMERSign(aItem As EMR.DOC.DTO.SignData, argInData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	//如果有失效签名，则先失效后保存
	if (aItem.InvalidCode'="")
	{
		s strRes = ##class(EMR.DOC.BL.EMRSign).RevokeSign(aItem.EpisodeID,aItem.DocumentID,aItem.ListNo,aItem.InvalidCode)
		q:(strRes["-1^") strRes
	}
	s strRes = ##class(EMR.DOC.BL.EMRSign).SaveEMRSign(aItem,argInData)
	q strRes
}

/// Desc:       失效签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aEpisodeID 就诊号
/// 			aDocumentID 文档ID
/// 			aListNo 文档顺序号
/// 			aInvalidCode 失效编码
/// Output:     成功：1^签名ID^日志ID
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).SetMERSign("","")
ClassMethod RevokeSign(aEpisodeID As %String, aDocumentID As %String, aListNo As %String, aInvalidCode As %String) As %String
{
	s strRes = "-1^失效签名失败"
	q:((aEpisodeID = "")||(aDocumentID = "")||(aListNo = "")||(aInvalidCode = "")) "-1^失效签名失败，参数有误"
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aEpisodeID)
	s rowId = $o(@TILEMRSign@("IdxCode",aDocumentID," "_aListNo," "_$zcvt(aInvalidCode,"U"),""))
	q:(rowId="") "-1^根据失效编码获取签名数据失败"
	s objEMRSign = ##Class(EMR.DAO.EMRSign).doOpenByID(aEpisodeID,rowId)
	//已经失效，返回1和ID
	q:(objEMRSign.isValid=0) "1^"_objEMRSign.%Id()
	s objEMRSign.isValid = "0"
	s sc = objEMRSign.%Save()
	q:$$$ISERR(sc) "-1^失效签名,更新状态失败"
	
	s strResLog = ##Class(EMR.DOC.BL.EMRSign).SaveEMRSignLog(objEMRSign)	
	q:(strResLog["-1^") strResLog
	s strRes ="1^"_objEMRSign.%Id()_"^"_$p(strResLog,"^",2)
  	q strRes
}

/// Desc:       保存签名信息
/// Creator:    Candy
/// CreateDate: 2014-7-25
/// Input:      aItem 签名对象
/// 			argInData 签名原文
/// Output:     成功：1^签名ID
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).SaveEMRSign("")
ClassMethod SaveEMRSign(aItem As EMR.DOC.DTO.SignData, argInData As %GlobalBinaryStream) As %String
{
	s strRes = "0"
	q:((aItem.EpisodeID = "")||(aItem.DocumentID = "")||(aItem.SignUserID = "")||(aItem.ActionCode = "")) "-1^保存签名失败，参数有误"
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aItem.EpisodeID)
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDocument="") "-1^根据文档ID获取文档失败"
	s objSignUser = ##class(User.SSUser).%OpenId(aItem.SignUserID,0)
	q:(objSignUser="") "-1^根据签名用户ID获取用户信息失败"
	s objUserLoc = ##class(User.CTLoc).%OpenId(aItem.UserLocID,0)
	q:(objUserLoc="") "-1^根据科室ID获取科室信息失败"
	
	s rowId = $o(@TILEMRSign@("IdxCode",aItem.DocumentID," "_aItem.ListNo," "_$zcvt(aItem.Code,"U"),""))
	if (rowId '= "" )
	{
		s objEMRSign = ##Class(EMR.DAO.EMRSign).doOpenByID(aItem.EpisodeID,rowId)
	}
	else
	{
		s objEMRSign = ##Class(EMR.DAO.EMRSign).doCreateInstance(aItem.EpisodeID)
	}
	q:(objEMRSign = "") strRes	
	s objEMRSign = ##Class(EMR.DAO.EMRSign).doCreateInstance(aItem.EpisodeID)
	s objEMRSign.Action = aItem.ActionCode
	s objEMRSign.DOCCategoryCode = objDocument.DOCCategoryCode
	s objEMRSign.DOCCode = aItem.DOCCode
	s objEMRSign.ElementCode = aItem.ElementCode
	s objEMRSign.Code = aItem.Code
	s objEMRSign.ListNo = aItem.ListNo
	s objEMRSign.EpisodeID = objDocument.EpisodeID
	s objEMRSign.UsrID = objSignUser
	s objEMRSign.DocumentID = objDocument
	s objEMRSign.SignDate = aItem.SignDate
	s objEMRSign.SignTime = aItem.SignTime
	s objEMRSign.Type = aItem.Type
	s objEMRSign.SignID = aItem.SignID
	s objEMRSign.isValid = 1 
	s objEMRSign.UsrLoginLocID = objUserLoc
	//摘要信息为文档压缩后，再生成的摘要
	s objEMRSign.Digest = aItem.Digest
	s sc = objEMRSign.%Save()
	if $$$ISOK(sc) 
	{ 
		//保存签名日志，失败 -1^失败信息，成功 1^日志ID
		s strResLog = ##Class(EMR.DOC.BL.EMRSign).SaveEMRSignLog(objEMRSign)	
		q:(strResLog["-1^") strResLog
		
		s strRes ="1^"_objEMRSign.%Id()_"^"_$P(strResLog,"^",2)
	}
	else
	{
		Do DecomposeStatus^%apiOBJ(sc,.errors,"d")
		s strRes ="-1^保存签名失败"_errors
	}
    q strRes
}

/// Desc:       保存签名历史
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      AEMRSign 签名数据
/// Output:     成功：1^签名ID
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).SaveEMRSignLog("")
ClassMethod SaveEMRSignLog(AEMRSign) As %String
{
	s strRes = "-1^保存签名日志失败"
	q:(AEMRSign = "") "-1^保存签名日志参数有误"
	s objEMRSingLog = ##Class(EMR.DAO.EMRSignLog).doCreateInstance(AEMRSign.EpisodeID.%Id())
	s objEMRSingLog.EMRSignID = AEMRSign
	s objEMRSingLog.Action = AEMRSign.Action
	s objEMRSingLog.Type = AEMRSign.Type
	s objEMRSingLog.DOCCode = AEMRSign.DOCCode
	s objEMRSingLog.DOCCategoryCode = AEMRSign.DOCCategoryCode
	s objEMRSingLog.Code = AEMRSign.Code
	s objEMRSingLog.ElementCode = AEMRSign.ElementCode
	s objEMRSingLog.ListNo = AEMRSign.ListNo
	s objEMRSingLog.EpisodeID = AEMRSign.EpisodeID
	s objEMRSingLog.DocumentID = AEMRSign.DocumentID
	s objEMRSingLog.isValid = AEMRSign.isValid
	s objEMRSingLog.SignDate = AEMRSign.SignDate
	s objEMRSingLog.SignTime = AEMRSign.SignTime
	s objEMRSingLog.SignID = AEMRSign.SignID
	s objEMRSingLog.UsrID = AEMRSign.UsrID
	s objEMRSingLog.UsrLoginLocID = AEMRSign.UsrLoginLocID
	s objEMRSingLog.Digest = AEMRSign.Digest
	s:($$$ISOK(objEMRSingLog.%Save())) strRes = "1^"_objEMRSingLog.%Id()
	q strRes
}

/// Desc:       获取患者签名角色信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"oriSignatureLevel":"Patient"},"product":"OP","action":"GET_PATIENTSIGNINFO"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPatientSignInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s oriSignatureLevel = argInJson.params.oriSignatureLevel
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRSign).GetPatientSignInfoJson(oriSignatureLevel,LangID,.argOutData)
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

/// Desc:       获取患者签名角色信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aDocumentID:文档ID
/// Output:     成功：签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetRecordInfoJson("","")
ClassMethod GetPatientSignInfoJson(aOSignLevel As %String, aLangID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aOSignLevel = "") "-1^签名角色不能为空"
	s rowId  = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(aOSignLevel,"U"),""))
	s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	q:(obj = "") "-1^签名角色未找到签名对象"
	s roleLevel = ##Class(EMR.DOC.BL.SignRole).GetSignLevel(aOSignLevel)
	s levelName = ##Class(EMR.DOC.BL.SignRole).GetSignDesc(aOSignLevel,aLangID)
    s jsonItem = ##class(%DynamicObject).%New()
	s jsonItem.signLevel = aOSignLevel
	s jsonItem.levelName = levelName
	s jsonItem.roleLevel = roleLevel
	s jsonItem.name = aOSignLevel
   	d jsonItem.%ToJSON(argOutData)
   	q strRes
Error 
	q "-1^"_$zerror
}

/// Desc:       验证签名
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"documentID":"33"},"product":"OP","action":"VERIFY_SIGNED_DATA"}
/// 			documentID: 文档ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod VerifySignedData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s documentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.EMRSign).VerifySignedDataJson(documentID,strProduct,.argOutData)
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

/// Desc:       获取患者签名角色信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aDocumentID:文档ID
/// 			aProduct:项目标识
/// Output:     成功：签名文档信息
///             失败：-1^错误信息
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetRecordInfoJson("","")
ClassMethod VerifySignedDataJson(aDocumentID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = "1"
	q:(aDocumentID = "") "-1^验证签名失败：病历实例ID为空"
	
	s signInfo =  ##Class(EMR.DOC.BL.EMRSign).GetSignInfoByInsID(aDocumentID)
	q:($p(signInfo,"^",1) = "-1") "-1^验证签名失败："_$p(signInfo,"^",2)
	
	s signID = $p(signInfo, "^" ,1)
	s digest = $p(signInfo, "^" ,2)
	s ret = ##Class(EMR.DOC.BL.CASservice).GetVerifySignResult(signID,digest)
	q:(ret["-1^") ret
	
   	d argOutData.Write(""""_ret_"""")
   	q strRes
Error 
	q "-1^"_$zerror
}

/// Desc:       获取最后一次有效的CA签名信息
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aDocumentID:文档ID
/// Output:     成功：签名文档信息
///             失败：-1^错误信息
///             查询到返回SignID->CA.DigitalSignature的rowID^摘要数据
/// Debug:      w  ##Class(EMR.DOC.BL.EMRSign).GetSignInfoByInsID("13||10")
ClassMethod GetSignInfoByInsID(aDocumentID As %String) As %String
{
	s strRes= ""
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^病历数据查询异常"
	
	s EpisodeID = objDoc.EpisodeID.%Id() 
	s TILEMRSignLog = ##class(EMR.DAO.EMRSignLog).GetTureIndexLocation(EpisodeID)
	s rowId = $o(@TILEMRSignLog@("IdxDocument",aDocumentID,""),-1) 
	q:(rowId = "") "-1^未查询到有效的CA签名记录"
	
	s objEMRSingLog = ##Class(EMR.DAO.EMRSignLog).doOpenByID(EpisodeID,rowId)
	q:(objEMRSingLog = "") "-1^未查询到有效的CA签名记录"
	
	s isValid = objEMRSingLog.isValid
	q:(isValid = 0) "-1^未查询到有效的CA签名记录"
	
	s signID = objEMRSingLog.SignID
	q:(signID = "") "-1^未查询到有效的CA签名记录"
	
	s signData = ##Class(%GlobalBinaryStream).%New()
	s temSignData = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDoc.DocumentStream.DocumentData)
	d signData.CopyFrom(temSignData)
	d signData.Rewind()	
	q:(signData.Size < 10) "-1^病历签名数据获取异常"
	s signmd5 = ##class(EMR.DOC.COM.EncryptionTool).GetMD5HashData(signData)
	q:(signmd5["-1^") "-1^对病历数据做摘要失败"
	q:(signmd5 = "") "-1^病历摘要为空"
	
	s strRes = signID_"^"_signmd5
	q strRes
}

/// Desc:       获取病历是否有CA有效签名
/// Creator:    yejian
/// CreateDate: 2023-5-13
/// Input:      aDocumentID 病历ID
///             AType: Doctor 医生/Patient 患者
/// Output:     1 有/0 无
/// Debug:      w ##Class(EMR.DOC.BL.EMRSign).GetIsSignCAByType("223","Doctor")
ClassMethod GetIsSignCAByType(aDocumentID As %String, AType As %String) As %String
{
	s result = "0"
	q:(aDocumentID = "")||(AType = "") result
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^病历数据查询异常"
	
	s EpisodeID = objDoc.EpisodeID.%Id() 
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(EpisodeID)
	s rowId = $o(@TILEMRSign@("IdxDocument",aDocumentID,""),-1) 
	q:(rowId = "") result
	s rowId = ""
	for
	{
		s rowId = $o(@TILEMRSign@("IdxDocument",aDocumentID,rowId))
		q:(rowId = "")
		s objEmrsign = ##Class(EMR.DAO.EMRSign).doOpenByID(EpisodeID,rowId)
		continue:(objEmrsign = "")
		continue:(objEmrsign.isValid '= "1")
		continue:(objEmrsign.Type '= "CA")
		if (AType = "Patient")
		{
			continue:(objEmrsign.Action '= "patientSign")
		}
		else
		{
			continue:(objEmrsign.Action = "patientSign")
		}
		s result = "1"
		q
	}
	q result
}

}
