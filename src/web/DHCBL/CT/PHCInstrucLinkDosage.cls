Import SQLUser

/// 名称:药学 -  用法与用量关联
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2016-8-31
Class web.DHCBL.CT.PHCInstrucLinkDosage Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:查询 用法与用量关联
/// Table:User.PHCInstrucLinkDosage
/// Input:rowid,instrucdr,freqdr
/// Return:ILDRowId,ILDInstrucDR,ILDDosageDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCInstrucLinkDosage","GetList","2","","","")
Query GetList(rowid As %String, instrucdr As %String, dosagedr As %String, dosagedesc) As %Query(ROWSPEC = "ILDRowId:%String,ILDInstrucDR:%String,ILDDosageDR:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, instrucdr As %String, dosagedr As %String, dosagedesc) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	
	if (rowid'="")
	{
		s ILDRowId=rowid
		s ILDInstrucDR=$p($g(^PHCINLD(ILDRowId)),"^",1)
		s:ILDInstrucDR'="" ILDInstrucDR=$p($g(^PHCIN(ILDInstrucDR)),"^",2)
		s ILDDosageDR=$p($g(^PHCINLD(ILDRowId)),"^",2)
		s:ILDDosageDR'="" ILDDosageDR=$p($g(^PHCDO(ILDDosageDR)),"^",3)
		
		d OutputRow
	}
	else
	{
		s ILDInstrucDRAuStr=##class(web.DHCBL.Authorize.PHCInstruc).DHCGetDataByDefaultSession()
		s ILDInstrucDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ILDInstrucDRAuStr="")||(ILDInstrucDRAuStr["limited:0") s ILDInstrucDRAuFlag=1	
		
		s ILDDosageDRAuStr=##class(web.DHCBL.Authorize.PHCFreq).DHCGetDataByDefaultSession()
		s ILDDosageDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ILDDosageDRAuStr="")||(ILDDosageDRAuStr["limited:0") s ILDDosageDRAuFlag=1		
		s ILDRowId=0
		for
		{
			s ILDRowId=$o(^PHCINLD(ILDRowId)) q:ILDRowId=""	
			s ILDInstrucDR=$p($g(^PHCINLD(ILDRowId)),"^",1)
			s ILDDosageDR=$p($g(^PHCINLD(ILDRowId)),"^",2)
			
			s ILDInstrucDRstrRowId="{ID:"_ILDInstrucDR_"}"
			s ILDDosageDRstrRowId="{ID:"_ILDDosageDR_"}"
			if ((ILDInstrucDRAuStr[ILDInstrucDRstrRowId)||(ILDInstrucDRAuFlag=1))&&((ILDDosageDRAuStr[ILDDosageDRstrRowId)||(ILDDosageDRAuFlag=1)) ;用来筛选授权数据
			{
				s ILDInstrucDRID=ILDInstrucDR
				s ILDDosageDRID=ILDDosageDR
				s:ILDInstrucDR'="" ILDInstrucDR=$p($g(^PHCIN(ILDInstrucDR)),"^",2)
				s:ILDDosageDR'="" ILDDosageDR=$p($g(^PHCDO(ILDDosageDR)),"^",3)
				i ((ILDInstrucDRID=instrucdr)||(instrucdr=""))&&((ILDDosageDRID=dosagedr)||(dosagedr=""))&&($zcvt(ILDDosageDR,"U")[$zcvt(dosagedesc,"U"))
				{
					d OutputRow
				}	
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ILDRowId,ILDInstrucDR,ILDDosageDR)
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

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:数据重复验证方法,js调用
/// Table:User.PHCInstrucLinkDosage
/// Input:id, instruc, dosage
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkDosage).FormValidate("","","")
ClassMethod FormValidate(id As %String, instruc As %String, dosage As %String) As %String
{
	new (id,instruc,dosage)
	q:(instruc="")||(dosage="") 0
	s flag=""
	s idd=$o(^PHCINLD(0,"Link",instruc,dosage,0))
	if (idd="")
	{
		s flag=0
	}
	else
	{
		if (id="") //如果为空，增加时的重复判断
		{
			s flag=1  //返回重复标志	
		}
		else //如果不为空，修改时的重复判断
		{
			if (idd'=id) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
			
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:双击修改时,从后台取数据
/// Table:User.PHCInstrucLinkDosage
/// Input:id
/// Return:Json格式的字符串str={list:[ILDInstrucDR,ILDDosageDR,ILDDateFrom,ILDDateTo,ILDRowId]}
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkDosage).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s pobj = ##class(User.PHCInstrucLinkDosage).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCInstrucLinkDosage).%New()
	s eobj.ILDRowId = id
	if $IsObject(pobj.ILDInstrucDR){
		s eobj.ILDInstrucDR = pobj.ILDInstrucDR.%Id() 
		}
	if $IsObject(pobj.ILDDosageDR){
		s eobj.ILDDosageDR = pobj.ILDDosageDR.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:增加/修改 用法与用量关联
/// Table:User.PHCInstrucLinkDosage
/// Input:web.Entity.CT.PHCInstrucLinkDosage
/// Return:成功返回success:'true'和新增或修改的数据的ILDRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCInstrucLinkDosage) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ILDRowId,eobj.ILDInstrucDR,eobj.ILDDosageDR)
		if (flag=0)
		{
	
		if (eobj.ILDRowId="")       
		{
			s obj=##class(User.PHCInstrucLinkDosage).%New()
		}
		else                           
		{
			s obj=##class(User.PHCInstrucLinkDosage).%OpenId(eobj.ILDRowId)
			
			s bobj=##class(web.Entity.CT.PHCInstrucLinkDosage).%New()
			s bobj.ILDRowId = eobj.ILDRowId
			if $IsObject(obj.ILDInstrucDR){
					s bobj.ILDInstrucDR = obj.ILDInstrucDR.%Id() 
				}
			if $IsObject(obj.ILDDosageDR){
					s bobj.ILDDosageDR = obj.ILDDosageDR.%Id() 
				}
			}
		d obj.ILDInstrucDRSetObjectId(eobj.ILDInstrucDR)
		d obj.ILDDosageDRSetObjectId(eobj.ILDDosageDR)
		s Desc=eobj.ILDInstrucDR_"-"_eobj.ILDDosageDR
		s:(eobj.ILDDosageDR'="")&&(eobj.ILDInstrucDR'="") Desc=$p($g(^PHCIN(eobj.ILDInstrucDR)),"^",2)_"-"_$p($g(^PHCDO(eobj.ILDDosageDR)),"^",2)
	
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ILDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkDosage","User.PHCInstrucLinkDosage","用法与用量关联",id,Desc,"A",eobj)
			d:eobj.ILDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkDosage","User.PHCInstrucLinkDosage","用法与用量关联",id,Desc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法与用量关联","web.DHCBL.CT.PHCInstrucLinkDosage","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		}
		else
		{
			s result = "{success:'false',errorinfo:'该数据已存在！'}"
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:根据id删除用法与用量关联
/// Table:User.PHCInstrucLinkDosage
/// Input:id(PHCInstrucLinkDosage的ILDRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkDosage).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	N (id,%session)
	s result=""
	
	s pobj = ##class(User.PHCInstrucLinkDosage).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCInstrucLinkDosage).%New()
	s eobj.ILDRowId = id
	if $IsObject(pobj.ILDInstrucDR){
		s eobj.ILDInstrucDR = pobj.ILDInstrucDR.%Id() 
		}
	if $IsObject(pobj.ILDDosageDR){
		s eobj.ILDDosageDR = pobj.ILDDosageDR.%Id() 
		}
	s Desc=eobj.ILDInstrucDR_"-"_eobj.ILDDosageDR
	s:(eobj.ILDDosageDR'="")&&(eobj.ILDInstrucDR'="") Desc=$p($g(^PHCIN(eobj.ILDInstrucDR)),"^",2)_"-"_$p($g(^PHCDO(eobj.ILDDosageDR)),"^",2)
		
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PHCInstrucLinkDosage).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkDosage","User.PHCInstrucLinkDosage","用法与用量关联",id,Desc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法与用量关联","web.DHCBL.CT.PHCInstrucLinkDosage","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	q result
}

}
