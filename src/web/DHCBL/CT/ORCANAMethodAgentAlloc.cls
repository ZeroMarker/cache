Import SQLUser

/// 名称:手术和过程 - 10.1 麻醉方法关联的麻醉剂	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-7
Class web.DHCBL.CT.ORCANAMethodAgentAlloc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 麻醉方法关联的麻醉剂
/// Table:User.ORCANAMethodAgentAlloc
/// Input:rowid,methoddr,agentdr
/// Return:METAGRowId,METAGMethodDR,METAGAgentDR
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCANAMethodAgentAlloc","GetList","","01","")
Query GetList(rowid As %String, methoddr As %String, agentdr As %String) As %Query(ROWSPEC = "METAGRowId:%String,METAGMethodDR:%String,METAGAgentDR:%String,ANMETRowId:%String,ANAGNRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, methoddr As %String, agentdr As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s METAGRowId=rowid
		s ANMETRowId=$p($g(^ORC("METAG",METAGRowId)),"^",1)
		i (ANMETRowId'="") 
		{
			s METAGMethodDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
		}
		else
		{
			s METAGMethodDR=""
		}
		
		s ANAGNRowId=$p($g(^ORC("METAG",METAGRowId)),"^",2)
		i (ANAGNRowId'="")
		{
			s METAGAgentDR=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
		}
		else
		{
			s METAGAgentDR=""
		}
		d OutputRow
	}
	else
	{
		
		s METAGRowId=0
		for{
			s METAGRowId=$o(^ORC("METAG",METAGRowId)) q:METAGRowId=""
		
		
				s ANMETRowId=$p($g(^ORC("METAG",METAGRowId)),"^",1)
				i (ANMETRowId'="")
				{
					s METAGMethodDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
				}
				else
				{
					s METAGMethodDR=""
				}
			
				s ANAGNRowId=$p($g(^ORC("METAG",METAGRowId)),"^",2)
				i (ANAGNRowId'="")
				{
					s METAGAgentDR=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
				}
				else
				{
					s METAGAgentDR=""
				}
				i (ANMETRowId=methoddr)&((ANAGNRowId=agentdr)||(agentdr=""))
				{
					d OutputRow
				}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(METAGRowId,METAGMethodDR,METAGAgentDR,ANMETRowId,ANAGNRowId)
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

//METAG_Method_DR->ORC_AnaestMethod

//METAG_Agent_DR->ORC_AnaestAgent

/// Creator:陈莹
/// CreatDate:2013-8-14
/// Other:d ##class(web.DHCBL.CT.ORCANAMethodAgentAlloc).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCANAMethodAgentAlloc).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCANAMethodAgentAlloc).%New()
	s eobj.METAGRowId = id
	if $IsObject(pobj.METAGMethodDR)
	{
		s eobj.METAGMethodDR = pobj.METAGMethodDR.%Id() 
	}
	if $IsObject(pobj.METAGAgentDR)
	{
		s eobj.METAGAgentDR = pobj.METAGAgentDR.%Id() 
	}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:增加/修改 麻醉方法关联的麻醉剂
/// Table:User.ORCANAMethodAgentAlloc
/// Input:web.Entity.CT.ORCANAMethodAgentAlloc
/// Return:成功返回success:'true'和新增或修改的数据的METAGRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCANAMethodAgentAlloc) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		//如果RowId未赋值则增加
		if (eobj.METAGRowId="")      
		{
			
			if ((eobj.METAGAgentDR'="")&(eobj.METAGMethodDR'=""))
			{
				s TempRowId=$d(^ORC("METAG",0,"METH",eobj.METAGMethodDR,eobj.METAGAgentDR))	
				s RowId=$d(^ORC("METAG",0,"METH",eobj.METAGMethodDR,eobj.METAGAgentDR,0))	
				if (TempRowId=0)  //判断Code是否重复
				{
					s obj=##class(User.ORCANAMethodAgentAlloc).%New()    
				}
				else
				{
					q "{success:'false',errorinfo:'该数据已经存在，请您重新填写！'}"
				}
			}
			else
			{
				q "{success:'false',errorinfo:'数据不可为空！'}"
			}
		}	
		//如果RowId已赋值则修改
		else                           
		{
			
			if ((eobj.METAGAgentDR'="")&(eobj.METAGMethodDR'=""))
			{
				s TempRowId=$d(^ORC("METAG",0,"METH",eobj.METAGMethodDR,eobj.METAGAgentDR))	
				s TempRowId2=$o(^ORC("METAG",0,"METH",eobj.METAGMethodDR,eobj.METAGAgentDR,0))		
				if (TempRowId=0)||((TempRowId'=0)&(eobj.METAGRowId=TempRowId2))  //判断Code是否重复
				{
					s obj=##class(User.ORCANAMethodAgentAlloc).%OpenId(eobj.METAGRowId)
					s bobj=##class(web.Entity.CT.ORCANAMethodAgentAlloc).%New()
					s bobj.METAGRowId=eobj.METAGRowId
					if $IsObject(obj.METAGMethodDR)
					{
						s bobj.METAGMethodDR = obj.METAGMethodDR.%Id() 
					}
					if $IsObject(obj.METAGAgentDR)
					{
						s bobj.METAGAgentDR = obj.METAGAgentDR.%Id() 
					}
				}
				else
				{
					q "{success:'false',errorinfo:'该数据已经存在，请您重新填写！'}"
				}
			}
			else
			{
				q "{success:'false',errorinfo:'数据不可为空！'}"
			}
			
					
		}		
		d obj.METAGMethodDRSetObjectId(eobj.METAGMethodDR)
		d obj.METAGAgentDRSetObjectId(eobj.METAGAgentDR)
		s ANAGNDesc=$p($g(^ORC("ANAGN",eobj.METAGAgentDR)),"^",2)
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.METAGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Ana_Method_Agent_Alloc","User.ORCANAMethodAgentAlloc","麻醉方法关联的麻醉剂",id,ANAGNDesc,"A",eobj)
			d:eobj.METAGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Ana_Method_Agent_Alloc","User.ORCANAMethodAgentAlloc","麻醉方法关联的麻醉剂",id,ANAGNDesc,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法关联的麻醉剂","web.DHCBL.CT.ORCANAMethodAgentAlloc","SaveEntity",eobj)
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

/// 保存完麻醉方法后调用，保存麻醉方法关联的麻醉剂(多条数据)
/// rowid:麻醉方法的rowid，metagstr为metagrowid^anagnrowid
/// 陈莹
/// 2014-12-24
ClassMethod SaveAll(rowid As %String, metagstr As %String) As %String
{
	if (metagstr'="")
	{
		s ssss=""
		s length=$Length(metagstr,"*")
		for i=1:1:length
		{
			s istr=$p(metagstr,"*",i)
			
			s eobj=##class(web.Entity.CT.ORCANAMethodAgentAlloc).%New()
			s eobj.METAGMethodDR = rowid
			s eobj.METAGRowId = $p(istr,"^",1)
			s eobj.METAGAgentDR = $p(istr,"^",2)
			s ssss=ssss_"^"_..SaveEntity(eobj)
		}
		
		s ^temp(1)=ssss
	}
	q 1
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:根据id删除 麻醉方法关联的麻醉剂
/// Table:User.ORCANAMethodAgentAlloc
/// Input:id(ORCANAMethodAgentAlloc的METAGRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCANAMethodAgentAlloc).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s pobj = ##class(User.ORCANAMethodAgentAlloc).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCANAMethodAgentAlloc).%New()
	s eobj.METAGRowId = id
	if $IsObject(pobj.METAGMethodDR)
	{
		s eobj.METAGMethodDR = pobj.METAGMethodDR.%Id() 
	}
	if $IsObject(pobj.METAGAgentDR)
	{
		s eobj.METAGAgentDR = pobj.METAGAgentDR.%Id() 
	}
	s ANAGNDesc=$p($g(^ORC("ANAGN",eobj.METAGAgentDR)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCANAMethodAgentAlloc).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Ana_Method_Agent_Alloc","User.ORCANAMethodAgentAlloc","麻醉方法关联的麻醉剂",id,ANAGNDesc,"D",eobj)
	}
	else
	{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法关联的麻醉剂","web.DHCBL.CT.ORCANAMethodAgentAlloc","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
