/// 2014.02和药库物资合并，不维护
/// 名称:库存 5供应商分类	
/// 描述:供应商分类，包含增删改查功能
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.APCVendCat Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-14
/// Description:查询 供应商分类
/// Table:User.APCVendCat
/// Input:rowid,code,desc
/// Return:APCVCRowId,APCVCCode,APCVCDesc,APCVCCoCodeDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.APCVendCat","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "APCVCRowId:%String,APCVCCode:%String,APCVCDesc:%String,APCVCCoCodeDR:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s APCVCRowId=rowid
		s APCVCCode=$p($g(^APC("APCVC",APCVCRowId)),"^",2)
		s APCVCDesc=$p($g(^APC("APCVC",APCVCRowId)),"^",3)
		s CTCORowId=$p($g(^APC("APCVC",APCVCRowId)),"^",1)  //-->CTCompany
		i CTCORowId'=""
		{
			s APCVCCoCodeDR=$p($g(^CT("CTCO",CTCORowId)),"^",2)
		}
		else
		{
			s APCVCCoCodeDR=""
		}
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.APCVendCat).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s APCVCRowId=0
		for
		{
			s APCVCRowId=$o(^APC("APCVC",APCVCRowId)) q:APCVCRowId=""
			s strRowId="{ID:"_APCVCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTCORowId=$p($g(^APC("APCVC",APCVCRowId)),"^",1)  //CTCompany
				i CTCORowId'=""
				{
					s APCVCCoCodeDR=$p($g(^CT("CTCO",CTCORowId)),"^",2)
				}
				else
				{
					s APCVCCoCodeDR=""
				}
				s APCVCCode=$p($g(^APC("APCVC",APCVCRowId)),"^",2)
				s APCVCDesc=$p($g(^APC("APCVC",APCVCRowId)),"^",3)
				s APCVCCode1=$ZCONVERT(APCVCCode,"U")
				s APCVCDesc1=$ZCONVERT(APCVCDesc,"U")
				i (APCVCCode1[code)&(APCVCDesc1[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(APCVCRowId,APCVCCode,APCVCDesc,APCVCCoCodeDR)
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
/// Description:查询 供应商分类for combo
/// Table:User.APCVendCat
/// Input:code,desc
/// Return:APCVCRowId,APCVCCode,APCVCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.APCVendCat","GetDataForCmb1","","")
Query GetDataForCmb1(code As %String, desc As %String) As %Query(ROWSPEC = "APCVCRowId:%String,APCVCCode:%String,APCVCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	s AuStr=##class(web.DHCBL.Authorize.APCVendCat).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s APCVCRowId=0
	for
	{
		s APCVCRowId=$o(^APC("APCVC",APCVCRowId)) q:APCVCRowId=""
		s strRowId="{ID:"_APCVCRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
			s APCVCCode=$p($g(^APC("APCVC",APCVCRowId)),"^",2)
			s APCVCDesc=$p($g(^APC("APCVC",APCVCRowId)),"^",3)
			s APCVCCode1=$ZCONVERT(APCVCCode,"U")
			s APCVCDesc1=$ZCONVERT(APCVCDesc,"U")
			i (APCVCCode1[code)&(APCVCDesc1[desc)
			{
				d OutputRowCmb
			}
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(APCVCRowId,APCVCCode,APCVCDesc)
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

/// Creator：陈莹
/// CreatDate: 2013-2-22
/// Description:为combobox查询取数据(单位)APCVCCoCodeDR->CTCompany
/// Table:User.CTCompany
/// Input:code,desc
/// Return:CTCORowId,CTCOCode,CTCODesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.APCVendCat","GetCTCODR","","")
Query GetCTCODR(code As %String, desc As %String) As %Query(ROWSPEC = "CTCORowId:%String,CTCOCode:%String,CTCODesc:%String")
{
}

ClassMethod GetCTCODRExecute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s CTCORowId=0
	for
	{
		s CTCORowId=$o(^CT("CTCO",CTCORowId)) q:CTCORowId=""
		s CTCOCode=$p($g(^CT("CTCO",CTCORowId)),"^",1)
		s CTCODesc=$p($g(^CT("CTCO",CTCORowId)),"^",2)
		s CTCOCode1=$ZCONVERT(CTCOCode,"U")
		s CTCODesc1=$ZCONVERT(CTCODesc,"U")
		i (CTCOCode1[code)&(CTCODesc1[desc)
		{
			d OutputRowCTCO
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCTCO
    set Data=$lb(CTCORowId,CTCOCode,CTCODesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCTCODRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTCODRExecute ]
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

ClassMethod GetCTCODRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTCODRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.APCVendCat
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.APCVendCat).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^APC("APCVC",0,"APCVC_Code",code))
	s:desc'="" flagd=$d(^APC("APCVC",0,"APCVC_Desc",desc))
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
		s:code'="" idc=$o(^APC("APCVC",0,"APCVC_Code",code,0))
		s:desc'="" idd=$o(^APC("APCVC",0,"APCVC_Desc",desc,0))
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
/// Table：User.APCVendCat
/// Input:APCVCRowId
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// w ##class(web.DHCBL.CT.APCVendCat).OpenData(1)
ClassMethod OpenData(APCVCRowId As %String) As %String
{
    s str = ""
	s pobj = ##class(User.APCVendCat).%OpenId(APCVCRowId)
	s eobj = ##class(web.Entity.CT.APCVendCat).%New()
	s eobj.APCVCRowId = APCVCRowId
	s eobj.APCVCCode  = pobj.APCVCCode
	s eobj.APCVCDesc = pobj.APCVCDesc 
	if $IsObject(pobj.APCVCCoCodeDR){
		s eobj.APCVCCoCodeDR = pobj.APCVCCoCodeDR.%Id() 
		}
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	; d ##class(web.DHCBL.CT.APCVendCat).SaveTest()
	s obj = ##class(web.Entity.CT.APCVendCat).%New()
	s obj.APCVCCode="ceshi"
	d ..SaveEntity(obj)
}

/// Creator：陈莹 
/// Description：保存 供应商分类 ，对应form中的保存按钮
/// Input:'供应商分类'实体类
/// Table：User.APCVendCat
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.APCVendCat) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.APCVCRowId="") //如果RowId未赋值则增加
		{	
	       s obj=##class(User.APCVendCat).%New()
		}
		else //如果RowId已赋值则修改
		{
			s obj=##class(User.APCVendCat).%OpenId(eobj.APCVCRowId)
		}		
		s obj.APCVCCode = eobj.APCVCCode
		s obj.APCVCDesc = eobj.APCVCDesc
		d obj.APCVCCoCodeDRSetObjectId(eobj.APCVCCoCodeDR)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.APCVCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("APC_VendCat","User.APCVendCat","供应商分类",id,eobj.APCVCDesc,"A",eobj)
			d:eobj.APCVCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("APC_VendCat","User.APCVendCat","供应商分类",id,eobj.APCVCDesc,"U",eobj)
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
/// Description：根据id删除 供应商分类
/// Table：User.APCVendCat
/// Input：id 
/// Return：成功返回true，失败返回false和info
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.APCVendCat).%OpenId(id)
	s eobj = ##class(web.Entity.CT.APCVendCat).%New()
	s eobj.APCVCRowId = id
	s eobj.APCVCCode  = pobj.APCVCCode
	s eobj.APCVCDesc = pobj.APCVCDesc 
	if $IsObject(pobj.APCVCCoCodeDR){
		s eobj.APCVCCoCodeDR = pobj.APCVCCoCodeDR.%Id() 
		}
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.APCVendCat).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("APC_VendCat","User.APCVendCat","供应商分类",id,eobj.APCVCDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

}
