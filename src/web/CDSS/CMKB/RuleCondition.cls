/// Description：诊疗节点内容表（触发条件类）
/// Table：CT.WDT.CDSS.RuleCondition
Class web.CDSS.CMKB.RuleCondition Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleCondition
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleCondition","GetList","298802","急性胃炎")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,ConditionRowId,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,ConditionItemValUnitN,SpecialConfig,Remarks,ConditionItemCategory")
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
		s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionRowId),-1) q:ConditionRowId=""
		s ConditionClass  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),3)
		s ConditionItem  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),4)
		s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),5)
		s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
		s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),7)
		s ConditionItemValUnitN=""
		s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
		s SpecialConfig  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),8)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)
		s ConditionItemCategory  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),10)
		
		continue:($ZCONVERT(ConditionItemValue,"U")'[desc)
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,ConditionRowId,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,ConditionItemValUnitN,SpecialConfig,Remarks,ConditionItemCategory)
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
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleCondition
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleCondition).TestSaveData("3")
ClassMethod TestSaveData(id As %String) As %String
{
	s str=""	
	s bobj = ##class(web.CDSSEntity.CMKB.RuleCondition).%New() 
	s bobj.ConditionRowId="23"
	s bobj.NodeDR = "89"
	s bobj.ConditionClass = "性别" 
	s bobj.ConditionItem = "Sex"
	s bobj.ConditionItemValue = "女" 
	s bobj.ConditionItemCalculate = "="
	s str=..SaveData(bobj)	
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-06-24   
/// w ##class(web.CDSS.CMKB.RuleCondition).FormValidate("","","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, NodeDR As %String, ConditionItemValue As %String, ConditionItemCategory As %String) As %String
{
	if (NodeDR="")||(ConditionItemValue="") q ""
	s NodeTypeDesc=""
	s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
	s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
	s flag=""
	if (NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="否定条件-诊断")||(NodeTypeDesc="通过条件")
    { 
		s flagc=""
		s flagc=$d(^CT.WDT.CDSS.RuleConditionI("NodeItemCateIndex",NodeDR,ConditionItemValue,ConditionItemCategory))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else //如果不为空，修改时的重复判断
		{
			s idc=""
			s idc=$o(^CT.WDT.CDSS.RuleConditionI("NodeItemCateIndex",NodeDR,ConditionItemValue,ConditionItemCategory,0))
			if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志

		}
    }
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleCondition
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleCondition).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleCondition) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(eobj.ConditionRowId,eobj.NodeDR,eobj.ConditionItemValue,eobj.ConditionItemCategory)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.ConditionRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleCondition).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(eobj.ConditionRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleCondition).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.ConditionClass = obj.ConditionClass  
			s bobj.ConditionItem = obj.ConditionItem 
			s bobj.ConditionItemValue = obj.ConditionItemValue 
			s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
			if $IsObject(obj.ConditionItemValUnit)
			{
			 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
			}
			s bobj.SpecialConfig = obj.SpecialConfig
			s bobj.Remarks = obj.Remarks
			s bobj.ConditionItemCategory=obj.ConditionItemCategory
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		s obj.ConditionClass = eobj.ConditionClass  
		s obj.ConditionItem = eobj.ConditionItem 
		s obj.ConditionItemValue = eobj.ConditionItemValue 
		s obj.ConditionItemCalculate = eobj.ConditionItemCalculate
		d:eobj.ConditionItemValUnit'="" obj.ConditionItemValUnitSetObjectId(eobj.ConditionItemValUnit)
		s obj.SpecialConfig = eobj.SpecialConfig
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
		s obj.ConditionItemCategory=eobj.ConditionItemCategory
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			
			d:eobj.ConditionRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleCondition","CT.WDT.CDSS.RuleCondition","诊疗节点内容表（触发条件类）",id,RuleDesc_","_NodeNum_","_eobj.ConditionClass,"A",eobj)
			d:eobj.ConditionRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleCondition","CT.WDT.CDSS.RuleCondition","诊疗节点内容表（触发条件类）",RuleDesc_","_NodeNum_","_eobj.ConditionRowId,eobj.ConditionClass,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表（触发条件类）","web.CDSS.CMKB.RuleCondition","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表（触发条件类）","web.CDSS.CMKB.RuleCondition","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleCondition
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleCondition).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleCondition).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.ConditionClass = obj.ConditionClass  
	s bobj.ConditionItem = obj.ConditionItem 
	s bobj.ConditionItemValue = obj.ConditionItemValue 
	s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
	if $IsObject(obj.ConditionItemValUnit)
	{
	 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
	}
	s bobj.SpecialConfig = obj.SpecialConfig
	s bobj.Remarks = obj.Remarks
	s bobj.ConditionItemCategory=obj.ConditionItemCategory
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleCondition
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleCondition).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleCondition).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.ConditionClass = obj.ConditionClass  
	s bobj.ConditionItem = obj.ConditionItem 
	s bobj.ConditionItemValue = obj.ConditionItemValue 
	s bobj.ConditionItemCalculate = obj.ConditionItemCalculate
	if $IsObject(obj.ConditionItemValUnit)
	{
	 	s bobj.ConditionItemValUnit = obj.ConditionItemValUnit.%Id()
	}
	s bobj.SpecialConfig = obj.SpecialConfig
	s bobj.Remarks = obj.Remarks
	s bobj.ConditionItemCategory=obj.ConditionItemCategory
	s sc=##class(CT.WDT.CDSS.RuleCondition).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDR="",NodeNum="",RuleDesc="" 
		s:bobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),2)
		s:bobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),4)
		s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleCondition","CT.WDT.CDSS.RuleCondition","诊疗节点内容表（触发条件类）",id,RuleDesc_","_NodeNum_","_bobj.ConditionClass,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表（触发条件类）","web.CDSS.CMKB.RuleCondition","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-04-15
/// Description：导出诊疗规则诊断条件和对应推荐治疗方案-药品 数据
/// Input：
/// Return: 疾病编码，诊断条件,推荐治疗方案-药品
/// Other:w ##class(web.CDSS.CMKB.RuleCondition).ExportDiseaseData()
ClassMethod ExportDiseaseData()
{
	
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"推荐治疗方案药品数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("编码,"_"主要条件-诊断,"_"推荐治疗方案_药品")
	d file.WriteLine()
	
	s RuleDR=""
	for	//遍历诊疗规则
	{ 
		s RuleDR=$o(^CT.WDT.CDSS.RuleDictD(RuleDR)) q:RuleDR="" 
		s NodeTypeId=5	//主要条件-诊断
		s NodeRowId=""
		for
		{
			s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleDR,NodeTypeId,NodeRowId)) q:NodeRowId=""
			s ConditionRowId=""
			for{
				s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId),-1) q:ConditionRowId=""
				s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
				s DiseaseCode = ""
				if ($o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(ConditionItemValue,"U"),0))){
					s DiseaseId = $o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(ConditionItemValue,"U"),0))
					
					s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseId)),2)
					
				}
				
				s FlowChartNum = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)	//主要条件-诊断所在的流程图顺序号，进而取对应的药品数据
				s NodeTypeDR = 12	//推荐治疗方案——药品节点类型12
				s NodeDR=""
				for{	//取当前诊断下所有的推荐治疗方案——药品
					s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleDR,FlowChartNum,NodeTypeDR,NodeDR)) q:NodeDR=""
					s DetailRowId = ""
					for
					{
						s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeDR,DetailRowId),-1) q:DetailRowId=""
						s DrugDR = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
						s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
						
						d file.Write(DiseaseCode_",")
						d file.Write(ConditionItemValue_",")
						d file.Write(DrugDRName)
						d file.WriteLine()
					}
				}
			}
		}		
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

}
