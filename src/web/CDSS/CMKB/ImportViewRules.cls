/// Creator：谷雪萍
/// CreatDate: 2021-08-12
/// Description：可视化规则导入
Class web.CDSS.CMKB.ImportViewRules Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:导入识别词
/// Table:CT.WDT.CDSS.IdentifyWords
/// Input:FilePath-csv文件，注意需要先在Excel里把英文,转换成中文，再转为csv文件
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).ImportIdentifyWords("D:\科室补充导入.csv")
ClassMethod ImportIdentifyWords(FilePath As %String) As %String
{
	q:FilePath="" "false^文件路径为空！"
	s file=##class(%File).%New(FilePath)
	d file.Open("RS")
	s NewFilePath=$p(FilePath,".",1)_"导入结果.csv"
	s Wfile=##class(%File).%New(NewFilePath)
	d Wfile.Open("NWS")
	s result=""
	
	k ^TMPIVR("ImportIdentifyWords")
	s ^TMPIVR("ImportIdentifyWords",1)=file.ReadLine()_",导入标识"
	s count=1
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s count=count+1
		//保存识别词及节点
		s result=..SaveIdentifyWordsLine(Line)
		
		s ^TMPIVR("ImportIdentifyWords",count)=Line_","_result
	}
	
	s RowId=0
	for
	{
		s RowId=$o(^TMPIVR("ImportIdentifyWords",RowId))
		q:RowId=""
		s SucessFlag=$p($g(^TMPIVR("ImportIdentifyWords",RowId)),",",16)
		
		if (SucessFlag="已导入")
		{
			//保存连线
			s NodeType=$p($g(^TMPIVR("ImportIdentifyWords",RowId)),",",3) //识别词类型
			
			if (NodeType'="") //如果识别词类型不为空，则保存连线
			{
				s WordsId=$p($g(^TMPIVR("ImportIdentifyWords",RowId)),",",17)
				
				s result=..SaveAllWordsNodeLink(WordsId,"1")
				
				if (result["false")
				{
					s ^TMPIVR("ImportIdentifyWords",RowId)=$p(^TMPIVR("ImportIdentifyWords",RowId),",",1,16)_",未导入,"_result
				}
				else
				{
					//删除json图信息
					s WordsChartId=$O(^CT.WDT.CDSS.WordsChartI("WordsDRIndex",WordsId,""))
					if (WordsChartId'="")
					{
						s ChartSC=##class(CT.WDT.CDSS.WordsChart).%DeleteId(WordsChartId)
						if '$$$ISOK(ChartSC)
						{
							s result = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ChartSC)  //返回错误信息
							s ^TMPIVR("ImportIdentifyWords",RowId)=$p(^TMPIVR("ImportIdentifyWords",RowId),",",1,16)_",未导入,"_result
						}
					}
				}
			}
			
		}
		d Wfile.WriteLine(^TMPIVR("ImportIdentifyWords",RowId))
	}
	
	d Wfile.%Save()
	d Wfile.%Close()
	d file.%Close()
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-01-04
/// Description:导入识别词
/// Input:Line-导入模板中一行的内容，单元格之间用英文逗号连接
/// Return:false^错误信息/true^导入成功
/// Other:模板：识别词名称	属性	类型	满足条件个数	项目	名称	是否有属性	属性	非数值属性描述	最小值	单位	是否包含	最大值	单位	是否包含
/// Other:d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsLine(Line)
ClassMethod SaveIdentifyWordsLine(Line As %String) As %String
{
	s SaveLineResult=""
	s Line = ..DealSymbol(Line)  //处理符号
	
	s WordsDesc=$p(Line,",",1)  //识别词名称
	
	//判断必填项 1
	if (WordsDesc="")
	{
		s SaveLineResult="未导入,false^未获取到识别词名称!"  //返回错误信息
		q
	}
	s WordsType=$p(Line,",",2)  //识别词类型
	s:WordsType="诊断" WordsType="诊断条件"
	if (WordsType="")
	{
		s SaveLineResult="未导入,false^未获取到识别词类型!"  //返回错误信息
		q
	}
	//保存识别词规则 2
	s NodeType=$p(Line,",",3) //识别词类型
	s WordsStatus="审核通过"
	if (NodeType="")
	{
		s WordsStatus="编辑中"
	}
	TS
	s WordsId=..SaveIdentifyWords(WordsDesc,WordsType,WordsStatus)  //保存识别词基础信息
	if (WordsId="")  //没获取到识别词id，则导入失败
	{
		s SaveLineResult="未导入,false^未获取到识别词id，不能进行拆分!"  //返回错误信息
	}
	else
	{
		if (NodeType="")  //如果识别词类型为空则不必拆分识别词，导入完成
		{
			 s SaveLineResult="已导入,"_WordsId
		}
		else  //如果识别词类型不为空则需要拆分识别词
		{
			s saveresult=..SaveAllWordsNode(WordsId,Line)
			if (saveresult["false")
			{
				s SaveLineResult="未导入,"_saveresult
			}
			else
			{
				 s SaveLineResult="已导入,"_WordsId
			}
		}
	}
	if (SaveLineResult["false")
	{
		tro
	}
	else
	{
		tc
	}
	q SaveLineResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存识别词规则
/// Table:CT.WDT.CDSS.IdentifyWords
/// Input:WordsDesc-识别词名称，WordsType-识别词类型，WordsState-状态
/// Return: 识别词规则id
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWords(WordsDesc,WordsType,WordsState)
ClassMethod SaveIdentifyWords(WordsDesc As %String, WordsType As %String, WordsState As %String = "审核通过", ConditionItemCategory As %String = "西医") As %String
{
	q:(WordsDesc="")||(WordsType="") ""
	if (ConditionItemCategory="中医")
	{
		s:WordsType="诊断条件" WordsType="中医诊断条件"
		s:WordsType="识别条件" WordsType="中医识别条件"
	}
	s WordsId=""
	if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType)))  //如果识别词已经存在，则只增加节点内容
	{
		s WordsId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType,0))  //识别词id
		if (WordsState="审核通过")&(WordsId'="")
		{
			s WordsObj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(WordsId)
			s WordsObj.WordsState=WordsState
			s WordsObj.UpdateDate = $zdt($h,3)
			s WordsObj.UpdateUser = "谷雪萍"
			s WordsObj.AuditDate = $zdt($h,3)
			s WordsObj.AuditUser = "付婧"
			s WordsObj.SplitState=0
			TS
			s WordsSC=WordsObj.%Save()
			d WordsObj.%Close()
	    	if $$$ISOK(WordsSC)
			{
				tc
			}
			else
			{
				tro
			}
			
		}
	}
	else
	{
		s WordsObj=##class(CT.WDT.CDSS.IdentifyWords).%New() 
		s WordsObj.WordsCode = ##class(web.CDSS.CMKB.IdentifyWords).GetLastCode()
		s WordsObj.WordsDesc = WordsDesc
		s WordsObj.WordsType=WordsType
		s WordsObj.WordsState=WordsState
		s WordsObj.UpdateDate = $zdt($h,3)
		s UpdateUser="谷雪萍"
		s AuditUser="付婧"
		if $d(%session)
		{
			s UpdateUser=$g(%session.Data("LOGON.USERNAME"))
			s AuditUser=$g(%session.Data("LOGON.USERNAME"))
		}
		s WordsObj.UpdateUser = UpdateUser

		if (WordsState="审核通过")  //拆分标识
		{
			s WordsObj.SplitState=0  //已拆分
			s WordsObj.AuditDate = $zdt($h,3)
			s WordsObj.AuditUser = AuditUser
		}
		else
		{
			s WordsObj.SplitState=1 //未拆分
		}
		TS
		s WordsSC=WordsObj.%Save()
		d WordsObj.%Close()
    	if $$$ISOK(WordsSC)
		{
			tc
			s WordsId = WordsObj.%Id()  //识别词字典ID

		}
		else
		{
			tro
		}
	}
	q WordsId
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存识别词节点及内容
/// Table:CT.WDT.CDSS.WordsNode
/// Input:WordsId-识别词id，Line-excel里行信息串
/// Return: true/false^成功/失败信息
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveAllWordsNode(WordsId,Line)
ClassMethod SaveAllWordsNode(WordsId As %String, Line As %String) As %String
{
	q:(WordsId="")||(Line="") "false^保存识别词节点时识别词id或信息串不能为空"
 	s NodeType=$p(Line,",",3) //识别词类型
 	q:NodeType="" "false^没有获取到识别词类型，不能拆分！"
	s MeetConditionNum=$p(Line,",",4) //需满足条件个数
	s:MeetConditionNum'="" MeetConditionNum=$p(MeetConditionNum,"/",1) //需满足条件个数
	s:MeetConditionNum="" MeetConditionNum=1
 	TS
 	s WordsNodeResult=""
    //保存识别词节点
	s StartStr=WordsId_",1,1,开始,,,0,0"
	s StartNodeId=..SaveWordsNode(StartStr)
	s ConditionStr=WordsId_",1,1,"_NodeType_","_MeetConditionNum_",,0,0"
	s ConditionNodeId=..SaveWordsNode(ConditionStr)
	s EndStr=WordsId_",1,1,结束,,,0,0"
	s EndNodeId=..SaveWordsNode(EndStr)	

	if (StartNodeId="")||(EndNodeId="")||(ConditionNodeId="")
	{
		s WordsNodeResult="false^识别词节点保存失败！"	
	}
	else
	{
		//保存识别词节点内容
		//节点id,识别词项目,项目名称,是否有属性,属性,非数值属性描述
		s ConditionLen=$l(Line,",")
		s ConditionStr=ConditionNodeId_","_$p(Line,",",5,ConditionLen)
		s WordsNodeResult =..SaveWordsCondition(ConditionStr)
	}
	
	if (WordsNodeResult["false")
	{
		tro	
	}
	else
	{
		tc
		s WordsNodeResult="true^识别词节点及内容保存成功"
	}
	q WordsNodeResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存识别词节点
/// Table:CT.WDT.CDSS.WordsNode
/// Input:str=识别词指针,流程图顺序号,节点顺序号,节点类型,需满足条件个数,备注,left坐标,top坐标
/// Return: 节点id
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveWordsNode()
ClassMethod SaveWordsNode(str As %String) As %String
{
	q:str="" ""

	s id=""
	s WordsDR=$p(str,",",1)  //识别词指针
	s FlowChartNum=$p(str,",",2) //流程图顺序号
	s NodeType=$p(str,",",4)  //节点类型
	q:(WordsDR="")||(FlowChartNum="")||(NodeType="") ""
	s NodeType=$o(^CT.WDT.CDSS.NodeTypeI("DescIndex"," "_$ZCONVERT(NodeType,"U"),0))
	q:NodeType="" ""
	if ($d(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsDR,FlowChartNum,NodeType)))
	{
		s id=$o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsDR,FlowChartNum,NodeType,0))
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.WordsNode).%New()
		d obj.WordsDRSetObjectId(WordsDR)
		s obj.FlowChartNum = FlowChartNum
		s obj.NodeNum = $p(str,",",3)  //节点顺序号
		d obj.NodeTypeSetObjectId(NodeType)
		s MeetConditionNum=$p(str,",",5)
		s:MeetConditionNum'="" MeetConditionNum=$tr(MeetConditionNum," ","")
		s obj.MeetConditionNum = MeetConditionNum  //需满足条件个数
		s obj.Remarks = $p(str,",",6) //备注
		s obj.ChartLeft = $p(str,",",7) //left坐标
		s obj.ChartTop = $p(str,",",8) //top坐标
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
		}
		else
		{
			Trollback
		}
	}
	q id
}

/// Creator:谷雪萍
/// CreatDate:2021-09-06
/// Description:保存识别词节点连线
/// Table:CT.WDT.CDSS.RuleLink
/// Input:WordsDR-识别词id，FlowChartNum-流程图顺序号
/// Return: true/false^成功/失败信息
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveAllWordsNodeLink(95934,1)
ClassMethod SaveAllWordsNodeLink(WordsDR As %String, FlowChartNum As %String = "1") As %String
{
	q:(WordsDR="")||(FlowChartNum="") "false^保存规则节点连线时规则id和流程图顺序号不能为空"
	
	s NodeStr="",StartNode="",EndNode=""
	s NodeNum=0   //节点id
	for
	{
		s NodeNum=$o(^CT.WDT.CDSS.WordsNodeI("ChartNumIndex",WordsDR,FlowChartNum,NodeNum))
		q:NodeNum=""
		s NodeID=0   //节点id
		for
		{
			s NodeID=$o(^CT.WDT.CDSS.WordsNodeI("ChartNumIndex",WordsDR,FlowChartNum,NodeNum,NodeID))
			q:NodeID=""
			s NodeType=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeID)),5) //节点类型
			if (NodeType="1")  //开始节点
			{
				s StartNode=NodeID
				continue
			}
			
			elseif (NodeType="2")  //结束节点
			{
				s EndNode=NodeID
				continue
			}
			else
			{
				s:NodeStr'="" NodeStr=NodeStr_","
				s NodeStr=NodeStr_NodeID
			}
		}
		
	}
	s NodeStr=StartNode_","_NodeStr_","_EndNode
	
	
	s SaveNodeResult=""
	Ts
	s strLen=$Length(NodeStr,",")
	for iNode=1:1:(strLen-1)
	{   
		    
	    s PreNode=$p(NodeStr,",",iNode)
	    s NextNode=$p(NodeStr,",",iNode+1)  
	    if (PreNode="")||(NextNode="")
	    {
		    continue
	    }
	    s WordsNodeStr=WordsDR_","_FlowChartNum_","_PreNode_","_NextNode
	    s SaveNodeResult=..SaveWordsNodeLink(WordsNodeStr)
		If (SaveNodeResult="")
		{
			s SaveNodeResult="false^节点连线保存失败！"
			q
		}
	    
	}
	if (SaveNodeResult["false")
	{
		tro
	}
	else
	{
		tc
		s SaveNodeResult="true^识别词节点连线保存成功!"
	}
	q SaveNodeResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存识别词节点连线
/// Table:CT.WDT.CDSS.WordsLink
/// Input:str=识别词指针,流程图顺序号,上一个节点,下一个节点,备注
/// Return: 节点id
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveWordsNodeLink()
ClassMethod SaveWordsNodeLink(str As %String) As %String
{
	q:str="" ""

	s id=""
	s obj=##class(CT.WDT.CDSS.WordsLink).%New()
	s WordsDR=$p(str,",",1)  //识别词指针
	s FlowChartNum=$p(str,",",2) //流程图顺序号
	s PreNode=$p(str,",",3) //上一个节点
	s NextNode=$p(str,",",4)  //下一个节点

	q:(WordsDR="")||(FlowChartNum="")||(PreNode="")||(NextNode="") ""
	if ($d(^CT.WDT.CDSS.WordsLinkI("UniqueIndex",WordsDR,FlowChartNum,PreNode,NextNode)))
	{
		s id=$o(^CT.WDT.CDSS.WordsLinkI("UniqueIndex",WordsDR,FlowChartNum,PreNode,NextNode,0))
	}
	else
	{
		d obj.WordsDRSetObjectId(WordsDR)
		s obj.FlowChartNum =FlowChartNum
		d obj.PreNodeSetObjectId(PreNode)
		d obj.NextNodeSetObjectId(NextNode)
		s obj.Remarks = $p(str,",",5)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
		}
		else
		{
			tro
		}
	}
	q id
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存识别词节点内容
/// Table:CT.WDT.CDSS.WordsNode
/// Input:str=节点id,识别词项目,项目名称,是否有属性,属性,非数值属性描述,最小值,最小值单位,是否包含最小值,最大值,最大值单位,是否包含最大值
/// Return: false^错误信息/true^导入成功
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveWordsCondition(str)
ClassMethod SaveWordsCondition(str As %String) As %String
{
	s ^TMP("ldy-excel")=str
	q:str="" "false^保存识别词节点内容时获取到的入参为空"
		
	s saveresult=""
	s NodeDR=$p(str,",",1)  //节点id
	s ItemNameStr=$p(str,",",3)  //识别词指针
	s WordsItem=$p(str,",",2)  //识别词项目
	q:(NodeDR="")||(ItemNameStr="")||(WordsItem="") "false^保存识别词节点内容时未获取到节点id、识别词项目或项目名称"
	s:WordsItem="查体结果名称" WordsItem="体格检查名称"
	s WordsItemDR=0   //识别词项目id 
	for
	{
		s WordsItemDR=$o(^CT.WDT.CDSS.WordsItemI("DescIndex"," "_$ZCONVERT(WordsItem,"U"),WordsItemDR))
		q:WordsItemDR=""
		s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),4)			//父节点DR
		if (ParentDR="")
		{
			q
		}
	}
	q:(WordsItemDR="") "false^保存识别词节点内容时未获取到识别项目"
	s ItemNameStr=##class(web.BDP.util.String).Replace(ItemNameStr,"|","｜")  //识别词项目的分隔符
	s ItemNameStr=..DealSymbol(ItemNameStr)  //处理符号
	s argsLen=$Length(ItemNameStr,"｜")
	
	Ts
	for item=1:1:argsLen   
	{   
		    
	    s ItemName=$p(ItemNameStr,"｜",item)  
	    continue:ItemName=""
	    if (WordsItem="诊断名称")||(WordsItem="既往诊断名称")||(WordsItem="诊断症状名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在诊断字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在疾病字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="手术名称")||(WordsItem="既往手术名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在手术字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在手术字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="检验项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检验项目字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在检验项目字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="检验医嘱名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检验医嘱字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在检验医嘱字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="检查项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检查字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在检查项目字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="护理项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在护理字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在护理字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="药品名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在药品字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在药物字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="输血品名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在输血品字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在输血品字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="症状名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在症状字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在症状字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="妊娠/产后状态名称")||(WordsItem="月经婚育项目名称")||(WordsItem="个人史名称")||(WordsItem="生命体征名称")
	    {
		    s DictId=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在通用名字典是否存在
		    if (DictId="")
		    {
			   	s saveresult="false^"_ItemName_"在通用名字典表内不存在！"
				q
		    }	    
	    }
	    elseif (WordsItem="体格检查名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在体格检查字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在体格检查字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="护理结果名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.NurseResultDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在护理结果字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在护理结果字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="检查结果名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检查结果字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在检查结果字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="会诊科室")||(WordsItem="科室名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在科室字典是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在科室字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="评估表名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在评估表知识库是否存在
		   if (DictId="")
		   {
			   	s saveresult="false^"_ItemName_"在评估表知识库内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="过敏原名称")
	    {
		   s AllergyDictId=$o(^CT.WDT.CDSS.AllergyDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   s DrugDictId=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   if (AllergyDictId="")&(DrugDictId="")
		   {
			   	s saveresult="false^"_ItemName_"在过敏原字典和药物字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="中医诊断名称")||(WordsItem="中医诊断症状名称")||(WordsItem="中医既往诊断名称")
	    {
		   s TCMDiseaseId=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",ItemName,0)) 
		   if (TCMDiseaseId="")
		   {
			   	s saveresult="false^"_ItemName_"在中医疾病字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="中医证型症状名称")||(WordsItem="中医证型名称")
	    {
		   s TCMSymptomId=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   if (TCMSymptomId="")
		   {
			   	s saveresult="false^"_ItemName_"在中医症候字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="中药名称")
	    {
		   s TCMMedicineId=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   if (TCMMedicineId="")
		   {
			   	s saveresult="false^"_ItemName_"在中药字典表内不存在！"
				q
		   }
	    }
	    elseif (WordsItem="中医体征")
	    {
		   s TCMSignsId=$o(^CT.WDT.CDSS.TCMSignsI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   if (TCMSignsId="")
		   {
			   	s saveresult="false^"_ItemName_"在中医体征字典表内不存在！"
				q
		   }
	    }
	    else
	    {
	    }
	   
		s ProperyNameStr=$p(str,",",5)  //属性名
		s ItemValueStr=$p(str,",",6)
		s MinItemValueStr=$p(str,",",7) //数值性描述最小值
		s MaxItemValueStr=$p(str,",",10) //数值性描述最大值
		s HasChild=$p(str,",",4)  //是否有属性
		
		s RepeatStr=WordsItemDR_","_NodeDR_","_ItemName_",=,"
	    if ($d(^TMPIVR("SaveWordsCondition",RepeatStr)))&(HasChild=0) 
		{
			s saveresult="false^"_ItemName_"重复！"
			q
		}
		
		s RepeatStr=..SortRepeatStr(NodeDR,WordsItemDR,ItemName,ItemValueStr,ProperyNameStr,MaxItemValueStr,MinItemValueStr)
		if ($d(^TMPIVR("SaveWordsCondition",RepeatStr)))&(HasChild=1)
		{
			s saveresult="false^"_ItemName_"重复！"
			q
		}
		
		s obj=##class(CT.WDT.CDSS.WordsCondition).%New()
	    d obj.WordsItemDRSetObjectId(WordsItemDR)
	    d obj.NodeDRSetObjectId(NodeDR)
		s obj.Sequence = item
		s obj.ConditionItemValue = ItemName
		s obj.ConditionItemCalculate = "="
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s TempLen=$p(str,",",5)
			for SubIndex=1:1:$l(TempLen,"&%")
			{
				s ProperyName=$p(ProperyNameStr,"&%",SubIndex)
				s ItemValue=$p(ItemValueStr,"&%",SubIndex)

				
				s ItemDR=0   //识别词项目id 
				for
				{
					s ItemDR=$o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",WordsItemDR,ItemDR))
					q:ItemDR=""
					
					s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ItemDR)),3)			//描述
					if (WordsItemDesc=ProperyName)
					{
						q
					}
				}
				

				
				if (ItemValue'="")&(HasChild=1)
				{
					s RepeatStr1=ItemDR_","_NodeDR_","_ItemName_","_ItemValue_",=,"
					//continue:$d(^TMPIVR("SaveWordsCondition",RepeatStr1))
				}
				

				
				if HasChild="0"
				{
					//s RepeatStr=WordsItemDR_","_NodeDR_","_ItemName_","_ItemValue_",=,"
					//s RepeatStr=WordsItemDR_","_NodeDR_","_ItemName_","_ItemValueStr_",=,"
					s RepeatStr=WordsItemDR_","_NodeDR_","_ItemName_",=,"
					s ^TMPIVR("SaveWordsCondition",RepeatStr)=""
				}

				if (HasChild=1) //如果有属性，则保存属性
				{
					
					if (id="")
					{
						s saveresult="false^识别词项目没保存成功"
						q
					}

					if (ItemDR="")
					{
						s saveresult="false^未获取到属性名"
						q
					}
					
					//s ItemValue=$p(str,",",6)
					//s ItemValue=$p(ItemValue,"&%",SubIndex)
					
					if (ItemValue'="")&(WordsItemDesc'="值")&(WordsItemDesc'="持续时间")&(WordsItemDesc'="时间")&(WordsItemDesc'="手术持续时间") //非数值性描述不为空，则保存条件
					{
						
					    s ItemObj=##class(CT.WDT.CDSS.WordsCondition).%New()
					    d ItemObj.WordsItemDRSetObjectId(ItemDR)
					    d ItemObj.NodeDRSetObjectId(NodeDR)
						s ItemObj.Sequence = 1
						s ItemObj.ConditionItemValue = ItemValue
						s ItemObj.ConditionItemCalculate = "="
						d ItemObj.ParentDRSetObjectId(id)
						s Itemsc=ItemObj.%Save()
						d ItemObj.%Close()
						If '$$$ISOK(Itemsc)
						{
							s saveresult = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Itemsc)  //返回错误信息
							q
						}
						else
						{
							//s RepeatStr=ItemDR_","_NodeDR_","_ItemName_","_ItemValue_",=,"
							//s ^TMPIVR("SaveWordsCondition",RepeatStr)=""
						}
					}
					//s MinItemValue=$p(str,",",7) //数值性描述最小值
					//s MinItemValue=$p(MinItemValue,"&%",SubIndex)
					//s MaxItemValue=$p(str,",",10) //数值性描述最大值
					//s MaxItemValue=$p(MaxItemValue,"&%",SubIndex)
					if (WordsItemDesc="值")||(WordsItemDesc="时间")||(WordsItemDesc="手术持续时间")||(WordsItemDesc="持续时间")
					{
						s MinItemValue=$p(MinItemValueStr,"&%",1)
						s MaxItemValue=$p(MaxItemValueStr,"&%",1)
						s MinContainStr=""
						s MaxContainStr=""
						s MinItemValUnitStr=""
						s MaxItemValUnitStr=""

						if (MinItemValue'="")||(MaxItemValue'="")
						{
							s ValueInfo = ..GetValuePropertyInfo(str)
							if ValueInfo["false^"
							{
								s saveresult=ValueInfo
								q
							}

							s MinContainStr=$p(ValueInfo,"##",1)
							s MaxContainStr=$p(ValueInfo,"##",2)
							s MinItemValUnitStr=$p(ValueInfo,"##",3)
							s MaxItemValUnitStr=$p(ValueInfo,"##",4)
							
							s RepeatStr2=ItemDR_","_NodeDR_","_ItemName_","_MinItemValue_"&&"_MaxItemValue_","_MinContainStr_"&&"_MaxContainStr_","_MinItemValUnitStr_"&&"_MaxItemValUnitStr
							//continue:$d(^TMPIVR("SaveWordsCondition",RepeatStr2))
						}
						s MinItemValUnit=$p(MinItemValUnitStr,"&%",1)
						s MaxItemValUnit=$p(MaxItemValUnitStr,"&%",1)
						s MinContain=$p(MinContainStr,"&%",1)
						s MaxContain=$p(MaxContainStr,"&%",1)
						
						if (MinItemValue'="")||(MaxItemValue'="")
						{
							
							s ItemObj=##class(CT.WDT.CDSS.WordsCondition).%New()
						    d ItemObj.WordsItemDRSetObjectId(ItemDR)
						    d ItemObj.NodeDRSetObjectId(NodeDR)
							s ItemObj.Sequence = 1
							s ItemObj.ConditionItemValue = MinItemValue_"&&"_MaxItemValue
							s ItemObj.ConditionItemCalculate = MinContain_"&&"_MaxContain
							s ItemObj.ConditionItemValUnit=MinItemValUnit_"&&"_MaxItemValUnit
							d ItemObj.ParentDRSetObjectId(id)
							s Itemsc=ItemObj.%Save()
							d ItemObj.%Close()
							If '$$$ISOK(Itemsc)
							{
								s saveresult = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Itemsc)  //返回错误信息
								q
							}
							else
							{
								//s RepeatStr=ItemDR_","_NodeDR_","_ItemName_","_MinItemValue_"&&"_MaxItemValue_","_MinContain_"&&"_MaxContain_","_MinItemValUnit_"&&"_MaxItemValUnit
								//s RepeatStr=ItemDR_","_NodeDR_","_ItemName_","_MinItemValue_"&&"_MaxItemValue_","_MinContain_"&&"_MaxContain_","_MinItemValUnit_"&&"_MaxItemValUnit
								//s ^TMPIVR("SaveWordsCondition",RepeatStr)=""
							}	
						}
					}
					
					
				}
				
				s RepeatStr=..SortRepeatStr(NodeDR,WordsItemDR,ItemName,ItemValueStr,ProperyNameStr,MaxItemValueStr,MinItemValueStr)
				s ^TMPIVR("SaveWordsCondition",RepeatStr)=""
			}
		}
		else
		{
			s saveresult = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  //返回错误信息
			q
		}

	}
	if (saveresult["false")
	{
		tro
	}
	else
	{
		tc
		s saveresult="true^导入成功！"
	
	}

	q saveresult
}

ClassMethod GetValuePropertyInfo(str As %String) As %String
{
	s MinItemValUnitStr=$p(str,",",8) //数值性描述最小值单位
	s MaxItemValUnitStr=$p(str,",",11) //数值性描述最大值单位
	s MinContainStr=$p(str,",",9) //是否包含最小值
	s MaxContainStr=$p(str,",",12) //是否包含最大值
	
	s TmpLen=1
	if MinItemValUnitStr'=""
	{
		s TmpLen=$l(MinItemValUnitStr,"&%")
	}
	else
	{
		s TmpLen=$l(MaxItemValUnitStr,"&%")
	}
	s NewMinContain=""
	s NewMaxContain=""
	s NewMinItemValUnit=""
	s NewMaxItemValUnit=""
	
	for MIndex=1:1:TmpLen
	{
			
		s MinContain=$p(MinContainStr,"&%",MIndex)
		s MaxContain=$p(MaxContainStr,"&%",MIndex)
		s MinItemValUnit=$p(MinItemValUnitStr,"&%",MIndex)
		s MaxItemValUnit=$p(MaxItemValUnitStr,"&%",MIndex)
		
		if (MinContain="是")||(MinContain="1")||(MinContain="Y") 
		{
			s MinContain=">="
		}
		else
		{
			s MinContain=">"
		}
		s:NewMinContain'="" NewMinContain=NewMinContain_"&%"_MinContain
		s:NewMinContain="" NewMinContain=MinContain
		
		if (MaxContain="是")||(MaxContain="1")||(MaxContain="Y") 
		{
			s MaxContain="<="
		}
		else
		{
			s MaxContain="<"
		}
		s:NewMaxContain'="" NewMaxContain=NewMaxContain_"&%"_MaxContain
		s:NewMaxContain="" NewMaxContain=MaxContain
		
		if (MinItemValUnit'="")
		{
			s MinItemValUnit=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(MinItemValUnit,"U"),0))
			if (MinItemValUnit="") //单位不存在
			{
				s saveresult="false^最小值单位在单位字典中不存在！"
				return saveresult
			}
		}
		s:NewMinItemValUnit'="" NewMinItemValUnit=NewMinItemValUnit_"&%"_MinItemValUnit
		s:NewMinItemValUnit="" NewMinItemValUnit=MinItemValUnit
		
		if (MaxItemValUnit'="")
		{
			s MaxItemValUnit=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(MaxItemValUnit,"U"),0))
			if (MaxItemValUnit="") //单位不存在
			{
				s saveresult="false^最大值单位在单位字典中不存在！"
				return saveresult
			}
		}
		s:NewMaxItemValUnit'="" NewMaxItemValUnit=NewMaxItemValUnit_"&%"_MaxItemValUnit
		s:NewMaxItemValUnit="" NewMaxItemValUnit=MaxItemValUnit
		
	}


	return NewMinContain_"##"_NewMaxContain_"##"_NewMinItemValUnit_"##"_NewMaxItemValUnit
}

/// Creator：谷雪萍
/// CreatDate:2021-08-18
/// Description:k掉识别词管理的global
/// Others：w ##class(web.CDSS.CMKB.ImportViewRules).KillIdentifyWordsGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","IdentifyWordsData.gof")
ClassMethod KillIdentifyWordsGlobal()
{
	b ;确定要删除识别词管理的所有数据吗？确定的话输 g 不确定输 q
	b ;确定要删除的数据库正确吗？确定的话输 g 不确定输 q	
	
	//***********识别词管理**************************/
	//k ^TMPIVR
	//识别词字典
	k ^CT.WDT.CDSS.IdentifyWordsD
	k ^CT.WDT.CDSS.IdentifyWordsI
	//识别词流程节点表
	k ^CT.WDT.CDSS.WordsNodeD
	k ^CT.WDT.CDSS.WordsNodeI
	//识别词流程线表
	k ^CT.WDT.CDSS.WordsLinkD
	k ^CT.WDT.CDSS.WordsLinkI	
	//识别词节点内容表（触发条件）
	k ^CT.WDT.CDSS.WordsConditionD
	k ^CT.WDT.CDSS.WordsConditionI
	//识别词流程图Json信息表 （用于还原流程图）
	k ^CT.WDT.CDSS.WordsChartD
	k ^CT.WDT.CDSS.WordsChartI	
	k ^CT.WDT.CDSS.WordsChartS
	
	q "over"
}

/// Creator：谷雪萍
/// CreatDate:2021-08-18
/// Description:导出识别词管理的global
/// Others：d ##class(web.CDSS.CMKB.ImportViewRules).ExportIdentifyWordsGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportIdentifyWordsGlobal(filePath As %String)
{
	k CList
	k myIdx
	
	//***********识别词管理**************************/
	//识别词字典
	s CList($i(CList))= "CT.WDT.CDSS.IdentifyWordsD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.IdentifyWordsI.GBL" 
	//识别词流程节点表
	s CList($i(CList))= "CT.WDT.CDSS.WordsNodeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsNodeI.GBL" 
	//识别词流程线表
	s CList($i(CList))= "CT.WDT.CDSS.WordsLinkD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsLinkI.GBL" 	
	//识别词节点内容表（触发条件）
	s CList($i(CList))= "CT.WDT.CDSS.WordsConditionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsConditionI.GBL" 
	//识别词流程图Json信息表 （用于还原流程图）
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartI.GBL" 	
	s CList($i(CList))= "CT.WDT.CDSS.WordsChartS.GBL" 			

	
    //把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"IdentifyWordsData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)  //删掉10天前的global
	w time,!
	s filename = filePath_"IdentifyWordsData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator：谷雪萍
/// CreatDate:2021-08-18
/// Description:k掉可视化规则管理的global
/// Others：w ##class(web.CDSS.CMKB.ImportViewRules).KillRulesGlobal()
/// 导入数据用d $SYSTEM.OBJ.ImportDir("D:\","RuleData.gof")
ClassMethod KillRulesGlobal()
{
	b ;确定要删除可视化规则管理的所有数据吗？确定的话输 g 不确定输 q	
	b ;确定要删除的数据库正确吗？确定的话输 g 不确定输 q	
	
	//k ^TMPIVR
	//***********识别词管理**************************/
	//诊疗规则字典
	k ^CT.WDT.CDSS.RuleDictD
	k ^CT.WDT.CDSS.RuleDictI
	//诊疗流程节点
	k ^CT.WDT.CDSS.RuleNodeD
	k ^CT.WDT.CDSS.RuleNodeI
	//诊疗流程线表
	k ^CT.WDT.CDSS.RuleLinkD
	k ^CT.WDT.CDSS.RuleLinkI	
	//诊疗流程图Json信息表
	k ^CT.WDT.CDSS.RuleChartD
	k ^CT.WDT.CDSS.RuleChartI
	k ^CT.WDT.CDSS.RuleChartS
	//触发条件表
	k ^CT.WDT.CDSS.RuleConditionD
	k ^CT.WDT.CDSS.RuleConditionI	
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	k ^CT.WDT.CDSS.RuleResultD
	k ^CT.WDT.CDSS.RuleResultI
	//诊疗节点内容表（预警规则-合理性）
	k ^CT.WDT.CDSS.RuleRationalityD
	k ^CT.WDT.CDSS.RuleRationalityI
	//诊疗节点内容表（预警规则-并发症）
	k ^CT.WDT.CDSS.RuleComplicationD
	k ^CT.WDT.CDSS.RuleComplicationI
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	k ^CT.WDT.CDSS.RuleDetailD
	k ^CT.WDT.CDSS.RuleDetailI	
	
	q "over"
}

/// Creator：谷雪萍
/// CreatDate:2021-08-18
/// Description:导出可视化规则管理的global
/// Others：d ##class(web.CDSS.CMKB.ImportViewRules).ExportRulesGlobal("D:\CDSSGlobal\NewTable\")
ClassMethod ExportRulesGlobal(filePath As %String)
{
	k CList
	k myIdx
	
	//诊疗规则字典
	s CList($i(CList))= "CT.WDT.CDSS.RuleDictD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleDictI.GBL" 
	//诊疗流程节点
	s CList($i(CList))= "CT.WDT.CDSS.RuleNodeD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleNodeI.GBL" 
	//诊疗流程线表
	s CList($i(CList))= "CT.WDT.CDSS.RuleLinkD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleLinkI.GBL" 	
	//诊疗流程图Json信息表
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartI.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleChartS.GBL" 
	//触发条件表
	s CList($i(CList))= "CT.WDT.CDSS.RuleConditionD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleConditionI.GBL" 	
	//诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
	s CList($i(CList))= "CT.WDT.CDSS.RuleResultD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleResultI.GBL" 
	//诊疗节点内容表（预警规则-合理性）
	s CList($i(CList))= "CT.WDT.CDSS.RuleRationalityD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleRationalityI.GBL" 
	//诊疗节点内容表（预警规则-并发症）
	s CList($i(CList))= "CT.WDT.CDSS.RuleComplicationD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleComplicationI.GBL" 
	//治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
	s CList($i(CList))= "CT.WDT.CDSS.RuleDetailD.GBL" 
	s CList($i(CList))= "CT.WDT.CDSS.RuleDetailI.GBL" 		

	
    //把所有GBL拼起来
	s items = ""
	for {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:items'="" items=items_","_CList(myIdx)
		s:items="" items=CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = filePath_"RuleData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)  //删掉10天前的global
	w time,!
	s filename = filePath_"RuleData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:导入规则（导csv文件）
/// Input:FilePath-csv文件，注意需要先在Excel里把英文,转换成中文，再转为csv文件
/// Return:false^错误信息/true^导入成功
/// Other:d ##class(web.CDSS.CMKB.ImportViewRules).ImportWarningRules("D:/text.csv")
ClassMethod ImportWarningRules(FilePath As %String) As %String
{
	q:FilePath="" "false^文件路径为空！"
	s file=##class(%File).%New(FilePath)
	d file.Open("RS")
	s NewFilePath=$p(FilePath,".",1)_"导入结果.csv"
	s Wfile=##class(%File).%New(NewFilePath)
	d Wfile.Open("NWS")
	s result=""
	
	k ^TMPIVR("ImportWarningRules")
	s ^TMPIVR("ImportWarningRules",1)=file.ReadLine()_",导入标识"
	s count=1
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s count=count+1
		s result=..SaveImportRules(Line)
		s ^TMPIVR("ImportWarningRules",count)=Line_","_result
	}
	
	s RowId=0
	for
	{
		s RowId=$o(^TMPIVR("ImportWarningRules",RowId))
		q:RowId=""
		d Wfile.WriteLine(^TMPIVR("ImportWarningRules",RowId))
	}
	
	d Wfile.%Save()
	d Wfile.%Close()
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-11-18
/// Description:导入规则（前端导入功能调用的接口）
/// Input:Line-导入模板中一行的内容，单元格之间用英文逗号连接
/// Return:false^错误信息/true^导入成功
/// Other:合理性预警模板：预警规则类型	规则名称	来源	批次号	备注	基本信息-年龄最小值	基本信息-年龄最小值单位	基本信息-年龄最小值是否包含	基本信息-年龄最大值	基本信息-年龄最大值单位	基本信息-年龄最大值是否包含	基本信息-性别	满足诊断条件个数	主要条件-诊断	满足主要条件个数	主要条件-识别词	满足否定条件个数	否定条件-识别词	提醒内容	禁忌级别
/// Other:并发症预警模板：预警规则类型	规则名称	来源	批次号	备注	基本信息-年龄最小值	基本信息-年龄最小值单位	基本信息-年龄最小值是否包含	基本信息-年龄最大值	基本信息-年龄最大值单位	基本信息-年龄最大值是否包含	基本信息-性别	满足诊断条件个数	主要条件-诊断	满足主要条件个数	主要条件-识别词	满足否定条件个数	否定条件-识别词	并发症	要点
/// Other:推荐类模板：规则类型	规则名称	来源	批次号	备注	基本信息-年龄最小值	基本信息-年龄最小值单位	基本信息-年龄最小值是否包含	基本信息-年龄最大值	基本信息-年龄最大值单位	基本信息-年龄最大值是否包含	基本信息-性别	满足诊断条件个数	主要条件-诊断	满足主要条件个数	主要条件-识别词	满足否定条件个数	否定条件-识别词	推荐内容	备注
/// Other:d ##class(web.CDSS.CMKB.ImportViewRules).SaveImportRules(Line)
ClassMethod SaveImportRules(Line As %String) As %String
{
	s ^TMP("RuleLine")=Line
	q:Line="" "false^传入的行数据不能为空！"
	s Line = ..DealSymbol(Line)  //处理符号
	s ImportResult=""
	s WordsId ="",FlowChartNum=""
	s RuleTypeDesc=$p(Line,",",1)  //预警规则类型
	s RuleTypeDR=""
	s RuleProvision=$p(Line,",",24) //规则来源（dhcc或者医院名称）
	if (RuleTypeDesc="推荐鉴别诊断")||(RuleTypeDesc="推荐检验检查")||(RuleTypeDesc="推荐护理处置")
	{
 		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐治疗方案",0))
 		s RuleTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_RuleTypeDesc,0))
	}
	elseif(RuleTypeDesc["评估表")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐评估表",0))
	}
	elseif(RuleTypeDesc="诊断合理性")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 疾病预警",0))
	}
	elseif(RuleTypeDesc="推荐确诊")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 疾病预警",0))
	}
	elseif(RuleTypeDesc="过敏合理性")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 过敏预警",0))
	}
	elseif(RuleTypeDesc="输血合理性")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 输血预警",0))
	}
	elseif(RuleTypeDesc="评估表自动勾选")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 评估表自动勾选",0))
	}
	elseif(RuleTypeDesc="药品合理性-高危警示")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 药品合理性",0))
	}
	elseif(RuleTypeDesc="病历书写合理性")
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 病历书写合理性",0))
	}
	else
	{
		s RuleType=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_RuleTypeDesc,0))
	}
	
	if RuleTypeDesc="评估表自动勾选"
	{
		if ($p(Line,",",6)="")&&($p(Line,",",9)="")&&($p(Line,",",12)="")&&($p(Line,",",14)="")&&($p(Line,",",16)="")&&($p(Line,",",18)="")
		{
			q "false^规则为空"
		}
	}

	
	if (RuleType="")
	{
		q "false^规则类型填写错误！"
	}
	if RuleTypeDesc="评估表自动勾选"
	{
		s RuleDesc=$p(Line,",",2)_$p(Line,",",3)
		s RuleDesc=$replace(RuleDesc,",","，")
	}
	else
	{
		s RuleDesc=$p(Line,",",2)  //规则名称
	}
	
 	if (RuleDesc="")
	{
		q "false^规则名称不能为空！"
	}	
	
	if RuleTypeDesc="评估表自动勾选"
	{
		s RuleSource=$p(Line,",",3)  //题干序号
		s RuleTitle = $p(Line,",",4)
		s RuleDescPre = $replace($p(Line,",",2),",","，")
		s Remarks=##class(web.CDSS.Access.AssBaseFieldItem).GetItemId(RuleDescPre,$p(Line,",",3))
		if Remarks ["-1"
		{
			q "false^"_Remarks
		}
		if Line["null"
		{
			q "false^空条件"
		}
	}
	else
	{
		s RuleSource=$p(Line,",",3)  //来源
		s Remarks=$p(Line,",",5)
	}
	
	s LocIds=""  //科室ID串，用&%连接
	s LocStr=$p(Line,",",21)  //科室描述串，用&%连接
	s LocsLen=$l(LocStr,"&%")
	for LocItem=1:1:LocsLen
	{
		s loc=$p(LocStr,"&%",LocItem)
		continue:loc=""
		s locid=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(loc,"U"),0))
		if (locid="")
		{
			s ImportResult="false^"_loc_"在科室字典表中不存在"
			q
		}
		else
		{
			s:LocIds'="" LocIds=LocIds_"&%"_locid
			s:LocIds="" LocIds=locid
		}
	}
	if (ImportResult["false")
	{
		q ImportResult
	}
	TS
	s RuleId=""
	if ($d(^CT.WDT.CDSS.RuleDictI("TypeDescIndex",RuleType,RuleDesc)))  //如果规则已经存在，则获取规则id
	{
		
		s RuleId=$o(^CT.WDT.CDSS.RuleDictI("TypeDescIndex",RuleType,RuleDesc,0))
		s RuleObj=##class(CT.WDT.CDSS.RuleDict).%OpenId(RuleId)
	}
	else  //如果规则不存在，则新增规则
	{
		s RuleObj=##class(CT.WDT.CDSS.RuleDict).%New() 
		s RuleObj.RuleCode = ##class(web.CDSS.CMKB.RuleDict).GetLastCode()
	}
	s RuleObj.RuleDesc = RuleDesc
	
	if RuleTypeDesc'="评估表自动勾选"
	{
		s RuleObj.RuleSource=RuleSource
		s RuleObj.BatchNum=$p(Line,",",4)
		s RuleObj.RuleLoc=LocIds
		
	}
	s RuleObj.Remarks=Remarks
	d RuleObj.RuleTypeSetObjectId(RuleType)
	s RuleObj.RuleStatus="审核通过"
	s RuleObj.UpdateDate = $zdt($h,3)
	s UpdateUser="谷雪萍"
	s AuditUser="毛庆荣"
	if $d(%session)
	{
		s UpdateUser=$g(%session.Data("LOGON.USERNAME"))
		s AuditUser=$g(%session.Data("LOGON.USERNAME"))
	}
	s RuleObj.UpdateUser = UpdateUser
	s RuleObj.AuditDate = $zdt($h,3)
	s RuleObj.AuditUser = AuditUser
	s RuleObj.RuleProvision = RuleProvision
	s RuleSC=RuleObj.%Save()
	d RuleObj.%Close()
	
	if $$$ISOK(RuleSC)
	{
		s RuleId = RuleObj.%Id()  //规则id
		
		if (RuleId'="") //获取流程图顺序号
		{
			s RuleTypeId=RuleTypeDR
			if (RuleTypeDR="")
			{
				s RuleTypeId=-100000000000000
			}

			s FlowChartNum=$o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleId,RuleTypeId,""),-1)
			s:FlowChartNum="" FlowChartNum=0
			s FlowChartNum=FlowChartNum+1
			//保存节点
			s result=..SaveAllRuleNode(RuleId,RuleTypeDR,Line,FlowChartNum)

			if (result["false")
			{
				s ImportResult=result
			}
			else  //保存节点连线
			{
				s result=..SaveAllRuleNodeLink(RuleId,FlowChartNum,RuleTypeDR)
				if (result["false")
				{
					s ImportResult=result
				}
				else
				{
					//删除json图信息
					s RuleChartId=$O(^CT.WDT.CDSS.RuleChartI("RuleTypeDRIndex",RuleId,RuleTypeId,""))
					if (RuleChartId'="")
					{
						s ChartSC=##class(CT.WDT.CDSS.RuleChart).%DeleteId(RuleChartId)
						if '$$$ISOK(ChartSC)
						{
							s ImportResult = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ChartSC)  //返回错误信息
						}
					}
				}	
			}
		}
		if (RuleTypeDesc="评估表自动勾选")&(ImportResult'["false")
		{
			d ##class(web.CDSS.Access.AssBaseFieldItem).SaveRuleData(Remarks,RuleId)
		}

	}
	else
	{
		s ImportResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(RuleSC)  //返回错误信息	
	}

	if (ImportResult["false")
	{
		tro
	}
	else
	{
		tc
		s ImportResult="true^导入成功！"	
	}
	q ImportResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-16
/// Description:获取节点顺序号最大值
/// Table:CT.WDT.CDSS.RuleNode
/// Input:RuleId-规则id，RuleTypeDR-图类型(只有辅助诊疗规则会用到)
/// Return:最大的NodeNum
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).GetMaxRuleNodeNum(RuleId,RuleTypeDR)
ClassMethod GetMaxRuleNodeNum(RuleId As %String, RuleTypeDR As %String = "") As %String
{
	q:(RuleId="") 0
	s:RuleTypeDR="" RuleTypeDR=-100000000000000
	s MaxRuleNodeNum=0
	s NodeId=0   //节点id
	for
	{
		s NodeId=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleId,RuleTypeDR,NodeId))
		q:NodeId=""
		s NodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeId)),4)
		if (NodeNum>MaxRuleNodeNum)
		{
			s MaxRuleNodeNum=NodeNum
		}
	}
	q MaxRuleNodeNum
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存该规则下所有的规则节点
/// Table:CT.WDT.CDSS.RuleNode
/// Input:RuleId-规则id，RuleTypeDR-图类型(只有辅助诊疗规则会用到)，Line-Excel某一行的信息串,FlowChartNum-流程图顺序号
/// Return:result
/// Other:d ##class(web.CDSS.CMKB.ImportViewRules).SaveAllRuleNode(RuleId,RuleTypeDR,Line,FlowChartNum)
ClassMethod SaveAllRuleNode(RuleId As %String, RuleTypeDR As %String = "", Line As %String, FlowChartNum As %String) As %String
{
	q:(RuleId="")||(Line="") "false^保存该规则下所有的规则节点时，没有获取到规则id，或者传入的行信息串为空！"
	q:(FlowChartNum="") "false^保存该规则下所有的规则节点时，流程图顺序号不能为空"
	s AgeMin=$p(Line,",",6)  //年龄最小值
	s AgeMinUom=$p(Line,",",7)  //年龄最小值单位
	s AgeMinContain=$p(Line,",",8)  //年龄最小值是否包含
	s AgeMax=$p(Line,",",9)  //年龄最大值
	s AgeMaxUom=$p(Line,",",10)  //年龄最大值单位
	s AgeMaxContain=$p(Line,",",11)  //年龄最大值是否包含
	s Sex=$p(Line,",",12)  //性别
	s DiaNum=$p(Line,",",13)  //满足诊断条件个数
	s DiaStr=$p(Line,",",14)  
	s MainNum=$p(Line,",",15)  //满足主要条件个数
	s MainStr=$p(Line,",",16)  //主要条件-识别词
	s NegativeNum=$p(Line,",",17)  //满足否定条件个数
	s NegativeStr=$p(Line,",",18)  //否定条件-识别词

	s WarningRemind=$p(Line,",",19)  //提示内容-合理性预警类/推荐内容-推荐类/并发症-并发症预警类
	s WarningType=$p(Line,",",20)  //禁忌级别-合理性预警类/备注-推荐类/要点-并发症预警类
	s NegativeDiaNum=$p(Line,",",22)  //满足否定条件-诊断个数
	s NegativeDiaStr=$p(Line,",",23)  //否定条件-诊断

	
	s PassNum=$p(Line,",",25)  //满足通过条件个数
	s PassStr=$p(Line,",",26)  //通过条件-识别条件 
	
	s DrugStr=$p(Line,",",27) //推荐药品  多个用&连接
	s OperStr=$p(Line,",",28) //推荐手术 多个用&连接
	//s OperRemarksStr=$p(Line,",",29) //推荐手术备注 多个用&连接 
	s TcmTreatZ = $p(Line,",",29)   //中医治法
	s TcmTreatC = $p(Line,",",30)   //中医处置
	//s RemarksStr = $p(Line,",",31)  //手术或治法备注 
	
	//s DrugDoseMin=$p(Line,",",32)  //推荐治疗方案-药品最小剂量
	//s DrugDoseMinUnit=$p(Line,",",33)  //推荐治疗方案-药品最小剂量单位
	//s DrugDoseMax=$p(Line,",",34)  //推荐治疗方案-药品最大剂量
	//s DrugDoseMaxUnit=$p(Line,",",35)  //推荐治疗方案-药品最大剂量单位
	
	//s Extra=$p(Line,",",36) //推荐治疗方案药品用法/手术方式/处置类型
	//s DrugFreq=$p(Line,",",37)  //推荐治疗方案药品频次
	//s TcmTreatF=$p(Line,",",37) //推荐治疗方案方剂
	//s TcmTreatFFreq=$p(Line,",",38)  //推荐治疗方案方剂频次
	//s TcmTreatCD=$p(Line,",",39)   //推荐治疗方案处置明细
	//s TcmTreatCDDose=$p(Line,",",40)   // 推荐治疗方案处置明细常规剂量
	//s TcmTreatCDDoseUnit=$p(Line,",",41) //推荐治疗方案处置明细常规剂量单位
	//s TcmTreatFCompose=$p(Line,",",42)   //推荐治疗方案方剂组成
	//s TcmTreatFComposeDose=$p(Line,",",43)  //推荐治疗方案方剂组成常规剂量 
	//s TcmTreatFComposeDoseUnit=$p(Line,",",44) //推荐治疗方案方剂组成常规剂量单位
	//s TcmTreatFComposeJ=$p(Line,",",44)  //推荐治疗方案方剂组成煎发
	
	
	s result=""

	TS 
	//保存开始节点
	s StartStr=RuleId_","_FlowChartNum_","_FlowChartNum_",开始,,,0,0"
	s StartNodeId=..SaveRuleNode(StartStr,RuleTypeDR)
	s:StartNodeId="" result="false^开始节点保存失败！"
	
	s NodeNum=..GetMaxRuleNodeNum(RuleId,RuleTypeDR)
	//保存年龄节点
	if ((AgeMin'="")||(AgeMax'=""))&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",基本信息-年龄,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
		//保存年龄节点内容到DHCDSSRuleCondition表
		if (SaveNodeId'="")
		{
			if (AgeMin'="")&(result'["false") //保存年龄最小值
			{
				if (AgeMinContain="是")||(AgeMinContain="1")||(AgeMinContain="Y") 
				{
					s ConditionItemCalculate=">="
				}
				else
				{
					s ConditionItemCalculate=">"
				}

				// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
				s ConditionStr=SaveNodeId_",年龄,Age,"_ConditionItemCalculate_","_AgeMin_","_AgeMinUom
				s result =..SaveRuleCondition(ConditionStr)
	
			}
			if (AgeMax'="")&(result'["false") //保存年龄最大值
			{
				if (AgeMaxContain="是")||(AgeMaxContain="1")||(AgeMaxContain="Y") 
				{
					s ConditionItemCalculate="<="
				}
				else
				{
					s ConditionItemCalculate="<"
				}
				// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
				s ConditionStr=SaveNodeId_",年龄,Age,"_ConditionItemCalculate_","_AgeMax_","_AgeMaxUom
				s result =..SaveRuleCondition(ConditionStr)
			}
		}
		else
		{
			s result="false^年龄节点没保存成功！"
		}
	}
	//保存性别节点
	if (Sex'="")&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",基本信息-性别,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)	
		//保存性别节点内容到DHCDSSRuleCondition表
		if (SaveNodeId'="")
		{
			// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
			s ConditionStr=SaveNodeId_",性别,Sex,=,"_Sex
			s result =..SaveRuleCondition(ConditionStr)	
		}
		else
		{
			s result="false^性别节点没保存成功！"
		}

	}
	//保存诊断条件节点
	if (DiaStr'="")&(result'["false")
	{
		if (DiaStr'["｜")
		{
			s NodeNum=NodeNum+1
			s MeetConditionNum=$l(DiaStr,"&")
			s MeetConditionNum=$tr(MeetConditionNum," ","")
			s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",主要条件-诊断,"_MeetConditionNum_",,0,0"
			s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
			
			if (SaveNodeId'="")
			{
				///保存诊断条件节点内容
				for DiaItem=1:1:MeetConditionNum
				{
					s DiaNameType=$p(DiaStr,"&",DiaItem)
					if $l(DiaNameType,"：")>1
					{
						s DiaType=$p(DiaNameType,"：",1)
						s DiaName=$p(DiaNameType,"：",2)
					}
					else
					{
						s DiaName=$p(DiaNameType,"：",1)
						s DiaType="西医"
					}
					s DiaName=$p(DiaName,"~",1)
					s NewFlag=$p(DiaName,"~",2)
					s:NewFlag="" NewFlag="new"
					// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
					s ConditionStr=SaveNodeId_",,,=,"_DiaName_",,"_NewFlag_","_DiaType
					s result =..SaveRuleCondition(ConditionStr)
					if (result["false")
					{
						q
					}
	
				}
			}
			else
			{
				s result="false^诊断条件节点没保存成功！"
			}	
		}
		else
		{
			s DiaStrLen=$l(DiaStr,"&")  //包含|的按照&拆分成几个条件框
			for DiaNodeItem=1:1:DiaStrLen
			{
				s OneDiaStr=$p(DiaStr,"&",DiaNodeItem)
				s MeetConditionNum=$p(DiaNum,"&",DiaNodeItem)
				s MeetConditionNum=$tr(MeetConditionNum," ","")
				s:MeetConditionNum="" MeetConditionNum=1
				s NodeNum=NodeNum+1
				s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",主要条件-诊断,"_MeetConditionNum_",,0,0"
				s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
				
				if (SaveNodeId'="")
				{
					///保存诊断条件节点内容
					s DiaItemLen=$l(OneDiaStr,"｜")  //按照|拆分具体的条件
					for DiaItem=1:1:DiaItemLen
					{
						s DiaNameType=$p(OneDiaStr,"｜",DiaItem)
						if $l(DiaNameType,"：")>1
						{
							s DiaType=$p(DiaNameType,"：",1)
							s DiaName=$p(DiaNameType,"：",2)
						}
						else
						{
							s DiaName=$p(DiaNameType,"：",1)
							s DiaType="西医"
						}
						s DiaName=$p(DiaName,"~",1)
						s NewFlag=$p(DiaName,"~",2)
						s:NewFlag="" NewFlag="new"
						// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
						s ConditionStr=SaveNodeId_",,,=,"_DiaName_",,"_NewFlag_","_DiaType
						s result =..SaveRuleCondition(ConditionStr)
						if (result["false")
						{
							q
						}
					}	
				}
				else
				{
					s result="false^诊断条件节点没保存成功！"
				}
				
			}
		}
		
	}
	//保存通过条件
	if (PassStr'="")&(result'["false")
	{
		if (PassStr'["｜")
		{
			s NodeNum=NodeNum+1
			s MeetConditionNum=$l(PassStr,"&")
			s MeetConditionNum=$tr(MeetConditionNum," ","")
			s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",通过条件,"_MeetConditionNum_",,0,0"
			s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
			
			if (SaveNodeId'="")
			{
				///保存诊断条件节点内容
				for DiaItem=1:1:MeetConditionNum
				{
					s DiaNameType=$p(PassStr,"&",DiaItem)
					if $l(DiaNameType,"：")>1
					{
						s DiaType=$p(DiaNameType,"：",1)
						s DiaName=$p(DiaNameType,"：",2)
					}
					else
					{
						s DiaType="西医"
						s DiaName=$p(DiaNameType,"：",1)	
					}
					s DiaName=$p(DiaName,"~",1)
					s NewFlag=$p(DiaName,"~",2)
					s:NewFlag="" NewFlag="new"
					// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
					s ConditionStr=SaveNodeId_",,,=,"_DiaName_",,"_NewFlag_","_DiaType
					s result =..SaveRuleCondition(ConditionStr)
					if (result["false")
					{
						q
					}
	
				}
			}
			else
			{
				s result="false^通过条件节点没保存成功！"
			}
		}
		else
		{
			s PassStrLen=$l(PassStr,"&")  //包含|的按照&拆分成几个条件框
			for PassNodeItem=1:1:PassStrLen
			{
				s OnePassStr=$p(PassStr,"&",PassNodeItem)
				s MeetConditionNum=$p(PassNum,"&",PassNodeItem)
				s MeetConditionNum=$tr(MeetConditionNum," ","")
				s:MeetConditionNum="" MeetConditionNum=1
				s NodeNum=NodeNum+1
				s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",通过条件,"_MeetConditionNum_",,0,0"
				s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
				
				if (SaveNodeId'="")
				{
					///保存诊断条件节点内容
					s PassItemLen=$l(OnePassStr,"｜")  //按照|拆分具体的条件
					for PassItem=1:1:PassItemLen
					{
						s PassNameType=$p(OnePassStr,"｜",PassItem)
						if $l(PassNameType,"：")>1
						{
							s PassType=$p(PassNameType,"：",1)
							s PassName=$p(PassNameType,"：",2)
						}
						else
						{
							s PassName=$p(PassNameType,"：",1)
							s PassType="西医"	
						}
						s PassName=$p(PassName,"~",1)
						s NewFlag=$p(PassName,"~",2)
						s:NewFlag="" NewFlag="new"
						// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
						s ConditionStr=SaveNodeId_",,,=,"_PassName_",,"_NewFlag_","_PassType
						s result =..SaveRuleCondition(ConditionStr)
						if (result["false")
						{
							q
						}
					}	
				}
				else
				{
					s result="false^通过条件节点没保存成功！"
				}
				
			}
		}
	}
	//保存否定条件-诊断节点
	if (NegativeDiaStr'="")&(result'["false")
	{
		if (NegativeDiaStr'["｜")
		{
			s NodeNum=NodeNum+1
			s MeetConditionNum=$l(NegativeDiaStr,"&")
			s MeetConditionNum=$tr(MeetConditionNum," ","")
			s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",否定条件-诊断,"_MeetConditionNum_",,0,0"
			s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
			
			if (SaveNodeId'="")
			{
				///保存诊断条件节点内容
				for DiaItem=1:1:MeetConditionNum
				{
					s DiaNameType=$p(NegativeDiaStr,"&",DiaItem)
					if $l(DiaNameType,"：")>1
					{
						s DiaType=$p(DiaNameType,"：",1)
						s DiaName=$p(DiaNameType,"：",2)
					}
					else
					{
						s DiaType="西医"
						s DiaName=$p(DiaNameType,"：",1)	
					}
					s DiagName=$p(DiaName,"~",1)
					s NewFlag=$p(DiaName,"~",2)
					s:NewFlag="" NewFlag="new"
					// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
					s ConditionStr=SaveNodeId_",,,=,"_DiaName_",,"_NewFlag_","_DiaType
					s result =..SaveRuleCondition(ConditionStr)
					if (result["false")
					{
						q
					}
	
				}
			}
			else
			{
				s result="false^否定条件-诊断节点没保存成功！"
			}	
		}
		else
		{
			s NegativeDiaStrLen=$l(NegativeDiaStr,"&")  //包含|的按照&拆分成几个条件框
			for DiaNodeItem=1:1:NegativeDiaStrLen
			{
				s OneNegativeDiaStr=$p(NegativeDiaStr,"&",DiaNodeItem)
				s MeetConditionNum=$p(NegativeDiaNum,"&",DiaNodeItem)
				s MeetConditionNum=$tr(MeetConditionNum," ","")
				s:MeetConditionNum="" MeetConditionNum=1
				s NodeNum=NodeNum+1
				s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",否定条件-诊断,"_MeetConditionNum_",,0,0"
				s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
				
				if (SaveNodeId'="")
				{
					///保存诊断条件节点内容
					s DiaItemLen=$l(OneNegativeDiaStr,"｜")  //按照|拆分具体的条件
					for DiaItem=1:1:DiaItemLen
					{
						s DiaNameType=$p(OneNegativeDiaStr,"｜",DiaItem)
						if $l(DiaNameType,"：")>1
						{
							s DiaType=$p(DiaNameType,"：",1)
							s DiaName=$p(DiaNameType,"：",2)
						}
						else
						{
							s DiaType="西医"
							s DiaName=$p(DiaNameType,"：",1)	
						}
						s DiagName=$p(DiaName,"~",1)
						s NewFlag=$p(DiaName,"~",2)
						s:NewFlag="" NewFlag="new"
						// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
						s ConditionStr=SaveNodeId_",,,=,"_DiaName_",,"_NewFlag_","_DiaType
						s result =..SaveRuleCondition(ConditionStr)
						if (result["false")
						{
							q
						}
					}	
				}
				else
				{
					s result="false^否定条件-诊断节点没保存成功！"
				}
				
			}
		}
		
	}
	//保存主要条件-识别词节点
	if (MainStr'="")&(result'["false")
	{
		if (MainStr'["｜")
		{
			s NodeNum=NodeNum+1
			s MeetConditionNum=$l(MainStr,"&")
			s MeetConditionNum=$tr(MeetConditionNum," ","")
			s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",主要条件-识别词,"_MeetConditionNum_",,0,0"
			s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
			if (SaveNodeId'="")
			{
				///保存主要条件-识别词节点内容
				for WordsItem=1:1:MeetConditionNum
				{
					s WordsNameType=$p(MainStr,"&",WordsItem)
					// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
					if $l(WordsNameType,"：")>1
					{
						s WordsType=$p(WordsNameType,"：",1)
						s WordsName=$p(WordsNameType,"：",2)
					}
					else
					{
						s WordsType="西医"	
						s WordsName=$p(WordsNameType,"：",1)
					}
					s WordsName=$p(WordsName,"~",1)
					s NewFlag=$p(WordsName,"~",2)
					s:NewFlag="" NewFlag="new"
					s ConditionStr=SaveNodeId_",,,=,"_WordsName_",,"_NewFlag_","_WordsType
					s result =..SaveRuleCondition(ConditionStr)
					if (result["false")
					{
						q
					}
				}
			}
			else
			{
				s result="false^主要条件-识别词节点没保存成功！"
			}
		}
		else
		{
			s MainStrLen=$l(MainStr,"&")
			for MainItem=1:1:MainStrLen
			{
				s OneMainStr=$p(MainStr,"&",MainItem)
				s MeetConditionNum=$p(MainNum,"&",MainItem)
				s MeetConditionNum=$tr(MeetConditionNum," ","")
				s:MeetConditionNum="" MeetConditionNum=1
				s NodeNum=NodeNum+1
				s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",主要条件-识别词,"_MeetConditionNum_",,0,0"
				s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
				if (SaveNodeId'="")
				{
					///保存主要条件-识别词节点内容
					s WordsItemLen=$l(OneMainStr,"｜")  //按照|拆分具体的条件
					for WordsItem=1:1:WordsItemLen
					{
						s WordsNameType=$p(OneMainStr,"｜",WordsItem)
						if $l(WordsNameType,"：")>1
						{
							s WordsType=$p(WordsNameType,"：",1)
							s WordsName=$p(WordsNameType,"：",2)
						}
						else
						{
							s WordsType="西医"	
							s WordsName=$p(WordsNameType,"：",1)
						}
						s WordsName=$p(WordsName,"~",1)
						s NewFlag=$p(WordsName,"~",2)
						s:NewFlag="" NewFlag="new"
						// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
						s ConditionStr=SaveNodeId_",,,=,"_WordsName_",,"_NewFlag_","_WordsType
						s result =..SaveRuleCondition(ConditionStr)
						if (result["false")
						{
							q
						}
						
					}
				}
				else
				{
					s result="false^主要条件-识别词节点没保存成功！"
					q
				}
			}
		}

	}
	//保存否定条件-识别词节点
	if (NegativeStr'="")&(result'["false")
	{
		if (NegativeStr'["｜")
		{
			s NodeNum=NodeNum+1
			s MeetConditionNum=$l(NegativeStr,"&")
			s MeetConditionNum=$tr(MeetConditionNum," ","")
			s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",否定条件-识别词,"_MeetConditionNum_",,0,0"
			s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
			if (SaveNodeId'="")
			{
				///保存否定条件-识别词节点内容
				for WordsItem=1:1:MeetConditionNum
				{
					s WordsNameType=$p(NegativeStr,"&",WordsItem)
					if $l(WordsNameType,"：")>1
					{
						s WordsType=$p(WordsNameType,"：",1)
						s WordsName=$p(WordsNameType,"：",2)
					}
					else
					{
						s WordsType="西医"	
						s WordsName=$p(WordsNameType,"：",1)
					}
					s WordsName=$p(WordsName,"~",1)
					s NewFlag=$p(WordsName,"~",2)
					s:NewFlag="" NewFlag="new"
					// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
					s ConditionStr=SaveNodeId_",,,=,"_WordsName_",,"_NewFlag_","_WordsType
					s result =..SaveRuleCondition(ConditionStr)
					if (result["false")
					{
						q
					}
				}
			}
			else
			{
				s result="false^否定条件-识别词节点没保存成功！"
			}
		}
		else
		{
			s NegativeStrLen=$l(NegativeStr,"&")
			for NegativeItem=1:1:NegativeStrLen
			{
				s OneNegativeStr=$p(NegativeStr,"&",NegativeItem)
				s MeetConditionNum=$p(NegativeNum,"&",NegativeItem)
				s MeetConditionNum=$tr(MeetConditionNum," ","")
				s:MeetConditionNum="" MeetConditionNum=1
				s NodeNum=NodeNum+1
				s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",否定条件-识别词,"_MeetConditionNum_",,0,0"
				s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
				if (SaveNodeId'="")
				{
					///保存否定条件-识别词节点内容
					s WordsItemLen=$l(OneNegativeStr,"｜")  //按照|拆分具体的条件
					for WordsItem=1:1:WordsItemLen
					{
						s WordsNameType=$p(OneNegativeStr,"｜",WordsItem)
						if $l(WordsNameType,"：")>1
						{
							s WordsType=$p(WordsNameType,"：",1)
							s WordsName=$p(WordsNameType,"：",2)
						}
						else
						{
							s WordsType="西医"	
							s WordsName=$p(WordsNameType,"：",1)
						}
						s WordsName=$p(WordsName,"~",1)
						s NewFlag=$p(WordsName,"~",2)
						s:NewFlag="" NewFlag="new"
						// 保存节点内容	NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks			
						s ConditionStr=SaveNodeId_",,,=,"_WordsName_",,"_NewFlag_","_WordsType
						s result =..SaveRuleCondition(ConditionStr)
						if (result["false")
						{
							q
						}
					}
				}
				else
				{
					s result="false^否定条件-识别词节点没保存成功！"
					q
				}

			}
		}
	}
	//预警提醒
	if (WarningRemind'="")&(result'["false")
	{
		s RuleTypeDesc=$p(Line,",",1)  //预警规则类型
		if (RuleTypeDesc="疾病预警")
		{
			s RuleTypeDesc="诊断合理性"
		}
		if (RuleTypeDesc="输血预警")
		{
			s RuleTypeDesc="输血合理性"
		}
		if (RuleTypeDesc="过敏预警")
		{
			s RuleTypeDesc="过敏合理性"
		}

		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_","_RuleTypeDesc_",,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)
	
		//保存预警提醒内容/推荐内容/并发症
		if (SaveNodeId'="")
		{

			if (RuleTypeDesc["合理性") //如果是合理性预警则保存到CT.WDT.CDSS.RuleRationality表
			{
				if RuleTypeDesc="药品合理性-高危警示"
				{
					s RuleTypeDesc="药品合理性"
				}
				s RuleTreatSource=$p(Line,",",25)
				// 保存节点内容	NodeDr,TabooLevel,WarningContent,Remarks			
				s RationalityStr=SaveNodeId_","_WarningType_","_WarningRemind_","_RuleTreatSource
				s result =..SaveRuleRationality(RationalityStr)	
			}
			elseif (RuleTypeDesc["并发症")  //如果是并发症预警则保存到CT.WDT.CDSS.RuleComplication
			{
				// 保存节点内容	NodeDr,TabooLevel,WarningContent,Remarks	
				s RuleTreatSource=$p(Line,",",25)		
				s RationalityStr=SaveNodeId_","_WarningRemind_","_WarningType_","_RuleTreatSource
				s result =..SaveRuleComplication(RationalityStr)	
			}
			else  //如果是推荐类的，则保存到推荐表CT.WDT.CDSS.RuleResult
			{
				// 保存节点内容	NodeDr,TabooLevel,WarningContent,Remarks	
				s RuleTreatSource=$p(Line,",",47) //推荐/预警等内容单条来源		
				s RationalityStr=SaveNodeId_","_WarningRemind_","_WarningType_","_RuleTreatSource
				s result =..SaveRuleResult(RationalityStr)	
			}
		}
		else
		{
			s result="false^预警提醒节点没保存成功！"
		}
		
	}
	//保存推荐治疗方案-药品节点
	if (DrugStr'="")&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",推荐治疗方案-药品,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)	
		//保存推荐治疗方案-药品节点内容到DHCDSSRuleDetail表
		if (SaveNodeId'="")
		{
			s LineLen=$l(Line,",")
			s DetailStr=SaveNodeId_","_$p(Line,",",27,LineLen)
			s result =..SaveRuleDetail(DetailStr)	
		}
		else
		{
			s result="false^推荐治疗方案-药品节点没保存成功！"
		}

	}
	//保存推荐治疗方案-手术节点
	if (OperStr'="")&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",推荐治疗方案-手术,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)	
		//保存推荐治疗方案-手术节点内容到DHCDSSRuleDetail表
		if (SaveNodeId'="")
		{
			s LineLen=$l(Line,",")
			s DetailStr=SaveNodeId_","_$p(Line,",",27,LineLen)
			s result =..SaveRuleDetail(DetailStr)	
		}
		else
		{
			s result="false^推荐治疗方案-手术节点没保存成功！"
		}

	}
	//保存推荐治疗方案-治法
	if (TcmTreatZ'="")&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",推荐治疗方案-治法,,,0,0"
		s SecondNodeNum=NodeNum+1
		s SaveSecondStr = RuleId_","_FlowChartNum_","_SecondNodeNum_",推荐治疗方案-方剂,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)	
		s SaveSecondNodeId=..SaveRuleNode(SaveSecondStr,RuleTypeDR)	
		if ((SaveNodeId'="")&(SaveSecondNodeId'=""))
		{
			s LineLen=$l(Line,",")
			s DetailStr=SaveNodeId_","_$p(Line,",",27,LineLen)_","_SaveSecondNodeId
			s result =..SaveRuleDetail(DetailStr)	
		}
		else
		{
			s result="false^推荐治疗方案-手术节点没保存成功！"
		}

	}
	
	if (TcmTreatC'="")&(result'["false")
	{
		s NodeNum=NodeNum+1
		s SaveStr=RuleId_","_FlowChartNum_","_NodeNum_",推荐治疗方案-处置,,,0,0"
		s SaveNodeId=..SaveRuleNode(SaveStr,RuleTypeDR)	
		if (SaveNodeId'="")
		{
			s LineLen=$l(Line,",")
			s DetailStr=SaveNodeId_","_$p(Line,",",27,LineLen)
			s result =..SaveRuleDetail(DetailStr)	
		}
		else
		{
			s result="false^推荐治疗方案-手术节点没保存成功！"
		}
	}
	if (result'["false")
	{
		s EndStr=RuleId_","_FlowChartNum_","_FlowChartNum_",结束,,,0,0"
		s EndNodeId=..SaveRuleNode(EndStr,RuleTypeDR)
		s:EndNodeId="" result="false^结束节点保存失败！"
	}
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result="true^所有节点保存成功！"
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存规则节点
/// Table:CT.WDT.CDSS.RuleNode
/// Input:str=规则指针,流程图顺序号,节点顺序号,节点类型,需满足条件个数,备注,left坐标,top坐标,RuleTypeDR-图类型
/// Return: 节点id
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleNode(str,RuleTypeDR)
ClassMethod SaveRuleNode(str As %String, RuleTypeDR As %String = "") As %String
{
	q:str="" ""

	s id=""
	s RuleDR=$p(str,",",1)  //规则指针
	s FlowChartNum=$p(str,",",2) //流程图顺序号
	s NodeType=$p(str,",",4)  //节点类型
	if NodeType="药品合理性-高危警示"
	{
		s NodeType="高危警示"
	}
	q:(RuleDR="")||(FlowChartNum="")||(NodeType="") ""
	s obj=##class(CT.WDT.CDSS.RuleNode).%New()
	d obj.RuleDRSetObjectId(RuleDR)
	s obj.FlowChartNum = FlowChartNum
	s obj.NodeNum = $p(str,",",3)  //节点顺序号
	s NodeType=$o(^CT.WDT.CDSS.NodeTypeI("DescIndex"," "_$ZCONVERT(NodeType,"U"),0))
	q:NodeType="" ""
	d obj.NodeTypeSetObjectId(NodeType)
	s MeetConditionNum=$p(str,",",5)
	s MeetConditionNum=$tr(MeetConditionNum," ","")
	s obj.MeetConditionNum = MeetConditionNum  //需满足条件个数
	s obj.Remarks = $p(str,",",6) //备注
	s obj.ChartLeft = $p(str,",",7) //left坐标
	s obj.ChartTop = $p(str,",",8) //top坐标
	d:RuleTypeDR'="" obj.RuleTypeDRSetObjectId(RuleTypeDR) //图类型
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
	}
	else
	{
		Trollback
	}
	q id
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存规则触发条件
/// Table:CT.WDT.CDSS.RuleCondition
/// Input:str=NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks
/// Return: false^错误信息/true^导入成功
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleCondition(str)
ClassMethod SaveRuleCondition(str As %String) As %String
{
	q:str="" "false^保存规则触发条件入参为空！"
	s ConditionResult=""
	s NodeDR=$p(str,",",1)  //规则节点id
	s ConditionClass = $p(str,",",2)
	s ConditionItemValue=$p(str,",",5) //规则条件值
	//s ConditionItemValue=##class(web.BDP.util.String).Replace(ConditionItemValue," ","")
	s ConditionItemCategory=$p(str,",",8) //规则条件类型
	
	
	q:(NodeDR="") "false^保存规则触发条件时没获取到规则节点！"
	q:(ConditionItemValue="") "true^保存规则触发条件时没获取规则条件值,无需保存空条件！"

	if (ConditionClass'="年龄")&($d(^CT.WDT.CDSS.RuleConditionI("NodeCondiIndex",NodeDR,ConditionItemValue)))
	{
		q "true^该规则触发条件-"_ConditionItemValue_"已经存在！"
		
	}

	s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)  //节点类型
	s NodeTypeDesc=""
	s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)  //节点类型描述
	if (NodeTypeDesc="")
	{
		q "false^保存规则触发条件时没有获取到节点类型！"
	}
	if (NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="通过条件") //如果识别词字典里没有该识别词则需要新增
	{
		s WordsID=..SaveIdentifyWords(ConditionItemValue,"识别条件","编辑中",ConditionItemCategory)
		q:WordsID="" "false^保存规则触发条件时往识别词字典里新增失败！"
	}
	if (NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="否定条件-诊断") 
	{
		s WordsID=..SaveIdentifyWords(ConditionItemValue,"诊断条件","编辑中",ConditionItemCategory)
		q:WordsID="" "false^保存规则触发条件时往识别词字典里新增失败！"
	}
	s obj=##class(CT.WDT.CDSS.RuleCondition).%New()
	d obj.NodeDRSetObjectId(NodeDR)
	s obj.ConditionClass = ConditionClass
	s obj.ConditionItem = $p(str,",",3)
	s obj.ConditionItemValue = ConditionItemValue
	s obj.ConditionItemCalculate = $p(str,",",4)
	s ConditionItemValUnit=$p(str,",",6) //单位
	if (ConditionItemValUnit'="")
	{
		s ConditionItemValUnit=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_ConditionItemValUnit,0))
	}
	d:ConditionItemValUnit'="" obj.ConditionItemValUnitSetObjectId(ConditionItemValUnit)
	s obj.SpecialConfig = $p(str,",",7)
	s obj.ConditionItemCategory = ConditionItemCategory
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s ConditionResult="true^规则触发条件保存成功！"
	}
	else
	{
		Trollback
		s ConditionResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

	}
	q ConditionResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存预警规则-合理性
/// Table:CT.WDT.CDSS.RuleRationality
/// Input:str=NodeDr,TabooLevel,WarningContent,Remarks	->流程图节点ID,禁忌级别,提醒内容,备注
/// Return: false^错误信息/true^预警提醒内容保存成功！
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleRationality(str)
ClassMethod SaveRuleRationality(str As %String) As %String
{
	q:str="" "false^保存预警提醒内容时入参为空！"
	s RationalityResult=""
	s NodeDR=$p(str,",",1)  //规则节点id
	s WarningContent=$p(str,",",3) //提醒内容
	s WarningContent=##class(web.BDP.util.String).Replace(WarningContent," ","")
	q:(NodeDR="") "false^保存预警提醒内容时没获取到流程图节点！"
	q:(WarningContent="") "false^保存预警提醒内容时没获取到提醒内容！"
	/*if ($d(^CT.WDT.CDSS.RuleRationalityI("NodeDRWCIndex",NodeDR,WarningContent)))
	{
		q "false^该预警提醒内容已经存在！"
	}*/
	s flag=##class(web.CDSS.CMKB.RuleRationality).FormValidate("",NodeDR,WarningContent)
	if (flag=1)
	{
		q "false^该预警提醒内容已经存在！"
	}
	s obj=##class(CT.WDT.CDSS.RuleRationality).%New()
	d obj.NodeDRSetObjectId(NodeDR)
	s obj.Sequence = 1 
	s obj.WarningContent = WarningContent
	s obj.TabooLevel = $p(str,",",2)
	if $p(str,",",4)'=""
	{
		s obj.TreatSource = $p(str,",",4)
	}
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s RationalityResult="true^预警提醒内容保存成功！"
	}
	else
	{
		Trollback
		s RationalityResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

	}
	q RationalityResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存预警规则-并发症
/// Table:CT.WDT.CDSS.RuleComplication
/// Input:str=NodeDr,ComplicationDesc,MainPoints  ->流程图节点ID,并发症,要点
/// Return: false^错误信息/true^并发症保存成功！
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleComplication(str)
ClassMethod SaveRuleComplication(str As %String) As %String
{
	q:str="" "false^保存并发症时入参为空！"
	s ComplicationResult=""
	s NodeDR=$p(str,",",1)  //规则节点id
	s ComplicationDescStr=$p(str,",",2) //并发症  多个用&连接
	s ComplicationDescStr=##class(web.BDP.util.String).Replace(ComplicationDescStr," ","")
	s MainPointsStr=$p(str,",",3)  //多个用&连接
	q:(NodeDR="") "false^保存并发症时没获取到流程图节点！"
	q:(ComplicationDescStr="") "false^保存并发症时没获取并发症内容！"
	
	TS
	s ComplicationDescLen=$l(ComplicationDescStr,"&")
	for ComplicationItem=1:1:ComplicationDescLen
	{
		s ComplicationDesc=$p(ComplicationDescStr,"&",ComplicationItem)  //疾病描述
		continue:ComplicationDesc=""
		s ComplicationDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(ComplicationDesc,"U"),0)) //疾病id
		if (ComplicationDR="") 
		{
			s ComplicationResult="false^"_ComplicationDesc_"并发症在疾病字典表不存在！"
			q
		}
		else
		{
			if $d(^CT.WDT.CDSS.RuleComplicationI("NodeCompDRIndex",NodeDR,ComplicationDR))
			{
				continue
			}
			s obj=##class(CT.WDT.CDSS.RuleComplication).%New()
			d obj.NodeDRSetObjectId(NodeDR)
			s obj.Sequence = 1 
			d obj.ComplicationDRSetObjectId(ComplicationDR)
			s obj.MainPoints = $p(MainPointsStr,"&",ComplicationItem)  //并发症要点
			if $p(str,",",4)'=""
			{
				s obj.TreatSource=$p(str,",",4)
			}
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				s ComplicationResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				q

			}
			
		}
	}
 
	if (ComplicationResult["false")
	{
		Trollback
	}
	else
	{
		TC
		s ComplicationResult="true^并发症保存成功！"	
	}
	q ComplicationResult
}

/// Creator:谷雪萍
/// CreatDate:2021-09-03
/// Description:保存推荐内容
/// Table:CT.WDT.CDSS.RuleResult
/// Input:str=NodeDr,RecommendResult,Remark ->节点ID,推荐内容,备注
/// Return: false^错误信息/true^推荐内容保存成功！
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleResult(str)
ClassMethod SaveRuleResult(str As %String) As %String
{
	q:str="" "false^保存推荐内容时入参为空！"
	s SaveRuleResult=""
	s NodeDR=$p(str,",",1)  //规则节点id
	s RecommendResultStr=$p(str,",",2) //推荐内容
	s RemarksStr=$p(str,",",3) //备注
	s TreatSources=$p(str,",",4)
	q:(NodeDR="") "false^保存推荐内容时没获取到流程图节点！"
	q:(RecommendResultStr="") "false^保存推荐内容时没获取到推荐内容！"	
	s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5) //节点类型
	s:NodeType'="" NodeType=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3) //节点类型描述
	q:(NodeType="") "false^保存推荐内容时没有获取到节点类型！"
	
	TS
	s ResultLen=$l(RecommendResultStr,"&")
	for ResultItem=1:1:ResultLen
	{
		s RecommendResult=$p(RecommendResultStr,"&",ResultItem)  //推荐内容
		continue:RecommendResult=""
		s RecommendResult=$zstrip(RecommendResult,"<>W")
		s Remarks=$p(RemarksStr,"&",ResultItem)  //推荐内容
		s TreatSource=$p(TreatSources,"&",ResultItem)
		s RecommendType=""
		if (NodeType'="推荐评估表")&(NodeType'="推荐临床指征评估表")&(NodeType'="推荐科室关联评估表")  //只有评估表会有空格，其他的推荐内容要过滤掉空格
		{
			s RecommendResult=##class(web.BDP.util.String).Replace(RecommendResult," ","")
		}
		if (NodeType="推荐临床指征评估表")
		{
			s RecommendType="评估表"
			s RecommendResult=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
			
		}
		elseif(NodeType="推荐科室关联评估表")
		{
			s RecommendType="评估表"
			s RecommendResult=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif(NodeType="推荐评估表")
		{
			s RecommendType="评估表"
			s RecommendResult=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif (NodeType="推荐治疗方案")
		{
			s RecommendType="治疗方案"
			s RecommendResult=$o(^CT.WDT.CDSS.TreatDictI("DescIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif (NodeType="推荐护理处置")
		{
			s RecommendType="护理处置"
			s RecommendResult=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif (NodeType="推荐检验检查")
		{
			//s RecommendType=$p(str,",",4) //推荐内容（检验/检查/检验医嘱）
			 s RecommendResultID=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(RecommendResult,"U"),0))	
			 if (RecommendResultID'="") //检查
			 {
				 s RecommendType="检查"
			 }
			 else  //检验或检验医嘱
			 {
				 s RecommendResultID=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
				 if (RecommendResultID'="")
				 {
					 s RecommendType="检验"
				 }
				 else
				 {
					 s RecommendResultID=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
					 s:RecommendResultID'="" RecommendType="检验医嘱"
				 }
			 }
			 s RecommendResult=RecommendResultID
			
		}
		elseif (NodeType="推荐鉴别诊断")
		{
			s RecommendType="鉴别诊断"
			s RecommendResult=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif (NodeType="推荐确诊")
		{
			s RecommendType="确诊诊断"
			s RecommendResult=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(RecommendResult,"U"),0))
		}
		elseif (NodeType="推荐文献")
		{
			s RecommendType="文献"
			s RecommendResult=$o(^CT.WDT.CDSS.DocuManageI("DescIndex",RecommendResult,0))
		}
		elseif (NodeType="推荐住院")
		{
			s RecommendType="住院"
			s Remarks=RecommendResult  //推荐住院的内容存在备注里
			s RecommendResult=0  //RecommendResult字段存0
			
		}
		elseif (NodeType="出院指导")
		{
			s RecommendType="出院指导"
			s RecommendResult=$o(^CT.WDT.CDSS.DischargeGuideI("NameIndex",RecommendResult,0))
		}
		else
		{
			s RecommendType=""
			s RecommendResult=""
		}
		if (RecommendType="") 
		{	
			s SaveRuleResult="false^保存推荐内容时没有获取到推荐类别！"
			q
		}
		if (RecommendResult="") 
		{
			s SaveRuleResult="false^推荐内容在字典表不存在！"
			q
		}
		if $d(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,RecommendType,RecommendResult)) 
		{
			s SaveRuleResult="false^该推荐内容已经存在！"
			q
		}
		s obj=##class(CT.WDT.CDSS.RuleResult).%New()
		d obj.NodeDRSetObjectId(NodeDR)
		s obj.Sequence = 1 
		s obj.RecommendResult = RecommendResult
		s obj.RecommendType =RecommendType
		s obj.Remarks = Remarks
		if TreatSource'=""
		{
			s obj.TreatSource=TreatSource
		}
		s sc=obj.%Save()
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			s SaveRuleResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			q

		}
	}
	if (SaveRuleResult["false")
	{
		Trollback
	}
	else
	{
		TC
		s SaveRuleResult="true^推荐内容保存成功！"	
	}
	q SaveRuleResult
}

/// Creator:谷雪萍
/// CreatDate:2021-12-06
/// Description:往治疗方案明细表存数据（推荐治疗方案-药品、推荐治疗方案-手术）
/// Table:CT.WDT.CDSS.RuleDetail
/// Input:str=流程图节点id,推荐治疗方案药品,推荐治疗方案手术,手术备注,药品最小剂量,药品最小剂量单位,药品最大剂量,药品最大剂量单位,药品用法,药品频次
/// Return: false^错误信息/true^推荐内容保存成功！
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveRuleDetail(str)
ClassMethod SaveRuleDetail(str As %String) As %String
{
	q:str="" "false^保存推荐治疗方案药品或推荐治疗方案手术时入参为空！"
	
	s DetailResult=""
	s NodeDR=$p(str,",",1)  //流程图节点id
	s DrugStr=$p(str,",",2) //推荐治疗方案药品  多个用&连接
	//s DrugStr=##class(web.BDP.util.String).Replace(DrugStr," ","")
	s OperStr=$p(str,",",3)  //推荐治疗方案手术 多个用&连接
	//s OperStr=##class(web.BDP.util.String).Replace(OperStr," ","")  //部分手术名中有空格
	s TCMTreatZ = $p(str,",",4)   //推荐治疗方案治法 多个用&连接
	s TCMTreatC = $p(str,",",5)   //推荐治疗方案处置 多个用&连接
	s OperRemarksStr=$p(str,",",6)  //手术或治法备注 多个用&连接

	q:(NodeDR="") "false^保存推荐治疗方案药品或推荐治疗方案手术时没获取到流程图节点！"	
	
	TS
	if (DrugStr'="")
	{
		s DosageMINStr=$p(str,",",7)  //药品最小剂量 多个用&连接
		s DosageMINUnitStr=$p(str,",",8)  //药品最小剂量单位 多个用&连接
		s DosageMAXStr=$p(str,",",9)  //药品最大剂量 多个用&连接
		s DosageMAXUnitStr=$p(str,",",10)  //药品最大剂量单位 多个用&连接
		s DrugUseStr=$p(str,",",11)  //药品用法 多个用&连接
		s FrequencyStr=$p(str,",",12)  //药品频次 多个用&连接
		
		s DrugLen=$l(DrugStr,"&")
		for DrugItem=1:1:DrugLen
		{
			s DrugDesc=$p(DrugStr,"&",DrugItem)  //药品描述
			continue:DrugDesc=""
			//校验推荐治疗方案药品 在字典表是否存在
			s DrugDR=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(DrugDesc,"U"),0)) //药品id
			if (DrugDR="") 
			{
				s DetailResult="false^"_DrugDesc_"在药品字典表不存在！"
				q
			}
			if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,DrugDR))
			{
				continue
			}
			//校验药品最小剂量单位 在字典表是否存在
			s DosageMINUnit=$p(DosageMINUnitStr,"&",DrugItem)  
			s DosageMINUnitDr=""
			if (DosageMINUnit'="")
			{
				s DosageMINUnitDr=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(DosageMINUnit,"U"),0)) //单位id
				if (DosageMINUnitDr="")
				{
					s DetailResult="false^"_DosageMINUnit_"在单位字典表不存在！"
					q	
				}
			}
			//校验药品最大剂量单位 在字典表是否存在
			s DosageMAXUnit=$p(DosageMAXUnitStr,"&",DrugItem)  
			s DosageMAXUnitDr=""
			if (DosageMAXUnit'="")
			{
				s DosageMAXUnitDr=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(DosageMAXUnit,"U"),0)) //单位id
				if (DosageMAXUnitDr="")
				{
					s DetailResult="false^"_DosageMAXUnit_"在单位字典表不存在！"
					q	
				}
			}
			//校验用法 在字典表是否存在
			s DrugUse=$p(DrugUseStr,"&",DrugItem)  
			s DrugUseDr=""
			if (DrugUse'="")
			{
				s DrugUseDr=$o(^CT.WDT.CDSS.UsageDictI("NameIndex"," "_$ZCONVERT(DrugUse,"U"),0)) //单位id
				if (DrugUseDr="")
				{
					s DetailResult="false^"_DrugUse_"在用法字典表不存在！"
					q	
				}
			}
			//校验频次 在字典表是否存在
			s Frequency=$p(FrequencyStr,"&",DrugItem)  
			s FrequencyDr=""
			if (Frequency'="")
			{
				s FrequencyDr=$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex"," "_$ZCONVERT(Frequency,"U"),0)) //单位id
				if (FrequencyDr="")
				{
					s DetailResult="false^"_Frequency_"在频率字典表不存在！"
					q	
				}
			}

			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
			d obj.NodeDRSetObjectId(NodeDR)
			s obj.Sequence =DrugItem
			s obj.DrugDR = DrugDR
			s obj.DosageMIN=$p(DosageMINStr,"&",DrugItem)  
			s obj.DosageMAX=$p(DosageMAXStr,"&",DrugItem) 
			d obj.DosageMINUnitSetObjectId(DosageMINUnitDr)
			d obj.DosageMAXUnitSetObjectId(DosageMAXUnitDr)
			d obj.FrequencySetObjectId(FrequencyDr)
			s obj.DrugUse=DrugUseDr
			
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				s DetailResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				q

			}			
			
		}
	}
	if (OperStr'="")&(DetailResult'["false")
	{
		s OperLen=$l(OperStr,"&")
		for OperItem=1:1:OperLen
		{
			s OperDesc=$p(OperStr,"&",OperItem)  //手术描述
			continue:OperDesc=""
			s OperDR=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(OperDesc,"U"),0)) //手术
			if (OperDR="") 
			{
				s DetailResult="false^"_OperDesc_"在手术字典表不存在！"
				q
			}

			if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,OperDR))
			{
				continue
			}
			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
			d obj.NodeDRSetObjectId(NodeDR)
			s obj.Sequence =OperItem
			s obj.DrugDR = OperDR
			s obj.Remarks=$p(OperRemarksStr,"&",OperItem)  //手术备注
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				s DetailResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				q

			}
				
			
		}
	}
	
	if (TCMTreatZ'="")&(DetailResult'["false")
	{
		s TreatZLen=$l(TCMTreatZ,"&")

		for TCMZIndex=1:1:TreatZLen
		{
			s TCMZDesc = $p(TCMTreatZ,"&",TCMZIndex)   //治法描述

			continue:TCMZDesc=""
			s TCMZRowid=$o(^CT.WDT.CDSS.TCMTreatmentI("NameIndex"," "_$ZCONVERT(TCMZDesc,"U"),0))  //治法id
			
			if TCMZRowid=""
			{
				s DetailResult="false^"_TCMZDesc_"在治法字典表不存在！"
				q
			}
			if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,TCMZRowid))
			{
				continue
			}

			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
			d obj.NodeDRSetObjectId(NodeDR)
			s obj.Sequence =TCMZIndex
			s obj.DrugDR = TCMZRowid
			s obj.Remarks=$p(OperRemarksStr,"&",TCMZIndex)  //治法备注
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISERR(sc)
			{
				s DetailResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				q
			}
		}
		s NodeDRF=$p(str,",",*)
		s str=$p(str,",",1,*-1)
		
		s TCMPrescription = $p(str,",",13) // 方剂
		s TcmTreatFFreq = $p(str,",",14) // 方剂频次

		s TCMTreatFLen=$l(TCMPrescription,"&")
		for TCMTreatFIndex=1:1:TCMTreatFLen
		{
			s PrescriptionDesc=$p(TCMPrescription,"&",TCMTreatFIndex)  //方剂描述
			s PrescriptionF = $p(TcmTreatFFreq,"&",TCMTreatFIndex)  //方剂频次
			s PrescriptionC =  $p($p(str,",",18),"&", TCMTreatFIndex)  // 方剂组成
			s PrescriptionComposeD = $p($p(str,",",19),"&", TCMTreatFIndex)  //方剂组成常规剂量
			s PrescriptionComposeDoseU = $p($p(str,",",20),"&", TCMTreatFIndex)  //方剂组成常规剂量单位
			s PrescriptionD = $p($p(str,",",21),"&", TCMTreatFIndex)   //方剂组成煎发 
			continue:PrescriptionDesc=""

			s TCMTreatFRowid = $o(^CT.WDT.CDSS.TCMPrescriptionI("NameIndex"," "_$ZCONVERT(PrescriptionDesc,"U"),0))
			if TCMTreatFRowid=""
			{
				s DetailResult="false^"_PrescriptionDesc_"在治法字典表不存在！"
				q
			}
			if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,TCMTreatFRowid))
			{
				continue
			}

			s FrequencyRowid =$o(^CT.WDT.CDSS.FrequencyDictI("NameIndex"," "_$ZCONVERT(PrescriptionF,"U"),0))
			if FrequencyRowid=""
			{
				//s DetailResult="false^"_PrescriptionF_"在方剂频次字典表不存在！"
				//q
			}

			s fobj=##class(CT.WDT.CDSS.RuleDetail).%New()
			d fobj.NodeDRSetObjectId(NodeDRF)
			s fobj.Sequence =TCMTreatFIndex
			s fobj.DrugDR = TCMTreatFRowid
			d fobj.FrequencySetObjectId(FrequencyRowid)
			//d fobj.LastLevelSetObjectId()
			s fsc=fobj.%Save()
			d fobj.%Close()
			if $$$ISOK(fsc)
			{
				s PrescriptionId = fobj.%Id()  //方剂id
				continue:PrescriptionC=""
				
				s PComposeLen = $l(PrescriptionC, "｜")

				for PComposeIndex=1:1:PComposeLen
				{
					s MedicineName = $p(PrescriptionC,"｜", PComposeIndex)   //方剂组成
					s MedicineDose = $p(PrescriptionComposeD,"｜", PComposeIndex) //方剂组成剂量
					s MedicineDoseUnit = $p(PrescriptionComposeDoseU,"｜", PComposeIndex) //方剂组成剂量单位
					s DecoctionName = $p(PrescriptionD,"｜", PComposeIndex)   // 煎发
					continue:MedicineName=""
					
					s MedicineRowid = $o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(MedicineName,"U"),0))
					if MedicineRowid=""
					{
						s DetailResult="false^"_MedicineName_"在中药字典表不存在！"
						q
					}
					if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,MedicineRowid))
					{
						continue
					}

					s MedicineDoseUnitRowid=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(MedicineDoseUnit, "U"),0))
					if MedicineDoseUnitRowid=""
					{
						//s DetailResult="false^"_MedicineDoseUnit_"在方剂组成剂量单位字典表不存在！"
						//q
					}
					s cobj=##class(CT.WDT.CDSS.RuleDetail).%New()
					d cobj.NodeDRSetObjectId(NodeDRF)
					s cobj.Sequence =PComposeIndex
					s cobj.DrugDR = MedicineRowid
					d cobj.LastLevelSetObjectId(PrescriptionId)
					s cobj.DrugUse=DecoctionName
					s cobj.DosageMIN=MedicineDose
					d cobj.DosageMINUnitSetObjectId(MedicineDoseUnitRowid)
					s csc=cobj.%Save()
					d cobj.%Close()
					if '$$$ISOK(csc)
					{
						s DetailResult="false^方剂组成保存失败！"
					}
				}
			}
			if DetailResult["false"
			{
				q
			}


		}

		if DetailResult["false"
		{
			q
		}
		
	}
	if (TCMTreatC'="")&(DetailResult'["false")
	{
		s TreatCLen=$l(TCMTreatC,"&")

		for TCMCIndex=1:1:TreatCLen
		{
			s TCMCDesc = $p(TCMTreatC,"&",TCMCIndex)   //处置描述
			s TCMCType=""
			s TCMCType = $p($p(str,",",11),"&", TCMCIndex) //处置类型
			s TCMCDetail = $p($p(str,",",15),"&",TCMCIndex)
			s TCMCDetailDose = $p($p(str,",",16),"&",TCMCIndex)  //处置明细常规剂量
			s TCMCDetailUnit = $p($p(str,",",17),"&",TCMCIndex) //处置明细常规剂量单位
			
			s TCMCRowid = $o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(TCMCDesc,"U"),0))
			if TCMCRowid=""
			{
				s DetailResult="false^"_TCMCDesc_"在治法字典表不存在！"
				q
			}
			if $d(^CT.WDT.CDSS.RuleDetailI("NodeDrugDRIndex",NodeDR,TCMCRowid))
			{
				continue
			}
			
			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
			d obj.NodeDRSetObjectId(NodeDR)
			s obj.Sequence =TCMCIndex
			s obj.DrugDR = TCMCRowid
			s obj.DrugUse=TCMCType  //处置类型
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s TCMCNewid = obj.%Id()

				s TCMCDetailItems = TCMCDetail
				
				s TCMCDetailDoseItem = TCMCDetailDose
				s TCMCDetailUnitItem = TCMCDetailUnit

				s TCMCDetailItemRowid=""
				s TCMCDetailUnitItemRowid=""
				if TCMCDetailUnitItem'=""
				{
					s TCMCDetailUnitItemRowid=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$ZCONVERT(TCMCDetailUnitItem, "U"),0))
					if TCMCDetailUnitItemRowid=""
					{
						s DetailResult="false^"_TCMCDetailUnitItem_"在处置明细剂量单位字典表不存在！"
						q
					}
				}
				
				if TCMCType="腧穴"
				{
					
					s TCMCDetailItemIndex=0
					for TCMCDetailItemIndex=1:1:$l(TCMCDetailItems,"｜")
					{
						s TCMCDetailItem=$p(TCMCDetailItems,"｜",TCMCDetailItemIndex)
						continue:TCMCDetailItem=""
						s TCMCDetailItemRowid =$o(^CT.WDT.CDSS.TCMAcupointsI("NameIndex",$zconvert(TCMCDetailItem,"U"),0))
						if TCMCDetailItemRowid=""
						{
							s DetailResult="false^"_TCMCDetailItem_"在处置明细字典表不存在！"
							q
						}
						
						s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
						d obj.NodeDRSetObjectId(NodeDR)
						s obj.Sequence =TCMCDetailItemIndex
						s obj.DosageMIN=TCMCDetailDoseItem
						d:TCMCDetailUnitItemRowid'="" obj.DosageMINUnitSetObjectId(TCMCDetailUnitItemRowid)
						s obj.DrugDR = TCMCDetailItemRowid
						s obj.DrugUse=TCMCType  //处置类型
						d obj.LastLevelSetObjectId(TCMCNewid)
						s sc=obj.%Save()
						d obj.%Close()
					}
				}
				elseif (TCMCType="中药")
				{
					s TCMCDetailItemIndex=0
					for TCMCDetailItemIndex=1:1:$l(TCMCDetailItems,"｜")
					{
						s TCMCDetailItem=$p(TCMCDetailItems,"｜",TCMCDetailItemIndex)
						continue:TCMCDetailItem=""
						s TCMCDetailItemRowid =$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$zconvert(TCMCDetailItem,"U"),0))
						if TCMCDetailItemRowid=""
						{
							s DetailResult="false^"_TCMCDetailItem_"在处置明细字典表不存在！"
							q
						}
						
						s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
						d obj.NodeDRSetObjectId(NodeDR)
						s obj.Sequence =TCMCDetailItemIndex
						s obj.DosageMIN=TCMCDetailDoseItem
						d:TCMCDetailUnitItemRowid'="" obj.DosageMINUnitSetObjectId(TCMCDetailUnitItemRowid)
						s obj.DrugDR = TCMCDetailItemRowid
						s obj.DrugUse=TCMCType  //处置类型
						d obj.LastLevelSetObjectId(TCMCNewid)
						s sc=obj.%Save()
						d obj.%Close()
					}
				}
				elseif (TCMCType="药物")
				{
					s TCMCDetailItemIndex=0
					for TCMCDetailItemIndex=1:1:$l(TCMCDetailItems,"｜")
					{
						s TCMCDetailItem=$p(TCMCDetailItems,"｜",TCMCDetailItemIndex)
						continue:TCMCDetailItem=""
						s TCMCDetailItemRowid= $o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$zconvert(TCMCDetailItem,"U"),0))
						if TCMCDetailItemRowid=""
						{
							s DetailResult="false^"_TCMCDetailItem_"在处置明细字典表不存在！"
							q
						}
						
						s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
						d obj.NodeDRSetObjectId(NodeDR)
						s obj.Sequence =TCMCDetailItemIndex
						s obj.DosageMIN=TCMCDetailDoseItem
						d:TCMCDetailUnitItemRowid'="" obj.DosageMINUnitSetObjectId(TCMCDetailUnitItemRowid)
						s obj.DrugDR = TCMCDetailItemRowid
						s obj.DrugUse=TCMCType  //处置类型
						d obj.LastLevelSetObjectId(TCMCNewid)
						s sc=obj.%Save()
						d obj.%Close()
					}
				}

				if DetailResult["false"
				{
					q
				}
			}
			
			else
			{
				s DetailResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				q
			}
			
			
		}
	}
	if (DetailResult["false")
	{
		Trollback
	}
	else
	{
		TC
		s DetailResult="true^保存成功！"	
	}
	q DetailResult
}

/// Creator:谷雪萍
/// CreatDate:2021-08-12
/// Description:保存规则节点连线
/// Table:CT.WDT.CDSS.RuleLink
/// Input:RuleDR-规则id，FlowChartNum-流程图顺序号，RuleTypeDR-图类型
/// Return: false^错误信息/true^规则节点连线保存成功！
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveAllRuleNodeLink(RuleDR,FlowChartNum,RuleTypeDR)
ClassMethod SaveAllRuleNodeLink(RuleDR As %String, FlowChartNum As %String, RuleTypeDR As %String = "") As %String
{
	q:(RuleDR="")||(FlowChartNum="") "false^保存规则节点连线时规则id和流程图顺序号不能为空"
	s:RuleTypeDR="" RuleTypeDR=-100000000000000
	
	s NodeStr="",StartNode="",EndNode=""
	s NodeNum=0   //节点id
	for
	{
		s NodeNum=$o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleDR,RuleTypeDR,FlowChartNum,NodeNum))
		q:NodeNum=""
		s NodeID=0   //节点id
		for
		{
			s NodeID=$o(^CT.WDT.CDSS.RuleNodeI("ChartNumIndex",RuleDR,RuleTypeDR,FlowChartNum,NodeNum,NodeID))
			q:NodeID=""
			s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeID)),5) //节点类型
			if (NodeType="1")  //开始节点
			{
				s StartNode=NodeID
				continue
			}
			
			elseif (NodeType="2")  //结束节点
			{
				s EndNode=NodeID
				continue
			}
			else
			{
				s:NodeStr'="" NodeStr=NodeStr_","
				s NodeStr=NodeStr_NodeID
			}
		}
		
	}
	s NodeStr=StartNode_","_NodeStr_","_EndNode
	
	
	s SaveLinkResult=""
	Ts
	s strLen=$Length(NodeStr,",")
	for iNode=1:1:(strLen-1)
	{   
		    
	    s PreNode=$p(NodeStr,",",iNode)
	    s NextNode=$p(NodeStr,",",iNode+1)  
	    if (PreNode="")||(NextNode="")
	    {
		    continue
	    }
	    s obj=##class(CT.WDT.CDSS.RuleLink).%New()
		d obj.RuleDRSetObjectId(RuleDR)
		s obj.FlowChartNum =FlowChartNum
		d obj.PreNodeSetObjectId(PreNode)
		d obj.NextNodeSetObjectId(NextNode)
		d:RuleTypeDR'="-100000000000000" obj.RuleTypeDRSetObjectId(RuleTypeDR)
		s sc=obj.%Save()
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			s SaveLinkResult="false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			q
		}
	    
	}
	if (SaveLinkResult["false")
	{
		tro
	}
	else
	{
		tc
		s SaveLinkResult="true^规则节点连线保存成功！"
	}
	q SaveLinkResult
}

/// Creator:谷雪萍
/// CreatDate:2021-10-13
/// Description:删除重复的识别词
/// Table:CT.WDT.CDSS.RuleLink
/// Input:filePath-csv文件路径
/// Return: true
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).DeleteRepeatWords("D:\delete20211013.csv")
ClassMethod DeleteRepeatWords(filePath) As %String
{
	s Rtn=""
	s file=##class(%File).%New(filePath)
	d file.Open("RS")
	s linenum=0
	TS
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		
		s linenum=linenum+1	
		s WordsCode = $p(str,",",1)  //代码		
		continue:WordsCode=""
		s WordsId=$o(^CT.WDT.CDSS.IdentifyWordsI("CodeIndex"," "_$ZCONVERT(WordsCode,"U"),0))
		continue:WordsId=""
		s result=##class(web.CDSS.CMKB.IdentifyWords).DeleteData(WordsId)
		if (result["false")
		{
			s Rtn=Rtn_"&"_linenum	//记录错误行
		}
	}
	if (Rtn'="")
	{
		s Rtn="第"_Rtn_"行删除不成功"
		tro
	}
	else
	{
		s Rtn="批量删除成功！"
		tc
	}
	
	q Rtn
}

/// Creator:谷雪萍
/// CreatDate:2021-1-17
/// Description:处理符号
/// Input:str-处理符号前字符串
/// Return: str-处理符号后的字符串
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).DealSymbol(str)
ClassMethod DealSymbol(str As %String) As %String
{
	q:str="" ""
	s str = ##class(web.BDP.util.String).Replace(str,"(","（")
	s str = ##class(web.BDP.util.String).Replace(str,")","）")
	s str = ##class(web.BDP.util.String).Replace(str,"【","[")
	s str = ##class(web.BDP.util.String).Replace(str,"】","]")
	s str = ##class(web.BDP.util.String).Replace(str,"［","[")
	s str = ##class(web.BDP.util.String).Replace(str,"］","]")
	s str = ##class(web.BDP.util.String).Replace(str,"＞",">")
	s str = ##class(web.BDP.util.String).Replace(str,"＜","<")
	q str
}

/// Creator:丁亚男
/// CreatDate:2022-03-29
/// Input:删除出院指导的规则
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).DeleteWrongRule()
ClassMethod DeleteWrongRule() As %String
{
	s count=0,fcount=0,total=0
	s ChartTypeRowId=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," 推荐评估表",""))
	if (ChartTypeRowId'="")
	{
		s RuleRowId=0
		for
		{ 
			s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeRowId,RuleRowId)) q:RuleRowId="" 
			s total=total+1
			s result=##class(web.CDSS.CMKB.RuleDict).DeleteData(RuleRowId)
			if (result["false")
			{
				s fcount=fcount+1	//记录错误行
			}
			else
			{
				s count=count+1
			}
		}
	}
	q "共有"_total_"条数据，其中"_count_"条处理成功！"_fcount_"条处理失败！"
}

/// Creator:丁亚男
/// CreatDate:2022-07-5
/// Input:生成规则表索引
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).BuildIndexRule()
ClassMethod BuildIndexRule() As %String
{
	d ##class(CT.WDT.CDSS.RuleDict).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleNode).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleLink).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleChart).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleCondition).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleResult).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleRationality).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleComplication).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleDetail).%BuildIndices()
	d ##class(CT.WDT.CDSS.RuleBasis).%BuildIndices()
	q:"OK"
}

/// Creator:李得原
/// CreatDate:2022-08-25
/// Input:导出医院自建规则
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).ExportHospitalRules("sds","d:\hospital-sds.csv")
ClassMethod ExportHospitalRules(HospitalName As %String, Path As %String)
{
	s Result=[]
	s RuleMap={"疾病预警":"诊断合理性","过敏预警":"过敏合理性","输血预警":"输血合理性"}
	s ReverseMap={"诊断合理性":"疾病预警","过敏合理性":"过敏预警","输血合理性":"输血预警"}
	s RuleRowid=0
	for
	{
		s RuleRowid=$o(^CT.WDT.CDSS.RuleDictD(RuleRowid)) q:RuleRowid=""
		s RuleProvision=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),14)  //录入来源
		s RuleDictTypeDR = $lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),6)
		s RuleDictType = $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleDictTypeDR)),3)

		if (RuleProvision=HospitalName)
		{
			s RuleLoc=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),4)   //科室
			s RuleLocDescStr=""
			for RuleLocIndex=1:1:$l(RuleLoc,"&%")
			{
				s RuleLocId=$p(RuleLoc,"&%",RuleLocIndex)
				continue:RuleLocId=""
				s RuleLocDesc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RuleLocId)),3)
				s:RuleLocDescStr'="" RuleLocDescStr=RuleLocDescStr_"&%"_RuleLocDesc
				s:RuleLocDescStr="" RuleLocDescStr=RuleLocDesc
			}
			s RuleSource=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),5)
			
			s RuleDesc=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),3)  //规则名称
			s BachNum=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),7)  //批次号
			s IWord=""
			s NIWord=""
			s DWord=""
			s NDWord=""
			s AgeWord=""
			s GenderWord=""
			s RuleTypeDR=""
			for
			{
				s RuleTypeDR=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleTypeDR)) 
				q:RuleTypeDR=""
				//s RuleType=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),6)  //规则类型
				s RuleType=$lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
				
				s FlowChartNum=0
				for
				{
					s FlowChartNum=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleTypeDR,FlowChartNum))
					q:FlowChartNum=""
					
					s Line=[]
					d Line.%Set(40,FlowChartNum)
					s DrugNameStr=""
					s DrugMinDoseStr=""
					s DrugMinDoseUnitStr=""
					s DrugMaxDoseStr=""
					s DrugMaxDoseUnitStr=""
					s DrugFreStr=""
					s DrugUseStr=""
					s OperNameStr=""
					s OperRemarkStr=""
					
					s TreatmentNameStr=""   //治法 
					s PrescriptionNameStr=""   //方剂
					s FrequencyName1Str="" //方剂频次
					s MedicineNameStr="" //方剂组成
					s DosageMIN2Str="" //方剂组成-常规剂量
					s DosageMINUnitName2Str=""  //方剂组成-常规剂量单位
					s DecoctionNameStr="" //方剂组成-煎发
					
					s RecommendStr=""
					s RecommendRemark=""
					
					s NursingNameStr=""
					s NursingDetailStr=""
					
					d Line.%Set(20,RuleLocDescStr)
					d Line.%Set(3,BachNum)
					d Line.%Set(1,RuleDesc)
					d Line.%Set(2,RuleSource)
					d Line.%Set(23,RuleProvision)
					
					s DrugUseStrArray=[]
					s RuleNodeRowid=0
					for
					{
						s RuleNodeRowid=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleTypeDR,FlowChartNum,RuleNodeRowid))
						q:RuleNodeRowid=""
						s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeRowid)),5)
						s NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
						
						if (NodeTypeDesc["合理性")||(NodeTypeDesc["并发症")
						{
							if ReverseMap.%Get(NodeTypeDesc)'=""
							{
								if Line.%Get(0)=""
								{
									d Line.%Set(0,ReverseMap.%Get(NodeTypeDesc))
								}
							}
							else
							{
								if Line.%Get(0)=""
								{
									d Line.%Set(0,NodeTypeDesc)
								}
							}
							s RuleType=NodeTypeDesc
						}

						if RuleDictType["自动勾选"
						{
							d Line.%Set(0,"评估表自动勾选")
						}
						
						if (NodeTypeDesc="出院指导")||(NodeTypeDesc="推荐评估表")
						{
							d Line.%Set(0,NodeTypeDesc)
							s RuleType=NodeTypeDesc
						}
						
						if (NodeTypeDesc["推荐")&(NodeTypeDesc'["-")
						{
							s RuleType=NodeTypeDesc
							if Line.%Get(0)=""
							{
								d Line.%Set(0,NodeTypeDesc)
							}
						}

						if (RuleType["推荐")||(RuleType["出院指导")
						{
							//推荐鉴别诊断,推荐检验检查,推荐护理处置

							s NursingDetailArray=[]
							if $d(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",RuleNodeRowid))
							{
								s n=0
								s DetailRowId = 0
								for
								{
									s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",RuleNodeRowid,DetailRowId)) q:DetailRowId=""
									s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
									s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
									s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
									s DrugUseName=""
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
									s DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
									s DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
									s DosageMINUnitName=""
									s:DosageMINUnit'="" DosageMINUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit)),3)
									
									s DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),8)
									s DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),9)
									s DosageMAXUnitName=""
									s:DosageMAXUnit'="" DosageMAXUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMAXUnit)),3)
									
									s Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),10)
									s FrequencyName=""
									s:Frequency'="" FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency)),3)
									s Remarks  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),11)
									
									s TreatSource = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),13)
									s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),14)

									s:OperRemarkStr'="" OperRemarkStr=OperRemarkStr_"&"_Remarks
									s:OperRemarkStr="" OperRemarkStr=Remarks
									
									
									if NodeTypeDesc="推荐治疗方案-药品"
									{
										s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
										s DrugUseName=""
										s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
										s:DrugNameStr'="" DrugNameStr=DrugNameStr_"&"_DrugDRName
										s:DrugNameStr="" DrugNameStr=DrugDRName
										
										s:DrugMinDoseStr'="" DrugMinDoseStr=DrugMinDoseStr_"&"_DosageMIN
										s:DrugMinDoseStr="" DrugMinDoseStr=DosageMIN
										
										s:DrugMinDoseUnitStr'="" DrugMinDoseUnitStr=DrugMinDoseUnitStr_"&"_DosageMINUnitName
										s:DrugMinDoseUnitStr="" DrugMinDoseUnitStr=DosageMINUnitName
										
										s:DrugMaxDoseStr'="" DrugMaxDoseStr=DrugMaxDoseStr_"&"_DosageMAX
										s:DrugMaxDoseStr="" DrugMaxDoseStr=DosageMAX
										
										s:DrugMaxDoseUnitStr'="" DrugMaxDoseUnitStr=DrugMaxDoseUnitStr_"&"_DosageMAXUnitName
										s:DrugMaxDoseUnitStr="" DrugMaxDoseUnitStr=DosageMAXUnitName
										
										s:DrugFreStr'="" DrugFreStr=DrugFreStr_"&"_FrequencyName
										s:DrugFreStr="" DrugFreStr=FrequencyName
										
										d DrugUseStrArray.%Push(DrugUseName)
										
										
									}
									elseif NodeTypeDesc="推荐治疗方案-手术"
									{
										s OperName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
										s OperUsge=""
										s:DrugUse'="" OperUsge=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
										s OperRemark=Remarks
										s:OperNameStr'="" OperNameStr=OperNameStr_"&"_OperName
										s:OperNameStr="" OperNameStr=OperName
										
										s:OperRemarkStr'="" OperRemarkStr=OperRemarkStr_"&"_Remarks
										s n=n+1
										s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
										d DrugUseStrArray.%Push(OperUsge)
										
											
									}
									elseif NodeTypeDesc="推荐治疗方案-治法"
									{
										
										
										s TreatmentName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
										s:TreatmentNameStr'="" TreatmentNameStr=TreatmentNameStr_"&"_TreatmentName
										s:TreatmentNameStr="" TreatmentNameStr=TreatmentName
										
										s MedicineNameStr=""
										s DosageMIN2PStr="" //方剂组成-常规剂量
										s DosageMINUnitName2Str=""  //方剂组成-常规剂量单位
										s DecoctionNamePartStr="" //方剂组成-煎发
										s PMNodeTypeDesc=""
										
										s PMNodeRowId=0
										for
										{ 
											s PMNodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid,RuleTypeDR,FlowChartNum,PMNodeRowId)) q:PMNodeRowId=""
											s PMNodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(PMNodeRowId)),5)	 //节点类型
											
											s:PMNodeType'="" PMNodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(PMNodeType)),3) //节点类型描述
											continue:(PMNodeTypeDesc'="推荐治疗方案-方剂")
											if ($d(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",PMNodeRowId))) //判断是否有方剂
											{
												s DetailRowId1 = 0
												for
												{
													s DetailRowId1 = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",PMNodeRowId,-100000000000000,DetailRowId1)) q:DetailRowId1=""
													s Sequence1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),3)
													s DrugDR1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),4)
													s PrescriptionName=""
													s:DrugDR1'="" PrescriptionName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR1)),3)
													s Frequency1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),10)
													s FrequencyName1=""
													s:Frequency1'="" FrequencyName1=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency1)),3)
													s Remarks1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),11)
													
													if PrescriptionNameStr'[PrescriptionName
													{
														s:PrescriptionNameStr'="" PrescriptionNameStr=PrescriptionNameStr_"&"_PrescriptionName
														s:PrescriptionNameStr="" PrescriptionNameStr=PrescriptionName
													}
													
													s MedicineNamePartStr=""
													s DosageMIN2PartStr="" //方剂组成-常规剂量
													s DosageMINUnitName2PartStr=""  //方剂组成-常规剂量单位
													s DecoctionNamePartStr="" //方剂组成-煎发
													if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId1))) //判断是否有方剂组成
													{
														s DetailRowId2 = 0
														for
														{
															s DetailRowId2 = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId1,DetailRowId2)) q:DetailRowId2=""
															s Sequence2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),3)
															s DrugDR2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),4)
															s MedicineName=""
															s:DrugDR2'="" MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR2)),3)  //中药字典
															
															s DrugUse2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),5)
															s DecoctionName=""
															s:DrugUse2'="" DecoctionName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(DrugUse2)),3) //煎法
															
															s DosageMIN2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
															s DosageMINUnit2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
															s DosageMINUnitName2=""
															s:DosageMINUnit2'="" DosageMINUnitName2=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit2)),3)
															s Remarks2  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId2)),11)
															
															s:MedicineNamePartStr'="" MedicineNamePartStr=MedicineNamePartStr_"｜"_MedicineName
															s:MedicineNamePartStr="" MedicineNamePartStr=MedicineName
															
															s:DosageMIN2PartStr'="" DosageMIN2PartStr=DosageMIN2PartStr_"｜"_DosageMIN2
															s:DosageMIN2PartStr="" DosageMIN2PartStr=DosageMIN2
															
															s:DosageMINUnitName2PartStr'="" DosageMINUnitName2PartStr=DosageMINUnitName2PartStr_"｜"_DosageMINUnitName2
															s:DosageMINUnitName2PartStr="" DosageMINUnitName2PartStr=DosageMINUnitName2
															
															s:DecoctionNamePartStr'="" DecoctionNamePartStr=DecoctionNamePartStr_"｜"_DecoctionName
															s:DecoctionNamePartStr="" DecoctionNamePartStr=DecoctionName   //煎法
															
														}
													}
													
													s:MedicineNameStr'="" MedicineNameStr=MedicineNameStr_"&"_MedicineNamePartStr  //中药
													s:MedicineNameStr="" MedicineNameStr=MedicineNamePartStr
													
													s:DosageMIN2Str'="" DosageMIN2Str=DosageMIN2Str_"&"_DosageMIN2PartStr
													s:DosageMIN2Str="" DosageMIN2Str=DosageMIN2PartStr
													
													s:DosageMINUnitName2Str'="" DosageMINUnitName2Str=DosageMINUnitName2Str_"&"_DosageMINUnitName2PartStr
													s:DosageMINUnitName2Str="" DosageMINUnitName2Str=DosageMINUnitName2PartStr
													
													s:DecoctionNameStr'="" DecoctionNameStr=DecoctionNameStr_"&"_DecoctionNamePartStr
													s:DecoctionNameStr="" DecoctionNameStr=DecoctionNamePartStr
												}
											}
											

											
										}
										s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
										d DrugUseStrArray.%Push(DrugUse)
										
										
									}
									elseif NodeTypeDesc="推荐治疗方案-处置"
									{
										s LastLevel = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),12)
										continue:LastLevel'=""
										s NursingName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
										continue:NursingName=""
										
										s:NursingNameStr'="" NursingNameStr=NursingNameStr_"&"_NursingName
										s:NursingNameStr="" NursingNameStr=NursingName
										s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
										d DrugUseStrArray.%Push(DrugUse)
										
										s childArray1=[]
										
										s NursingDetailPartArray=[]
										s NursingDetailPartStr=""
										if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId))) //判断是否有处置明细
										{
											s DetailRowId1 = 0
											for
											{
												s DetailRowId1 = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId,DetailRowId1)) q:DetailRowId1=""
												s Sequence1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),3)
												s DrugDR1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId1)),4)
												s DrugUse1  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5) //处置类型（腧穴、中药、药物）
												s DrugDRName1=""
												s ProjectDataName=""
												if (DrugUse1'="")
												{
													if (DrugUse1="腧穴")
													{
														s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(DrugDR1)),3)
													}
													elseif (DrugUse1="中药")
													{
														s DrugDRName1=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR1)),3)
													}
													elseif (DrugUse1="药物")
													{
														s DrugDRName1=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR1)),4)
													}
													
												}
												d NursingDetailPartArray.%Push(DrugDRName1)
											}
										}
										s NursingDetailPartStr=..Join(NursingDetailPartArray,"｜")
									
										d NursingDetailArray.%Push(NursingDetailPartStr)
									}
								}
								s DrugUseStr=..Join(DrugUseStrArray,"&")
								s NursingDetailStr=..Join(NursingDetailArray,"&")
								d Line.%Set(26,DrugNameStr)
								d Line.%Set(27,OperNameStr)
								d Line.%Set(30,OperRemarkStr)
								d Line.%Set(31,DrugMinDoseStr)
								d Line.%Set(32,DrugMinDoseUnitStr)
								d Line.%Set(33,DrugMaxDoseStr)
								d Line.%Set(34,DrugMaxDoseUnitStr)
								d Line.%Set(35,DrugUseStr)
								d Line.%Set(36,DrugFreStr)
								
								d Line.%Set(28,TreatmentNameStr)   //治法
								d Line.%Set(37,PrescriptionNameStr)  //方剂
								d Line.%Set(38,FrequencyName1Str)  //方剂频次
								d Line.%Set(42,MedicineNameStr)   //方剂组成
								d Line.%Set(43,DosageMIN2Str)
								d Line.%Set(44,DosageMINUnitName2Str)
								d Line.%Set(45,DecoctionNameStr)
								
								d Line.%Set(29,NursingNameStr)
								d Line.%Set(39,NursingDetailStr)

							}
							
							if ($d(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",RuleNodeRowid)))
							{
								s ResultRowId = 0
								for
								{
									s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",RuleNodeRowid,ResultRowId)) q:ResultRowId=""
									s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
									s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
									s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
									s Remarks  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),6)
									s BaseTable  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),7)
									s:BaseTable="" BaseTable=0
									s TreatSource= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
									s RuleBasisDR= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
									s SourceFlag=0
									if (RuleBasisDR'="")
									{
										s SourceFlag=1
									}
									if (TreatSource'="")
									{
										s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\CDSS\\Doc\\"_TreatSource_".pdf")
										if isExistDoc
										{
											s SourceFlag=1
										}	
									}
									s RecommendResultDesc=""
									
									if (RecommendType="检验") 
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
									}
									if (RecommendType="检验医嘱")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
									}
									if (RecommendType="检查")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
									}
									if (RecommendType="评估表")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
									}
									if (RecommendType="辅助计算")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TermD(RecommendResult)),3)
									}
									if (RecommendType="治疗方案")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
										s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
									}
									if (RecommendType="确诊诊断")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									}
									if (RecommendType="鉴别诊断")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
									}
									if (RecommendType="护理处置")
									{
										s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
									}
									if (RecommendType="出院指导")
									{
										s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
									}
									s:RecommendStr'="" RecommendStr=RecommendStr_"&"_RecommendResultDesc
									s:RecommendStr="" RecommendStr=RecommendResultDesc
									
									s:RecommendRemark'="" RecommendRemark=RecommendRemark_"&"_Remarks
									s:RecommendRemark="" RecommendRemark=Remarks

								}
								d Line.%Set(18,RecommendStr)
								d Line.%Set(19,RecommendRemark)
								
							}
						}
						
						if (RuleType="疾病预警")||(RuleType="过敏预警")||(RuleType="输血预警")
						{
							s RuleType=RuleMap.%Get(RuleType)
						}
						// 推荐预警类型
						if RuleType["合理性"
						{
							if ($d(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",RuleNodeRowid)))
							{
								s RationalityRowId = 0
								for
								{
									s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",RuleNodeRowid,RationalityRowId)) q:RationalityRowId=""
									s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
									s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
									s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
									s TreatSource = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),7)
									s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),8)
									
#;									if (RuleType="过敏合理性")||(RuleType="输血合理性")||(RuleType="诊断合理性")
#;									{
#;										d Line.%Set(0,ReverseMap.%Get(RuleType))
#;									}
#;									else
#;									{
#;										d Line.%Set(0,RuleType)
#;									}
									
									d Line.%Set(18,WarningContent)
									d Line.%Set(19,TabooLevel)
									
								}	
							}
						}

						// 并发症
						if (NodeTypeDesc["并发症")
						{
							s ComplicationStr=""
							s MainPointsStr=""
							if ($d(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",RuleNodeRowid)))
							{
								s ComplicationRowId = 0
								for
								{
									s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",RuleNodeRowid,ComplicationRowId)) q:ComplicationRowId=""
									continue:ComplicationRowId=""
									s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
									s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
									s ComplicationDRDesc=""
									s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
									s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
									s TreatSource = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),7)
									s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),8)

									s:ComplicationStr'="" ComplicationStr=ComplicationStr_"&"_ComplicationDRDesc
									s:ComplicationStr="" ComplicationStr=ComplicationDRDesc
									
									s:MainPointsStr'="" MainPointsStr=MainPointsStr_"&"_MainPoints
									s:MainPointsStr="" MainPointsStr=MainPoints
								}
							}
							d Line.%Set(0,RuleType)
							d Line.%Set(18,ComplicationStr)
							d Line.%Set(19,MainPointsStr)
						}

						if (NodeTypeDesc="开始")||(NodeTypeDesc="结束")
						{
							continue
						}
						if (NodeTypeDesc="主要条件-识别词")
						{
							s WordMeetNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeRowid)),6)
							d Line.%Set(14, WordMeetNum)
							s IWStr=""
							s IWStr=..GetDescFromCondition(RuleNodeRowid)
							d Line.%Set(15,IWStr)
						}
						elseif (NodeTypeDesc="否定条件-识别词")
						{
							s NegWordMeetNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeRowid)),6)
							d Line.%Set(16, NegWordMeetNum)
							s NIWStr=..GetDescFromCondition(RuleNodeRowid)
							d Line.%Set(17,NIWStr)
						}
						elseif (NodeTypeDesc="主要条件-诊断")
						{
							s DiagMeetNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeRowid)),6)
							d Line.%Set(12, DiagMeetNum)
							s DIWStr=..GetDescFromCondition(RuleNodeRowid)
							d Line.%Set(13,DIWStr)
						}
						elseif (NodeTypeDesc="否定条件-诊断")
						{
							s NegDiagMeetNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeRowid)),6)
							d Line.%Set(21, NegDiagMeetNum)
							s NDIWStr=..GetDescFromCondition(RuleNodeRowid)
							d Line.%Set(22,NDIWStr)
						}
						elseif (NodeTypeDesc="基本信息-年龄")
						{
							s AgeStr=..GetDescFromCondition(RuleNodeRowid)
							s AgeMin=$p(AgeStr,",",1)
							s AgeMinUnit=$p(AgeStr,",",2)
							s AgeMinContain=$p(AgeStr,",",3)
							s AgeMax=$p(AgeStr,",",4)
							s AgeMaxUnit=$p(AgeStr,",",5)
							s AgeMaxContain=$p(AgeStr,",",6)
							d Line.%Set(5,AgeMin)
							d Line.%Set(6,AgeMinUnit)
							d Line.%Set(7,AgeMinContain)
							d Line.%Set(8,AgeMax)
							d Line.%Set(9,AgeMaxUnit)
							d Line.%Set(10,AgeMaxContain)
						}
						elseif (NodeTypeDesc="基本信息-性别")
						{
							s GenderWord=..GetDescFromCondition(RuleNodeRowid)
							d Line.%Set(11,GenderWord)
						}		
					}
					if (Line.%Get(0)="")&(RuleType'="")
					{
						d Line.%Set(0,RuleType)
					}
					s LineStr=..Join(Line,",")
					d Result.%Push(LineStr)
				}

			}
		}			
	}
	d ..RuleToFile(Result,Path)
	q ""
}

/// Creator:李得原
/// CreatDate:2022-08-25
/// Input:从节点中取出规则条件
/// Return:
/// w ##class(web.CDSS.CMKB.ImportViewRules).GetDescFromCondition(272314)
ClassMethod GetDescFromCondition(NodeRowid As %String)
{
	s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),5)
	s NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
	s Str=""
	s AgeMin=""
	s AgeMinUnit=""
	s AgeMinContain=""
	s AgeMax=""
	s AgeMaxUnit=""
	s AgeMaxContain=""
	s Gender=""
	s ConditionRowid=0
	for
	{
		s ConditionRowid=$o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowid,ConditionRowid))
		q:ConditionRowid=""
		s ConditionDesc=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowid)),6)
		s ConditionCat=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowid)),10)
		continue:ConditionDesc=""
		s:ConditionCat="" ConditionCat="西医"
		if NodeTypeDesc="基本信息-性别"
		{
			s Str=ConditionDesc
		}
		elseif NodeTypeDesc="基本信息-年龄"
		{
			s ConditionUnit=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowid)),7)
			s ConditionCaculate=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowid)),5)
			if (ConditionCaculate[">")
			{
				s AgeMin=ConditionDesc
				if (ConditionCaculate=">=")
				{
					s AgeMinContain="Y"
				}
				s AgeMinUnit=ConditionUnit
				s:ConditionUnit="" ConditionUnit=32
				
				s AgeMinUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(ConditionUnit)),3)
			}
			else
			{
				s AgeMax=ConditionDesc
				if (ConditionCaculate="<=")
				{
					s AgeMaxContain="Y"
				}
				s:ConditionUnit="" ConditionUnit=32
				s AgeMaxUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(ConditionUnit)),3)
			}
			s Str=AgeMin_","_AgeMinUnit_","_AgeMinContain_","_AgeMax_","_AgeMaxUnit_","_AgeMaxContain
		}
		else
		{
			s:Str'="" Str=Str_"｜"_ConditionCat_"："_ConditionDesc
			s:Str="" Str=ConditionCat_"："_ConditionDesc
		}
	}
	q Str
}

/// Creator:李得原
/// CreatDate:2022-08-25
/// Input:把列表中的数据通过符号拼接成字符串
/// Return:
/// w ##class(web.CDSS.CMKB.ImportViewRules).Join()
ClassMethod Join(List, Symbol As %String) As %String
{
	s Str=""
	if $IsObject(List)
	{
		for ListIndex=0:1:List.%Size()-1
		{
			s Item=List.%Get(ListIndex)
			s ItemStr=$replace(Item,",","，")
			s:ListIndex'=0 Str=Str_Symbol_ItemStr
			s:ListIndex=0 Str=ItemStr
		}
	}
	q Str
}

/// Creator:李得原
/// CreatDate:2022-08-25
/// Input:规则导出到csv文件
/// Return:
/// w ##class(web.CDSS.CMKB.ImportViewRules).RuleToFile()
ClassMethod RuleToFile(RuleList, Path)
{
	s File=##class(%File).%New(Path)
	d File.Open("NWS")
	for RuleIndex=0:1:RuleList.%Size()-1
	{
		s RuleLine=RuleList.%Get(RuleIndex)
		s RuleLine=##class(web.CDSS.CMKB.FunLib).TransLinefeed(RuleLine)
		d File.WriteLine(RuleLine)
	}
	d File.%Save()
}

/// Creator:李得原
/// CreatDate:2022-09-01
/// Description:导入医院规则
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).ImportHospitalRules("D:\hospital-ccc.csv")
ClassMethod ImportHospitalRules(Path)
{
	s Str=""
	s File=##class(%File).%New(Path)
	d File.Open("RS")
	while 'File.AtEnd
	{
		s Line=File.ReadLine()
		continue:Line=""
		s Result= ..SaveImportRules(Line)
		if Result["false"
		{
			s:Str'="" Str=Str_","_Result
			s:Str="" Str=Result
			
		}
	}
	q Str
}

/// Creator：丁亚男
/// CreatDate:2022-12-1
/// Description：导出识别词拆分项目类型与项目内容不匹配的识别词及内容
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).ExportIdentifyWTXT()
ClassMethod ExportIdentifyWTXT() As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"识别词拆分有误数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "识别词id	识别词名称	识别词类型	拆分项目名称	拆分值"
	
	s myRowID=0
	for {
		s myRowID=$o(^CT.WDT.CDSS.WordsConditionD(myRowID)) q:myRowID=""
		
		s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
		s WordsItem=""
		s:WordsItemDR'="" WordsItem= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
		s ParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),4)
		continue:ParentDR'=""
		s DictId=""
		s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)
		s ItemName=ConditionItemValue
		
		if (WordsItem="诊断名称")||(WordsItem="既往诊断名称")||(WordsItem="诊断症状名称")||(WordsItem="家族史")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在诊断字典是否存在
	    }
	    elseif (WordsItem="手术名称")||(WordsItem="既往手术名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在手术字典是否存在
	    }
	    elseif (WordsItem="检验项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检验项目字典是否存在
		   
	    }
	    elseif (WordsItem="检验医嘱名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检验医嘱字典是否存在
		   
	    }
	    elseif (WordsItem="检查项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检查字典是否存在
		   
	    }
	    elseif (WordsItem="护理项目名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在护理字典是否存在
		   
	    }
	    elseif (WordsItem="药品名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在药品字典是否存在
		   
	    }
	    elseif (WordsItem="输血品名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.BloodProductDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在输血品字典是否存在
		   
	    }
	    elseif (WordsItem="症状名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在症状字典是否存在
		   
	    }
	    elseif (WordsItem="妊娠/产后状态名称")||(WordsItem="月经婚育项目名称")||(WordsItem="个人史名称")||(WordsItem="生命体征名称")
	    {
		    s DictId=$o(^CT.WDT.CDSS.CommonDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在通用名字典是否存在
		    	    
	    }
	    elseif (WordsItem="体格检查名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在体格检查字典是否存在
		   
	    }
	    elseif (WordsItem="护理结果名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.NurseResultDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在护理结果字典是否存在
		  
	    }
	    elseif (WordsItem="检查检验结果名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.ExamResultDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在检查结果字典是否存在
		   
	    }
	    elseif (WordsItem="会诊科室")||(WordsItem="科室名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在科室字典是否存在
		   
	    }
	    elseif (WordsItem="评估表名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0))  //判断在评估表知识库是否存在
	    }
	    elseif (WordsItem="过敏原名称")
	    {
		   s AllergyDictId=$o(^CT.WDT.CDSS.AllergyDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   s DrugDictId=$o(^CT.WDT.CDSS.DrugDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   s:AllergyDictId'="" DictId=AllergyDictId
		   s:DrugDictId'="" DictId=DrugDictId
		   
	    }
	    elseif (WordsItem="中医诊断名称")||(WordsItem="中医诊断症状名称")||(WordsItem="中医既往诊断名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",ItemName,0)) 
	    }
	    elseif (WordsItem="中医证型症状名称")||(WordsItem="中医证型名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
	    }
	    elseif (WordsItem="中医症状")
	    {
		   s DictId=$o(^CT.WDT.CDSS.TCMSymDictI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
	    }
	    elseif (WordsItem="中药名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.TCMMedicineI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   
	    }
	    elseif (WordsItem="中医体征")
	    {
		   s DictId=$o(^CT.WDT.CDSS.TCMSignsI("NameIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   
	    }
	    elseif (WordsItem="病因/诱因")
	    {
		   s DictId=$o(^CT.WDT.CDSS.PathogenyDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   
	    }
	    elseif (WordsItem="评估表结论名称")
	    {
		   s DictId=$o(^CT.WDT.CDSS.AssessResultDictI("DescIndex"," "_$ZCONVERT(ItemName,"U"),0)) 
		   
	    }
	    else //if (WordsItem="性别")||(WordsItem="年龄")||(WordsItem="男")||(WordsItem="女")||(WordsItem="值")||(WordsItem="")
	    {
		    continue
		}
	    
	    if (DictId="")
		{
			
			s NodeDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),2)
			s WordsDR="",NodeNum="",WordsDesc="",WordsType=""
			s:NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),2)
			s:NodeDR'="" NodeNum="节点"_$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),4)
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			s:WordsDR'="" WordsType=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),4)
			w !,WordsDR_"	"_WordsDesc_"	"_WordsType_"	"_WordsItem_"	"_ConditionItemValue
		}
	    
	
	}
	c file
	q fileName
}

/// Creator:丁亚男
/// CreatDate:2023-01-31
/// Description:询证规则某类规则删除方法
/// Table: CT.WDT.CDSS.RuleDict
/// Input: id 
/// Return:返回成功删除条数及失败的规则名称
/// others:w ##class(web.CDSS.CMKB.ImportViewRules).DeleteDataByRuleType("推荐治疗方案","推荐评估表")
ClassMethod DeleteDataByRuleType(ruletypedesc As %String, nodetypedesc As %String)
{
	s resultstr="",nodecount=0,chartcount=0
	s RuleTypeRowid=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_ruletypedesc,""))
	s NodeTypeRowid=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_nodetypedesc,""))
	
	if (RuleTypeRowid'="")&(NodeTypeRowid'="")
	{
		s RuleRowid=0
		for
		{
			s RuleRowid=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",RuleTypeRowid,RuleRowid)) q:RuleRowid=""
			s RuleDesc=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),3)
			
			//查找当前规则下符合要求的节点并删除
			s NodeRowid=""
			for
			{
				s NodeRowid=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowid,NodeTypeRowid,NodeRowid)) q:NodeRowid=""
				//删除节点
				s Noderesult=##class(web.CDSS.CMKB.RuleNode).DeleteData(NodeRowid)  //删除节点及节点连线
				
				if (Noderesult["false")
				{
					s:resultstr'="" resultstr=resultstr_","_RuleDesc_"规则下节点"_Noderesult
					s:resultstr="" resultstr=RuleDesc_"规则下节点"_Noderesult
				}
				else
				{
					s nodecount=nodecount+1
				}
			}
			
			//删除流程图表
			s ChartRowId=0,resultstr=""
			for 
			{
				s ChartRowId = $o(^CT.WDT.CDSS.RuleChartI("RuleTypeDRIndex",RuleRowid,NodeTypeRowid,ChartRowId)) q:ChartRowId=""
				s Chartresult=##class(web.CDSS.CMKB.RuleChart).DeleteData(ChartRowId)  //删除流程图表
				if (Chartresult["false")
				{
					s:resultstr'="" resultstr=resultstr_","_RuleDesc_"规则下流程图"_Chartresult
					s:resultstr="" resultstr=RuleDesc_"规则下流程图"_Chartresult
				}
				else
				{
					s chartcount=chartcount+1
				}
				
			}
	
		}
	}
	s resultstr="成功删除节点"_nodecount_"条！成功删除流程图"_chartcount_"条！"_resultstr
	q resultstr
}

ClassMethod SortRepeatStr(NodeDR As %String, WordsItemDR As %String, ItemName As %String, ItemValues As %String, Properties As %String, MaxValues As %String, MinValues As %String) As %String
{
	s Sort=""
	for ItemIndex=1:1:$l(Properties,"&%")
	{
		s Property=$p(Properties,"&%",ItemIndex)
		continue:Property=""
		if Property="值"
		{
			s MaxValue=$p(MaxValues,"&%",1)
			s MinValue=$p(MinValues,"&%",1)
		}
		else
		{
			s ItemValue=$p(ItemValues,"&%",ItemIndex)
		}
		s:$g(ItemValue,"")="" ItemValue="空Item"
		s:$g(MaxValue,"")="" MaxValue="空Max"
		s:$g(MinValue,"")="" MinValue="空Min"
		s Sort(Property,ItemValue,MaxValue,MinValue)=""
	}
	s LongStr=""
	s Property =""
	for
	{
		s Property=$o(Sort(Property)) q:Property=""
		s ItemValue=""
		for
		{
			s ItemValue=$o(Sort(Property,ItemValue)) q:ItemValue=""
			s MaxValue=""
			for
			{
				s MaxValue=$o(Sort(Property,ItemValue,MaxValue)) q:MaxValue=""
				s MinValue=""
				for
				{
					s MinValue=$o(Sort(Property,ItemValue,MaxValue,MinValue)) q:MinValue=""
					s:LongStr'="" LongStr=LongStr_"&"_Property_","_ItemValue_","_MaxValue_","_MinValue
					s:LongStr="" LongStr=Property_","_ItemValue_","_MaxValue_","_MinValue
				}
			}
		}
	}
	s RepeatStr=WordsItemDR_","_NodeDR_","_ItemName_","_LongStr
	q RepeatStr
}

/// Creator:谷雪萍
/// CreatDate:2023-05-08
/// Description:字典审核的时候，按名称以及识别词导入的格式新增一条识别条件的识别词
/// Input:Line-导入模板中一行的内容，单元格之间用英文逗号连接
/// Return:false^错误信息/true^导入成功
/// Other:模板：识别词名称	属性	类型	满足条件个数	项目	名称	是否有属性
/// Other:w ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo("GXP测试诊断,诊断条件,主要条件-识别词,1,诊断名称,GXP测试诊断,0")
ClassMethod SaveIdentifyWordsInfo(Line As %String) As %String
{
	s SaveLineResult=""
	s Line = ..DealSymbol(Line)  //处理符号
	
	s WordsDesc=$p(Line,",",1)  //识别词名称
	
	//判断必填项 1
	if (WordsDesc="")
	{
		q "未导入,false^未获取到识别词名称!"  //返回错误信息
		
	}
	s WordsType=$p(Line,",",2)  //识别词类型
	s:WordsType="诊断" WordsType="诊断条件"
	if (WordsType="")
	{
		q "未导入,false^未获取到识别词类型!"  //返回错误信息
		
	}
	//保存识别词规则 2
	s NodeType=$p(Line,",",3) //识别词类型
	s WordsStatus="审核通过"
	if (NodeType="")
	{
		s WordsStatus="编辑中"
	}
	if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType)))
	{
		q "未导入,false^已经有该识别词了，不能新增!"  //返回错误信息
		
	}

	TS
	s WordsId=..SaveIdentifyWords(WordsDesc,WordsType,WordsStatus)  //保存识别词基础信息
	if (WordsId="")  //没获取到识别词id，则导入失败
	{
		s SaveLineResult="未导入,false^未获取到识别词id，不能进行拆分!"  //返回错误信息
	}
	else
	{
		if (NodeType="")  //如果识别词类型为空则不必拆分识别词，导入完成
		{
			 s SaveLineResult="已导入,"_WordsId
		}
		else  //如果识别词类型不为空则需要拆分识别词
		{
			s saveresult=..SaveAllWordsNode(WordsId,Line)
			if (saveresult["false")
			{
				s SaveLineResult="未导入,"_saveresult
			}
			else
			{
				//保存连线				
				if (NodeType'="") //如果识别词类型不为空，则保存连线
				{					
					s linkresult=..SaveAllWordsNodeLink(WordsId,"1")
					
					if (linkresult["false")
					{
						s SaveLineResult="未导入,"_linkresult
					}
					else
					{
						//删除json图信息
						s WordsChartId=$O(^CT.WDT.CDSS.WordsChartI("WordsDRIndex",WordsId,""))
						if (WordsChartId'="")
						{
							s ChartSC=##class(CT.WDT.CDSS.WordsChart).%DeleteId(WordsChartId)
							if '$$$ISOK(ChartSC)
							{
								s jsonresult = "false^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ChartSC)  //返回错误信息
								s SaveLineResult="未导入,"_jsonresult
							}
						}
					}
				}
			}
		}
	}

	if (SaveLineResult["false")
	{
		tro
	}
	else
	{
		tc
		s SaveLineResult="已导入,"_WordsId
	}
	q SaveLineResult
}

}
