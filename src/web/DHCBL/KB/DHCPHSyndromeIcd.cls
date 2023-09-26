Import SQLUser

/// 名称: 诊断与证型关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-8-22
Class web.DHCBL.KB.DHCPHSyndromeIcd Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：查询诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndromeIcd","GetList","","","")
Query GetNewList(rowid As %String, parref As %String) As %Query(ROWSPEC = "PHSIRowId:%String,PHSIICDDr:%String,ICDRowId:%String,PHSISynDr:%String,DRORowId:%String,PHSIICDDrF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s PHSIRowId=rowid
		s ICDRowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",1)
		s PHSIICDDr=""
		s:ICDRowId'="" PHSIICDDrF=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s PHSIICDDr=ICDRowId
		s DRORowId=$p($g(^DHCPHSYNICD(DisRowId)),"^",2)
		i DRORowId'="" 
		{
			s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
		}
		else 
		{
			s PHSISynDr=""
		}

		d OutputNewRow
		
	}
	else
	{
		if (parref'="")
		{
			s ICDRowId=parref,PHSIRowId=0
			for {
				S PHSIRowId=$o(^DHCPHSYNICD(0,"ICD",ICDRowId,PHSIRowId)) q:PHSIRowId=""
				s PHSIICDDrF=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s PHSIICDDr=ICDRowId
				s DRORowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",2)
				i DRORowId'="" 
				{
					s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
				}
				else 
				{
					s PHSISynDr=""
				}

				d OutputNewRow
					
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(PHSIRowId,PHSIICDDr,ICDRowId,PHSISynDr,DRORowId,PHSIICDDrF)
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

/// Description：保存诊断与证型关联表字典的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：web.Entity.KB.DHCPHSyndromeIcd 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHSyndromeIcd).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHSyndromeIcd) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.PHSISynDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.PHSISynDr=$p(args,",",i)	
			if (eobj.PHSIRowId="")  //如果RowId未赋值则增加
			{
				//s SYNLength=$d(^DHCPHDISL(0,"SYN",eobj.PHSISynDr,eobj.PHSIICDDr))
				s SYNLength=$d(^DHCPHSYNICD(0,"SYN",eobj.PHSISynDr,eobj.PHSIICDDr))
				if (SYNLength=0)
				{
					s obj=##class(User.DHCPHSyndromeIcd).%New()
					d obj.PHSIICDDrSetObjectId(eobj.PHSIICDDr)
					d obj.PHSISynDrSetObjectId(eobj.PHSISynDr)
					s DRODesc=$p($g(^DHCPHSYDRO(eobj.PHSISynDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeIcd","User.DHCPHSyndromeIcd","诊断与证型关联表",id,DRODesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联表","web.DHCBL.KB.DHCPHSyndromeIcd","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'存在已经被关联的证型！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s SYNLength=$d(^DHCPHSYNICD(0,"SYN",eobj.PHSISynDr,eobj.PHSIICDDr))
				s PHSIRowId=$o(^DHCPHSYNICD(0,"SYN",eobj.PHSISynDr,eobj.PHSIICDDr,0))
				if (SYNLength=0)||((SYNLength'=0)&(PHSIRowId=eobj.PHSIRowId))
				{
					s obj=##class(User.DHCPHSyndromeIcd).%OpenId(eobj.PHSIRowId)
					s bobj=##class(web.Entity.KB.DHCPHSyndromeIcd).%New()
					s bobj.PHSIRowId=eobj.PHSIRowId
					if $IsObject(obj.PHSIICDDr)
					{
						s bobj.PHSIICDDr = obj.PHSIICDDr.%Id() 
					}
					if $IsObject(obj.PHSISynDr)
					{
						s bobj.PHSISynDr = obj.PHSISynDr.%Id() 
					}     
			
					d obj.PHSISynDrSetObjectId(eobj.PHSISynDr)
					d obj.PHSIICDDrSetObjectId(eobj.PHSIICDDr)
					
					s DRODesc=$p($g(^DHCPHSYDRO(eobj.PHSISynDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.PHSIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeIcd","User.DHCPHSyndromeIcd","诊断与证型关联表",id,DRODesc,"A",eobj)
						//修改时，日志
						d:eobj.PHSIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeIcd","User.DHCPHSyndromeIcd","诊断与证型关联表",eobj.PHSIRowId,DRODesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联表","web.DHCBL.KB.DHCPHSyndromeIcd","SaveData",eobj)
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
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联表","web.DHCBL.KB.DHCPHSyndromeIcd","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHSyndromeIcd).GetRefFlag("23")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""

	i ($d(^DHCPHSYNGEN(0,"Link",id)))
	{
		s myInfo=myInfo_"<诊断与证型关联明细表>"
	}
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Description：根据ID删除诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	new (id)
	s result = ""
	s re=##class(web.DHCBL.KB.DHCPHSyndromeIcd).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		//new Entity对象，用于保存日志
		s pobj=##class(User.DHCPHSyndromeIcd).%OpenId(id)
		s eobj = ##class(web.Entity.KB.DHCPHSyndromeIcd).%New()
		s eobj.PHSIRowId = id
		if $IsObject(pobj.PHSIICDDr)
		{
			s eobj.PHSIICDDr=pobj.PHSIICDDr.%Id()
		}
		if $IsObject(pobj.PHSISynDr)
		{
			s eobj.PHSISynDr=pobj.PHSISynDr.%Id()
		}
		s DRODesc=""
		s:eobj.PHSISynDr'="" DRODesc=$p($g(^DHCPHSYDRO(eobj.PHSISynDr)),"^",2)
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.DHCPHSyndromeIcd).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeIcd","User.DHCPHSyndromeIcd","诊断与证型关联表",id,DRODesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联表","web.DHCBL.KB.DHCPHSyndromeIcd","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// 谷雪萍 2017-08-25
/// Description：批量删除诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：ids——要删除的ID串
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: d ##class(web.DHCBL.KB.DHCPHSyndromeIcd).DeleteDataStr()
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

/// Description：查询诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndromeIcd","GetList","","","")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "PHSIRowId:%String,PHSIICDDr:%String,ICDRowId:%String,PHSISynDr:%String,DRORowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s PHSIRowId=rowid
		s ICDRowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",1)
		//s PHSIICDDr=""
		s:ICDRowId'="" PHSIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		//s PHSIICDDr=ICDRowId
		s DRORowId=$p($g(^DHCPHSYNICD(DisRowId)),"^",2)
		i DRORowId'="" 
		{
			s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
		}
		else 
		{
			s PHSISynDr=""
		}

		d OutputRow
		
	}
	else
	{
		if (parref'="")
		{
			s ICDRowId=parref,PHSIRowId=0
			for {
				S PHSIRowId=$o(^DHCPHSYNICD(0,"ICD",ICDRowId,PHSIRowId)) q:PHSIRowId=""
				s PHSIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				//s PHSIICDDr=ICDRowId
				s DRORowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",2)
				i DRORowId'="" 
				{
					s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
				}
				else 
				{
					s PHSISynDr=""
				}

				d OutputRow
					
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHSIRowId,PHSIICDDr,ICDRowId,PHSISynDr,DRORowId)
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

/// Description：查询诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndromeIcd","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String) As %Query(ROWSPEC = "PHSIRowId:%String,PHSIICDDr:%String,ICDRowId:%String,PHSISynDr:%String,DRORowId:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s PHSIRowId=rowid
		s ICDRowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",1)
		s PHSIICDDr=""
		s:ICDRowId'="" PHSIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		s DRORowId=$p($g(^DHCPHSYNICD(DisRowId)),"^",2)
		i DRORowId'="" 
		{
			s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
		}
		else 
		{
			s PHSISynDr=""
		}

		d OutputRowCmb1
		
	}
	else
	{
		s parref=0
		for {
			S parref=$o(^DHCPHSYNICD(0,"ICD",parref)) q:parref="" 
			s ICDRowId=parref,PHSIRowId=0
			for {
				S PHSIRowId=$o(^DHCPHSYNICD(0,"ICD",ICDRowId,PHSIRowId)) q:PHSIRowId=""
				s PHSIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s DRORowId=$p($g(^DHCPHSYNICD(PHSIRowId)),"^",2)
				i DRORowId'="" 
				{
					s PHSISynDr=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
				}
				else 
				{
					s PHSISynDr=""
				}

				d OutputRowCmb1
			}
					
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb1
    set Data=$lb(PHSIRowId,PHSIICDDr,ICDRowId,PHSISynDr,DRORowId)
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

}
