Class User.DHCCLCScoreOption Extends %Library.Persistent [ CompileAfter = User.DHCCLCScore, Not ProcedureBlock, SqlRowIdName = CLCSO_RowId, SqlTableName = DHC_CLC_ScoreOption, StorageStrategy = "" ]
{

Relationship CLCSOParref As User.DHCCLCScore [ Cardinality = parent, Inverse = ChildDHCCLCScoreOption, SqlFieldName = CLCSO_Parref ];

Property CLCSOCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCSO_Code ];

Property CLCSODesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCSO_Desc ];

Property CLCSOMinValue As %Float [ SqlColumnNumber = 4, SqlFieldName = CLCSO_MinValue ];

Property CLCSOMaxValue As %Float [ SqlColumnNumber = 5, SqlFieldName = CLCSO_MaxValue ];

Property CLCSOScoreValue As %Float [ SqlColumnNumber = 6, SqlFieldName = CLCSO_ScoreValue ];

Property CLCSOType As %String [ SqlColumnNumber = 7, SqlFieldName = CLCSO_Type ];

Storage Default
{
<Data name="DHCCLCScoreOptionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCScoreOptionDefaultData">
<Value name="1">
<Value>CLCSOCode</Value>
</Value>
<Value name="2">
<Value>CLCSODesc</Value>
</Value>
<Value name="3">
<Value>CLCSOMinValue</Value>
</Value>
<Value name="4">
<Value>CLCSOMaxValue</Value>
</Value>
<Value name="5">
<Value>CLCSOScoreValue</Value>
</Value>
<Value name="6">
<Value>CLCSOType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("O")</DataLocation>
<DefaultData>DHCCLCScoreOptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("O")</IdLocation>
<IndexLocation>^User.DHCCLCScoreOptionI</IndexLocation>
<SqlChildSub>CLCSO_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCCLCScoreOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
