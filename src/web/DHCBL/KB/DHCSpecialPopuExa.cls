Import SQLUser

/// 名称: 特殊人群与检查结果关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.DHCBL.KB.DHCSpecialPopuExa Extends %RegisteredObject
{

/// Description：查询特殊人群与检查结果关联表的内容
/// Table：User.DHCSpecialPopuExa
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuExa","GetList","","","")
Query GetNewList(rowid As %String, parref As %String, exa As %String) As %Query(ROWSPEC = "SPEERowId:%String,SPEEPODr:%String,SPEEEXDr:%String,SPEEActiveFlag:%String,SPEESysFlag:%String,SPEEPODrF:%String,ExaRowId:%String,SPEEActiveFlagF:%String,SPEESysFlagF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, exa As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuExa).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPEERowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEERowId,"||",1)
			s SPEEChildsub=$p(SPEERowId,"||",2)
			s SPEEPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEEPODr=PopuRowId
			s ExaRowId=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",1)
			s SPEEActiveFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",2)
			s SPEESysFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",3)
			s:SPEEActiveFlag="" SPEEActiveFlag="Y"
        	s:SPEESysFlag="" SPEESysFlag="Y"
        	
			s SPEEActiveFlagF=""
			s SPEESysFlagF=""
			i ExaRowId'="" 
			{
				s SPEEEXDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
			}
			else 
			{
				s SPEEEXDr=""
			}
	
			d OutputNewRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEEChildsub=0
		for 
		{
			S SPEEChildsub=$o(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)) q:SPEEChildsub=""
			s SPEERowId=PopuRowId_"||"_SPEEChildsub
			s SPEEPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPEEPODr=PopuRowId
			s ExaRowId=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",1)
			s SPEEActiveFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",2)
			s SPEESysFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",3)
			s:SPEEActiveFlag="" SPEEActiveFlag="Y"
        	s:SPEESysFlag="" SPEESysFlag="Y"
        	
			s SPEEActiveFlagF=""
			s SPEESysFlagF=""
			i ExaRowId'="" 
			{
				s SPEEEXDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
			}
			else 
			{
				s SPEEEXDr=""
			}
			if (SPEEChildsub>0)&((ExaRowId=exa)||(exa=""))
			{
				d OutputNewRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(SPEERowId,SPEEPODr,SPEEEXDr,SPEEActiveFlag,SPEESysFlag,SPEEPODrF,ExaRowId,SPEEActiveFlagF,SPEESysFlagF)
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
/// Table：User.DHCSpecialPopuExa
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuExa).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuExa).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuExa).%New()
	s eobj.SPEERowId=id
	s eobj.SPEEPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEEEXDr)
	{
		s eobj.SPEEEXDr = pobj.SPEEEXDr.%Id() 
	}		
	s eobj.SPEEActiveFlag = pobj.SPEEActiveFlag
	s:eobj.SPEEActiveFlag="" eobj.SPEEActiveFlag="Y" 
	s eobj.SPEESysFlag = pobj.SPEESysFlag
	s:eobj.SPEESysFlag="" eobj.SPEESysFlag="Y" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopuExa
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuExa).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuExa).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuExa).%New()
	s eobj.SPEERowId=id
	s eobj.SPEEPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEEEXDr)
	{
		s eobj.SPEEEXDr = pobj.SPEEEXDr.%Id() 
	}		
	s eobj.SPEEActiveFlag = pobj.SPEEActiveFlag
	s:eobj.SPEEActiveFlag="Y" eobj.SPEEActiveFlag="true" 
	s eobj.SPEESysFlag = pobj.SPEESysFlag
	s:eobj.SPEESysFlag="Y" eobj.SPEESysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存特殊人群与检查结果关联表字典的内容
/// Table：User.DHCSpecialPopuExa
/// Input：web.Entity.KB.DHCSpecialPopuExa 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCSpecialPopuExa).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCSpecialPopuExa) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.SPEEEXDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.SPEEEXDr=$p(args,",",i)	
			if (eobj.SPEERowId="")  //如果RowId未赋值则增加
			{
				s Length=$d(^DHCSPEP(0,"EXA",eobj.SPEEEXDr,eobj.SPEEPODr))
				if (Length=0)
				{
					s obj=##class(User.DHCSpecialPopuExa).%New(eobj.SPEEPODr)
					d obj.SPEEPODrSetObjectId(eobj.SPEEPODr)
					d obj.SPEEEXDrSetObjectId(eobj.SPEEEXDr)
					s:eobj.SPEEActiveFlag="" eobj.SPEEActiveFlag ="N" 
					s obj.SPEEActiveFlag = eobj.SPEEActiveFlag          //修改描述
					s:eobj.SPEESysFlag="" eobj.SPEESysFlag ="N" 
					s obj.SPEESysFlag = eobj.SPEESysFlag
					s exaDesc=$p($g(^DHCEXAMINE(eobj.SPEEEXDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuExa","User.DHCSpecialPopuExa","特殊人群与检查结果关联表",id,exaDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检查结果关联表","web.DHCBL.KB.DHCSpecialPopuExa","SaveData",eobj)
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
				s Length=$d(^DHCSPEP(0,"EXA",eobj.SPEEEXDr,eobj.SPEEPODr))
				s SPEEChildsub=$p(eobj.SPEERowId,"||",2)
				s TempChildsub=$o(^DHCSPEP(0,"EXA",eobj.SPEEEXDr,eobj.SPEEPODr,0))
				if (Length=0)||((Length'=0)&(SPEEChildsub=TempChildsub))
				{
					s obj=##class(User.DHCSpecialPopuExa).%OpenId(eobj.SPEERowId)
					s bobj=##class(web.Entity.KB.DHCSpecialPopuExa).%New()
					s bobj.SPEERowId=eobj.SPEERowId
					s bobj.SPEEPODr=$p(eobj.SPEERowId,"||",1)
					if $IsObject(obj.SPEEEXDr)	
					{
						s bobj.SPEEEXDr = obj.SPEEEXDr.%Id() 
					}
					s bobj.SPEEActiveFlag = obj.SPEEActiveFlag          
					s bobj.SPEESysFlag = obj.SPEESysFlag       
			
					d obj.SPEEEXDrSetObjectId(eobj.SPEEEXDr)
					d obj.SPEEPODrSetObjectId(eobj.SPEEPODr)
					s:eobj.SPEEActiveFlag="" eobj.SPEEActiveFlag ="N" 
					s obj.SPEEActiveFlag = eobj.SPEEActiveFlag          //修改描述
					s:eobj.SPEESysFlag="" eobj.SPEESysFlag ="N" 
					s obj.SPEESysFlag = eobj.SPEESysFlag
					s exaDesc=$p($g(^DHCEXAMINE(eobj.SPEEEXDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.SPEERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuExa","User.DHCSpecialPopuExa","特殊人群与检查结果关联表",id,exaDesc,"A",eobj)
						//修改时，日志
						d:eobj.SPEERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuExa","User.DHCSpecialPopuExa","特殊人群与检查结果关联表",eobj.SPEERowId,exaDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检查结果关联表","web.DHCBL.KB.DHCSpecialPopuExa","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检查结果关联表","web.DHCBL.KB.DHCSpecialPopuExa","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除特殊人群与检查结果关联表的内容
/// Table：User.DHCSpecialPopuExa
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCSpecialPopuExa).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuExa).%New()
	s eobj.SPEERowId = id
	s eobj.SPEEPODr=$p(id,"||",1)
	if $IsObject(pobj.SPEEEXDr)
	{
		s eobj.SPEEEXDr=pobj.SPEEEXDr.%Id()
	}
	s eobj.SPEEActiveFlag=pobj.SPEEActiveFlag
	s eobj.SPEESysFlag=pobj.SPEESysFlag
	s exaDesc=$p($g(^DHCEXAMINE(eobj.SPEEEXDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCSpecialPopuExa).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuExa","User.DHCSpecialPopuExa","特殊人群与检查结果关联表",id,exaDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检查结果关联表","web.DHCBL.KB.DHCSpecialPopuExa","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询特殊人群与检查结果关联表的内容
/// Table：User.DHCSpecialPopuExa
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuExa","GetList","","","")
Query GetList(rowid As %String, parref As %String, exa As %String) As %Query(ROWSPEC = "SPEERowId:%String,SPEEPODr:%String,SPEEEXDr:%String,SPEEActiveFlag:%String,SPEESysFlag:%String,ExaRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, exa As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuExa).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPEERowId=$p(rowid,",",i)
			s PopuRowId=$p(SPEERowId,"||",1)
			s SPEEChildsub=$p(SPEERowId,"||",2)
			s SPEEPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEEPODr=PopuRowId
			s ExaRowId=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",1)
			s SPEEActiveFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",2)
			s SPEESysFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",3)
			s:SPEEActiveFlag="" SPEEActiveFlag="Y"
        	s:SPEESysFlag="" SPEESysFlag="Y"
        	
			i ExaRowId'="" 
			{
				s SPEEEXDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
			}
			else 
			{
				s SPEEEXDr=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s PopuRowId=parref,SPEEChildsub=0
		for 
		{
			S SPEEChildsub=$o(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)) q:SPEEChildsub=""
			s SPEERowId=PopuRowId_"||"_SPEEChildsub
			s SPEEPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPEEPODr=PopuRowId
			s ExaRowId=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",1)
			s SPEEActiveFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",2)
			s SPEESysFlag=$p($g(^DHCSPEP(PopuRowId,"EXA",SPEEChildsub)),"^",3)
			s:SPEEActiveFlag="" SPEEActiveFlag="Y"
        	s:SPEESysFlag="" SPEESysFlag="Y"
			i ExaRowId'="" 
			{
				s SPEEEXDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
			}
			else 
			{
				s SPEEEXDr=""
			}
			if (SPEEChildsub>0)&((ExaRowId=exa)||(exa=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SPEERowId,SPEEPODr,SPEEEXDr,SPEEActiveFlag,SPEESysFlag,ExaRowId)
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
