Class User.DHCCLCScore Extends %Library.Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCS_RowId, SqlTableName = DHC_CLC_Score, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCCLCScoreOption As User.DHCCLCScoreOption [ Cardinality = children, Inverse = CLCSOParref ];

Property CLCSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCS_Code ];

Property CLCSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCS_Desc ];

Property CLCSType As %String(DISPLAYLIST = ",Select,Calculate", MAXLEN = 9, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",S,C") [ SqlColumnNumber = 4, SqlFieldName = CLCS_Type ];

Property CLCSFactor As %Float [ SqlColumnNumber = 5, SqlFieldName = CLCS_Factor ];

Property CLCSBaseValue As %Float [ SqlColumnNumber = 6, SqlFieldName = CLCS_BaseValue ];

Property CLCSIsMainScore As %Boolean [ SqlColumnNumber = 7, SqlFieldName = CLCS_IsMainScore ];

Property CLCSCanEdit As %Boolean [ SqlColumnNumber = 8, SqlFieldName = CLCS_CanEdit ];

Property CLCSUomdr As %String [ SqlColumnNumber = 9, SqlFieldName = CLCS_Uom_dr ];

Property CLCSComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 10, SqlFieldName = CLCS_ComOrd_Dr ];

Property CLCSTestCode As %String [ SqlColumnNumber = 11, SqlFieldName = CLCS_TestCode ];

Property CLCSStrategy As %String [ SqlColumnNumber = 12, SqlFieldName = CLCS_Strategy ];

Property CLCSRefIcucriDr As %String [ SqlColumnNumber = 13, SqlFieldName = CLCS_RefIcucri_Dr ];

Property CLCSRefeValue As %String [ SqlColumnNumber = 14, SqlFieldName = CLCS_RefeValue ];

Property CLCSSucceedComOrdCode As %String [ SqlColumnNumber = 15, SqlFieldName = CLCS_SucceedComOrdCode ];

Storage CacheStorage
{
<Data name="DHCCLCScoreClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLCSCode</Value>
</Value>
<Value name="3">
<Value>CLCSDesc</Value>
</Value>
<Value name="4">
<Value>CLCSType</Value>
</Value>
<Value name="5">
<Value>CLCSFactor</Value>
</Value>
<Value name="6">
<Value>CLCSBaseValue</Value>
</Value>
<Value name="7">
<Value>CLCSIsMainScore</Value>
</Value>
<Value name="8">
<Value>CLCSCanEdit</Value>
</Value>
<Value name="9">
<Value>CLCSUomdr</Value>
</Value>
</Data>
<Data name="DHCCLCScoreDefaultData">
<Value name="1">
<Value>CLCSCode</Value>
</Value>
<Value name="2">
<Value>CLCSDesc</Value>
</Value>
<Value name="3">
<Value>CLCSType</Value>
</Value>
<Value name="4">
<Value>CLCSFactor</Value>
</Value>
<Value name="5">
<Value>CLCSBaseValue</Value>
</Value>
<Value name="6">
<Value>CLCSIsMainScore</Value>
</Value>
<Value name="7">
<Value>CLCSCanEdit</Value>
</Value>
<Value name="8">
<Value>CLCSUomdr</Value>
</Value>
<Value name="9">
<Value>CLCSComOrdDr</Value>
</Value>
<Value name="10">
<Value>CLCSTestCode</Value>
</Value>
<Value name="11">
<Value>CLCSStrategy</Value>
</Value>
<Value name="12">
<Value>CLCSRefIcucriDr</Value>
</Value>
<Value name="13">
<Value>CLCSRefeValue</Value>
</Value>
<Value name="14">
<Value>CLCSSucceedComOrdCode</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Score")</DataLocation>
<DefaultData>DHCCLCScoreDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Score")</IdLocation>
<IndexLocation>^User.DHCCLCScoreI</IndexLocation>
<StreamLocation>^User.DHCCLCScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
