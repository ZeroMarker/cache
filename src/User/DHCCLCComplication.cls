Class User.DHCCLCComplication Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_CLC_Complication, StorageStrategy = CacheStorage ]
{

Property CLCCCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCC_Code ];

Property CLCCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCC_Desc ];

Property CLCCType As %String(DISPLAYLIST = ",Operation,Anaesthesia,ICU", MAXLEN = 11, SELECTIVITY = "25%", VALUELIST = ",O,A,I") [ SqlColumnNumber = 4, SqlFieldName = CLCC_Type ];

Index Type On CLCCType As Exact;

Storage CacheStorage
{
<Data name="DHCCLCComplicationClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCComplicationDefaultData">
<Value name="1">
<Value>CLCCCode</Value>
</Value>
<Value name="2">
<Value>CLCCDesc</Value>
</Value>
<Value name="3">
<Value>CLCCType</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Complication")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Complication")</IdLocation>
<IndexLocation>^DHCCLC("Complication",0)</IndexLocation>
<StreamLocation>^User.DHCCLCComplicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
