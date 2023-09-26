/// 2014.02和药库物资合并，不维护
/// 名称:库存 2调价原因
/// 描述:调价原因维护，包含增删改查功能
/// 编写者：基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.INCReasonForAdjustment Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-14
/// Description:查询 调价原因
/// Table:User.INCReasonForAdjustment
/// Input:rowid,code,desc
/// Return:ADJRowId,ADJCode,ADJDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCReasonForAdjustment","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ADJRowId:%String,ADJCode:%String,ADJDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ADJRowId=rowid
		s ADJCode=$p($g(^INC("ADJ",ADJRowId)),"^",1)
		s ADJDesc=$p($g(^INC("ADJ",ADJRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.INCReasonForAdjustment).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ADJRowId=0
		for
		{
			s ADJRowId=$o(^INC("ADJ",ADJRowId)) q:ADJRowId=""
			s strRowId="{ID:"_ADJRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ADJCode=$p($g(^INC("ADJ",ADJRowId)),"^",1)
				s ADJDesc=$p($g(^INC("ADJ",ADJRowId)),"^",2)
				s ADJCode1=$ZCONVERT(ADJCode,"U")
				s ADJDesc1=$ZCONVERT(ADJDesc,"U")
				i (ADJCode1[code)&(ADJDesc1[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ADJRowId,ADJCode,ADJDesc)
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
/// Description:查询 调价原因for combo
/// Table:User.INCReasonForAdjustment
/// Input:code,desc
/// Return:ADJRowId,ADJCode,ADJDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCReasonForAdjustment","GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "ADJRowId:%String,ADJCode:%String,ADJDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s AuStr=##class(web.DHCBL.Authorize.INCReasonForAdjustment).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s ADJRowId=0
	for
	{
		s ADJRowId=$o(^INC("ADJ",ADJRowId)) q:ADJRowId=""
		s strRowId="{ID:"_ADJRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s ADJCode=$p($g(^INC("ADJ",ADJRowId)),"^",1)
			s ADJDesc=$p($g(^INC("ADJ",ADJRowId)),"^",2)
			s ADJCode1=$ZCONVERT(ADJCode,"U")
			s ADJDesc1=$ZCONVERT(ADJDesc,"U")
			i (ADJCode1[code)&(ADJDesc1[desc)
			{
				d OutputRowCmb
			}
		}
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ADJRowId,ADJCode,ADJDesc)
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
/// Table:User.INCReasonForAdjustment
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.INCReasonForAdjustment).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^INC("ADJ",0,"Code",code))
	s:desc'="" flagd=$d(^INC("ADJ",0,"Desc",desc))
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
		s:code'="" idc=$o(^INC("ADJ",0,"Code",code,0))
		s:desc'="" idd=$o(^INC("ADJ",0,"Desc",desc,0))
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
/// Table：User.INCReasonForAdjustment
/// Return：Json格式的字符串(即：form表单中对应的数据项)
ClassMethod OpenData(ADJRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.INCReasonForAdjustment).%OpenId(ADJRowId)
	s eobj = ##class(web.Entity.CT.INCReasonForAdjustment).%New()
	s eobj.ADJRowId = ADJRowId
	s eobj.ADJCode  = pobj.ADJCode
	s eobj.ADJDesc = pobj.ADJDesc
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 调价原因 ，对应form中的保存按钮
/// Table：INC_ReasonForAdjustment
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.INCReasonForAdjustment) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.ADJRowId="")
		{	
	        s obj=##class(User.INCReasonForAdjustment).%New()
		}
		else
		{
			s obj=##class(User.INCReasonForAdjustment).%OpenId(eobj.ADJRowId)
		}	
		s obj.ADJCode = eobj.ADJCode
		s obj.ADJDesc = eobj.ADJDesc
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ADJRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","调价原因",id,eobj.ADJDesc,"A",eobj)
			d:eobj.ADJRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","调价原因",id,eobj.ADJDesc,"U",eobj)
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
/// Description：根据id删除 调价原因
/// Table：User.ReasonForAdjustment
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.INCReasonForAdjustment).%OpenId(id)
	s eobj = ##class(web.Entity.CT.INCReasonForAdjustment).%New()
	s eobj.ADJRowId = id
	s eobj.ADJCode  = pobj.ADJCode
	s eobj.ADJDesc = pobj.ADJDesc
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.INCReasonForAdjustment).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_ReasonForAdjustment","User.INCReasonForAdjustment","调价原因",id,eobj.ADJDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
