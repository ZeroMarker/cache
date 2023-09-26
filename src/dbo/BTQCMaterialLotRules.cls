///     
Class dbo.BTQCMaterialLotRules Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialLotRules, StorageStrategy = Default ]
{

/// Foreign Key FKMaterialLotRulesLot created via DDL
ForeignKey FKMaterialLotRulesLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_MaterialLotRulesLot ];

/// Foreign Key FKMaterialLotRulesRule created via DDL
ForeignKey FKMaterialLotRulesRule(QCRulesDR) References dbo.BTQCRules(PKBTQCRULES) [ SqlName = FK_MaterialLotRulesRule ];

Index IndexMaster On (MaterialLotDR, QCRulesDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOTRULES On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALLOTRULES, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property QCRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTQCMaterialLotRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>QCRulesDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialLotRulesD</DataLocation>
<DefaultData>BTQCMaterialLotRulesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTQCMaterialLotRulesD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialLotRulesI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialLotRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
