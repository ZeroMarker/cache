Class User.DHCBPCArrangeExtend Extends %Persistent [ SqlRowIdName = BPCAE_RowId, SqlTableName = DHC_BPC_ArrangeExtend, StorageStrategy = CacheStorage ]
{

Property BPCAECode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCAE_Code ];

Property BPCAEDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCAE_Desc ];

Property BPCAEType As %String(DISPLAYLIST = ",Normal,Discharge,", MAXLEN = 9, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 4, SqlFieldName = BPCAE_Type ];

Property BPCAEActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BPCAE_Active ];

Property BPCAEOption As %String [ SqlColumnNumber = 6, SqlFieldName = BPCAE_Option ];

Property BPCAESortNo As %String [ SqlColumnNumber = 7, SqlFieldName = BPCAE_SortNo ];

Property BPCAEBPACode As %String [ SqlColumnNumber = 8, SqlFieldName = BPCAE_BPACode ];

Index Code On BPCAECode As Exact;

Index TypeCode On (BPCAEType As Exact, BPCAECode As Exact);

Storage CacheStorage
{
<Data name="BPCArrangeExtendClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCArrangeExtendDefaultData">
<Value name="1">
<Value>BPCAECode</Value>
</Value>
<Value name="2">
<Value>BPCAEDesc</Value>
</Value>
<Value name="3">
<Value>BPCAEType</Value>
</Value>
<Value name="4">
<Value>BPCAEActive</Value>
</Value>
<Value name="5">
<Value>BPCAEOption</Value>
</Value>
<Value name="6">
<Value>BPCAESortNo</Value>
</Value>
<Value name="7">
<Value>BPCAEBPACode</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("ArrangeExtend")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("ArrangeExtend")</IdLocation>
<IndexLocation>^DHCBPC("ArrangeExtend",0)</IndexLocation>
<StreamLocation>^User.DHCBPCArrangeExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
