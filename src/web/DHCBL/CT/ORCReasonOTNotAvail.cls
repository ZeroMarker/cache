Import SQLUser

/// 名称:手术和过程 - 14 手术室不可用原因	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ORCReasonOTNotAvail Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 手术室不可用原因
/// Table:User.ORCReasonOTNotAvail
/// Input:rowid,code,desc
/// Return:RNAVRowId,RNAVCode,RNAVDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonOTNotAvail","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RNAVRowId:%String,RNAVCode:%String,RNAVDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s RNAVRowId=rowid
		s RNAVCode=$p($g(^ORC("RNAV",RNAVRowId)),"^",1)
		s RNAVDesc=$p($g(^ORC("RNAV",RNAVRowId)),"^",2)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonOTNotAvail",RNAVRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonOTNotAvail).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RNAVRowId=0
		for
		{
			s RNAVRowId=$o(^ORC("RNAV",RNAVRowId)) q:RNAVRowId=""
			s strRowId="{ID:"_RNAVRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RNAVCode=$p($g(^ORC("RNAV",RNAVRowId)),"^",1)
				s RNAVDesc=$p($g(^ORC("RNAV",RNAVRowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_ReasonOTNotAvail",RNAVRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonOTNotAvail",RNAVRowId,RNAVDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(RNAVCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RNAVRowId,RNAVCode,RNAVDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCReasonOTNotAvail
/// Input:code,desc
/// Return:RNAVRowId,RNAVCode,RNAVDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCReasonOTNotAvail","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RNAVRowId:%String,RNAVCode:%String,RNAVDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s RNAVRowId=rowid
		s RNAVCode=$p($g(^ORC("RNAV",RNAVRowId)),"^",1)
		s RNAVDesc=$p($g(^ORC("RNAV",RNAVRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCReasonOTNotAvail).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RNAVRowId=0
		for
		{
			s RNAVRowId=$o(^ORC("RNAV",RNAVRowId)) q:RNAVRowId=""
			s strRowId="{ID:"_RNAVRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RNAVCode=$p($g(^ORC("RNAV",RNAVRowId)),"^",1)
				s RNAVDesc=$p($g(^ORC("RNAV",RNAVRowId)),"^",2)
				s RNAVCode1=$ZCONVERT(RNAVCode,"U")
				s RNAVDesc1=$ZCONVERT(RNAVDesc,"U")
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_ReasonOTNotAvail",RNAVRowId,RNAVDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(RNAVCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RNAVRowId,RNAVCode,RNAVDesc)
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
/// Table:User.ORCReasonOTNotAvail
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCReasonOTNotAvail).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("RNAV",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("RNAV",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("RNAV",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("RNAV",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:双击修改时从后台取数据
/// Table:User.ORCReasonOTNotAvail
/// Input:id
/// Return:Json格式的字符串str={list:[RNAVCode,RNAVDesc,RNAVRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCReasonOTNotAvail).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCReasonOTNotAvail).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonOTNotAvail).%New()
	s eobj.RNAVRowId = id
	s eobj.RNAVCode = pobj.RNAVCode
	s eobj.RNAVDesc = pobj.RNAVDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:增加、修改 手术室不可用原因
/// Table:User.ORCReasonOTNotAvail
/// Input:web.Entity.CT.ORCReasonOTNotAvail 实体类
/// Return:成功返回success:'true'和新增或修改的数据的RNAVRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCReasonOTNotAvail) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		s flag=..FormValidate(eobj.RNAVRowId,eobj.RNAVCode,eobj.RNAVDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RNAVRowId="")       
		{
			s obj=##class(User.ORCReasonOTNotAvail).%New()
		}
		else                           
		{
			s obj=##class(User.ORCReasonOTNotAvail).%OpenId(eobj.RNAVRowId)
			
			s bobj = ##class(web.Entity.CT.ORCReasonOTNotAvail).%New()
			s bobj.RNAVRowId = eobj.RNAVRowId
			s bobj.RNAVCode = obj.RNAVCode
			s bobj.RNAVDesc = obj.RNAVDesc
		}

		s obj.RNAVCode = eobj.RNAVCode
		s obj.RNAVDesc = eobj.RNAVDesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RNAVRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonOTNotAvail","User.ORCReasonOTNotAvail","手术室不可用原因",id,eobj.RNAVDesc,"A",eobj)
			d:eobj.RNAVRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonOTNotAvail","User.ORCReasonOTNotAvail","手术室不可用原因",id,eobj.RNAVDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术室不可用原因","web.DHCBL.CT.ORCReasonOTNotAvail","SaveEntity",eobj)
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
/// Description:根据id删除 手术室不可用原因
/// Table:User.ORCReasonOTNotAvail
/// Input:id(ORCReasonOTNotAvail的RNAVRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCReasonOTNotAvail).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s pobj = ##class(User.ORCReasonOTNotAvail).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCReasonOTNotAvail).%New()
	s eobj.RNAVRowId = id
	s eobj.RNAVCode = pobj.RNAVCode
	s eobj.RNAVDesc = pobj.RNAVDesc
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCReasonOTNotAvail).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_ReasonOTNotAvail","User.ORCReasonOTNotAvail","手术室不可用原因",id,eobj.RNAVDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术室不可用原因","web.DHCBL.CT.ORCReasonOTNotAvail","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
