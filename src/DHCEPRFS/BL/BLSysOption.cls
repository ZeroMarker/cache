Class DHCEPRFS.BL.BLSysOption Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc：设置系统参数
/// Creator:Candy
/// CreateDate:2013-05-21
ClassMethod SetData(AName As %String, AValue As %String, ADesc As %String, AType) As %String
{
	s result = ""
	q:(AName = "") result
	s Id = $o(^DHCEPRFS.META.SysOptionI("IdxOptionName"," "_$ZCVT(AName,"U"),""))
	if (Id = "")
	{
		s obj = ##Class(DHCEPRFS.META.SysOption).%New()
	}else
	{
        s obj = ##Class(DHCEPRFS.META.SysOption).%OpenId(Id)
	}

	s obj.OptionDesc = ADesc
	s obj.OptionName = AName
	s obj.OptionValue = AValue
	s obj.OptionType = AType
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

ClassMethod GetValueByName(ASysName As %String) As %String
{
	q:(ASysName="") ""
	
	s Id = $o(^DHCEPRFS.META.SysOptionI("IdxOptionName"," "_$ZCVT(ASysName,"U"),""))
	q:(Id="") ""
	
	s obj = ##Class(DHCEPRFS.META.SysOption).%OpenId(Id)
	q:(obj = "") ""
	
	q obj.OptionValue
}

ClassMethod UpdateValueByName(AName As %String, ANewValue As %String) As %String
{
	q:(AName="") ""

	s rowID = $o(^DHCEPRFS.META.SysOptionI("IdxOptionName"," "_$ZCVT(AName,"U"),""))
	q:(rowID="") 
	s obj = ##Class(DHCEPRFS.META.SysOption).%OpenId(rowID)
	q:(obj="")
	s obj.OptionValue = ANewValue
	s status = obj.%Save()
	q:($$$ISOK(status)) "1"

	q "-1"
}

/// Desc:根据系统参数类型，取其数据
/// Input:AType 参数类型
/// Debuger:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLSysOption","GetValueByType","BROWSE")
Query GetValueByType(AType As %String) As %Query(ROWSPEC = "Name:%String,Value:%String")
{
}

ClassMethod GetValueByTypeExecute(ByRef qHandle As %Binary, AType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:(AType = "") $$$OK
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.SysOptionI("IdxOptionType"," "_AType,rowID))
		q:(rowID="") 
		s obj = ##Class(DHCEPRFS.META.SysOption).%OpenId(rowID)
		q:(obj="")
		s Name = obj.OptionName
		s Value = obj.OptionValue
        s data = $lb(Name,Value)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetValueByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetValueByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:取所有系统参数
/// Input:
/// Debuger:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLSysOption","GetAllSysOption")
Query GetAllSysOption() As %Query(ROWSPEC = "Name:%String,Value:%String")
{
}

ClassMethod GetAllSysOptionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.SysOptionD(rowID))
		q:(rowID="") 
		s obj = ##Class(DHCEPRFS.META.SysOption).%OpenId(rowID)
		q:(obj="")
		s Name = obj.OptionName
		s Value = obj.OptionValue
        s data = $lb(Name,Value)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetAllSysOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllSysOptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllSysOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllSysOptionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

}
