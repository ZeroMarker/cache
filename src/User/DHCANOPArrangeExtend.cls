Class User.DHCANOPArrangeExtend Extends %Persistent [ SqlRowIdName = ANOPAE_RowId, SqlTableName = DHC_AN_OPArrangeExtend, StorageStrategy = CacheStorage ]
{

Property ANOPAEOPADr As %String [ SqlColumnNumber = 2, SqlFieldName = ANOPAE_OPA_Dr ];

Property ANOPAEUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANOPAE_User_Dr ];

Property ANOPAEUpdateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ANOPAE_UpdateDate ];

Property ANOPAEUpdateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANOPAE_UpdateTime ];

Property ANOPAEANCOPAECode As %String [ SqlColumnNumber = 6, SqlFieldName = ANOPAE_ANCOPAECode ];

Property ANOPAEValue As %String [ SqlColumnNumber = 7, SqlFieldName = ANOPAE_Value ];

Property ANOPAEPreValue As %String [ SqlColumnNumber = 8, SqlFieldName = ANOPAE_PreValue ];

Property ANOPAENote As %String [ SqlColumnNumber = 9, SqlFieldName = ANOPAE_Note ];

Index OPA On ANOPAEOPADr As Exact;

Index OPACode On (ANOPAEOPADr As Exact, ANOPAEANCOPAECode As Exact);

Storage CacheStorage
{
<Data name="ANOPArrangeExtendClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ANOPArrangeExtendDefaultData">
<Value name="1">
<Value>ANOPAEOPADr</Value>
</Value>
<Value name="2">
<Value>ANOPAEUserDr</Value>
</Value>
<Value name="3">
<Value>ANOPAEUpdateDate</Value>
</Value>
<Value name="4">
<Value>ANOPAEUpdateTime</Value>
</Value>
<Value name="5">
<Value>ANOPAEANCOPAECode</Value>
</Value>
<Value name="6">
<Value>ANOPAEValue</Value>
</Value>
<Value name="7">
<Value>ANOPAEPreValue</Value>
</Value>
<Value name="8">
<Value>ANOPAENote</Value>
</Value>
</Data>
<DataLocation>^DHCANOPArrangeExtend</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANOPArrangeExtend</IdLocation>
<IndexLocation>^DHCANOPArrangeExtend(0)</IndexLocation>
<StreamLocation>^User.DHCANOPArrangeExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
