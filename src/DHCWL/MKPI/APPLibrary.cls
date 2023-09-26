/// DHCWL_MKPI.DHCWLMKPIAPPLibrary   d ##class(DHCWL.MKPI.APPLibrary).%BuildIndices()
/// 应用程序编码库
Class DHCWL.MKPI.APPLibrary Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIAPPLibrary ]
{

Property AppFor As %String [ Required, SqlColumnNumber = 2, SqlFieldName = AppFor ];

Property Code As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Code ];

Property Name As %String [ SqlColumnNumber = 4, SqlFieldName = Name ];

Property Describe As %String [ SqlColumnNumber = 5, SqlFieldName = Describes ];

Property Value As %String [ SqlColumnNumber = 6, SqlFieldName = APP_Value ];

Property Delimiter As %String [ SqlColumnNumber = 7, SqlFieldName = Deli ];

Property ExcuteCode As %String [ SqlColumnNumber = 8, SqlFieldName = ExcuteCode ];

Index CodeI On Code As AlphaUp;

Index AppForCodeI On (AppFor As AlphaUp, Code As AlphaUp);

/// w ##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||PP")
ClassMethod GetIdByCode(indentity)
{
	q:indentity="" ""
	s indentity=$zcvt(indentity,"U")
	s code=$p(indentity,"||",2)
	s appFor=$p(indentity,"||",1)
	q:(appFor="")||(code="") ""
	q $o(^DHCWL.MKPI.APPLibraryI("AppForCodeI",appFor,code,""))
}

ClassMethod GetCodeById(id)
{
	q:'$d(^DHCWL.MKPI.APPLibraryD(id)) ""
	q $lg(^DHCWL.MKPI.APPLibraryD(id),2)_"||"_$lg(^DHCWL.MKPI.APPLibraryD(id),3)
}

Storage Default
{
<Data name="APPLibraryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppFor</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Describe</Value>
</Value>
<Value name="6">
<Value>Value</Value>
</Value>
<Value name="7">
<Value>Delimiter</Value>
</Value>
<Value name="8">
<Value>ExcuteCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.APPLibraryD</DataLocation>
<DefaultData>APPLibraryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.APPLibraryD</IdLocation>
<IndexLocation>^DHCWL.MKPI.APPLibraryI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.APPLibraryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
