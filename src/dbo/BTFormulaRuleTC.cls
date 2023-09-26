Class dbo.BTFormulaRuleTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FormulaRuleTC ]
{

/// Foreign Key FKFormulaRule created via DDL
ForeignKey FKFormulaRuleTC(FormulaRuleDR) References dbo.BTFormulaRule(PKBTFormulaRule) [ SqlName = FK_FormulaRuleTC ];

Index IndexMaster On (FormulaRuleDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTFormulaRuleTC On RowID [ PrimaryKey, SqlName = PK_BT_FormulaRuleTC, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// BTFormulaRule
Property FormulaRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 规则  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTFormulaRuleTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FormulaRuleDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFormulaRuleTCD</DataLocation>
<DefaultData>BTFormulaRuleTCDefaultData</DefaultData>
<IdLocation>^dbo.BTFormulaRuleTCD</IdLocation>
<IndexLocation>^dbo.BTFormulaRuleTCI</IndexLocation>
<StreamLocation>^dbo.BTFormulaRuleTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
