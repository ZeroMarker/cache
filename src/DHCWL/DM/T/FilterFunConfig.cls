/// Created by lihaihong
/// Created date at 20170405
/// Deprecated
Class DHCWL.DM.T.FilterFunConfig Extends %Persistent
{

Property FilterName As %String [ Required ];

Property FilterType As TypeConfig [ Required ];

Property CallExpression As %String [ Required ];

Property Description As %String(MAXLEN = 512, TRUNCATE = 1) [ Required ];

Property Creator As %String [ Required ];

Property CreatedDate As %Date [ Required ];

Index MainI On FilterName [ PrimaryKey ];

// d ##class(DHCWL.DM.T.FilterFunConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.FilterFunConfig)
	k ^DHCWL.DM.T.FilterFunConfigD,^DHCWL.DM.T.FilterFunConfigI
	s obj=##class(FilterFunConfig).%New()
	s obj.FilterName="test",obj.CallExpression="##class(DHCWL.DM.Function.FilterFunction).test",obj.Creator="lhh"
	s obj.FilterType=##class(TypeConfig).GetByPath("FILTER:DCF")
	s obj.Description="测试",obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id()_","
	
	s obj=##class(FilterFunConfig).%New()
	s obj.FilterName="DR",obj.CallExpression="##class(DHCWL.DM.Function.DateRange).%New",obj.Creator="lhh"
	s obj.FilterType=##class(TypeConfig).GetByPath("FILTER:ITERATOR")
	s obj.Description="日期范围迭代器",obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id()_","
}

ClassMethod GetIdByPath(filterName) As %String
{
	s filterName=" "_$zcvt(filterName,"U")
	q:'$d(^DHCWL.DM.T.FilterFunConfigI("MainI",filterName)) ""
	s id=$o(^DHCWL.DM.T.FilterFunConfigI("MainI",filterName,""))
	q:'$d(^DHCWL.DM.T.FilterFunConfigD(id)) ""
	q id
}

ClassMethod GetByPath(filterName) As FilterFunConfig
{
	q ##class(FilterFunConfig).%OpenId(..GetIdByPath(filterName))
}

Storage Default
{
<Data name="FilterFunConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FilterName</Value>
</Value>
<Value name="3">
<Value>FilterType</Value>
</Value>
<Value name="4">
<Value>CallExpression</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreatedDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.FilterFunConfigD</DataLocation>
<DefaultData>FilterFunConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.FilterFunConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.FilterFunConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.FilterFunConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
