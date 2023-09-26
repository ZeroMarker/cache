/// Created At 20170307
Class DHCWL.DM.T.ThemeFetchFilter Extends %Persistent
{

Property FetchBase As ThemeFetchConfig [ Required ];

Property FilterField As MetaTablePro [ Required ];

Property FilterFunction As %String [ Required ];

Property FilterParam As %String;

Property ExecuteOrder As %Integer [ Required ];

Property JoinLogicalForAfter As %String;

Property HasNotLogical As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required ];

Index MainI On (FetchBase, ExecuteOrder, FilterField) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.ThemeFetchFilter).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeFetchFilter)
	k ^DHCWL.DM.T.ThemeFetchFilterD,^DHCWL.DM.T.ThemeFetchFilterI
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/workload.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction=">=",obj.FilterParam="@startDate",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction="<=",obj.FilterParam="@endDate",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/workload2.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction=">=",obj.FilterParam="@startDate",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction="<=",obj.FilterParam="@endDate",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/workload3.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction=">=",obj.FilterParam="@startDate",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction="<=",obj.FilterParam="@endDate",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/workload4.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction=">=",obj.FilterParam="@startDate",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WorkLoad_OrdDate")
	s obj.FilterFunction="<=",obj.FilterParam="@endDate",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	
	/*s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/WorkLoadAlll.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WL_ORDDATE")
	s obj.FilterFunction=">=",obj.FilterParam="@startDate",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WL_ORDDATE")
	s obj.FilterFunction="<=",obj.FilterParam="@endDate",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/WorkLoadAlll.t")
	s wl=list.GetAt(1)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WL_ID")
	s obj.FilterFunction=">=",obj.FilterParam="@startId",obj.ExecuteOrder=1,obj.JoinLogicalForAfter=" and ",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=wl,obj.FilterField=wl.FactMetaTable.GetProperty("WL_ID")
	s obj.FilterFunction="<=",obj.FilterParam="@endId",obj.ExecuteOrder=2,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","*/
}

// w ##class(DHCWL.DM.T.ThemeFetchFilter).GetWhere(1)

ClassMethod GetAt(fetchId, position) As DHCWL.DM.T.ThemeFetchFilter
{
	q:'$d(^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchId,position)) ""
	s fid=$o(^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchId,position,""))
	s id=$o(^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchId,position,fid,""))
	q ##class(ThemeFetchFilter).%OpenId(id)
}

ClassMethod GetWhere(fetchConfigId) As %String
{
	s where="",num=0
	q:( (fetchConfigId="") || ('$d( ^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchConfigId) )) ) ""
	s order="" f  s order=$o( ^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchConfigId,order) ) q:order=""  d
	.s ff=$o( ^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchConfigId,order,"") )
	.s id=$o( ^DHCWL.DM.T.ThemeFetchFilterI("MainI",fetchConfigId,order,ff,"") )
	.s obj=##class(ThemeFetchFilter).%OpenId(id)
	.q:obj=""
	.s where=where
	.s:obj.HasNotLogical="Y" where=where_" NOT "
	.s where=where_obj.FilterField.Code_" "_obj.FilterFunction_"( "
	.i obj.FilterParam'="" d
	..s where=where_obj.FilterParam
	.s where=where_")"
	.s:obj.JoinLogicalForAfter'="" where="("_where_") "_obj.JoinLogicalForAfter_" "
	q where
}

Storage Default
{
<Data name="ThemeFetchFilterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FetchBase</Value>
</Value>
<Value name="3">
<Value>FilterField</Value>
</Value>
<Value name="4">
<Value>FilterFunction</Value>
</Value>
<Value name="5">
<Value>FilterParam</Value>
</Value>
<Value name="6">
<Value>ExecuteOrder</Value>
</Value>
<Value name="7">
<Value>JoinLogicalForAfter</Value>
</Value>
<Value name="8">
<Value>HasNotLogical</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeFetchFilterD</DataLocation>
<DefaultData>ThemeFetchFilterDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeFetchFilterD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeFetchFilterI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeFetchFilterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
