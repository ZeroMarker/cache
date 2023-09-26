/// 名称:EMR.DOC.BL.LocTemplateRules
/// 描述:科室文档规则管理模块
/// 编写者：ningyanghong
/// 编写日期: 2022-01-13
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplateRules Extends EMR.DOC.COM.ActionBase
{

/// Creator:    ningyanghong
/// Desc:       获取文档列表
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).getDocList()
ClassMethod getDocList(jsonArr As %DynamicArray, name As %String, rule As %String) As %String
{
	s templateID = ""
	for {
		s templateID = $o(^CF.EMR.DOC.LocTemplateD(templateID))
		q:(templateID = "")			
		s objTemplate = ##Class(CF.EMR.DOC.LocTemplate).%OpenId(templateID)
        continue:(objTemplate="")
        s jsonTemplate  = ##class(%DynamicObject).%New()
        // 判断搜索条件
        
        if (name'=""){
	        s count=0
	        s count=$FIND(objTemplate.Name,name)
	        continue:(count=0)
        }
        s jsonTemplate.id = templateID_"||IT"
        s jsonTemplate.type ="IT"
        s jsonTemplate.name=objTemplate.Name
        // 获取rule
        s ruleArr=##class(%DynamicArray).%New()
        s res= ##class(EMR.DOC.BL.LocTemplateRules).getRulesByTemplateID(templateID,ruleArr,rule)
        continue:(res'="1")
		
		s jsonTemplate.rules=ruleArr
    	d jsonArr.%Push(jsonTemplate)
  		}
}

/// Creator:    ningyanghong
/// Desc:       新增文档规则
/// CreateDate: 2022-01-13
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).addDocRule()
ClassMethod addDocRule(temID As %String, ruleStr As %String, des As %String, str As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(temID)
	q:(objTem="") "-300"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			
			// 判断是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.LocTemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 返回提示
				s objRule=##class(CF.EMR.DOC.LocTemplateRules).%OpenId(rowID)
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
				s newRule=##class(CF.EMR.DOC.LocTemplateRules).%New()
				
				s newRule.TemplateID=objTem
				s newRule.RuleItemIDs=rule
				s newRule.RuleItemDesc=$p(des,";",i)
				s sc = newRule.%Save()
			}
		}
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
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(id)
	q:(objTem="") "-200"
	s objCon=##class(%DynamicArray).%New()
	d ##class(EMR.DOC.BL.LocTemplateRules).getRulesByTemplateID(objTem.%Id(),objCon,"")
	d objCon.%ToJSON(argOutData)
	q "1"
}

/// Creator:    ningyanghong
/// Desc:       删除文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).deleteDocRuleJson()
ClassMethod deleteDocRuleJson(temID As %String, ruleStr As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(temID)
	q:(objTem="") "-300"
	s strRes="1"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			// 判断是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.LocTemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 删除
				s res= ##class(CF.EMR.DOC.LocTemplateRules).%DeleteId(rowID)
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
/// Desc:       更新文档规则
/// CreateDate: 2022-01-14
/// Input:      obj 查询条件对象						 
/// Debug:      w ##Class(EMR.DOC.BL.TemplateRules).updateDocRuleJson()
ClassMethod updateDocRuleJson(temID As %String, ruleStr As %String, addRule As %String, des As %String) As %String
{
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(temID)
	q:(objTem="") "-300"
	s strRes="1"
	for i=1:1:$l(ruleStr,";")
		{
			s rule=$p(ruleStr,";",i)
			q:(rule="")
			
			// 判断新增的规则是否单独存在 存在就退出
			s count=0
			&sql(select count(*) into :count from CF_EMR_DOC.LocTemplateRules where TemplateID = :temID and RuleItemIDs = :addRule )
			q:(count'=0)
			// 判断旧的规则是否存在
			s rowID=""
			&sql(select ID into :rowID from CF_EMR_DOC.LocTemplateRules where RuleItemIDs = :rule and TemplateID = :temID)
			if (rowID'="")
			{
				// 存在 更新
				s objRule=##class(CF.EMR.DOC.LocTemplateRules).%OpenId(rowID)
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
			}else
			{
				continue
			}
		}
		q strRes
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
	for {
		s strRowID = $o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",aID,strRowID))
		q:(strRowID = "")		
		s strRes = "1"	
		s objRule = ##Class(CF.EMR.DOC.LocTemplateRules).%OpenId(strRowID)
        continue:(objRule="")
        // 判断查询条件是否成立
        if (rule'=""){
	        
	        s count=$FIND(objRule.RuleItemDesc,rule)
        }
        s jsonRule=##class(%DynamicObject).%New()
        s jsonRule.id=strRowID
        s jsonRule.description=objRule.RuleItemDesc
        s jsonRule.rules=objRule.RuleItemIDs
        d objCon.%Push(jsonRule)
	}
		// 如果rule存在，并且count不为0  如果rule存在 count为0 
	if (rule'="")&&(count=0)
	{
		q "-200"
	}
	q strRes
}

}
