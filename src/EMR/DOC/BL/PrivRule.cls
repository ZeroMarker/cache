/// 名称：		EMR.DOC.BL.PrivRule
/// 描述：		权限规则
/// 编写者：	huhao
/// 编写时间：	2022-4-26
Class EMR.DOC.BL.PrivRule Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取权限规则
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      argArray  	{"action":"GET_PRIVRULE","product":"GlobalEMR","params":{"userCode":"YS01","IP":"118.122.119.130"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetPrivRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HospGroupID=argInJson.params.GroupId
	if (HospGroupID="" )
	{
   		 s strRes = ##class(EMR.DOC.BL.PrivRule).GetAllRule(.argOutData)
   	}
    else
    {
	     s strRes = ##class(EMR.DOC.BL.PrivRule).GetSearchRule(HospGroupID,.argOutData)
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

/// Desc:       查询权限规则
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      无 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1，失败：-1
ClassMethod GetAllRule(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s resArr=##class(%DynamicArray).%New()
	s rowId=""
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.PrivRuleD(rowId))
		s obj=##class(CF.EMR.DOC.PrivRule).%OpenId(rowId)
		q:obj=""
		continue:obj.Status="0"
        s resObj.key = rowId
        s resObj.Name =obj.Name
        s resObj.Code=obj.Code
        s resObj.Valid=obj.Valid
        s resObj.HospGroupID=obj.HospGroupID
        s Tmpobj=##class(%DynamicObject).%New()
        continue:obj.RuleType=""
        s Tmpobj.Name=obj.RuleType.Name
        s Tmpobj.Desc=obj.RuleType.Description
        s Tmpobj.id=obj.RuleType.%Id()
        s resObj.RuleType=Tmpobj
		d resArr.%Push(resObj)
		s strRes="1"
	}
	d resArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       查询院区所属权限规则
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      HospGroupID:院区分组ID 
/// OutPut:     argOutMessage 返回消息json格式(分组对应下的所有医院信息)
///            	argOutData 	返回数据 成功：1，失败：-1
ClassMethod GetSearchRule(HospGroupID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",grpId=""
	s resArr=##class(%DynamicArray).%New()
	s rowId=""
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.PrivRuleD(rowId))
		s obj=##class(CF.EMR.DOC.PrivRule).%OpenId(rowId)
		q:obj=""
		continue:obj.Status="0"
		;&sql(SELECT HOSP_DefaultHospital_DR into :grpId from SQLUser.CT_Hospital where HOSP_RowId=:obj.HospGroupID)
		;continue:grpId'=HospGroupID
		continue:obj.HospGroupID'=HospGroupID
        s resObj.key = rowId
        s resObj.Name =obj.Name
        s resObj.Code=obj.Code
        s resObj.Valid=obj.Valid
        s resObj.HospGroupID=obj.HospGroupID
        s Tmpobj=##class(%DynamicObject).%New()
        continue:obj.RuleType=""
        s Tmpobj.Name=obj.RuleType.Name
        s Tmpobj.Desc=obj.RuleType.Description
        s Tmpobj.id=obj.RuleType.%Id()
        s resObj.RuleType=Tmpobj
		d resArr.%Push(resObj)
		s strRes="1"
	}
	d resArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       修改权限规则属性
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      argArray  	{"action":"UPDATE_PRIVRULE","params":{"ID":"3","HospGroupID":"1","Valid":"1","Name":"导出权限","RuleTypeName":"ActionPrivilege"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdatePrivRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indate=##class(%DynamicObject).%New()
	s indate.ID=argInJson.params.ID
	s indate.Name=argInJson.params.Name
	s indate.Valid=argInJson.params.Valid
	s indate.HospGroupID=argInJson.params.HospGroupID
	s TypeRowId=""
	s TypeRowId=$o(^CF.EMR.DOC.PrivRuleTypeI("IdxName"," "_$zcvt(argInJson.params.RuleTypeName,"U"),TypeRowId))
	s indate.RuleTypeId=TypeRowId
	s strRes = ##class(EMR.DOC.BL.PrivRule).UpdateRule(indate,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","修改失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       更新权限规则
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      ID:权限规则对应ID 
/// 				HospGroupID：院区ID  Name：新的规则名称  RuleTypeName：权限类型名称 Valid：是否有效 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1，失败：-1
ClassMethod UpdateRule(indate As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s rowId="",strRes="",res=""
	s obj = ##Class(CF.EMR.DOC.PrivRule).%OpenId(indate.ID)
	q:obj="" "-1^权限规则不存在"
	if ((obj.HospGroupID=indate.HospGroupID)&&(obj.RuleType.%Id()=indate.RuleTypeId))
	{
		s obj.Name=indate.Name
		s obj.Valid=indate.Valid
		d obj.%Save()
		s strRes="1"
	}
	else
	{
		s res=$o(^CF.EMR.DOC.PrivRuleI("IdxHosRuleType"," "_$zcvt(indate.HospGroupID,"U"),indate.RuleTypeId,res))
		if (res="")
		{
			s obj.Name=indate.Name
			s obj.RuleType=##class(CF.EMR.DOC.PrivRuleType).%OpenId(indate.RuleTypeId)
			s obj.HospGroupID=indate.HospGroupID
			s obj.Valid=indate.Valid
			d obj.%Save()
			s strRes="1"
		}
		else
		{
			s resobj=##class(CF.EMR.DOC.PrivRule).%OpenId(res)
			if (resobj.Status="1")
			{
				s strRes="-1^已存在相同类型权限规则"
			}
			else
			{
				s obj.Name=indate.Name
				s obj.RuleType=##class(CF.EMR.DOC.PrivRuleType).%OpenId(indate.RuleTypeId)
				s obj.HospGroupID=indate.HospGroupID
				s obj.Valid=indate.Valid
				d obj.%Save()
				s strRes="1"
			}
		}
	}
	q strRes
}

/// Desc:       配置权限规则脚本
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      argArray  	{"action":"UPDATE_PRIVRULECODE","params":{"ID":"2","Code":"if ($$printed$$)  s save=1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdatePrivRuleCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indate=##class(%DynamicObject).%New()
	s indate.ID=argInJson.params.ID
	s indate.Code=argInJson.params.Code
	s strRes = ##class(EMR.DOC.BL.PrivRule).UpdateCode(indate,.argOutData)
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

/// Desc:       编辑权限规则脚本
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      ID:权限规则对应ID
/// 				Code:脚本内容
/// OutPut:     argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdateCode(indate As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s obj = ##Class(CF.EMR.DOC.PrivRule).%OpenId(indate.ID)
	if (obj="")
	{ 
		s strRes="-1^权限规则不存在"
	}
	else
	{
		s obj.Code=indate.Code
		d obj.%Save()
		s strRes="1"
	}
	q strRes
}

/// Desc:       新增权限规则属性
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      argArray  	{"action":"ADD_PRIVRULE","params":{"HospGroupID":"","Valid":"1","Name":"打开权限","RuleTypeName":"CreatePrivilege"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddPrivRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indate=##class(%DynamicObject).%New()
	s indate.Name=argInJson.params.Name
	s indate.Valid=argInJson.params.Valid
	s indate.HospGroupID=argInJson.params.HospGroupID
	s indate.RuleTypeName=argInJson.params.RuleTypeName
	s TypeRowId=""
	s TypeRowId=$o(^CF.EMR.DOC.PrivRuleTypeI("IdxName"," "_$zcvt(indate.RuleTypeName,"U"),TypeRowId))
	s indate.RuleTypeId=TypeRowId
	s strRes = ##class(EMR.DOC.BL.PrivRule).AddRule(indate,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","新增出错",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       新增权限规则
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      Name:权限规则名称
/// 			HospGroupID：院区分组ID Valid：是否有效 RuleTypeName：权限类型名称
/// OutPut:     argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddRule(indate As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s newRowId="",TypeRowId="",strRes=""
	q:indate.Name="" "-1^规则名称必填"
	q:indate.RuleTypeId="" "-1^权限类型不能为空"
	s newRowId=$o(^CF.EMR.DOC.PrivRuleI("IdxHosRuleType"," "_$zcvt(indate.HospGroupID,"U"),indate.RuleTypeId,newRowId))
	if (newRowId'="")
	{
		s oldObj=##class(CF.EMR.DOC.PrivRule).%OpenId(newRowId)
		if (oldObj.Status="0")
		{
			s oldObj.Name=indate.Name
			s oldObj.HospGroupID=indate.HospGroupID
			s oldObj.Valid=indate.Valid
			s oldObj.RuleType=##class(CF.EMR.DOC.PrivRuleType).%OpenId(indate.RuleTypeId)
			s oldObj.Status="1"
			d oldObj.%Save()	
			s strRes="1"
		}
		else
		{
			q "-1^已存在同类型规则"
		}
	}
	else
	{
		s obj=##class(CF.EMR.DOC.PrivRule).%New()
		s obj.Name=indate.Name
		s obj.HospGroupID=indate.HospGroupID
		s obj.Valid=indate.Valid
		s obj.RuleType=##class(CF.EMR.DOC.PrivRuleType).%OpenId(indate.RuleTypeId)
		s obj.Status="1"
		d obj.%Save()
		s strRes="1"	
	}	
	q strRes
}

/// Desc:       删除权限规则
/// Creator:    huhao
/// CreateDate: 2022-4-26
/// Input:      argArray  	{"action":"DELETE_PRIVRULE","params":{"ID":"8"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回 1
ClassMethod DeletePrivRule(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID=argInJson.params.ID
	s strRes = ##class(EMR.DOC.BL.PrivRule).DeleteRule(ID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","不存在目标数据",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除权限规则
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      ID:权限规则RowId 
/// OutPut:     argOutData 	返回数据 成功：1，失败：-1
ClassMethod DeleteRule(ID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s obj = ##Class(CF.EMR.DOC.PrivRule).%OpenId(ID)
	q:obj="" "-1"
	s obj.Status=0
	s strRes=obj.%Save()
	q strRes
}

}
