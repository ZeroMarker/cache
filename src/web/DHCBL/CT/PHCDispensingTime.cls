Import SQLUser

/// 名称:药学 3.1频次分发时间(频次PHCFreq子表)	
/// 描述:频次分发时间维护，包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期:2012-8-30
Class web.DHCBL.CT.PHCDispensingTime Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-17
/// Description:查询 频次分发时间
/// Table:User.PHCDispensingTime
/// Input:parref,rowid
/// Return:PHCDTRowId,PHCDTPHCFRParRef,PHCDTTime,PHCDTTimeDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCDispensingTime","GetList","4","")
/// CONVERT(varchar(12),PHCDT_Time,108) as PHCDTTime
Query GetList(parref As %String, rowid As %String) As %Query(ROWSPEC = "PHCDTRowId:%String,PHCDTPHCFRParRef:%String,PHCDTTime:%String,PHCDTTimeDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s PHCDTRowId=rowid
		s PHCDTPHCFRParRef=$p(rowid,"||",1)
		s PHCDTChildSub=$p(rowid,"||",2)
		s PHCDTTime=$P($g(^PHCFR(PHCDTPHCFRParRef,"DT",PHCDTChildSub)),"^",1)
		s:PHCDTTime'="" PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PHCDTTime)
		s PHCDTTimeDesc=$P($g(^PHCFR(PHCDTPHCFRParRef,"DT",PHCDTChildSub)),"^",2)
		d OutputRow
	}
	else
	{
		if (parref)
		{
			s PHCDTPHCFRParRef=parref
			s PHCDTChildSub=0
			for
			{
				s PHCDTChildSub=$o(^PHCFR(PHCDTPHCFRParRef,"DT",PHCDTChildSub)) q:PHCDTChildSub=""
				s PHCDTRowId=PHCDTPHCFRParRef_"||"_PHCDTChildSub
				s PHCDTTime=$p($g(^PHCFR(PHCDTPHCFRParRef,"DT",PHCDTChildSub)),"^",1)
				s:PHCDTTime'="" PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PHCDTTime)
				s PHCDTTimeDesc=$P($g(^PHCFR(PHCDTPHCFRParRef,"DT",PHCDTChildSub)),"^",2)
				i (PHCDTChildSub>0)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCDTRowId,PHCDTPHCFRParRef,PHCDTTime,PHCDTTimeDesc)
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
/// CreatDate:2013-8-15
/// Other:w ##class(web.DHCBL.CT.PHCDispensingTime).OpenData("4||1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s pobj = ##class(User.PHCDispensingTime).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCDispensingTime).%New()
	s eobj.PHCDTRowId = id
	s eobj.PHCDTChildSub=$p(id,"||",2)
	s eobj.PHCDTPHCFRParRef = $p(id,"||",1)
	s:pobj.PHCDTTime'="" pobj.PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(pobj.PHCDTTime)
	s eobj.PHCDTTime=pobj.PHCDTTime
	s eobj.PHCDTTimeDesc=pobj.PHCDTTimeDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.PHCDispensingTime).SaveTest()
	s obj = ##class(web.Entity.CT.PHCDispensingTime).%New()
	s obj.PHCDTPHCFRParRef=1
	s obj.PHCDTRowId="1||1"
	s obj.PHCDTTime="22:00:00"
	s obj.PHCDTTimeDesc="晚饭后"
	W ..SaveEntity(obj)
}

/// 保存完频次后调用，保存分发时间(多条数据)
/// 陈莹
/// 2014-12-24
/// d ##class(web.DHCBL.CT.PHCDispensingTime).SaveAll()
ClassMethod SaveAll(rowid As %String, dtstr As %String) As %String
{
	s ret=""
	if (dtstr'="")
	{
		s length=$Length(dtstr,"*")
		for i=1:1:length
		{
			s istr=$p(dtstr,"*",i)
			
			s eobj=##class(web.Entity.CT.PHCDispensingTime).%New()
			s eobj.PHCDTPHCFRParRef = rowid
			s eobj.PHCDTRowId = $p(istr,"^",1)
			s eobj.PHCDTTime = $p(istr,"^",2)
			s eobj.PHCDTTimeDesc = $p(istr,"^",3)
			s result= ..SaveEntity(eobj)
			if result["success:'false'"
			{
				s ret= result
			}
		}
		
	}
	q ret
}

/// Creator:陈莹
/// CreatDate:201-2-20
/// Description:数据重复验证方法,js调用
/// Table:User.PHCDispensingTime
/// Input:
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCDispensingTime).FormValidate("","","")
ClassMethod FormValidate(rowid As %String, parref As %String, time As %String) As %String
{
	n (parref,rowid,time)
	if parref="" s parref=$P(rowid,"||",1)
	q:parref="" 0
	s flag=0
	s PHCDTChildSub=0
	for
	{
		s PHCDTChildSub=$o(^PHCFR(parref,"DT",PHCDTChildSub)) q:((PHCDTChildSub="")||(flag=1))
		s PHCDTRowId=parref_"||"_PHCDTChildSub
		s PHCDTTime=$p($g(^PHCFR(parref,"DT",PHCDTChildSub)),"^",1)
		s PHCDTTimeDesc=$p($g(^PHCFR(parref,"DT",PHCDTChildSub)),"^",2)
		i (time=PHCDTTime)&&(rowid'=PHCDTRowId)  //&&(timedesc=PHCDTTimeDesc)
		{
			s flag=1
		}
	}
	
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 频次分发时间
/// Input: 频次分发时间 实体类
/// Table：User.PHCDispensingTime
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCDispensingTime) As %String
{
	n (%session,eobj)
	s result=""
	if $IsObject(eobj)
	{
		s PHCDTTime=eobj.PHCDTTime
		s:eobj.PHCDTTime'="" eobj.PHCDTTime= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(eobj.PHCDTTime)
		
		s flag=##class(web.DHCBL.CT.PHCDispensingTime).FormValidate(eobj.PHCDTRowId,eobj.PHCDTPHCFRParRef,eobj.PHCDTTime)
		
		if (flag'=1)
		{
			if (eobj.PHCDTRowId="") //如果RowId未赋值则增加
			{
	     		s obj = ##class(User.PHCDispensingTime).%New(eobj.PHCDTPHCFRParRef)
	 		}
			else //如果RowId已赋值则修改
			{
			
	     		s obj = ##class(User.PHCDispensingTime).%OpenId(eobj.PHCDTRowId)
	     		s bobj = ##class(web.Entity.CT.PHCDispensingTime).%New()
	     		s bobj.PHCDTRowId = eobj.PHCDTRowId
	     		s bobj.PHCDTPHCFRParRef = $p(eobj.PHCDTRowId,"||",1)
				s bobj.PHCDTTime=obj.PHCDTTime
	     		s bobj.PHCDTTimeDesc=obj.PHCDTTimeDesc
	     		
	 		}
	 		d obj.PHCDTPHCFRParRefSetObjectId(eobj.PHCDTPHCFRParRef)
			s obj.PHCDTTime=eobj.PHCDTTime
			s obj.PHCDTTimeDesc=eobj.PHCDTTimeDesc
			
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc)
			{
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.PHCDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_DispensingTime","User.PHCDispensingTime","频次分发时间",id,PHCDTTime,"A",eobj)
				d:eobj.PHCDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_DispensingTime","User.PHCDispensingTime","频次分发时间",id,PHCDTTime,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频次分发时间","web.DHCBL.CT.PHCDispensingTime","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}	
		}
		else
 		{
	 		 s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	 	}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 频次分发时间
/// Table：User.PHCDispensingTime
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	s eobj = ##class(web.Entity.CT.PHCDispensingTime).%New()
	s eobj.PHCDTRowId = id
	s eobj.PHCDTPHCFRParRef = $p(id,"||",1)
	s PHCDTTime=$p($g(^PHCFR($p(id,"||",1),"DT",$p(id,"||",2))),"^",1)
	s:PHCDTTime'="" PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PHCDTTime)
	s eobj.PHCDTTime=$p($g(^PHCFR($p(id,"||",1),"DT",$p(id,"||",2))),"^",1)
	s eobj.PHCDTTimeDesc=$p($g(^PHCFR($p(id,"||",1),"DT",$p(id,"||",2))),"^",2)
	Tstart
	s sc=##class(User.PHCDispensingTime).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_DispensingTime","User.PHCDispensingTime","频次分发时间",id,PHCDTTime,"D",eobj)
	}
	else
	{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频次分发时间","web.DHCBL.CT.PHCDispensingTime","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Function: 提供接口给药房：入参：频次id、医院、分发时间，出参：分发时间描述
/// Creator:zrf
/// CreateDate:  2023-2-23
/// Input:频次id、医院、分发时间
/// Return : 分发时间描述
/// Debug: w ##class(web.DHCBL.CT.PHCDispensingTime).GetTimeDesc("1","GZ01","22:00:00")
ClassMethod GetTimeDesc(PHCFRRowId, hospcode, time)
{
	s hospid=""
	s:hospcode'="" hospid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospcode),""))
	q:((PHCFRRowId="")||(time="")) ""
	s time= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(time)
	s PHCDTTimeDesc=""
	s parref=PHCFRRowId
	s PHCDTChildSub=0
	for
	{
		s PHCDTChildSub=$o(^PHCFR(parref,"DT",PHCDTChildSub)) q:(PHCDTChildSub="")
		s PHCDTRowId=parref_"||"_PHCDTChildSub
		s PHCDTTime=$p($g(^PHCFR(parref,"DT",PHCDTChildSub)),"^",1)
		s PHCDTHospDR= $p($g(^PHCFR(parref,"DT",PHCDTChildSub)),"^",2)
		continue:(hospid'=PHCDTHospDR)
		if (PHCDTTime=time)
		{
			s PHCDTTimeDesc=$p($g(^PHCFR(parref,"DT",PHCDTChildSub)),"^",3)	
			q 
		}
		
	}
	q PHCDTTimeDesc
}

}
