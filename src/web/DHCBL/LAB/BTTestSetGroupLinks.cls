/// 名称:标准版检验-组合套分组关联
/// 描述:增删改查
/// 编写者:基础数据平台组 -谢海睿
/// 编写日期: 2019-11-15
Class web.DHCBL.LAB.BTTestSetGroupLinks Extends %RegisteredObject
{

/// Creator：谢海睿 		
/// CreatDate: 2019-11-7
/// Description：查询 组合套分组关联
/// Table:dbo.BTTestSetGroupLinks
/// Input:id, testsetgroupdr, testsetdr
/// Output:RowID,TestSetGroupDR,TestSetDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetGroupLinks","GetList","","7","")
Query GetList(rowid As %String, testsetgroupdr As %String, testsetdr As %String) As %Query(ROWSPEC = "RowID,TestSetGroupDR,TestSetDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, testsetgroupdr As %String, testsetdr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s TestSetGroupDR = $lg($g(^dbo.BTTestSetGroupLinksD(RowID)),2)	// 合管组合套分组 
		s:TestSetGroupDR'="" TestSetGroupDR=$lg($g(^dbo.BTTestSetGroupD(TestSetGroupDR)),3)
		s TestSetDR=$lg($g(^dbo.BTTestSetGroupLinksD(RowID)),3)	// 项目组合套
		s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)	
		d OutputRow
	}
	else
	{
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTTestSetGroupLinksD(RowID)) q:RowID=""
			s TestSetGroupDR=$lg($g(^dbo.BTTestSetGroupLinksD(RowID)),2)
			if (testsetgroupdr'="")
			{
				if (testsetgroupdr'=TestSetGroupDR) 
				{
					continue
				}
			}
			s:TestSetGroupDR'="" TestSetGroupDR=$lg($g(^dbo.BTTestSetGroupD(TestSetGroupDR)),3)	
			
			s TestSetDR=$lg($g(^dbo.BTTestSetGroupLinksD(RowID)),3)
			if (testsetdr'="")
			{
				if (testsetdr'=TestSetDR) 
				{
					continue
				}
			}
			s:TestSetDR'="" TestSetDR=$lg($g(^dbo.BTTestSetD(TestSetDR)),3)	
			
			d OutputRow
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow	
    set Data=$lb(RowID,TestSetGroupDR,TestSetDR)
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

/// Creator：谢海睿
/// CreatDate: 2019-11-26
/// Description：根据id删除 采集容器
/// Table：dbo.BTTestSetGroupLinks
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetGroupLinks).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(dbo.BTTestSetGroupLinks).%OpenId(id)
	s eobj = ##class(web.Entity.LAB.BTTestSetGroupLinks).%New()
	s eobj.TestSetGroupDR = pobj.TestSetGroupDR //各管组合套分组
	s eobj.TestSetDR = pobj.TestSetDR    //检验医嘱（项目组合套）
	d pobj.%Close()
	kill pobj
	
	Tstart
	s sc=##class(dbo.BTTestSetGroupLinks).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetGroupLinks","dbo.BTTestSetGroupLinks","组合套分组关联",id,eobj.TestSetGroupDR_"-"_eobj.TestSetDR,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组合套分组关联","web.DHCBL.LAB.BTTestSetGroupLinks","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:谢海睿
/// CreatDate:2019-11-26
/// Description:数据重复验证方法,js调用
/// Table:dbo.BTTestSetGroupLinks
/// Input:id, code, hosp
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSetGroupLinks).FormValidate("","7","3")
ClassMethod FormValidate(id As %String, TestSetGroupDR As %String, TestSetDR As %String) As %String
{
	s flag = 0
	if (TestSetGroupDR'="")&&(TestSetDR'="")
	{
		s RowID=$o(^dbo.BTTestSetGroupLinksI("IndexMaster",TestSetGroupDR,TestSetDR,0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
		//一条项目组合套数据只能关联一条合管组合套分组数据
		s testsetgroupdr=$o(^dbo.BTTestSetGroupLinksI("IndexTestSet",TestSetDR,0))
		if (testsetgroupdr'="")&&(testsetgroupdr'=TestSetGroupDR)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:谢海睿
/// CreatDate: 2019-11-26
/// Description：保存 合管组合套分组关联
/// Input: eobj As web.Entity.LAB.BTTestSetGroupLinks
/// Table：dbo.BTTestSetGroupLinks
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSetGroupLinks).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSetGroupLinks) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.RowID,eobj.TestSetGroupDR,eobj.TestSetDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
			s obj=##class(dbo.BTTestSetGroupLinks).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestSetGroupLinks).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestSetGroupLinks).%New()
			s bobj.RowID = eobj.RowID
			s bobj.TestSetGroupDR = obj.TestSetGroupDR   //合管组合套分组
			s bobj.TestSetDR = obj.TestSetDR			//检验医嘱（项目组合套）
		}
		s obj.TestSetGroupDR= eobj.TestSetGroupDR
		s obj.TestSetDR  = eobj.TestSetDR
		       
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetGroupLinks","dbo.BTTestSetGroupLinks","组合套分组关联",id,eobj.TestSetGroupDR _"-"_eobj.TestSetDR,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetGroupLinks","dbo.BTTestSetGroupLinks","组合套分组关联",id,eobj.TestSetGroupDR _"-"_eobj.TestSetDR,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组合套分组关联","web.DHCBL.LAB.BTTestSetGroupLinks","SaveEntity",eobj)
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

/// Creator:谢海睿
/// CreatDate: 2019-12-2
/// Description：关联
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s TestSetGroupDR=$p(ids,"^",1) //rowid
    s TestSetDR=$p(ids,"^",2) //hisrowid
	s flag=..FormValidate("",TestSetGroupDR,TestSetDR) 
	if (flag=1)
	{
		q "{success:'false',errorinfo:'该关联已经存在！'}"
	}	
	
	s obj=##class(dbo.BTTestSetGroupLinks).%New()
	s obj.TestSetDR = TestSetDR     //检验医嘱（项目组合套）
	s obj.TestSetGroupDR = TestSetGroupDR //合管组合套分组
	s logJson="{TestSetDR:"_$c(34)_TestSetDR_$c(34)_",TestSetGroupDR:"_$c(34)_TestSetGroupDR_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("dbo.BT_TestSetGroupLinks","dbo.BTTestSetGroupLinks","组合套分组关联",id,TestSetGroupDR_"-"_TestSetDR,"A",logJson)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组合套分组关联","web.DHCBL.LAB.BTTestSetGroupLinks","SaveData",logJson)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	q result
}

}
