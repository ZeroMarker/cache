Import SQLUser

/// 名称: 特殊人群与检验指标关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.DHCBL.KB.DHCSpecialPopuLab Extends %RegisteredObject
{

/// Description：查询特殊人群与检验指标关联表的内容
/// Table：User.DHCSpecialPopuLab
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuLab","GetList","","","")
Query GetNewList(rowid As %String, parref As %String, lab As %String) As %Query(ROWSPEC = "SPELRowId:%String,SPELPODr:%String,SPELPhyDr:%String,SPELActiveFlag:%String,SPELSysFlag:%String,SPELPODrF:%String,PhyRowId:%String,SPELSysFlagF:%String,SPELActiveFlagF:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, lab As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuLab).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPELRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPELRowId,"||",1)
			s SPELChildsub=$p(SPELRowId,"||",2)
			s SPELPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPELPODr=PopuRowId
			s PhyRowId=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",1)
			s SPELActiveFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",2)
			s SPELSysFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",3)
			s:SPELActiveFlag="" SPELActiveFlag="Y"
        	s:SPELSysFlag="" SPELSysFlag="Y"
        
			s SPELSysFlagF=""
			s SPELActiveFlagF=""
			i PhyRowId'="" 
			{
				s SPELPhyDr=$p($g(^DHCLABIF(PhyRowId)),"^",2)
			}
			else 
			{
				s SPELPhyDr=""
			}
	
			d OutputNewRow
		}
	}
	else
	{
		s PopuRowId=parref,SPELChildsub=0
		for 
		{
			S SPELChildsub=$o(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)) q:SPELChildsub=""
			s SPELRowId=PopuRowId_"||"_SPELChildsub
			s SPELPODrF=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			s SPELPODr=PopuRowId
			s PhyRowId=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",1)
			s SPELActiveFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",2)
			s SPELSysFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",3)
			s:SPELActiveFlag="" SPELActiveFlag="Y"
        	s:SPELSysFlag="" SPELSysFlag="Y"
        	
			s SPELSysFlagF=""
			s SPELActiveFlagF=""
			i PhyRowId'="" 
			{
				s SPELPhyDr=$p($g(^DHCLABIF(PhyRowId)),"^",2)
			}
			else 
			{
				s SPELPhyDr=""
			}
			if (SPELChildsub>0)&((PhyRowId=lab)||(lab=""))
			{
				d OutputNewRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(SPELRowId,SPELPODr,SPELPhyDr,SPELActiveFlag,SPELSysFlag,SPELPODrF,PhyRowId,SPELSysFlagF,SPELActiveFlagF)
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
/// Table：User.DHCSpecialPopuLab
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuLab).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuLab).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuLab).%New()
	s eobj.SPELRowId=id
	s eobj.SPELPODr=$p(id,"||",1)
	if $IsObject(pobj.SPELPhyDr)
	{
		s eobj.SPELPhyDr = pobj.SPELPhyDr.%Id() 
	}		
	s eobj.SPELActiveFlag = pobj.SPELActiveFlag
	s:eobj.SPELActiveFlag="" eobj.SPELActiveFlag="Y" 
	s eobj.SPELSysFlag = pobj.SPELSysFlag
	s:eobj.SPELSysFlag="" eobj.SPELSysFlag="Y" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopuLab
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopuLab).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCSpecialPopuLab).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuLab).%New()
	s eobj.SPELRowId=id
	s eobj.SPELPODr=$p(id,"||",1)
	if $IsObject(pobj.SPELPhyDr)
	{
		s eobj.SPELPhyDr = pobj.SPELPhyDr.%Id() 
	}		
	s eobj.SPELActiveFlag = pobj.SPELActiveFlag
	s:eobj.SPELActiveFlag="Y" eobj.SPELActiveFlag="true" 
	s eobj.SPELSysFlag = pobj.SPELSysFlag
	s:eobj.SPELSysFlag="Y" eobj.SPELSysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存特殊人群与检验指标关联表字典的内容
/// Table：User.DHCSpecialPopuLab
/// Input：web.Entity.KB.DHCSpecialPopuLab 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCSpecialPopuLab).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCSpecialPopuLab) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.SPELPhyDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.SPELPhyDr=$p(args,",",i)	
			if (eobj.SPELRowId="")  //如果RowId未赋值则增加
			{
				s labLength=$d(^DHCSPEP(0,"LAB",eobj.SPELPhyDr,eobj.SPELPODr))
				if (labLength=0)
				{
					s obj=##class(User.DHCSpecialPopuLab).%New(eobj.SPELPODr)
					d obj.SPELPODrSetObjectId(eobj.SPELPODr)
					d obj.SPELPhyDrSetObjectId(eobj.SPELPhyDr)
					s:eobj.SPELActiveFlag="" eobj.SPELActiveFlag ="N" 
					s obj.SPELActiveFlag = eobj.SPELActiveFlag          //修改描述
					s:eobj.SPELSysFlag="" eobj.SPELSysFlag ="N" 
					s obj.SPELSysFlag = eobj.SPELSysFlag
					s labDesc=$p($g(^DHCLABIF(eobj.SPELPhyDr)),"^",2)
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
						}else
						{
							s ids = ids_","_id
						}
						s result = "{success:'true',id:'"_ids_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuLab","User.DHCSpecialPopuLab","特殊人群与检验指标关联表",id,labDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检验指标关联表","web.DHCBL.KB.DHCSpecialPopuLab","SaveData",eobj)
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
				s labLength=$d(^DHCSPEP(0,"LAB",eobj.SPELPhyDr,eobj.SPELPODr))
				s SPELChildsub=$p(eobj.SPELRowId,"||",2)
				s TempChildsub=$o(^DHCSPEP(0,"LAB",eobj.SPELPhyDr,eobj.SPELPODr,0))
				if (labLength=0)||((labLength'=0)&(SPELChildsub=TempChildsub))
				{
					s obj=##class(User.DHCSpecialPopuLab).%OpenId(eobj.SPELRowId)
					s bobj=##class(web.Entity.KB.DHCSpecialPopuLab).%New()
					s bobj.SPELRowId=eobj.SPELRowId
					s bobj.SPELPODr=$p(eobj.SPELRowId,"||",1)
					if $IsObject(obj.SPELPhyDr)
					{
						s bobj.SPELPhyDr = obj.SPELPhyDr.%Id() 
					}
					s bobj.SPELActiveFlag = obj.SPELActiveFlag          
					s bobj.SPELSysFlag = obj.SPELSysFlag       
			
					d obj.SPELPhyDrSetObjectId(eobj.SPELPhyDr)
					d obj.SPELPODrSetObjectId(eobj.SPELPODr)
					s:eobj.SPELActiveFlag="" eobj.SPELActiveFlag ="N" 
					s obj.SPELActiveFlag = eobj.SPELActiveFlag          //修改描述
					s:eobj.SPELSysFlag="" eobj.SPELSysFlag ="N" 
					s obj.SPELSysFlag = eobj.SPELSysFlag
					s labDesc=$p($g(^DHCLABIF(eobj.SPELPhyDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.SPELRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuLab","User.DHCSpecialPopuLab","特殊人群与检验指标关联表",id,labDesc,"A",eobj)
						//修改时，日志
						d:eobj.SPELRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuLab","User.DHCSpecialPopuLab","特殊人群与检验指标关联表",eobj.SPELRowId,labDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检验指标关联表","web.DHCBL.KB.DHCSpecialPopuLab","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检验指标关联表","web.DHCBL.KB.DHCSpecialPopuLab","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除特殊人群与检验指标关联表的内容
/// Table：User.DHCSpecialPopuLab
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCSpecialPopuLab).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCSpecialPopuLab).%New()
	s eobj.SPELRowId = id
	s eobj.SPELPODr=$p(id,"||",1)
	if $IsObject(pobj.SPELPhyDr)
	{
		s eobj.SPELPhyDr=pobj.SPELPhyDr.%Id()
	}
	s eobj.SPELActiveFlag=pobj.SPELActiveFlag
	s eobj.SPELSysFlag=pobj.SPELSysFlag
	s labDesc=""
	s:eobj.SPELPhyDr'="" labDesc=$p($g(^DHCLABIF(eobj.SPELPhyDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCSpecialPopuLab).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopuLab","User.DHCSpecialPopuLab","特殊人群与检验指标关联表",id,labDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群与检验指标关联表","web.DHCBL.KB.DHCSpecialPopuLab","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询特殊人群与检验指标关联表的内容
/// Table：User.DHCSpecialPopuLab
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopuLab","GetList","","","")
Query GetList(rowid As %String, parref As %String, lab As %String) As %Query(ROWSPEC = "SPELRowId:%String,SPELPODr:%String,SPELPhyDr:%String,SPELActiveFlag:%String,SPELSysFlag:%String,PhyRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, lab As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopuLab).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s SPELRowId=$p(rowid,",",i)
			s PopuRowId=$p(SPELRowId,"||",1)
			s SPELChildsub=$p(SPELRowId,"||",2)
			s SPELPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPELPODr=PopuRowId
			s PhyRowId=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",1)
			s SPELActiveFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",2)
			s SPELSysFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",3)
			s:SPELActiveFlag="" SPELActiveFlag="Y"
        	s:SPELSysFlag="" SPELSysFlag="Y"
        	
			i PhyRowId'="" 
			{
				s SPELPhyDr=$p($g(^DHCLABIF(PhyRowId)),"^",2)
			}
			else 
			{
				s SPELPhyDr=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s PopuRowId=parref,SPELChildsub=0
		for 
		{
			S SPELChildsub=$o(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)) q:SPELChildsub=""
			s SPELRowId=PopuRowId_"||"_SPELChildsub
			s SPELPODr=$p($g(^DHCSPEP(PopuRowId)),"^",2)
			//s SPELPODr=PopuRowId
			s PhyRowId=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",1)
			s SPELActiveFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",2)
			s SPELSysFlag=$p($g(^DHCSPEP(PopuRowId,"LAB",SPELChildsub)),"^",3)
			s:SPELActiveFlag="" SPELActiveFlag="Y"
        	s:SPELSysFlag="" SPELSysFlag="Y"
        	
			i PhyRowId'="" 
			{
				s SPELPhyDr=$p($g(^DHCLABIF(PhyRowId)),"^",2)
			}
			else 
			{
				s SPELPhyDr=""
			}
			if (SPELChildsub>0)&((PhyRowId=lab)||(lab=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SPELRowId,SPELPODr,SPELPhyDr,SPELActiveFlag,SPELSysFlag,PhyRowId)
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
