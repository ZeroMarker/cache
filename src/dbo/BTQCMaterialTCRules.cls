/// 质控项目规则
Class dbo.BTQCMaterialTCRules Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MaterialTCRules ]
{

/// Foreign Key FKBTQCMaterialTCRulesMaterialDR created via DDL
ForeignKey FKBTQCMaterialTCRulesMaterialDR(MaterialDR) References dbo.BTQCMaterial(PKBTQCMATERIAL) [ SqlName = FK_BTQCMaterialTCRulesMaterialDR ];

/// Foreign Key FKBTQCMaterialTCRulesTestCodeDR created via DDL
ForeignKey FKBTQCMaterialTCRulesTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCMaterialTCRulesTestCodeDR ];

/// Foreign Key FKBTQCMaterialTCRulesQCRulesDR created via DDL
ForeignKey FKBTQCMaterialTCRulesQCRulesDR(QCRulesDR) References dbo.BTQCRules(PKBTQCRULES) [ SqlName = FK_BTQCMaterialTCRulesQCRulesDR ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALTCRULES On RowID [ PrimaryKey, SqlName = PK_BTQC_MATERIALTCRULES, Type = index, Unique ];

Index IndexMaster On (MaterialDR, TestCodeDR, QCRulesDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控物
Property MaterialDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 质控规则
Property QCRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 状态
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTQCMaterialTCRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>QCRulesDR</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMaterialTCRulesD</DataLocation>
<DefaultData>BTQCMaterialTCRulesDefaultData</DefaultData>
<IdLocation>^dbo.BTQCMaterialTCRulesD</IdLocation>
<IndexLocation>^dbo.BTQCMaterialTCRulesI</IndexLocation>
<StreamLocation>^dbo.BTQCMaterialTCRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
