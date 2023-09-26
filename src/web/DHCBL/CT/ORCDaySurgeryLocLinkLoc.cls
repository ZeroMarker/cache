/// 日间手术科室关联科室关联科室表，增删改查
/// 基础数据平台-李可凡
/// 2021-05-08
Class web.DHCBL.CT.ORCDaySurgeryLocLinkLoc Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：查询日间手术科室关联科室表
/// Table：ORC_DaySurgeryLocLinkLoc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgeryLocLinkLoc","GetList","","","","")
Query GetList(rowid As %String, parref As %String, query As %String) As %Query(ROWSPEC = "DSLLLRowId,DSLLLParRef,DSLLLLinkLocDR,CTLOCCode,CTLOCDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, query As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s DSLLLRowId=rowid
		s DSLLLParRef=$p(DSLLLRowId,"||",1)
		s DSLLLChildSub=$p(DSLLLRowId,"||",2)
		s DSLLLLinkLocDR=$lg($g(^User.ORCDaySurgeryLocD(DSLLLParRef,"ChildLinkLoc",DSLLLChildSub)),2)		//日间手术科室关联科室DR
		s CTLOCCode="",CTLOCDesc=""
		s:DSLLLLinkLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLLLLinkLocDR)),"^",1)	//科室代码
		s:DSLLLLinkLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLLLLinkLocDR)),"^",2)	//科室名称
		d OutputRow
	}
	else
	{
		if (parref'="")
		{
			s:query'="" query=$ZCONVERT(query,"U")
			s DSLLLParRef=0
			for
			{
				s DSLLLParRef=$o(^User.ORCDaySurgeryLocD(DSLLLParRef)) q:DSLLLParRef=""
				continue:(parref'=DSLLLParRef)
				s DSLLLChildSub=0
				for
				{
					s DSLLLChildSub=$o(^User.ORCDaySurgeryLocD(DSLLLParRef,"ChildLinkLoc",DSLLLChildSub)) q:DSLLLChildSub=""
					s DSLLLRowId=DSLLLParRef_"||"_DSLLLChildSub
					s DSLLLLinkLocDR=$lg($g(^User.ORCDaySurgeryLocD(DSLLLParRef,"ChildLinkLoc",DSLLLChildSub)),2)		//日间手术科室关联科室DR
					s CTLOCCode="",CTLOCDesc=""
					s:DSLLLLinkLocDR'="" CTLOCCode=$p($g(^CTLOC(DSLLLLinkLocDR)),"^",1)	//科室代码
					s:DSLLLLinkLocDR'="" CTLOCDesc=$p($g(^CTLOC(DSLLLLinkLocDR)),"^",2)	//科室名称
					s PINYIN=""
				 	s:query'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
				 	if ($ZCONVERT(CTLOCCode,"U")[query)||($ZCONVERT(CTLOCDesc,"U")[query)||(PINYIN[query)
				 	{
						d OutputRow
				 	}
				}
			}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DSLLLRowId,DSLLLParRef,DSLLLLinkLocDR,CTLOCCode,CTLOCDesc)
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
/// Description：查询日间手术科室关联科室表
/// Table：ORC_DaySurgeryLocLinkLoc
/// Input：id
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s obj = ##class(User.ORCDaySurgeryLocLinkLoc).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCDaySurgeryLocLinkLoc).%New()
	s eobj.DSLLLRowId = id
	s:obj.DSLLLParRef'="" eobj.DSLLLParRef=obj.DSLLLParRef.%Id()
	s:obj.DSLLLLinkLocDR'="" eobj.DSLLLLinkLocDR=obj.DSLLLLinkLocDR.%Id()			// 日间手术科室关联科室DR
	d obj.%Close()
	k obj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：删除日间手术科室关联科室表
/// Table：ORC_DaySurgeryLocLinkLoc
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).DeleteData("1||2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.ORCDaySurgeryLocLinkLoc).%OpenId(id)
		s pobj = ##class(web.Entity.CT.ORCDaySurgeryLocLinkLoc).%New()
		s pobj.DSLLLRowId = id
		s:obj.DSLLLParRef'="" pobj.DSLLLParRef=obj.DSLLLParRef.%Id()
		s:obj.DSLLLLinkLocDR'="" pobj.DSLLLLinkLocDR=obj.DSLLLLinkLocDR.%Id()	// 日间手术科室关联科室DR
		TSTART
		s sc=##class(User.ORCDaySurgeryLocLinkLoc).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLocLinkLoc","User.ORCDaySurgeryLocLinkLoc","日间手术科室关联科室",id,pobj.DSLLLLinkLocDR,"D",pobj)
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
/// Table：ORC_DaySurgeryLocLinkLoc
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).FormValidate("1||1","1","2")
ClassMethod FormValidate(id As %String, parref As %String, dsllllinkloc As %String) As %String
{
	s flag=0
	if (parref'="")&&(dsllllinkloc'="")
	{
		s DSLLLChildSub=$o(^User.ORCDaySurgeryLocLinkLocI("DSLocIndex",parref,dsllllinkloc,0))
		s DSLLLRowId=parref_"||"_DSLLLChildSub
		s:(DSLLLChildSub'="")&&(DSLLLRowId'=id) flag=1
	}
	q flag
}

/// w ##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).test()
ClassMethod test() As %String
{
	s eobj=##class(web.Entity.CT.ORCDaySurgeryLocLinkLoc).%New()
	s eobj.DSLLLParRef=1
	s eobj.DSLLLLinkLocDR=4
	s re=##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).SaveEntity(eobj)
	q re
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// function:日间手术科室关联科室表的新增修改
/// Table：ORC_DaySurgeryLocLinkLoc
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCDaySurgeryLocLinkLoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DSLLLRowId'="" eobj.DSLLLParRef=$p(eobj.DSLLLRowId,"||",1)
		s flag=..FormValidate(eobj.DSLLLRowId,eobj.DSLLLParRef,eobj.DSLLLLinkLocDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.DSLLLRowId="")
		{
			s obj=##class(User.ORCDaySurgeryLocLinkLoc).%New(eobj.DSLLLParRef)
		}
		else
		{
			s obj=##class(User.ORCDaySurgeryLocLinkLoc).%OpenId(eobj.DSLLLRowId)
			s bobj=##class(web.Entity.CT.ORCDaySurgeryLocLinkLoc).%New()
		    s bobj.DSLLLRowId=eobj.DSLLLRowId
		    s:obj.DSLLLParRef'="" bobj.DSLLLParRef=obj.DSLLLParRef.%Id()
		    s:obj.DSLLLLinkLocDR'="" bobj.DSLLLLinkLocDR=obj.DSLLLLinkLocDR.%Id()		// 日间手术科室关联科室DR
		}
		d obj.DSLLLParRefSetObjectId(eobj.DSLLLParRef)
		d obj.DSLLLLinkLocDRSetObjectId(eobj.DSLLLLinkLocDR)		// 日间手术科室关联科室DR
		TSTART
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.DSLLLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLocLinkLoc","User.ORCDaySurgeryLocLinkLoc","日间手术科室关联科室",eobj.DSLLLRowId,eobj.DSLLLLinkLocDR,"U",eobj,bobj)
			d:eobj.DSLLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryLocLinkLoc","User.ORCDaySurgeryLocLinkLoc","日间手术科室关联科室",id,eobj.DSLLLLinkLocDR,"A",eobj)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// function:入参：登录locid，出参：日间手术中心关联科室ID，如果有多个可以拼接
/// w ##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).GetLinkLoc(1)
ClassMethod GetLinkLoc(locid) As %String
{
	q:locid="" ""
	s result=""
	s ID=0
	for
	{
		s ID=$o(^User.ORCDaySurgeryLocD(ID)) q:ID=""
		s DSLDaySurgeryLocDR=$lg($g(^User.ORCDaySurgeryLocD(ID)),2)
		q:DSLDaySurgeryLocDR=locid
	}
	q:ID="" ""
	if $d(^User.ORCDaySurgeryLocD(ID))
	{
		s DSLLLChildSub=0
		for
		{
			s DSLLLChildSub=$o(^User.ORCDaySurgeryLocD(ID,"ChildLinkLoc",DSLLLChildSub)) q:DSLLLChildSub=""
			s DSLLLLinkLocDR=$lg($g(^User.ORCDaySurgeryLocD(ID,"ChildLinkLoc",DSLLLChildSub)),2)		//日间手术科室关联科室DR
			continue:DSLLLLinkLocDR=""
			s:result'="" result=result_"^"
			s result=result_DSLLLLinkLocDR
		}
	}
	q result
}

}
