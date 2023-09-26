Import SQLUser

/// 名称:药学 -  用法与频次关联
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2016-8-31
Class web.DHCBL.CT.PHCInstrucLinkFreq Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:查询 用法与频次关联
/// Table:User.PHCInstrucLinkFreq
/// Input:rowid,instrucdr,freqdr
/// Return:ILFRowId,ILFInstrucDR,ILFFreqDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCInstrucLinkFreq","GetList","","2","","")
Query GetList(rowid As %String, instrucdr As %String, freqdr As %String, freqdesc As %String) As %Query(ROWSPEC = "ILFRowId:%String,ILFInstrucDR:%String,ILFFreqDR:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, instrucdr As %String, freqdr As %String, freqdesc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	
	if (rowid'="")
	{
		s ILFRowId=rowid
		s ILFInstrucDR=$p($g(^PHCINLF(ILFRowId)),"^",1)
		s:ILFInstrucDR'="" ILFInstrucDR=$p($g(^PHCIN(ILFInstrucDR)),"^",2)
		s ILFFreqDR=$p($g(^PHCINLF(ILFRowId)),"^",2)
		s:ILFFreqDR'="" ILFFreqDR=$p($g(^PHCFR(ILFFreqDR)),"^",3)
		d OutputRow
	}
	else
	{
		s ILFInstrucDRAuStr=##class(web.DHCBL.Authorize.PHCInstruc).DHCGetDataByDefaultSession()
		s ILFInstrucDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ILFInstrucDRAuStr="")||(ILFInstrucDRAuStr["limited:0") s ILFInstrucDRAuFlag=1	
		
		s ILFFreqDRAuStr=##class(web.DHCBL.Authorize.PHCFreq).DHCGetDataByDefaultSession()
		s ILFFreqDRAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ILFFreqDRAuStr="")||(ILFFreqDRAuStr["limited:0") s ILFFreqDRAuFlag=1		
		
		s ILFRowId=0
		for
		{
			s ILFRowId=$o(^PHCINLF(ILFRowId)) q:ILFRowId=""	
			s ILFInstrucDR=$p($g(^PHCINLF(ILFRowId)),"^",1)
			s ILFFreqDR=$p($g(^PHCINLF(ILFRowId)),"^",2)
			
			s ILFInstrucDRstrRowId="{ID:"_ILFInstrucDR_"}"
			s ILFFreqDRstrRowId="{ID:"_ILFFreqDR_"}"
			if ((ILFInstrucDRAuStr[ILFInstrucDRstrRowId)||(ILFInstrucDRAuFlag=1))&&((ILFFreqDRAuStr[ILFFreqDRstrRowId)||(ILFFreqDRAuFlag=1)) ;用来筛选授权数据
			{
				
				s ILFInstrucDRID=ILFInstrucDR
				s ILFFreqDRID=ILFFreqDR
				s:ILFInstrucDR'="" ILFInstrucDR=$p($g(^PHCIN(ILFInstrucDR)),"^",2)
				s:ILFFreqDR'="" ILFFreqDR=$p($g(^PHCFR(ILFFreqDR)),"^",3)
				i ((ILFInstrucDRID=instrucdr)||(instrucdr=""))&&((ILFFreqDRID=freqdr)||(freqdr=""))&&($zcvt(ILFFreqDR,"U")[$ZCVT(freqdesc,"U"))
				{
					d OutputRow
				}	
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ILFRowId,ILFInstrucDR,ILFFreqDR)
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
/// Table:User.PHCInstrucLinkFreq
/// Input:id, instruc, freq
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkFreq).FormValidate("","","")
ClassMethod FormValidate(id As %String, instruc As %String, freq As %String) As %String
{
	new (id,instruc,freq)
	q:(instruc="")||(freq="") 0
	s flag=""
	s idd=$o(^PHCINLF(0,"Link",instruc,freq,0))
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
/// Table:User.PHCInstrucLinkFreq
/// Input:id
/// Return:Json格式的字符串str={list:[ILFInstrucDR,ILFFreqDR,ILFDateFrom,ILFDateTo,ILFRowId]}
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkFreq).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s pobj = ##class(User.PHCInstrucLinkFreq).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCInstrucLinkFreq).%New()
	s eobj.ILFRowId = id
	if $IsObject(pobj.ILFInstrucDR){
		s eobj.ILFInstrucDR = pobj.ILFInstrucDR.%Id() 
		}
	if $IsObject(pobj.ILFFreqDR){
		s eobj.ILFFreqDR = pobj.ILFFreqDR.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2016-8-31
/// Description:增加/修改 用法与频次关联
/// Table:User.PHCInstrucLinkFreq
/// Input:web.Entity.CT.PHCInstrucLinkFreq
/// Return:成功返回success:'true'和新增或修改的数据的ILFRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCInstrucLinkFreq) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ILFRowId,eobj.ILFInstrucDR,eobj.ILFFreqDR)
		if (flag=0)
		{
		
		if (eobj.ILFRowId="")       
		{
			s obj=##class(User.PHCInstrucLinkFreq).%New()
		}
		else                           
		{
			s obj=##class(User.PHCInstrucLinkFreq).%OpenId(eobj.ILFRowId)
			
			s bobj=##class(web.Entity.CT.PHCInstrucLinkFreq).%New()
			s bobj.ILFRowId = eobj.ILFRowId
			if $IsObject(obj.ILFInstrucDR){
					s bobj.ILFInstrucDR = obj.ILFInstrucDR.%Id() 
				}
			if $IsObject(obj.ILFFreqDR){
					s bobj.ILFFreqDR = obj.ILFFreqDR.%Id() 
				}
			}
		d obj.ILFInstrucDRSetObjectId(eobj.ILFInstrucDR)
		d obj.ILFFreqDRSetObjectId(eobj.ILFFreqDR)
		s Desc=eobj.ILFInstrucDR_"-"_eobj.ILFFreqDR
		s:(eobj.ILFFreqDR'="")&&(eobj.ILFInstrucDR'="") Desc=$p($g(^PHCIN(eobj.ILFInstrucDR)),"^",2)_"-"_$p($g(^PHCFR(eobj.ILFFreqDR)),"^",3)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ILFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkFreq","User.PHCInstrucLinkFreq","用法与频次关联",id,Desc,"A",eobj)
			d:eobj.ILFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkFreq","User.PHCInstrucLinkFreq","用法与频次关联",id,Desc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法与频次关联","web.DHCBL.CT.PHCInstrucLinkFreq","SaveEntity",eobj)
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
/// Description:根据id删除用法与频次关联
/// Table:User.PHCInstrucLinkFreq
/// Input:id(PHCInstrucLinkFreq的ILFRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PHCInstrucLinkFreq).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	N (id,%session)
	s result=""
	s pobj = ##class(User.PHCInstrucLinkFreq).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCInstrucLinkFreq).%New()
	s eobj.ILFRowId = id
	if $IsObject(pobj.ILFInstrucDR){
		s eobj.ILFInstrucDR = pobj.ILFInstrucDR.%Id() 
		}
	if $IsObject(pobj.ILFFreqDR){
		s eobj.ILFFreqDR = pobj.ILFFreqDR.%Id() 
		}
	s Desc=eobj.ILFInstrucDR_"-"_eobj.ILFFreqDR
	s:(eobj.ILFFreqDR'="")&&(eobj.ILFInstrucDR'="") Desc=$p($g(^PHCIN(eobj.ILFInstrucDR)),"^",2)_"-"_$p($g(^PHCFR(eobj.ILFFreqDR)),"^",3)
		
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PHCInstrucLinkFreq).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_InstrucLinkFreq","User.PHCInstrucLinkFreq","用法与频次关联",id,Desc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法与频次关联","web.DHCBL.CT.PHCInstrucLinkFreq","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}

	q result
}

}
