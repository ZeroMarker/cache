/// 日间手术参数配置参数配置表，增删改查
/// 基础数据平台-李可凡
/// 2021-05-10
Class web.DHCBL.CT.ORCDaySurgeryConfig Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡		
/// CreatDate: 2021-05-08
/// Description：查询 日间手术参数配置 下拉框
/// Table:ORC_DaySurgeryConfig
/// Input:id, code, desc
/// Output:RowId,DSCCode,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgeryConfig","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, name As %String, hospid As %String) As %Query(ROWSPEC = "DSCRowId,DSCCode,DSCName,DSCContent,DSCExplain")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s DSCRowId=rowid
		s DSCCode=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),2)		//代码
		s DSCName=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),3)		//名称
		s DSCContent=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),4)		//内容
		s DSCExplain=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),5)		//参数说明
		d OutputRowCmb
	}
	else
	{
		s DSCRowId=0
		for 
		{
			s DSCRowId=$o(^User.ORCDaySurgeryConfigD(DSCRowId)) q:DSCRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgeryConfig",DSCRowId,hospid)
	  		continue:showflag="N"
			s DSCCode=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),2)		//代码
			s DSCName=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),3)		//名称
			s DSCContent=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),4)		//内容
			s DSCExplain=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),5)		//参数说明
			d OutputRowCmb
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(DSCRowId,DSCCode,DSCName,DSCContent,DSCExplain)
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
/// Description：查询日间手术参数配置表
/// Table：ORC_DaySurgeryConfig
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgeryConfig","GetList","","","")
Query GetList(rowid As %String, code As %String, name As %String, hospid As %String) As %Query(ROWSPEC = "DSCRowId,DSCCode,DSCName,DSCContent,DSCExplain")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String, hospid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s DSCRowId=rowid
		s DSCCode=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),2)		//代码
		s DSCName=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),3)		//名称
		s DSCContent=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),4)		//内容
		s DSCExplain=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),5)		//参数说明
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:name'="" name=$ZCONVERT(name,"U")
		s DSCRowId=0
		for
		{
			s DSCRowId=$o(^User.ORCDaySurgeryConfigD(DSCRowId)) q:DSCRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgeryConfig",DSCRowId,hospid)
	  		continue:showflag="N"
			s DSCCode=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),2)		//代码
			s DSCName=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),3)		//名称
			s DSCContent=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),4)		//内容
			s DSCExplain=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),5)		//参数说明
			s PINYIN=""
			s:name'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DSCName)
		 	if ($ZCONVERT(DSCCode,"U")[code)&&(($ZCONVERT(DSCName,"U")[name)||(PINYIN[name))
		 	{
				d OutputRow
		 	}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DSCRowId,DSCCode,DSCName,DSCContent,DSCExplain)
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
/// Description：查询日间手术参数配置表
/// Table：ORC_DaySurgeryConfig
/// Input：id
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryConfig).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.ORCDaySurgeryConfig).%OpenId(id)
	 s eobj = ##class(web.Entity.CT.ORCDaySurgeryConfig).%New()
	 s eobj.DSCRowId = id
	 s eobj.DSCCode=obj.DSCCode		//代码
	 s eobj.DSCName=obj.DSCName		//名称
	 s eobj.DSCContent=obj.DSCContent		//内容
	 s eobj.DSCExplain=obj.DSCExplain		//参数说明
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：删除日间手术参数配置表
/// Table：ORC_DaySurgeryConfig
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgeryConfig).DeleteData(19)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.ORCDaySurgeryConfig).%OpenId(id)
		s pobj = ##class(web.Entity.CT.ORCDaySurgeryConfig).%New()
		s pobj.DSCRowId = id
		s pobj.DSCCode=obj.DSCCode		//代码
		s pobj.DSCName=obj.DSCName		//名称
		s pobj.DSCContent=obj.DSCContent		//内容
		s pobj.DSCExplain=obj.DSCExplain		//参数说明
		
		TSTART
		s sc=##class(User.ORCDaySurgeryConfig).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryConfig","User.ORCDaySurgeryConfig","日间手术参数配置",id,pobj.DSCName,"D",pobj)
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
/// Table：ORC_DaySurgeryConfig
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCDaySurgeryConfig).FormValidate("1","1")
ClassMethod FormValidate(id As %String, code As %String, name As %String, hospid As %String = "") As %String
{
	s flag=0
	if code'=""
	{
		s DSCRowId=$o(^User.ORCDaySurgeryConfigI("DSCCodeIndex",code,0))
		if (DSCRowId'="")&&(id'=DSCRowId)
		{
			if (hospid'="")
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgeryConfig",DSCRowId,hospid)
				s:(showflag'="N") flag=1
			}
			else
			{
				s flag=1
			}
		}
	}
	if name'=""
	{
		s DSCRowId=$o(^User.ORCDaySurgeryConfigI("DSCNameIndex",name,0))
		if (DSCRowId'="")&&(id'=DSCRowId)
		{
			if (hospid'="")
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgeryConfig",DSCRowId,hospid)
				s:(showflag'="N") flag=1
			}
			else
			{
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// function:日间手术参数配置表的新增修改
/// Table：ORC_DaySurgeryConfig
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCDaySurgeryConfig) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.DSCRowId,eobj.DSCCode,eobj.DSCName,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.DSCRowId="")
		{
			s obj=##class(User.ORCDaySurgeryConfig).%New()
		}
		else
		{
			s obj=##class(User.ORCDaySurgeryConfig).%OpenId(eobj.DSCRowId)
			s bobj=##class(web.Entity.CT.ORCDaySurgeryConfig).%New()
		    s bobj.DSCRowId=eobj.DSCRowId
		    s bobj.DSCCode=obj.DSCCode		//代码
			s bobj.DSCName=obj.DSCName		//名称
			s bobj.DSCContent=obj.DSCContent		//内容
			s bobj.DSCExplain=obj.DSCExplain		//参数说明
		}
		s obj.DSCCode=eobj.DSCCode		//代码
		s obj.DSCName=eobj.DSCName		//名称
		s obj.DSCContent=eobj.DSCContent		//内容
		s obj.DSCExplain=eobj.DSCExplain		//参数说明
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.DSCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryConfig","User.ORCDaySurgeryConfig","日间手术参数配置",eobj.DSCRowId,eobj.DSCName,"U",eobj,bobj)
			d:eobj.DSCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgeryConfig","User.ORCDaySurgeryConfig","日间手术参数配置",id,eobj.DSCName,"A",eobj)
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
/// CreatDate: 2021-05-18
/// function:根据医院加代码返回参数值
/// input：参数配置代码，医院id
/// output：参数值
/// Other:w ##class(web.DHCBL.CT.ORCDaySurgeryConfig).GetDSCContentByCode("1","2")
ClassMethod GetDSCContentByCode(code As %String, hospid As %String) As %String
{
	q:code="" ""
	q:hospid="" ""
	s DSCContent=""
	s DSCRowId=0
	for
	{
		s DSCRowId=$o(^User.ORCDaySurgeryConfigI("DSCCodeIndex",code,DSCRowId)) q:DSCRowId=""
		s showflag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgeryConfig",DSCRowId,hospid)
		if (showflag="Y")
		{
			s DSCContent=$lg($g(^User.ORCDaySurgeryConfigD(DSCRowId)),4)		//内容
			q
		}
	}
	q DSCContent
}

}
