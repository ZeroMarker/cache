/// /// 名称:	EMR.DOC.BL.PrivRuleList
/// /// 描述:	权限参数列表
/// /// 编写者： huhao
/// /// 编写日期: 2022-3-31
/// /// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivRuleList Extends EMR.DOC.COM.ActionBase
{

/// Desc:      	获取权限参数
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      argArray  	{"action":"GET_PRIVRULELIST","product":"GlobalEMR","params":{"userCode":"YS01","IP":"localhost"}}
/// OutPut:     
/// 				argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetPrivRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.RuleName=argInJson.params.RuleName
	s indata.RuleDesc=argInJson.params.RuleDesc
	s indata.RuleType=argInJson.params.RuleType
	
	if ((indata.RuleName="") && (indata.RuleDesc="") && (indata.RuleType=""))
	{
   		s strRes = ##class(EMR.DOC.BL.PrivRuleList).GetAllList(.argOutData)
   	}
    else
    {
	    s strRes = ##class(EMR.DOC.BL.PrivRuleList).GetSearchList(indata,.argOutData)
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

/// Desc:       获取所有权限参数
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      
/// OutPut:     成功 返回权限参数JSON数据，
/// 			失败 -1 未查询到权限参数数据
/// Debug:      
ClassMethod GetAllList(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes = ""
	s RuleID = ""
	for {
		s RuleID = $o(^CF.EMR.DOC.PrivRuleListD(RuleID))
		q:(RuleID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleList).%OpenId(RuleID)
		continue:(obj.Status=0)
        continue:(obj="")
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = RuleID
        s resObj.RuleName =obj.RuleName
        s resObj.RuleDesc =obj.RuleDesc
        s resObj.RuleType =obj.RuleType
        d resJson.%Push(resObj)
        s strRes="1"
	}
	if (resJson=""){s strRes="-1"}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       根据条件获取目标权限参数
/// Creator:    huhao
/// CreateDate: 2022-3-31
/// Input:      
/// OutPut:     成功 返回权限参数JSON数据，
/// 			失败 -1 未查询到权限参数数据
/// Debug:      
ClassMethod GetSearchList(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes = "1"
	s RuleID = ""
	for {
		s RuleID = $o(^CF.EMR.DOC.PrivRuleListD(RuleID))
		q:(RuleID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleList).%OpenId(RuleID)
		continue:(obj.Status=0)
        continue:(obj="")
        continue:($find(obj.RuleName,indata.RuleName)=0)
        continue:($find(obj.RuleDesc,indata.RuleDesc)=0)
        continue:($find(obj.RuleType,indata.RuleType)=0)
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = RuleID
        s resObj.RuleName =obj.RuleName
        s resObj.RuleDesc =obj.RuleDesc
        s resObj.RuleType =obj.RuleType

        d resJson.%Push(resObj)
	}
	if (resJson=""){s strRes="-1"}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       更新权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      argArray  	{"action":"UPDATE_PRIVRULELIST","product":"GlobalEMR","params":{"RuleName":"view","RuleDesc":"查看病历","RuleType":"操作参数","Id":"1","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdatePrivRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s inJson = ##class(%DynamicObject).%New()
	s inJson.Id=argInJson.params.Id
	s inJson.RuleName=argInJson.params.RuleName
	s inJson.RuleDesc=argInJson.params.RuleDesc
	s inJson.RuleType=argInJson.params.RuleType	
	s strRes = ##class(EMR.DOC.BL.PrivRuleList).UpdateList(inJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       更新权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      RuleDesc:权限描述
/// 				RuleName:权限名称
/// 				RuleType:权限类型
/// OutPut:     成功：1 
///            	失败：-1^错误信息
ClassMethod UpdateList(inJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:inJson.RuleName="" "-1^参数名称不能为空"
	q:inJson.RuleDesc="" "-1^参数描述不能为空"
	q:inJson.RuleType="" "-1^参数类型不能为空"
	s obj=##class(CF.EMR.DOC.PrivRuleList).%OpenId(inJson.Id)
	q:obj="" "-1^id有误"
	s rowId=$o(^CF.EMR.DOC.PrivRuleListI("IdxName"," "_$zcvt(inJson.RuleName,"U"),""))
	if (rowId="")
	{
		s obj.RuleDesc=inJson.RuleDesc
		s obj.RuleName=inJson.RuleName
		s obj.RuleType=inJson.RuleType
		s s=obj.%Save()
		q s
	}
	else
	{
		if (rowId'=inJson.Id)
		{
			q "-1^已存在同名权限参数"
		}
		else
		{
			s obj.RuleDesc=inJson.RuleDesc
			s obj.RuleName=inJson.RuleName
			s obj.RuleType=inJson.RuleType
			s s=obj.%Save()
			q s
		}
	}
}

/// Desc:       删除权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      argArray  	{"action":"DELETE_PRIVRULELIST","product":"GlobalEMR","params":{"Id":"73","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 1 or -1
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DeletePrivRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Id=argInJson.params.Id
	s strRes = ##class(EMR.DOC.BL.PrivRuleList).DeleteList(Id,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      Id:权限参数Id
/// OutPut:     成功 1
/// 				失败 -1
ClassMethod DeleteList(Id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s obj=##class(CF.EMR.DOC.PrivRuleList).%OpenId(Id)
	q:obj="" "-1^数据不存在"
	&sql(DELETE FROM CF_EMR_DOC.PrivRuleList where ID=:Id)
	q "1"
}

/// Desc:      	增加权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      argArray  	{"action":"ADD_PRIVRULELIST","product":"GlobalEMR","params":{"RuleName":"test","RuleDesc":"test","RuleType":"test","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddPrivRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s AddData = ##class(%DynamicObject).%New()
	s AddData.RuleName=argInJson.params.RuleName
	s AddData.RuleDesc=argInJson.params.RuleDesc
	s AddData.RuleType=argInJson.params.RuleType
	s strRes = ##class(EMR.DOC.BL.PrivRuleList).AddList(AddData,.argOutData)	
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
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:      	增加权限参数
/// Creator:    huhao
/// CreateDate: 2022-4-1
/// Input:      RuleName:权限名称
/// 				RuleDesc:权限描述
/// 				RuleType:权限类型
/// OutPut:     成功 1
///            	失败 -1^错误信息
ClassMethod AddList(AddData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s rowId=""
	q:AddData.RuleName="" "-1^权限名称不能为空"
	s rowId=$o(^CF.EMR.DOC.PrivRuleListI("IdxName"," "_$ZCVT(AddData.RuleName,"U"),rowId))
	if (rowId="")
	{
		s res=##class(CF.EMR.DOC.PrivRuleList).%New()
		s res.RuleName=AddData.RuleName
		s res.RuleType=AddData.RuleType
		s res.RuleDesc=AddData.RuleDesc
		s res.Status=1
		d res.%Save()
		s strRes="1"
	}
	else
	{
		s obj=##class(CF.EMR.DOC.PrivRuleList).%OpenId(rowId)
		if (obj.Status="0")
		{
			s obj.RuleName=AddData.RuleName
			s obj.RuleType=AddData.RuleType
			s obj.RuleDesc=AddData.RuleDesc
			s obj.Status=1
			d obj.%Save()
			s strRes="1"
		}
		else
		{
			q:obj.Status="1" "-1^已存在同名参数"
		}
	}
	q strRes
}

}
