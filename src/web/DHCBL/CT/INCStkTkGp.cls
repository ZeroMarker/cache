/// 2014.02和药库物资合并，不维护
/// 名称:库存 9库存盘点分类
/// 描述:库存盘点分类维护，包含增删改查功能
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.INCStkTkGp Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-14
/// Description:查询 库存盘点分类
/// Table:User.INCStkTkGp
/// Input:rowid,code,desc
/// Return:INCTGRowId,INCTGCode,INCTGDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCStkTkGp","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INCTGRowId:%String,INCTGCode:%String,INCTGDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s INCTGRowId=rowid
		s INCTGCode=$p($g(^INC("TG",INCTGRowId)),"^",1)
		s INCTGDesc=$p($g(^INC("TG",INCTGRowId)),"^",2)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.INCStkTkGp).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s INCTGRowId=0
		for
		{
			s INCTGRowId=$o(^INC("TG",INCTGRowId)) q:INCTGRowId=""
			s strRowId="{ID:"_INCTGRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s INCTGCode=$p($g(^INC("TG",INCTGRowId)),"^",1)
				s INCTGDesc=$p($g(^INC("TG",INCTGRowId)),"^",2)
				s INCTGCode1=$ZCONVERT(INCTGCode,"U")
				s INCTGDesc1=$ZCONVERT(INCTGDesc,"U")
				i (INCTGCode1[code)&(INCTGDesc1[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(INCTGRowId,INCTGCode,INCTGDesc)
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
/// Description:查询 库存盘点分类
/// Table:User.INCStkTkGp
/// Input:code,desc
/// Return:INCTGRowId,INCTGCode,INCTGDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.INCStkTkGp","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INCTGRowId:%String,INCTGCode:%String,INCTGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s AuStr=##class(web.DHCBL.Authorize.INCStkTkGp).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s INCTGRowId=0
	for
	{
		s INCTGRowId=$o(^INC("TG",INCTGRowId)) q:INCTGRowId=""
		s strRowId="{ID:"_INCTGRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s INCTGCode=$p($g(^INC("TG",INCTGRowId)),"^",1)
			s INCTGDesc=$p($g(^INC("TG",INCTGRowId)),"^",2)
			s INCTGCode1=$ZCONVERT(INCTGCode,"U")
			s INCTGDesc1=$ZCONVERT(INCTGDesc,"U")
			i (INCTGCode1[code)&(INCTGDesc1[desc)
			{
				d OutputRowCmb
			}
		}
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(INCTGRowId,INCTGCode,INCTGDesc)
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
/// Table:User.INCStkTkGp
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.INCStkTkGp).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^INC("TG",0,"Code",code))
	s:desc'="" flagd=$d(^INC("TG",0,"Desc",desc))
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
		s:code'="" idc=$o(^INC("TG",0,"Code",code,0))
		s:desc'="" idd=$o(^INC("TG",0,"Desc",desc,0))
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
/// Description：新增/修改时打开Form，根据RowId查询
/// Table：User.INCStkTkGp
ClassMethod OpenData(INCTGRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.INCStkTkGp).%OpenId(INCTGRowId)
	s eobj = ##class(web.Entity.CT.INCStkTkGp).%New()
	s eobj.INCTGRowId = INCTGRowId
	s eobj.INCTGCode  = pobj.INCTGCode
	s eobj.INCTGDesc = pobj.INCTGDesc
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：保存 库存盘点分类 ，对应form中的保存按钮
/// Input: 库存盘点分类 实体类
/// Table：User.INCStkTkGp
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.INCStkTkGp) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.INCTGRowId="")
		{	
	        s obj=##class(User.INCStkTkGp).%New() 
		}
		else
		{
			s obj=##class(User.INCStkTkGp).%OpenId(eobj.INCTGRowId)
		}
		s obj.INCTGCode = eobj.INCTGCode
		s obj.INCTGDesc = eobj.INCTGDesc
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.INCTGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_StkTkGp","User.INCStkTkGp","库存盘点分类",id,eobj.INCTGDesc,"A",eobj)
			d:eobj.INCTGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_StkTkGp","User.INCStkTkGp","库存盘点分类",id,eobj.INCTGDesc,"U",eobj)
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

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s inci=0,flag=0 
	for
	{
		s inci=$o(^INCI(inci)) q:(inci="IB_EX")||(flag=1)  ///库存项子表INCItmBat有索引^INCI("IB_EX",
		s INCIINCTGDR=($p(^INCI(inci,2),"^",4))
		i INCIINCTGDR=id
		{
			s flag=1
			s myInfo=myInfo_"<库存项>"
		}	
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 库存盘点分类 的内容
/// Table：User.INCStkTkGp
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.INCStkTkGp).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
	s pobj = ##class(User.INCStkTkGp).%OpenId(id)
	s eobj = ##class(web.Entity.CT.INCStkTkGp).%New()
	s eobj.INCTGRowId = id
	s eobj.INCTGCode  = pobj.INCTGCode
	s eobj.INCTGDesc = pobj.INCTGDesc
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.INCStkTkGp).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("INC_StkTkGp","User.INCStkTkGp","库存盘点分类",id,eobj.INCTGDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
