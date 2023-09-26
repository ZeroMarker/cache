/// 名称:床位费时制
/// 描述:包含增删改查功能
/// 编写者：鲁俊文
/// 编写日期: 2022-10-14
Class web.DHCBL.CT.BedFeeTime Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:鲁俊文
/// CreatDate:2022-10-13
/// Description：查询床位费时制  
/// Table：CT_BDP_CT.BedFeeTime
/// Input：rowid,code,name
/// Return: BedFeeTimeRowId:RowId BedFeeTimeCode:代码 BedFeeTimeName:名称 BedFeeDateFrom:开始日期 BedFeeDateTo:结束日期 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BedFeeTime","GetList","","","")
Query GetList(rowid As %String, code As %String, name As %String) As %Query(ROWSPEC = "BedFeeTimeRowId:%String,BedFeeTimeCode:%String,BedFeeTimeName:%String,BedFeeDateFrom:%Date,BedFeeDateTo:%Date")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (rowid'="") //根据rowid返回该条记录
	{
    	s BedFeeTimeRowId=rowid                                     ///RowID
	    s BedFeeTimeCode=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),2)  ///代码
	    s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),3)  ///名称
	    s BedFeeDateFrom=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),4)  ///开始日期
	    s BedFeeDateTo=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),5)    ///结束日期
	    s:BedFeeDateFrom'="" BedFeeDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BedFeeDateFrom) ///转日期格式
	    s:BedFeeDateTo'="" BedFeeDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BedFeeDateTo)	///转日期格式
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	    s BedFeeTimeRowId=0
    	for 
    	{
	        s BedFeeTimeRowId=$o(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)) q:BedFeeTimeRowId=""  ///RowID
	        s BedFeeTimeCode=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),2)  ///代码
	    	s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),3)  ///名称
	    	s BedFeeDateFrom=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),4)  ///开始日期
	    	s BedFeeDateTo=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),5)    ///结束日期	    	
	    	s:BedFeeDateFrom'="" BedFeeDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BedFeeDateFrom) ///转日期格式
	    	s:BedFeeDateTo'="" BedFeeDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BedFeeDateTo)	///转日期格式
	    	s PINYIN=""
	        s:name'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BedFeeTimeName)
        	if ($ZCONVERT(BedFeeTimeCode,"U")[code)&(($ZCONVERT(BedFeeTimeName,"U")[name)||(PINYIN[name))
        	{
	            d OutputRow
        	} 
    	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(BedFeeTimeRowId,BedFeeTimeCode,BedFeeTimeName,BedFeeDateFrom,BedFeeDateTo)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
    //if there are no more rows,finish fetching...
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

/// Creator：鲁俊文 		
/// CreatDate: 2020-10-21
/// Description：查询床位费用时制
/// Table:CT_BDP_CT.BedFeeTime
/// Input：rowid ：RowID
/// Output:BedFeeTimeRowId,BedFeeTimeCode,BedFeeTimeName
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BedFeeTime","GetDataForCmb1","")
Query GetDataForCmb1(rowid As %String) As %Query(ROWSPEC = "BedFeeTimeRowId,BedFeeTimeCode,BedFeeTimeName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (rowid'="") //根据rowid返回该条记录
	{
    	s BedFeeTimeRowId=rowid                                     ///RowID
	    s BedFeeTimeCode=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),2)  ///代码
	    s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),3)  ///名称	
		d OutputRowCmb
	}
	else
	{
		s BedFeeTimeRowId=0
		for
		{
	        s BedFeeTimeRowId=$o(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)) q:BedFeeTimeRowId=""  ///RowID
	        s BedFeeTimeCode=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),2)  ///代码
	    	s BedFeeTimeName=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),3)  ///名称	    	
	    	s BedFeeDateFrom=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),4)  ///开始日期
	    	continue:(BedFeeDateFrom'="")&&(BedFeeDateFrom>+$h)
	    	s BedFeeDateTo=$lg($g(^CT.BDP.CT.BedFeeTimeD(BedFeeTimeRowId)),5)  ///结束日期
	    	continue:(BedFeeDateTo'="")&&(BedFeeDateTo<+$h) //时间限制
			d OutputRowCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BedFeeTimeRowId,BedFeeTimeCode,BedFeeTimeName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
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

/// Creator：鲁俊文
/// CreatDate: 2022-10-14
/// Description：日期交叉校验
/// Table：CT_BDP_CT.BedFeeTime
/// Input：id datefrom dateto
/// Others：w ##class(web.DHCBL.CT.BedFeeTime).FormValidate("","","春令时")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0	
	if (code'="")
	{
		s ID=$o(^CT.BDP.CT.BedFeeTimeI("CodeIndex"," "_$ZCONVERT(code,"U"),0))	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}	
	}
	if (desc'="")
	{
		s ID=$o(^CT.BDP.CT.BedFeeTimeI("NameIndex",$ZCONVERT(desc,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
			
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年10月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.BedFeeTime).savetest()
ClassMethod savetest()
{
	
	s eobj=##class(web.Entity.CT.BedFeeTime).%New()
	s eobj.BedFeeTimeCode="002"
	s eobj.BedFeeTimeName="保存测试"
	s eobj.BedFeeDateFrom="2022-10-14"
	s eobj.BedFeeDateTo=""
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-14
/// Description：保存床位时制信息
/// Table：CT_BDP_CT.BedFeeTime
/// Others：w ##class(web.DHCBL.CT.BedFeeTime).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.BedFeeTime) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.BedFeeDateFrom'="" eobj.BedFeeDateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BedFeeDateFrom)	//时间转换
	    s:eobj.BedFeeDateTo'="" eobj.BedFeeDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BedFeeDateTo)		//时间转换 
	    s:eobj.BedFeeDateFrom="" eobj.BedFeeDateFrom=+$h //取当前日期
		s islegal=..FormValidate(eobj.BedFeeTimeRowId,eobj.BedFeeTimeCode,eobj.BedFeeTimeName) //调用时间交叉验证
		if (islegal=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}	
		if (eobj.BedFeeTimeRowId="")
		{
			s obj=##class(CT.BDP.CT.BedFeeTime).%New()
		}
		else
		{
			s obj=##class(CT.BDP.CT.BedFeeTime).%OpenId(eobj.BedFeeTimeRowId)
			s bobj=##class(web.Entity.CT.BedFeeTime).%New()
		    s bobj.BedFeeTimeRowId=eobj.BedFeeTimeRowId    ////RowId
		    s bobj.BedFeeTimeName=obj.BedFeeTimeName		///名称
			s bobj.BedFeeTimeCode=obj.BedFeeTimeCode		///代码
			s bobj.BedFeeDateFrom=obj.BedFeeDateFrom ///开始日期
			s bobj.BedFeeDateTo=obj.BedFeeDateTo ///结束日期	
		}
		s obj.BedFeeTimeName=eobj.BedFeeTimeName		//名称
		s obj.BedFeeTimeCode=eobj.BedFeeTimeCode		//代码
		s obj.BedFeeDateFrom= eobj.BedFeeDateFrom     //开始日期
	    s obj.BedFeeDateTo= eobj.BedFeeDateTo 		 //结束日期
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.BedFeeTimeRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTime","CT.BDP.CT.BedFeeTime","床位时制信息",eobj.BedFeeTimeRowId,eobj.BedFeeTimeName,"U",eobj,bobj) 
			d:eobj.BedFeeTimeRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTime","CT.BDP.CT.BedFeeTime","床位时制信息",id,eobj.BedFeeTimeName,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位时制信息","web.DHCBL.CT.BedFeeTime","SaveEntity",eobj) 
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:    鲁俊文
/// CreatDate:  2022-10-13
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.BedFeeTime).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BedFeeTime).%New()
    s obj = ##class(CT.BDP.CT.BedFeeTime).%OpenId(id)
    s eobj.BedFeeTimeRowId=id ///RowId
    s eobj.BedFeeTimeCode= obj.BedFeeTimeCode ///代码
    s eobj.BedFeeTimeName= obj.BedFeeTimeName ///名称
    s:obj.BedFeeDateFrom'="" eobj.BedFeeDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.BedFeeDateFrom) ///开始日期 
    s:obj.BedFeeDateTo'="" eobj.BedFeeDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.BedFeeDateTo) ///结束日期
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator:鲁俊文
/// CreatDate:2022-10-13
/// Description：根据ID删除床位时制的内容
/// Table：CT_BDP_CT.BedFeeTime
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BedFeeTime).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	//new Entity对象，用于保存日志
	s pobj = ##class(CT.BDP.CT.BedFeeTime).%OpenId(id)
	s eobj = ##class(web.Entity.CT.BedFeeTime).%New()
	s eobj.BedFeeTimeRowId = id ///RowId
	s eobj.BedFeeTimeCode=pobj.BedFeeTimeCode ///代码
	s eobj.BedFeeTimeName=pobj.BedFeeTimeName ///名称
	s eobj.BedFeeDateFrom=pobj.BedFeeDateFrom ///开始日期
	s eobj.BedFeeDateTo=pobj.BedFeeDateTo ///结束日期
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.BedFeeTime).%DeleteId(id)
	if $$$ISOK(sc)
	{
	    Tcommit
	    s result = "{success:'true',info:'删除成功！'}"  
	    //保存日志
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BedFeeTime","CT.BDP.CT.BedFeeTime","床位时制",id,eobj.BedFeeTimeName,"D",eobj)
	    d eobj.%Close()
	}
	else 
	{
	    Trollback
	    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位时制","web.DHCBL.CT.BedFeeTime","DeleteData",eobj)
	    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}
