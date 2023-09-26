Import SQLUser

/// 名称: 诊断与症状关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2016-8-22
Class web.DHCBL.KB.DHCPHDisLinkSym Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：查询诊断与症状关联表的内容
/// Table：User.DHCPHDisLinkSym
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLinkSym","GetList","","","")
Query GetNewList(rowid As %String, parref As %String) As %Query(ROWSPEC = "LSYRowId:%String,LSYIcdDr:%String,ICDRowId:%String,LSYSymDr:%String,SYMRowId:%String,LSYIcdDrF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s LSYRowId=rowid
		s ICDRowId=$p($g(^DHCPHDLSY(LSYRowId)),"^",1)
		s LSYIcdDrF=""
		s:ICDRowId'="" LSYIcdDrF=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s LSYIcdDr=ICDRowId
		s SYMRowId=$p($g(^DHCPHDLSY(DisRowId)),"^",2)
		i SYMRowId'="" 
		{
			s LSYSymDr=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
		}
		else 
		{
			s LSYSymDr=""
		}

		d OutputNewRow
		
	}
	else
	{
		s ICDRowId=parref,LSYRowId=0
		for {
			S LSYRowId=$o(^DHCPHDLSY(0,"ICD",ICDRowId,LSYRowId)) q:LSYRowId=""
			s LSYIcdDrF=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			s LSYIcdDr=ICDRowId
			s SYMRowId=$p($g(^DHCPHDLSY(LSYRowId)),"^",2)
			i SYMRowId'="" 
			{
				s LSYSymDr=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
			}
			else 
			{
				s LSYSymDr=""
			}

			d OutputRow
					
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(LSYRowId,LSYIcdDr,ICDRowId,LSYSymDr,SYMRowId,LSYIcdDrF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewListExecute ]
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

/// Description：保存诊断与症状关联表字典的内容
/// Table：User.DHCPHDisLinkSym
/// Input：web.Entity.KB.DHCPHDisLinkSym 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLinkSym).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDisLinkSym) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.LSYSymDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.LSYSymDr=$p(args,",",i)	
			if (eobj.LSYRowId="")  //如果RowId未赋值则增加
			{
				//s SYMLength=$d(^DHCPHDISL(0,"SYM",eobj.LSYSymDr,eobj.LSYIcdDr))
				s SYMLength=$d(^DHCPHDLSY(0,"SYM",eobj.LSYSymDr,eobj.LSYIcdDr))
				if (SYMLength=0)
				{
					s obj=##class(User.DHCPHDisLinkSym).%New()
					d obj.LSYIcdDrSetObjectId(eobj.LSYIcdDr)
					d obj.LSYSymDrSetObjectId(eobj.LSYSymDr)
					s SYMDesc=$p($g(^DHCPHSYMP(eobj.LSYSymDr)),"^",2)
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc)
					{
						Tcommit
						s id = obj.%Id()
						if (ids="")
						{
						    s ids = id
						}
						else
						{
							s ids = ids_","_id
						}
						s result = "{success:'true',id:'"_ids_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSym","User.DHCPHDisLinkSym","诊断与症状关联表",id,SYMDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状关联表","web.DHCBL.KB.DHCPHDisLinkSym","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'存在已经被关联的症状！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s SYMLength=$d(^DHCPHDLSY(0,"SYM",eobj.LSYSymDr,eobj.LSYIcdDr))
				s LSYRowId=$o(^DHCPHDLSY(0,"SYM",eobj.LSYSymDr,eobj.LSYIcdDr,0))
				if (SYMLength=0)||((SYMLength'=0)&(LSYRowId=eobj.LSYRowId))
				{
					s obj=##class(User.DHCPHDisLinkSym).%OpenId(eobj.LSYRowId)
					s bobj=##class(web.Entity.KB.DHCPHDisLinkSym).%New()
					s bobj.LSYRowId=eobj.LSYRowId
					if $IsObject(obj.LSYIcdDr)
					{
						s bobj.LSYIcdDr = obj.LSYIcdDr.%Id() 
					}
					if $IsObject(obj.LSYSymDr)
					{
						s bobj.LSYSymDr = obj.LSYSymDr.%Id() 
					}     
			
					d obj.LSYSymDrSetObjectId(eobj.LSYSymDr)
					d obj.LSYIcdDrSetObjectId(eobj.LSYIcdDr)
					
					s SYMDesc=$p($g(^DHCPHSYMP(eobj.LSYSymDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.LSYRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSym","User.DHCPHDisLinkSym","诊断与症状关联表",id,SYMDesc,"A",eobj)
						//修改时，日志
						d:eobj.LSYRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSym","User.DHCPHDisLinkSym","诊断与症状关联表",eobj.LSYRowId,SYMDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状关联表","web.DHCBL.KB.DHCPHDisLinkSym","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}	
		}			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状关联表","web.DHCBL.KB.DHCPHDisLinkSym","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHDisLinkSym).GetRefFlag("23")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""

	i ($d(^DHCPHDLSYI(0,"Link",id)))
	{
		s myInfo=myInfo_"<诊断与症状建议用药或检查>"
	}
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Description：根据ID删除诊断与症状关联表的内容
/// Table：User.DHCPHDisLinkSym
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	new (id)
	s result = ""
	s re=##class(web.DHCBL.KB.DHCPHDisLinkSym).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		//new Entity对象，用于保存日志
		s pobj=##class(User.DHCPHDisLinkSym).%OpenId(id)
		s eobj = ##class(web.Entity.KB.DHCPHDisLinkSym).%New()
		s eobj.LSYRowId = id
		if $IsObject(pobj.LSYIcdDr)
		{
			s eobj.LSYIcdDr=pobj.LSYIcdDr.%Id()
		}
		if $IsObject(pobj.LSYSymDr)
		{
			s eobj.LSYSymDr=pobj.LSYSymDr.%Id()
		}
		s SYMDesc=""
		s:eobj.LSYSymDr'="" SYMDesc=$p($g(^DHCPHSYMP(eobj.LSYSymDr)),"^",2)
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.DHCPHDisLinkSym).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSym","User.DHCPHDisLinkSym","诊断与症状关联表",id,SYMDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状关联表","web.DHCBL.KB.DHCPHDisLinkSym","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// 谷雪萍 2017-08-25
/// Description：批量删除诊断与症状关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：ids——要删除的ID串
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLinkSym).DeleteDataStr()
ClassMethod DeleteDataStr(ids As %String) As %String
{
	new (ids)
	s result=""	
	s idsLen=$Length(ids,"^")
	for i=1:1:idsLen   
	{
	  s id=$p(ids,"^",i)  
	  if (id'=""){
		  s rs=..DeleteData(id)
		  if (rs["false")
		  {			  
			 s result=rs		 			  
		  }
	  }
	}
	s:result="" result = "{success:'true',info:'批量删除成功！'}"	
	q result
}

/// Description：查询诊断与症状关联表的内容
/// Table：User.DHCPHDisLinkSym
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLinkSym","GetList","","","")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "LSYRowId:%String,LSYIcdDr:%String,ICDRowId:%String,LSYSymDr:%String,SYMRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s LSYRowId=rowid
		s ICDRowId=$p($g(^DHCPHDLSY(LSYRowId)),"^",1)
		//s LSYIcdDrF=""
		s:ICDRowId'="" LSYIcdDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		//s LSYIcdDr=ICDRowId
		s SYMRowId=$p($g(^DHCPHDLSY(DisRowId)),"^",2)
		i SYMRowId'="" 
		{
			s LSYSymDr=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
		}
		else 
		{
			s LSYSymDr=""
		}

		d OutputRow
		
	}
	else
	{
		s ICDRowId=parref,LSYRowId=0
		for {
			S LSYRowId=$o(^DHCPHDLSY(0,"ICD",ICDRowId,LSYRowId)) q:LSYRowId=""
			s LSYIcdDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			//s LSYIcdDr=ICDRowId
			s SYMRowId=$p($g(^DHCPHDLSY(LSYRowId)),"^",2)
			i SYMRowId'="" 
			{
				s LSYSymDr=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
			}
			else 
			{
				s LSYSymDr=""
			}

			d OutputRow
					
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LSYRowId,LSYIcdDr,ICDRowId,LSYSymDr,SYMRowId)
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

}
