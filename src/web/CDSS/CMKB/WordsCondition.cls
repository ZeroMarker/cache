/// Description：识别词节点内容表（触发条件类）
/// Table：CT.WDT.CDSS.WordsCondition
Class web.CDSS.CMKB.WordsCondition Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-26
/// Description：树形节点内容
/// Input：上级节点
/// Return:成功返回树形节点内容
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).GetTreeJson("53")
/// w ##class(web.CDSS.CMKB.WordsCondition).GetTreeJson("344948","")
ClassMethod GetTreeJson(NodeDR As %String, id As %String = "") As %String
{
	if NodeDR="" q:"[]"
	s IDStr=""
	s parentdr=id
	if (parentdr="") s parentdr=-100000000000000
	s myJsonStr=""
	
	//输出树形JSON串
	s childStr=""
	w "["
	s count=0
	s myRowID=0
	for {
		s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeDR,parentdr,myRowID)) q:(myRowID="")
		
		s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
		s WordsItemDRN=""
		s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
		s ParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),4)
		s ParentDRN=""
		s:ParentDR'="" ParentDRN= $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),9)
		s Sequence  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),5)
		s ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),6)
		s ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),7)
		s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),8)
		s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)
		s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),10)
		s ConditionItemValUnitN=""
		s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),11)
		
		
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""WordsItemDR"":"""_WordsItemDR_""",""WordsItemDRN"":"""_WordsItemDRN_""",""ParentDR"":"""_ParentDR_""",""ParentDRN"":"""_ParentDRN_""",""Sequence"":"""_Sequence
		_""",""ConditionClass"":"""_ConditionClass_""",""ConditionItem"":"""_ConditionItem_""",""ConditionItemCalculate"":"""_ConditionItemCalculate
		_""",""ConditionItemValue"":"""_ConditionItemValue_""",""ConditionItemValUnit"":"""_ConditionItemValUnit_""",""ConditionItemValUnitN"":"""_ConditionItemValUnitN_""",""Remarks"":"""_Remarks_""""
		
		if $d(^CT.WDT.CDSS.WordsConditionI("ParentIndex",myRowID))
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeJson(NodeDR,myRowID)	
		}
		else
		{
			w ",""state"":""open"""
			
		}
		w "}"
	}
	
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.WordsCondition
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsCondition","GetList","235","")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,ConditionRowId,WordsItemDR,WordsItemDRN,ParentDR,ParentDRN,Sequence,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,ConditionItemValUnitN,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (NodeDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s ConditionRowId = ""
	for
	{
		s ConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,ConditionRowId),-1) q:ConditionRowId=""
		s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),3)
		s WordsItemDRN=""
		s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
		s ParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),4)
		s ParentDRN=""
		s:ParentDR'="" ParentDRN= $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),9)
		s Sequence  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),5)
		s ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),6)
		s ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),7)
		s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),8)
		s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),9)
		s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),10)
		s ConditionItemValUnitN=""
		s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
		s Remarks  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),11)
		continue:($ZCONVERT(ConditionItemValue,"U")'[desc)
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,ConditionRowId,WordsItemDR,WordsItemDRN,ParentDR,ParentDRN,Sequence,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,ConditionItemValUnitN,Remarks)
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
/// Table：CT.WDT.CDSS.WordsCondition
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.WordsCondition).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.WordsCondition) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		
		if (eobj.ConditionRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.WordsCondition).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.WordsCondition).%OpenId(eobj.ConditionRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.WordsCondition).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			if $IsObject(obj.WordsItemDR)
			{
			 	s bobj.WordsItemDR = obj.WordsItemDR.%Id()
			}
			if $IsObject(obj.ParentDR)
			{
			 	s bobj.ParentDR = obj.ParentDR.%Id()
			}
			s bobj.Sequence = obj.Sequence
			s bobj.ConditionClass = obj.ConditionClass  
			s bobj.ConditionItem = obj.ConditionItem 
			s bobj.ConditionItemValue = obj.ConditionItemValue 
			s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
			/*if $IsObject(obj.ConditionItemValUnit)
			{
			 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
			}*/
			s bobj.ConditionItemValUnit = obj.ConditionItemValUnit
			s bobj.Remarks = obj.Remarks
			
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		d:eobj.WordsItemDR'="" obj.WordsItemDRSetObjectId(eobj.WordsItemDR)
		d:eobj.ParentDR'="" obj.ParentDRSetObjectId(eobj.ParentDR)
		s obj.Sequence = eobj.Sequence 
		s obj.ConditionClass = eobj.ConditionClass  
		s obj.ConditionItem = eobj.ConditionItem 
		s obj.ConditionItemValue = eobj.ConditionItemValue 
		s obj.ConditionItemCalculate = eobj.ConditionItemCalculate
		s obj.ConditionItemValUnit = eobj.ConditionItemValUnit
		//d:eobj.ConditionItemValUnit'="" obj.ConditionItemValUnitSetObjectId(eobj.ConditionItemValUnit)
		
		if (eobj.ConditionClass="年龄")
		{
			s ValUnit=""
			s:eobj.ConditionItemValUnit'="" ValUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(eobj.ConditionItemValUnit)),3)
			s obj.Remarks = ##class(web.CDSS.CMKB.FunLib).TransforDateFormat(eobj.ConditionItemValue,ValUnit)	
		}
		else
		{
			s obj.Remarks = eobj.Remarks	
		}
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s WordsDR="",NodeNum="",WordsDesc=""
			s:eobj.NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$lg($g(^CT.WDT.CDSS.WordsNodeD(eobj.NodeDR)),4)
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			d:eobj.ConditionRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsCondition","CT.WDT.CDSS.WordsCondition","识别词节点内容表（触发条件类）",id,WordsDesc_","_NodeNum_","_eobj.ConditionClass,"A",eobj)
			d:eobj.ConditionRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsCondition","CT.WDT.CDSS.WordsCondition","识别词节点内容表（触发条件类）",eobj.ConditionRowId,WordsDesc_","_NodeNum_","_eobj.ConditionClass,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词节点内容表（触发条件类）","web.CDSS.CMKB.WordsCondition","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词节点内容表（触发条件类）","web.CDSS.CMKB.WordsCondition","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.WordsCondition
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.WordsCondition).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.WordsCondition).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsCondition).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	if $IsObject(obj.WordsItemDR)
	{
	 	s bobj.WordsItemDR = obj.WordsItemDR.%Id()
	}
	if $IsObject(obj.ParentDR)
	{
	 	s bobj.ParentDR = obj.ParentDR.%Id()
	}
	s bobj.Sequence = obj.Sequence
	s bobj.ConditionClass = obj.ConditionClass  
	s bobj.ConditionItem = obj.ConditionItem 
	s bobj.ConditionItemValue = obj.ConditionItemValue 
	s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
	/*if $IsObject(obj.ConditionItemValUnit)
	{
	 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
	}*/
	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit

	s bobj.Remarks = obj.Remarks
	
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.WordsCondition
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.WordsCondition).DeleteData("173478")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	//判断是否有子节点，先删除子节点
	if $d(^CT.WDT.CDSS.WordsConditionI("ParentIndex",id))
	{
		
		s myRowID=0
		for 
		{
			s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("ParentIndex",id,myRowID)) q:(myRowID="")
			d ..DeleteData(myRowID)
		}
	}
	s obj=##class(CT.WDT.CDSS.WordsCondition).%OpenId(id)
	d ..DelTmpGlobal(obj)
	s bobj = ##class(web.CDSSEntity.CMKB.WordsCondition).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	if $IsObject(obj.WordsItemDR)
	{
	 	s bobj.WordsItemDR = obj.WordsItemDR.%Id()
	}
	if $IsObject(obj.ParentDR)
	{
	 	s bobj.ParentDR = obj.ParentDR.%Id()
	}
	s bobj.Sequence = obj.Sequence
	s bobj.ConditionClass = obj.ConditionClass  
	s bobj.ConditionItem = obj.ConditionItem 
	s bobj.ConditionItemValue = obj.ConditionItemValue 
	s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
	/*if $IsObject(obj.ConditionItemValUnit)
	{
	 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
	}*/
	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit

	s bobj.Remarks = obj.Remarks
	
	
	s sc=##class(CT.WDT.CDSS.WordsCondition).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s WordsDR="",NodeNum="",WordsDesc=""
		s:bobj.NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(bobj.NodeDR)),2)
		s:bobj.NodeDR'="" NodeNum="节点"_$lg($g(^CT.WDT.CDSS.WordsNodeD(bobj.NodeDR)),4)
		s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsCondition","CT.WDT.CDSS.WordsCondition","识别词节点内容表（触发条件类）",id,WordsDesc_","_NodeNum_","_bobj.ConditionClass,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词节点内容表（触发条件类）","web.CDSS.CMKB.WordsCondition","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// 删除导入excel时候的去重临时global
ClassMethod DelTmpGlobal(obj As CT.WDT.CDSS.WordsCondition) As %String
{
	if obj.ParentDR'=""
	{
		
		s ParentId=obj.ParentDR.%Id()
		s ItemName = $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentId)),9)
	}
	else
	{
		q ""
	}
	if obj.ConditionItemCalculate["&&"
	{
		s MinItemValue = $p(obj.ConditionItemValue,"&&",1)
		s MaxItemValue = $p(obj.ConditionItemValue,"&&",2)
		s MinContain=$p(obj.ConditionItemCalculate,"&&",1)
		s MaxContain=$p(obj.ConditionItemCalculate,"&&",2)
		s MinItemValUnit=$p(obj.ConditionItemValUnit,"&&",1)
		s MaxItemValUnit=$p(obj.ConditionItemValUnit,"&&",2)
		s RepeatStr=obj.WordsItemDR.%Id()_","_obj.NodeDR.%Id()_","_ItemName_","_MinItemValue_"&&"_MaxItemValue_","_MinContain_"&&"_MaxContain_","_MinItemValUnit_"&&"_MaxItemValUnit
	}
	else
	{
		s ItemValue = obj.ConditionItemValue
		s RepeatStr=obj.WordsItemDR.%Id()_","_obj.NodeDR.%Id()_","_ItemName_","_ItemValue_",=,"
	}
	s ^TMP("ldy",RepeatStr)=""
	k ^TMPIVR("SaveWordsCondition",RepeatStr)
	q ""
}

/// 删除数据下的子节点
ClassMethod DeleteChildData(id As %String)
{
	//判断是否有子节点，有则删除
	if $d(^CT.WDT.CDSS.WordsConditionI("ParentIndex",id))
	{
		
		s myRowID=0
		for 
		{
			s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("ParentIndex",id,myRowID)) q:(myRowID="")
			d ##class(CT.WDT.CDSS.WordsCondition).%DeleteId(myRowID)
		}
	}
	q ""
}

/// Creator:丁亚男
/// CreatDate:2021-11-18
/// Input：Type:类型(取自识别词项目字典表项目描述，其中既往诊断名称传诊断名称、既往手术名称传手术名称) NewName字典修改后的名称 OldName字典修改前的名称
/// Description:字典同步修改名称
/// Return:count 修改成功了几处，修改失败几处
/// w ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断症状名称","慢性重度丙型病毒性肝炎1","慢性重度丙型病毒性肝炎")
ClassMethod SynchroDictWord(Type As %String, NewName As %String, OldName As %String) As %String
{
	q:(Type="")||(NewName="")||(OldName="") ""
	q:NewName=OldName ""
	
	s count=0,fcount=0
	s ConditionRowID=0
	for 
	{
		s ConditionRowID=$o(^CT.WDT.CDSS.WordsConditionI("ItemValueIndex",OldName,ConditionRowID)) q:(ConditionRowID="")
		s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),3)
		s WordsItemDRN=""
		s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
		s:WordsItemDRN="既往诊断名称" WordsItemDRN="诊断名称"
		s:WordsItemDRN="诊断症状名称" WordsItemDRN="诊断名称"
		s:WordsItemDRN="既往手术名称" WordsItemDRN="手术名称"
		s:WordsItemDRN="每日频率" WordsItemDRN="频率"
		s:WordsItemDRN="科室名称" WordsItemDRN="会诊科室"
		
		s:WordsItemDRN="中医既往诊断名称" WordsItemDRN="中医诊断名称"
		s:WordsItemDRN="中医诊断症状名称" WordsItemDRN="中医诊断名称"
		
		if (WordsItemDRN=Type)
		{
			s obj=##class(CT.WDT.CDSS.WordsCondition).%OpenId(ConditionRowID)
			s obj.ConditionItemValue = NewName
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s count=count+1		
			}
			else
			{
				s fcount=fcount+1		
			}	
		}
			
	}
	s result = ""
	try
	{
		s result=##class(web.CDSS.CMKB.RuleTrigger).SynchroDictWord(Type,NewName,OldName)
	}
	catch e
	{
		s result=""
	}
    q "2.0规则修改结果:成功修改"_count_"处！失败"_fcount_"处！"_" 1.0规则修改结果:"_result
}

/// Creator:丁亚男
/// CreatDate:2021-11-18
/// Description:删除限制
/// Input:Type:类型(取自识别词项目字典表项目描述，其中既往诊断名称传诊断名称、既往手术名称传手术名称) Name字典表数据名称
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("检验项目名称","尿蛋白定量")
ClassMethod GetRefFlag(Type As %String, Name As %String) As %String
{
    s return="",myInfo=""
    
    if ($d(^CT.WDT.CDSS.WordsConditionI("ItemValueIndex",Name)))
    {
	    s ConditionRowID=0
		for 
		{
			s ConditionRowID=$o(^CT.WDT.CDSS.WordsConditionI("ItemValueIndex",Name,ConditionRowID)) q:(ConditionRowID="")
			s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),3)
			s WordsItemDRN=""
			s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
			s WordsItemType=WordsItemDRN
			s:WordsItemType="既往诊断名称" WordsItemType="诊断名称"
			s:WordsItemType="既往手术名称" WordsItemType="手术名称"
			s:WordsItemType="每日频率" WordsItemType="频率"
			
           	if (WordsItemType=Type)
			{
	            s NodeDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),2)
	            s WordsDR="",NodeTypeDR="",WordsDesc="",NodeTypeDesc=""
	            s:NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),2)
	            s:NodeDR'="" NodeTypeDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
	            s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
	            s:NodeTypeDR'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3)
	            s flag=1
	            s myInfo=myInfo_"<识别词规则:"_WordsDesc_"-"_NodeTypeDesc_"-"_WordsItemDRN_">"  
			}
	    }
    }
   
    q myInfo
}

/// Creator:赵文伟
/// CreatDate:2022-03-10
/// Description：检索树形节点内容【根据项目名称或属性名称匹配检索】
/// Input：流程图节点、项目名称或属性名称
/// Return: 成功返回树形节点内容
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).EnterGetCurrentTreeJson("262119","头痛")
///       w ##class(web.CDSS.CMKB.WordsCondition).EnterGetCurrentTreeJson("111963","多胎妊娠")
ClassMethod EnterGetCurrentTreeJson(NodeDR As %String, ItemValue As %String) As %String
{
	if (NodeDR=""||ItemValue="") q:"参数不能为空！"
	s ItemValue=$ZCONVERT(ItemValue,"U")
	s RowID=0
	s CorrectNode={}
	w "["
	s count=0
	for {		//遍历匹配
		s RowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,RowID)) q:RowID=""
		s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(RowID)),9)
		if ($ZCONVERT(ConditionItemValue,"U")[ItemValue)					//数据存在
		{
			s count=count+1
			s NowParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(RowID)),4) 	//父节点
			
			if (NowParentDR'="") //子节点
			{   
				//子节点——>父节点
				//s ChildRowID=""
				//s ChildRowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeItemParentIndex",NodeDR,ConditionItemValue,NowParentDR,ChildRowID)) q:(ChildRowID="")
				//s ChildParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ChildRowID)),4)
				//s RowID=ChildParentDR
				s flag=CorrectNode.%Get(NowParentDR)
				if (flag="")
				{
					w ..GetCurrentTreeJson(NodeDR,NowParentDR,count)
					d CorrectNode.%Set(NowParentDR,NowParentDR)
					
				}		
			} 
			else //父节点为空，自身为父节点
			{						
				s flag=CorrectNode.%Get(RowID)
				if (flag="")
				{
					
					w ..GetCurrentTreeJson(NodeDR,RowID,count)
					d CorrectNode.%Set(RowID,RowID)
				}	
			}
		}
	}
	w "]"
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-03-07
/// Description：树形节点内容【根据项目名称或属性名称检索】
/// Input：流程图节点、项目名称或属性名称
/// Return: 成功返回树形节点内容
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).GetCurrentTreeJson("262119","消失","")
ClassMethod GetCurrentTreeJson(NodeDR As %String, RowID As %String, count) As %String
{
	
	//输出树形JSON串
	s myRowID=RowID
	s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
	s WordsItemDRN=""
	s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
		
	s ParentDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),4)
	s ParentDRN=""
	s:ParentDR'="" ParentDRN= $lg($g(^CT.WDT.CDSS.WordsConditionD(ParentDR)),9)	//父节点名称
	s Sequence  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),5)
	s ConditionClass  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),6)
	s ConditionItem  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),7)
	s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),8)
	s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)		//项目名称/属性内容
	s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),10)
	s ConditionItemValUnitN=""
	s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
	s Remarks  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),11)
	
		
	if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""WordsItemDR"":"""_WordsItemDR_""",""WordsItemDRN"":"""_WordsItemDRN_""",""ParentDR"":"""_ParentDR_""",""ParentDRN"":"""_ParentDRN_""",""Sequence"":"""_Sequence
		_""",""ConditionClass"":"""_ConditionClass_""",""ConditionItem"":"""_ConditionItem_""",""ConditionItemCalculate"":"""_ConditionItemCalculate
		_""",""ConditionItemValue"":"""_ConditionItemValue_""",""ConditionItemValUnit"":"""_ConditionItemValUnit_""",""ConditionItemValUnitN"":"""_ConditionItemValUnitN_""",""Remarks"":"""_Remarks_""""
		
		if $d(^CT.WDT.CDSS.WordsConditionI("ParentIndex",myRowID))
		{	
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeJson(NodeDR,myRowID)	
		} 
		else
		{
			w ",""state"":""open"""	
		}
		w "}"
		
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-03-14
/// Description：按条件返回流程图节点和线表数据【被HandleGetNodeLineJson()调用】
/// Input：识别词ID、识别词节点内容[项目名称或属性名称]、类型ID
/// Return: 返回流程图节点和线表数据
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).GetNodeLineJson("95063","休克","6")
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).GetNodeLineJson("5","血细胞分析","6")
ClassMethod GetNodeLineJson(WordsDR As %String, ItemValue As %String, NodeTypeId As %String) As %String
{
	s count=0
	s NodeDR=""
	s GlobalStr=""
	s GlobalStr=GlobalStr_"["
	for {		
		s NodeDR = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsDR,NodeTypeId,NodeDR)) q:NodeDR=""
		//遍历匹配
		s RowID=""
		for {
			s RowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,RowID)) q:RowID=""
			s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(RowID)),9)
			if ($ZCONVERT(ConditionItemValue,"U")[ItemValue)
			{
				s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),3)
				s count=count+1
				if count>1 s GlobalStr=GlobalStr_","
				s GlobalStr=GlobalStr_"["
				//取节点数据
				s countN=0
				s NodeRowId = ""
				for
				{
					s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsChartIndex",WordsDR,FlowChartNumT,NodeRowId)) q:NodeRowId=""
					s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
					s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),4)
					s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)
					s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),7)
					s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),8)
					s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),9)
					s countN=countN+1
						if countN>1 s GlobalStr=GlobalStr_ ","
						
						s GlobalStr=GlobalStr_ "{""NodeRowId"":"""_NodeRowId_""""
						s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
						_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""""
						s GlobalStr=GlobalStr_"}"
								
				}
				//取线表数据
				s LinkRowId = ""
				for
				{
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
	}
	s GlobalStr=GlobalStr_"]"
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2022-03-16
/// Description：按条件返回流程图节点和线表数据 [顺序处理]【旧版，已弃用,改为GetNodeLineJsonNew()】
/// Input：识别词ID、识别词节点内容[项目名称或属性名称]、类型ID
/// Return: 返回流程图节点和线表数据 返回顺序[{开始节点-》内容节点-》线节点-》结束节点}，{}]
/// Other:d ##class(web.CDSS.CMKB.WordsCondition).HandleGetNodeLineJson("107057","脑炎","6")
/// Other:d ##class(web.CDSS.CMKB.WordsCondition).HandleGetNodeLineJson("5","血细胞分析","6")
ClassMethod HandleGetNodeLineJson(WordsDR As %String, ItemValue As %String, NodeTypeId As %String) As %String
{
	s RawData= ..GetNodeLineJson(WordsDR,ItemValue,NodeTypeId)
	s array=##class(%DynamicAbstractObject).%FromJSON(RawData)

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
				elseif (item.NodeType="2")
				{
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
	w result.%ToJSON()
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-08-11
/// Description：按条件返回流程图节点和线表数据
/// Input：识别词ID、识别词节点内容【项目名称或属性名称】、类型ID
/// Return: 返回流程图节点和线表数据
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).GetNodeLineJsonNew("107057","脑炎","6")
ClassMethod GetNodeLineJsonNew(WordsDR As %String, ItemValue As %String, NodeTypeId As %String) As %String
{
	s count=0
	s GlobalStr=""
	s startNodeType=1
	s FlowChartNumTemp ={}
	s GlobalStr=GlobalStr_"["
	s NodeDR=""
	for {		
		s NodeDR = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsDR,NodeTypeId,NodeDR)) q:NodeDR=""
		//遍历匹配
		s RowID=""
		for {
			s RowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,RowID)) q:RowID=""
			s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(RowID)),9)
			if ($ZCONVERT(ConditionItemValue,"U")[ItemValue)
			{
				s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),3)
				s flagF=FlowChartNumTemp.%Get(FlowChartNumT)	//如果该值不存在，则返回空字符串
				if (flagF=""){			//防止同一流程图内多个节点内容匹配导致重复返回流程图
					d FlowChartNumTemp.%Set(FlowChartNumT,FlowChartNumT)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					//s GlobalStr=GlobalStr_"["
					//取节点数据
					s countN=0
					s NodeRowId = ""
					//1、先取符合条件的流程图的开始节点
					for
					{
						s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRTypeIndex",WordsDR,FlowChartNumT,startNodeType,NodeRowId)) q:NodeRowId=""
						s FlowChartNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),3)
						s NodeNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),4)
						s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),5)
						s NodeTypeDesc=""
						s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
						s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),6)
						s Remarks  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),7)
						s ChartLeft  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),8)
						s ChartTop  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeRowId)),9)
						s countN=countN+1
							if countN>1 s GlobalStr=GlobalStr_ ","
							
							s GlobalStr=GlobalStr_ "[{""NodeRowId"":"""_NodeRowId_""""
							s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
							_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""""
							s GlobalStr=GlobalStr_"}"
							
						//2、再按顺序取开始节点的所有后续节点
						s NodeId=NodeRowId
						//s GlobalStr=..GetFollowWordsJson(GlobalStr,WordsDR,NodeId)	
						s GlobalStr=##class(web.CDSS.CMKB.WordsNode).GetFollowWordsJson(GlobalStr,WordsDR,NodeId)	
					}	
					
				}
				
			}
		}
	}
	s GlobalStr=GlobalStr_"]"
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2023-01-15
/// Description:单位删除限制
/// Input:单位字典表数据id
/// Return:引用信息
/// w ##class(web.CDSS.CMKB.WordsCondition).GetUnitRefFlag("单位","32")
ClassMethod GetUnitRefFlag(type As %String, id As %String) As %String
{
    s return="",myInfo=""
    if type'="单位" q "参数错误！"
    s count=0
    s ConditionRowID=""
	for 
	{
		s ConditionRowID=$o(^CT.WDT.CDSS.WordsConditionD(ConditionRowID),-1) q:ConditionRowID=""
		
		if (count>20) {
		   s myInfo=myInfo_"..."
		   q
		}
		s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),10)
		continue:ConditionItemValUnit=""	//过滤空值
		
		
		s len=$l(ConditionItemValUnit,"&&")   
       	for j=1:1:len 
        {
			s unitDR=$p(ConditionItemValUnit,"&&",j)
			continue:unitDR=""
			if (unitDR=id){
				
				s NodeDR = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),2)
	            s WordsDR="",NodeTypeDR="",WordsDesc="",NodeTypeDesc=""
	            s:NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),2)
	            s:NodeDR'="" NodeTypeDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
	            s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
	            s:NodeTypeDR'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3)
	            s count=count+1
	            
	            s myInfo=myInfo_"<识别词规则:"_WordsDesc_"-"_NodeTypeDesc_">" 
			}
      }

	}
    q myInfo
}

/// Creator:丁亚男
/// CreatDate:2023-03-30
/// Description：按照给定表格的数据导出诊断条件的内容重复的识别词
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.WordsCondition).ExportRepeatDiagIWContent()
ClassMethod ExportRepeatDiagIWContent()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	//导出数据	
	s ExPath=##class(%File).GetDirectory()
	s ExDisk=$p(ExPath,":",1)
	s ExPathDir=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(ExPathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s ExP=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\诊断条件识别词拆分重复数据导出.csv"
	s Exfile=##class(%File).%New(ExP)
	s Exfilename = "诊断条件识别词拆分重复数据导出.csv"
	d Exfile.Open("NWS")
	d Exfile.Write("识别词id,"_"识别词名称,"_"项目名称,"_"拆分内容")
	d Exfile.WriteLine()
	
	s Value=0
	for 
	{
		s Value=$o(^CT.WDT.CDSS.WordsConditionI("ItemDRConditionIndex",4,Value)) q:Value=""
		s ConditionRowID=0,count=0
		for 
		{
			s ConditionRowID=$o(^CT.WDT.CDSS.WordsConditionI("ItemDRConditionIndex",4,Value,ConditionRowID)) q:ConditionRowID=""
			
			s NodeDR = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowID)),2)
            s WordsDR="",NodeTypeDR="",WordsDesc="",NodeTypeDesc=""
            s:NodeDR'="" WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),2)
            s:NodeDR'="" NodeTypeDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
            s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
            s:NodeTypeDR'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3)
            continue:NodeTypeDesc'="主要条件-识别词"
            s count=count+1
			if (count=1)
			{
				s Record1=WordsDR_","_WordsDesc_","_"诊断名称"_","_Value
			}
			else
			{
				s Record=WordsDR_","_WordsDesc_","_"诊断名称"_","_Value
				if (count=2)
				{
					d Exfile.Write(Record1)
					d Exfile.WriteLine()
					d Exfile.Write(Record)
					d Exfile.WriteLine()	
				}
				else
				{
					d Exfile.Write(Record)
					d Exfile.WriteLine()
				}
			}
		}

	}
	
	d Exfile.%Save()
	d Exfile.%Close()
	q Exfilename
}

}
