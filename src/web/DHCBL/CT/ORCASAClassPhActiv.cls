Import SQLUser

/// 名称:手术和过程 - 1 ASA分级	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-3
Class web.DHCBL.CT.ORCASAClassPhActiv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-20
/// Description:查询 ASA分级
/// Table:User.ORCASAClassPhActiv
/// Input:rowid,code,desc
/// Return:ORASARowId,ORASACode,ORASADesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCASAClassPhActiv","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ORASARowId:%String,ORASACode:%String,ORASADesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ORASARowId=rowid
		s ORASACode=$p($g(^ORC("ASA",ORASARowId)),"^",1)
		s ORASADesc=$p($g(^ORC("ASA",ORASARowId)),"^",2)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ASA_ClassPhActiv",ORASARowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCASAClassPhActiv).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ORASARowId=0
		for
		{
			s ORASARowId=$o(^ORC("ASA",ORASARowId)) q:ORASARowId=""
			s strRowId="{ID:"_ORASARowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ORASACode=$p($g(^ORC("ASA",ORASARowId)),"^",1)
				s ORASADesc=$p($g(^ORC("ASA",ORASARowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ASA_ClassPhActiv",ORASARowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ASA_ClassPhActiv",ORASARowId,ORASADesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ORASACode,"u")[code)&(AliasFlag=1)
				{	
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ORASARowId,ORASACode,ORASADesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.ORCASAClassPhActiv
/// Input:code,desc
/// Return:ORASARowId,ORASACode,ORASADesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCASAClassPhActiv","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ORASARowId:%String,ORASACode:%String,ORASADesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ORASARowId=rowid
		s ORASACode=$p($g(^ORC("ASA",ORASARowId)),"^",1)
		s ORASADesc=$p($g(^ORC("ASA",ORASARowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCASAClassPhActiv).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ORASARowId=0
		for
		{
			s ORASARowId=$o(^ORC("ASA",ORASARowId)) q:ORASARowId=""
			s strRowId="{ID:"_ORASARowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ORASACode=$p($g(^ORC("ASA",ORASARowId)),"^",1)
				s ORASADesc=$p($g(^ORC("ASA",ORASARowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ASA_ClassPhActiv",ORASARowId,ORASADesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ORASACode,"u")[code)&(AliasFlag=1)
				{	
					d OutputRowCmb
				}
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ORASARowId,ORASACode,ORASADesc)
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
/// Table:User.ORCASAClassPhActiv
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCASAClassPhActiv).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("ASA",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("ASA",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("ASA",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("ASA",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
		
		
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-3
/// Description:双击修改时从后台取数据
/// Table:User.ORCASAClassPhActiv
/// Input:id
/// Return:Json格式的字符串str={list:[ORASACode,ORASADesc,ORASARowId]}
/// Other:d ##class(web.DHCBL.CT.ORCASAClassPhActiv).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCASAClassPhActiv).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCASAClassPhActiv).%New()
	s eobj.ORASARowId = id
	s eobj.ORASACode = pobj.ORASACode
	s eobj.ORASADesc = pobj.ORASADesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-3
/// Description:增加/修改 ASA分级
/// Table:User.ORCASAClassPhActiv
/// Input:web.Entity.CT.ORCASAClassPhActiv 实体类
/// Return:成功返回success:'true'和新增或修改的数据的ORASARowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCASAClassPhActiv) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		s flag=..FormValidate(eobj.ORASARowId,eobj.ORASACode,eobj.ORASADesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ORASARowId="")       
		{
			s obj=##class(User.ORCASAClassPhActiv).%New()
		}
		else                           
		{
			s obj=##class(User.ORCASAClassPhActiv).%OpenId(eobj.ORASARowId)
			s bobj=##class(web.Entity.CT.ORCASAClassPhActiv).%New()
			s bobj.ORASARowId = eobj.ORASARowId
			s bobj.ORASACode = obj.ORASACode
			s bobj.ORASADesc = obj.ORASADesc
		}
		s obj.ORASACode = eobj.ORASACode
		s obj.ORASADesc = eobj.ORASADesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ORASARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ASA_ClassPhActiv","User.ORCASAClassPhActiv","ASA分级",id,eobj.ORASADesc,"A",eobj)
			d:eobj.ORASARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ASA_ClassPhActiv","User.ORCASAClassPhActiv","ASA分级",id,eobj.ORASADesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ASA分级","web.DHCBL.CT.ORCASAClassPhActiv","SaveEntity",eobj)
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
/// CreatDate:2012-9-3
/// Description:根据id删除 ASA分级
/// Table:User.ORCASAClassPhActiv
/// Input:id(ORCASAClassPhActiv的ORASARowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCASAClassPhActiv).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.ORCASAClassPhActiv).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCASAClassPhActiv).%New()
	s eobj.ORASARowId = id
	s eobj.ORASACode = pobj.ORASACode
	s eobj.ORASADesc = pobj.ORASADesc
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCASAClassPhActiv).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ASA_ClassPhActiv","User.ORCASAClassPhActiv","ASA分级",id,eobj.ORASADesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ASA分级","web.DHCBL.CT.ORCASAClassPhActiv","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
