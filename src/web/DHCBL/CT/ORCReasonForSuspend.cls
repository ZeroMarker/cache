Import SQLUser

/// 名称:手术和过程 - 17 手术延缓原因	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-12
Class web.DHCBL.CT.ORCReasonForSuspend Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:查询 手术延缓原因
/// Table:User.ORCReasonForSuspend
/// Input:rowid,code,desc,DefaultForAutomatic
/// Return:SUSPRowId,SUSPCode,SUSPDesc,SUSPDefaultForAutomatic
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonForSuspend","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, dfa As %String) As %Query(ROWSPEC = "SUSPRowId:%String,SUSPCode:%String,SUSPDesc:%String,SUSPDefaultForAutomatic:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, dfa As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s SUSPRowId=rowid
		s SUSPCode=$p($g(^ORC("SUSP",SUSPRowId)),"^",1)
		s SUSPDesc=$p($g(^ORC("SUSP",SUSPRowId)),"^",2)
		s SUSPDefaultForAutomatic=$p($g(^ORC("SUSP",SUSPRowId)),"^",3)
		s:SUSPDefaultForAutomatic="" SUSPDefaultForAutomatic="N"
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonForSuspend",SUSPRowId)
     	s BDPInternalCode =$p($g(resultStr),"^",1)       
     	s BDPInternalDesc = $p($g(resultStr),"^",2)  
     	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonForSuspend).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s SUSPRowId=0
		for
		{
			s SUSPRowId=$o(^ORC("SUSP",SUSPRowId)) q:SUSPRowId=""
			s strRowId="{ID:"_SUSPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s SUSPCode=$p($g(^ORC("SUSP",SUSPRowId)),"^",1)
				s SUSPDesc=$p($g(^ORC("SUSP",SUSPRowId)),"^",2)
				s SUSPDefaultForAutomatic=$p($g(^ORC("SUSP",SUSPRowId)),"^",3)
				s:SUSPDefaultForAutomatic="" SUSPDefaultForAutomatic="N"
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonForSuspend",SUSPRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonForSuspend",SUSPRowId,SUSPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(SUSPCode,"u")[code)&(AliasFlag=1)&&((dfa=SUSPDefaultForAutomatic)||(dfa=""))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SUSPRowId,SUSPCode,SUSPDesc,SUSPDefaultForAutomatic,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2013-2-19
/// Description:为combobox查询取数据
/// Table:User.ORCReasonForSuspend
/// Input:code,desc
/// Return:SUSPRowId,SUSPCode,SUSPDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonForSuspend","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SUSPRowId:%String,SUSPCode:%String,SUSPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s SUSPRowId=rowid
		s SUSPCode=$p($g(^ORC("SUSP",SUSPRowId)),"^",1)
		s SUSPDesc=$p($g(^ORC("SUSP",SUSPRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonForSuspend).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s SUSPRowId=0
		for
		{
			s SUSPRowId=$o(^ORC("SUSP",SUSPRowId)) q:SUSPRowId=""
			s strRowId="{ID:"_SUSPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s SUSPCode=$p($g(^ORC("SUSP",SUSPRowId)),"^",1)
				s SUSPDesc=$p($g(^ORC("SUSP",SUSPRowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonForSuspend",SUSPRowId,SUSPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(SUSPCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(SUSPRowId,SUSPCode,SUSPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.ORCReasonForSuspend
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCReasonForSuspend).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("SUSP",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("SUSP",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idd=""
		s:code'="" idc=$o(^ORC("SUSP",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("SUSP",0,"Desc",desc,0))
		
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:双击修改时从后台取数据
/// Table:User.ORCReasonForSuspend
/// Input:id
/// Return:Json格式的字符串str={list:[SUSPCode,SUSPDesc,SUSPDefaultForAutomatic,SUSPRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCReasonForSuspend).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCReasonForSuspend).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonForSuspend).%New()
	s eobj.SUSPRowId = id
	s eobj.SUSPCode = pobj.SUSPCode
	s eobj.SUSPDesc = pobj.SUSPDesc
	//checkbox
	s:pobj.SUSPDefaultForAutomatic="Y" eobj.SUSPDefaultForAutomatic="true"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:增加/修改 手术延缓原因
/// Table:User.ORCReasonForSuspend
/// Input:web.Entity.CT.ORCReasonForSuspend 实体类
/// Return:成功返回success:'true'和新增或修改的数据的SUSPRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCReasonForSuspend) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.SUSPDefaultForAutomatic="" eobj.SUSPDefaultForAutomatic="N"
		s flag=..FormValidate(eobj.SUSPRowId,eobj.SUSPCode,eobj.SUSPDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.SUSPRowId="")       
		{
			s obj=##class(User.ORCReasonForSuspend).%New()
		}
		else                           
		{
			s obj=##class(User.ORCReasonForSuspend).%OpenId(eobj.SUSPRowId)
			
			s bobj = ##class(web.Entity.CT.ORCReasonForSuspend).%New()
			s bobj.SUSPRowId = eobj.SUSPRowId
			s bobj.SUSPCode = obj.SUSPCode
			s bobj.SUSPDesc = obj.SUSPDesc
			s bobj.SUSPDefaultForAutomatic = obj.SUSPDefaultForAutomatic
		}

		s obj.SUSPCode = eobj.SUSPCode
		s obj.SUSPDesc = eobj.SUSPDesc
		s obj.SUSPDefaultForAutomatic = eobj.SUSPDefaultForAutomatic
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.SUSPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForSuspend","User.ORCReasonForSuspend","手术延缓原因",id,eobj.SUSPDesc,"A",eobj)
			d:eobj.SUSPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForSuspend","User.ORCReasonForSuspend","手术延缓原因",id,eobj.SUSPDesc,"U",eobj,bobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术延缓原因","web.DHCBL.CT.ORCReasonForSuspend","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	

	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:根据id删除 手术延缓原因
/// Table:User.ORCReasonForSuspend
/// Input:id(ORCReasonForSuspend的SUSPRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCReasonForSuspend).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCReasonForSuspend).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonForSuspend).%New()
	s eobj.SUSPRowId = id
	s eobj.SUSPCode = pobj.SUSPCode
	s eobj.SUSPDesc = pobj.SUSPDesc
	//checkbox
	//s:pobj.SUSPDefaultForAutomatic="Y" eobj.SUSPDefaultForAutomatic="true"
	s eobj.SUSPDefaultForAutomatic=pobj.SUSPDefaultForAutomatic
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCReasonForSuspend).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForSuspend","User.ORCReasonForSuspend","手术延缓原因",id,eobj.SUSPDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术延缓原因","web.DHCBL.CT.ORCReasonForSuspend","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
