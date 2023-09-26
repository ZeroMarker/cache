/// /// 名称:	EMR.DOC.BL.PrivRuleType
/// /// 描述:	权限类型
/// /// 编写者： huhao
/// /// 编写日期: 2022-4-1
/// /// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivRuleType Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      argArray  	{"action":"GET_RULETYPELIST","product":"GlobalEMR","params":{"userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod GetRuleTypeList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.Name=argInJson.params.Name
	s indata.Description=argInJson.params.Description
	if ((indata.Name="") && (indata.Description=""))
	{
   		 s strRes = ##class(EMR.DOC.BL.PrivRuleType).GetAllRes(.argOutData)}
    else
    {
	     s strRes = ##class(EMR.DOC.BL.PrivRuleType).GetSearchRes(indata,.argOutData)
	}
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       获取全部权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      无
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod GetAllRes(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes="-1"
	s typeID=""
	for
	{
		s typeID=$o(^CF.EMR.DOC.PrivRuleTypeD(typeID))
		q:(typeID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleType).%OpenId(typeID)
		continue:(obj.Status=0)
        continue:(obj="")
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = typeID
        s resObj.Name =obj.Name
        s resObj.Description =obj.Description
        d resJson.%Push(resObj)
        s strRes ="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取目标权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      Name：权限名称
/// 				Description：权限描述
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod GetSearchRes(indata As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes="-1"
	s typeID=""
	for
	{
		s typeID=$o(^CF.EMR.DOC.PrivRuleTypeD(typeID))
		q:(typeID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleType).%OpenId(typeID)
		continue:(obj.Status=0)
		continue:($find(obj.Name,indata.Name)=0)
		continue:($find(obj.Description,indata.Description)=0)
        continue:(obj="")
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = typeID
        s resObj.Name =obj.Name
        s resObj.Description =obj.Description
        d resJson.%Push(resObj)
        s strRes ="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增权限类型
/// Creator:    huhao
/// CreateDate: 2022-4-2
/// Input:      argArray  	{"action":"ADD_RULETYPELIST","product":"GlobalEMR","params":{"Name":"test","Description":"test","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddRuleTypeList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.Name=argInJson.params.Name
	s indata.Description=argInJson.params.Description
	s strRes = ##class(EMR.DOC.BL.PrivRuleType).AddType(indata,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^"){
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加出错",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       新增权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      Name：权限名称
/// 			Description：权限描述
/// OutPut:     argOutData 	返回数据 成功：1,失败：-1^错误信息
ClassMethod AddType(indata As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:indata.Name="" "-1^权限名称不能为空"
	q:indata.Description="" "-1^描述不能为空"
	s rowId=$o(^CF.EMR.DOC.PrivRuleTypeI("IdxName"," "_$zcvt(indata.Name,"U"),""))
	s obj=##class(CF.EMR.DOC.PrivRuleType).%OpenId(rowId)
	if (obj'="")
	{
		if (obj.Status=0)
		{
			s obj.Name=indata.Name
			S obj.Description=indata.Description
			S obj.Status="1"
			s strRes=obj.%Save()
			q strRes	
		}
		else
		{
			q "-1^该权限已存在"	
		}
	}
	else
	{
		s obj=##class(CF.EMR.DOC.PrivRuleType).%New()
		s obj.Name=indata.Name
		S obj.Description=indata.Description
		S obj.Status="1"
		s strRes=obj.%Save()
		q strRes		
	}
}

/// Desc:       更新权限类型
/// Creator:    huhao
/// CreateDate: 2022-4-2
/// Input:      argArray  	{"action":"UPDATE_RULETYPELIST","product":"GlobalEMR","params":{"Name":"test","Description":"test1","Id":"8","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdateRuleTypeList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.Id=argInJson.params.Id
	s indata.Name=argInJson.params.Name
	s indata.Description=argInJson.params.Description
	s strRes = ##class(EMR.DOC.BL.PrivRuleType).UpdateType(indata,.argOutData)
	if (strRes = "1")
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
	    q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       更新权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input: 		Id：权限类型对应rowid     
/// 				Name：权限名称
/// 			Description：权限描述
/// OutPut:    	argOutData 	返回数据 成功：1,失败：-1^错误信息
ClassMethod UpdateType(indata As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:((indata.Name="")||(indata.Description="")) "-1^请输入需要更新的内容"
	s obj=##class(CF.EMR.DOC.PrivRuleType).%OpenId(indata.Id)
	q:(obj="") "-1^该权限类型不存在"
	s obj.Name=indata.Name
	s obj.Description=indata.Description
	s strRes=obj.%Save()
	q strRes
}

/// Desc:       删除权限类型
/// Creator:    huhao
/// CreateDate: 2022-4-2
/// Input:      argArray  	{"action":"DELETE_RULETYPELIST","product":"GlobalEMR","params":{"Id":"8","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod DeletePrivRuleType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Id=argInJson.params.Id
	s strRes = ##class(EMR.DOC.BL.PrivRuleType).DeleteType(Id,.argOutData)
	if (strRes = "1")
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
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除权限类型
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input: 		Id：权限类型对应rowid     
/// OutPut:    	argOutData 	返回数据 成功：1,失败：-1^错误信息
ClassMethod DeleteType(Id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s obj=##class(CF.EMR.DOC.PrivRuleType).%OpenId(Id)
	q:(obj="") "-1^该类型不存在"
	s obj.Status=0
	s strRes=obj.%Save()
	q strRes
}

}
