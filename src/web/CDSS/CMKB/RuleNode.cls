/// Description：诊疗流程节点表
/// Table：CT.WDT.CDSS.RuleNode
Class web.CDSS.CMKB.RuleNode Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-09-07
/// Description:获得规则节点
/// Table: CT.WDT.CDSS.RuleNode
/// Input:节点id RuleDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleNode","GetList","9211","8")
Query GetList(RuleDR As %String, TypeDR As %String) As %Query(ROWSPEC = "RuleDR,NodeRowId,FlowChartNum,NodeNum,NodeType,NodeTypeDesc,MeetConditionNum,Remarks,ChartLeft,ChartTop,RuleTypeDR,ChartTypeDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RuleDR As %String, TypeDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (RuleDR="") q ""
 
	s NodeRowId = ""
	for
	{
		s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR,NodeRowId)) q:NodeRowId=""
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
		s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),9)
		s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10)
		s ChartTypeDesc=""
		s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
		if (RuleTypeDR=TypeDR)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RuleDR,NodeRowId,FlowChartNum,NodeNum,NodeType,NodeTypeDesc,MeetConditionNum,Remarks,ChartLeft,ChartTop,RuleTypeDR,ChartTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleNode
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleNode).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleNode) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		if (eobj.NodeRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleNode).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(eobj.NodeRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleNode).%New() 
			if $IsObject(obj.RuleDR)
			{
			 	s bobj.RuleDR = obj.RuleDR.%Id()
			}
			s bobj.FlowChartNum = obj.FlowChartNum  
			s bobj.NodeNum = obj.NodeNum 
			if $IsObject(obj.NodeType)
			{
			 	s bobj.NodeType = obj.NodeType.%Id()
			}
			s bobj.MeetConditionNum = obj.MeetConditionNum
			s bobj.Remarks = obj.Remarks
			s bobj.ChartLeft = obj.ChartLeft
			s bobj.ChartTop = obj.ChartTop
			if $IsObject(obj.RuleTypeDR)
			{
			 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
			}
		}
		d:eobj.RuleDR'="" obj.RuleDRSetObjectId(eobj.RuleDR)
		d:eobj.RuleDR="" obj.RuleDRSetObjectId("")
		s obj.FlowChartNum = eobj.FlowChartNum  
		s obj.NodeNum = eobj.NodeNum 
		d:eobj.NodeType'="" obj.NodeTypeSetObjectId(eobj.NodeType)
		d:eobj.NodeType="" obj.NodeTypeSetObjectId("")
		s obj.MeetConditionNum = eobj.MeetConditionNum
		s obj.Remarks = eobj.Remarks
		s obj.ChartLeft = eobj.ChartLeft
		s obj.ChartTop = eobj.ChartTop
		d:eobj.RuleTypeDR'="" obj.RuleTypeDRSetObjectId(eobj.RuleTypeDR)
		d:eobj.RuleTypeDR="" obj.RuleTypeDRSetObjectId("")
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDesc=""
			s:eobj.RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(eobj.RuleDR)),3)
		
			d:eobj.NodeRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleNode","CT.WDT.CDSS.RuleNode","诊疗流程节点表",id,RuleDesc_",图"_eobj.FlowChartNum_",节点"_eobj.NodeNum,"A",eobj)
			d:eobj.NodeRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleNode","CT.WDT.CDSS.RuleNode","诊疗流程节点表",eobj.NodeRowId,RuleDesc_",图"_eobj.FlowChartNum_",节点"_eobj.NodeNum,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程节点表","web.CDSS.CMKB.RuleNode","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程节点表","web.CDSS.CMKB.RuleNode","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleNode
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleNode).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleNode).%New() 
	if $IsObject(obj.RuleDR)
	{
	 	s bobj.RuleDR = obj.RuleDR.%Id()
	}
	s bobj.FlowChartNum = obj.FlowChartNum  
	s bobj.NodeNum = obj.NodeNum 
	if $IsObject(obj.NodeType)
	{
	 	s bobj.NodeType = obj.NodeType.%Id()
	}
	s bobj.MeetConditionNum = obj.MeetConditionNum
	s bobj.Remarks = obj.Remarks
	s bobj.ChartLeft = obj.ChartLeft
	s bobj.ChartTop = obj.ChartTop
	if $IsObject(obj.RuleTypeDR)
	{
	 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
	}
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleNode
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleNode).DeleteData("152722")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	//删除诊疗节点内容（触发条件类）
	s ConditionRowId=0
	for
	{
		s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",id,ConditionRowId)) q:ConditionRowId=""
		s result=##class(web.CDSS.CMKB.RuleCondition).DeleteData(ConditionRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（触发条件类）删除失败'}"  //返回错误信息
		}
	}
	//删除诊疗节点内容（结论类）
	s ResultRowId=0
	for
	{
		s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",id,ResultRowId)) q:ResultRowId=""
		s result=##class(web.CDSS.CMKB.RuleResult).DeleteData(ResultRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（结论类）删除失败'}"  //返回错误信息
		}
	}
	//删除诊疗节点内容（合理性）
	s RationalityRowId=0
	for
	{
		s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",id,RationalityRowId)) q:RationalityRowId=""
		s result=##class(web.CDSS.CMKB.RuleRationality).DeleteData(RationalityRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（合理性）删除失败'}"  //返回错误信息
		}
	}
	//删除诊疗节点内容（并发症）
	s ComplicationRowId=0
	for
	{
		s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",id,ComplicationRowId)) q:ComplicationRowId=""
		s result=##class(web.CDSS.CMKB.RuleComplication).DeleteData(ComplicationRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（并发症）删除失败'}"  //返回错误信息
		}
	}
	
	//删除诊疗节点内容（治疗方案明细表）
	s DetailRowId=0
	for
	{
		s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",id,DetailRowId)) q:DetailRowId=""
		s result=##class(web.CDSS.CMKB.RuleDetail).DeleteData(DetailRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（治疗方案明细表）删除失败'}"  //返回错误信息
		}
	}
	
	//删除诊疗流程线表上节点连线
	s PreLinkRowId=0
	for
	{
		s PreLinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("PreNodeIndex",id,PreLinkRowId)) q:PreLinkRowId=""
		s result=##class(web.CDSS.CMKB.RuleLink).DeleteData(PreLinkRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗流程上节点连线删除失败'}"  //返回错误信息
		}
	}
	//删除诊疗流程线表下节点连线
	s NextLinkRowId=0
	for
	{
		s NextLinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("NextNodeIndex",id,NextLinkRowId)) q:NextLinkRowId=""
		s result=##class(web.CDSS.CMKB.RuleLink).DeleteData(NextLinkRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗流程下节点连线删除失败'}"  //返回错误信息
		}
	}
	s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleNode).%New() 
	if $IsObject(obj.RuleDR)
	{
	 	s bobj.RuleDR = obj.RuleDR.%Id()
	}
	s bobj.FlowChartNum = obj.FlowChartNum  
	s bobj.NodeNum = obj.NodeNum 
	if $IsObject(obj.NodeType)
	{
	 	s bobj.NodeType = obj.NodeType.%Id()
	}
	s bobj.MeetConditionNum = obj.MeetConditionNum
	s bobj.Remarks = obj.Remarks
	s bobj.ChartLeft = obj.ChartLeft
	s bobj.ChartTop = obj.ChartTop
	if $IsObject(obj.RuleTypeDR)
	{
	 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
	}
	s sc=##class(CT.WDT.CDSS.RuleNode).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDesc=""
		s:bobj.RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(bobj.RuleDR)),3)
			
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleNode","CT.WDT.CDSS.RuleNode","诊疗流程节点表",id,RuleDesc_",图"_bobj.FlowChartNum_",节点"_bobj.NodeNum,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程节点表","web.CDSS.CMKB.RuleNode","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-26
/// Description：修改流程图顺序号
/// Table：CT.WDT.CDSS.RuleNode
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleNode).ChangeFlowChartNum()
ClassMethod ChangeFlowChartNum(NodeRowId, FlowChartNum) As %String
{
	if (NodeRowId="")||(FlowChartNum="")
	{
		s result="{success:'false',errorinfo:'数据项为空!'}" 
	}
	s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeRowId)
	s obj.FlowChartNum = FlowChartNum 	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-26
/// Description：获取流程图顺序号
/// Table：CT.WDT.CDSS.RuleNode
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleNode).getFlowChartNum()
ClassMethod getFlowChartNum(NodeRowId) As %String
{
	if (NodeRowId="") q ""
	s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
	q FlowChartNum
}

/// Creator：丁亚男
/// CreatDate: 2011-11-10
/// Description：修改节点需要满足的条件个数
/// Table：CT.WDT.CDSS.RuleNode
/// Input：NodeRowId
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleNode).UpMeetConditionNum(NodeRowId,MeetConditionNum)
ClassMethod UpMeetConditionNum(NodeRowId, MeetConditionNum) As %String
{
	if (NodeRowId="") q "false"
	s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeRowId) 
	s obj.MeetConditionNum = MeetConditionNum	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-03-24
/// Description:获得规则下所有流程节点，按流程顺序返回
/// Table: CT.WDT.CDSS.RuleNode
/// Input: 识别词ID—WordsDR
/// Return:顺序返回流程节点
/// Other: w ##class(web.CDSS.CMKB.RuleNode).GetRuleListJson("9776","")
ClassMethod GetRuleListJson(RuleDR As %String, TypeDR As %String = "") As %String
{
	
	if (RuleDR="") q ""	
 	s store={}
 	if TypeDR="" s TypeDR=-100000000000000
 	s GlobalStr=""
 	s num=0
 	s GlobalStr=GlobalStr_"["
 	s NodeId=""
 	for{
	 	
	 	s NodeId = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleDR,TypeDR,NodeId)) q:NodeId=""
 		s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeId)),3)
	 	s num=num+1
		if num>1 s GlobalStr=GlobalStr_ ","
	 	s GlobalStr=GlobalStr_"["
	 	s count=0
		s NodeRowId = ""
		for
		{
			s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,TypeDR,FlowChartNumT,NodeRowId)) q:NodeRowId=""
				
			s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
			s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
			s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				
			s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),7)
			s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),8)
			s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),9)
			s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10)
			s ChartTypeDesc=""
			s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
				
			s count=count+1
			if count>1 s GlobalStr=GlobalStr_ ","
			s GlobalStr=GlobalStr_ "{""NodeRowId"":"""_NodeRowId_""""
			s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
			_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
			s GlobalStr=GlobalStr_ "}"
				
		}
			
		//线表数据
		s LinkRowId = ""
		for
		{
			s LinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("TypeChartIndex",RuleDR,TypeDR,FlowChartNumT,LinkRowId)) q:LinkRowId=""
			s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),3)
			s PreNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),4)
			s PreNodeNum="",PreNodeType="",PreNodeTypeDesc=""
			if (PreNode'="")
			{
				s PreNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),4)
				s PreNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),5)
				s:PreNodeType'="" PreNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(PreNodeType)),3)
			} 
			s NextNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),5)
			s NextNodeNum="",NextNodeType="",NextNodeTypeDesc=""
			if (NextNode'="")
			{
				s NextNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),4)
				s NextNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),5)
				s:NextNodeType'="" NextNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NextNodeType)),3)
			}					
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),6)
			s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),7)
			s ChartTypeDesc=""
			s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
									
			s GlobalStr=GlobalStr_ ","
			s GlobalStr=GlobalStr_ "{""LinkRowId"":"""_LinkRowId_""""
			s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""PreNode"":"""_PreNode_""",""PreNodeNum"":"""_PreNodeNum_""",""PreNodeType"":"""_PreNodeType_""",""PreNodeTypeDesc"":"""_PreNodeTypeDesc
			_""",""NextNode"":"""_NextNode_""",""NextNodeNum"":"""_NextNodeNum_""",""NextNodeType"":"""_NextNodeType_""",""NextNodeTypeDesc"":"""_NextNodeTypeDesc
			_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
				s GlobalStr=GlobalStr_"}"						
		}
			
		s GlobalStr=GlobalStr_"]"
		
	}
	s GlobalStr=GlobalStr_"]"
	//节点排序
	s array=##class(%DynamicAbstractObject).%FromJSON(GlobalStr)
	s outer=[]
	s result=[]
	s record={}
	s checkRowId=""
	for index=0:1:(array.%Size()-1)    //遍历array
	{
		s outer=array.%Get(index)	
		if outer.%ToJSON()="" continue
		s checkRowId=outer.%Get(0).NodeRowId
		s flag=record.%Get(checkRowId)
		if (flag=""){
			d record.%Set(checkRowId,checkRowId)
			s empty=[{}]
			s temp={}
			f j=0:1:(outer.%Size()-1)
			{	
				s item=outer.%Get(j)
				q:item=""
				if item.%ToJSON()="" continue
				//s check=item.%ToJSON()
				if (item.NodeType="1")
				{
					d empty.%Set(0,item)
					
				}
				elseif (item.NodeType="2"){
					s temp=item	
				}
				else{
					d empty.%Push(item)
				}
			}
			d empty.%Push(temp)
			d result.%Push(empty)
		}
	}
	q result.%ToJSON()
}

/// Creator:赵文伟
/// CreatDate:2022-06-09
/// Description:获得当前规则下所有流程数据，按流程顺序返回节点和线
/// Table: CT.WDT.CDSS.RuleNode，CT.WDT.CDSS.RuleLink
/// Input: 规则Id：RuleDR，规则类型：TypeDR
/// Return:按流程图顺序返回流程节点和线数据
/// Other: w ##class(web.CDSS.CMKB.RuleNode).GetRuleJson("9776","14")
/// Other: w ##class(web.CDSS.CMKB.RuleNode).GetRuleJson("480","")
ClassMethod GetRuleJson(RuleDR As %String, TypeDR As %String = "") As %String
{
	if (RuleDR="") q ""
	s:TypeDR="" TypeDR=-100000000000000
	s GlobalStr=""
 	s count=0
 	s num=0
 	s GlobalStr=GlobalStr_"["
 	s GlobalStrArr={}
	s StartNodeType=1	//开始
	s EndNodeType=2		//结束
	s ChartNum=0
 	for{
	 	s ChartNum = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeChartIndex",RuleDR,TypeDR,StartNodeType,ChartNum)) q:ChartNum=""	//流程图顺序号
		s NodeRowId=""
	 	for{
		 	s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeChartIndex",RuleDR,TypeDR,StartNodeType,ChartNum,NodeRowId)) q:NodeRowId=""	//开始节点
	 		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
			s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
			s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					
			s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),7)
			s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),8)
			s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),9)
			s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10)
			s ChartTypeDesc=""
			s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			
	 		s count=count+1
			if count>1 s GlobalStr=GlobalStr_","
			s GlobalStr=GlobalStr_"["
			s GlobalStr=GlobalStr_"{""NodeRowId"":"""_NodeRowId_""""
			s GlobalStr=GlobalStr_",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
				_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
			s GlobalStr=GlobalStr_"}"
			s NodeId=NodeRowId
			
			s GlobalStr=..GetFollowRuleJson(GlobalStr,RuleDR,NodeId,TypeDR)
			S Len=$L(GlobalStr)
			if (Len>100000) {
				w GlobalStr
				s GlobalStr=""
			}
	 	}
 	}
	s GlobalStr=GlobalStr_"]"
 	w GlobalStr
 	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-06-09
/// Description:获得当前规则下所有流程数据，按流程顺序返回节点和线【递归取开始节点后续节点】
/// Table: CT.WDT.CDSS.RuleNode，CT.WDT.CDSS.RuleLink
/// Input: 
/// Return:按流程顺序返回开始节点的后续流程节点和线
/// Other: w ##class(web.CDSS.CMKB.RuleNode).GetFollowRuleJson("","","","")
/// Other: w ##class(web.CDSS.CMKB.RuleNode).GetFollowRuleJson("XXX","480","7655","")
ClassMethod GetFollowRuleJson(GlobalStr As %String, RuleDR As %String, NodeId As %String, TypeDR As %String = "") As %String
{
	s EndNodeType=2		//结束
	s:TypeDR="" TypeDR=-100000000000000
	s LinkRowId = ""
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("PreRuleTypeIndex",RuleDR,TypeDR,NodeId,LinkRowId)) q:LinkRowId=""
		
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),3)
		s PreNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),4)
		s PreNodeNum="",PreNodeType="",PreNodeTypeDesc=""
		if (PreNode'="")
		{
			s PreNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),4)
			s PreNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),5)
			s:PreNodeType'="" PreNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(PreNodeType)),3)
		} 
		s NextNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),5)
		s NextNodeNum="",NextNodeType="",NextNodeTypeDesc=""
		if (NextNode'="")
		{
			s NextNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),4)
			s NextNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),5)
			s:NextNodeType'="" NextNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NextNodeType)),3)
		}					
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),6)
		s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),7)
		s ChartTypeDesc=""
		s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			
		s GlobalStr=GlobalStr_ ","
		s GlobalStr=GlobalStr_ "{""LinkRowId"":"""_LinkRowId_""""
		s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""PreNode"":"""_PreNode_""",""PreNodeNum"":"""_PreNodeNum_""",""PreNodeType"":"""_PreNodeType_""",""PreNodeTypeDesc"":"""_PreNodeTypeDesc
			_""",""NextNode"":"""_NextNode_""",""NextNodeNum"":"""_NextNodeNum_""",""NextNodeType"":"""_NextNodeType_""",""NextNodeTypeDesc"":"""_NextNodeTypeDesc
			_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
		s GlobalStr=GlobalStr_"}"
		
		if (NextNode="") continue
		s NodeDR=NextNode
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
		
		s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),9)
		s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),10)
		s ChartTypeDesc=""
		s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
		s GlobalStr=GlobalStr_ ","
		s GlobalStr=GlobalStr_ "{""NodeRowId"":"""_NodeDR_""""
		s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
			_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
		s GlobalStr=GlobalStr_ "}"
			 
		if (NodeType=EndNodeType){		//找到结束节点，取下一条流程
			s GlobalStr=GlobalStr_"]"
			
			q 
			
		} 
		else 	//取当前流程后续数据
		{
			
			s GlobalStr= ..GetFollowRuleJson(GlobalStr,RuleDR,NodeDR,TypeDR)
			
		}
		
	}
	
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2023-02-14
/// Description:根据id判断规则节点数据是否存在
/// Table: CT.WDT.CDSS.RuleNode
/// Input: id
/// Return:0[不存在]，1[存在]
/// Other: w ##class(web.CDSS.CMKB.RuleNode).JustExistID("12324")
ClassMethod JustExistID(id As %String) As %String
{
	q:id="" 0
	s flag=0
	if ($d(^CT.WDT.CDSS.RuleNodeD(id))){
		s flag=1
	} 
	q flag
}

/// Creator:dingyanan
/// CreatDate:2023-03-17
/// Description:复制规则流程图节点的方法
/// Table: CT.WDT.CDSS.WordsNode
/// Input: id--复制节点的id
/// Return:成功返回true及新节点的id，失败返回false
/// Other: w ##class(web.CDSS.CMKB.RuleNode).CopyNode(343362,866,126)
ClassMethod CopyNode(copyid As %String, ChartLeft As %String, ChartTop As %String, RuleId As %String = "", RuleTypeId As %String = "", NodeNum As %String = "") As %String
{
	
	s result=""
	if (copyid="")||('$d(^CT.WDT.CDSS.RuleNodeD(copyid)))
	{
		q "{success:'false',errorinfo:'节点不存在！'}"
	}
	//复制节点
	s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(copyid)
	s eobj = ##class(web.CDSSEntity.CMKB.RuleNode).%New()
	if (RuleId'="")
	{
		s eobj.RuleDR =RuleId
	} 
	else
	{
		if $IsObject(obj.RuleDR)
		{
		 	s eobj.RuleDR = obj.RuleDR.%Id()
		}
	}
	s eobj.FlowChartNum = obj.FlowChartNum  
	if (NodeNum'="")
	{
		s eobj.NodeNum = NodeNum 
	}
	else
	{
		s eobj.NodeNum = obj.NodeNum 
	}
	if $IsObject(obj.NodeType)
	{
	 	s eobj.NodeType = obj.NodeType.%Id()
	}
	s eobj.MeetConditionNum = obj.MeetConditionNum
	s eobj.Remarks = obj.Remarks
	s eobj.ChartLeft = ChartLeft
	s eobj.ChartTop = ChartTop 
	if (RuleTypeId'="")
	{
		s eobj.RuleTypeDR = RuleTypeId
	}
	else
	{
		if $IsObject(obj.RuleTypeDR)
		{
		 	s eobj.RuleTypeDR = obj.RuleTypeDR.%Id()
		}
	}
	
	s noderesult=..SaveData(eobj)
	d eobj.%Close()
	if (noderesult["true")
	{
		s NewNodeId=$p(noderesult,"'",4)
		//条件复制
		s ConditionID=0
		for 
		{
			s ConditionID=$o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",copyid,ConditionID)) q:(ConditionID="")
			s eobjCondition=##class(web.CDSSEntity.CMKB.RuleCondition).%New()
			s eobjCondition.NodeDR=NewNodeId 
			s eobjCondition.ConditionClass=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),3)
			s eobjCondition.ConditionItem=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),4)
			s eobjCondition.ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),5)
			s eobjCondition.ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),6)
			s eobjCondition.ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),7)
			s eobjCondition.SpecialConfig  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),8)
			s eobjCondition.Remarks  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),9)
			s eobjCondition.ConditionItemCategory  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionID)),10)
			s Conditionresult=##class(web.CDSS.CMKB.RuleCondition).SaveData(eobjCondition)
			d eobjCondition.%Close()
			if (Conditionresult'["true")
			{
				
				s result="{success:'false',errorinfo:'"_eobjCondition.ConditionItemValue_"复制失败！'}"	
			}
			
		}
		//推荐诊疗复制
		s ResultRowId = 0
		for
		{
			s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",copyid,ResultRowId)) q:ResultRowId=""
			
			//复制来源
			s RuleBasisDR= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
			s NewBasisId=""
			if (RuleBasisDR'="")
			{
				s eobjBasis=##class(web.CDSSEntity.CMKB.RuleBasis).%New()
				s eobjBasis.Content = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),2)
				s eobjBasis.UpdateUser  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),3)
				s eobjBasis.UpdateDate  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),4)
				s eobjBasis.Remarks  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),5)
				s Basisresult=##class(web.CDSS.CMKB.RuleBasis).SaveData(eobjBasis)
				d eobjBasis.%Close()
				if (Basisresult'["true")
				{
					
					s result="{success:'false',errorinfo:'来源复制失败！'}"	
				}
				else
				{
					s NewBasisId=$p(Basisresult,"'",4)
				}
			}
			//ResultRowId, NodeDR, Sequence, RecommendType, RecommendResult, Remarks, BaseTable, TreatSource, SourceImg, RuleBasisDR
			s NodeDR=NewNodeId 
			s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
			s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
			s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),6)
			s BaseTable= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),7)
			s TreatSource= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
			//读取流数据
			s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(ResultRowId)
			s Img  = obj.SourceImg //$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
			s len=Img.SizeGet()
	        d Img.Rewind()
	        s SourceImg=Img.Read(len)
			d obj.%Close()	
			k obj
		
			//s SourceImg= $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
			s RuleBasisDR=NewBasisId
			s Resultresult=##class(web.CDSS.CMKB.RuleResult).SaveData("",NodeDR, Sequence, RecommendType, RecommendResult, Remarks, BaseTable, TreatSource, SourceImg, RuleBasisDR)
			
			if (Resultresult'["true")
			{
				
				s result="{success:'false',errorinfo:'来源复制失败！'}"	
			}
		}
		
								
		//推荐治疗方案明细表 注意推荐治疗方案方剂会自动保存方剂明细 没有严格按照复制数据的方剂明细走
		s PDetailRowId = 0
		for
		{
			s PDetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",copyid,-100000000000000,PDetailRowId)) q:PDetailRowId=""
			s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NewNodeId)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			s eobjPDetail=##class(web.CDSSEntity.CMKB.RuleDetail).%New()
			s eobjPDetail.NodeDR=NewNodeId 
			s eobjPDetail.Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),3)
			s eobjPDetail.DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),4)
			s eobjPDetail.DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),5)
			s eobjPDetail.DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),6)
			s eobjPDetail.DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),7)
			s eobjPDetail.DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),8)
			s eobjPDetail.DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),9)
			s eobjPDetail.Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),10)
			s eobjPDetail.Remarks  = $lg($g(^CT.WDT.CDSS.RuleDetailD(PDetailRowId)),11)
			s eobjPDetail.LastLevel=""
			s PDetailresult=##class(web.CDSS.CMKB.RuleDetail).SaveData(eobjPDetail)
			d eobjPDetail.%Close()
			if (PDetailresult'["true")
			{
			
				s result="{success:'false',errorinfo:'推荐治疗方案复制失败！'}"	
			}
			elseif(NodeTypeDesc="推荐治疗方案-处置")
			{	
			
				s NewPDetail=$p(PDetailresult,"'",4) 
				s CDetailRowId = 0
				for
				{
					s CDetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",PDetailRowId,CDetailRowId)) q:CDetailRowId=""
					s eobjCDetail=##class(web.CDSSEntity.CMKB.RuleDetail).%New()
					s eobjCDetail.NodeDR=NewNodeId
					s eobjCDetail.Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),3)
					s eobjCDetail.DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),4)
					s eobjCDetail.DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),5)
					s eobjCDetail.DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),6)
					s eobjCDetail.DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),7)
					s eobjCDetail.DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),8)
					s eobjCDetail.DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),9)
					s eobjCDetail.Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),10)
					s eobjCDetail.Remarks  = $lg($g(^CT.WDT.CDSS.RuleDetailD(CDetailRowId)),11)
					s eobjCDetail.LastLevel=NewPDetail
					s CDetailresult=##class(web.CDSS.CMKB.RuleDetail).SaveData(eobjCDetail)
					d eobjCDetail.%Close()
					if (CDetailresult'["true")
					{
						
						s result="{success:'false',errorinfo:'推荐治疗方案-处置复制失败！'}"	
					}
				}
			}
			
		}
		
		//预警信息复制
		s RationalityRowId = 0
		for
		{
			s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",copyid,RationalityRowId)) q:RationalityRowId=""
			//复制来源
			s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),8)
			s NewBasisId=""
			if (RuleBasisDR'="")
			{
				s eobjBasis=##class(web.CDSSEntity.CMKB.RuleBasis).%New()
				s eobjBasis.Content = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),2)
				s eobjBasis.UpdateUser  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),3)
				s eobjBasis.UpdateDate  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),4)
				s eobjBasis.Remarks  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),5)
				s Basisresult=##class(web.CDSS.CMKB.RuleBasis).SaveData(eobjBasis)
				d eobjBasis.%Close()
				if (Basisresult'["true")
				{
					
					s result="{success:'false',errorinfo:'来源复制失败！'}"	
				}
				else
				{
					s NewBasisId=$p(Basisresult,"'",4)
				}
			}
			
			s eobjRationality=##class(web.CDSSEntity.CMKB.RuleRationality).%New()
			s eobjRationality.NodeDR=NewNodeId	
			s eobjRationality.Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
			s eobjRationality.WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
			s eobjRationality.TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
			s eobjRationality.TreatSource = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),7)
			s eobjRationality.RuleBasisDR = NewBasisId	
			s Rationalityresult=##class(web.CDSS.CMKB.RuleRationality).SaveData(eobjRationality)
			d eobjRationality.%Close()
			if (Rationalityresult'["true")
			{
				
				s result="{success:'false',errorinfo:'合理性预警复制失败！'}"	
			}
			
		}
		
		//并发症信息复制
		s ComplicationRowId = 0
		for
		{
			s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",copyid,ComplicationRowId)) q:ComplicationRowId=""
			
			//复制来源
			s RuleBasisDR = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),8)
			s NewBasisId=""
			if (RuleBasisDR'="")
			{
				s eobjBasis=##class(web.CDSSEntity.CMKB.RuleBasis).%New()
				s eobjBasis.Content = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),2)
				s eobjBasis.UpdateUser  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),3)
				s eobjBasis.UpdateDate  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),4)
				s eobjBasis.Remarks  = $lg($g(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)),5)
				s Basisresult=##class(web.CDSS.CMKB.RuleBasis).SaveData(eobjBasis)
				d eobjBasis.%Close()
				if (Basisresult'["true")
				{
					
					s result="{success:'false',errorinfo:'来源复制失败！'}"	
				}
				else
				{
					s NewBasisId=$p(Basisresult,"'",4)
				}
			}
			
			s eobjComplication=##class(web.CDSSEntity.CMKB.RuleComplication).%New()	
			s eobjComplication.NodeDR=NewNodeId
			s eobjComplication.Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
			s eobjComplication.ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
			s eobjComplication.MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
			s eobjComplication.Remarks = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),6)
			s eobjComplication.TreatSource = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),7)
			s eobjComplication.RuleBasisDR = NewBasisId	
			s Complicationresult=##class(web.CDSS.CMKB.RuleComplication).SaveData(eobjComplication)
			d eobjComplication.%Close()
			if (Complicationresult'["true")
			{
				
				s result="{success:'false',errorinfo:'并发症预警复制失败！'}"	
			}
			
		}
		
		
		s result = "{success:'true',id:'"_NewNodeId_"'}"
	}
	else
	{
		
		s result="{success:'false',errorinfo:'节点复制失败！'}"
	}
	q result
}

/// Creator:dingyanan
/// CreatDate:2023-04-04
/// Description:更新流程图节点顺序号
/// Table: CT.WDT.CDSS.WordsNode
/// Input: RuleId--规则的id、RuleTypeId--规则类型的id、OldNum、NewNum
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.CMKB.RuleNode).UpdateFlowChartNum(64946,"",1,3)
ClassMethod UpdateFlowChartNum(RuleId As %String, RuleTypeId As %String = "", OldNum As %String, NewNum As %String) As %String
{
	if (RuleId="")||(OldNum="")||(NewNum="")
	{
		q "{success:'false',errorinfo:'入参格式不正确，请重新操作！'}"
	}
	s result="{success:'success',info:'顺序号改变成功！'}"
	s StartNodeTDR=$O(^CT.WDT.CDSS.NodeTypeI("DescIndex"," 开始",""))
	s EndNodeTDR=$O(^CT.WDT.CDSS.NodeTypeI("DescIndex"," 结束",""))
	
	s:RuleTypeId="" RuleTypeId=-100000000000000
	s NodeDRStr="",len=0
	s TNodeDR=0
	for
	{
		s TNodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeIndex",RuleTypeId,RuleId,OldNum,TNodeDR)) q:TNodeDR=""
		s len=len+1
		s:NodeDRStr'="" NodeDRStr=NodeDRStr_"&%"_TNodeDR
		s:NodeDRStr="" NodeDRStr=TNodeDR	
	}
	Ts
	if (NewNum>OldNum)
	{
		s StartNum=OldNum+1
		for iNum=StartNum:1:NewNum
		{
			//节点顺序号改变
			s NodeDR=0
			for
			{
				s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeIndex",RuleTypeId,RuleId,iNum,NodeDR)) q:NodeDR=""
				s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeDR)
				s obj.FlowChartNum=iNum-1
				s NodeType=obj.NodeType.%Id()
				if (NodeType=StartNodeTDR)||(NodeType=EndNodeTDR)
				{
					s obj.NodeNum=iNum-1
				}
				s sc=obj.%Save()
				d obj.%Close()
				If '$$$ISOK(sc)
				{
					Trollback
				}
			}
			
			//线顺序号改变
			s LinkDR=0
			for
			{
				s LinkDR = $o(^CT.WDT.CDSS.RuleLinkI("TypeChartIndex",RuleId,RuleTypeId,iNum,LinkDR)) q:LinkDR=""
				s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkDR)
				s obj.FlowChartNum=iNum-1
				s sc=obj.%Save()
				d obj.%Close()
				If '$$$ISOK(sc)
				{
					Trollback
				}
			}
			
		}
	}
	elseif(NewNum<OldNum)
	{
		s iNum=OldNum
		for 
		{
			S iNum=iNum-1
			q:iNum<NewNum
			//节点顺序号改变
			s NodeDR=0
			for
			{
				s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeIndex",RuleTypeId,RuleId,iNum,NodeDR)) q:NodeDR=""
				s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeDR)
				s obj.FlowChartNum=iNum+1
				s NodeType=obj.NodeType.%Id()
				if (NodeType=StartNodeTDR)||(NodeType=EndNodeTDR)
				{
					s obj.NodeNum=iNum+1
				}
				s sc=obj.%Save()
				d obj.%Close()
				If '$$$ISOK(sc)
				{
					Trollback
				}
			}
			
			//线顺序号改变
			s LinkDR=0
			for
			{
				s LinkDR = $o(^CT.WDT.CDSS.RuleLinkI("TypeChartIndex",RuleId,RuleTypeId,iNum,LinkDR)) q:LinkDR=""
				s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkDR)
				s obj.FlowChartNum=iNum+1
				s sc=obj.%Save()
				d obj.%Close()
				If '$$$ISOK(sc)
				{
					Trollback
				}
			}
			
		}
	}


	// 移动节点顺序号修改
	for iNodeDR=1:1:len
	{
		s NodeDR=$p(NodeDRStr,"&%",iNodeDR)
		//节点顺序号改变
		s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeDR)
		s obj.FlowChartNum=NewNum
		s NodeType=obj.NodeType.%Id()
		if (NodeType=StartNodeTDR)||(NodeType=EndNodeTDR)
		{
			s obj.NodeNum=NewNum
		}
		s sc=obj.%Save()
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			Trollback
		}

		// 线顺序号改变
		s LinkDR=0
		for
		{
			s LinkDR = $o(^CT.WDT.CDSS.RuleLinkI("NextNodeIndex",NodeDR,LinkDR)) q:LinkDR=""
			s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkDR)
			s obj.FlowChartNum=NewNum
			s sc=obj.%Save()
			d obj.%Close()
			If '$$$ISOK(sc)
			{
				Trollback
			}
		}
		
	}
	
	Tc
	
	
	q result
}

}
