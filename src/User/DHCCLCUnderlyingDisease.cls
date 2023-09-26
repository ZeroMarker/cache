Class User.DHCCLCUnderlyingDisease Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCUD_RowId, SqlTableName = DHC_CLC_UnderlyingDisease, StorageStrategy = CacheStorage ]
{

Index Ctloc On CLCUDCtlocDr As Exact;

Index Code On (CLCUDCode As Exact, CLCUDCtlocDr As Exact);

Property CLCUDCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCUD_Code ];

Property CLCUDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCUD_Desc ];

Property CLCUDCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = CLCUD_Ctloc_Dr ];

Property CLCUDSeqNo As %String [ SqlColumnNumber = 5, SqlFieldName = CLCUD_SeqNo ];

Property CLCUDIsChronicDisease As %Boolean [ SqlColumnNumber = 6, SqlFieldName = CLCUD_IsChronicDisease ];

Storage CacheStorage
{
<Data name="DHCCLCUnderDiseaseClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCUnderDiseaseDefaultData">
<Value name="1">
<Value>CLCUDCode</Value>
</Value>
<Value name="2">
<Value>CLCUDDesc</Value>
</Value>
<Value name="3">
<Value>CLCUDCtlocDr</Value>
</Value>
<Value name="4">
<Value>CLCUDSeqNo</Value>
</Value>
<Value name="5">
<Value>CLCUDIsChronicDisease</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("UnderlyingDisease")</DataLocation>
<DefaultData>DHCCLCUnderlyingDiseaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("UnderlyingDisease")</IdLocation>
<IndexLocation>^DHCCLC("UnderlyingDisease",0)</IndexLocation>
<StreamLocation>^User.DHCCLCUnderlyingDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
