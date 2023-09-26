/// 名称:	EMR.DOC.BL.PrivRuleDetail
/// 描述:	权限规则配置-脚本内容编辑排序
/// 编写者：huhao
/// 编写日期: 2022-6-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivRuleDetail Extends EMR.DOC.COM.ActionBase
{

/// Desc:       脚本内容查询
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod GetRuleDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).GetDetail(argInJson.params,.argOutData)
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

/// Desc:       查询脚本内容
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      无 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod GetDetail(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s privRule=indata.key
	s resJson=##class(%DynamicArray).%New()
	s sequence=""
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=""
		s sequence=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",privRule,sequence))
		q:sequence=""
		s rowId=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",privRule,sequence,rowId))
		s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(rowId)
		continue:obj.Status="0"
		q:obj=""
		s resObj.key=rowId
		s resObj.RuleCode=obj.RuleCode
		s resObj.RuleDesc=obj.RuleDesc
		s resObj.IsUsing=obj.IsUsing
		s resObj.Sequence=obj.Sequence
		;s resObj.PrivRule=obj.PrivRule
		s resObj.PrivRule=##class(CF.EMR.DOC.PrivRule).%OpenId(obj.PrivRule)
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       脚本内容添加
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod AddRuleDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).AddDetail(argInJson.params,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","新增失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       添加脚本内容
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      RuleCode:脚本内容
/// 				RuleDesc:脚本描述
/// 				PrivRule:脚本内容对应的权限规则
/// OutPut:     argOutData 	成功：1  失败：-1^错误信息
ClassMethod AddDetail(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:indata.PrivRule="" "-1^所属权限不能为空"
	q:indata.RuleCode="" "-1^脚本名称不能为空"
	q:indata.RuleDesc="" "-1^脚本描述不能为空"
	s resObj=##class(CF.EMR.DOC.PrivRuleDetail).%New()
	s resObj.RuleCode=indata.RuleCode
	s resObj.RuleDesc=indata.RuleDesc
	s resObj.PrivRule=##class(CF.EMR.DOC.PrivRule).%OpenId(indata.PrivRule)
	s resObj.IsUsing="1"
	s resObj.Sequence=+($g(^CF.EMR.DOC.PrivRuleDetailD))+1
	s resObj.Status="1"
	s obj=##class(CF.EMR.DOC.PrivRule).%OpenId(indata.PrivRule)
	s resObj.PrivRule=obj
	s strRes=resObj.%Save()
	q strRes
}

/// Desc:       脚本内容更新
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod UpdateRuleDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).UpdateDetail(argInJson.params,.argOutData)
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

/// Desc:       更新脚本内容
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      RuleCode:脚本内容
/// 				IsUsing：是否启用
/// 				PrivRule:脚本内容对应的权限规则
/// OutPut:     argOutData 	成功：1  失败：-1^错误信息
ClassMethod UpdateDetail(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",rowId=""
	s rowId=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,indata.Sequence,rowId))
	s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(rowId)
	q:obj.Status="" "-1^脚本已被删除"
	s obj.RuleCode=indata.RuleCode
	s obj.IsUsing=indata.IsUsing	
	s strRes= obj.%Save()
	q strRes
}

/// Desc:       脚本内容删除
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod DeleteRuleDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).DeleteDetail(argInJson.params,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除脚本内容
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      Sequqence：脚本序号
/// 				PrivRule：脚本内容对应的权限规则
/// OutPut:     argOutData 	成功：1  失败：-1^错误信息
ClassMethod DeleteDetail(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",rowId=""
	s rowId=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,indata.Sequence,rowId))
	q:rowId="" "-1^脚本不存在"
	s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(rowId)
	s obj.Status="0"
	s strRes= obj.%Save()
	q strRes
}

/// Desc:       脚本内容排序
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod SortSequence(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).Sort(argInJson.params,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","排序失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       脚本条目排序
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      Sequqence：变更后的脚本排序序号
/// 				rowId：当前脚本的ID
/// 				PrivRule：脚本内容对应的权限规则
/// OutPut:     argOutData 	成功：1  失败：-1^错误信息
ClassMethod Sort(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(indata.Sequence="")||(indata.PrivRule="")||(indata.rowId="") "-1^参数错误"
	s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(indata.rowId)	
	s oldSeq=obj.Sequence
	if (oldSeq>indata.Sequence) //脚本内容上移
	{
		for i=(oldSeq-1):-1:indata.Sequence
		{
			s newSeq=i+1
			s id=""
			s id=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,i,id))
			s sObj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(id)
			continue:(sObj="")
			s sObj.Sequence=newSeq
			d sObj.%Save()
		}
	}
	else
	{
		for i=(oldSeq+1):1:indata.Sequence
		{
			s newSeq=i-1
			s id=""
			s id=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,i,id))
			s sObj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(id)
			continue:(sObj="")
			s sObj.Sequence=newSeq
			d sObj.%Save()		
		}
	}
	s obj.Sequence=indata.Sequence
	s strRes=obj.%Save()
	q strRes
}

/// Desc:       生成脚本
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod GetScript(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.PrivRuleDetail).GetScriptcode(argInJson.params,.argOutData)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请先添加脚本项",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       生成脚本内容
/// Creator:    huhao
/// CreateDate: 2022-6-22
/// Input:      PrivRule：脚本对应的权限规则
/// OutPut:     argOutData 	成功：1  失败：-1
ClassMethod GetScriptcode(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",code="",sequence=""
	s resJson=##class(%DynamicArray).%New()
	s resObj=##class(%DynamicObject).%New()
	for
	{
		s rowId=""
		s sequence=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,sequence))
		q:sequence=""
		s rowId=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",indata.PrivRule,sequence,rowId))
		s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(rowId)
		q:obj=""
		continue:obj.IsUsing="0"
		continue:obj.Status="0"
		s code=code_obj.RuleCode_" "
		s strRes="1"
	}
	s resObj.code=code
	d resJson.%Push(resObj)
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// 测试方法
ClassMethod test() As %String
{
	/*
	s b=""
	s result=##Class(%ResultSet).%New("EMRservice.BL.BLHospitals:SelectHospitals")
	d result.%Execute()
	while(result.%Next())
	{
		s HosId=result.Data("HosGroupID")
		s Name=result.Data("Name")
	}

	s RuleName="t"
	s rowId=""
	s rowId=$o(^CF.EMR.DOC.PrivRuleListI("IdxName"," "_$ZCVT(RuleName,"U"),rowId))
	s obj=##class(CF.EMR.DOC.PrivRuleList).%OpenId(rowId)	*/
	s PrivRule="",Sequence="2",rowid=""
	s PrivRule=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",PrivRule))
	s rowid=$o(^CF.EMR.DOC.PrivRuleDetailI("IdxPrivSeq",PrivRule,Sequence,rowid))
	s obj=##class(CF.EMR.DOC.PrivRuleDetail).%OpenId(rowid)
	w PrivRule
}

}
