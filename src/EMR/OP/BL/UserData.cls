/// 名称:	EMR.OP.BL.UserData
/// 描述:	门诊病历-获取用户信息（用户级别）
/// 编写者：yejian
/// 编写日期: 2022-6-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.UserData Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取用户级别信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_USER_DATA","product":"OP","params":{"userID":"10209"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUserData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userID = argInJson.params.userID
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.UserData).GetUserDataJson(userID,LangID,.argOutData)
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

/// Desc:       获取用户级别信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.UserData).GetUserDataJson("10209",.obj)
ClassMethod GetUserDataJson(aUserID As %String, aLangID As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^获取用户信息失败"
	q:(aUserID="") strRes
    s jsonItem  = ##class(%DynamicObject).%New()
    s userCode = $p($g(^SSU("SSUSR",aUserID)),"^",1)
    s userName = $p($g(^SSU("SSUSR",aUserID)),"^",2)
	s userPvId = $p($g(^SSU("SSUSR",aUserID)),"^",14)
	q:(userPvId = "")||(userCode="")||(userName="") strRes
	
	q:('$d(^CTPCP(userPvId,1))) strRes
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	q:(userCarprvtpId = "") strRes
	q:(($p(^CTPCP(userPvId,1),"^",9) '= "Y")&&($p(^CTPCP(userPvId,1),"^",9) '= "true")) strRes
	q:('$d(^CT("CPT",userCarprvtpId))) strRes
	s userCarprvtpCode = $p($g(^CT("CPT",userCarprvtpId)),"^",1)
	q:(userCarprvtpCode = "") strRes
	s signRoleID = $o(^CF.EMR.DOC.SignRoleLinkCPTI("IdxCPTSignRole"," "_$zcvt(userCarprvtpCode,"U"),""))
	q:(signRoleID = "") strRes
	s objRole = ##class(CF.EMR.DOC.SignRole).%OpenId(signRoleID)
	q:(objRole="") strRes
	s levelName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.SignRole","Description",objRole.Description,aLangID)
	s jsonItem.id =aUserID
	s jsonItem.name =userName
	s jsonItem.userCode =userCode
	s jsonItem.level =objRole.Name
	s jsonItem.levelName =levelName
	d jsonItem.%ToJSON(argOutData)
	q "1"
}

}
