/// Description: 诊疗规则流程类型关联节点类型
/// Creator: 高姗姗
/// Date: 2021-01-07
Class web.CDSS.CMKB.ChartNodeTypeCon Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2021-01-07
/// Description:根据诊疗规则流程类型获取节点类型
/// Table：CT.WDT.CDSS.ChartNodeTypeCon
/// Input：ChartTypeDR 流程类型dr
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ChartNodeTypeCon","GetList","1")
Query GetList(ChartTypeDR As %String) As %Query(ROWSPEC = "RowId,ChartTypeCode,ChartTypeDesc,NodeTypeDR,NodeTypeCode,NodeTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ChartTypeDR As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (ChartTypeDR'=""){
		s RowId=""
		for  
		{	
			s RowId=$o(^CT.WDT.CDSS.ChartNodeTypeConI("ChartTypeIndex",ChartTypeDR,RowId)) q:RowId=""
			
			s ChartTypeCode=$listGet($g(^CT.WDT.CDSS.ChartTypeD(ChartTypeDR)),2) //诊疗规则流程类型编码
			s ChartTypeDesc=$listGet($g(^CT.WDT.CDSS.ChartTypeD(ChartTypeDR)),3) //诊疗规则流程类型描述
			s NodeTypeCode="",NodeTypeDesc=""
			s NodeTypeDR=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),3)  //诊疗规则流程节点类型DR
			s:NodeTypeDR'="" NodeTypeCode = $listGet($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),2) //节点类型编码
			s:NodeTypeDR'="" NodeTypeDesc = $listGet($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3) //节点类型描述
			s UseFlag=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),4)  //使用标志（0在用，1停用）
			s UpdateUser=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),5)  //编辑人员
			s UpdateDate=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),6)  //编辑时间
			s Remarks=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),7)  //备注
			
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,ChartTypeCode,ChartTypeDesc,NodeTypeDR,NodeTypeCode,NodeTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2021-01-07
/// Description:获取诊疗规则流程类型列表
/// Table：CT.WDT.CDSS.ChartType
/// Input：desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ChartNodeTypeCon","GetChartList","")
Query GetChartList(desc As %String) As %Query(ROWSPEC = "RowId,ChartTypeCode,ChartTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetChartListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")

	s RowId=""
	for  
	{	
		s RowId=$o(^CT.WDT.CDSS.ChartTypeD(RowId)) q:RowId=""
		s ChartTypeCode=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),2)  //诊疗规则流程类型代码
		s ChartTypeDesc=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),3)  //诊疗规则流程类型描述
		s PINYIN=""
		s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ChartTypeDesc) 
		s UseFlag=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),4)  //使用标志（0在用，1停用）
		s UpdateUser=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),5)  //编辑人员
		s UpdateDate=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),6)  //编辑时间
		s Remarks=$listGet($g(^CT.WDT.CDSS.ChartTypeD(RowId)),7)  //备注
		
		i (($ZCONVERT(ChartTypeCode,"U")[desc)||($ZCONVERT(ChartTypeDesc,"U")[desc)||(PINYIN[desc)||(desc=""))  //条件
		{
			d OutputRowChart
        }	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowChart
    set Data=$lb(RowId,ChartTypeCode,ChartTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetChartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2021-01-07
/// Description:获取诊疗规则流程节点类型列表
/// Table：CT.WDT.CDSS.NodeType
/// Input：desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ChartNodeTypeCon","GetNodeList","")
Query GetNodeList(desc As %String) As %Query(ROWSPEC = "RowId,NodeTypeCode,NodeTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks")
{
}

ClassMethod GetNodeListExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")

	s RowId=""
	for  
	{	
		s RowId=$o(^CT.WDT.CDSS.NodeTypeD(RowId)) q:RowId=""
		s NodeTypeCode=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),2)  //节点类型代码
		s NodeTypeDesc=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),3)  //节点类型描述
		s PINYIN=""
		s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(NodeTypeDesc) 
		s UseFlag=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),4)  //使用标志（0在用，1停用）
		s UpdateUser=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),5)  //编辑人员
		s UpdateDate=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),6)  //编辑时间
		s Remarks=$listGet($g(^CT.WDT.CDSS.NodeTypeD(RowId)),7)  //备注
		
		i (($ZCONVERT(NodeTypeCode,"U")[desc)||($ZCONVERT(NodeTypeDesc,"U")[desc)||(PINYIN[desc)||(desc=""))  //条件
		{
			d OutputRowNode
        }	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowNode
    set Data=$lb(RowId,NodeTypeCode,NodeTypeDesc,UseFlag,UpdateUser,UpdateDate,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNodeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2021-01-08
/// Description:保存关联表
/// Table: CT.WDT.CDSS.ChartNodeTypeCon
/// Input: ChartTypeDR NodeTypeDR
/// others:w ##class(web.CDSS.CMKB.ChartNodeTypeCon).SaveData()
ClassMethod SaveData(ChartTypeDR, NodeTypeDR)
{
	if ($d(^CT.WDT.CDSS.ChartNodeTypeConI("ChartNodeTypeIndex",ChartTypeDR,NodeTypeDR))){
		q "{success:'false',info:'该类型已经存在'}"
	}
	s obj=##class(CT.WDT.CDSS.ChartNodeTypeCon).%New()
	d:ChartTypeDR'="" obj.ChartTypeDRSetObjectId(ChartTypeDR)
	d:ChartTypeDR="" obj.ChartTypeDRSetObjectId("")
	d:NodeTypeDR'="" obj.NodeTypeDRSetObjectId(NodeTypeDR)
	d:NodeTypeDR="" obj.NodeTypeDRSetObjectId("")
	s obj.UseFlag="0"
	s obj.UpdateUser=$Get(%session.Data("LOGON.USERNAME"))
	s obj.UpdateDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
	s obj.Remarks=""
	
	s NodeTypeDesc=""
	s:NodeTypeDR'="" NodeTypeDesc=$listGet($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3)
	s logJson="{ChartTypeDR:"""_ChartTypeDR_""",NodeTypeDR:"""_NodeTypeDR_""",UseFlag:"""_obj.UseFlag_""",UpdateUser:"""_obj.UpdateUser_""",UpdateDate:"""_obj.UpdateDate_""",Remarks:"""_obj.Remarks_"""}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.ChartNodeTypeCon","CT.WDT.CDSS.ChartNodeTypeCon","诊疗规则流程类型关联节点类型",id,NodeTypeDesc,"A",logJson)
	}
	else
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2021-01-08
/// Description:删除关联表
/// Table: CT.WDT.CDSS.ChartNodeTypeCon
/// Input:id
/// others:w ##class(web.CDSS.CMKB.ChartNodeTypeCon).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s obj=##class(CT.WDT.CDSS.ChartNodeTypeCon).%OpenId(id)	
	s blogJson="{ChartTypeDR:"""_obj.ChartTypeDR.%Id()_""",NodeTypeDR:"""_obj.NodeTypeDR.%Id()_""",UseFlag:"""_obj.UseFlag_""",UpdateUser:"""_obj.UpdateUser_""",UpdateDate:"""_obj.UpdateDate_""",Remarks:"""_obj.Remarks_"""}"
	
	s NodeTypeDesc=""
	s:obj.NodeTypeDR.%Id()'="" NodeTypeDesc=$listGet($g(^CT.WDT.CDSS.NodeTypeD(obj.NodeTypeDR.%Id())),3)
	
	Ts
	s sc=##class(CT.WDT.CDSS.ChartNodeTypeCon).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.ChartNodeTypeCon","CT.WDT.CDSS.ChartNodeTypeCon","诊疗规则流程类型关联节点类型",id,NodeTypeDesc,"D",blogJson)
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

ClassMethod KillGlobal()
{
	;w ##class(web.CDSS.CMKB.ChartNodeTypeCon).KillGlobal()
	k ^CT.WDT.CDSS.ChartTypeD
	k ^CT.WDT.CDSS.ChartTypeI
	k ^CT.WDT.CDSS.NodeTypeD
	k ^CT.WDT.CDSS.NodeTypeI
	k ^CT.WDT.CDSS.ChartNodeTypeConD
	k ^CT.WDT.CDSS.ChartNodeTypeConI
	
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-07
/// Description:导入诊疗规则流程类型数据
/// Table: CT.WDT.CDSS.ChartType
/// others:w ##class(web.CDSS.CMKB.ChartNodeTypeCon).ImportChartType()
ClassMethod ImportChartType()
{
	Ts
	s result="true"
	s file=##class(%File).%New("D:\诊疗规则流程类型.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s datastr=file.Read()   
		continue:datastr=""
		//诊疗规则流程类型代码 诊疗规则流程类型描述
		s ChartTypeCode=$p(datastr,",",1)
		continue:ChartTypeCode=""
		continue:ChartTypeCode="诊疗规则流程类型代码"
		continue:$d(^CT.WDT.CDSS.ChartTypeI("CodeIndex"," "_$ZCONVERT(ChartTypeCode,"U")))
		s ChartTypeDesc=$p(datastr,",",2)

		s obj=##class(CT.WDT.CDSS.ChartType).%New()
		s obj.ChartTypeCode=ChartTypeCode
		s obj.ChartTypeDesc=ChartTypeDesc
		s obj.UseFlag="0"
		s obj.UpdateUser="dhcc"
		s obj.UpdateDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.Remarks=""
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else{
			s result="false"
			Trollback
		}
	}
	if (result="true"){
		Tc	
	}else{
		Trollback	
	}
	
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-07
/// Description:导入诊疗规则流程节点类型
/// Table: CT.WDT.CDSS.NodeType
/// others:w ##class(web.CDSS.CMKB.ChartNodeTypeCon).ImportNodeType()
ClassMethod ImportNodeType()
{
	Ts
	s result="true"
	s file=##class(%File).%New("D:\诊疗规则流程节点类型.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s datastr=file.Read()   
		continue:datastr=""
		//诊疗规则节点类型代码 诊疗规则节点类型描述
		s NodeTypeCode=$p(datastr,",",1)
		continue:NodeTypeCode=""
		continue:NodeTypeCode="诊疗规则节点类型代码"
		continue:$d(^CT.WDT.CDSS.NodeTypeI("CodeIndex"," "_$ZCONVERT(NodeTypeCode,"U")))
		s NodeTypeDesc=$p(datastr,",",2)

		s obj=##class(CT.WDT.CDSS.NodeType).%New()
		s obj.NodeTypeCode=NodeTypeCode
		s obj.NodeTypeDesc=NodeTypeDesc
		s obj.UseFlag="0"
		s obj.UpdateUser="dhcc"
		s obj.UpdateDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.Remarks=""
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else{
			s result="false"
			Trollback
		}
	}
	if (result="true"){
		Tc	
	}else{
		Trollback	
	}
	
	q "ok"
}

/// Creator:高姗姗
/// CreatDate:2021-01-07
/// Description:导入规则流程类型关联节点类型
/// Table: CT.WDT.CDSS.ChartNodeTypeCon
/// others:w ##class(web.CDSS.CMKB.ChartNodeTypeCon).ImportChartNodeTypeCon()
ClassMethod ImportChartNodeTypeCon()
{
	Ts
	s result="true"
	s file=##class(%File).%New("D:\规则流程类型关联节点类型.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s datastr=file.Read()   
		continue:datastr=""
		//诊疗规则流程类型 诊疗规则节点类型
		s ChartTypeDesc=$p(datastr,",",1)
		continue:ChartTypeDesc=""
		continue:ChartTypeDesc="诊疗规则流程类型"
		s NodeTypeDesc=$p(datastr,",",2)
		
		s ChartTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_$ZCONVERT(ChartTypeDesc,"U"),""))
		s NodeTypeDR=$o(^CT.WDT.CDSS.NodeTypeI("DescIndex"," "_$ZCONVERT(NodeTypeDesc,"U"),""))
		continue:$d(^CT.WDT.CDSS.ChartNodeTypeConI("ChartNodeTypeIndex",ChartTypeDR,NodeTypeDR))

		s obj=##class(CT.WDT.CDSS.ChartNodeTypeCon).%New()
		d:ChartTypeDR'="" obj.ChartTypeDRSetObjectId(ChartTypeDR)
		d:ChartTypeDR="" obj.ChartTypeDRSetObjectId("")
		d:NodeTypeDR'="" obj.NodeTypeDRSetObjectId(NodeTypeDR)
		d:NodeTypeDR="" obj.NodeTypeDRSetObjectId("")
		s obj.UseFlag="0"
		s obj.UpdateUser="dhcc"
		s obj.UpdateDate=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.Remarks=""
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else{
			s result="false"
			Trollback
		}
	}
	if (result="true"){
		Tc	
	}else{
		Trollback	
	}
	
	q "ok"
}

/// Creator：石萧伟
/// CreatDate: 2021-04-23
/// Description:根据诊疗规则流程类型获取节点类型（出去开始和结束）
/// Table：CT.WDT.CDSS.ChartNodeTypeCon
/// Input：ChartTypeDR 流程类型dr
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.ChartNodeTypeCon","GetType","1")
Query GetType(ChartTypeDR As %String, ruleType As %String) As %Query(ROWSPEC = "RowId,ChartTypeCode,ChartTypeDesc,NodeTypeDR,NodeTypeCode,NodeTypeDesc")
{
}

ClassMethod GetTypeExecute(ByRef qHandle As %Binary, ChartTypeDR As %String, ruleType As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (ChartTypeDR'=""){
		s RowId=""
		for  
		{	
			s RowId=$o(^CT.WDT.CDSS.ChartNodeTypeConI("ChartTypeIndex",ChartTypeDR,RowId)) q:RowId=""
			
			s ChartTypeCode=$listGet($g(^CT.WDT.CDSS.ChartTypeD(ChartTypeDR)),2) //诊疗规则流程类型编码
			s ChartTypeDesc=$listGet($g(^CT.WDT.CDSS.ChartTypeD(ChartTypeDR)),3) //诊疗规则流程类型描述
			s NodeTypeCode="",NodeTypeDesc=""
			s NodeTypeDR=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),3)  //诊疗规则流程节点类型DR
			s:NodeTypeDR'="" NodeTypeCode = $listGet($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),2) //节点类型编码
			s:NodeTypeDR'="" NodeTypeDesc = $listGet($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3) //节点类型描述
			;s UseFlag=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),4)  //使用标志（0在用，1停用）
			;s UpdateUser=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),5)  //编辑人员
			;s UpdateDate=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),6)  //编辑时间
			;s Remarks=$listGet($g(^CT.WDT.CDSS.ChartNodeTypeConD(RowId)),7)  //备注
			if ((NodeTypeDesc'="开始") & (NodeTypeDesc'="结束")){
				if ((ChartTypeDR=1)&(ruleType="")){
					if ((NodeTypeDesc'="推荐评估表")&(NodeTypeDesc'="推荐护理措施")&(NodeTypeDesc'="推荐检验/检查")&(NodeTypeDesc'="推荐鉴别诊断"))
					{
						d OutputRow
					}
				}
				
				elseif ((ChartTypeDR'=1))
				{
					d OutputRow
				}
				else{
					if ((NodeTypeDesc="诊断条件")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="否定条件-诊断")||(NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc=ruleType))
					{
						d OutputRow
					}
				}
				
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,ChartTypeCode,ChartTypeDesc,NodeTypeDR,NodeTypeCode,NodeTypeDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
