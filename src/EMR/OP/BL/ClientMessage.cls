/// 名称:	EMR.OP.BL.ClientMessage
/// 描述:	门诊病历-客户端信息服务
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.OP.BL.ClientMessage Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取客户端信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetClientInfo(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s LoginID  = argInJson.params.loginID
    s strRes = ##Class(EMR.OP.BL.ClientMessage).GetClientInfoJson(LoginID,.argOutData)
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

/// Desc:       获取客户端信息
/// Creator:    yejian
/// CreateDate: 2022-4-1
/// Table:		
/// Input: 		argOutData json数据
/// Output:     成功：1，失败 -1^失败信息
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 		q ##Class(EMR.OP.BL.UserMessage).GetPrivilegeJson(.obj)
ClassMethod GetClientInfoJson(aLoginID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	//IP地址^会话ID^在线状态^计算机名^计算机MAC
	s strData = ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetClientInfo(aLoginID)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.ipAddress =$p(strData,"^",1)
	s jsonItem.clientID =$p(strData,"^",2)
	s jsonItem.computerStatus= $p(strData,"^",3)
	s jsonItem.computerName=$p(strData,"^",4)
	s jsonItem.computerMac=$p(strData,"^",5)
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

}
