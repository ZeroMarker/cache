/// 名称:	EMR.OP.BL.LinkData
/// 描述:	门诊病历-链接数据业务实现
/// 编写者：yejian
/// 编写日期: 2022-6-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.LinkData Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取链接单元配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_LINK","params":{"url":"diag"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLink(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s productCode = argInJson.product
	s strCode = argInJson.params.url
    s strRes = ##Class(EMR.OP.BL.LinkData).GetLinkJson(strCode,productCode,.argOutData)
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

/// Desc:       获取链接单元配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aCode:链接配置编码
/// 			aProductCode 项目标识
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.UserData).GetUserDataJson("10209",.obj)
ClassMethod GetLinkJson(aCode As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aCode="")||(aProductCode="") "-1^链接配置编码、项目标识不能为空"	
   	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(aProductCode,"U"),""))
    q:(ProductID="") "-1^获取项目标识ID失败"
    s id=$O(^CF.EMR.DOC.LinkConfigI("idxMain",ProductID," "_$zcvt(aCode,"U"),""))
	q:(""=id) "-1^获取用户信息失败"
	s objItem = ##Class(CF.EMR.DOC.LinkConfig).%OpenId(id)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.url =objItem.Code
	s jsonItem.title =objItem.Name
	s jsonItem.src =objItem.Src
	s jsonItem.method =objItem.Method
	s jsonItem.directOpen =$case(objItem.IsDirectOpen,"Y":"true",:"false")
	d jsonItem.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取链接单元（诊断数据）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_DIAG","params":{"episodeID":"1117"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDiag(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s productCode = argInJson.product
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetDiag(episodeID,"",.argOutData)
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

/// Desc:       获取链接单元（医嘱）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_OEORD","params":{"episodeID":"1117"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOeord(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s productCode = argInJson.product
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeord(episodeID,.argOutData)
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

/// Desc:       获取链接单元（中草药）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_OEORDCN","params":{"episodeID":"1117"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOeordCN(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s productCode = argInJson.product
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeordCN(episodeID,.argOutData)
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

/// Desc:       获取链接单元（过敏史）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_ALLERGIC","params":{"episodeID":"1117","queryAllergiesList":""}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllergic(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s productCode = argInJson.product
	s episodeID = argInJson.params.episodeID
	s queryAllergiesList= argInJson.params.queryAllergiesList
    s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetAllergic(episodeID,queryAllergiesList,.argOutData)
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

}
