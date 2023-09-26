Import SQLUser

/// 名称:手术和过程 - 18.2 手术关联医嘱项	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-20
Class web.DHCBL.CT.ORCOperationItemLink Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-23
/// Description:查询 手术关联医嘱项
/// Table:User.ORCOperationItemLink
/// Input:rowid,linkparref,linkarcimdr 
/// Return:LINKRowId,LINKParref,LINKARCIMDR
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationItemLink","GetList","1||16","","")
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationItemLink","GetList","","5745","")
Query GetList(rowid As %String, linkparref As %String, linkarcimdr As %String, cflag) As %Query(ROWSPEC = "LINKRowId:%String,LINKParRef:%String,LINKARCIMDR:%String,ARCIMDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, linkparref As %String, linkarcimdr As %String, cflag) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s LINKRowId=rowid
		s OPERRowId=$p(LINKRowId,"||",1)
		s LINKChildsub=$p(LINKRowId,"||",2)
		;s LINKParRef=OPERRowId
		s LINKParRef=$p($g(^ORC("OPER",OPERRowId)),"^",2) //取手术描述DESC
		s LINKARCIMDR=$p($g(^ORC("OPER",OPERRowId,"LINK",LINKChildsub)),"^",1)
		s ARCIMSubscript=$p(LINKARCIMDR,"||",1)
		s ARCIMVersion=$p(LINKARCIMDR1,"||",2)
		i (LINKARCIMDR'="")
		{
			s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		}
		else
		{
			s ARCIMDesc=""
		}
		d OutputRow
	}
	else
	{
		if (linkparref)
		{
			s OPERRowId=linkparref,LINKChildsub=0
			for
			{
				s LINKChildsub=$o(^ORC("OPER",OPERRowId,"LINK",LINKChildsub)) q:LINKChildsub=""
				s LINKRowId=OPERRowId_"||"_LINKChildsub
				;s LINKParRef=linkparref
				s LINKParRef=$p($g(^ORC("OPER",OPERRowId)),"^",2) //取手术描述DESC
				s LINKARCIMDR=$p($g(^ORC("OPER",OPERRowId,"LINK",LINKChildsub)),"^",1)
				s ARCIMSubscript=$p(LINKARCIMDR,"||",1)
				s ARCIMVersion=$p(LINKARCIMDR,"||",2)
				i LINKARCIMDR'="" {
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
				}
				else {
					s ARCIMDesc=""
				}
				if cflag=1 s LINKRowId="",LINKParRef=""
				i (LINKChildsub>0)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LINKRowId,LINKParRef,LINKARCIMDR,ARCIMDesc)
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

/// Creator:陈莹
/// CreatDate:2013-8-14
/// Other:d ##class(web.DHCBL.CT.ORCOperationItemLink).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.ORCOperationItemLink).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperationItemLink).%New()
	s eobj.LINKRowId = id
	s eobj.LINKParRef =$p(id,"||",1)
	
	if $IsObject(pobj.LINKARCIMDR)
	{
		s eobj.LINKARCIMDR = pobj.LINKARCIMDR.%Id() 
	}
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.ORCOperationItemLink).SaveTest()
	s eobj = ##class(web.Entity.CT.ORCOperationItemLink).%New()
	s eobj.LINKARCIMDR="6||1"   //te级护理
	s eobj.LINKRowId=""
	s eobj.LINKParRef="1"
	d ..SaveEntity(eobj)
}

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用  判断是否和手术过程关联的默认医嘱项相同
/// Table：User.OECOrderStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.ORCOperationItemLink).FormValidate("2","","3||1")
/// /w ##class(web.DHCBL.CT.ORCOperationItemLink).FormValidate("2","2||1","3||1")
ClassMethod FormValidate(operrowid As %String, id As %String, acrimdr As %String) As %String
{
	s flag="",flagc=""
	q:operrowid="" 0
	q:acrimdr="" 0
	s flagc=$d(^ORC("OPER",0,"ARCIM",acrimdr,operrowid))
	
	if (flagc>0)
	{
		if (id="")
		{
			s flag=1
		}
		else
		{
			s idc=""
			s sub1=$p(id,"||",2)
			s idc=$o(^ORC("OPER",0,"ARCIM",acrimdr,operrowid,0))
			s idc=operrowid_"||"_idc
			if (idc'="")&(idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志	
		}	
	}
	else
	{
		s flag=0
	}
	
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:增加/修改 手术关联医嘱项
/// Table:User.ORCOperationItemLink
/// Input:web.Entity.CT.ORCOperationItemLink
/// Return:成功返回success:'true'和新增或修改的数据的LINKRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperationItemLink) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag= ##class(web.DHCBL.CT.ORCOperationItemLink).FormValidate(eobj.LINKParRef,eobj.LINKRowId,eobj.LINKARCIMDR)
		if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
		//如果RowId未赋值则增加
		if (eobj.LINKRowId="")       
		{
			s obj = ##class(User.ORCOperationItemLink).%New(eobj.LINKParRef)
		}
		//如果RowId已赋值则修改
		else                           
		{
			s obj=##class(User.ORCOperationItemLink).%OpenId(eobj.LINKRowId)
			s bobj = ##class(web.Entity.CT.ORCOperationItemLink).%New()
			s bobj.LINKRowId=eobj.LINKRowId
			s bobj.LINKParRef=$p(eobj.LINKRowId,"||",1)
			if $IsObject(obj.LINKARCIMDR)
			{
				s bobj.LINKARCIMDR = obj.LINKARCIMDR.%Id() 
			}
		}
		
		
		d obj.LINKParRefSetObjectId(eobj.LINKParRef)
		d obj.LINKARCIMDRSetObjectId(eobj.LINKARCIMDR) //13||1
		
		s ARCIMSubscript=$p(eobj.LINKARCIMDR,"||",1),ARCIMVersion=$p(eobj.LINKARCIMDR,"||",2)
		s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.LINKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationItemLink","User.ORCOperationItemLink","手术关联医嘱项",id,ARCIMDesc,"A",eobj)
			d:eobj.LINKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationItemLink","User.ORCOperationItemLink","手术关联医嘱项",id,ARCIMDesc,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术关联医嘱项","web.DHCBL.CT.ORCOperationItemLink","SaveEntity",eobj)
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

/// 保存完手术后调用，保存关联的医嘱项(多条数据)
/// rowid:手术的rowid，
/// 陈莹
/// 2015-1-14
ClassMethod SaveAll(rowid As %String, linkstr As %String) As %String
{
	if (linkstr'="")
	{
		s length=$Length(linkstr,"*")
		for i=1:1:length
		{
			s istr=$p(linkstr,"*",i)
			
			s eobj=##class(web.Entity.CT.ORCOperationItemLink).%New()
			s eobj.LINKParRef = rowid
			s eobj.LINKRowId = $p(istr,"^",1)
			s eobj.LINKARCIMDR = $p(istr,"^",2)
			s flag=..FormValidate(rowid,$p(istr,"^",1), $p(istr,"^",2))
			if flag=0
			{
				d ..SaveEntity(eobj)
			}
		}
	}
	q 1
}

/// Creator:陈莹
/// CreatDate:2012-9-20
/// Description:根据id删除 手术关联医嘱项
/// Table:User.ORCOperationItemLink
/// Input:id(ORCOperationItemLink的LINKRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.ORCOperationItemLink).DeleteData("1||16")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCOperationItemLink).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperationItemLink).%New()
	s eobj.LINKRowId = id
	s eobj.LINKParRef =$p(id,"||",1)
	
	if $IsObject(pobj.LINKARCIMDR)
	{
		s eobj.LINKARCIMDR = pobj.LINKARCIMDR.%Id() 
	}
	s ARCIMSubscript=$p(eobj.LINKARCIMDR,"||",1),ARCIMVersion=$p(eobj.LINKARCIMDR,"||",2)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)		
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCOperationItemLink).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationItemLink","User.ORCOperationItemLink","手术关联医嘱项",id,ARCIMDesc,"D",eobj)
	}
	else
	{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术关联医嘱项","web.DHCBL.CT.ORCOperationItemLink","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/*s TempARCIMDR=$d(^ORC("OPER",0,"ARCIM",eobj.LINKARCIMDR,eobj.LINKParRef))
			s LINKChildsub=$p(eobj.LINKRowId,"||",2)
			s TempChildsub=$o(^ORC("OPER",0,"ARCIM",eobj.LINKARCIMDR,eobj.LINKParRef,0))
			//2||2,2,9||1
			//TempARCIMDR=$d(^ORC("OPER",0,"ARCIM","9||1",2))=10,
			//TempChildsub=$o(^ORC("OPER",0,"ARCIM","9||1",2,0))=2 =LINKChildsub
			if (TempARCIMDR=0)||((TempARCIMDR'=0)&(LINKChildsub=TempChildsub))
			{*/
}
