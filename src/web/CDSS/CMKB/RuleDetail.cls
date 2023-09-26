/// Description：治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
/// Table：CT.WDT.CDSS.RuleDetail
Class web.CDSS.CMKB.RuleDetail Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleDetail
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleDetail","GetList","318722","少泽")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,NodeType,DetailRowId,Sequence,DrugDR,DrugDRName,DrugUse,DrugUseName,DosageMIN,DosageMINUnit,DosageMINUnitName,DosageMAX,DosageMAXUnit,DosageMAXUnitName,Frequency,FrequencyName,Remarks,LastLevel")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (NodeDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s DetailRowId = ""
	for
	{
		s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeDR,-100000000000000,DetailRowId),-1) q:DetailRowId=""
		s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		
		s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
		s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
		s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
		
		s DrugDRName="",DrugUseName=""
		if (NodeTypeDesc="推荐治疗方案-药品") 
		{
			s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
			s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
		}
		elseif(NodeTypeDesc="推荐治疗方案-手术") 
		{
			s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
			s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
		}
		elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法-方剂-方剂组成
		{
			s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
		}
		elseif(NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
		{
			s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR)),3)
			
		}
		elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
		{
			s DrugDRName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
			
		}
		continue:DrugDRName=""
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
		s LastLevel  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),12)
		
		if ($ZCONVERT(DrugDRName,"U")[desc)
		{
			d OutputRow
		} else{				//add by ZWW 2022-08-15
			s DetailId = ""
			for
			{
				s DetailId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId,DetailId),-1) q:DetailId=""
				s LastLevelDrugDR=DrugDR
				s LastLevelDrugUse=DrugUse
				s CDrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailId)),4)
				
				s ChildDrugDRName=""
				if (NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
				{
					
					s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(CDrugDR)),3)
					
				}
				elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
				{
					
					if (LastLevelDrugUse="腧穴")
					{
						s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(CDrugDR)),3)
					}
					elseif (LastLevelDrugUse="中药")
					{
						s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(CDrugDR)),3)
					}
					elseif (LastLevelDrugUse="药物")
					{
						s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(CDrugDR)),4)
					}
				}
				if ($ZCONVERT(ChildDrugDRName,"U")[desc){
					d OutputRow
				}
			}
		
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,NodeType,DetailRowId,Sequence,DrugDR,DrugDRName,DrugUse,DrugUseName,DosageMIN,DosageMINUnit,DosageMINUnitName,DosageMAX,DosageMAXUnit,DosageMAXUnitName,Frequency,FrequencyName,Remarks,LastLevel)
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

/// Creator:丁亚男
/// CreatDate:2022-02-14
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleDetail
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleDetail","GetChildList","407","")
Query GetChildList(ParentDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,NodeType,DetailRowId,Sequence,DrugDR,DrugDRName,DrugUse,DrugUseName,DosageMIN,DosageMINUnit,DosageMINUnitName,DosageMAX,DosageMAXUnit,DosageMAXUnitName,Frequency,FrequencyName,Remarks,LastLevel")
{
}

ClassMethod GetChildListExecute(ByRef qHandle As %Binary, ParentDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (ParentDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s DetailRowId = ""
	for
	{
		s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",ParentDR,DetailRowId),-1) q:DetailRowId=""
		s LastLevel=ParentDR
		s NodeDR=$lg($g(^CT.WDT.CDSS.RuleDetailD(ParentDR)),2)
		s LastLevelDrugDR=$lg($g(^CT.WDT.CDSS.RuleDetailD(ParentDR)),3)
		s LastLevelDrugUse=$lg($g(^CT.WDT.CDSS.RuleDetailD(ParentDR)),5)
		s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					
		s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
		s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
		s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
		s DrugDRName="",DrugUseName="",LastLevelName=""
		if (NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
		{
			s:LastLevelDrugDR'="" LastLevelName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(LastLevelDrugDR)),3)
			s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR)),3)
			s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(DrugUse)),3) //煎法
		}
		elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
		{
			s:LastLevelDrugDR'="" LastLevelName=$lg($g(^CT.WDT.CDSS.NursingDictD(LastLevelDrugDR)),4)
			
			if (LastLevelDrugUse="腧穴")
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(DrugDR)),3)
			}
			elseif (LastLevelDrugUse="中药")
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(DrugDR)),3)
			}
			elseif (LastLevelDrugUse="药物")
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
			}
			
		}
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
		
		if ($ZCONVERT(DrugUseName,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,NodeType,DetailRowId,Sequence,DrugDR,DrugDRName,DrugUse,DrugUseName,DosageMIN,DosageMINUnit,DosageMINUnitName,DosageMAX,DosageMAXUnit,DosageMAXUnitName,Frequency,FrequencyName,Remarks,LastLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetChildListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetChildListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChildListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-06-24   
/// w ##class(web.CDSS.CMKB.RuleDetail).FormValidate("","170649","1024","4545")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, NodeDR As %String, DrugDR As %String, LastLevel As %String) As %String
{
	if (NodeDR="")||(DrugDR="") q ""
	s:LastLevel="" LastLevel=-100000000000000
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.RuleDetailI("NodeLLDrugDRIndex",NodeDR,LastLevel,DrugDR)) //不用判断类型（药品或者手术），因为一个节点只能是一种类型
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.RuleDetailI("NodeLLDrugDRIndex",NodeDR,LastLevel,DrugDR,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Other:w ##class(web.CDSS.CMKB.RuleDetail).testSaveData()
ClassMethod testSaveData()
{
	
	s bobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
    s bobj.DetailRowId=""
    s bobj.NodeDR=504938
	s bobj.DrugDR = 47	//清瘟败毒饮
	s bobj.Sequence=2
	//s bobj.LastLevel=4545
	s result=..SaveData(bobj)
	
	b ;1					
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleDetail
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleDetail).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleDetail) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s tag=$MATCH(eobj.DrugDR,"^[0-9]*[1-9][0-9]*$")
		if (tag=0){	
			s result = "{success:'false',errorinfo:'保存内容不合法！'}"
			q result
		}
		s flag=..FormValidate(eobj.DetailRowId,eobj.NodeDR,eobj.DrugDR,eobj.LastLevel)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.DetailRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(eobj.DetailRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.Sequence = obj.Sequence
			s bobj.DrugDR = obj.DrugDR 
			s bobj.DrugUse = obj.DrugUse 
			s bobj.DosageMIN = obj.DosageMIN 
			if $IsObject(obj.DosageMINUnit)
			{
			 	s bobj.DosageMINUnit = obj.DosageMINUnit.%Id()
			}
			s bobj.DosageMAX = obj.DosageMAX 
			if $IsObject(obj.DosageMAXUnit)
			{
			 	s bobj.DosageMAXUnit = obj.DosageMAXUnit.%Id()
			} 
			if $IsObject(obj.Frequency)
			{
			 	s bobj.Frequency = obj.Frequency.%Id()
			}
			s bobj.Remarks = obj.Remarks
			
			if $IsObject(obj.LastLevel)
			{
			 	s bobj.LastLevel = obj.LastLevel.%Id()
			}
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		
		s obj.Sequence = eobj.Sequence  
		s obj.DrugDR = eobj.DrugDR 
		s obj.DrugUse = eobj.DrugUse 
		s obj.DosageMIN = eobj.DosageMIN 
		d:eobj.DosageMINUnit'="" obj.DosageMINUnitSetObjectId(eobj.DosageMINUnit)
		d:eobj.DosageMINUnit="" obj.DosageMINUnitSetObjectId("")
		s obj.DosageMAX = eobj.DosageMAX
		d:eobj.DosageMAXUnit'="" obj.DosageMAXUnitSetObjectId(eobj.DosageMAXUnit)
		d:eobj.DosageMAXUnit="" obj.DosageMAXUnitSetObjectId("")
		d:eobj.Frequency'="" obj.FrequencySetObjectId(eobj.Frequency)
		d:eobj.Frequency="" obj.FrequencySetObjectId("")
		s obj.Remarks = eobj.Remarks
		d:eobj.LastLevel'="" obj.LastLevelSetObjectId(eobj.LastLevel)
		d:eobj.LastLevel="" obj.LastLevelSetObjectId("")
		
		Ts
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s FirstNodeDR=eobj.NodeDR
			s FirstDrugDR=eobj.DrugDR
			//保存子节点
			s childres="true"
			s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(FirstNodeDR)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			
			if (NodeTypeDesc="推荐治疗方案-方剂")&($d(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",FirstDrugDR)))
			{
				
				//判断节点下是否有子节点，删除子节点
				s childdelres="true"
				if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",id)))
				{
					s DetailRowId = ""
					for
					{
						s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",id,DetailRowId),-1) q:DetailRowId=""
						
						s childdelres=..DeleteData(DetailRowId)
						if (childdelres["false")
						{
							s childdelres="{success:'false',info:'子节点删除失败，请先删除子节点！'}"
						}
					}
				}
				
				if (childdelres["true")
				{
					s cobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New()
					s MedRowId="",Sequence=1
					
					for
					{
						s MedRowId = $o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",FirstDrugDR,MedRowId)) q:MedRowId=""	
						
						s cobj.NodeDR=FirstNodeDR
						s cobj.Sequence=Sequence
						s cobj.DrugDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(MedRowId)),3) //中药指向
						/*s RecommendDose=$lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(MedRowId)),4)
						s:RecommendDose'="" cobj.DosageMIN = $lg($g(^CT.WDT.CDSS.TCMMedicineD(RecommendDose)),9) 	//推荐剂量*/
						s cobj.DosageMIN=$lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(MedRowId)),4) //推荐剂量
						s cobj.DosageMINUnit= $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(MedRowId)),5) 	//推荐单位
						s cobj.DrugUse = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(MedRowId)),6) 	//煎法
						s cobj.LastLevel=id
						s childres=..SaveChildData(cobj)
						
						if (childres["false")
						{
							
							s childres = "{success:'false',errorinfo:'方剂组成保存失败'}"  //返回错误信息
							
						}
						else
						{
							
							s Sequence=Sequence+1
							
						}	
					}	
				}	
			}
			if (childres["true")
			{
				
				Tc
				s result = "{success:'true',id:'"_id_"'}" 
				
				//保存日志
				s RuleDR="",NodeNum="",RuleDesc="" 
				s NodeDR=eobj.NodeDR
				s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
				s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
				s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
				d:eobj.DetailRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDetail","CT.WDT.CDSS.RuleDetail","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_eobj.DrugDR,"A",eobj)
				d:eobj.DetailRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDetail","CT.WDT.CDSS.RuleDetail","诊疗节点内容表(结论类)",eobj.DetailRowId,RuleDesc_","_NodeNum_","_eobj.DrugDR,"U",eobj,bobj)
				
			}
			else
			{
				Tro
				s result = childres //返回错误信息
				
			}
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleDetail
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleDetail).SaveEntity()
ClassMethod SaveChildData(eobj As web.CDSSEntity.CMKB.RuleDetail) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s tag=$MATCH(eobj.DrugDR,"^[0-9]*[1-9][0-9]*$")
		if (tag=0){	
			s result = "{success:'false',errorinfo:'保存内容不合法！'}"
			q result
		}
		s flag=..FormValidate(eobj.DetailRowId,eobj.NodeDR,eobj.DrugDR,eobj.LastLevel)  //调用重复验证
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.DetailRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleDetail).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(eobj.DetailRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.Sequence = obj.Sequence
			s bobj.DrugDR = obj.DrugDR 
			s bobj.DrugUse = obj.DrugUse 
			s bobj.DosageMIN = obj.DosageMIN 
			if $IsObject(obj.DosageMINUnit)
			{
			 	s bobj.DosageMINUnit = obj.DosageMINUnit.%Id()
			}
			s bobj.DosageMAX = obj.DosageMAX 
			if $IsObject(obj.DosageMAXUnit)
			{
			 	s bobj.DosageMAXUnit = obj.DosageMAXUnit.%Id()
			} 
			if $IsObject(obj.Frequency)
			{
			 	s bobj.Frequency = obj.Frequency.%Id()
			}
			s bobj.Remarks = obj.Remarks
			
			if $IsObject(obj.LastLevel)
			{
			 	s bobj.LastLevel = obj.LastLevel.%Id()
			}
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		
		s obj.Sequence = eobj.Sequence  
		s obj.DrugDR = eobj.DrugDR 
		s obj.DrugUse = eobj.DrugUse 
		s obj.DosageMIN = eobj.DosageMIN 
		d:eobj.DosageMINUnit'="" obj.DosageMINUnitSetObjectId(eobj.DosageMINUnit)
		d:eobj.DosageMINUnit="" obj.DosageMINUnitSetObjectId("")
		s obj.DosageMAX = eobj.DosageMAX
		d:eobj.DosageMAXUnit'="" obj.DosageMAXUnitSetObjectId(eobj.DosageMAXUnit)
		d:eobj.DosageMAXUnit="" obj.DosageMAXUnitSetObjectId("")
		d:eobj.Frequency'="" obj.FrequencySetObjectId(eobj.Frequency)
		d:eobj.Frequency="" obj.FrequencySetObjectId("")
		s obj.Remarks = eobj.Remarks
		d:eobj.LastLevel'="" obj.LastLevelSetObjectId(eobj.LastLevel)
		d:eobj.LastLevel="" obj.LastLevelSetObjectId("")
		
		Ts
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			Tc
			s result = "{success:'true',id:'"_id_"'}" 
			
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s NodeDR=eobj.NodeDR
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			d:eobj.DetailRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDetail","CT.WDT.CDSS.RuleDetail","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_eobj.DrugDR,"A",eobj)
			d:eobj.DetailRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDetail","CT.WDT.CDSS.RuleDetail","诊疗节点内容表(结论类)",eobj.DetailRowId,RuleDesc_","_NodeNum_","_eobj.DrugDR,"U",eobj,bobj)
				
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleDetail","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleDetail","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleDetail
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleDetail).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence
	s bobj.DrugDR = obj.DrugDR 
	s bobj.DrugUse = obj.DrugUse 
	s bobj.DosageMIN = obj.DosageMIN 
	if $IsObject(obj.DosageMINUnit)
	{
	 	s bobj.DosageMINUnit = obj.DosageMINUnit.%Id()
	}
	s bobj.DosageMAX = obj.DosageMAX 
	if $IsObject(obj.DosageMAXUnit)
	{
	 	s bobj.DosageMAXUnit = obj.DosageMAXUnit.%Id()
	} 
	if $IsObject(obj.Frequency)
	{
	 	s bobj.Frequency = obj.Frequency.%Id()
	}
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.LastLevel)
	{
	 	s bobj.LastLevel = obj.LastLevel.%Id()
	}
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleDetail
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleDetail).DeleteData("4515")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence
	s bobj.DrugDR = obj.DrugDR 
	s bobj.DrugUse = obj.DrugUse 
	s bobj.DosageMIN = obj.DosageMIN 
	if $IsObject(obj.DosageMINUnit)
	{
	 	s bobj.DosageMINUnit = obj.DosageMINUnit.%Id()
	}
	s bobj.DosageMAX = obj.DosageMAX 
	if $IsObject(obj.DosageMAXUnit)
	{
	 	s bobj.DosageMAXUnit = obj.DosageMAXUnit.%Id()
	} 
	if $IsObject(obj.Frequency)
	{
	 	s bobj.Frequency = obj.Frequency.%Id()
	} 
	
	s bobj.Remarks = obj.Remarks
	if $IsObject(obj.LastLevel)
	{
	 	s bobj.LastLevel = obj.LastLevel.%Id()
	}
	s sc=##class(CT.WDT.CDSS.RuleDetail).%DeleteId(id)
	if $$$ISOK(sc)
	{
		//删除子节点
		s childres=""
		if ($d(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",id)))
		{
			s DetailRowId = ""
			for
			{
				s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",id,DetailRowId),-1) q:DetailRowId=""
				s childdelres=..DeleteData(DetailRowId)
				if (childdelres["false")
				{
					s childres="{success:'false',info:'子节点删除失败，请先删除子节点！'}"
				}
			}
		}
		if (childres="")
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:bobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),2)
			s:bobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDetail","CT.WDT.CDSS.RuleDetail","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_bobj.DrugDR,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = childres //返回错误信息
		}
		
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleDetail","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

}
