/// Description：识别词流程线表
/// Table：CT.WDT.CDSS.WordsLink
Class web.CDSS.CMKB.WordsLink Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Description:获得识别词线表
/// Table: CT.WDT.CDSS.WordsLink
/// Input:节点id WordsDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsLink","GetList","235")
Query GetList(WordsDR As %String) As %Query(ROWSPEC = "WordsDR,LinkRowId,FlowChartNum,PreNode,PreNodeNum,PreNodeType,PreNodeTypeDesc,NextNode,NextNodeNum,NextNodeType,NextNodeTypeDesc,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, WordsDR As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (WordsDR="") q ""
 
	s LinkRowId = ""
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsDRIndex",WordsDR,LinkRowId)) q:LinkRowId=""
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
		
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(WordsDR,LinkRowId,FlowChartNum,PreNode,PreNodeNum,PreNodeType,PreNodeTypeDesc,NextNode,NextNodeNum,NextNodeType,NextNodeTypeDesc,Remarks)
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
/// Table：CT.WDT.CDSS.WordsLink
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsLink).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.WordsLink) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		if (eobj.LinkRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.WordsLink).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.WordsLink).%OpenId(eobj.LinkRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.WordsLink).%New() 
			if $IsObject(obj.WordsDR)
			{
			 	s bobj.WordsDR = obj.WordsDR.%Id()
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
		}
		d:eobj.WordsDR'="" obj.WordsDRSetObjectId(eobj.WordsDR)
		s obj.FlowChartNum = eobj.FlowChartNum
		d:eobj.PreNode'="" obj.PreNodeSetObjectId(eobj.PreNode)
		d:eobj.PreNode="" obj.PreNodeSetObjectId("")
		d:eobj.NextNode'="" obj.NextNodeSetObjectId(eobj.NextNode)
		d:eobj.NextNode="" obj.NextNodeSetObjectId("")
		s obj.Remarks = eobj.Remarks
		
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
			d:eobj.LinkRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsLink","CT.WDT.CDSS.WordsLink","识别词流程线表",id,WordsDesc_","_eobj.FlowChartNum,"A",eobj)
			d:eobj.LinkRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsLink","CT.WDT.CDSS.WordsLink","识别词流程线表",eobj.LinkRowId,WordsDesc_","_eobj.FlowChartNum,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程线表","web.CDSS.CMKB.WordsLink","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程线表","web.CDSS.CMKB.WordsLink","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.WordsLink
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.WordsLink).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.WordsLink).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsLink).%New() 
	if $IsObject(obj.WordsDR)
	{
	 	s bobj.WordsDR = obj.WordsDR.%Id()
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
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.WordsLink
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.WordsLink).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.WordsLink).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsLink).%New() 
	if $IsObject(obj.WordsDR)
	{
	 	s bobj.WordsDR = obj.WordsDR.%Id()
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
	
	s sc=##class(CT.WDT.CDSS.WordsLink).%DeleteId(id)
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
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsLink","CT.WDT.CDSS.WordsLink","识别词流程线表",id,WordsDesc_","_bobj.FlowChartNum,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词流程线表","web.CDSS.CMKB.WordsLink","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:赵文伟
/// CreatDate:2023-02-14
/// Description:根据id判断识别词线数据是否存在
/// Table: CT.WDT.CDSS.WordsLink
/// Input: id
/// Return:0[不存在]，1[存在]
/// Other: w ##class(web.CDSS.CMKB.WordsLink).JustExistID("24")
ClassMethod JustExistID(id As %String) As %String
{
	s flag=0
	if (##class(CT.WDT.CDSS.WordsLink).%OpenId(id)){
		s flag=1
	} 
	q flag
}

}
