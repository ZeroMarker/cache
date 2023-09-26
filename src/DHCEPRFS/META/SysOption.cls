Class DHCEPRFS.META.SysOption Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxOptionName On OptionName [ Unique ];

Property OptionName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property OptionValue As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property OptionDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property OptionType As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxOptionType On OptionType;

Storage Default
{
<Data name="SysOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OptionName</Value>
</Value>
<Value name="3">
<Value>OptionValue</Value>
</Value>
<Value name="4">
<Value>OptionDesc</Value>
</Value>
<Value name="5">
<Value>OptionType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.SysOptionD</DataLocation>
<DefaultData>SysOptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.SysOptionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.SysOptionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.SysOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
