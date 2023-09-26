/// 名称:标准版检验-项目组合套
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-5
Class web.DHCBL.LAB.BTTestSet Extends %RegisteredObject
{

/// Creator：钟荣枫		
/// CreatDate: 2019-11-5
/// Description：查询 项目组合套
/// Table：dbo.BT_TestSet
/// Input：RowID, code ,desc,hospital,active
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSet","GetList","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospital As %String, active As %String) As %Query(ROWSPEC = "RowID,Code,CName,HospitalDR,EName,Description,HISCode,SpeciesDR,Urgent,SpecimenDR,ContainerDR,MergeType,WorkGroupMachineDR,CostItemDR,CollectPromptDR,ReportPromptDR,Sequence,Active,ReportType,LinkStr,LinkType,WorkGroupDR,ExtraFlag,ReportRemark,MICDefDrugRule,PositiveAlarn,WorkRatio,ReportShowType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospital As %String, active As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s:hospital'="" hospital=$ZCONVERT(hospital,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
			
		s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
		s HospitalDR= $lg($g(^dbo.BTTestSetD(RowID)),4)		//医院
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		s EName= $lg($g(^dbo.BTTestSetD(RowID)),5)		//英文名称
		s Description= $lg($g(^dbo.BTTestSetD(RowID)),6)		//描述
		s HISCode= $lg($g(^dbo.BTTestSetD(RowID)),7)		//HIS 对照码
		s SpeciesDR= $lg($g(^dbo.BTTestSetD(RowID)),8)	//适合性别 
		s:SpeciesDR'="" SpeciesDR=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)	//适合性别描述
		s Urgent= $lg($g(^dbo.BTTestSetD(RowID)),9)	//允许急诊
		s:Urgent="" Urgent=0						//update2019-11-19 CheckBox复选框值为空时，设为0
		s SpecimenDR= $lg($g(^dbo.BTTestSetD(RowID)),10)	//默认标本类型 
		s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)	//默认标本类型描述
		
		s ContainerDR= $lg($g(^dbo.BTTestSetD(RowID)),11)		//默认容器
		s:ContainerDR'="" ContainerDR=$lg($g(^dbo.BTContainerD(ContainerDR)),3)	//默认容器描述
		s MergeType= $lg($g(^dbo.BTTestSetD(RowID)),12)		//默认条码数量
		s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetD(RowID)),13)		//默认工作小组 
		s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//默认工作小组描述
		s CostItemDR= $lg($g(^dbo.BTTestSetD(RowID)),14)		//收费项目 
		s:CostItemDR'="" CostItemDR=$lg($g(^dbo.BTCostItemD(CostItemDR)),3)	//收费项目描述 
		s CollectPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),15)		//采集提示 
		s:CollectPromptDR'="" CollectPromptDR=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)	//采集提示描述 
		s ReportPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),16)		//取报告提示
		s:ReportPromptDR'="" ReportPromptDR=$lg($g(^dbo.BTReportPromptD(ReportPromptDR)),3)	//取报告提示描述 
		s Sequence= $lg($g(^dbo.BTTestSetD(RowID)),17)	//序号
		s Active= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
		s:Active="" Active=1			//update 2019-12-17  激活为空时，设为1
		s ReportType= $lg($g(^dbo.BTTestSetD(RowID)),19)	//报告模式	
		s LinkStr= $lg($g(^dbo.BTTestSetD(RowID)),20)	//
		s LinkType= $lg($g(^dbo.BTTestSetD(RowID)),21)
		s WorkGroupDR= $lg($g(^dbo.BTTestSetD(RowID)),22)	//医嘱所属工作组
		s:WorkGroupDR'="" WorkGroupDR=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)	 
		s ExtraFlag= $lg($g(^dbo.BTTestSetD(RowID)),23)		//附加处理
		s:ExtraFlag="" ExtraFlag=0
		s ReportRemark= $lg($g(^dbo.BTTestSetD(RowID)),24)	//报告说明
		s MICDefDrugRule= $lg($g(^dbo.BTTestSetD(RowID)),25)	//微生物耐药机制
		s PositiveAlarn= $lg($g(^dbo.BTTestSetD(RowID)),26)		//阳性报警
		s:PositiveAlarn="" PositiveAlarn=0
		s WorkRatio= $lg($g(^dbo.BTTestSetD(RowID)),27)			//测试数
		s ReportShowType=$lg($g(^dbo.BTTestSetD(RowID)),28)	// 报告显示类型 
		d OutputRow
		
	}
	else
	{
		s RowID=0
		k ^tempsequencesort("dbo.BTTestSet")
		for 
		{
			s RowID=$o(^dbo.BTTestSetD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)
			
			s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
			
			s HospitalDR= $lg($g(^dbo.BTTestSetD(RowID)),4)		//医院
			if (hospital'="")
			{
				continue:hospital'=HospitalDR
			}
			
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
			
			s EName= $lg($g(^dbo.BTTestSetD(RowID)),5)		//英文名称
			s Description= $lg($g(^dbo.BTTestSetD(RowID)),6)		//描述
			s HISCode= $lg($g(^dbo.BTTestSetD(RowID)),7)		//HIS 对照码
			s SpeciesDR= $lg($g(^dbo.BTTestSetD(RowID)),8)	//适合性别 
			s:SpeciesDR'="" SpeciesDR=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)	//适合性别描述
			s Urgent= $lg($g(^dbo.BTTestSetD(RowID)),9)	//允许急诊
			s:Urgent="" Urgent=0
			s SpecimenDR= $lg($g(^dbo.BTTestSetD(RowID)),10)	//默认标本类型 
			s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)	//默认标本类型描述
			
			s ContainerDR= $lg($g(^dbo.BTTestSetD(RowID)),11)		//默认容器
			s:ContainerDR'="" ContainerDR=$lg($g(^dbo.BTContainerD(ContainerDR)),3)	//默认容器描述
			s MergeType= $lg($g(^dbo.BTTestSetD(RowID)),12)		//默认条码数量
			s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetD(RowID)),13)		//默认工作小组 
			s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//默认工作小组描述
			s CostItemDR= $lg($g(^dbo.BTTestSetD(RowID)),14)		//收费项目 
			s:CostItemDR'="" CostItemDR=$lg($g(^dbo.BTCostItemD(CostItemDR)),3)	//收费项目描述 
			s CollectPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),15)		//采集提示 
			s:CollectPromptDR'="" CollectPromptDR=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)	//采集提示描述 
			s ReportPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),16)		//取报告提示
			s:ReportPromptDR'="" ReportPromptDR=$lg($g(^dbo.BTReportPromptD(ReportPromptDR)),3)	//取报告提示描述 
			s Sequence= $lg($g(^dbo.BTTestSetD(RowID)),17)	//序号
			s Active= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
			s:Active="" Active=1			//update 2019-12-17  激活为空时，设为1
			if (active'="")&&(Active'=active)
			{
				continue 
			}
			s ReportType= $lg($g(^dbo.BTTestSetD(RowID)),19)	//报告模式	
			s LinkStr= $lg($g(^dbo.BTTestSetD(RowID)),20)	//
			s LinkType= $lg($g(^dbo.BTTestSetD(RowID)),21)
			s WorkGroupDR= $lg($g(^dbo.BTTestSetD(RowID)),22)	//医嘱所属工作组
			s:WorkGroupDR'="" WorkGroupDR=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)	 
			s ExtraFlag= $lg($g(^dbo.BTTestSetD(RowID)),23)		//附加处理
			s:ExtraFlag="" ExtraFlag=0
			s ReportRemark= $lg($g(^dbo.BTTestSetD(RowID)),24)	//报告说明
			s MICDefDrugRule= $lg($g(^dbo.BTTestSetD(RowID)),25)	//微生物耐药机制
			s PositiveAlarn= $lg($g(^dbo.BTTestSetD(RowID)),26)		//阳性报警
			s:PositiveAlarn="" PositiveAlarn=0
			s WorkRatio= $lg($g(^dbo.BTTestSetD(RowID)),27)			//测试数
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if (($ZCONVERT(CName,"U")[desc)||(PINYINCODE[desc)) 
				{
					s AliasFlag= 1	 
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTTestSet",Sequence,RowID)=RowID
				;d OutputRow
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTTestSet",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{

				s RowIDSort=$o(^tempsequencesort("dbo.BTTestSet",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
				s HospitalDR= $lg($g(^dbo.BTTestSetD(RowID)),4)		//医院
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
				s EName= $lg($g(^dbo.BTTestSetD(RowID)),5)		//英文名称
				s Description= $lg($g(^dbo.BTTestSetD(RowID)),6)		//描述
				s HISCode= $lg($g(^dbo.BTTestSetD(RowID)),7)		//HIS 对照码
				s SpeciesDR= $lg($g(^dbo.BTTestSetD(RowID)),8)	//适合性别 
				s:SpeciesDR'="" SpeciesDR=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)	//适合性别描述
				s Urgent= $lg($g(^dbo.BTTestSetD(RowID)),9)	//允许急诊
				s:Urgent="" Urgent=0						//update2019-11-19 CheckBox复选框值为空时，设为0
				s SpecimenDR= $lg($g(^dbo.BTTestSetD(RowID)),10)	//默认标本类型 
				s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)	//默认标本类型描述
				
				s ContainerDR= $lg($g(^dbo.BTTestSetD(RowID)),11)		//默认容器
				s:ContainerDR'="" ContainerDR=$lg($g(^dbo.BTContainerD(ContainerDR)),3)	//默认容器描述
				s MergeType= $lg($g(^dbo.BTTestSetD(RowID)),12)		//默认条码数量
				s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetD(RowID)),13)		//默认工作小组 
				s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//默认工作小组描述
				s CostItemDR= $lg($g(^dbo.BTTestSetD(RowID)),14)		//收费项目 
				s:CostItemDR'="" CostItemDR=$lg($g(^dbo.BTCostItemD(CostItemDR)),3)	//收费项目描述 
				s CollectPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),15)		//采集提示 
				s:CollectPromptDR'="" CollectPromptDR=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)	//采集提示描述 
				s ReportPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),16)		//取报告提示
				s:ReportPromptDR'="" ReportPromptDR=$lg($g(^dbo.BTReportPromptD(ReportPromptDR)),3)	//取报告提示描述 
				s Sequence= $lg($g(^dbo.BTTestSetD(RowID)),17)	//序号
				s Active= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
				s:Active="" Active=1			//update 2019-12-17  激活为空时，设为1
				s ReportType= $lg($g(^dbo.BTTestSetD(RowID)),19)	
				s LinkStr= $lg($g(^dbo.BTTestSetD(RowID)),20)	//
				s LinkType= $lg($g(^dbo.BTTestSetD(RowID)),21)
				s WorkGroupDR= $lg($g(^dbo.BTTestSetD(RowID)),22)	//医嘱所属工作组
				s:WorkGroupDR'="" WorkGroupDR=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)	 
				s ExtraFlag= $lg($g(^dbo.BTTestSetD(RowID)),23)		//附加处理
				s:ExtraFlag="" ExtraFlag=0
				s ReportRemark= $lg($g(^dbo.BTTestSetD(RowID)),24)	//报告说明
				s MICDefDrugRule= $lg($g(^dbo.BTTestSetD(RowID)),25)	//微生物耐药机制
				s PositiveAlarn= $lg($g(^dbo.BTTestSetD(RowID)),26)		//阳性报警
				s:PositiveAlarn="" PositiveAlarn=0
				s WorkRatio= $lg($g(^dbo.BTTestSetD(RowID)),27)			//测试数
				s ReportShowType=$lg($g(^dbo.BTTestSetD(RowID)),28)	// 报告显示类型 
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,HospitalDR,EName,Description,HISCode,SpeciesDR,Urgent,SpecimenDR,ContainerDR,MergeType,WorkGroupMachineDR,CostItemDR,CollectPromptDR,ReportPromptDR,Sequence,Active,ReportType,LinkStr,LinkType,WorkGroupDR,ExtraFlag,ReportRemark,MICDefDrugRule,PositiveAlarn,WorkRatio,ReportShowType)
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

/// Creator：钟荣枫		
/// CreatDate: 2019-11-5
/// Description：查询 项目组合套 下拉框		update2020-5-12 过滤在合报告分组关联中已经关联的项目组合套
/// Table：dbo.BT_TestSet
/// Input：RowID, desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSet","GetDataForCmb1","","","xt")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, linkflag As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, linkflag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
		s Active= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
		
		d OutputRowCmb	
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTTestSet")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestSetD(RowID))
			q:RowID=""
			
			if (linkflag="Y")		//过滤
			{
				s flag=0
				s SubTestSet=0
				//过滤已经关联的项目组合套
				for
				{
					s SubTestSet=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSet",SubTestSet)) 
					q:SubTestSet=""
					s:(SubTestSet=RowID) flag=1
				}
				continue:flag=1
			}
			s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
			s Sequence= $lg($g(^dbo.BTTestSetD(RowID)),17)	//序号
			s Active= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
			continue:Active=0
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if (($ZCONVERT(CName,"U")[desc)||(PINYINCODE[desc)) 
				{
					s AliasFlag= 1	
				} 
				
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTTestSet",Sequence,RowID)=RowID
				;d OutputRowCmb
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTTestSet",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{

				s RowIDSort=$o(^tempsequencecombosort("dbo.BTTestSet",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
				d OutputRowCmb
			}
		}	
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowID,Code,CName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:钟荣枫
/// CreatDate:2019-11-14
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTTestSet).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	//n (id)
	s return="",myInfo=""
	//dbo.BTTestSetWorkGroupMachine
	s TSWGMRowID=0
	for 
	{
		s TSWGMRowID=$o(^dbo.BTTestSetWorkGroupMachineD(TSWGMRowID))
		q:TSWGMRowID=""
		s TestSetDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(TSWGMRowID)),2)
		
		if (TestSetDR=id)
		{
			s myInfo=myInfo_"<项目组合套关联工作小组>"
			q
		}
	}
	//dbo.BTTestCode
	s TSCodeRowID=0
	for 
	{
		s TSCodeRowID=$o(^dbo.BTTestCodeD(TSCodeRowID))
		q:TSCodeRowID=""
		s TestSetDR= $lg($g(^dbo.BTTestCodeD(TSCodeRowID)),22)
		
		if (TestSetDR=id)
		{
			s myInfo=myInfo_"<检测项目>"
			q
		}
	}
	//dbo.BTTestSetSpecimen
	s TSSpeciRowID=0
	for 
	{
		s TSSpeciRowID=$o(^dbo.BTTestSetSpecimenD(TSSpeciRowID))
		q:TSSpeciRowID=""
		s TestSetDR= $lg($g(^dbo.BTTestSetSpecimenD(TSSpeciRowID)),2)
		
		if (TestSetDR=id)
		{
			s myInfo=myInfo_"<项目组合套关联标本>"
			q
		}
	}
	//dbo.BTTestSetLayout 
	s TSLayoutRowID=0
	for 
	{
		s TSLayoutRowID=$o(^dbo.BTTestSetLayoutD(TSLayoutRowID))
		q:TSLayoutRowID=""
		s TestSetDR= $lg($g(^dbo.BTTestSetLayoutD(TSLayoutRowID)),2)
		
		if (TestSetDR=id)
		{
			s myInfo=myInfo_"<项目组合套布局>"
			q
		}
	}
	//dbo.BTTestSetOGTTGroupLinks 
	s TSOGTTGLRowID=0
	for 
	{
		s TSOGTTGLRowID=$o(^dbo.BTTestSetOGTTGroupLinksD(TSOGTTGLRowID))
		q:TSOGTTGLRowID=""
		s MainTestSetDR= $lg($g(^dbo.BTTestSetOGTTGroupLinksD(TSOGTTGLRowID)),3)
		s SubTestSetDR=	$lg($g(^dbo.BTTestSetOGTTGroupLinksD(TSOGTTGLRowID)),4)
		if (MainTestSetDR=id)||(SubTestSetDR=id)
		{
			s myInfo=myInfo_"<组合套组配置>"
			q
		}
	}
	//dbo.BTTestSetGroupLinks
	s TSGLRowID=0
	for 
	{
		s TSGLRowID=$o(^dbo.BTTestSetGroupLinksD(TSGLRowID))
		q:TSGLRowID=""
		s TestSetDR= $lg($g(^dbo.BTTestSetGroupLinksD(TSGLRowID)),3)	
		if (TestSetDR=id)
		{
			s myInfo=myInfo_"<组合套分组关联>"
			q
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-7
/// Description：根据id删除 工作组
/// Table：dbo.BT_TestSet
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSet).DeleteData(156)
ClassMethod DeleteData(id) As %String
{

	s result=""
	s re=##class(web.DHCBL.LAB.BTTestSet).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTTestSet).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTTestSet).%New()
		
		s eobj.Code = pobj.Code
		s eobj.CName = pobj.CName
		
		s eobj.HospitalDR=pobj.HospitalDR
		s eobj.EName = pobj.EName
		s eobj.Description = pobj.Description
		
		s eobj.HISCode = pobj.HISCode
		
		s eobj.SpeciesDR=pobj.SpeciesDR
		s eobj.Urgent = pobj.Urgent
		
		s eobj.SpecimenDR=pobj.SpecimenDR
		s eobj.ContainerDR=pobj.ContainerDR
		
		s eobj.MergeType = pobj.MergeType
		s eobj.WorkGroupMachineDR=pobj.WorkGroupMachineDR
		s eobj.CostItemDR=pobj.CostItemDR
		s eobj.CollectPromptDR=pobj.CollectPromptDR
		s eobj.ReportPromptDR=pobj.ReportPromptDR
		
		s eobj.Sequence = pobj.Sequence
		s eobj.Active = pobj.Active
		s eobj.ReportType = pobj.ReportType
		s eobj.LinkStr = pobj.LinkStr
		s eobj.LinkType = pobj.LinkType
		s eobj.WorkGroupDR=pobj.WorkGroupDR
		s eobj.ExtraFlag = pobj.ExtraFlag
		s eobj.ReportRemark=pobj.ReportRemark
		s eobj.MICDefDrugRule = pobj.MICDefDrugRule
		s eobj.PositiveAlarn = pobj.PositiveAlarn
		s eobj.WorkRatio = pobj.WorkRatio
		s eobj.ReportShowType=pobj.ReportShowType
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTTestSet).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSet","dbo.BTTestSet","项目组合套",id,eobj.CName,"D",eobj)
			if (eobj.WorkGroupMachineDR'="")	//删除关联工作小组
			{
				s TSWGMRowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",id,eobj.WorkGroupMachineDR,0))
				d:TSWGMRowID'="" ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).DeleteData(TSWGMRowID)	
			}
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("工作组","web.DHCBL.LAB.BTTestSet","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-6
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BT_TestSet
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTTestSet).OpenData(15)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTTestSet).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestSet).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.CName = pobj.CName
	s:eobj.CName["'" eobj.CName=$tr(eobj.CName,"'","‘")
	s eobj.HospitalDR=pobj.HospitalDR
	s eobj.EName = pobj.EName
	
	s eobj.Description=pobj.Description
	s eobj.HISCode = pobj.HISCode
	s eobj.SpeciesDR = pobj.SpeciesDR
	s eobj.Urgent = pobj.Urgent
	s eobj.SpecimenDR=pobj.SpecimenDR
	
	s eobj.ContainerDR = pobj.ContainerDR
	s eobj.MergeType = pobj.MergeType
	s eobj.WorkGroupMachineDR = pobj.WorkGroupMachineDR
	s eobj.CostItemDR = pobj.CostItemDR
	s eobj.CollectPromptDR = pobj.CollectPromptDR
	
	s eobj.ReportPromptDR = pobj.ReportPromptDR
	s eobj.Sequence = pobj.Sequence
	s eobj.Active = pobj.Active
	s eobj.ReportType = pobj.ReportType
	s eobj.LinkStr = pobj.LinkStr
	
	s eobj.LinkType = pobj.LinkType
	s eobj.WorkGroupDR = pobj.WorkGroupDR
	s eobj.ExtraFlag = pobj.ExtraFlag
	s eobj.ReportRemark = pobj.ReportRemark
	s eobj.MICDefDrugRule = pobj.MICDefDrugRule
	//s eobj.MICDefDrugRule =##class(web.BDP.util.String).Replace(eobj.MICDefDrugRule,"""", "'")
	s eobj.PositiveAlarn = pobj.PositiveAlarn
	s eobj.WorkRatio = pobj.WorkRatio
	s eobj.ReportShowType=pobj.ReportShowType
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str =##class(web.BDP.util.String).Replace(str,"'", "\'")
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:钟荣枫 
/// CreatDate:2019-11-6
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_TestSet
/// Input:id, Code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSet).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	
	s flag=0
	if (code'="")&&(hosp'="")
	{

		s RowID=$o(^dbo.BTTestSetI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2020-1-16
/// Description:通过项目组合套代码获取项目组合套rowid
/// w ##class(web.DHCBL.LAB.BTTestSet).GetTextSetRowIdByCode("A1AB51")
ClassMethod GetTextSetRowIdByCode(code As %String) As %String
{
	S ROWID=""
	IF (code'="")
	{
		s hospital=0
		for
		{
			s hospital=$O(^dbo.BTTestSetI("IndexCode",hospital)) q:hospital=""
			s rowid=0
			for
			{
				s rowid=$O(^dbo.BTTestSetI("IndexCode",hospital,##Class(web.DHCBL.BDP.FunLib).IndexData(code),rowid)) q:rowid=""
				s SCODE=$lg($g(^dbo.BTTestSetD(rowid)),2)		//代码
				IF (SCODE=code) S ROWID=rowid
			}
		}
	}
	q ROWID
}

/// Creator:钟荣枫 
/// CreatDate: 2019-11-6
/// Description：保存 项目组合套
/// Input: eobj As web.Entity.LAB.BTTestSet
/// Table：dbo.BT_TestSet
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSet).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSet) As %String
{
	
	s result=""
	
	if $IsObject(eobj)
	{	
		s:eobj.Urgent="" eobj.Urgent=0		//update2019-11-19 CheckBox复选框值为空时，设为0
		s:eobj.Active="" eobj.Active=0
		s:eobj.ExtraFlag="" eobj.ExtraFlag=0
		s:eobj.PositiveAlarn="" eobj.PositiveAlarn=0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
			
			s obj=##class(dbo.BTTestSet).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestSet).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestSet).%New()
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code	
			s bobj.CName = obj.CName	
			s bobj.HospitalDR=obj.HospitalDR	
			s bobj.EName = obj.EName	
			
			s bobj.Description = obj.Description	
			s bobj.HISCode = obj.HISCode	
			s bobj.SpeciesDR=obj.SpeciesDR	
			s bobj.Urgent = obj.Urgent	
			s bobj.SpecimenDR=obj.SpecimenDR	
			s bobj.ContainerDR=obj.ContainerDR	
	
			s bobj.MergeType = obj.MergeType	
			s bobj.WorkGroupMachineDR=obj.WorkGroupMachineDR	
			s bobj.CostItemDR=obj.CostItemDR	
			s bobj.CollectPromptDR=obj.CollectPromptDR	
			s bobj.ReportPromptDR=obj.ReportPromptDR	
			
			s bobj.Sequence = obj.Sequence	
			s bobj.Active = obj.Active	
			s bobj.ReportType = obj.ReportType	
			s bobj.LinkStr = obj.LinkStr
			s bobj.LinkType = obj.LinkType
			
			s bobj.WorkGroupDR=obj.WorkGroupDR	
			s bobj.ExtraFlag = obj.ExtraFlag	
			s bobj.ReportRemark = obj.ReportRemark	
			s bobj.MICDefDrugRule = obj.MICDefDrugRule	
			s bobj.PositiveAlarn = obj.PositiveAlarn	
			s bobj.WorkRatio = obj.WorkRatio
			s bobj.ReportShowType=obj.ReportShowType	 /// 报告显示类型 
		
		}
		
		s obj.Code = eobj.Code	//代码
		s obj.CName = eobj.CName	//名称
		s obj.HospitalDR=eobj.HospitalDR	//医院
		s obj.EName = eobj.EName	//英文名称
		s obj.Description = eobj.Description	//描述
		
		s obj.HISCode=eobj.HISCode	//HIS 对照码
		s obj.SpeciesDR=eobj.SpeciesDR	//适合性别
		s obj.Urgent = eobj.Urgent	//允许急诊
		s obj.SpecimenDR=eobj.SpecimenDR	//默认标本类型
		s obj.ContainerDR=eobj.ContainerDR	//默认容器
		
		s obj.MergeType = eobj.MergeType	//默认条码数量
		s obj.WorkGroupMachineDR=eobj.WorkGroupMachineDR	//默认工作小组
		s obj.CostItemDR=eobj.CostItemDR	//收费项目

		s obj.CollectPromptDR=eobj.CollectPromptDR	//采集提示
		s obj.ReportPromptDR=eobj.ReportPromptDR	//取报告提示
					        
		s obj.Sequence = eobj.Sequence	//序号
		s obj.Active = eobj.Active	//激活
		s obj.ReportType = eobj.ReportType	/// 报告类型  {N:普通,P:模板}
		s obj.LinkStr = eobj.LinkStr
		s obj.LinkType = eobj.LinkType		        
		
		s obj.WorkGroupDR=eobj.WorkGroupDR	//医嘱所属工作组
		s obj.ExtraFlag = eobj.ExtraFlag	//附加处理
		s obj.ReportRemark = eobj.ReportRemark	//报告说明
		s obj.MICDefDrugRule = eobj.MICDefDrugRule	//微生物耐药机制
		s obj.PositiveAlarn = eobj.PositiveAlarn	//阳性报警
		s obj.WorkRatio = eobj.WorkRatio	//测试数
		s obj.ReportShowType=eobj.ReportShowType
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSet","dbo.BTTestSet","项目组合套",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSet","dbo.BTTestSet","项目组合套",id,eobj.CName,"U",eobj,bobj)
			
			//同时修改关联标本类型
			if (eobj.SpecimenDR'="")
			{
				s TSSRowID=$o(^dbo.BTTestSetSpecimenI("IndexMaster",id,eobj.SpecimenDR,0))
				s teobj = ##class(web.Entity.LAB.BTTestSetSpecimen).%New()
				if (TSSRowID="")
				{
				    s teobj.TestSetDR=id			// 项目组合套
					s teobj.SpecimenDR=eobj.SpecimenDR		// 标本类型
					s teobj.ContainerDR=eobj.ContainerDR		// 采集容器
					s teobj.IsDefault="1"			// 默认
				}
				else
				{
					s tobj=##class(dbo.BTTestSetSpecimen).%OpenId(TSSRowID)
					s teobj.RowID=TSSRowID					// RowID
				    s teobj.TestSetDR=tobj.TestSetDR			// 项目组合套
					s teobj.SpecimenDR=eobj.SpecimenDR			// 标本类型
					s teobj.ContainerDR=eobj.ContainerDR		// 采集容器
					s teobj.MergeType=tobj.MergeType			// 合管类型
					s teobj.IsDefault="1"					// 默认
					s teobj.Sequence=tobj.Sequence			// 序号
				}
				d ##class(web.DHCBL.LAB.BTTestSetSpecimen).SaveEntity(teobj)
			}
			//如果修改时去掉已有的默认标本类型，把关联标本类型里的默认勾选去掉
			if (eobj.RowID'="")&&(eobj.SpecimenDR="")&&(bobj.SpecimenDR'="")
			{
				s TSSRowID=$o(^dbo.BTTestSetSpecimenI("IndexMaster",id,eobj.SpecimenDR,0))
				if (TSSRowID'="")
				{
					s tobj=##class(dbo.BTTestSetSpecimen).%OpenId(TSSRowID)
					s tobj.IsDefault=0
					s tsc=tobj.%Save()
					d tobj.%Close()
				}
			}
			
			//同时修改关联工作小组
			if (eobj.WorkGroupMachineDR'="")
			{
				s TSWGMRowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",id,eobj.WorkGroupMachineDR,0))
				s teobj = ##class(web.Entity.LAB.BTTestSetWorkGroupMachine).%New()
				if (TSWGMRowID="")
				{
					s teobj.TestSetDR = id
					s teobj.WorkGroupMachineDR = eobj.WorkGroupMachineDR
					s teobj.IsDefault="1"
				}
				else
				{
					s tobj=##class(dbo.BTTestSetWorkGroupMachine).%OpenId(TSWGMRowID)
					s teobj.RowID=TSWGMRowID
					s teobj.TestSetDR = tobj.TestSetDR
					s teobj.WorkGroupMachineDR = eobj.WorkGroupMachineDR
					s teobj.IsDefault= "1"
					s teobj.Active = tobj.Active
					s teobj.Sequence = tobj.Sequence
					d tobj.%Close()
				}
				d ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).SaveEntity(teobj)
			}
			//如果修改时去掉已有的默认工作小组，把关联工作小组里的默认勾选去掉
			if (eobj.RowID'="")&&(eobj.WorkGroupMachineDR="")&&(bobj.WorkGroupMachineDR'="")
			{
				s TSWGMRowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",id,bobj.WorkGroupMachineDR,0))
				if (TSWGMRowID'="")
				{
					s tobj=##class(dbo.BTTestSetWorkGroupMachine).%OpenId(TSWGMRowID)
					s tobj.IsDefault=0
					s tsc=tobj.%Save()
					d tobj.%Close()
				}
			}
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("项目组合套","web.DHCBL.LAB.BTTestSet","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-1-17
/// Description:通过项目组合套代码获取项目组合套rowid
/// w ##class(web.DHCBL.LAB.BTTestSet).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestSetD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTTestSetD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q RowID
}

}
