/// 名称: 医嘱项有效日期记录
/// 描述: 包含增加\查找功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2016-4-28
Class web.DHCBL.CT.ARCItmMastUpdInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-9-6
/// Description：保存医嘱项有效日期记录的内容
/// Table：User.ARCItmMastUpdInfo
/// Input：
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData()
ClassMethod SaveData(ARCIMRowId, ARCIMEffDate, ARCIMEffDateTo) As %String
{
	N (ARCIMEffDate,ARCIMEffDateTo,ARCIMRowId,%session)
	s result=""
	s obj=##class(User.ARCItmMastUpdInfo).%New()
		
	 
	d obj.DUPDIARCIMDRSetObjectId(ARCIMRowId)      		        	
	s obj.DUPDIEffDate = ARCIMEffDate 
	s obj.DUPDIEffDateTo = ARCIMEffDateTo
	s obj.DUPDIUpdDate = +$h
	s obj.DUPDIUpdTime = $p($h,",",2)
	if $d(%session) d obj.DUPDIUpdUserSetObjectId($g(%session.Data("LOGON.USERID")))
	if $d(%session)  d obj.DUPDIHospitalDRSetObjectId($g(%session.Data("LOGON.HOSPID")))
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"         //返回RowId
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}
				
	
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-9-6
/// Description：查询医嘱项有效期变更记录
/// Table：User.ARCItemCat
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItmMastUpdInfo","GetList","","")
Query GetList(arcimrowid, rowid As %String) As %Query(ROWSPEC = "DUPDIRowId,DUPDIEffDate,DUPDIEffDateTo,DUPDIUpdDate,DUPDIUpdTime,DUPDIUpdUser:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, arcimrowid As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s DUPDIRowId=rowid
		s DUPDIEffDate=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",2)
		s DUPDIEffDateTo=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",3)
		s DUPDIUpdDate=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",4)
		s DUPDIUpdTime=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",5)
		s DUPDIUpdUser=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",6)
		s:DUPDIUpdUser'="" DUPDIUpdUser=$p($g(^SSU("SSUSR",DUPDIUpdUser)),"^",2)
		
		s:DUPDIEffDate'="" DUPDIEffDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIEffDate)
		s:DUPDIEffDateTo'="" DUPDIEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIEffDateTo)
		s:DUPDIUpdDate'="" DUPDIUpdDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIUpdDate)
		s:DUPDIUpdTime'="" DUPDIUpdTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(DUPDIUpdTime,1)
		
		
	
		d OutputRow
	}
	else
	{
		if (arcimrowid'="")
		{
			s DUPDIRowId=0
			f {
				s DUPDIRowId=$o(^ARCIMDUPDI(0,"ARCIM",arcimrowid,DUPDIRowId)) q:DUPDIRowId=""
				s DUPDIEffDate=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",2)
				s DUPDIEffDateTo=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",3)
				s DUPDIUpdDate=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",4)
				s DUPDIUpdTime=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",5)
				s DUPDIUpdUser=$p($g(^ARCIMDUPDI(DUPDIRowId)),"^",6)
				s:DUPDIUpdUser'="" DUPDIUpdUser=$p($g(^SSU("SSUSR",DUPDIUpdUser)),"^",2)
				
				s:DUPDIEffDate'="" DUPDIEffDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIEffDate)
				s:DUPDIEffDateTo'="" DUPDIEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIEffDateTo)
				s:DUPDIUpdDate'="" DUPDIUpdDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DUPDIUpdDate)
				s:DUPDIUpdTime'="" DUPDIUpdTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(DUPDIUpdTime,1)
				d OutputRow
				
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DUPDIRowId,DUPDIEffDate,DUPDIEffDateTo,DUPDIUpdDate,DUPDIUpdTime,DUPDIUpdUser)
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

}
