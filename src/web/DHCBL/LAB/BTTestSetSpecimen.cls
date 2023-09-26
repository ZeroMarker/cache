/// 名称:项目组合套界面-关联标本类型窗口
/// 描述:包含增删改查等功能
/// 编写者:基础数据平台-李可凡
/// 编写日期: 2020-9-17
Class web.DHCBL.LAB.BTTestSetSpecimen Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：查询关联标本类型表
/// Table：dbo.BT_TestSetSpecimen
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetSpecimen","GetList","","","")
Query GetList(rowid As %String, testsetdr As %String, specimendr As %String) As %Query(ROWSPEC = "RowID,TestSetDR,SpecimenDR,ContainerDR,MergeType,IsDefault,Sequence")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, testsetdr As %String, specimendr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	if (rowid'="")
	{
		s RowID=rowid
		s TestSetDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),2)		//项目组合套
		s SpecimenDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),3)		//标本类型
		s ContainerDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),4)		//采集容器
		s MergeType=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),5)		//默认条码数量
		s IsDefault=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),6)		//默认
		s Sequence=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),7)		//序号
		s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)			//项目组合套名称
		s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)		//标本类型内部名称
		s:ContainerDR'="" ContainerDR=$lg($g(^dbo.BTContainerD(ContainerDR)),3)		//采集容器名称
		s IsDefault=$CASE(IsDefault,"1":"Y",:"N")
		d OutputRow
	}
	else
	{
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTTestSetSpecimenD(RowID)) q:RowID=""
			s TestSetDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),2)		//项目组合套
			s SpecimenDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),3)		//标本类型
			s ContainerDR=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),4)		//采集容器
			s MergeType=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),5)		//默认条码数量
			s IsDefault=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),6)		//默认
			s Sequence=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),7)		//序号
			s textTestSetDR=TestSetDR
			s textSpecimenDR=SpecimenDR
			s textContainerDR=ContainerDR
			s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)			//项目组合套名称
			s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)		//标本类型内部名称
			s:ContainerDR'="" ContainerDR=$lg($g(^dbo.BTContainerD(ContainerDR)),3)		//采集容器名称
			s IsDefault=$CASE(IsDefault,"1":"Y",:"N")
			if ((textTestSetDR=testsetdr)||(testsetdr=""))&&((textSpecimenDR=specimendr)||(specimendr=""))
			{
				d OutputRow
			}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID,TestSetDR,SpecimenDR,ContainerDR,MergeType,IsDefault,Sequence)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：Form表单查询关联标本类型表
/// Table：dbo.BT_TestSetSpecimen
/// Input：id
/// Others：w ##class(web.DHCBL.LAB.BTTestSetSpecimen).OpenData("238")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(dbo.BTTestSetSpecimen).%OpenId(id)
	 s eobj = ##class(web.Entity.LAB.BTTestSetSpecimen).%New()
	 s eobj.RowID = id						// RowID
	 s eobj.TestSetDR=obj.TestSetDR			// 项目组合套
	 s eobj.SpecimenDR= obj.SpecimenDR		// 标本类型
	 s eobj.ContainerDR=obj.ContainerDR		// 采集容器
	 s eobj.MergeType=obj.MergeType			// 默认条码数量
	 s eobj.IsDefault=obj.IsDefault			// 默认
	 s eobj.Sequence=obj.Sequence			// 序号
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：删除关联标本类型表
/// Table：dbo.BT_TestSetSpecimen
/// Others：w ##class(web.DHCBL.LAB.BTTestSetSpecimen).DeleteData(238)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(dbo.BTTestSetSpecimen).%OpenId(id)
		s pobj = ##class(web.Entity.LAB.BTTestSetSpecimen).%New()
		s pobj.RowID = id						// RowID
		s pobj.TestSetDR=obj.TestSetDR			// 项目组合套
		s pobj.SpecimenDR= obj.SpecimenDR		// 标本类型
		s pobj.ContainerDR=obj.ContainerDR		// 采集容器
		s pobj.MergeType=obj.MergeType			// 默认条码数量
		s pobj.IsDefault=obj.IsDefault			// 默认
		s pobj.Sequence=obj.Sequence			// 序号
		TSTART
		s sc=##class(dbo.BTTestSetSpecimen).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			
			//如果是删除默认标本类型，则同时修改项目组合套的默认标本类型为空
			if (pobj.IsDefault=1)&&(pobj.TestSetDR'="")
			{
				s obj4=##class(dbo.BTTestSet).%OpenId(pobj.TestSetDR)
				s obj4.SpecimenDR=""		//默认标本类型
				s obj4.ContainerDR=""		//默认容器
				s sc4=obj4.%Save()
				d obj4.%Close()
			}
			
			s result="{success:'true',info:'删除成功！'}"
			s:pobj.TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(pobj.TestSetDR)),3)			//项目组合套名称
			s:pobj.SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(pobj.SpecimenDR)),3)		//标本类型内部名称
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetSpecimen","dbo.BTTestSetSpecimen","关联标本类型",id,TestSetDR_"-"_SpecimenDR,"D",pobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：数据重复校验
/// Table：dbo.BT_TestSetSpecimen
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSetSpecimen).FormValidate("1","1","1")
ClassMethod FormValidate(id As %String, testsetdr As %String, specimendr As %String) As %String
{
	s flag=0
	if (testsetdr'="")&&(specimendr'="")
	{
		s RowID=$o(^dbo.BTTestSetSpecimenI("IndexMaster",testsetdr,specimendr,0))
		s:(RowID'="")&&(RowID'=id) flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// function:关联标本类型表的新增修改
/// Table：dbo.BT_TestSetSpecimen
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSetSpecimen) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s eobj.IsDefault=$CASE(eobj.IsDefault,"Y":"1","true":"1","1":"1",:"0")
		s flag=..FormValidate(eobj.RowID,eobj.TestSetDR,eobj.SpecimenDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTTestSetSpecimen).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestSetSpecimen).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTTestSetSpecimen).%New()
		    s bobj.RowID=eobj.RowID			// RowID
		    s bobj.TestSetDR=obj.TestSetDR			// 项目组合套
			s bobj.SpecimenDR=obj.SpecimenDR		// 标本类型
			s bobj.ContainerDR=obj.ContainerDR		// 采集容器
			s bobj.MergeType=obj.MergeType			// 默认条码数量
			s bobj.IsDefault=obj.IsDefault			// 默认
			s bobj.Sequence=obj.Sequence			// 序号
		}
		s obj.TestSetDR=eobj.TestSetDR			// 项目组合套
		s obj.SpecimenDR=eobj.SpecimenDR		// 标本类型
		s obj.ContainerDR=eobj.ContainerDR		// 采集容器
		s obj.MergeType=eobj.MergeType			// 默认条码数量
		s obj.IsDefault=eobj.IsDefault			// 默认
		s obj.Sequence=eobj.Sequence			// 序号
		TSTART
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			
			//关联标本类型的默认数据需和项目组合套的默认标本类型字段保持一直
			if (eobj.TestSetDR'="")
			{
				//只能有一个默认，改为默认时，需把其他默认的勾选去掉
				if (eobj.IsDefault=1)
				{
					s SpecimenDR=0
					for
					{
						s SpecimenDR=$o(^dbo.BTTestSetSpecimenI("IndexMaster",eobj.TestSetDR,SpecimenDR)) q:SpecimenDR=""
						continue:eobj.SpecimenDR=SpecimenDR
						s RowID=$o(^dbo.BTTestSetSpecimenI("IndexMaster",eobj.TestSetDR,SpecimenDR,0))
						s IsDefault=$lg($g(^dbo.BTTestSetSpecimenD(RowID)),6)
						if (IsDefault'=0)
						{
							s obj2=##class(dbo.BTTestSetSpecimen).%OpenId(RowID)
							s obj2.IsDefault=0
							s sc2=obj2.%Save()
							d obj2.%Close()
						}
					}
					//判断项目组合套默认标本类型是否和关联标本类型表一致，不一致则修改一致
					if (eobj.SpecimenDR'="")
					{
						s SpecimenDR=$lg($g(^dbo.BTTestSetD(eobj.TestSetDR)),10)	//默认标本类型
						s ContainerDR= $lg($g(^dbo.BTTestSetD(eobj.TestSetDR)),11)		//默认容器
						if (SpecimenDR'=eobj.SpecimenDR)||(ContainerDR'=eobj.ContainerDR)
						{
							s obj3=##class(dbo.BTTestSet).%OpenId(eobj.TestSetDR)
							s obj3.SpecimenDR=eobj.SpecimenDR		//默认标本类型
							s obj3.ContainerDR=eobj.ContainerDR		//默认容器
							s sc3=obj3.%Save()
							d obj3.%Close()
						}
					}
				}
				elseif (eobj.IsDefault=0)&&(eobj.RowID'="")&&(bobj.IsDefault=1)	//去掉默认勾选，需同步修改项目组合套的默认字段
				{
					s obj4=##class(dbo.BTTestSet).%OpenId(eobj.TestSetDR)
					s obj4.SpecimenDR=""		//默认标本类型
					s obj4.ContainerDR=""		//默认容器
					s sc4=obj4.%Save()
					d obj4.%Close()
				}
			}
			
			s:eobj.TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(eobj.TestSetDR)),3)			//项目组合套名称
			s:eobj.SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(eobj.SpecimenDR)),3)		//标本类型内部名称
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetSpecimen","dbo.BTTestSetSpecimen","关联标本类型",id,TestSetDR_"-"_SpecimenDR,"U",eobj,bobj)
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetSpecimen","dbo.BTTestSetSpecimen","关联标本类型",id,TestSetDR_"-"_SpecimenDR,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		k obj
		k eobj
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：判断项目组合套默认标本类型是否和关联标本类型表一致，不一致则修改一致
/// Table：dbo.BT_TestSet
/// Input:项目组合套id，标本类型id，采集容器id
/// Other:w ##class(web.DHCBL.LAB.BTTestSetSpecimen).SaveDefSpecimen()
ClassMethod SaveDefSpecimen(testsetdr, specimendr, containerdr) As %String
{
	s re=""
	if (testsetdr'="")&&(specimendr'="")
	{
		s SpecimenDR=$lg($g(^dbo.BTTestSetD(testsetdr)),10)	//默认标本类型
		if (SpecimenDR'=specimendr)
		{
			s obj=##class(dbo.BTTestSet).%OpenId(testsetdr)
			s obj.SpecimenDR=specimendr		//默认标本类型
			s obj.ContainerDR=containerdr	//默认容器
			s sc=obj.%Save()
			d obj.%Close()
			s re=sc
		}
	}
	q re
}

}
