Import SQLUser

/// 名称:手术和过程 - 15 手术室类型
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ORCOperTheatreType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 手术室类型
/// Table:User.ORCOperTheatreType
/// Input:rowid,code,desc
/// Return:OTTYPERowId,OTTYPECode,OTTYPEDesc,OTTYPEDateFrom,OTTYPEDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperTheatreType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "OTTYPERowId:%String,OTTYPECode:%String,OTTYPEDesc:%String,OTTYPEDateFrom:%String,OTTYPEDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s OTTYPERowId=rowid
		s OTTYPECode=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",1)
		s OTTYPEDesc=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",2)
		s OTTYPEDateFrom=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",3)
		s OTTYPEDateTo=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",4)
		s:OTTYPEDateFrom'="" OTTYPEDateFrom=$zd(OTTYPEDateFrom,1)
		s:OTTYPEDateTo'="" OTTYPEDateTo=$zd(OTTYPEDateTo,1)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_OperTheatreType",OTTYPERowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCOperTheatreType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s OTTYPERowId=0
		for
		{
			s OTTYPERowId=$o(^ORC("OTTYPE",OTTYPERowId)) q:OTTYPERowId=""
			s strRowId="{ID:"_OTTYPERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s OTTYPECode=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",1)
				s OTTYPEDesc=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",2)
				s OTTYPEDateFrom=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",3)
				s OTTYPEDateTo=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",4)
				s:OTTYPEDateFrom'="" OTTYPEDateFrom=$zd(OTTYPEDateFrom,1)
				s:OTTYPEDateTo'="" OTTYPEDateTo=$zd(OTTYPEDateTo,1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_OperTheatreType",OTTYPERowId)
    			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_OperTheatreType",OTTYPERowId,OTTYPEDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(OTTYPECode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(OTTYPERowId,OTTYPECode,OTTYPEDesc,OTTYPEDateFrom,OTTYPEDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCOperTheatreType
/// Input:code,desc
/// Return:OTTYPERowId,OTTYPECode,OTTYPEDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperTheatreType","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "OTTYPERowId:%String,OTTYPECode:%String,OTTYPEDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s OTTYPERowId=rowid
		s OTTYPECode=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",1)
		s OTTYPEDesc=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCOperTheatreType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s OTTYPERowId=0
		for
		{
			s OTTYPERowId=$o(^ORC("OTTYPE",OTTYPERowId)) q:OTTYPERowId=""
			s strRowId="{ID:"_OTTYPERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s OTTYPECode=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",1)
				s OTTYPEDesc=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",2)
				s OTTYPEDateFrom=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",3)
				continue:(OTTYPEDateFrom'="")&&(OTTYPEDateFrom>+$h)
				
				s OTTYPEDateTo=$p($g(^ORC("OTTYPE",OTTYPERowId)),"^",4)
				continue:(OTTYPEDateTo'="")&&(OTTYPEDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_OperTheatreType",OTTYPERowId,OTTYPEDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(OTTYPECode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(OTTYPERowId,OTTYPECode,OTTYPEDesc)
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
/// Table:User.ORCOperTheatreType
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCOperTheatreType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("OTTYPE",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("OTTYPE",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("OTTYPE",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("OTTYPE",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:双击修改时,从后台取数据
/// Table:User.ORCOperTheatreType
/// Input:id
/// Return:Json格式的字符串str={list:[OTTYPECode,OTTYPEDesc,OTTYPEDateFrom,OTTYPEDateTo,OTTYPERowId]}
/// Other:d ##class(web.DHCBL.CT.ORCOperTheatreType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCOperTheatreType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperTheatreType).%New()
	s eobj.OTTYPERowId = id
	s eobj.OTTYPECode = pobj.OTTYPECode
	s eobj.OTTYPEDesc = pobj.OTTYPEDesc
	s eobj.OTTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OTTYPEDateFrom)
	s eobj.OTTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.OTTYPEDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:增加/修改 手术室类型
/// Table:User.ORCOperTheatreType
/// Input:web.Entity.CT.ORCOperTheatreType
/// Return:成功返回success:'true'和新增或修改的数据的OTTYPERowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperTheatreType) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OTTYPEDateFrom'="" eobj.OTTYPEDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OTTYPEDateFrom)
		s:eobj.OTTYPEDateTo'="" eobj.OTTYPEDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OTTYPEDateTo)
		s:eobj.OTTYPEDateFrom="" eobj.OTTYPEDateFrom = +$h
		s flag=..FormValidate(eobj.OTTYPERowId,eobj.OTTYPECode,eobj.OTTYPEDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.OTTYPERowId="")       
		{
			s obj=##class(User.ORCOperTheatreType).%New()
		}
		else                           
		{
			s obj=##class(User.ORCOperTheatreType).%OpenId(eobj.OTTYPERowId)
			
			s bobj = ##class(web.Entity.CT.ORCOperTheatreType).%New()
			s bobj.OTTYPERowId = eobj.OTTYPERowId
			s bobj.OTTYPECode = obj.OTTYPECode
			s bobj.OTTYPEDesc = obj.OTTYPEDesc
			s bobj.OTTYPEDateFrom=obj.OTTYPEDateFrom
			s bobj.OTTYPEDateTo=obj.OTTYPEDateTo
		}
		s obj.OTTYPECode = eobj.OTTYPECode
		s obj.OTTYPEDesc = eobj.OTTYPEDesc
		s obj.OTTYPEDateFrom=eobj.OTTYPEDateFrom
		s obj.OTTYPEDateTo=eobj.OTTYPEDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.OTTYPERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperTheatreType","User.ORCOperTheatreType","手术室类型",id,eobj.OTTYPEDesc,"A",eobj)
			d:eobj.OTTYPERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperTheatreType","User.ORCOperTheatreType","手术室类型",id,eobj.OTTYPEDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术室类型","web.DHCBL.CT.ORCOperTheatreType","SaveEntity",eobj)
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
/// CreatDate:2012-9-6
/// Description:根据id删除 手术室类型
/// Table:User.ORCOperTheatreType
/// Input:id(ORCOperTheatreType的OTTYPERowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCOperTheatreType).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCOperTheatreType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperTheatreType).%New()
	s eobj.OTTYPERowId = id
	s eobj.OTTYPECode = pobj.OTTYPECode
	s eobj.OTTYPEDesc = pobj.OTTYPEDesc
	s eobj.OTTYPEDateFrom = pobj.OTTYPEDateFrom 
	s eobj.OTTYPEDateTo =  pobj.OTTYPEDateTo 
	//s:pobj.OTTYPEDateFrom'="" eobj.OTTYPEDateFrom =$zd(pobj.OTTYPEDateFrom,1)
	//s:pobj.OTTYPEDateTo'="" eobj.OTTYPEDateTo = $zd(pobj.OTTYPEDateTo,1)
	d pobj.%Close()
	Tstart
	s sc=##class(User.ORCOperTheatreType).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperTheatreType","User.ORCOperTheatreType","手术室类型",id,eobj.OTTYPEDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术室类型","web.DHCBL.CT.ORCOperTheatreType","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
