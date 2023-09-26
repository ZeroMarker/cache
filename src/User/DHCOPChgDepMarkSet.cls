Class User.DHCOPChgDepMarkSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_OPChgDepMarkSet ]
{

Property DepSource As %String [ SqlFieldName = DepSource ];

Property MarkSource As %String [ SqlFieldName = MarkSource ];

Property DepTarget As %String [ SqlFieldName = DepTarget ];

Property MarkTarget As %String [ SqlFieldName = MarkTarget ];

Property Comm1 As %String [ SqlFieldName = Comm1 ];

Property Comm2 As %String [ SqlFieldName = Comm2 ];

Storage Default
{
<Data name="DHCOPChgDepMarkSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comm1</Value>
</Value>
<Value name="3">
<Value>Comm2</Value>
</Value>
<Value name="4">
<Value>DepSource</Value>
</Value>
<Value name="5">
<Value>DepTarget</Value>
</Value>
<Value name="6">
<Value>MarkSource</Value>
</Value>
<Value name="7">
<Value>MarkTarget</Value>
</Value>
</Data>
<DataLocation>^User.DHCOPChgDepMarkSetD</DataLocation>
<DefaultData>DHCOPChgDepMarkSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCOPChgDepMarkSetD</IdLocation>
<IndexLocation>^User.DHCOPChgDepMarkSetI</IndexLocation>
<StreamLocation>^User.DHCOPChgDepMarkSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
