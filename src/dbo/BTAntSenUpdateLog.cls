Class dbo.BTAntSenUpdateLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntSenUpdateLog ]
{

/// Foreign Key FKUpdateUser created via DDL
ForeignKey FKUpdateUser(UpdateUser) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UpdateUser ];

/// Foreign Key FKAntSenUpdateLogAntibiocs created via DDL
ForeignKey FKAntSenUpdateLogAntibiocs(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_AntSenUpdateLogAntibiocs ];

/// Foreign Key FKAntSenUpdateLogOldSenRes created via DDL
ForeignKey FKAntSenUpdateLogOldSenRes(OldSensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_AntSenUpdateLogOldSenRes ];

/// Foreign Key FKAntSenUpdateLogNewSenRes created via DDL
ForeignKey FKAntSenUpdateLogNewSenRes(NewSensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_AntSenUpdateLogNewSenRes ];

Index IndexMaster On (UpdateDate, UpdateTime, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

Index IndexTableName On (TableName, TableDR, UpdateDate, UpdateTime, AntibioticsDR) [ SqlName = Index_TableName, Type = index ];

/// DDL Primary Key Specification
Index PKBTANTSENUPDATELOG On RowID [ PrimaryKey, SqlName = PK_BT_ANTSENUPDATELOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property UpdateUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property TableName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property OldSensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property OldOperand As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 9 ];

Property OldResult As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Property OldDescription As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property NewSensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property NewOperand As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 13 ];

Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

Property NewDescription As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 16 ];

Property TableDR As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTAntSenUpdateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpdateDate</Value>
</Value>
<Value name="3">
<Value>UpdateTime</Value>
</Value>
<Value name="4">
<Value>UpdateUser</Value>
</Value>
<Value name="5">
<Value>TableName</Value>
</Value>
<Value name="6">
<Value>AntibioticsDR</Value>
</Value>
<Value name="7">
<Value>OldSensitivityDR</Value>
</Value>
<Value name="8">
<Value>OldOperand</Value>
</Value>
<Value name="9">
<Value>OldResult</Value>
</Value>
<Value name="10">
<Value>OldDescription</Value>
</Value>
<Value name="11">
<Value>NewSensitivityDR</Value>
</Value>
<Value name="12">
<Value>NewOperand</Value>
</Value>
<Value name="13">
<Value>NewResult</Value>
</Value>
<Value name="14">
<Value>NewDescription</Value>
</Value>
<Value name="15">
<Value>Remark</Value>
</Value>
<Value name="16">
<Value>TableDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntSenUpdateLogD</DataLocation>
<DefaultData>BTAntSenUpdateLogDefaultData</DefaultData>
<IdLocation>^dbo.BTAntSenUpdateLogD</IdLocation>
<IndexLocation>^dbo.BTAntSenUpdateLogI</IndexLocation>
<StreamLocation>^dbo.BTAntSenUpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
