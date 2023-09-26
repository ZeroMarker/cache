/// 名称:	EMR.IP.BL.BLDHCEvent
/// 描述:	获取病历提交状态
/// 编写者：lifengbo
/// 编写日期: 2023-04-13
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLRecordStatus Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取病历提交状态
/// Creator:    lifengbo
/// CreateDate: 2023-04-14
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCommitRecordStatus(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeId=""
	s episodeId=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.DOC.BL.AdmRecordStatus).GetAdmRecordStatus(episodeId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-500")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
}

/// Desc:       变更病历提交相关状态
/// Creator:    lifengbo
/// CreateDate: 2023-04-14
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod ChangeRecordStatus(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s dtoItem = ##class(EMR.DOC.DTO.AdmRecordStatus).%New()
	
	/// 就诊号
  	s dtoItem.EpisodeID = argInJson.params.episodeID

	/// 病历提交状态（1：提交，0：撤销 -1 退回 -2:召回）
	s action = argInJson.params.action
	s CompletedStatus = $case(action,"commit":1,"revoke":0,:1)
  	s dtoItem.CompletedStatus = CompletedStatus

	/// 病历提交人
	s userID = argInJson.params.userID
  	s dtoItem.UserID =##class(User.SSUser).%OpenId(userID)

	/// 操作人IP地址
  	s dtoItem.IPAddress = argInJson.params.ipAddress

	/// 操作产品模块来源
  	s dtoItem.ProductSource = argInJson.product
  	
  	
    s strRes = ##Class(EMR.DOC.BL.AdmRecordStatus).SaveAdmRecordStatus(dtoItem,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes [ "-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常"_$p(strRes,"^",2),2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未捕获的代码异常：ChangeRecordStatus",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常"_$ze,2)
}

}
