/// 日间手术表，增删改查
/// Table:ORC_DaySurgery
/// 基础数据平台-李可凡
/// 2021-05-08
Class web.DHCBL.CT.ORCDaySurgery Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡		
/// CreatDate: 2021-05-08
/// Description：查询 日间手术 下拉框
/// Table:ORC_DaySurgery
/// Input:id, code, desc
/// Output:RowId,DSDaySurgeryDR,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgery","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, daysurgery As %String, hospid As %String) As %Query(ROWSPEC = "DSRowId,DSDaySurgeryDR,OPERCode,OPERDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, daysurgery As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s DSRowId=rowid
		s DSDaySurgeryDR=$lg($g(^User.ORCDaySurgeryD(DSRowId)),2)		//日间手术DR
		s OPERCode="",OPERDesc=""
		s:DSDaySurgeryDR'="" OPERCode=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",1)	//手术代码
		s:DSDaySurgeryDR'="" OPERDesc=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",2)	//手术名称
		d OutputRowCmb
	}
	else
	{
		s DSRowId=0
		for 
		{
			s DSRowId=$o(^User.ORCDaySurgeryD(DSRowId)) q:DSRowId=""
			s DSDaySurgeryDR= $lg($g(^User.ORCDaySurgeryD(DSRowId)),2)		//日间手术DR
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgery",DSRowId,hospid)
	  		continue:showflag="N"
			s OPERCode="",OPERDesc=""
			s:DSDaySurgeryDR'="" OPERCode=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",1)	//手术代码
			s:DSDaySurgeryDR'="" OPERDesc=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",2)	//手术名称
			d OutputRowCmb
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(DSRowId,DSDaySurgeryDR,OPERCode,OPERDesc)
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
/// Description：查询日间手术表
/// Table：ORC_DaySurgery
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCDaySurgery","GetList","","","","","")
Query GetList(rowid As %String, daysurgery As %String, hospid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DSRowId,DSDaySurgeryDR,OPERCode,OPERDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, daysurgery As %String, hospid As %String, code As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s DSRowId=rowid
		s DSDaySurgeryDR= $lg($g(^User.ORCDaySurgeryD(DSRowId)),2)		//日间手术DR
		s OPERCode="",OPERDesc=""
		s:DSDaySurgeryDR'="" OPERCode=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",1)	//手术代码
		s:DSDaySurgeryDR'="" OPERDesc=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",2)	//手术名称
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s DSRowId=0
		for
		{
			s DSRowId=$o(^User.ORCDaySurgeryD(DSRowId)) q:DSRowId=""
			s DSDaySurgeryDR=$lg($g(^User.ORCDaySurgeryD(DSRowId)),2)		//日间手术DR
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgery",DSRowId,hospid)
	  		continue:showflag="N"
			s OPERCode="",OPERDesc=""
			s:DSDaySurgeryDR'="" OPERCode=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",1)	//手术代码
			s:DSDaySurgeryDR'="" OPERDesc=$p($g(^ORC("OPER",DSDaySurgeryDR)),"^",2)	//手术名称
			s PINYIN=""
		 	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(OPERDesc)
		 	if ((daysurgery="")||(daysurgery=DSDaySurgeryDR))&&($ZCONVERT(OPERCode,"U")[code)&&(($ZCONVERT(OPERDesc,"U")[desc)||(PINYIN[desc))
		 	{
				d OutputRow
		 	}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DSRowId,DSDaySurgeryDR,OPERCode,OPERDesc)
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
/// Description：查询日间手术表
/// Table：ORC_DaySurgery
/// Input：id
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgery).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.ORCDaySurgery).%OpenId(id)
	 s eobj = ##class(web.Entity.CT.ORCDaySurgery).%New()
	 s eobj.DSRowId = id
	 s:obj.DSDaySurgeryDR'="" eobj.DSDaySurgeryDR=obj.DSDaySurgeryDR.%Id()			// 日间手术DR
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// Description：删除日间手术表
/// Table：ORC_DaySurgery
/// Others：w ##class(web.DHCBL.CT.ORCDaySurgery).DeleteData(19)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.ORCDaySurgery).%OpenId(id)
		s pobj = ##class(web.Entity.CT.ORCDaySurgery).%New()
		s pobj.DSRowId = id
		s:obj.DSDaySurgeryDR'="" pobj.DSDaySurgeryDR=obj.DSDaySurgeryDR.%Id()	// 日间手术DR
		
		TSTART
		s sc=##class(User.ORCDaySurgery).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgery","User.ORCDaySurgery","日间手术",id,pobj.DSDaySurgeryDR,"D",pobj)
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
/// Table：ORC_DaySurgery
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.ORCDaySurgery).FormValidate("1","1")
ClassMethod FormValidate(id As %String, daysurgery As %String, hospid As %String) As %String
{
	s ^templkf(1)=id_"^"_daysurgery_"^"_hospid
	s flag=0
	if daysurgery'=""
	{
		s DSRowId=$o(^User.ORCDaySurgeryI("DaySurgeryIndex",daysurgery,0))
		if (DSRowId'="")&&(id'=DSRowId)
		{
			s hospflag=$d(^User.BDPMappingHospI("HospRef","ORC_DaySurgery",DSRowId,hospid))
			if (hospflag'=0) s flag=1
		}
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-05-08
/// function:日间手术表的新增修改
/// Table：ORC_DaySurgery
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCDaySurgery) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.DSRowId,eobj.DSDaySurgeryDR,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.DSRowId="")
		{
			s obj=##class(User.ORCDaySurgery).%New()
		}
		else
		{
			s obj=##class(User.ORCDaySurgery).%OpenId(eobj.DSRowId)
			s bobj=##class(web.Entity.CT.ORCDaySurgery).%New()
		    s bobj.DSRowId=eobj.DSRowId
		    s:obj.DSDaySurgeryDR'="" bobj.DSDaySurgeryDR=obj.DSDaySurgeryDR.%Id()		// 日间手术DR
		}
		d obj.DSDaySurgeryDRSetObjectId(eobj.DSDaySurgeryDR)		// 日间手术DR
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.DSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgery","User.ORCDaySurgery","日间手术",eobj.DSRowId,eobj.DSDaySurgeryDR,"U",eobj,bobj)
			d:eobj.DSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_DaySurgery","User.ORCDaySurgery","日间手术",id,eobj.DSDaySurgeryDR,"A",eobj)
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

/// 日间手术表清数据方法，提供给产品组
/// 基础数据-likefan
/// 2021-11-16
/// d ##class(web.DHCBL.CT.ORCDaySurgery).DeleteAllData()
ClassMethod DeleteAllData() As %String
{
	d ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals("ORC_DaySurgery")
	k ^User.ORCDaySurgeryD,^User.ORCDaySurgeryI
	q ""
}

}
