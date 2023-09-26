///     
Class dbo.BTDiseaseAntRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_DiseaseAntRule ]
{

/// Foreign Key FKBTDiseaseAntRuleRUDiseaseDR created via DDL
ForeignKey FKBTDiseaseAntRuleRUDiseaseDR(RUDiseaseDR) References dbo.BTRUDisease(PKBTRUDisease) [ SqlName = FK_BTDiseaseAntRuleRUDiseaseDR ];

/// Foreign Key FKRuleSpecType created via DDL
ForeignKey FKRuleSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RuleSpecType ];

/// DDL Primary Key Specification
Index IndexMasterSP On (RUDiseaseDR, AntiWCode, SpecimenDR) [ SqlName = Index_MasterSP, Type = index, Unique ];

/// DDL Primary Key Specification
Index IndexMaster On (RUDiseaseDR, AntiWCode) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTDISEASEANTRULE On RowID [ PrimaryKey, SqlName = PK_BT_DISEASEANTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTDiseaseAntRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="3">
<Value>AntiWCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDiseaseAntRuleD</DataLocation>
<DefaultData>BTDiseaseAntRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTDiseaseAntRuleD</IdLocation>
<IndexLocation>^dbo.BTDiseaseAntRuleI</IndexLocation>
<StreamLocation>^dbo.BTDiseaseAntRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
