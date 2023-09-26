/// 名称:标准版检验-项目组合套关联工作小组
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-5
Class web.DHCBL.LAB.BTTestSetWorkGroupMachine Extends %RegisteredObject
{

/// Creator：钟荣枫		
/// CreatDate: 2019-11-5
/// Description：查询 项目组合套关联工作小组
/// Table：dbo.BT_TestSetWorkGroupMachine
/// Input：RowID, code ,desc,hospital,active
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetWorkGroupMachine","GetList","","","")
Query GetList(rowid As %String, testsetdr As %String, workgroupmachinedr As %String) As %Query(ROWSPEC = "RowID,TestSetDR,WorkGroupMachineDR,Sequence,Active,AlowedPrint,IsDefault")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, testsetdr As %String, workgroupmachinedr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
			
		s TestSetDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),2)		//项目组合套
		s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)	//项目组合套描述
		s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),3)		//工作小组
		s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//工作小组描述
		s IsDefault= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),4)		//默认
		
		s Sequence= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),5)		//序号
		s Active= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),6)			//激活
		s:Active="" Active=1
		s AlowedPrint= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),7)		

		d OutputRow
		
	}
	else
	{
		s RowID=0
		k ^tempsequencesort("dbo.BTTestSetWorkGroupMachine")
		for 
		{
			s RowID=$o(^dbo.BTTestSetWorkGroupMachineD(RowID))
			q:RowID=""
			s TestSetDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),2)		//项目组合套
			continue:(testsetdr'="")&&(testsetdr'=TestSetDR)
			s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)	//项目组合套描述
			s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),3)		//工作小组
			continue:(workgroupmachinedr'="")&&(workgroupmachinedr'=WorkGroupMachineDR)
			s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//工作小组描述
			s IsDefault= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),4)		//默认
			
			s Sequence= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),5)		//序号
			s Active= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),6)			//激活
			s:Active="" Active=1
			s AlowedPrint= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),7)
			
			s:Sequence="" Sequence=" "_Sequence
			s ^tempsequencesort("dbo.BTTestSetWorkGroupMachine",Sequence,RowID)=RowID
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTTestSetWorkGroupMachine",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{

				s RowIDSort=$o(^tempsequencesort("dbo.BTTestSetWorkGroupMachine",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s TestSetDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),2)		//项目组合套
				s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)	//项目组合套描述
				s WorkGroupMachineDR= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),3)		//工作小组
				s:WorkGroupMachineDR'="" WorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)	//工作小组描述
				s IsDefault= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),4)		//默认
				
				s Sequence= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),5)		//序号
				s Active= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),6)			//激活
				s:Active="" Active=1
				s AlowedPrint= $lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),7)		//测试数
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,TestSetDR,WorkGroupMachineDR,Sequence,Active,AlowedPrint,IsDefault)
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
/// CreatDate: 2019-11-7
/// Description：根据id删除 项目组合套关联工作小组
/// Table：dbo.BT_TestSetWorkGroupMachine
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).DeleteData(156)
ClassMethod DeleteData(id) As %String
{

	s result=""
	s pobj = ##class(dbo.BTTestSetWorkGroupMachine).%OpenId(id)
	s eobj = ##class(web.Entity.LAB.BTTestSetWorkGroupMachine).%New()
	
	s eobj.TestSetDR = pobj.TestSetDR
	s eobj.WorkGroupMachineDR = pobj.WorkGroupMachineDR
	
	s eobj.IsDefault=pobj.IsDefault
	s eobj.Sequence = pobj.Sequence
	s eobj.Active = pobj.Active
	
	s eobj.AlowedPrint = pobj.AlowedPrint
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(dbo.BTTestSetWorkGroupMachine).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		
		//如果是删除默认工作小组，则同时修改项目组合套的默认工作小组为空
		if (eobj.IsDefault=1)&&(eobj.TestSetDR'="")
		{
			s obj4=##class(dbo.BTTestSet).%OpenId(eobj.TestSetDR)
			s obj4.WorkGroupMachineDR=""		//默认工作小组
			s sc4=obj4.%Save()
			d obj4.%Close()
		}
		
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetWorkGroupMachine","dbo.BTTestSetWorkGroupMachine","项目组合套关联工作小组",id,eobj.TestSetDR_"-"_eobj.WorkGroupMachineDR,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("项目组合套关联工作小组","web.DHCBL.LAB.BTTestSetWorkGroupMachine","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-6
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BT_TestSetWorkGroupMachine
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).OpenData(15)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTTestSetWorkGroupMachine).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestSetWorkGroupMachine).%New() 
	s eobj.RowID = id
	s eobj.TestSetDR = pobj.TestSetDR
	s eobj.WorkGroupMachineDR = pobj.WorkGroupMachineDR
	
	s eobj.IsDefault=pobj.IsDefault
	s eobj.Sequence = pobj.Sequence
	s eobj.Active = pobj.Active
	
	s eobj.AlowedPrint = pobj.AlowedPrint
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:钟荣枫 
/// CreatDate:2019-11-6
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_TestSetWorkGroupMachine
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).FormValidate("","","")
ClassMethod FormValidate(id As %String, TestSetDR As %String, WorkGroupMachineDR As %String) As %String
{
	
	s flag=0
	if (TestSetDR'="")&&(WorkGroupMachineDR'="")
	{

		s RowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR,WorkGroupMachineDR,0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2019-11-6
/// Description：保存 项目组合套关联工作小组
/// Input: eobj As web.Entity.LAB.BTTestSet
/// Table：dbo.BT_TestSetWorkGroupMachine
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSetWorkGroupMachine).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSet) As %String
{
	
	s result=""
	
	if $IsObject(eobj)
	{	
		s eobj.Active=1 //$CASE(eobj.Active,"Y":"1","true":"1","1":"1",:"0")	//前台去掉激活的维护，后台自动存1
		s eobj.IsDefault=$CASE(eobj.IsDefault,"Y":"1","true":"1","1":"1",:"0")
		s flag=..FormValidate(eobj.RowID,eobj.TestSetDR,eobj.WorkGroupMachineDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
			
			s obj=##class(dbo.BTTestSetWorkGroupMachine).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestSetWorkGroupMachine).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestSetWorkGroupMachine).%New()
	
			
			s bobj.TestSetDR = obj.TestSetDR
			s bobj.WorkGroupMachineDR = obj.WorkGroupMachineDR
			s bobj.IsDefault=obj.IsDefault
			s bobj.Sequence = obj.Sequence
			s bobj.Active = obj.Active
			s bobj.AlowedPrint = obj.AlowedPrint	
		
		}
		s obj.TestSetDR = eobj.TestSetDR
		s obj.WorkGroupMachineDR = eobj.WorkGroupMachineDR
		s obj.IsDefault=eobj.IsDefault
		s obj.Sequence = eobj.Sequence
		s obj.Active = eobj.Active
		s obj.AlowedPrint = eobj.AlowedPrint
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			
			//关联工作小组的默认数据需和项目组合套的默认工作小组字段保持一直
			if (eobj.TestSetDR'="")
			{
				//只能有一个默认，改为默认时，需把其他默认的勾选去掉
				if (eobj.IsDefault=1)
				{
					s WorkGroupMachineDR=0
					for
					{
						s WorkGroupMachineDR=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",eobj.TestSetDR,WorkGroupMachineDR)) q:WorkGroupMachineDR=""
						continue:eobj.WorkGroupMachineDR=WorkGroupMachineDR
						s RowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",eobj.TestSetDR,WorkGroupMachineDR,0))
						s IsDefault=$lg($g(^dbo.BTTestSetWorkGroupMachineD(RowID)),4)
						if (IsDefault'=0)
						{
							s obj2=##class(dbo.BTTestSetWorkGroupMachine).%OpenId(RowID)
							s obj2.IsDefault=0
							s sc2=obj2.%Save()
							d obj2.%Close()
						}
					}
					//判断项目组合套默认工作小组是否和关联工作小组表一致，不一致则修改一致
					if (eobj.WorkGroupMachineDR'="")
					{
						s WorkGroupMachineDR=$lg($g(^dbo.BTTestSetD(eobj.TestSetDR)),13)		//默认工作小组 
						if (WorkGroupMachineDR'=eobj.WorkGroupMachineDR)
						{
							s obj3=##class(dbo.BTTestSet).%OpenId(eobj.TestSetDR)
							s obj3.WorkGroupMachineDR=eobj.WorkGroupMachineDR		//默认工作小组
							s sc3=obj3.%Save()
							d obj3.%Close()
						}
					}
				}
				elseif (eobj.IsDefault=0)&&(eobj.RowID'="")&&(bobj.IsDefault=1)	//去掉默认勾选，需同步修改项目组合套的默认字段
				{
					s obj4=##class(dbo.BTTestSet).%OpenId(eobj.TestSetDR)
					s obj4.WorkGroupMachineDR=""		//默认工作小组
					s sc4=obj4.%Save()
					d obj4.%Close()
				}
			}
			
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetWorkGroupMachine","dbo.BTTestSetWorkGroupMachine","项目组合套关联工作小组",id,eobj.TestSetDR_"-"_eobj.WorkGroupMachineDR,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetWorkGroupMachine","dbo.BTTestSetWorkGroupMachine","项目组合套关联工作小组",id,eobj.TestSetDR_"-"_eobj.WorkGroupMachineDR,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("项目组合套关联工作小组","web.DHCBL.LAB.BTTestSetWorkGroupMachine","SaveEntity",eobj)
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

}
