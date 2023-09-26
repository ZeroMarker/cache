/// Description：诊疗流程线表
/// Table：CT.WDT.CDSS.RuleLink
Class web.CDSS.CMKB.RuleLink Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-09-07
/// Description:获得规则线表
/// Table: CT.WDT.CDSS.RuleLink
/// Input:节点id RuleDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleLink","GetList","1624",14)
Query GetList(RuleDR As %String, TypeDR As %String) As %Query(ROWSPEC = "RuleDR,LinkRowId,FlowChartNum,PreNode,PreNodeNum,PreNodeType,PreNodeTypeDesc,NextNode,NextNodeNum,NextNodeType,NextNodeTypeDesc,Remarks,RuleTypeDR,ChartTypeDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RuleDR As %String, TypeDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (RuleDR="") q ""
 
	s LinkRowId = ""
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("RuleDRIndex",RuleDR,LinkRowId)) q:LinkRowId=""
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
		if (TypeDR=RuleTypeDR)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RuleDR,LinkRowId,FlowChartNum,PreNode,PreNodeNum,PreNodeType,PreNodeTypeDesc,NextNode,NextNodeNum,NextNodeType,NextNodeTypeDesc,Remarks,RuleTypeDR,ChartTypeDesc)
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
/// Table：CT.WDT.CDSS.RuleLink
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleLink).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleLink) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		if (eobj.FlowChartNum<="0"){
			s result = "{success:'false',errorinfo:'保存线数据流程顺序号不合法！'}"  
		}
		if (eobj.LinkRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleLink).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(eobj.LinkRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleLink).%New() 
			if $IsObject(obj.RuleDR)
			{
			 	s bobj.RuleDR = obj.RuleDR.%Id()
			}
			s bobj.FlowChartNum = obj.FlowChartNum
			if $IsObject(obj.PreNode)
			{
			 	s bobj.PreNode = obj.PreNode.%Id()
			}
			if $IsObject(obj.NextNode)
			{
			 	s bobj.NextNode = obj.NextNode.%Id()
			}
			s bobj.Remarks = obj.Remarks
			if $IsObject(obj.RuleTypeDR)
			{
			 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
			}
		}
		d:eobj.RuleDR'="" obj.RuleDRSetObjectId(eobj.RuleDR)
		d:eobj.RuleDR="" obj.RuleDRSetObjectId("")
		s obj.FlowChartNum = eobj.FlowChartNum
		d:eobj.PreNode'="" obj.PreNodeSetObjectId(eobj.PreNode)
		d:eobj.PreNode="" obj.PreNodeSetObjectId("")
		d:eobj.NextNode'="" obj.NextNodeSetObjectId(eobj.NextNode)
		d:eobj.NextNode="" obj.NextNodeSetObjectId("")
		s obj.Remarks = eobj.Remarks
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
			
			d:eobj.LinkRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleLink","CT.WDT.CDSS.RuleLink","诊疗流程线表",id,RuleDesc_",图"_eobj.FlowChartNum,"A",eobj)
			d:eobj.LinkRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleLink","CT.WDT.CDSS.RuleLink","诊疗流程线表",eobj.LinkRowId,RuleDesc_",图"_eobj.FlowChartNum,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程线表","web.CDSS.CMKB.RuleLink","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程线表","web.CDSS.CMKB.RuleLink","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleLink
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleLink).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleLink).%New() 
	if $IsObject(obj.RuleDR)
	{
	 	s bobj.RuleDR = obj.RuleDR.%Id()
	}
	s bobj.FlowChartNum = obj.FlowChartNum
	if $IsObject(obj.PreNode)
	{
	 	s bobj.PreNode = obj.PreNode.%Id()
	}
	if $IsObject(obj.NextNode)
	{
	 	s bobj.NextNode = obj.NextNode.%Id()
	}
	s bobj.Remarks = obj.Remarks
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
/// Table: CT.WDT.CDSS.RuleLink
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleLink).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleLink).%New() 
	if $IsObject(obj.RuleDR)
	{
	 	s bobj.RuleDR = obj.RuleDR.%Id()
	}
	s bobj.FlowChartNum = obj.FlowChartNum
	if $IsObject(obj.PreNode)
	{
	 	s bobj.PreNode = obj.PreNode.%Id()
	}
	if $IsObject(obj.NextNode)
	{
	 	s bobj.NextNode = obj.NextNode.%Id()
	}
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.RuleTypeDR)
	{
	 	s bobj.RuleTypeDR = obj.RuleTypeDR.%Id()
	}
	s sc=##class(CT.WDT.CDSS.RuleLink).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDesc=""
		s:bobj.RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(bobj.RuleDR)),3)
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleLink","CT.WDT.CDSS.RuleLink","诊疗流程线表",id,RuleDesc_",图"_bobj.FlowChartNum,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗流程线表","web.CDSS.CMKB.RuleLink","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：赵文伟
/// CreatDate: 2022-07-07
/// Description：规则流程图线表数据中流程顺序号为0的异常数据处理修复
/// Table： CT.WDT.CDSS.RuleLink
/// Input：
/// Return:
/// Other: d ##class(web.CDSS.CMKB.RuleLink).RepairData()
ClassMethod RepairData() As %String
{
	s count=0
	s LinkRowId=""
	for{ //取流程顺序号为0的数据
		s LinkRowId=$o(^CT.WDT.CDSS.RuleLinkI("FlowChartNumIndex",0,LinkRowId)) q:LinkRowId=""
		
		s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkRowId)
		s PreNode = obj.PreNode.%Id()
		s NextNode = obj.NextNode.%Id()
		if (PreNode'=""){
			s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),3)
			s obj.FlowChartNum=FlowChartNum
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s count=count+1
			}
		} elseif(NextNode'=""){
			s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),3)
			s obj.FlowChartNum=FlowChartNum
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s count=count+1
			}
		}
	}
	w "共处理"_count_"条数据！"
}

/// Creator:赵文伟
/// CreatDate:2023-02-14
/// Description:根据id判断规则线数据是否存在
/// Table: CT.WDT.CDSS.RuleLink
/// Input: id
/// Return:0[不存在]，1[存在]
/// Other: w ##class(web.CDSS.CMKB.RuleLink).JustExistID("324")
ClassMethod JustExistID(id As %String) As %String
{
	s flag=0
	if (##class(CT.WDT.CDSS.RuleLink).%OpenId(id)){
		s flag=1
	} 
	q flag
}

}
