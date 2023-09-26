Import SQLUser

/// 名称: 特殊人群与既往史关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.DHCBL.KB.DHCSpecialPopuHistory Extends %RegisteredObject
{

/// Description：查询特殊人群与既往史关联表的内容
/// Table：User.DHCSpecialPopuHistory
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuHistory","GetList","","","")
Query GetNewList(rowid As %String, parref As %String, disHis As %String) As %Query(ROWSPEC = "SPEHRowId:%String,SPEHPODr:%String,SPEHDHDr:%String,SPEHActiveFlag:%String,SPEHSysFlag:%String,SPEHPODrF:%String,DisHisRowId:%String,SPEHSysFlagF:%String,SPEHActiveFlagF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, disHis As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuHistory).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")	
		for i=1:1:idLen
		{
			s SPEHRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEHRowId,"||",1)
			s SPEHChildsub=$p(SPEHRowId,"||",2)
			s SPEHPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEHPODr=PopuRowId
			s DisHisRowId=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",1)
			s SPEHActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",2)
			s SPEHSysFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",3)
			s:SPEHActiveFlag="" SPEHActiveFlag="Y"
        	s:SPEHSysFlag="" SPEHSysFlag="Y"
			s SPEHSysFlagF=""
			s SPEHActiveFlagF=""
			i DisHisRowId'=""
			{
				s SPEHDHDr=$p($g(^DHCDISHISF(DisHisRowId)),"^",2)
			}
			else 
			{
				s SPEHDHDr=""
			}
	
			d OutputNewRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEHChildsub=0
		for 
		{
			S SPEHChildsub=$o(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)) q:SPEHChildsub=""
			s SPEHRowId=PopuRowId_"||"_SPEHChildsub
			s SPEHPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEHPODr=PopuRowId
			s DisHisRowId=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",1)
			s SPEHActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",2)
			s SPEHSysFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",3)
			s:SPEHActiveFlag="" SPEHActiveFlag="Y"
        	s:SPEHSysFlag="" SPEHSysFlag="Y"
        
			s SPEHSysFlagF=""
			s SPEHActiveFlagF=""
			i DisHisRowId'="" 
			{
				s SPEHDHDr=$p($g(^DHCDISHISF(DisHisRowId)),"^",2)
			}
			else 
			{
				s SPEHDHDr=""
			}
			if (SPEHChildsub>0)&((DisHisRowId=disHis)||(disHis=""))
			{
				d OutputNewRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(SPEHRowId,SPEHPODr,SPEHDHDr,SPEHActiveFlag,SPEHSysFlag,SPEHPODrF,DisHisRowId,SPEHSysFlagF,SPEHActiveFlagF)
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
/// Table：User.DHCSpecialPopuHistory
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuHistory).NewOpenData("1||3")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuHistory).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuHistory).%New()
	s eobj.SPEHRowId=id
	s eobj.SPEHPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEHDHDr)
	{
		s eobj.SPEHDHDr = pobj.SPEHDHDr.%Id() 
	}		
	s eobj.SPEHActiveFlag = pobj.SPEHActiveFlag
	s:eobj.SPEHActiveFlag="" eobj.SPEHActiveFlag="Y" 
	s eobj.SPEHSysFlag = pobj.SPEHSysFlag
	s:eobj.SPEHSysFlag="" eobj.SPEHSysFlag="Y" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopuHistory
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuHistory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuHistory).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuHistory).%New()
	s eobj.SPEHRowId=id
	s eobj.SPEHPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEHDHDr)
	{
		s eobj.SPEHDHDr = pobj.SPEHDHDr.%Id() 
	}		
	s eobj.SPEHActiveFlag = pobj.SPEHActiveFlag
	s:eobj.SPEHActiveFlag="Y" eobj.SPEHActiveFlag="true" 
	s eobj.SPEHSysFlag = pobj.SPEHSysFlag
	s:eobj.SPEHSysFlag="Y" eobj.SPEHSysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存特殊人群与既往史关联表字典的内容
/// Table：User.DHCSpecialPopuHistory
/// Input：web.Entity.KB.DHCSpecialPopuHistory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCSpecialPopuHistory).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCSpecialPopuHistory) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.SPEHDHDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.SPEHDHDr=$p(args,",",i)	
			if (eobj.SPEHRowId="")  //如果RowId未赋值则增加
			{
				s Length=$d(^DHCSPEP(0,"DH",eobj.SPEHDHDr,eobj.SPEHPODr))
				if (Length=0)
				{
					s obj=##class(User.DHCSpecialPopuHistory).%New(eobj.SPEHPODr)
					d obj.SPEHPODrSetObjectId(eobj.SPEHPODr)
					d obj.SPEHDHDrSetObjectId(eobj.SPEHDHDr)
					s:eobj.SPEHActiveFlag="" eobj.SPEHActiveFlag ="N" 
					s obj.SPEHActiveFlag = eobj.SPEHActiveFlag          //修改描述
					s:eobj.SPEHSysFlag="" eobj.SPEHSysFlag ="N" 
					s obj.SPEHSysFlag = eobj.SPEHSysFlag
					s hisDesc=$p($g(^DHCDISHISF(eobj.SPEHDHDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuHistory","User.DHCSpecialPopuHistory","特殊人群与既往史关联表",id,hisDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与既往史关联表","web.DHCBL.KB.DHCSpecialPopuHistory","SaveData",eobj)
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
				s Length=$d(^DHCSPEP(0,"DH",eobj.SPEHDHDr,eobj.SPEHPODr))
				s SPEHChildsub=$p(eobj.SPEHRowId,"||",2)
				s TempChildsub=$o(^DHCSPEP(0,"DH",eobj.SPEHDHDr,eobj.SPEHPODr,0))
				if (Length=0)||((Length'=0)&(SPEHChildsub=TempChildsub))
				{
					s obj=##class(User.DHCSpecialPopuHistory).%OpenId(eobj.SPEHRowId)
					s bobj=##class(web.Entity.KB.DHCSpecialPopuHistory).%New()
					s bobj.SPEHRowId=eobj.SPEHRowId
					s bobj.SPEHPODr=$p(eobj.SPEHRowId,"||",1)
					if $IsObject(obj.SPEHDHDr)
					{
						s bobj.SPEHDHDr = obj.SPEHDHDr.%Id() 
					}
					s bobj.SPEHActiveFlag = obj.SPEHActiveFlag          
					s bobj.SPEHSysFlag = obj.SPEHSysFlag       
			
					d obj.SPEHDHDrSetObjectId(eobj.SPEHDHDr)
					d obj.SPEHPODrSetObjectId(eobj.SPEHPODr)
					s:eobj.SPEHActiveFlag="" eobj.SPEHActiveFlag ="N" 
					s obj.SPEHActiveFlag = eobj.SPEHActiveFlag          //修改描述
					s:eobj.SPEHSysFlag="" eobj.SPEHSysFlag ="N" 
					s obj.SPEHSysFlag = eobj.SPEHSysFlag
					s hisDesc=$p($g(^DHCDISHISF(eobj.SPEHDHDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.SPEHRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuHistory","User.DHCSpecialPopuHistory","特殊人群与既往史关联表",id,hisDesc,"A",eobj)
						//修改时，日志
						d:eobj.SPEHRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuHistory","User.DHCSpecialPopuHistory","特殊人群与既往史关联表",eobj.SPEHRowId,hisDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与既往史关联表","web.DHCBL.KB.DHCSpecialPopuHistory","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与既往史关联表","web.DHCBL.KB.DHCSpecialPopuHistory","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除特殊人群与既往史关联表的内容
/// Table：User.DHCSpecialPopuHistory
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCSpecialPopuHistory).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuHistory).%New()
	s eobj.SPEHRowId = id
	s eobj.SPEHPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEHDHDr)
	{
		s eobj.SPEHDHDr=pobj.SPEHDHDr.%Id()
	}
	s eobj.SPEHActiveFlag=pobj.SPEHActiveFlag
	s eobj.SPEHSysFlag=pobj.SPEHSysFlag
	s hisDesc=$p($g(^DHCDISHISF(eobj.SPEHDHDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCSpecialPopuHistory).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuHistory","User.DHCSpecialPopuHistory","特殊人群与既往史关联表",id,hisDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与既往史关联表","web.DHCBL.KB.DHCSpecialPopuHistory","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询特殊人群与既往史关联表的内容
/// Table：User.DHCSpecialPopuHistory
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuHistory","GetList","","","")
Query GetList(rowid As %String, parref As %String, disHis As %String) As %Query(ROWSPEC = "SPEHRowId:%String,SPEHPODr:%String,SPEHDHDr:%String,SPEHActiveFlag:%String,SPEHSysFlag:%String,DisHisRowId")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, disHis As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuHistory).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")	
		for i=1:1:idLen
		{
			s SPEHRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEHRowId,"||",1)
			s SPEHChildsub=$p(SPEHRowId,"||",2)
			s SPEHPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEHPODr=PopuRowId
			s DisHisRowId=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",1)
			s SPEHActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",2)
			s SPEHSysFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",3)
			s:SPEHActiveFlag="" SPEHActiveFlag="Y"
        	s:SPEHSysFlag="" SPEHSysFlag="Y"
			i DisHisRowId'=""
			{
				s SPEHDHDr=$p($g(^DHCDISHISF(DisHisRowId)),"^",2)
			}
			else 
			{
				s SPEHDHDr=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEHChildsub=0
		for 
		{
			S SPEHChildsub=$o(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)) q:SPEHChildsub=""
			s SPEHRowId=PopuRowId_"||"_SPEHChildsub
			s SPEHPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEHPODr=PopuRowId
			s DisHisRowId=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",1)
			s SPEHActiveFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",2)
			s SPEHSysFlag=$p($g(^DHCSPEP(PopuRowId,"DH",SPEHChildsub)),"^",3)
			s:SPEHActiveFlag="" SPEHActiveFlag="Y"
        	s:SPEHSysFlag="" SPEHSysFlag="Y"
			i DisHisRowId'="" 
			{
				s SPEHDHDr=$p($g(^DHCDISHISF(DisHisRowId)),"^",2)
			}
			else 
			{
				s SPEHDHDr=""
			}
			if (SPEHChildsub>0)&((DisHisRowId=disHis)||(disHis=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SPEHRowId,SPEHPODr,SPEHDHDr,SPEHActiveFlag,SPEHSysFlag,DisHisRowId)
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
