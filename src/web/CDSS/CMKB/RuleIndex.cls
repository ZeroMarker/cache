/// Creator：谷雪萍
/// CreatDate: 2021-08-23
/// Description：生成识别词索引和规则索引
Class web.CDSS.CMKB.RuleIndex Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:生成所有已上线的识别词的索引
/// Table:CT.WDT.CDSS.IdentifyWIndex
/// Input:PassedFlag->如果是1，则生成已上线+审核通过的规则索引,否则只生成已上线的规则索引，默认是空
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).CreateIdentifyWIndex()
ClassMethod CreateIdentifyWIndex(PassedFlag As %String = "") As %String
{
	k ^CT.WDT.CDSS.IdentifyWIndexD
	k ^CT.WDT.CDSS.IdentifyWIndexI
	s result=""
	TS
	s WordsRowId=0
	for
	{ 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId))  //遍历识别词字典表
		q:(WordsRowId="")||(result["false")
		s result=..CreateIdentifyWIndexById(WordsRowId,PassedFlag)
	}
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="true^成功生成识别词索引！"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:生成某一个识别词的索引
/// Table:CT.WDT.CDSS.IdentifyWIndex
/// Input:WordsRowId-识别词id，PassedFlag->如果是1，则生成已上线+审核通过的规则索引,否则只生成已上线的规则索引，默认是空
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).CreateIdentifyWIndexById(WordsRowId,PassedFlag)
ClassMethod CreateIdentifyWIndexById(WordsRowId As %String, PassedFlag As %String = "") As %String
{
	q:WordsRowId="" "false^识别词id不能为空！"
	s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)

	s IpAddress = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061901")

	if (IpAddress["119.96.225.237") //PassedFlag->如果是1，则生成已上线+审核通过的规则索引
	{
		if (WordsState'="已上线")&(WordsState'="审核通过")
		{	
			 q:"true^识别词未上线或审核通过,不生成索引"
		}
	}
	else  //如果是空，则只生成已上线的规则索引
	{
		if (WordsState'="已上线") 
		{	
			 q:"true^识别词未上线,不生成索引"
		}
	}
		
	s CreateResult=""
	TS
    
	s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3) //识别词名称
	if (WordsDesc="年龄")   //年龄没有拆分，需要单独处理，生成一条索引
	{
		s str=WordsRowId_"&%年龄&%年龄"
		s CreateResult=..SaveIdentifyWIndex(str)
	}
	elseif(WordsDesc="性别") //性别没有拆分，需要单独处理，生成一条索引
	{
		s str=WordsRowId_"&%性别&%性别"
		s CreateResult=..SaveIdentifyWIndex(str)
	}
	elseif(WordsDesc="全部诊断") //全部诊断没有拆分，需要单独处理，生成一条索引
	{
		s str=WordsRowId_"&%诊断&%全部诊断"
		s CreateResult=..SaveIdentifyWIndex(str)
	}
	elseif(WordsDesc="手术")
	{
		s str=WordsRowId_"&%手术&%全部手术"
		s CreateResult=..SaveIdentifyWIndex(str)
	}
	else
	{
		s NodeRowId = ""
		for
		{
			s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsRowId,NodeRowId))  //遍历识别词节点表
			q:(NodeRowId="")||(CreateResult["false")
			s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			continue:(NodeTypeDesc'="主要条件-识别词")&(NodeTypeDesc'="否定条件-识别词")&(NodeTypeDesc'="基本信息-年龄")&(NodeTypeDesc'="基本信息-性别")
			s myRowID=0
			for 
			{
				s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeRowId,-100000000000000,myRowID))  //遍历识别词节点内容表
				q:myRowID=""
				s DrugStr=""
				if (NodeTypeDesc="基本信息-年龄")
				{
					s WordsItemType="年龄",ConditionItemValue="年龄"
				}
				elseif (NodeTypeDesc="基本信息-性别")
				{
					s WordsItemType="性别",ConditionItemValue="性别"
				}
				else
				{
					s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
					continue:(WordsItemDR="")
					s WordsItemDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)  //识别词姓名名称
					s WordsItemType= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),5) //项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
					s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),8)
					continue:(ConditionItemCalculate'="=")
					s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)
					continue:(WordsItemType="")||(ConditionItemValue="")
					if (WordsItemDesc="过敏原名称") //如果过敏原名称取药物字典。则药物字典里的药品通用名、别名、化学名、商品名、药物类、成分都要生成索引
					{
						s DrugID=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ConditionItemValue,"U"),0))  //药物字典id
						if (DrugID'="")
						{
							s DrugAlias=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),25)	//别名
							s DrugChemicalName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),27)	//化学名
							s DrugTradeName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),29)	//商品名
							s DrugCategory=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),26)	//药物类
							s DrugComposition=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugID)),28)	//成分 
							s:DrugAlias'="" DrugStr=DrugAlias
							if (DrugChemicalName'="")
							{
								s:DrugStr'="" DrugStr=DrugStr_","
								s DrugStr=DrugStr_DrugChemicalName
							}
							if (DrugTradeName'="")
							{
								s:DrugStr'="" DrugStr=DrugStr_","
								s DrugStr=DrugStr_DrugTradeName
							}
							if (DrugCategory'="")
							{
								s:DrugStr'="" DrugStr=DrugStr_","
								s DrugStr=DrugStr_DrugCategory
							}
							if (DrugComposition'="")
							{
								s:DrugStr'="" DrugStr=DrugStr_","
								s DrugStr=DrugStr_DrugComposition
							}
						}
						
					}
				}
				s str=WordsRowId_"&%"_WordsItemType_"&%"_ConditionItemValue
				if (DrugStr'="")
				{
					s DrugStr=##class(web.BDP.util.String).Replace(DrugStr," ","[A]")
					s DrugStr=##class(web.BDP.util.String).Replace(DrugStr,",","[A]")
					s str=str_"[A]"_DrugStr
				}
				s CreateResult=..SaveIdentifyWIndex(str)
				if (CreateResult["false")
				{
					q
				}
			}
			
		}
	}
	if (CreateResult["false")
	{
		tro
	}
	else
	{
		tc
		s CreateResult="true^成功生成识别词索引！"
	}
	q CreateResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:保存识别词项目索引表
/// Table:Table：CT.WDT.CDSS.IdentifyWIndex
/// Input:str=识别词id&%识别词项目&%识别词项目名称
/// Return: true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).SaveIdentifyWIndex(str)
ClassMethod SaveIdentifyWIndex(str As %String) As %String
{
	q:str="" "false^入参为空"
	s SaveResult=""
	s WordsDR=$p(str,"&%",1)  //识别词指针
	s IdentifyWType=$p(str,"&%",2) //识别词项目
	s IdentifyWTypeNameStr=$p(str,"&%",3)  //识别词项目名称 (如果过敏原名称取药物字典。则药物字典里的药品通用名[A]别名[A]化学名[A]商品名[A]药物类[A]成分)
	q:(WordsDR="")||(IdentifyWType="")||(IdentifyWTypeNameStr="") "false^识别词指针、识别词项目或识别词项目名称为空"

	Ts
	s IdentifyWTypeNameLen=$Length(IdentifyWTypeNameStr,"[A]")
	for IdentifyItem=1:1:IdentifyWTypeNameLen   
	{
          
     	s IdentifyWTypeName=$p(IdentifyWTypeNameStr,"[A]",IdentifyItem)  
     	if ($d(^CT.WDT.CDSS.IdentifyWIndexI("TypeNameIWIndex",IdentifyWType,IdentifyWTypeName,WordsDR)))  //若果索引表已存在该数据，则不再重复保存
		{
			continue	
		}
		s obj=##class(CT.WDT.CDSS.IdentifyWIndex).%New()
		d obj.IdentifyWordsDRSetObjectId(WordsDR)
		s obj.IdentifyWType = IdentifyWType
		s obj.IdentifyWTypeName = IdentifyWTypeName  
		

		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s SaveResult="true^"_id
		}
		else
		{
			s SaveResult="false"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			q
		}
	}
	if (SaveResult["false")
	{
		tro
	}
	else
	{
		tc
	}
	q SaveResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-02
/// Description:删除某一个识别词的索引，当下线或者删除时调用
/// Table:CT.WDT.CDSS.IdentifyWIndex
/// Input:WordsRowId-识别词id
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).DeleteIdentifyWIndexById(WordsRowId)
ClassMethod DeleteIdentifyWIndexById(WordsRowId As %String) As %String
{
	q:WordsRowId="" "false^识别词id不能为空！"
	s DeleteResult=""
	TS
	s IndexRowId =0
	for
	{
		s IndexRowId = $o(^CT.WDT.CDSS.IdentifyWIndexI("WordsDRIndex",WordsRowId,IndexRowId))  //遍历识别词索引表
		q:IndexRowId=""

		s sc=##class(CT.WDT.CDSS.IdentifyWIndex).%DeleteId(IndexRowId)
		if '$$$ISOK(sc)
		{
			s DeleteResult = "false"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			q
		}
		
	}
	if (DeleteResult["false")
	{
		tro
	}
	else
	{
		tc
		s DeleteResult="true^成功删除识别词索引！"
	}
	q DeleteResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:生成规则索引
/// Table:CT.WDT.CDSS.RuleIndex
/// Input:PassedFlag->如果是1，则生成已上线+审核通过的规则索引,否则只生成已上线的规则索引，默认是空
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).CreateRuleIndex()
ClassMethod CreateRuleIndex(PassedFlag As %String = "") As %String
{
	k ^CT.WDT.CDSS.RuleIndexD
	k ^CT.WDT.CDSS.RuleIndexI
	s result=""
	TS
	s RuleRowId=0
	for
	{ 
		s RuleRowId=$o(^CT.WDT.CDSS.RuleDictD(RuleRowId))  //遍历诊疗规则字典表
		q:(RuleRowId="")||(result["false")
		s result=..CreateRuleIndexById(RuleRowId,PassedFlag)	
	}
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="true^成功生成规则索引！"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:生成规则索引
/// Table:CT.WDT.CDSS.RuleIndex
/// Input:RuleRowId-规则id，PassedFlag->如果是1，则生成已上线+审核通过的规则索引,否则只生成已上线的规则索引，默认是空
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).CreateRuleIndexById(63963)
ClassMethod CreateRuleIndexById(RuleRowId, PassedFlag As %String = "")
{
	q:RuleRowId="" "false^规则id不能为空！"
	s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
	s IpAddress = ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061901")

	if (IpAddress["119.96.225.237") //PassedFlag->如果是1，则生成已上线+审核通过的规则索引
	{
		q:(RuleStatus'="已上线")&(RuleStatus'="审核通过") "true^规则未上线或审核通过，不能生成规则索引！"
	}
	else  //如果是空，则只生成已上线的规则索引
	{
		q:(RuleStatus'="已上线") "true^规则未上线，不能生成规则索引！"
	}

	TS
	s CreateResult=""
	s NodeRowId = ""
	for
	{
		s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleRowId,NodeRowId))  //遍历识别词节点表
		q:(NodeRowId="")||(CreateResult["false")

	    s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5) //节点类型
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3) //流程图顺序号
		s RuleTypeDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10) //图类型
		
		s RealTypeDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10) //图类型
		if RealTypeDR=""
		{
			s RealTypeDR=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
		}

		continue:(NodeTypeDesc'="主要条件-诊断")&(NodeTypeDesc'="主要条件-识别词")&(NodeTypeDesc'="否定条件-识别词")&(NodeTypeDesc'="基本信息-年龄")&(NodeTypeDesc'="基本信息-性别")&(NodeTypeDesc'="否定条件-诊断")
		s ConditionDR=0
	    for
	    {
		    s ConditionDR=$O(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionDR)) 
		    q:ConditionDR=""
	
			if (NodeTypeDesc="基本信息-年龄")
			{
				s ConditionItemValue="年龄"
			}
			elseif (NodeTypeDesc="基本信息-性别")
			{
				s ConditionItemValue="性别"
			}
			else
			{
				s ConditionItemValue=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionDR)),6)
				continue:ConditionItemValue=""
			}
			
			s WordsType="识别条件"
			if (NodeTypeDesc="主要条件-诊断")
			{
				s WordsType="诊断条件"
			}
			
    		if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,WordsType))) 
    		{	
	    		s WordsDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,WordsType,""))
	    		continue:WordsDR=""
	    		s str=RuleRowId_"&%"_WordsDR_"&%"_RuleTypeDR_"&%"_FlowChartNum_"&%"_RealTypeDR
				s CreateResult=..SaveRuleIndex(str)
				if (CreateResult["false")
				{
					q
				}
    		}
    		
    		if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"中医"_WordsType))) 
    		{	
	    		s WordsDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"中医"_WordsType,""))
	    		continue:WordsDR=""
	    		s str=RuleRowId_"&%"_WordsDR_"&%"_RuleTypeDR_"&%"_FlowChartNum_"&%"_RealTypeDR
				s CreateResult=..SaveRuleIndex(str)
				if (CreateResult["false")
				{
					q
				}
    		}
	    }
		
	}
	if (CreateResult["false")
	{
		tro
	}
	else
	{
		tc
		s CreateResult="true^成功生成规则索引！"
	}
	q CreateResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-23
/// Description:保存规则识别词索引表
/// Table:Table：CT.WDT.CDSS.RuleIndex
/// Input:str=规则id&%识别词id&
/// Return: true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).SaveRuleIndex(str)
ClassMethod SaveRuleIndex(str)
{
	q:str="" "false^入参为空"
	s SaveResult=""
	s RuleDR=$p(str,"&%",1)  //规则id
	s IdentifyWordsDR=$p(str,"&%",2) //识别词id
	s RuleTypeDR=$p(str,"&%",3)  //图类型
	s FlowChartNum=$p(str,"&%",4) //流程图顺序号
	s RealTypeDR=$p(str,"&%",5)
	

	q:(RuleDR="")||(IdentifyWordsDR="")||(FlowChartNum="") "false^规则指针、识别词指针、顺序号为空"
	s RuleTypeDR1=RuleTypeDR
	s:RuleTypeDR="" RuleTypeDR1=-100000000000000
	if ($d(^CT.WDT.CDSS.RuleIndexI("IRTypeFlowIndex",IdentifyWordsDR,RuleDR,RuleTypeDR1,FlowChartNum)))
	{
		q "true^该数据在规则识别词索引表已存在"
	}
	s obj=##class(CT.WDT.CDSS.RuleIndex).%New()
	d obj.RuleDRSetObjectId(RuleDR)
	d obj.IdentifyWordsDRSetObjectId(IdentifyWordsDR)
	d:RuleTypeDR="" obj.RuleTypeDRSetObjectId("")
	d:RuleTypeDR'="" obj.RuleTypeDRSetObjectId(RuleTypeDR)
	d:RealTypeDR'="" obj.RealRuleTypeDRSetObjectId(RealTypeDR)
	s obj.FlowChartNum=FlowChartNum
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s SaveResult="true^"_id
	}
	else
	{
		Trollback
		s SaveResult="false"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q SaveResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-02
/// Description:删除某一个规则的索引，当下线或者删除时调用
/// Table:CT.WDT.CDSS.RuleIndex
/// Input:RuleRowId-规则id
/// Return:true/false^成功或失败信息
/// Other:w ##class(web.CDSS.CMKB.RuleIndex).DeleteRuleIndexById(RuleRowId)
ClassMethod DeleteRuleIndexById(RuleRowId)
{
	q:RuleRowId="" "false^规则id不能为空！"
	s DeleteResult=""
	TS
	s IndexRowId =0
	for
	{
		s IndexRowId = $o(^CT.WDT.CDSS.RuleIndexI("RuleDRIndex",RuleRowId,IndexRowId))  //遍历识别词索引表
		q:IndexRowId=""

		s sc=##class(CT.WDT.CDSS.RuleIndex).%DeleteId(IndexRowId)
		if '$$$ISOK(sc)
		{
			s DeleteResult = "false"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			q
		}
		
	}
	if (DeleteResult["false")
	{
		tro
	}
	else
	{
		tc
		s DeleteResult="true^成功删除规则索引！"
	}
	q DeleteResult
}

}
