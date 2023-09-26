Class User.DHCBPCBusinessFieldExtend Extends %Persistent [ SqlRowIdName = BPCBFE_RowId, SqlTableName = DHC_BPC_BusinessFieldExtend, StorageStrategy = CacheStorage ]
{

Property BPCBFECode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCBFE_Code ];

Property BPCBFEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCBFE_Desc ];

Property BPCBFEType As %String(DISPLAYLIST = ",Scheme,Arrange", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",S,A") [ SqlColumnNumber = 4, SqlFieldName = BPCBFE_Type ];

Property BPCBFEActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BPCBFE_Active ];

Property BPCBFEOption As %String [ SqlColumnNumber = 6, SqlFieldName = BPCBFE_Option ];

Property BPCBFESortNo As %String [ SqlColumnNumber = 7, SqlFieldName = BPCBFE_SortNo ];

Index Code On BPCBFECode As Exact;

Index TypeCode On (BPCBFEType As Exact, BPCBFECode As Exact);

Storage CacheStorage
{
<Data name="BPCBusinessFieldExtendClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCBusinessFieldExtendDefaultData">
<Value name="1">
<Value>BPCBFECode</Value>
</Value>
<Value name="2">
<Value>BPCBFEDesc</Value>
</Value>
<Value name="3">
<Value>BPCBFEType</Value>
</Value>
<Value name="4">
<Value>BPCBFEActive</Value>
</Value>
<Value name="5">
<Value>BPCBFEOption</Value>
</Value>
<Value name="6">
<Value>BPCBFESortNo</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("BusinessFieldExtend")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("BusinessFieldExtend")</IdLocation>
<IndexLocation>^DHCBPC("BusinessFieldExtend",0)</IndexLocation>
<StreamLocation>User.DHCBPCBusinessFieldExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
