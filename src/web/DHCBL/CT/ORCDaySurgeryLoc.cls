/// 日间手术科室表，增删改查
/// Table:ORC_DaySurgeryLoc
/// 基础数据平台-李可凡
/// 2021-05-08
Class web.DHCBL.CT.ORCDaySurgeryLoc Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡		
/// CreatDate: 2021-05-08
/// Description：查询 日间手术科室 下拉框
/// Table:ORC_DaySurgeryLoc
/// Input:id, code, desc
/// Output:RowId,DSLDaySurgeryLocDR,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgeryLoc","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, daysurgeryloc As %String, hospid As %String) As %Query(ROWSPEC = "DSLRowId,DSLDaySurgeryLocDR,CTLOCCode,CTLOCDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, daysurgeryloc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s DSLRowId=rowid
		s DSLDaySurgeryLocDR=$lg($g(^User.ORCDaySurgeryLocD(DSLRowId)),2)		//日间手术科室DR
		s CTLOCCode="",CTLOCDesc=""
		s:DSLDaySurgeryLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",1)	//科室代码
		s:DSLDaySurgeryLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",2)	//科室名称
		d OutputRowCmb
	}
	else
	{
		s DSLRowId=0
		for 
		{
			s DSLRowId=$o(^User.ORCDaySurgeryLocD(DSLRowId)) q:DSLRowId=""
			s DSLDaySurgeryLocDR= $lg($g(^User.ORCDaySurgeryLocD(DSLRowId)),2)		//日间手术科室DR
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",DSLDaySurgeryLocDR,hospid)
	  		continue:showflag="N"
			s CTLOCCode="",CTLOCDesc=""
			s:DSLDaySurgeryLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",1)	//科室代码
			s:DSLDaySurgeryLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",2)	//科室名称
			d OutputRowCmb
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(DSLRowId,DSLDaySurgeryLocDR,CTLOCCode,CTLOCDesc)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：查询日间手术科室表
/// Table：ORC_DaySurgeryLoc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgeryLoc","GetList","","","","","")
Query GetList(rowid As %String, daysurgeryloc As %String, hospid As %String, query As %String) As %Query(ROWSPEC = "DSLRowId,DSLDaySurgeryLocDR,CTLOCCode,CTLOCDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, daysurgeryloc As %String, hospid As %String, query As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s DSLRowId=rowid
		s DSLDaySurgeryLocDR= $lg($g(^User.ORCDaySurgeryLocD(DSLRowId)),2)		//日间手术科室DR
		s CTLOCCode="",CTLOCDesc=""
		s:DSLDaySurgeryLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",1)	//科室代码
		s:DSLDaySurgeryLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",2)	//科室名称
		d OutputRow
	}
	else
	{
		s:query'="" query=$ZCONVERT(query,"U")
		s DSLRowId=0
		for
		{
			s DSLRowId=$o(^User.ORCDaySurgeryLocD(DSLRowId)) q:DSLRowId=""
			s DSLDaySurgeryLocDR=$lg($g(^User.ORCDaySurgeryLocD(DSLRowId)),2)		//日间手术科室DR
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",DSLDaySurgeryLocDR,hospid)
	  		continue:showflag="N"
			s CTLOCCode="",CTLOCDesc=""
			s:DSLDaySurgeryLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",1)	//科室代码
			s:DSLDaySurgeryLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLDaySurgeryLocDR)),"^",2)	//科室名称
			s PINYIN=""
		 	s:query'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
		 	if ((daysurgeryloc="")||(daysurgeryloc=DSLDaySurgeryLocDR))&&(($ZCONVERT(CTLOCCode,"U")[query)||($ZCONVERT(CTLOCDesc,"U")[query)||(PINYIN[query))
		 	{
				d OutputRow
		 	}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DSLRowId,DSLDaySurgeryLocDR,CTLOCCode,CTLOCDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：查询日间手术科室表
/// Table：ORC_DaySurgeryLoc
/// Input：id
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryLoc).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.ORCDaySurgeryLoc).%OpenId(id)
	 s eobj = ##class(web.Entity.CT.ORCDaySurgeryLoc).%New()
	 s eobj.DSLRowId = id
	 s:obj.DSLDaySurgeryLocDR'="" eobj.DSLDaySurgeryLocDR=obj.DSLDaySurgeryLocDR.%Id()			// 日间手术科室DR
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：删除日间手术科室表
/// Table：ORC_DaySurgeryLoc
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryLoc).DeleteData(19)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.ORCDaySurgeryLoc).%OpenId(id)
		s pobj = ##class(web.Entity.CT.ORCDaySurgeryLoc).%New()
		s pobj.DSLRowId = id
		s:obj.DSLDaySurgeryLocDR'="" pobj.DSLDaySurgeryLocDR=obj.DSLDaySurgeryLocDR.%Id()	// 日间手术科室DR
		
		TSTART
		s sc=##class(User.ORCDaySurgeryLoc).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLoc","User.ORCDaySurgeryLoc","日间手术科室",id,pobj.DSLDaySurgeryLocDR,"D",pobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：数据重复校验
/// Table：ORC_DaySurgeryLoc
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCDaySurgeryLoc).FormValidate("1","1")
ClassMethod FormValidate(id As %String, daysurgeryloc As %String) As %String
{
	s flag=0
	if daysurgeryloc'=""
	{
		s DSLRowId=$o(^User.ORCDaySurgeryLocI("DaySurgeryLocIndex",daysurgeryloc,0))
		if (DSLRowId'="")&&(id'=DSLRowId) s flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// function:日间手术科室表的新增修改
/// Table：ORC_DaySurgeryLoc
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCDaySurgeryLoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.DSLRowId,eobj.DSLDaySurgeryLocDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.DSLRowId="")
		{
			s obj=##class(User.ORCDaySurgeryLoc).%New()
		}
		else
		{
			s obj=##class(User.ORCDaySurgeryLoc).%OpenId(eobj.DSLRowId)
			s bobj=##class(web.Entity.CT.ORCDaySurgeryLoc).%New()
		    s bobj.DSLRowId=eobj.DSLRowId
		    s:obj.DSLDaySurgeryLocDR'="" bobj.DSLDaySurgeryLocDR=obj.DSLDaySurgeryLocDR.%Id()		// 日间手术科室DR
		}
		d obj.DSLDaySurgeryLocDRSetObjectId(eobj.DSLDaySurgeryLocDR)		// 日间手术科室DR
		TSTART
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.DSLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLoc","User.ORCDaySurgeryLoc","日间手术科室",eobj.DSLRowId,eobj.DSLDaySurgeryLocDR,"U",eobj,bobj)
			d:eobj.DSLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLoc","User.ORCDaySurgeryLoc","日间手术科室",id,eobj.DSLDaySurgeryLocDR,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// 入参科室ID，出参是否是日间手术科室（Y/N）
/// w ##class(web.DHCBL.CT.ORCDaySurgeryLoc).IsDaySurgeryLoc("")
ClassMethod IsDaySurgeryLoc(id) As %String
{
	q:id="" ""
	s flag="N"
	s:$d(^User.ORCDaySurgeryLocI("DaySurgeryLocIndex",id)) flag="Y"
	q flag
}

/// 日间手术科室及关联科室表清数据方法，提供给产品组
/// 基础数据-likefan
/// 2021-11-16
/// d ##class(web.DHCBL.CT.ORCDaySurgeryLoc).DeleteAllData()
ClassMethod DeleteAllData() As %String
{
	k ^User.ORCDaySurgeryLocD,^User.ORCDaySurgeryLocI,^User.ORCDaySurgeryLocLinkLocI
	q ""
}

}
