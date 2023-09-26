Import SQLUser

/// 名称: 特殊人群与病症关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2014-11-10
Class web.DHCBL.KB.DHCSpecialPopuDis Extends %RegisteredObject
{

/// Description：查询特殊人群与病症关联表的内容
/// Table：User.DHCSpecialPopuDis
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuDis","GetList","","","")
Query GetNewList(rowid As %String, parref As %String, dis As %String) As %Query(ROWSPEC = "SPEDRowId:%String,SPEDPODr:%String,DisRowId:%String,SPEDDISDr:%String,SPEDActiveFlag:%String,SPEDSysFlag:%String,SPEDPODrF:%String,DisRowId:%String,SPEDSysFlagF:%String,SPEDActiveFlagF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, dis As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuDis).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPEDRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEDRowId,"||",1)
			s SPEDChildsub=$p(SPEDRowId,"||",2)
			s SPEDPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEDPODr=PopuRowId
			s DisRowId=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",1)
			s SPEDActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",2)
			s SPEDSysFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",3)
			s:SPEDActiveFlag="" SPEDActiveFlag="Y"
        	s:SPEDSysFlag="" SPEDSysFlag="Y"
			s SPEDSysFlagF=""
			s SPEDActiveFlagF=""			
			i DisRowId'="" 
			{
				s SPEDDISDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			}
			else 
			{
				s SPEDDISDr=""
			}
	
			d OutputNewRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEDChildsub=0
		for 
		{
			S SPEDChildsub=$o(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)) q:SPEDChildsub=""
			s SPEDRowId=PopuRowId_"||"_SPEDChildsub
			s SPEDPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEDPODr=PopuRowId
			s DisRowId=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",1)
			s SPEDActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",2)
			s SPEDSysFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",3)
			s:SPEDActiveFlag="" SPEDActiveFlag="Y"
        	s:SPEDSysFlag="" SPEDSysFlag="Y"
			s SPEDSysFlagF=""
			s SPEDActiveFlagF=""
			i DisRowId'="" 
			{
				s SPEDDISDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			}
			else 
			{
				s SPEDDISDr=""
			}
			if (SPEDChildsub>0)&((DisRowId=dis)||(dis=""))
			{
				d OutputNewRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(SPEDRowId,SPEDPODr,DisRowId,SPEDDISDr,SPEDActiveFlag,SPEDSysFlag,SPEDPODrF,DisRowId,SPEDSysFlagF,SPEDActiveFlagF)
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

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopuDis
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuDis).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuDis).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuDis).%New()
	s eobj.SPEDRowId=id
	s eobj.SPEDPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEDDISDr)
	{
		s eobj.SPEDDISDr = pobj.SPEDDISDr.%Id() 
	}		
	s eobj.SPEDActiveFlag = pobj.SPEDActiveFlag
	s:eobj.SPEDActiveFlag="" eobj.SPEDActiveFlag="Y" 
	s eobj.SPEDSysFlag = pobj.SPEDSysFlag
	s:eobj.SPEDSysFlag="" eobj.SPEDSysFlag="Y" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopuDis
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuDis).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuDis).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuDis).%New()
	s eobj.SPEDRowId=id
	s eobj.SPEDPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEDDISDr)
	{
		s eobj.SPEDDISDr = pobj.SPEDDISDr.%Id() 
	}		
	s eobj.SPEDActiveFlag = pobj.SPEDActiveFlag
	s:eobj.SPEDActiveFlag="Y" eobj.SPEDActiveFlag="true" 
	s eobj.SPEDSysFlag = pobj.SPEDSysFlag
	s:eobj.SPEDSysFlag="Y" eobj.SPEDSysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存特殊人群与病症关联表字典的内容
/// Table：User.DHCSpecialPopuDis
/// Input：web.Entity.KB.DHCSpecialPopuDis 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCSpecialPopuDis).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCSpecialPopuDis) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.SPEDDISDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.SPEDDISDr=$p(args,",",i)	
			if (eobj.SPEDRowId="")  //如果RowId未赋值则增加
			{
				s disLength=$d(^DHCSPEP(0,"DIS",eobj.SPEDDISDr,eobj.SPEDPODr))
				if (disLength=0)
				{
					s obj=##class(User.DHCSpecialPopuDis).%New(eobj.SPEDPODr)
					d obj.SPEDPODrSetObjectId(eobj.SPEDPODr)
					d obj.SPEDDISDrSetObjectId(eobj.SPEDDISDr)
					s:eobj.SPEDActiveFlag="" eobj.SPEDActiveFlag ="N" 
					s obj.SPEDActiveFlag = eobj.SPEDActiveFlag          //修改描述
					s:eobj.SPEDSysFlag="" eobj.SPEDSysFlag ="N" 
					s obj.SPEDSysFlag = eobj.SPEDSysFlag
					s disDesc=$p($g(^DHCPHDISL(eobj.SPEDDISDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuDis","User.DHCSpecialPopuDis","特殊人群与病症关联表",id,disDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与病症关联表","web.DHCBL.KB.DHCSpecialPopuDis","SaveData",eobj)
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
				s disLength=$d(^DHCSPEP(0,"DIS",eobj.SPEDDISDr,eobj.SPEDPODr))
				s SPEDChildsub=$p(eobj.SPEDRowId,"||",2)
				s TempChildsub=$o(^DHCSPEP(0,"DIS",eobj.SPEDDISDr,eobj.SPEDPODr,0))
				if (disLength=0)||((disLength'=0)&(SPEDChildsub=TempChildsub))
				{
					s obj=##class(User.DHCSpecialPopuDis).%OpenId(eobj.SPEDRowId)
					s bobj=##class(web.Entity.KB.DHCSpecialPopuDis).%New()
					s bobj.SPEDRowId=eobj.SPEDRowId
					s bobj.SPEDPODr=$p(eobj.SPEDRowId,"||",1)
					if $IsObject(obj.SPEDDISDr)
					{
						s bobj.SPEDDISDr = obj.SPEDDISDr.%Id() 
					}
					s bobj.SPEDActiveFlag = obj.SPEDActiveFlag          
					s bobj.SPEDSysFlag = obj.SPEDSysFlag       
			
					d obj.SPEDDISDrSetObjectId(eobj.SPEDDISDr)
					d obj.SPEDPODrSetObjectId(eobj.SPEDPODr)
					s:eobj.SPEDActiveFlag="" eobj.SPEDActiveFlag ="N" 
					s obj.SPEDActiveFlag = eobj.SPEDActiveFlag          //修改描述
					s:eobj.SPEDSysFlag="" eobj.SPEDSysFlag ="N" 
					s obj.SPEDSysFlag = eobj.SPEDSysFlag
					
					s disDesc=$p($g(^DHCPHDISL(eobj.SPEDDISDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.SPEDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuDis","User.DHCSpecialPopuDis","特殊人群与病症关联表",id,disDesc,"A",eobj)
						//修改时，日志
						d:eobj.SPEDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuDis","User.DHCSpecialPopuDis","特殊人群与病症关联表",eobj.SPEDRowId,disDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与病症关联表","web.DHCBL.KB.DHCSpecialPopuDis","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与病症关联表","web.DHCBL.KB.DHCSpecialPopuDis","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除特殊人群与病症关联表的内容
/// Table：User.DHCSpecialPopuDis
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCSpecialPopuDis).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuDis).%New()
	s eobj.SPEDRowId = id
	s eobj.SPEDPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEDDISDr)
	{
		s eobj.SPEDDISDr=pobj.SPEDDISDr.%Id()
	}
	s eobj.SPEDActiveFlag=pobj.SPEDActiveFlag
	s eobj.SPEDSysFlag=pobj.SPEDSysFlag
	s disDesc=$p($g(^DHCPHDISL(eobj.SPEDDISDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCSpecialPopuDis).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuDis","User.DHCSpecialPopuDis","特殊人群与病症关联表",id,disDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与病症关联表","web.DHCBL.KB.DHCSpecialPopuDis","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询特殊人群与病症关联表的内容
/// Table：User.DHCSpecialPopuDis
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuDis","GetList","","","")
Query GetList(rowid As %String, parref As %String, dis As %String) As %Query(ROWSPEC = "SPEDRowId:%String,SPEDPODr:%String,DisRowId:%String,SPEDDISDr:%String,SPEDActiveFlag:%String,SPEDSysFlag:%String,DisRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, dis As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuDis).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPEDRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEDRowId,"||",1)
			s SPEDChildsub=$p(SPEDRowId,"||",2)
			s SPEDPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEDPODr=PopuRowId
			s DisRowId=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",1)
			s SPEDActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",2)
			s SPEDSysFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",3)
			s:SPEDActiveFlag="" SPEDActiveFlag="Y"
        	s:SPEDSysFlag="" SPEDSysFlag="Y"
        	
			i DisRowId'="" 
			{
				s SPEDDISDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			}
			else 
			{
				s SPEDDISDr=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEDChildsub=0
		for 
		{
			S SPEDChildsub=$o(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)) q:SPEDChildsub=""
			s SPEDRowId=PopuRowId_"||"_SPEDChildsub
			s SPEDPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEDPODr=PopuRowId
			s DisRowId=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",1)
			s SPEDActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",2)
			s SPEDSysFlag=$p($g(^DHCSPEP(PopuRowId,"DIS",SPEDChildsub)),"^",3)
			s:SPEDActiveFlag="" SPEDActiveFlag="Y"
        	s:SPEDSysFlag="" SPEDSysFlag="Y"
			i DisRowId'="" 
			{
				s SPEDDISDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			}
			else 
			{
				s SPEDDISDr=""
			}
			if (SPEDChildsub>0)&((DisRowId=dis)||(dis=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SPEDRowId,SPEDPODr,DisRowId,SPEDDISDr,SPEDActiveFlag,SPEDSysFlag,DisRowId)
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
