Class DHCWL.DM.T.FilterFunParams Extends %Persistent
{

Property FilterFun As FilterFunConfig [ Required ];

Property ParaName As %String [ Required ];

Property ParaIndex As %Integer [ Required ];

Property DefaultValue As %String;

Property ValueType As DataType [ Required ];

Index MainI On (FilterFun, ParaIndex) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.FilterFunParams).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.FilterFunParams)
	k ^DHCWL.DM.T.FilterFunParamsD,^DHCWL.DM.T.FilterFunParamsI
	s strType=##class(DataType).GetIdByPath("VARCHAR")
	&sql(INSERT INTO DHCWL_DM_T.FilterFunParams(FilterFun,ParaName,ParaIndex,ValueType)VALUES(1,'a',1,:strType))
	w %ROWID,","
}

ClassMethod GetParams(filterId, ByRef params) As %Status
{
	k params
	q:'$d(^DHCWL.DM.T.FilterFunParamsI("MainI",filterId)) $$$OK
	s i=0,pi="" f  s pi=$o(^DHCWL.DM.T.FilterFunParamsI("MainI",filterId,pi)) q:pi=""  d
	.s id=$o(^DHCWL.DM.T.FilterFunParamsI("MainI",filterId,pi,""))
	.q:'$d(^DHCWL.DM.T.FilterFunParamsD(id))
	.s i=i+1
	.s params(i,"N")=$lg(^DHCWL.DM.T.FilterFunParamsD(id),3)
	.s params(i,"V")=$lg(^DHCWL.DM.T.FilterFunParamsD(id),4)
}

Storage Default
{
<Data name="FilterFunParamsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FilterFun</Value>
</Value>
<Value name="3">
<Value>ParaName</Value>
</Value>
<Value name="4">
<Value>ParaIndex</Value>
</Value>
<Value name="5">
<Value>DefaultValue</Value>
</Value>
<Value name="6">
<Value>ValueType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.FilterFunParamsD</DataLocation>
<DefaultData>FilterFunParamsDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.FilterFunParamsD</IdLocation>
<IndexLocation>^DHCWL.DM.T.FilterFunParamsI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.FilterFunParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
