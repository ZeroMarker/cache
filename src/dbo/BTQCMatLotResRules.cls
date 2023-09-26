/// 定性结果规则
Class dbo.BTQCMatLotResRules Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MatLotResRules ]
{

/// Foreign Key FKMaterialLotTestCode created via DDL
ForeignKey FKMaterialLotTestCode(MaterialLotTestCodeDR) References dbo.BTQCMaterialLotTestCode(PKBTQCMATERIALLOTTESTCODE) [ SqlName = FK_MaterialLotTestCode ];

/// Foreign Key FKMaterialLotRulesRule created via DDL
ForeignKey FKMaterialLotRulesRule(QCRulesDR) References dbo.BTQCRules(PKBTQCRULES) [ SqlName = FK_MaterialLotRulesRule ];

Index IndexMaster On (MaterialLotTestCodeDR, Result, QCRulesDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCMATERIALLOTRULES On RowID [ PrimaryKey, SqlName = PK_BTQC_MATLOTRESRULES, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 批次项目  
Property MaterialLotTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 质控规则  
Property QCRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 状态  {W:警告,D:禁止,R:失控}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTQCMatLotResRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotTestCodeDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>QCRulesDR</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMatLotResRulesD</DataLocation>
<DefaultData>BTQCMatLotResRulesDefaultData</DefaultData>
<IdLocation>^dbo.BTQCMatLotResRulesD</IdLocation>
<IndexLocation>^dbo.BTQCMatLotResRulesI</IndexLocation>
<StreamLocation>^dbo.BTQCMatLotResRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
