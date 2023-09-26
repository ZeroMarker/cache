/// 2014.02和药库物资合并，不维护
/// 名称:库存 6库存返回原因
/// 描述:库存返回原因维护，包含增删改查功能
/// 编写者：基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.INCReasonForReturn Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-14
/// Description:查询 库存返回原因
/// Table:User.INCReasonForReturn
/// Input:rowid,code,desc
/// Return:RETRowId,RETCode,RETDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCReasonForReturn","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RETRowId:%String,RETCode:%String,RETDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s RETRowId=rowid
		s RETCode=$p($g(^INC("RET",RETRowId)),"^",1)
		s RETDesc=$p($g(^INC("RET",RETRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.INCReasonForReturn).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RETRowId=0
		for
		{
			s RETRowId=$o(^INC("RET",RETRowId)) q:RETRowId=""
			s strRowId="{ID:"_RETRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RETCode=$p($g(^INC("RET",RETRowId)),"^",1)
				s RETDesc=$p($g(^INC("RET",RETRowId)),"^",2)
				s RETCode1=$ZCONVERT(RETCode,"U")
				s RETDesc1=$ZCONVERT(RETDesc,"U")
				i (RETCode1[code)&(RETDesc1[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RETRowId,RETCode,RETDesc)
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
/// CreatDate:2013-5-14
/// Description:查询 库存返回原因for combo
/// Table:User.INCReasonForReturn
/// Input:code,desc
/// Return:RETRowId,RETCode,RETDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCReasonForReturn","GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "RETRowId:%String,RETCode:%String,RETDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s AuStr=##class(web.DHCBL.Authorize.INCReasonForReturn).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s RETRowId=0
	for
	{
		s RETRowId=$o(^INC("RET",RETRowId)) q:RETRowId=""
		s strRowId="{ID:"_RETRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s RETCode=$p($g(^INC("RET",RETRowId)),"^",1)
			s RETDesc=$p($g(^INC("RET",RETRowId)),"^",2)
			s RETCode1=$ZCONVERT(RETCode,"U")
			s RETDesc1=$ZCONVERT(RETDesc,"U")
			i (RETCode1[code)&(RETDesc1[desc)
			{
				d OutputRowCmb
			}
		}
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RETRowId,RETCode,RETDesc)
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
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.INCReasonForReturn
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.INCReasonForReturn).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^INC("RET",0,"Code",code))
	s:desc'="" flagd=$d(^INC("RET",0,"Desc",desc))
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
		s:code'="" idc=$o(^INC("RET",0,"Code",code,0))
		s:desc'="" idd=$o(^INC("RET",0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if (code="")
			{
				if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
				else  s flag=0 //返回不重复标志
			}
			else
			{
				if ((idc'=id)||(idd'=id))&((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
				else  s flag=0 //返回不重复标志
			}
		}
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.INCReasonForReturn
ClassMethod OpenData(RETRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.INCReasonForReturn).%OpenId(RETRowId)
	s eobj = ##class(web.Entity.CT.INCReasonForReturn).%New()
	s eobj.RETRowId = RETRowId
	s eobj.RETCode  = pobj.RETCode
	s eobj.RETDesc = pobj.RETDesc
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：保存 库存返回原因 ，对应form中的保存按钮
/// Input:'库存返回原因'实体类
/// Table：User.INCReasonForReturn
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.INCReasonForReturn) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.RETRowId="")
		{	
	        s obj=##class(User.INCReasonForReturn).%New()
		}
		else
		{
			s obj=##class(User.INCReasonForReturn).%OpenId(eobj.RETRowId)
		}
		s obj.RETCode = eobj.RETCode
		s obj.RETDesc = eobj.RETDesc
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RETRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","库存返回原因",id,eobj.RETDesc,"A",eobj)
			d:eobj.RETRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","库存返回原因",id,eobj.RETDesc,"U",eobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：陈莹  
/// CreatDate: 2012-8-30
/// Description：根据id删除 库存返回原因
/// Table：User.INCReasonForReturn
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.INCReasonForReturn).%OpenId(id)
	s eobj = ##class(web.Entity.CT.INCReasonForReturn).%New()
	s eobj.RETRowId = id
	s eobj.RETCode  = pobj.RETCode
	s eobj.RETDesc = pobj.RETDesc
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.INCReasonForReturn).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForReturn","User.INCReasonForReturn","库存返回原因",id,eobj.RETDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
