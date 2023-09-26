Class User.DHCBPArrangeExtend Extends %Persistent [ SqlTableName = DHC_BP_ArrangeExtend, StorageStrategy = CacheStorage ]
{

Property BPAEBPADr As %String [ SqlColumnNumber = 2, SqlFieldName = BPAE_BPA_Dr ];

Property BPAEUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPAE_User_Dr ];

Property BPAEUpdateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPAE_UpdateDate ];

Property BPAEUpdateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BPAE_UpdateTime ];

Property BPAEBPCAECode As %String [ SqlColumnNumber = 6, SqlFieldName = BPAE_BPCAECode ];

Property BPAEValue As %String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = BPAE_Value ];

Property BPAEPreValue As %String(MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = BPAE_PreValue ];

Property BPAENote As %String [ SqlColumnNumber = 9, SqlFieldName = BPAE_Note ];

Index BPA On BPAEBPADr As Exact;

Index BPACode On (BPAEBPADr As Exact, BPAEBPCAECode As Exact);

Storage CacheStorage
{
<Data name="BPArrangeExtendClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPArrangeExtendDefaultData">
<Value name="1">
<Value>BPAEBPADr</Value>
</Value>
<Value name="2">
<Value>BPAEUserDr</Value>
</Value>
<Value name="3">
<Value>BPAEUpdateDate</Value>
</Value>
<Value name="4">
<Value>BPAEUpdateTime</Value>
</Value>
<Value name="5">
<Value>BPAEBPCAECode</Value>
</Value>
<Value name="6">
<Value>BPAEValue</Value>
</Value>
<Value name="7">
<Value>BPAEPreValue</Value>
</Value>
<Value name="8">
<Value>BPAENote</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrangeExtend</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrangeExtend</IdLocation>
<IndexLocation>^DHCBPArrangeExtend(0)</IndexLocation>
<StreamLocation>^User.DHCBPArrangeExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
