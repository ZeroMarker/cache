/// 名称:标准版检验-合报告分组关联
/// 描述:对合报告分组关联信息的增删改查
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2020-4-16
Class web.DHCBL.LAB.BTTestSetOGTTGroupLinks Extends %RegisteredObject
{

/// Creator：钟荣枫		
/// CreatDate: 2020-4-16
/// Description：查询 合报告分组关联
/// Table:dbo.BTTestSetOGTTGroupLinks		合报告分组关联
/// Input:id, otttgroup 组合套组, maintestset 主组合套,subtestset 子组合套
/// Output:RowID,TestSetOGTTGroupDR 组合套组,MainTestSetDR 主组合套,SubTestSetDR 子组合套,Sequence 序号
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetOGTTGroupLinks","GetList","","","","")
Query GetList(rowid As %String, otttgroup As %String, maintestset As %String, subtestset As %String) As %Query(ROWSPEC = "RowID,TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR,Sequence,TestSetOGTTGroupDesc,MainTestSetDesc,SubTestSetDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, otttgroup As %String, maintestset As %String, subtestset As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s TestSetOGTTGroupDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)	//组合套组
		s TestSetOGTTGroupDesc=""
		s:TestSetOGTTGroupDR'="" TestSetOGTTGroupDesc= $lg($g(^dbo.BTTestSetOGTTGroupD(TestSetOGTTGroupDR)),3)	//组合套组描述	
		s MainTestSetDR = $lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),3)	// 主组合套 
		s MainTestSetDesc=""
		s:MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(MainTestSetDR)),3)	//主组合套描述
		s SubTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),4)	// 子组合套
		s SubTestSetDesc=""
		s:SubTestSetDR'="" SubTestSetDesc=$lg($g(^dbo.BTTestSetD(SubTestSetDR)),3)	//子组合套描述
		s Sequence=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),5)	//序号
		d OutputRow
		
	}
	else	//循环查询
	{
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTTestSetOGTTGroupLinksD(RowID)) q:RowID=""
			
			s TestSetOGTTGroupDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)	//组合套组
			if (otttgroup'="")&&(otttgroup'=TestSetOGTTGroupDR) 	//过滤组合套组
			{
				continue
			}
			s TestSetOGTTGroupDesc=""
			s:TestSetOGTTGroupDR'="" TestSetOGTTGroupDesc= $lg($g(^dbo.BTTestSetOGTTGroupD(TestSetOGTTGroupDR)),3)	//组合套组描述	
			s MainTestSetDR = $lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),3)	// 主组合套 
			if (maintestset'="")&&(maintestset'=MainTestSetDR) 	//过滤主组合套
			{
				continue
			}
			s MainTestSetDesc=""
			s:MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(MainTestSetDR)),3)	//主组合套描述
			s SubTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),4)	// 子组合套
			if (subtestset'="")&&(subtestset'=SubTestSetDR) 	//过滤子组合套
			{
				continue
			}
			s SubTestSetDesc=""
			s:SubTestSetDR'="" SubTestSetDesc=$lg($g(^dbo.BTTestSetD(SubTestSetDR)),3)	//子组合套描述
			s Sequence=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),5)	//序号
			
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow	
    set Data=$lb(RowID,TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR,Sequence,TestSetOGTTGroupDesc,MainTestSetDesc,SubTestSetDesc)
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
/// CreatDate: 2020-4-16
/// Description：修改 合报告分组关联 同一组合套组的所有数据的主组合套
/// Table：dbo.BTTestSetOGTTGroupLinks 合报告分组关联
/// Input：TestSetOGTTGroupDR 组合套组，MainTestSetDR 主组合套
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).ChangeMaintestSet("5","35")
ClassMethod ChangeMaintestSet(TestSetOGTTGroupDR, MainTestSetDR)
{
	s result=""
	s errorflag=""
	ts
	s RowID=0
	for
	{
		s RowID=$o(^dbo.BTTestSetOGTTGroupLinksD(RowID)) q:RowID=""
		
		s TestSetOGTTGroup=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)	//组合套组
		continue:(TestSetOGTTGroup'=TestSetOGTTGroupDR)
		s SubTestSet=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),4)	// 子组合套
		s Sequence=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),5)		//序号
		//循环修改关联表数据
		s eobj= ##class(web.Entity.LAB.BTTestSetOGTTGroupLinks).%New()
		s eobj.RowID=RowID
		s eobj.TestSetOGTTGroupDR=TestSetOGTTGroupDR	//组合套组
		s eobj.MainTestSetDR=MainTestSetDR		//主组合套
		
		
		s eobj.SubTestSetDR=SubTestSet	//子组合套
		s eobj.Sequence=Sequence	//序号
		s result= ..SaveEntity(eobj)
		if (result["false")		//单条数据修改失败
		{
			s errorflag=1
			q 
		}
	}
	if (errorflag=1)	//修改失败
	{
		tro	
		q result
	}
	else	//修改成功
	{
		tc
		s result= ..UpdateOGTTGroup(TestSetOGTTGroupDR,MainTestSetDR)	//修改主表  主组合套	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-4-16
/// Description：删除某个组合套组下的所有关联
/// Table：dbo.BTTestSetOGTTGroupLinks 合报告分组关联
/// Input：TestSetOGTTGroupDR 组合套组
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).DeleteLinkData(27)
ClassMethod DeleteAllLinkData(TestSetOGTTGroupDR) As %String
{
	s RowID=0
	s result=""
	s errorflag=0
	ts
	for
	{
		s RowID=$o(^dbo.BTTestSetOGTTGroupLinksD(RowID)) q:RowID=""
		
		s TestSetOGTTGroup=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)	//组合套组
		continue:(TestSetOGTTGroup'=TestSetOGTTGroupDR)
		
		s result= ..DeleteData(RowID)	//删除数据
		if (result["false")		//单条数据删除失败
		{
			s errorflag=1
			q 
		}
	}
	if (errorflag=1)	//删除失败
	{
		tro	
		q result
	}
	else	//删除成功
	{
		tc
		s result= ..UpdateOGTTGroup(TestSetOGTTGroupDR, "")	//同步修改父表	
	}
	
	q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-4-16
/// Description：根据id删除 合报告分组关联	前台已判断是否最后一条关联即主组合套 是 允许删除 否 不允许删除
/// Table：dbo.BTTestSetOGTTGroupLinks 合报告分组关联
/// Input：id  合报告分组关联id
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(dbo.BTTestSetOGTTGroupLinks).%OpenId(id)
	s eobj = ##class(web.Entity.LAB.BTTestSetOGTTGroupLinks).%New()
	s eobj.TestSetOGTTGroupDR = pobj.TestSetOGTTGroupDR //组合套组
	s eobj.MainTestSetDR = pobj.MainTestSetDR    //主组合套
	s eobj.SubTestSetDR = pobj.SubTestSetDR    //子组合套
 	s eobj.Sequence=pobj.Sequence	//序号

	s TestSetOGTTGroupDesc="",MainTestSetDesc="",SubTestSetDesc=""
	s:eobj.TestSetOGTTGroupDR'="" TestSetOGTTGroupDesc= $lg($g(^dbo.BTTestSetOGTTGroupD(eobj.TestSetOGTTGroupDR)),3)	//组合套组描述	
	s:eobj.MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(eobj.MainTestSetDR)),3)	//主组合套描述
	s:eobj.SubTestSetDR'="" SubTestSetDsc=$lg($g(^dbo.BTTestSetD(eobj.SubTestSetDR)),3)	//子组合套描述
	s eobj.Sequence = pobj.Sequence    //序号
	d pobj.%Close()
	kill pobj
	
	Tstart
	s sc=##class(dbo.BTTestSetOGTTGroupLinks).%DeleteId(id)
	IF $$$ISOK(sc)	//删除成功
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroupLinks","dbo.BTTestSetOGTTGroupLinks","合报告分组关联",id,TestSetOGTTGroupDesc_"-"_MainTestSetDesc_"-"_SubTestSetDsc,"D",eobj)
	}
	else	//删除失败
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合报告分组关联","web.DHCBL.LAB.BTTestSetOGTTGroupLinks","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2019-11-26
/// Description:数据重复验证方法,js调用
/// Table:dbo.BTTestSetOGTTGroupLinks
/// Input:id, TestSetOGTTGroupDR 组合套组, MainTestSetDR 主组合套，SubTestSetDR 子组合套
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).FormValidate("","3","6","3")
ClassMethod FormValidate(id As %String, TestSetOGTTGroupDR As %String, MainTestSetDR As %String, SubTestSetDR As %String) As %String
{
	s flag = 0
	//组合套组、主组合套、子组合套不为空
	if (TestSetOGTTGroupDR'="")&&(MainTestSetDR'="")&&(SubTestSetDR'="")
	{
		s idsub=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexMaster",SubTestSetDR,0))
		s idsubtest=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",SubTestSetDR,TestSetOGTTGroupDR,0))
		s RowID=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexTestSetOGTTGroupDR",TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR,0))
		//重复
		if ((idsub'="")&&(id'=idsub))||((idsubtest'="")&&(id'=idsubtest))||((RowID'="")&&(id'=RowID))		//数据重复
		{
			s flag = 1
		}
		
	}
	q flag
}

/// Creator：钟荣枫
/// CreatDate: 2020-4-16
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BTTestSetOGTTGroupLinks  合管合报告分组关联
/// Input：id 关联id
/// Return:JSON字符串 如 {list:[{"MainTestSetDR":"1","RowID":"14","Sequence":"","SubTestSetDR":"6","TestSetOGTTGroupDR":"2"}]}
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).OpenData(2)
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
	s pobj = ##class(dbo.BTTestSetOGTTGroupLinks).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestSetOGTTGroupLinks).%New() 
	s eobj.RowID = id
	s eobj.TestSetOGTTGroupDR = pobj.TestSetOGTTGroupDR //组合套组
	s eobj.MainTestSetDR = pobj.MainTestSetDR    //主组合套
	s eobj.SubTestSetDR = pobj.SubTestSetDR    //子组合套
	s eobj.Sequence = pobj.Sequence    //序号
	s str = eobj.JsonS()
	d eobj.%Close()
	if (RetFlag'="JSON")	//RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:钟荣枫
/// CreatDate: 2020-4-16
/// Description：保存 合管合报告分组关联
/// Input: eobj As web.Entity.LAB.BTTestSetOGTTGroupLinks
/// Table：dbo.BTTestSetOGTTGroupLinks  合管合报告分组关联
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSetOGTTGroupLinks) As %String
{
	s result=""
	if $IsObject(eobj)		//对象存在
	{	
		s flag=..FormValidate(eobj.RowID,eobj.TestSetOGTTGroupDR,eobj.MainTestSetDR,eobj.SubTestSetDR)  //调用重复验证
		if (flag=1)		//重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s TestSetOGTTGroupDesc="",MainTestSetDesc="",SubTestSetDesc=""
		s:eobj.TestSetOGTTGroupDR'="" TestSetOGTTGroupDesc= $lg($g(^dbo.BTTestSetOGTTGroupD(eobj.TestSetOGTTGroupDR)),3)	//组合套组描述	
		s:eobj.MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(eobj.MainTestSetDR)),3)	//主组合套描述
		s:eobj.SubTestSetDR'="" SubTestSetDsc=$lg($g(^dbo.BTTestSetD(eobj.SubTestSetDR)),3)	//子组合套描述
		if (eobj.RowID="")		//新增
		{	
			s obj=##class(dbo.BTTestSetOGTTGroupLinks).%New()
		}
		else		//修改
		{
			s obj=##class(dbo.BTTestSetOGTTGroupLinks).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestSetOGTTGroupLinks).%New()
			s bobj.RowID = eobj.RowID
			
			s bobj.TestSetOGTTGroupDR = obj.TestSetOGTTGroupDR //组合套组
			s bobj.MainTestSetDR = obj.MainTestSetDR    //主组合套
			s bobj.SubTestSetDR = obj.SubTestSetDR    //子组合套
			s bobj.Sequence = obj.Sequence    //序号
		}
		
		s obj.TestSetOGTTGroupDR = eobj.TestSetOGTTGroupDR //组合套组
		s obj.MainTestSetDR = eobj.MainTestSetDR    //主组合套
		s obj.SubTestSetDR = eobj.SubTestSetDR    //子组合套
		s obj.Sequence = eobj.Sequence    //序号
		       
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)		//保存成功
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroupLinks","dbo.BTTestSetOGTTGroupLinks","合报告分组关联",id,TestSetOGTTGroupDesc_"-"_MainTestSetDesc_"-"_SubTestSetDsc,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroupLinks","dbo.BTTestSetOGTTGroupLinks","合报告分组关联",id,TestSetOGTTGroupDesc_"-"_MainTestSetDesc_"-"_SubTestSetDsc,"U",eobj,bobj)
		}
		else			//保存失败
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合报告分组关联","web.DHCBL.LAB.BTTestSetOGTTGroupLinks","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else			//对象不存在
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate: 2020-4-22
/// Description：修改合报告分组的主组合套
/// Return：成功返回true，失败返回false
/// Input: id  ,MainTestSetDR
/// Table：dbo.BTTestSetOGTTGroup  合报告分组
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).UpdateOGTTGroup("3","3")
ClassMethod UpdateOGTTGroup(id As %String, MainTestSetDR As %String) As %String
{
	s result=""
	//修改合报告分组
    s obj=##class(dbo.BTTestSetOGTTGroup).%OpenId(id) 
    s oldMainTestSetDR=obj.MainTestSetDR
    s obj.MainTestSetDR=MainTestSetDR		//主组合套
   	s CName=obj.CName	//合报告分组描述
   	
    Ts
	s sc=obj.%Save()
	d obj.%Close()
	s OldJsonStr="{描述:"_$c(34)_CName_$c(34)_",主组合套:"_oldMainTestSetDR_"}"		
	s JsonStr="{描述:"_$c(34)_CName_$c(34)_",主组合套:"_MainTestSetDR_"}"	
	If $$$ISOK(sc)	//保存成功
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("dbo.BT_TestSetOGTTGroup","dbo.BTTestSetOGTTGroup","合报告分组",id,CName,"U",JsonStr,OldJsonStr)	
	}
	else	//保存失败
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合报告分组","web.DHCBL.LAB.BTTestSetOGTTGroupLinks","SaveLinkDatas",JsonStr)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate: 2020-4-22
/// Description：合报告分组关联	新增第一条关联数据时，设为主组合套，同步修改主表主组合套数据
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Input: TestSetOGTTGroupDR 合报告分组,SubTestSetDR 子组合套
/// Table：dbo.BTTestSetOGTTGroupLinks  合报告分组关联
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).SaveLinkDatas("2","21","0")
ClassMethod SaveLinkDatas(TestSetOGTTGroupDR As %String, SubTestSetDR As %String, firstflag As %String) As %String
{
	s result = ""
    
    if (firstflag=1)	//判断是否是分组下的第一条关联数据	 //是，则设为主组合套，同步修改主表主组合套数据
    {
	    s MainTestSetDR=SubTestSetDR
	    s result=..SaveData(TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR)	//保存关联
	    
	    d ..UpdateOGTTGroup(TestSetOGTTGroupDR,MainTestSetDR)	//修改主表	
    }
    else	    //若不是，照常新增
    {
	    s MainTestSetDR=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexTestSetOGTTGroupDR",TestSetOGTTGroupDR,0))
	    s result= ..SaveData(TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR)		//保存关联数据
    }
    q result
}

/// Creator:钟荣枫
/// CreatDate: 202-4-22
/// Description：合报告分组关联
/// Input:  TestSetOGTTGroupDR 组合套组,MainTestSetDR 主组合套,SubTestSetDR 子组合套
/// Table：dbo.BTTestSetOGTTGroupLinks  合报告分组关联
/// Return：成功返回success:'true'和新增的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).SaveData("2","1","3")
ClassMethod SaveData(TestSetOGTTGroupDR As %String, MainTestSetDR As %String, SubTestSetDR As %String) As %String
{
	s result = ""
	//主组合套
	s:MainTestSetDR="" MainTestSetDR=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexTestSetOGTTGroupDR",TestSetOGTTGroupDR,0))

	s flag=..FormValidate("",TestSetOGTTGroupDR,MainTestSetDR,SubTestSetDR) 
	if (flag=1)			//关联已经存在
	{
		q "{success:'false',errorinfo:'该关联已经存在！'}"
	}	
	
	s obj=##class(dbo.BTTestSetOGTTGroupLinks).%New()
	s obj.TestSetOGTTGroupDR=TestSetOGTTGroupDR	//组合套组
	s obj.MainTestSetDR=MainTestSetDR	//主组合套
	s obj.SubTestSetDR=SubTestSetDR		//子组合套
	s TestSetOGTTGroupDesc="",MainTestSetDesc="",SubTestSetDesc=""
	s:obj.TestSetOGTTGroupDR'="" TestSetOGTTGroupDesc= $lg($g(^dbo.BTTestSetOGTTGroupD(obj.TestSetOGTTGroupDR)),3)	//组合套组描述	
	s:obj.MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(obj.MainTestSetDR)),3)	//主组合套描述
	s:obj.SubTestSetDR'="" SubTestSetDsc=$lg($g(^dbo.BTTestSetD(obj.SubTestSetDR)),3)	//子组合套描述
	
	s logJson="{TestSetOGTTGroupDR:"_$c(34)_TestSetOGTTGroupDR_$c(34)_",MainTestSetDR:"_$c(34)_MainTestSetDR_$c(34)_",SubTestSetDR:"_$c(34)_SubTestSetDR_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)	//保存成功
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("dbo.BT_TestSetOGTTGroupLinks","dbo.BTTestSetOGTTGroupLinks","合报告分组关联",id,TestSetOGTTGroupDesc_"-"_MainTestSetDesc_"-"_SubTestSetDsc,"A",logJson)
			
	}
	else	//保存失败
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate: 202-4-22
/// Description：合报告分组关联
/// Input:  groupcode 合报告分组代码,hospitalcode 医院代码
/// Table：dbo.BTTestSetOGTTGroupLinks  合报告分组关联
/// Return:json串  子组合套id，是否主组合套 {data:[{"SubTestSetDR":"22",mainflag":"Y"},{"SubTestSetDR":"5",mainflag":"N"},{"SubTestSetDR":"1",mainflag":"N"},{"SubTestSetDR":"6",mainflag":"N"}], success:true, total:4}
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroupLinks).IfMainTestSet("cs01","DHSZHYYZY")
ClassMethod IfMainTestSet(groupcode As %String, hospitalcode As %String) As %String
{
	s result=""
	s hosital=""
	s:hospitalcode'="" hosital=$o(^dbo.BTHospitalI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(hospitalcode),0))
	s groupid=""
	s:hosital'="" groupid = $o(^dbo.BTTestSetOGTTGroupI("IndexCode",hosital,##Class(web.DHCBL.BDP.FunLib).IndexData(groupcode),0))
	s RowID=0
	s Count=0
	for
	{
		s RowID=$o(^dbo.BTTestSetOGTTGroupLinksD(RowID)) q:RowID=""
		
		s TestSetOGTTGroupDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)	//组合套组
		if (groupid'="")&&(groupid'=TestSetOGTTGroupDR) 	//过滤组合套组
		{
			continue
		}
		s MainTestSetDR = $lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),3)	// 主组合套 
		s SubTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),4)	// 子组合套
		if (MainTestSetDR=SubTestSetDR) //是主组合套
		{
			s mainflag="Y"
		}
		else
		{
			s mainflag="N"
		}
			
		s Count=Count+1
		if (result'="") //未循环完
		{
			s result=result_",{""SubTestSetDR"":"""_SubTestSetDR_""",mainflag"":"""_mainflag_"""}"
		}
		else		//开始循环
		{
			s result="{""SubTestSetDR"":"""_SubTestSetDR_""",mainflag"":"""_mainflag_"""}"
		}
		b ;1
	}
	s result="{data:["_result_"], success:true, total:"_Count_"}"
	q result
}

}
