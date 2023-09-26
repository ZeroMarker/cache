Import SQLUser

/// 名称:手术和过程 - 18.1 手术别名	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-20
Class web.DHCBL.CT.ORCOperationAlias Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-23
/// Description:查询 手术别名
/// Table:User.ORCOperationAlias
/// Input:rowid,aliasparref,aliastext
/// 注:rowid,aliasparref至少有一个不为空
/// Return:ALIASRowId,ALIASParRef,ALIASText
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationAlias","GetList","","2","")
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationAlias","GetList","2||1","","")
Query GetList(rowid As %String, aliasparref As %String, aliastext As %String) As %Query(ROWSPEC = "ALIASRowId:%String,ALIASParRef:%String,ALIASText:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, aliasparref As %String, aliastext As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ALIASRowId=rowid
		s OPERRowId=$p(ALIASRowId,"||",1)
		s ALIASChildsub=$p(ALIASRowId,"||",2)
		;s ALIASParRef=OPERRowId 
		s ALIASParRef=$p($g(^ORC("OPER",OPERRowId)),"^",2) //取手术描述DESC
		s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
		d OutputRow
	}
	else
	{
		//aliasparref不为空
		if (aliasparref)
		{
		s OPERRowId=aliasparref,ALIASChildsub=0
		for
		{
			s ALIASChildsub=$o(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub)) q:ALIASChildsub=""
			s ALIASRowId=OPERRowId_"||"_ALIASChildsub
			;s ALIASParRef=aliasparref
			s ALIASParRef=$p($g(^ORC("OPER",OPERRowId)),"^",2) //取手术描述DESC
			s ALIASText=$g(^ORC("OPER",OPERRowId,"ALIAS",ALIASChildsub))
			i (ALIASChildsub>0)
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ALIASRowId,ALIASParRef,ALIASText)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod test(ALIASRowId, ALIASParRef, ALIASText) As %String
{
	s eobj=##class(web.Entity.CT.ORCOperationAlias).%New()
	s eobj.ALIASRowId=ALIASRowId
	s eobj.ALIASText=ALIASText
	s eobj.ALIASParRef=ALIASParRef
	d ##class(web.DHCBL.CT.ORCOperationAlias).SaveEntity(eobj)
}

/// Creator:陈莹
/// CreatDate:2013-8-14
/// Other:d ##class(web.DHCBL.CT.ORCOperationAlias).OpenData("2||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.ORCOperationAlias).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperationAlias).%New()
	s eobj.ALIASRowId = id
	s eobj.ALIASParRef = $p(id,"||",1)
	s eobj.ALIASText=pobj.ALIASText
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2022-02-11
/// Description:数据重复验证方法,js调用
/// Table:User.ORCOperationAlias
/// Input:id, parref, alias
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCOperationAlias).FormValidate("","1","XCZLXCS")
ClassMethod FormValidate(id As %String, parref As %String, alias As %String) As %String
{
	new (id,parref,alias)
	s flag=0
	q:alias="" 0
	if parref="" s parref=$p(id,"||",1)
	s sub=$p(id,"||",2)
	q:parref="" 0
	s TempChildsub=$o(^ORC("OPER",0,"ALIAS",$ZCONVERT(alias,"U"),parref,0))
	if ((id="")&&(TempChildsub'=""))||((id'="")&&(TempChildsub'="")&&(sub'="")&&(sub'=TempChildsub))
	{
		s flag=1
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:增加/修改 手术别名
/// Table:User.ORCOperationAlias
/// Input:web.Entity.CT.ORCOperationAlias
/// Return:成功返回success:'true'和新增或修改的数据的ALIASRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperationAlias) As %String
{
    new (eobj,%session)
	s result=""
	if eobj.ALIASText="" q "{success:'false',errorinfo:'别名不能为空！'}"
	if $IsObject(eobj)
	{
		s flag=##class(web.DHCBL.CT.ORCOperationAlias).FormValidate(eobj.ALIASRowId,eobj.ALIASParRef,eobj.ALIASText)
		if (flag=1)
		{	
 			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		//如果RowId未赋值则增加
		if (eobj.ALIASRowId="")       
		{
			s obj = ##class(User.ORCOperationAlias).%New(eobj.ALIASParRef)
			
		}
		//如果RowId已赋值则修改
		else                           
		{
			s obj=##class(User.ORCOperationAlias).%OpenId(eobj.ALIASRowId)
			s bobj = ##class(web.Entity.CT.ORCOperationAlias).%New()
			s bobj.ALIASRowId=eobj.ALIASRowId
			s bobj.ALIASParRef=$p(eobj.ALIASRowId,"||",1)
			s bobj.ALIASText=obj.ALIASText
		}	
				
		d obj.ALIASParRefSetObjectId(eobj.ALIASParRef)
		s obj.ALIASText=eobj.ALIASText
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ALIASRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationAlias","User.ORCOperationAlias","手术别名",id,eobj.ALIASText,"A",eobj)
		
			d:eobj.ALIASRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationAlias","User.ORCOperationAlias","手术别名",id,eobj.ALIASText,"U",eobj,bobj)
					
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术别名","web.DHCBL.CT.ORCOperationAlias","SaveEntity",eobj)
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

/// createdate:2015-1-14
/// RowId^ALIASText^ALIASParRef # RowId^ALIASText^ALIASParRef
/// d ##class(web.DHCBL.CT.ORCOperationAlias).SaveAll("^alias^1")
ClassMethod SaveAll(listData As %String) As %String
{
	n (listData,%session)
	s result="" 
	s msg=0
	s length=$length($g(listData),"#")
	for i=1:1:length q:msg'=0  d 
	.s DataStr=$p($g(listData),"#",i)
	.s eobj = ##class(web.Entity.CT.ORCOperationAlias).%New()
	.s eobj.ALIASRowId=$p($g(DataStr),"^",1)
	.s eobj.ALIASText=$p($g(DataStr),"^",2)
	.s eobj.ALIASParRef=$p($g(DataStr),"^",3)
	.s ret=..SaveEntity(eobj)
	.if (ret["success:'false'") d
	..s msg=1
	if (msg=0) d
	.s result= "{success:'true',info:'保存成功！'}"
	else  d
	.s result= "{success:'false',errorinfo:'保存失败！'}"
	
	q result
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:根据id删除 手术别名
/// Table:User.ORCOperationAlias
/// Input:id(ORCOperationAlias的ALIASRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCOperationAlias).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCOperationAlias).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperationAlias).%New()
	s eobj.ALIASRowId = id
	s eobj.ALIASParRef = $p(id,"||",1)
	s eobj.ALIASText=pobj.ALIASText
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCOperationAlias).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationAlias","User.ORCOperationAlias","手术别名",id,eobj.ALIASText,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术别名","web.DHCBL.CT.ORCOperationAlias","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
