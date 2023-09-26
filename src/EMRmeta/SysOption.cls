Class EMRmeta.SysOption Extends %Persistent
{

Parameter EXTENTSIZE = 26;

Index NameIndex On Name [ Unique ];

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

Property IsVisible As %String(TRUNCATE = 1);

// Visible:Null or "Y";  Unvisible:"N"

//插件是否加载

Property IsEditor As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property OptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="SysOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>IsVisible</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>OptionValue</Value>
</Value>
<Value name="6">
<Value>IsEditor</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SysOptionD</DataLocation>
<DefaultData>SysOptionDefaultData</DefaultData>
<ExtentSize>26</ExtentSize>
<IdLocation>^DHCEMRM.SysOptionD</IdLocation>
<IndexLocation>^DHCEMRM.SysOptionI</IndexLocation>
<StreamLocation>^DHCEMRM.SysOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
