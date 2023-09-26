///     
Class dbo.BTAntibioticsSensitivity Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntibioticsSensitivity, StorageStrategy = Default ]
{

/// Foreign Key FKAntibioticsSensitivity created via DDL
ForeignKey FKAntibioticsSensitivity(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_AntibioticsSensitivity ];

/// Foreign Key FKAntibioticsSensitivityRes created via DDL
ForeignKey FKAntibioticsSensitivityRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_AntibioticsSensitivityRes ];

Index IndexMaster On (AntibioticsDR, SenMethod, SensitivityDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTANTIBIOTICSSENSITIVITY On RowID [ PrimaryKey, SqlName = PK_BT_ANTIBIOTICSSENSITIVITY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Operand As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 6 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTAntibioticsSensitivityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntibioticsDR</Value>
</Value>
<Value name="3">
<Value>SenMethod</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
<Value name="5">
<Value>Operand</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntibioticsSensitivityD</DataLocation>
<DefaultData>BTAntibioticsSensitivityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAntibioticsSensitivityD</IdLocation>
<IndexLocation>^dbo.BTAntibioticsSensitivityI</IndexLocation>
<StreamLocation>^dbo.BTAntibioticsSensitivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
