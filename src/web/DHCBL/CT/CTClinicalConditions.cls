/// 名称:检验系统 2临床条件
/// 描述:临床条件，包含增删改查功能
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-12-5
Class web.DHCBL.CT.CTClinicalConditions Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-12-5
/// Description:查询 临床条件
/// Table:lab.CTClinicalConditions
/// Input:rowid,code,desc
/// Return:CTCLCRowId,CTCLCCode,CTCLCDescription
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTClinicalConditions","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTCLCRowId:%String,CTCLCCode:%String,CTCLCDescription:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CTCLCRowId=rowid
		s CTCLCCode=rowid
		s CTCLCDescription=$g(^TTAB("CLC",CTCLCRowId))
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.CTClinicalConditions).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTCLCRowId=0
		for
		{
			s CTCLCRowId=$o(^TTAB("CLC",CTCLCRowId)) q:CTCLCRowId=""
			s strRowId="{ID:"_CTCLCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTCLCCode=CTCLCRowId
				s CTCLCDescription=$g(^TTAB("CLC",CTCLCRowId))
				i ($ZCONVERT(CTCLCCode,"U")[code)&($ZCONVERT(CTCLCDescription,"U")[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTCLCRowId,CTCLCCode,CTCLCDescription)
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
/// CreatDate:2013-12-5
/// Description:查询 临床条件for combo
/// Table:lab.CTClinicalConditions
/// Input:code,desc
/// Return:CTCLCRowId,CTCLCCode,CTCLCDescription
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTClinicalConditions","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTCLCRowId:%String,CTCLCCode:%String,CTCLCDescription:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s CTCLCRowId=rowid
		s CTCLCCode=rowid
		s CTCLCDescription=$g(^TTAB("CLC",CTCLCRowId))
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
	
		s AuStr=##class(web.DHCBL.Authorize.CTClinicalConditions).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTCLCRowId=0
		for
		{
			s CTCLCRowId=$o(^TTAB("CLC",CTCLCRowId)) q:CTCLCRowId=""
			s strRowId="{ID:"_CTCLCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTCLCCode=CTCLCRowId
				s CTCLCDescription=$g(^TTAB("CLC",CTCLCRowId))
				i ($ZCONVERT(CTCLCCode,"U")[code)&($ZCONVERT(CTCLCDescription,"U")[desc)
				{
					d OutputRowCmb
				}
			}	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTCLCRowId,CTCLCCode,CTCLCDescription)
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
/// CreatDate:2013-12-5
/// Description:数据重复验证方法,js调用
/// Table:lab.CTClinicalConditions
/// Input:id, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTClinicalConditions).FormValidate("","A01","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	//Labtrak里代码不可重复，desc可重复
	s flag=0
	if (id="") //如果为空，增加时的重复判断
	{
		s codeid=0
		for
	    {
			s codeid=$o(^TTAB("CLC",codeid)) q:(codeid="")||(flag=1)
			i codeid=code 
			{
				s flag=1
			}		
	   	}
		
		if (desc'=""){    
		s rowid=0
		for
   	 	{
			s rowid=$o(^TTAB("CLC",rowid)) q:(rowid="")||(flag=1)
			s CTCLCDescription=$g(^TTAB("CLC",rowid))
			i (desc=CTCLCDescription)
			{
			s flag=1 //有重复
			}
     	}
		}
	    
	}
	else //如果不为空，修改时的重复判断
	{
		s rowid=0
		for
	    {
			s rowid=$o(^TTAB("CLC",rowid)) q:(rowid="")||(flag=1)
			s CTCLCDescription=$g(^TTAB("CLC",rowid))
			i (desc=CTCLCDescription)&(rowid'=id)
			{
				s flag=1 //有重复
			}
	     }
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2013-12-5
/// Description：新增/修改时打开Form，根据RowId查询
/// Table：lab.CTClinicalConditions
/// Input:CTCLCRowId
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// w ##class(web.DHCBL.CT.CTClinicalConditions).OpenData("A01")
ClassMethod OpenData(CTCLCRowId As %String) As %String
{
    s str = ""
   	/*
	s pobj = ##class(lab.CTClinicalConditions).%OpenId(CTCLCRowId)
	s eobj = ##class(web.Entity.CT.CTClinicalConditions).%New()
	s eobj.CTCLCRowId = CTCLCRowId
	s eobj.CTCLCCode  = pobj.CTCLCCode
	s eobj.CTCLCDescription = pobj.CTCLCDescription 
	*/
	s RowId="CTCLCRowId"
	s CTCLCDescription=$g(^TTAB("CLC",RowId))
	
	s eobj = ##class(web.Entity.CT.CTClinicalConditions).%New()
	s eobj.CTCLCRowId = CTCLCRowId
	s eobj.CTCLCCode  = CTCLCRowId
	s eobj.CTCLCDescription = CTCLCDescription
	
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// Description：保存 临床条件 ，对应form中的保存按钮
/// Input:'临床条件'实体类
/// Table：lab.CTClinicalConditions
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.CTClinicalConditions) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.CTCLCRowId="") //如果RowId未赋值则增加
		{	
	       s obj=##class(lab.CTClinicalConditions).%New()
		}
		else //如果RowId已赋值则修改
		{
			s obj=##class(lab.CTClinicalConditions).%OpenId(eobj.CTCLCRowId)
			s bobj=##class(web.Entity.CT.CTClinicalConditions).%New()
			s bobj.CTCLCRowId = eobj.CTCLCRowId
			s bobj.CTCLCCode = obj.CTCLCCode
			s bobj.CTCLCDescription = obj.CTCLCDescription
		}		
		s obj.CTCLCCode = eobj.CTCLCCode
		s obj.CTCLCDescription = eobj.CTCLCDescription
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			;d:eobj.CTCLCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ClinicalConditions","lab.CTClinicalConditions","临床条件",id,eobj.CTCLCDescription,"A",eobj)
			;d:eobj.CTCLCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ClinicalConditions","lab.CTClinicalConditions","临床条件",id,eobj.CTCLCDescription,"U",eobj,bobj)
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
/// CreatDate: 2013-12-5
/// Description：根据id删除 临床条件
/// Table：lab.CTClinicalConditions
/// Input：id 
/// Return：成功返回true，失败返回false和info
ClassMethod DeleteData(id) As %String
{
	s result=""
	/*s pobj = ##class(lab.CTClinicalConditions).%OpenId(id)  //有问题
	s eobj = ##class(web.Entity.CT.CTClinicalConditions).%New()
	s eobj.CTCLCRowId = id
	s eobj.CTCLCCode  = pobj.CTCLCCode
	s eobj.CTCLCDescription = pobj.CTCLCDescription 
	*/
	s CTCLCDescription=$g(^TTAB("CLC",id))
	s eobj = ##class(web.Entity.CT.CTClinicalConditions).%New()
	s eobj.CTCLCRowId = id
	s eobj.CTCLCCode  = id
	s eobj.CTCLCDescription = CTCLCDescription
	
	Tstart
	s sc=##class(lab.CTClinicalConditions).%DeleteId(id)  //有问题
	IF $$$ISOK(sc){ 
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_ClinicalConditions","lab.CTClinicalConditions","临床条件",id,eobj.CTCLCDescription,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
