Class dbo.BTAntKindLogicRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntKindLogicRule ]
{

/// Foreign Key FKKindDR created via DDL
ForeignKey FKKindDR(KindDR) References dbo.BTAntibioticsKind(PKBTANTIBIOTICSKIND) [ SqlName = FK_KindDR ];

/// Foreign Key FKPerKindDR created via DDL
ForeignKey FKPerKindDR(PerKindDR) References dbo.BTAntibioticsKind(PKBTANTIBIOTICSKIND) [ SqlName = FK_PerKindDR ];

/// Foreign Key FKRuleSpecType created via DDL
ForeignKey FKRuleSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RuleSpecType ];

/// DDL Primary Key RUGenusDR
Index IndexMasterSP On (KindDR, Sensitivity, PerKindDR, PerSensitivity, SpecimenDR) [ SqlName = Index_MasterSP, Type = index ];

/// DDL Primary Key RUGenusDR
Index IndexMaster On (KindDR, Sensitivity, PerKindDR, PerSensitivity) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANTLOGICRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGANTLOGICRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property KindDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Sensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 4 ];

Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property PerKindDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property PerSensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 7 ];

Property Prompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTAntKindLogicRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KindDR</Value>
</Value>
<Value name="3">
<Value>Sensitivity</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
<Value name="5">
<Value>PerKindDR</Value>
</Value>
<Value name="6">
<Value>PerSensitivity</Value>
</Value>
<Value name="7">
<Value>Prompt</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntKindLogicRuleD</DataLocation>
<DefaultData>BTAntKindLogicRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTAntKindLogicRuleD</IdLocation>
<IndexLocation>^dbo.BTAntKindLogicRuleI</IndexLocation>
<StreamLocation>^dbo.BTAntKindLogicRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
