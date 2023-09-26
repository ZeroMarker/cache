/// Creator:鲁俊文
/// CreatDate:2022-10-26
/// Description：版本字典表与医保对照的关联表
Class web.DHCBL.CT.BDVersionDictInsu Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:鲁俊文
/// CreatDate:2022-10-26
/// Description：查询版本字典表与医保对照的关联表
/// Table：CT_BDP_CT.BDVersionDictInsu
/// Input：rowid,code,desc,type
/// Return: ID:RowId VersionDictDr:版本字典表 VersionInsuDr:医保版本 DateFrom:开始日期 DateTo:结束日期 IsSyncToMr:同步到病案系统 
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDVersionDictInsu","GetList","","","")
Query GetList(rowid As %String, versiondictdr As %String, versioninsudr As %String) As %Query(ROWSPEC = "ID:%String,VersionDictDr:%String,VersionInsuDr:%String, DateFrom:%String,DateTo:%String,IsSyncToMr:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, versiondictdr As %String, versioninsudr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (rowid'="") //根据rowid返回该条记录
	{
    	s ID=rowid                                     ///RowID
    	s VersionDictDr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),2) /// 版本字典表字段dr
    	if VersionDictDr'=""
    	{
	    	s VersionDictDr=$lg($g(^CT.BDP.CT.BDVersionDictD(VersionDictDr)),4) ///版本号
    	}
    	
    	s VersionInsuDr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),3)	///医保版本dr
    	if VersionInsuDr'=""
    	{
	    	s VersionInsuDr=$lg($g(^CT.BDP.CT.BDVersionDictD(VersionInsuDr)),4) ///版本号
    	}
	    s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),4)   ///开始日期
	    s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),5)     ///结束日期
	   	s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) ///转日期格式
	    s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	///转日期格式
	    s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),6) ///同步到病案系统
	    d OutputRow
	}
	else
	{
	    
	    s ID=0
    	for 
    	{
	        s ID=$o(^CT.BDP.CT.BDVersionDictInsuD(ID)) q:ID=""  ///RowID
	    	s VersionDictDr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),2) /// 版本字典表字段dr
	    	continue:(versiondictdr'="")&&(versiondictdr'=VersionDictDr)
	    	s VersionInsuDr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),3)	///医保版本dr
	    	continue:(versioninsudr'="")&&(versioninsudr'=VersionInsuDr)
	    	if VersionDictDr'=""
	    	{
		    	s VersionDictDr=$lg($g(^CT.BDP.CT.BDVersionDictD(VersionDictDr)),4) ///版本号
	    	}
	    	if VersionInsuDr'=""
	    	{
		    	s VersionInsuDr=$lg($g(^CT.BDP.CT.BDVersionDictD(VersionInsuDr)),4) ///版本号
	    	}
		    s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),4)   ///开始日期
		    s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),5)     ///结束日期
		    s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(ID)),6) ///同步到病案系统
	    	s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) ///转日期格式
	    	s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo)	///转日期格式
	    	d OutputRow
        	 
    	}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,VersionDictDr,VersionInsuDr,DateFrom,DateTo,IsSyncToMr)
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

/// Creator:    鲁俊文
/// CreatDate:  2022-10-26
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.BDVersionDictInsu).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BDVersionDictInsu).%New()
    s obj = ##class(CT.BDP.CT.BDVersionDictInsu).%OpenId(id)
    s eobj.ID=id ///RowId
    s:obj.VersionDictDr'="" eobj.VersionDictDr = obj.VersionDictDr.%Id() ///版本字典表dr
    s:obj.VersionInsuDr'="" eobj.VersionInsuDr = obj.VersionInsuDr.%Id() ///医保版本dr
    s:obj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.DateFrom) ///开始日期 
    s:obj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.DateTo) ///结束日期
    s eobj.IsSyncToMr=obj.IsSyncToMr ///同步到病案系统
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-09-13
/// Description：重复校验
/// Table：CT_BDP_CT.BDVersionDictInsu
/// Input：id code
/// Others：w ##class(web.DHCBL.CT.BDVersionDictInsu).FormValidate("","12","")
ClassMethod FormValidate(id As %String, versioninsurancedr As %String, versionnamedr As %String) As %String
{
	s flag=0
	if (versioninsurancedr'="")&&(versionnamedr'="")
	{
		s ID=$o(^CT.BDP.CT.BDVersionDictInsuI("IndexDictInsu",versioninsurancedr,versionnamedr,0))
		if (ID'="")&&(id'=ID)
		{ 
			s flag=1
		}
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-26
/// Description：版本字典表与医保对照的关联表信息
/// Table：CT_BDP_CT.BDVersionDictInsu
/// Others：w ##class(web.DHCBL.CT.BDVersionDictInsu).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.BDVersionDictInsu) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateFrom)	//时间转换
	    s:eobj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateTo)		//时间转换 
	    s:eobj.DateFrom="" eobj.DateFrom=+$h //取当前日期
	    s:eobj.IsSyncToMr="" eobj.IsSyncToMr="N"
		s flag=..FormValidate(eobj.ID,eobj.VersionDictDr,eobj.VersionInsuDr)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.BDVersionDictInsu).%New()
		}
		else
		{
			s obj=##class(CT.BDP.CT.BDVersionDictInsu).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.BDVersionDictInsu).%New()
		    s bobj.ID=eobj.ID    ////RowId
		    s:obj.VersionDictDr'="" bobj.VersionDictDr = obj.VersionDictDr.%Id() ///版本字典表dr
			s:obj.VersionInsuDr'="" bobj.VersionInsuDr = obj.VersionInsuDr.%Id() ///医保版本dr
			s bobj.DateFrom=obj.DateFrom ///开始日期
			s bobj.DateTo=obj.DateTo ///结束日期
			s bobj.IsSyncToMr=obj.IsSyncToMr ///同步到病案系统
				
		}
		d obj.VersionDictDrSetObjectId(eobj.VersionDictDr) ///版本字典表dr
	    d obj.VersionInsuDrSetObjectId(eobj.VersionInsuDr) ///医保版本dr
		s obj.DateFrom= eobj.DateFrom     //开始日期
	    s obj.DateTo= eobj.DateTo 		 //结束日期
	    s obj.IsSyncToMr=eobj.IsSyncToMr ///同步到病案系统
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s VersionDictDesc="",VersionInsuDesc=""
			if eobj.VersionDictDr'=""
	    	{
		    	s VersionDictDesc=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.VersionDictDr)),4) ///版本号
	    	}
	    	if eobj.VersionInsuDr'=""
	    	{
		    	s VersionInsuDesc=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.VersionInsuDr)),4) ///版本号
	    	}
	    	s Desc=VersionDictDesc_" "_VersionInsuDesc
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDictInsu","CT.BDP.CT.BDVersionDictInsu","版本字典表与医保对照的关联表",eobj.ID,Desc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDictInsu","CT.BDP.CT.BDVersionDictInsu","版本字典表与医保对照的关联表",id,Desc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("版本字典表与医保对照的关联表","web.DHCBL.CT.BDVersionDictInsu","SaveEntity",eobj) 
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:鲁俊文
/// CreatDate:2022-09-09
/// Description：根据id删除版本字典表与医保对照的关联表信息的内容
/// Table：CT_BDP_CT.BDVersionDictInsu
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BDVersionDictInsu).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	//new Entity对象，用于保存日志
	s pobj = ##class(CT.BDP.CT.BDVersionDictInsu).%OpenId(id)
	s eobj = ##class(web.Entity.CT.BDVersionDictInsu).%New()
	s eobj.ID = id ///RowId
	s:pobj.VersionDictDr'="" eobj.VersionDictDr=pobj.VersionDictDr.%Id() ///版本字典表
	s:pobj.VersionInsuDr'="" eobj.VersionInsuDr=pobj.VersionInsuDr.%Id() ///医保版本
	s eobj.DateFrom=pobj.DateFrom ///开始日期
	s eobj.DateTo=pobj.DateTo ///结束日期
	s eobj.IsSyncToMr=pobj.IsSyncToMr ///同步到病案系统

	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.BDVersionDictInsu).%DeleteId(id)
	if $$$ISOK(sc)
	{
	    Tcommit
	    s result = "{success:'true',info:'删除成功！'}"  
	    //保存日志
	    s VersionDictDesc="",VersionInsuDesc=""
		if eobj.VersionDictDr'=""
    	{
	    	s VersionDictDesc=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.VersionDictDr)),4) ///类型-版本号
    	}
    	if eobj.VersionInsuDr'=""
    	{
	    	s VersionInsuDesc=$lg($g(^CT.BDP.CT.BDVersionDictD(eobj.VersionInsuDr)),4) ///类型-版本号
    	}
    	s Desc=VersionDictDesc_" "_VersionInsuDesc
	    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDictInsu","CT.BDP.CT.BDVersionDictInsu","版本字典表与医保对照的关联表",id,Desc,"D",eobj)
	    d eobj.%Close()
	}
	else 
	{
	    Trollback
	    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("版本字典表与医保对照的关联表","web.DHCBL.CT.BDVersionDictInsu","DeleteData",eobj)
	    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

/// Creator:    chenying
/// CreatDate:  2023-01-04
/// Description：根据版本号id和对照版本id 获取是否同步病案系统标志
/// Input：dictid  insudictid
/// Return:Y/N
/// Other: w ##class(web.DHCBL.CT.BDVersionDictInsu).GetIsSyncToMr("1","2")
ClassMethod GetIsSyncToMr(dictid As %String, insudictid As %String) As %String
{
	q:dictid="" "N"
	q:insudictid="" "N"
	S DictInsuRowId=$o(^CT.BDP.CT.BDVersionDictInsuI("IndexDictInsu",dictid,insudictid,0))
	q:DictInsuRowId="" "N"
    s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(DictInsuRowId)),6) ///同步到病案系统
    s:IsSyncToMr="" IsSyncToMr="N"
    q IsSyncToMr
}

/// Creator:    chenying
/// CreatDate:  2023-02-20
/// Description：根据版本号代码和对照版本代码 获取是否同步病案系统接口标志
/// Input：  dictcode insudictcode
/// Return:Y/N
/// Other: w ##class(web.DHCBL.CT.BDVersionDictInsu).GetIsSyncToMr("SSLCB1.0","SSYBB1.0")
ClassMethod GetIsSyncToMrByCode(dictcode As %String, insudictcode As %String) As %String
{
	q:dictcode="" "N"
	s dictid=$o(^CT.BDP.CT.BDVersionDictI("CodeIndex"," "_$ZCONVERT(dictcode,"U"),0))
	q:dictid="" "N"
	q:insudictcode="" "N"
	s insudictid=$o(^CT.BDP.CT.BDVersionDictI("CodeIndex"," "_$ZCONVERT(insudictcode,"U"),0))
	q:insudictid="" "N"
	S DictInsuRowId=$o(^CT.BDP.CT.BDVersionDictInsuI("IndexDictInsu",dictid,insudictid,0))
	q:DictInsuRowId="" "N"
    s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictInsuD(DictInsuRowId)),6) ///同步到病案系统
    s:IsSyncToMr="" IsSyncToMr="N"
    q IsSyncToMr
}

}
