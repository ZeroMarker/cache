/// 2014.02和药库物资合并，不维护
/// 名称:库存 1 库存消耗原因
/// 描述:库存消耗原因维护，包含增删改查功能
/// 编写者：基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.INCConsumptionReason Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-14
/// Description:查询 库存消耗原因
/// Table:User.INCConsumptionReason
/// Input:rowid,code,desc
/// Return:CONRRowId,CONRCode,CONRDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCConsumptionReason","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CONRRowId:%String,CONRCode:%String,CONRDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CONRRowId=rowid
		s CONRCode=$p($g(^INC("CONR",CONRRowId)),"^",1)
		s CONRDesc=$p($g(^INC("CONR",CONRRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.INCConsumptionReason).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CONRRowId=0
		for
		{
			s CONRRowId=$o(^INC("CONR",CONRRowId)) q:CONRRowId=""
			s strRowId="{ID:"_CONRRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CONRCode=$p($g(^INC("CONR",CONRRowId)),"^",1)
				s CONRDesc=$p($g(^INC("CONR",CONRRowId)),"^",2)
				s CONRCode1=$ZCONVERT(CONRCode,"U")
				s CONRDesc1=$ZCONVERT(CONRDesc,"U")
				i (CONRCode1[code)&(CONRDesc1[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CONRRowId,CONRCode,CONRDesc)
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
/// Description:查询 库存消耗原因for combo
/// Table:User.INCConsumptionReason
/// Input:code,desc
/// Return:CONRRowId,CONRCode,CONRDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCConsumptionReason","GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "CONRRowId:%String,CONRCode:%String,CONRDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s AuStr=##class(web.DHCBL.Authorize.INCConsumptionReason).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s CONRRowId=0
	for
	{
		s CONRRowId=$o(^INC("CONR",CONRRowId)) q:CONRRowId=""
		s strRowId="{ID:"_CONRRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s CONRCode=$p($g(^INC("CONR",CONRRowId)),"^",1)
			s CONRDesc=$p($g(^INC("CONR",CONRRowId)),"^",2)
			s CONRCode1=$ZCONVERT(CONRCode,"U")
			s CONRDesc1=$ZCONVERT(CONRDesc,"U")
			i (CONRCode1[code)&(CONRDesc1[desc)
			{
				d OutputRowCmb
			}
		}

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CONRRowId,CONRCode,CONRDesc)
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
/// Table:User.INCConsumptionReason
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.INCConsumptionReason).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^INC("CONR",0,"Code",code))
	s:desc'="" flagd=$d(^INC("CONR",0,"Desc",desc))
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
		s:code'="" idc=$o(^INC("CONR",0,"Code",code,0))
		s:desc'="" idd=$o(^INC("CONR",0,"Desc",desc,0))
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
/// Description：新增、修改时打开Form，根据RowId查询
/// Table：User.INCConsumptionReason
/// Return：Json格式的字符串(即：form表单中对应的数据项)
ClassMethod OpenData(CONRRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.INCConsumptionReason).%OpenId(CONRRowId)
	s eobj = ##class(web.Entity.CT.INCConsumptionReason).%New()
	s eobj.CONRRowId = CONRRowId
	s eobj.CONRCode  = pobj.CONRCode
	s eobj.CONRDesc = pobj.CONRDesc
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 库存消耗原因 ，对应form中的保存按钮
/// Input:'库存消耗原因'实体类
/// Table：User.INCConsumptionReason
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.INCConsumptionReason) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.CONRRowId="")
		{	
	        s obj=##class(User.INCConsumptionReason).%New()
		}
		else
		{
			s obj=##class(User.INCConsumptionReason).%OpenId(eobj.CONRRowId)
		}	
		s obj.CONRCode = eobj.CONRCode
		s obj.CONRDesc = eobj.CONRDesc
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CONRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ConsumptionReason","User.INCConsumptionReason","库存消耗原因",id,eobj.CONRDesc,"A",eobj)
			d:eobj.CONRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ConsumptionReason","User.INCConsumptionReason","库存消耗原因",id,eobj.CONRDesc,"U",eobj)
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
/// Description：根据id删除 库存消耗原因
/// Table：User.INCConsumptionReason
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.INCConsumptionReason).%OpenId(id)
	s eobj = ##class(web.Entity.CT.INCConsumptionReason).%New()
	s eobj.CONRRowId = id
	s eobj.CONRCode  = pobj.CONRCode
	s eobj.CONRDesc = pobj.CONRDesc
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.INCConsumptionReason).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ConsumptionReason","User.INCConsumptionReason","库存消耗原因",id,eobj.CONRDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
