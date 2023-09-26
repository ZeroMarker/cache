Import SQLUser

/// 名称: 诊断与证型关联明细表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-8-25
Class web.DHCBL.KB.DHCPHSyndromeGen Extends %RegisteredObject
{

/// 石萧伟 2018-07-27
/// Description：批量删除诊断与证型关联表的内容
/// Table：User.DHCPHSyndromeIcd
/// Input：ids——要删除的ID串
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: d ##class(web.DHCBL.KB.DHCPHSyndromeIcd).DeleteDataStr()
ClassMethod DeleteDataStr(ids As %String) As %String
{
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

/// Description：保存诊断与证型关联明细表字典的内容
/// Table：User.DHCPHSyndromeGen
/// Input：web.Entity.KB.DHCPHSyndromeGen 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHSyndromeGen).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHSyndromeGen) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.PHSGGenDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.PHSGGenDr=$p(args,",",i)	
			if (eobj.PHSGRowId="")  //如果RowId未赋值则增加
			{
				//s GenLength=$d(^DHCPHDISL(0,"Gen",eobj.PHSGGenDr,eobj.PHSGLinkDr))
				s GenLength=$d(^DHCPHSYNGEN(0,"Gen",eobj.PHSGGenDr,eobj.PHSGLinkDr))
				if (GenLength=0)
				{
					s obj=##class(User.DHCPHSyndromeGen).%New()
					d obj.PHSGLinkDrSetObjectId(eobj.PHSGLinkDr)
					d obj.PHSGGenDrSetObjectId(eobj.PHSGGenDr)
					s GenDesc=$p($g(^DHCPHEGEN(eobj.PHSGGenDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeGen","User.DHCPHSyndromeGen","诊断与证型关联明细表",id,GenDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联明细表","web.DHCBL.KB.DHCPHSyndromeGen","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'存在已经被关联的通用名！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s GenLength=$d(^DHCPHSYNGEN(0,"Gen",eobj.PHSGGenDr,eobj.PHSGLinkDr))
				s PHSGRowId=$o(^DHCPHSYNGEN(0,"Gen",eobj.PHSGGenDr,eobj.PHSGLinkDr,0))
				if (GenLength=0)||((GenLength'=0)&(PHSGRowId=eobj.PHSGRowId))
				{
					s obj=##class(User.DHCPHSyndromeGen).%OpenId(eobj.PHSGRowId)
					s bobj=##class(web.Entity.KB.DHCPHSyndromeGen).%New()
					s bobj.PHSGRowId=eobj.PHSGRowId
					if $IsObject(obj.PHSGLinkDr)
					{
						s bobj.PHSGLinkDr = obj.PHSGLinkDr.%Id() 
					}
					if $IsObject(obj.PHSGGenDr)
					{
						s bobj.PHSGGenDr = obj.PHSGGenDr.%Id() 
					}     
			
					d obj.PHSGGenDrSetObjectId(eobj.PHSGGenDr)
					d obj.PHSGLinkDrSetObjectId(eobj.PHSGLinkDr)
					
					s GenDesc=$p($g(^DHCPHEGEN(eobj.PHSGGenDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.PHSGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeGen","User.DHCPHSyndromeGen","诊断与证型关联明细表",id,GenDesc,"A",eobj)
						//修改时，日志
						d:eobj.PHSGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeGen","User.DHCPHSyndromeGen","诊断与证型关联明细表",eobj.PHSGRowId,GenDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联明细表","web.DHCBL.KB.DHCPHSyndromeGen","SaveData",eobj)
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
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联明细表","web.DHCBL.KB.DHCPHSyndromeGen","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除诊断与证型关联明细表的内容
/// Table：User.DHCPHSyndromeGen
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHSyndromeGen).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHSyndromeGen).%New()
	s eobj.PHSGRowId = id
	if $IsObject(pobj.PHSGLinkDr)
	{
		s eobj.PHSGLinkDr=pobj.PHSGLinkDr.%Id()
	}
	if $IsObject(pobj.PHSGGenDr)
	{
		s eobj.PHSGGenDr=pobj.PHSGGenDr.%Id()
	}
	s GenDesc=""
	s:eobj.PHSGGenDr'="" GenDesc=$p($g(^DHCPHEGEN(eobj.PHSGGenDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHSyndromeGen).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndromeGen","User.DHCPHSyndromeGen","诊断与证型关联明细表",id,GenDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与证型关联明细表","web.DHCBL.KB.DHCPHSyndromeGen","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询诊断与证型关联明细表的内容
/// Table：User.DHCPHSyndromeGen
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndromeGen","GetList","","","")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "PHSGRowId:%String,ICDdesc:%String,SynDesc:%String,LinkRowId:%String,PHSGGenDr:%String,GenRowId:%String,DRORowId:%String,PHSGGenDrF:%String,PHSGLinkDr:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s PHSGRowId=rowid
		s LinkRowId=$p($g(^DHCPHSYNGEN(PHSGRowId)),"^",1)
		i LinkRowId'=""
		{
			s ICDRowId=$p($g(^DHCPHSYNICD(LinkRowId)),"^",1)
			s ICDdesc=""
			s PHSGLinkDr=LinkRowId
			s:ICDRowId'="" ICDdesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			s DRORowId=$p($g(^DHCPHSYNICD(LinkRowId)),"^",2)
			s SynDesc=""
			s:DRORowId'="" SynDesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
		}
		else
		{
			s ICDdesc=""
			s SynDesc=""
		}
		
		s GenRowId=$p($g(^DHCPHSYNGEN(DisRowId)),"^",2)
		i GenRowId'="" 
		{
			s PHSGGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			s PHSGGenDrF=GenRowId
		}
		else 
		{
			s PHSGGenDr=""
		}

		d OutputRow
		
	}
	else
	{
		if (parref'="")
		{
			s LinkRowId=parref,PHSGRowId=0
			for {
				S PHSGRowId=$o(^DHCPHSYNGEN(0,"Link",LinkRowId,PHSGRowId)) q:PHSGRowId=""
				s ICDRowId=$p($g(^DHCPHSYNICD(LinkRowId)),"^",1)
				s ICDdesc=""
				s:ICDRowId'="" ICDdesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s DRORowId=$p($g(^DHCPHSYNICD(LinkRowId)),"^",2)
				s SynDesc=""
				s:DRORowId'="" SynDesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
				s PHSGLinkDr=LinkRowId
				s GenRowId=$p($g(^DHCPHSYNGEN(PHSGRowId)),"^",2)
				i GenRowId'="" 
				{
					s PHSGGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
					s PHSGGenDrF=GenRowId
				}
				else 
				{
					s PHSGGenDr=""
				}

				d OutputRow
					
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHSGRowId,ICDdesc,SynDesc,LinkRowId,PHSGGenDr,GenRowId,DRORowId,PHSGGenDrF,PHSGLinkDr)
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
