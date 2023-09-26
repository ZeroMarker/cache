Import SQLUser

/// 名称:手术和过程 - 8 麻醉方法类型	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.DHCBL.CT.ORCAnaestType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 麻醉方法类型
/// Table:User.ORCAnaestType
/// Input:rowid,code,desc
/// Return:ANTYPERowId,ANTYPECode,ANTYPEDesc,ANTYPEDateFrom,ANTYPEDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANTYPERowId:%String,ANTYPECode:%String,ANTYPEDesc:%String,ANTYPEDateFrom:%String,ANTYPEDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ANTYPERowId=rowid
		s ANTYPECode=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",1)
		s ANTYPEDesc=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
		s ANTYPEDateFrom=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",3)
		s ANTYPEDateTo=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",4)
		s:ANTYPEDateFrom'="" ANTYPEDateFrom=$zd(ANTYPEDateFrom,1)
		s:ANTYPEDateTo'="" ANTYPEDateTo=$zd(ANTYPEDateTo,1)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestType",ANTYPERowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANTYPERowId=0
		for
		{
			s ANTYPERowId=$o(^ORC("ANTYPE",ANTYPERowId)) q:ANTYPERowId=""
			s strRowId="{ID:"_ANTYPERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ANTYPECode=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",1)
				s ANTYPEDesc=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
				s ANTYPEDateFrom=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",3)
				s ANTYPEDateTo=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",4)
				s:ANTYPEDateFrom'="" ANTYPEDateFrom=$zd(ANTYPEDateFrom,1)
				s:ANTYPEDateTo'="" ANTYPEDateTo=$zd(ANTYPEDateTo,1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestType",ANTYPERowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestType",ANTYPERowId,ANTYPEDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANTYPEDesc,"u")[code)&(AliasFlag=1)
				{				
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ANTYPERowId,ANTYPECode,ANTYPEDesc,ANTYPEDateFrom,ANTYPEDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCAnaestType
/// Input:code,desc
/// Return:ANTYPERowId,ANTYPECode,ANTYPEDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestType","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANTYPERowId:%String,ANTYPECode:%String,ANTYPEDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ANTYPERowId=rowid
		s ANTYPECode=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",1)
		s ANTYPEDesc=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANTYPERowId=0
		for
		{
			s ANTYPERowId=$o(^ORC("ANTYPE",ANTYPERowId)) q:ANTYPERowId=""
			s strRowId="{ID:"_ANTYPERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ANTYPECode=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",1)
				s ANTYPEDesc=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
				s ANTYPEDateFrom=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",3)
				continue:(ANTYPEDateFrom'="")&&(ANTYPEDateFrom>+$h)
				s ANTYPEDateTo=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",4)
				continue:(ANTYPEDateTo'="")&&(ANTYPEDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestType",ANTYPERowId,ANTYPEDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANTYPEDesc,"u")[code)&(AliasFlag=1)
				{	
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ANTYPERowId,ANTYPECode,ANTYPEDesc)
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
/// Table:User.ORCAnaestType
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCAnaestType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("ANTYPE",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("ANTYPE",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("ANTYPE",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("ANTYPE",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}	
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:双击修改时,从后台取数据
/// Table:User.ORCAnaestType
/// Input:id
/// Return:Json格式的字符串str={list:[ANTYPECode,ANTYPEDesc,ANTYPEDateFrom,ANTYPEDateTo,ANTYPERowId]}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCAnaestType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCAnaestType).%New()
	s eobj.ANTYPERowId = id
	s eobj.ANTYPECode = pobj.ANTYPECode
	s eobj.ANTYPEDesc = pobj.ANTYPEDesc
	s eobj.ANTYPEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ANTYPEDateFrom)
	s eobj.ANTYPEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ANTYPEDateTo)
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:增加/修改 麻醉方法类型
/// Table:User.ORCAnaestType
/// Input:web.Entity.CT.ORCAnaestType
/// Return:成功返回success:'true'和新增或修改的数据的ANTYPERowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCAnaestType) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ANTYPEDateFrom'="" eobj.ANTYPEDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ANTYPEDateFrom)
		s:eobj.ANTYPEDateTo'="" eobj.ANTYPEDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ANTYPEDateTo)
		s:eobj.ANTYPEDateFrom="" eobj.ANTYPEDateFrom = +$h
		s flag=..FormValidate(eobj.ANTYPERowId,eobj.ANTYPECode,eobj.ANTYPEDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ANTYPERowId="")       
		{
			s obj=##class(User.ORCAnaestType).%New()
		}
		else                           
		{
			s obj=##class(User.ORCAnaestType).%OpenId(eobj.ANTYPERowId)
			s bobj=##class(web.Entity.CT.ORCAnaestType).%New()
			s bobj.ANTYPERowId = eobj.ANTYPERowId
			s bobj.ANTYPECode = obj.ANTYPECode
			s bobj.ANTYPEDesc = obj.ANTYPEDesc
			s bobj.ANTYPEDateFrom=obj.ANTYPEDateFrom
			s bobj.ANTYPEDateTo=obj.ANTYPEDateTo
		}
			
		s obj.ANTYPECode = eobj.ANTYPECode
		s obj.ANTYPEDesc = eobj.ANTYPEDesc
		s obj.ANTYPEDateFrom=eobj.ANTYPEDateFrom
		s obj.ANTYPEDateTo=eobj.ANTYPEDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ANTYPERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestType","User.ORCAnaestType","麻醉方法类型",id,eobj.ANTYPEDesc,"A",eobj)
			d:eobj.ANTYPERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestType","User.ORCAnaestType","麻醉方法类型",id,eobj.ANTYPEDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法类型","web.DHCBL.CT.ORCAnaestType","SaveEntity",eobj)
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
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s ANMETRowId=0,flag=0
	for
	{
		s ANMETRowId=$o(^ORC("ANMET",ANMETRowId)) q:(ANMETRowId="")||(flag=1)
		s ANMETTypeDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",3)
		i ANMETTypeDR=id
		{
			s flag=1
			s myInfo=myInfo_"<麻醉方法>"
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:根据id删除 麻醉方法类型
/// Table:User.ORCAnaestType
/// Input:id(ORCAnaestType的ANTYPERowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestType).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.ORCAnaestType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCAnaestType).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCAnaestType).%New()
		s eobj.ANTYPERowId = id
		s eobj.ANTYPECode = pobj.ANTYPECode
		s eobj.ANTYPEDesc = pobj.ANTYPEDesc
		s eobj.ANTYPEDateFrom =pobj.ANTYPEDateFrom
		s eobj.ANTYPEDateTo = pobj.ANTYPEDateTo
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCAnaestType).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestType","User.ORCAnaestType","麻醉方法类型",id,eobj.ANTYPEDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法类型","web.DHCBL.CT.ORCAnaestType","DeleteData",eobj)
		    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
