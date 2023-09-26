Import SQLUser

/// 名称: 诊断与症状建议用药或检查表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-8-25
Class web.DHCBL.KB.DHCPHDisLinkSymI Extends %RegisteredObject
{

/// 石萧伟 2017-08-25
/// Description：批量删除诊断与症状建议用药或检查表维护内容
/// Table：User.DHCPHSyndromeIcd
/// Input：ids——要删除的ID串
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLinkSymI).DeleteDataStr()
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

/// Description：保存诊断与症状建议用药或检查表字典的内容
/// Table：User.DHCPHDisLinkSymI
/// Input：web.Entity.KB.DHCPHDisLinkSymI 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLinkSymI).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDisLinkSymI) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.LSYGenDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.LSYGenDr=$p(args,",",i)	
			if (eobj.LSYRowId="")  //如果RowId未赋值则增加
			{
				//s GenLength=$d(^DHCPHDISL(0,"Gen",eobj.LSYGenDr,eobj.LSYLinkDr))
				s GenLength=$d(^DHCPHDLSYI(0,"Gen",eobj.LSYGenDr,eobj.LSYLinkDr))
				if (GenLength=0)
				{
					s obj=##class(User.DHCPHDisLinkSymI).%New()
					d obj.LSYLinkDrSetObjectId(eobj.LSYLinkDr)
					d obj.LSYGenDrSetObjectId(eobj.LSYGenDr)
					s GenDesc=$p($g(^DHCPHEGEN(eobj.LSYGenDr)),"^",2)
					s PHEGLibDr=$p($g(^DHCPHEGEN(eobj.LSYGenDr)),"^",7)  //知识库标识DR
					s:PHEGLibDr'="" obj.LSYFlag=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
					s:PHEGLibDr="" obj.LSYFlag=""
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSymI","User.DHCPHDisLinkSymI","诊断与症状建议用药或检查表",id,GenDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状建议用药或检查表","web.DHCBL.KB.DHCPHDisLinkSymI","SaveData",eobj)
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
				s GenLength=$d(^DHCPHDLSYI(0,"Gen",eobj.LSYGenDr,eobj.LSYLinkDr))
				s LSYRowId=$o(^DHCPHDLSYI(0,"Gen",eobj.LSYGenDr,eobj.LSYLinkDr,0))
				if (GenLength=0)||((GenLength'=0)&(LSYRowId=eobj.LSYRowId))
				{
					s obj=##class(User.DHCPHDisLinkSymI).%OpenId(eobj.LSYRowId)
					s bobj=##class(web.Entity.KB.DHCPHDisLinkSymI).%New()
					s bobj.LSYRowId=eobj.LSYRowId
					if $IsObject(obj.LSYLinkDr)
					{
						s bobj.LSYLinkDr = obj.LSYLinkDr.%Id() 
					}
					if $IsObject(obj.LSYGenDr)
					{
						s bobj.LSYGenDr = obj.LSYGenDr.%Id() 
					}
					s bobj.LSYFlag=obj.LSYFlag     
			
					d obj.LSYGenDrSetObjectId(eobj.LSYGenDr)
					d obj.LSYLinkDrSetObjectId(eobj.LSYLinkDr)
					
					s GenDesc=$p($g(^DHCPHEGEN(eobj.LSYGenDr)),"^",2)
					s PHEGLibDr=$p($g(^DHCPHEGEN(eobj.LSYGenDr)),"^",7)  //知识库标识DR
					s:PHEGLibDr'="" obj.LSYFlag=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
					s:PHEGLibDr="" obj.LSYFlag=""
						          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.LSYRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSymI","User.DHCPHDisLinkSymI","诊断与症状建议用药或检查表",id,GenDesc,"A",eobj)
						//修改时，日志
						d:eobj.LSYRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSymI","User.DHCPHDisLinkSymI","诊断与症状建议用药或检查表",eobj.LSYRowId,GenDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状建议用药或检查表","web.DHCBL.KB.DHCPHDisLinkSymI","SaveData",eobj)
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
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状建议用药或检查表","web.DHCBL.KB.DHCPHDisLinkSymI","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除诊断与症状建议用药或检查表的内容
/// Table：User.DHCPHDisLinkSymI
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDisLinkSymI).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLinkSymI).%New()
	s eobj.LSYRowId = id
	if $IsObject(pobj.LSYLinkDr)
	{
		s eobj.LSYLinkDr=pobj.LSYLinkDr.%Id()
	}
	if $IsObject(pobj.LSYGenDr)
	{
		s eobj.LSYGenDr=pobj.LSYGenDr.%Id()
	}
	s eobj.LSYFlag=pobj.LSYFlag
	
	s GenDesc=""
	s:eobj.LSYGenDr'="" GenDesc=$p($g(^DHCPHEGEN(eobj.LSYGenDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDisLinkSymI).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLinkSymI","User.DHCPHDisLinkSymI","诊断与症状建议用药或检查表",id,GenDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断与症状建议用药或检查表","web.DHCBL.KB.DHCPHDisLinkSymI","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询诊断与症状建议用药或检查表的内容
/// Table：User.DHCPHDisLinkSymI
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLinkSymI","GetList","","","")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "LSYRowId:%String,ICDdesc:%String,SymDesc:%String,LinkRowId:%String,LSYGenDr:%String,GenRowId:%String,LSYFlag:%String,SymRowId:%String,LSYGenDrF:%String,LSYLinkDr:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s LSYRowId=rowid
		s LinkRowId=$p($g(^DHCPHDLSYI(LSYRowId)),"^",1)
		i LinkRowId'=""
		{
			s ICDRowId=$p($g(^DHCPHDLSY(LinkRowId)),"^",1)
			s ICDdesc=""
			s:ICDRowId'="" ICDdesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			s SymRowId=$p($g(^DHCPHDLSY(LinkRowId)),"^",2)
			s SymDesc=""
			s:SymRowId'="" SymDesc=$p($g(^DHCPHSYMP(SymRowId)),"^",2)
			s LSYLinkDr=LinkRowId
		}
		else
		{
			s ICDdesc=""
			s SymDesc=""
		}
		
		s GenRowId=$p($g(^DHCPHDLSYI(DisRowId)),"^",2)
		i GenRowId'="" 
		{
			s LSYGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			s LSYGenDrF=GenRowId
			s PHEGLibDr=$p($g(^DHCPHEGEN(GenRowId)),"^",7)  //知识库标识DR
			s:PHEGLibDr'="" LSYFlag=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识
			s:PHEGLibDr="" LSYFlag=""
			s:LSYFlag="" LSYFlag="Y"
		}
		else 
		{
			s LSYGenDr=""
			s LSYFlag=""
			s:LSYFlag="" LSYFlag="Y"
		}

		d OutputRow
		
	}
	else
	{
		s LinkRowId=parref,LSYRowId=0
		for {
			S LSYRowId=$o(^DHCPHDLSYI(0,"Link",LinkRowId,LSYRowId)) q:LSYRowId=""
			s ICDRowId=$p($g(^DHCPHDLSY(LinkRowId)),"^",1)
			s ICDdesc=""
			s:ICDRowId'="" ICDdesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			s SymRowId=$p($g(^DHCPHDLSY(LinkRowId)),"^",2)
			s SymDesc=""
			s:SymRowId'="" SymDesc=$p($g(^DHCPHSYMP(SymRowId)),"^",2)
			s LSYLinkDr=LinkRowId
			
			s GenRowId=$p($g(^DHCPHDLSYI(LSYRowId)),"^",2)
			i GenRowId'="" 
			{
				s LSYGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
				s LSYGenDrF=GenRowId
				s PHEGLibDr=$p($g(^DHCPHEGEN(GenRowId)),"^",7)  //知识库标识DR
				s:PHEGLibDr'="" LSYFlag=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识
				s:PHEGLibDr="" LSYFlag=""
				s:LSYFlag="" LSYFlag="Y"
			}
			else 
			{
				s LSYGenDr=""
				s LSYFlag=""
				s:LSYFlag="" LSYFlag="Y"
			}

			d OutputRow
					
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LSYRowId,ICDdesc,SymDesc,LinkRowId,LSYGenDr,GenRowId,LSYFlag,SymRowId,LSYGenDrF,LSYLinkDr)
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

/// Creator:谷雪萍
/// Description:查询 通用名标识 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLinkSymI","GetDataForGen","","lab","")
Query GetDataForGen(rowid As %String, code As %String, desc As %String, lib As %String) As %Query(ROWSPEC = "PHEGRowId:%String,PHEGDesc:%String")
{
}

ClassMethod GetDataForGenExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, lib As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s PHEGRowId=rowid
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		//s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
		//s AuFlag=0
		;未授权情况下，默认显示全部数据
		//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		s PHEGRowId=0
		for
		{
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId=""
			s strRowId="{ID:"_PHEGRowId_"}"
			//if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			//{
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)
				s PHEGDesc1=$ZCONVERT(PHEGDesc,"U")
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) 
				s PHLICode1=$ZCONVERT(PHLICode,"U")
				if (PHLICode1="DRUG")||(PHLICode1="LAB"){
					s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc1))
					i (PHLICode1[code)&((PHEGDesc1[desc)||(PINYIN[desc))&(PHLICode1[lib)
					{
						d OutputRowCmb
					}
				}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEGRowId,PHEGDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForGenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForGenExecute ]
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

ClassMethod GetDataForGenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForGenExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
