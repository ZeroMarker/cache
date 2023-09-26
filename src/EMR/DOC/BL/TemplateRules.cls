/// 名称:EMR.DOC.COM.TemplateRules
/// 描述:通用文档规则管理模块
/// 编写者：ningyanghong
/// 编写日期: 2022-01-13
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateRules Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档规则列表
/// Creator:    ningyanghong
/// CreateDate: 2022-01-13
/// Input:      argArray  	命令参数 
/// 									{
/// 										"action":"GET_DOC_LIST",
/// 										"params":
/// 												{
/// 													"name":"入院记录内科新增文档测试",
/// 													"rule":"女",
/// 													"type":"all",
/// 												},
/// 										"product":"GlobalEMR"
/// 									}
/// OutPut:     argOutMessage 返回消息json格式
/// 								{
/// 										id:"",
/// 										name:"",
/// 										type:"",
/// 										ruls:""
/// 								}
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod GetDocRulesList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s obj=##class(%DynamicObject).%New()
	s obj.name = argInJson.params.name
	s obj.rule =  argInJson.params.rule
	s obj.type=argInJson.params.type
	s res = ##Class(EMR.DOC.BL.TemplateRules).GetDoc(obj,.argOutData)
	if (res = "-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取失败",2) 
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档规则列表
/// Creator:    ningyanghong
/// CreateDate: 2022-01-14
/// Input:      argArray  	命令参数 {"action":"GET_DOC_RULES","params":{"id":"2||DT","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
/// 								{
/// 									id:"",
/// 									description:"",
/// 									rules:""
/// 									}
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetDocRules(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id =..GetIDByKey(argInJson.params.id) 
	s type=..GetTypeByKey(argInJson.params.id)
	s res=""
	if (type="DT")
	{
		s res = ##Class(EMR.DOC.BL.TemplateRules).GetDocRule(id,.argOutData)
	}elseif (type="IT")
	{
		s res = ##Class(EMR.DOC.BL.LocTemplateRules).GetDocRule(id,.argOutData)
	}else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档类型不存在",2) 
	}
	
	if (res = "-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项为空",2) 
	}
	elseif(res="-200")
	{
	   q ..SetOutMessage(argOutMessage,"ERROR","文档不存在",2) 
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取失败",2) 
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       新增文档规则
/// Creator:    ningyanghong
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"GET_DOC_LIST","params":{"name":"入院记录内科新增文档测试","rule":"女","type":"all","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddDocRules(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s idStr = argInJson.params.id
	s ruleStr =  argInJson.params.rule
	s des=argInJson.params.description
	s wrongStr=""
	s res = ##Class(EMR.DOC.BL.TemplateRules).AddRules(idStr,ruleStr,des,wrongStr)
	if (res = "-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项ID未传",2) 
	}
	elseif (res="-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR",wrongStr,2) 
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除文档规则
/// Creator:    ningyanghong
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DELETE_DOC_RULES","params":{"id":"5||DT^4||IT","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DeleteDocRules(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s idStr = argInJson.params.id
	/// 删除的规则ID字符串
	s ruleStr =  argInJson.params.rule
	s res = ##Class(EMR.DOC.BL.TemplateRules).DeleteRules(idStr,ruleStr)
	if (res = "-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项ID未传",2) 
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}else
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","数据有误",2) 
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新文档规则
/// Creator:    ningyanghong
/// CreateDate: 2022-01-14
/// Input:      argArray  	命令参数 {"action":"DELETE_DOC_RULES","params":{"id":"5||DT^4||IT","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdateDocRules(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART
	s idStr = argInJson.params.id
	/// 更新的规则字符串
	s ruleStr =  argInJson.params.rule
	s addRule=argInJson.params.addRule
	s addRuleDes=argInJson.params.description
	s res = ##Class(EMR.DOC.BL.TemplateRules).UpdateRules(idStr,ruleStr,addRule,addRuleDes)
	if (res = "-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项ID未传",2) 
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}else
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","数据有误",2) 
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Creator:    ningyanghong
/// Desc:       获取文档规则列表
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).GetDoc()
ClassMethod GetDoc(objCon As %DynamicObject, argOutData As %GlobalBinaryStream) As %String
{
	s str="-100"
	q:(objCon.type="") str
	s name=objCon.name
	s rule=objCon.rule
	// 判断type类型
	s jsonArr = ##class(%DynamicArray).%New()
	if (objCon.type="all")
	{
		// 获取通用模板
		d ##class(EMR.DOC.BL.TemplateRules).getDocList(jsonArr,name,rule)
		// 获取科室模板
		d ##class(EMR.DOC.BL.LocTemplateRules).getDocList(jsonArr,name,rule)
		
	}
	elseif (objCon.type="basic")
	{
		// 获取通用模板
		d ##class(EMR.DOC.BL.TemplateRules).getDocList(jsonArr,name,rule)
		
	}
	elseif (objCon.type="loc")
	{
		// 获取科室模板
		d ##class(EMR.DOC.BL.LocTemplateRules).getDocList(jsonArr,name,rule)
	}
	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Creator:    ningyanghong
/// Desc:       获取文档规则列表
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).GetDocRule()
ClassMethod GetDocRule(id As %String, argOutData As %GlobalBinaryStream) As %String
{
	q:(id="") "-100"
	s objTem=##class(CF.EMR.DOC.Template).%OpenId(id)
	q:(objTem="") "-200"
	s objCon=##class(%DynamicArray).%New()
	d ##class(EMR.DOC.BL.TemplateRules).getRulesByTemplateID(objTem.%Id(),objCon,"")
	d objCon.%ToJSON(argOutData)
	q "1"
}

/// Creator:    ningyanghong
/// Desc:       新增文档规则
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).AddRules()
ClassMethod AddRules(id As %String, rule As %String, des As %String, str As %String) As %String
{
		// 遍历截取ItemID
	q:(id="") "-100"
	s res="1"
	for i=1:1:$l(id,"^")
		{
			s templateID=$p(id,"^",i)
			q:(templateID="")
			
			//  截取type和ID
			s temID=..GetIDByKey(templateID)
			s type=..GetTypeByKey(templateID)
			if (type="DT")
			{
				// 新增通用模板规则
				s strRes= ##class(EMR.DOC.BL.TemplateRules).addDocRule(temID,rule,des,str)
				if (strRes="-300")
				{
					s str="ID为"_temID_"的文档不存在"
				}
			}
			elseif (type="IT")
			{
				// 新增科室模板规则
				s strRes= ##class(EMR.DOC.BL.LocTemplateRules).addDocRule(temID,rule,des,str)
				if (strRes="-300")
				{
					s str="ID为"_temID_"的文档不存在"
				}
			}
		}
	q res
}

/// Creator:    ningyanghong
/// Desc:       删除文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).DeleteRules()
ClassMethod DeleteRules(id As %String, rule As %String) As %String
{
		// 遍历截取ItemID
	q:(id="") "-100"
	s res="1"
	for i=1:1:$l(id,"^")
		{
			s templateID=$p(id,"^",i)
			q:(templateID="")
			//  截取type和ID
			s temID=..GetIDByKey(templateID)
			s type=..GetTypeByKey(templateID)
				if (type="DT")
			{
				// 删除通用模板规则
				s strRes= ##class(EMR.DOC.BL.TemplateRules).deleteDocRuleJson(temID,rule)
			
			}
			elseif (type="IT")
			{
				// 删除科室模板规则
				s strRes= ##class(EMR.DOC.BL.LocTemplateRules).deleteDocRuleJson(temID,rule)
				
			}
		}
		q res
}

/// Creator:    ningyanghong
/// Desc:       更新文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).UpdateRules()
ClassMethod UpdateRules(id As %String, rule As %String, addRule As %String, ruleDes As %String) As %String
{
		// 遍历截取ItemID
	q:(id="") "-100"
	s res="1"
	for i=1:1:$l(id,"^")
		{
			s templateID=$p(id,"^",i)
			q:(templateID="")
			//  截取type和ID
			s temID=..GetIDByKey(templateID)
			s type=..GetTypeByKey(templateID)
				if (type="DT")
			{
				// 更新通用模板规则
				s strRes= ##class(EMR.DOC.BL.TemplateRules).updateDocRuleJson(temID,rule,addRule,ruleDes)
				if (strRes'="1")
				{
					TROLLBACK
				}
			
			}
			elseif (type="IT")
			{
				// 更新科室模板规则
				s strRes= ##class(EMR.DOC.BL.LocTemplateRules).updateDocRuleJson(temID,rule,addRule,ruleDes)
				if (strRes'="1")
				{
					TROLLBACK
				}
			}
		}
	TCOMMIT
	q res
}

/// Creator:    ningyanghong
/// Desc:       更新文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).updateDocRuleJson()
ClassMethod updateDocRuleJson(temID As %String, ruleStr As %String, addRule As %String, des As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.Template).%OpenId(temID)
	q:(objTem="") "-300"
	s strRes="1"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			
			
			// 判断旧的规则是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.TemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 更新
				s objRule=##class(CF.EMR.DOC.TemplateRules).%OpenId(rowID)
				if (objRule.RuleItemIDs'="")
				{
					s objRule.RuleItemIDs=objRule.RuleItemIDs_"^"_addRule
				}else
				{
					s objRule.RuleItemIDs=addRule
				}
				
				if (objRule.RuleItemDesc'="")
				{
					s objRule.RuleItemDesc=objRule.RuleItemDesc_"+"_des
				}else
				{
					s objRule.RuleItemDesc=des
				}
				
				
				s sc=objRule.%Save()
			}
		}
		q strRes
}

/// Creator:    ningyanghong
/// Desc:       删除文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).deleteDocRuleJson()
ClassMethod deleteDocRuleJson(temID As %String, ruleStr As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.Template).%OpenId(temID)
	q:(objTem="") "-300"
	s strRes="1"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			// 判断是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.TemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 删除
				s res= ##class(CF.EMR.DOC.TemplateRules).%DeleteId(rowID)
			}else
			{
				// 不存在 提示不存在
				s strRes="-301"
				continue
			}
		}
		q strRes
}

/// Creator:    ningyanghong
/// Desc:       新增文档规则
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).addDocRule()
ClassMethod addDocRule(temID As %String, ruleStr As %String, des As %String, str As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.Template).%OpenId(temID)
	q:(objTem="") "-300"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			
			// 判断是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.TemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 返回提示
				s objRule=##class(CF.EMR.DOC.TemplateRules).%OpenId(rowID)
				if (str="")
				{
					s str=objRule.RuleItemDesc_"与已有规则重复"
				}
				else
				{
					s str=str_";"_objRule.RuleItemDesc_"与已有规则重复"
				}
				
			}
			else
			{
				// 新增
				s newRule=##class(CF.EMR.DOC.TemplateRules).%New()
				
				s newRule.TemplateID=objTem
				s newRule.RuleItemIDs=rule
				s newRule.RuleItemDesc=$p(des,";",i)
				s sc = newRule.%Save()
			}
		}
		q "1"
}

/// Creator:    ningyanghong
/// Desc:       获取文档列表
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).getDocList()
ClassMethod getDocList(jsonArr As %DynamicArray, name As %String, rule As %String) As %String
{
	s templateID = ""
	for {
		s templateID = $o(^CF.EMR.DOC.TemplateD(templateID))
		q:(templateID = "")			
		s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(templateID)
        continue:(objTemplate="")
        s jsonTemplate  = ##class(%DynamicObject).%New()
        // 判断搜索条件
        
        if (name'=""){
	        s count=0
	        s count=$FIND(objTemplate.Name,name)
	        continue:(count=0)
        }
        s jsonTemplate.id = templateID_"||DT"
        s jsonTemplate.type ="DT"
        s jsonTemplate.name=objTemplate.Name
        // 获取rule
        s ruleArr=##class(%DynamicArray).%New()
        s res= ##class(EMR.DOC.BL.TemplateRules).getRulesByTemplateID(templateID,ruleArr,rule)
        continue:(res'="1")
		
		s jsonTemplate.rules=ruleArr
    	d jsonArr.%Push(jsonTemplate)
  		}
}

/// Creator:    ningyanghong
/// Desc:       获取文档规则
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).getRulesByTemplateID()
ClassMethod getRulesByTemplateID(aID As %String, objCon As %DynamicArray, rule As %String) As %String
{
	s strRes="1"
	q:(aID="")
	s strRowID = ""
	s count=0
	for 
	{
		s strRowID = $o(^CF.EMR.DOC.TemplateRulesI("TemplateIDIdx",aID,strRowID))
		q:(strRowID = "")		
		s strRes = "1"	
		s objRule = ##Class(CF.EMR.DOC.TemplateRules).%OpenId(strRowID)
        continue:(objRule="")
        // 判断查询
        if (rule'="")
        {
	        s count=$FIND(objRule.RuleItemDesc,rule)
        }
        s jsonRule=##class(%DynamicObject).%New()
        s jsonRule.id=strRowID
        s jsonRule.description=objRule.RuleItemDesc
        s jsonRule.rules=objRule.RuleItemIDs
        d objCon.%Push(jsonRule)
	}
	if (rule'="")&&(count=0)
	{
		q "-200"
	}
	q strRes
}

/// Desc:       获取字典目录
/// Creator:    huhao
/// CreateDate: 2020-12-16
/// Input:      
/// OutPut:     argOutData 返回数据
ClassMethod GetStCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.TemplateRules).GetCategory(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

ClassMethod GetCategory(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s data=..QueryCategory()
	s resArray=##class(%DynamicArray).%New()
	s key=0
	while data.%Next()
	{
		s resobj=##class(%DynamicObject).%New()
		s resobj.value=data.GetDataByName("Code")
		s resobj.label=data.GetDataByName("Description")
		s tagID=data.GetDataByName("RuleTypeTag")
		s objRuleType=##class(CF.EMR.DOC.EMRTSRuleType).%OpenId(tagID)
		continue:objRuleType=""
		s resobj.ruleTag=objRuleType.Code
		s resobj.key=key
		d resArray.%Push(resobj)
		s key=key+1
	}
	d resArray.%ToJSON(argOutData)
	q "1"
}

ClassMethod QueryCategory() As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql= "select Code,Description,RuleTypeTag from CF_EMR_DOC.StdDictionary WHERE IsRuleType='Y'"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

}
