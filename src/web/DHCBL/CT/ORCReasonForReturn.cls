Import SQLUser

/// 名称:手术和过程 - 2 返回原因	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.ORCReasonForReturn Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 返回原因
/// Table:User.ORCReasonForReturn
/// Input:rowid,code,desc
/// Return:RFRRowId,RFRCode,RFRDesc,RFRDateFrom,RFRDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonForReturn","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFRRowId:%String,RFRCode:%String,RFRDesc:%String,RFRDateFrom:%String,RFRDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s RFRRowId=rowid
		s RFRCode=$p($g(^ORC("RFRET",RFRRowId)),"^",1)
		s RFRDesc=$p($g(^ORC("RFRET",RFRRowId)),"^",2)
		s RFRDateFrom=$p($g(^ORC("RFRET",RFRRowId)),"^",3)
		s RFRDateTo=$p($g(^ORC("RFRET",RFRRowId)),"^",4)
		s:RFRDateFrom'="" RFRDateFrom=$zd(RFRDateFrom,1)
		s:RFRDateTo'="" RFRDateTo=$zd(RFRDateTo,1)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonForReturn",RFRRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonForReturn).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RFRRowId=0
		for
		{
			s RFRRowId=$o(^ORC("RFRET",RFRRowId)) q:RFRRowId=""
			s strRowId="{ID:"_RFRRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RFRCode=$p($g(^ORC("RFRET",RFRRowId)),"^",1)
				s RFRDesc=$p($g(^ORC("RFRET",RFRRowId)),"^",2)
				s RFRDateFrom=$p($g(^ORC("RFRET",RFRRowId)),"^",3)
				s RFRDateTo=$p($g(^ORC("RFRET",RFRRowId)),"^",4)
				s:RFRDateFrom'="" RFRDateFrom=$zd(RFRDateFrom,1)
				s:RFRDateTo'="" RFRDateTo=$zd(RFRDateTo,1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonForReturn",RFRRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonForReturn",RFRRowId,RFRDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(RFRCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RFRRowId,RFRCode,RFRDesc,RFRDateFrom,RFRDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCReasonForReturn
/// Input:code,desc
/// Return:RFRRowId,RFRCode,RFRDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonForReturn","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFRRowId:%String,RFRCode:%String,RFRDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s RFRRowId=rowid
		s RFRCode=$p($g(^ORC("RFRET",RFRRowId)),"^",1)
		s RFRDesc=$p($g(^ORC("RFRET",RFRRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonForReturn).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RFRRowId=0
		for
		{
			s RFRRowId=$o(^ORC("RFRET",RFRRowId)) q:RFRRowId=""
			s strRowId="{ID:"_RFRRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RFRCode=$p($g(^ORC("RFRET",RFRRowId)),"^",1)
				s RFRDesc=$p($g(^ORC("RFRET",RFRRowId)),"^",2)
				s RFRDateFrom=$p($g(^ORC("RFRET",RFRRowId)),"^",3)
				continue:(RFRDateFrom'="")&&(RFRDateFrom>+$h)
				s RFRDateTo=$p($g(^ORC("RFRET",RFRRowId)),"^",4)
				continue:(RFRDateTo'="")&&(RFRDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonForReturn",RFRRowId,RFRDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(RFRCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RFRRowId,RFRCode,RFRDesc)
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
/// Table:User.ORCReasonForReturn
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCReasonForReturn).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("RFRET",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("RFRET",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("RFRET",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("RFRET",0,"Desc",desc,0))
		
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-4
/// Description:双击修改时,从后台取数据
/// Table:User.ORCReasonForReturn
/// Input:id
/// Return:Json格式的字符串str={list:[RFRCode,RFRDesc,RFRDateFrom,RFRDateTo,RFRRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCReasonForReturn).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCReasonForReturn).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonForReturn).%New()
	s eobj.RFRRowId = id
	s eobj.RFRCode = pobj.RFRCode
	s eobj.RFRDesc = pobj.RFRDesc
	s eobj.RFRDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RFRDateFrom)
	s eobj.RFRDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RFRDateTo)
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-4
/// Description:增加/修改 返回原因
/// Table:User.ORCReasonForReturn
/// Input:web.Entity.CT.ORCReasonForReturn
/// Return:成功返回success:'true'和新增或修改的数据的RFRRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCReasonForReturn) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.RFRDateFrom'="" eobj.RFRDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RFRDateFrom)
		s:eobj.RFRDateTo'="" eobj.RFRDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RFRDateTo)
		s:eobj.RFRDateFrom="" eobj.RFRDateFrom = +$h
		s flag=..FormValidate(eobj.RFRRowId,eobj.RFRCode,eobj.RFRDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		if (eobj.RFRRowId="")       
		{
			s obj=##class(User.ORCReasonForReturn).%New()
		}
		else                           
		{
			s obj=##class(User.ORCReasonForReturn).%OpenId(eobj.RFRRowId)
			
			s bobj = ##class(web.Entity.CT.ORCReasonForReturn).%New()
			s bobj.RFRRowId = eobj.RFRRowId
			s bobj.RFRCode = obj.RFRCode
			s bobj.RFRDesc = obj.RFRDesc
			s bobj.RFRDateFrom=obj.RFRDateFrom
			s bobj.RFRDateTo=obj.RFRDateTo
		}

		s obj.RFRCode = eobj.RFRCode
		s obj.RFRDesc = eobj.RFRDesc
		s obj.RFRDateFrom=eobj.RFRDateFrom
		s obj.RFRDateTo=eobj.RFRDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RFRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForReturn","User.ORCReasonForReturn","返回原因",id,eobj.RFRDesc,"A",eobj)
			d:eobj.RFRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForReturn","User.ORCReasonForReturn","返回原因",id,eobj.RFRDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("返回原因","web.DHCBL.CT.ORCReasonForReturn","SaveEntity",eobj)
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
/// CreatDate:2012-9-4
/// Description:根据id删除 返回原因
/// Table:User.ORCReasonForReturn
/// Input:id(ORCReasonForReturn的RFRRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCReasonForReturn).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCReasonForReturn).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonForReturn).%New()
	s eobj.RFRRowId = id
	s eobj.RFRCode = pobj.RFRCode
	s eobj.RFRDesc = pobj.RFRDesc
	s eobj.RFRDateFrom = pobj.RFRDateFrom 
	s eobj.RFRDateTo =  pobj.RFRDateTo 
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCReasonForReturn).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonForReturn","User.ORCReasonForReturn","返回原因",id,eobj.RFRDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("返回原因","web.DHCBL.CT.ORCReasonForReturn","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
