Import SQLUser

/// 名称: 推导目录维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-04-14
Class web.DHCBL.KB.DHCPHDiseaseLinkLabel Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseLinkLabel
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseLinkLabel).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseLinkLabel).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseLinkLabel).%New()
	s eobj.PDLRowId=id
	if $IsObject(pobj.PDLDisTreeDr)
	{
		s eobj.PDLDisTreeDr = pobj.PDLDisTreeDr.%Id() 
	}
	s eobj.PDLOperator = pobj.PDLOperator
	s eobj.PDLRelation = pobj.PDLRelation
	if $IsObject(pobj.PDLLabelDr)
	{
		s eobj.PDLLabelDr = pobj.PDLLabelDr.%Id() 
	}	
	s eobj.PDLNum=pobj.PDLNum	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseLinkLabel
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseLinkLabel).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseLinkLabel).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseLinkLabel).%New()
	s eobj.PDLRowId=id
	if $IsObject(pobj.PDLDisTreeDr)
	{
		s eobj.PDLDisTreeDr = pobj.PDLDisTreeDr.%Id() 
	}
	s eobj.PDLOperator = pobj.PDLOperator
	s eobj.PDLRelation = pobj.PDLRelation
	if $IsObject(pobj.PDLLabelDr)
	{
		s eobj.PDLLabelDr = pobj.PDLLabelDr.%Id() 
	}	
	s eobj.PDLNum=pobj.PDLNum	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存推导目录字典的内容
/// Table：User.DHCPHDiseaseLinkLabel
/// Input：web.Entity.KB.DHCPHDiseaseLinkLabel 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseLinkLabel).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseLinkLabel) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		if eobj.PDLDisTreeDr=""  q "{success:'false',errorinfo:'没有获取到对应的诊断逻辑推导目录指针'}"
		s args=eobj.PDLLabelDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.PDLLabelDr=$p(args,",",i)		
			if (eobj.PDLRowId="")  //如果RowId未赋值则增加
			{
				s labelLen=$d(^DHCPHDISLILAi(0,"Link",eobj.PDLDisTreeDr,eobj.PDLLabelDr))
				if (labelLen=0)
				{
					s obj=##class(User.DHCPHDiseaseLinkLabel).%New()
					d obj.PDLDisTreeDrSetObjectId(eobj.PDLDisTreeDr)
					d obj.PDLLabelDrSetObjectId(eobj.PDLLabelDr)
					s obj.PDLOperator=eobj.PDLOperator
					s obj.PDLRelation=eobj.PDLRelation
					s obj.PDLNum=eobj.PDLNum
					s Desc=$p($g(^DHCPHGULA(eobj.PDLLabelDr)),"^",2)
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc)
					{
						Tcommit
						s id = obj.%Id()
						if (ids'="")
						{
							s ids = ids_","_id						    
						}
						else
						{
							s ids = id
						}
						s result = "{success:'true',id:'"_ids_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseLinkLabel","User.DHCPHDiseaseLinkLabel","推导目录",id,Desc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录","web.DHCBL.KB.DHCPHDiseaseLinkLabel","SaveData",eobj)
     					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s labelLen=$d(^DHCPHDISLILAi(0,"Link",eobj.PDLDisTreeDr,eobj.PDLLabelDr))
				s rowid=$o(^DHCPHDISLILAi(0,"Link",eobj.PDLDisTreeDr,eobj.PDLLabelDr,0))
				if (labelLen=0)||((labelLen'=0)&(rowid=eobj.PDLRowId))
				{
					s obj=##class(User.DHCPHDiseaseLinkLabel).%OpenId(eobj.PDLRowId)
					s bobj=##class(web.Entity.KB.DHCPHDiseaseLinkLabel).%New()
					s bobj.PDLRowId=eobj.PDLRowId
					if $IsObject(obj.PDLDisTreeDr)
					{
						s bobj.PDLDisTreeDr = obj.PDLDisTreeDr.%Id() 
					}
					if $IsObject(obj.PDLLabelDr)
					{
						s bobj.PDLLabelDr = obj.PDLLabelDr.%Id() 
					}
					s bobj.PDLOperator= obj.PDLOperator
					s bobj.PDLRelation=obj.PDLRelation  
					s bobj.PDLNum=obj.PDLNum        
			
					d obj.PDLLabelDrSetObjectId(eobj.PDLLabelDr)
					d obj.PDLDisTreeDrSetObjectId(eobj.PDLDisTreeDr)
					s obj.PDLOperator= eobj.PDLOperator
					s obj.PDLRelation=eobj.PDLRelation
					s obj.PDLNum=eobj.PDLNum
					s Desc=$p($g(^DHCPHGULA(eobj.PDLLabelDr)),"^",2)           	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.PDLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseLinkLabel","User.DHCPHDiseaseLinkLabel","推导目录",id,Desc,"A",eobj)
						//修改时，日志
						d:eobj.PDLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseLinkLabel","User.DHCPHDiseaseLinkLabel","推导目录",eobj.PDLRowId,Desc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录","web.DHCBL.KB.DHCPHDiseaseLinkLabel","SaveData",eobj)
     					s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
}

/// Description：根据ID删除推导目录的内容
/// Table：User.DHCPHDiseaseLinkLabel
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDiseaseLinkLabel).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseLinkLabel).%New()
	s eobj.PDLRowId = id
	if $IsObject(pobj.PDLDisTreeDr)
	{
		s eobj.PDLDisTreeDr=pobj.PDLDisTreeDr.%Id()
	}
	if $IsObject(pobj.PDLLabelDr)
	{
		s eobj.PDLLabelDr=pobj.PDLLabelDr.%Id()
	}
	s eobj.PDLOperator=pobj.PDLOperator
	s eobj.PDLRelation=pobj.PDLRelation
	s eobj.PDLNum=pobj.PDLNum
	s labelDesc=$p($g(^DHCPHGULA(eobj.PDLLabelDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDiseaseLinkLabel).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseLinkLabel","User.DHCPHDiseaseLinkLabel","推导目录",id,labelDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录","web.DHCBL.KB.DHCPHDiseaseLinkLabel","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询推导目录的内容
/// Table：User.DHCPHDiseaseLinkLabel
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseLinkLabel","GetList","","","")
Query GetList(rowid As %String, treeid As %String, label As %String) As %Query(ROWSPEC = "PDLRowId:%String,PDLDisTreeDr:%String,PDLLabelDrID:%String,PDLLabelDr:%String,PDLOperator:%String,PDLRelation:%String,PDLNum:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, treeid As %String, label As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseLinkLabel).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDLRowId=rowid
		s PDLDisTreeDr=$p($g(^DHCPHDISLILA(PDLRowId)),"^",5)
		s:PDLDisTreeDr'="" PDLDisTreeDr=$p($g(^DHCPHDISTR(PDLDisTreeDr)),"^",2)
		s:PDLDisTreeDr="" PDLDisTreeDr=""
		s PDLLabelDrID=$p($g(^DHCPHDISLILA(PDLRowId)),"^",1)
		s:PDLLabelDrID'="" PDLLabelDr=$p($g(^DHCPHGULA(PDLLabelDrID)),"^",2)
		s:PDLLabelDrID="" PDLLabelDr=""
		s PDLRelation=$p($g(^DHCPHDISLILA(PDLRowId)),"^",2)
		s PDLOperator=$p($g(^DHCPHDISLILA(PDLRowId)),"^",3)
		s PDLNum=$p($g(^DHCPHDISLILA(PDLRowId)),"^",4)
		d OutputRow		
	}
	else
	{
		s PDLRowId=0
		for 
		{
			S PDLRowId=$o(^DHCPHDISLILAi(0,"Tree",treeid,PDLRowId)) q:PDLRowId=""
		
			s PDLDisTreeDr=treeid
			s:PDLDisTreeDr'="" PDLDisTreeDr=$p($g(^DHCPHDISTR(PDLDisTreeDr)),"^",2)
			s:PDLDisTreeDr="" PDLDisTreeDr=""
			s PDLLabelDrID=$p($g(^DHCPHDISLILA(PDLRowId)),"^",1)
			s:PDLLabelDrID'="" PDLLabelDr=$p($g(^DHCPHGULA(PDLLabelDrID)),"^",2)
			s:PDLLabelDrID="" PDLLabelDr=""
			s PDLRelation=$p($g(^DHCPHDISLILA(PDLRowId)),"^",2)
			s PDLOperator=$p($g(^DHCPHDISLILA(PDLRowId)),"^",3)
			s PDLNum=$p($g(^DHCPHDISLILA(PDLRowId)),"^",4)

			if ((PDLLabelDr=label)||(label=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDLRowId,PDLDisTreeDr,PDLLabelDrID,PDLLabelDr,PDLOperator,PDLRelation,PDLNum)
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
