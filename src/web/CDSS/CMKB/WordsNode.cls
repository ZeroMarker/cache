/// Description：识别词流程节点表
/// Table：CT.WDT.CDSS.WordsNode
Class web.CDSS.CMKB.WordsNode Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Description:获得识别词节点
/// Table: CT.WDT.CDSS.WordsNode
/// Input:节点id WordsDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsNode","GetList","95044")
Query GetList(WordsDR As %String) As %Query(ROWSPEC = "WordsDR,NodeRowId,FlowChartNum,NodeNum,NodeType,NodeTypeDesc,MeetConditionNum,Remarks,ChartLeft,ChartTop")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, WordsDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (WordsDR="") q ""
 
	s NodeRowId = ""
	for
	{
		s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsDR,NodeRowId)) q:NodeRowId=""
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
		s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),9)
	
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(WordsDR,NodeRowId,FlowChartNum,NodeNum,NodeType,NodeTypeDesc,MeetConditionNum,Remarks,ChartLeft,ChartTop)
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
/// Table：CT.WDT.CDSS.WordsNode
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsNode).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.WordsNode) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		if (eobj.NodeRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.WordsNode).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(eobj.NodeRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.WordsNode).%New() 
			if $IsObject(obj.WordsDR)
			{
			 	s bobj.WordsDR = obj.WordsDR.%Id()
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
		}
		d:eobj.WordsDR'="" obj.WordsDRSetObjectId(eobj.WordsDR)
		s obj.FlowChartNum = eobj.FlowChartNum  
		s obj.NodeNum = eobj.NodeNum 
		d:eobj.NodeType'="" obj.NodeTypeSetObjectId(eobj.NodeType)
		d:eobj.NodeType="" obj.NodeTypeSetObjectId("")
		s obj.MeetConditionNum = eobj.MeetConditionNum
		s obj.Remarks = eobj.Remarks
		s obj.ChartLeft = eobj.ChartLeft
		s obj.ChartTop = eobj.ChartTop
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s WordsDesc=""
			if (eobj.WordsDR'="")
			{
				s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(eobj.WordsDR)),3)
			}
			
			d:eobj.NodeRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsNode","CT.WDT.CDSS.WordsNode","识别词流程节点表",id,WordsDesc_",图"_eobj.FlowChartNum_",节点"_eobj.NodeNum,"A",eobj)
			d:eobj.NodeRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsNode","CT.WDT.CDSS.WordsNode","识别词流程节点表",eobj.NodeRowId,WordsDesc_",图"_eobj.FlowChartNum_",节点"_eobj.NodeNum,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程节点表","web.CDSS.CMKB.WordsNode","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程节点表","web.CDSS.CMKB.WordsNode","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.WordsNode
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.WordsNode).OpenData("95020")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsNode).%New() 
	if $IsObject(obj.WordsDR)
	{
	 	s bobj.WordsDR = obj.WordsDR.%Id()
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
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.WordsNode
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.WordsNode).DeleteData("253729")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	//删除诊疗节点内容（触发条件类）
	s ConditionRowId=0
	for
	{
		s ConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",id,ConditionRowId)) q:ConditionRowId=""
		s result=##class(web.CDSS.CMKB.WordsCondition).DeleteData(ConditionRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'识别词节点内容（触发条件类）删除失败'}"  //返回错误信息
		}
	}
	
	//删除识别词流程线表上节点连线
	s PreLinkRowId=0
	for
	{
		s PreLinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("PreNodeIndex",id,PreLinkRowId)) q:PreLinkRowId=""
		s result=##class(web.CDSS.CMKB.WordsLink).DeleteData(PreLinkRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'识别词流程上节点连线删除失败'}"  //返回错误信息
		}
	}
	//删除识别词流程线表下节点连线
	s NextLinkRowId=0
	for
	{
		s NextLinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("NextNodeIndex",id,NextLinkRowId)) q:NextLinkRowId=""
		s result=##class(web.CDSS.CMKB.WordsLink).DeleteData(NextLinkRowId)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'识别词流程下节点连线删除失败'}"  //返回错误信息
		}
	}
	s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsNode).%New() 
	if $IsObject(obj.WordsDR)
	{
	 	s bobj.WordsDR = obj.WordsDR.%Id()
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
	
	s sc=##class(CT.WDT.CDSS.WordsNode).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s WordsDesc=""
		if (bobj.WordsDR'="")
		{
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(bobj.WordsDR)),3)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsNode","CT.WDT.CDSS.WordsNode","识别词流程节点表",id,WordsDesc_",图"_bobj.FlowChartNum_",节点"_bobj.NodeNum,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程节点表","web.CDSS.CMKB.WordsNode","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-26
/// Description：修改流程图顺序号
/// Table：CT.WDT.CDSS.WordsNode
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsNode).ChangeFlowChartNum()
ClassMethod ChangeFlowChartNum(NodeRowId, FlowChartNum) As %String
{
	if (NodeRowId="")||(FlowChartNum="")
	{
		s result="{success:'false',errorinfo:'数据项为空!'}" 
	}
	s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(NodeRowId)
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
/// Table：CT.WDT.CDSS.WordsNode
/// Input：NodeRowId
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsNode).getFlowChartNum()
ClassMethod getFlowChartNum(NodeRowId) As %String
{
	if (NodeRowId="") q ""
	s FlowChartNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
	q FlowChartNum
}

/// Creator：丁亚男
/// CreatDate: 2011-11-10
/// Description：修改节点需要满足的条件个数
/// Table：CT.WDT.CDSS.WordsNode
/// Input：NodeRowId
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsNode).UpMeetConditionNum(NodeRowId,MeetConditionNum)
ClassMethod UpMeetConditionNum(NodeRowId, MeetConditionNum) As %String
{
	if (NodeRowId="") q "false"
	s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(NodeRowId) 
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
/// CreatDate:2022-03-23
/// Description:获得当前识别词下所有流程节点，按流程顺序返回【已弃用，改为GetWordsJson()】
/// Table: CT.WDT.CDSS.WordsNode
/// Input: 识别词ID—WordsDR
/// Return:顺序返回流程节点
/// Other: w ##class(web.CDSS.CMKB.WordsNode).GetWordsListJson("92465")
ClassMethod GetWordsListJson(WordsDR As %String) As %String
{
	
	if (WordsDR="") q ""	
 	s store={}
 	s GlobalStr=""
 	s num=0
 	s GlobalStr=GlobalStr_"["
 	s NodeId=""
 	for{
	 	s NodeId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsDR,NodeId)) q:NodeId=""
 		s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeId)),3)
 		s flag=store.%Get(FlowChartNumT)
 		if (flag=""){
	 		d store.%Set(FlowChartNumT,FlowChartNumT)
	 		s num=num+1
			if num>1 s GlobalStr=GlobalStr_ ","
	 		s GlobalStr=GlobalStr_"["
	 		s count=0
			s NodeRowId = ""
			for
			{
				s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsChartIndex",WordsDR,FlowChartNumT,NodeRowId)) q:NodeRowId=""
				//s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsDR,NodeRowId)) q:NodeRowId=""
				s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
				s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),4)
				s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)
				s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),7)
				s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),8)
				s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),9)
			
				s count=count+1
				if count>1 s GlobalStr=GlobalStr_ ","
				s GlobalStr=GlobalStr_ "{""NodeRowId"":"""_NodeRowId_""""
				s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
				_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""""
				s GlobalStr=GlobalStr_ "}"
			}
			s LinkRowId = ""
			for
			{
				//s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsDRIndex",WordsDR,LinkRowId)) q:LinkRowId=""
				s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsFlowIndex",WordsDR,FlowChartNumT,LinkRowId)) q:LinkRowId=""
				s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),3)
				s PreNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),4)
				s PreNodeNum="",PreNodeType="",PreNodeTypeDesc=""
				if (PreNode'="")
				{
					s PreNodeNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(PreNode)),4)
					s PreNodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(PreNode)),5)
					s:PreNodeType'="" PreNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(PreNodeType)),3)
				} 
				s NextNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),5)
				s NextNodeNum="",NextNodeType="",NextNodeTypeDesc=""
				if (NextNode'="")
				{
					s NextNodeNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(NextNode)),4)
					s NextNodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NextNode)),5)
					s:NextNodeType'="" NextNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NextNodeType)),3)
				}
				s Remarks  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),7)
				s GlobalStr=GlobalStr_ ","
				s GlobalStr=GlobalStr_ "{""LinkRowId"":"""_LinkRowId_""""
				s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""PreNode"":"""_PreNode_""",""PreNodeNum"":"""_PreNodeNum_""",""PreNodeType"":"""_PreNodeType_""",""PreNodeTypeDesc"":"""_PreNodeTypeDesc
				_""",""NextNode"":"""_NextNode_""",""NextNodeNum"":"""_NextNodeNum_""",""NextNodeType"":"""_NextNodeType_""",""NextNodeTypeDesc"":"""_NextNodeTypeDesc_""""
				s GlobalStr=GlobalStr_"}"
			}
			s GlobalStr=GlobalStr_"]"
		}
	}
	
	//节点排序
	s GlobalStr=GlobalStr_"]"
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

/// Creator:guxueping
/// CreatDate:2022-07-27
/// Description: 检查识别词节点表，如果Link表中不存在，或者Link表中顺序号不一致，则是问题数据，导出查看
/// Table: CT.WDT.CDSS.IdentifyWords、CT.WDT.CDSS.WordsNode、CT.WDT.CDSS.WordsLink
/// Input: 
/// Return: D:/识别词拆分数据问题.csv
/// Other: d ##class(web.CDSS.CMKB.WordsNode).CheckWordsNode()
ClassMethod CheckWordsNode() As %String
{
	s Wfile=##class(%File).%New("D:/识别词拆分数据问题.csv")
	d Wfile.Open("NWS")
	
	k ^TEMPGXP("WordsNode")
	s WordsDR=""
	for
	{ 
		s WordsDR=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)) q:WordsDR="" 
		
		s FlowChartNum=""
		for
		{
			s FlowChartNum = $o(^CT.WDT.CDSS.WordsNodeI("WordsChartIndex",WordsDR,FlowChartNum)) q:FlowChartNum=""
			
		    s NodeDR= ""
			for
			{
				s NodeDR = $o(^CT.WDT.CDSS.WordsNodeI("WordsChartIndex",WordsDR,FlowChartNum,NodeDR)) q:NodeDR=""
				s flag=0
				s LinkRowId= ""
				for
				{
					s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsFlowIndex",WordsDR,FlowChartNum,LinkRowId)) q:LinkRowId=""
					s PreNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),4)
					s NextNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),5)
					if (PreNode=NodeDR)||(NextNode=NodeDR)
					{
						s flag=1
						q
					}
				}
				if (flag=0)
				{
					s ^TEMPGXP("WordsNode",WordsDR,NodeDR)=""
				}
			}
			

		}
	}
	
    s WordsDR=0
	for
	{
		s WordsDR = $o(^TEMPGXP("WordsNode",WordsDR)) q:WordsDR=""
		s WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)	
		s WordsType= $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),4)
		s WordsState = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),5)
		s str=""
	    s NodeDR=0
		for
		{
			s NodeDR = $o(^TEMPGXP("WordsNode",WordsDR,NodeDR)) q:NodeDR=""
			s:str'="" str=str_"^"
			s str=str_NodeDR
		}
		s str=WordsDR_","_WordsDesc_","_str_","_WordsType_","_WordsState
		d Wfile.WriteLine(str)   
	}
	d Wfile.%Save()
	d Wfile.%Close()
	k ^TEMPGXP("WordsNode")
	q "1"
}

/// Creator:赵文伟
/// CreatDate:2022-08-10
/// Description:获得当前识别词下所有流程数据，按流程顺序返回节点和线
/// Table: CT.WDT.CDSS.WordsNode，CT.WDT.CDSS.WordsLink
/// Input: 识别词Id：WordsDR
/// Return:按流程图顺序返回流程节点和线数据
/// Other: w ##class(web.CDSS.CMKB.WordsNode).GetWordsJson("13")
/// Other: w ##class(web.CDSS.CMKB.WordsNode).GetWordsJson("")
ClassMethod GetWordsJson(WordsDR As %String) As %String
{
	if (WordsDR="") q ""
	s GlobalStr=""
 	s count=0
 	s GlobalStr=GlobalStr_"["
	s StartNodeType=1	//开始
	s EndNodeType=2		//结束
	s NodeRowId=""
 	for{
	 	s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsDR,StartNodeType,NodeRowId)) q:NodeRowId=""	//开始节点
	 	s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
		s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),9)
			
		s count=count+1
		if count>1 s GlobalStr=GlobalStr_ ","
		s GlobalStr=GlobalStr_ "[{""NodeRowId"":"""_NodeRowId_""""
		s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
		_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""""
		s GlobalStr=GlobalStr_ "}"
	 	
		s NodeId=NodeRowId
		s GlobalStr=..GetFollowWordsJson(GlobalStr,WordsDR,NodeId)
				
 
 	}
 	s GlobalStr=GlobalStr_"]"
 	
 	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2022-08-10
/// Description:获得当前识别词下所有流程数据，按流程顺序返回节点和线【递归取开始节点后续节点】
/// Table: CT.WDT.CDSS.WordsNode，CT.WDT.CDSS.WordsLink
/// Input: 
/// Return:【按流程顺序返回开始节点的后续流程节点和线】
/// Other: w ##class(web.CDSS.CMKB.WordsNode).GetFollowWordsJson("","","")
/// Other: w ##class(web.CDSS.CMKB.WordsNode).GetFollowWordsJson("","","")
ClassMethod GetFollowWordsJson(GlobalStr As %String, WordsDR As %String, NodeId As %String) As %String
{
	s EndNodeType=2		//结束
	s LinkRowId = ""
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsPreNodeIndex",WordsDR,NodeId,LinkRowId)) q:LinkRowId=""
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),3)
		s PreNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),4)
		s PreNodeNum="",PreNodeType="",PreNodeTypeDesc=""
		if (PreNode'="")
		{
			s PreNodeNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(PreNode)),4)
			s PreNodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(PreNode)),5)
			s:PreNodeType'="" PreNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(PreNodeType)),3)
		} 
		s NextNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),5)
		s NextNodeNum="",NextNodeType="",NextNodeTypeDesc=""
		if (NextNode'="")
		{
			s NextNodeNum=$lg($g(^CT.WDT.CDSS.WordsNodeD(NextNode)),4)
			s NextNodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NextNode)),5)
			s:NextNodeType'="" NextNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NextNodeType)),3)
		}
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),7)
		s GlobalStr=GlobalStr_ ","
		s GlobalStr=GlobalStr_ "{""LinkRowId"":"""_LinkRowId_""""
		s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""PreNode"":"""_PreNode_""",""PreNodeNum"":"""_PreNodeNum_""",""PreNodeType"":"""_PreNodeType_""",""PreNodeTypeDesc"":"""_PreNodeTypeDesc
		_""",""NextNode"":"""_NextNode_""",""NextNodeNum"":"""_NextNodeNum_""",""NextNodeType"":"""_NextNodeType_""",""NextNodeTypeDesc"":"""_NextNodeTypeDesc_""""
		s GlobalStr=GlobalStr_"}"
		
		if (NextNode="") continue
		s NodeDR=NextNode
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),3)
		s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeDR)),3)
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),9)
			
		s GlobalStr=GlobalStr_ ","
		s GlobalStr=GlobalStr_ "{""NodeRowId"":"""_NodeDR_""""
		s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
		_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""""
		s GlobalStr=GlobalStr_ "}"
		
			 
		if (NodeType=EndNodeType){		//找到结束节点，取下一条流程
			s GlobalStr=GlobalStr_"]"
			
			q 
			
		} 
		else 	//取当前流程后续数据
		{
			
			s GlobalStr= ..GetFollowWordsJson(GlobalStr,WordsDR,NodeDR)
			
		}
		
	}
	
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2023-02-14
/// Description:根据id判断识别词节点数据是否存在
/// Table: CT.WDT.CDSS.WordsNode
/// Input: id
/// Return:0[不存在]，1[存在]
/// Other: w ##class(web.CDSS.CMKB.WordsNode).JustExistID("4222")
ClassMethod JustExistID(id As %String) As %String
{
	q:id="" 0
	s flag=0
	if ($d(^CT.WDT.CDSS.WordsNodeD(id))){
		s flag=1
	} 
	q flag
}

/// Creator:dingyanan
/// CreatDate:2023-03-16
/// Description:复制识别词流程图节点的方法
/// Table: CT.WDT.CDSS.WordsNode
/// Input: id--复制节点的id
/// Return:成功返回true及新节点的id，失败返回false
/// Other: w ##class(web.CDSS.CMKB.WordsNode).CopyNode(copyid,ChartLeft,ChartTop)
ClassMethod CopyNode(copyid As %String, ChartLeft As %String, ChartTop As %String, WordId As %String = "", NodeNum As %String = "") As %String
{
	s result=""
	if (copyid="")||('$d(^CT.WDT.CDSS.WordsNodeD(copyid)))
	{
		q "{success:'false',errorinfo:'节点不存在！'}"
	}
	//复制节点
	s obj=##class(CT.WDT.CDSS.WordsNode).%OpenId(copyid)
	s eobj = ##class(web.CDSSEntity.CMKB.WordsNode).%New() 
	if (WordId'="")
	{
		s eobj.WordsDR=WordId
	}
	else
	{
		if $IsObject(obj.WordsDR)
		{
		 	s eobj.WordsDR = obj.WordsDR.%Id()
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
	
	s noderesult=..SaveData(eobj)
	d eobj.%Close()
	if (noderesult["true")
	{
		s NewNodeId=$p(noderesult,"'",4)
		s ConditionPID=0
		for 
		{
			s ConditionPID=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",copyid,-100000000000000,ConditionPID)) q:(ConditionPID="")
			s eobjPCondition=##class(web.CDSSEntity.CMKB.WordsCondition).%New() 
			s eobjPCondition.NodeDR=NewNodeId
			s eobjPCondition.WordsItemDR=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),3)
			s eobjPCondition.ParentDR=""
			s eobjPCondition.Sequence = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),5)
			s eobjPCondition.ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),6)
			s eobjPCondition.ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),7)
			s eobjPCondition.ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),8)
			s eobjPCondition.ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),9)
			s eobjPCondition.ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),10)
			s eobjPCondition.Remarks  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionPID)),11)
			s PConditionresult=##class(web.CDSS.CMKB.WordsCondition).SaveData(eobjPCondition)
			d eobjPCondition.%Close()
			if (PConditionresult["true")
			{
				s NewPCondition=$p(PConditionresult,"'",4)
				s ConditionCID=0
				for 
				{
					s ConditionCID=$o(^CT.WDT.CDSS.WordsConditionI("ParentIndex",ConditionPID,ConditionCID)) q:(ConditionCID="")
					s eobjCCondition=##class(web.CDSSEntity.CMKB.WordsCondition).%New()
					s eobjCCondition.NodeDR=NewNodeId 
					s eobjCCondition.WordsItemDR=$lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),3)
					s eobjCCondition.ParentDR=NewPCondition
					s eobjCCondition.Sequence = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),5)
					s eobjCCondition.ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),6)
					s eobjCCondition.ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),7)
					s eobjCCondition.ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),8)
					s eobjCCondition.ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),9)
					s eobjCCondition.ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),10)
					s eobjCCondition.Remarks  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionCID)),11)
					s CConditionresult=##class(web.CDSS.CMKB.WordsCondition).SaveData(eobjCCondition)
					d eobjCCondition.%Close()
					if (CConditionresult'["true")
					{
						
						s result="{success:'false',errorinfo:'"_eobjCCondition.ConditionItemValue_"复制失败！'}"
					}
					
				}	
			}
			else
			{
				
				s result="{success:'false',errorinfo:'"_eobjPCondition.ConditionItemValue_"复制失败！'}"
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

}
